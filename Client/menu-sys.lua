function drawTestMenu()
    x,y = (screenW - 512) / 2, (screenH - 512) / 2
    dxDrawImage((screenW - 512) / 2, (screenH - 512) / 2, 512, 512, "Images/menu-mask.png")
    dxDrawText("Меню",x+100, y+50)
end