$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.action === "openTablet") {
            $("#tablet-container").fadeIn(200);
            renderOrders(item.orders);
        } else if (item.action === "closeTablet") {
            $("#tablet-container").fadeOut(200);
        }
    });

    $("#close-tablet").click(function(){
        $("#tablet-container").fadeOut(200);
        $.post('http://nation_bennys/closeTablet', JSON.stringify({}));
    });

    // Close on escape
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $("#tablet-container").fadeOut(200);
            $.post('http://nation_bennys/closeTablet', JSON.stringify({}));
        }
    });
});

function renderOrders(orders) {
    var list = $("#orders-list");
    list.empty();
    
    // Check if orders is empty
    if (Object.keys(orders).length === 0) {
        list.append(`
            <div class="empty-state">
                <i class="fas fa-clipboard-check"></i>
                <span>Nenhuma ordem de serviço pendente</span>
            </div>
        `);
        return;
    }

    let counter = 1;
    $.each(orders, function(key, order) {
        if (!order) return;
        
        // Shorten ID for display if needed, or use counter
        let displayId = counter.toString().padStart(3, '0');
        
        var html = `
            <div class="order-item">
                <div class="order-id">
                    <i class="fas fa-hashtag"></i> ${displayId}
                </div>
                <div class="vehicle-info">
                    <span class="vehicle-name">${order.vehicleName}</span>
                    <span class="vehicle-plate">${order.plate}</span>
                </div>
                <div class="client-name">
                    <img src="https://ui-avatars.com/api/?name=${encodeURIComponent(order.name)}&background=random&color=fff&size=64" alt="">
                    ${order.name}
                </div>
                <div class="order-price">
                    $${order.price}
                </div>
                <div class="action-btn-container">
                    <button class="apply-btn" onclick="applyOrder('${order.id}', '${order.plate}')">
                        APLICAR
                    </button>
                    <button class="deny-btn" onclick="denyOrder('${order.id}')">
                        RECUSAR
                    </button>
                </div>
            </div>
        `;
        list.append(html);
        counter++;
    });
}

// Global function to be called from onclick
window.applyOrder = function(orderId, plate) {
    $.post('http://nation_bennys/applyOrder', JSON.stringify({
        orderId: orderId,
        plate: plate
    }));
}

window.denyOrder = function(orderId) {
    $.post('http://nation_bennys/denyOrder', JSON.stringify({
        orderId: orderId
    }));
}
