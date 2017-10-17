--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX = nil
local balances = {}
local user = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--================================================================================================
--==                                On Player Loaded Event                                      ==
--================================================================================================
AddEventHandler('es:playerLoaded', function(source)
  steamid = GetPlayerIdentifiers(source)[1]
  identification = {
    steamidentifier = steamid,
    playerid        = source
  }
  
  TriggerClientEvent('menu:setIdentifier', source, identification)
  
  getCharacters(source, function(data)
    if data ~= nil then
      if data.firstname1 ~= '' and data.firstname2 ~= '' and data.firstname3 ~= '' then
	    local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
	    local char2 = tostring(data.firstname2) .. " " .. tostring(data.lastname2)
	    local char3 = tostring(data.firstname3) .. " " .. tostring(data.lastname3)
				
	    characters = {
	      character1         = char1,
		  character2         = char2,
		  character3         = char3,
	    }
		  
		TriggerClientEvent('menu:setCharacters', source, characters)	
		
      elseif data.firstname1 ~= '' and data.firstname2 ~= '' and data.firstname3 == '' then
	    local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
	    local char2 = tostring(data.firstname2) .. " " .. tostring(data.lastname2)
	    local char3 = "No Character"
		
	    characters = {
	      character1         = char1,
		  character2         = char2,
		  character3         = char3,
	    }
		  
		TriggerClientEvent('menu:setCharacters', source, characters)	
		
      elseif data.firstname1 ~= '' and data.firstname2 == '' and data.firstname3 == '' then
      	local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
      	local char2 = "No Character"
      	local char3 = "No Character"
		
		identification = {
		  steamidentifier = steamid,
		  playerid        = source
		}
		
	    characters = {
	      character1         = char1,
		  character2         = char2,
		  character3         = char3,
	    }
		  
		TriggerClientEvent('menu:setCharacters', source, characters)	
		
      elseif data.firstname1 == '' and data.firstname2 == '' and data.firstname3 == '' then
      	local char1 = "No Character"
	    local char2 = "No Character"
      	local char3 = "No Character"
		
		
	    characters = {
	      character1         = char1,
		  character2         = char2,
		  character3         = char3,
	    }
		  
		TriggerClientEvent('menu:setCharacters', source, characters)	
		
      else
		
      	characters = {
      	  character1 = "No Character",
      	  character2 = "No Character",
      	  character3 = "No Character"
      	}
	  
      	TriggerClientEvent('menu:setCharacters', source, characters)		
		
      end
    end
  end)
end)

AddEventHandler('playerDropped', function()
  local _source = source
  balances[_source] = nil
  _source = nil
  user = nil
  source = nil
end)

--================================================================================================
--==                                   Functions - DO NOT EDIT                                  ==
--================================================================================================

--===============================================
--==           Get Identity                    ==
--===============================================
function getIdentity(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if result[1] ~= nil then
      local data = {
        identifier	= identifier,
        firstname	= result[1]['firstname'],
        lastname	= result[1]['lastname'],
        dateofbirth	= result[1]['dateofbirth'],
        sex			= result[1]['sex'],
        height		= result[1]['height'],
		phonenumber = result[1]['phone_number']
      }
			
      callback(data)
    else	
      local data = {
        identifier 	= '',
        firstname 	= '',
        lastname 	= '',
        dateofbirth = '',
        sex 		= '',
        height 		= '',
		phonenumber = ''
      }
			
      callback(data)
    end
  end)
end

--===============================================
--==           Get Characters                  ==
--===============================================
function getCharacters(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll("SELECT * FROM `characters` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if result[1] and result[2] and result[3] then
      local data = {
        identifier    = result[1]['identifier'],
        firstname1    = result[1]['firstname'],
        lastname1    = result[1]['lastname'],
        dateofbirth1  = result[1]['dateofbirth'],
        sex1      = result[1]['sex'],
        height1      = result[1]['height'],
        firstname2    = result[2]['firstname'],
        lastname2    = result[2]['lastname'],
        dateofbirth2  = result[2]['dateofbirth'],
        sex2      = result[2]['sex'],
        height2      = result[2]['height'],
        firstname3    = result[3]['firstname'],
        lastname3    = result[3]['lastname'],
        dateofbirth3  = result[3]['dateofbirth'],
        sex3      = result[3]['sex'],
        height3      = result[3]['height']
      }

      callback(data)
    elseif result[1] and result[2] and not result[3] then
      local data = {
        identifier    = result[1]['identifier'],
        firstname1    = result[1]['firstname'],
        lastname1    = result[1]['lastname'],
        dateofbirth1  = result[1]['dateofbirth'],
        sex1      = result[1]['sex'],
        height1      = result[1]['height'],
        firstname2    = result[2]['firstname'],
        lastname2    = result[2]['lastname'],
        dateofbirth2  = result[2]['dateofbirth'],
        sex2      = result[2]['sex'],
        height2      = result[2]['height'],
        firstname3    = '',
        lastname3    = '',
        dateofbirth3  = '',
        sex3      = '',
        height3      = ''
      }

      callback(data)
    elseif result[1] and not result[2] and not result[3] then
      local data = {
        identifier    = result[1]['identifier'],
        firstname1    = result[1]['firstname'],
        lastname1    = result[1]['lastname'],
        dateofbirth1  = result[1]['dateofbirth'],
        sex1      = result[1]['sex'],
        height1      = result[1]['height'],
        firstname2    = '',
        lastname2    = '',
        dateofbirth2  = '',
        sex2      = '',
        height2      = '',
        firstname3    = '',
        lastname3    = '',
        dateofbirth3  = '',
        sex3      = '',
        height3      = ''
      }

      callback(data)
    else
      local data = {
        identifier    = '',
        firstname1    = '',
        lastname1    = '',
        dateofbirth1  = '',
        sex1      = '',
        height1      = '',
        firstname2    = '',
        lastname2    = '',
        dateofbirth2  = '',
        sex2      = '',
        height2      = '',
        firstname3    = '',
        lastname3    = '',
        dateofbirth3  = '',
        sex3      = '',
        height3      = ''
      }

      callback(data)
    end
  end)
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

--===============================================
--==           Update Identity                 ==
--===============================================
function updateIdentity(source, data, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier",
    {
      ['@identifier']   = identifier,
      ['@firstname']    = data.firstname,
      ['@lastname']     = data.lastname,
      ['@dateofbirth']  = data.dateofbirth,
      ['@sex']          = data.sex,
      ['@height']       = data.height
    },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

--===============================================
--==           Delete Character                ==
--===============================================
function deleteCharacter(source, data, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.execute("DELETE FROM `characters` WHERE identifier = @identifier AND firstname = @firstname AND lastname = @lastname AND dateofbirth = @dateofbirth AND sex = @sex AND height = @height",
    {
      ['@identifier']   = identifier,
      ['@firstname']    = data.firstname,
      ['@lastname']     = data.lastname,
      ['@dateofbirth']  = data.dateofbirth,
      ['@sex']        = data.sex,
      ['@height']       = data.height
    },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

--================================================================================================
--==                                   Events - DO NOT EDIT                                     ==
--================================================================================================

RegisterServerEvent('menu:id')
AddEventHandler('menu:id', function(myIdentifiers)
  getIdentity(myIdentifiers.playerid, function(data)
    if data ~= nil then
	  TriggerClientEvent("sendProximityMessageID", -1, myIdentifiers.playerid, data.firstname .. " " .. data.lastname)
	end
  end)
end)

RegisterNetEvent('menu:phone')
AddEventHandler('menu:phone', function(myIdentifiers)
  getIdentity(myIdentifiers.playerid, function(data)
    if data ~= nil then
	  local name = data.firstname .. " " .. data.lastname
	  TriggerClientEvent("sendProximityMessagePhone", -1, myIdentifiers.playerid, name, data.phonenumber)
	end
  end)
end)

RegisterServerEvent('menu:setChars')
AddEventHandler('menu:setChars', function()
  local _source = source
  getCharacters(source, function(data)	
    if data ~= nil then
	  if data.firstname1 ~= '' and data.firstname2 ~= '' and data.firstname3 ~= '' then
	    getIdentity(source, function(result)
		  if result ~= nil then
		    local activeName = tostring(result.firstname) .. " " .. tostring(result.lastname)
	        local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
	        local char2 = tostring(data.firstname2) .. " " .. tostring(data.lastname2)
	        local char3 = tostring(data.firstname3) .. " " .. tostring(data.lastname3)
		      
			if activeName == char1 then
	          characters = {
	            character1 = char1 .. " [Active]",
		        character2 = char2,
		        character3 = char3
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
			elseif activeName == char2 then
	          characters = {
	            character1 = char1,
		        character2 = char2 .. " [Active]",
		        character3 = char3
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
			elseif activeName == char3 then
	          characters = {
	            character1 = char1,
		        character2 = char2,
		        character3 = char3 .. " [Active]"
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
		    else
			  characters = {
			    character1 = char1,
			    character2 = char2,
			    character3 = char3
		      }
				
			  TriggerClientEvent('menu:setCharacters', source, characters)
			end
		  else
			characters = {
			  character1 = char1,
			  character2 = char2,
			  character3 = char3
		    }
				
			TriggerClientEvent('menu:setCharacters', source, characters)
		  end
		end)
      elseif data.firstname1 ~= '' and data.firstname2 ~= '' and data.firstname3 == '' then
		getIdentity(source, function(result)
		  if result ~= nil then
			local activeName = tostring(result.firstname) .. " " .. tostring(result.lastname)
	        local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
	        local char2 = tostring(data.firstname2) .. " " .. tostring(data.lastname2)
	        local char3 = "No Character"
		      
			if activeName == char1 then
	          characters = {
	            character1 = char1 .. " [Active]",
		        character2 = char2,
		        character3 = char3
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
			elseif activeName == char2 then
	          characters = {
	            character1 = char1,
		        character2 = char2 .. " [Active]",
		        character3 = char3
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
			else
			  characters = {
				character1 = char1,
				character2 = char2,
				character3 = char3
		      }
				
			  TriggerClientEvent('menu:setCharacters', source, characters)
			end
		  else
			characters = {
			  character1 = char1,
		      character2 = char2,
		      character3 = char3
		    }
				
			TriggerClientEvent('menu:setCharacters', source, characters)
		  end
		end)
      elseif data.firstname1 ~= '' and data.firstname2 == '' and data.firstname3 == '' then
		getIdentity(source, function(result)
		  if result ~= nil then
			local activeName = tostring(result.firstname) .. " " .. tostring(result.lastname)
	        local char1 = tostring(data.firstname1) .. " " .. tostring(data.lastname1)
	        local char2 = "No Character"
	        local char3 = "No Character"
		      
			if activeName == char1 then
	          characters = {
	            character1 = char1 .. " [Active]",
		        character2 = char2,
		        character3 = char3
	          }	
		  
              TriggerClientEvent('menu:setCharacters', source, characters)
			else
			  characters = {
				character1 = char1,
				character2 = char2,
				character3 = char3
			  }
				
			  TriggerClientEvent('menu:setCharacters', source, characters)
			end
		  else
			characters = {
		      character1 = char1,
			  character2 = char2,
			  character3 = char3
		    }
				
			TriggerClientEvent('menu:setCharacters', source, characters)
		  end
		end)  
	  else	
	    characters = {
	      character1 = "No Character",
		  character2 = "No Character",
		  character3 = "No Character"
	    }  
		
		TriggerClientEvent('menu:setCharacters', source, characters)  
	  end
	end
  end)
end)


RegisterServerEvent('menu:deleteChar1')
AddEventHandler('menu:deleteChar1', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname1,
      lastname  = data.lastname1,
      dateofbirth  = data.dateofbirth1,
      sex      = data.sex1,
      height    = data.height1
    }
	
	if data.firstname ~= '' then
      deleteCharacter(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Have Deleted " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Delete Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 1!")
	end
  end)
end)

RegisterServerEvent('menu:deleteChar2')
AddEventHandler('menu:deleteChar2', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname2,
      lastname  = data.lastname2,
      dateofbirth  = data.dateofbirth2,
      sex      = data.sex2,
      height    = data.height2
    }
	
	if data.firstname ~= '' then
      deleteCharacter(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Have Deleted " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Delete Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 2!")
	end
  end)
end)

RegisterServerEvent('menu:deleteChar3')
AddEventHandler('menu:deleteChar3', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname3,
      lastname  = data.lastname3,
      dateofbirth  = data.dateofbirth3,
      sex      = data.sex3,
      height    = data.height3
    }
	
	if data.firstname ~= '' then
      deleteCharacter(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Have Deleted " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Delete Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 3!")
	end
  end)
end)

RegisterServerEvent('menu:selectChar1')
AddEventHandler('menu:selectChar1', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname1,
      lastname  = data.lastname1,
      dateofbirth  = data.dateofbirth1,
      sex      = data.sex1,
      height    = data.height1
    }
	
	if data.firstname ~= '' then
      updateIdentity(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Are Now " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Update Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 1!")
	end
  end)
end)

RegisterServerEvent('menu:selectChar2')
AddEventHandler('menu:selectChar2', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname2,
      lastname  = data.lastname2,
      dateofbirth  = data.dateofbirth2,
      sex      = data.sex2,
      height    = data.height2
    }
	
	if data.firstname ~= '' then
      updateIdentity(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Are Now " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Update Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 2!")
	end
  end)
end)

RegisterServerEvent('menu:selectChar3')
AddEventHandler('menu:selectChar3', function()
  local _source = source
  getCharacters(source, function(data)	
    local data = {
      identifier   = data.identifier,
      firstname  = data.firstname3,
      lastname  = data.lastname3,
      dateofbirth  = data.dateofbirth3,
      sex      = data.sex3,
      height    = data.height3
    }
	
	if data.firstname ~= '' then
      updateIdentity(source, data, function(callback)
	    if callback == true then
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "You Are Now " .. data.firstname .. " " .. data.lastname .. "!")
		else
		  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "Failed To Update Identity!")
		end
	  end)
	else
	  TriggerClientEvent('chatMessage', source, "[IDENTITY]", {255, 0, 0}, "No Character In Slot 3!")
	end
  end)
end)

--===============================================
--== Jail/Fine Event						   ==
--===============================================
RegisterServerEvent('jail:fine')
local _source = source
AddEventHandler('jail:fine', function(playerID, jailT, jailF)
	local xPlayer = ESX.GetPlayerFromId(tonumber(playerID))
	TriggerClientEvent('chatMessage', playerID, 'You have been fined $' .. tonumber(jailF) .. " by the state.")
    xPlayer.removeAccountMoney('bank', tonumber(jailF))
	TriggerClientEvent("jail:fine", tonumber(playerID), tonumber(jailT))

end)




	

--===============================================
--== Warrant List Event						   ==
--===============================================



RegisterServerEvent('revivePlayer')
AddEventHandler('revivePlayer', function(target)
	TriggerClientEvent('menu:revive', target)
end)


--===============================================
--== Warrants Event						   ==
--===============================================
RegisterServerEvent('warrant:new')
local _source = source
AddEventHandler('warrant:new', function(fullname, crimes)
	
	TriggerClientEvent('chatMessage', source, "[WARRANT ADDED]", {255, 0, 0},fullname ..'- '.. crimes )
	 MySQL.Async.execute(
    'INSERT INTO warrants (fullname, crimes) VALUES (@fullname, @crimes)',
    {
      ['@fullname'] = fullname,
      ['@crimes']  = crimes
    })

end)




ESX.RegisterServerCallback('getWarrantsList', function(source, cb)

  MySQL.Async.fetchAll(
    'SELECT * FROM warrants',
    {
    },
    function(warrants)
      cb(warrants)
    end
  )

end)



RegisterServerEvent('warrant:remove')
AddEventHandler('warrant:remove', function(warrantName)
	TriggerClientEvent('chatMessage', source, "[WARRANT DELETED]", {255, 0, 0})
	MySQL.Async.execute("DELETE FROM `warrants` WHERE id = @id",
		{
		  ['@id']   = warrantName,
		},
		 function(done)
		if callback then
		  callback(true)
		end

	end)
end)

--===============================================
--== /charselect 1,2,3 Select Your Active Char ==
--===============================================
TriggerEvent('es:addCommand', 'getID', function(source, args, user)

  identification = {
    steamidentifier = GetPlayerIdentifiers(source)[1],
	playerid        = source
  }
		
  TriggerClientEvent('menu:setIdentifier', source, identification)	
end)











RegisterServerEvent('jail:history')

AddEventHandler('jail:history', function(playerID, crimes, jailT)
	local _source = source
	local identifier = GetPlayerIdentifiers(playerID)[1]

			MySQL.Async.execute("UPDATE characters SET history = @history WHERE identifier = @identifier",
		{
			['@identifier'] = identifier,
		  ['@history']  = crimes
		 
		  
		}	, function(done)
		if callback then
		  callback(true)
		end

	end)
	
		
			

end)