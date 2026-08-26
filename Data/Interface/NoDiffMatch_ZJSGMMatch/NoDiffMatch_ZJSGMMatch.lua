-- 总决赛GM比赛操作界面
--
local g_unifiedposistion
local g_ui_command_id	= 88996401
local g_op_script_id	= 889964

function NoDiffMatch_ZJSGMMatch_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_ZJSGMMatch_OnLoad()
	-- 保存界面的默认相对位置
	g_unifiedposistion	= NoDiffMatch_ZJSGMMatch_Frame:GetProperty("UnifiedPosition")

	NoDiffMatch_ZJSGMMatch_InitData()
end

function NoDiffMatch_ZJSGMMatch_OnEvent(event)
	if (event == "UI_COMMAND") and tonumber(arg0) == g_ui_command_id then
		NoDiffMatch_ZJSGMMatch_OnShow()
	elseif( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_ZJSGMMatch_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_ZJSGMMatch_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	end
end

function NoDiffMatch_ZJSGMMatch_InitData()
	NoDiffMatch_ZJSGMMatch_Input1:SetText("")
	NoDiffMatch_ZJSGMMatch_Input2:SetText("")
	NoDiffMatch_ZJSGMMatch_select:ResetList();
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("", 0)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_86}", 1)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_87}", 2)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_88}", 3)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_89}", 4)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_90}", 5)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_91}", 6)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_92}", 7)
	NoDiffMatch_ZJSGMMatch_select:AddTextItem("#{WCJS_180522_93}", 8)
	NoDiffMatch_ZJSGMMatch_select:SetCurrentSelect(0)
	NoDiffMatch_ZJSGMMatch_Input1:SetProperty("DefaultEditBox", "True")
end

function NoDiffMatch_ZJSGMMatch_OnShow()
	NoDiffMatch_ZJSGMMatch_InitData()
	this:Show()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_ZJSGMMatch_ResetPos()
	NoDiffMatch_ZJSGMMatch_Frame:SetProperty("UnifiedPosition",g_unifiedposistion)
end

function NoDiffMatch_ZJSGMMatch_Submit_Clicked()

	local nTeamA_ID = NoDiffMatch_ZJSGMMatch_Input1:GetText()
	local nTeamB_ID = NoDiffMatch_ZJSGMMatch_Input2:GetText()

	if nTeamA_ID == nil or nTeamB_ID == nil or nTeamA_ID == "" or nTeamB_ID == "" then
		PushDebugMessage("#{DFSZ_220905_15}")
		return
	end

	if tonumber(nTeamA_ID) == nil or tonumber(nTeamB_ID) == nil then
		PushDebugMessage("#{DFSZ_220905_16}")
		return
	end

	local __txt, idx = NoDiffMatch_ZJSGMMatch_select:GetCurrentSelect()
	if idx <= 0 then
		PushDebugMessage("#{DFSZ_220905_17}")
		return
	end

	--比赛场地、双方战队ID
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSelectTwoTeamsToBattleField")
		Set_XSCRIPT_ScriptID(g_op_script_id)
		Set_XSCRIPT_Parameter(0,tonumber(nTeamA_ID))
		Set_XSCRIPT_Parameter(1,tonumber(nTeamB_ID))
		Set_XSCRIPT_Parameter(2,tonumber(idx))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

	this:Hide()
end

function NoDiffMatch_ZJSGMMatch_Cancel_Clicked()
	NoDiffMatch_ZJSGMMatch_Input1:SetProperty("DefaultEditBox", "False")
	this:Hide()
end
