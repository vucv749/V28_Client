-- 双人玩法 规则界面

-- 默认位置
local DoublePK_CaiQuanGuiZe_UnifiedPosition = nil

function DoublePK_CaiQuanGuiZe_PreLoad()
    this:RegisterEvent("OPEN_DOUBLEPK_RULE", true)
    this:RegisterEvent("CLOSE_DOUBLEPK_ALL", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function DoublePK_CaiQuanGuiZe_OnEvent(event)
    if (event == "OPEN_DOUBLEPK_RULE") then
        DoublePK_CaiQuanGuiZe_Show()
    elseif (event == "CLOSE_DOUBLEPK_ALL") then
        DoublePK_CaiQuanGuiZe_Hide()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_CaiQuanGuiZe_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_CaiQuanGuiZe_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_CaiQuanGuiZe_UnifiedPos()
	end
end

function DoublePK_CaiQuanGuiZe_OnLoad()
	DoublePK_CaiQuanGuiZe_UnifiedPosition = DoublePK_CaiQuanGuiZe_Frame:GetProperty("UnifiedPosition")
end


-- 界面默认位置
function DoublePK_CaiQuanGuiZe_UnifiedPos()
	if (DoublePK_CaiQuanGuiZe_UnifiedPosition ~= nil) then
		DoublePK_CaiQuanGuiZe_Frame:SetProperty("UnifiedPosition", DoublePK_CaiQuanGuiZe_UnifiedPosition)
	end
end

function DoublePK_CaiQuanGuiZe_Show()
    DoublePK_CaiQuanGuiZe_BaseShow()
    this:Show()
end

function DoublePK_CaiQuanGuiZe_BaseShow()

end

function DoublePK_CaiQuanGuiZe_Hide()
    this:Hide()
end


-- 关闭按钮点击事件
function DoublePK_CaiQuanGuiZe_Clicked_Close()
    DoublePK_CaiQuanGuiZe_Hide()
end


