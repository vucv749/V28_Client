
function Makefriends_Activity_WatchMini_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("MAKEFRIENDS_WATCH_CLOSE");
	this:RegisterEvent("JIAOYOU_SHOW_FINAL");
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED");
end

function Makefriends_Activity_WatchMini_OnLoad()
end

function Makefriends_Activity_WatchMini_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		this:Hide()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	elseif (event=="MAKEFRIENDS_WATCH_CLOSE") then
		if arg0=="0" then
			this:Show()
		else
			this:Hide()
		end
	elseif( event == "JIAOYOU_SHOW_FINAL" ) then
		this:Hide();
	end
end

function Makefriends_Activity_WatchMini_OnShowNormalUI()
	this:Hide()
	PushEvent("MAKEFRIENDS_WATCH_CLOSE",1)
end

