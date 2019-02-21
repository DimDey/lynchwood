local w,h=guiGetScreenSize()
local movespeed = 1
local zoom = 1
local size = h*zoom
local x,y = (screenW - size) / 2, (screenH - size) / 2
local toggle=false
local mapTexture = dxCreateTexture("images/radar_map.jpg")
toggleControl("radar",false)
target = dxCreateRenderTarget (w, h,true)
function drawMap()
	if toggle then
		size = h*zoom,h*zoom
        dxDrawImage(x,y,size,size,mapTexture,0,0,0,tocolor(255,255,255,255),false)
		if getKeyState("arrow_l") then
			moveMap(movespeed,"x")
		end
		if getKeyState("arrow_r") then
			moveMap(-movespeed,"x")
		end
		if getKeyState("arrow_u") then
			moveMap(movespeed,"y")
		end
		if getKeyState("arrow_d") then
			moveMap(-movespeed,"y")
		end
		if getKeyState("lalt") then
			movespeed = 0.5
		elseif getKeyState("lshift") then
			movespeed = 2
		else
			movespeed = 1
		end
	end
end
addEventHandler("onClientRender",getRootElement(),drawMap)

function onZoomMap(btn,press)
	if toggle then
		if press then
			if btn == "mouse_wheel_up" then
				if not(h*zoom > h) then
					zoom = zoom + 0.02
				end
			elseif btn == "mouse_wheel_down" then
				newZoom = zoom - 0.02
				if newZoom > 0.5 then -- предел в 0.5(минимальный 1024x1024)
					zoom = newZoom
				else
					zom = 0.5
				end
				outputDebugString(zoom..": "..h*zoom.."x"..h*zoom)
			end
		end
	end
end
addEventHandler("onClientKey",root,onZoomMap)


function moveMap(delta,axis)
	if axis == "x" then
		local newPos = x + delta
		x = newPos
	else
		local newPos = y + delta
		y = newPos
	end
end

function toggleMap()
	if isLogged(lp) then
		toggle = not toggle
		showCursor ( not(isCursorShowing()) )
	end
end
bindKey("F11","down",toggleMap)


function table.find(table,value)
	for k,v in ipairs(table) do
		if v==value then
			return true
		end
	end
	return false
end

function math.round(number,decimals)
	decimals=decimals or 0
	number=number*10^decimals
	return math.floor(number+0.5)/10^decimals
end
