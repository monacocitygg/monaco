$(document).ready(function(){
    let vehicleData = {};
    let currentCategory = null;
    let cartTotal = 0;
    let prices = {};
    let mods = {};

    // Mapping Mod IDs to Names and Icons (indices based on standard GTA V mod slots where applicable)
    // We use the keys provided by client.lua
    const categories = [
        {
            id: "performance",
            name: "MOTOR",
            icon: "fas fa-tachometer-alt",
            img: "imagens/motor.png",
            items: [
                { key: "motor", label: "Motor", type: "mod", img: "imagens/motor.png" },
                { key: "freios", label: "Freios", type: "mod", img: "imagens/brakes.png" },
                { key: "transmissão", label: "Transmissão", type: "mod", img: "imagens/transmission.png" },
                { key: "suspensão", label: "Suspensão", type: "mod", img: "imagens/suspensao.png" },
                { key: "turbo", label: "Turbo", type: "toggle", img: "imagens/turbo.png" },
                { key: "blindagem", label: "Blindagem", type: "mod", img: "imagens/armor.png" }
            ]
        },
        {
            id: "paint",
            name: "PINTURA",
            icon: "fas fa-fill-drip",
            img: "imagens/pintura.png",
            items: [
                { key: "cor-primaria", label: "Cor Primária", type: "color", colorType: "primaria", img: "imagens/pintura.png" },
                { key: "cor-secundaria", label: "Cor Secundária", type: "color", colorType: "secundaria", img: "imagens/pintura.png" },
                { key: "perolado", label: "Cor Perolada", type: "color", colorType: "perolado", img: "imagens/pintura.png" }
            ]
        },
        {
            id: "wheels",
            name: "RODAS",
            icon: "fas fa-compact-disc",
            img: "imagens/wheels.png",
            items: [
                // Custom UI will be rendered for this category
                { key: "wheel-ui", type: "custom-wheels" }
            ]
        },
        {
            id: "lights",
            name: "FARÓIS",
            icon: "fas fa-lightbulb",
            img: "imagens/farol.png",
            items: [
                { key: "farol", label: "Xenon", type: "toggle", img: "imagens/farol.png" },
                { key: "xenon-colors", label: "Cor do Xenon", type: "xenon", img: "imagens/xenon.png" },
                { key: "neon", label: "Kit Neon", type: "toggle", img: "imagens/neon.png" },
                { key: "neon-colors", label: "Cor do Neon", type: "color", colorType: "neon", img: "imagens/neon.png" }
            ]
        },
        {
            id: "extra",
            name: "EXTRA",
            icon: "fas fa-plus-circle",
            img: "imagens/plus.png",
            items: [
                // Visual
                { key: "aerofólio", label: "Aerofólio", type: "mod", img: "imagens/aerofolio.png" },
                { key: "parachoque-dianteiro", label: "Para-choque Dianteiro", type: "mod", img: "imagens/front_bumper.png" },
                { key: "parachoque-traseiro", label: "Para-choque Traseiro", type: "mod", img: "imagens/rear_bumper.png" },
                { key: "saias", label: "Saias", type: "mod", img: "imagens/saia.png" },
                { key: "escapamento", label: "Escapamento", type: "mod", img: "imagens/escapamento.png" },
                { key: "grelha", label: "Grelha", type: "mod", img: "imagens/grelha.png" },
                { key: "capô", label: "Capô", type: "mod", img: "imagens/capo.png" },
                { key: "para-lama", label: "Para-lama", type: "mod", img: "imagens/paralama.png" },
                { key: "teto", label: "Teto", type: "mod", img: "imagens/teto.png" },
                // Interior
                { key: "roll-cage", label: "Santo Antônio", type: "mod", img: "imagens/chassi.png" },
                { key: "interior", label: "Interior", type: "mod", img: "imagens/interior.png" },
                { key: "dashboard", label: "Painel", type: "mod", img: "imagens/painel.png" },
                { key: "dials", label: "Ponteiros", type: "mod", img: "imagens/ponteiro.png" },
                { key: "seats", label: "Bancos", type: "mod", img: "imagens/seats.png" },
                { key: "ornaments", label: "Enfeites", type: "mod", img: "imagens/enfeites.png" },
                { key: "steering-wheel", label: "Volante", type: "mod", img: "imagens/cockpit.png" },
                { key: "shifter-leavers", label: "Câmbio", type: "mod" },
                { key: "plaques", label: "Placas Int.", type: "mod", img: "imagens/placa.png" },
                { key: "speakers", label: "Falantes", type: "mod" },
                { key: "trunk", label: "Porta-malas", type: "mod" },
                // Others
                { key: "placa", label: "Placa", type: "mod", img: "imagens/placa.png" },
                { key: "vidro", label: "Insulfilm", type: "mod", img: "imagens/window.png" },
                { key: "buzina", label: "Buzina", type: "mod", img: "imagens/buzina.png" }
            ]
        }
    ];

    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.action === "showMenu") {
            $("#bennys-hover").hide();
            $("#actionmenu").fadeIn(300);
        } else if (item.action === "hideMenu") {
            $("#actionmenu").fadeOut(300);
        } else if (item.action === "showHover") {
            if (typeof item.x === "number" && typeof item.y === "number") {
                const x = Math.max(0, Math.min(1, item.x));
                const y = Math.max(0, Math.min(1, item.y));
                $("#bennys-hover").css({
                    left: `${x * 100}vw`,
                    top: `${y * 100}vh`
                });
            }
            if (typeof item.title === "string") $("#bennys-hover-title").text(item.title);
            if (typeof item.subtitle === "string") $("#bennys-hover-subtitle").text(item.subtitle);
            $("#bennys-hover").stop(true, true).fadeIn(120);
        } else if (item.action === "hideHover") {
            $("#bennys-hover").stop(true, true).fadeOut(120);
        } else if (item.action === "vehicle") {
            vehicleData = item.vehicle;
            if (item.prices) prices = item.prices;
            if (item.mods) mods = item.mods;
            renderCategories();
            // Select first category by default
            selectCategory(categories[0].id);
        } else if (item.action === "price") {
            cartTotal = item.price;
            $("#preco").text("$ " + cartTotal);
        } else if (item.action === "repair") {
            $("#repair").fadeOut();
        } else if (item.action === "applying") {
            $("#actionmenu").hide();
        }
    });

    // --- CUSTOM COLOR PICKER LOGIC ---
    const ColorPicker = {
        state: {},

        getState: function(type) {
            if (!this.state[type]) this.state[type] = { h: 0, s: 100, v: 100 };
            return this.state[type];
        },
        
        init: function(container, type, initialHex) {
            let self = this;
            const st = this.getState(type);
            
            // Render HTML
            let html = `
                <div class="cp-container">
                    ${(type === 'primaria' || type === 'secundaria') ? `
                    <div class="cp-label">Material ${type === 'primaria' ? 'Primário' : 'Secundário'}</div>
                    <select class="cp-select" onchange="ColorPicker.setMaterial('${type}', this.value)">
                        <option value="metálico">Metálico</option>
                        <option value="fosco">Fosco</option>
                        <option value="metal">Metal</option>
                        <option value="cromado">Cromado</option>
                    </select>
                    ` : ''}
                    
                    <div class="cp-label">Cor ${type === 'primaria' ? 'Primária' : (type === 'secundaria' ? 'Secundária' : 'Custom')}</div>
                    
                    <div class="cp-saturation" id="cp-sat-${type}">
                        <div class="cp-saturation-white"></div>
                        <div class="cp-saturation-black"></div>
                        <div class="cp-cursor" id="cp-cursor-${type}"></div>
                    </div>
                    
                    <div class="cp-controls">
                        <div class="cp-hex-row">
                            <span>HEX:</span>
                            <input type="text" class="cp-hex-input" id="cp-hex-${type}" value="FFFFFF" maxlength="6">
                        </div>
                        <div class="cp-hue-slider" id="cp-hue-${type}">
                            <div class="cp-hue-thumb" id="cp-hue-thumb-${type}"></div>
                        </div>
                    </div>
                </div>
            `;
            container.append(html);
            
            // Set initial color if provided (convert hex to hsv)
            if (initialHex) {
                let rgb = hexToRgb(initialHex);
                if (rgb) {
                    let hsv = this.rgbToHsv(rgb.r, rgb.g, rgb.b);
                    st.h = hsv.h * 360;
                    st.s = hsv.s * 100;
                    st.v = hsv.v * 100;
                }
            }
            
            this.updateUI(type);
            this.bindEvents(type);
        },
        
        bindEvents: function(type) {
            let self = this;
            const st = this.getState(type);
            let isDraggingSat = false;
            let isDraggingHue = false;
            
            // Saturation/Value Area
            let satBox = $(`#cp-sat-${type}`);
            
            function updateSat(e) {
                let offset = satBox.offset();
                let x = e.pageX - offset.left;
                let y = e.pageY - offset.top;
                
                // Clamp
                x = Math.max(0, Math.min(x, satBox.width()));
                y = Math.max(0, Math.min(y, satBox.height()));
                
                st.s = (x / satBox.width()) * 100;
                st.v = 100 - ((y / satBox.height()) * 100);
                
                self.updateUI(type);
                self.applyColor(type);
            }
            
            satBox.mousedown(function(e) {
                isDraggingSat = true;
                updateSat(e);
            });
            
            // Hue Slider
            let hueBox = $(`#cp-hue-${type}`);
            
            function updateHue(e) {
                let offset = hueBox.offset();
                let x = e.pageX - offset.left;
                
                // Clamp
                x = Math.max(0, Math.min(x, hueBox.width()));
                
                st.h = (x / hueBox.width()) * 360;
                
                self.updateUI(type);
                self.applyColor(type);
            }
            
            hueBox.mousedown(function(e) {
                isDraggingHue = true;
                updateHue(e);
            });
            
            $(document).mouseup(function() {
                isDraggingSat = false;
                isDraggingHue = false;
            });
            
            $(document).mousemove(function(e) {
                if (isDraggingSat) updateSat(e);
                if (isDraggingHue) updateHue(e);
            });
            
            // Hex Input
            $(`#cp-hex-${type}`).change(function() {
                let hex = $(this).val();
                let rgb = hexToRgb(hex);
                if (rgb) {
                    let hsv = self.rgbToHsv(rgb.r, rgb.g, rgb.b);
                    st.h = hsv.h * 360;
                    st.s = hsv.s * 100;
                    st.v = hsv.v * 100;
                    self.updateUI(type);
                    self.applyColor(type);
                }
            });
        },
        
        updateUI: function(type) {
            const st = this.getState(type);
            // Update Saturation Box Background
            $(`#cp-sat-${type}`).css('background-color', `hsl(${st.h}, 100%, 50%)`);
            
            // Update Cursor Position
            let satBox = $(`#cp-sat-${type}`);
            let x = (st.s / 100) * satBox.width();
            let y = (1 - (st.v / 100)) * satBox.height();
            $(`#cp-cursor-${type}`).css({ left: x, top: y });
            
            // Update Hue Thumb
            let hueBox = $(`#cp-hue-${type}`);
            let hx = (st.h / 360) * hueBox.width();
            $(`#cp-hue-thumb-${type}`).css({ left: hx });
            
            // Update Hex Input
            let rgb = this.hsvToRgb(st.h / 360, st.s / 100, st.v / 100);
            let hex = rgbToHex(rgb);
            $(`#cp-hex-${type}`).val(hex.replace('#', '').toUpperCase());
        },
        
        applyColor: function(type) {
            const st = this.getState(type);
            let rgb = this.hsvToRgb(st.h / 360, st.s / 100, st.v / 100);
            if (type === "perolado") {
                const idx = rgbToPeroladoIndex(rgb);
                $.post("http://nation_bennys/callbacks", JSON.stringify({ type: `perolado-color-${idx}` }));
                return;
            }
            pickColor(type, `${rgb.r},${rgb.g},${rgb.b}`);
        },
        
        setMaterial: function(type, material) {
             const st = this.getState(type);
             st.material = material;
        },
        
        // Helpers
        hsvToRgb: function(h, s, v) {
            var r, g, b;
            var i = Math.floor(h * 6);
            var f = h * 6 - i;
            var p = v * (1 - s);
            var q = v * (1 - f * s);
            var t = v * (1 - (1 - f) * s);
            switch (i % 6) {
                case 0: r = v, g = t, b = p; break;
                case 1: r = q, g = v, b = p; break;
                case 2: r = p, g = v, b = t; break;
                case 3: r = p, g = q, b = v; break;
                case 4: r = t, g = p, b = v; break;
                case 5: r = v, g = p, b = q; break;
            }
            return {
                r: Math.round(r * 255),
                g: Math.round(g * 255),
                b: Math.round(b * 255)
            };
        },
        
        rgbToHsv: function(r, g, b) {
            r /= 255, g /= 255, b /= 255;
            var max = Math.max(r, g, b), min = Math.min(r, g, b);
            var h, s, v = max;
            var d = max - min;
            s = max == 0 ? 0 : d / max;
            if (max == min) {
                h = 0;
            } else {
                switch (max) {
                    case r: h = (g - b) / d + (g < b ? 6 : 0); break;
                    case g: h = (b - r) / d + 2; break;
                    case b: h = (r - g) / d + 4; break;
                }
                h /= 6;
            }
            return { h: h, s: s, v: v };
        }
    };
    
    // Expose to window so HTML can access if needed (though we use listeners)
    window.ColorPicker = ColorPicker;

    window.pickColor = function(kind, rgb) {
        const payload = { color: rgb };
        if (kind === "primaria") {
            payload.type = "cor-primaria";
        } else if (kind === "secundaria") {
            payload.type = "cor-secundaria";
        } else if (kind === "neon") {
            payload.type = "neon-colors";
        } else if (kind === "smoke") {
            payload.type = "smoke";
        } else {
            payload.type = kind;
        }
        $.post("http://nation_bennys/callbacks", JSON.stringify(payload));
    }

    function renderCategories() {
        const list = $("#categories-list");
        list.empty();

        categories.forEach(cat => {
            let html = `
                <div class="hex-item" data-id="${cat.id}" onclick="selectCategory('${cat.id}')">
                    <img src="${cat.img}" class="category-icon">
                    <i class="${cat.icon}"></i>
                    <div class="hex-label">${cat.name}</div>
                </div>
            `;
            list.append(html);
        });
    }

    window.selectCategory = function(id) {
        currentCategory = id;
        $(".hex-item").removeClass("active");
        $(`.hex-item[data-id="${id}"]`).addClass("active");
        
        const category = categories.find(c => c.id === id);
        $("#category-title").text(category.name);
        
        renderOptions(category);
    }

    function getPrice(key) {
        if (mods[key] !== undefined && prices[mods[key]]) return prices[mods[key]].startprice;
        if (prices[key]) return prices[key].startprice;
        // Check for specific price keys in config.prices that match key directly
        return 0;
    }

    function renderOptions(category) {
        const grid = $("#options-grid");
        grid.empty();

        // Special handling for Wheels UI
        if (category.id === "wheels") {
            createCustomWheelsUI(grid);
            return;
        }

        category.items.forEach(item => {
            // Check if mod exists for vehicle
            // Special handling for some types
            let price = getPrice(item.key);
            
            if (item.type === 'mod') {
                if (vehicleData[item.key]) {
                    // It's a mod with count and current index
                    // vehicleData[item.key] = [numMods, currentModIndex]
                    let numMods = vehicleData[item.key][0];
                    let current = vehicleData[item.key][1];
                    
                    // If numMods > 0, show it
                    if (numMods > 0) {
                        if (category.id === "extra") {
                            createArrowSelector(grid, item, numMods, current, price);
                        } else {
                            createModSelector(grid, item, numMods, current, price);
                        }
                    }
                }
            } else if (item.type === 'toggle') {
                let active = vehicleData[item.key]; // boolean
                createToggle(grid, item, active, price);
            } else if (item.type === 'wheel') {
                // Wheel categories - DEPRECATED in favor of custom UI
                createWheelSelector(grid, item);
            } else if (item.type === 'color') {
                createColorSelector(grid, item, price);
            } else if (item.type === 'xenon') {
                createXenonSelector(grid, item, price);
            } else if (item.type === 'neon') {
                let active = vehicleData["neon"];
                createNeonSelector(grid, item, active, price);
            } else if (item.type === 'custom-tires') {
                createCustomTiresSelector(grid, item, price);
            }
        });
    }

    // --- Custom Wheels UI ---
    let currentWheelType = "sport";
    const wheelTypes = [
        { id: "stock", label: "ORIGINAL" },
        { id: "sport", label: "SPORT" },
        { id: "muscle", label: "MUSCLE" },
        { id: "lowrider", label: "LOWRIDER" },
        { id: "suv", label: "SUV" },
        { id: "offroad", label: "OFFROAD" },
        { id: "tuner", label: "TUNER" },
        { id: "highend", label: "HIGH END" }
    ];

    // Colors for Wheel Grid (Standard GTA Palette approximation)
    const wheelColors = [
        "#111111", "#333333", "#555555", "#777777", "#999999", "#BBBBBB", "#DDDDDD", "#FFFFFF", // Grayscale
        "#FF0000", "#AA0000", "#550000", // Reds
        "#00FF00", "#00AA00", "#005500", // Greens
        "#0000FF", "#0000AA", "#000055", // Blues
        "#FFFF00", "#FFAA00", "#FF5500", // Yellow/Orange
        "#FF00FF", "#AA00AA", // Purples
        "#00FFFF", "#00AAAA"  // Cyans
    ];

    function createCustomWheelsUI(container) {
        // Dropdown for Wheel Category
        let dropdownHtml = `
            <div class="wheel-ui-container">
                <div class="option-label">CATEGORIA DE RODAS</div>
                <select id="wheel-type-select" class="custom-select" onchange="changeWheelType(this.value)">
                    ${wheelTypes.map(t => `<option value="${t.id}" ${t.id === currentWheelType ? 'selected' : ''}>${t.label}</option>`).join('')}
                </select>
                
                <div class="option-label" style="margin-top: 20px;">RODAS</div>
                <div class="wheel-selector-controls">
                    <button class="arrow-btn left" onclick="prevWheel()"><i class="fas fa-chevron-left"></i></button>
                    <div id="current-wheel-name" class="wheel-name-display">N/A</div>
                    <button class="arrow-btn right" onclick="nextWheel()"><i class="fas fa-chevron-right"></i></button>
                </div>
                
                <div class="option-label" style="margin-top: 20px;">COR DAS RODAS</div>
                <div class="wheel-color-grid">
                    ${wheelColors.map((color, index) => `
                        <div class="hex-color-small" onclick="setWheelColor(${index})" style="background-color: ${color};"></div>
                    `).join('')}
                </div>
                
                <div class="option-label" style="margin-top: 20px;">FUMAÇA</div>
                <div class="toggle-container" onclick="toggleSmoke()">
                    <div id="smoke-yes" class="toggle-option">SIM</div>
                    <div id="smoke-no" class="toggle-option">NÃO</div>
                </div>
            </div>
        `;
        container.append(dropdownHtml);

        changeWheelType(currentWheelType);
    }
    
    // Global functions for wheel UI
    window.changeWheelType = function(type) {
        currentWheelType = type;
        if (currentWheelType === "stock") {
            window._wheelMax = 0;
            currentWheelIndex = -1;
            $.post('http://nation_bennys/callbacks', JSON.stringify({ type: "dianteira-0" }));
            updateWheelUI();
            return;
        }
        let info = vehicleData[type];
        if (info && info.length >= 3) {
            const active = !!info[0];
            const wheel = parseInt(info[1]);
            const num = parseInt(info[2]);
            window._wheelMax = isNaN(num) ? 0 : num;
            currentWheelIndex = (active && wheel >= 0) ? (wheel + 1) : -1;
        } else {
            window._wheelMax = 0;
            currentWheelIndex = -1;
        }
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: currentWheelType }));
        updateWheelUI();
    }

    let currentWheelIndex = -1; // Start at N/A

    window.prevWheel = function() {
        if (currentWheelType === "stock") return;
        if (currentWheelIndex > -1) {
            currentWheelIndex--;
            if (currentWheelIndex >= 1) {
                applyWheel(currentWheelType, currentWheelIndex);
            } else {
                currentWheelIndex = -1;
                applyWheel(currentWheelType, 0);
            }
            updateWheelUI();
        }
    }

    window.nextWheel = function() {
        if (currentWheelType === "stock") return;
        if (currentWheelIndex < 1) {
            currentWheelIndex = 1;
        } else {
            if (window._wheelMax && currentWheelIndex >= window._wheelMax) {
                currentWheelIndex = window._wheelMax;
            } else {
                currentWheelIndex++;
            }
        }
        applyWheel(currentWheelType, currentWheelIndex);
        updateWheelUI();
    }

    function applyWheel(type, index) {
        if (type === "stock") {
            $.post('http://nation_bennys/callbacks', JSON.stringify({ type: "dianteira-0" }));
            return;
        }
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: `${type}-${index}` }));
    }

    window.setWheelColor = function(index) {
        // Color index logic
        // "wheelcolor" in mod items was type mod.
        // We need to set wheel color. 
        // Is there a callback for wheel color index?
        // client.lua handles "wheelcolor" as mod?
        // Wait, earlier script had "wheelcolor" as mod type.
        // Let's assume we can send a callback.
        // Or use pickColor if it supports index.
        // The original script had: { key: "wheelcolor", label: "Cor das Rodas", type: "mod", ... }
        // This implies it's a mod with ID.
        // If it's a mod, we use updateMod('wheelcolor', index).
        updateMod('wheelcolor', index);
    }
    
    window.toggleSmoke = function() {
        const next = !vehicleData["smoke"];
        vehicleData["smoke"] = next;
        if (next) {
            pickColor("smoke", "255,255,255");
        } else {
            pickColor("smoke", "0,0,0");
        }
        updateWheelUI();
    }

    function updateWheelUI() {
        if (currentWheelType === "stock") {
            $("#current-wheel-name").text("ORIGINAL");
        } else if (currentWheelIndex < 1) {
            $("#current-wheel-name").text(`${currentWheelType.toUpperCase()} PADRÃO`);
        } else {
            $("#current-wheel-name").text(`${currentWheelType.toUpperCase()} ${currentWheelIndex}`);
        }
        
        // Update Smoke Toggle State
        let smokeActive = !!vehicleData["smoke"];
        if (smokeActive) {
            $("#smoke-yes").addClass("active");
            $("#smoke-no").removeClass("active");
        } else {
            $("#smoke-yes").removeClass("active");
            $("#smoke-no").addClass("active");
        }
        
        // Update Wheel Color Grid (populate with colors)
        // We need the colors array from client.lua?
        // client.lua has `colors` table.
        // We can hardcode some standard GTA colors or just show indices.
        // The screenshot shows a grid of hex colors.
        // I will update the grid HTML in createCustomWheelsUI to be more realistic if needed.
    }

    // Perolado helper already handled by createColorSelector when colorType === 'perolado'
    
    window.updateModIndex = function(key, val) {
        const v = parseInt(val);
        const send = isNaN(v) ? 0 : (v + 1);
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: `${key}-${send}` }));
        if (vehicleData[key] && Array.isArray(vehicleData[key])) vehicleData[key][1] = v;
    }

    window.updateModRaw = function(key, val) {
        const v = parseInt(val);
        const send = isNaN(v) ? 0 : v;
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: `${key}-${send}` }));
        if (vehicleData[key] && Array.isArray(vehicleData[key])) vehicleData[key][1] = v;
    }

    window.updateMod = function(key, val) {
        const v = parseInt(val);
        const send = isNaN(v) ? 0 : v;
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: `${key}-${send}` }));
        if (vehicleData[key] && Array.isArray(vehicleData[key])) vehicleData[key][1] = v;
    }

    window.updateXenonColor = function(val) {
        const v = parseInt(val);
        const send = isNaN(v) ? 0 : v;
        $.post('http://nation_bennys/callbacks', JSON.stringify({ type: `xenon-color-${send}` }));
        vehicleData["xenoncolor"] = send;
    }

    window.pickColor = function(type, rgb) {
        if (type === "primaria") {
            $.post("http://nation_bennys/callbacks", JSON.stringify({ type: "cor-primaria", color: rgb }));
        } else if (type === "secundaria") {
            $.post("http://nation_bennys/callbacks", JSON.stringify({ type: "cor-secundaria", color: rgb }));
        } else if (type === "neon") {
            $.post("http://nation_bennys/callbacks", JSON.stringify({ type: "neon-colors", color: rgb }));
        } else if (type === "smoke") {
            $.post("http://nation_bennys/callbacks", JSON.stringify({ type: "smoke-colors", color: rgb }));
        }
    }

    window.toggleMod = function(key, active) {
        $.post('http://nation_bennys/callbacks', JSON.stringify({
            type: key + "-" + (active ? 1 : 0) // 1 for on, 0 for off? or toggle logic
        }));
        // Update local
        vehicleData[key] = active;
        // Update UI classes for toggles
        const row = $(`.option-row[data-key="${key}"]`);
        if (row.length) {
            const opts = row.find('.toggle-option');
            opts.removeClass('active');
            if (active) opts.eq(0).addClass('active'); else opts.eq(1).addClass('active');
        }
        if (key === "smoke") updateWheelUI();
    }

    window.setSliderFill = function(el) {
        const min = parseFloat(el.min);
        const max = parseFloat(el.max);
        const val = parseFloat(el.value);
        const pct = ((val - min) / (max - min)) * 100;
        el.style.background = `linear-gradient(to right, rgba(0,229,255,0.9) 0%, rgba(0,229,255,0.9) ${pct}%, rgba(255,255,255,0.22) ${pct}%, rgba(255,255,255,0.22) 100%)`;
    }

    window.handleSliderInput = function(el, key) {
        setSliderFill(el);
        updateModIndex(key, el.value);
    }

    function createModSelector(container, item, max, current, price) {
        let html = `
            <div class="option-row" data-key="${item.key}">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="slider-container">
                    <input type="range" min="-1" max="${max-1}" value="${current}" class="mod-slider" 
                        oninput="handleSliderInput(this, '${item.key}')"
                        onchange="handleSliderInput(this, '${item.key}')">
                </div>
            </div>
        `;
        container.append(html);
        const inputEl = container.find(`.option-row[data-key="${item.key}"] .mod-slider`)[0];
        if (inputEl) setSliderFill(inputEl);
    }

    function createToggle(container, item, active, price) {
        let html = `
            <div class="option-row" data-key="${item.key}">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="toggle-container" onclick="toggleMod('${item.key}', ${!active})">
                    <div class="toggle-option ${active ? 'active' : ''}">SIM</div>
                    <div class="toggle-option ${!active ? 'active' : ''}">NÃO</div>
                </div>
            </div>
        `;
        container.append(html);
    }

    function createWheelSelector(container, item) {
        // Wheel categories usually don't have a single price, price depends on specific wheel or wheel type
        let html = `
            <div class="wheel-category-btn" onclick="selectWheelCategory('${item.wheelType}')">
                <div style="display:flex; align-items:center; gap:10px;">
                    ${item.img ? `<img src="${item.img}" style="width:24px; height:24px; object-fit:contain;">` : ''}
                    <span>${item.label}</span>
                </div>
                <i class="fas fa-chevron-right"></i>
            </div>
        `;
        container.append(html);
    }
    
    function rgbToHex(rgb) {
        var r = rgb.r.toString(16).padStart(2, '0');
        var g = rgb.g.toString(16).padStart(2, '0');
        var b = rgb.b.toString(16).padStart(2, '0');
        return "#" + r + g + b;
    }

    function hexToRgb(hex) {
        if (hex === undefined || hex === null) return null;
        let h = String(hex).trim();
        if (h.startsWith("#")) h = h.slice(1);
        if (h.length === 3) h = h.split("").map(c => c + c).join("");
        if (!/^[0-9a-fA-F]{6}$/.test(h)) return null;
        const num = parseInt(h, 16);
        return { r: (num >> 16) & 255, g: (num >> 8) & 255, b: num & 255 };
    }

    function rgbToPeroladoIndex(rgb) {
        const candidates = [];
        for (let i = 0; i < 160; i++) candidates.push(i);

        let bestIdx = 0;
        let bestDist = Infinity;

        for (let i = 0; i < candidates.length; i++) {
            const idx = candidates[i];
            const hsvRgb = ColorPicker.hsvToRgb(idx / 160, 0.85, 0.95);
            const dr = (rgb.r - hsvRgb.r);
            const dg = (rgb.g - hsvRgb.g);
            const db = (rgb.b - hsvRgb.b);
            const d = dr * dr + dg * dg + db * db;
            if (d < bestDist) {
                bestDist = d;
                bestIdx = idx;
            }
        }
        return bestIdx;
    }

    function createColorSelector(container, item, price) {
        if (item.colorType === 'primaria' || item.colorType === 'secundaria') {
            // Use Custom Color Picker
            let currentHex = vehicleData[item.key] || "#FFFFFF";
            ColorPicker.init(container, item.colorType, currentHex);
        } else if (item.colorType === 'perolado') {
            let html = `
                <div class="option-row">
                    <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                        <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                            ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                            <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                        </div>
                        <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                    </div>
                    <div id="perolado-picker"></div>
                </div>
            `;
            container.append(html);
            ColorPicker.init(container.find("#perolado-picker"), "perolado", null);
        } else {
            // Use Grid for others (Neon, Smoke)
            let html = `
                <div class="option-row">
                    <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                        <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                            ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                            <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                        </div>
                        <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                    </div>
                    <div class="color-grid">
                        <div class="hex-color" style="background: #000;" onclick="pickColor('${item.colorType}', '0,0,0')"></div>
                        <div class="hex-color" style="background: #fff;" onclick="pickColor('${item.colorType}', '255,255,255')"></div>
                        <div class="hex-color" style="background: #ff0000;" onclick="pickColor('${item.colorType}', '255,0,0')"></div>
                        <div class="hex-color" style="background: #00ff00;" onclick="pickColor('${item.colorType}', '0,255,0')"></div>
                        <div class="hex-color" style="background: #0000ff;" onclick="pickColor('${item.colorType}', '0,0,255')"></div>
                        <div class="hex-color" style="background: #ffff00;" onclick="pickColor('${item.colorType}', '255,255,0')"></div>
                        <div class="hex-color" style="background: #ff00ff;" onclick="pickColor('${item.colorType}', '255,0,255')"></div>
                        <div class="hex-color" style="background: #00ffff;" onclick="pickColor('${item.colorType}', '0,255,255')"></div>
                        <div class="hex-color" style="background: #808080;" onclick="pickColor('${item.colorType}', '128,128,128')"></div>
                        <div class="hex-color" style="background: #c0c0c0;" onclick="pickColor('${item.colorType}', '192,192,192')"></div>
                        <div class="hex-color" style="background: #800000;" onclick="pickColor('${item.colorType}', '128,0,0')"></div>
                        <div class="hex-color" style="background: #808000;" onclick="pickColor('${item.colorType}', '128,128,0')"></div>
                    </div>
                </div>
            `;
            container.append(html);
        }
    }
    
    window.setPerolado = function(index) {
        $.post('http://nation_bennys/callbacks', JSON.stringify({
            type: "perolado-color-" + index
        }));
    }
    function createXenonSelector(container, item, price) {
        let html = `
            <div class="option-row">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">Cor Xenon</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="slider-container">
                    <input type="range" min="0" max="12" value="0" class="mod-slider" oninput="updateXenonColor(this.value)">
                </div>
            </div>
        `;
        container.append(html);
    }

    function createNeonSelector(container, item, active, price) {
         let html = `
            <div class="option-row">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="toggle-container" onclick="toggleNeon(${!active})">
                    <div class="toggle-option ${active ? 'active' : ''}">SIM</div>
                    <div class="toggle-option ${!active ? 'active' : ''}">NÃO</div>
                </div>
            </div>
        `;
        container.append(html);
    }
    
    function createCustomTiresSelector(container, item, price) {
         let html = `
            <div class="option-row" onclick="toggleCustomTires()">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">Pneus Custom</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="toggle-container">
                    <div class="toggle-option">ALTERNAR</div>
                </div>
            </div>
        `;
        container.append(html);
    }
 
    // --- Arrow selectors for EXTRA ---
    function createArrowSelector(container, item, max, current, price) {
        const displayText = current < 0 ? "N/A" : `OPÇÃO ${parseInt(current) + 1}`;
        let html = `
            <div class="option-row" data-key="${item.key}">
                <div class="option-header" style="display:flex; justify-content:space-between; align-items: center; margin-bottom: 10px;">
                    <div class="option-left" style="display:flex; align-items:center; gap:10px;">
                        ${item.img ? `<img src="${item.img}" style="width:28px; height:28px; object-fit:contain;">` : ''}
                        <div class="option-label" style="margin-bottom:0;">${item.label}</div>
                    </div>
                    <div class="option-price" style="color:#00e5ff; font-weight:bold; font-size:12px;">$ ${price}</div>
                </div>
                <div class="wheel-selector-controls mod-arrow-controls">
                    <button class="arrow-btn left" onclick="prevMod('${item.key}', ${max})"><i class="fas fa-chevron-left"></i></button>
                    <div id="mod-name-${item.key}" class="wheel-name-display">${displayText}</div>
                    <button class="arrow-btn right" onclick="nextMod('${item.key}', ${max})"><i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
        `;
        container.append(html);
    }
    window.prevMod = function(key, max) {
        if (!vehicleData[key]) return;
        let current = parseInt(vehicleData[key][1]);
        if (isNaN(current)) current = -1;
        if (current > -1) current--;
        updateModIndex(key, current);
        $(`#mod-name-${key}`).text(current < 0 ? "N/A" : `OPÇÃO ${current + 1}`);
    }
    window.nextMod = function(key, max) {
        if (!vehicleData[key]) return;
        let current = parseInt(vehicleData[key][1]);
        if (isNaN(current)) current = -1;
        if (current < (parseInt(max) - 1)) current++;
        updateModIndex(key, current);
        $(`#mod-name-${key}`).text(current < 0 ? "N/A" : `OPÇÃO ${current + 1}`);
    }

    // Neon toggle helper (client.lua expects "neon-kit" / "neon-default")
    window.toggleNeon = function(active) {
        $.post('http://nation_bennys/callbacks', JSON.stringify({
            type: active ? "neon-kit" : "neon-default"
        }));
        vehicleData["neon"] = active;
        const row = $(`.option-row[data-key="neon"]`);
        if (row.length) {
            const opts = row.find('.toggle-option');
            opts.removeClass('active');
            if (active) opts.eq(0).addClass('active'); else opts.eq(1).addClass('active');
        }
    }
    // Custom tires simple toggle (factory/custom)
    let customTiresOn = false;
    window.toggleCustomTires = function() {
        customTiresOn = !customTiresOn;
        $.post('http://nation_bennys/callbacks', JSON.stringify({
            type: customTiresOn ? "pneus-custom" : "pneus-fabrica"
        }));
    }

    // Main Buttons
    $("#pagar").click(function(){
        $.post('http://nation_bennys/pagar', JSON.stringify({}));
        $("#actionmenu").hide();
    });

    $("#sair").click(function(){
        $.post('http://nation_bennys/close', JSON.stringify({}));
    });
    
    $("#voltar").click(function(){
        // Logic to go back if deep in menu (like wheels)
        renderOptions(categories.find(c => c.id === currentCategory));
    });

    $("#reparar").click(function(){
        $.post('http://nation_bennys/callbacks', JSON.stringify({
            type: "reparar"
        }));
    });

    // Keyboard
    document.onkeyup = function(data){
        if (data.which == 27) {
            $.post('http://nation_bennys/close', JSON.stringify({}));
        } else if (data.which == 72) { // H key
             $.post('http://nation_bennys/cam', JSON.stringify({ cam: "freecam" }));
             $("#actionmenu").fadeOut(100);
        }
    };
});
