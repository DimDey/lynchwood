-- ВЫБОР СКИНА ПРИ РЕГЕ
function registerMenu()
	dxDrawRectangle(1121, 231, 309, 233, tocolor(0, 0, 0, 165), false)
    dxDrawRectangle(1126, 344, 142, 35, tocolor(0, 0, 0, 255), true)
    dxDrawRectangle(1123, 231, 307, 22, tocolor(25, 25, 25, 255), false)
    dxDrawText("Регистрация персонажа", 1123, 231, 1430, 253, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
   	dxDrawText("Пол персонажа:", 1128, 269, 1229, 292, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, true, false, false)
    dxDrawText("Выбор скина:", 1123, 312, 1430, 336, tocolor(255, 255, 255, 255), 1.00, "default", "center", "center", false, false, true, true, false)
    dxDrawRectangle(1128, 344, 142, 35, tocolor(0, 0, 0, 255), true)
    dxDrawText("Предыдущий", 1128, 344, 1268, 377, tocolor(192, 192, 192, 255), 1.00, "default", "center", "center", false, false, true, true, false)
    dxDrawRectangle(1278, 344, 142, 35, tocolor(0, 0, 0, 255), true)
    dxDrawText("Следущий", 1278, 345, 1418, 378, tocolor(192, 192, 192, 255), 1.00, "default", "center", "center", false, false, true, true, false)
    dxDrawRectangle(1133, 398, 280, 38, tocolor(17, 0, 0, 255), true)
    dxDrawText("Далее", 1134, 399, 1413, 436, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, true, false)
end

function registerClick( button, state, absoluteX, absoluteY )
	if source == registered.button[1] then -- кнопка предыдущий
		selectedSkin = selectedSkin -1 -- уменьшение выбор
		if selectedSkin <= 0 then -- если выбранный скин равен или меньше нуля
			if selectedgender == 1 then
				selectedSkin = #male_register_skins -- выбранный скин = конец массива со скинами
			elseif selectedgender == 2 then
				selectedSkin = #female_register_skins -- выбранный скин = конец массива со скинами
			end
		end
		--outputDebugString(selectedSkin) -- дебаг выбранного скина
		setSkin( lp, selectedSkin ) -- функция смены скина персонажа
	elseif source == registered.button[2] then -- следующий
		selectedSkin = selectedSkin + 1 -- увеличение выбора
		if selectedgender == 1 then
			if selectedSkin > #male_register_skins then -- если выбор больше массива
				selectedSkin = 1 -- выбранный скин = 1
			end
		elseif selectedgender == 2 then
			if selectedSkin > #female_register_skins then -- если выбор больше массива
				selectedSkin = 1 -- выбранный скин = 1
			end
		end
		setSkin( lp, selectedSkin ) -- сет скина
		--outputDebugString(selectedSkin) --дебаг
	elseif source == registered.button[3] then -- далее
		selectSkin()
	elseif source == registered.radiobutton[2] then
		selectedgender = 1
		selectedSkin = 1
		setElementModel(lp,male_register_skins[1])
	elseif source == registered.radiobutton[1] then
		selectedgender = 2
		selectedSkin = 1
		setElementModel(lp,female_register_skins[1])
	end
end


function setSkins() -- смена скина при реге
	selectedSkin = 1
	selectedgender = 1
	setElementModel(lp, male_register_skins[selectedSkin])
	addEventHandler("onClientRender",root,rotatePed)
	outputChatMessage("Выберите ваш будущий скин. Вращение: стрелочка влево, стрелочка вправо.")

	addEventHandler("onClientRender",root,registerMenu)
	addEventHandler("onClientGUIClick",registered.button[1],registerClick)
	addEventHandler("onClientGUIClick",registered.button[2],registerClick)
	addEventHandler("onClientGUIClick",registered.button[3],registerClick)
	addEventHandler("onClientGUIClick",registered.radiobutton[1],registerClick)
	addEventHandler("onClientGUIClick",registered.radiobutton[2],registerClick)

	guiSetVisible( registered.button[1], true)
	guiSetVisible( registered.button[2], true)
	guiSetVisible( registered.button[3], true)
	guiSetVisible( registered.button[3], true)

	guiSetVisible( registered.radiobutton[1], true)
	guiSetVisible( registered.radiobutton[2], true)
end
addEvent("setSkin",true)
addEventHandler("setSkin", root, setSkins)

function rotatePed()
	local rotX, rotY, rotZ = getElementRotation(localPlayer) -- get the local players's rotation
	if getKeyState("arrow_l") then
    	setElementRotation(localPlayer,0,0,rotZ-1,"default",true) -- turn the player 1 degrees
	elseif getKeyState("arrow_r") then
    	setElementRotation(localPlayer,0,0,rotZ+1,"default",true) -- turn the player 1 degrees
	end
end


function setSkin( lp, skin ) -- функция сета скина
	if selectedgender == 1 then
		setElementModel(lp, male_register_skins[skin])
	elseif selectedgender == 2 then
		setElementModel(lp, female_register_skins[skin])
	end
end

function selectSkin( ) -- выбор скина
	showCursor(false)
	
	setElementData(lp, "gender",selectedgender)
	if selectedgender == 1 then
		setElementData(lp,"skin",male_register_skins[selectedSkin])
		setElementData( lp, "walkstyle", 1 )
		setPedWalkingStyle( lp, 0 )
		triggerServerEvent("addDataToDataBase",lp,getElementData(lp,"nick"),'walkstyle',getElementData(lp,"walkstyle"))
	elseif selectedgender == 2 then
		setElementData(lp,"skin",female_register_skins[selectedSkin])
		setElementData(lp,"walkstyle",4)
		setPedWalkingStyle( lp, 129)
		triggerServerEvent("addDataToDataBase",lp,getElementData(lp,"nick"),'walkstyle',getElementData(lp,"walkstyle"))
	end
	triggerServerEvent("addDataToDataBase",lp,getElementData(lp,"nick"),'skin',getElementData(lp,"skin"))
	
	triggerServerEvent("addDataToDataBase",lp,getElementData(lp,"nick"),'gender',selectedgender)
	setElementData(lp, "logged", true)
	removeEventHandler("onClientRender",root,registerMenu)

	removeEventHandler("onClientGUIClick",registered.button[1],registerClick)
	removeEventHandler("onClientGUIClick",registered.button[2],registerClick)
	removeEventHandler("onClientGUIClick",registered.button[3],registerClick)
	removeEventHandler("onClientGUIClick",registered.radiobutton[1],registerClick)
	removeEventHandler("onClientGUIClick",registered.radiobutton[2],registerClick)
	removeEventHandler("onClientRender",root,rotatePed)

	guiSetVisible( registered.button[1], false)
	guiSetVisible( registered.button[2], false)
	guiSetVisible( registered.button[3], false)
	guiSetVisible( registered.button[3], false)

	guiSetVisible( registered.radiobutton[1], false)
	guiSetVisible( registered.radiobutton[2], false)

	showCursor(false)
	triggerServerEvent("onClientEndRegister",root,lp,getElementData(lp,"skin"))
end