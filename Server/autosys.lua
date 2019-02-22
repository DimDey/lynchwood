function parseFactionVehicles(res)
	if res == resorceRoot then
		local query = dbQuery(parseFactionCallback,dbHandle,"SELECT * FROM `vehicles` WHERE `faction`")
		outputServerLog("Parsing faction vehicles...")
	end
end
addEventHandler("onResourceStart", root, parseFactionVehicles)

function parseFactionCallback(qh)
	local result = dbPoll(qh, 0)
	if result then
		for _,row in ipairs(result) do
			local veh = createVehicle(row.modelid,row.sx,row.sy,row.sz,row.rx,row.ry,row.rz,row.number)
			setVehicleEngineState(veh, false)
			setElementData( veh,"frid",row.faction )
			setElementData( veh,"fuel",row.fuel )
			setElementData( veh,"id",row.carid )
			setVehicleColor( veh,row.r,row.g,row.b )
			setElementData( veh, "broken",row.broken )
			setElementData( veh, "odometer", row.odometer )
            if row.broken == 1 then
				setElementHealth( veh, 400 )
				setVehicleDamageProof(veh,true)
            end
		end
	end
	outputServerLog("Faction vehicles parsed!")
	dbFree(qh)
end

function parsePlayerVehicles(table)
    local qh = dbQuery(function(qh,table)
		local result = dbPoll(qh,0)
		if result then
			for k,row in ipairs(result) do
				local veh = createVehicle(row.modelid,row.sx,row.sy,row.sz,row.rx,row.ry,row.rz,row.number)
				setVehicleEngineState( veh, false )
				setElementData( veh,"pid",row.playerid )
                setElementData( veh,"fuel",row.fuel )
				setElementData( veh, "broken", row.broken )
				setElementData( veh, "odometer", row.odometer )
                if row.broken == 1 then
					setElementHealth( veh, 400 )
					setVehicleDamageProof(veh,true)
                end
				setElementData(veh, "id",row.carid)
				setVehicleColor(veh,row.r,row.g,row.b)
			end
		end
		
	end,{table},dbHandle,"SELECT * FROM `vehicles` WHERE playerid='"..table.id.."'")
end

function updateVehData(veh,seat,thePlayer)
    if seat == 0 then
        local broken = getElementData(veh,"broken")
		local fuel = getElementData(veh,"fuel")
		local odometer = getElementData(veh,"odometer")
        local id = getElementData(veh,"id")
		dbExec(dbHandle,"UPDATE `vehicles` SET `fuel` = '"..fuel.."', `broken`='"..broken.."', `odometer`='"..odometer.."' WHERE `carid` = "..id..";")
	end
end
addEventHandler("onPlayerVehicleExit",root,updateVehData)

function onCarshopMarkerHit(el)
	if getElementType(source) == "player" then
		triggerClientEvent(source,"openCarshopMenu",source,carshops[getElementData(el,"shopid")])
	end
end

function parseCarshops()
	if getDbConnection() then
		if #carshops > 0 then table.clear(carshops) end
		outputServerLog("Parsing carshops...")
		local qh = dbQuery(function(qh)
			local result = dbPoll(qh,-1)
			if result then
				for col,row in ipairs(result) do
					local settings = fromJSON(row.settings)
					local mark = createMarker(settings["x"], settings["y"], settings["z"],"cylinder", 1)
					addEventHandler("onPlayerMarkerHit",root, onCarshopMarkerHit)
					setElementData(mark,"shopid",col)
					carshops[col] = settings
				end
				outputServerLog("Parsing carshops: SUCCESS!")
			else
				outputServerLog("Parsing carshops: FAILED!")
			end
		end,dbHandle,"SELECT * from `carshops`")
	end
end
addEventHandler("onResourceStart",resourceRoot,parseCarshops)