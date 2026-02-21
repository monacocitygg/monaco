$(document).ready(function(){
	window.addEventListener("message",function(event){
		var modeClass = "remove";
		var modeSymbol = "-";

		if (event.data.mode.includes("+") || event.data.mode.toLowerCase().includes("recebido")) {
			modeClass = "add";
			modeSymbol = "+";
		}

		var html = `<div class="item" style="background-image: url('nui://vrp/config/inventory/${event.data.item}.png');">
			<div class="itemAmount">x${event.data.amount}</div>
			<div class="itemMode ${modeClass}">${modeSymbol}</div>
			<div class="nameItem">${event.data.name}</div>
		</div>`;

		$(html).fadeIn(500).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});
