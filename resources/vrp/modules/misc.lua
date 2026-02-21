vRP.getUserSource = vRP.Source
vRP.getUserId = vRP.Passport
vRP.getUData = vRP.UserData
vRP.query = vRP.Query
vRP.prepare = vRP.Prepare


function vRP.setUData(user_id, key, value)
    vRP.Query("playerdata/SetData",{ Passport = parseInt(user_id), dkey = key, dvalue = value })
end


vRP.getUserDataTable = vRP.Datatable

-- vRP.playerDropped = playerDropped

vRP.hasPermission = vRP.HasPermission

function vRP.format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

vRP.tryFullPayment = function(user_id, value)
    return vRP.PaymentFull(user_id, vRP.Source(user_id), value)
end

CreateThread(function()
	SetRoutingBucketEntityLockdownMode(0,"inactive")
end)