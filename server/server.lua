ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'toggleui', function()
end, { help = _U('toggleui') })

local updatedMoney

RegisterServerEvent('mr:getvipcoin')
AddEventHandler('mr:getvipcoin', function(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT vipcoin FROM users WHERE identifier = @identifier', { -- Change this line
		['@identifier'] = identifier
	},
	function(result)
		if result[1] ~= nil then
			for k,v in pairs(result[1]) do 
				updatedMoney = v
			end
		end
	end)
end)

RegisterServerEvent('trew_hud_ui:getServerInfo')
AddEventHandler('trew_hud_ui:getServerInfo', function()

	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local job

	if xPlayer ~= nil then
		
		if xPlayer.job.label == xPlayer.job.grade_label then
			job = xPlayer.job.grade_label
		else
			job = xPlayer.job.label .. ': ' .. xPlayer.job.grade_label
		end
		TriggerEvent('mr:getvipcoin', source)
		local info = {
			job = job,
			money = xPlayer.getMoney(),
			bankMoney = xPlayer.getAccount('bank').money,
			blackMoney = xPlayer.getAccount('black_money').money,
			vipcoin = updatedMoney

		}
		TriggerClientEvent('trew_hud_ui:setInfo', source, info)
	end
end)

RegisterServerEvent('trew_hud_ui:syncCarLights')
AddEventHandler('trew_hud_ui:syncCarLights', function(status)
	TriggerClientEvent('trew_hud_ui:syncCarLights', -1, source, status)
end)
