$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "openNUI":
				updateGarages();
				$("body").fadeIn();
			break;

			case "closeNUI":
				$("body").fadeOut();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://garages/close");
		}
	};
});
/* --------------------------------------------------- */
const updateGarages = () => {
	$.post("http://garages/myVehicles",JSON.stringify({}),(data) => {
		const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
		$("#displayHud").html(`
			${nameList.map((item) => (`
				<div class="vehicle-item" data-name="${item.Model}">
					<div class="item-left">
						<div class="item-info">
							<h3 class="vehicle-name">${item.name}</h3>
							<p class="vehicle-plate">${item.plate}</p>
						</div>
						<div class="item-stats">
							<div class="stat-box">
								<i class="fa-solid fa-gas-pump"></i>
								<span>${item.fuel}%</span>
							</div>
							<div class="stat-box">
								<i class="fa-solid fa-cogs"></i>
								<span>${Math.floor(item.engine / 10)}%</span>
							</div>
							<div class="stat-box">
								<i class="fa-solid fa-car-side"></i>
								<span>${Math.floor(item.body / 10)}%</span>
							</div>
						</div>
					</div>
					<div class="item-right">
						<img src="./vehicles/${item.Model}.png" alt="${item.name}" onerror="this.onerror=null;this.src='./vehicles/default.png';">
					</div>
				</div>
			`)).join("")}
		`);
	});
}
/* --------------------------------------------------- */
$(document).on("click",".vehicle-item",function(){
	let $el = $(this);
	let isActive = $el.hasClass("active");
	$(".vehicle-item").removeClass("active");
	if(!isActive) $el.addClass("active");
});
/* --------------------------------------------------- */
$(document).on("click","#spawnVehicle",debounce(function(){
	let $el = $(".vehicle-item.active").attr("data-name");
	if($el){
		$.post("http://garages/spawnVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#taxVehicle",debounce(function(){
	let $el = $(".vehicle-item.active").attr("data-name");
	if($el){
		$.post("http://garages/taxVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#sellVehicle",debounce(function(){
	let $el = $(".vehicle-item.active").attr("data-name");
	if($el){
		$.post("http://garages/sellVehicles",JSON.stringify({ name: $el }));
	}
}));
/* --------------------------------------------------- */
$(document).on("click","#storeVehicle",function(){
	$.post("http://garages/deleteVehicles");
});

$(document).on("click","#storeSpecific",function(){
	$.post("http://garages/deleteVehicles");
});

/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}
