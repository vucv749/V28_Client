local g_Frame_UnifiedPosition
local g_BeginDay = 20251009
local g_Part1Time = 20251010
local g_Part2Time = 20251013
local g_EndDay = 20251016


local g_MissionInfo = {

	[1] = {MissionId= 2418,str2 = "您尚未完成任务",itemid = 38003647,num = 1},
	[2] = {MissionId= 2419,str2 = "您尚未完成任务",itemid = 20600002,num = 1},
	[3] = {MissionId= 2421,str2 = "您尚未完成任务",itemid = 38002519,num = 1},
}

local g_MissionIdList = {2416,2417,2418,2419,2420,2421}

local g_RenWuButtonList = {}
local g_RenWuOverList = {}
local g_RenWuBKList = {}
--=========
-- PreLoad()
--=========
function Peak_WarmUp_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function Peak_WarmUp_OnLoad()

	g_Frame_UnifiedPosition = Peak_WarmUp_Frame:GetProperty("UnifiedPosition")

	Peak_WarmUp_RenWu_ItemAnimate1:Hide()
	Peak_WarmUp_RenWu_ItemAnimate2:Hide()
	Peak_WarmUp_RenWu_ItemAnimate3:Hide()

	Peak_WarmUp_RenWu_Down1:Hide()
	Peak_WarmUp_RenWu_Down2:Hide()
	Peak_WarmUp_RenWu_Down3:Hide()

	g_RenWuButtonList[1] = Peak_WarmUp_RenWu_1
	g_RenWuButtonList[2] = Peak_WarmUp_RenWu_2
	g_RenWuButtonList[3] = Peak_WarmUp_RenWu_3
	g_RenWuButtonList[4] = Peak_WarmUp_RenWu_4
	g_RenWuButtonList[5] = Peak_WarmUp_RenWu_5
	g_RenWuButtonList[6] = Peak_WarmUp_RenWu_6

	g_RenWuOverList[1] = Peak_WarmUp_RenWu_1_Over
	g_RenWuOverList[2] = Peak_WarmUp_RenWu_2_Over
	g_RenWuOverList[3] = Peak_WarmUp_RenWu_3_Over
	g_RenWuOverList[4] = Peak_WarmUp_RenWu_4_Over
	g_RenWuOverList[5] = Peak_WarmUp_RenWu_5_Over
	g_RenWuOverList[6] = Peak_WarmUp_RenWu_6_Over


	g_RenWuBKList[1] = Peak_WarmUp_RenWu_Bk1
	g_RenWuBKList[2] = Peak_WarmUp_RenWu_Bk2
	g_RenWuBKList[3] = Peak_WarmUp_RenWu_Bk3
	g_RenWuBKList[4] = Peak_WarmUp_RenWu_Bk4
	g_RenWuBKList[5] = Peak_WarmUp_RenWu_Bk5
	g_RenWuBKList[6] = Peak_WarmUp_RenWu_Bk6


	for i = 1, 6 do
		g_RenWuOverList[i]:Hide()
		g_RenWuButtonList[i]:Hide()
		g_RenWuBKList[i]:Hide()
    end

	Peak_WarmUp_HuoyueFrame2_TimeBk:Show()
	Peak_WarmUp_HuoyueFrame2_GiftBk:Hide()

	Peak_WarmUp_HuoyueFrame3_TimeBk:Show()
	Peak_WarmUp_HuoyueFrame3_GiftBk:Hide()

end

--=========
-- Event
--=========
function Peak_WarmUp_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99990902 ) then

		local num = Get_XParam_INT(0)
		if num == nil then
			this:Hide()
			return
		end
		Peak_WarmUp_SetFrame(num)

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99990904 ) then

		local index = Get_XParam_INT(0)
		local num = Get_XParam_INT(1)
		if num == nil or index == nil then
			this:Hide()
			return
		end

		Peak_WarmUp_SetFrame(num)

		if index == 1 then
			Peak_WarmUp_RenWu_Item1:Disable()
			Peak_WarmUp_RenWu_ItemAnimate1:Hide()
			Peak_WarmUp_RenWu_Down1:Show()
		elseif index == 2 then
			Peak_WarmUp_RenWu_Item2:Disable()
			Peak_WarmUp_RenWu_ItemAnimate2:Hide()
			Peak_WarmUp_RenWu_Down2:Show()
		elseif index == 3 then
			Peak_WarmUp_RenWu_Item3:Disable()
			Peak_WarmUp_RenWu_ItemAnimate3:Hide()
			Peak_WarmUp_RenWu_Down3:Show()
		end


	elseif event == "HIDE_ON_SCENE_TRANSED" then

		this:Hide()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		Peak_WarmUp_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		Peak_WarmUp_On_ResetPos()

	end

end


function Peak_WarmUp_SetFrame(num)

	Peak_WarmUp_SetRedPoint()
	Lua_ShowQuickEnterPointTip(48, 0)

	local curDay = tonumber(DataPool:GetServerDayTime())

    for i = 1, 6 do
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

	for i = 1, 6 do
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
				if i > 4 then
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
		Peak_WarmUp_HuoyueFrame2_TimeBk:Show()
		Peak_WarmUp_HuoyueFrame3_TimeBk:Show()

		Peak_WarmUp_HuoyueFrame2_GiftBk:Hide()
		Peak_WarmUp_HuoyueFrame3_GiftBk:Hide()

	elseif curDay > g_BeginDay and curDay <= g_Part2Time then
		Peak_WarmUp_HuoyueFrame2_TimeBk:Hide()
		Peak_WarmUp_HuoyueFrame3_TimeBk:Show()

		Peak_WarmUp_HuoyueFrame2_GiftBk:Show()
		Peak_WarmUp_HuoyueFrame3_GiftBk:Hide()

	elseif curDay > g_BeginDay and curDay <= g_EndDay then
		Peak_WarmUp_HuoyueFrame2_TimeBk:Hide()
		Peak_WarmUp_HuoyueFrame3_TimeBk:Hide()

		Peak_WarmUp_HuoyueFrame2_GiftBk:Show()
		Peak_WarmUp_HuoyueFrame3_GiftBk:Show()
	end


	local theAction1 = DataPool:CreateBindActionItemForShow(g_MissionInfo[1].itemid,g_MissionInfo[1].num)
	if theAction1:GetID() ~= 0 then
		Peak_WarmUp_RenWu_Item1:SetActionItem(theAction1:GetID())
	end

	local theAction2 = DataPool:CreateBindActionItemForShow(g_MissionInfo[2].itemid,g_MissionInfo[2].num)
	if theAction2:GetID() ~= 0 then
		Peak_WarmUp_RenWu_Item2:SetActionItem(theAction2:GetID())
	end

	local theAction3 = DataPool:CreateBindActionItemForShow(g_MissionInfo[3].itemid,g_MissionInfo[3].num)
	if theAction3:GetID() ~= 0 then
		Peak_WarmUp_RenWu_Item3:SetActionItem(theAction3:GetID())
	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[1].MissionId) == 1 then

		if Peak_WarmUp_GetMD(num,1) < 1 then
			Peak_WarmUp_RenWu_Item1:Enable()
			Peak_WarmUp_RenWu_ItemAnimate1:Show()
			Peak_WarmUp_RenWu_Down1:Hide()
			Lua_ShowQuickEnterPointTip(48, 1)

		else
			Peak_WarmUp_RenWu_Item1:Disable()
			Peak_WarmUp_RenWu_ItemAnimate1:Hide()
			Peak_WarmUp_RenWu_Down1:Show()
		end

	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[2].MissionId) == 1 then

		if Peak_WarmUp_GetMD(num,2) < 1 then
			Peak_WarmUp_RenWu_Item2:Enable()
			Peak_WarmUp_RenWu_ItemAnimate2:Show()
			Peak_WarmUp_RenWu_Down2:Hide()
			Lua_ShowQuickEnterPointTip(48, 1)
		else
			Peak_WarmUp_RenWu_Item2:Disable()
			Peak_WarmUp_RenWu_ItemAnimate2:Hide()
			Peak_WarmUp_RenWu_Down2:Show()
		end
	end

	if DataPool:Lua_IsMissionComplete(g_MissionInfo[3].MissionId) == 1 then

		if Peak_WarmUp_GetMD(num,3) < 1 then
			Peak_WarmUp_RenWu_Item3:Enable()
			Peak_WarmUp_RenWu_ItemAnimate3:Show()
			Peak_WarmUp_RenWu_Down3:Hide()
			Lua_ShowQuickEnterPointTip(48, 1)
		else
			Peak_WarmUp_RenWu_Item3:Disable()
			Peak_WarmUp_RenWu_ItemAnimate3:Hide()
			Peak_WarmUp_RenWu_Down3:Show()
		end

	end



	this:Show()

end


function Peak_WarmUp_RenWuClicked(index)

	PushEvent("UI_COMMAND", 99990903, index)

end

function Peak_WarmUp_On_ResetPos()

	Peak_WarmUp_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end


function Peak_WarmUp_Help_Clicked()
	PushEvent("QUEST_HELPINFO", "#{DFYR_250725_16}")
end


function  Peak_WarmUp_Close()

	Peak_WarmUp_RenWu_ItemAnimate1:Hide()
	Peak_WarmUp_RenWu_ItemAnimate2:Hide()
	Peak_WarmUp_RenWu_ItemAnimate3:Hide()

	Peak_WarmUp_RenWu_Item1:Disable()
	Peak_WarmUp_RenWu_Item2:Disable()
	Peak_WarmUp_RenWu_Item3:Disable()

	Peak_WarmUp_RenWu_Down1:Hide()
	Peak_WarmUp_RenWu_Down2:Hide()
	Peak_WarmUp_RenWu_Down3:Hide()


	for i = 1, 6 do
		g_RenWuOverList[i]:Hide()
		g_RenWuButtonList[i]:Hide()
    end



	Peak_WarmUp_HuoyueFrame2_TimeBk:Show()
	Peak_WarmUp_HuoyueFrame2_GiftBk:Hide()

	Peak_WarmUp_HuoyueFrame3_TimeBk:Show()
	Peak_WarmUp_HuoyueFrame3_GiftBk:Hide()

	this:Hide()

end




function Peak_WarmUp_GetMD(TotalNum,index)
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



function Peak_WarmUp_AwardClicked(index)

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
	else
		return 0
	end

	if 	index >= 1 and index <= 3 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(999882)
			Set_XSCRIPT_Parameter(0,index)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end


end

function Peak_WarmUp_SetRedPoint()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SetRedPoint")
		Set_XSCRIPT_ScriptID(999882)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()


end