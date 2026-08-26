-- GM视角

local g_OB_Pad_UnifiedPosition = nil

local g_OB_Pad_Data = {}
local g_OB_Pad_PlayerUI = {}
local g_OB_Pad_UI = {}
local g_OB_Pad_JoinUI = {}

local g_OB_Pad_Def = {
    teammax = 2,                -- ??????
    membermax = 6,              -- ??????
    skillmax = 9,               -- ??????
    buffmax = 9,                -- Buff????
    hpflash = 20,               -- ??????

    result_invalid = -1,        -- ??
    result_equal = 0,           -- ??
    result_teamfst = 1,         -- A?
    result_teamsec = 2,         -- B?
}
local g_OB_Pad_Type = {
    zbs = 1,
}

local g_OB_Pad_ScnID = {
    607,
}
local g_OB_Pad_MP = {
    [0]  ={name="#{WCBZ_180128_59}",color="#cff6600"},    --??
    [1]  ={name="#{WCBZ_180128_65}",color="#cffcc00"},    --??
    [2]  ={name="#{WCBZ_180128_67}",color="#c00ff00"},    --??
    [3]  ={name="#{WCBZ_180128_61}",color="#c0000ff"},    --??
    [4]  ={name="#{WCBZ_180128_68}",color="#cff99cc"},    --??
    [5]  ={name="#{WCBZ_180128_66}",color="#c007700"},    --??
    [6]  ={name="#{WCBZ_180128_60}",color="#cffff00"},    --??
    [7]  ={name="#{WCBZ_180128_63}",color="#cffffff"},    --??
    [8]  ={name="#{WCBZ_180128_64}",color="#c7700ff"},    --??
    [9]  ={name="#{WCBZ_180128_57}",color="#c999999"},    --???
    [10] ={name="#{WCBZ_180128_62}",color="#cffffb3"},    --??
}

function OB_Pad_PreLoad()
    this:RegisterEvent("GMVISIBLE_OPEN", true)
    this:RegisterEvent("GMVISIBLE_ALLDATA", true)
    this:RegisterEvent("GMVISIBLE_CLOSE", false)
    this:RegisterEvent("GMVISIBLE_DATAREFRESH", false)
    this:RegisterEvent("GMVISIBLE_SCORE", false)
    this:RegisterEvent("GMVISIBLE_TIME", false)
    this:RegisterEvent("GMVISIBLE_RESULT", false)
    this:RegisterEvent("SCENE_TRANSED", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
end

function OB_Pad_OnEvent(event)
    if (event == "GMVISIBLE_OPEN") then
        --OB_Pad_Show()
    elseif (event == "GMVISIBLE_ALLDATA") then
        OB_Pad_Show()
    elseif (event == "GMVISIBLE_DATAREFRESH") then
        OB_Pad_SetGameOverState(0)
        OB_Pad_UpdateMember()
        OB_Pad_UpdateTimeInfo()
    elseif (event == "GMVISIBLE_SCORE") then
        OB_Pad_UpdateOtherInfo()
    elseif (event == "GMVISIBLE_RESULT") then
        OB_Pad_SetGameOverState(1)
        OB_Pad_UpdateResult()
        OB_Pad_UpdateTimeInfo()
    elseif (event == "GMVISIBLE_CLOSE") then
        GMVisible:LuaFnCanelView()
        OB_Pad_Hide()
    elseif (event == "GMVISIBLE_TIME") then
        OB_Pad_UpdateTimeInfo()
    elseif (event == "SCENE_TRANSED") then
        OB_Pad_TransHideScn()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        OB_Pad_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        OB_Pad_UnifiedPos()
    end
end

function OB_Pad_OnLoad()
    g_OB_Pad_UnifiedPosition = OB_Pad_Frame:GetProperty("UnifiedPosition")
    OB_Pad_InitCtrlList()
end

function OB_Pad_InitCtrlList()
    g_OB_Pad_PlayerUI = {}
    local makePlayerGroup = function(_prefix,bg,head,mask,name,level,mp)
        return {
            ["bg"] = _G[_prefix..bg],
            ["head"] = _G[_prefix..head],
            ["mask"] = _G[_prefix..mask],
            ["name"] = _G[_prefix..name],
            ["level"] = _G[_prefix..level],
            ["menpai"] = _G[_prefix..mp],
            ["hp"] = _G[_prefix.."HP"],
            ["hpflash"] = _G[_prefix.."HP_Flash"],
            ["mp"] = _G[_prefix.."MP"],
            ["sp"] = _G[_prefix.."SP"],
            ["tep"] = _G[_prefix.."TEP"],
            ["skill"] = {
                _G[_prefix.."Skill1"],
                _G[_prefix.."Skill2"],
                _G[_prefix.."Skill3"],
                _G[_prefix.."Skill4"],
                _G[_prefix.."Skill5"],
                _G[_prefix.."Skill6"],
                _G[_prefix.."Skill7"],
                _G[_prefix.."Skill8"],
                _G[_prefix.."Skill9"],
            },
            ["buff"] = {
                _G[_prefix.."Buff1"],
                _G[_prefix.."Buff2"],
                _G[_prefix.."Buff3"],
                _G[_prefix.."Buff4"],
                _G[_prefix.."Buff5"],
                _G[_prefix.."Buff6"],
                _G[_prefix.."Buff7"],
                _G[_prefix.."Buff8"],
                _G[_prefix.."Buff9"],
            },
        }
    end

    local makePlayerJoinGroup = function(_prefix)
        return {
            ["bg"] = _G[_prefix.."BK"],
            ["head"] = _G[_prefix.."Head"],
            ["name"] = _G[_prefix.."Nametext"],
            ["level"] = _G[_prefix.."Leveltext"],
            ["menpai"] = _G[_prefix.."MenPai"],
        }
    end

    g_OB_Pad_PlayerUI[1] = {}
    g_OB_Pad_PlayerUI[1] = {
        makePlayerGroup("OB_Left_6V6_Player1_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Left_6V6_Player2_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Left_6V6_Player3_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Left_6V6_Player4_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Left_6V6_Player5_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Left_6V6_Player6_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
    }
    g_OB_Pad_PlayerUI[2] = {}
    g_OB_Pad_PlayerUI[2] = {
        makePlayerGroup("OB_Right_6V6_Player1_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Right_6V6_Player2_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Right_6V6_Player3_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Right_6V6_Player4_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Right_6V6_Player5_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
        makePlayerGroup("OB_Right_6V6_Player6_","BK","Head","HeadMask","Nametext","Leveltext","Menpai"),
    }
    g_OB_Pad_JoinUI[1] = {}
    g_OB_Pad_JoinUI[1] = {
        makePlayerJoinGroup("OB_Left_0V0_Player1_"),
        makePlayerJoinGroup("OB_Left_0V0_Player2_"),
        makePlayerJoinGroup("OB_Left_0V0_Player3_"),
        makePlayerJoinGroup("OB_Left_0V0_Player4_"),
        makePlayerJoinGroup("OB_Left_0V0_Player5_"),
        makePlayerJoinGroup("OB_Left_0V0_Player6_"),
    }
    g_OB_Pad_JoinUI[2] = {}
    g_OB_Pad_JoinUI[2] = {
        makePlayerJoinGroup("OB_Right_0V0_Player1_"),
        makePlayerJoinGroup("OB_Right_0V0_Player2_"),
        makePlayerJoinGroup("OB_Right_0V0_Player3_"),
        makePlayerJoinGroup("OB_Right_0V0_Player4_"),
        makePlayerJoinGroup("OB_Right_0V0_Player5_"),
        makePlayerJoinGroup("OB_Right_0V0_Player6_"),
    }
    g_OB_Pad_UI = {
        player = {
            {pk=OB_Left_6V6_Client, rest=OB_Left_0V0_Client,},
            {pk=OB_Right_6V6_Client,rest=OB_Right_0V0_Client,},
        },
        team = {
            OB_Top_TeamAtext, OB_Top_TeamBtext,
        },
        result = {
            OB_Top_TeamA_Win,OB_Top_TeamB_Win
        },
    }
    g_OB_Pad_Data = {
        titleshow = 0,
        gameover = 0,
    }
end

-- 界面默认位置
function OB_Pad_UnifiedPos()
    if (g_OB_Pad_UnifiedPosition ~= nil) then
        OB_Pad_Frame:SetProperty("UnifiedPosition", g_OB_Pad_UnifiedPosition)
    end
end

-- 初始化信息信息
function OB_Pad_InitData()
    g_OB_Pad_Data.titleshow = 0
    g_OB_Pad_Data.gameover = 0
end

function OB_Pad_Show()
    if GMVisible:LuaFnGetViewType() == 0 then
        return
    end

    OB_Pad_InitData()
    OB_Pad_UpdateMember()
    OB_Pad_UpdateTimeInfo()
    OB_Pad_UpdateOtherInfo()
    OB_Pad_UpdateCreatureBoard()
    OB_Pad_UpdateResult()

    OB_Pad_OpenData_Click()
    OB_Pad_CloseOtherUI()

    this:Show()
end

-- 更新玩家信息
function OB_Pad_UpdateMember()
    OB_Pad_ResetMemberUI()
    OB_Pad_MemberShow_Common()
end

-- 更新其他界面信息
function OB_Pad_UpdateOtherInfo()
    OB_Pad_OtherInfoShow_Common()
end

-- 更新其他界面信息
function OB_Pad_UpdateTimeInfo()
    OB_Pad_TimeShow_Common()
end

-- 更新头顶信息
function OB_Pad_UpdateCreatureBoard()
    OB_Pad_CreatureBoardShow_Common()
end

-- 更新结果信息
function OB_Pad_UpdateResult()
    OB_Pad_ResultShow_Common()
end

-- 重置成员UI
function OB_Pad_ResetMemberUI()
    for _, ui in (g_OB_Pad_UI.player or {}) do
        ui.pk:Hide()
        ui.rest:Hide()
    end

    for i=1, g_OB_Pad_Def.teammax do
        local teamui = g_OB_Pad_PlayerUI[i]
        if teamui == nil then
            break
        end
        for idx=1, g_OB_Pad_Def.membermax do
            local playerui = teamui[idx]
            if playerui ~= nil then
                playerui.bg:Hide()
                playerui.head:SetImage("", "")
                playerui.mask:Hide()
                playerui.name:SetText("")
                playerui.level:SetText("")
                playerui.menpai:SetText("")
                playerui.hp:SetProgress(0, 100)
                playerui.mp:SetProgress(0, 100)
                playerui.sp:SetProgress(0, 100)
                playerui.tep:Hide()
                playerui.hpflash:Hide()
                for _, skillui in (playerui.skill or {}) do
                    skillui:Hide()
                end
                for _, buffui in (playerui.buff or {}) do
                    buffui:Hide()
                end
            end
        end
    end
    for i=1, g_OB_Pad_Def.teammax do
        local joinui = g_OB_Pad_JoinUI[i]
        if joinui == nil then
            break
        end
        for idx=1, g_OB_Pad_Def.membermax do
            local playerui = joinui[idx]
            if playerui ~= nil then
                playerui.bg:Hide()
                playerui.head:SetImage("", "")
                playerui.name:SetText("")
                playerui.menpai:SetText("")
            end
        end
    end
end

-- 后续比赛需要特写的，请自行区分别类
function OB_Pad_MemberShow_Common()
    
    for i=1, g_OB_Pad_Def.teammax do
        local teamui = g_OB_Pad_PlayerUI[i]
        if teamui == nil then
            break
        end
        local upidx = 1
        local zoneid,teamname = GMVisible:LuaFnGetTeamInfo(i-1)
        for idx=1, g_OB_Pad_Def.membermax do
            local playerui = teamui[upidx]
            if playerui ~= nil then
                local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
                if guid ~= -1 and GMVisible:LuaFnGetJoinFlag(i-1, guid) == 1 then
                    upidx = upidx + 1
                    local basedata = GMVisible:LuaFnGetBaseData(i-1, guid)
                    if basedata ~= nil and type(basedata) == "table" then
                        playerui.bg:Show()
                        -- 头像
                        local portrait = DataPool:GetPortraitByID(basedata.portrait)
                        playerui.head:SetProperty("Image", (tostring(portrait)))
                        -- 名字
                        local trasformname = OB_Pad_TransformName(basedata.name, zoneid)
                        playerui.name:SetText(trasformname)
                        -- 等级
                        playerui.level:SetText(basedata.level)
                        -- 门派
                        local mpinfo = g_OB_Pad_MP[basedata.mp]
                        if mpinfo ~= nil then
                            playerui.menpai:SetText(mpinfo.name)
                        end
                    end
                    local data = GMVisible:LuaFnGetChangeData(i-1, guid)
                    if data ~= nil and type(data) == "table" then
                        -- 血量
                        playerui.hp:SetProgress(data.hp, 100)
                        -- 蓝量
                        playerui.mp:SetProgress(data.mp, 100)
                        -- 怒气
                        playerui.sp:SetProgress(data.rage, 100)
                        --playerui.tep:SetProgress(data.eng, 100)
                        --playerui.tep:SetProgress(data.eng, 100)
                        -- 蒙灰
                        if data.hp <= 0 or data.state > 0 then
                            playerui.mask:Show()
                        else
                            if data.hp < g_OB_Pad_Def.hpflash then
                                playerui.hpflash:Play(true)
                                playerui.hpflash:Show()
                            end
                        end
                        --data.state
                        -- 技能
                        for pos, skillui in (playerui.skill or {}) do
                            local skillid, time = GMVisible:LuaFnGetSkill(i-1, guid, pos-1)
                            if skillid > 0 then
                                local icon,tips = GMVisible:LuaFnGetSkillInfo(skillid)
                                skillui:SetProperty("ShortImage", icon)
                                skillui:SetToolTip(tips)
                                skillui:Show()
                            end
                        end
                        -- Buff
                        for pos, buffui in (playerui.buff or {}) do
                            local buffid, time = GMVisible:LuaFnGetBuff(i-1, guid, pos-1)
                            if buffid > 0 then
                                local icon,tips = GMVisible:LuaFnGetBuffInfo(buffid)
                                buffui:SetProperty("ShortImage", icon)
                                buffui:SetToolTip(tips)
                                buffui:Show()
                            end
                        end
                        -- 头顶信息
                        if g_OB_Pad_Data.titleshow <= 0 then
                            GMVisible:LuaFnSetSpecialObjHp(guid, data.hp, 100, i)
                            GMVisible:LuaFnShowSpecialObjHp(guid, 1, i)
                        end
                    end
                end
            end
        end

        -- 对需要的区域进行牴示
        local bgui = g_OB_Pad_UI.player[i]
        if bgui ~= nil then
            bgui.pk:Show()
        end
    end

    -- 待上狊的
    for i=1, g_OB_Pad_Def.teammax do
        local teamui = g_OB_Pad_JoinUI[i]
        if teamui == nil then
            break
        end
        local restidx = 1
        local zoneid,teamname = GMVisible:LuaFnGetTeamInfo(i-1)
        for idx=1, g_OB_Pad_Def.membermax do
            local playerui = teamui[restidx]
            if playerui ~= nil then
                local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
                if guid ~= -1 and GMVisible:LuaFnGetJoinFlag(i-1, guid) ~= 1 then
                    restidx = restidx + 1
                    local basedata = GMVisible:LuaFnGetBaseData(i-1, guid)
                    if basedata ~= nil and type(basedata) == "table" then
                        playerui.bg:Show()
                        -- 头像
                        local portrait = DataPool:GetPortraitByID(basedata.portrait)
                        playerui.head:SetProperty("Image", (tostring(portrait)))
                        -- 名字
                        local trasformname = OB_Pad_TransformName(basedata.name, zoneid)
                        playerui.name:SetText(trasformname)
                        -- 等级
                        playerui.level:SetText(basedata.level)
                        -- 门派
                        local mpinfo = g_OB_Pad_MP[basedata.mp]
                        if mpinfo ~= nil then
                            playerui.menpai:SetText(mpinfo.name)
                        end
                    end
                end
            end
        end
        local bgui = g_OB_Pad_UI.player[i]
        if bgui ~= nil then
            bgui.rest:Show()
        end
    end
end

-- 更新其他界面信息
function OB_Pad_OtherInfoShow_Common()
    -- 名字版
    for i=1, g_OB_Pad_Def.teammax do
        local zoneid, name = GMVisible:LuaFnGetTeamInfo(i-1)
        local transname = OB_Pad_TransformName(name, zoneid)
        g_OB_Pad_UI.team[i]:SetText(transname)
    end
    -- 比赛类型
    local matchtype = GMVisible:LuaFnMatchType()
    if matchtype == g_OB_Pad_Type.zbs then
        local score_a, score_b = GMVisible:LuaFnGetScore()
        local scoreStr = ScriptGlobal_Format("#{SJYH_210426_07}", score_a, score_b) 
        OB_Top_Scoretext:SetText(scoreStr)
    else
        OB_Top_Scoretext:SetText("#{WCBZ_180128_245}")
    end
end

function OB_Pad_TimeShow_Common()
    if g_OB_Pad_Data.gameover == 1 then
        OB_Top_Timetext:Show()
        OB_Top_TimeStopWatch:Hide()
        OB_Top_TimeStopWatchIcon:Hide()
        OB_Top_Timetext:SetText("#{SJYH_210426_09}")
    else
        OB_Top_Timetext:Hide()
        OB_Top_TimeStopWatch:Show()
        OB_Top_TimeStopWatchIcon:Show()

        local remainTime = GMVisible:LuaFnGetRemainTime()
        OB_Top_TimeStopWatch:SetProperty("Timer", remainTime)
    end
end

-- 更新头顶信息
function OB_Pad_CreatureBoardShow_Common()
    if g_OB_Pad_Data.titleshow == 1 then
        OB_Right_TitleShow:Hide()
        OB_Right_HPShow:Show()
        OB_Pad_ShowTitle(1)
        OB_Pad_ShowHp(0)
    else
        OB_Right_TitleShow:Show()
        OB_Right_HPShow:Hide()
        OB_Pad_ShowTitle(0)
        OB_Pad_ShowHp(1)
    end
end

-- 更新结果信息
function OB_Pad_ResultShow_Common()
    for _, ui in (g_OB_Pad_UI.result or {}) do
        ui:Hide()
    end

    local win = GMVisible:LuaFnGetResult()
    if win == g_OB_Pad_Def.result_teamfst or win == g_OB_Pad_Def.result_teamsec then
        local winui = g_OB_Pad_UI.result[win]
        if winui ~= nil then
            winui:Show()
        end
    end
end

-- 更新血量信息
function OB_Pad_HpShow_Common(show)
    for i=1, g_OB_Pad_Def.teammax do
        for idx=1, g_OB_Pad_Def.membermax do
            local guid = GMVisible:LuaFnGetGuid(i-1, idx-1)
            if guid ~= -1 then
                local data = GMVisible:LuaFnGetChangeData(i-1, guid)
                if data ~= nil then
                    GMVisible:LuaFnSetSpecialObjHp(guid, data.hp, 100, i)
                    GMVisible:LuaFnShowSpecialObjHp(guid, show, i)
                end
            end
        end
    end
end

function OB_Pad_ShowTitle(show)
    GMVisible:LuaFnShowObjTitle(show)
end


function OB_Pad_ShowHp(show)
    OB_Pad_HpShow_Common(show)
end

-- 转换名字
function OB_Pad_TransformName(name, zoneid)
    if zoneid <= 0 then
        return name
    end

    local serverName = DataPool:GetServerName( zoneid )
    retname = name.."@"..tostring(serverName)

    return retname
end

function OB_Pad_TransHideScn()
    local scnid = GetSceneID()
    for _, id in (g_OB_Pad_ScnID or {}) do
        if scnid == id then
            return
        end
    end

    OB_Pad_Hide()
end

function OB_Pad_Hide()
    OB_Pad_ShowTitle(1)
    this:Hide()
end

-- 关睜按钮点击事件
function OB_Pad_Clicked_Close()
    OB_Pad_Hide()
end

function OB_Pad_SelectTarget(teamIdx, memberIdx)
    GMVisible:LuaFnSetMainTargetByIdx(teamIdx-1,memberIdx-1)
end

--显示心情或称号
function OB_Pad_ShowTitle_Click()
    if g_OB_Pad_Data.gameover == 1 then
        --PushDebugMessage("本局比赛已结束")
        return
    end
    
    g_OB_Pad_Data.titleshow = 1
    OB_Pad_UpdateCreatureBoard()
end

--显示血条
function OB_Pad_ShowHp_Click()
    if g_OB_Pad_Data.gameover == 1 then
        --PushDebugMessage("本局比赛已结束")
        return
    end
    
    g_OB_Pad_Data.titleshow = 0
    OB_Pad_UpdateCreatureBoard()
end

function OB_Pad_OpenData_Click()
    PushEvent("GMVISIBLE_OPENDATA")
end

function OB_Left_6V6_Player_ShowTooltip(index, stateType)
end

function OB_Right_6V6_Player_ShowTooltip(index, stateType)
end

function OB_Pad_CloseOtherUI()
    if IsWindowShow("FreshmanWatch") then
        CloseWindow("FreshmanWatch", true)
    end
    if IsWindowShow("FreshmanWatchMin") then
        CloseWindow("FreshmanWatchMin", true)
    end
end

function OB_Pad_SetGameOverState(state)
    g_OB_Pad_Data.gameover = state
end
