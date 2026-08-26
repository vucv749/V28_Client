-- 2023Q1preheat seek


local g_UnifiedPosition = nil
--图标
local g_Images = 
{
	[1] = { part = "set:ShenFen_Yure2 image:ShenFen_Yure_Seek_GSL",},
	[2] = { part = "set:ShenFen_Yure2 image:ShenFen_Yure_Seek_CR",},
}
local g_Text = 
{
	[1] = "1/2",
	[2] = "2/2",
}
local g_idx = 1
--===============================================
-- PreLoad()
--===============================================
function ShenFen_Yure_Seek_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ShenFen_Yure_Seek_OnLoad()
	g_UnifiedPosition = ShenFen_Yure_Seek_Frame:GetProperty("UnifiedPosition")	

end

--===============================================
-- OnEvent()
--===============================================
function ShenFen_Yure_Seek_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99870201) then
		this:Show()
		ShenFen_Yure_Seek_OnShow(g_idx)
	elseif (event == "ADJEST_UI_POS") then
		ShenFen_Yure_Seek_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShenFen_Yure_Seek_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShenFen_Yure_Seek_Close_Click()
	end
end

--===============================================
-- 重置
--===============================================
function ShenFen_Yure_Seek_ResetPos()
	ShenFen_Yure_Seek_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

function ShenFen_Yure_Seek_OnShow(idx)
	
	ShenFen_Yure_Seek_Image:SetProperty("Image", g_Images[idx].part)

	ShenFen_Yure_Seek_CurrentlyPage:SetText(g_Text[idx])

	if idx == 1 then
		ShenFen_Yure_Seek_UpPage:Disable()
		ShenFen_Yure_Seek_DownPage:Enable()
	elseif idx == 2 then
		ShenFen_Yure_Seek_UpPage:Enable()
		ShenFen_Yure_Seek_DownPage:Disable()
	end
end
--===============================================
-- 清数据
--===============================================
function ShenFen_Yure_Seek_Clear()
	g_idx = 1
	ShenFen_Yure_Seek_CurrentlyPage:SetText("")
	ShenFen_Yure_Seek_Close_Click()
end

--===============================================
-- 关界面
--===============================================
function ShenFen_Yure_Seek_Close_Click()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 小问号
--===============================================
function ShenFen_Yure_Seek_Help()
	PushEvent("CCSHOP_HELP", 14)
end

function ShenFen_Yure_Seek_PageUp()
	if g_idx == 2 then
		g_idx = 1
		ShenFen_Yure_Seek_OnShow(1)
	end

end

function ShenFen_Yure_Seek_PageDown()
	if g_idx == 1 then
		g_idx = 2
		ShenFen_Yure_Seek_OnShow(2)
	end
end

