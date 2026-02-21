let cart = {};
let currentItems = [];

window.addEventListener('message', function(event) {
    if (event.data.action === "open") {
        document.getElementById("container").style.display = "block";
        currentItems = event.data.items;
        renderItems();
        resetCart();
    }
});

function renderItems() {
    const list = document.getElementById("itemsList");
    list.innerHTML = "";
    
    currentItems.forEach(item => {
        const div = document.createElement("div");
        div.className = "item";
        
        // Use inventory images path
        const imgPath = `nui://inventory/web-side/images/${item.img || item.item + '.png'}`;
        
        div.innerHTML = `
            <img src="${imgPath}" onerror="this.src='https://via.placeholder.com/50?text=?'">
            <div class="item-info">
                <div class="item-name">${item.name}</div>
                <div class="item-price">R$ ${item.price}</div>
            </div>
            <div class="item-controls">
                <button class="btn-qty" onclick="updateQty('${item.item}', -1)">-</button>
                <span class="qty-display" id="qty-${item.item}">0</span>
                <button class="btn-qty" onclick="updateQty('${item.item}', 1)">+</button>
            </div>
        `;
        list.appendChild(div);
    });
}

function updateQty(item, change) {
    if (!cart[item]) cart[item] = 0;
    cart[item] += change;
    if (cart[item] < 0) cart[item] = 0;
    
    const qtyDisplay = document.getElementById(`qty-${item}`);
    if (qtyDisplay) {
        qtyDisplay.innerText = cart[item];
    }
    updateTotals();
}

function updateTotals() {
    let totalItems = 0;
    let totalPrice = 0;
    
    for (const [key, qty] of Object.entries(cart)) {
        if (qty > 0) {
            const itemData = currentItems.find(i => i.item === key);
            if (itemData) {
                totalItems += qty;
                totalPrice += qty * itemData.price;
            }
        }
    }
    
    document.getElementById("totalItems").innerText = totalItems;
    document.getElementById("totalPrice").innerText = "R$ " + totalPrice;
}

function resetCart() {
    cart = {};
    document.querySelectorAll(".qty-display").forEach(el => el.innerText = "0");
    updateTotals();
}

function closeUI() {
    document.getElementById("container").style.display = "none";
    fetch("https://catcafe_totem/close", { method: "POST" });
}

function confirmBuy() {
    const itemsToBuy = [];
    for (const [key, qty] of Object.entries(cart)) {
        if (qty > 0) {
            const itemData = currentItems.find(i => i.item === key);
            itemsToBuy.push({ item: key, amount: qty, price: itemData.price });
        }
    }
    
    if (itemsToBuy.length > 0) {
        fetch("https://catcafe_totem/buy", {
            method: "POST",
            body: JSON.stringify({ cart: itemsToBuy })
        });
        closeUI();
    } else {
        // Optional: Notify user to select items
    }
}

document.onkeydown = function(data) {
    if (data.which == 27) {
        closeUI();
    }
};
