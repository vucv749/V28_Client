--2022周年稳活 许愿泉 倒计时界面
--!!!reloadscript =XuYuanQuan_DaoJiShi

local g_XuYuanQuan_DaoJiShi_Frame_UnifiedPosition = 0


--===============================================
-- PreLoad()
--===============================================
function XuYuanQuan_DaoJiShi_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--????
	this:RegisterEvent("ADJEST_UI_POS",false)				-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- ??????????
	
end
--===============================================
-- OnLoad()
--===============================================
function XuYuanQuan_DaoJiShi_OnLoad()
	g_XuYuanQuan_DaoJiShi_Frame_UnifiedPosition = XuYuanQuan_DaoJiShi_Frame:GetProperty("UnifiedPosition")


end

--===============================================
-- OnEvent()
--===============================================
function XuYuanQuan_DaoJiShi_OnEvent(event)

	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		this:Hide();
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		XuYuanQuan_DaoJiShi_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		XuYuanQuan_DaoJiShi_On_ResetPos()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89330402 ) then

		XuYuanQuan_DaoJiShi_Open()
	end

end

function XuYuanQuan_DaoJiShi_Open()
	if(this:IsVisible())then
		this:Hide()
		return
	end

	this:Show()
	SetTimer("XuYuanQuan_DaoJiShi","XuYuanQuan_DaoJiShi_Timmer()", 4000)
end


function XuYuanQuan_DaoJiShi_Timmer()
	KillTimer("XuYuanQuan_DaoJiShi_Timmer()")
	XuYuanQuan_DaoJiShi_Close()
end

function XuYuanQuan_DaoJiShi_OnHiden()
	this:Hide();
end

function XuYuanQuan_DaoJiShi_Close()
	XuYuanQuan_DaoJiShi_OnHiden()
end

function XuYuanQuan_DaoJiShi_On_ResetPos()
	XuYuanQuan_DaoJiShi_Frame:SetProperty("UnifiedPosition", g_XuYuanQuan_DaoJiShi_Frame_UnifiedPosition)
end
