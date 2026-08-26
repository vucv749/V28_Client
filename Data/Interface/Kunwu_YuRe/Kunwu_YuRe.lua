local g_Frame_UnifiedPosition
local g_BeginDay = 20250306
local g_Part1Time = 20250308
local g_Part2Time = 20250311
local g_EndDay = 20250313


local g_MissionInfo = {

	[1] = {MissionId= 2372,str2 = "#{SJYY_20241216_281}",itemid = 20600002,num = 1},
	[2] = {MissionId= 2375,str2 = "#{SJYY_20241216_281}",itemid = 38002519,num = 1},
	[3] = {MissionId= 2378,str2 = "#{SJYY_20241216_281}",itemid = 20501003,num = 1},
	[4] = {MissionId= 2378,str2 = "#{SJYY_20241216_281}",itemid = 20502003,num = 1},
}

local g_MissionIdList = {2370,2371,2372,2373,2374,2375,2376,2377,2378}

local g_RenWuButtonList = {}
local g_RenWuOverList = {}
local g_RenWuBKList = {}
--=========
-- PreLoad()
--=========
function Kunwu_YuRe_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function Kunwu_YuRe_OnLoad()

	g_Frame_UnifiedPosition = Kunwu_YuRe_Frame:GetProperty("UnifiedPosition")

	Kunwu_YuRe_RenWu_ItemAnimate1:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate2:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate3:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate4:Hide()

	Kunwu_YuRe_RenWu_Down1:Hide()
	Kunwu_YuRe_RenWu_Down2:Hide()
	Kunwu_YuRe_RenWu_Down3:Hide()
	Kunwu_YuRe_RenWu_Down4:Hide()

	g_RenWuButtonList[1] = Kunwu_YuRe_RenWu_1
	g_RenWuButtonList[2] = Kunwu_YuRe_RenWu_2
	g_RenWuButtonList[3] = Kunwu_YuRe_RenWu_3
	g_RenWuButtonList[4] = Kunwu_YuRe_RenWu_4
	g_RenWuButtonList[5] = Kunwu_YuRe_RenWu_5
	g_RenWuButtonList[6] = Kunwu_YuRe_RenWu_6
	g_RenWuButtonList[7] = Kunwu_YuRe_RenWu_7
	g_RenWuButtonList[8] = Kunwu_YuRe_RenWu_8
	g_RenWuButtonList[9] = Kunwu_YuRe_RenWu_9

	g_RenWuOverList[1] = Kunwu_YuRe_RenWu_1_Over
	g_RenWuOverList[2] = Kunwu_YuRe_RenWu_2_Over
	g_RenWuOverList[3] = Kunwu_YuRe_RenWu_3_Over
	g_RenWuOverList[4] = Kunwu_YuRe_RenWu_4_Over
	g_RenWuOverList[5] = Kunwu_YuRe_RenWu_5_Over
	g_RenWuOverList[6] = Kunwu_YuRe_RenWu_6_Over
	g_RenWuOverList[7] = Kunwu_YuRe_RenWu_7_Over
	g_RenWuOverList[8] = Kunwu_YuRe_RenWu_8_Over
	g_RenWuOverList[9] = Kunwu_YuRe_RenWu_9_Over


	g_RenWuBKList[1] = Kunwu_YuRe_RenWu_Bk1
	g_RenWuBKList[2] = Kunwu_YuRe_RenWu_Bk2
	g_RenWuBKList[3] = Kunwu_YuRe_RenWu_Bk3
	g_RenWuBKList[4] = Kunwu_YuRe_RenWu_Bk4
	g_RenWuBKList[5] = Kunwu_YuRe_RenWu_Bk5
	g_RenWuBKList[6] = Kunwu_YuRe_RenWu_Bk6
	g_RenWuBKList[7] = Kunwu_YuRe_RenWu_Bk7
	g_RenWuBKList[8] = Kunwu_YuRe_RenWu_Bk8
	g_RenWuBKList[9] = Kunwu_YuRe_RenWu_Bk9


	for i = 1, 9 do
		g_RenWuOverList[i]:Hide()
		g_RenWuButtonList[i]:Hide()
		g_RenWuBKList[i]:Hide()
    end

	Kunwu_YuRe_HuoyueFrame2_TimeBk:Show()
	Kunwu_YuRe_HuoyueFrame2_GiftBk:Hide()

	Kunwu_YuRe_HuoyueFrame3_TimeBk:Show()
	Kunwu_YuRe_HuoyueFrame3_GiftBk:Hide()

end

--=========
-- Event
--=========
function Kunwu_YuRe_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99964601 ) then
		Kunwu_YuRe_SetFrame()

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99964603 ) then

		Kunwu_YuRe_SetFrame()

		local index = Get_XParam_INT(0)
		if index == 1 then
			Kunwu_YuRe_RenWu_Item1:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate1:Hide()
			Kunwu_YuRe_RenWu_Down1:Show()
		elseif index == 2 then
			Kunwu_YuRe_RenWu_Item2:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate2:Hide()
			Kunwu_YuRe_RenWu_Down2:Show()
		elseif index == 3 then
			Kunwu_YuRe_RenWu_Item3:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate3:Hide()
			Kunwu_YuRe_RenWu_Down3:Show()
		elseif index == 4 then
			Kunwu_YuRe_RenWu_Item4:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate4:Hide()
			Kunwu_YuRe_RenWu_Down4:Show()
		end


	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Kunwu_YuRe_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Kunwu_YuRe_On_ResetPos()

	end

end


function Kunwu_YuRe_SetFrame()

	Kunwu_YuRe_SetRedPoint()
	Lua_ShowQuickEnterPointTip(37, 0)

	local curDay = tonumber(DataPool:GetServerDayTime())

    for i = 1, 9 do
		if DataPool:Lua_IsMissionComplete(g_MissionIdList[i]) == 1 then
			g_RenWuButtonList[i]:Hide()
			g_RenWuOverList[i]:Show()
			g_RenWuBKList[i]:Show()
		else
			g_RenWuBKList[i]:Hide()
			g_RenWuOverList[i]:Hide()
			g_RenWuButtonList[i]:Hide()
		end
    end

	for i = 1, 9 do
		if curDay >= g_BeginDay and curDay <= g_Part1Time then
			if DataPool:Lua_IsMissionComplete(g_MissionIdList[i]) ~= 1 then
				if i > 3 then
					break
				end
				g_RenWuButtonList[i]:Show()
				break
			else
				g_RenWuBKList[i]:Show()
				g_RenWuOverList[i]:Show()
			end
		elseif curDay > g_BeginDay and curDay <= g_Part2Time then
			if DataPool:Lua_IsMissionComplete(g_MissionIdList[i]) ~= 1 then
				if i > 6 then
					break
				end
				g_RenWuButtonList[i]:Show()
				break
			else
				g_RenWuBKList[i]:Show()
				g_RenWuOverList[i]:Show()
			end
		elseif curDay > g_BeginDay and curDay <= g_EndDay then
			if DataPool:Lua_IsMissionComplete(g_MissionIdList[i]) ~= 1 then
				g_RenWuButtonList[i]:Show()
				break
			else
				g_RenWuBKList[i]:Show()
				g_RenWuOverList[i]:Show()
			end
		else
			break
		end

    end


	if curDay > g_BeginDay and curDay <= g_Part1Time then
		Kunwu_YuRe_HuoyueFrame2_TimeBk:Show()
		Kunwu_YuRe_HuoyueFrame3_TimeBk:Show()

		Kunwu_YuRe_HuoyueFrame2_GiftBk:Hide()
		Kunwu_YuRe_HuoyueFrame3_GiftBk:Hide()

	elseif curDay > g_BeginDay and curDay <= g_Part2Time then
		Kunwu_YuRe_HuoyueFrame2_TimeBk:Hide()
		Kunwu_YuRe_HuoyueFrame3_TimeBk:Show()

		Kunwu_YuRe_HuoyueFrame2_GiftBk:Show()
		Kunwu_YuRe_HuoyueFrame3_GiftBk:Hide()

	elseif curDay > g_BeginDay and curDay <= g_EndDay then
		Kunwu_YuRe_HuoyueFrame2_TimeBk:Hide()
		Kunwu_YuRe_HuoyueFrame3_TimeBk:Hide()

		Kunwu_YuRe_HuoyueFrame2_GiftBk:Show()
		Kunwu_YuRe_HuoyueFrame3_GiftBk:Show()
	end


	local theAction1 = DataPool:CreateBindActionItemForShow(g_MissionInfo[1].itemid,g_MissionInfo[1].num)
	if theAction1:GetID() ~= 0 then
		Kunwu_YuRe_RenWu_Item1:SetActionItem(theAction1:GetID())
	end

	local theAction2 = DataPool:CreateBindActionItemForShow(g_MissionInfo[2].itemid,g_MissionInfo[2].num)
	if theAction2:GetID() ~= 0 then
		Kunwu_YuRe_RenWu_Item2:SetActionItem(theAction2:GetID())
	end

	local theAction3 = DataPool:CreateBindActionItemForShow(g_MissionInfo[3].itemid,g_MissionInfo[3].num)
	if theAction3:GetID() ~= 0 then
		Kunwu_YuRe_RenWu_Item3:SetActionItem(theAction3:GetID())
	end

	local theAction4 = DataPool:CreateBindActionItemForShow(g_MissionInfo[4].itemid,g_MissionInfo[4].num)
	if theAction4:GetID() ~= 0 then
		Kunwu_YuRe_RenWu_Item4:SetActionItem(theAction4:GetID())
	end


	if DataPool:Lua_IsMissionComplete(g_MissionInfo[1].MissionId) == 1 then

		if Kunwu_YuRe_GetMD(1) < 1 then
			Kunwu_YuRe_RenWu_Item1:Enable()
			Kunwu_YuRe_RenWu_ItemAnimate1:Show()
			Kunwu_YuRe_RenWu_Down1:Hide()
			Lua_ShowQuickEnterPointTip(37, 1)

		else
			Kunwu_YuRe_RenWu_Item1:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate1:Hide()
			Kunwu_YuRe_RenWu_Down1:Show()
		end

	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[2].MissionId) == 1 then

		if Kunwu_YuRe_GetMD(2) < 1 then
			Kunwu_YuRe_RenWu_Item2:Enable()
			Kunwu_YuRe_RenWu_ItemAnimate2:Show()
			Kunwu_YuRe_RenWu_Down2:Hide()
			Lua_ShowQuickEnterPointTip(37, 1)
		else
			Kunwu_YuRe_RenWu_Item2:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate2:Hide()
			Kunwu_YuRe_RenWu_Down2:Show()
		end
	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[3].MissionId) == 1 then

		if Kunwu_YuRe_GetMD(3) < 1 then
			Kunwu_YuRe_RenWu_Item3:Enable()
			Kunwu_YuRe_RenWu_ItemAnimate3:Show()
			Kunwu_YuRe_RenWu_Down3:Hide()
			Lua_ShowQuickEnterPointTip(37, 1)
		else
			Kunwu_YuRe_RenWu_Item3:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate3:Hide()
			Kunwu_YuRe_RenWu_Down3:Show()
		end

		if Kunwu_YuRe_GetMD(4) < 1 then
			Kunwu_YuRe_RenWu_Item4:Enable()
			Kunwu_YuRe_RenWu_ItemAnimate4:Show()
			Kunwu_YuRe_RenWu_Down4:Hide()
			Lua_ShowQuickEnterPointTip(37, 1)
		else
			Kunwu_YuRe_RenWu_Item4:Disable()
			Kunwu_YuRe_RenWu_ItemAnimate4:Hide()
			Kunwu_YuRe_RenWu_Down4:Show()
		end
	end



	this:Show()

end


function Kunwu_YuRe_RenWuClicked(index)

	PushEvent("UI_COMMAND", 99964602, index)

end

function Kunwu_YuRe_On_ResetPos()

	Kunwu_YuRe_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end


function Kunwu_YuRe_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{SJYY_20241216_14}")
end


function  Kunwu_YuRe_Close()

	Kunwu_YuRe_RenWu_ItemAnimate1:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate2:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate3:Hide()
	Kunwu_YuRe_RenWu_ItemAnimate4:Hide()

	Kunwu_YuRe_RenWu_Item1:Disable()
	Kunwu_YuRe_RenWu_Item2:Disable()
	Kunwu_YuRe_RenWu_Item3:Disable()
	Kunwu_YuRe_RenWu_Item4:Disable()

	Kunwu_YuRe_RenWu_Down1:Hide()
	Kunwu_YuRe_RenWu_Down2:Hide()
	Kunwu_YuRe_RenWu_Down3:Hide()
	Kunwu_YuRe_RenWu_Down4:Hide()


	for i = 1, 9 do
		g_RenWuOverList[i]:Hide()
		g_RenWuButtonList[i]:Hide()
    end

	this:Hide()


	Kunwu_YuRe_HuoyueFrame2_TimeBk:Show()
	Kunwu_YuRe_HuoyueFrame2_GiftBk:Hide()

	Kunwu_YuRe_HuoyueFrame3_TimeBk:Show()
	Kunwu_YuRe_HuoyueFrame3_GiftBk:Hide()

end




function Kunwu_YuRe_GetMD(index)
	local TotalNum = DataPool:LuaFnGetMD( 1210 )
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



function Kunwu_YuRe_AwardClicked(index)

	if index == 1 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[1].MissionId) < 1 then
			PushDebugMessage(g_MissionInfo[1].str2)
			return 0
		end
	elseif index == 2 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[2].MissionId) < 1 then
			PushDebugMessage(g_MissionInfo[2].str2)
			return 0
		end
	elseif index == 3 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[3].MissionId) < 1 then
			PushDebugMessage(g_MissionInfo[3].str2)
			return 0
		end
	elseif index == 4 then
		if DataPool:Lua_IsMissionHaveDone(g_MissionInfo[4].MissionId) < 1 then
			PushDebugMessage(g_MissionInfo[4].str2)
			return 0
		end
	else
		return 0
	end

	if 	index >= 1 and index <= 4 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(999646)
			Set_XSCRIPT_Parameter(0,index)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end


end

function Kunwu_YuRe_SetRedPoint()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SetRedPoint")
		Set_XSCRIPT_ScriptID(999646)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()


end