--NewZhuXian_Task2
local g_Frame_UnifiedPosition

--=========
-- PreLoad()
--=========
function NewZhuXian_Task2_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)

end

--=========
-- OnLoad()
--=========
function NewZhuXian_Task2_OnLoad()

	g_Frame_UnifiedPosition = NewZhuXian_Task2_Frame:GetProperty("UnifiedPosition")
	
end

--=========
-- Event
--=========
function NewZhuXian_Task2_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 89018001 then

		local param = Get_XParam_INT(0)
		local itemIndex = Get_XParam_INT(1)
		if param == 1 then
			--打开界面
			NewZhuXian_Task2_ShowFrame(itemIndex)
		elseif param == 2 then
			--关闭界面
			NewZhuXian_Task2_OnHiden()
		end
		
	elseif event == "HIDE_ON_SCENE_TRANSED" then

		NewZhuXian_Task2_OnHiden()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		NewZhuXian_Task2_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		NewZhuXian_Task2_ResetPos()
	
	end

end

function NewZhuXian_Task2_ShowFrame(itemIndex)
	if itemIndex == 40005102 then
		NewZhuXian_Task2_BK:SetProperty("Image","set:NewZhuXian_Task2 image:NewZhuXian_Xin2")
	elseif itemIndex == 40005101 then
		NewZhuXian_Task2_BK:SetProperty("Image","set:NewZhuXian_Task3 image:NewZhuXian_Xin3")
	end
	this:Show()
end


--调整：界面位置
function NewZhuXian_Task2_ResetPos()

	NewZhuXian_Task2_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

--关闭：界面
function NewZhuXian_Task2_OnHiden()
	this:Hide()
end
