-- 犱兽PVP 休息室信息牴示UI
-- mini UI打开状态
local Kunwu_PVPDaojishi_MiniUIOpenState = 0
-- 保存UI默认位置
local Kunwu_PVPDaojishi_UnifiedPosition = nil

-- 场景逻辑状态
local Kunwu_PVPDaojishi_LogicState =
{
    before_act = 2,             -- ???? ????????
    in_act = 3,                 -- ????
    after_act = 4,              -- ???? ????????
} -- end Kunwu_PVPDaojishi_LogicState



function Kunwu_PVPDaojishi_PreLoad()
    this:RegisterEvent("PETPVP_UI_OPENRESTINFO")
    this:RegisterEvent("PETPVP_UI_UPDATERESTINFO")
    this:RegisterEvent("PETPVP_UI_CLOSERESTINFO")
    this:RegisterEvent("PETPVP_UI_RESTORERESTINFO")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????
	this:RegisterEvent("ADJEST_UI_POS")
end -- end func Kunwu_PVPDaojishi_PreLoad()

function Kunwu_PVPDaojishi_OnLoad()
	Kunwu_PVPDaojishi_UnifiedPosition = Kunwu_PVPDaojishi:GetProperty("UnifiedPosition")
end -- end func Kunwu_PVPDaojishi_OnLoad()

function Kunwu_PVPDaojishi_OnEvent(event)
    if event == "PETPVP_UI_OPENRESTINFO" then
        Kunwu_PVPDaojishi_MiniUIOpenState = 0
        Kunwu_PVPDaojishi_UpdateRestInfo(0, 0, 0, 0)
        Kunwu_PVPDaojishi_Show()
    elseif event == "PETPVP_UI_UPDATERESTINFO" then
        Kunwu_PVPDaojishi_UpdateRestInfo(tonumber(arg0), tonumber(arg1), tonumber(arg2), tonumber(arg3))

        if (Kunwu_PVPDaojishi_MiniUIOpenState <= 0 and not this:IsVisible()) then
            Kunwu_PVPDaojishi_Show()
        end
    elseif event == "PETPVP_UI_CLOSERESTINFO" then
        Kunwu_PVPDaojishi_MiniUIOpenState = 1
        Kunwu_PVPDaojishi_Hide()
    elseif event == "PETPVP_UI_RESTORERESTINFO" then
        Kunwu_PVPDaojishi_MiniUIOpenState = 0
        Kunwu_PVPDaojishi_UpdateRestInfo(0, 0, 0, 0)
        Kunwu_PVPDaojishi_Show()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_PVPDaojishi_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Kunwu_PVPDaojishi_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Kunwu_PVPDaojishi_Hide()
	end
end -- end func Kunwu_PVPDaojishi_OnEvent()

function Kunwu_PVPDaojishi_On_ResetPos()
    if (Kunwu_PVPDaojishi_UnifiedPosition ~= nil) then
        Kunwu_PVPDaojishi:SetProperty("UnifiedPosition", Kunwu_PVPDaojishi_UnifiedPosition)
    end
end -- end func Kunwu_PVPDaojishi_On_ResetPos()

function Kunwu_PVPDaojishi_Show()
    PushEvent("PETPVP_UI_CLOSERESTINFOMINI")
    this:Show()
end -- end func Kunwu_PVPDaojishi_Show()

function Kunwu_PVPDaojishi_Hide()
    this:Hide()
end -- end func Kunwu_PVPDaojishi_Hide()

-- 最小化按钮
function Kunwu_PVPDaojishi_OpenMini()
    Kunwu_PVPDaojishi_MiniUIOpenState = 1
    PushEvent("PETPVP_UI_OPENRESTINFOMINI")
    Kunwu_PVPDaojishi_Hide()
end -- end func Kunwu_PVPDaojishi_OpenMini()

-- 活动结束倒计时开始事件
function Kunwu_PVPDaojishi_StartTime()
end -- end func Kunwu_PVPDaojishi_StartTime()

-- 活动结束倒计时结束事件
function Kunwu_PVPDaojishi_TimeOut()
end -- end func Kunwu_PVPDaojishi_TimeOut()

-- 更新数据
function Kunwu_PVPDaojishi_UpdateRestInfo(stateFlag, teamNum, forceMatchCountdown, actEndCountdown)
    -- 队伍数
    if (teamNum <= 0) then
        Kunwu_PVPDaojishi_Num:SetText("")
    else
        local strTeamNum = ScriptGlobal_Format("#{BXDZ_240918_49}", teamNum)
        Kunwu_PVPDaojishi_Num:SetText(strTeamNum)
    end
    -- 匹配倒计时
    if (forceMatchCountdown <= 0) then
        Kunwu_PVPDaojishi_Time:SetProperty("Timer", tostring(0))
    else
        Kunwu_PVPDaojishi_Time:SetProperty("Timer", tostring(forceMatchCountdown))
    end
    Kunwu_PVPDaojishi_Time:Show()
    -- 活动结束倒计时
    if (actEndCountdown <= 0) then
        Kunwu_PVPDaojishi_Time2:SetProperty("Timer", tostring(0))
    else
        Kunwu_PVPDaojishi_Time2:SetProperty("Timer", tostring(actEndCountdown))
    end
    Kunwu_PVPDaojishi_Time2:Show()
end -- end func Kunwu_PVPDaojishi_UpdateRestInfo()
