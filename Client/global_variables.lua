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
SERVERNAME = "UNKNOWN ROLEPLAY"
SERVERVER = "0.01"
SERVERCOLORS = {
	GENERAL =  tocolor(255,106,19),
	RED     =  tocolor(236,32,32)
}

exports.dgs:dgsSetRenderSetting("postGUI",false)
exports.dgs:dgsSetRenderSetting("renderPriority","normal-1")
showChat(false)
-- регистрация и авторизация
editWidth = 400
editHeight = 35

function getFont(path,size,bold)
	bold = bold or false
	local fontSize = math.ceil((size * screenH) / 1080) 
	font = dxCreateFont(path, fontSize,bold)
	return font
end

function getFontSize(font)
	return getElementData(font,"pt")
end

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