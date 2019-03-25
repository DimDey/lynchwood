local screenWidth, screenHeight = guiGetScreenSize()
local screenSource	= dxCreateScreenSource(screenWidth, screenHeight)
local darkness		= 0.8
local radius		= 2

function createVignette()
    vignetteShader = dxCreateShader("Shaders/vignette.fx")
end
addEventHandler("onClientResourceStart", resourceRoot, createVignette)

function dxDrawVignette()
    dxUpdateScreenSource(screenSource)
		if(vignetteShader) then
		    dxSetShaderValue(vignetteShader, "ScreenSource", screenSource);
			dxSetShaderValue(vignetteShader, "radius", radius);
			dxSetShaderValue(vignetteShader, "darkness", darkness);
			dxDrawImage(0, 0, screenWidth, screenHeight, vignetteShader)
		end
end

addEventHandler("onClientPreRender", root, dxDrawVignette)