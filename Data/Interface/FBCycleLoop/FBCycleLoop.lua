--******************************************
--雁门论武超特服月常界面
--create by  limengyue 
--2025-10-21
--******************************************

local g_FBCycleLoop_Frame_UnifiedPosition;

--=========================================================
--PreLoad
--=========================================================
function FBCycleLoop_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--距离NPC距离
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--切场景事件
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function FBCycleLoop_OnLoad()
	g_FBCycleLoop_Frame_UnifiedPosition	= FBCycleLoop_Frame : GetProperty("UnifiedPosition");
end

--=========================================================
--恢复界面的默认相对位置
--=========================================================
function FBCycleLoop_On_ResetPos()
	FBCycleLoop_Frame : SetProperty("UnifiedPosition", g_FBCycleLoop_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function FBCycleLoop_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89313001 ) then
		--打开界面
		if(IsWindowShow("FBCycleLoop")) then
			CloseWindow("FBCycleLoop", true)
		end
		FBCycleLoop_Open()
	end
	-- 窗口变化
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		FBCycleLoop_On_ResetPos();
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		FBCycleLoop_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       FBCycleLoop_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--打开界面
--=========================================================
function FBCycleLoop_Open()
	--直接显示就行了
	this:Show()

end
--=========================================================
--关闭界面
--=========================================================
function FBCycleLoop_OnClosed()
	this:Hide()
end

--=========================================================
--寻路
--=========================================================
function FBCycleLoop_Goto(nIndex)
	if nIndex == 1 then
		--雁门论武
		AutoRuntoTargetExWithName(59, 95, 0, "孟闯")
	else
		AutoRuntoTargetExWithName(193, 144, 1, "种师道")
	end
end

--=========================================================
--帮助
--=========================================================
function FBCycleLoop_HelpClick()
	PushEvent("QUEST_HELPINFO", "#{CTYM_251020_06}")
end
