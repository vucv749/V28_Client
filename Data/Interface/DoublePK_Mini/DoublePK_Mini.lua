-- 双人玩法 基本信息UI

-- 默认位置
local DoublePK_Mini_UnifiedPosition = nil
local DoublePK_Mini_UICommandClose = 99831901
local DoublePK_Mini_UICommandOpen = 99831902
local DoublePK_Mini_GuessList = {}
local DoublePK_Mini_GuessMax = 7

local DoublePK_Mini_Identity_QS = 1                           -- 琴师

local DoublePK_Mini_Team_Type = {                             -- 队伍分类，这个define是对应关系
    team_a = 0,                                               -- A队
    team_b = 1,                                               -- B队
}
local DoublePK_Mini_GuessResult = {                           -- 选项类型，猜拳结果
    invalid = 0,                                              -- 无效
    win_a = 1,                                                -- 选项
    win_b = 2,                                                -- 选项
    equal = 3,                                                -- 选项
    fail = 4,                                                 -- 选项
}

function DoublePK_Mini_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("OPEN_DOUBLEPK_MINI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function DoublePK_Mini_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == DoublePK_Mini_UICommandOpen) then
        DoublePK_Mini_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == DoublePK_Mini_UICommandClose) then
        DoublePK_Mini_Hide()
    elseif (event == "OPEN_DOUBLEPK_MINI") then
        if not IsWindowShow("DoublePK_Mini2") then
            this:Show()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Mini_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Mini_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Mini_UnifiedPos()
	end
end

function DoublePK_Mini_OnLoad()
    DoublePK_Mini_UnifiedPosition = DoublePK_Mini_Frame:GetProperty("UnifiedPosition")
    
    DoublePK_Mini_GuessList = {
        DoublePK_Mini_PageHeaderText1,
        DoublePK_Mini_PageHeaderText2,
        DoublePK_Mini_PageHeaderText3,
        DoublePK_Mini_PageHeaderText4,
        DoublePK_Mini_PageHeaderText5,
        DoublePK_Mini_PageHeaderText6,
        DoublePK_Mini_PageHeaderText7,
    }
end



-- 界面默认位置
function DoublePK_Mini_UnifiedPos()
	if (DoublePK_Mini_UnifiedPosition ~= nil) then
		DoublePK_Mini_Frame:SetProperty("UnifiedPosition", DoublePK_Mini_UnifiedPosition)
	end
end

function DoublePK_Mini_Show()
    local step = Get_XParam_INT(0)
    local timer = Get_XParam_INT(1)
    local start = Get_XParam_INT(2)
    local guesswin = Get_XParam_INT(3)
    local team = Get_XParam_INT(4)
    local identity = Get_XParam_INT(5)
    local wininfo = {}
    for i=1, DoublePK_Mini_GuessMax do
        wininfo[i] = Get_XParam_INT(i+5)
    end

    if step == 0 and start <= 0 then
        DoublePK_Mini_PageHeaderTime2:SetText("#{SRPK_230331_222}")
        DoublePK_Mini_PageHeaderTime:Hide()
    else
        DoublePK_Mini_PageHeaderTime:Show()
        if timer > 0 then
            DoublePK_Mini_PageHeaderTime2:SetText("")
            DoublePK_Mini_PageHeaderTime:SetProperty("Timer", timer)
        else
            DoublePK_Mini_PageHeaderTime:SetProperty("Timer", 0)
        end
        DoublePK_Mini_PageHeaderTime:SetProperty("TextColor","FFFFF263")
    end


    DoublePK_Mini_WinGo:Disable()
    for i=1, DoublePK_Mini_GuessMax do
        DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_317}")
    end

    local timeTotal = 0
    if identity > 0 then
        for i=1, DoublePK_Mini_GuessMax do
            if wininfo[i] == DoublePK_Mini_GuessResult.win_a then
                if team == DoublePK_Mini_Team_Type.team_a then
                    timeTotal = timeTotal + 1
                    DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_319}")
                elseif team == DoublePK_Mini_Team_Type.team_b then
                    DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_321}")
                end
            elseif wininfo[i] == DoublePK_Mini_GuessResult.win_b then
                if team == DoublePK_Mini_Team_Type.team_b then
                    timeTotal = timeTotal + 1
                    DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_319}")
                elseif team == DoublePK_Mini_Team_Type.team_a then
                    DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_321}")
                end
            elseif wininfo[i] == DoublePK_Mini_GuessResult.equal then
                DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_320}")
            elseif wininfo[i] == DoublePK_Mini_GuessResult.fail then
                DoublePK_Mini_GuessList[i]:SetText("#{SRPK_230331_321}")
            end
        end

        -- 琴师身份
        if identity == DoublePK_Mini_Identity_QS then
            if guesswin == DoublePK_Mini_GuessResult.equal then
                --DoublePK_Mini_WinGo:Enable()
            elseif team == DoublePK_Mini_Team_Type.team_a and guesswin == DoublePK_Mini_GuessResult.win_a then
                DoublePK_Mini_WinGo:Enable()
            elseif team == DoublePK_Mini_Team_Type.team_b and guesswin == DoublePK_Mini_GuessResult.win_b then
                DoublePK_Mini_WinGo:Enable()
            end
        end
    end

    local szTimes = ScriptGlobal_Format("#{SRPK_230331_318}", timeTotal)
    DoublePK_Mini_WinText:SetText(szTimes)

    if not IsWindowShow("DoublePK_Mini2") then
        this:Show()
    end
end

function DoublePK_Mini_TimeOut()
    DoublePK_Mini_PageHeaderTime2:SetText("#{SRPK_230331_208}")
end

function DoublePK_Mini_Hide()
    this:Hide()
end

function DoublePK_Mini_ClickFighting()
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(998319)
        Set_XSCRIPT_Function_Name("OnSelectFighting")
        Set_XSCRIPT_Parameter(0, -1)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end

-- 关闭按钮点击事件
function DoublePK_Mini_Clicked_Close()
    DoublePK_Mini_Hide()
end

function DoublePK_Mini_Close()
    DoublePK_Mini_Hide()
    PushEvent("OPEN_DOUBLEPK_MINIEX")
end