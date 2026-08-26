local g_TongTianTaTime_Mini_Frame_UnifiedPosition = nil 

function TongTianTaTime_Mini_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TONGTIANTA_MD_SWITCH")
	----------------------
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end 

function TongTianTaTime_Mini_OnLoad()
	g_TongTianTaTime_Mini_Frame_UnifiedPosition = TongTianTaTime_Mini_Frame:GetProperty("UnifiedPosition");
end

function TongTianTaTime_Mini_OnEvent(event)

	if(event == "ADJEST_UI_POS") then
		TongTianTaTime_Mini_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		TongTianTaTime_Mini_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		if GetSceneID() == 764 or GetSceneID() == 765 or GetSceneID() == 766 
		or GetSceneID() == 767 or GetSceneID() == 768 then
			return
		end
		TongTianTaTime_Mini_On_Hide()
	elseif(event == "TONGTIANTA_MD_SWITCH") then
		local opType = tonumber(arg0)
		if opType == 1 then
			this:Show()
		else
			this:Hide()
		end
	end
end


function TongTianTaTime_Mini_On_ResetPos()
	TongTianTaTime_Mini_Frame:SetProperty("UnifiedPosition", g_TongTianTaTime_Mini_Frame_UnifiedPosition)
end


function TongTianTaTime_Mini_Open()
	PushEvent("TONGTIANTA_MD_SWITCH",2)
end


function TongTianTaTime_Mini_On_Hide()
	this:Hide()
end