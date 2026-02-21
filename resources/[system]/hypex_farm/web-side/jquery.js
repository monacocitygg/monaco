/* ---------------------------------------------------------------------------------------------------------------- */
var rotinha = null
$(document).ready(function(){

	window.addEventListener("message",function(event){
		switch (event.data.action){
			case "openSystem":
                $("#conteiner").css("display","block");
				requestinfos();
				carregaritens(event.data.InRoute);
				rotinha = event.data.InRoute;
			break;

			case "closeSystem":
                $("#conteiner").css("display","none");
				$("#meiobox").html('');
			break;

			case "attupar":
				$("#meiobox").html('');
				carregaritens(event.data.InRoute);
				rotinha = event.data.InRoute;
			break;
		};
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://hypex_farm/closeSystem");
		};

		if (data.which == 118 && rotinha){
			$.post("http://hypex_farm/encerrarrota");
		};
	};
});


const requestinfos = () => {
	$.post("https://hypex_farm/requestinfos",JSON.stringify({}),(data) => {
		$('#topo').html(`
    <table width="100%" border="0">
    <tbody>
    <tr>
    <th scope="col" width="64%"><h1>ROTAS</h1></th>
    <th scope="col">
    <div style="float: right">
        ${data[0] > 0 ? '<div class="circulo active"></div>':' <div class="circulo "></div>'}
        ${data[0] > 1 ? '<div class="circulo active"></div>':' <div class="circulo "></div>'}
        ${data[0] > 2 ? '<div class="circulo active"></div>':' <div class="circulo "></div>'}
		${data[0] > 3 ? '<div class="circulo active"></div>':' <div class="circulo "></div>'}
		${data[0] > 4 ? '<div class="circulo active"></div>':' <div class="circulo "></div>'}
    </div>	
        <div style="clear: both"></div>
        <span>NÍVEL</span>
    </th>
    </tr>
    </tbody>
    </table>
		`);
	});
}


const carregaritens = (InRoute) => {
	if (InRoute) {
		$("#meiobox").html(`<center>
		<img src="imagens/certo.png" class="imgcerto">
		<h1>ROTA EM PROCESSO</h1>
		<p>PARA CANCELAR É SO APERTAR F7.</p>
		</center>`);
	} else {
		$.post(`http://hypex_farm/requestitens`,JSON.stringify({}),(data) => {
			let i = 0;
			const nameList = data.listarfarms.sort((a,b) => (a.name > b.name) ? 1: -1);
			$("#meiobox").html(`
				<div id="escrita">
					<span>ESCOLHA O TIPO DE ROTA</span>
					<div class="escrita_select"  data-tipo="aleatoria">ALEATÓRIA</div>
					<div class="escrita_select active2" data-tipo="fixa">FIXA</div>	
				</div>
			<div id="farm">
				${nameList.map((item) => (`  
				<div class="btns">
					<div class="btns_foto">
					<img src="nui://inventory/web-side/images/${item.k}.png" width="120" height="120" alt=""/> 
					</div>
			
					<div class="btn_infos">
					<h1>${item.name}</h1>
					<div class="btn_play" id="${item.k}${item.Route}${item.Org}" data-farm="${item.k}" data-rota="${item.Route}" data-org="${item.Org}" data-nivel="${item.Lvl}">
						<img src="imagens/play.png" alt=""/>INICIAR
					</div>
					</div>
				</div>	
			`)).join('')}
			</div>
			`);
		});
	}
}


$(document).ready(function() {
	$(document).on("click",".escrita_select",debounce(function(e){
		$('.escrita_select').removeClass('active2');
		$(this).addClass('active2');
	}));


	$(document).on("click","#box2",debounce(function(e){
		$.post("http://hypex_farm/upar",JSON.stringify({}));
	}));

	$(document).on("click",".btn_play",function(e){
		
		var farmar =   $(this).data('farm');
		var tipo = $('.escrita_select.active2').data('tipo') || 'fixa';
		var org = $(this).data('org');
		var rota = $(this).data('rota');
		var ronivelta = $(this).data('nivel');

		/*console.log(farmar)
		console.log(tipo)
		console.log(org)
		console.log(rota)
		console.log(ronivelta)
		console.log('CLICK FUDIDO')*/

		$.post("http://hypex_farm/IniciarFarm",JSON.stringify({farmar: farmar, tipo: tipo, org: org, rota: rota, nivel: ronivelta}));
	});
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
		timeout = setTimeout(later,250)
		if (callNow) func.apply(context,args)
	}
}



