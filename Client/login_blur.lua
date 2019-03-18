Blur = {}
Blurs = {}

local shader = false
local renderTarget = false
local screenSource = false
local blurW, blurH = guiGetScreenSize()

function Blur.createShader()
	shader = dxCreateShader("Shaders/login_blur.c")

	if not shader then
		outputDebugString("Failed to create blur shader")
		return false
	end

	renderTarget = dxCreateRenderTarget(blurW, blurH, true)

	if not renderTarget then
		destroyElement(shader)
		shader = false
		outputDebugString("Failed to create a render target for blur shader")
		return false
	end

	screenSource = dxCreateScreenSource(blurW, blurH)

	if not screenSource then
		destroyElement(renderTarget)
		destroyElement(shader)
		shader = false
		renderTarget = false
		outputDebugString("Failed to create a screen source for blur shader")
		return false
	else
		dxSetShaderValue(shader, 'texture0', renderTarget)
	end
	return true
end
addEventHandler( "onClientResourceStart", getRootElement(), Blur.createShader )

function Blur.render()
	strength = 9
	-- Update screen source
	dxUpdateScreenSource(screenSource, true)
	
	-- Switch rendering to our render target
	dxSetRenderTarget(renderTarget, false)
	-- Prepare render target content
	dxDrawImage(0, 0, blurW, blurH, screenSource)
	
	-- Repeat shader align on the image inside the render target
	for i = 0, 6 do
		dxSetShaderValue(shader, 'factor', 0.00005 * strength + (i / 0.15 * 0.00001 * strength))
		dxDrawImage(0, 0, blurW, blurH, shader)
	end
		
	-- Restore the default render target
	dxSetRenderTarget()
end

function Blur:getScreenTexture()
	return renderTarget
end