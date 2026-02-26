// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Radio":
			if (event["data"]["Show"] == true){
					if (event["data"]["Permission"]){
					$(".frequency-item").show();
				} else {
					$(".frequency-item").hide();
					$(".frequency-item").eq(0).show();
				}

				// Atualizar toggle de prop
				if (typeof event["data"]["UseProp"] !== "undefined") {
					$("#propToggle").prop("checked", event["data"]["UseProp"]);
				}

				if (event["data"]["Animations"]) {
				var $grid = $("#animationGrid");
				$grid.empty();
				var currentAnim = event["data"]["CurrentAnim"] || "none";
				$.each(event["data"]["Animations"], function(i, anim) {
					var selectedClass = (anim.id === currentAnim) ? " selected" : "";
					var imgSrc = anim.image ? "images/" + anim.image : "images/Radio.png";
					$grid.append(
						'<div class="anim-grid-item' + selectedClass + '" data-anim="' + anim.id + '">' +
						'<img src="' + imgSrc + '" alt="' + anim.label + '">' +
						'<div class="anim-grid-label">' + anim.label + '</div>' +
						'</div>'
					);
				});
			}

				if ($("#Radio").css("display") === "none"){
					$("#Radio").fadeIn(300);
				}
			} else {
				if ($("#Radio").css("display") !== "none"){
					$("#Radio").fadeOut(300);
				}
			}
		break;

		case "Frequency":
			// Update UI if needed when frequency changes from server
            // For now, we rely on user input
		break;
	}
});
// -------------------------------------------------------------------------------------------
$(document).ready(function(){
	document.onkeyup = function(event){
		switch (event["key"]){
			case "Escape":
				if ($("#animOverlay").css("display") !== "none"){
					$("#animOverlay").fadeOut(300);
				} else if ($("#Radio").css("display") !== "none"){
					$("#Radio").fadeOut(300);
					$.post("http://radio/RadioClose");
				}
			break;
		}
	}

    // Input Enter Key
    $(".frequency-input").on("keyup", function(e) {
        if (e.key === "Enter") {
            var Frequency = $(this).val();
            if (Frequency && Frequency.trim().length > 0 && Frequency.trim().length <= 5) {
                $.post("http://radio/RadioActive", JSON.stringify({ Frequency: Frequency.trim() }));
                $(this).blur();
                
                // Reset other items
                $(".frequency-item").removeClass("connected");
                $(".action-btn").removeClass("mdi-radio-tower").addClass("mdi-microphone");
                
                // Update this item
                var $parent = $(this).parent();
                $parent.addClass("connected");
                $parent.find(".action-btn").removeClass("mdi-microphone").addClass("mdi-radio-tower");
            }
        }
    });

    // Microphone/Action Button Click
    $(".action-btn").on("click", function() {
        var $parent = $(this).parent();
        var $input = $parent.find("input");
        
        if ($parent.hasClass("connected")) {
            // Disconnect
            $.post("http://radio/RadioInative");
            $parent.removeClass("connected");
            $(this).removeClass("mdi-radio-tower").addClass("mdi-microphone");
            $input.val("");
        } else {
            // Connect
            var Frequency = $input.val();
            if (Frequency && Frequency.trim().length > 0 && Frequency.trim().length <= 5) {
                $.post("http://radio/RadioActive", JSON.stringify({ Frequency: Frequency.trim() }));
                
                // Reset others
                $(".frequency-item").removeClass("connected");
                $(".action-btn").removeClass("mdi-radio-tower").addClass("mdi-microphone");
                
                // Set connected
                $parent.addClass("connected");
                $(this).removeClass("mdi-microphone").addClass("mdi-radio-tower");
            }
        }
    });

    // Open Animation Popup
    $("#openAnimPopup").on("click", function() {
        $("#animOverlay").fadeIn(300);
    });

    // Close Animation Popup
    $("#closeAnimPopup").on("click", function() {
        $("#animOverlay").fadeOut(300);
    });

    // Close popup when clicking overlay background
    $("#animOverlay").on("click", function(e) {
        if ($(e.target).is("#animOverlay")) {
            $("#animOverlay").fadeOut(300);
        }
    });

    // Animation Grid Item Selection (event delegation for dynamic elements)
    $("#animationGrid").on("click", ".anim-grid-item", function() {
        $(".anim-grid-item").removeClass("selected");
        $(this).addClass("selected");
        var anim = $(this).data("anim");
        $.post("http://radio/RadioAnimation", JSON.stringify({ Animation: anim }));
        setTimeout(function() {
            $("#animOverlay").fadeOut(300);
        }, 200);
    });

    // Prop Toggle
    $("#propToggle").on("change", function() {
        var useProp = $(this).is(":checked");
        $.post("http://radio/RadioProp", JSON.stringify({ UseProp: useProp }));
    });

    // Volume Slider
    $(".volume-slider").on("input", function() {
        var vol = $(this).val();
        $(".volume-text").text(vol + "%");
    });

    $(".volume-slider").on("change", function() {
        var vol = $(this).val();
        $.post("http://radio/RadioVolume", JSON.stringify({ Volume: parseInt(vol) }));
    });

    // Header Microphone Click
    $(".header-icons .icon-box i.mdi-microphone").parent().on("click", function() {
        var $firstItem = $(".frequency-item").first();
        var $input = $firstItem.find(".frequency-input");
        var Frequency = $input.val();

        if (Frequency && Frequency.trim().length > 0 && Frequency.trim().length <= 5) {
            $.post("http://radio/RadioActive", JSON.stringify({ Frequency: Frequency.trim() }));
            
            $(".frequency-item").removeClass("connected");
            $(".action-btn").removeClass("mdi-radio-tower").addClass("mdi-microphone");
            
            $firstItem.addClass("connected");
            $firstItem.find(".action-btn").removeClass("mdi-microphone").addClass("mdi-radio-tower");
        }
    });
});
