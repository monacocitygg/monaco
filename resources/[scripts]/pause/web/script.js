$(document).ready(function() {
    let currentData = null;
    let boxContentsMap = {};
    let myBoxesDataMap = {};
    let currentOpeningBox = null;
    let currentOpeningQty = 1;

    // Listen for NUI Messages
    window.addEventListener('message', function(event) {
        let data = event.data;

        if (data.name === "Open") {
            $("body").fadeIn(200);
            $(".app-window").css("display", "flex");
            // Default to Shop
            $(".nav-item").removeClass("active");
            $(".nav-item[data-tab='shop']").addClass("active");
            $(".section").removeClass("active");
            $("#shop-section").addClass("active");
            
            requestShopData();
            requestHomeData(); 
        } else if (data.name === "Close") {
            $("body").fadeOut(200);
            $.post("http://pause/Close");
        }
    });

    // Navigation Click Handlers
    $(".nav-item").click(function() {
        let tab = $(this).data("tab");
        
        if (tab === "settings") {
            $.post("http://pause/Settings");
            return;
        }

        if (tab === "map") {
            $.post("http://pause/Map");
            return;
        }

        // Active Tab UI
        $(".nav-item").removeClass("active");
        $(this).addClass("active");

        // Show Section
        $(".section").removeClass("active");
        $(`#${tab}-section`).addClass("active");

        // Load Data
        if (tab === "shop") requestShopData();
        if (tab === "boxes") {
            // Reset sub-nav to 'all'
            $(".sub-nav-btn").removeClass("active");
            $(".sub-nav-btn[data-sub='all']").addClass("active");
            $("#my-boxes-grid").hide();
            $("#my-boxes-empty").hide();
            requestBoxesData();
        }
    });

    // Boxes Sub-Navigation Click Handler
    $(".sub-nav-btn").click(function() {
        let sub = $(this).data("sub");

        // Active UI
        $(".sub-nav-btn").removeClass("active");
        $(this).addClass("active");

        if (sub === "all") {
            $("#my-boxes-grid").hide();
            $("#my-boxes-empty").hide();
            requestBoxesData();
        } else if (sub === "my-boxes") {
            $("#boxes-grid").hide();
            $("#boxes-empty").hide();
            requestMyBoxesData();
        }
    });

    // Close on Escape
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $("body").fadeOut(200);
            $.post("http://pause/Close");
        }
    });

    // Data Request Functions
    function requestHomeData() {
        $.post("http://pause/Home", JSON.stringify({}), function(data) {
            if (!data) return;
            currentData = data;
            
            // Header currency only
            $("#user-diamonds-header").text(data.Information.Diamonds);
        });
    }

    function requestShopData() {
        $.post("http://pause/DiamondsList", JSON.stringify({}), function(data) {
            renderShop(data);
        });
    }

    function requestBoxesData() {
        $.post("http://pause/Boxes", JSON.stringify({}), function(data) {
            if (data && data.length > 0) {
                $("#boxes-grid").show();
                $("#boxes-empty").hide();
                renderBoxes(data);
            } else {
                $("#boxes-grid").hide();
                $("#boxes-empty").show();
            }
        });
    }

    function requestMyBoxesData() {
        $.post("http://pause/GetMyBoxes", JSON.stringify({}), function(data) {
            if (data && data.length > 0) {
                $("#my-boxes-grid").show();
                $("#my-boxes-empty").hide();
                renderMyBoxes(data);
            } else {
                $("#my-boxes-grid").hide();
                $("#my-boxes-empty").show();
            }
        });
    }

    // Render Functions
    function renderShop(items) {
        let html = "";
        items.forEach(item => {
            let finalPrice = item.Discount > 0 ? Math.round(item.Price * (1 - item.Discount/100)) : item.Price;
            
            let priceDisplay = item.Discount > 0 ? 
                `<span style="text-decoration: line-through; opacity: 0.5; margin-right: 5px;">${item.Price}</span> <i class="fa-brands fa-bitcoin"></i> ${finalPrice}` : 
                `<i class="fa-brands fa-bitcoin"></i> ${item.Price}`;

            // Escape quotes for data attributes
            let safeName = item.Name.replace(/"/g, '&quot;');
            let safeIndex = String(item.Index).replace(/"/g, '&quot;');

            html += `
                <div class="shop-item" data-type="shop" data-index="${safeIndex}" data-name="${safeName}" data-price="${finalPrice}">
                    ${item.Discount > 0 ? `<div class="promo-tag">PROMO</div>` : ''}
                    <div class="shop-item-content">
                        <img src="nui://inventory/web-side/images/${item.Image}.png" class="item-img" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                        <div class="item-name">${item.Name}</div>
                    </div>
                    <div class="item-footer">
                        ${priceDisplay}
                    </div>
                </div>
            `;
        });
        $("#shop-grid").html(html);
    }

    function renderBoxes(items) {
        boxContentsMap = {}; // Reset map
        let html = "";
        items.forEach(item => {
            boxContentsMap[item.key] = item.items; // Store contents

            let safeName = item.name.replace(/"/g, '&quot;');
            let safeKey = String(item.key).replace(/"/g, '&quot;');

            // Use local images folder if available, otherwise fallback could be handled via onerror
            // User specified they added an img folder for boxes and skins
            let imagePath = `imgs/${item.image}`;

            html += `
                <div class="shop-item" data-type="box" data-key="${safeKey}" data-name="${safeName}" data-price="${item.price}">
                    <div class="shop-item-actions">
                        <button class="info-btn" onclick="viewBoxContents(event, '${safeKey}')"><i class="fa-solid fa-eye"></i></button>
                    </div>
                    <div class="shop-item-content">
                        <img src="${imagePath}" class="item-img" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                        <div class="item-name">${item.name}</div>
                    </div>
                    <div class="item-footer">
                        <i class="fa-brands fa-bitcoin"></i> ${item.price}
                    </div>
                </div>
            `;
        });
        $("#boxes-grid").html(html);
    }

    function renderMyBoxes(items) {
        boxContentsMap = {}; 
        myBoxesDataMap = {}; // Reset my boxes map
        let html = "";
        items.forEach(item => {
            if (item.items) {
                boxContentsMap[item.key] = item.items;
            }
            myBoxesDataMap[item.key] = item; // Store full data

            let safeName = item.name.replace(/"/g, '&quot;');
            let safeKey = String(item.key).replace(/"/g, '&quot;');
            let imagePath = `imgs/${item.image}`;

            html += `
                <div class="shop-item" data-type="my-box" data-key="${safeKey}" data-name="${safeName}" onclick="openBoxOpeningScreen('${safeKey}')">
                    <div class="shop-item-actions">
                        <button class="info-btn"><i class="fa-solid fa-eye"></i></button>
                    </div>
                    <div class="shop-item-content">
                        <img src="${imagePath}" class="item-img" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                        <div class="item-name">${item.name}</div>
                    </div>
                    <div class="item-footer">
                        x${item.amount}
                    </div>
                </div>
            `;
        });
        $("#my-boxes-grid").html(html);
    }

    // Box Opening Screen Functions
    window.openBoxOpeningScreen = function(key) {
        let item = myBoxesDataMap[key];
        if (!item) return;

        currentOpeningBox = key;
        currentOpeningQty = 1;
        updateQtyUI();

        // Reset Views
        $("#box-static-display").show();
        $("#roulette-view").hide();
        $(".opening-controls").show();
        $("#opening-items-grid").parent().show(); // Show contents area
        $("#roulette-track").empty(); // Clear previous roulette
        $("#roulette-track").css("transition", "none").css("transform", "translateX(0)"); // Reset position

        // Populate Data
        $("#opening-box-name").text(`${item.name} (x${item.amount})`);
        $("#opening-box-img").attr("src", `imgs/${item.image}`);
        $("#opening-box-img").attr("onerror", "this.src='nui://inventory/web-side/images/backpack.png'");

        // Populate Contents
        let html = "";
        if (item.items) {
            item.items.forEach(content => {
                let imgPath = `imgs/${content.img || content.image}`;
                let rarity = content.type || 'common'; 
                
                html += `
                    <div class="opening-item-card ${rarity}">
                        <div class="rarity-tag">${rarity}</div>
                        <img src="${imgPath}" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                    </div>
                `;
            });
        }
        $("#opening-items-grid").html(html);

        // Switch View
        $(".section").removeClass("active");
        $("#box-opening-section").addClass("active");
    }

    window.closeOpeningScreen = function() {
        $("#box-opening-section").removeClass("active");
        $("#boxes-section").addClass("active");
        currentOpeningBox = null;
    }

    window.selectQty = function(qty) {
        currentOpeningQty = qty;
        updateQtyUI();
    }

    function updateQtyUI() {
        $(".qty-btn").removeClass("active");
        $(`.qty-btn:contains('${currentOpeningQty}')`).filter(function() {
            return $(this).text().trim() == currentOpeningQty;
        }).addClass("active");
    }

    $("#btn-open-box").click(function() {
        if (!currentOpeningBox) return;
        
        // Disable button
        $("#btn-open-box").prop("disabled", true).text("Abrindo...");
        
        // Call OpenMyBox
        $.post("http://pause/OpenMyBox", JSON.stringify({ key: currentOpeningBox }), function(data) {
            if (data && data.success) {
                // Success
                startRoulette(data.winner);
                
                // Update local count if possible
                if (myBoxesDataMap[currentOpeningBox]) {
                    myBoxesDataMap[currentOpeningBox].amount--;
                    $("#opening-box-name").text(`${myBoxesDataMap[currentOpeningBox].name} (x${myBoxesDataMap[currentOpeningBox].amount})`);
                }
            } else {
                // Error
                let msg = (data && data.error) ? data.error : "Erro ao abrir caixa.";
                showNotification(msg, "error");
                $("#btn-open-box").prop("disabled", false).text("Abrir Caixa");
            }
        }).fail(function() {
            showNotification("Erro de conexão ou timeout.", "error");
            $("#btn-open-box").prop("disabled", false).text("Abrir Caixa");
        });
    });

    function startRoulette(winner) {
        // Setup UI for animation
        $("#box-static-display").hide();
        $(".opening-controls").hide();
        $("#opening-items-grid").parent().fadeOut(200);
        $("#roulette-view").fadeIn(200);
        
        const track = $("#roulette-track");
        track.empty();
        track.css("transition", "none").css("transform", "translateX(0)");
        
        // Generate Items
        const boxData = myBoxesDataMap[currentOpeningBox];
        const items = generateRouletteItems(boxData.items, winner);
        
        // Render Items
        let html = "";
        items.forEach(item => {
            let imgPath = `imgs/${item.img || item.image}`;
            let rarity = item.type || 'common';
            
            html += `
                <div class="roulette-item">
                    <img src="${imgPath}" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                    <div class="item-rarity-bar ${rarity}"></div>
                </div>
            `;
        });
        track.html(html);
        
        // Force reflow
        track[0].offsetHeight;
        
        // Calculate Position
        // Winner is at index 45 (defined in generate)
        const winnerIndex = 45; 
        const cardWidth = 200; // Updated Width from CSS
        const containerWidth = 900; // Width from CSS
        
        // Random offset within the card (center +/- 40%)
        const randomOffset = Math.floor(Math.random() * (cardWidth * 0.8)) - (cardWidth * 0.4);
        
        const targetCenter = (winnerIndex * cardWidth) + (cardWidth / 2);
        const containerCenter = containerWidth / 2;
        
        const scrollAmount = -(targetCenter - containerCenter + randomOffset);
        
        // Animate
        setTimeout(() => {
            // Bezier for realistic slow down
            track.css("transition", "transform 6s cubic-bezier(0.15, 0, 0.10, 1)"); 
            track.css("transform", `translateX(${scrollAmount}px)`);
        }, 100);
        
        // Show Reward
        setTimeout(() => {
            showRewardModal(winner);
            $("#btn-open-box").prop("disabled", false).text("Abrir Caixa");
        }, 6500); // 6s animation + 0.5s buffer
    }

    function generateRouletteItems(possibleItems, winner) {
        let items = [];
        const totalItems = 60;
        const winnerIndex = 45;
        
        for (let i = 0; i < totalItems; i++) {
            if (i === winnerIndex) {
                items.push(winner);
            } else {
                // Pick random item
                let randomItem = possibleItems[Math.floor(Math.random() * possibleItems.length)];
                items.push(randomItem);
            }
        }
        return items;
    }
    
    function showRewardModal(winner) {
        $("#reward-img").attr("src", `imgs/${winner.img || winner.image}`);
        $("#reward-name").text(winner.name || winner.item);
        
        let rarity = winner.type || 'common';
        
        // Remove old rarity classes from card and badge
        $(".reward-card-display").removeClass("mitic mitica rare raro comum common epico epic");
        $("#reward-rarity").removeClass("mitic mitica rare raro comum common epico epic");

        // Add new rarity class to card (for border/bg) and badge (for text/bg)
        $(".reward-card-display").addClass(rarity);
        $("#reward-rarity").text(rarity).addClass(rarity);
        
        $("#reward-modal").css("display", "flex").hide().fadeIn(300);
    }
    
    window.closeRewardModal = function() {
        $("#reward-modal").fadeOut(300, function() {
             // Reset UI for next open
             $("#roulette-view").hide();
             $("#box-static-display").show();
             $(".opening-controls").show();
             $("#opening-items-grid").parent().show();
             
             // Refresh data in background
             requestMyBoxesData();
        });
    }

    window.viewBoxContents = function(event, key) {
        event.stopPropagation(); // Prevent triggering the buy click
        
        let items = boxContentsMap[key];
        if (!items || items.length === 0) {
            // If no items directly (maybe legacy structure), try to fetch or show empty
            return; 
        }

        let html = "";
        items.forEach(item => {
            // Handle different item structures if needed
            let imgPath = `imgs/${item.img || item.image}`;
            let rarityClass = item.type || 'common';
            
            html += `
                <div class="box-content-item ${rarityClass}">
                    <img src="${imgPath}" onerror="this.src='nui://inventory/web-side/images/backpack.png'">
                    <div class="content-info">
                        <span class="content-name">${item.itemType === 'weapon' ? (item.item || 'Arma') : (item.name || 'Item')}</span>
                        <span class="content-chance">${item.chance}%</span>
                    </div>
                </div>
            `;
        });

        $("#box-items-list").html(html);
        $("#box-contents-modal").css("display", "flex").hide().fadeIn(200);
    }

    window.closeBoxModal = function() {
        $("#box-contents-modal").fadeOut(200);
    }

    // Unified Click Handler for Shop Items
    $(document).on("click", ".shop-item", function() {
        // Visual Selection
        $(".shop-item").removeClass("selected");
        $(this).addClass("selected");

        let type = $(this).data("type");
        
        if (type === "shop") {
            let index = $(this).data("index");
            let name = $(this).data("name");
            let price = $(this).data("price");
            buyItem(index, 1, name, price);
        } else if (type === "box") {
            let key = $(this).data("key");
            let name = $(this).data("name");
            let price = $(this).data("price");
            buyBox(key, name, price);
        }
    });

    // Helper Functions
    window.formatCurrency = function(value) {
        return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(value).replace('$', '').trim();
    }

    let pendingPurchase = null;

    window.buyItem = function(index, amount, name, price) {
        pendingPurchase = { type: 'shop', index, amount, name, price };
        
        $("#confirm-item-name").text(name);
        $("#confirm-item-price").text(price);
        
        // Ensure flex display with fade in
        $("#confirmation-modal").css("display", "flex").hide().fadeIn(200);
    }

    window.buyBox = function(key, name, price) {
        pendingPurchase = { type: 'box', key, name, price };
        
        $("#confirm-item-name").text(name);
        $("#confirm-item-price").text(price);
        
        // Ensure flex display with fade in
        $("#confirmation-modal").css("display", "flex").hide().fadeIn(200);
    }

    window.openLootbox = function(key) {
        $.post("http://pause/OpenLootbox", JSON.stringify({ key: key }), function(data) {
            if (data === false) {
                showNotification("Erro ao processar compra.", "error");
                return;
            }

            if (typeof data === "string") {
                let type = data.toLowerCase().includes("insuficiente") ? 'error' : 'success';
                showNotification(data, type);
                
                if (type === 'success') {
                    requestHomeData();
                }
            }
        });
    }

    window.closeModal = function() {
        $("#confirmation-modal").fadeOut(200);
        pendingPurchase = null;
        // Reset button state just in case
        $("#confirm-buy-btn").prop("disabled", false).text("CONFIRMAR");
    }

    window.processBuy = function() {
        if (!pendingPurchase) return;
        
        // Disable button to prevent double clicks
        $("#confirm-buy-btn").prop("disabled", true).text("Processando...");

        // Safety timeout in case server doesn't respond
        let safetyTimeout = setTimeout(() => {
            console.log("[DEBUG] Purchase timed out - forcing close");
            showNotification("Tempo limite excedido.", "error");
            closeModal();
        }, 5000);

        if (pendingPurchase.type === 'shop') {
            const { index, amount } = pendingPurchase;
            console.log(`[DEBUG] Processing buy item: Index=${index}, Amount=${amount}`);

            $.post("http://pause/DiamondsBuy", JSON.stringify({ Index: index, Amount: amount }), function(data) {
                handleBuyResponse(data, safetyTimeout, 'shop');
            })
            .fail(function(xhr, status, error) {
                handleBuyFail(safetyTimeout, status, error);
            });
        } else if (pendingPurchase.type === 'box') {
            const { key } = pendingPurchase;
            console.log(`[DEBUG] Processing buy box: Key=${key}`);

            $.post("http://pause/OpenLootbox", JSON.stringify({ key: key }), function(data) {
                handleBuyResponse(data, safetyTimeout, 'box');
            })
            .fail(function(xhr, status, error) {
                handleBuyFail(safetyTimeout, status, error);
            });
        }
    }

    function handleBuyResponse(data, safetyTimeout, type) {
        clearTimeout(safetyTimeout);
        console.log(`[DEBUG] Buy response:`, data);

        // Handle boolean false
        if (data === false) {
            showNotification("Erro ao processar compra.", "error");
            closeModal();
            return;
        }

        // Handle string response (notification)
        if (typeof data === "string") {
            let notifType = data.toLowerCase().includes("insuficiente") ? 'error' : 'success';
            showNotification(data, notifType);
            
            if (notifType === 'success') {
                requestHomeData();
                if (type === 'shop') requestShopData();
            }
            closeModal();
        } else if (data === true) {
             showNotification("Compra realizada com sucesso!", "success");
             requestHomeData();
             if (type === 'shop') requestShopData();
             closeModal();
        } else if (typeof data === 'object' && data !== null) {
            if (data.status === 'error' || data.error) {
                showNotification(data.message || "Erro desconhecido.", "error");
            } else {
                showNotification(data.message || "Compra realizada.", "success");
                requestHomeData();
                if (type === 'shop') requestShopData();
            }
            closeModal();
        } else {
            closeModal();
        }
    }

    function handleBuyFail(safetyTimeout, status, error) {
        clearTimeout(safetyTimeout);
        console.error(`[DEBUG] Buy request failed: ${status} - ${error}`);
        showNotification("Erro de comunicação com o servidor.", "error");
        closeModal();
    }

    // Notification Function
    function showNotification(message, type = 'success') {
        $("#nui-notification").remove();
        
        let borderColor = type === 'error' ? '#ef4444' : '#7c3aed';
        let icon = type === 'error' ? '<i class="fa-solid fa-circle-exclamation"></i>' : '<i class="fa-solid fa-circle-check"></i>';
        
        const notify = $(`
            <div id="nui-notification">
                ${icon}
                <span>${message}</span>
            </div>
        `);
        $("body").append(notify);
        
        notify.css({
            "position": "fixed",
            "top": "30px",
            "right": "30px",
            "background": "#18181b",
            "color": "#fafafa",
            "padding": "16px 24px",
            "border-radius": "12px",
            "z-index": "10001",
            "border-left": `4px solid ${borderColor}`,
            "font-family": "'Montserrat', sans-serif",
            "font-weight": "500",
            "box-shadow": "0 10px 30px rgba(0,0,0,0.5)",
            "display": "none",
            "font-size": "14px",
            "display": "flex",
            "align-items": "center",
            "gap": "12px",
            "min-width": "300px",
            "opacity": "0",
            "transform": "translateX(20px)"
        });
        
        notify.animate({ opacity: 1, "transform": "translateX(0)" }, 300);
        
        setTimeout(() => {
            notify.animate({ opacity: 0, "transform": "translateX(20px)" }, 300, function() {
                $(this).remove();
            });
        }, 4000);
    }
});
