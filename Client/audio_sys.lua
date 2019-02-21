function startLoad(path)
	if not(fileExists(path)) then
		downloadFile(path)
    end
end


function playBackgroundMusic()
    if isLogged(lp) then
        local hour,minute = getTime()
        if hour > 0 and hour < 20 then
            startLoad("Audio/lesden.mp3")
            bgmusic = playSound("Audio/lesden.mp3")
        else
            startLoad("Audio/lesnoch.mp3")
            bgmusic = playSound("Audio/lesnoch.mp3")
        end
        setSoundVolume(bgmusic,1.0)
    end
end
setTimer(playBackgroundMusic,80000,0)
--1500000

function isSoundFinished(theSound)
    return ( getSoundPosition(theSound) == getSoundLength(theSound) )
end