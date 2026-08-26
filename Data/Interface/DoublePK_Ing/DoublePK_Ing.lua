-- 双人PK玩法 匹配提示UI

function DoublePK_Ing_PreLoad()
    this:RegisterEvent("DOUBLEPK_MATCHINGTIP", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end -- end func DoublePK_Ing_PreLoad()

function DoublePK_Ing_OnEvent(event)
    if (event == "DOUBLEPK_MATCHINGTIP") then
        if (tonumber(arg0) > 0) then
            if (not this:IsVisible()) then
                DoublePK_Ing_Hide()
            end

            DoublePK_Ing_UpdateUI(tonumber(arg2))
            DoublePK_Ing_Show()
        else
            DoublePK_Ing_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Ing_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Ing_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Ing_UnifiedPos()
	end
end -- end func DoublePK_Ing_OnEvent()

function DoublePK_Ing_OnLoad()
	-- DoublePK_Ing_UnifiedPosition = DoublePK_Ing:GetProperty("UnifiedPosition")
end -- end func DoublePK_Ing_OnLoad()

-- 界面默认位置
function DoublePK_Ing_UnifiedPos()
	-- if (DoublePK_Ing_UnifiedPosition ~= nil) then
	-- 	DoublePK_Ing:SetProperty("UnifiedPosition", DoublePK_Ing_UnifiedPosition)
	-- end
end -- end func DoublePK_Ing_UnifiedPos()

function DoublePK_Ing_Show()
    this:Show()
end -- end func DoublePK_Ing_Show()

function DoublePK_Ing_Hide()
    this:Hide()
end -- end func DoublePK_Ing_Hide()

function DoublePK_Ing_UpdateUI(tipType)
    if (tipType == 1) then
        -- 开始匹配
        DoublePK_Ing_Animate2:Show()
        DoublePK_Ing_Animate3:Hide()
    else
        -- 匹配成功
        DoublePK_Ing_Animate2:Hide()
        DoublePK_Ing_Animate3:Show()
    end
end -- end func DoublePK_Ing_UpdateUI()
