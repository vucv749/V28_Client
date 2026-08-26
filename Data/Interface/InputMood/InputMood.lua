local g_InputMood_Frame_UnifiedPosition
--===============================================
-- OnLoad
--===============================================
function InputMood_PreLoad()
	this:RegisterEvent("MOOD_SET")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function InputMood_OnLoad()
	g_InputMood_Frame_UnifiedPosition=InputMood_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent
--===============================================
function InputMood_OnEvent(event)
	if event == "MOOD_SET" then
		InputMood_Input:SetText("")
		this:Show()
		InputMood_Input:SetProperty("DefaultEditBox", "True")
		InputMood_Input:SetText(DataPool:GetMood())
		InputMood_Input:SetSelected(0, -1)
		
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		InputMood_Frame_On_ResetPos()
	end
end

--===============================================
-- 确定
--===============================================
function InputMood_EventOK()
	local strMood = InputMood_Input:GetText()
	if strMood == "" then 
		PushDebugMessage("#{KDHYYH_211025_50}")
		return
	end
	DataPool:SetMood(strMood)
	this:Hide()
end

--===============================================
-- 取消
--===============================================
function InputMood_EventCancel()
	this:Hide()
end

--===============================================
-- 关闭自动执行
--===============================================
function InputMood_OnHiden()
	InputMood_Input:SetProperty("DefaultEditBox", "False")
end

function InputMood_Frame_On_ResetPos()
  InputMood_Frame:SetProperty("UnifiedPosition", g_InputMood_Frame_UnifiedPosition)
end

--显示自己的心情
function InputMood_ViewMood_Clicked()
	Friend:ViewFeel()
end

--鼠标进入按钮
function InputMood_ViewMood_MouseEnter()
	--显示tooltips
	if Friend:IsMoodInHead() == 1 then
		InputMood_ViewMood:SetToolTip("#{KDHYYH_211025_46}")
	else
		InputMood_ViewMood:SetToolTip("#{KDHYYH_211025_47}")
	end
end