local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function NewZhuXian_Task_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function NewZhuXian_Task_OnLoad()

	g_Frame_UnifiedPosition = NewZhuXian_Task_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function NewZhuXian_Task_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89015401 then

		local param = Get_XParam_INT(0)
		if param == 1 then
			--打开界面
			NewZhuXian_Task_ShowFrame()
		elseif param == 2 then
			--自动寻路：找npc
			NewZhuXian_Task_GoToFindNpc()
		elseif param == 3 then
			--关闭界面
			NewZhuXian_Task_OnHiden()
		end
		
	elseif event == "HIDE_ON_SCENE_TRANSED" then

		NewZhuXian_Task_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		NewZhuXian_Task_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		NewZhuXian_Task_ResetPos()
	
	end

end

function NewZhuXian_Task_ShowFrame()
	this:Show()
end

--点击：前往server判断，是否可以寻路找npc
function NewZhuXian_Task_Clicked()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GotoFindNpc");
		Set_XSCRIPT_ScriptID(890154);
		   --Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();

	NewZhuXian_Task_OnHiden()
end

--响应：通过server判断，可以寻路找npc
function NewZhuXian_Task_GoToFindNpc()

	AutoRuntoTargetExWithName(63, 53, 613, "墨知愁")

	NewZhuXian_Task_OnHiden()
end

--调整：界面位置
function NewZhuXian_Task_ResetPos()

	NewZhuXian_Task_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function NewZhuXian_Task_OnHiden()
	this:Hide()
end
