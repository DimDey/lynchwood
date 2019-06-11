gRetexObjects = {}

addEvent("onReturnsMap",true)

function addRetexToObj(tex,toTex,obj)
    --if source == localPlayer then
        if fileExists(toTex) then
            addRetexture(obj,tex,toTex)
            setRetexProperty(obj,"color",false)
        else
            downloadFile(toTex)
            local onDownloadFile
            onDownloadFile = function(file,success)
                if success then
                    if file == toTex then
                        addRetexture(obj,tex,toTex)
                    end
                end
            end
            addEventHandler("onClientFileDownloadComplete",root,onDownloadFile)
        end
    --end
end
addEvent("onAddRetexture",true)
addEventHandler("onAddRetexture",root,addRetexToObj)

function setRetexProperty(obj,prop,state)
    if prop == "color" then
        setColorToObj(obj,state)
    end
end

function setColorToObj(obj,state)
    if obj then
        dxSetShaderValue(gRetexObjects[obj][1].shader,"retexColor",true)
        engineApplyShaderToWorldTexture(gRetexObjects[obj][1].shader,gRetexObjects[obj][1].tex,obj)
    end
end

function addRetexture(obj,tex,retex)
    local gShader = dxCreateShader("Shaders/retexture.fx",0,120,true,"all")
    retex = dxCreateTexture(retex)
    dxSetShaderValue(gShader,"gTexture",retex)
    engineApplyShaderToWorldTexture(gShader,tex,obj)
    if obj then
        if gRetexObjects[obj] == nil then
            gRetexObjects[obj] = {}
        end
        table.insert(gRetexObjects[obj],{tex = tex,newTex = retex,shader = gShader})
    end
    return true
end

function removeRetexture(obj,tex)
    if source == localPlayer then
        if isElement(obj) and tex then
            for i,texTable in ipairs(gRetexObjects[obj]) do
                if texTable.tex == tex then
                    engineRemoveShaderFromWorldTexture(texTable.shader,tex,obj)
                end
            end
        end
    end
end
addEvent("onRemoveRetexture",true)
addEventHandler("onRemoveRetexture",root,removeRetexture)

function onReturnsTheMap(objTable)
    gObjList = objTable
end
addEventHandler("onReturnsMap",root,onReturnsTheMap)