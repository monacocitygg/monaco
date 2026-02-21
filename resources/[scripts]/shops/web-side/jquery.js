
var selectShop = "selectShop";
var selectType = "Buy";
var shopItems = [];
var cart = [];
var userInventory = {};

$(document).ready(function() {
    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "showNUI":
                selectShop = event.data.name;
                selectType = event.data.type;
                $("#app").css("display", "flex");
                $(".shop-title").html(selectShop || "Loja de departamento");
                const isIllegal = (selectShop || "").toLowerCase() === "ilegal";
                $("#app").toggleClass("illegal-shop", isIllegal);
                requestShop();
                break;

            case "hideNUI":
                $("#app").css("display", "none");
                break;

            case "requestShop":
                requestShop();
                break;
            
            case "updateShops":
                requestShop();
                break;
        }
    });

    document.onkeyup = data => {
        if (data["key"] === "Escape") {
            $.post("http://shops/close");
            resetShop();
        }
    }

    // Filter Logic
    $(".filter-btn").click(function() {
        $(".filter-btn").removeClass("active");
        $(this).addClass("active");
        const category = $(this).data("category");
        renderProducts(category);
    });

    // Search Logic
    $("#search-input").on("input", function() {
        const query = $(this).val().toLowerCase();
        renderProducts("all", query);
    });

    // Checkout
    $("#checkout-btn").click(function() {
        if (cart.length === 0) return;
        processCheckout();
    });
});

function resetShop() {
    cart = [];
    shopItems = [];
    userInventory = {};
    updateCartUI();
    $("#search-input").val("");
}

function requestShop() {
    $.post("http://shops/requestShop", JSON.stringify({ shop: selectShop }), (data) => {
        if (data) {
            // Process Shop Items
            // Data.shopSlots comes as an object/array. We need to normalize it.
            // Based on previous code: { key: "item_id", amount: 10, price: 100, name: "Item Name", index: "item_index" }
            // Actually previous code just rendered grids. We need to inspect the data structure more if possible, 
            // but assuming standard vRP structure: key => { amount, price, name, index, weight, etc }
            
            // Let's assume shopSlots is an object where keys are slot numbers or item names.
            // We'll convert it to an array for easier rendering.
            
            shopItems = [];
            const productList = data.inventoryShop;
            const inventory = data.inventoryUser;
            userInventory = inventory; // Store for checkout logic

            if (Array.isArray(productList)) {
                productList.forEach(item => {
                    shopItems.push({
                        key: item.key,
                        name: item.name,
                        price: item.price,
                        amount: item.amount || 1, // Default amount for shop items is usually 1 or unlimited logic handled elsewhere
                        image: `nui://inventory/web-side/images/${item.index || item.key}.png`,
                        weight: item.peso,
                        slot: item.key // For shop items, key is essentially the ID
                    });
                });
            } else if (typeof productList === 'object') {
                 // Fallback if it comes as object
                 for (const [key, item] of Object.entries(productList)) {
                    shopItems.push({
                        key: item.key,
                        name: item.name,
                        price: item.price,
                        amount: item.amount || 1,
                        image: `nui://inventory/web-side/images/${item.index || item.key}.png`,
                        weight: item.peso,
                        slot: key
                    });
                }
            }

            renderProducts();
            
            // Update Balance based on shop type
            let totalMoney = 0;
            const useDirty = (selectShop || "").toLowerCase() === "ilegal";

            if (data.inventoryUser) {
                const inv = Object.values(data.inventoryUser);
                inv.forEach(item => {
                    if (item.item === (useDirty ? "dollars2" : "dollars")) {
                        totalMoney += (item.amount || 0);
                    }
                });
            }
            
            $("#player-balance").text(totalMoney.toLocaleString('pt-BR'));
        }
    });
}

function renderProducts(category = "all", searchQuery = "") {
    const container = $("#products-list");
    container.empty();

    shopItems.forEach(item => {
        // Filter logic (Basic implementation)
        // If we had categories in item data, we would use it. 
        // For now, "all" shows everything.
        
        if (searchQuery && !item.name.toLowerCase().includes(searchQuery)) {
            return;
        }

        const card = `
            <div class="product-card">
                <div class="product-price-tag">R$ ${item.price}</div>
                <div class="product-image" style="background-image: url('${item.image}');"></div>
                <div class="product-name">${item.name}</div>
                
                <div class="product-controls">
                    <button class="qty-btn minus" onclick="adjustQty('${item.key}', -1)">-</button>
                    <span class="product-qty" id="qty-${item.key}">1</span>
                    <button class="qty-btn plus" onclick="adjustQty('${item.key}', 1)">+</button>
                </div>
                
                <button class="add-btn" onclick="addToCart('${item.key}')">
                    <i class="fa-solid fa-cart-plus"></i>
                </button>
            </div>
        `;
        container.append(card);
    });
}

// Helper to track temporary quantities in the grid before adding to cart
var tempQtys = {};

window.adjustQty = function(itemKey, delta) {
    if (!tempQtys[itemKey]) tempQtys[itemKey] = 1;
    tempQtys[itemKey] += delta;
    if (tempQtys[itemKey] < 1) tempQtys[itemKey] = 1;
    $(`#qty-${itemKey}`).text(tempQtys[itemKey]);
}

window.addToCart = function(itemKey) {
    const item = shopItems.find(i => i.key === itemKey);
    if (!item) return;

    const qty = tempQtys[itemKey] || 1;
    
    // Check if item already in cart
    const existing = cart.find(c => c.key === itemKey);
    if (existing) {
        existing.amount += qty;
    } else {
        cart.push({
            ...item,
            amount: qty
        });
    }

    // Reset temp qty
    tempQtys[itemKey] = 1;
    $(`#qty-${itemKey}`).text(1);

    updateCartUI();
}

function updateCartUI() {
    const container = $("#cart-list");
    container.empty();

    if (cart.length === 0) {
        container.html('<div class="empty-cart-message">Carrinho vazio</div>');
        $("#cart-total").text("R$ 0");
        $("#checkout-btn").prop("disabled", true);
        return;
    }

    let total = 0;

    cart.forEach((item, index) => {
        total += item.price * item.amount;
        
        const cartItem = `
            <div class="cart-item">
                <div class="cart-item-img" style="background-image: url('${item.image}');"></div>
                <div class="cart-item-info">
                    <span class="cart-item-name">${item.name}</span>
                    <span class="cart-item-price">R$ ${item.price} x ${item.amount}</span>
                </div>
                <div class="cart-item-remove" onclick="removeFromCart(${index})">
                    <i class="fa-solid fa-trash"></i>
                </div>
            </div>
        `;
        container.append(cartItem);
    });

    $("#cart-total").text(`R$ ${total.toLocaleString('pt-BR')}`);
    $("#checkout-btn").prop("disabled", false);
}

window.removeFromCart = function(index) {
    cart.splice(index, 1);
    updateCartUI();
}

async function processCheckout() {
    // We need to find empty slots for each item
    // Since we don't have a sophisticated slot allocator on client side that perfectly mirrors server,
    // we will try to send requests.
    
    // Issue: The previous system required a target slot.
    // We need to find empty slots in 'userInventory'.
    
    // Strategy:
    // 1. Map current used slots in userInventory.
    // 2. For each item in cart:
    //    Find a free slot.
    //    Trigger functionShops.
    //    Mark slot as used.
    
    // Note: This assumes standard vRP numeric slots (1 to MaxWeight/MaxSlots).
    // Usually vRP uses slot numbers as strings "1", "2", etc.
    
    let usedSlots = Object.keys(userInventory).map(Number);
    // Find max slot? Usually assumes infinite or weight based. 
    // If weight based, we just need unique slot numbers.
    // Let's assume slots 1-100 are valid.
    
    for (const item of cart) {
        // Find first free slot
        let targetSlot = 1;
        while (usedSlots.includes(targetSlot)) {
            targetSlot++;
        }
        
        // Mark as used for next iteration
        usedSlots.push(targetSlot);
        
        // Send request
        // Previous: vSERVER.functionShops(Data["shop"],Data["item"],Data["amount"],Data["slot"])
        $.post("http://shops/functionShops", JSON.stringify({
            shop: selectShop,
            item: item.key,
            amount: parseInt(item.amount),
            slot: targetSlot.toString()
        }));
        
        // Small delay to prevent spam/race conditions
        await new Promise(r => setTimeout(r, 100));
    }

    // Clear cart after checkout
    cart = [];
    updateCartUI();
    // Close shop after checkout
    $.post("http://shops/close");
    resetShop();
}
