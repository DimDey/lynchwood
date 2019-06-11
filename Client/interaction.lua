interactive = {
    opened = false, -- открыто ли меню
    intObjNear = {},
    events = {
        onClick = function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedWorld) -- обработчик клика на экран
            if(clickedWorld) then
                local parent = getElementParent(clickedWorld)
                if(getElementType(parent) == "int-obj") then
                    local elTable = interactive.objects[tonumber(getElementID(parent))]
                    if (elTable) then
                        elTable.onClick()
                        
                    end
                end
            end
        end,
        onHover = function(cursorX,cursorY,absoluteX,absoluteY,worldX,worldY,worldZ)
            -- доработать потом
        end
    },
    functions = {
        open = function() -- открытие меню
            if getKeyState("mouse2") then
                if interactive.opened == false then
                    elements = getElementsByType("int-obj")
                    if interactive.functions.get("count") > 0 then
                        interactive.opened = true
                        showCursor(true)

                        for i,v in ipairs(interactive.intObjNear) do
                            if getElementType(v) == "vehicle" then
                                engineApplyShaderToWorldTexture(interactive.shaders.veh,"vehiclegrunge256",v)
                            else
                                engineApplyShaderToWorldTexture(interactive.shaders.ped,"*",v)                            
                            end
                        end

                        addEventHandler("onClientRender",root,interactive.functions.render)
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
                    removeEventHandler("onClientRender",root,interactive.functions.render)
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
        end
    },
    shaders = { -- шейдеры
        ped = dxCreateShader("Shaders/ped-stroke.fx",0,0,true,"ped,object"),
        veh = dxCreateShader("Shaders/veh-stroke.fx",0,0,true,"vehicle")
    },
    objects = {}, -- массив с данными об интерактивных объектах
    objects_meta = { -- метатаблица массива выше
        __call = function(self,x,y,z,element,funClick)
            local gelement = createElement("int-obj")
            setElementID(gelement,#interactive.objects+1)
            setElementParent(element,gelement)
            
            local object = {
                x = x,
                y = y,
                z = z,
                intEl = element,
                element = gelement,
                onClick = funClick
            }
            interactive.objects[#interactive.objects+1] = object
            local link = interactive.objects[#interactive.objects]
            return link
        end;
    }
    
}
setmetatable(interactive.objects,interactive.objects_meta);
addEventHandler("onClientClick",root,interactive.events.onClick)
bindKey("e","down",interactive.functions.open)

-- test

setDevelopmentMode(true)
local ped = createPed(120,0,0,5.00)
local veh = createVehicle(400,0,4,5)
function test()
    outputDebugString("click to ped")
end
function test2()
    outputDebugString("click to veh")
end
interactive.objects(0,0,5,ped,test)
interactive.objects(0,0,5,veh,test2)