local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function JiangHuZhi_Letter_PreLoad()

	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function JiangHuZhi_Letter_OnLoad()
	g_Frame_UnifiedPosition = JiangHuZhi_Letter_Frame:GetProperty("UnifiedPosition")
end

--=========
-- Event
--=========
function JiangHuZhi_Letter_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99878902 ) then

		Lua_ShowQuickEnterPointTip(27,0)

		local type = tonumber(arg1)
		if type == 1 then
			this:Show()
		elseif type == 0 then
			JiangHuZhi_Letter_GoToFindNpc()
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		JiangHuZhi_Letter_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		JiangHuZhi_Letter_On_ResetPos()
    end

end

--=========
--重置
--=========
function JiangHuZhi_Letter_On_ResetPos()
	JiangHuZhi_Letter_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
--按钮点击
--=========
function  JiangHuZhi_Letter_Clicked()
	JiangHuZhi_Letter_AddMission()
end

function  JiangHuZhi_Letter_OnHiden()
	this:Hide()
end


--=========
--兑换召唤券按钮点击
--=========
function JiangHuZhi_Letter_AddMission()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AddMissionToPlayer");
		Set_XSCRIPT_ScriptID(998789);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end

--响应：通过server判断，可以寻路找npc
function JiangHuZhi_Letter_GoToFindNpc()
	AutoRuntoTargetExWithName(150, 208, 1, "百晓生")
	this:Hide()
end