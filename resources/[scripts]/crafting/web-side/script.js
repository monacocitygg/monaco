
var selectType = "";
var selectedRecipe = null;
var playerInventory = {};

$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showNUI":
				selectType = event.data.name;
				$(".inventory").css("display", "flex").css("opacity", 0).animate({ opacity: 1 }, 400);
				requestCrafting();
			break;

			case "hideNUI":
				$(".inventory").animate({ opacity: 0 }, 400, function(){
                    $(this).css("display", "none");
                });
				$(".ui-tooltip").hide();
			break;

			case "updateCrafting":
				requestCrafting();
			break;

            case "progress":
                var time = event.data.time * 1000;
                $(".progress-container").fadeIn();
                $(".progress-fill").css("width", "0%");
                $(".progress-fill").animate({ width: "100%" }, time, "linear", function(){
                    $(".progress-container").fadeOut();
                });
            break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://crafting/close");
            $(".inventory").fadeOut();
		}
	}

    // Amount input change
    $(".amount").on("input", function() {
        if (selectedRecipe) {
            updateRequirements(selectedRecipe);
        }
    });

    // Quantity Buttons
    $(".minus").click(function(){
        let val = parseInt($(".amount").val());
        if(isNaN(val)) val = 1;
        if(val > 1) {
            $(".amount").val(val - 1);
            if (selectedRecipe) updateRequirements(selectedRecipe);
        }
    });

    $(".plus").click(function(){
        let val = parseInt($(".amount").val());
        if(isNaN(val)) val = 1;
        $(".amount").val(val + 1);
        if (selectedRecipe) updateRequirements(selectedRecipe);
    });

    // Craft button click
    $("#craft-btn").click(function() {
        if (!selectedRecipe) return;
        
        let amount = parseInt($(".amount").val());
        if (isNaN(amount) || amount <= 0) amount = 1;

        $.post("http://crafting/functionCraft", JSON.stringify({
            craftType: selectType,
            item: selectedRecipe.key,
            amount: amount
        }));
    });
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const requestCrafting = () => {
	$.post("http://crafting/requestCrafting", JSON.stringify({ craftType: selectType }), (data) => {
        playerInventory = data.inventoryUser;
        
        // Update Weight
		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)} / ${(data["invMaxpeso"]).toFixed(2)}`);
		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);

        // Clear List
		$(".recipe-list").html("");

        // Populate Recipes
        if (data.recipes) {
            const recipes = data.recipes.sort((a,b) => (a.name > b.name) ? 1: -1);
            
            recipes.forEach(recipe => {
                const item = `<div class="item populated recipe-item" onclick="selectRecipe(this)" 
                    data-key="${recipe.key}" 
                    data-name="${recipe.name}" 
                    data-index="${recipe.index}"
                    data-requirements='${JSON.stringify(recipe.required)}'
                    data-amount="${recipe.amount}"
                    data-time="${recipe.time}"
                    data-name-key="${recipe.name}" data-description="${recipe.desc}" title=""
                    style="background-image: url('nui://inventory/web-side/images/${recipe.index}.png');">
                    <div class="nameItem">${recipe.name}</div>
                </div>`;
                
                $(".recipe-list").append(item);
            });

            // Custom Tooltip Logic
            $(".populated").off("mouseenter mouseleave mousemove");
            $(".populated").on("mouseenter", function(e){
                var name = $(this).attr("data-name-key");
                var description = $(this).attr("data-description");

                if (description === "undefined" || description === "false" || !description)
                    description = "";

                var tooltipHtml = `<div class="tooltip-name">${name}</div>${description !== "" ? "<div class='tooltip-desc'>"+description+"</div>":""}<div class="tooltip-info"></div>`;
                
                $(".ui-tooltip").html(tooltipHtml).css("display", "block");
            });

            $(".populated").on("mouseleave", function(){
                $(".ui-tooltip").css("display", "none");
            });

            $(".populated").on("mousemove", function(e){
                $(".ui-tooltip").css({
                    top: e.pageY + 10,
                    left: e.pageX + 10
                });
            });
        }
        
        // Re-select recipe if one was selected
        if (selectedRecipe) {
             updateRequirements(selectedRecipe);
        }
	});
}

const selectRecipe = (element) => {
    const el = $(element);
    
    // Visual selection
    $(".recipe-item").removeClass("active");
    el.addClass("active");

    selectedRecipe = {
        key: el.data("key"),
        name: el.data("name"),
        index: el.data("index"),
        required: el.data("requirements"),
        amount: el.data("amount"),
        time: el.data("time"),
        desc: el.data("description")
    };

    // Update Details View
    $(".selected-image").css("background-image", `url('nui://inventory/web-side/images/${selectedRecipe.index}.png')`);
    $(".selected-name").html(selectedRecipe.name);
    $(".selected-desc").html(selectedRecipe.desc || "");

    updateRequirements(selectedRecipe);
}

const updateRequirements = (recipe) => {
    let craftAmount = parseInt($(".amount").val());
    if (isNaN(craftAmount) || craftAmount <= 0) craftAmount = 1;

    $(".requirements-list").html("");

	recipe.required.forEach(req => {
		const totalRequired = req.amount * craftAmount;
		const hasItem = checkPlayerHasItem(req.key, totalRequired);
		
		const reqElement = `
			<div class="requirement-item ${hasItem ? 'has-enough' : 'not-enough'}">
				<div class="req-image" style="background-image: url('nui://inventory/web-side/images/${req.index}.png');"></div>
				<div class="req-info">
					<span class="req-name">${req.name}</span>
					<span class="req-amount">${totalRequired}</span>
				</div>
				<div class="req-status">
					<i class="fa-solid ${hasItem ? 'fa-check' : 'fa-xmark'}"></i>
				</div>
			</div>
		`;
		$(".requirements-list").append(reqElement);
	});
}

const checkPlayerHasItem = (itemKey, amountRequired) => {
    let totalInInventory = 0;
    // playerInventory is an object with slots as keys
    for (const key in playerInventory) {
        const item = playerInventory[key];
        if (item.item === itemKey) { // item.item is the spawn name in vRP inventory structure usually
             totalInInventory += item.amount;
        } else if (item.key === itemKey) { // Fallback if structure is different
             totalInInventory += item.amount;
        }
    }
    return totalInInventory >= amountRequired;
}
