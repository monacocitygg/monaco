-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("dismantled", Creative)
vGARAGES = Tunnel.getInterface("garages")
vCLIENT = Tunnel.getInterface("dismantled")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local desmanche = "https://discord.com/api/webhooks/1123869916114722846/KGb2c70n5BbZkl8LrcgPY9XZGcevGeWO7_wHscS_XWCIDD5J-HRktWsjyUdhRMa8i5ij"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

------------------------------------------------------
-- CONFIG 
------------------------------------------------------
local RestritoParaDesmanche = true -- É restrito para quem tiver só a permissão do desmanche? (TRUE/FALSE)
local PermissaoDesmanche = 'Bennys' -- Se RestritoParaDesmanche for TRUE, aqui deverá ter a permissão que será verifiada.

local CarrosDesmanches = {
    --==============================================================
    -- configure o nome do veículo e valor que recebe ao desmanchar
    -- geralmente configuro 10% do valor do veículo
    --==============================================================
--Commercials
["mule4"] = 80000,
['packer'] = 80000,
['phantom'] = 80000,
['hauler'] = 80000,
--Compacts
['blista'] = 8000,
['brioso'] = 3500,
['dilettante'] = 4000,
['issi2'] = 9000,
['issi3'] = 19000,
['panto'] = 800,
['prairie'] = 8000,
['rhapsody'] = 1000,
--Coupes
['cogcabrio'] = 13000,
['exemplar'] = 30000,
['f620'] = 15000,
['felon'] = 14000,
['felon2'] = 200,
['jackal'] = 12000,
['oracle'] = 12000,
['oracle2'] = 16000,
['sentinel'] = 5000,
['sentinel2'] = 12000,
['windsor'] = 15000,
['windsor2'] = 17000,
['zion'] = 5000,
['zion2'] = 12000,
--Industrial
['guardian'] = 54000,
--Motorcycles
['akuma'] = 25000,
['avarus'] = 88000,
['bagger'] = 5000,
['bati'] = 74000,
['bati2'] = 74000,
['bf400'] = 64000,
['carbonrs'] = 74000,
['chimera'] = 69000,
['cliffhanger'] = 62000,
['daemon'] = 5000,
['daemon2'] = 48000,
['defiler'] = 92000,
['diablous'] = 86000,
['diablous2'] = 92000,
['double'] = 74000,
['enduro'] = 39000,
['esskey'] = 64000,
['faggio2'] = 1000,
['faggio3'] = 1000,
['fcr'] = 78000,
['fcr2'] = 78000,
['gargoyle'] = 69000,
['hakuchou'] = 76000,
['hakuchou2'] = 76000,
['hexer'] = 5000,
['innovation'] = 5000,
['lectro'] = 76000,
['manchez'] = 71000,
['nemesis'] = 69000,
['nightblade'] = 83000,
['pcj'] = 46000,
['ruffian'] = 69000,
['sanchez'] = 37000,
['sanchez2'] = 37000,
['sanctus'] = 5000,
['sovereign'] = 57000,
['thrust'] = 75000,
['vader'] = 69000,
['vindicator'] = 68000,
['vortex'] = 75000,
['wolfsbane'] = 58000,
['zombiea'] = 58000,
['zombieb'] = 58000,
['shotaro'] = 25000,
['ratbike'] = 46000,
--Muscle
['blade'] = 22000,
['buccaneer'] = 26000,
['buccaneer2'] = 21000,
['chino'] = 26000,
['chino2'] = 5000,
['coquette3'] = 39000,
['dominator'] = 56000,
['dominator2'] = 56000,
['dominator3'] = 74000,
['dukes'] = 5000,
['faction'] = 5000,
['faction2'] = 5000,
['faction3'] = 35000,
['ellie'] = 64000,
['gauntlet'] = 33000,
['gauntlet2'] = 33000,
['hermes'] = 46000,
['hotknife'] = 36000,
['lurcher'] = 5000,
['moonbeam'] = 44000,
['moonbeam2'] = 5000,
['nightshade'] = 54000,
['phoenix'] = 25000,
['picador'] = 5000,
['ratloader2'] = 14000,
['ruiner'] = 5000,
['sabregt'] = 52000,
['sabregt2'] = 5000,
['slamvan'] = 36000,
['slamvan2'] = 5000,
['slamvan3'] = 46000,
['stalion'] = 5000,
['stalion2'] = 5000,
['tampa'] = 34000,
['vigero'] = 34000,
['virgo'] = 5000,
['virgo2'] = 5000,
['virgo3'] = 36000,
['voodoo'] = 44000,
['voodoo2'] = 44000,
['yosemite'] = 5000,
--Off-Road
['bfinjection'] = 16000,
['bifta'] = 38000,
['blazer'] = 46000,
['blazer4'] = 74000,
['bodhi2'] = 34000,
['brawler'] = 5000,
['dloader'] = 5000,
['dubsta3'] = 5000,
['freecrawler'] = 5000,
['kamacho'] = 15000,
['mesa3'] = 5000,
['rancherxl'] = 44000,
['rebel'] = 200,
['rebel2'] = 5000,
['riata'] = 5000,
['sandking'] = 5000,
['sandking2'] = 74000,
['trophytruck'] = 5000,
['trophytruck2'] = 5000,
--SUVs
['baller'] = 10000,
['baller2'] = 32000,
['baller3'] = 35000,
['baller4'] = 37000,
['baller5'] = 54000,
['baller6'] = 56000,
['mesa'] = 42000,
['bjxl'] = 22000,
['cavalcade'] = 22000,
['cavalcade2'] = 26000,
['contender'] = 5000,
['dubsta'] = 42000,
['dubsta2'] = 48000,
['fq2'] = 22000,
['granger'] = 69000,
['gresley'] = 5000,
['habanero'] = 22000,
['huntley'] = 22000,
['landstalker'] = 26000,
['mesa'] = 18000,
['patriot'] = 5000,
['patriot2'] = 15000,
['radi'] = 22000,
['rocoto'] = 22000,
['seminole'] = 22000,
['serrano'] = 5000,
['xls'] = 5000,
['xls2'] = 5000,
--Sedans
['asea'] = 11000,
['asterope'] = 13000,
['cog55'] = 5000,
['cog552'] = 5000,
['cognoscenti'] = 56000,
['cognoscenti2'] = 5000,
['emperor'] = 5000,
['emperor2'] = 5000,
['fugitive'] = 5000,
['glendale'] = 14000,
['ingot'] = 15500,
['intruder'] = 12000,
['premier'] = 7000,
['primo'] = 26000,
['primo2'] = 5000,
['stafford'] = 5000,
['stanier'] = 12000,
['stratum'] = 18000,
['stretch'] = 20000,
['superd'] = 5000,
['surge'] = 42000,
['tailgater'] = 22000,
['warrener'] = 18000,

['washington'] = 26000,
['faggio'] = 800,
['rallytruck'] = 52000,
--Sports
['alpha'] = 46000,
['banshee'] = 10000,
['bestiagts'] = 58000,
['blista2'] = 11000,
['blista3'] = 16000,
['buffalo'] = 5000,
['buffalo2'] = 5000,
['buffalo3'] = 5000,
['carbonizzare'] = 58000,
['comet2'] = 58000,
['comet3'] = 58000,
['comet5'] = 58000,
['coquette'] = 58000,
['deveste'] = 18000,
['elegy'] = 5000,
['elegy2'] = 71000,
['feltzer2'] = 51000,
['flashgt'] = 74000,
['furoregt'] = 58000,
['fusilade'] = 42000,
['futo'] = 34000,
['gb200'] = 39000,
['hotring'] = 5000,
['jester'] = 5000,
['jester3'] = 69000,
['khamelion'] = 42000,
['kuruma'] = 66000,
['lynx'] = 74000,
['massacro'] = 66000,
['massacro2'] = 66000,
['neon'] = 74000,
['ninef'] = 58000,
['ninef2'] = 58000,
['omnis'] = 48000,
['pariah'] = 25000,
['penumbra'] = 5000,
['raiden'] = 48000,
['schwarzer'] = 34000,
['sentinel3'] = 34000,
['seven70'] = 74000,
['specter'] = 64000,
['specter2'] = 71000,
['streiter'] = 5000,
['sultan'] = 42000,
['surano'] = 62000,
['tampa2'] = 5000,
['tropos'] = 34000,
['verlierer2'] = 76000,
--Sport Classic
['btype'] = 5000,
['btype2'] = 92000,
['btype3'] = 78000,
['casco'] = 71000,
['cheetah2'] = 48000,
['coquette2'] = 57000,
['fagaloa'] = 64000,
['feltzer3'] = 44000,
['gt500'] = 5000,
['infernus2'] = 5000,
['jb700'] = 44000,
['mamba'] = 5000,
['manana'] = 26000,
['michelli'] = 32000,
['monroe'] = 52000,
['peyote'] = 5000,
['pigalle'] = 5000,
['rapidgt3'] = 44000,
['retinue'] = 5000,
['stinger'] = 44000,
['stingergt'] = 46000,
['swinger'] = 5000,
['torero'] = 32000,
['tornado'] = 5000,
['tornado2'] = 32000,
['tornado5'] = 44000,
['tornado6'] = 5000,
['turismo2'] = 5000,
['z190'] = 5000,
['ztype'] = 5000,
['cheburek'] = 34000,
--Super
['adder'] = 34000,
['autarch'] = 32000,
['banshee2'] = 74000,
['bullet'] = 15000,
['cheetah'] = 85000,
['cyclone'] = 14000,
['entity2'] = 15000,
['entityxf'] = 92000,
['fmj'] = 40000,
['gp1'] = 99000,
['infernus'] = 94000,
['italigtb'] = 25000,
['italigtb2'] = 22000,
['le7b'] = 15000,
['nero'] = 60000,
['nero2'] = 96000,
['osiris'] = 92000,
['penetrator'] = 96000,
['pfister811'] = 26000,
['prototipo'] = 26000,
['reaper'] = 34000,
['sc1'] = 99000,
['sheava'] = 15000,
['sultanrs'] = 15000,
['t20'] = 14000,
['taipan'] = 14000,
['tempesta'] = 15000,
['tezeract'] = 14000,
['turismor'] = 14000,
['tyrant'] = 18000,
['tyrus'] = 14000,
['vacca'] = 14000,
['vagner'] = 16000,
['visione'] = 18000,
['voltic'] = 88000,
['xa21'] = 16000,
['zentorno'] = 14000,
--Vans
['bison'] = 44000,
['bison2'] = 36000,
['bobcatxl'] = 52000,
['boxville2'] = 5000,
['burrito'] = 52000,
['burrito2'] = 52000,
['burrito3'] = 52000,
['burrito4'] = 52000,
['gburrito'] = 5000,
['minivan'] = 22000,
['minivan2'] = 44000,
['paradise'] = 52000,
['pony'] = 52000,
['pony2'] = 52000,
['rumpo'] = 52000,
['rumpo2'] = 52000,
['rumpo3'] = 52000,
['speedo'] = 52000,
['surfer'] = 11000,
['youga'] = 5000,
['youga2'] = 5000,
['speedo4'] = 5000,
['taco'] = 5000,
['youga3'] = 5000,
['avenger'] = 5000,
['seasparrow3'] = 5000,
['annihilator2'] = 5000,
['valkyrie2'] = 5000,
['valkyrie'] = 5000,
--DLC Cayo Perico
["weevil"] = 2000,
["brioso2"] = 2500,
["manchez2"] = 5000,
["italirsx"] = 5000,
--DLC The Diamond Casino
["asbo"] = 9000,
["kanjo"] = 29000,
["yosemite2"] = 5000,
["caracara2"] = 15000,
["everon"] = 75000,
["rebla"] = 5000,
["komoda"] = 125000,
["imorgon"] = 15000,
["vstr"] = 15000,
--DLC Arena WAR
['clique'] = 72000,
['deviant'] = 74000,
['impaler'] = 64000,
['tulip'] = 64000,
['vamos'] = 64000,
['toros'] = 40000,
['italigto'] = 15000,
['schlagen'] = 80000,
--DLC Los Santos Tunners
["previon"] = 25000,
["dominator7"] = 25000,
["tailgater2"] = 25000,
["zr350"] = 25000,
["calico"] = 25000,
["futo2"] = 25000,
["euros"] = 25000,
["jester4"] = 25000,
["remus"] = 25000,
["comet6"] = 25000,
["growler"] = 25000,
["vectre"] = 25000,
["cypher"] = 25000,
["sultan3"] = 25000,
["rt3000"] = 25000,

["club"] = 9000,
["gauntlet5"] = 5000,
["yosemite3"] = 39000,
["landstalker2"] = 5000,
["seminole2"] = 31000,
["glendale2"] = 45000,
["coquette4"] = 25000,
["penumbra2"] = 25000,
['ruston'] = 25000,
["manana2"] = 5000,
["peyote3"] = 13000,
["tigon"] = 25000,

}
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------


-- RETORNA VEICULOS PERMITIDOS
function Creative.GetVehs()
    return CarrosDesmanches
end


-- FUNÇÃO VERIFICAR PERMISSÃO DO DESMANCHE
function Creative.CheckPerm()
    local source = source
    local Passport = vRP.Passport(source)
    if RestritoParaDesmanche then
        if vRP.HasPermission(Passport, PermissaoDesmanche) then
            return true
        end
        return false
    end
end

-- FUNÇÃO VERIFICAR SE O PLAYER ESTA DESMANCHANDO
local trabalhando = true

function Creative.IsPlayerWorking()
    local source = source
    local Passport = vRP.Passport(source)
    if trabalhando then
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERARPAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GerarPagamento(placa, nomeCarro)
    --print("iniciou pagamento do veiculo")
    local source = source
    local Passport = vRP.Passport(source)
	local identity = vRP.Identity(Passport)

    -- REALIZA O PAGAMENTO
    for k, v in pairs(CarrosDesmanches) do
        if string.upper(k) == string.upper(nomeCarro) then
            local pagamento = v
            vRP.GenerateItem(Passport,'dollars2',pagamento) -- DINHEIRO SUJO
            vRP.GenerateItem(Passport,'sucata',1) -- carro velho

            TriggerClientEvent('Notify',source,'verde','Você recebeu <b>R$'..pagamento..'</b> pelo desmanche de um <b> ('.. nomeCarro..' - PLACA [' .. placa .. '])</b>.',20000)
            vRP.upgradeStress(Passport,5)
            SendWebhookMessage(desmanche,"```[NOME]: "..identity.name.." "..identity.name2.." \n[ID]: "..Passport.." \n[DESMANCHOU]: "..nomeCarro.." \n[PLACA]: "..placa.." \n[E RECEBEU]: "..pagamento.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GERARARREST
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vehicles/arrestDismantle","UPDATE vehicles SET arrest = UNIX_TIMESTAMP() + 2592000 WHERE vehicle = @vehicle AND plate = @plate")

function Creative.GerarArrest(placa, nomeCarro)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
        local Vehicle = vRP.Query("vehicles/plateVehicles",{ plate = placa })
        if Vehicle[1] then
            vRP.Query("vehicles/arrestDismantle",{ vehicle = nomeCarro, plate = placa })
        end
	end
end