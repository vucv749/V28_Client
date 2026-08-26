
local SongliaoWarSingle_Mini_Battle_OneTimeBegin = 10090  --SongliaoWarSingle_Mini.lua 里面有一样的宏
local SongliaoWarSingle_Mini_Battle_OneTimeEnd = 10390
local SongliaoWarSingle_Mini_Battle_TwoTimeBegin = 10450
local SongliaoWarSingle_Mini_Battle_TwoTimeEnd = 10750
local SongliaoWarSingle_Mini_Battle_ThreeTimeBegin = 10810
local SongliaoWarSingle_Mini_Battle_ThreeTimeEnd = 11110
local SongliaoWarSingle_Mini_Battle_FourTimeBegin = 11170
local SongliaoWarSingle_Mini_Battle_FourTimeEnd = 11470--SongliaoWarSingle_Mini.lua 里面有一样的宏
function SongliaoWarSingle_Mini_PreLoad()
	this:RegisterEvent("SONGLIAOSINGLE_MINI");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function SongliaoWarSingle_Mini_OnLoad()
end

function SongliaoWarSingle_Mini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event=="SONGLIAOSINGLE_MINI") then
		
		if arg0=="0" then
			this:Show()
		end
	end
end

function SongliaoWarSingle_Mini_Open()
	this:Hide()
	PushEvent("SONGLIAOSINGLE_MINI",1)
end

