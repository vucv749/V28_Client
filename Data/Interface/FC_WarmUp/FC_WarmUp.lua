local g_Frame_UnifiedPosition
local g_BeginDay = 20250612
local g_Part2Time = 20250615
local g_Part3Time = 20250618
local g_EndDay = 20250619


local g_MissionInfo = {
	[1] = {MissionId= 2392,str2 = "#{JOMY_20250403_45}",itemid = 50313004,num = 1},
	[2] = {MissionId= 2395,str2 = "#{JOMY_20250403_48}",itemid = 20600002,num = 1},
	[3] = {MissionId= 2398,str2 = "#{JOMY_20250403_51}",itemid = 38002519,num = 1},
}

local g_MissionInfoDetail = {
	[1] = {MissionId= 2390, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_43}",str3 = "#{JOMY_20250403_74}"},
	[2] = {MissionId= 2391, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_44}",str3 = "#{JOMY_20250403_75}"},
	[3] = {MissionId= 2392, str1 = "#{JOMY_20250403_267}",str2 = "#{JOMY_20250403_45}",str3 = "#{JOMY_20250403_76}"},
	[4] = {MissionId= 2393, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_46}",str3 = "#{JOMY_20250403_77}"},
	[5] = {MissionId= 2394, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_47}",str3 = "#{JOMY_20250403_78}"},
	[6] = {MissionId= 2395, str1 = "#{JOMY_20250403_268}",str2 = "#{JOMY_20250403_48}",str3 = "#{JOMY_20250403_79}"},
	[7] = {MissionId= 2396, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_49}",str3 = "#{JOMY_20250403_80}"},
	[8] = {MissionId= 2397, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_50}",str3 = "#{JOMY_20250403_81}"},
	[9] = {MissionId= 2398, str1 = "#{JOMY_20250403_269}",str2 = "#{JOMY_20250403_51}",str3 = "#{JOMY_20250403_82}"},
}

local g_MissionIdList = {2390,2391,2392,2393,2394,2395,2396,2397,2398}

local g_RenWuUnFinish = {}
local g_RenWuOverList = {}
local g_RenWuFinished = {}
--=========
-- PreLoad()
--=========
function FC_WarmUp_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function FC_WarmUp_OnLoad()

	g_Frame_UnifiedPosition = FC_WarmUp_Frame:GetProperty("UnifiedPosition")

	FC_WarmUp_RenWu_ItemAnimate1:Hide()
	FC_WarmUp_RenWu_ItemAnimate2:Hide()
	FC_WarmUp_RenWu_ItemAnimate3:Hide()

	FC_WarmUp_RenWu_Down1:Hide()
	FC_WarmUp_RenWu_Down2:Hide()
	FC_WarmUp_RenWu_Down3:Hide()

	g_RenWuUnFinish[1] = FC_WarmUp_RenWu_1
	g_RenWuUnFinish[2] = FC_WarmUp_RenWu_2
	g_RenWuUnFinish[3] = FC_WarmUp_RenWu_3
	g_RenWuUnFinish[4] = FC_WarmUp_RenWu_4
	g_RenWuUnFinish[5] = FC_WarmUp_RenWu_5
	g_RenWuUnFinish[6] = FC_WarmUp_RenWu_6
	g_RenWuUnFinish[7] = FC_WarmUp_RenWu_7
	g_RenWuUnFinish[8] = FC_WarmUp_RenWu_8
	g_RenWuUnFinish[9] = FC_WarmUp_RenWu_9

	g_RenWuOverList[1] = FC_WarmUp_RenWu_1_Over
	g_RenWuOverList[2] = FC_WarmUp_RenWu_2_Over
	g_RenWuOverList[3] = FC_WarmUp_RenWu_3_Over
	g_RenWuOverList[4] = FC_WarmUp_RenWu_4_Over
	g_RenWuOverList[5] = FC_WarmUp_RenWu_5_Over
	g_RenWuOverList[6] = FC_WarmUp_RenWu_6_Over
	g_RenWuOverList[7] = FC_WarmUp_RenWu_7_Over
	g_RenWuOverList[8] = FC_WarmUp_RenWu_8_Over
	g_RenWuOverList[9] = FC_WarmUp_RenWu_9_Over


	g_RenWuFinished[1] = FC_WarmUp_RenWu_Bk1
	g_RenWuFinished[2] = FC_WarmUp_RenWu_Bk2
	g_RenWuFinished[3] = FC_WarmUp_RenWu_Bk3
	g_RenWuFinished[4] = FC_WarmUp_RenWu_Bk4
	g_RenWuFinished[5] = FC_WarmUp_RenWu_Bk5
	g_RenWuFinished[6] = FC_WarmUp_RenWu_Bk6
	g_RenWuFinished[7] = FC_WarmUp_RenWu_Bk7
	g_RenWuFinished[8] = FC_WarmUp_RenWu_Bk8
	g_RenWuFinished[9] = FC_WarmUp_RenWu_Bk9


	for i = 1, 9 do
		g_RenWuOverList[i]:Hide()
		g_RenWuUnFinish[i]:Hide()
		g_RenWuFinished[i]:Hide()
    end

	FC_WarmUp_HuoyueFrame2_TimeBk:Show()
	FC_WarmUp_HuoyueFrame2_GiftBk:Hide()

	FC_WarmUp_HuoyueFrame3_TimeBk:Show()
	FC_WarmUp_HuoyueFrame3_GiftBk:Hide()

end

--=========
-- Event
--=========
function FC_WarmUp_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99973201 ) then
		FC_WarmUp_SetFrame()

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99973203 ) then

		FC_WarmUp_SetFrame()

		local index = Get_XParam_INT(0)
		if index == 1 then
			FC_WarmUp_RenWu_Item1:Disable()
			FC_WarmUp_RenWu_ItemAnimate1:Hide()
			FC_WarmUp_RenWu_Down1:Show()
		elseif index == 2 then
			FC_WarmUp_RenWu_Item2:Disable()
			FC_WarmUp_RenWu_ItemAnimate2:Hide()
			FC_WarmUp_RenWu_Down2:Show()
		elseif index == 3 then
			FC_WarmUp_RenWu_Item3:Disable()
			FC_WarmUp_RenWu_ItemAnimate3:Hide()
			FC_WarmUp_RenWu_Down3:Show()
		end


	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		FC_WarmUp_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		FC_WarmUp_On_ResetPos()

	end

end


function FC_WarmUp_SetFrame()

	FC_WarmUp_SetRedPoint()
	Lua_ShowQuickEnterPointTip(39, 0)

	local curDay = tonumber(DataPool:GetServerDayTime())

	if curDay >= g_BeginDay and curDay < g_Part2Time then
		FC_WarmUp_HuoyueFrame2_TimeBk:Show()
		FC_WarmUp_HuoyueFrame3_TimeBk:Show()

		FC_WarmUp_HuoyueFrame2_GiftBk:Hide()
		FC_WarmUp_HuoyueFrame3_GiftBk:Hide()

		for i = 1, 3 do
			g_RenWuUnFinish[i]:Show()
		end

	elseif curDay >= g_Part2Time and curDay < g_Part3Time then
		FC_WarmUp_HuoyueFrame2_TimeBk:Hide()
		FC_WarmUp_HuoyueFrame3_TimeBk:Show()

		FC_WarmUp_HuoyueFrame2_GiftBk:Show()
		FC_WarmUp_HuoyueFrame3_GiftBk:Hide()

		for i = 1, 6 do
			g_RenWuUnFinish[i]:Show()
		end
	elseif curDay >= g_Part3Time and curDay <= g_EndDay then
		FC_WarmUp_HuoyueFrame2_TimeBk:Hide()
		FC_WarmUp_HuoyueFrame3_TimeBk:Hide()

		FC_WarmUp_HuoyueFrame2_GiftBk:Show()
		FC_WarmUp_HuoyueFrame3_GiftBk:Show()

		for i = 1, 9 do
			g_RenWuUnFinish[i]:Show()
		end
	end

	for i = 1, 9 do
		if DataPool:Lua_IsMissionComplete(g_MissionIdList[i]) == 1 then
			g_RenWuUnFinish[i]:Hide()
			g_RenWuOverList[i]:Show()
			g_RenWuFinished[i]:Show()
		end
    end


	local theAction1 = DataPool:CreateBindActionItemForShow(g_MissionInfo[1].itemid,g_MissionInfo[1].num)
	if theAction1:GetID() ~= 0 then
		FC_WarmUp_RenWu_Item1:SetActionItem(theAction1:GetID())
	end

	local theAction2 = DataPool:CreateBindActionItemForShow(g_MissionInfo[2].itemid,g_MissionInfo[2].num)
	if theAction2:GetID() ~= 0 then
		FC_WarmUp_RenWu_Item2:SetActionItem(theAction2:GetID())
	end

	local theAction3 = DataPool:CreateBindActionItemForShow(g_MissionInfo[3].itemid,g_MissionInfo[3].num)
	if theAction3:GetID() ~= 0 then
		FC_WarmUp_RenWu_Item3:SetActionItem(theAction3:GetID())
	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[1].MissionId) == 1 then

		if FC_WarmUp_GetMD(1) < 1 then
			FC_WarmUp_RenWu_Item1:Enable()
			FC_WarmUp_RenWu_ItemAnimate1:Show()
			FC_WarmUp_RenWu_Down1:Hide()
			Lua_ShowQuickEnterPointTip(39, 1)

		else
			FC_WarmUp_RenWu_Item1:Disable()
			FC_WarmUp_RenWu_ItemAnimate1:Hide()
			FC_WarmUp_RenWu_Down1:Show()
		end

	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[2].MissionId) == 1 then

		if FC_WarmUp_GetMD(2) < 1 then
			FC_WarmUp_RenWu_Item2:Enable()
			FC_WarmUp_RenWu_ItemAnimate2:Show()
			FC_WarmUp_RenWu_Down2:Hide()
			Lua_ShowQuickEnterPointTip(39, 1)
		else
			FC_WarmUp_RenWu_Item2:Disable()
			FC_WarmUp_RenWu_ItemAnimate2:Hide()
			FC_WarmUp_RenWu_Down2:Show()
		end
	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[3].MissionId) == 1 then

		if FC_WarmUp_GetMD(3) < 1 then
			FC_WarmUp_RenWu_Item3:Enable()
			FC_WarmUp_RenWu_ItemAnimate3:Show()
			FC_WarmUp_RenWu_Down3:Hide()
			Lua_ShowQuickEnterPointTip(39, 1)
		else
			FC_WarmUp_RenWu_Item3:Disable()
			FC_WarmUp_RenWu_ItemAnimate3:Hide()
			FC_WarmUp_RenWu_Down3:Show()
		end

	end

	this:Show()

end


function FC_WarmUp_RenWuClicked(index)
	if index < 1 or index > 9 then
		return
	end

	local curDay = tonumber(DataPool:GetServerDayTime())
	if curDay < g_BeginDay or curDay > g_EndDay then
		PushDebugMessage("#{JOMY_20250403_54}")
		return 
	end

	local my_level = Player:GetData("LEVEL")
	if my_level < 30 then
		PushDebugMessage("#{JOMY_20250403_55}")
		return
	end

	if index > 1 then
		if DataPool:Lua_IsMissionComplete(g_MissionIdList[index-1]) ~= 1 then
			PushDebugMessage(ScriptGlobal_Format("#{JOMY_20250403_56}", g_MissionInfoDetail[index-1].str2))
			return
		end
	end

	PushEvent("UI_COMMAND", 99973202, index)
end

function FC_WarmUp_On_ResetPos()

	FC_WarmUp_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end


function FC_WarmUp_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{JOMY_20250403_14}")
end


function  FC_WarmUp_Close()

	FC_WarmUp_RenWu_ItemAnimate1:Hide()
	FC_WarmUp_RenWu_ItemAnimate2:Hide()
	FC_WarmUp_RenWu_ItemAnimate3:Hide()

	FC_WarmUp_RenWu_Item1:Disable()
	FC_WarmUp_RenWu_Item2:Disable()
	FC_WarmUp_RenWu_Item3:Disable()


	FC_WarmUp_RenWu_Down1:Hide()
	FC_WarmUp_RenWu_Down2:Hide()
	FC_WarmUp_RenWu_Down3:Hide()
	


	for i = 1, 9 do
		g_RenWuOverList[i]:Hide()
		g_RenWuUnFinish[i]:Hide()
		g_RenWuFinished[i]:Hide()
    end

	this:Hide()


	--FC_WarmUp_HuoyueFrame2_TimeBk:Show()
	--FC_WarmUp_HuoyueFrame2_GiftBk:Hide()

	--FC_WarmUp_HuoyueFrame3_TimeBk:Show()
	--FC_WarmUp_HuoyueFrame3_GiftBk:Hide()

end




function FC_WarmUp_GetMD(index)
	local TotalNum = DataPool:LuaFnGetMD( 1245 )
	local List= {0,0,0,0,0,0,0,0,0,0}
	local temp = 0

	temp = math.floor(TotalNum/1000000000)
	List[1] = math.mod(temp,10)

	temp = math.floor(TotalNum/100000000)
	List[2] = math.mod(temp,10)

	temp = math.floor(TotalNum/10000000)
	List[3] = math.mod(temp,10)

	temp = math.floor(TotalNum/1000000)
	List[4] = math.mod(temp,10)

	temp = math.floor(TotalNum/100000)
	List[5] = math.mod(temp,10)

	temp = math.floor(TotalNum/10000)
	List[6] = math.mod(temp,10)

	temp = math.floor(TotalNum/1000)
	List[7] = math.mod(temp,10)

	temp = math.floor(TotalNum/100)
	List[8] = math.mod(temp,10)

	temp = math.floor(TotalNum/10)
	List[9] = math.mod(temp,10)

	List[10] = math.mod(TotalNum,10)

	return List[index]
end



function FC_WarmUp_AwardClicked(index)

	if index == 1 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[1].MissionId) < 1 then
			PushDebugMessage(ScriptGlobal_Format("#{JOMY_20250403_61}", g_MissionInfo[1].str2))
			return 0
		end
	elseif index == 2 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[2].MissionId) < 1 then
			PushDebugMessage(ScriptGlobal_Format("#{JOMY_20250403_61}", g_MissionInfo[2].str2))
			return 0
		end
	elseif index == 3 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[3].MissionId) < 1 then
			PushDebugMessage(ScriptGlobal_Format("#{JOMY_20250403_61}", g_MissionInfo[3].str2))
			return 0
		end
	else
		return 0
	end

	if 	index >= 1 and index <= 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(999732)
			Set_XSCRIPT_Parameter(0,index)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end


end

function FC_WarmUp_SetRedPoint()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SetRedPoint")
		Set_XSCRIPT_ScriptID(999732)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()


end