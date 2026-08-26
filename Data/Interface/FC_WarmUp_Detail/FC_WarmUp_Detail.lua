local g_Frame_UnifiedPosition
local g_index = -1

local g_MissionInfo = {
	[1] = {MissionId= 2390, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_64}",str3 = "#{JOMY_20250403_74}"},
	[2] = {MissionId= 2391, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_65}",str3 = "#{JOMY_20250403_75}"},
	[3] = {MissionId= 2392, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_66}",str3 = "#{JOMY_20250403_76}"},
	[4] = {MissionId= 2393, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_67}",str3 = "#{JOMY_20250403_77}"},
	[5] = {MissionId= 2394, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_68}",str3 = "#{JOMY_20250403_78}"},
	[6] = {MissionId= 2395, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_69}",str3 = "#{JOMY_20250403_79}"},
	[7] = {MissionId= 2396, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_70}",str3 = "#{JOMY_20250403_80}"},
	[8] = {MissionId= 2397, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_71}",str3 = "#{JOMY_20250403_81}"},
	[9] = {MissionId= 2398, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_72}",str3 = "#{JOMY_20250403_82}"},
}
function FC_WarmUp_Detail_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

function FC_WarmUp_Detail_OnLoad()

	g_Frame_UnifiedPosition = FC_WarmUp_Detail_Frame:GetProperty("UnifiedPosition")

end

function FC_WarmUp_Detail_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99973202 ) then

		FC_WarmUp_Detail_SetFrame(tonumber(arg1))
		this:Show()
	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		FC_WarmUp_Detail_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		FC_WarmUp_Detail_On_ResetPos()

	end

end


function FC_WarmUp_Detail_SetFrame(index)

	if index < 1 and index > 10 then
		return 0
	end

	g_index = index

	FC_WarmUp_Detail_Info:SetText( g_MissionInfo[index].str1)
	FC_WarmUp_Detail_JieDuan_Title1:SetText( g_MissionInfo[index].str2)
	FC_WarmUp_Detail_JieDuan_Text:SetText( g_MissionInfo[index].str3)

	this:Show()

end



function FC_WarmUp_Detail_On_ResetPos()

	FC_WarmUp_Detail_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function FC_WarmUp_Detail_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{JOMY_20250403_14}")
end

function  FC_WarmUp_Detail_Close()
	g_index = -1
	this:Hide()
end