$(document).ready(function(){
	window.addEventListener("message", function(event){
		if (event["data"]["notify"] !== undefined){
			var data = event.data;
			var type = data.css;
			var title = "NOTIFICAÇÃO";
			var icon = "fa-solid fa-bell";
			var cssClass = "info";

			// Mapeamento de Tipos
			if (type === "sucesso" || type === "verde") {
				title = "SUCESSO";
				icon = "fa-solid fa-check";
				cssClass = "sucesso";
			} else if (type === "negado" || type === "vermelho" || type === "importante" || type === "erro") {
				title = "DEU ERRO"; // Mantendo o título solicitado anteriormente
				icon = "fa-solid fa-xmark";
				cssClass = "negado";
			} else if (type === "policia" || type === "police") {
				title = "POLICIA MILITAR";
				icon = "images/PM.png";
				cssClass = "policia";
			} else if (type === "ilegal" || type === "illegal") {
				title = "ATIVIDADE ILEGAL";
				icon = "fa-solid fa-mask"; // Ícone de criminoso
				cssClass = "ilegal";
			} else if (type === "aviso" || type === "alert") {
				title = "NOVIDADE"; // Exemplo da imagem, ou IMPORTANTE
				icon = "fa-solid fa-bell";
				cssClass = "aviso"; // Roxo/Aviso
			} else if (type === "info") {
				title = "INFORMAÇÃO";
				icon = "fa-solid fa-info";
				cssClass = "info";
			}

			var iconHtml = `<i class="${icon}"></i>`;
			if (icon.indexOf('.') > -1 || icon.indexOf('/') > -1) {
				iconHtml = `<img src="${icon}" style="width: 100%; height: 100%; object-fit: contain;">`;
			}

			var html = `
				<div class="notification ${cssClass}">
					<div class="notify-icon-box">
						${iconHtml}
					</div>
					<div class="notify-content">
						<div class="notify-title">${title}</div>
						<div class="notify-message">${data.mensagem}</div>
					</div>
                    <div class="notify-timer-circle">
                        <svg viewBox="0 0 36 36">
                            <path class="circle-bg"
                                d="M18 2.0845
                                a 15.9155 15.9155 0 0 1 0 31.831
                                a 15.9155 15.9155 0 0 1 0 -31.831"
                            />
                            <path class="circle-progress"
                                stroke-dasharray="100, 100"
                                d="M18 2.0845
                                a 15.9155 15.9155 0 0 1 0 31.831
                                a 15.9155 15.9155 0 0 1 0 -31.831"
                            />
                        </svg>
                    </div>
				</div>
			`;

			var $notification = $(html);

			if (type === "policia" || type === "police") {
				$("#notifications-police").append($notification);
			} else {
				$("#notifications").append($notification);
			}

			$notification.hide().fadeIn(400);
            var duration = data.timer || 5000;

            // Animação do Timer Circular (Stroke Dashoffset)
            // 100 é o perímetro total definido no stroke-dasharray
            // Vamos animar de 0 (cheio) até 100 (vazio) ou vice-versa.
            // Na imagem parece ir esvaziando ou enchendo. Vamos fazer esvaziando (progress bar).
            
            var $circle = $notification.find('.circle-progress');
            
            // Force reflow
            $circle[0].getBoundingClientRect();

            // Animate using CSS transition
            $circle.css({
                'transition': `stroke-dashoffset ${duration}ms linear`,
                'stroke-dashoffset': '100'
            });

			setTimeout(function(){
				$notification.fadeOut(500, function(){
					$(this).remove();
				});
			}, duration);
		}
	});
});
