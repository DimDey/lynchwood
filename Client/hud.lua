local walletrectangle = dxCreateRoundedTexture(screenW * 0.8931, screenH * 0.1178, screenW * 0.1215, screenH * 0.0400,12,"Images/wallet-mask.png")
function dxDrawLogo()
    if isLogged(lp) and not(PlayerSettings["camerafaded"]) then
        dxDrawImage(screenW * 0.8931, screenH * 0.1178, screenW * 0.1215, screenH * 0.0400,walletrectangle)

        dxDrawImage(screenW * 0.8479, screenH * -0.0644, 219, 219, "Images/biglogo.png" )

        dxDrawImage(screenW * 0.9028, screenH * 0.1267, screenW * 0.0125, screenH * 0.0200, "Images/wallet.png")

        dxDrawText(getPlayerMoney(), screenW * 0.9222, screenH * 0.1244, screenW * 0.9951, screenH * 0.1467, tocolor(255, 255, 255, 255), 1.00, font_montlightX, "center", "center")
    end
end
addEventHandler("onClientRender",root,dxDrawLogo)