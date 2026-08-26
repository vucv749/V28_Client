local g_Frame_UnifiedPosition
local g_index = -1

local g_MissionInfo = {
	[1] = {MissionId= 2370, str1 = "#{SJYY_20241216_267}",str2 = "#{SJYY_20241216_64}",str3 = "#{SJYY_20241216_74}"},
	[2] = {MissionId= 2371, str1 = "#{SJYY_20241216_267}",str2 = "#{SJYY_20241216_65}",str3 = "#{SJYY_20241216_75}"},
	[3] = {MissionId= 2372, str1 = "#{SJYY_20241216_267}",str2 = "#{SJYY_20241216_66}",str3 = "#{SJYY_20241216_76}"},
	[4] = {MissionId= 2373, str1 = "#{SJYY_20241216_268}",str2 = "#{SJYY_20241216_67}",str3 = "#{SJYY_20241216_77}"},
	[5] = {MissionId= 2374, str1 = "#{SJYY_20241216_268}",str2 = "#{SJYY_20241216_68}",str3 = "#{SJYY_20241216_78}"},
	[6] = {MissionId= 2375, str1 = "#{SJYY_20241216_268}",str2 = "#{SJYY_20241216_69}",str3 = "#{SJYY_20241216_79}"},
	[7] = {MissionId= 2376, str1 = "#{SJYY_20241216_269}",str2 = "#{SJYY_20241216_70}",str3 = "#{SJYY_20241216_80}"},
	[8] = {MissionId= 2377, str1 = "#{SJYY_20241216_269}",str2 = "#{SJYY_20241216_71}",str3 = "#{SJYY_20241216_81}"},
	[9] = {MissionId= 2378, str1 = "#{SJYY_20241216_269}",str2 = "#{SJYY_20241216_72}",str3 = "#{SJYY_20241216_82}"},
}
function Kunwu_YuRe_SecondAry_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

function Kunwu_YuRe_SecondAry_OnLoad()

	g_Frame_UnifiedPosition = Kunwu_YuRe_SecondAry_Frame:GetProperty("UnifiedPosition")

end

function Kunwu_YuRe_SecondAry_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99964602 ) then

		Kunwu_YuRe_SecondAry_SetFrame(tonumber(arg1))

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99964603 ) then

		Kunwu_YuRe_SecondAry_JieDuan_Item:Disable()

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Kunwu_YuRe_SecondAry_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Kunwu_YuRe_SecondAry_On_ResetPos()

	end

end


function Kunwu_YuRe_SecondAry_SetFrame(index)

	if index < 1 and index > 10 then
		return 0
	end

	g_index = index

	Kunwu_YuRe_SecondAry_Info:SetText( g_MissionInfo[index].str1)
	Kunwu_YuRe_SecondAry_JieDuan_Title1:SetText( g_MissionInfo[index].str2)
	Kunwu_YuRe_SecondAry_JieDuan_Text:SetText( g_MissionInfo[index].str3)

	this:Show()

end



function Kunwu_YuRe_SecondAry_On_ResetPos()

	Kunwu_YuRe_SecondAry_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end

function Kunwu_YuRe_SecondAry_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{SJYY_20241216_14}")
end

function  Kunwu_YuRe_SecondAry_Close()
	g_index = -1
	this:Hide()
end