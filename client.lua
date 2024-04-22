local ESX = exports.es_extended:getSharedObject()

local Vehicles = json.decode(LoadResourceFile(GetCurrentResourceName(), 'vehicles.json'))

local rootOptions = {}

for k, v in pairs(Vehicles) do
	local options = {}

	for kk, vv in pairs(v) do
		local menu = ('spawn:%s:%s'):format(k, kk)

		options[kk] = {
			title = kk,
			menu  = menu
		}

		local moarOptions = {}

		for kkk, vvv in pairs(vv) do
			moarOptions[kkk] = {
				title    = vvv,
				image    = ('https://docs.fivem.net/vehicles/%s.webp'):format(kkk),
				onSelect = function()
					ESX.Game.SpawnVehicle(joaat(kkk), GetEntityCoords(cache.ped), GetEntityHeading(cache.ped), function(vehicle)
						local currVehicle <const> = GetVehiclePedIsIn(cache.ped, false)
						if currVehicle ~= 0 then ESX.Game.DeleteVehicle(currVehicle) end

						SetPedIntoVehicle(cache.ped, vehicle, -1)
					end, true)
				end
			}
		end

		lib.registerContext({
			id      = menu,
			title   = kk,
			menu    = 'spawn:' .. k,
			options = moarOptions
		})
	end

	lib.registerContext({
		id      = 'spawn:' .. k,
		title   = k,
		menu    = 'spawnVehicle',
		options = options
	})

	rootOptions[k] = {
		title = k,
		menu  = 'spawn:' .. k
	}
end

lib.registerContext({
	id      = 'spawnVehicle',
	title   = 'Spawn de Veiculos',
	options = rootOptions
})

RegisterCommand('spawnveh', function() lib.showContext('spawnVehicle') end)