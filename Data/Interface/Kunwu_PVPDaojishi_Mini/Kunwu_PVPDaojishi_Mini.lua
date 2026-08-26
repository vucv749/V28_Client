-- 珍兽PVP 休息室信息展示UI最小化
-- 默认位置
local Kunwu_PVPDaojishi_Mini_UnifiedPosition = nil



function Kunwu_PVPDaojishi_Mini_PreLoad()
    this:RegisterEvent("PETPVP_UI_OPENRESTINFOMINI", true)
    this:RegisterEvent("PETPVP_UI_CLOSERESTINFOMINI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end -- end func Kunwu_PVPDaojishi_Mini_PreLoad()

function Kunwu_PVPDaojishi_Mini_OnEvent(event)
    if (event == "PETPVP_UI_OPENRESTINFOMINI") then
        Kunwu_PVPDaojishi_Mini_Show()
    elseif (event == "PETPVP_UI_CLOSERESTINFOMINI") then
        Kunwu_PVPDaojishi_Mini_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Kunwu_PVPDaojishi_Mini_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_PVPDaojishi_Mini_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		Kunwu_PVPDaojishi_Mini_UnifiedPos()
	end
end -- end func Kunwu_PVPDaojishi_Mini_OnEvent()

function Kunwu_PVPDaojishi_Mini_OnLoad()
	Kunwu_PVPDaojishi_Mini_UnifiedPosition = Kunwu_PVPDaojishi_Mini_Frame:GetProperty("UnifiedPosition")
end -- end func Kunwu_PVPDaojishi_Mini_OnLoad()

-- 界面默认位置
function Kunwu_PVPDaojishi_Mini_UnifiedPos()
	if (Kunwu_PVPDaojishi_Mini_UnifiedPosition ~= nil) then
		Kunwu_PVPDaojishi_Mini_Frame:SetProperty("UnifiedPosition", Kunwu_PVPDaojishi_Mini_UnifiedPosition)
	end
end -- end func Kunwu_PVPDaojishi_Mini_UnifiedPos()

function Kunwu_PVPDaojishi_Mini_Show()
    this:Show()
end -- end func Kunwu_PVPDaojishi_Mini_Show()

function Kunwu_PVPDaojishi_Mini_Hide()
    this:Hide()
end -- end func Kunwu_PVPDaojishi_Mini_Hide()

-- 打开休息室UI按钮点击事件
function Kunwu_PVPDaojishi_Mini_Open()
    PushEvent("PETPVP_UI_RESTORERESTINFO")
    
    Kunwu_PVPDaojishi_Mini_Hide()
end -- end func Kunwu_PVPDaojishi_Mini_Open()