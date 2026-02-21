// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	var item = event.data;
	switch (item.Action){
		case "Display":
			if (item.Mode === "block") {
				$("#deathDiv").fadeIn(500);
			} else {
				$("#deathDiv").fadeOut(500);
			}
		break;

		case "Update":
			// Timer logic
			var timer = item.Timer;
			
			if (timer > 0) {
				$("#timer-text").html(`Aguarde <span id="seconds">${timer}</span> segundos para retornar ao hospital.`);
			} else {
				if (item.Message) {
					$("#timer-text").html(item.Message);
				} else {
					$("#timer-text").html(`Pressione <color>E</color> para renascer.`);
				}
			}
		break;

		case "Message": // Backward compatibility
			$("#timer-text").html(item.Message);
		break;
	}
});
