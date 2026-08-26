-- GM视角

local g_OB_Over_UnifiedPosition = nil

local g_OB_Over_Data = {}
local g_OB_Over_PlayerUI = {}
local g_OB_Over_UI = {}

local g_OB_Over_Def = {
    teammax = 2,                -- ??????
    membermax = 6,              -- ??????
    skillmax = 9,               -- ??????
    buffmax = 9,                -- Buff????
    hpflash = 20,               -- ??????

    fstblood_invalid = -1,      -- ???
    fstblood_teamfst = 1,       -- A?
    fstblood_teamsec = 2,       -- B?

    result_invalid = -1,        -- ??
    result_equal = 0,           -- ??
    result_teamfst = 1,         -- A?
    result_teamsec = 2,         -- B?
}
local g_OB_Over_Type = {
    zbs = 1,
}
local g_OB_Over_Page = {
    single = 1,                 -- ??
    team = 2,                   -- ??
}
local g_OB_Over_ScnID = {
    607,
}
local g_OB_Over_MP = {
    [0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},	--??
    [1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},	--??
    [2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},	--??
    [3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},	--??
    [4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},	--??
    [5]  ={name="#{WCBZ_180128_66}",color="#c007700"},	--??
    [6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},	--??
    [7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},	--??
    [8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},	--??
    [9]  ={name="#{WCBZ_180128_57}",color="#c999999"},	--???
    [10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},	--??
}

function OB_Over_PreLoad()
    this:RegisterEvent("GMVISIBLE_OPENDATA", true)
    this:RegisterEvent("GMVISIBLE_CLOSE", false)
    this:RegisterEvent("GMVISIBLE_DATAREFRESH", false)
    this:RegisterEvent("GMVISIBLE_SCORE", false)
    this:RegisterEvent("GMVISIBLE_RESULT", false)
    this:RegisterEvent("SCENE_TRANSED", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
end

function OB_Over_OnEvent(event)
    if (event == "GMVISIBLE_OPENDATA") then
        OB_Over_Show()
    elseif (event == "GMVISIBLE_DATAREFRESH") then
        OB_Over_DataFresh()
    elseif (event == "GMVISIBLE_SCORE") then
        OB_Over_UpdateOtherInfo()
    elseif (event == "GMVISIBLE_RESULT") then
        OB_Over_BattleResult_Show()
    elseif (event == "GMVISIBLE_CLOSE") then
        OB_Over_Hide()
    elseif (event == "SCENE_TRANSED") then
        OB_Over_TransHideScn()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        OB_Over_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        OB_Over_UnifiedPos()
    end
end

function OB_Over_OnLoad()
    g_OB_Over_UnifiedPosition = OB_Over_Frame:GetProperty("UnifiedPosition")
    OB_Over_InitCtrlList()
end

function OB_Over_InitCtrlList()
        
    g_OB_Over_PlayerUI = {}
    local makePlayerGroup = function(_prefix)
        return {
            ["bg"] = _G[_prefix],
            ["name"] = _G[_prefix.."_Name"],
            ["mp"] = _G[_prefix.."_MenPai"],
            ["kill"] = _G[_prefix.."_Kill"],
            ["damage"] = _G[_prefix.."_Damage"],
            ["injure"] = _G[_prefix.."_Tank"],
            ["cure"] = _G[_prefix.."_Heal"],
            ["damagetxt"] = _G[_prefix.."_DamageText"],
            ["injuretxt"] = _G[_prefix.."_TankText"],
            ["curetxt"] = _G[_prefix.."_HealText"],
        }
    end

    g_OB_Over_PlayerUI[1] = {}
    g_OB_Over_PlayerUI[1] = {
        makePlayerGroup("OB_Over_Single_Team1_Player1"),
        makePlayerGroup("OB_Over_Single_Team1_Player2"),
        makePlayerGroup("OB_Over_Single_Team1_Player3"),
        makePlayerGroup("OB_Over_Single_Team1_Player4"),
        makePlayerGroup("OB_Over_Single_Team1_Player5"),
        makePlayerGroup("OB_Over_Single_Team1_Player6"),
    }
    g_OB_Over_PlayerUI[2] = {}
    g_OB_Over_PlayerUI[2] = {
        makePlayerGroup("OB_Over_Single_Team2_Player1"),
        makePlayerGroup("OB_Over_Single_Team2_Player2"),
        makePlayerGroup("OB_Over_Single_Team2_Player3"),
        makePlayerGroup("OB_Over_Single_Team2_Player4"),
        makePlayerGroup("OB_Over_Single_Team2_Player5"),
        makePlayerGroup("OB_Over_Single_Team2_Player6"),
    }
    g_OB_Over_UI = {
        win = {
            {OB_Over_Single_Team1_Win, OB_Over_Single_Team2_Win,},
            {OB_Over_Team_Team1_Win, OB_Over_Team_Team2_Win,},
        },
        bg = {OB_Over_Single_ClientBK, OB_Over_Team_ClientBK},
        -- 队伍名字
        name = {
            {OB_Over_Single_Team1Title_Name, OB_Over_Team_Team1_Name},
            {OB_Over_Single_Team2Title_Name, OB_Over_Team_Team2_Name},
        },
        team = {
            {
                damage=OB_Over_Team_Team1_Damage, injure=OB_Over_Team_Team1_Tank,
                cure=OB_Over_Team_Team1_Heal, kill=OB_Over_Team_Team1_Kill,mp=OB_Over_Team_Team1_MenPai,
            },
            {
                damage=OB_Over_Team_Team2_Damage, injure=OB_Over_Team_Team2_Tank,
                cure=OB_Over_Team_Team2_Heal, kill=OB_Over_Team_Team2_Kill,mp=OB_Over_Team_Team2_MenPai,
            },
        }
    }

    g_OB_Over_Data ={
        page = g_OB_Over_Page.single,
        gameover = 0,
        firstblood = 0,
        showtxt = 1,
    }
end

-- 界面默认位置
function OB_Over_UnifiedPos()
    if (g_OB_Over_UnifiedPosition ~= nil) then
        OB_Over_Frame:SetProperty("UnifiedPosition", g_OB_Over_UnifiedPosition)
    end
end

-- 初始化信息信息
function OB_Over_InitData()
    g_OB_Over_Data.page = g_OB_Over_Page.single
    g_OB_Over_Data.gameover = 0
    g_OB_Over_Data.firstblood = 0
    g_OB_Over_Data.showtxt = 1
end

function OB_Over_Show()
    if GMVisible:LuaFnGetViewType() == 0 then
        return
    end

    OB_Over_InitData()

    if g_OB_Over_Data.page == g_OB_Over_Page.single then
        OB_Over_Switch_Show_Single()
    elseif g_OB_Over_Data.page == g_OB_Over_Page.team then
        OB_Over_Switch_Show_Team()
    end

    this:Show()
end

-- 更新玩家信息
function OB_Over_UpdateMember()
    if g_OB_Over_Data.page == g_OB_Over_Page.single then
        OB_Over_SingleMemberShow_Common()
    elseif g_OB_Over_Data.page == g_OB_Over_Page.team then
        OB_Over_TeamMemberShow_Common()
    end
end

-- 更新其他界面信息
function OB_Over_UpdateOtherInfo()
    OB_Over_OtherInfoShow_Common()
end

-- 更新其他界面信息
function OB_Over_UpdateFirstBlood()
    OB_Over_FirstBloodShow_Common()
end

-- 更新结果信息
function OB_Over_UpdateResult()
    OB_Over_ResultShow_Common()
end

function OB_Over_SingleMemberShow_Common()

    OB_Over_ClearData_Single()

    local damage_total = {}
    local injure_total = {}
    local cure_total = {}
    
    for i=1, g_OB_Over_Def.teammax do
        damage_total[i] = 0
        injure_total[i] = 0
        cure_total[i] = 0
        for idx=1, g_OB_Over_Def.membermax do
            local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
            if guid ~= -1 and GMVisible:LuaFnGetJoinFlag(i-1, guid) == 1 then
                local data = GMVisible:LuaFnGetChangeData(i-1, guid)
                if data ~= nil then
                    damage_total[i] = damage_total[i] + data.damage
                    injure_total[i] = injure_total[i] + data.injury
                    cure_total[i] = cure_total[i] + data.cure
                end
            end
        end
    end

    for i=1, g_OB_Over_Def.teammax do
        local teamui = g_OB_Over_PlayerUI[i]
        if teamui == nil then
            break
        end
        -- 获取牻队内容
        local uiIdx = 1
        local zoneid,teamname = GMVisible:LuaFnGetTeamInfo(i-1)
        for idx=1, g_OB_Over_Def.membermax do
            local playerui = teamui[uiIdx]
            if playerui ~= nil then
                local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
                if guid ~= -1 and GMVisible:LuaFnGetJoinFlag(i-1, guid) == 1 then
                    uiIdx = uiIdx + 1
                    local basedata = GMVisible:LuaFnGetBaseData(i-1, guid)
                    if basedata ~= nil and type(basedata) == "table" then
                        playerui.bg:Show()
                        -- 门派
                        local mpinfo = g_OB_Over_MP[basedata.mp]
                        if mpinfo ~= nil then
                            -- 名字
                            local transname = OB_Over_TransformName(basedata.name, zoneid)
                            playerui.name:SetText(transname)
                            -- 门派
                            playerui.mp:SetText(mpinfo.color..mpinfo.name)
                        end
                    end
                    local data = GMVisible:LuaFnGetChangeData(i-1, guid)
                    if data ~= nil and type(data) == "table" then
                        -- 对显示类型进行区分
                        if g_OB_Over_Data.showtxt > 0 then
                            if damage_total[i] > 0 then
                                playerui.damage:SetText(math.floor(data.damage/damage_total[i] * 100 + 0.5).."%")
                                playerui.damage:SetProgress(data.damage, damage_total[i])
                            end
                            if injure_total[i] > 0 then
                                playerui.injure:SetText(math.floor(data.injury/injure_total[i] * 100 + 0.5).."%")
                                playerui.injure:SetProgress(data.injury, injure_total[i])
                            end
                            if cure_total[i] > 0 then
                                playerui.cure:SetText(math.floor(data.cure/cure_total[i] * 100 + 0.5).."%")
                                playerui.cure:SetProgress(data.cure, cure_total[i])
                            end
                            playerui.damage:Show()
                            playerui.injure:Show()
                            playerui.cure:Show()
                        else
                            playerui.damagetxt:SetText(tostring(data.damage))
                            playerui.injuretxt:SetText(tostring(data.injury))
                            playerui.curetxt:SetText(tostring(data.cure))
                            playerui.damagetxt:Show()
                            playerui.injuretxt:Show()
                            playerui.curetxt:Show()
                        end
                        playerui.kill:SetText(tostring(data.kill))
                    end
                end
            end
        end
    end
end

function OB_Over_TeamMemberShow_Common()
    OB_Over_ClearData_Team()

    for i=1, g_OB_Over_Def.teammax do
        local teamui = g_OB_Over_UI.team[i]
        if teamui ~= nil then
            local damage_total = 0
            local injure_total = 0  
            local cure_total = 0
            local kill_total = 0
            for idx=1, g_OB_Over_Def.membermax do
                local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
                if guid ~= -1 and GMVisible:LuaFnGetJoinFlag(i-1, guid) == 1 then
                    local data = GMVisible:LuaFnGetChangeData(i-1, guid)
                    if data ~= nil then
                        damage_total = damage_total + data.damage
                        injure_total = injure_total + data.injury
                        cure_total = cure_total + data.cure
                        kill_total = kill_total + data.kill
                    end
                end
            end
            teamui.damage:SetText(damage_total)
            teamui.injure:SetText(injure_total)
            teamui.cure:SetText(cure_total)
            teamui.kill:SetText(kill_total)
            teamui.mp:Hide()
        end
    end
end

-- 更新其他界面信息
function OB_Over_OtherInfoShow_Common()
    for i=1, g_OB_Over_Def.teammax do
        local zoneid, name = GMVisible:LuaFnGetTeamInfo(i-1)
        local transname = OB_Over_TransformName(name, zoneid)
        local nameui = g_OB_Over_UI.name[i]
        for _, ui in (nameui or {}) do
            ui:SetText(transname)
        end
    end
    -- 比赛类型
    local matchtype = GMVisible:LuaFnMatchType()
    if matchtype == g_OB_Over_Type.zbs then
        --OB_Over_Title:SetText("#{WCBZ_180128_245}")
    end
end

function OB_Over_FirstBloodShow_Common()
    OB_Over_Single_Team1Title_FB:Hide()
    OB_Over_Single_Team2Title_FB:Hide()
    OB_Over_Team_Team1_FB:Hide()
    OB_Over_Team_Team2_FB:Hide()

    local fstblood = GMVisible:LuaFnGetFirstBloodTeam()
    if fstblood <= 0 then
        return
    end

    if g_OB_Over_Data.page == g_OB_Over_Page.team then
        if fstblood == g_OB_Over_Def.fstblood_teamfst then
            OB_Over_Team_Team1_FB:Show()
        elseif fstblood == g_OB_Over_Def.fstblood_teamsec then
            OB_Over_Team_Team2_FB:Show()
        end
    elseif g_OB_Over_Data.page == g_OB_Over_Page.single then
        if fstblood == g_OB_Over_Def.fstblood_teamfst then
            OB_Over_Single_Team1Title_FB:Show()
        elseif fstblood == g_OB_Over_Def.fstblood_teamsec then
            OB_Over_Single_Team2Title_FB:Show()
        end
    end
end

-- 更新结果信息
function OB_Over_ResultShow_Common()

    for _, winui in (g_OB_Over_UI.win or {}) do
        for _, ui in (winui or {}) do
            ui:Hide()
        end
    end
    if g_OB_Over_Data.gameover <= 0 then
        return
    end

    local resultui = g_OB_Over_UI.win[g_OB_Over_Data.page]
    if resultui ~= nil then
        local result = GMVisible:LuaFnGetResult()
        if resultui[result] ~= nil then
            resultui[result]:Show()
        end
    end
end

function OB_Over_Frame_Show()
    for i, ui in (g_OB_Over_UI.bg or {}) do
        if i == g_OB_Over_Data.page then
            ui:Show()
        else
            ui:Hide()
        end
    end
end

--清除数据
function OB_Over_ClearData_Single()
    for i=1, g_OB_Over_Def.teammax do
        local teamui = g_OB_Over_PlayerUI[i]
        for idx=1, g_OB_Over_Def.membermax do
            local playerui = teamui[idx]
            if playerui ~= nil then
                playerui.damage:SetText("0%")
                playerui.injure:SetText("0%")
                playerui.cure:SetText("0%")
                playerui.damage:SetProgress(0, 100)
                playerui.injure:SetProgress(0, 100)
                playerui.cure:SetProgress(0, 100)
                playerui.damagetxt:SetText(0)
                playerui.injuretxt:SetText(0)
                playerui.curetxt:SetText(0)
                playerui.damage:Hide()
                playerui.injure:Hide()
                playerui.cure:Hide()
                playerui.damagetxt:Hide()
                playerui.injuretxt:Hide()
                playerui.curetxt:Hide()
                playerui.bg:Hide()
            end
        end
    end


    OB_Over_Team_Client:Hide()
    OB_Over_Single_Client:Show()

    OB_Over_Single_Title_Tab:SetCheck(1)
    OB_Over_Team_Title_Tab:SetCheck(0)
    OB_Over_Change_Title_Tab:Show()
end

--清除数据
function OB_Over_ClearData_Team()
    OB_Over_Team_Client : Show()
    OB_Over_Single_Client : Hide()

    OB_Over_Single_Title_Tab:SetCheck(0)
    OB_Over_Team_Title_Tab:SetCheck(1)
    OB_Over_Change_Title_Tab:Hide()

end

-- 转换名字
function OB_Over_TransformName(name, zoneid)
    if zoneid <= 0 then
        return name
    end

    local serverName = DataPool:GetServerName( zoneid )
    retname = name.."@"..tostring(serverName)

    return retname
end

function OB_Over_Hide()
    this:Hide()
end

-- 关睜按钮点击事件
function OB_Over_Clicked_Close()
    OB_Over_Hide()
end

function OB_Over_OpenMember_Click()
    OB_Over_Hide()
end

-- 切换团队显示
function OB_Over_Switch_Show_Team()
    g_OB_Over_Data.page = g_OB_Over_Page.team

    OB_Over_Frame_Show()
    OB_Over_UpdateMember()
    OB_Over_UpdateFirstBlood()
    OB_Over_UpdateResult()
    OB_Over_UpdateOtherInfo()
end

-- 切换个人显示
function OB_Over_Switch_Show_Single()
    g_OB_Over_Data.page = g_OB_Over_Page.single

    OB_Over_Frame_Show()
    OB_Over_UpdateMember()
    OB_Over_UpdateFirstBlood()
    OB_Over_UpdateResult()
    OB_Over_UpdateOtherInfo()
end

-- 结果牴示
function OB_Over_BattleResult_Show()
    g_OB_Over_Data.gameover = 1
    OB_Over_UpdateFirstBlood()
    OB_Over_UpdateResult()
end

-- 数据刷新
function OB_Over_DataFresh()
    OB_Over_UpdateMember()
    OB_Over_UpdateFirstBlood()
end

--切换数据
function OB_Over_Switch_Data_Click()
    if g_OB_Over_Data.showtxt > 0 then
        g_OB_Over_Data.showtxt = 0
    else
        g_OB_Over_Data.showtxt = 1
    end

    OB_Over_UpdateMember()
end

function OB_Over_TransHideScn()
    local scnid = GetSceneID()
    for _, id in (g_OB_Over_ScnID or {}) do
        if scnid == id then
            return
        end
    end

    OB_Over_Hide()
end
