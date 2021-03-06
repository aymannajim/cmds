ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('license', function(source, args)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local license = xPlayer.identifier
	TriggerClientEvent('cmds:licensecopy', src, license)
end)

RegisterCommand('cash', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cash = xPlayer.getMoney()
	if cash < 0 then
		local debt = cash * -1
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "You have a debt of <span style='font-weight:500;'>$".. debt, length = 12000 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "You have <span style='font-weight:500;'>$".. cash .."</span> cash", length = 12000 })
	end
end)

RegisterCommand('bank', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local balance = xPlayer.getAccount('bank').money
	if balance < 0 then
		local debt = balance * -1
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "You have an unpaid loan of <span style='font-weight:500;'>$".. debt, length = 12000 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "You have <span style='font-weight:500;'>$".. balance .."DH</span> on your bank account", length = 12000 })
	end
end)

RegisterCommand('ping', function(source, args, raw)
	local src = source
	local ping = GetPlayerPing(src)
	local msgcolor = '#959595'
	if ping >= 200 then
		msgcolor = '#C80D0D'
	elseif ping < 200 and ping >= 150 then
		msgcolor = '#D42307'
	elseif ping < 150 and ping >= 80 then
		msgcolor = '#F4A700'
	elseif ping < 80 then
		msgcolor = '#13B60B'
	end
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = "Your ping: <span style='font-weight:500;'>"..ping.."ms", length = 12000, style = { ['background-color'] = msgcolor, ['color'] = '#FFF' } })
end)

ESX.RegisterServerCallback('cmds:getping', function(source, cb)
	local src = source
	local ping = GetPlayerPing(src)
	cb(ping)
end)


TriggerClientEvent('chat:addSuggestion', -1, '/ping', 'Shows your actual ping', {})
