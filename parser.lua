local Vehicles = json.decode(LoadResourceFile(GetCurrentResourceName(), 'vehicles.json'))

local TypesWithClasses = {}

for i = 1, #Vehicles do
    local vehicle <const>      = Vehicles[i]
    local vehicleType <const>  = vehicle.Type
    local vehicleClass <const> = vehicle.Class
    local vehicleName <const>  = vehicle.Name
    local vehicleDisplayName = vehicle.DisplayName.Portuguese or (vehicle.DisplayName.English or vehicle.DisplayName.Name)

	if not TypesWithClasses[vehicleType] then TypesWithClasses[vehicleType] = {} end
	if not TypesWithClasses[vehicleType][vehicleClass] then TypesWithClasses[vehicleType][vehicleClass] = {} end

	-- Insert or update the display name for the vehicle in the class
	local classTable = TypesWithClasses[vehicleType][vehicleClass]
	local foundDuplicate = false

	for name, displayName in pairs(classTable) do
		if displayName:find("%(") then
			-- Already modified display name, check if it is the same vehicle display name
			if displayName:match("%((.-)%)"):find(vehicleName) then
				foundDuplicate = true
				break
			end
		elseif displayName == vehicleDisplayName then
			-- Found a duplicate display name, update both the current and the found one
			classTable[name] = displayName .. " (" .. name .. ")"
			vehicleDisplayName = vehicleDisplayName .. " (" .. vehicleName .. ")"
			foundDuplicate = true
			break
		end
	end

	if foundDuplicate then classTable[vehicleName] = vehicleDisplayName	end
end

lib.setClipboard(json.encode(TypesWithClasses, { indent = true }))