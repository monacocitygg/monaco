var Voip = "Normal";
var isTalking = false;
const gears = ['R', 'N', '1', '2', '3', '4', '5', '6']
var Interval = undefined;

// Cache jQuery selectors
const $hud = $("section.hud");
const $progress = $(".progress");
const $progressText = $(".progress-text");
const $progressPercent = $(".progress-percent");
const $progressBarFill = $(".progress-bar-fill");
const $hexSvg = $(".hex-svg");
const $hexFill = $(".hex-fill");
const $weapon = $(".weapon");
const $weaponName = $(".weapon-name");
const $ammoClip = $(".ammo-clip");
const $ammoRemaining = $(".ammo-remaining");
const $wanted = $(".wanted");
const $wantedTime = $(".wanted-time");
const $reposed = $(".reposed");
const $reposedTime = $(".reposed-time");
const $radio = $('.radio');
const $tom = $(".tom");
const $voiceBars = $(".v-bar");
const $timeText = $(".time-text");
const $road = $("#road");
const $hudDirection = $(".hud-direction");
const $health = $(".Health");
const $armour = $('.Armour');
const $vest = $(".Vest");
const $thirst = $(".Thirst");
const $hunger = $(".Hunger");
const $stressContainer = $(".Stresss");
const $stress = $(".Stress");
const $staminaContainer = $(".Stamines");
const $stamina = $(".Stamine");
const $staminaRow = $(".stamina-row");
const $staminaBar = $(".stamina-bar-fill");
const $luckContainer = $(".Lucks");
const $luck = $(".Luck");
const $dexterityContainer = $(".Dexteritys");
const $dexterity = $(".Dexterity");
const $velocimeterHud = $(".velocimeterHud");
const $fuelHex = $(".FuelHex");
const $velo = $(".velo");
const $hudGear = $('.hud-gear');
const $rpmBars = $(".rpm-bars");
const $engineHex = $(".EngineHex");
const $handbrakeIcon = $(".middle-icons .handbrake");
const $seatbeltIcon = $(".middle-icons .seatbelt");
const $lockIcon = $(".middle-icons .lock");
const $engineIcon = $(".middle-icons .engine");
const $logoContainer = $("header.logo-container");
const $movieTop = $("#movieTop");
const $movieBottom = $("#movieBottom");
const $textformContainer = $("#Textform");
const $healthBar = $(".health-bar-fill");
const $armorBar = $(".armor-bar-fill");
const $directionContainer = $("#direction");
const $statusContent = $("#direction .status-content");

// DOM Elements for direct manipulation (RPM optimization)
let rpmSegmentsDOM = [];

// -------------------------------------------------------------------------------------------
function Minimal(Seconds){
	var Days = Math.floor(Seconds / 86400)
	Seconds = Seconds - Days * 86400
	var Hours = Math.floor(Seconds / 3600)
	Seconds = Seconds - Hours * 3600
	var Minutes = Math.floor(Seconds / 60)
	Seconds = Seconds - Minutes * 60

	const [D,H,M,S] = [Days,Hours,Minutes,Seconds].map(s => s.toString().padStart(2,0))

    if (Days > 0){
        return D + ":" + H
    } else if (Hours > 0){
        return H + ":" + M
    } else if (Minutes > 0){
        return M + ":" + S
    } else if (Seconds > 0){
        return "00:" + S
    }
}
// -------------------------------------------------------------------------------------------
const FormatNumber = n => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n["length"]; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
}
// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Body":
			if (event["data"]["Status"]){
				if ($hud.css("display") === "none"){
					$hud.fadeIn(0);
				}
				
				// Re-check vehicle status when showing body to ensure correct position
				if ($velocimeterHud.css("display") !== "none") {
					$directionContainer.css({ left: "auto", right: "30px" });
					$statusContent.css("align-items","flex-end").removeClass("left-side");
					$directionContainer.removeClass("left-side");
				} else {
					$directionContainer.css({ right: "auto", left: "30px" });
					$statusContent.css("align-items","flex-start").addClass("left-side");
					$directionContainer.addClass("left-side");
				}
			} else {
				if ($hud.css("display") === "flex"){
					$hud.fadeOut(0);
				}
			}
		break;

		case "Progress":
			if (Interval) {
				clearInterval(Interval);
				Interval = undefined;
			}

			$progressText.html(event["data"]["Message"] || "Espere um momento");
			$progressPercent.html("0");
			$progress.css("display","flex").removeClass("animate-out").addClass("animate-in");

			var Percentage = 0;
			var totalMs = event["data"]["Timer"] || 3000;
			var stepMs = (totalMs - 300) / 100;
			Interval = setInterval(Ticker,stepMs);

			function Ticker(){
				Percentage = Percentage + 1;

				if (Percentage >= 100){
					clearInterval(Interval);
					$progress.removeClass("animate-in").addClass("animate-out");
					setTimeout(function(){
						$progress.css("display","none").removeClass("animate-out");
					}, 350);
					Interval = undefined;
				}

				var elapsedMs = Percentage * stepMs;
				var remaining = Math.max(0, Math.ceil((totalMs - elapsedMs) / 1000));
				$progressPercent.html(remaining);

                // Sem rotação do hex e sem preenchimento descendente
			}
		break;

		case "Weapon":
			if (event["data"]["Status"]){
				if ($weapon.css("display") === "none"){
					$weapon.css("display", "flex").hide().fadeIn(1000);
				}
				$weaponName.html(event["data"]["Name"]);
				$ammoClip.html(event["data"]["Min"]);
				$ammoRemaining.html("/" + event["data"]["Max"]);
			} else {
				if ($weapon.css("display") !== "none"){
					$weapon.fadeOut(1000);
				}
			}
		break;

		case "Wanted":
			if (event["data"]["Number"] > 0){
				if ($wanted.css("display") === "none"){
					$wanted.fadeIn(1000);
				}

				$wantedTime.html(Minimal(event["data"]["Number"]));
			} else {
				if ($wanted.css("display") === "flex"){
					$wanted.fadeOut(1000);
				}
			}
		break;

		case "Reposed":
			if (event["data"]["Number"] > 0){
				if ($reposed.css("display") === "none"){
					$reposed.fadeIn(1000);
				}

				$reposedTime.html(Minimal(event["data"]["Number"]));
			} else {
				if ($reposed.css("display") === "flex"){
					$reposed.fadeOut(1000);
				}
			}
		break;

		case "Frequency":
			let freq = document.querySelector('.freq')

			if (event["data"]["Frequency"] !== "Offline" && event["data"]["Frequency"] != 0 && event["data"]["Frequency"] != undefined) {
				if ($radio.css("display") === "none") {
					$radio.css("display", "flex").hide().fadeIn(1000);
				}
				freq.innerHTML = `<span>${event["data"]["Frequency"]}</span>`
			  } else {
				$radio.fadeOut(1000);
				freq.innerHTML = ''
			  }
		break;

		case "Voip":
			if (event["data"]["Voip"] == "Offline"){
				$tom.html("Offline");
			} else {
				if (event["data"]["Voip"] !== "Online"){
					Voip = event["data"]["Voip"];
				}

				$tom.html(Voip);
                if (isTalking) updateVoiceBars(Voip);
			}
		break;

		case "Voice":
            isTalking = event["data"]["Status"];
			if (isTalking){
				updateVoiceBars(Voip);
			} else {
				$voiceBars.removeClass("active");
			}
		break;

		case "Clock":
			var Hours = event["data"]["Hours"];
			var Minutes = event["data"]["Minutes"];

			if (Hours <= 9) Hours = "0" + Hours
			if (Minutes <= 9) Minutes = "0" + Minutes

			$timeText.html(Hours + ":" + Minutes);
		break;

		case "Road":
			var Name = event["data"]["Name"];
			var Direction = event["data"]["Direction"];

			$road.html(Name + " | <b>" + Direction + "</b>");
            $hudDirection.html(Direction || "N");
		break;

		case "Health":
			$health.css("stroke-dashoffset",100 - event["data"]["Number"]);
			$healthBar.css("width", event["data"]["Number"] + "%");
		break;

		case "Armour":
			if ($armour.css("display") === "none") {
				$armour.fadeIn(1000);
			}
			if ($armorBar.parent().css("display") === "none") {
				$armorBar.parent().fadeIn(1000);
			}
			$vest.css("stroke-dashoffset",100 - event["data"]["Number"]);
			$armorBar.css("width", event["data"]["Number"] + "%");
		break;

		case "Thirst":
			$thirst.css("stroke-dashoffset",100 - event["data"]["Number"]);
		break;

		case "Hunger":
			$hunger.css("stroke-dashoffset",100 - event["data"]["Number"]);
		break;

		case "Stress":
			if (event["data"]["Number"] > 0){
				if ($stressContainer.css("display") === "none"){
					$stressContainer.fadeIn(1000);
				}

				$stress.css("stroke-dashoffset",100 - event["data"]["Number"]);
			} else {
				if ($stressContainer.css("display") === "block"){
					$stressContainer.fadeOut(1000);
				}
			}
		break;

		case "Stamine":
			if (event["data"]["Number"] < 100){
				if ($staminaRow.css("display") === "none"){
					$staminaRow.css("display", "flex").hide().fadeIn(1000);
				}
				$staminaBar.css("width", event["data"]["Number"] + "%");
			} else {
				if ($staminaRow.css("display") !== "none"){
					$staminaRow.fadeOut(1000);
				}
			}
		break;

		case "Luck":
			if (event["data"]["Number"] > 0){
				if ($luckContainer.css("display") === "none"){
					$luckContainer.fadeIn(1000);
				}

				event["data"]["Number"] = event["data"]["Number"] / 36;

				$luck.css("stroke-dashoffset",100 - event["data"]["Number"]);
			} else {
				if ($luckContainer.css("display") === "block"){
					$luckContainer.fadeOut(1000);
				}
			}
		break;

		case "Dexterity":
			if (event["data"]["Number"] > 0){
				if ($dexterityContainer.css("display") === "none"){
					$dexterityContainer.fadeIn(1000);
				}

				event["data"]["Number"] = event["data"]["Number"] / 36;

				$dexterity.css("stroke-dashoffset",100 - event["data"]["Number"]);
			} else {
				if ($dexterityContainer.css("display") === "block"){
					$dexterityContainer.fadeOut(1000);
				}
			}
		break;

		case "Vehicle":
			if (event["data"]["Status"]){
				if ($velocimeterHud.css("display") === "none"){
					$velocimeterHud.css("display", "flex").hide().fadeIn('slow')
				}
				$directionContainer.css({ left: "auto", right: "30px" });
				$statusContent.css("align-items","flex-end").removeClass("left-side");
				$directionContainer.removeClass("left-side");
			} else {
				if ($velocimeterHud.css("display") !== "none"){
					$velocimeterHud.fadeOut();
				}
				$directionContainer.css({ right: "auto", left: "30px" });
				$statusContent.css("align-items","flex-start").addClass("left-side");
				$directionContainer.addClass("left-side");
			}
		break;

		case "Fuel":
			$fuelHex.css("stroke-dashoffset", 100 - event["data"]["Number"]);
		break;

		case "Speed":
			let speed = Number(event["data"]["Number"]).toFixed(0);
			if (speed <= 9) { 
				$velo.html(`00${speed}`)
			}
			else if (speed <= 99) { 
				$velo.html(`0${speed}`)
			}
			else { 
				$velo.html(speed)
			}
		break;

		case "Rpm":
			if (event["data"]["Gear"] === 7) event["data"]["Gear"] = 0
			let gear = gears[event["data"]["Gear"]]
			$hudGear.html(gear)
            
            // Initialize RPM segments if empty
            if ($rpmBars.is(":empty")) {
                let segmentsHtml = '';
                for(let i=0; i<30; i++) {
                    segmentsHtml += '<div class="segment"></div>';
                }
                $rpmBars.append(segmentsHtml);
                // Cache DOM elements after creation
                rpmSegmentsDOM = document.querySelectorAll(".rpm-bars .segment");
            }

            let rpm = event["data"]["Number"];
            let totalSegments = 30;
            let activeSegments = Math.round((rpm / 100) * totalSegments);
            
            // Optimize loop: direct DOM manipulation instead of jQuery
            if (rpmSegmentsDOM.length > 0) {
                for (let i = 0; i < totalSegments; i++) {
                    if (i < activeSegments) {
                        rpmSegmentsDOM[i].classList.add("active");
                    } else {
                        rpmSegmentsDOM[i].classList.remove("active");
                    }
                }
            }
		break;

		case "Handbrake":
			if (event["data"]["Status"]){
				$handbrakeIcon.addClass("active");
			} else {
				$handbrakeIcon.removeClass("active");
			}
		break;

		case "Seatbelt":
			if (!event["data"]["Status"]){
				$seatbeltIcon.addClass("active");
			} else {
				$seatbeltIcon.removeClass("active");
			}
		break;

		case "Locked":
			if (event["data"]["Status"] == 'false' || event["data"]["Status"] == false){
				$lockIcon.removeClass("fa-lock active").addClass("fa-lock-open");
			} else {
				$lockIcon.removeClass("fa-lock-open").addClass("fa-lock active");
			}
		break;

		case "Engine":
            $engineHex.css("stroke-dashoffset", 100 - event["data"]["Number"]);

            $engineIcon.removeClass("active broken");

            if (event["data"]["Number"] <= 30){
                $engineIcon.addClass("broken");
            } else if (event["data"]["Running"]){
                $engineIcon.addClass("active");
            }
		break;

		case "Movie":
			if (event["data"]["Movie"] !== undefined){
				if (event["data"]["Movie"] == true){
					$logoContainer.css("display", "none")
					$movieTop.fadeIn(500);
					$movieBottom.fadeIn(500);
				} else {
					$logoContainer.css("display", "block")
					$movieTop.fadeOut(500);
					$movieBottom.fadeOut(500);
				}
				return
			}
		break;

		case "Textform":
			if (event["data"]["Mode"] === "Create"){
				var html = `<span id=Textform-${event["data"]["Number"]} class="Textform" style="left: 0; top: 0;"></span>`;
				$(html).fadeIn("normal").appendTo("#Textform");
			} else if (event["data"]["Mode"] === "Update"){
				$("#Textform-" + event["data"]["Number"]).css("left",event["data"]["x"] * 100 + "%").css("top",event["data"]["y"] * 100 + "%");
				$("#Textform-" + event["data"]["Number"]).html(event["data"]["Text"])
			} else if (event["data"]["Mode"] === "Remove"){
				$("#Textform-" + event["data"]["Number"]).fadeOut("normal",function(){ $(this).remove(); });
			}
		break;
	}

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://hud/closeSystem");
			$.post("http://hud/focusOff");
			hideAll()
		}
	};
});

function updateVoiceBars(mode) {
    $voiceBars.removeClass("active");
    var level = 2; // Default
    
    // Normalize mode string
    if (!mode) mode = "Normal";
    var m = mode.toLowerCase();
    
    if (m.includes("baixo") || m.includes("sussurrando") || m.includes("whisper")) level = 1;
    else if (m.includes("normal") || m.includes("médio") || m.includes("medio")) level = 2;
    else if (m.includes("alto") || m.includes("gritando") || m.includes("shout") || m.includes("megafone")) level = 3;
    
    for(var i=0; i<level; i++) {
        $voiceBars.eq(i).addClass("active");
    }
}
