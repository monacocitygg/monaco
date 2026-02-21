-- function vRP.getUserId(source)
-- 	return vRP.Passport(source)
-- end

function vRP.userInventory(Passport)
	return vRP.Inventory(Passport)
end

function vRP.getWeight(Passport)
	return vRP.GetWeight(Passport)
end

function vRP.setWeight(Passport,amount)
	return vRP.SetWeight(Passport,amount)
end

function vRP.userIdentity(Passport)
	return vRP.Identity(Passport)
end

function vRP.registerDrivers(name,onInit,onPrepare,onQuery)
	return vRP.Drivers(name,onInit,onPrepare,onQuery)
end

function vRP.checkBroken(nameItem)
	return vRP.CheckDamaged(nameItem)
end

function vRP.query(name,params,mode)
	return vRP.Query(name,params,mode)
end

function vRP.Execute(name,params)
	return vRP.Query(name,params)
end

function vRP.execute(name,params)
	return vRP.Query(name,params)
end

function vRP.delBank(Passport,amount,mode)
	return vRP.RemoveBank(Passport,amount,mode)
end

function vRP.addBank(Passport,amount,mode)
	return  vRP.GiveBank(Passport,amount,mode)
end

function vRP.prepare(name,Query)
	return vRP.Prepare(name,Query)
end

function vRP.userPlate(vehPlate)
	return vRP.PassportPlate(vehPlate)
end

function vRP.getIdentities(source)
	return vRP.Identities(source)
end

function vRP.characterChosen(source,Passport,model)
	return vRP.CharacterChosen(source,Passport,model)
end

function vRP.infoAccount(steam)
	return vRP.Account(steam)
end

function vRP.insertReputation(Passport,experience,amount)
	return vRP.PutExperience(Passport,experience,amount)
end

function vRP.checkReputation(Passport,experience)
	return vRP.GetExperience(Passport,experience)
end

function vRP.userPremium(Passport)
	return vRP.UserPremium(Passport)
end

function vRP.steamPremium(steam)
	return vRP.LicensePremium(steam)
end

function vRP.userList()
	return vRP.Players()
end

function vRP.tryChest(Passport,chestData,amount,slot,target)
	return vRP.TakeChest(Passport,chestData,amount,slot,target)
end

function vRP.removeInventoryItem(Passport,nameItem,amount,notify)
	return vRP.RemoveItem(Passport,nameItem,amount,notify)
end

function vRP.falseIdentity(Passport)
	return vRP.FalseIdentity(Passport)
end

function vRP.giveInventoryItem(Passport,nameItem,amount,notify,slot)
	return vRP.GiveItem(Passport,nameItem,amount,notify,slot)
end

function vRP.checkMaxItens(Passport,nameItem,amount)
	return vRP.MaxItens(Passport,nameItem,amount)
end

function vRP.tryGetInventoryItem(Passport,nameItem,amount,notify,slot)
	return vRP.TakeItem(Passport,nameItem,amount,notify,slot)
end

function vRP.generatePlate()
	return vRP.GeneratePlate()
end

function vRP.numPermission(perm)
	return vRP.NumPermission(perm)
end

function vRP.getInventoryItemAmount(Passport,nameItem)
	return vRP.InventoryItemAmount(Passport,nameItem)
end

function vRP.getHealth(source)
	return vRP.GetHealth(source)
end

function vRP.paymentFull(Passport,amount)
	return vRP.PaymentFull(Passport,amount)
end

function vRP.upgradeHunger(Passport,amount)
	return vRP.UpgradeHunger(Passport,amount)
end

function vRP.upgradeThirst(Passport,amount)
	return vRP.UpgradeThirst(Passport,amount)
end

function vRP.upgradeStress(Passport,amount)
	return vRP.UpgradeStress(Passport,amount)
end

function vRP.downgradeThirst(Passport,amount)
	return vRP.DowngradeThirst(Passport,amount)
end

function vRP.downgradeHunger(Passport,amount)
	return vRP.DowngradeHunger(Passport,amount)
end

function vRP.downgradeStress(Passport,amount)
	return vRP.DowngradeStress(Passport,amount)
end

function vRP.modelPlayer(source)
	return vRP.ModelPlayer(source)
end

function vRP.hasPermission(Passport,perm)
	return vRP.HasPermission(Passport,perm)
end

function vRP.getBank(Passport)
	return vRP.GetBank(Passport)
end

function vRP.getFines(Passport)
	return vRP.GetFine(Passport)
end

function vRP.delFines(Passport,amount)
	return vRP.RemoveFine(Passport,amount)
end