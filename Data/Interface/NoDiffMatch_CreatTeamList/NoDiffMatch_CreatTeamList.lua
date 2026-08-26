--查看已组建战队

local g_unifiedposistion = nil
local g_TargetId = -1
local g_TragetNpcId = 0
local g_teamcnt = 0
local g_curpage = 0
local g_pagemax = 0
local g_teammax = 0
local g_op_cd = 2000		-- 操作CD
local g_last_optime	= 1		-- 最后操作的时间
function NoDiffMatch_CreatTeamList_PreLoad()
	this:RegisterEvent("ZBS_TEAMINFOLIST_SHOW")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function NoDiffMatch_CreatTeamList_OnLoad()
	NoDiffMatch_CreatTeamList_ResetControl()
	g_unifiedposistion = NoDiffMatch_CreatTeamList_Frame:GetProperty("UnifiedPosition")
end

function NoDiffMatch_CreatTeamList_OnEvent(event)
	if event == "ZBS_TEAMINFOLIST_SHOW" then
		NoDiffMatch_CreatTeamList_OnShow(tonumber(arg0),tonumber(arg1),tonumber(arg2),tonumber(arg3),tonumber(arg4))
	elseif event == "ADJEST_UI_POS" then
		NoDiffMatch_CreatTeamList_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		NoDiffMatch_CreatTeamList_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		NoDiffMatch_CreatTeamList_CloseClicked()
	end
end

function NoDiffMatch_CreatTeamList_OnShow(nTeamInfoCount, nTargetId, nCurPage, nMaxPage, nTeamTotal)
	g_teamcnt = nTeamInfoCount
	g_curpage = nCurPage
	g_pagemax = nMaxPage
	g_teammax = nTeamTotal
	if nTargetId > 0 then
		g_TragetNpcId = nTargetId
		g_TargetId = DataPool : GetNPCIDByServerID( nTargetId )
		this:CareObject( g_TargetId, 1, "NoDiffMatch_CreatTeamList" )
	end

	if IsWindowShow("NoDiffMatch_TeamInfo")  then
		CloseWindow("NoDiffMatch_TeamInfo", true)
	end
	
	NoDiffMatch_CreatTeamList_Update()

	this:Show()
end

function NoDiffMatch_CreatTeamList_Update()

    NoDiffMatch_CreatTeamList_ResetControl()

	
	local szDesc = ScriptGlobal_Format("#{WCBZ_180128_550}", tostring(g_teammax) )
	NoDiffMatch_CreatTeamList_ExplainText:SetText(szDesc)

	local cnt = 0
	for i = 0, g_teamcnt-1 do
		local teamid, teamname, teamleadername, memcnt, zoneid = ZBS:GetTeamListInfo(i)
		if teamid ~= nil and teamid > 0 then
			local szTeamId = string.format("%03d", teamid)
			local szmemcnt = ScriptGlobal_Format("#{WCBZ_180128_50}", tostring(memcnt) )
			NoDiffMatch_CreatTeamList_ListInfo:AddNewItem(szTeamId, 0, cnt)
    		NoDiffMatch_CreatTeamList_ListInfo:AddNewItem(teamname, 1, cnt)
			NoDiffMatch_CreatTeamList_ListInfo:AddNewItem(teamleadername, 2, cnt)
    		NoDiffMatch_CreatTeamList_ListInfo:AddNewItem(szmemcnt, 3, cnt)
			cnt = cnt + 1
        end
	end

	local szpage = ScriptGlobal_Format("#{WCBZ_220809_9}", tostring(g_curpage), tostring(g_pagemax) )
	NoDiffMatch_CreatTeamList_CurrentlyPage:SetText(szpage)

	-- 有页可翻
	if g_pagemax > 1 then
		if g_curpage <= 1 then
			NoDiffMatch_CreatTeamList_DownPage:Enable()
		elseif g_curpage == g_pagemax then
			NoDiffMatch_CreatTeamList_UpPage:Enable()
		else
			NoDiffMatch_CreatTeamList_UpPage:Enable()
			NoDiffMatch_CreatTeamList_DownPage:Enable()
		end
	end 
end


function NoDiffMatch_CreatTeamList_ResetControl()
	NoDiffMatch_CreatTeamList_ListInfo:RemoveAllItem()
    NoDiffMatch_CreatTeamList_TeamInfo:Disable()
	local toptext = ScriptGlobal_Format("#{WCBZ_180128_550}" , "0" )
	NoDiffMatch_CreatTeamList_ExplainText:SetText(toptext)
	local szpage = ScriptGlobal_Format("#{WCBZ_220809_9}", "0", "0" )
	NoDiffMatch_CreatTeamList_CurrentlyPage:SetText(szpage)

	NoDiffMatch_CreatTeamList_UpPage:Disable()
	NoDiffMatch_CreatTeamList_DownPage:Disable()
end

function NoDiffMatch_CreatTeamList_ListInfo_On_SelectionChanged()
    NoDiffMatch_CreatTeamList_TeamInfo:Enable()
end

function NoDiffMatch_CreatTeamList_TeamInfo_Clicked()
	local index = NoDiffMatch_CreatTeamList_ListInfo:GetSelectItem()
	if index < 0 then
		return
	end
	
	PushEvent("ZBS_VIEWTEAMINFO_SHOW", index, 0)
end

function NoDiffMatch_CreatTeamList_Pre_Click()
	if NoDiffMatch_CreatTeamList_CheckOpCD() < 1 then
		return
	end

	ZBS:AskTeamListInfo(g_TragetNpcId, g_curpage-1)
end

function NoDiffMatch_CreatTeamList_Next_Click()
	if NoDiffMatch_CreatTeamList_CheckOpCD() < 1 then
		return
	end

	ZBS:AskTeamListInfo(g_TragetNpcId, g_curpage+1)
end

function NoDiffMatch_CreatTeamList_ResetPos()
	NoDiffMatch_CreatTeamList_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function NoDiffMatch_CreatTeamList_CloseClicked()
    this:Hide()
	if g_TargetId ~= -1 then
		this:CareObject( g_TargetId, 0, "NoDiffMatch_CreatTeamList" )
	end
	g_TargetId = -1
	g_TragetNpcId = -1

	CloseWindow("NoDiffMatch_TeamInfo",true)
end

function NoDiffMatch_CreatTeamList_CheckOpCD()
	local curTime = FindFriendDataPool:GetTickCount()
	if curTime - g_last_optime < g_op_cd then
		PushDebugMessage("#{WCBZ_220809_49}")
		return 0
	else
		g_last_optime = curTime
	end

	return 1
end

function NoDiffMatch_CreatTeamList_ExplainText_Help_Clicked()
    Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ClientAskNpcTalk")
		Set_XSCRIPT_ScriptID(889961)
		Set_XSCRIPT_Parameter(0,tonumber(g_TragetNpcId))
		Set_XSCRIPT_Parameter(1,tonumber(1))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

