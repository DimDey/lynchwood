local leftBtn = dxCreateButton(screenW * 0.36,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,3,true) -- создание кнопки
local rightBtn = dxCreateButton(screenW * 0.53,screenH * 0.84,screenW * 0.13,screenH * 0.07,"",tocolor(0,0,0,50),nil,nil,3,true) -- создание кнопки

local font = getFont("Fonts/Montserrat-Medium.ttf",15,true)
local fontLabel = getFont("Fonts/Montserrat-Medium.ttf",9,true)

local loginEdit = dgsCreateEdit(screenW * 0.54, screenH * 0.55,screenW * 0.1-19, screenH * 0.04, "", false, nil, tocolor(255,255,255), 1, 1, nil, tocolor(0,0,0,0))
local emailEdit = dgsCreateEdit(screenW * 0.54, screenH * 0.61,screenW * 0.1-19, screenH * 0.04,"", false, nil, tocolor(255,255,255), 1, 1, nil, tocolor(0,0,0,0))
local passEdit = dgsCreateEdit(screenW * 0.54, screenH * 0.67,screenW * 0.1-19, screenH * 0.04, "", false, nil, tocolor(255,255,255), 1, 1, nil, tocolor(0,0,0,0))
local passConfirmEdit = dgsCreateEdit(screenW * 0.54, screenH * 0.73,screenW * 0.1-19, screenH * 0.04,"", false, nil, tocolor(255,255,255), 1, 1, nil, tocolor(0,0,0,0))
dgsEditSetMasked(passEdit,true)
dgsEditSetMasked(passConfirmEdit,true)

local Edits = {
	[loginEdit] = {
		label = "Логин",
		logPos = {
			labelX = screenW * 0.37,
			labelY = screenH * 0.66
		},
		regPos = {
			labelX = screenW * 0.54,
			labelY = screenH * 0.54
		},
		statecolor = tocolor(255,255,255),
		success = nil
	},
	[emailEdit] = {
		label = "Почта",
		logPos = {
			labelX = 0,
			labelY = 0
		},
		regPos = {
			labelX = screenW * 0.54,
			labelY = screenH * 0.60
		},
		statecolor = tocolor(255,255,255),
		success = nil
	},
	[passEdit] = {
		label = "Пароль",
		logPos = {
			labelX = screenW * 0.37,
			labelY = screenH * 0.74
		},
		regPos = {
			labelX = screenW * 0.54,
			labelY = screenH * 0.66
		},
		statecolor = tocolor(255,255,255),
		success = nil
	},
	[passConfirmEdit] = {
		label = "Повторите пароль",
		logPos = {
			labelX = 0,
			labelY = 0
		},
		regPos = {
			labelX = screenW * 0.54,
			labelY = screenH * 0.72
		},
		statecolor = tocolor(255,255,255),
		success = nil
	}
}

local Buttons = {
	[leftBtn] = {
		width = 0,
		anim = false
	},
	[rightBtn] = {
		width = 0,
		anim = false
	}
}
local arrowAlpha = 0

function drawLogin()
	for i, editTable in pairs(Edits) do
		if editTable.label == "Логин" or editTable.label == "Пароль" then
			dxDrawText(editTable.label,editTable.logPos.labelX,editTable.logPos.labelY,nil,nil,white,1,fontLabel)
			dxDrawRectangle(editTable.logPos.labelX,editTable.logPos.labelY+screenH * 0.04,screenW * 0.1,2,editTable.statecolor)
			local width,height = dgsGetSize(i)
			if editTable.statecolor == tocolor(21,185,25) then
				dxDrawImage(math.floor(editTable.logPos.labelX+width),math.floor(editTable.logPos.labelY+15),19,19,"Images/mask-success.png")
			elseif editTable.statecolor == tocolor(212,38,42) then
				dxDrawImage(math.floor(editTable.logPos.labelX+width),math.floor(editTable.logPos.labelY+15),19,19,"Images/mask-error.png")
			end
		end
	end
end

function drawReg()
	for i, editTable in pairs(Edits) do
		dxDrawText(editTable.label,editTable.regPos.labelX,editTable.regPos.labelY,nil,nil,white,1,fontLabel)
		dxDrawRectangle(editTable.regPos.labelX,editTable.regPos.labelY+screenH * 0.04,screenW * 0.1,2,editTable.statecolor)
		local width,height = dgsGetSize(i)
		if editTable.statecolor == tocolor(21,185,25) then
			dxDrawImage(math.floor(editTable.regPos.labelX+width),math.floor(editTable.regPos.labelY+15),19,19,"Images/mask-success.png")
		elseif editTable.statecolor == tocolor(212,38,42) then

			dxDrawImage(math.floor(editTable.regPos.labelX+width),math.floor(editTable.regPos.labelY+15),19,19,"Images/mask-error.png")
		end
	end
end

local LogInMenus = {
	["general"] = {
		state = true,
		dxFunc = nil,
		leftLabel = "ВОЙТИ",
		rightLabel = "РЕГИСТРАЦИЯ"
	},
	["login"] = {
		state = false,
		dxFunc = drawLogin,
		leftLabel = "ВОЙТИ",
		rightLabel = "НАЗАД"
	},
	["register"] = {
		state = false,
		dxFunc = drawReg,
		leftLabel = "НАЗАД",
		rightLabel = "ДАЛЕЕ"
	},
	["createcharacter"] = {
		state = false,
		dxFunc = nil,
		leftLabel  = "СОЗДАНИЕ ПЕРСОНАЖА",
		rightLabel = "СОЗДАНИЕ ПЕРСОНАЖА"
	}
}
local selectedMenu = "general"

function onStartResourceFunction()
	dgsSetVisible(loginEdit,false)
	dgsSetVisible(emailEdit,false)
	dgsSetVisible(passEdit,false)
	dgsSetVisible(passConfirmEdit,false)

	fadeCamera(true)
	setCameraTarget(lp)
	setCameraMatrix(-369.0126953125, -1541.95703125,36.245861053467,-333.9208984375,-1448.4169921875,31.908327102661)
	showCursor(true)
end
addEventHandler("onClientResourceStart",resourceRoot,onStartResourceFunction)

function MenuRender()
	if LogInMenus[selectedMenu] then
		dxDrawImage(screenW * 0.67,screenH * 0.86,24,24,"Images/mm-arrow.png",0,0,0,tocolor(255,255,255,arrowAlpha))

		dxDrawRoundedRectangle(screenW * 0.36,screenH * 0.84,Buttons[leftBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText(LogInMenus[selectedMenu].leftLabel,screenW * 0.36,screenH * 0.84,screenW * 0.49,screenH * 0.91,white,1,font,"center","center")

		dxDrawRoundedRectangle(screenW * 0.53,screenH * 0.84,Buttons[rightBtn].width,screenH * 0.07,"",nil,tocolor(14,168,18,255),2,false)
		dxDrawText(LogInMenus[selectedMenu].rightLabel,screenW * 0.53,screenH * 0.84,screenW * 0.66,screenH * 0.91,white,1,font,"center","center")
		if LogInMenus[selectedMenu].dxFunc ~= nil then
			LogInMenus[selectedMenu].dxFunc()
		end
	end
end
addEventHandler("onClientRender",root,MenuRender,true,"low")

function onHover()
	if not(Buttons[source].width >= screenW * 0.13) then
		if not(isAnimatedButton(source)) then
			animBtn(source,screenW * 0.131,255,2000)
		end
	end
end
addEventHandler("onDxFocus",leftBtn,onHover)
addEventHandler("onDxFocus",rightBtn,onHover)

function onBlur()
	if Buttons[source].width ~= 0 then
		if not(isAnimatedButton(source)) then
			animBtn(source,0,0,500)
		end
	end
end
addEventHandler("onDxBlur",leftBtn,onBlur)
addEventHandler("onDxBlur",rightBtn,onBlur)


function onMainMenuClickBtn()
	if LogInMenus["general"].state then
		LogInMenus[selectedMenu].state = false
		if source == leftBtn then
			selectedMenu = "login"
			window = dxCreateWindow(screenW * 0.36,screenH * 0.60,screenW * 0.13, screenH * 0.23,tocolor(0,0,0,50),nil,nil,3,true)
		else
			selectedMenu = "register"
			window = dxCreateWindow(screenW * 0.53,screenH * 0.5,screenW * 0.13,screenH * 0.31,tocolor(0,0,0,50),nil,nil,3,true)
		end
	elseif LogInMenus["login"].state then
		LogInMenus[selectedMenu].state = false
		if source == leftBtn then
			checkLoginEdit()
		else
			selectedMenu = "general"
			if window then
				destroyDxElement(window)
			end
		end
		
	elseif LogInMenus["register"].state then
		if source == leftBtn then
			selectedMenu = "general"
			LogInMenus[selectedMenu].state = false
			if window then
				destroyDxElement(window)
			end
		else
			checkRegisterEdit()
		end
	end
	LogInMenus[selectedMenu].state = true	
	for i,menuTable in pairs(LogInMenus) do
		if menuTable ~= LogInMenus[selectedMenu] then
			menuTable.state = false
		end
	end
	showEdits(selectedMenu)
end
addEventHandler("onDxClick",leftBtn,onMainMenuClickBtn)
addEventHandler("onDxClick",rightBtn,onMainMenuClickBtn)


function checkLoginEdit()
	local loginsuccess,_,passuccess = checkEditText()
	if loginsuccess and passucess then
		LogInMenus[selectedMenu].state = false
		LogInMenus["selectcharacter"].state = true
		if window then
			destroyDxElement(window)
		end
	end
end

function checkRegisterEdit()
	local loginsuccess, emailsuccess, passuccess,passconfsuccess = checkEditText()
	if loginsuccess and emailsuccess and passuccess and passconfsuccess then
		LogInMenus[selectedMenu].state = false
		selectedMenu = "createcharacter"
		if window then
			destroyDxElement(window)
		end
		triggerServerEvent("onPlayerStartSignUp",root,lp,login,pass,email)
	end
end

function showEdits(menu)
	if menu == "login" then
		dgsSetVisible(loginEdit,true)
		dgsSetVisible(passEdit,true)
		dgsSetPosition(loginEdit,screenW * 0.37, screenH * 0.67,false)
		dgsSetPosition(passEdit,screenW * 0.37, screenH * 0.75,false)
	elseif menu == "register" then
		dgsSetVisible(loginEdit,true)
		dgsSetVisible(emailEdit,true)
		dgsSetVisible(passEdit,true)
		dgsSetVisible(passConfirmEdit,true)
		dgsSetPosition(loginEdit,screenW * 0.54, screenH * 0.55,false)
		dgsSetPosition(passEdit,screenW * 0.54, screenH * 0.67,false)
	else	
		dgsSetVisible(loginEdit,false)
		dgsSetVisible(emailEdit,false)
		dgsSetVisible(passEdit,false)
		dgsSetVisible(passConfirmEdit,false)
	end
end

function checkEditText()
	local login        = dgsGetText(loginEdit)
	local email        = dgsGetText(emailEdit)
	local pass  	   = dgsGetText(passEdit)
	local passConfirm  = dgsGetText(passConfirmEdit)
	if string.len(login) > 5 then
		Edits[loginEdit].statecolor = tocolor(21,185,25)
		loginsuccess = true
	else
		Edits[loginEdit].statecolor = tocolor(212,38,42)
		loginsuccess = false
	end
	if email:find("^[%w.]+@%w+%.%w+$") then
		Edits[emailEdit].statecolor = tocolor(21,185,25)
		emailsuccess = true
	else
		Edits[emailEdit].statecolor = tocolor(212,38,42)
		emailsuccess = false
	end
	if string.len(pass) > 6 then
		Edits[passEdit].statecolor = tocolor(21,185,25)
		passsuccess = true
	else
		passsuccess = false
	end
	if pass == passConfirm then
		Edits[passEdit].statecolor = tocolor(212,38,42)
		Edits[passConfirmEdit].statecolor = Edits[passEdit].statecolor
		passconfsuccess = true
	else
		passconfsuccess = false
	end	
	return loginsuccess,emailsuccess,passucess,passconfsuccess
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
		if selectedMenu == "general" then
			arrowAlpha = interpolateBetween(arrowAlpha,0,0,arrwalpha,0,0,progress,"Linear")
		else
			arrowAlpha = 0
		end
		if math.floor(Buttons[btn].width) >= math.floor(size) then
			Buttons[btn].anim = false
			removeEventHandler("onClientRender",root,func)
		end
	end
	addEventHandler("onClientRender",root,func)
end

function removeRegister()
	destroyElement(loginEdit)
	destroyElement(emailEdit)
	destroyElement(passEdit)
	destroyElement(passConfirmEdit)
	destroyElement(emailEdit)
	removeEventHandler("onClientRender",root,MenuRender)
	Edits = nil
end
