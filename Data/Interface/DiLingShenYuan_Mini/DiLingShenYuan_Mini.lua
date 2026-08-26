-- 帝陵深渊场景信息牴示UI最小化

-- 默认位置
local DiLingShenYuan_Mini_UnifiedPosition = nil

function DiLingShenYuan_Mini_PreLoad()
    this:RegisterEvent("DLZXPVP_DLSYSCENEINFO_MINI", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end -- end func DiLingShenYuan_Mini_PreLoad()

function DiLingShenYuan_Mini_OnEvent(event)
    if (event == "DLZXPVP_DLSYSCENEINFO_MINI") then
        if (not this:IsVisible()) then
            DiLingShenYuan_Mini_Show()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DiLingShenYuan_Mini_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DiLingShenYuan_Mini_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DiLingShenYuan_Mini_UnifiedPos()
	end
end -- end func DiLingShenYuan_Mini_OnEvent()

function DiLingShenYuan_Mini_OnLoad()
	DiLingShenYuan_Mini_UnifiedPosition = DiLingShenYuan_Mini_Frame:GetProperty("UnifiedPosition")
end -- end func DiLingShenYuan_Mini_OnLoad()

-- 界面默认位置
function DiLingShenYuan_Mini_UnifiedPos()
	if (DiLingShenYuan_Mini_UnifiedPosition ~= nil) then
		DiLingShenYuan_Mini_Frame:SetProperty("UnifiedPosition", DiLingShenYuan_Mini_UnifiedPosition)
	end
end -- end func DiLingShenYuan_Mini_UnifiedPos()

function DiLingShenYuan_Mini_Show()
    this:Show()
end -- end func DiLingShenYuan_Mini_Show()

function DiLingShenYuan_Mini_Hide()
    this:Hide()
end -- end func DiLingShenYuan_Mini_Hide()

-- 牴开按钮点击事件
function DiLingShenYuan_Mini_Button_Clicked_Open()
    PushEvent("DLZXPVP_DLSYUPDATEOPENFLAG", 1)
    DiLingShenYuan_Mini_Hide()
end -- end func DiLingShenYuan_Mini_Button_Clicked_Open()
