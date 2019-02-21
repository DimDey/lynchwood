function dxDrawChatScrollBar( )
	if chat_opened == 1 then
		if not(#chat_messages <= 14) then
			local TotalMessagesNum = #chat_messages
			local ChatLinesNum = 14
			local CurrentLine = chat_index
			local chatW, chatH = 700, 227
			local scrollwidth = 2
			local scrollheight = 75
			local scrollx = 0
			local ScrollValue = math.min(TotalMessagesNum-ChatLinesNum, CurrentLine)-- спасибо TEDERIs за код
			local ScrollY = ScrollValue * (chatH - scrollheight)
			dxDrawRectangle( scrollx, ScrollY, scrollwidth, scrollheight, tocolor( 111, 168, 252 ) )
		end
	end
end
addEventHandler( "onClientRender", getRootElement(), dxDrawChatScrollBar )