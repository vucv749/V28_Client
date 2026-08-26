--2025巅峰系统引导任务

local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function Peak_GuideLetter_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function Peak_GuideLetter_OnLoad()

	g_Frame_UnifiedPosition = Peak_GuideLetter_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function Peak_GuideLetter_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 9998401 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--打开界面
			this:Show()
		elseif param == 2 then
			--自动寻路：找npc
			Peak_GuideLetter_GoToFindNpc()
			--关闭界面
			Peak_GuideLetter_OnClose()			
		elseif param == 3 then
			--关闭界面
			Peak_GuideLetter_OnClose()
		elseif param == 4 then
			--打开巅峰系统的界面
			TogglePeak()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		Peak_GuideLetter_OnClose()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Peak_GuideLetter_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Peak_GuideLetter_ResetPos()
	
	end

end

--点击：前往server判断，是否可以寻路找npc
function Peak_GuideLetter_OnGoButtonClicked()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenUI");
		Set_XSCRIPT_ScriptID(999840);
		Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
end

--响应：通过server判断，可以寻路找npc
function Peak_GuideLetter_GoToFindNpc()
	
	AutoRuntoTargetExWithName(219, 43, 2, "玄智法师") --替代
	
end

--调整：界面位置
function Peak_GuideLetter_ResetPos()

	Peak_GuideLetter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function Peak_GuideLetter_OnClose()
	this:Hide()
end

