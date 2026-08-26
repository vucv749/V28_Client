
local g_unifiedposistion
local g_last_optime		= 1		-- ???????
local g_op_cd			= 1000	-- ??CD
local g_list_max		= 32	-- ??????32?

function NoDiffMatch_ZJSGMList_PreLoad()
    this:RegisterEvent("ZBS_REST_TEAMINFO_SHOW")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function NoDiffMatch_ZJSGMList_OnLoad()
	-- 保存界面的默认相对位置
	g_unifiedposistion = NoDiffMatch_ZJSGMList_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_ZJSGMList_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		NoDiffMatch_ZJSGMList_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NoDiffMatch_ZJSGMList_ResetPos()
	elseif( event == "ZBS_REST_TEAMINFO_SHOW" ) then
		NoDiffMatch_ZJSGMList_FillListData()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end
function NoDiffMatch_ZJSGMList_ClearItemList()
	NoDiffMatch_ZJSGMList_List:RemoveAllItem()
end

function NoDiffMatch_ZJSGMList_FillListData()
	--NoDiffMatch_ZJSGMList_List:RemoveAllItem()
	NoDiffMatch_ZJSGMList_ClearItemList()
	
	NoDiffMatch_ZJSGMList_List:SetProperty("SortDirection", "None")
	for i=0, g_list_max-1 do
		local teamID,count,teamname,leader,deputy = ZBS:GetRestTeamInfo(i)
		if teamID == nil or teamID <= 0 then
			break
		end
		NoDiffMatch_ZJSGMList_List:AddNewItem(tostring(teamID),0,i)
		NoDiffMatch_ZJSGMList_List:AddNewItem(tostring(teamname),1,i)
		NoDiffMatch_ZJSGMList_List:AddNewItem(tostring(count),2,i)
		NoDiffMatch_ZJSGMList_List:AddNewItem(tostring(leader),3,i)
		NoDiffMatch_ZJSGMList_List:AddNewItem(tostring(deputy),4,i)
	end
	
	this:Show()
end

function NoDiffMatch_ZJSGMList_List_On_SelectionChanged()

end

function NoDiffMatch_ZJSGMList_CloseClicked()
    this:Hide()
end

function NoDiffMatch_ZJSGMList_RefreshClicked()
	-- 不让瞎点
	if NoDiffMatch_ZJSGMList_CheckOpCD() < 1 then
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnRefreshTeamList")
		Set_XSCRIPT_ScriptID(889963)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

-- function NoDiffMatch_ZJSGMList_EnterClicked()

-- 	local nIndex = NoDiffMatch_ZJSGMList_List:GetSelectItem()
-- 	if nIndex == -1 then
-- 		return
-- 	end
-- 	local teamID,teamname,count = ZBS:GetRestTeamInfo(nIndex)
-- 	if teamID == nil or teamID <= 0 then
-- 		return
-- 	end

-- 	Clear_XSCRIPT()
-- 		Set_XSCRIPT_Function_Name("OnRefreshTeamList")
-- 		Set_XSCRIPT_ScriptID(889963)
-- 		Set_XSCRIPT_ParamCount(0)
-- 	Send_XSCRIPT()
-- end

--================================================
-- 恢复界面的默认相对位置
--================================================
function NoDiffMatch_ZJSGMList_ResetPos()
	NoDiffMatch_ZJSGMList_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function NoDiffMatch_ZJSGMList_CheckOpCD()
	local curTime = FindFriendDataPool:GetTickCount()
	if curTime - g_last_optime < g_op_cd then
		PushDebugMessage("#{WCBZ_220809_49}")
		return 0
	else
		g_last_optime = curTime
	end

	return 1
end
