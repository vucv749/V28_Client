-- 双人休闲玩法 匹配提示UI

function DoublePlay_Ing_PreLoad()
    this:RegisterEvent("DOUBLEGAME_MATCHINGTIP", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func DoublePlay_Ing_PreLoad()

function DoublePlay_Ing_OnEvent(event)
    if (event == "DOUBLEGAME_MATCHINGTIP") then
        if (tonumber(arg0) > 0) then
            if (not this:IsVisible()) then
                DoublePlay_Ing_Hide()
            end

            DoublePlay_Ing_UpdateUI(tonumber(arg2))
            DoublePlay_Ing_Show()
        else
            DoublePlay_Ing_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePlay_Ing_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePlay_Ing_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePlay_Ing_UnifiedPos()
	end
end -- end func DoublePlay_Ing_OnEvent()

function DoublePlay_Ing_OnLoad()
	-- DoublePlay_Ing_UnifiedPosition = DoublePlay_Ing:GetProperty("UnifiedPosition")
end -- end func DoublePlay_Ing_OnLoad()

-- 界面默认位置
function DoublePlay_Ing_UnifiedPos()
	-- if (DoublePlay_Ing_UnifiedPosition ~= nil) then
	-- 	DoublePlay_Ing:SetProperty("UnifiedPosition", DoublePlay_Ing_UnifiedPosition)
	-- end
end -- end func DoublePlay_Ing_UnifiedPos()

function DoublePlay_Ing_Show()
    this:Show()
end -- end func DoublePlay_Ing_Show()

function DoublePlay_Ing_Hide()
    this:Hide()
end -- end func DoublePlay_Ing_Hide()

function DoublePlay_Ing_UpdateUI(tipType)
    if (tipType == 1) then
        -- 开始匹配
        DoublePlay_Ing_Animate2:Show()
        DoublePlay_Ing_Animate3:Hide()
    else
        -- 匹配成功
        DoublePlay_Ing_Animate2:Hide()
        DoublePlay_Ing_Animate3:Show()
    end
end -- end func DoublePlay_Ing_UpdateUI()