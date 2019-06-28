interactive = {
    -- Переменные
    shaders = { -- шейдеры
        ped = dxCreateShader("Shaders/ped-stroke.fx",0,0,true,"ped,object"),
        veh = dxCreateShader("Shaders/veh-stroke.fx",0,0,true,"vehicle")
    },
    opened = false, -- открыто ли меню
    intObjNear = {},
    onClick = function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedWorld) -- обработчик клика на экран
        if(clickedWorld) then
            if button == "left" then
                if state == "down" then
                    local elTable = interactive.getParentTable(clickedWorld)
                    if elTable then
                        elTable.onClick(absoluteX,absoluteY,worldX,worldY,worldZ)
                    end
                end
            end
        end
    end,
    open = function() -- открытие меню
        if getKeyState("mouse2") then
            if interactive.opened == false then
                elements = getElementsByType("int-obj")
                local count = interactive.get("count")
                if count > 1 then
                    interactive.opened = true
                    showCursor(true)

                    for i,v in ipairs(interactive.intObjNear) do
                        if getElementType(v) == "vehicle" then
                            engineApplyShaderToWorldTexture(interactive.shaders.veh,"vehiclegrunge256",v)
                        else
                            engineApplyShaderToWorldTexture(interactive.shaders.ped,"*",v)                            
                        end
                    end

                    addEventHandler("onClientRender",root,interactive.render)
                elseif count == 1 then
                    for i,el in ipairs(interactive.intObjNear) do
                        local elTable = interactive.getParentTable(el)
                        elTable.onClick()
                    end
                end
            else
                interactive.opened = false
                showCursor(false)

                for i,v in ipairs(interactive.intObjNear) do
                    if getElementType(v) == "vehicle" then
                        engineRemoveShaderFromWorldTexture(interactive.shaders.veh,"vehiclegrunge256",v)
                    else
                        engineRemoveShaderFromWorldTexture(interactive.shaders.ped,"*",v)                            
                    end
                end
                interactive.intObjNear = {}
                removeEventHandler("onClientRender",root,interactive.render)
            end
        end
    end,
    render = function() -- рендер выбора интерактивного объекта
        for i,element in ipairs(interactive.intObjNear) do
            local x,y,z = getElementPosition(element)
            local sX,sY = getScreenFromWorldPosition(x,y,z)
            if sX and sY then
                dxDrawRectangle(sX,sY,dxGetTextWidth(getElementType(element)),17,tocolor(0,0,0,155))
                dxDrawText(getElementType(element),sX,sY)
            end
        end
    end,
    get = function(ret) -- взятие кол-ва объектов и самих объектов
        for i,v in ipairs(elements) do
            local attachedTo = getElementChild(v,0)
            local x,y,z = getElementPosition(attachedTo)
            local px,py,pz = getElementPosition(lp)
            if getDistanceBetweenPoints3D(x,y,z,px,py,pz) <= 5 then
                interactive.intObjNear[i] = attachedTo
            end
        end
        if ret == "obj" then
            return interactive.intObjNear
        else   
            return #interactive.intObjNear
        end
    end,
    getParentTable = function(el)
        local parent = getElementParent(el)
        if parent then
            local elTable = interactive.objects[tonumber(getElementID(parent))]
            return elTable
        else
            return false
        end
    end
}
addEventHandler("onClientClick",root,interactive.onClick)
bindKey("e","down",interactive.open)

-- test

setDevelopmentMode(true)
