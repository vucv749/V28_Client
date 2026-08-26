-- 6V6 牻队排行榜
-- 默认位置
local g_HuaShanLunJian_TopList2_UnifiedPosition = nil
local g_HuaShanLunJian_TopList2_UICommandShow = 89289599
local g_HuaShanLunJian_TopList2_SvrScriptId = 892891
local g_HuaShanLunJian_TopList2_CareObjId = -1
local g_HuaShanLunJian_TopList2_CareObjSvrId = -1
-- 锁定牻队榜标记
local g_HuaShanLunJian_TopList2_LockedTeamFlag = 0
-- 切换茽通榜还是锁定牻队榜操作CD时间（秒）
local g_HuaShanLunJian_TopList2_ChangeRankOpMinTime = 5
-- 上一次切换茽通榜还是锁定牻队榜的操作时间
local g_HuaShanLunJian_TopList2_LastChangeRankOpTime = 0

-- 初始化
local g_init_List = 0
-- 上一次的页签选择
local g_tab_lastselect = 0
local g_cur_selIndex = 0
local g_cur_page = 0
local g_cur_pagemax = 0
-- 单页的最大数量
local g_team_max = 10
local g_ui_barList = {}
local g_ui_sel_TabBtnList = {}

local g_TeamRankStage = {
	null = -1,		
	begin = 0,		
	yingyang = 1,	-- ??(1 - 69)
	huxiao = 2,		-- ??(70 - 89)
	longwei = 3,	-- ??(90 - 119)
	max = 4,		
}

-- 资源相关
local g_rank_Image = {
    [1] = {image = "set:HSLJ_01 image:HSLJ_One"},
    [2] = {image = "set:HSLJ_01 image:HSLJ_Two"},
    [3] = {image = "set:HSLJ_01 image:HSLJ_Three"},
}
function HuaShanLunJian_TopList2_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("XBW_TEAMRANK_UPDATE", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
    this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function HuaShanLunJian_TopList2_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == g_HuaShanLunJian_TopList2_UICommandShow) then
        HuaShanLunJian_TopList2_BeginCareObject()
    elseif (event == "XBW_TEAMRANK_UPDATE") then
        HuaShanLunJian_TopList2_Show(tonumber(arg0))
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        HuaShanLunJian_TopList2_Close()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HuaShanLunJian_TopList2_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        HuaShanLunJian_TopList2_UnifiedPos()
    end
end

function HuaShanLunJian_TopList2_OnLoad()
    g_ui_sel_TabBtnList = {
        HuaShanLunJian_TopList2_Page01,
        HuaShanLunJian_TopList2_Page02,
        HuaShanLunJian_TopList2_Page03,
    }

    g_HuaShanLunJian_TopList2_UnifiedPosition = HuaShanLunJian_TopList2_MainFrame:GetProperty("UnifiedPosition")
end


-- 界面默认位置
function HuaShanLunJian_TopList2_UnifiedPos()
    if (g_HuaShanLunJian_TopList2_UnifiedPosition ~= nil) then
        HuaShanLunJian_TopList2_MainFrame:SetProperty("UnifiedPosition", g_HuaShanLunJian_TopList2_UnifiedPosition)
    end
end

function HuaShanLunJian_TopList2_Show(isLockedTeam)
    if (isLockedTeam ~= nil and isLockedTeam > 0) then
        -- 锁定牻队榜
        HuaShanLunJian_TopList2_Buttontab01:SetCheck(1)
        HuaShanLunJian_TopList2_Buttontab02:SetCheck(0)
        HuaShanLunJian_TopList2_Buttontab03:SetCheck(0)

        g_HuaShanLunJian_TopList2_LockedTeamFlag = 1
    else
        -- 茽通榜（非所动牻队榜）
        HuaShanLunJian_TopList2_Buttontab01:SetCheck(0)
        HuaShanLunJian_TopList2_Buttontab02:SetCheck(1)
        HuaShanLunJian_TopList2_Buttontab03:SetCheck(0)

        g_HuaShanLunJian_TopList2_LockedTeamFlag = 0
    end

    g_HuaShanLunJian_TopList2_LastChangeRankOpTime = 0

    -- 初始化
    HuaShanLunJian_TopList2_InitList()
    -- 进行内容的显示
    HuaShanLunJian_TopList2_ListShow()
    -- 进行一些页签的内容的显示
    HuaShanLunJian_TopList2_OtherShow()

    local curDay = tonumber(DataPool:GetServerDayTime())
	local seasonIndex, lockBegin, lockEnd = XBW:GetXbwGetCurSeasonLockInfo(curDay)
	local beginYear, beginMonth, beginDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockBegin)
    local endYear, endMonth, endDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockEnd)
    if (g_HuaShanLunJian_TopList2_LockedTeamFlag == 1) then
        -- 锁定牻队榜
        HuaShanLunJian_TopList2_DragTitle:SetText("#{HSPH_191120_62}")

        local msg = ScriptGlobal_Format("#{HSPH_191120_63}", beginYear, beginMonth, beginDay, endMonth, endDay)
        HuaShanLunJian_TopList2_TextInfo:SetText(msg)
    else
        -- 茽通榜（非所动牻队榜）
        HuaShanLunJian_TopList2_DragTitle:SetText("#{HSPH_191120_08}")
        
        local msg = ScriptGlobal_Format("#{HSPH_191120_65}", beginYear, beginMonth, beginDay, endMonth, endDay)
        HuaShanLunJian_TopList2_TextInfo:SetText(msg)
    end

    HuaShanLunJian_TopList2_CloseSameGroupWindow()
    HuaShanLunJian_TopList2_SetPosition()
    this:Show()
end

function HuaShanLunJian_TopList2_LevelSelect(selectIdx)

    for i, ui in (g_ui_sel_TabBtnList or {}) do
        --ui:SetCheck(0)
    end

    for i, ui in (g_ui_sel_TabBtnList or {}) do
        if i == selectIdx then
            ui:SetProperty("Selected", "True")
        else
            ui:SetProperty("Selected", "False")
        end
    end

    g_tab_lastselect = selectIdx
end

function HuaShanLunJian_TopList2_ResetUIInfo()
    -- g_init_List = 0
    -- HuaShanLunJian_TopList2_InitList()

    local curDay = tonumber(DataPool:GetServerDayTime())
	local seasonIndex, lockBegin, lockEnd = XBW:GetXbwGetCurSeasonLockInfo(curDay)
	local beginYear, beginMonth, beginDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockBegin)
    local endYear, endMonth, endDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockEnd)
    if (g_HuaShanLunJian_TopList2_LockedTeamFlag == 1) then
        -- 锁定牻队榜
        HuaShanLunJian_TopList2_DragTitle:SetText("#{HSPH_191120_62}")

        local msg = ScriptGlobal_Format("#{HSPH_191120_63}", beginYear, beginMonth, beginDay, endMonth, endDay)
        HuaShanLunJian_TopList2_TextInfo:SetText(msg)
    else
        -- 茽通榜（非所动牻队榜）
        HuaShanLunJian_TopList2_DragTitle:SetText("#{HSPH_191120_08}")
        
        local msg = ScriptGlobal_Format("#{HSPH_191120_65}", beginYear, beginMonth, beginDay, endMonth, endDay)
        HuaShanLunJian_TopList2_TextInfo:SetText(msg)
    end

    for i = 1, g_team_max do
        if (g_ui_barList[i] ~= nil) then
            g_ui_barList[i]:Hide()
        end
    end -- end for

    HuaShanLunJian_TopList2_UpPage:Disable()
    HuaShanLunJian_TopList2_DownPage:Disable()
    HuaShanLunJian_TopList2_CurrentlyPage:SetText("0/0")
    HuaShanLunJian_TopList2_Info:Disable()


end -- end func HuaShanLunJian_TopList2_ResetUIInfo()

-- 初始化列表
function HuaShanLunJian_TopList2_InitList()
    if g_init_List == 0 then
        HuaShanLunJian_TopList2:Clear()
        for i = 1, g_team_max do
            local bar = HuaShanLunJian_TopList2:AddChild("HuaShanLunJian_TopList2_Item")
            g_ui_barList[i] = bar	
            --bar:GetSubItem("HuaShanLunJian_TopList2_Info"):SetEvent("MouseLButtonDown", string.format("HuaShanLunJian_TopList2_ItemClicked(%d)", i))
            bar:SetEvent( "MouseLButtonDown", string.format("HuaShanLunJian_TopList2_ItemClicked(%d)", i))
        end
        g_init_List = 1
    end
    
    g_cur_selIndex = 0
    g_cur_page = 0
    g_cur_pagemax = 0
end

function HuaShanLunJian_TopList2_OtherShow()
    -- 进行页签的显示
    local selectStage = NewXBW:GetRankBaseInfo("Stage")
    HuaShanLunJian_TopList2_LevelSelect(selectStage)
    -- 进行页签底部内容显示

    local curPage = 0
    local total = NewXBW:GetRankBaseInfo("Total")
    if total > 0 then
        g_cur_page = NewXBW:GetRankBaseInfo("Page")
        g_cur_pagemax = NewXBW:GetRankBaseInfo("PageMax")

        curPage = g_cur_page + 1
    end

    local szPage = tostring(curPage).."/"..tostring(g_cur_pagemax)
	HuaShanLunJian_TopList2_CurrentlyPage:SetText(szPage)

    HuaShanLunJian_TopList2_DownPage:Disable()
    HuaShanLunJian_TopList2_UpPage:Disable()

	-- 有页可翻
	if g_cur_pagemax > 1 then
		if curPage <= 1 then
			HuaShanLunJian_TopList2_DownPage:Enable()
		elseif curPage == g_cur_pagemax then
			HuaShanLunJian_TopList2_UpPage:Enable()
		else
			HuaShanLunJian_TopList2_UpPage:Enable()
			HuaShanLunJian_TopList2_DownPage:Enable()
		end
    end
    
    if g_cur_selIndex > 0 then
        HuaShanLunJian_TopList2_Info:Enable()
    else
        HuaShanLunJian_TopList2_Info:Disable()
    end
end

function HuaShanLunJian_TopList2_ListShow()
    -- 先看看显示了多少内容
    local count = NewXBW:GetRankBaseInfo("Count")
    for i, ui in (g_ui_barList or {}) do
        HuaShanLunJian_TopList2_SetItem(i, count)
    end

    HuaShanLunJian_TopList2:RefreshLayout()
    HuaShanLunJian_TopList2:SetScrollPosition4Index(0)
end

function HuaShanLunJian_TopList2_SetItem(index, max_count)
    local bar = g_ui_barList[index]
    if bar == nil then
        return
    end

    if index > max_count then
        bar:Hide()
        return
    end

    local data = NewXBW:GetRankTeamInfo(index-1)
    if data == nil or type(data) ~= "table" then
        bar:Hide()
        return
    end

    bar:Show()

    -- 排名
    local rankTxt = bar:GetSubItem("HuaShanLunJian_TopList2_Number")
    if rankTxt ~= nil then
        rankTxt:SetText("#cfff263"..data.rank)
    end
    -- 排名图标
    local rankImage = bar:GetSubItem("HuaShanLunJian_TopList2_NumberImage")
    if rankImage ~= nil then
        if g_rank_Image[data.rank] ~= nil then
            rankImage:SetProperty("Image", g_rank_Image[data.rank].image)
            rankImage:Show()
            if rankTxt ~= nil then
                rankTxt:SetText("")
            end
        else
            rankImage:Hide()
        end
    end

    -- 总分
    local rankScore = bar:GetSubItem("HuaShanLunJian_TopList2_WinNum")
    if rankScore ~= nil then
        rankScore:SetText("#cfff263"..data.star)
    end
    -- 牻队名字
    local rankName = bar:GetSubItem("HuaShanLunJian_TopList2_Name")
    if rankName ~= nil then
        rankName:SetText("#cfff263"..data.name)
    end
end

function HuaShanLunJian_TopList2_RankHelp()
    local curDay = tonumber(DataPool:GetServerDayTime())
	local seasonIndex, lockBegin, lockEnd = XBW:GetXbwGetCurSeasonLockInfo(curDay)
	local beginYear, beginMonth, beginDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockBegin)
	local endYear, endMonth, endDay = HuaShanLunJian_LockTeam_GetYMDByDate(lockEnd)
    
    if (g_HuaShanLunJian_TopList2_LockedTeamFlag == 1) then
        local msg = ScriptGlobal_Format("#{HSPH_191120_64}", beginYear, beginMonth, beginDay, endMonth, endDay)
        PushEvent("QUEST_HELPINFO", msg)
    else
        local msg = ScriptGlobal_Format("#{HSLJ_190919_212}", beginYear, beginMonth, beginDay, endMonth, endDay)
        PushEvent("QUEST_HELPINFO", msg)
    end
end

-- 开启NPC关注
function HuaShanLunJian_TopList2_BeginCareObject()
    local objSvrId = Get_XParam_INT(0)
	g_HuaShanLunJian_TopList2_CareObjId = DataPool:GetNPCIDByServerID(objSvrId)
    if (g_HuaShanLunJian_TopList2_CareObjId >= 0) then
        g_HuaShanLunJian_TopList2_CareObjSvrId = tonumber(objSvrId)
		this:CareObject(g_HuaShanLunJian_TopList2_CareObjId, 1, "HuaShanLunJian_TopList2")
	end
end

-- 取消NPC关注
function HuaShanLunJian_TopList2_StopCareObject()
	if (g_HuaShanLunJian_TopList2_CareObjId >= 0) then
		this:CareObject(g_HuaShanLunJian_TopList2_CareObjId, 0, "HuaShanLunJian_TopList2")
		g_HuaShanLunJian_TopList2_CareObjId = -1
		g_HuaShanLunJian_TopList2_CareObjSvrId = -1
	end
end

function HuaShanLunJian_TopList2_Close()
    HuaShanLunJian_TopList2_SavePosition()
    this:Hide()
end

function HuaShanLunJian_TopList2_Hide()
    HuaShanLunJian_TopList2_StopCareObject()
    g_tab_lastselect = 0
    g_cur_selIndex = 0

    if(IsWindowShow("HuaShanLunJian_TeamInfo2")) then
        CloseWindow("HuaShanLunJian_TeamInfo2", true);
    end
end

-- 茽通榜还是锁定牻队榜页签点击事件
function HuaShanLunJian_TopList2_ChangeTopList(nIndex)
    if (nIndex == 0) then
        -- 锁定牻队榜
        if (g_HuaShanLunJian_TopList2_LockedTeamFlag > 0) then
            HuaShanLunJian_TopList2_Buttontab01:SetCheck(1)
            HuaShanLunJian_TopList2_Buttontab02:SetCheck(0)
            return
        end

        local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
        local diffTime = curTime - g_HuaShanLunJian_TopList2_LastChangeRankOpTime
        if (diffTime < g_HuaShanLunJian_TopList2_ChangeRankOpMinTime) then
            -- 操作CD没到
            if (g_HuaShanLunJian_TopList2_LockedTeamFlag == 1) then
                HuaShanLunJian_TopList2_Buttontab01:SetCheck(1)
                HuaShanLunJian_TopList2_Buttontab02:SetCheck(0)
            else
                HuaShanLunJian_TopList2_Buttontab01:SetCheck(0)
                HuaShanLunJian_TopList2_Buttontab02:SetCheck(1)
            end

            PushDebugMessage("#{JZGN_20230710_117}")
            return
        end

        g_HuaShanLunJian_TopList2_LockedTeamFlag = 1
        g_HuaShanLunJian_TopList2_LastChangeRankOpTime = curTime

        -- 重置UI 等排行榜数据下来再刷新
        HuaShanLunJian_TopList2_ResetUIInfo()

        if g_tab_lastselect <= g_TeamRankStage.begin or g_tab_lastselect >= g_TeamRankStage.max then
            g_tab_lastselect = g_TeamRankStage.yingyang
        end
        -- 请求一下新的排行榜数据
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList2_SvrScriptId)
            Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
            Set_XSCRIPT_Parameter(0, g_tab_lastselect)
            Set_XSCRIPT_Parameter(1, 0)
            Set_XSCRIPT_Parameter(2, g_HuaShanLunJian_TopList2_LockedTeamFlag)
            Set_XSCRIPT_ParamCount(3)
        Send_XSCRIPT()
    elseif (nIndex == 1) then
        -- 茽通榜
        if (g_HuaShanLunJian_TopList2_LockedTeamFlag <= 0) then
            HuaShanLunJian_TopList2_Buttontab01:SetCheck(0)
            HuaShanLunJian_TopList2_Buttontab02:SetCheck(1)
            return
        end

        local curTime = tonumber(DataPool:LuaGetCurrentServerTime())
        local diffTime = curTime - g_HuaShanLunJian_TopList2_LastChangeRankOpTime
        if (diffTime < g_HuaShanLunJian_TopList2_ChangeRankOpMinTime) then
            -- 操作CD没到
            if (g_HuaShanLunJian_TopList2_LockedTeamFlag == 1) then
                HuaShanLunJian_TopList2_Buttontab01:SetCheck(1)
                HuaShanLunJian_TopList2_Buttontab02:SetCheck(0)
            else
                HuaShanLunJian_TopList2_Buttontab01:SetCheck(0)
                HuaShanLunJian_TopList2_Buttontab02:SetCheck(1)
            end

            PushDebugMessage("#{JZGN_20230710_117}")
            return
        end

        g_HuaShanLunJian_TopList2_LockedTeamFlag = 0
        g_HuaShanLunJian_TopList2_LastChangeRankOpTime = curTime

        -- 重置UI 等排行榜数据下来再刷新
        HuaShanLunJian_TopList2_ResetUIInfo()

        if g_tab_lastselect <= g_TeamRankStage.begin or g_tab_lastselect >= g_TeamRankStage.max then
            g_tab_lastselect = g_TeamRankStage.yingyang
        end
        -- 请求一下新的排行榜数据
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList2_SvrScriptId)
            Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
            Set_XSCRIPT_Parameter(0, g_tab_lastselect)
            Set_XSCRIPT_Parameter(1, 0)
            Set_XSCRIPT_Parameter(2, g_HuaShanLunJian_TopList2_LockedTeamFlag)
            Set_XSCRIPT_ParamCount(3)
        Send_XSCRIPT()
    elseif nIndex == 2 then
        HuaShanLunJian_TopList2_SavePosition()
        PushEvent("XBW_RANKLIST3_OPEN", g_HuaShanLunJian_TopList2_CareObjSvrId)
    else
        -- 按说不应该到犫里的
    
    end
end -- end func HuaShanLunJian_TopList2_ChangeTopList()

-- 点击查看信息
function HuaShanLunJian_TopList2_ItemClicked(nIndex)
    if nIndex > 0 then
        g_cur_selIndex = nIndex
        HuaShanLunJian_TopList2_Info:Enable()
    end
end

function HuaShanLunJian_TopList2_ChangeTabIndex(selectIdx)
    --HuaShanLunJian_TopList2_LevelSelect(selectIdx)
    if selectIdx == g_tab_lastselect then
        HuaShanLunJian_TopList2_LevelSelect(g_tab_lastselect)
        return
    end

    HuaShanLunJian_TopList2_LevelSelect(g_tab_lastselect)

    if selectIdx <= g_TeamRankStage.begin or selectIdx >= g_TeamRankStage.max then
        return
    end

    -- 重置UI 等排行榜数据下来再刷新
    --HuaShanLunJian_TopList2_ResetUIInfo()

    -- 请求一下新的信息
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList2_SvrScriptId)
        Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
        Set_XSCRIPT_Parameter(0, selectIdx)
        Set_XSCRIPT_Parameter(1, 0)
        Set_XSCRIPT_Parameter(2, g_HuaShanLunJian_TopList2_LockedTeamFlag)
        Set_XSCRIPT_ParamCount(3)
    Send_XSCRIPT()
end

-- 查看详情
function HuaShanLunJian_TopList2_ViewDetailsClick()

    if g_cur_selIndex < 1 then
        return
    end

    PushEvent("XBW_TEAMRANK_OPENTEAMUI", g_cur_selIndex, g_HuaShanLunJian_TopList2_CareObjSvrId)
end

-- 前一页
function HuaShanLunJian_TopList2_Pre_Click(selectIdx)

    if g_tab_lastselect <= g_TeamRankStage.begin or g_tab_lastselect >= g_TeamRankStage.max then
        return
    end

    g_cur_page = NewXBW:GetRankBaseInfo("Page")

    if g_cur_page <= 0 then
        return
    end

    -- 请求一下新的信息
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList2_SvrScriptId)
        Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
        Set_XSCRIPT_Parameter(0, g_tab_lastselect)
        Set_XSCRIPT_Parameter(1, g_cur_page-1)
        Set_XSCRIPT_Parameter(2, g_HuaShanLunJian_TopList2_LockedTeamFlag)
        Set_XSCRIPT_ParamCount(3)
    Send_XSCRIPT()


end

-- 下一页
function HuaShanLunJian_TopList2_Next_Click(selectIdx)

    if g_tab_lastselect <= g_TeamRankStage.begin or g_tab_lastselect >= g_TeamRankStage.max then
        return
    end

    g_cur_page = NewXBW:GetRankBaseInfo("Page")
    g_cur_pagemax = NewXBW:GetRankBaseInfo("PageMax")

    if (g_cur_page + 1) >= g_cur_pagemax then
        return
    end
    
    -- 请求一下新的信息
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList2_SvrScriptId)
        Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
        Set_XSCRIPT_Parameter(0, g_tab_lastselect)
        Set_XSCRIPT_Parameter(1, g_cur_page+1)
        Set_XSCRIPT_Parameter(2, g_HuaShanLunJian_TopList2_LockedTeamFlag)
        Set_XSCRIPT_ParamCount(3)
    Send_XSCRIPT()
end

function HuaShanLunJian_TopList2_SetPosition()
	local nExteriorUnionPos = Variable:GetVariable("XbwTopListUnionPos")
	if nExteriorUnionPos ~= nil then
		HuaShanLunJian_TopList2_FrameFull:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end
end

function HuaShanLunJian_TopList2_SavePosition()
	Variable:SetVariable("XbwTopListUnionPos", HuaShanLunJian_TopList2_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HuaShanLunJian_TopList2_CloseSameGroupWindow()
    if (IsWindowShow("HuaShanLunJian_TopList3")) then
        CloseWindow("HuaShanLunJian_TopList3", true)
    end
end
