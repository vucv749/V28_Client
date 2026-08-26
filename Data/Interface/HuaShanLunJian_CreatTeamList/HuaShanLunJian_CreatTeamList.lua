-- 新6v6 查看已组建牻队

local HuaShanLunJian_CreateTeamList_UnifiedPosition = nil

local HuaShanLunJian_CreateTeamList_TargetObjId = -1
local HuaShanLunJian_CreateTeamList_TargetSvrId = 0
local HuaShanLunJian_CreateTeamList_TeamCount = 0
local HuaShanLunJian_CreateTeamList_CurPage = 0
local HuaShanLunJian_CreateTeamList_MaxPage = 0
local HuaShanLunJian_CreateTeamList_MaxTeam = 0

local HuaShanLunJian_CreateTeamList_OpCD = 2000				-- ??CD
local HuaShanLunJian_CreateTeamList_LastOpTime = 1			-- ???????
local HuaShanLunJian_CreateTeamList_TeamCountPerPage = 10	-- ????????



function HuaShanLunJian_CreatTeamList_PreLoad()
	this:RegisterEvent("XBW_TEAMINFOLIST_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end -- end func HuaShanLunJian_CreatTeamList_PreLoad()

function HuaShanLunJian_CreatTeamList_OnEvent(event)
	if event == "XBW_TEAMINFOLIST_SHOW" then
		local targetId = tonumber(arg0)
		local teamCount = tonumber(arg1)
		local teamMaxCount = tonumber(arg2)
		local startPage = tonumber(arg3)
		HuaShanLunJian_CreatTeamList_OnShow(targetId, teamCount, teamMaxCount, startPage)
	elseif event == "ADJEST_UI_POS" then
		HuaShanLunJian_CreatTeamList_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		HuaShanLunJian_CreatTeamList_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		HuaShanLunJian_CreatTeamList_CloseClicked()
	end
end -- end func HuaShanLunJian_CreatTeamList_OnEvent()

function HuaShanLunJian_CreatTeamList_OnLoad()
	HuaShanLunJian_CreatTeamList_ResetControl()
	HuaShanLunJian_CreateTeamList_UnifiedPosition = HuaShanLunJian_CreatTeamList_Frame:GetProperty("UnifiedPosition")
end -- end func HuaShanLunJian_CreatTeamList_OnLoad()

function HuaShanLunJian_CreatTeamList_ResetPos()
	HuaShanLunJian_CreatTeamList_Frame:SetProperty("UnifiedPosition", HuaShanLunJian_CreateTeamList_UnifiedPosition)
end -- end func HuaShanLunJian_CreatTeamList_ResetPos()

function HuaShanLunJian_CreatTeamList_ResetControl()
	HuaShanLunJian_CreatTeamList_ListInfo:RemoveAllItem()
    HuaShanLunJian_CreatTeamList_TeamInfo:Disable()
	local toptext = ScriptGlobal_Format("#{JZGN_20230710_121}" , "0")
	HuaShanLunJian_CreatTeamList_ExplainText:SetText(toptext)
	local szpage = ScriptGlobal_Format("#{WCBZ_220809_9}", "0", "0")	-- ?????? ???????
	HuaShanLunJian_CreatTeamList_CurrentlyPage:SetText(szpage)

	HuaShanLunJian_CreatTeamList_NumPage:SetText("")

	HuaShanLunJian_CreatTeamList_UpPage:Disable()
	HuaShanLunJian_CreatTeamList_DownPage:Disable()
end -- end func HuaShanLunJian_CreatTeamList_ResetControl()

-- 牻队列表控件选择点击事件
function HuaShanLunJian_CreatTeamList_ListInfo_On_SelectionChanged()
    HuaShanLunJian_CreatTeamList_TeamInfo:Enable()
end -- end func HuaShanLunJian_CreatTeamList_ListInfo_On_SelectionChanged()

-- 牻队详情按钮点击事件
function HuaShanLunJian_CreatTeamList_TeamInfo_Clicked()
	local index = HuaShanLunJian_CreatTeamList_ListInfo:GetSelectItem()
	if index < 0 then
		return
	end
	
	PushEvent("XBW_VIEWTEAMINFO_SHOW", index, 0)
end -- end func HuaShanLunJian_CreatTeamList_TeamInfo_Clicked()

-- 上一页
function HuaShanLunJian_CreatTeamList_Pre_Click()
	if HuaShanLunJian_CreatTeamList_CheckOpCD() < 1 then
		return
	end

	NewXBW:AskTeamListInfo(HuaShanLunJian_CreateTeamList_TargetSvrId, HuaShanLunJian_CreateTeamList_CurPage-1)
end -- end func HuaShanLunJian_CreatTeamList_Pre_Click()

-- 下一页
function HuaShanLunJian_CreatTeamList_Next_Click()
	if HuaShanLunJian_CreatTeamList_CheckOpCD() < 1 then
		return
	end

	NewXBW:AskTeamListInfo(HuaShanLunJian_CreateTeamList_TargetSvrId, HuaShanLunJian_CreateTeamList_CurPage+1)
end -- end func HuaShanLunJian_CreatTeamList_Next_Click()

-- 跳转
function HuaShanLunJian_CreatTeamList_GotoPageClicked()
	if HuaShanLunJian_CreatTeamList_CheckOpCD() < 1 then
		return
	end

	local pageText = HuaShanLunJian_CreatTeamList_NumPage:GetText()
	if (pageText == nil) then
		return
	end
	local pageNum = tonumber(pageText)
	if (pageNum == nil) then
		return
	end
	if (pageNum <= 0) then
		return
	end
	if (pageNum > HuaShanLunJian_CreateTeamList_MaxPage) then
		return
	end

	NewXBW:AskTeamListInfo(HuaShanLunJian_CreateTeamList_TargetSvrId, pageNum-1)
end -- end func HuaShanLunJian_CreatTeamList_GotoPageClicked()

-- 关睜按钮事件
function HuaShanLunJian_CreatTeamList_CloseClicked()
    this:Hide()
	if HuaShanLunJian_CreateTeamList_TargetObjId ~= -1 then
		this:CareObject(HuaShanLunJian_CreateTeamList_TargetObjId, 0, "HuaShanLunJian_CreatTeamList")
	end
	HuaShanLunJian_CreateTeamList_TargetObjId = -1
	HuaShanLunJian_CreateTeamList_TargetSvrId = -1

	CloseWindow("HuaShanLunJian_TeamInfo",true)
end -- end func HuaShanLunJian_CreatTeamList_CloseClicked()

-- 说明帮助按钮事件
function HuaShanLunJian_CreatTeamList_ExplainText_Help_Clicked()
    Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("CCallBack_ClientAskNpcTalk")
		Set_XSCRIPT_ScriptID(998497)
		Set_XSCRIPT_Parameter(0,tonumber(HuaShanLunJian_CreateTeamList_TargetSvrId))
		Set_XSCRIPT_Parameter(1,tonumber(1))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end -- end func HuaShanLunJian_CreatTeamList_ExplainText_Help_Clicked()

function HuaShanLunJian_CreatTeamList_CheckOpCD()
	local curTime = FindFriendDataPool:GetTickCount()
	if curTime - HuaShanLunJian_CreateTeamList_LastOpTime < HuaShanLunJian_CreateTeamList_OpCD then
		PushDebugMessage("#{WCBZ_220809_49}")
		return 0
	else
		HuaShanLunJian_CreateTeamList_LastOpTime = curTime
	end

	return 1
end -- end func HuaShanLunJian_CreatTeamList_CheckOpCD()

--*************************************************************************************************
-- 显示 刷新UI
--*************************************************************************************************
function HuaShanLunJian_CreatTeamList_OnShow(nTargetId, nTeamCount, nTeamTotal, nStartPage)
	HuaShanLunJian_CreateTeamList_TeamCount = nTeamCount
	HuaShanLunJian_CreateTeamList_MaxTeam = nTeamTotal
	HuaShanLunJian_CreateTeamList_CurPage = nStartPage
	local maxPage = math.floor(nTeamTotal / HuaShanLunJian_CreateTeamList_TeamCountPerPage)
	if (math.mod(nTeamTotal, HuaShanLunJian_CreateTeamList_TeamCountPerPage) ~= 0) then
		maxPage = maxPage + 1
	end
	HuaShanLunJian_CreateTeamList_MaxPage = maxPage

	if nTargetId > 0 then
		HuaShanLunJian_CreateTeamList_TargetSvrId = nTargetId
		HuaShanLunJian_CreateTeamList_TargetObjId = DataPool:GetNPCIDByServerID(nTargetId)
		this:CareObject(HuaShanLunJian_CreateTeamList_TargetObjId, 1, "HuaShanLunJian_CreatTeamList")
	end

	if IsWindowShow("HuaShanLunJian_TeamInfo")  then
		CloseWindow("HuaShanLunJian_TeamInfo", true)
	end
	
	-- local debugMsg = string.format("debug(1), create team list, team count: %d|%d, team max: %d|%d, cur page: %d|%d, max page: %d",
	-- 							HuaShanLunJian_CreateTeamList_TeamCount, nTeamCount,
	-- 							HuaShanLunJian_CreateTeamList_MaxTeam, nTeamTotal,
	-- 							HuaShanLunJian_CreateTeamList_CurPage, nStartPage,
	-- 							HuaShanLunJian_CreateTeamList_MaxPage)
	-- PushDebugMessage(debugMsg)

	HuaShanLunJian_CreatTeamList_Update()

	this:Show()
end -- end func HuaShanLunJian_CreatTeamList_OnShow()

function HuaShanLunJian_CreatTeamList_Update()
    HuaShanLunJian_CreatTeamList_ResetControl()

	local szDesc = ScriptGlobal_Format("#{JZGN_20230710_121}", tostring(HuaShanLunJian_CreateTeamList_MaxTeam))
	HuaShanLunJian_CreatTeamList_ExplainText:SetText(szDesc)

	local cnt = 0
	for i = 0, HuaShanLunJian_CreateTeamList_TeamCountPerPage-1 do
		local teamid, memcnt, worldId, teamname, teamleadername = NewXBW:GetTeamListInfo(i)
		if teamid ~= nil and teamid > 0 then
			local szTeamId = string.format("%03d", teamid)
			local szmemcnt = ScriptGlobal_Format("#{JZGN_20230710_29}", tostring(memcnt))
			HuaShanLunJian_CreatTeamList_ListInfo:AddNewItem("#cfff263" .. szTeamId, 0, cnt)
    		HuaShanLunJian_CreatTeamList_ListInfo:AddNewItem("#cfff263" .. teamname, 1, cnt)
			HuaShanLunJian_CreatTeamList_ListInfo:AddNewItem("#cfff263" .. teamleadername, 2, cnt)
    		HuaShanLunJian_CreatTeamList_ListInfo:AddNewItem("#cfff263" .. szmemcnt, 3, cnt)
			cnt = cnt + 1
        end
	end -- end for

	-- 犫个字典没给 暂时用狔霸赛的
	local szpage = ScriptGlobal_Format("#{WCBZ_220809_9}", tostring(HuaShanLunJian_CreateTeamList_CurPage+1), tostring(HuaShanLunJian_CreateTeamList_MaxPage))
	HuaShanLunJian_CreatTeamList_CurrentlyPage:SetText(szpage)

	-- local debugMsg = string.format("debug(2), create team list, count: %d, cur page: %d, max page: %d",
	-- 							HuaShanLunJian_CreateTeamList_TeamCount,
	-- 							HuaShanLunJian_CreateTeamList_CurPage,
	-- 							HuaShanLunJian_CreateTeamList_MaxPage)
	-- PushDebugMessage(debugMsg)

	-- 有页可翻
	if (HuaShanLunJian_CreateTeamList_MaxPage > 1) then
		if (HuaShanLunJian_CreateTeamList_CurPage < 1) then
			HuaShanLunJian_CreatTeamList_UpPage:Disable()
			HuaShanLunJian_CreatTeamList_DownPage:Enable()
		elseif (HuaShanLunJian_CreateTeamList_CurPage == (HuaShanLunJian_CreateTeamList_MaxPage-1)) then
			HuaShanLunJian_CreatTeamList_UpPage:Enable()
			HuaShanLunJian_CreatTeamList_DownPage:Disable()
		else
			HuaShanLunJian_CreatTeamList_UpPage:Enable()
			HuaShanLunJian_CreatTeamList_DownPage:Enable()
		end
	else
		HuaShanLunJian_CreatTeamList_UpPage:Disable()
		HuaShanLunJian_CreatTeamList_DownPage:Disable()
	end 
end -- end func HuaShanLunJian_CreatTeamList_Update()
