local tagFont = nil

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1
	local sx, sy = getScreenFromWorldPosition(x, y, z+height)
	if(sx) and (sy) then
		local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		if(distanceBetweenPoints < distance) then
			dxDrawText(text, sx+1, (sy/1.1)+1, sx+1, sy+1, tocolor(0,0,0, 100), size or 1, font or font_montregular, "center", "top")
			dxDrawText(text, sx-1, (sy/1.1)+1, sx+1, sy-1, tocolor(0,0,0, 100), size or 1, font or font_montregular, "center", "top")
			dxDrawText(text, sx+1, (sy/1.1)-1, sx+1, sy-1, tocolor(0,0,0, 100), size or 1, font or font_montregular, "center", "top")
			dxDrawText(text, sx-1, (sy/1.1)-1, sx, sy, tocolor(0,0,0, 100), size or 1, font or font_montregular, "center", "top")
				
			dxDrawText(text, sx, sy/1.1, sx-1, sy-1, tocolor(R or 255, G or 255, B or 255, alpha or 255), size or 1.0, font or font_montregular, "center", "top")
		end
	end
end

function renderTagStreamedInPlayers( )
	for k,v in ipairs(getElementsByType("player",root,true)) do
		if isLogged(v) and getElementData(v,"id")  then
			--if v ~= lp then
				if getPlayerComponentVisible("camerafaded") == false then
					dxDrawTextOnElement(v,getElementData( v,"nick").." [ "..getElementData(v,"id").." ]",1,20,255,255,255)
					if getElementData(v,"afk") then
						afktime = math.floor((getTickCount() - getElementData(v, "afk")) / 1000)
						dxDrawTextOnElement(v,"AFK ",1.2,219, 219, 219)
						dxDrawTextOnElement(v,afktime .. " секунд",1.1,219, 219, 219)
					end
				end
			--end
		end
	end
end
addEventHandler( "onClientRender", getRootElement(), renderTagStreamedInPlayers )


function renderBarStreamedInPlayers()
	for k,v in ipairs(getElementsByType("player"),true) do
		if isLogged(v) and getElementData(v, "id")  then
			local x, y, z = getElementPosition(v)
			local x2, y2, z2 = getCameraMatrix()
			if v ~= lp then
				if (isLineOfSightClear(x, y, z+2, x2, y2, z2)) then
					local sx, sy = getScreenFromWorldPosition(x, y, z+1)
					if(sx) and (sy) then
						local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
						if(distanceBetweenPoints < 20) then													
							dxDrawRectangle(sx / 1.0625, sy/1.02, getPedArmor(v), screenH * 0.01, tocolor(225, 227, 232))
							dxDrawRectangle(sx / 1.0625, sy/0.99, getElementHealth(v), screenH * 0.01, tocolor(255, 0, 0))
							dxDrawLinedRectangle(sx / 1.0625, sy/0.99, 100, screenH * 0.01, tocolor(0,0,0), 2, false)
							if (getPedArmor(v) > 0) then
								dxDrawLinedRectangle(sx / 1.0625, sy/1.02, 100, screenH * 0.01, tocolor(0,0,0), 2, false)
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler( "onClientRender", getRootElement(), renderBarStreamedInPlayers )