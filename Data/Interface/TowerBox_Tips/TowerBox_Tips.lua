-- 跨服爬塔夺宝 横幅UI

-- 默认位置
local TowerBox_Tips_UnifiedPosition = nil
local TowerBox_Tips_UICommandClose = 99855901
local TowerBox_Tips_UICommandOpen = 99855903

function TowerBox_Tips_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end

function TowerBox_Tips_OnEvent(event)
    if (event == "UI_COMMAND" and tonumber(arg0) == TowerBox_Tips_UICommandOpen) then
        TowerBox_Tips_Show()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == TowerBox_Tips_UICommandClose) then
        if (this:IsVisible()) then
            TowerBox_Tips_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        TowerBox_Tips_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TowerBox_Tips_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TowerBox_Tips_UnifiedPos()
	end
end


function TowerBox_Tips_OnLoad()
    TowerBox_Tips_UnifiedPosition = TowerBox_Tips_Frame:GetProperty("UnifiedPosition")
end



-- 界面默认位置
function TowerBox_Tips_UnifiedPos()
	if (TowerBox_Tips_UnifiedPosition ~= nil) then
		TowerBox_Tips_Frame:SetProperty("UnifiedPosition", TowerBox_Tips_UnifiedPosition)
	end
end

function TowerBox_Tips_Show()
    -- 提醒的ID
    local str_Idx = Get_XParam_INT(0)
    -- 提醒的字典
    local str_tips = Get_XParam_STR(0)
    -- 给需要改变的文字进行设置字符串
    if str_tips ~= nil then
        TowerBox_Tips_Text:SetText(str_tips)
    end

    TowerBox_Tips_BeginPlay()
    this:Show()
end

-- 开始播放内容
function TowerBox_Tips_BeginPlay()
    -- 6秒线性消失，到时候看看效果
    TowerBox_Tips_Frame:SetProperty("Alpha",1)
    TowerBox_Tips_Frame:Tween_SetInfo("Alpha", "curve:Liner mode:Once duration:6.0 startx:1 starty:0 endx:0.9 endy:0")
    TowerBox_Tips_Frame:Tween_Play("Alpha", true, true)
    
    KillTimer("TowerBox_Tips_OnTimer()")
	SetTimer("TowerBox_Tips","TowerBox_Tips_OnTimer()", 6000)
end

-- 心跳
function TowerBox_Tips_OnTimer()
    TowerBox_Tips_Hide()
end

function TowerBox_Tips_Hide()
    TowerBox_Tips_Frame:Tween_Reset("Alpha",0)

    KillTimer("TowerBox_Tips_OnTimer()")

    this:Hide()
end
