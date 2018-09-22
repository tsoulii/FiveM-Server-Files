--[[------------------------------------------------------------------------

	ActionMenu 
	Created by WolfKnight
	Additional help from lowheartrate, TheStonedTurtle, and Briglair. 

------------------------------------------------------------------------]]--

-- Define the variable used to open/close the menu 
local menuEnabled = false 

--[[------------------------------------------------------------------------
	ActionMenu Toggle
	Calling this function will open or close the ActionMenu. 
------------------------------------------------------------------------]]--
function ToggleActionMenu()
	-- Make the menuEnabled variable not itself 
	-- e.g. not true = false, not false = true 
	menuEnabled = not menuEnabled

	if ( menuEnabled ) then 
		-- Focuses on the NUI, the second parameter toggles the 
		-- onscreen mouse cursor. 
		SetNuiFocus( true, true )

		-- Sends a message to the JavaScript side, telling it to 
		-- open the menu. 
		SendNUIMessage({
			showmenu = true 
		})
	else 
		-- Bring the focus back to the game
		SetNuiFocus( false )

		-- Sends a message to the JavaScript side, telling it to
		-- close the menu.
		SendNUIMessage({
			hidemenu = true 
		})
	end 
end 

--[[------------------------------------------------------------------------
	ActionMenu HTML Callbacks
	This will be called every single time the JavaScript side uses the
	sendData function. The name of the data-action is passed as the parameter
	variable data. 
------------------------------------------------------------------------]]--
RegisterNUICallback( "ButtonClick", function( data, cb ) 
	if ( data == "handsup" ) then 
		handsUp()
	elseif ( data == "kneel" ) then 
		TriggerEvent( "KneelHU" )
	elseif ( data == "dropweapon" ) then 
		TriggerEvent( "dropweapon" )
		elseif ( data == "trunk" ) then 
		TriggerEvent( "openTrunk" )
	elseif ( data == "rollwindow" ) then 
		TriggerEvent( "RollWindow" )
		elseif ( data == "carbine" ) then 
		TriggerEvent( "equipCarbine" )
	elseif ( data == "shotgun" ) then 
		TriggerEvent( "equipShotgun" )
		elseif ( data == "loadout" ) then 
		TriggerEvent( "equipPistol" )
		elseif ( data == "cuff" ) then 
		TriggerEvent( "cuff" )
	elseif ( data == "grab" ) then 
		TriggerEvent( "grab" )
	elseif ( data == "exit" ) then 
		-- We toggle the ActionMenu and return here, otherwise the function 
		-- call below would be executed too, which would just open the menu again 
		ToggleActionMenu()
		return 
	end 

	-- This will only be called if any button other than the exit button is pressed
	ToggleActionMenu()
end )


--[[------------------------------------------------------------------------
	ActionMenu Control and Input Blocking 
	This is the main while loop that opens the ActionMenu on keypress. It 
	uses the input blocking found in the ES Banking resource, credits to 
	the authors.
------------------------------------------------------------------------]]--
Citizen.CreateThread( function()
	-- This is just in case the resources restarted whilst the NUI is focused. 
	SetNuiFocus( false )

	while true do 
		-- Control ID 20 is the 'Z' key by default 
		-- Use https://wiki.fivem.net/wiki/Controls to find a different key 
		if ( IsControlJustPressed( 1, 20 ) ) then 
			ToggleActionMenu()
		end 

	    if ( menuEnabled ) then
            local ped = GetPlayerPed( -1 )	

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride
        end

		Citizen.Wait( 0 )
	end 
end )

function chatPrint( msg )
	TriggerEvent( 'chatMessage', "ActionMenu", { 255, 255, 255 }, msg )
end 

local handsup = false

function handsUp()
    local dict = "missminuteman_1ig_2"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
	if not handsup then
		TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
		handsup = true
	else
		handsup = false
		ClearPedTasks(GetPlayerPed(-1))
	end
end

--Kneel Handsup Start
 
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end
 
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

--Kneel Handsup End

RegisterNetEvent("dropweapon")
AddEventHandler('dropweapon', function()
	local ped = GetPlayerPed(-1)
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetPedDropsWeapon(ped)
		ShowNotification("~r~You have dropped your weapon.")
	end
end)


function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent( 'openTrunk' )
AddEventHandler( 'openTrunk', function()

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 5) > 0 then
            SetVehicleDoorShut(veh, 5, false)
        else
            SetVehicleDoorOpen(veh, 5, false, false)
        end
    end
end, false)

local windowup = true
RegisterNetEvent("RollWindow")
AddEventHandler('RollWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then 
            SetEntityAsMissionEntity( playerCar, true, true )
		
			if ( windowup ) then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows down')
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				TriggerEvent('chatMessage', '', {255,0,0}, 'Windows up')
				windowup = true
			end
		end
	end
end )

RegisterCommand("rollw", function(source, args, raw)
    TriggerEvent("RollWindow")
end, false) --False, allow everyone to run it(thnx @Havoc)

carbineEquipped = false
shotgunEquipped = false


Citizen.CreateThread(function()

		ped = GetPlayerPed(-1)
	
	while true do 
		Wait(0)

		ped = GetPlayerPed(-1)
		veh = GetVehiclePedIsIn(ped)
		currentWeapon = GetSelectedPedWeapon(ped)
		

		if nearPickup then
			TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Near pickup")
		end
		
		if carbineEquipped == false then
			RemoveWeaponFromPed(ped, "WEAPON_CARBINERIFLE")			
			
		end
		
		if shotgunEquipped == false then
			RemoveWeaponFromPed(ped, "WEAPON_PUMPSHOTGUN")			
		
		end
		
		if carbineEquipped then
			if (tostring(currentWeapon) ~= "-2084633992") and veh == nil then
				TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Must put away your carbine!")
			end
			SetCurrentPedWeapon(ped, "WEAPON_CARBINERIFLE", true)
		end
		
		if shotgunEquipped then
			if tostring(currentWeapon) ~= "487013001" and veh == ni then
				TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Must put away your shotgun!")
			end
			SetCurrentPedWeapon(ped, "WEAPON_PUMPSHOTGUN", true)
		end
		
		
	--	GiveWeaponToPed(ped, "WEAPON_COMBATPISTOL", 60, false, true)
		
		--Wait(3000)
		
	--	RemoveWeaponFromPed(ped, "WEAPON_COMBATPISTOL")
	
		
		--TaskReloadWeapon(ped, true)

	end

end)

RegisterNetEvent("equipCarbine")
AddEventHandler("equipCarbine", function()
	
	print((GetVehicleClass(veh) == 18))
	
	if (GetVehicleClass(veh) == 18) then
		carbineEquipped = not carbineEquipped
		shotgunEquipped = false
		
		
		
	elseif (GetVehicleClass(veh) ~= 18) then
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Must be in a police car to grab your carbine!")
	end
	
	
	if carbineEquipped then
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Carbine Equipped!")
		GiveWeaponToPed(ped, "WEAPON_CARBINERIFLE", 60, false, true)
	else 
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Carbine Unequipped!")
	end
end)

RegisterNetEvent("equipShotgun")
AddEventHandler("equipShotgun", function()
	
	if (GetVehicleClass(veh) == 18) then
		shotgunEquipped = not shotgunEquipped
		carbineEquipped = false
		
	elseif (GetVehicleClass(veh) ~= 18) then
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Must be in a police car to grab your shotgun!")
	end
	
	if shotgunEquipped then
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Shotgun Equipped!")
		GiveWeaponToPed(ped, "WEAPON_PUMPSHOTGUN", 60, false, true)
	else
		TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Shotgun Unequipped!")
	end
end)

RegisterNetEvent("equipPistol")
AddEventHandler("equipPistol", function()
	GiveWeaponToPed(ped, "WEAPON_COMBATPISTOL", 60, false, true)
	GiveWeaponToPed(ped, "WEAPON_STUNGUN", 60, false, true)
	GiveWeaponToPed(ped, "WEAPON_FLASHLIGHT", 60, false, true)
	GiveWeaponToPed(ped, "WEAPON_NIGHTSTICK", 60, false, true)
end)

RegisterNetEvent("dropGun")
AddEventHandler("dropGun", function()
	currentWeapon = GetSelectedPedWeapon(ped)
	
	droppedWeapon = SetPedDropsInventoryWeapon(ped, currentWeapon, -2.0, 0.0, 0.5, 30)
	
	
	TriggerEvent("chatMessage", "[DOJ  WEAPON]", {255, 0, 0}, "Gun Dropped!")
end)

--[[ Cuff Player ]]--
RegisterNetEvent("cuff1")
AddEventHandler("cuff1", function()
	ped = GetPlayerPed(-1)
	if (DoesEntityExist(ped)) then
		Citizen.CreateThread(function()
		RequestAnimDict("mp_arresting")
			while not HasAnimDictLoaded("mp_arresting") do
				Citizen.Wait(0)
			end
			if isCuffed then
				ClearPedSecondaryTask(ped)
				StopAnimTask(ped, "mp_arresting", "idle", 3)
				SetEnableHandcuffs(ped, false)
				isCuffed = false
			else
				TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(ped, true)
				Citizen.Trace("cuffed")
				isCuffed = true
			end
			
			
		end)
	end
end)


AddEventHandler("core:ShowNotification", function(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true)
end)


--[[ Cuff Nearest Player ]]--
RegisterNetEvent("cuff")
AddEventHandler("cuff", function()
	local ped = GetPlayerPed(-1)
	local nearestPlayer = GetNearestPlayerToEntity(ped)
	local entityType = GetEntityType(ped)
	
	shortestDistance = 2
	closestId = 0
	
	for id = 0, 32 do
        if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
			ped1 = GetPlayerPed( id )
			local x,y,z = table.unpack(GetEntityCoords(ped))
                if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  shortestDistance) then
					
					shortestDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), x,y,z)
					closestId = GetPlayerServerId(id)		
					
				end
				
        end		
	end
		
		TriggerServerEvent("cuffNear", closestId)
	
end)




--[[ Some Realism Factors ]]--
Citizen.CreateThread(function()

	ped = GetPlayerPed(-1)

	while true do
		Citizen.Wait(0)
		if IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
			isCuffed = true
		elseif isCuffed then
			TaskPlayAnim(ped, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 25, true)
			DisableControlAction(1, 59, true)
			DisableControlAction(1, 63, true)
			DisableControlAction(1, 64, true)
			DisableControlAction(1, 123, true)
			DisableControlAction(1, 124, true)
			DisableControlAction(1, 125, true)
			DisableControlAction(1, 133, true)
			DisableControlAction(1, 134, true)
			SetPedCurrentWeaponVisible(GetPlayerPed(-1), false, true, false, false)
			
		end
	end
end)
otherid = 0
grab = false

RegisterNetEvent("grab")
AddEventHandler('grab', function(pl)
	
	otherid = tonumber(pl)
	local ped = GetPlayerPed(-1)
	local ped1 = GetPlayerPed(GetPlayerFromServerId(otherid))
	local x,y,z = table.unpack(GetEntityCoords(ped))
	
	if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  5) then
	
		grab = not grab
		
		if (grab == false) then
			DetachEntity(GetPlayerPed(-1), true, false)	
	    else
			TriggerEvent("chatMessage", "[DOJ GRAB]", {255, 255, 255}, "Grabbed!")
	    end 
	end
	
end)


RegisterNetEvent("grabNearClient")
AddEventHandler('grabNearClient', function()
	
	local ped = GetPlayerPed(-1)
	local nearestPlayer = GetNearestPlayerToEntity(ped)
	local entityType = GetEntityType(ped)
	
	shortestDistance = 2
	closestId = 0
	
	for id = 0, 32 do
        if NetworkIsPlayerActive( id ) and GetPlayerPed(id) ~= GetPlayerPed(-1) then
			ped1 = GetPlayerPed( id )
			local x,y,z = table.unpack(GetEntityCoords(ped))
                if (GetDistanceBetweenCoords(GetEntityCoords(ped1), x,y,z) <  shortestDistance) then
					
					shortestDistance = GetDistanceBetweenCoords(GetEntityCoords(ped), x,y,z)
					closestId = GetPlayerServerId(id)	
							
			
				end
				
        end		
	end
		
    if (closestId ~= nil) then
		TriggerServerEvent("grabNear", closestId)
	else
		 TriggerEvent("chatMessage", "[DOJ GRAB]", {255, 255, 255}, "No one found!")
	end
end)



Citizen.CreateThread(function()
	while true do

		if grab then
			
			local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
			local myped = GetPlayerPed(-1)
			
			
			AttachEntityToEntity(myped, ped, 11816, 0.45, 0.35, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end
		Citizen.Wait(0)
	end
end)
