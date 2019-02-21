function isLocalPlayerActive ()
	if isMainMenuActive() and not(getElementData(lp,"afk")) then
		setElementData(lp,"afk",getTickCount())
	elseif isMainMenuActive() == false then
		setElementData(lp,"afk",false)
	end
end
addEventHandler( "onClientRender", getRootElement(), isLocalPlayerActive )


function onMinimize()
	setElementData(lp,"afk",getTickCount())
end
addEventHandler( "onClientMinimize",root,onMinimize )

function onRestore()
	if not(isMainMenuActive()) then
		setElementData(lp,"afk",false)
	end
end
addEventHandler( "onClientRestore", root, onRestore )