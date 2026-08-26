-- 界面最小化

local g_unifiedposistion = nil

function Kunwu_PVPScoreMini_PreLoad()
	this:RegisterEvent("PETPVP_UI_BATTLEMINI_SHOW")
	this:RegisterEvent("PETPVP_UI_BATTLERESULT_SHOW",false)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function Kunwu_PVPScoreMini_OnLoad()
	g_unifiedposistion = Kunwu_PVPScoreMini_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_PVPScoreMini_OnEvent(event)

	if ( event == "PETPVP_UI_BATTLEMINI_SHOW" ) then
		Kunwu_PVPScoreMini_OnShow()
	elseif ( event == "ADJEST_UI_POS" ) then
		Kunwu_PVPScoreMini_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Kunwu_PVPScoreMini_ResetPos()
	elseif(event == "PLAYER_LEAVE_WORLD") then
		Kunwu_PVPScoreMini_CloseClicked()
	elseif(event == "PETPVP_UI_BATTLERESULT_SHOW") then
		Kunwu_PVPScoreMini_CloseClicked()
	end

end

function Kunwu_PVPScoreMini_OnShow()
	if IsWindowShow("Kunwu_PVPScore") then
		CloseWindow("Kunwu_PVPScore", true)
	end
	
	this:Show()

end

--================================================
-- 关闭
--================================================
function Kunwu_PVPScoreMini_OnClose()
	this:Hide()
	PushEvent("PETPVP_UI_BATTLESCORE_SHOW")
end

--================================================
-- 关闭
--================================================
function Kunwu_PVPScoreMini_CloseClicked()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_PVPScoreMini_ResetPos()
	if g_unifiedposistion ~= nil then
		Kunwu_PVPScoreMini_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
	end
end
