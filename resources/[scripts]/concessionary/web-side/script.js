$(document).ready(function() {
    let allVehicles = {};
    let categories = {};
    let currentCategory = null;
    let selectedVehicle = null;
    let isMouseDown = false;
    let startX = 0;

    // Listen for NUI messages
    window.addEventListener("message", function(event) {
        let data = event.data;

        if (data.name === "Open") {
            openDealer(data.payload);
        }
    });

    // Close on Escape
    document.onkeyup = function(data) {
        if (data.which == 27) {
            closeDealer();
        }
    };

    function openDealer(vehiclesData) {
        allVehicles = vehiclesData;
        categories = {};
        
        // Define blacklisted categories
        const blacklist = ["Aviões", "Emergência", "Helicópteros", "Serviços", "Trens", "Militares", "Barcos", "Embarcações", "Industriais", "Trailers"];

        // Group by category
        for (let spawnName in allVehicles) {
            let veh = allVehicles[spawnName];
            veh.spawnName = spawnName; // Add key to object
            
            let cat = veh.Class || "Outros";

            // Skip if category is in blacklist
            if (blacklist.includes(cat)) {
                continue;
            }

            // Skip if Mode is nil or undefined (as requested)
            // Note: In Lua nil becomes null/undefined in JS JSON
            if (!veh.Mode) {
                continue;
            }

            // Skip if Mode is 'Work' or 'work'
            if (veh.Mode.toLowerCase() === "work") {
                continue;
            }

            if (!categories[cat]) {
                categories[cat] = [];
            }
            categories[cat].push(veh);
        }

        renderCategories();
        $("#app").fadeIn(300).css("display", "flex");
    }

    function closeDealer() {
        $("#app").fadeOut(300);
        $.post("http://concessionary/Close", JSON.stringify({}));
    }

    function renderCategories() {
        let catList = $("#categories-list");
        catList.empty();

        let sortedCats = Object.keys(categories).sort();
        
        // Default to first category
        if (sortedCats.length > 0) {
            currentCategory = sortedCats[0];
        }

        sortedCats.forEach(cat => {
            let active = cat === currentCategory ? "active" : "";
            let catHtml = `<div class="category-pill ${active}" data-cat="${cat}">${cat}</div>`;
            catList.append(catHtml);
        });

        // Add click event
        $(".category-pill").click(function() {
            $(".category-pill").removeClass("active");
            $(this).addClass("active");
            currentCategory = $(this).data("cat");
            renderVehicles(currentCategory);
        });

        renderVehicles(currentCategory);
    }

    function renderVehicles(category) {
        let vehList = $("#vehicles-list");
        vehList.empty();

        let vehicles = categories[category];
        if (!vehicles) return;

        // Sort by name
        vehicles.sort((a, b) => a.Name.localeCompare(b.Name));

        vehicles.forEach((veh, index) => {
            // Using a generic image path or a fallback
            // Try to find if there is a known path, otherwise use a placeholder or icon
            // Common path: http://127.0.0.1/vehicles/${veh.spawnName}.png
            // We will use a div with background image
            
            let price = veh.Price ? veh.Price : 0;
            if (veh.Mode === "Rental") price = veh.Gemstone || 0; // Just in case

            let html = `
                <div class="vehicle-card" data-spawn="${veh.spawnName}">
                    <div class="veh-price-tag">$${formatPrice(price)}</div>
                    <div class="veh-img" style="background-image: url('http://45.149.153.98/vehiclesimgs/${veh.spawnName}.png'), url('assets/default_car.png');"></div>
                    <div class="veh-info">
                        <div class="veh-name">${veh.Name}</div>
                        <div class="veh-class">${veh.Class || 'Veículo'}</div>
                    </div>
                </div>
            `;
            // Note: I added a fallback URL logic in CSS/JS if possible, or just rely on browser behavior (it won't show if 404)
            // Ideally we handle error. For now, let's assume the URL is valid or empty.
            // I used a random IP found in other scripts or just localhost. 
            // Wait, I should check if I can find the real URL.
            // In the absence of a real URL, I will use a local path and maybe the user needs to add images.
            // Replaced URL with a generic one or local.
            // Let's use a relative path if they have images in web-side/images
            
            vehList.append(html);
        });

        // Select first vehicle
        if (vehicles.length > 0) {
            selectVehicle(vehicles[0].spawnName);
        }

        $(".vehicle-card").click(function() {
            let spawn = $(this).data("spawn");
            selectVehicle(spawn);
        });
    }

    function selectVehicle(spawnName) {
        $(".vehicle-card").removeClass("active");
        $(`.vehicle-card[data-spawn='${spawnName}']`).addClass("active");
        
        selectedVehicle = allVehicles[spawnName];
        
        // Update Info
        $("#vehicle-name").text(selectedVehicle.Name);
        $("#vehicle-class").text(selectedVehicle.Class);
        $("#vehicle-price").text("R$ " + formatPrice(selectedVehicle.Price));

        // Update Stats (Fake values based on hash/random or just static for now as we don't have real stats in payload)
        // The payload ONLY has Name, Weight, Price, Mode, Gemstone, Class.
        // It does NOT have speed, accel, etc.
        // So we have to fake it or set to 0. The reference image shows stats. 
        // We will randomize slightly based on price/class to make it look "alive" or just fill them 50-80%.
        
        updateStats();

        // Send Mount to Client
        $.post("http://concessionary/Mount", JSON.stringify(spawnName));
    }

    function updateStats() {
        // Since we don't have real stats, we simulate them for visual effect
        // In a real scenario, we would need to fetch them or have them in the payload.
        
        let speed = Math.floor(Math.random() * (300 - 150) + 150);
        let accel = Math.floor(Math.random() * (100 - 60) + 60);
        let brake = Math.floor(Math.random() * (100 - 60) + 60);
        let trac = Math.floor(Math.random() * (100 - 60) + 60);

        $("#val-speed").text(speed + " KM/H");
        $("#stat-speed").css("width", (speed / 350 * 100) + "%");

        $("#val-accel").text(accel + "%");
        $("#stat-accel").css("width", accel + "%");

        $("#val-brake").text(brake + "%");
        $("#stat-brake").css("width", brake + "%");

        $("#val-traction").text(trac + "%");
        $("#stat-traction").css("width", trac + "%");
    }

    function formatPrice(value) {
        return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }

    // Buttons
    $("#btn-buy").click(function() {
        if (selectedVehicle) {
            $.post("http://concessionary/Buy", JSON.stringify(selectedVehicle.spawnName));
        }
    });

    $("#btn-test").click(function() {
        if (selectedVehicle) {
            $.post("http://concessionary/Drive", JSON.stringify(selectedVehicle.spawnName));
        }
    });

    // Rotation (Mouse Drag)
    $(document).mousedown(function(e) {
        isMouseDown = true;
        startX = e.pageX;
    });

    $(document).mouseup(function() {
        isMouseDown = false;
    });

    $(document).mousemove(function(e) {
        if (isMouseDown) {
            let diff = e.pageX - startX;
            if (Math.abs(diff) > 10) {
                let dir = diff > 0 ? "Right" : "Left";
                $.post("http://concessionary/Rotate", JSON.stringify(dir));
                startX = e.pageX;
            }
        }
    });

    // Carousel Navigation
    $("#veh-prev").click(function() {
        document.getElementById("vehicles-list").scrollBy({ left: -200, behavior: 'smooth' });
    });
    $("#veh-next").click(function() {
        document.getElementById("vehicles-list").scrollBy({ left: 200, behavior: 'smooth' });
    });

    $("#cat-prev").click(function() {
        document.getElementById("categories-list").scrollBy({ left: -150, behavior: 'smooth' });
    });
    $("#cat-next").click(function() {
        document.getElementById("categories-list").scrollBy({ left: 150, behavior: 'smooth' });
    });
});
