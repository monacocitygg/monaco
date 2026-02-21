let users = {}
let groups = {}
let vehicles = {}
let items = {}
let vehicle = null
let perms = {}
let item = null
let itemplayer = null
$(document).ready(function() {

    window.addEventListener("message", function(event) {
        let data = event.data;
        switch (data.action) {
            case "loadstaff":
                loadstaff(data.staff);
                break;
            case "loadusers":
                users = data.users
                loadusers(".paineladm .conteudo .players .todosplayers");
                break;
            case "loadgroups":
                groups = data.groups
                loadgroups(".cargos-select .input select");
                break;
            case "loadvehicles":
                vehicles = data.vehicles
                vehicle = null
                loadvehicles(".paineladm .conteudo .spawnveiculos .todoscarros");
                break;
            case "loaditems":
                items = data.items
                item = null
                itemplayer = null
                loaditems(".paineladm .conteudo .spawnitens .staffspawn .todositens");
                loaditems(".paineladm .conteudo .spawnitens .playerspawn .todositens");
                break;
            case "loadmessages":
                loadchatmessages(data.messages)
                break;
            case "loadchat":
                loadusermessages(data.user_id)
                break;
            case "showmenu":
                $("body").show();
                $(".paineladm").show();
                $(".shadow").show();
                $(".shadow2").show();
                break;
            case "showchat":
                $(".paineladm").hide();
                $(".playerchat").show();
                $("body").show();
                break;
            case "hidemenu":
                $("body").hide();
                break;
            case "hidechat":
                $(".paineladm").show();
                $(".playerchat").hide();
                $("body").hide();
                break;
        }
    });

    document.onkeyup = function(data) {
        if (data.which == 27) {
            if ($("body center").is(":visible")) {
                $("body center").hide();
            }else{
                $.post("https://Night_Admin/close");
            }
        }
    };

    $(".paineladm .menu .opcoes .bloco").click(function() {
        var section = $(this).data("section");

        if (section == "players" || section == "banimentos" || section == "mensagens"){
            loadusers(".paineladm .conteudo ."+section+" .todosplayers");
        }

        $(".paineladm .conteudo .section").hide();
        $(".paineladm .conteudo ."+section).show();
    });

    
});

$(document).on("keyup", "#txtBusca", function(e) {
    var texto = $(this).val();
    $("#principal .cidadao").removeClass('filter');
    $("#principal .cidadao").each(function() {
        if ($(this).text().indexOf(texto) < 0)
            $(this).addClass('filter');
    });
});

$(document).on("keyup", "#txtBuscaVehicle", function(e) {
    var texto = $(this).val();
    $("#principal-vehicle .carro").removeClass('filter');
    $("#principal-vehicle .carro").each(function() {
        if ($(this).text().indexOf(texto) < 0)
            $(this).addClass('filter');
    });
});

$(document).on("keyup", "#txtBuscaItem", function(e) {
    var texto = $(this).val();
    $("#principal-item .item").removeClass('filter');
    $("#principal-item .item").each(function() {
        if ($(this).text().indexOf(texto) < 0)
            $(this).addClass('filter');
    });
});

$(document).on("keyup", "#txtBuscaItemPlayer", function(e) {
    var texto = $(this).val();
    $("#principal-itemplayer .item").removeClass('filter');
    $("#principal-itemplayer .item").each(function() {
        if ($(this).text().indexOf(texto) < 0)
            $(this).addClass('filter');
    });
});

$(document).on("click", ".paineladm .conteudo .players .todosplayers .cidadao", function(e) {
    var user_id = $(this).data("user_id");
    loaduserdata(user_id)
});

$(document).on("click", ".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos .ativos .removercargo", function(e) {
    var user_id = $(this).data("user_id");
    var group = $(this).data("group");

    $.post("https://Night_Admin/remgroup", JSON.stringify({ id: user_id, group: group }), function(data) {
        if (data) {
            loaduserdata(user_id)
            createAlert("success", "Sucesso", "Grupo removido com sucesso do id #"+user_id, 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel remover o grupo do id #"+user_id, 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos .addcargo .adicionar", function(e) {
    var user_id = $(this).attr("data-user_id");
    $(".cargos-select").show();
    $(".cargos-select .input button").attr("data-user_id", user_id);
});

$(document).on("click", ".cargos-select .input button", function(e) {
    var user_id = $(this).attr("data-user_id");
    var group = $(".cargos-select .input select").val();
    $.post("https://Night_Admin/addgroup", JSON.stringify({ id: user_id, group: group }), function(data) {
        if (data) {
            loaduserdata(user_id);
            $("body center").hide();
            createAlert("success", "Sucesso", "Grupo adicionado com sucesso do id #"+user_id, 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel adicionar o grupo do id #"+user_id, 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .banimentos .todosplayers .cidadao", function(e) {
    var user_id = $(this).data("user_id");
    loaduserwarnings(user_id)
});

$(document).on("click", ".paineladm .conteudo .banimentos .banadv .acoesbanadv .adicionar", function(e) {
    var user_id = $(this).attr("data-user_id");
    $(".adv-ban").show();
    $(".adv-ban .input button").attr("data-user_id", user_id);
});

$(document).on("click", ".paineladm .conteudo .banimentos .banadv .acoesbanadv .advertencia", function(e) {
    var user_id = $(this).attr("data-user_id");
    $(".adv-reason").show();
    $(".adv-reason .input button").attr("data-user_id", user_id);
});

$(document).on("click", ".paineladm .conteudo .banimentos .banadv .acoesbanadv .time", function(e) {
    var id = $(this).attr("data-id");
    var user_id = $(this).attr("data-user_id");
    var time = $(this).attr("data-time");
    $(".adv-ban-edit").show();
    $(".adv-ban-edit .input input").val(parseInt(time));
    $(".adv-ban-edit .input button").attr("data-id", id);
    $(".adv-ban-edit .input button").attr("data-user_id", user_id);
});

$(document).on("click", ".adv-ban .input button", function(e) {
    var user_id = $(this).attr("data-user_id");
    var time = $(".adv-ban .input input").val();
    time = parseInt(time)
    if (time > 0){
        $.post("https://Night_Admin/addban", JSON.stringify({ id: user_id, time: time }), function(data) {
            if (data) {
                loaduserwarnings(user_id);
                $("body center").hide();
                createAlert("success", "Sucesso", "O id #"+user_id+" foi banido com sucesso", 3000);
            } else {
                createAlert("danger", "Alerta", "Não foi possivel banir o id #"+user_id, 3000);
            }
        });

    }else{
        createAlert("danger", "Error", "O tempo precisa ser maior que 0", 3000);
    }
});

$(document).on("click", ".adv-reason .input button", function(e) {
    var user_id = $(this).attr("data-user_id");
    var reason = $(".adv-reason .input input").val();
    if (reason){
        $.post("https://Night_Admin/addwarning", JSON.stringify({ id: user_id, reason: reason }), function(data) {
            if (data) {
                loaduserwarnings(user_id);
                $("body center").hide();
                createAlert("success", "Sucesso", "O id #"+user_id+" foi advertido com sucesso", 3000);
            } else {
                createAlert("danger", "Alerta", "Não foi possivel advertir o id #"+user_id, 3000);
            }
        });

    }else{
        createAlert("danger", "Error", "Você deve escrever o motivo", 3000);
    }
});

$(document).on("click", ".adv-ban-edit .input button", function(e) {
    var id = $(this).attr("data-id");
    var user_id = $(this).attr("data-user_id");
    var time = $(".adv-ban-edit .input input").val();
    time = parseInt(time)
    if (time > 0){
        $.post("https://Night_Admin/editban", JSON.stringify({ id: id, time: time }), function(data) {
            if (data) {
                loaduserwarnings(user_id);
                $("body center").hide();
                createAlert("success", "Sucesso", "O banimento do id #"+user_id+" foi alterado com sucesso", 3000);
            } else {
                createAlert("danger", "Alerta", "Não foi possivel alterar o banimento do id #"+user_id, 3000);
            }
        });

    }else{
        createAlert("danger", "Error", "O tempo precisa ser maior que 0", 3000);
    }
});

$(document).on("click", ".paineladm .conteudo .banimentos .banadv .acoesbanadv .deletar", function(e) {
    var id = $(this).attr("data-id");
    var user_id = $(this).attr("data-user_id");
    $.post("https://Night_Admin/deletewarning", JSON.stringify({ id: id }), function(data) {
        if (data) {
            loaduserwarnings(user_id);
            $("body center").hide();
            createAlert("success", "Sucesso", "A advertência do id #"+user_id+" foi deletada com sucesso", 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel deletar a advertência do id #"+user_id, 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .mensagens .todosplayers .cidadao", function(e) {
    var user_id = $(this).data("user_id");
    loadusermessages(user_id)
});

$(document).on("click", ".paineladm .conteudo .mensagens .msgprivadas .chat-input-wrapper .chat-send-btn", function(e) {
    var user_id = $(this).attr("data-user_id");
    var message = $(".paineladm .conteudo .mensagens .msgprivadas .chat-input-wrapper input").val();
    
    if (!message){
        createAlert("danger", "Error", "Escreva uma mensagem", 3000);
        return
    }

    $.post("https://Night_Admin/sendmessage", JSON.stringify({ id: user_id, message: message }), function(data) {
        if (data) {
            loadusermessages(user_id);
            createAlert("success", "Sucesso", "A mensagem foi enviada para o id #"+user_id+" com sucesso", 3000);
            $(".paineladm .conteudo .mensagens .msgprivadas .chat-input-wrapper input").val("");
        } else {
            createAlert("danger", "Alerta", "Não foi possivel a mensagem para o id #"+user_id, 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .spawnitens .staffspawn .todositens .item", function(e) {
    $(".paineladm .conteudo .spawnitens .staffspawn .todositens .item").removeClass("selected")
    var itemdata = $(this).data("item");
    $(this).addClass("selected");
    item = itemdata
});

$(document).on("click", ".paineladm .conteudo .spawnitens .playerspawn .todositens .item", function(e) {
    $(".paineladm .conteudo .spawnitens .playerspawn .todositens .item").removeClass("selected")
    var itemdata = $(this).data("item");
    $(this).addClass("selected");
    itemplayer = itemdata
});

$(document).on("click", ".paineladm .conteudo .spawnitens .staffspawn button", function(e) {
    var amount = $(".paineladm .conteudo .spawnitens .staffspawn .item2").val();
    amount = parseInt(amount);

    if (!item){
        createAlert("danger", "Error", "Selecione o item", 3000);
        return
    }

    if (isNaN(amount)){
        createAlert("danger", "Error", "Selecione a quantidade", 3000);
        return
    }

    if (amount < 1){
        createAlert("danger", "Error", "Selecione a quantidade", 3000);
        return
    }

    $.post("https://Night_Admin/spawnitem", JSON.stringify({ item: item, amount: amount }), function(data) {
        if (data) {
            $("body center").hide();
            createAlert("success", "Sucesso", "Item spawnado com sucesso", 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel spawnar o item", 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .spawnitens .playerspawn button", function(e) {
    var user_id = $(".paineladm .conteudo .spawnitens .playerspawn .item4").val();
    var amount = $(".paineladm .conteudo .spawnitens .playerspawn .item5").val();
    user_id = parseInt(user_id);
    amount = parseInt(amount);

    if (!itemplayer){
        createAlert("danger", "Error", "Selecione o item", 3000);
        return
    }

    if (isNaN(user_id)){
        createAlert("danger", "Error", "Selecione o passaporte", 3000);
        return
    }

    if (isNaN(amount)){
        createAlert("danger", "Error", "Selecione a quantidade", 3000);
        return
    }

    if (user_id < 1){
        createAlert("danger", "Error", "Selecione a passaporte", 3000);
        return
    }

    if (amount < 1){
        createAlert("danger", "Error", "Selecione a quantidade", 3000);
        return
    }

    $.post("https://Night_Admin/spawnitem", JSON.stringify({ item: itemplayer, amount: amount, id: user_id }), function(data) {
        if (data) {
            $("body center").hide();
            createAlert("success", "Sucesso", "Item spawnado com sucesso", 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel spawnar o item", 3000);
        }
    });
});

$(document).on("click", ".paineladm .conteudo .spawnveiculos .todoscarros .carro", function(e) {
    $(".paineladm .conteudo .spawnveiculos .todoscarros .carro").removeClass("selected")
    var vehicledata = $(this).data("vehicle");
    $(this).addClass("selected");
    vehicle = vehicledata
});

$(document).on("click", ".paineladm .conteudo .spawnveiculos .staffspawn button", function(e) {
    if (vehicle){
        $(".spawn-vehicle").show();
    }else{
        createAlert("danger", "Error", "Selecione o veículo", 3000);
    }
});

$(document).on("click", ".spawn-vehicle .input .spawnvehicle", function(e) {
    var user_id = $(".spawn-vehicle .input input").val();

    $.post("https://Night_Admin/spawnvehicle", JSON.stringify({ id: user_id, vehicle: vehicle }), function(data) {
        if (data) {
            $("body center").hide();
            $(".paineladm").hide();
            $(".shadow").hide();
            $(".shadow2").hide();
            createAlert("success", "Sucesso", "Veículo spawnado com sucesso", 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel spawnar o veículo", 3000);
        }
    });
});

$(document).on("click", ".spawn-vehicle .input .addvehicle", function(e) {
    var user_id = $(".spawn-vehicle .input input").val();

    $.post("https://Night_Admin/addvehicle", JSON.stringify({ id: user_id, vehicle: vehicle }), function(data) {
        if (data) {
            $("body center").hide();
            createAlert("success", "Sucesso", "Veículo adicionado na garagem com sucesso", 3000);
        } else {
            createAlert("danger", "Alerta", "Não foi possivel adicionar o veículo na garagem", 3000);
        }
    });
});

$(document).on("click", ".playerchat .chatativo .chat-input-wrapper .chat-send-btn", function(e) {
    var message = $(".playerchat .chatativo .chat-input-wrapper input").val();
    
    if (!message){
        createAlert("danger", "Error", "Escreva uma mensagem", 3000);
        return
    }

    $.post("https://Night_Admin/sendmessageplayer", JSON.stringify({ message: message }), function(data) {
        if (data) {
            loadchatmessages(data);
            createAlert("success", "Sucesso", "A mensagem foi enviada", 3000);
            $(".playerchat .chatativo .chat-input-wrapper input").val("");
        } else {
            createAlert("danger", "Alerta", "Não foi possivel a mensagem", 3000);
        }
    });
});

function loadstaff(data){
    $(".paineladm .opcoes .dados .cargo").html(data.role);
    $(".paineladm .opcoes .dados .nome").html(data.name+" #"+data.user_id);
    perms = data.perms

    if(!perms["players"]){
        $(".paineladm .menu .opcoes .players").hide();
    }

    if(!perms["punishments"]){
        $(".paineladm .menu .opcoes .punishments").hide();
    }

    if(!perms["messages"]){
        $(".paineladm .menu .opcoes .messages").hide();
    }

    if(!perms["spawnitems"]){
        $(".paineladm .menu .opcoes .spawnitems").hide();
    }

    if(!perms["spawnvehicles"]){
        $(".paineladm .menu .opcoes .spawnvehicles").hide();
    }

    if(!perms["addvehicles"]){
        $(".spawn-vehicle .input .addvehicle").hide();
    }
}

function loadusers(div){
    
    $(div).html("");
    $.each(users, function (index, value) {
        var onlinetext = "Offline"
        var onlinecolor = "#a70000"
        if (value.online){
            onlinetext = "Online"
            onlinecolor = "#00911f"
        }

        var html = `<div class="cidadao" data-user_id="${value.user_id}">
            <div class="imagem">
                <img src="img/players.png">
            </div>
            <div class="nomeopcao">
                <h3 class="id">#${value.user_id}</h3>
                <a class="nome">${value.name}</a>
                <p class="set" style="color: ${onlinecolor}">${onlinetext}</p>
            </div>
        </div>`;
        $(div).append(html);
    });
}

function loadgroups(div){
    var nameList = groups.sort((a,b) => (a["name"] > b["name"]) ? 1: -1);

    $(div).html(`<option value="" disabled selected>Cargo que deseja...</option>`);
    $.each(nameList, function (index, value) {
        if (value.group != "Admin") {
            var html = `<option value="${value.group}">${value.name}</option>`;
        }
        $(div).append(html);
    });
}

function loadvehicles(div){
    var nameList = vehicles.sort((a,b) => (a["name"] > b["name"]) ? 1: -1);

    $(div).html("");
    $.each(nameList, function (index, value) {
        var html = `<div class="carro" data-vehicle="${value.vehicle}">
            <div class="imagem">
                <img src="${value.image}">
            </div>
            <div class="nomecar">
                <a>${value.name}</a>
            </div>
        </div>`;
        $(div).append(html);
    });
}

function loaditems(div){
    var nameList = items.sort((a,b) => (a["name"] > b["name"]) ? 1: -1);

    $(div).html("");
    $.each(nameList, function (index, value) {
        var html = `<div class="item" data-item="${value.item}">
            <div class="imagem">
                <img src="${value.image}">
            </div>
            <div class="nomeitem">
                <a>${value.name}</a>
            </div>
        </div>`
        $(div).append(html);
    });
}

function loaduserdata(user_id) {
    $.post("https://Night_Admin/getuser", JSON.stringify({ id: user_id }), function(data) {
        if (data) {

            var banned = "Não"
            var image = "https://cdn.discordapp.com/attachments/956313116013101106/974323031998611456/default.png";

            if (data.image){
                image = data.image
            }

            if (data.banned){
                banned = "Sim"
            }

            var html = `<div class="foto">
                <div class="imagem">
                    <img src="${image}">
                </div>
            </div>

            <div class="dados">
                <div class="infos">
                    <span class="titulo">Nome:</span>
                    <span class="resultado">${data.name}#${data.user_id}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Idade:</span>
                    <span class="resultado">${data.age}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Telefone:</span>
                    <span class="resultado">${data.phone}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Registro:</span>
                    <span class="resultado">${data.registration}</span>
                </div>
            </div>
            <div class="dados">
                <div class="infos">
                    <span class="titulo">Banco:</span>
                    <span class="resultado">${formatcurrency(parseInt(data.bank))}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Multas:</span>
                    <span class="resultado">${formatcurrency(parseInt(data.fines))}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Banido:</span>
                    <span class="resultado">${banned}</span>
                </div>
                <div class="infos">
                    <span class="titulo">Advertências:</span>
                    <span class="resultado">${data.warnings.length}</span>
                </div>
                <div></div>
            </div>`;

            $(".paineladm .conteudo .players .dadosplayer .dadospessoal").html(html);
            $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .inventario .pertences").html("");
            $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos .ativos").html("");

            var inventory = data.inventory.sort((a,b) => (a["name"] > b["name"]) ? 1: -1);
            $.each(inventory, function (index, value) { 
                var html = `<div class="item">
                    <div class="icon">
                        <img src="${value.image}">
                    </div>
                    <a>${value.name}</a>
                    <div class="right">
                        <span>${value.amount}x</span>
                    </div>
                </div>`;

                $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .inventario .pertences").append(html);
            });

            var groups = data.groups.sort((a,b) => (a["name"] > b["name"]) ? 1: -1);
            $.each(groups, function (index, value) { 
                if (value.group != "Admin") {
                    var html = `
                    <div class="cargo">
                        <a>${value.name}</a>
                        <div class="right">
                            <button class="removercargo" data-user_id="${data.user_id}" data-group="${value.group}">Remover</button>
                        </div>
                    </div>`;
                } else {
                    var html = `
                    <div class="cargo">
                        <a>${value.name}</a>
                    </div>`;
                }

                $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos .ativos").append(html);
            });
    
            $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos .addcargo .adicionar").attr("data-user_id", user_id);

            if(!perms["groups"]){
                $(".paineladm .conteudo .players .dadosplayer .dadospersonagem .cargos").hide();
            }

            $(".paineladm .conteudo .players .dadosplayer").show()
        } else {
            createAlert("danger", "Alerta", "Não foi possivel listar os dados", 3000);
        }
    });
}

function loaduserwarnings(user_id) {
    $.post("https://Night_Admin/getuser", JSON.stringify({ id: user_id }), function(data) {
        if (data) {

            $(".paineladm .conteudo .banimentos .banadv .acoesbanadv").html("");
            $.each(data.warnings, function (index, value) {

                var time = "";
                if (value.banned_real_time) {
                    time = value.banned_real_time+ " min"
                }

                var html = `<div class="opcoesbanadv">
                    <div class="playermotivo">
                        <span class="player">${data.name}#${data.user_id}</span>
                        <span class="motivo">${value.reason}</span>
                    </div>
                    <div class="tempo">${time}</div>
                    <div class="opcoes">
                        <div class="acao time" data-id="${value.id}" data-user_id="${data.user_id}" data-time="${value.banned_real_time}">
                            <img src="img/tempo.png">
                            <span class="tooltiptext">Alterar Tempo</span>
                        </div>
                        <div class="acao deletar" data-id="${value.id}" data-user_id="${data.user_id}">
                            <img src="img/deletar.png">
                            <span class="tooltiptext">Apagar Advertência</span>
                        </div>
                    </div>
                </div>`;

                $(".paineladm .conteudo .banimentos .banadv .acoesbanadv").append(html);
            });

            var html = `<div class="opcoesbanadv">
                <div class="playermotivo">
                    <span class="player">${data.name}#${data.user_id}</span>
                </div>
                <div class="tempo"></div>
                <div class="opcoes">
                    <div class="acao adicionar" data-user_id="${data.user_id}">
                        <img src="img/add.png">
                        <span class="tooltiptext">Aplicar Banimento</span>
                    </div>
                    <div class="acao advertencia" data-user_id="${data.user_id}">
                        <img src="img/adv.png">
                        <span class="tooltiptext">Adicionar Advertência</span>
                    </div>
                </div>
            </div>`;

            $(".paineladm .conteudo .banimentos .banadv .acoesbanadv").append(html);

            $(".paineladm .conteudo .banimentos .banadv").show()
        } else {
            createAlert("danger", "Alerta", "Não foi possivel listar os dados", 3000);
        }
    });
}

function loadusermessages(user_id) {
    $.post("https://Night_Admin/getmessages", JSON.stringify({ id: user_id }), function(data) {
        if (data) {

            $(".paineladm .conteudo .mensagens .msgprivadas .chat-wrapper").html("");
            $.each(data, function (index, value) {

                var classe = "";
                if (value.staff) {
                    classe = "reverse"
                }
                var image = "https://cdn.discordapp.com/attachments/956313116013101106/974323031998611456/default.png";
    
                if (value.image){
                    image = value.image
                }

                var message = value.message;
                if (value.message.indexOf(".jpg") != -1) {
                    message = "<img src='" + value.message + "' />"
                }

                if (value.message.indexOf(".png") != -1) {
                    message = "<img src='" + value.message + "' />"
                }

                if (value.message.indexOf(".gif") != -1) {
                    message = "<img src='" + value.message + "' />"
                }

                var html = `<div class="message-wrapper ${classe}">
                    <img class="message-pp" src="${image}" alt="profile-pic">
                    <div class="message-box-wrapper">
                        <div class="message-box">${message}</div>
                        <span>${value.name}#${value.user_id}</span>
                    </div>
                </div>`

                $(".paineladm .conteudo .mensagens .msgprivadas .chat-wrapper").append(html);
            });
    
            $(".paineladm .conteudo .mensagens .msgprivadas .chat-input-wrapper .chat-send-btn").attr("data-user_id", user_id);
            $(".paineladm .conteudo .mensagens .msgprivadas").show();
        } else {
            createAlert("danger", "Alerta", "Não foi possivel listar as mensagens", 3000);
        }
    });
}

function loadchatmessages(data) {
    $(".playerchat .chatativo .chat-wrapper").html("");
    $.each(data, function (index, value) {

        var classe = "reverse";
        if (value.staff) {
            classe = ""
        }
        var image = "https://cdn.discordapp.com/attachments/956313116013101106/974323031998611456/default.png";

        if (value.image){
            image = value.image
        }

        var message = value.message;
        if (value.message.indexOf(".jpg") != -1) {
            message = "<img src='" + value.message + "' />"
        }

        if (value.message.indexOf(".png") != -1) {
            message = "<img src='" + value.message + "' />"
        }

        if (value.message.indexOf(".gif") != -1) {
            message = "<img src='" + value.message + "' />"
        }

        var html = `<div class="message-wrapper ${classe}">
            <img class="message-pp" src="${image}" alt="profile-pic">
            <div class="message-box-wrapper">
                <div class="message-box">${message}</div>
                <span>${value.name}#${value.user_id}</span>
            </div>
        </div>`

        $(".playerchat .chatativo .chat-wrapper").append(html);
    });
}

function formatcurrency(value) {
    var amount = (value).toLocaleString('en-US', {
        style: 'currency',
        currency: 'USD',
    });

    return amount;
}

function createAlert(type, title, message, time) {
    var html = `<div class="alert ${type}">
        <h3>${title}</h3>
        <p>${message}</p>
    </div>`;

    $(".alerts").html(html);
    $(".alerts").fadeIn();

    setTimeout(() => {
        $(".alerts").fadeOut();
    }, time);
}