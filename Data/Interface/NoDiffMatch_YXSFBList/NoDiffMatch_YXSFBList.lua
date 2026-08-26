
local g_unifiedposistion
local g_last_optime		= 1		-- ???????
local g_op_cd			= 1000	-- ??CD
local g_list_max		= 16	-- ??????16?

function NoDiffMatch_YXSFBList_PreLoad()
    this:RegisterEvent("ZBS_REST_BATTLEINFO_SHOW")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function NoDiffMatch_YXSFBList_OnLoad()
	-- 保存界面的默认相对位置
	g_unifiedposistion = NoDiffMatch_YXSFBList_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_YXSFBList_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_YXSFBList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_YXSFBList_ResetPos()
	elseif( event == "ZBS_REST_BATTLEINFO_SHOW" ) then
		NoDiffMatch_YXSFBList_FillListData()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end
function NoDiffMatch_YXSFBList_ClearItemList()
	NoDiffMatch_YXSFBList_List:RemoveAllItem()
end

function NoDiffMatch_YXSFBList_FillListData()
	--NoDiffMatch_YXSFBList_List:RemoveAllItem()
	NoDiffMatch_YXSFBList_ClearItemList()
	
	NoDiffMatch_YXSFBList_List:SetProperty("SortDirection", "None")
	for i=0, g_list_max-1 do
		local sceneID,teamIDA,teamIDB,teamNameA,teamNameB = ZBS:GetRestBattleInfo(i)
		if sceneID == nil or sceneID <= 0 then
			break
		end
		NoDiffMatch_YXSFBList_List:AddNewItem(tostring(i+1),0,i)
		NoDiffMatch_YXSFBList_List:AddNewItem(tostring(teamIDA),1,i)
		NoDiffMatch_YXSFBList_List:AddNewItem(teamNameA,2,i)
		NoDiffMatch_YXSFBList_List:AddNewItem(tostring(teamIDB),3,i)
		NoDiffMatch_YXSFBList_List:AddNewItem(teamNameB,4,i)
	end
	this:Show()
end

function NoDiffMatch_YXSFBList_List_On_SelectionChanged()

end

function NoDiffMatch_YXSFBList_CloseClicked()
    this:Hide()
end

function NoDiffMatch_YXSFBList_RefreshClicked()
	-- 不让瞎点
	if NoDiffMatch_YXSFBList_CheckOpCD() < 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnRefreshMatchList")
		Set_XSCRIPT_ScriptID(889963)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function NoDiffMatch_YXSFBList_EnterClicked()

	local nIndex = NoDiffMatch_YXSFBList_List:GetSelectItem()
	if nIndex == -1 then
		return
	end

	local sceneID,teamIDA,teamIDB,teamNameA,teamNameB = ZBS:GetRestBattleInfo(nIndex)
	if sceneID == nil or sceneID <= 0 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnEnterBattleField")
		Set_XSCRIPT_ScriptID(889963)
		Set_XSCRIPT_Parameter(0,sceneID)
		Set_XSCRIPT_Parameter(1,teamIDA)
		Set_XSCRIPT_Parameter(2,teamIDB)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_YXSFBList_ResetPos()
	NoDiffMatch_YXSFBList_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function NoDiffMatch_YXSFBList_CheckOpCD()
	local curTime = FindFriendDataPool:GetTickCount()
	if curTime - g_last_optime < g_op_cd then
		PushDebugMessage("#{WCBZ_220809_49}")
		return 0
	else
		g_last_optime = curTime
	end

	return 1
end
