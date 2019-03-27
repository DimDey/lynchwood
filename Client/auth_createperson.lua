function setPersonAge(delta)
    if personAge+(delta) ~= 19 and personAge+(delta) ~= 40 then
        personAge = personAge+delta
    end
end

local selectMenus = {
    [1] = {screenW * 0.1,screenH * 0.64,screenW * 0.09,screenH * 0.03,setPersonAge}
}
function dxDrawCharacterMenu()
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/background-login.png")
    dxDrawRectangle(0,0,screenW * 0.5,screenH * 0.5,tocolor(29,29,33,100))
    dxDrawRectangle(0,yPosition,screenW * 0.5,screenH * 0.5,tocolor(255,106,19,175))
    dxDrawImage(0,0,screenW * 0.5,screenH * 0.5,"Images/next-btn.png")

    dxDrawImage(0,screenH * 0.5,screenW * 0.5,screenH * 0.5,"Images/background-reg.png")
    dxDrawRectangle(0,screenH * 0.5,screenW * 0.5,screenH * 0.5, tocolor(29,29,33,155))

    dxDrawLine(screenW * 0.05,screenH * 0.5,screenW * 0.05,screenH,tocolor(255,255,255,50))
    dxDrawLine(screenW * 0.45,screenH * 0.5,screenW * 0.45,screenH,tocolor(255,255,255,50))
    dxDrawLine(0,screenH * 0.55,screenW * 0.5,screenH * 0.55,tocolor(255,255,255,50))
    dxDrawLine(0,screenH * 0.95,screenW * 0.5,screenH * 0.95,tocolor(255,255,255,50))

    dxSetRenderTarget(regRt,true)
    dxDrawRectangle(screenW * 0.05 - 1,animateRectangles[1],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(screenW * 0.45 - 1,animateRectangles[2],3,10,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[3],screenH * 0.55 - 1,10,3,SERVERCOLORS.GENERAL)
    dxDrawRectangle(animateRectangles[4],screenH * 0.95 - 1,10,3,SERVERCOLORS.GENERAL)
    dxSetRenderTarget()

    for k,pos in ipairs(animateRectangles) do
        if k <= 2 then
            if animateRectangles[k] < screenH then
                animateRectangles[k] = animateRectangles[k]+0.3
            else
                animateRectangles[k] = screenH * 0.5
            end
        else
            if animateRectangles[k] < screenW * 0.5 - 6 then
                animateRectangles[k] = animateRectangles[k]+0.3
            else
                animateRectangles[k] = - 10
            end
        end
    end
    dxDrawImage(0,0,screenW * 0.5,screenH,regRt)

    dxDrawText("ВОЗРАСТ",screenW * 0.1,screenH * 0.58,screenW * 0.1,screenH * 0.58,white,1,bebasreg)
    dxDrawAge()
end

function dxDrawAge()
    dxDrawRectangle(screenW * 0.1,screenH * 0.64,screenW * 0.09,screenH * 0.03,tocolor(255,106,19,51))
    dxDrawRectangle(screenW * 0.1,screenH * 0.67,screenW * 0.09,2,SERVERCOLORS.GENERAL)
    dxDrawText("",screenW * 0.105,screenH * 0.64,screenW * 0.09+screenW * 0.105,screenH * 0.03+screenH * 0.64,SERVERCOLORS.GENERAL,1,fontawesome,"left","center")
    dxDrawText("",screenW * 0.175,screenH * 0.64,screenW * 0.09+screenW * 0.105,screenH * 0.03+screenH * 0.64,SERVERCOLORS.GENERAL,1,fontawesome,"left","center")
    if personAge-1 ~= 19 then
        dxDrawText(personAge-1,screenW * 0.115,screenH * 0.64,screenW * 0.09+screenW * 0.105,screenH * 0.03+screenH * 0.64,tocolor(255,255,255,127),1,dxCeraReg,"left","center")
    end
    dxDrawText(personAge,screenW * 0.136,screenH * 0.64,screenW * 0.09+screenW * 0.105,screenH * 0.03+screenH * 0.64,tocolor(255,255,255,255),1,dxCeraReg,"left","center")
    if personAge+1 ~= 40 then
        dxDrawText(personAge+1,screenW * 0.155,screenH * 0.64,screenW * 0.09+screenW * 0.105,screenH * 0.03+screenH * 0.64,tocolor(255,255,255,127),1,dxCeraReg,"left","center")
    end
end

function onButtonCharacterHover()
    if isMouseInPosition(0,0,screenW * 0.5,screenH * 0.5) then
        if yPosition < 0 then
            animReg(0,1700)
        end
    else
        if yPosition > -10  then
            animReg(-screenH * 0.5,1700)
        end
    end
end

function onClickToAngle(btn,state)
    if btn == "left" then
        if state == "down" then
            for i,elTable in ipairs(selectMenus) do
                if isMouseInPosition(elTable[1]+screenW * 0.05,elTable[2],dxGetTextWidth("",1,fontawesome),elTable[4]+elTable[2]) then
                    elTable[5](-1)
                    selectedSelecter = elTable[5]
                    outputDebugString("true")
                elseif isMouseInPosition(elTable[1]+screenW * 0.65,elTable[3],dxGetTextWidth("",1,fontawesome),elTable[4]+elTable[2]) then
                    elTable[5](1)
                    outputDebugString("true")
                end
                if isMouseInPosition(elTable[1],elTable[2],elTable[3],elTable[4]) then
                    selectedSelecter = elTable[5]
                end
                outputDebugString("false")
            end

        end
    end
end 

function onPlayerScroll(btn,press)
    if press then
        if selectedSelecter then
            if btn == "mouse_wheel_up" then
                selectedSelecter(1)
            elseif btn == "mouse_wheel_down" then
                selectedSelecter(-1)
            end
        end
    end
end