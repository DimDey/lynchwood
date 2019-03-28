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


addEventHandler("onClientResourceStart",resourceRoot,function() -- отключение света в городах
    local shader = dxCreateShader("Shaders/clear.fx") 
    dxSetShaderValue(shader, "color", { 0.0, 0.0, 0.0, 0.0 } ); 
	engineApplyShaderToWorldTexture(shader,"coronastar") 
	engineApplyShaderToWorldTexture(shader,"shad_exp") 
	engineApplyShaderToWorldTexture(shader,"handman") 
	engineApplyShaderToWorldTexture(shader,"sl_dtwinlights*") 
	engineApplyShaderToWorldTexture(shader,"*nite") 
	engineApplyShaderToWorldTexture(shader,"*night") 
	setTrafficLightState ( "disabled" )
end) 

local texturesimg = {
	{"Images/Textures/1.png", "collisionsmoke"},
	{"Images/Textures/2.png", "particleskid"},
	{"Images/Textures/3.png", "cloudmasked"},
	{"Images/Textures/3.png", "cardebris_01"},
	{"Images/Textures/3.png", "cardebris_02"},
	{"Images/Textures/3.png", "cardebris_03"},
	{"Images/Textures/3.png", "cardebris_04"},
	{"Images/Textures/3.png", "cardebris_05"},
	{"Images/Textures/4.png", "headlight1"},
	{"Images/Textures/5.png", "headlight"},
	{"Images/Textures/3.png", "cloudhigh"}
}
addEventHandler("onClientResourceStart", resourceRoot, function()
	for i = 1, #texturesimg do
		local shader = dxCreateShader("Shaders/retexture.fx")
		engineApplyShaderToWorldTexture(shader, texturesimg[i][2])
		dxSetShaderValue(shader, "Tex0", dxCreateTexture(texturesimg[i][1]))
	end
end)
	