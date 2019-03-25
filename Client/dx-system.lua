dxElements = {} -- массив с элементами
sysSettings = {
    defaultColor = white,
    font = "default"
}

local easingTypes = { "Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve" }

function dxMaskTexture(mask,width,height)
    local mask = dxCreateTexture( mask )
    local texture = dxCreateTexture(width,height)
    local shader = dxCreateShader("Shaders/mask.fx")
    if shader and mask then
        dxSetShaderValue( shader, "Texture0",mask) -- текстура
        dxSetShaderValue( shader, "Texture1",mask) -- маска     

        return shader
    end
end


function dxDrawRoundedRectangle(x, y, rx, ry, text, textFont, color, radius, blur)
    blur = blur or false
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

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
        if blur then
            rt = Blur:getScreenTexture()
            dxDrawImageSection(x,y,rx,ry,x,y,rx,ry,rt)
        end
        if text then
            if textFont == nil then textFont = sysSettings.font end
            dxDrawText(text,x,y,x+rx,y+ry,white,1,textFont,"center","center")
        end
        
    end
end

--Render

function dxDrawElements()
    for k,elementTable in pairs(dxElements) do
        if type(elementTable.dxFunction) == "function" then
            elementTable.dxFunction(elementTable)
            if elementTable.childs then
                for i,child in pairs(elementTable.childs) do
                    child.dxFunction(child)
                end
            end
        end
    end
end
addEventHandler("onClientRender",root,dxDrawElements)

--dxCreate functions

function dxCreateWindow(aX,aY,w,h,norcolor,hovcolor,clicolor,radius,blured,movable)
    norcolor = norcolor or white
    hovcolor = hovcolor or norcolor
    clicolor = clicolor or norcolor
    radius = radius or 0
    blured = blured or false
    movable = movable or false
    window = createElement("dx-window")
    dxElements[window] = {
        type = "window",
        element = window,
        dxFunction = dxDrawRect,
        pos = {
            x = aX,
            y = aY
        },
        size = {
            width = w,
            height = h
        },
        states = {
            focused = false,
            clicked = false
        },
        activecolor = norcolor,
        colors = {
            normal = norcolor,
            hover = hovcolor,
            click = clicolor
        },
        animation = {
            sizing = false,
            animating = false,
            alphing = false
        },
        style = {radius = radius, blur = blured,movable},
        childs = {}
    }
    return window
end

function dxCreateEdit(aX,aY,w,h,titleText,text,norcolor,hovcolor,clicolor)
    text = text or ""
    textFont = textFont or nil
    norcolor = norcolor or white
    hovcolor = hovcolor or norcolor
    clicolor = clicolor or norcolor
    edit = createElement("dx-edit")
    editRT = dxCreateRenderTarget(w,h,true)
    dxElements[edit] = {
        type = "edit",
        element = edit,
        dxFunction = dxDrawEdit,
        rt = editRT,
        pos = {
            x = aX,
            y = aY
        },
        size = {
            width = w,
            height = h
        },
        offset = {
            x = 0,
            y = 0
        },
        states = {
            focused = false,
            clicked = false
        },
        activecolor = norcolor,
        colors = {
            normal = norcolor,
            hover = hovcolor,
            click = clicolor,
            error = tocolor(255,0,0,255),
            success = tocolor(255,0,0,255)
        },
        text = text,
        index = utf8.len(text) or 1,
        font = textFont or sysSettings.font,
        titleText = titleText,
        maxLength = 120,
        masked = false
    }
    return edit
end

function dxCreateButton(aX,aY,w,h,text,norcolor,hovcolor,clicolor,radius,blured)
    norcolor = norcolor or white
    hovcolor = hovcolor or norcolor
    clicolor = clicolor or norcolor
    radius = radius or 0
    blured = blured or false
    btn = createElement("dx-element")
    dxElements[btn] = 
    { 
        type = "button",
        element = btn,
        dxFunction = dxDrawRect,
        pos = {
            x = aX,
            y = aY
        },
        size = {
            width = w,
            height = h
        }, 
        states = {
            focused = false,
            clicked = false
        },
        activecolor = norcolor,
        colors = {
            normal = norcolor,
            hover = hovcolor,
            click = clicolor
        },
        text = text,
        labelFont = nil,
        animation = {
            sizing = false,
            animating = false,
            alphing = false
        },
        style = {blur = blured,radius = radius},
        childs = {}
    }
    return btn
end

function dxDrawRect(elementTable)
    if elementTable.style.radius > 0 then
        Blur.render()
        dxDrawRoundedRectangle(
            elementTable.pos.x,elementTable.pos.y,
            elementTable.size.width,elementTable.size.height, 
            elementTable.label,elementTable.labelFont,
            elementTable.activecolor,elementTable.style.radius,elementTable.style.blur)
    else
        dxDrawRectangle(elementTable.pos.x,elementTable.pos.y,elementTable.size.width,elementTable.size.height,elementTable.activecolor,true)
    end
end

function dxDrawEdit(elementTable)
    local caretX = dxGetTextWidth(utf8.sub(elementTable.text,0,elementTable.index),1,elementTable.font)+elementTable.offset.x
    local x,y,w,h = elementTable.pos.x,elementTable.pos.y,elementTable.pos.x+elementTable.size.width,elementTable.pos.y+elementTable.size.height
    local textFont = elementTable.font or sysSettings.font
    dxSetRenderTarget(elementTable.rt,true)
    dxDrawRectangle(x,y,w,h,elementTable.activecolor)
    dxDrawRectangle(x,y+h-5,w,5)
    dxDrawText(elementTable.text,x+elementTable.offset.x,y-elementTable.offset.y,w,h,tocolor(255,255,255),1,textFont,"left","center")
    
    dxDrawRectangle(caretX-0.5,elementTable.pos.y+20,2,15,tocolor(0,0,0))
    dxSetRenderTarget()
    dxDrawText(elementTable.titleText,elementTable.pos.x,elementTable.pos.y,elementTable.size.width,elementTable.size.height)
    dxDrawImage(x,y,w,h,elementTable.rt)
end

--utils func

function dxGetElementTable(el)
    return dxElements[el]
end

function destroyDxElement(el)
    if type(el) == "table" then
        el = nil 
    elseif type(el) == "userdata" then
        dxElements[el] = nil
    end
end

function dxSetProperty(element,prop,state)
    local elementTable = dxGetElementTable(element)
    for name,propFunc in pairs(properties) do
        if name == prop then
            propFunc(elementTable,state)
            break
        end
    end
end 

function dxSetElementText(elementTable,state)
    elementTable.label = state
end

function dxSetSystemFont(font)
    if getElementType(font) == "dx-font" then
        sysSettings.font = font
    end
end

properties = {
    ["text"] = dxSetElementText
}

function dxCreateChild(parent,child,elementTable)
    dxElements[parent].childs[child] = elementTable
    dxElements[parent].childs[child].parent = parent
    if dxElements[child] then
        return child
    end
end

function dxSetEditText(elementTable)
    elementTable.text = utf8.sub(elementTable.text,1,elementTable.index)..text..utf8.sub(elementTable.text,elementTable.index+1)
    elementTable.index = elementTable.index+1
    if dxGetTextWidth(utf8.sub(elementTable.text,0,elementTable.index),1,elementTable.font)+elementTable.offset.x > elementTable.size.width then
        elementTable.offset.x = -(elementTable.offset.x + dxGetTextWidth(elementTable.text,1,elementTable.font))
    else
        elementTable.offset.x =  elementTable.offset.x - dxGetTextWidth(utf8.sub(elementTable.text,0,elementTable.index),1,elementTable.font)
        if elementTable.offset.x < 0 then
            elementTable.offset.x = 0
        end
    end
end

function dxSetEditCaret(elementTable)
    
end

function dxEditUpdateText(elementTable)
    local index = elementTable.index
    local text = elementTable.text
    elementTable.text = utf8.sub(textData,1,index)..text..utf8.sub(textData,index+1)
end

function dxGetCaretPosition(element)
    if type(element) == "table" then
        elementTable = element
    else
        elementTable = dxGetElementTable(element)
    end
    return elementTable.index
end

function dxFindCaret(elementTable,posx,posy)
    local text = elementTable.text
	local sfrom,sto = 0,utf8.len(text)
	if elementTable.masked then
		text = utf8.rep("*",sto)
	end
	local font = elementTable.font or systemFont
	local txtSizX = 1
	local size = 1
	local offset = elementTable.offset.x
	local x = elementTable.pos.x
	local padding = 0
	local pos
	local alllen = dxGetTextWidth(elementTable.text,1,elementTable.font)
	local sx,sy = elementTable.pos.x,elementTable.pos.y
	pos = (alllen-1+offset)*0.5-x+posx
	local templen = 0
	for i=1,sto do
		local stoSfrom_Half = (sto+sfrom)*0.5
		local strlen = dxGetTextWidth(utf8.sub(text,sfrom+1,stoSfrom_Half),txtSizX)
		local len1 = strlen+templen
		if pos < len1 then
			sto = math.floor(stoSfrom_Half)
		elseif pos > len1 then
			sfrom = math.floor(stoSfrom_Half)
			templen = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX)
			start = len1
		elseif pos == len1 then
			start = len1
			sto = sfrom
			templen = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX)
		end
		if sto-sfrom <= 10 then
			break
		end
	end
	local start = dxGetTextWidth(utf8.sub(text,0,sfrom),txtSizX)
	local lastWidth
	for i=start,sto do
		local poslen1 = dxGetTextWidth(utf8.sub(text,sfrom+1,i),txtSizX,font)+start
		local Next = dxGetTextWidth(utf8.sub(text,i+1,i+1),txtSizX,font)*0.5
		local offsetR = Next+poslen1
		local Last = lastWidth or dxGetTextWidth(utf8.sub(text,i,i),txtSizX,font)*0.5
		lastWidth = Next
		local offsetL = poslen1-Last
		if i <= sfrom and pos <= offsetL then
			return sfrom
		elseif i >= sto and pos >= offsetR then
			return sto
		elseif pos >= offsetL and pos <= offsetR then
			return i
		end
	end
	return -1
end

--EVENTS

function onClickOnElement(button,state)
    for i,elementTable in pairs(dxElements) do
        if elementTable.states.focused then
            triggerEvent("onDxClick",elementTable.element)
            elementTable.states.clicked = true
            elementTable.activecolor = elementTable.colors.click
            if elementTable.type == "edit" then
                local x,y = getCursorPosition()
                elementTable.index = dxFindCaret(elementTable,x,y)
            end
        else
            if elementTable.states.clicked then
                elementTable.states.clicked = false
            end
        end
    end
end
bindKey("mouse1","down",onClickOnElement)

function onHoverOnElement()
    for i,elementTable in pairs(dxElements) do
        if isMouseInPosition(elementTable.pos.x,elementTable.pos.y,elementTable.size.width,elementTable.size.height) then
            if not(elementTable.states.focused) then
                triggerEvent("onDxFocus",elementTable.element)
                elementTable.states.focused = true
                elementTable.activecolor = elementTable.colors.hover
            end
        else
            if elementTable.states.focused then
                elementTable.states.focused = false
                elementTable.activecolor = elementTable.colors.normal
            end
            triggerEvent("onDxBlur",elementTable.element)
        end
    end
end
addEventHandler("onClientRender",root,onHoverOnElement)


function onClientPressCharacter(button)
    for i,elementTable in pairs(dxElements) do
        if elementTable.type == "edit" then
            if elementTable.states.clicked then
                dxSetEditText(elementTable,button)
            end
        end
    end
end
addEventHandler("onClientCharacter",root,onClientPressCharacter)

function onClientPressKey(button,press)
    if press then
        for i,elementTable in pairs(dxElements) do
            if elementTable.type == "edit" then
                if button == "backspace" then
                    dxEditUpdateText(elementTable)
                end
            end
        end
    end
end
addEventHandler("onClientKey",root,onClientPressKey)

--ANIMS

--EVENTS
addEvent("onDxClick")
addEvent("onDxFocus")
addEvent("onDxBlur")


function useAdaptive()
    
end
addEventHandler("onClientRender",root,useAdaptive)