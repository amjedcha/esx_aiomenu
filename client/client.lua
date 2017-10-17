ESX = nil

--ESX base
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)
--===============================================
--==                 VARIABLES                 ==
--===============================================
local Vehicle = GetVehiclePedIsIn(ped, false)
local inVehicle = IsPedSittingInAnyVehicle(ped)
local lastCar = nil	
local myIdentity = {}
local myWarrants = {}
local myIdentifiers = {}
local guiEnabled = false
--===============================================
--==                 THREADING                 ==
--===============================================
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if IsControlJustPressed(1, 10) then
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped, true) then 
				SendNUIMessage({type = 'showVehicleButton'})
			else 
				SendNUIMessage({type = 'hideVehicleButton'})
			end		
		end
        
		if IsControlJustPressed(1, 322) then
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
end)

--===============================================
--== NUIFocusoff                               ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)

--================================================================================================
--==                                 General Actions GUI                                        ==
--================================================================================================
RegisterNUICallback('NUIGenActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openGeneral'})
end)

--===============================================
--== Show ID                                   ==
--===============================================
RegisterNUICallback('toggleid', function(data)
	TriggerServerEvent('menu:id', myIdentifiers, data)
end)

--===============================================
--== Show Phone Number                         ==
--===============================================
RegisterNUICallback('togglephone', function(data)
	TriggerServerEvent('menu:phone', myIdentifiers, data)
end)

--===============================================
--== Engine On/Off                             ==
--===============================================
RegisterNUICallback('toggleEngineOnOff', function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then 
	if (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
	  if IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
		SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
		TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Engine is now ^1off^0.")
	  else
		SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
		TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Engine is now ^2on^0.")
	  end
	else 
	  ShowNotification("You have to be in the driver's seat of a vehicle!")
	end 
  end 
end)

--===============================================
--== Toggle Door Locks                         ==
--===============================================
RegisterNUICallback('toggleVehicleLocks', function()
  car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        
  if car ~= 0 then
    lastCar = car
  end
		
  lockStatus = GetVehicleDoorLockStatus(lastCar)
  if lastCar ~= nil then
    if lockStatus == 0 or lockStatus == 1 then
      SetVehicleDoorsLocked(lastCar, 2)
      SetVehicleDoorsLockedForPlayer(lastCar, PlayerId(), false)
      TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Door is now ^1locked^0.")
    elseif lockStatus == 2 then
      SetVehicleDoorsLocked(lastCar, 1)
      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
      TriggerEvent("chatMessage", "Info", {255, 255, 0}, "Door is now ^2unlocked^0.")
    end
  else
    TriggerEvent("chatMessage", "Info", {255, 255, 0}, "You don't have a car.")
  end
end)

--===============================================
--== Show ID                                   ==
--===============================================
RegisterNUICallback('showCharacters', function(data)
	TriggerServerEvent('menu:characters', data)
	cb(data)
end)

--================================================================================================
--==                                  ESX Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIESXActions', function(data)
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openESX'})
  SendNUIMessage({type = 'showInventoryButton'})
  SendNUIMessage({type = 'showPhoneButton'})
  SendNUIMessage({type = 'showBillingButton'})
  SendNUIMessage({type = 'showAnimationsButton'})
  
end)

--================================================================================================
--==                                  Rob Player Event                                          ==
--================================================================================================
RegisterNUICallback('toggleRob', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('menu:rob')
	else
		TriggerEvent('chatMessage', "No Player is nearby")
	end
end)


--===============================================
--== NUIopenInventory                          ==
--===============================================
RegisterNUICallback('NUIopenInventory', function()
	exports['es_extended']:openInventory()
end)

--===============================================
--== NUIopenPhone                              ==
--===============================================
RegisterNUICallback('NUIopenPhone', function()
	exports['esx_phone']:openPhone()
end)

--===============================================
--== NUIopenInvoices                           ==
--===============================================
RegisterNUICallback('NUIopenInvoices', function()
	exports['esx_billing']:openInvoices()
end)

--===============================================
--== NUIsetVoice                               ==
--===============================================
RegisterNUICallback('NUIsetVoice', function()
	exports['esx_voice']:setVoice()
end)

--===============================================
--== NUIopenAnimations                         ==
--===============================================
RegisterNUICallback('NUIopenAnimations', function()
	exports['esx_animations']:openAnimations()
end)

--================================================================================================
--==                                  Job Actions GUI                                           ==
--================================================================================================
RegisterNUICallback('NUIJobActions', function(data)
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openJobs'})
  local job = tostring(exports['esx_policejob']:getJob())
  if job == 'police' then
      SendNUIMessage({type = 'showPoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'ambulance' then
      SendNUIMessage({type = 'showAmbulanceButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'taxi' then
      SendNUIMessage({type = 'showTaxiButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideMechanicButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'mecano' then
      SendNUIMessage({type = 'showMechanicButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
	  SendNUIMessage({type = 'hideFireButton'})
  elseif job == 'fire' then
	  SendNUIMessage({type = 'showFireButton'})  
      SendNUIMessage({type = 'hideMechanicButton'})
      SendNUIMessage({type = 'hidePoliceButton'})
      SendNUIMessage({type = 'hideAmbulanceButton'})
      SendNUIMessage({type = 'hideTaxiButton'})
  else
    SendNUIMessage({type = 'hidePoliceButton'})
    SendNUIMessage({type = 'hideAmbulanceButton'})
    SendNUIMessage({type = 'hideTaxiButton'})
    SendNUIMessage({type = 'hideMechanicButton'})
	SendNUIMessage({type = 'hideFireButton'})
  end
end)

--===============================================
--== NUIopenAmbulanceActions                   ==
--===============================================
RegisterNUICallback('NUIopenAmbulance', function()
	exports['esx_ambulancejob']:openAmbulance()
end)

--===============================================
--== NUIopenPoliceActions                      ==
--===============================================
RegisterNUICallback('NUIopenPolice', function()
	exports['esx_policejob']:openPolice()
end)


--===============================================
--== NUIJailMenu		                       ==
--===============================================
RegisterNUICallback('NUIopenJail', function()
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openJail'})
end)

--===============================================
--== NUIWarrantMenu		                       ==
--===============================================
RegisterNUICallback('NUIopenWarrant', function()

	ESX.TriggerServerCallback('getWarrantsList', function(warrants)
		local player1 = {}
		    for i=1, #warrants, 1 do
            table.insert(player1, {
					id = warrants[i].id,
					fullname = warrants[i].fullname,
					crimes = warrants[i].crimes
            })
			
			end
	
			
			
	
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openWarrant', players = player1})
	end)
end)

--===============================================
--== NUIopenMechanicActions                    ==
--===============================================
RegisterNUICallback('NUIopenMechanic', function()
	exports['esx_mecanojob']:openMechanic()
end)

--===============================================
--== NUIopenMechanicActions                    ==
--===============================================
RegisterNUICallback('NUIopenTaxi', function()
	exports['esx_taxijob']:openTaxi()
end)

--===============================================
--== NUIopenFireActions                        ==
--===============================================
RegisterNUICallback('NUIopenFire', function()
	exports['esx_firejob']:openFire()
end)

--===============================================
--== NUItoggleCuff                             ==
--===============================================
RegisterNUICallback('NUItoggleCuff', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		exports['esx_policejob']:toggleCuff()
	else
		SetTextComponentFormat('STRING')
	    AddTextComponentString("~r~ No player nearby")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)

--===============================================
--== NUItoggleDrag                             ==
--===============================================
RegisterNUICallback('NUItoggleDrag', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		exports['esx_policejob']:toggleDrag()
	else
		SetTextComponentFormat('STRING')
	    AddTextComponentString("~r~ No player nearby")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)

--===============================================
--== NUItoggleInVehicle                        ==
--===============================================
RegisterNUICallback('NUItoggleIn', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		exports['esx_policejob']:toggleIn()
	else
		SetTextComponentFormat('STRING')
	    AddTextComponentString("~r~ No player nearby")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)


--===============================================
--== NUItoggleRevive	                       ==
--===============================================
RegisterNUICallback('NUItoggleRevive', function()
	exports['esx_ambulancejob']:toggleRevive()
end)


--===============================================
--== Jail NUI                                  ==
--===============================================
RegisterNUICallback('jail', function(data, cb)
  TriggerServerEvent('jail:fine', tonumber(data.playerID), data.crimes, tonumber(data.jailT), tonumber(data.jailF))
  TriggerServerEvent('jail:history', tonumber(data.playerID), data.crimes, tonumber(data.jailT))
  cb('ok')
end)






RegisterNetEvent('jail:fine')
AddEventHandler('jail:fine', function(jailT)
	local player2 = GetPlayerFromServerId(playerID)
	local playing = IsPlayerPlaying(player2)

	TriggerServerEvent("jail:fine", playerID, jailT, jailF)
	if check1 == true then
		return
	end
	local jailPlayer = GetPlayerPed(-1)
	TriggerEvent('chatMessage', "Jail Test: " ..jailPlayer)

	
	if DoesEntityExist(jailPlayer) then
		Citizen.CreateThread(function()
     
			
			while jailT > 0 and not check2 do
				jailPlayer = GetPlayerPed(-1)
				RemoveAllPedWeapons(jailPlayer, true)
				SetEntityInvincible(jailPlayer, true)
				if IsPedInAnyVehicle(jailPlayer, false) then
					ClearPedTasksImmediately(jailPlayer)
				end
				
				if jailT % 30 == 0 then
					SetTextComponentFormat('STRING')
					AddTextComponentString("~r~Time: " .. "~w~" ..math.floor(jailT/60) .. " Minutes left")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				end
				Citizen.Wait(500)
				
				local playerLocation = GetEntityCoords(jailPlayer, true)
				
				local entrap = Vdist(1677.233, 2658.618, 45.216, playerLocation['x'],playerLocation['y'],playerLocation['z'])
				
				if entrap > 60 then
					SetEntityCoords(jailPlayer, 1677.233, 2658.618, 45.216)
				end
				jailT = jailT - 0.5
			end
			
			
			
			TriggerEvent('chatMessage', "SYSTEM", { 0, 0, 0 }, GetPlayerName(PlayerId()) .." was released from jail.")
			SetEntityCoords(jailPlayer, 1855.807, 2601.949, 45.323)
			check1 = false
			SetEntityInvincible(jailPlayer, false)
		end)
	end
	
end)



--===============================================
--== Warrants NUI                                  ==
--===============================================
RegisterNUICallback('warrants', function(data, cb)
	TriggerEvent('warrant:new', data.fullname, data.crimes)
	cb('ok')
end)


RegisterNetEvent('warrant:new')
AddEventHandler('warrant:new', function(fullname, crimes)
	TriggerServerEvent('warrant:new', fullname, crimes)
end)

RegisterNUICallback('warrants:remove', function(data, cb)
	TriggerEvent('warrant:remove', data.warrantName)
	cb('ok')
end)
RegisterNetEvent('warrant:remove')
AddEventHandler('warrant:remove', function(warrantName)
	TriggerServerEvent('warrant:remove', warrantName)
end)


--===============================================
--== NUItoggleOutVehicle                       ==
--===============================================
RegisterNUICallback('NUItoggleOut', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		exports['esx_policejob']:toggleOut()
	else
		SetTextComponentFormat('STRING')
	    AddTextComponentString("~r~ No player nearby")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)



--===============================================
--== NUItoggleImpoundVehicle                   ==
--===============================================
RegisterNUICallback('NUItoggleImpound', function()
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local vehiclePos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 40.0, 0.0)
	
	local rayHandle = CastRayPointToPoint(pos.x, pos.y,pos.z, vehiclePos.x, vehiclePos.y, vehiclePos.z, 10, GetPlayerPed(-1), 0)
	local a,b,c,d, vehicle = GetRaycastResult(rayHandle)
	
	
	if DoesEntityExist(vehicle) then
		SetTextComponentFormat('STRING')
		AddTextComponentString("~y~Impounding Vehicle...")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		Wait(3000)
		exports['es_extended']:toggleImpound()
	else
		SetTextComponentFormat('STRING')
		AddTextComponentString("~r~Not Near a Vehicle...")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)

--===============================================
--== NUItoggleSearchPlayer                     ==
--===============================================
RegisterNUICallback('NUItoggleSearchPlayer', function()
	local player, distance = ESX.Game.GetClosestPlayer()
	if distance ~= -1 and distance <= 3.0 then
		exports['esx_policejob']:toggleSearchPlayer()
	else
		SetTextComponentFormat('STRING')
	    AddTextComponentString("~r~ No player nearby")
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
	end
end)




--================================================================================================
--==                                 Vehicles Actions GUI                                        ==
--================================================================================================
RegisterNUICallback('NUIVehicleActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openVehicles'})
end)

--================================================================================================
--==                                   Door Actions GUI                                         ==
--================================================================================================
RegisterNUICallback('NUIDoorActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openDoorActions'})
end)

RegisterNUICallback('toggleFrontLeftDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 0, false)            
       else
         SetVehicleDoorOpen(playerVeh, 0, false)             
      end
   end
end)

RegisterNUICallback('toggleFrontRightDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 1, false)            
       else
         SetVehicleDoorOpen(playerVeh, 1, false)             
      end
   end
end)

RegisterNUICallback('toggleBackLeftDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 2, false)            
       else
         SetVehicleDoorOpen(playerVeh, 2, false)             
      end
   end
end)

RegisterNUICallback('toggleBackRightDoor', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 3, false)            
       else
         SetVehicleDoorOpen(playerVeh, 3, false)             
      end
   end
end)

RegisterNUICallback('toggleHood', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 4, false)            
       else
         SetVehicleDoorOpen(playerVeh, 4, false)             
      end
   end
end)

RegisterNUICallback('toggleTrunk', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
      if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
         SetVehicleDoorShut(playerVeh, 5, false)            
       else
         SetVehicleDoorOpen(playerVeh, 5, false)             
      end
   end
end)

RegisterNUICallback('toggleWindowsUp', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
	 RollUpWindow(playerVeh, 0)
	 RollUpWindow(playerVeh, 1)
	 RollUpWindow(playerVeh, 2)
	 RollUpWindow(playerVeh, 3)
   end
end)

RegisterNUICallback('toggleWindowsDown', function()
   local playerPed = GetPlayerPed(-1)
   local playerVeh = GetVehiclePedIsIn(playerPed, false)
   if ( IsPedSittingInAnyVehicle( playerPed ) ) then
	 RollDownWindow(playerVeh, 0)
	 RollDownWindow(playerVeh, 1)
	 RollDownWindow(playerVeh, 2)
	 RollDownWindow(playerVeh, 3)
   end
end)

--================================================================================================
--==                                Windows Actions GUI                                         ==
--================================================================================================
RegisterNUICallback('NUIWindowActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openWindows'})
end)

--================================================================================================
--==                               Character Actions GUI                                        ==
--================================================================================================
RegisterNUICallback('NUICharActions', function()
  SetNuiFocus(true, true)
  SendNUIMessage({type = 'openCharacters'})
end)

RegisterNetEvent("menu:setCharacters")
AddEventHandler("menu:setCharacters", function(identity)
  myIdentity = identity
end)



RegisterNetEvent("menu:setIdentifier")
AddEventHandler("menu:setIdentifier", function(data)
  myIdentifiers = data
end)

RegisterNetEvent("menu:getSteamIdent")
AddEventHandler("menu:getSteamIdent", function(identity)
  if myIdentifiers.steamidentifier then
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is:" .. myIdentifiers.steamidentifier)
  else
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "Your steam identifier is nil. Please use /getID")
  end
end)





--===============================================
--== Button Events for List Characters         ==
--===============================================
RegisterNUICallback('NUIlistCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "listCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)

--===============================================
--== Button Events for Change Characters       ==
--===============================================
RegisterNUICallback('NUIchangeCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "changeCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)

RegisterNUICallback('NUISelChar1', function(data)
  TriggerServerEvent('menu:selectChar1', myIdentifiers, data)
  cb(data)
end)

RegisterNUICallback('NUISelChar2', function(data)
    TriggerServerEvent('menu:selectChar2', myIdentifiers, data)
    cb(data)
end)

RegisterNUICallback('NUISelChar3', function(data)
    TriggerServerEvent('menu:selectChar3', myIdentifiers, data)
    cb(data)
end)

--===============================================
--== Button Events for Delete Characters       ==
--===============================================
RegisterNUICallback('NUIdeleteCharacters', function(data)
  TriggerServerEvent('menu:setChars', myIdentifiers)
  Wait(1000)
  SetNuiFocus(true, true)
  local bt  = myIdentity.character1 --- Character 1 ---
  local bt2 = myIdentity.character2 --- character 2 ---
  local bt3 = myIdentity.character3 --- character 3 ---
  
  SendNUIMessage({
  type = "deleteCharacters",
  char1    = bt,
  char2    = bt2,
  char3    = bt3,
  backBtn  = "Back",
  exitBtn  = "Exit"
}) 
end)

RegisterNUICallback('NUInewCharacter', function(data)
  if myIdentity.character3 == "No Character" then
    exports['esx_identity']:openRegistry()
  else
    TriggerEvent("chatMessage", "^1[IDENTITY]", {255, 255, 0}, "You can only have 3 characters!")
  end
end)

RegisterNUICallback('NUIDelChar1', function(data)
  TriggerServerEvent('menu:deleteChar1', myIdentifiers, data)
  cb(data)
end)

RegisterNUICallback('NUIDelChar2', function(data)
    TriggerServerEvent('menu:deleteChar2', myIdentifiers, data)
    cb(data)
end)

RegisterNUICallback('NUIDelChar3', function(data)
    TriggerServerEvent('menu:deleteChar3', myIdentifiers, data)
    cb(data)
end)

RegisterNetEvent('sendProximityMessageID')
AddEventHandler('sendProximityMessageID', function(id, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "[ID]" .. "", {0, 153, 204}, "^7 " .. message)
  end
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
    TriggerEvent('chatMessage', "[Phone]^3(" .. name .. ")", {0, 153, 204}, "^7 " .. message)
  end
  
end)



