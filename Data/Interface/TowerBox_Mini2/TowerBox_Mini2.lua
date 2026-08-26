-- 跨服爬塔夺宝 龙塔三层奖励（神龙祝福）宝箱信息展示UI

-- 默认位置
local TowerBox_Mini2_UnifiedPosition = nil


function TowerBox_Mini2_PreLoad()
	this:RegisterEvent("PTDB_UI_BOXINFOMINI", true)
	this:RegisterEvent("PTDB_UI_CLOSEBOXINFO", true)
	this:RegisterEvent("PTDB_UI_CLOSEBOXINFOMINI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end -- end func TowerBox_Mini2_PreLoad()

function TowerBox_Mini2_OnEvent(event)
    if (event == "PTDB_UI_BOXINFOMINI") then
        TowerBox_Mini2_Show()
    elseif (event == "PTDB_UI_CLOSEBOXINFO") then
		TowerBox_Mini2_Hide()
	elseif (event == "PTDB_UI_CLOSEBOXINFOMINI") then
		TowerBox_Mini2_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		TowerBox_Mini2_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TowerBox_Mini2_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		TowerBox_Mini2_UnifiedPos()
	end
end -- end func TowerBox_Mini2_OnEvent()

function TowerBox_Mini2_OnLoad()
	TowerBox_Mini2_UnifiedPosition = TowerBox_Mini2_Frame:GetProperty("UnifiedPosition")
end -- end func TowerBox_Mini2_OnLoad()

function TowerBox_Mini2_OnHidden()
end -- end func TowerBox_Mini2_OnHidden()

function TowerBox_Mini2_Open()
    PushEvent("PTDB_UI_BOXINFORESUME")
    TowerBox_Mini2_Hide()
end -- end func TowerBox_Mini2_Open()

function TowerBox_Mini2_Small()
    PushEvent("PTDB_UI_BOXINFORESUME")
    TowerBox_Mini2_Hide()
end -- end func TowerBox_Mini2_Small()

-- 界面默认位置
function TowerBox_Mini2_UnifiedPos()
	if (TowerBox_Mini2_UnifiedPosition ~= nil) then
		TowerBox_Mini2_Frame:SetProperty("UnifiedPosition", TowerBox_Mini2_UnifiedPosition)
	end
end -- end func TowerBox_Mini2_UnifiedPos()

function TowerBox_Mini2_Show()
	this:Show()
end -- end func TowerBox_Mini2_Show()

function TowerBox_Mini2_Hide()
	this:Hide()
end -- end func TowerBox_Mini2_Hide()