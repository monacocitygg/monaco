$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "showMenu":
				Backpack();
				$(".inventory").css("display","flex");
				// Initialize Inventory State
				$(".nav-item[data-tab='inventory']").hide();
				$(".nav-item[data-tab='skins']").show();
				$(".middle-col").show();
				$(".inventory-grid-container").show();
				$(".header").show();
				$(".skins-wrapper").hide();
			break;

			case "hideMenu":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
				$(".ui-tooltip").remove();
				
				// Reset Inventory State on Close
				$(".inventory-grid-container").show();
				$(".skins-container").hide();
				$(".middle-col").show();
				$(".header-info").show();
				$(".right-col").show();
				$(".inventory").css("align-items", "center");
				$(".inventory").css("padding-left", "0");
				$(".left-col").css("width", "auto");
			break;

			case "Backpack":
				Backpack();
			break;
		}
	});



	// Initialize Default State (Inventory Active)
	// We trigger click on load to set initial state correctly? 
	// Or we just set the initial CSS state. Let's do it via CSS or JS init.
	// But since this runs on document ready, we can just force the state.
	
	$(document).on("keyup", data => {
		if (data["key"] === "Escape"){
			$.post("http://inventory/invClose");
			$(".invRight").html("");
			$(".invLeft").html("");
		}
	});


	$("#openSkins").click(function(){
		if($(".inventory-grid-container").is(":visible")){
			$(".inventory-grid-container").hide();
			$(".skins-container").css("display", "grid");
			$(".middle-col").hide();
			$(".header-info").hide();
			$(".right-col").hide();
			
			// Align to left and expand width
			$(".inventory").css("align-items", "flex-start");
			$(".inventory").css("padding-left", "5rem");
			$(".left-col").css("width", "75vw"); // Expand column width
			
			loadSkins();
		} else {
			$(".inventory-grid-container").show();
			$(".skins-container").hide();
			$(".middle-col").show();
			$(".header-info").show();
			$(".right-col").show();
			
			// Reset alignment and width
			$(".inventory").css("align-items", "center");
			$(".inventory").css("padding-left", "0");
			$(".left-col").css("width", "auto"); // Reset column width
		}
	});
});

const loadSkins = () => {
	$.post("http://inventory/requestSkins",JSON.stringify({}),(data) => {
		$(".skins-container").html("");

		// Add Remove Skin Button
		$(".skins-container").append(`
			<div class="skin-card remove-skin" style="border: 1px dashed #ff5555;">
				<div class="skin-image" style="display: flex; justify-content: center; align-items: center;">
					<i class="fa-solid fa-ban" style="font-size: 3rem; color: #ff5555;"></i>
				</div>
				<div class="skin-name" style="color: #ff5555;">Remover Skin</div>
				<div class="skin-type">Ação</div>
			</div>
		`);

		const skins = data.skins.sort((a,b) => (a.name > b.name) ? 1 : -1);

		$.each(skins, (index, item) => {
			$(".skins-container").append(`
				<div class="skin-card" data-weapon="${item.weapon}" data-skin="${item.index}" data-type="${(item.type || 'comum').toLowerCase()}">
					<div class="skin-image" style="background-image: url('nui://inventory/web-side/images/skins/${item.image}');"></div>
					<div class="skin-name">${item.name}</div>
					<div class="skin-type">${item.type}</div>
				</div>
			`);
		});

		$(".remove-skin").click(function(){
			$.post("http://inventory/removeSkin",JSON.stringify({}));
		});

		$(".skin-card:not(.remove-skin)").click(function(){
			console.log("DEBUG: Clique no card da skin detectado");
			console.log("DEBUG: Dados enviados:", JSON.stringify({
				weapon: $(this).data("weapon"),
				skin: $(this).data("skin")
			}));
			
			$.post("http://inventory/equipSkin",JSON.stringify({
				weapon: $(this).data("weapon"),
				skin: $(this).data("skin") // Assuming index or name is used to identify
			}));
		});
	});
}

const updateDrag = () => {
	const hasBolso = window.hasBolso;
	const hasVip = window.hasVip;
	console.log(`[DEBUG] updateDrag called. hasBolso: ${hasBolso}, hasVip: ${hasVip}`);

	$(".populated").draggable({
		helper: "clone",
		appendTo: "body",
		zIndex: 100000,
		scroll: false,
		containment: ".inventory",
		distance: 0,
		revertDuration: 0,
	});

	$(".empty").droppable({
		hoverClass: "hoverControl",
		tolerance: "pointer",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			const isOriginInv = origin.includes("invLeft") || origin.includes("invHotbar");
			const isTargetInv = tInv.includes("invLeft") || tInv.includes("invHotbar");
			const isOriginChest = origin.includes("invRight");
			const isTargetChest = tInv.includes("invRight");

			if(isOriginChest && isTargetChest) return;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			// Debug info for slot restriction
			if (parseInt(target) > 17) {
				console.log(`[DEBUG] Attempting drop on Slot ${target}. Target: ${target} (${typeof target}), hasVip: ${hasVip}, tInv: ${tInv}`);
			}

			if ((parseInt(target) == 4 || parseInt(target) == 5) && !hasBolso && isTargetInv) {
				console.log(`[DEBUG] Blocked drop on Slot ${target} due to missing Bolso permissions`);
				return;
			}

			if (parseInt(target) > 17 && !hasVip && !(window.hasSerendibite && parseInt(target) <= 21) && !(window.hasPainite && parseInt(target) <= 25) && isTargetInv) {
				console.log(`[DEBUG] Blocked drop on Slot ${target} due to missing Vip permissions`);
				return;
			}

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data("amount"));

			if (event.shiftKey)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$(".populated, .empty, .use, .send, .deliver, .destroy").off("draggable droppable");

			let clone1 = ui.draggable.clone();
			let slot2 = $(this).data("slot"); 

			if(amount == itemAmount) {
				let slot1 = ui.draggable.data("slot");

				$(this).replaceWith(clone1);
				ui.draggable.replaceWith(`<div class="item empty" data-slot="${slot1}"></div>`);
				
				$(clone1).data("slot", slot2);
			} else {
				let newAmountOldItem = itemAmount - amount;
				let weight = parseFloat(ui.draggable.data("peso"));
				let newWeightClone1 = (amount*weight).toFixed(2);
				let newWeightOldItem = (newAmountOldItem*weight).toFixed(2);

				ui.draggable.data("amount",newAmountOldItem);

				clone1.data("amount",amount);

				$(this).replaceWith(clone1);
				$(clone1).data("slot",slot2);

				ui.draggable.children(".itemAmount").html("x" + formatarNumero(ui.draggable.data("amount")));
				
				$(clone1).children(".itemAmount").html("x" + formatarNumero(clone1.data("amount")));
			}

			updateDrag();

			// Handle invHotbar logic for drops too
			if (isOriginInv && isTargetInv){
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (isOriginChest && isTargetInv){
				const id = ui.draggable.data("id");
				$.post("http://inventory/pickupItem",JSON.stringify({
					id: id,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (isOriginInv && isTargetChest){
				$.post("http://inventory/dropItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					amount: parseInt(amount)
				}));
			}

			$(".amount").val("");
		}
	});

	$(".populated").droppable({
		hoverClass: "hoverControl",
		tolerance: "pointer",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			const isOriginInv = origin.includes("invLeft") || origin.includes("invHotbar");
			const isTargetInv = tInv.includes("invLeft") || tInv.includes("invHotbar");
			const isOriginChest = origin.includes("invRight");
			const isTargetChest = tInv.includes("invRight");

			if(isOriginChest && isTargetChest) return;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			if ((parseInt(target) == 4 || parseInt(target) == 5) && !hasBolso && isTargetInv) return;

			if (parseInt(target) > 17 && !hasVip && !(window.hasSerendibite && parseInt(target) <= 21) && !(window.hasPainite && parseInt(target) <= 25) && isTargetInv) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data("amount"));

			if (event.shiftKey)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			$(".populated, .empty, .use, .send, .deliver, .destroy").off("draggable droppable");

			if(ui.draggable.data("item-key") == $(this).data("item-key")){
				let newSlotAmount = amount + parseInt($(this).data("amount"));
				let newSlotWeight = ui.draggable.data("peso") * newSlotAmount;

				$(this).data("amount",newSlotAmount);
				$(this).children(".itemAmount").html("x" + formatarNumero(newSlotAmount));

				if(amount == itemAmount) {
					ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data("slot")}"></div>`);
				} else {
					let newMovedAmount = itemAmount - amount;
					let newMovedWeight = parseFloat(ui.draggable.data("peso")) * newMovedAmount;

					ui.draggable.data("amount",newMovedAmount);
					ui.draggable.children(".itemAmount").html("x" + formatarNumero(newMovedAmount));
				}
			} else {
				if (isOriginChest && isTargetInv) return;

				let clone1 = ui.draggable.clone();
				let clone2 = $(this).clone();

				let slot1 = ui.draggable.data("slot");
				let slot2 = $(this).data("slot");

				ui.draggable.replaceWith(clone2);
				$(this).replaceWith(clone1);

				$(clone1).data("slot",slot2);
				$(clone2).data("slot",slot1);
			}

			updateDrag();

			// Handle invHotbar logic for drops too
			if (isOriginInv && isTargetInv) {
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (isOriginChest && isTargetInv){
				const id = ui.draggable.data("id");
				$.post("http://inventory/pickupItem",JSON.stringify({
					id: id,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (isOriginInv && isTargetChest){
				$.post("http://inventory/dropItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					amount: parseInt(amount)
				}));
			}

			$(".amount").val("");
		}
	});

	$(".use").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "invRight") return;
			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (event.shiftKey) amount = ui.draggable.data("amount");

			$.post("http://inventory/useItem",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));

			$(".amount").val("");
		}
	});

	$(".send").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "invRight") return;
			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (event.shiftKey) amount = ui.draggable.data("amount");

			$.post("http://inventory/sendItem",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));

			$(".amount").val("");
		}
	});

	$(".deliver").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "invRight") return;
			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (event.shiftKey) amount = ui.draggable.data("amount");

			$.post("http://inventory/Deliver",JSON.stringify({
				slot: itemData.slot
			}));

			$(".amount").val("");
		}
	});
	
		$(".destroy").droppable({
		hoverClass: "hoverControl",
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === "invRight") return;
			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (event.shiftKey) amount = ui.draggable.data("amount");

			$.post("http://inventory/destroyItem",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));

			$(".amount").val("");
		}
	});
	$(".populated").tooltip({
		items: ".populated",
		position: { my: "center top+10", at: "center bottom", collision: "flipfit" },
		show: { duration: 10 },
		hide: { duration: 10 },
		content: function(){
			var element = $(this);
			var max = element.attr("data-max");
			var name = element.attr("data-name-key");
			var Vehkey = element.attr("data-Vehkey");
			var economy = element.attr("data-economy");
			var Suitcase = element.attr("data-Suitcase");
			var description = element.attr("data-description");
			var contents = `<item>${name}</item>${description !== "false" ? "<br><description>"+description+"</description>":""}${Vehkey !== "undefined" ? "<br><legenda>Placa: <r>"+ Vehkey +"</r></legenda>":""}<br><legenda>Economia: <r>$${economy}</r> <s>|</s> Máximo: <r>${max !== "false" ? max:"S/L"}</r></legenda>`;

			if (Suitcase !== "undefined"){
				contents = `<item>${name}</item><br><description>Contém <green>$${Suitcase}</green> dólares em espécie.</description>`;
			}

			if (name == "Passaporte" || name == "Distintivo"){
				var idName = element.attr("data-idName");
				var idBlood = element.attr("data-idBlood");
				var Passport = element.attr("data-Passport");
				var idVality = element.attr("data-idVality");
				var idPremium = element.attr("data-idPremium");
				var idRolepass = element.attr("data-idRolepass");

				contents = `<item>${name} - ${Passport}</item>${description !== "false" ? "<br><description>"+description+"</description>":""}<br><legenda>Nome: <r>${idName}</r><br>Tipo Sangüineo: <r>${idBlood}</r><br>Rolepass: <r>${idRolepass}</r><br>Validade: <r>${idVality}</r><br>Premium: <r>${idPremium}</r></legenda>`;
			}

			return contents;
		}
	});
}

	$(document).on("mousedown", ".populated", function(e) {
		if (e.which === 3){
			e.preventDefault();
			const item = this;
			const origin = $(item).parent()[0].className;
			
			if (origin === undefined || origin === "invRight") return;

			itemData = { key: $(item).data("item-key"), slot: $(item).data("slot") };

			if (itemData.key === undefined) return;

			let amount = $(".amount").val();
			if (e.shiftKey) amount = $(item).data("amount");

			$.post("http://inventory/useItem",JSON.stringify({
				slot: itemData.slot,
				amount: parseInt(amount)
			}));
		}
	});

	$(document).on("contextmenu", ".populated", function(e) {
		e.preventDefault();
	});

const colorPicker = (percent) => {
	var colorPercent = "#2ecc71";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#fcc458";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#fc8a58";

	if (percent <= 25)
		colorPercent = "#fc5858";

	return colorPercent;
}

const Backpack = () => {
	$.post("http://inventory/requestInventory",JSON.stringify({}),(data) => {
		const hasBolso = data["hasBolso"];
		const hasVip = data["hasVip"];
		const hasSerendibite = data["hasSerendibite"];
		const hasPainite = data["hasPainite"];
		window.hasBolso = hasBolso;
		window.hasVip = hasVip;
		window.hasSerendibite = hasSerendibite;
		window.hasPainite = hasPainite;
		
		if (hasBolso) {
			$(".invHotbar").addClass("has-bolso");
		} else {
			$(".invHotbar").removeClass("has-bolso");
		}

		if (hasVip) {
			$(".invLeft").addClass("has-vip");
		} else {
			$(".invLeft").removeClass("has-vip");
		}
		// Prioridade: Painite > Serendibite
		if (hasPainite) {
			$(".invLeft").addClass("has-painite").removeClass("has-serendibite");
		} else if (hasSerendibite) {
			$(".invLeft").addClass("has-serendibite").removeClass("has-painite");
		} else {
			$(".invLeft").removeClass("has-serendibite has-painite");
		}

		if (data["identity"]) {
			$(".left-col .player-name").html(`${data["identity"]["name"]} ${data["identity"]["name2"]}`);
			$(".left-col .player-id").html(`#${data["identity"]["passport"]}`);
		}

		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}   /   ${(data["invMaxpeso"]).toFixed(2)}`);
		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);

		// Right side weight calculation (approximate)
		let rightWeight = 0;
		const rightMaxWeight = 50; // Default placeholder
		if (data["drop"]) {
			data["drop"].forEach(item => {
				if (item["peso"] && item["amount"]) {
					rightWeight += item["peso"] * item["amount"];
				}
			});
		}
		$("#weightTextRight").html(`${rightWeight.toFixed(2)}   /   ${rightMaxWeight.toFixed(2)}`);
		$("#weightBarRight").html(`<div id="weightContent" style="width: ${(rightWeight / rightMaxWeight * 100)}%"></div>`);

		$(".invLeft").html("");
		$(".invHotbar").html("");
		$(".invRight").html("");

		if (data["invMaxpeso"] > 120)
			data["invMaxpeso"] = 120;

		const nameList2 = data["drop"].sort((a,b) => (a["name"] > b["name"]) ? 1:-1);

		let loopMax = 37;

		for (let x = 1; x <= loopMax; x++){
			const slot = x.toString();
			let lockedClass = "";
			
			if (((x === 4 || x === 5) && !hasBolso) || (x > 17 && !hasVip && !(hasSerendibite && x <= 21) && !(hasPainite && x <= 25))) {
				lockedClass = "locked";
			}

			if (data["inventario"][slot] !== undefined){
				var v = data["inventario"][slot];
				var maxDurability = 86400 * v["days"];
				var newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (v["charges"] !== undefined)
					actualPercent = v["charges"];

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated ${lockedClass}" title="" data-max="${v["max"]}" data-economy="${v["economy"]}" data-description="${v["desc"]}" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-slot="${slot}" data-idName="${v["idName"]}" data-idBlood="${v["idBlood"]}" data-idPremium="${v["idPremium"]}" data-idVality="${v["idVality"]}" data-idRolepass="${v["idRolepass"]}" data-Suitcase="${v["Suitcase"]}" data-Vehkey="${v["Vehkey"]}" data-Passport="${v["Passport"]}">
					<div class="nameItem">${v["name"]}</div>
					<div class="itemAmount">x${formatarNumero(v["amount"])}</div>
					
					<div class="item-image" style="background-image: url('images/${v["index"]}.png');"></div>

					<div class="durability" style="background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
				</div>`;

				if (x <= 5) {
					$(".invHotbar").append(item);
				} else {
					$(".invLeft").append(item);
				}
			} else {
				const item = `<div class="item empty ${lockedClass}" data-slot="${slot}"></div>`;

				if (x <= 5) {
					$(".invHotbar").append(item);
				} else {
					$(".invLeft").append(item);
				}
			}
		}

		$(".invLeft .vip-banner, .invLeft .vip-tooltip").remove();
		if (!hasVip) {
			const tooltipHtml = `
			<div class="vip-tooltip">
				<div class="tooltip-icon">
					<i class="fas fa-lock"></i>
				</div>
				<div class="tooltip-content">
					<div class="tooltip-title">Libere mais slots!</div>
					<div class="tooltip-desc">Adquira um pacote VIP e libere mais slots no seu inventário!</div>
				</div>
			</div>`;
			$(".invLeft").append(tooltipHtml);
		}

		for (let x = 1; x <= 20; x++){
			const slot = x.toString();

			if (nameList2[x - 1] !== undefined){
				var v = nameList2[x - 1];
				var maxDurability = 86400 * v["days"];
				var newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (v["charges"] !== undefined)
					actualPercent = v["charges"];

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" data-item-key="${v["key"]}" data-id="${v["id"]}" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-slot="${slot}">
					<div class="nameItem">${v["name"]}</div>
					<div class="itemAmount">x${formatarNumero(v["amount"])}</div>

					<div class="item-image" style="background-image: url('nui://inventory/web-side/images/${v["index"]}.png');"></div>

					<div class="durability" style="background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}

		updateDrag();
	});
}
/* ----------CRAFT---------- */
$(document).on("click",".craft",function(e){
	$.post("http://inventory/Craft");
});
/* ----------FORMATARNUMERO---------- */
const formatarNumero = n => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n["length"]; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
}
