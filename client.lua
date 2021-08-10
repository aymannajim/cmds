PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

  	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-------------------------- SOME USEFUL RP STUFF ---------------------------

--- Command to show society money
RegisterCommand('socmoney', function(source,args)
	local societyname = PlayerData.job.name
	-- if PlayerData.job.grade >= 2 then
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(acc)
		exports['mythic_notify']:SendAlert('inform', "["..PlayerData.job.label.."] Your society money: "..acc.."DH", 12000)
	end, societyname)
	-- end
end)

--- MAKE PLANES ENGINE CUT OFF AFTER seconds of riding them
------------------ You need to add exception for people with license
Citizen.CreateThread(function()
	while true do
		local plane = GetVehiclePedIsIn(PlayerPedId(), false)
		if IsThisModelAPlane(GetEntityModel(plane)) and GetPedInVehicleSeat(PlayerPedId(), 1) then
			SetPlaneTurbulenceMultiplier(plane, 100.0)
			Citizen.Wait(math.random(5000,15000))
			if IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) and GetPedInVehicleSeat(PlayerPedId(), 1) then -- is he still in the plane? because if we don't check he might destroy the airplane without being in it
				SetPlaneEngineHealth(plane, 100.0)
				exports['mythic_notify']:SendAlert('error', "Oh my god! You're an idiot! You don't even know how to drive this thing..", 12000)
			else
				Citizen.Wait(2500)
			end
		end
		Citizen.Wait(8000)
	end
end)

--- MAKE HELIS HARDER
------------------ You need to add exception for people with license
Citizen.CreateThread(function()
	while true do
		local inHeli = IsPedInAnyHeli(PlayerPedId(), false)
		if inHeli and GetPedInVehicleSeat(PlayerPedId(), 1) then
			local Heli = GetVehiclePedIsIn(PlayerPedId(), false)
			SetHeliTurbulenceScalar(Heli, 10.0)
		end
		Citizen.Wait(8000)
	end
end)

---- WARN USER WHEN PING IS HIGH
Citizen.CreateThread(function()
	while true do
		ESX.TriggerServerCallback('cmds:getping', function(ping)
			if ping >= 200 then
				exports['mythic_notify']:SendAlert('inform', 'Your ping is extremely high ( '..ping..'ms ), you may get kicked by the server.', 5000, { ['background-color'] = '#C80D0D', ['color'] = '#FFF' })
			elseif ping > 150 and ping < 200 then
				exports['mythic_notify']:SendAlert('inform', 'Your ping is high ( '..ping..'ms )', 5000, { ['background-color'] = '#D42307', ['color'] = '#FFF' })
			end
		end)
		Citizen.Wait(8000)
	end
end)

---------------------------------------------------------------------------

RegisterNetEvent('cmds:licensecopy')
AddEventHandler('cmds:licensecopy', function(lic)
	SendNUIMessage({
		clipboard = lic
	})
	exports['mythic_notify']:SendAlert('success', 'Your license key (Rockstar Identifier) is copied to the clipboard', 15000)
end)

RegisterCommand('h', function(src, args)
	local dict = "missminuteman_1ig_2"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	if not handsup then
		TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
		handsup = true
	else
		handsup = false
		ClearPedTasks(GetPlayerPed(-1))
    end
end)

------------------- kneel script ------------
---- https://github.com/Cosharek/ArrestAnims
RegisterCommand('k', function(source, args, raw)
	TriggerEvent('KneelHU')
end)

RegisterNetEvent( 'KneelHU' )
AddEventHandler( 'KneelHU', function()
    local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
		if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then 
			TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (3000)
            TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
        else
            TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (4000)
            TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (500)
			TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
        end     
    end
end )

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(0,21,true)
		end
	end
end)
-------------------------------------

RegisterCommand("job", function(source, args)
    ShowJob()
end, false)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function ShowJob()
	exports['mythic_notify']:SendAlert('inform', 'Job: <span style="font-weight:500;">' .. PlayerData.job.label .. '</span> | Rank: <span style="font-weight:500;">' .. PlayerData.job.grade_label, 8000)
end

TriggerEvent('chat:addSuggestion', '/cash', 'See how much you have in your pocket', {})
TriggerEvent('chat:addSuggestion', '/job', 'Shows your current job', {})
TriggerEvent('chat:addSuggestion', '/ping', 'Shows your actual ping', {})
TriggerEvent('chat:addSuggestion', '/h', 'Puts your hands up', {})
TriggerEvent('chat:addSuggestion', '/k', 'Kneel Before your Master', {})
