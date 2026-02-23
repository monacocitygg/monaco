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

    $.each(orders, function(key, order) {
        if (!order) return;
        
        var html = `
            <div class="order-item">
                <div class="vehicle-info">
                    <span class="vehicle-name">${order.vehicleName}</span>
                    <span class="vehicle-plate">${order.plate}</span>
                </div>
                <div class="client-name">
                    ${order.name}
                </div>
                <div class="order-price">
                    $${order.price}
                </div>
                <div class="action-btn">
                    <button class="apply-btn" onclick="applyOrder('${order.id}', '${order.plate}')">
                        APLICAR
                    </button>
                </div>
            </div>
        `;
        list.append(html);
    });
}

// Global function to be called from onclick
window.applyOrder = function(orderId, plate) {
    $.post('http://nation_bennys/applyOrder', JSON.stringify({
        orderId: orderId,
        plate: plate
    }));
}
