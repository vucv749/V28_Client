-- 6V6 牻队排行榜, 记录榜
-- 默认位置
local g_HuaShanLunJian_TopList3_UnifiedPosition = nil
local g_HuaShanLunJian_TopList3_SvrScriptId = 892891
local g_HuaShanLunJian_TopList3_CareObjId = -1
local g_HuaShanLunJian_TopList3_CareObjSvrId = -1
local g_HuaShanLunJian_TopList3_LM = 9018
-- 上一次的页签选择
local g_player_max = 6
local g_tab_lastselect = 0
local g_season_select = 1
-- 单页的最大数量
local g_ui_barList = {}
local g_ui_sel_TabRankBtnList = {}
local g_ui_sel_TabBtnList = {}

local g_ui_rank_text = {
    [1] = {str="#{HSPH_191120_70}"} ,
    [2] = {str="#{HSPH_191120_69}"} ,
    [3] = {str="#{HSPH_191120_68}"} ,
}

local g_menpaiinfo = {
	[0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	-- ??
	[1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	-- ??
	[2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	-- ??
	[3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	-- ??
	[4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	-- ??
	[5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	-- ??
	[6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	-- ??
	[7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	-- ??
	[8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	-- ??
	[9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	-- ???
	[10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	-- ??
}

local g_tab_Type = {
    lock = 0,
    normal = 1,
    honour = 2,
}

function HuaShanLunJian_TopList3_PreLoad()
    this:RegisterEvent("XBW_RANKLIST3_OPEN", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
    this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function HuaShanLunJian_TopList3_OnEvent(event)
    if (event == "XBW_RANKLIST3_OPEN") then
        HuaShanLunJian_TopList3_Show(tonumber(arg0))
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        HuaShanLunJian_TopList3_Close()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        HuaShanLunJian_TopList3_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        HuaShanLunJian_TopList3_UnifiedPos()
    end
end

function HuaShanLunJian_TopList3_OnLoad()
    g_ui_sel_TabBtnList = {
        HuaShanLunJian_TopList3_Page01,
        HuaShanLunJian_TopList3_Page02,
        HuaShanLunJian_TopList3_Page03,
    }
    g_ui_sel_TabRankBtnList = {
        HuaShanLunJian_TopList3_Buttontab01,
        HuaShanLunJian_TopList3_Buttontab02,
        HuaShanLunJian_TopList3_Buttontab03,
    }

    local _prefix_l = "HuaShanLunJian_TopList3_"
	local makeGroup = function(prefix,name,mp,lv,server,team)
		return {
			["name"] = _G[prefix..name],
			["mp"] = _G[prefix..mp],
			["lv"] = _G[prefix..lv],
			["server"] = _G[prefix..server],
			["team"] = _G[prefix..team],
		}
    end
    
    g_ui_barList = {
        makeGroup(_prefix_l, "List1_1","List1_2","List1_3","List1_4","List1_5"),
        makeGroup(_prefix_l, "List2_1","List2_2","List2_3","List2_4","List2_5"),
        makeGroup(_prefix_l, "List3_1","List3_2","List3_3","List3_4","List3_5"),
        makeGroup(_prefix_l, "List4_1","List4_2","List4_3","List4_4","List4_5"),
        makeGroup(_prefix_l, "List5_1","List5_2","List5_3","List5_4","List5_5"),
        makeGroup(_prefix_l, "List6_1","List6_2","List6_3","List6_4","List6_5"),
    }

    g_HuaShanLunJian_TopList3_UnifiedPosition = HuaShanLunJian_TopList3_FrameFull:GetProperty("UnifiedPosition")
end


-- 界面默认位置
function HuaShanLunJian_TopList3_UnifiedPos()
    if (g_HuaShanLunJian_TopList3_UnifiedPosition ~= nil) then
        HuaShanLunJian_TopList3_FrameFull:SetProperty("UnifiedPosition", g_HuaShanLunJian_TopList3_UnifiedPosition)
    end
end

function HuaShanLunJian_TopList3_Show(objSvrId)
    -- 优先跟军当前等级段进行显示
    local levelIndex = Player:Lua_GetXbwData("LevelIndex")
    local selectIndex = levelIndex + 1
    if selectIndex <= 0 then
        selectIndex = 1
    end

    HuaShanLunJian_TopList3_SetPosition()
    HuaShanLunJian_TopList3_CloseSameGroupWindow()
    HuaShanLunJian_TopList3_BeginCareObject(objSvrId)
    HuaShanLunJian_TopList3_LevelSelect(selectIndex)
    HuaShanLunJian_TopList3_ResetUIInfo()
    this:Show()
end

function HuaShanLunJian_TopList3_LevelSelect(selectIdx)

    for i, ui in (g_ui_sel_TabBtnList or {}) do
        if i == selectIdx then
            ui:SetProperty("Selected", "True")
        else
            ui:SetProperty("Selected", "False")
        end
    end

    g_tab_lastselect = selectIdx

    local desc = g_ui_rank_text[selectIdx]
    if desc ~= nil then
        HuaShanLunJian_TopList3_MyNumber:SetText(desc.str)
    end

end

function HuaShanLunJian_TopList3_ResetUIInfo()
    
    HuaShanLunJian_TopList3_Buttontab01:SetCheck(0)
    HuaShanLunJian_TopList3_Buttontab02:SetCheck(0)
    HuaShanLunJian_TopList3_Buttontab03:SetCheck(1)

    for i, ui in (g_ui_barList or {}) do
        ui.name:SetText("")
        ui.mp:SetText("")
        ui.lv:SetText("")
        ui.server:SetText("")
        ui.team:SetText("")
    end

    local uiIndex = 0
    local lmFlag = HuaShanLunJian_TopList3_IsLMFlag()
    local tabData = NewXBW:GetXbwHonourWallInfo(g_season_select, g_tab_lastselect-1, lmFlag)
    for i=1, g_player_max do
        local data = tabData[i]
        if data ~= nil and type(data) == "table" then
            uiIndex = uiIndex + 1
            local uiData = g_ui_barList[uiIndex]
            if uiData ~= nil then
                -- 进行内容显示
                uiData.name:SetText(data.name)
                uiData.lv:SetText(data.level)
                uiData.team:SetText(data.teamname)
                if g_menpaiinfo[data.menpai] ~= nil then
                    uiData.mp:SetText(g_menpaiinfo[data.menpai].name)
                end
                local serverName = DataPool:GetServerName(data.world)
                uiData.server:SetText(serverName)
            end
        end
    end
end

function HuaShanLunJian_TopList3_RankHelp()
    PushEvent("QUEST_HELPINFO", "my name is StrDictionary")
end

function HuaShanLunJian_TopList3_IsLMFlag()
    local selfID = DataPool:GetSelfZoneWorldID()
    if selfID ~= g_HuaShanLunJian_TopList3_LM then
        return 1
    end

    return -1
end

-- 开启NPC关注
function HuaShanLunJian_TopList3_BeginCareObject(objSvrId)
	g_HuaShanLunJian_TopList3_CareObjId = DataPool:GetNPCIDByServerID(objSvrId)
    if (g_HuaShanLunJian_TopList3_CareObjId >= 0) then
        g_HuaShanLunJian_TopList3_CareObjSvrId = tonumber(objSvrId)
		this:CareObject(g_HuaShanLunJian_TopList3_CareObjId, 1, "HuaShanLunJian_TopList3")
	end
end

-- 取消NPC关注
function HuaShanLunJian_TopList3_StopCareObject()
	if (g_HuaShanLunJian_TopList3_CareObjId >= 0) then
		this:CareObject(g_HuaShanLunJian_TopList3_CareObjId, 0, "HuaShanLunJian_TopList3")
		g_HuaShanLunJian_TopList3_CareObjId = -1
		g_HuaShanLunJian_TopList3_CareObjSvrId = -1
	end
end

function HuaShanLunJian_TopList3_Close()
    HuaShanLunJian_TopList3_SavePosition()
    this:Hide()
end

function HuaShanLunJian_TopList3_Hide()
    HuaShanLunJian_TopList3_StopCareObject()
end

-- 切换大页签
function HuaShanLunJian_TopList3_ChangeTopList(nIndex)

    local levelIndex = Player:Lua_GetXbwData("LevelIndex")
    local selectIndex = levelIndex + 1
    if selectIndex <= 0 then
        selectIndex = 1
    end

    if nIndex == g_tab_Type.lock then
        -- 请求一下新的排行榜数据
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList3_SvrScriptId)
            Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
            Set_XSCRIPT_Parameter(0, selectIndex)
            Set_XSCRIPT_Parameter(1, 0)
            Set_XSCRIPT_Parameter(2, 1)
            Set_XSCRIPT_ParamCount(3)
        Send_XSCRIPT()
        HuaShanLunJian_TopList3_SavePosition()
    elseif nIndex == g_tab_Type.normal then
        Clear_XSCRIPT()
            Set_XSCRIPT_ScriptID(g_HuaShanLunJian_TopList3_SvrScriptId)
            Set_XSCRIPT_Function_Name("AskPlayerTeamRank")
            Set_XSCRIPT_Parameter(0, selectIndex)
            Set_XSCRIPT_Parameter(1, 0)
            Set_XSCRIPT_Parameter(2, 0)
            Set_XSCRIPT_ParamCount(3)
        Send_XSCRIPT()
        HuaShanLunJian_TopList3_SavePosition()
    else
        HuaShanLunJian_TopList3_Buttontab01:SetCheck(0)
        HuaShanLunJian_TopList3_Buttontab02:SetCheck(0)
        HuaShanLunJian_TopList3_Buttontab03:SetCheck(1)
    end
end

-- 切换等级段页签
function HuaShanLunJian_TopList3_ChangeTabIndex(selectIdx)
    if selectIdx == g_tab_lastselect then
        HuaShanLunJian_TopList3_LevelSelect(selectIdx)
        return
    end

    HuaShanLunJian_TopList3_LevelSelect(selectIdx)
    HuaShanLunJian_TopList3_ResetUIInfo()
end

function HuaShanLunJian_TopList3_SetPosition()
    local nExteriorUnionPos = Variable:GetVariable("XbwTopListUnionPos")
    if nExteriorUnionPos ~= nil then
        HuaShanLunJian_TopList3_FrameFull:SetProperty("UnifiedPosition", nExteriorUnionPos)
    end
end

function HuaShanLunJian_TopList3_SavePosition()
    Variable:SetVariable("XbwTopListUnionPos", HuaShanLunJian_TopList3_FrameFull:GetProperty("UnifiedPosition"), 1)
end

function HuaShanLunJian_TopList3_CloseSameGroupWindow()
    if (IsWindowShow("HuaShanLunJian_TeamInfo2")) then
        CloseWindow("HuaShanLunJian_TeamInfo2", true)
    end
    if (IsWindowShow("HuaShanLunJian_TopList2")) then
        CloseWindow("HuaShanLunJian_TopList2", true)
    end
end
