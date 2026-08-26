--*********************************
--激活扫荡特权界面
--*********************************

-- 界面的默认相对位置
local g_SweepAll_Activate_Frame_UnifiedXPosition;
local g_SweepAll_Activate_Frame_UnifiedYPosition;


function SweepAll_Activate_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);

	this:RegisterEvent("OPEN_SECKILL_LIST")
	this:RegisterEvent("UI_COMMAND")
end

function SweepAll_Activate_OnLoad()
	g_SweepAll_Activate_Frame_UnifiedXPosition	= SweepAll_Activate_Frame : GetProperty("UnifiedXPosition");
	g_SweepAll_Activate_Frame_UnifiedYPosition	= SweepAll_Activate_Frame : GetProperty("UnifiedYPosition");
end

-- OnEvent
function SweepAll_Activate_OnEvent(event)
	if (event == "OPEN_SECKILL_LIST" ) then
		if not this:IsVisible() then
			SendSecKillDataMsg()
		end

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SweepAll_Activate_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		SweepAll_Activate_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		SweepAll_Activate_OnClosed()
	elseif (event == "UI_COMMAND" ) then
		--PushDebugMessage(tonumber(arg0))
		if tonumber(arg0) == 20221115 then
			local opt = Get_XParam_INT(0)
			if 0 == opt then
				if not this:IsVisible() then
					this:Show()
				else
					SweepAll_Activate_Close()
				end
			elseif 1 == opt then
				--激活成功关闭当前界面
				SweepAll_Activate_Close()
			end
		end
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SweepAll_Activate_Frame_On_ResetPos()
	SweepAll_Activate_Frame : SetProperty("UnifiedXPosition", g_SweepAll_Activate_Frame_UnifiedXPosition);
	SweepAll_Activate_Frame : SetProperty("UnifiedYPosition", g_SweepAll_Activate_Frame_UnifiedYPosition);
end

function SweepAll_Activate_Close()
	this:Hide();
end

function SweepAll_Activate_HelpClicked()
	PushEvent("OPEN_SWEEPPAGE_QUEST", "SweepAll_Activate_ExplainHelp") 
end

function SweepAll_Activate_Monthly_Clicked()
	if Player:GetLevel() < 60 then
        PushDebugMessage("#{TQJF_221108_05}")
	return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OpenTeQuan")
	Set_XSCRIPT_ScriptID(891062)
	Set_XSCRIPT_Parameter(0,1);  --open
	Set_XSCRIPT_Parameter(1,0);  --confirm
	Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()	

end
function SweepAll_Activate_Daily_Clicked()
	if Player:GetLevel() < 60 then
        PushDebugMessage("#{TQJF_221108_05}")
	return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OpenTeQuan")
	Set_XSCRIPT_ScriptID(891062)
	Set_XSCRIPT_Parameter(0,2);  --open
	Set_XSCRIPT_Parameter(1,0);  --confirm
	Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()	

end
