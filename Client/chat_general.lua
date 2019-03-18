local chatBox = dgsCreateEdit(14,269,471,26,"",false,nil,tocolor(255,255,255),1,1,nil,tocolor(0, 0, 0, 255))
dgsSetVisible(chatBox,false)
dgsEditSetMaxLength ( chatBox, 62 )
chat_opened = 0
chat_focus = 0
chat_mouse = 0
chat_entries = {} 
chat_entries_index = 1
chat_index = 0

function chatCheck( )
	if isLogged(lp) then
		if chat_opened == 0 then -- если чат не открыт
			addEventHandler("onClientRender",root,openChat) -- отрисовка обводки
			chat_opened = 1 
			dgsSetVisible(chatBox,true) -- показываем чатбокс
			dgsBringToFront( chatBox ) -- переместить на передний фон
			dgsEditSetCaretPosition( chatBox, 1 ) -- установить курсор на 1 символ
			chat_focus = 1
			showCursor(true)
		elseif chat_opened == 1 then -- если чат открыт
			removeEventHandler("onClientRender",root,openChat) -- убираем отрисовку обводки
			chat_opened = 0
			chat_focus = 0
			dgsSetVisible(chatBox,false) -- убираем чатбокс
			showCursor(false)
		end
	end
end

function ChatYcheck()
	if isLogged(lp) then
		if chat_opened == 0 then
			addEventHandler("onClientRender",root,openChat) -- отрисовка обводки
			chat_opened = 1 
			dgsSetVisible(chatBox,true) -- показываем чатбокс
			dgsBringToFront( chatBox ) -- переместить на передний фон
			dgsEditSetCaretPosition( chatBox, 1 ) -- установить курсор на 1 символ
			chat_focus = 1
			showCursor(true)
		end
	end
end

bindKey("F6","down",chatCheck)
bindKey("y","up",ChatYcheck)

function selectMessage(btn,press)
	if press and chat_opened then
		if btn == "arrow_u" then
			local text = dgsGetText( chatBox ) -- текст из эдитбокса
			if chat_entries_index > 1 then
				if string.len(text) > 0 then
					chat_entries[chat_entries_index+1] = text
				end
				chat_entries_index = chat_entries_index-1
				dgsSetText(chatBox, chat_entries[chat_entries_index])
			end
		elseif btn == "arrow_d" then
			if chat_entries_index+1 ~= #chat_entries+2 then
				chat_entries_index = chat_entries_index+1
				if chat_entries[chat_entries_index] == nil then
					dgsSetText(chatBox, "")
				else
					dgsSetText(chatBox, chat_entries[chat_entries_index])
				end
			end
		end
	end
end
addEventHandler("onClientKey",root,selectMessage)


function openChat( )
	dxDrawRectangle(10, 265, 479, 34, tocolor(55, 55, 55, 255), false)
end

function onPlayerEnterMessage( )
	local text = removeHex(dgsGetText( chatBox )) -- текст из эдитбокса
	local iftext = string.gsub(text,"%s+", "") -- проверка не пустой ли текст без пробелов
	if string.len(iftext) > 0 then
		chat_entries[#chat_entries+1] = text
		chat_entries_index = chat_entries_index+1
		if (text:sub(1,1) == "/") then -- если текст команда
			local cmd = split(text:sub(2), " ")
			triggerServerEvent("sendCommand", lp, cmd)
		else
			
			triggerServerEvent("sendMessage",lp,lp,15,nil, getElementData(lp,"nick").."[ "..getElementData(lp,"id").." ]: "..text)
		end
		clearChatBox()
	else
		removeEventHandler("onClientRender",root,openChat) -- убираем отрисовку обводки
		chat_opened = 0
		dgsSetVisible(chatBox,false) -- убираем чатбокс
		showCursor(false)
	end
end

function chat_onDGSFocus() -- фокус чатбокса
	chat_focus = 1
end

function chat_onDGSBlur()
	chat_focus = 0
end

function outputChatMessage( msg, hexColor ) -- написать сообщение
	if hexColor == nil then
		hexColor = "#FFFFFF"
	end
	table.insert(chat_messages,hexColor .. "[ "..hours..":"..minutes..":"..seconds.." ] "..msg) -- исёртим сообщение в таблицу
	TextFuel() -- отрисовываем чат
	chat_index = chat_index + 1
end
addEvent("outputChatMessage",true) -- добавляем ивент для триггера с серверной части
addEventHandler("outputChatMessage",root,outputChatMessage) -- добавляем хандлер ивента

function outputAdminChatMessage( msgNick, msg )
	local message = ""
	for i, theMsg in pairs(msg) do
		message = message.." "..theMsg
	end
	outputChatMessage("[ Admin Chat ]: "..msgNick..message,"#ADFF2F")
end
addEvent( "outputAdminChatMessage",true)
addEventHandler( "outputAdminChatMessage", root, outputAdminChatMessage)


function clearChatBox( )
	dgsSetText ( chatBox, "" ) -- обнуление текста
	dgsSetVisible(chatBox, false ) -- скрытие эдитбокса
	showCursor (false) -- скрытие курсора
	chat_visible = false -- переменная чата
	removeEventHandler("onClientRender",root,openChat) -- убираем отрисовку обводки
	chat_opened = 0
	chat_focus = 0
end


addEventHandler("onDgsFocus", chatBox, chat_onDGSFocus) --true because for the example we want propagated events
addEventHandler("onDgsBlur", chatBox, chat_onDGSBlur) --true because for the example we want propagated events
addEventHandler( "onDgsEditAccepted", chatBox, onPlayerEnterMessage) -- когда игрок нажал ентер в чатбокс