local renderChatTarget = dxCreateRenderTarget(700,250,true) --рендертаргет
chat_index = 0

function dxDrawBorderedText( text,xposit,yposit,zposit,top ) -- ИСПОЛЬЗОВАТЬ ТОЛЬКО С РЕНДЕРТАРГЕТОМ!!!!!!!!
    dxDrawText ( "#000000"..removeHex(text), xposit+1, yposit + 1, zposit+1, top+1, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit+1, yposit - 1, zposit+1, top-1, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit-1, yposit + 1, zposit-1, top+1, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit-1, yposit - 1, zposit-1, top-1, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit-1, yposit, zposit, top, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit, yposit - 1, zposit, top, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit, yposit, zposit-1, top, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)
    dxDrawText ( "#000000"..removeHex(text), xposit, yposit, zposit, top-1, tocolor ( 0, 0, 0, 255 ), 1.00, "default-bold", "left", "top",false,true,false,true)

    dxDrawText (text, xposit, yposit, zposit,top,nil, 1.00, "default-bold", "left", "top",false,true,false,true)
end

function TextFuel() -- описано ниже в скролле
    local ypos = yposition
    dxSetRenderTarget(renderChatTarget,true)
    for i = #chat_messages, 1, -1 do
        if ypos < 0 or ypos > 227 then 
           i = #chat_messages-1
           ypos = ypos - 17
        else
            dxDrawBorderedText(chat_messages[i],5,ypos,5,5)
            ypos = ypos - 17
        end
    end
    dxSetRenderTarget()
end

function TextScroll(ypos) -- скролл чата
    dxSetRenderTarget(renderChatTarget,true)
        for i = #chat_messages, 1, -1 do -- перебор сообщений с ходом -1
        if ypos < 0 or ypos > 225 then -- если позиция собщения дальше рендертаргета
            i = #chat_messages-1 
            ypos = ypos - 17 -- позиция сообщения-17
        else
            dxDrawBorderedText(chat_messages[i],5,ypos,250,5) -- отрисовка сообщения 
            ypos = ypos - 17
        end
    end
    dxSetRenderTarget()
end

function chatKey( btn, press )
    if chat_opened == 1 then
        if press then
            if btn == "mouse_wheel_up" then
                updateScroll(1,17)
            elseif btn == "mouse_wheel_down" then
                updateScroll(-1,-17)
            end
        end
    end
end
addEventHandler("onClientKey", root, chatKey)

function updateScroll(delta,yposminus)
    local newScroll = chat_index + delta
    yposition = yposition + yposminus
    chat_index = chat_index + delta
    TextScroll(yposition)
end


function dxRenderMainTarget()
    if isElement(renderChatTarget) then
        dxDrawImage(0,0,700,250,renderChatTarget, 0, 0, 0, tocolor(255,255,255,255), true)
    end
end
addEventHandler("onClientRender", root, dxRenderMainTarget)

function handleRestore()
    TextFuel() 
end
addEventHandler("onClientRestore",root,handleRestore)