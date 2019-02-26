EditBox = {
    create = createEdit,
    setProperty = setProperty
}


function dxCreateRoundedTexture(text_X,text_Y,text_width,text_height,radius,mask)
    assert(text_width,"Missing argument 'text_width' at dxCreateRoundedTexture")
    assert(text_height,"Missing argument 'height' at dxCreateRoundedTexture")
    assert(radius,"Missing argument 'radius' at dxCreateRoundedTexture")
    if type(text_width) ~= "number" then outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 1, got " .. type(text_width) .. "]",2) return false end
    if type(text_height) ~= "number" then outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 2, got " .. type(text_height) .. "]",2) return false end
    if type(radius) ~= "number" then outputDebugString("Bad argument @ 'dxCreateRoundedTexture' [Excepted number at argument 3, got " .. type(radius) .. "]",2) return false end
    if text_width < 0 then outputDebugString("text_width can't be less than 0",1) return false end
    if text_height < 0 then outputDebugString("text_height can't be less than 0",1) return false end
    if radius < 0 or radius > 100 then outputDebugString("Parameter 'radius' can't be between 0 and 100",1) return false end

    local texture = DxTexture(text_width,text_height)
    local pix = texture:getPixels()

    radius = (radius * (text_height / 2)) / 100

    for x=0,text_width do
        for y=0,text_height do
            if x >= radius and x <= text_width - radius then
                dxSetPixelColor(pix,x,y,255,255,255,255)
            end
            if y >= radius and y <= text_height - radius then
                dxSetPixelColor(pix,x,y,255,255,255,255)
            end
            if math.sqrt((x - radius)^2 + (y - radius)^2) < radius then
                dxSetPixelColor(pix,x,y,255,255,255,255) -- lewy gorny rog
            end
            if math.sqrt((x - (text_width - radius))^2 + (y - radius)^2) < radius then
                dxSetPixelColor(pix,x,y,255,255,255,255) -- prawy gorny rog
            end
            if math.sqrt((x - radius)^2 + (y - (text_height - radius))^2) < radius then
                dxSetPixelColor(pix,x,y,255,255,255,255) -- lewy dolny rog
            end
            if math.sqrt((x - (text_width - radius))^2 + (y - (text_height - radius))^2) < radius then
                dxSetPixelColor(pix,x,y,255,255,255,255) -- prawy dolny rog
            end
        end
    end
    texture:setPixels(pix)
    if mask then
        return dxSmoothRoundedTexture(texture,text_X,text_Y,text_width,text_height, mask)
    else
        return texture
    end
    
end

function dxSmoothRoundedTexture( texture, x,y, width, height, mask )
    local mask = dxCreateTexture( mask )
    local shader = dxCreateShader("Shaders/smooth.fx")
    if shader and mask then
        dxSetShaderValue( shader, "Texture0",texture) -- текстура
        dxSetShaderValue( shader, "Texture1",mask) -- маска     

        return shader
    end

end

function dxMaskTexture(texture, mask)
    local mask = dxCreateTexture( mask )
    local shader = dxCreateShader("Shaders/mask.fx")
    if shader and mask then
        dxSetShaderValue( shader, "Texture0",texture) -- текстура
        dxSetShaderValue( shader, "Texture1",mask) -- маска     

        return shader
    end
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 3)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 3)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 3)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 3)
    end
end

function dxDrawCheckButton(x, y, w, h, text, chek )
	local mx, my = getMousePos()
	local color1 = tocolor(255, 255, 255, 255)
	local color2 = tocolor(82, 82, 82, 255)
	local color3 = tocolor(255, 255, 255, 255)
	if isPointInRect(mx, my, x, y, w, h) then
		color3 = tocolor(200, 200, 200, 200)
	end
	local pos = x
	dxDrawRectangle(x, y, w, h, color1, false)
	dxDrawRectangle(x + 2, y + 2, w - 4, h - 4, color2, false)
	if chek then
		dxDrawRectangle(pos + 4, y + 4, w - 8, h - 8, color3, false)
	end
	dxDrawText(text, pos + 30, y + 6, 30 + pos + 25, h - 12 + y + 6, tcolor, 1, "default", "left", "center", true, false, false, true)
end

function dxDrawScrollBar (x, y, w, h, scroll)
	local mx, my = getMousePos()
	local bgcolor = tocolor(82, 82, 82, 255)
	local tcolor = tocolor(255, 255, 255, 255)
	if isPointInRect(mx, my, scroll, y-5, 10, h+10) then
		tcolor = tocolor(200, 200, 200, 255)
	elseif isPointInRect(mx, my, x, y-5, 10, h+10 ) then
		tcolor = tocolor(200, 200, 200, 255)
	elseif isPointInRect(mx, my, x, (x+w)-10, y-5, 10, h+10 ) then
		tcolor = tocolor(200, 200, 200, 255)
	end
	if scrollMoving then
		tcolor = tocolor(82, 82, 82, 255)
	end
	dxDrawRectangle(x, y, w, h, bgcolor, false)
	if scroll >= x and scroll <= (x+w)-10 then
		dxDrawRectangle(scroll, y-5, 10, h+10, tcolor, false)
		--scrollProcent = ((scroll-x)/w)*100
		scrollProcent = 5 * (scroll - x) / 250
		--setElementData(localPlayer, "map:speed", 1 - math.floor(scrollProcent)*0.01)
	else
		if scroll <= x then
			dxDrawRectangle(x, y-5, 10, h+10, tcolor, false)
			scrollProcent = 0
			--setElementData(localPlayer, "map:speed", 1 - math.floor(scrollProcent)*0.01)
		else
			dxDrawRectangle((x+w)-10, y-5, 10, h+10, tcolor, false)
			scrollProcent = 5
			--setElementData(localPlayer, "map:speed", 1 - math.floor(scrollProcent)*0.01)
		end
	end
end


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

function dxDraw()
    for id,element in pairs(MainDraw) do
        if isElement(element) then
            local x,y,width,height = getElementData(element,"x"),getElementData(element,"y"),getElementData(element,"width"),getElementData(element,"height")
            if getElementType(element) == "dx-edit" then
                dxDrawRectangle(x,y,width,height)
            end
            if isCursorOverText(x,y,width,height) then
                triggerEvent("onDxMouseEnter",element)
            end
        end
    end
end


function createEdit(x,y,width,height)
    local edit = createElement("dx-edit")
    table.insert(MainDraw,#MainDraw,edit)
    setElementData(edit,"dxfunction","dxDrawRectangle")
    addEventHandler("onClientRender",root,dxDraw)
    setElementData(edit,"x",tonumber(x))
    setElementData(edit,"y",tonumber(y))
    setElementData(edit,"width",tonumber(width))
    setElementData(edit,"height",tonumber(height))
end

function onDxMouseEnter()

end
addEventHandler("onDxMouseEnter",root,onDxMouseEnter)

function getMousePos()
	local xsc, ysc = guiGetScreenSize()
	local mx, my = getCursorPosition()
	if not mx or not my then
		mx, my = 0, 0
	end
	return mx * xsc, my * ysc
end

function cursorPosition(x, y, w, h)
	if (not isCursorShowing()) then
		return false
	end
	local mx, my = getCursorPosition()
	local fullx, fully = guiGetScreenSize()
	cursorx, cursory = mx*fullx, my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function isPointInRect(x, y, rx, ry, rw, rh)
	if x >= rx and y >= ry and x <= rx + rw and y <= ry + rh then
		return true
	else
		return false
	end
end

--[[_dxDrawImage = dxDrawImage
function dxDrawImage(posX, posY, width, height, relative, image, ...)
    local relative = relative or false
    if relative then
        local x,y = (screenW * posX)-width, (screenH * posY)-height
        _dxDrawImage(x,y,width, height, image, ...)
    else
        _dxDrawImage(posX, posY, width, height, image, ...)
    end
end]]