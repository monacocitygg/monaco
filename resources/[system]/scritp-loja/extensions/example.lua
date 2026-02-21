local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
local ItemModule = module("vrp","config/Item")

AddEventHandler("centralcart.ready", function()
  local CentralCart = exports[GetCurrentResourceName()]

  CentralCart:registerCommand("examplelua", function()
    print("Comando de exemplo em lua")

    return "OK"
  end)

  CentralCart:registerCommand("addcar", function(user_id, vehicle)
    if user_id and vehicle then
      local nuser_id = tonumber(user_id)
      local nsource = vRP.Source(nuser_id)

      vRP.Query("vehicles/addVehicles",{ Passport = nuser_id, vehicle = vehicle, plate = vRP.GeneratePlate(), work = tostring(false) })
      
      if nsource then
        TriggerClientEvent("Notify",nsource,"verde","Adicionado o veiculo <b>"..vehicle.."</b> em sua garagem.",10000)
      end

      print("CentralCart: Veículo "..vehicle.." entregue para ID "..nuser_id)
      return "OK"
    else
      return "ERROR"
    end
  end)

  CentralCart:registerCommand("addgems", function(user_id, amount)
    if user_id and amount then
      local nuser_id = tonumber(user_id)
      local namount = tonumber(amount)
      local Identity = vRP.Identity(nuser_id)

      if Identity then
        vRP.Query("accounts/AddGems",{ license = Identity["license"], gems = namount })
        print("CentralCart: "..namount.." Gemas entregues para ID "..nuser_id)
        return "OK"
      end
    end
    return "ERROR"
  end)

  CentralCart:registerCommand("remcar", function(user_id, vehicle)
    if user_id and vehicle then
      local nuser_id = tonumber(user_id)
      
      vRP.Query("vehicles/removeVehicles",{ Passport = nuser_id, vehicle = vehicle })
      
      print("CentralCart: Veículo "..vehicle.." removido do ID "..nuser_id)
      return "OK"
    else
      return "ERROR"
    end
  end)

  CentralCart:registerCommand("addGroup", function(user_id, group)
    if user_id and group then
      local nuser_id = tonumber(user_id)
      
      vRP.SetPermission(nuser_id, group)
      
      print("CentralCart: Grupo "..group.." adicionado ao ID "..nuser_id)
      return "OK"
    else
      return "ERROR"
    end
  end)

  CentralCart:registerCommand("remGroup", function(user_id, group)
    if user_id and group then
      local nuser_id = tonumber(user_id)
      
      vRP.RemovePermission(nuser_id, group)
      
      print("CentralCart: Grupo "..group.." removido do ID "..nuser_id)
      return "OK"
    else
      return "ERROR"
    end
  end)
  
  CentralCart:registerCommand("addItem", function(client_identifier, item, amount)
    if not client_identifier or not item or not amount then
      return "ERROR"
    end
    local targetPassport = nil
    local namount = tonumber(amount) or 1
    local effectiveItem = tostring(item)
    if tonumber(client_identifier) then
      targetPassport = tonumber(client_identifier)
    else
      local rows = vRP.Query("characters/lastCharacters",{ license = client_identifier })
      if rows and rows[1] and rows[1]["id"] then
        targetPassport = tonumber(rows[1]["id"])
      end
    end
    if not targetPassport then
      print("CentralCart: addItem falhou, cliente não encontrado: "..tostring(client_identifier))
      return "ERROR"
    end
    if type(itemBody) == "function" and not itemBody(effectiveItem) then
      if type(ItemListGlobal) == "function" then
        local list = ItemListGlobal()
        for k,v in pairs(list) do
          if v and v["Index"] == effectiveItem then
            effectiveItem = k
            break
          end
        end
      end
      if not itemBody(effectiveItem) then
        print("CentralCart: addItem falhou, item inválido: "..tostring(item))
        return "ERROR"
      end
    end
    local before = vRP.InventoryItemAmount(targetPassport,effectiveItem)
    local beforeCount = 0
    if before and before[1] then beforeCount = parseInt(before[1]) end

    local ok = pcall(function()
      return vRP.GenerateItem(targetPassport,effectiveItem,math.floor(namount),true)
    end)
    if not ok then
      print("CentralCart: addItem falhou ao gerar item: "..tostring(effectiveItem))
      return "ERROR"
    end

    local after = vRP.InventoryItemAmount(targetPassport,effectiveItem)
    local afterCount = 0
    if after and after[1] then afterCount = parseInt(after[1]) end
    if afterCount < (beforeCount + math.floor(namount)) then
      print("CentralCart: addItem não confirmou no inventário (item="..tostring(effectiveItem)..", solicitado="..math.floor(namount)..", antes="..beforeCount..", depois="..afterCount..")")
      return "ERROR"
    end
    local targetSource = vRP.Source(targetPassport)
    if targetSource then
      TriggerClientEvent("inventory:Update",targetSource,"Backpack")
      local displayName = tostring(effectiveItem)
      if type(itemName) == "function" then
        displayName = itemName(effectiveItem)
      end
      TriggerClientEvent("Notify",targetSource,"verde","Você recebeu <b>"..math.floor(namount).."x "..displayName.."</b>.",5000)
    end
    local logName = tostring(effectiveItem)
    if type(itemName) == "function" then
      logName = itemName(effectiveItem)
    end
    print("CentralCart: "..math.floor(namount).."x "..logName.." entregue para ID "..targetPassport)
    return "OK"
  end)
end)
