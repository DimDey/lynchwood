--[[	
	ФАЙЛ СОЗДАН ДЛЯ ТОГО, ЧТОБЫ СКИДЫВАТЬ СЮДА ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ КЛИЕНТСКОЙ ЧАСТИ.
--]]

screenW, screenH = guiGetScreenSize() -- get player`s screen size
sX,sY = screenW, screenH
global_rendertarget = dxCreateRenderTarget( screenW, screenH, true )
api_key = "uRDWClUg73pUDRyrAqtS_5WYczuS7lDF"
resetAmbientSounds()
lp = getLocalPlayer() -- локальный игрок
clp = getCamera()
chat_messages = {} -- сообщения чата
registered = {
    button = {},
    radiobutton = {}
}
yposition = 225

showChat(false)
-- регистрация и авторизация
editWidth = 400
editHeight = 35
male_register_skins = {
	[1] = 47,
	[2] = 98,
	[3] = 46,
	[4] = 60
}

female_register_skins = {
	[1] = 11,
	[2] = 12,
	[3] = 40,
	[4] = 69
}


function getFont(path,size,bold)
	bold = bold or false
	local fontSize = math.ceil((size * screenH) / 1080) 
	font = dxCreateFont(path, fontSize,bold)
	return font
end

function getFontSize(font)
	return getElementData(font,"pt")
end


font_montmediumL = getFont("Fonts/Montserrat-Medium.ttf",9)
font_montmediumXX = getFont("Fonts/Montserrat-Medium.ttf",11,true)
font_montregularB = getFont("Fonts/Montserrat-Regular.ttf",10,false)
font_montregular = getFont("Fonts/Montserrat-Regular.ttf",8)
font_montlight = getFont("Fonts/Montserrat-ExtraLight.ttf",9)
font_montlightX = getFont("Fonts/Montserrat-ExtraLight.ttf",12)


Colors = {
	["general"] = tocolor(21,185,25),
	["grey"] = tocolor(234,234,234)
}

controlTable = { "fire", "aim_weapon", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
 "change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "conversation_yes", "conversation_no",
 "group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
 "steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
 "handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
 "special_control_down", "special_control_up" }

function timestamp( )
	time = getRealTime()
	hours = time.hour
	minutes = time.minute
	seconds = time.second

	if hours <= 9 then -- если час меньше двухзначного числа, то автоматически добавляется ноль в начале
		hours = "0"..hours
	end
	if minutes <= 9 then -- такая же ситуация, как и с часами
		minutes = "0"..minutes
	end
	if seconds <= 9 then -- такая же ситуация, как и с часами
		seconds = "0"..seconds
	end
end
addEventHandler("onClientRender",root,timestamp)