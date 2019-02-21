-- Сделано не мной, делал про паблик скрипту

local settings = {
    
    displayScale = 0.3*screenH, -- ширина радара
    aspectRatio = 3/2, -- Соотношение 3: 2, высота - масштаб дисплея, деленный на это
    safeX = 0.025*screenW, -- отступ слева
    safeY = 0.025*screenH, -- отступ снизу

    map = {
        image = "Images/radar_map.jpg",
        alwaysRender = false, -- false = рендер только тогда, когда игрок не в инте
        backgroundColor = tocolor(61, 134, 211), -- цвет воды на фоне					 
    },
    bar = { -- настройки баров хп, брони и т.д
        backgroundAlpha = 50,
        valueAlpha = 100,
    },
    healthbar = {
        colorNormal = {102, 204, 102},
        colorLow = {200, 200, 0},
        colorCritical = {200, 0, 0},
    },
    armorbar = { 
        color = {0, 102, 255},
    },
    oxygenbar = {
        alwaysRender = false, -- false = только тогда, когда у игрока меньше 100% кислорода
        color = {255, 255, 0},
    },
    blips = {
        enabled = true,
        sizeFactor = 10,
        northBlip = true,
        drawProjectiles = true,
        projectilesAll = false,
        projectileColor = tocolor(255, 0, 0)
    },
}

local maprendertarget = dxCreateRenderTarget(290, 290/settings.aspectRatio) -- таргет радара
local rtW, rtH = dxGetMaterialSize(maprendertarget)

local map = dxCreateTexture(settings.map.image, "dxt5", true, "wrap") -- превращаем картинку в текстуру
local mW, mH = dxGetMaterialSize(map) -- размер текстуры

local mapScaleFactor = 6000/mW -- размер карты?
local mapDisplayWidth = settings.displayScale -- ширина карты?
local mapDisplayHeight = settings.displayScale / settings.aspectRatio -- высота карты?

local armorBg = tocolor(settings.armorbar.color[1], settings.armorbar.color[2], settings.armorbar.color[3], settings.bar.backgroundAlpha)
local armorVal = tocolor(settings.armorbar.color[1], settings.armorbar.color[2], settings.armorbar.color[3], settings.bar.valueAlpha)
local oxygenBg = tocolor(settings.oxygenbar.color[1], settings.oxygenbar.color[2], settings.oxygenbar.color[3], settings.bar.backgroundAlpha)
local oxygenVal = tocolor(settings.oxygenbar.color[1], settings.oxygenbar.color[2], settings.oxygenbar.color[3], settings.bar.valueAlpha)

local function getMaxHealth()
    return 100 + (getPedStat(lp, 24) - 569) / 4.31
end

local function getMaxOxygen()
    return 1000 + getPedStat(lp, 225) * 1.5
end
-- Это.видимо, переменные стриминга радара, они увеличиваются в getRadarRadius, если игрок сидит в авто.
local minVel = 0.3
local minDist = 1
local maxVel = 1
local maxDist = 1/2
local ratio = (maxDist-minDist)/(maxVel-minVel)

local function getRadarRadius()
    if not isPedInVehicle(lp) then
        return minDist
    else
        local theVehicle = getPedOccupiedVehicle( lp )
        if theVehicle then
            if getVehicleType(theVehicle) == "Plane" then
                return maxDist
            end
            local speed = getElementVelocity(theVehicle)
            if speed <= minVel then
                return minDist
            elseif speed >= maxVel then
                return maxDist
            end
            local streamDistance = speed - minVel
            streamDistance = streamDistance * ratio
            streamDistance = streamDistance + minDist
            return math.ceil(streamDistance)
        end
    end
end

-- Draws map to render target
local function updateRT()
    dxSetRenderTarget(maprendertarget, true)

    if settings.map.alwaysRender or getCameraInterior() == 0 then
        local pos = Vector2(getElementPosition(lp))
        local X, Y = rtW/2 - (pos.x/mapZoomScale), rtH*(3/5) + (pos.y/mapZoomScale)
        dxDrawRectangle(0, 0, rtW, rtH, settings.map.backgroundColor) --render background
        local zmW, zmH = mW * getRadarRadius(), mH * getRadarRadius()
        dxDrawImage(X - (zmW)/2, Y - (zmH)/2, zmW, zmH, map, cz, pos.x/mapZoomScale, -(pos.y/mapZoomScale), 0xFFFFFFFF)
    end

    dxSetRenderTarget()
end

-- Triggered on every frame
function render()
    cx,cy,cz = getElementRotation(getCamera())
    px,py,pz = getElementRotation(lp)
    if isLogged(lp) then
        mapZoomScale = mapScaleFactor / getRadarRadius()
        if (not isPlayerMapVisible()) then
            updateRT()

            local offset = 5

            -- Calculations
            local barsHeight = 10
            local barsWidth = mapDisplayWidth

            local radarWidth = mapDisplayWidth + offset + offset
            local radarHeight = mapDisplayHeight + offset + barsHeight + offset + offset
            local radarLeft = settings.safeX
            local radarTop = screenH - settings.safeY - radarHeight
            
            local mapWidth = mapDisplayWidth
            local mapHeight = mapDisplayHeight
            local mapLeft = radarLeft + offset
            local mapTop = radarTop + offset

            local barsLeft = radarLeft + offset
            local barsTop = radarTop + offset + mapHeight + offset
            local barsOffset = 5

            -- Draw radar
            dxDrawRectangle(radarLeft, radarTop, radarWidth, radarHeight, tocolor(0, 0, 0, 175))
            dxSetBlendMode("add")
            dxDrawImage(mapLeft, mapTop, mapWidth, mapHeight, maprendertarget, 0, 0, 0, tocolor(255, 255, 255, 150))
            dxSetBlendMode("blend")

            -- Calculate percentage values
            local health = getElementHealth(localPlayer) / getMaxHealth(localPlayer)
            local armor = getPedArmor(localPlayer) / 100
            local oxygen = getPedOxygenLevel(localPlayer) / getMaxOxygen(localPlayer)

            -- Compute healthbar color
            local r, g, b = settings.healthbar.colorNormal[1], settings.healthbar.colorNormal[2], settings.healthbar.colorNormal[3]
            if health >= 0.25 then
                interpolateBetween(
                    settings.healthbar.colorNormal[1], settings.healthbar.colorNormal[2], settings.healthbar.colorNormal[3],
                    settings.healthbar.colorLow[1], settings.healthbar.colorLow[2], settings.healthbar.colorLow[3],
                    math.floor(health*20)/10, "InOutQuad"
                )
            else
                r, g, b = interpolateBetween(
                    settings.healthbar.colorCritical[1], settings.healthbar.colorCritical[2], settings.healthbar.colorCritical[3],
                    settings.healthbar.colorLow[1], settings.healthbar.colorLow[2], settings.healthbar.colorLow[3],
                    math.floor(health*20)/10, "InOutQuad"
                )
            end
            local healthBg = tocolor(r, g, b, 100)
            local healthVal = tocolor(r, g, b, 190)

            -- Draw health bar
            local healthbarLeft = barsLeft
            local healthbarWidth = barsWidth/2 - barsOffset/2

            dxDrawRectangle(healthbarLeft, barsTop, healthbarWidth,        barsHeight, healthBg)
            dxDrawRectangle(healthbarLeft, barsTop, healthbarWidth*health, barsHeight, healthVal)

            if settings.oxygenbar.alwaysRender or (oxygen < 1 or isElementInWater(localPlayer)) then
                -- draw armor bar
                local armorLeft = barsLeft + barsWidth/2 + barsOffset/2
                local armorWidth = barsWidth/4 - barsOffset

                dxDrawRectangle(armorLeft, barsTop, armorWidth,       barsHeight, armorBg)
                dxDrawRectangle(armorLeft, barsTop, armorWidth*armor, barsHeight, armorVal)
                
                -- draw oxygen bar
                local oxygenLeft = barsLeft + barsWidth/2 + barsWidth/4 + barsOffset/2
                local oxygenWidth = barsWidth/4 - barsOffset/2

                dxDrawRectangle(oxygenLeft, barsTop, oxygenWidth,        barsHeight, oxygenBg)
                dxDrawRectangle(oxygenLeft, barsTop, oxygenWidth*oxygen, barsHeight, oxygenVal)
            else
                -- draw armor bar (extended length)
                local armorLeft = barsLeft + barsWidth/2 + barsOffset/2
                local armorWidth = barsWidth/2 - barsOffset/2

                dxDrawRectangle(armorLeft, barsTop, armorWidth,       barsHeight, armorBg)
                dxDrawRectangle(armorLeft, barsTop, armorWidth*armor, barsHeight, armorVal)
            end

            local rx, ry, rz = getElementRotation(localPlayer)
            local centerX, centerY = mapWidth/2, mapHeight*(3/5)

            -- Draw heat-seeking rockets targeting the local player
            if settings.blips.drawProjectiles then
                for k, v in ipairs(getElementsByType("projectile")) do
                    local blipPos = v.position
                    local dist = (localPlayer.position - v.position).length
                    if v.dimension == localPlayer.dimension and v.interior == Camera.interior and (settings.blips.projectilesAll or v.target == localPlayer or (localPlayer.vehicle and v.target == localPlayer.vehicle)) then
                        local radius = dist/mapZoomScale
                        local direction = math.atan2(v.position.x - localPlayer.position.x, v.position.y - localPlayer.position.y) + math.rad(Camera.rotation.z)
                        local blipX, blipY = centerX + math.sin(direction) * radius, centerY - math.cos(direction) * radius
                        if blipX >= 0 and blipX <= mapWidth and blipY >= 0 and blipY <= mapHeight then
                            local path = "Images/blips/0.png"
                            local blipColor = settings.blips.projectileColor
                            local blipSize = settings.blips.sizeFactor
                            dxDrawImage(mapLeft + blipX - blipSize/2, mapTop + blipY - blipSize/2, blipSize, blipSize, path, 0, 0, 0, blipColor)
                        end
                    end
                end
            end

            -- Draw blips
            for k, v in ipairs(getElementsByType("blip")) do
                local blipPos = v.position
                local dist = (localPlayer.position - v.position).length
                local maxdist = v.visibleDistance

                if dist <= maxdist and v.dimension == localPlayer.dimension and v.interior == Camera.interior then
                    local radius = dist/mapZoomScale

                    local direction = math.atan2(v.position.x - localPlayer.position.x, v.position.y - localPlayer.position.y) + math.rad(Camera.rotation.z)

                    local blipX, blipY = centerX + math.sin(direction) * radius, centerY - math.cos(direction) * radius

                    local blipX = math.max(0, math.min(blipX, mapWidth)) -- clamp position between 0 and mapWidth
                    local blipY = math.max(0, math.min(blipY, mapHeight)) -- clamp position between 0 and mapHeight

                    local blipRot = getElementData(v, "blipRotation") or 0
                    if type(blipRot) ~= "number" then
                        blipRot = 0
                    end
                    
                    local path = "Images/blips/"..v.icon..".png"
                    do
                        local custom = getElementData(v, "customIcon")
                        if custom and custom:sub(1, 1) == ":" then
                            path = custom
                        elseif custom then
                            path = "Images/blips/"..custom..".png"
                        end
                    end
                    local blipColor = (type(v.icon) == "number" and v.icon >= 1 and v.icon <= 63) and 0xFFFFFFFF or tocolor(getBlipColor(v))
                    local blipSize = v.size * settings.blips.sizeFactor
                    dxDrawImage(mapLeft + blipX - blipSize/2, mapTop + blipY - blipSize/2, blipSize, blipSize, path, blipRot, 0, 0, blipColor)
                end
            end

            -- Draw local player blip
            local blipSize = 2 * settings.blips.sizeFactor
            dxDrawImage(mapLeft + centerX - blipSize/2, mapTop + centerY - blipSize/2, blipSize, blipSize, "Images/player.png", cz-pz, 0, 0)
        end
    end
end
addEventHandler("onClientRender", root, render, false)