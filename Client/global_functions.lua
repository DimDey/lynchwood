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

function isCursorOnElement( posX, posY, width, height )
	if isCursorShowing( ) then
		local mouseX, mouseY = getCursorPosition( )
		local mouseX, mouseY = mouseX * screenW, mouseY * screenH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			return true
		end
	end
	return false
end

function cursorY( )
	if isCursorShowing( ) then
		local _, mouseY = getCursorPosition( )
		return mouseY * screenH
	end
	return 0
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

function dxDrawCorner( x, y, r, color, corner, postGUI )
	local corner = corner or 1
	local start = corner % 2 == 0 and 0 or -r
	local stop = corner % 2 == 0 and r or 0
	local m = corner > 2 and -1 or 1
	local h = ( corner == 1 or corner == 3 ) and -1 or 1
 	for yoff = start, stop do
 		local xoff = math.sqrt( r * r - yoff * yoff ) * m
 		dxDrawRectangle( x - xoff, y + yoff, xoff, h, color, postGUI )
	end 
end

function _dxDrawRectangle( posX, posY, width, height, radius, color, postGUI )	
	local posX, posY, width, height = round( posX ), round( posY ), round( width ), round( height )
	local radius = radius and math.min( radius, math.min( width, height ) / 2 )  or 12
	
	dxDrawRectangle( posX, posY + radius, width, height - radius * 2, color, postGUI )
	dxDrawRectangle( posX + radius, posY, width - 2 * radius, radius, color, postGUI )
	dxDrawRectangle( posX + radius, posY + height - radius, width - 2 * radius, radius, color, postGUI )
	
	dxDrawCorner( posX + radius, posY + radius, radius, color, 1, postGUI )
	dxDrawCorner( posX + radius, posY + height - radius, radius, color, 2, postGUI )
	dxDrawCorner( posX + width - radius, posY + radius, radius, color, 3, postGUI )
	dxDrawCorner( posX + width - radius, posY + height - radius, radius, color, 4, postGUI )
end


colshape = {}
markers = {}

function colshape:create(func,onEnter,onExit,...)
	local col = func(...)
	if onEnter and onExit then
		addEventHandler("onClientColShapeHit",col,onEnter)
		addEventHandler("onClientColShapeLeave",col,onExit)
	end
	return col
end

function markers:create(x,y,z,onEnter,onExit,...)
	local marker = createMarker(x,y,z,...)
	if onEnter and onExit then
		addEventHandler("onClientMarkerHit",marker,onEnter)
		addEventHandler("onClientMarkerLeave",marker,onExit)
	end
	return marker
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
local sx,sy = guiGetScreenSize()
local sw,sh = 1440,900

function relative(x,y,w,h)
    local x,y,w,h = x/sx*sw,y/sy*sh,w/sx*sw,h/sy*sh
    return x,y,w,h
end

function showGrid()
	if isEventHandlerAdded("onClientRender",root,dxDrawGrid) then
		removeEventHandler("onClientRender",root,dxDrawGrid)
	else
		
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