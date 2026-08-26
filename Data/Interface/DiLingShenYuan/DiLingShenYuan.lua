-- 帝陵深渊场景信息展示UI

-- UI展开、关闭标记
local DiLingShenYuan_OpenFlag = 1

-- 默认位置
local DiLingShenYuan_UnifiedPosition = nil

function DiLingShenYuan_PreLoad()
    this:RegisterEvent("DLZXPVP_DLSYSCENEINFO", true)
    this:RegisterEvent("DLZXPVP_DLSYUPDATEOPENFLAG", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end -- end func DiLingShenYuan_PreLoad()

function DiLingShenYuan_OnEvent(event)
    if (event == "DLZXPVP_DLSYSCENEINFO") then
        if (DiLingShenYuan_OpenFlag > 0) then
            if (not this:IsVisible()) then
                DiLingShenYuan_Show()
            end

            DiLingShenYuan_UpdateInfo(tonumber(arg0), tonumber(arg1), tonumber(arg2), tonumber(arg3))
        end
    elseif (event == "DLZXPVP_DLSYUPDATEOPENFLAG") then
        DiLingShenYuan_OpenFlag = tonumber(arg0)
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DiLingShenYuan_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DiLingShenYuan_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DiLingShenYuan_UnifiedPos()
	end
end -- end func DiLingShenYuan_OnEvent()

function DiLingShenYuan_OnLoad()
	DiLingShenYuan_UnifiedPosition = DiLingShenYuan_Frame:GetProperty("UnifiedPosition")
end -- end func DiLingShenYuan_OnLoad()

-- 界面默认位置
function DiLingShenYuan_UnifiedPos()
	if (DiLingShenYuan_UnifiedPosition ~= nil) then
		DiLingShenYuan_Frame:SetProperty("UnifiedPosition", DiLingShenYuan_UnifiedPosition)
	end
end -- end func DiLingShenYuan_UnifiedPos()

function DiLingShenYuan_Show()
    this:Show()
end -- end func DiLingShenYuan_Show()

function DiLingShenYuan_Hide()
    this:Hide()
end -- end func DiLingShenYuan_Hide()

-- 缩小按钮点击事件
function DiLingShenYuan_Button_Clicked_Close()
    DiLingShenYuan_OpenFlag = 0
    PushEvent("DLZXPVP_DLSYSCENEINFO_MINI")
    DiLingShenYuan_Hide()
end -- end func DiLingShenYuan_Button_Clicked_Close()

-- 更新UI
function DiLingShenYuan_UpdateInfo(awardLeft, qyNum, qhznNum, timeLeft)
    -- 奖励剩余次数
    if (DiLingShenYuan_AwardNum ~= nil) then
        local txt = ScriptGlobal_Format("#{DLZX_230518_67}", awardLeft)
        DiLingShenYuan_AwardNum:SetText(txt)
    end

    -- 场上秦皇执念boss数量
    if (DiLingShenYuan_Monster1Num ~= nil) then
        local txt = ScriptGlobal_Format("#{DLZX_230518_69}", qhznNum)
        DiLingShenYuan_Monster1Num:SetText(txt)
    end

    -- 场上秦俑boss数量
    if (DiLingShenYuan_Monster2Num ~= nil) then
        local txt = ScriptGlobal_Format("#{DLZX_230518_68}", qyNum)
        DiLingShenYuan_Monster2Num:SetText(txt)
    end

    local roundFlag = math.floor(timeLeft / 10000)
    local timeLeftVal = math.mod(timeLeft, 10000)
    -- 剩余 分
    local minLeft = math.floor(timeLeftVal / 60)
    local minLeftTxt = nil
    if (minLeft < 10) then
        minLeftTxt = string.format("0%d", minLeft)
    else
        minLeftTxt = string.format("%d", minLeft)
    end
    -- 剩余 秒
    local secLeft = math.mod(timeLeftVal, 60)
    local secLeftTxt = nil
    if (secLeft < 10) then
        secLeftTxt = string.format("0%d", secLeft)
    else
        secLeftTxt = string.format("%d", secLeft)
    end
    if (roundFlag == 2) then
        -- 宝箱都刷完了 提示距离活动结束的时间
        if (DiLingShenYuan_Time ~= nil) then
            DiLingShenYuan_Time:SetText("#{DLZX_230518_72}")
        end
        if (DiLingShenYuan_TimeNum ~= nil) then
            local txt = ScriptGlobal_Format("#{DLZX_230518_73}", minLeftTxt, secLeftTxt)
            DiLingShenYuan_TimeNum:SetText(txt)
        end
    elseif (roundFlag == 1) then
        -- boss刷完了但宝箱还没刷 提示宝箱时间
        if (DiLingShenYuan_Time ~= nil) then
            DiLingShenYuan_Time:SetText("#{DLZX_230518_119}")
        end
        if (DiLingShenYuan_TimeNum ~= nil) then
            local txt = ScriptGlobal_Format("#{DLZX_230518_71}", minLeftTxt, secLeftTxt)
            DiLingShenYuan_TimeNum:SetText(txt)
        end
    else
        -- 不是最后一轮boss
        if (DiLingShenYuan_Time ~= nil) then
            DiLingShenYuan_Time:SetText("#{DLZX_230518_70}")
        end
        if (DiLingShenYuan_TimeNum ~= nil) then
            local txt = ScriptGlobal_Format("#{DLZX_230518_71}", minLeftTxt, secLeftTxt)
            DiLingShenYuan_TimeNum:SetText(txt)
        end
    end
end -- end func DiLingShenYuan_UpdateInfo()