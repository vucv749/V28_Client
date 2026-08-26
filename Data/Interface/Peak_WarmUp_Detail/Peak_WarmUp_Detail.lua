local g_Frame_UnifiedPosition
local g_index = -1

local g_MissionInfo = {
	[1] = {MissionId= 2416, str1 = "#{DFYR_250725_99}",str2 = "#{DFYR_250725_145}",str3 = "#{DFYR_250725_134}"},
	[2] = {MissionId= 2417, str1 = "#{DFYR_250725_99}",str2 = "#{DFYR_250725_146}",str3 = "#{DFYR_250725_135}"},
	[3] = {MissionId= 2418, str1 = "#{DFYR_250725_99}",str2 = "#{DFYR_250725_147}",str3 = "#{DFYR_250725_136}"},
	[4] = {MissionId= 2419, str1 = "#{DFYR_250725_100}",str2 = "#{DFYR_250725_148}",str3 = "#{DFYR_250725_137}"},
	[5] = {MissionId= 2420, str1 = "#{DFYR_250725_101}",str2 = "#{DFYR_250725_149}",str3 = "#{DFYR_250725_138}"},
	[6] = {MissionId= 2421, str1 = "#{DFYR_250725_101}",str2 = "#{DFYR_250725_150}",str3 = "#{DFYR_250725_139}"},
}
function Peak_WarmUp_Detail_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

function Peak_WarmUp_Detail_OnLoad()

	g_Frame_UnifiedPosition = Peak_WarmUp_Detail_Frame:GetProperty("UnifiedPosition")

end

function Peak_WarmUp_Detail_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99990903 ) then

		Peak_WarmUp_Detail_SetFrame(tonumber(arg1))

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Peak_WarmUp_Detail_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Peak_WarmUp_Detail_On_ResetPos()

	end

end


function Peak_WarmUp_Detail_SetFrame(index)

	if index < 1 and index > 6 then
		return 0
	end

	g_index = index

	Peak_WarmUp_Detail_Info:SetText( g_MissionInfo[index].str1)
	Peak_WarmUp_Detail_JieDuan_Title1:SetText( g_MissionInfo[index].str2)
	Peak_WarmUp_Detail_JieDuan_Text:SetText( g_MissionInfo[index].str3)

	this:Show()

end



function Peak_WarmUp_Detail_On_ResetPos()

	Peak_WarmUp_Detail_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function Peak_WarmUp_Detail_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{DFYR_250725_16}")
end

function  Peak_WarmUp_Detail_Close()
	g_index = -1
	this:Hide()
end