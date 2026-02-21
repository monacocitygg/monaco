-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
hypex = {}
Tunnel.bindInterface("hypex_farm", hypex)
vCLIENT = Tunnel.getInterface("hypex_farm")
REQUEST = Tunnel.getInterface("request")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("hypex_farm/getOrg", "SELECT * FROM hypex_farm WHERE Org = @Org")
vRP.Prepare("hypex_farm/updateFarm", "UPDATE hypex_farm SET Lvl = Lvl + 1 WHERE Org = @Org")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.CheckOrg()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        for Number, v in pairs(Cfg.FarmConfig) do
            local Consult = vRP.Query("hypex_farm/getOrg", { Org = Number })
            if Consult[1] and vRP.HasPermission(Passport, v.PermToAcess) then
                return Consult[1].Org
            end
        end
        TriggerClientEvent("Notify", source, "vermelho", Cfg.NotifyConfig.NoPerm, 3000)
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.GetLvl(Value)
    local source = source
    local Passport = vRP.Passport(source)
    local Consult = vRP.Query("hypex_farm/getOrg", { Org = Value })
    if Passport then
        if Consult[1] then
            return Consult[1].Lvl
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.PaymentCollect(Org, Rota, Nivel)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        Player(source).state.Buttons = true
        Player(source).state.Cancel = true
        if not vRPC.inVehicle(source) then
            vRPC.playAnim(source, false, { Cfg.FarmConfig[Org].Animation[1], Cfg.FarmConfig[Org].Animation[2] }, true)
            TriggerClientEvent("Progress", source, "Coletando", Cfg.FarmConfig[Org].AnimDuration)
            Wait(Cfg.FarmConfig[Org].AnimDuration)
            vRPC.stopAnim(source, false)
        end
        Player(source).state.Buttons = false
        Player(source).state.Cancel = false
        if vRP.InventoryWeight(Passport) + itemWeight(Cfg.FarmConfig[Org].ItemFarm[Rota].ItemSpawn) * math.random(Cfg.FarmConfig[Org].ItemFarm[Rota].ItemAmount["Lvl" .. Nivel][1], Cfg.FarmConfig[Org].ItemFarm[Rota].ItemAmount["Lvl" .. Nivel][2]) <= vRP.GetWeight(Passport) then
            vRP.GenerateItem(Passport, Cfg.FarmConfig[Org].ItemFarm[Rota].ItemSpawn, math.random(Cfg.FarmConfig[Org].ItemFarm[Rota].ItemAmount["Lvl" .. Nivel][1], Cfg.FarmConfig[Org].ItemFarm[Rota].ItemAmount["Lvl" .. Nivel][2]), true)
            return true
        else
            TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
            return false
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.CreateNewRoute(FarmcTable, Message)
    if vRP.Passport(source) then
        for Number, v in pairs(FarmcTable) do
            vRP.Archive(Message .. ".txt", "{ " .. mathLength(FarmcTable[Number].Coords[1]) .. "," .. mathLength(FarmcTable[Number].Coords[2]) .. "," .. mathLength(FarmcTable[Number].Coords[3]) .. " },")
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.UpgradeFarm()
    local source = source
    local Passport = vRP.Passport(source)
    local CheckOrg = hypex.CheckOrg(source)
    local Consult = vRP.Query("hypex_farm/getOrg", { Org = CheckOrg })
    if Passport and CheckOrg then
        if Consult[1].Lvl + 1 > 5 then
            TriggerClientEvent("Notify", source, "amarelo", Cfg.NotifyConfig.MaxLvl, 3000)
            return
        end
        vCLIENT.CloseSystem(source)
        if REQUEST.Function(source, "Upgrade no farm para o LVL " .. Consult[1].Lvl + 1 .. " por " .. Cfg.FarmConfig[CheckOrg].UpgradeValue[Consult[1].Lvl + 1] .. "?", "Sim, efetuar pagamento", "N\195\163o, decido depois") then
            if vRP.PaymentFull(Passport, Cfg.FarmConfig[CheckOrg].UpgradeValue[Consult[1].Lvl + 1]) then
                vRP.Query("hypex_farm/updateFarm", { Org = CheckOrg })
                TriggerClientEvent("Notify", source, "verde", Cfg.NotifyConfig.SucessPayment, 3000)
            else
                TriggerClientEvent("Notify", source, "vermelho", Cfg.NotifyConfig.FailedPayment, 5000)
            end
        else
            return
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
function hypex.levelIdentify()
    local source = source
    local CheckOrg = hypex.CheckOrg(source)
    local Consult = vRP.Query("hypex_farm/getOrg", { Org = CheckOrg })
    if CheckOrg then
        if Consult[1] and vRP.getUserId(source) then
            return { Consult[1].Lvl, "attfutura", "attfutura", "attfutura", "attfutura", "attfutura" }
        end
    end
end
