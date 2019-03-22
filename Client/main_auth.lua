leftBtn = dxCreateButton(screenW * 0.36,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,2.5,true) -- создание кнопки
rightBtn = dxCreateButton(screenW * 0.53,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,2.5,true) -- создание кнопки


font = getFont("Fonts/Montserrat-Medium.ttf",15,true)

Buttons = {
	[leftBtn] = {
		width = 0,
		anim = false
	},
	[rightBtn] = {
		width = 0,
		anim = false
	}
}
arrowAlpha = 0
RenderMenu = {
	["general"] = true,
	["login"] = false,
	["register"] = false,
	["createcharacter"] = false
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

		dxDrawRoundedRectangle(screenW * 0.36,screenH * 0.84,Buttons[leftBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("ВОЙТИ",screenW * 0.36,screenH * 0.84,screenW * 0.49,screenH * 0.91,white,1,font,"center","center")

		dxDrawRoundedRectangle(screenW * 0.53,screenH * 0.84,Buttons[rightBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("РЕГИСТРАЦИЯ",screenW * 0.53,screenH * 0.84,screenW * 0.66,screenH * 0.91,white,1,font,"center","center")
	elseif RenderMenu["login"] then
		
	elseif RenderMenu["register"] then
		dxDrawRoundedRectangle(screenW * 0.36,screenH * 0.84,Buttons[leftBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("НАЗАД",screenW * 0.36,screenH * 0.84,screenW * 0.49,screenH * 0.91,white,1,font,"center","center")

		dxDrawRoundedRectangle(screenW * 0.53,screenH * 0.84,Buttons[rightBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText("ДАЛЕЕ",screenW * 0.53,screenH * 0.84,screenW * 0.66,screenH * 0.91,white,1,font,"center","center")
	end
end
addEventHandler("onClientRender",root,RenderMenu.render,true,"low")

function onHover()
	if not(Buttons[source].width >= screenW * 0.13) then
		if not(isAnimatedButton(source)) then
			animBtn(source,screenW * 0.13,255,2000)
		end
	end
end
addEventHandler("onDxFocus",leftBtn,onHover)
addEventHandler("onDxFocus",rightBtn,onHover)

function onBlur()
	if selectedMenu ~= source then
		if Buttons[source].width ~= 0 then
			if not(isAnimatedButton(source)) then
				animBtn(source,0,0,500)
			end
		end
	end
end
addEventHandler("onDxBlur",leftBtn,onBlur)
addEventHandler("onDxBlur",rightBtn,onBlur)

function selectLogInWindow(window)
	RenderMenu[window] = true
	for name,_ in pairs(RenderMenu) do
		if name ~= window then
			RenderMenu[name] = false
		end
	end
	if window == "general" then
		addEventHandler("onDxClick",leftBtn,onMainMenuClickBtn)
		addEventHandler("onDxClick",rightBtn,onMainMenuClickBtn)
	end
end

function onMainMenuClickBtn()
	RenderMenu["general"] = false
	if source == leftBtn then
		selectedMenu = "login"
	else
		selectedMenu = "register"
		addEventHandler("onDxClick",leftBtn,onRegMenuClickBtn)
		addEventHandler("onDxClick",rightBtn,onRegMenuClickBtn)
		regWindow = dxCreateWindow(screenW * 0.53,screenH * 0.5,screenW * 0.13,screenH * 0.31,tocolor(0,0,0,50),nil,nil,2,true)
	end
	RenderMenu[selectedMenu] = true
	removeEventHandler("onDxClick",leftBtn,onMainMenuClickBtn)
	removeEventHandler("onDxClick",rightBtn,onMainMenuClickBtn)
end
addEventHandler("onDxClick",leftBtn,onMainMenuClickBtn)
addEventHandler("onDxClick",rightBtn,onMainMenuClickBtn)

function onLoginMenuClickBtn()
	
end

function onRegMenuClickBtn()
	RenderMenu["register"] = false
	if regWindow then
		destroyDxElement(regWindow)
	end
	if source == leftBtn then
		selectLogInWindow("general")
	else
		selectedMenu = "createcharacter"
	end
	removeEventHandler("onDxClick",leftBtn,onRegMenuClickBtn)
	removeEventHandler("onDxClick",rightBtn,onRegMenuClickBtn)
	RenderMenu[selectedMenu] = true
end

function isAnimatedButton(btn)
	return Buttons[btn].anim
end

function animBtn(btn,size,arrwalpha,duration)
	local startTime = getTickCount()
	local func
	func = function()
		Buttons[btn].anim = true
		local now = getTickCount()
		local elapsedTime = now - startTime
		local progress = elapsedTime / duration
		
		Buttons[btn].width = interpolateBetween(Buttons[btn].width,0,0,size,0,0,progress,"Linear")
		arrowAlpha = interpolateBetween(arrowAlpha,0,0,arrwalpha,0,0,progress,"Linear")
		if math.floor(Buttons[btn].width) >= math.floor(size) then
			Buttons[btn].anim = false
			removeEventHandler("onClientRender",root,func)
		end
	end
	addEventHandler("onClientRender",root,func)
end