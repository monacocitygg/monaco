let selectedOutfit = null;
let clothesList = [];
let maxSlots = 1;
let isEditing = false;

$(document).ready(function() {
    window.addEventListener("message", function(event) {
        const data = event.data;
        if (data.action === "open") {
            clothesList = data.clothes || [];
            maxSlots = data.maxSlots || 1;
            renderClothes();
            $(".container").fadeIn();
            selectedOutfit = null;
            updateButtons();
        } else if (data.action === "update") {
            clothesList = data.clothes || [];
            maxSlots = data.maxSlots || 1;
            renderClothes();
            selectedOutfit = null;
            updateButtons();
        } else if (data.action === "close") {
            $(".container").fadeOut();
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post("http://wardrobe/close");
            $(".container").fadeOut();
            $("#name-modal").fadeOut();
        }
    };

    $("#equip-btn").click(function() {
        if (selectedOutfit) {
            $.post("http://wardrobe/equip", JSON.stringify({ name: selectedOutfit }));
        }
    });

    $("#edit-btn").click(function() {
        if (selectedOutfit) {
            isEditing = true;
            $("#preset-name").val(selectedOutfit);
            $("#name-modal").fadeIn();
        }
    });

    $("#delete-btn").click(function() {
        if (selectedOutfit) {
            $.post("http://wardrobe/delete", JSON.stringify({ name: selectedOutfit }));
        }
    });

    $("#cancel-save").click(function() {
        $("#name-modal").fadeOut();
        isEditing = false;
    });

    $("#confirm-save").click(function() {
        const name = $("#preset-name").val().trim();
        if (name) {
            if (isEditing) {
                if (name === selectedOutfit) {
                    $.post("http://wardrobe/update", JSON.stringify({ name: name }));
                } else {
                    $.post("http://wardrobe/save", JSON.stringify({ name: name }));
                }
            } else {
                $.post("http://wardrobe/save", JSON.stringify({ name: name }));
            }
            $("#name-modal").fadeOut();
            $("#preset-name").val("");
            isEditing = false;
        }
    });
});

function renderClothes() {
    const grid = $("#outfit-grid");
    grid.empty();

    const totalDisplaySlots = 3;
    const limit = Math.max(totalDisplaySlots, maxSlots, clothesList.length);

    for (let i = 0; i < limit; i++) {
        if (i < clothesList.length) {
            // Render Filled Slot
            const outfit = clothesList[i];
            
            if (i < maxSlots) {
                // Available Outfit
                const card = $(`
                    <div class="card populated" data-name="${outfit.name}">
                        <i class="fa-solid fa-shirt"></i>
                        <div class="card-text">${outfit.name}</div>
                    </div>
                `);

                card.click(function() {
                    $(".card").removeClass("selected");
                    $(this).addClass("selected");
                    selectedOutfit = outfit.name;
                    updateButtons(false);
                });
                grid.append(card);
            } else {
                // Locked Outfit (Over Limit)
                const card = $(`
                    <div class="card populated" data-name="${outfit.name}" style="opacity: 0.6; border: 1px solid #ff4444;">
                        <i class="fa-solid fa-lock"></i>
                        <div class="card-text">${outfit.name}</div>
                    </div>
                `);

                card.click(function() {
                    $(".card").removeClass("selected");
                    $(this).addClass("selected");
                    selectedOutfit = outfit.name;
                    updateButtons(true);
                });
                grid.append(card);
            }
        } else if (i < maxSlots) {
            // Render Empty Slot
            const newCard = $(`
                <div class="card empty" id="new-slot-${i}">
                    <i class="fa-solid fa-plus"></i>
                    <div class="card-text">Slot Vazio</div>
                </div>
            `);
            
            newCard.click(function() {
                isEditing = false;
                $("#preset-name").val("");
                $("#name-modal").fadeIn();
            });
            
            grid.append(newCard);
        } else {
            // Render Locked Slot
            const lockedCard = $(`
                <div class="card empty" style="opacity: 0.5; cursor: default;">
                    <i class="fa-solid fa-lock"></i>
                    <div class="card-text">Bloqueado</div>
                </div>
            `);
            grid.append(lockedCard);
        }
    }
}

function updateButtons(isLocked = false) {
    if (selectedOutfit) {
        $("#delete-btn").prop("disabled", false);
        
        if (isLocked) {
            $("#equip-btn").prop("disabled", true);
            $("#edit-btn").prop("disabled", true);
        } else {
            $("#equip-btn").prop("disabled", false);
            $("#edit-btn").prop("disabled", false);
        }
    } else {
        $("#equip-btn").prop("disabled", true);
        $("#edit-btn").prop("disabled", true);
        $("#delete-btn").prop("disabled", true);
    }
}
