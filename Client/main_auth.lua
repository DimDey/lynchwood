leftBtn = dxCreateButton(screenW * 0.36,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,2.5,true) -- создание кнопки
rightBtn = dxCreateButton(screenW * 0.53,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,2.5,true) -- создание кнопки


font = getFont("Fonts/Montserrat-Medium.ttf",15,true)
ButtonW = {
	[leftBtn] = 0,
	[rightBtn] = 0
}
arrowAlpha = 0
ButtonAnims = {
	[leftBtn] = false,
	[rightBtn] = false
}
RenderMenu = {
	["general"] = true,
	["login"] = false,
	["register"] = false
}
selectedMenu = ""

function onStartResourceFunction()
	fadeCamera(true)
	setCameraTarget(lp)
	setCameraMatrix(-369.0126953125, -1541.95703125,36.245861053467,-333.9208984375,-1448.4169921875,31.908327102661)
	showCursor(true)
end
addEventHandler("onClientResourceStart",resourceRoot,onStartResourceFunction)

function RenderMenu.render()
	if getCurrentFPS() then
		dxDrawText(getCurrentFPS(),50,500)
	end
	if RenderMenu["general"] then
		dxDrawImage(screenW * 0.67,screenH * 0.86,24,24,"Images/mm-arrow.png",0,0,0,tocolor(255,255,255,arrowAlpha))

		dxDrawRoundedRectangle(screenW * 0.36,screenH * 0.84,ButtonW[leftBtn],screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("ВОЙТИ",screenW * 0.36,screenH * 0.84,screenW * 0.49,screenH * 0.91,white,1,font,"center","center")

		dxDrawRoundedRectangle(screenW * 0.53,screenH * 0.84,ButtonW[rightBtn],screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("РЕГИСТРАЦИЯ",screenW * 0.53,screenH * 0.84,screenW * 0.66,screenH * 0.91,white,1,font,"center","center")
	end
end
addEventHandler("onClientRender",root,RenderMenu.render,true,"low")

function onHover()
	if not(ButtonW[source] >= screenW * 0.13) then
		if not(isAnimatedButton(source)) then
			animBtn(source,screenW * 0.13,255,2000)
		end
	end
end
addEventHandler("onDxFocus",leftBtn,onHover)
addEventHandler("onDxFocus",rightBtn,onHover)

function onBlur()
	if selectedMenu ~= source then
		if ButtonW[source] ~= 0 then
			if not(isAnimatedButton(source)) then
				animBtn(source,0,0,500)
			end
		end
	end
end
addEventHandler("onDxBlur",leftBtn,onBlur)
addEventHandler("onDxBlur",rightBtn,onBlur)

function onMainMenuClickBtn()
	RenderMenu["general"] = false
	if source == leftBtn then
		selectedMenu = "login"
	else
		selectedMenu = "register"
		regWindow = dxCreateWindow(screenW * 0.53,screenH * 0.5,screenW * 0.13,screenH * 0.31,tocolor(0,0,0,50),nil,nil,2,true)
	end
	RenderMenu[selectedMenu] = true
end
addEventHandler("onDxClick",leftBtn,onMainMenuClickBtn)
addEventHandler("onDxClick",rightBtn,onMainMenuClickBtn)

function isAnimatedButton(btn)
	return ButtonAnims[btn]
end

function animBtn(btn,size,arrwalpha,duration)
	local startTime = getTickCount()
	local func
	func = function()
		ButtonAnims[btn] = true
		local now = getTickCount()
		local elapsedTime = now - startTime
		local progress = elapsedTime / duration
		
		ButtonW[btn] = interpolateBetween(ButtonW[btn],0,0,size,0,0,progress,"Linear")
		arrowAlpha = interpolateBetween(arrowAlpha,0,0,arrwalpha,0,0,progress,"Linear")
		if math.floor(ButtonW[btn]) >= math.floor(size) then
			ButtonAnims[btn] = false
			removeEventHandler("onClientRender",root,func)
		end
	end
	addEventHandler("onClientRender",root,func)
end