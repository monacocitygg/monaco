$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				requestChest();
				$(".inventory").css("display","flex");
			break;

			case "hideMenu":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "requestChest":
				requestChest();
			break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://inspect/invClose");
			$(".invRight").html("");
			$(".invLeft").html("");
			$(".invHotbar").html("");
		}
	};

	$('body').mousedown(e => {
		if(e.button == 1) return false;
	});
});

const updateDrag = () => {
	// Try to destroy existing instances to prevent conflicts
	try { $(".populated").draggable("destroy"); } catch(e){}
	try { $(".empty").droppable("destroy"); } catch(e){}
	try { $(".populated").droppable("destroy"); } catch(e){}

	$(".populated").draggable({
		helper: "clone",
        appendTo: "body",
        scroll: false,
        revert: "invalid", 
        start: function(event, ui) {
            $(this).css("opacity", 0.5);
        },
        stop: function(event, ui) {
            $(this).css("opacity", 1.0);
        }
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

            console.log("DEBUG JS updateDrag: itemData", JSON.stringify(itemData));
            console.log("DEBUG JS updateDrag: target", target);

			if (itemData.key === undefined || target === undefined) {
                console.log("DEBUG JS updateDrag: Missing itemData.key or target");
                return;
            }

			if (tInv === "invLeft" || tInv === "invHotbar") {
				if (["4", "5"].includes(String(target)) && !window.myHasBolso) return;
				if (parseInt(target) > 17 && !window.myHasVip && !(window.myHasSerendibite && parseInt(target) <= 21) && !(window.myHasPainite && parseInt(target) <= 25)) return;
			}

			if (tInv === "invRight") {
				if (["4", "5"].includes(String(target)) && !window.tHasBolso) return;
				if (parseInt(target) > 17 && !window.tHasVip && !(window.tHasSerendibite && parseInt(target) <= 21) && !(window.tHasPainite && parseInt(target) <= 25)) return;
			}

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			// Clean up previous instances to prevent memory leaks and double-binding
			try { $(".populated").draggable("destroy"); } catch(e){}
			try { $(".empty").droppable("destroy"); } catch(e){}
			try { $(".populated").droppable("destroy"); } catch(e){}

			// Logic for updating UI immediately (optimistic update)
			if(amount == itemAmount){
                // Moving full stack
                if (ui.draggable.parent()[0] == $(this).parent()[0]) {
                    // Same inventory: swap
                    let clone1 = ui.draggable.clone();
                    let clone2 = $(this).clone();
                    
                    let slot1 = ui.draggable.data("slot");
                    let slot2 = $(this).data("slot");

                    ui.draggable.replaceWith(clone2);
                    $(this).replaceWith(clone1);
                    
                    $(clone1).data("slot", slot2);
                    $(clone2).data("slot", slot1);
                }
			}
            
            // Re-init drag to capture new elements
			updateDrag();

            const isOriginInventory = origin.includes("invLeft") || origin.includes("invHotbar");
			const isTargetInventory = tInv.includes("invLeft") || tInv.includes("invHotbar");
			const isOriginChest = origin.includes("invRight");
			const isTargetChest = tInv.includes("invRight");

			if (isOriginInventory && isTargetInventory){
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginChest && isTargetInventory){
				$.post("http://inspect/takeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginInventory && isTargetChest){
				$.post("http://inspect/storeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginChest && isTargetChest){
				$.post("http://inspect/updateChest",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			}

			$(".amount").val("");
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

            console.log("DEBUG JS updateDrag (populated): itemData", JSON.stringify(itemData));
            console.log("DEBUG JS updateDrag (populated): target", target);

			if (itemData.key === undefined || target === undefined) {
                console.log("DEBUG JS updateDrag (populated): Missing itemData.key or target");
                return;
            }

			if (tInv === "invLeft" || tInv === "invHotbar") {
				if (["4", "5"].includes(String(target)) && !window.myHasBolso) return;
				if (parseInt(target) > 17 && !window.myHasVip && !(window.myHasSerendibite && parseInt(target) <= 21) && !(window.myHasPainite && parseInt(target) <= 25)) return;
			}

			if (tInv === "invRight") {
				if (["4", "5"].includes(String(target)) && !window.tHasBolso) return;
				if (parseInt(target) > 17 && !window.tHasVip && !(window.tHasSerendibite && parseInt(target) <= 21) && !(window.tHasPainite && parseInt(target) <= 25)) return;
			}

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if (shiftPressed)
				amount = itemAmount;
			else if($(".amount").val() == "" | parseInt($(".amount").val()) <= 0)
				amount = 1;
			else
				amount = parseInt($(".amount").val());

			if(amount > itemAmount)
				amount = itemAmount;

			// Clean up previous instances
			try { $(".populated").draggable("destroy"); } catch(e){}
			try { $(".empty").droppable("destroy"); } catch(e){}
			try { $(".populated").droppable("destroy"); } catch(e){}

			if(ui.draggable.data('item-key') == $(this).data('item-key')){
				let newSlotAmount = amount + parseInt($(this).data('amount'));
				let newSlotWeight = ui.draggable.data("peso") * newSlotAmount;

				$(this).data('amount',newSlotAmount);
				$(this).children(".itemAmount").html("x" + formatarNumero(newSlotAmount));

				if(amount == itemAmount) {
					ui.draggable.replaceWith(`<div class="item empty" data-slot="${ui.draggable.data('slot')}"></div>`);
				} else {
					let newMovedAmount = itemAmount - amount;
					let newMovedWeight = parseFloat(ui.draggable.data("peso")) * newMovedAmount;

					ui.draggable.data('amount',newMovedAmount);
					ui.draggable.children(".itemAmount").html("x" + formatarNumero(newMovedAmount));
				}
			} else {
				if (origin === "invRight" && (tInv === "invLeft" || tInv === "invHotbar")) return;

				let clone1 = ui.draggable.clone();
				let clone2 = $(this).clone();

				let slot1 = ui.draggable.data("slot");
				let slot2 = $(this).data("slot");

				ui.draggable.replaceWith(clone2);
				$(this).replaceWith(clone1);

				$(clone1).data("slot",slot2);
				$(clone2).data("slot",slot1);
			}

			// Re-init drag to capture new elements
			updateDrag();

            const isOriginInventory = origin.includes("invLeft") || origin.includes("invHotbar");
			const isTargetInventory = tInv.includes("invLeft") || tInv.includes("invHotbar");
			const isOriginChest = origin.includes("invRight");
			const isTargetChest = tInv.includes("invRight");

			if (isOriginInventory && isTargetInventory){
				$.post("http://inventory/updateSlot",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginChest && isTargetInventory){
				$.post("http://inspect/takeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginInventory && isTargetChest){
				$.post("http://inspect/storeItem",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			} else if (isOriginChest && isTargetChest){
				$.post("http://inspect/updateChest",JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}), (data) => { requestChest(); }); 
			}

			$(".amount").val("");
		}
	});

	$(".populated").tooltip({
		create: function(event,ui){
			var max = $(this).attr("data-max");
			var name = $(this).attr("data-name-key");
			var economy = $(this).attr("data-economy");
			var description = $(this).attr("data-description");

			$(this).tooltip({
				content: `<item>${name}</item>${description !== "false" ? "<br><description>"+description+"</description>":""}<br><legenda>Economia: <r>$${economy}</r> <s>|</s> Máximo: <r>${max !== "false" ? max:"S/L"}</r></legenda>`,
				position: { my: "center top+10", at: "center bottom", collision: "flipfit" },
				show: { duration: 10 },
				hide: { duration: 10 }
			});
		}
	});
}

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

const requestChest = () => {
	$.post("http://inspect/requestChest",JSON.stringify({}),(data) => {
		window.myHasBolso = data.myHasBolso;
		window.myHasVip = data.myHasVip;
		window.tHasBolso = data.tHasBolso;
		window.tHasVip = data.tHasVip;
		window.myHasSerendibite = data.myHasSerendibite;
		window.myHasPainite = data.myHasPainite;
		window.tHasSerendibite = data.tHasSerendibite;
		window.tHasPainite = data.tHasPainite;

		if (window.myHasBolso) {
			$(".invHotbar").addClass("has-bolso");
		} else {
			$(".invHotbar").removeClass("has-bolso");
		}

		if (window.myHasVip) {
			$(".invLeft").addClass("has-vip");
		} else {
			$(".invLeft").removeClass("has-vip");
		}
		if (window.myHasPainite) {
			$(".invLeft").addClass("has-painite").removeClass("has-serendibite");
		} else if (window.myHasSerendibite) {
			$(".invLeft").addClass("has-serendibite").removeClass("has-painite");
		} else {
			$(".invLeft").removeClass("has-serendibite has-painite");
		}

		if (window.tHasVip) {
			$(".invRight").addClass("has-vip");
		} else {
			$(".invRight").removeClass("has-vip");
		}
		if (window.tHasPainite) {
			$(".invRight").addClass("has-painite").removeClass("has-serendibite");
		} else if (window.tHasSerendibite) {
			$(".invRight").addClass("has-serendibite").removeClass("has-painite");
		} else {
			$(".invRight").removeClass("has-serendibite has-painite");
		}

		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}   /   ${(data["invMaxpeso"]).toFixed(2)}`);
		$("#weightTextRight").html(`${(data["chestPeso"]).toFixed(2)}   /   ${(data["chestMaxpeso"]).toFixed(2)}`);

		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);
		$("#weightBarRight").html(`<div id="weightContent" style="width: ${data["chestPeso"] / data["chestMaxpeso"] * 100}%"></div>`);

		$(".invLeft").html("");
		$(".invRight").html("");
		$(".invHotbar").html("");

		if (data["invMaxpeso"] > 100)
			data["invMaxpeso"] = 100;

		let loopMax = 37;
		if (data["invMaxpeso"] > loopMax)
			data["invMaxpeso"] = loopMax;

		for (let x = 1; x <= loopMax; x++){
			const slot = x.toString();

			if (data.myInventory[slot] !== undefined){
				const v = data.myInventory[slot];
				var maxDurability = 86400 * v["days"];
				var newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (v["charges"] !== undefined)
					actualPercent = v["charges"];

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-economy="${v["economy"]}" data-description="${v["desc"]}" data-amount="${v.amount}" data-peso="${v.peso}" data-item-key="${v.key}" data-name-key="${v.name}" data-slot="${slot}">
					<div class="nameItem">${v.name}</div>
					<div class="itemAmount">x${formatarNumero(v.amount)}</div>
					
					<div class="item-image" style="background-image: url('nui://inventory/web-side/images/${v.index}.png');"></div>

					<div class="durability" style="background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
				</div>`;

				if (x <= 5) {
					$(".invHotbar").append(item);
				} else {
					$(".invLeft").append(item);
				}
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				if (x <= 5) {
					$(".invHotbar").append(item);
				} else {
					$(".invLeft").append(item);
				}
			}
		}

		let loopMaxChest = 37;
		if (data["chestMaxpeso"] > loopMaxChest)
			data["chestMaxpeso"] = loopMaxChest;

		for (let x = 1; x <= loopMaxChest; x++){
			const slot = x.toString();

			if (data.myChest[slot] !== undefined){
				const v = data.myChest[slot];
				var maxDurability = 86400 * v["days"];
				var newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (v["charges"] !== undefined)
					actualPercent = v["charges"];

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-economy="${v["economy"]}" data-description="${v["desc"]}" data-amount="${v.amount}" data-peso="${v.peso}" data-item-key="${v.key}" data-name-key="${v.name}" data-slot="${slot}">
					<div class="nameItem">${v.name}</div>
					<div class="itemAmount">x${formatarNumero(v.amount)}</div>
					
					<div class="item-image" style="background-image: url('nui://inventory/web-side/images/${v.index}.png');"></div>

					<div class="durability" style="background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}

		if (!window.myHasVip) {
			$(".invLeft").append(`
				<div class="vip-tooltip">
					<div class="tooltip-icon">
						<i class="fa-solid fa-lock"></i>
					</div>
					<div class="tooltip-title">Libere mais slots!</div>
					<div class="tooltip-desc">
						Adquira um pacote <b>VIP</b> e libere<br>
						mais slots no seu inventário!
					</div>
				</div>
			`);
		}

		updateDrag();
	});
}

const formatarNumero = n => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
