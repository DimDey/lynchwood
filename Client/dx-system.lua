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
            for i,child in pairs(elementTable.childs) do
                child.dxFunction(child)
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
        label = text,
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

--EVENTS

function onClickOnElement(button,state)
    for i,elementTable in pairs(dxElements) do
        if isMouseInPosition(elementTable.pos.x,elementTable.pos.y,elementTable.size.width,elementTable.size.height) then
            triggerEvent("onDxClick",elementTable.element)
            elementTable.states.clicked = true
            elementTable.activecolor = elementTable.colors.click
            if elementTable.type == "window" and elementTable.movable then
                local x,y = getCursorPosition()
                elementTable.pos.x = screenW * x
                elementTable.pos.y = screenH * y
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

--ANIMS

--EVENTS
addEvent("onDxClick")
addEvent("onDxFocus")
addEvent("onDxBlur")
