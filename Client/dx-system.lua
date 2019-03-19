dxElements = {} -- массив с элементами
sysSettings = {
    defaultColor = white,
    font = "default"
}
animList = {}
easingTypes = { "Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve" }

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
        index = string.len(text),
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
    local x,y,w,h = elementTable.pos.x,elementTable.pos.y,elementTable.pos.x+elementTable.size.width,elementTable.pos.y+elementTable.size.height
    local textFont = elementTable.font or sysSettings.font
    dxSetRenderTarget(elementTable.rt,true)
    dxDrawRectangle(x,y,w,h,elementTable.activecolor)
    dxDrawRectangle(x,y+h-5,w,5)
    dxDrawText(elementTable.text,x-elementTable.offset.x,y-elementTable.offset.y,w,h,tocolor(255,255,255),1,textFont,"left","center")
    dxSetRenderTarget()
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
        return true
    end
end

function dxSetEditText(elementTable,text)
    elementTable.text = utf8.sub(elementTable.text,1,elementTable.index)..text..utf8.sub(elementTable.text,elementTable.index+1)
    elementTable.index = elementTable.index+1
    if dxGetTextWidth(elementTable.text,1,elementTable.font) > elementTable.size.width then
        elementTable.offset.x = elementTable.offset.x + dxGetTextWidth(utf8.sub(elementTable.text,elementTable.index),1,elementTable.font)
    end
end

function dxSetEditCaret(elementTable)
    
end

function dxFindCaret(elementTable,x,y)
    local text = elementTable.text
    local sfrom,sto = 0,utf8.len(elementTable.text)
    local font = elementTable.font
    if elementTable.masked then

    end
    local textWidth = dxGetTextWidth(elementTable.text,1,elementTable.font)

end

--EVENTS

function onClickOnElement(button,state)
    for i,elementTable in pairs(dxElements) do
        if isMouseInPosition(elementTable.pos.x,elementTable.pos.y,elementTable.size.width,elementTable.size.height) then
            triggerEvent("onDxClick",elementTable.element)
            elementTable.states.clicked = true
            elementTable.activecolor = elementTable.colors.click
            if elementTable.type == "edit" then
                local x,y = getCursorPosition()
                dxFindCaret(elementTable,x,y)
            end
        end
    end
end
bindKey("mouse1","down",onClickOnElement)

function getCharacters(button)
    for i,elementTable in pairs(dxElements) do
        if elementTable.type == "edit" then
            if elementTable.states.clicked then
                dxSetEditText(elementTable,button)
            end
        end
    end
end
addEventHandler("onClientCharacter",root,getCharacters)

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

--ANIMS

--EVENTS
addEvent("onDxClick")
addEvent("onDxFocus")
addEvent("onDxBlur")
