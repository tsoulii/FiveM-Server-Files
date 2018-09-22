local m = {} -- <<< Don't touch this!
-----------[ SETTINGS ]---------------------------------------------------

-- Delay in minutes between messages
m.delay = 2

-- Prefix appears in front of each message. 
-- Suffix appears on the end of each message.
-- Leave a prefix/suffix empty ( '' ) to disable them.
m.prefix = '^1[ATTENTION:] '
m.suffix = ''

-- You can make as many messages as you want.
-- You can use ^0-^9 in your messages to change text color.
m.messages = {   
    '^1Please go to www.cad-lossantoscounty.usa.cc to register your civilian to be a legal citizen.',
	'^1If you do not register on the site and you are pulled over or arrested, we will give you 1 chance to register. You will not be released until you have registered and your identity has been confirmed.',
	'Use F10 for trainer to change your skin. Weapons and Vehicles spawning is disabled. Need one, go buy it at the weapon store (for guns) or garage (for vehicles).',
	'Any weapon larger than a pistol is illegal.',
    'Press K to use the menu.',
    'Stick to the RP areas unless directed by the Admins.',
    '^1Stealing Emergency Service Vehicles is FailRP and you will be kicked/banned.',
    'Want to chat with us? Join us on TeamSpeak:  ^1lscl.ts.io',
	'Civilians - type /setinv to set your vehicle inventory',
	'Civilians - type /resetinv to remove your inventory',
}

-- Player identifiers on this list will not receive any messages.
-- Simply remove all identifiers if you don't want an ignore list.
m.ignorelist = { 
    'ip:127.0.1.5',
    'steam:123456789123456',
    'license:1654687313215747944131321',
}
--------------------------------------------------------------------------


















-----[ CODE, DON'T TOUCH THIS ]-------------------------------------------
local playerIdentifiers
local enableMessages = true
local timeout = m.delay * 1000 * 60 -- from ms, to sec, to min
local playerOnIgnoreList = false
RegisterNetEvent('va:setPlayerIdentifiers')
AddEventHandler('va:setPlayerIdentifiers', function(identifiers)
    playerIdentifiers = identifiers
end)
Citizen.CreateThread(function()
    while playerIdentifiers == {} or playerIdentifiers == nil do
        Citizen.Wait(1000)
        TriggerServerEvent('va:getPlayerIdentifiers')
    end
    for iid in pairs(m.ignorelist) do
        for pid in pairs(playerIdentifiers) do
            if m.ignorelist[iid] == playerIdentifiers[pid] then
                playerOnIgnoreList = true
                break
            end
        end
    end
    if not playerOnIgnoreList then
        while true do
            for i in pairs(m.messages) do
                if enableMessages then
                    chat(i)
                    print('[vAnnouncer] Message #' .. i .. ' sent.')
                end
                Citizen.Wait(timeout)
            end
            
            Citizen.Wait(0)
        end
    else
        print('[vAnnouncer] Player is on ignorelist, no announcements will be received.')
    end
end)
function chat(i)
    TriggerEvent('chatMessage', '', {255,255,255}, m.prefix .. m.messages[i] .. m.suffix)
end
RegisterCommand('automessage', function()
    enableMessages = not enableMessages
    if enableMessages then
        status = '^2enabled^5.'
    else
        status = '^1disabled^5.'
    end
    TriggerEvent('chatMessage', '', {255, 255, 255}, '^5[vAnnouncer] automessages are now ' .. status)
end, false)
--------------------------------------------------------------------------
