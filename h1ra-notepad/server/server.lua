local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject', function() if source ~= '' then return false end	QBCore = exports['qb-core']:GetCoreObject() end)

local Notes = {}


QBCore.Functions.CreateUseableItem("notepad", function(source, item) TriggerClientEvent("h1ra-notepad:Client:Create", source) end)

QBCore.Functions.CreateCallback('h1ra-notepad:Server:Sync', function(source, cb) cb(Notes) end)

RegisterNetEvent("h1ra-notepad:Server:Create", function(data)
	for k, v in pairs(data) do print(k, tostring(v)) end
	local charset = {
		"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",
		"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M",
		"1","2","3","4","5","6","7","8","9","0"
	}
	local GeneratedID = ""
	for i = 1, 12 do GeneratedID = GeneratedID..charset[math.random(1, #charset)] end

	local creator = QBCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname..' '..QBCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname

	DiscordLog(creator, data.message, 14177041)

	if tostring(data.anon) == "true" then creator = "Anonymous" end

	Notes[GeneratedID] = {
		id = GeneratedID,
		coords = data.coords,
		message = data.image or data.message,
		creator = creator,
	}


	discord = {
		['webhook'] = "",
		['name'] = 'Notepad',
		['image'] = "https://i.imgur.com/G3jeSZv.png"
	}
	
	function DiscordLog(name, message, color)
		local embed = {
			{
				["color"] = 04255,
				["title"] = "**Note Dropped:**",
				["description"] = message,
				["url"] = "",
				["footer"] = {
				["text"] = "Dropped by: "..name,
				["icon_url"] = ""
			},
				["thumbnail"] = {
					["url"] = "",
				},
			}
		}
		PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = embed, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
	end


	TriggerClientEvent("h1ra-notepad:Client:Sync", -1, Notes)
end)
RegisterNetEvent("h1ra-notepad:Server:Destroy", function(data) Notes[data] = nil TriggerClientEvent("h1ra-notepad:Client:Sync", -1, Notes) end)
RegisterNetEvent("h1ra-notepad:Server:Read", function(data) local src = source TriggerClientEvent("h1ra-notepad:Client:Read", src, Notes[data.noteid]) end)
RegisterNetEvent("h1ra-notepad:Server:Sync", function(coords) TriggerClientEvent("h1ra-notepad:Client:SyncEffect", -1, coords) end)
