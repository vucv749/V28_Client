-- 双人玩法 效果界面

-- 默认位置
local DoublePK_Over_UnifiedPosition = nil
local DoublePK_Over_UICommandId = 99831901
local DoublePK_Over_Type = {
    invalid = 0,                                                    -- ??
    win_a = 1,                                                      -- ??
    win_b = 2,                                                      -- ??
    equal = 3,                                                      -- ??
    fail = 4,                                                       -- ??
    escwin_a = 5,                                                   -- ??
    escwin_b = 6,                                                   -- ??
}
DoublePK_Over_TeamType                     = {                      -- ????,??define?????
    team_a = 0,                                                     -- A?
    team_b = 1,                                                     -- B?
    team_max = 2,                                                   -- ????
}
function DoublePK_Over_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function DoublePK_Over_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == DoublePK_Over_UICommandId) then
        DoublePK_Over_Show()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Over_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Over_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Over_UnifiedPos()
	end
end

function DoublePK_Over_OnLoad()
	DoublePK_Over_UnifiedPosition = DoublePK_Over_Frame:GetProperty("UnifiedPosition")
	DoublePK_Over_InitCtrlList()
end

function DoublePK_Over_InitCtrlList()
end

-- 界面默认位置
function DoublePK_Over_UnifiedPos()
	if (DoublePK_Over_UnifiedPosition ~= nil) then
		DoublePK_Over_Frame:SetProperty("UnifiedPosition", DoublePK_Over_UnifiedPosition)
	end
end

function DoublePK_Over_Show()
    PushEvent("CLOSE_DOUBLEPK_ALL")
    DoublePK_Over_BaseShow()
    this:Show()
end

function DoublePK_Over_BaseShow()
    local teamId = Get_XParam_INT(0)
    local winTeam = Get_XParam_INT(1)
    local score = Get_XParam_INT(2)
    local weekscore = Get_XParam_INT(3)
    local loseWinTeam = Get_XParam_INT(4)
    local teambind = Get_XParam_INT(5)
    local name = Get_XParam_STR(0)
    -- 胜负
    local szDesc,szImage = DoublePK_Over_GetDesc(teamId, winTeam, loseWinTeam)
    DoublePK_Over_Text1:SetText(szDesc)
    DoublePK_Over_Fight:SetProperty("Image", szImage)
    -- 得分
    --local szScore = ScriptGlobal_Format("#{SRPK_230331_187}", score)
    --DoublePK_Over_Text2:SetText(szScore)
    -- 时间
    --local sec = math.mod(time,60)
    --local min = math.floor(time/60)
    --local szTime = ScriptGlobal_Format("#{SRPK_230331_188}", min, sec)
    --DoublePK_Over_Text3:SetText(szTime)
    DoublePK_Over_Text2:SetText("")
    DoublePK_Over_Text3:SetText("")
    -- 绑定关系
    if teambind > 0 then
        if score > 0 then
            local szScore = ScriptGlobal_Format("#{SRPK_230331_285}", name, score)
            DoublePK_Over_Text2:SetText(szScore)
        end
        --if weekscore > 0 then
        --    local szWeekScore = ScriptGlobal_Format("#{SRPK_230331_189}", name, weekscore)
        --    DoublePK_Over_Text2:SetText(szWeekScore)
        --end
        if score <= 0 or weekscore <= 0 then
            DoublePK_Over_Text2:SetText("#{SRPK_230331_287}")
        end
    else
        local szMsg = ScriptGlobal_Format("#{SRPK_230331_286}", name)
        DoublePK_Over_Text2:SetText(szMsg)
    end

end

function DoublePK_Over_GetDesc(teamId, winTeam, loseWinTeam)
    local szDesc = "#{SRPK_230331_185}"
    local szImage = "set:Makefriends image:SB"
    if winTeam == DoublePK_Over_Type.equal then
        szDesc = "#{SRPK_230331_185}"
        szImage = "set:Makefriends image:PJ"
    elseif teamId == DoublePK_Over_TeamType.team_a then
        if winTeam == DoublePK_Over_Type.win_a then
            if loseWinTeam == DoublePK_Over_Type.invalid then
                szDesc = "#{SRPK_230331_184}"
            else
                szDesc = "#{SRPK_230331_265}"
            end
            szImage = "set:Makefriends image:SL"
        elseif winTeam == DoublePK_Over_Type.win_b then
            szDesc = "#{SRPK_230331_186}"
        elseif winTeam == DoublePK_Over_Type.escwin_a then
            szDesc = "#{SRPK_230331_266}"
            szImage = "set:Makefriends image:SL"
        elseif winTeam == DoublePK_Over_Type.escwin_b then
            szDesc = "#{SRPK_230331_186}"
        end
    elseif teamId == DoublePK_Over_TeamType.team_b then
        if winTeam == DoublePK_Over_Type.win_a then
            szDesc = "#{SRPK_230331_186}"
        elseif winTeam == DoublePK_Over_Type.win_b then
            if loseWinTeam == DoublePK_Over_Type.invalid then
                szDesc = "#{SRPK_230331_184}"
            else
                szDesc = "#{SRPK_230331_265}"
            end
            szImage = "set:Makefriends image:SL"
        elseif winTeam == DoublePK_Over_Type.escwin_a then
            szDesc = "#{SRPK_230331_186}"
        elseif winTeam == DoublePK_Over_Type.escwin_b then
            szDesc = "#{SRPK_230331_266}"
            szImage = "set:Makefriends image:SL"
        end
    end

    return szDesc,szImage
end

function DoublePK_Over_Hide()
    this:Hide()
end

-- 关睜按钮点击事件
function DoublePK_Over_Clicked_Close()
    DoublePK_Over_Hide()
end


