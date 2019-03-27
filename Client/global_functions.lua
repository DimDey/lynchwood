hud_visible = true

function showHud(btn, press)
	if (press) then
		if btn == "F7" then
			local components = {"ammo","breath","clock","vehicle_name","weapon"}
			if hud_visible then
				for k,v in pairs(components) do
					setPlayerHudComponentVisible( v, false )
				end
				hud_visible = false
				dxSetRenderTarget( renderChatTarget, true)
				dxSetRenderTarget()
				if isEventHandlerAdded("onClientRender",root, openChat) then
					clearChatBox()
				end
			else
				hud_visible = true
				for k,v in pairs(components) do
					setPlayerHudComponentVisible( v, true )
				end
				TextFuel()
			end
		end
	end
end
addEventHandler( "onClientKey", getRootElement(), showHud )

function _getZoneName( x, y, z )
	if ( getElementDimension( localPlayer ) == 0 ) then
		local zoneName = getZoneName( x, y, z )
		return zoneName ~= "Unknown" and zoneName or "Не найден"
	end
end

function convertNumber( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1.%2' )    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end

function round(num) 
    if ( num >= 0 ) then return math.floor( num + .5 ) 
    else return math.ceil( num - .5 ) end
end

function copyToClipboard()
	local x,y,z = getElementPosition(lp)
	setClipboard(x..", "..y..", "..z)
end
addEvent("copyPosToClipboard",true)
addEventHandler("copyPosToClipboard",root,copyToClipboard)

PlayerComps = {
	["maptoggle"] = false,
	["tabtoggle"] = false,
	["chattoggle"] = false,
	["camerafaded"] = false
}

function getPlayerComponentVisible(comp)
	return PlayerComps[comp]
end

function setPlayerComponentVisible(comp,visible)
	PlayerComps[comp] = visible
end


function showGrid()
	if isEventHandlerAdded("onClientRender",root,dxDrawGrid) then
		removeEventHandler("onClientRender",root,dxDrawGrid)
	else
		addEventHandler("onClientRender",root,dxDrawGrid)
	end
end
addEvent("showGrid",true)
addEventHandler("showGrid",root,showGrid)

function dxDrawGrid()
	dxDrawLine(screenW * 0.1,0,screenW * 0.1, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.2,0,screenW * 0.2, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.3,0,screenW * 0.3, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.4,0,screenW * 0.4, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.5,0,screenW * 0.5, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.6,0,screenW * 0.6, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.7,0,screenW * 0.7, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.8,0,screenW * 0.8, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 0.9,0,screenW * 0.9, screenH,tocolor(71,241,241))
	dxDrawLine(screenW * 1,0,screenW * 1, screenH,tocolor(71,241,241))

	dxDrawLine(0, screenH * 0.1, screenW, screenH * 0.1, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.2, screenW, screenH * 0.2, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.3, screenW, screenH * 0.3, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.4, screenW, screenH * 0.4, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.5, screenW, screenH * 0.5, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.6, screenW, screenH * 0.6, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.7, screenW, screenH * 0.7, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.8, screenW, screenH * 0.8, tocolor(71,241,241))
	dxDrawLine(0, screenH * 0.9, screenW, screenH * 0.9, tocolor(71,241,241))
	dxDrawLine(0, screenH * 001, screenW, screenH * 001, tocolor(71,241,241))
end
addEventHandler("onClientRender",root,dxDrawGrid)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

function isCursorOverText(posX, posY, sizeX, sizeY)
    if(isCursorShowing()) then
        local cX, cY = getCursorPosition()
        local screenWidth, screenHeight = guiGetScreenSize()
        local cX, cY = (cX*screenWidth), (cY*screenHeight)
        if(cX >= posX and cX <= posX+(sizeX - posX)) and (cY >= posY and cY <= posY+(sizeY - posY)) then
            return true
        else
            return false
        end
    else
        return false	
    end
end

function lerp(a,b,t)
    return ((1-t)*a) + (t*b)
end

local fps = false
function getCurrentFPS()
    return fps
end

local function updateFPS(msSinceLastFrame)
	fps = (1 / msSinceLastFrame) * 1000
	
end
addEventHandler("onClientPreRender", root, updateFPS)

function dxDrawFPS()
	if fps then
		dxDrawText(math.floor(fps),screenW-40,0,screenW-10,0,white,1.5,"antialiased")
	end
end
addEventHandler("onClientRender", root, dxDrawFPS,true,"low")

loadstring(exports.dgs:dgsImportFunction())()

function RGBToHex(red, green, blue, alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("0x%.2X%.2X%.2X%.2X",alpha, red, green, blue)
	else
		return string.format("0x%.2X%.2X%.2X", red, green, blue)
	end

end
