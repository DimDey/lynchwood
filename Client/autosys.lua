local MaxFuel = 100
local decreasing = 0.000005
local speedometerTexture = dxCreateRoundedTexture(screenW * 0.8194, screenH * 0.7100, screenW * 0.1590, screenH * 0.2467, 10, "Images/speedbg.png")

local gasStationsCords = {
    {0,0,12.5,100}
}

local gasStations = {}

function createGasStationCols()
    for i, gasTable in ipairs(gasStationsCords) do
        local col = colshape:create(createColSphere,nil,nil,gasTable[1], gasTable[2], gasTable[3],gasTable[4])
        gasStations[i] = col
    end
end
addEventHandler("onClientResourceStart",resourceRoot,createGasStationCols)

function engineCheck(theVehicle)
    if itHaveVehicleKeys(theVehicle) then
        vehCheck(theVehicle)
    end
end

function itHaveVehicleKeys(vehicle)
    local keys = false
    if getElementData(vehicle,"pid") == getElementData(lp, "tableid") then
        keys = true
    elseif getElementData(vehicle, "frid") == getElementData(lp, "faction") then
        keys = true
    end
    return keys
end

function vehCheck(theVehicle)
    if tonumber(getElementData(theVehicle,"broken")) == 0 then
        if getElementData(theVehicle,"fuel") > 0 then
            setVehicleEngineState(theVehicle, not(getVehicleEngineState(theVehicle)))
        end
    else
        setVehicleEngineState(theVehicle, false)
    end
end

function beltCheck(theVehicle)
    local belt = getElementData(theVehicle,"belt")
    setElementData(theVehicle, "belt",not(belt))
end

function lightCheck(theVehicle)
    if itHaveVehicleKeys(theVehicle) then
        local state = getVehicleOverrideLights(theVehicle)
        if ( state ~= 2 ) then
            setVehicleOverrideLights ( theVehicle, 2 )
        else
            setVehicleOverrideLights ( theVehicle, 1 )
        end
    end
end

function fuelsysCheck(theVehicle)
    for i=1, #gasStations do
        local elements = getElementsWithinColShape(gasStations[i],"vehicle")
        for _,veh in ipairs(elements) do
            if veh == theVehicle then
                local fuel = getElementData(veh,"fuel")
                if not(fuel >= MaxFuel) then
                    setElementData(theVehicle,"fuel",100)
                end
            end
        end
    end
end

local vehBtnFunctions = {
    {"2",engineCheck},
    {"l",beltCheck},
    {"lctrl",lightCheck},
    {"x",fuelsysCheck}
}


function onPlayerInVehKey(btn,press)
    if press then
        local theVehicle = getPedOccupiedVehicle ( lp )
	    if theVehicle then
            for i=1,#vehBtnFunctions do
                if btn == vehBtnFunctions[i][1] then
                    vehBtnFunctions[i][2](theVehicle)
                end
            end
        end
	end
end
addEventHandler( "onClientKey", root, onPlayerInVehKey)

function vehicleRemoveFuel()
    local veh = getPedOccupiedVehicle(lp)
    if veh then
        if getVehicleEngineState(veh) then
            local speedx, speedy, speedz = getElementVelocity ( veh )
            local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
            local localkmh = actualspeed * 180
            local newFuel = getElementData(veh,"fuel")-decreasing*localkmh
            setElementData(veh,"fuel",newFuel)
            local odometer = localkmh/newFuel/180 + getElementData(veh,"odometer")
            setElementData(veh,"odometer",odometer)
        end
        if getElementData(veh,"fuel") <= 0 then
            setVehicleEngineState(veh, false)
            toggleControl( 'accelerate', not(isControlEnabled('accelerate')) )
            toggleControl( 'brake_reverse', not(isControlEnabled('brake_reverse')) )
        end
    end
end
addEventHandler( "onClientRender",root, vehicleRemoveFuel )


function onVehDamage(attacker,weap,loss,atx,aty,atz)
    local speedx, speedy, speedz = getElementVelocity ( source )
    local player = getVehicleOccupant(source)
    local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
    local localkmh = actualspeed * 180
    if player == lp then
        if loss > 100 then
            local x,y,z = getElementPosition(player)
            fadeCamera(false,0)
            local phealth = getElementHealth(player)
            setElementHealth(player,phealth-loss/25)
            toggleControl ( "accelerate", false ) -- disable the accelerate key
            toggleControl ( "brake_reverse", false ) -- disable the brake_reverse key
            toggleControl ( "handbrake", false ) -- disable the handbrake key
            toggleControl ( "enter_exit", false )
            startLoad("Audio/zvonvushax.mp3")
            startLoad("Audio/serdce.mp3")
            incidentetime = getTickCount()
            zvon = playSound("Audio/zvonvushax.mp3")
            sedce = playSound("Audio/serdce.mp3")
            setSoundVolume(zvon,0.3)
            setSoundVolume(sedce,1)
            if getElementData(source,"belt") == true then
                createVehTimer(2000)
                timer = 2000
            else
                createVehTimer(5000)
                timer = 5000
            end
            addEventHandler("onClientRender",root,dxDrawIncidente)
            if bgmusic ~= nil then stopSound(bgmusic) end
            PlayerSettings["camerafaded"] = true
        end
    end
    if getElementHealth(source) <= 400 and getElementData(source, "broken") ~= 1 then
        setElementData( source, "broken",1 )
        setVehicleDamageProof(source,true)
        setVehicleEngineState(source,false)
    end
end
addEventHandler("onClientVehicleDamage",root,onVehDamage)

function createVehTimer(interval)
    setTimer(function()
        fadeCamera(true,interval/1000)
        toggleControl ( "accelerate", true ) -- disable the accelerate key
        toggleControl ( "brake_reverse", true ) -- disable the brake_reverse key
        toggleControl ( "handbrake", true ) -- disable the handbrake key
        toggleControl ( "enter_exit", true )
        removeEventHandler("onClientRender",root,dxDrawIncidente)
    end,interval,1)
end

function dxDrawIncidente()
    local now = getTickCount()
    local endTime = incidentetime + timer
    local elapsedTime = now - incidentetime
    local duration = endTime - incidentetime
    local progress = elapsedTime / duration
    local timeToEnd = endTime - now
    local width, x = interpolateBetween ( 395, screenW * 0.3868, 0, 0, (screenW * 0.3868)+197.5, 0, progress, "Linear")

    dxDrawText("БЕЗ СОЗНАНИЯ", screenW * 0.3806, screenH * 0.0233, 962, 69, white, 1, font_montmediumXX, "center", "center")
    dxDrawImage(screenW * 0.5049, screenH * 0.0878, 61, 61, "Images/icon-sleep.png")
    dxDrawRectangle(x, screenH * 0.1833, width, 2, Colors["general"])
    dxDrawRectangle(screenW * 0.3868, screenH * 0.1833, 395, 2, tocolor(21,185,25,100))
    dxDrawText(math.round((timeToEnd/1000),1), screenW * 0.4931, screenH * 0.1978, screenW * 0.5653, screenH * 0.2311, white, 1.00, font_montmediumXX, "center", "top", false, false, false, false, false)
end

function drawNeedle()
    if not isPedInVehicle(localPlayer) then
        hideSpeedometer()
    end
    local vehSpeed = getVehicleSpeed()
    local vehHealth = getElementHealth(getPedOccupiedVehicle(localPlayer))
    local odometer = getElementData(getPedOccupiedVehicle(localPlayer),"odometer")

    dxDrawImage(screenW * 0.7986, screenH * 0.6800, 256, 256, "Images/disc.png" )
    dxDrawText(math.floor(vehSpeed), screenW * 0.8764, screenH * 0.8522, screenW * 0.9028, screenH * 0.8833, white, 1, font_montmediumL, "center", "center")
    dxDrawImage(screenW * 0.7986, screenH * 0.6800, 256, 256, "Images/needle.png", vehSpeed-5, 0, 0, white, true)
    local zeros = ""
    local odometerfl = math.floor(odometer)
    if 7-string.len(odometerfl) > 0 then
        zeros = string.rep("0",7-string.len(odometerfl))
    end
    
    dxDrawText(zeros..math.floor(odometerfl), screenW * 0.8576, screenH * 0.9100, screenW * 0.9111, screenH * 0.9311, white, 1, font_montmediumL, "right", "center")
end

function showSpeedometer()
    addEventHandler("onClientRender", root, drawNeedle)
end
function hideSpeedometer()
	removeEventHandler("onClientRender", root, drawNeedle)
end

function getVehicleSpeed()
    if isPedInVehicle(localPlayer) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 180
    end
    return 0
end


addEventHandler("onClientVehicleEnter", root,
	function(thePlayer)
		if thePlayer == localPlayer then
			showSpeedometer()
		end
	end
)

addEventHandler("onClientVehicleStartExit", root,
	function(thePlayer)
		if thePlayer == localPlayer then
			hideSpeedometer()
		end
	end
)

function onCarshopMarkerHit()
    outputDebugString("TEST")
end
addEvent("openCarshopMenu",true)
addEventHandler("openCarshopMenu",root,onCarshopMarkerHit)