-- ½Áî
--PrizeÓÃµ½µÄ³£Á¿
local g_MAX_LEVEL = 12 --?da??
local g_MAX_TODAY_GET_POINT = 200

--ÆäËûÒ³Ãæ±äÁ¿
local g_bIsNewServerGiftsForLevelUpValid = 0
local nCharCreateDate = 0
local CreateDate = 904691712			-- 2013?08?22?08:00:00

local g_NowCheck = 0

--PrizeÓÃµÄÈ«¾Ö±äÁ¿
local g_ShengWang_Pass_Frame_UnifiedPosition;
local g_MonthActivePoint = 0
local g_ServerYearMonth = -1
local g_LevelPoint = {	-- ??-?? 
	[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0,[6] = 0,[7] = 0,[8] = 0,[9] = 0,[10] = 0
}
local g_ShengWang_Pass_ActionBtn = {}
local g_PrizeStateA = {}
local g_PrizeStateB = {}
local g_PrizeStateC = {}
local g_IsAroused = 0
local g_IsAroused2 = 0
local g_TodayGetPoint = 0
local g_SeasonLeftDays = 0
local g_PointLevel = 0 --???????
local g_IsShowRedPoint = 0

local nFullLevel = 0 --?????

local g_LevelPrizeinfo = {}

local g_EachLeveActivePoint = 10

local g_MAX_MISSION_NUM = 5 --????

local g_MissionInfoList = {
	[1] = {name = "#{SWXT_221213_125}", maxtime = 12, notfinshtext = "#{SWXT_221213_126}" ,finshtext = "#{SWXT_221213_127}", addpoint = 8},
	[2] = {name = "#{SWXT_221213_128}", maxtime = 18, notfinshtext = "#{SWXT_221213_129}" ,finshtext = "#{SWXT_221213_130}", addpoint = 5},
	[3] = {name = "#{SWXT_221213_137}", maxtime = 4, notfinshtext = "#{SWXT_221213_138}" ,finshtext = "#{SWXT_221213_139}", addpoint = 5},
	[4] = {name = "#{SWXT_221213_131}", maxtime = 2, notfinshtext = "#{SWXT_221213_132}" ,finshtext = "#{SWXT_221213_133}", addpoint = 20},
}


--¹ö¶¯ÌõµÄÎ»ÖÃ
local g_Position_Scroll = 0;

--===============================================
-- PreLoad()
--===============================================
function ShengWang_Pass_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--????
	this:RegisterEvent("ADJEST_UI_POS",false)				-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- ??????????
	this:RegisterEvent("OPEN_ZHANLING")
	this:RegisterEvent("UPDATE_REDPOINT_IN_UI")
end

--===============================================
-- OnEvent()
--===============================================
function ShengWang_Pass_OnEvent(event)
	if event == "HIDE_ON_SCENE_TRANSED" then
		ShengWang_Pass_OnClose()
	elseif event == "ADJEST_UI_POS" then
		ShengWang_Pass_OnResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		ShengWang_Pass_OnResetPos()	
	elseif event == "OPEN_ZHANLING" then
		--Í¨Öª·þÎñ¶Ë½Å±¾´«Êý¾Ý
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskOpenMainUI" )
		Set_XSCRIPT_ScriptID( 890215 )
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()

	elseif event == "UI_COMMAND" and (tonumber(arg0) == 89021501) then	--??????
	
		local nOper = Get_XParam_INT(0)	--??????(0 ??,1??, 2??)
		local nTime  = Get_XParam_INT(1) --?????????
		g_MonthActivePoint = Get_XParam_INT(2) --????????
		g_TodayGetPoint = Get_XParam_INT(3) --????????
		g_IsAroused = Get_XParam_INT(6) --????RMB1
		g_IsShowRedPoint = Get_XParam_INT(7) --??????
		g_IsAroused2 = Get_XParam_INT(9) --????RMB2
		local nEndTime =  Get_XParam_INT(10)
		g_ServerYearMonth = -1
		g_SeasonLeftDays = ShengWang_Pass_GetMonthLeftDays(nTime, nEndTime)
		g_Position_Scroll = 0
		--ºìµã
		if 1 == g_IsShowRedPoint then
		
		end
		if 0 == nOper then
			ShengWang_Pass_OnClose()
			return 
		elseif 2 == nOper then
			if not this:IsVisible() then	
				return 
			end
			-- Ö»ÓÐ´ò¿ªÒ³ÃæÊ±Ë¢ÐÂÒ³Ãæ²Å¼ÇÂ¼ÉÏÒ»´ÎµÄ¹ö¶¯Ìõ
			g_Position_Scroll = ShengWang_Pass_RewardList:GetScrollPosition()	--??????????
		end
		ShengWang_Pass_PrizePageOpen()
		ShengWang_Pass_RewardListBK:Show()
		ShengWang_Pass_RewardTaskBK:Hide()
		ShengWang_PassBtn:SetCheck(1)
		ShengWang_PassTaskBtn:SetCheck(0)
		g_NowCheck = 0
		local nRet, nAddProcessOpenTime = GetZhanLingOpenAddProcessTime(nTime)
		if nRet > 0 and nTime < nAddProcessOpenTime then
			local strTemp = ScriptGlobal_Format("#{SWXT_221213_244}", math.floor(nAddProcessOpenTime/10000),math.mod(math.floor(nAddProcessOpenTime/100),100),math.mod(nAddProcessOpenTime, 100))
			ShengWang_Pass_PlusBK:SetToolTip(strTemp)	
			ShengWang_Pass_PlusBK:Show()
			ShengWang_Pass_Plus:Disable()
		elseif nRet > 0 and nTime >= nAddProcessOpenTime then
			ShengWang_Pass_Plus:SetToolTip("")	
			ShengWang_Pass_PlusBK:Hide()
			ShengWang_Pass_Plus:Enable()
		end
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 89021505) then	--??????
	
		local nMissionData = Get_XParam_INT(0)	--????
		local nMissionGetAwardData  = Get_XParam_INT(1) --????????
		
		ShengWang_Pass_MissionPageOpen(nMissionData, nMissionGetAwardData)
		ShengWang_Pass_RewardListBK:Hide()
		ShengWang_Pass_RewardTaskBK:Show()
		ShengWang_PassBtn:SetCheck(0)
		ShengWang_PassTaskBtn:SetCheck(1)
		g_NowCheck = 1
	end
end



function ShengWang_Pass_OnLoad()
	g_ShengWang_Pass_Frame_UnifiedPosition = ShengWang_Pass_Frame:GetProperty("UnifiedPosition")
end


function ShengWang_Pass_GetPrizeInfo()
		--»ñÈ¡½±ÀøÐÅÏ¢ ¼ÆËã½×Î» »ñÈ¡Áì½±MD
		for i = 1,g_MAX_LEVEL do
			local bRet,nPoint,
				nShowB1,nItemNumB1,
				nShowB2,nItemNumB2,
				nShowB3,nItemNumB3,
				nShowB4,nItemNumB4,
				nShowB5,nItemNumB5,
				nShowA1,nItemNumA1,
				nShowA2,nItemNumA2,
				nShowA3,nItemNumA3,
				nShowA4,nItemNumA4,
				nShowA5,nItemNumA5,
				nShowA6,nItemNumA6,
				nShowC1,nItemNumC1,
				nShowC2,nItemNumC2,
				nShowC3,nItemNumC3,
				nShowC4,nItemNumC4,
				nShowC5,nItemNumC5,
				nShowC6,nItemNumC6
				=GetZhanLingPrizeInfo(g_ServerYearMonth,i)
			if nil == bRet or 0 == bRet then
				return 0 
			end
			g_LevelPoint[i] = nPoint
			g_LevelPrizeinfo[i] = {}
			g_LevelPrizeinfo[i].ShowA1 = nShowA1
			g_LevelPrizeinfo[i].itemNumA1 = nItemNumA1
			g_LevelPrizeinfo[i].ShowA2 = nShowA2
			g_LevelPrizeinfo[i].itemNumA2 = nItemNumA2
			g_LevelPrizeinfo[i].ShowA3 = nShowA3
			g_LevelPrizeinfo[i].itemNumA3 = nItemNumA3
			g_LevelPrizeinfo[i].ShowA4 = nShowA4
			g_LevelPrizeinfo[i].itemNumA4 = nItemNumA4
			g_LevelPrizeinfo[i].ShowA5 = nShowA5
			g_LevelPrizeinfo[i].itemNumA5 = nItemNumA5
			g_LevelPrizeinfo[i].ShowA6 = nShowA6
			g_LevelPrizeinfo[i].itemNumA6 = nItemNumA6
			g_LevelPrizeinfo[i].ShowB1 = nShowB1
			g_LevelPrizeinfo[i].itemNumB1 = nItemNumB1
			g_LevelPrizeinfo[i].ShowB2 = nShowB2
			g_LevelPrizeinfo[i].itemNumB2 = nItemNumB2
			g_LevelPrizeinfo[i].ShowB3 = nShowB3
			g_LevelPrizeinfo[i].itemNumB3 = nItemNumB3
			g_LevelPrizeinfo[i].ShowB4 = nShowB4
			g_LevelPrizeinfo[i].itemNumB4 = nItemNumB4
			g_LevelPrizeinfo[i].ShowB5 = nShowB5
			g_LevelPrizeinfo[i].itemNumB5 = nItemNumB5
			g_LevelPrizeinfo[i].ShowC1 = nShowC1
			g_LevelPrizeinfo[i].itemNumC1 = nItemNumC1
			g_LevelPrizeinfo[i].ShowC2 = nShowC2
			g_LevelPrizeinfo[i].itemNumC2 = nItemNumC2
			g_LevelPrizeinfo[i].ShowC3 = nShowC3
			g_LevelPrizeinfo[i].itemNumC3 = nItemNumC3
			g_LevelPrizeinfo[i].ShowC4 = nShowC4
			g_LevelPrizeinfo[i].itemNumC4 = nItemNumC4
			g_LevelPrizeinfo[i].ShowC5 = nShowC5
			g_LevelPrizeinfo[i].itemNumC5 = nItemNumC5
			g_LevelPrizeinfo[i].ShowC6 = nShowC6
			g_LevelPrizeinfo[i].itemNumC6 = nItemNumC6
		end
		--end for
		--»ý·Ö¼ÆËã½×Î»
		if g_MonthActivePoint < 0 then
			return 0 
		end
		g_PointLevel = g_MAX_LEVEL
		for i = 1, g_MAX_LEVEL do
			if g_MonthActivePoint < g_LevelPoint[i] then
				g_PointLevel = i
				break
			end
		end

		if g_MonthActivePoint >= g_LevelPoint[g_MAX_LEVEL] then
			nFullLevel = 1
		else
			nFullLevel = 0
		end

		local prizeB_MD = Get_XParam_INT(4) --????MD
		local prizeA_MD = Get_XParam_INT(5) --??1??MD
		local prizeC_MD = Get_XParam_INT(8) --??2??MD

		g_PrizeStateA = ShengWang_Pass_GetBitTable(prizeA_MD)
		g_PrizeStateB = ShengWang_Pass_GetBitTable(prizeB_MD)
		g_PrizeStateC = ShengWang_Pass_GetBitTable(prizeC_MD)

		return 1
end

--´ò¿ª ½Áî½±Àø½çÃæ
function ShengWang_Pass_PrizePageOpen()	
	if 1 ~= ShengWang_Pass_GetPrizeInfo() then  --???????
		PushDebugMessage("Di®p Di®n s¯ li®u Gia Täi th¤t bÕi, Thïnh mµt l¥n næa Tá Khai Di®p Di®n.")
		return
	end
	
	--½çÃæÊý¾Ý
	--½×Î»Èü¼¾ÐÅÏ¢
	local strTemp = nil
	
	if g_SeasonLeftDays < 1 then
		ShengWang_Pass_Award_PregressTime:SetText("#{SWXT_221213_114}")
	elseif g_SeasonLeftDays <= 7 then
		strTemp = ScriptGlobal_Format("#{SWXT_221213_17}",g_SeasonLeftDays)
		ShengWang_Pass_Award_PregressTime:SetText(strTemp)
	else
		strTemp = ScriptGlobal_Format("#{SWXT_221213_17}",g_SeasonLeftDays)
		ShengWang_Pass_Award_PregressTime:SetText(strTemp)
	end
	--ShengWang_Pass_Award_PregressTime:SetToolTip("#{TLZL_190802_54}")
	
	local nLevel = math.floor(g_MonthActivePoint/g_EachLeveActivePoint)
	ShengWang_Pass_Award_PregressLevel:SetText(ScriptGlobal_Format("#{SWXT_221213_15}",nLevel))
	local nExp = math.mod(g_MonthActivePoint, g_EachLeveActivePoint)
	ShengWang_Pass_Award_Pregress:SetProgress(nExp,g_EachLeveActivePoint)
	ShengWang_Pass_Award_PregressText:SetText(ScriptGlobal_Format("#{SWXT_221213_16}",nExp, g_EachLeveActivePoint))
	ShengWang_Pass_Award_PregressText:SetToolTip(ScriptGlobal_Format("#{SWXT_221213_16}",nExp, g_EachLeveActivePoint))
	

	--List
	ShengWang_Pass_ClearRewardList()
	this:Show()
	for i = 1 , g_MAX_LEVEL do

		if nil == g_LevelPrizeinfo[i] or nil == g_PrizeStateA[i] or nil ==g_PrizeStateB[i] then
			PushDebugMessage("Di®p Di®n s¯ li®u Gia Täi th¤t bÕi, Thïnh mµt l¥n næa Tá Khai Di®p Di®n.")
			return 
		end

		local bar = ShengWang_Pass_RewardList:AddChild("ShengWang_Pass_RewardContent")
		if not bar then 
			break
		end
		--½×¶Î»ý·Ö
		local pointText = bar:GetSubItem("ShengWang_Pass_RewardLevel")
		if g_MonthActivePoint < g_LevelPoint[i] then
			pointText:SetText(ScriptGlobal_Format("#{SWXT_221213_37}",i))
		else
			pointText:SetText(ScriptGlobal_Format("#{SWXT_221213_37}",i))
		end

		--ActionItem
		local barItem = nil
		local theAction = nil
		----Basic 4¸ö
		barItem= bar:GetSubItem("ShengWang_Pass_Reward_NormalItem1")
		theAction = DataPool:CreateBindActionItemForShow(g_LevelPrizeinfo[i].ShowB1,g_LevelPrizeinfo[i].itemNumB1)
		if theAction:GetID() ~= 0 and barItem ~= nil then
			barItem:SetActionItem(theAction:GetID())
			table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		else
			barItem:Hide()
		end
		
		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_NormalItem2")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowB2,g_LevelPrizeinfo[i].itemNumB2)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end

		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_NormalItem3")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowB3,g_LevelPrizeinfo[i].itemNumB3)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end

		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_BasicItem4")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowB4,g_LevelPrizeinfo[i].itemNumB4)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end

		----Advanced 4¸ö
		barItem= bar:GetSubItem("ShengWang_Pass_Reward_EliteItem1")
		theAction = DataPool:CreateBindActionItemForShow(g_LevelPrizeinfo[i].ShowA1,g_LevelPrizeinfo[i].itemNumA1)
		if theAction:GetID() ~= 0 and barItem ~= nil then
			barItem:SetActionItem(theAction:GetID())
			table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		else
			barItem:Hide() 
		end

		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_EliteItem2")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowA2,g_LevelPrizeinfo[i].itemNumA2)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end

		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_EliteItem3")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowA3,g_LevelPrizeinfo[i].itemNumA3)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end

		-- barItem= bar:GetSubItem("ShengWang_Pass_Reward_AdvancedItem4")
		-- theAction = DataPool:CreateActionItemForShow(g_LevelPrizeinfo[i].ShowA4,g_LevelPrizeinfo[i].itemNumA4)
		-- if theAction:GetID() ~= 0 and barItem ~= nil then
			-- barItem:SetActionItem(theAction:GetID())
			-- table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		-- else
			-- barItem:Hide() 
		-- end
		
		barItem= bar:GetSubItem("ShengWang_Pass_Reward_HighItem1")
		theAction = DataPool:CreateBindActionItemForShow(g_LevelPrizeinfo[i].ShowC1,g_LevelPrizeinfo[i].itemNumC1)
		if theAction:GetID() ~= 0 and barItem ~= nil then
			barItem:SetActionItem(theAction:GetID())
			table.insert( g_ShengWang_Pass_ActionBtn,barItem)
		else
			barItem:Hide() 
		end

		--°´Å¥
		local basicButton = bar:GetSubItem("ShengWang_Pass_Reward_BasicGetButton")
		local basicHaveGetImg = bar:GetSubItem("ShengWang_Pass_Reward_BasicGetMark")
		local basicCannotGetImg = bar:GetSubItem("ShengWang_Pass_Reward_BasicDisableMark")

		local arouseButton = bar:GetSubItem("ShengWang_Pass_Reward_AdvancedArouseButton")
		local advancedButton = bar:GetSubItem("ShengWang_Pass_Reward_AdvancedGetButton")
		local advancedHaveGetImg = bar:GetSubItem("ShengWang_Pass_Reward_AdvancedGetMark")
		local advancedCannotGetImg = bar:GetSubItem("ShengWang_Pass_Reward_AdvancedDisableMark")
		
		local arouseButton2 = bar:GetSubItem("ShengWang_Pass_Reward_HighArouseButton")
		local advancedButton2 = bar:GetSubItem("ShengWang_Pass_Reward_HighGetButton")
		local advancedHaveGetImg2 = bar:GetSubItem("ShengWang_Pass_Reward_HighGetMark")
		local advancedCannotGetImg2 = bar:GetSubItem("ShengWang_Pass_Reward_HighDisableMark")
		
		if basicButton and basicHaveGetImg and basicCannotGetImg and arouseButton and advancedButton and advancedHaveGetImg and advancedCannotGetImg and arouseButton2 and advancedButton2 and advancedHaveGetImg2 and advancedCannotGetImg2 then

			--button°ó¶¨ÊÂ¼þ
			basicButton:SetEvent("Clicked",string.format( "ShengWang_Pass_GetPrize(%d,%d)",i,0 ))
			advancedButton:SetEvent("Clicked",string.format( "ShengWang_Pass_GetPrize(%d,%d)",i,1 ))
			arouseButton:SetEvent("Clicked","ShengWang_Pass_Arouse()")
			advancedButton2:SetEvent("Clicked",string.format( "ShengWang_Pass_GetPrize(%d,%d)",i,2 ))
			arouseButton2:SetEvent("Clicked","ShengWang_Pass_Arouse2()")
			if i >= g_PointLevel and 0 == nFullLevel then
				--Î´´ïµ½µÄ½×¼¶
				--basic
				basicButton:Hide()
				basicHaveGetImg:Hide()
				basicCannotGetImg:Show()

				--advanced
				if 0 == g_IsAroused then
					if 1 == i then
						arouseButton:Show()
						advancedButton:Hide()
						advancedHaveGetImg:Hide()
						advancedCannotGetImg:Hide()				
					else
						arouseButton:Hide()
						advancedButton:Hide()
						advancedHaveGetImg:Hide()
						advancedCannotGetImg:Hide()					
					end
				else
					arouseButton:Hide()
					advancedButton:Hide()
					advancedHaveGetImg:Hide()
					advancedCannotGetImg:Show()
				end
				
				--advanced2
				if 0 == g_IsAroused2 then
					if 1 == i then
						arouseButton2:Show()
						advancedButton2:Hide()
						advancedHaveGetImg2:Hide()
						advancedCannotGetImg2:Hide()				
					else
						arouseButton2:Hide()
						advancedButton2:Hide()
						advancedHaveGetImg2:Hide()
						advancedCannotGetImg2:Hide()					
					end
				else
					arouseButton2:Hide()
					advancedButton2:Hide()
					advancedHaveGetImg2:Hide()
					advancedCannotGetImg2:Show()
				end
			else
				--ÒÑ´ïµ½µÄ½×¼¶
				--Basic
				if 0 == g_PrizeStateB[i] then
					basicButton:Show()
					basicHaveGetImg:Hide()
					basicCannotGetImg:Hide()
				else
					basicButton:Hide()
					basicHaveGetImg:Show()
					basicCannotGetImg:Hide()
				end

				--Advanced
				if 0 == g_IsAroused then
					--Î´½âËø
					if 1 == i then
						arouseButton:Show()
						advancedButton:Hide()
						advancedHaveGetImg:Hide()
						advancedCannotGetImg:Hide()
					else
						arouseButton:Hide()
						advancedButton:Hide()
						advancedHaveGetImg:Hide()
						advancedCannotGetImg:Hide()
					end
				else
					--ÒÑ½âËø
					if 1 == g_PrizeStateA[i] then
						--ÒÑÁìÈ¡
						arouseButton:Hide()
						advancedButton:Hide()
						advancedHaveGetImg:Show()
						advancedCannotGetImg:Hide()
					else
						--Î´ÁìÈ¡
						arouseButton:Hide()
						advancedButton:Show()
						advancedHaveGetImg:Hide()
						advancedCannotGetImg:Hide()
					end
				end
				
				--Advanced2
				if 0 == g_IsAroused2 then
					--Î´½âËø
					if 1 == i then
						arouseButton2:Show()
						advancedButton2:Hide()
						advancedHaveGetImg2:Hide()
						advancedCannotGetImg2:Hide()
					else
						arouseButton2:Hide()
						advancedButton2:Hide()
						advancedHaveGetImg2:Hide()
						advancedCannotGetImg2:Hide()
					end
				else
					--ÒÑ½âËø
					if 1 == g_PrizeStateC[i] then
						--ÒÑÁìÈ¡
						arouseButton2:Hide()
						advancedButton2:Hide()
						advancedHaveGetImg2:Show()
						advancedCannotGetImg2:Hide()
					else
						--Î´ÁìÈ¡
						arouseButton2:Hide()
						advancedButton2:Show()
						advancedHaveGetImg2:Hide()
						advancedCannotGetImg2:Hide()
					end
				end
			end
		end
	end
	ShengWang_Pass_RewardList:SetScrollPosition(g_Position_Scroll)
	this:Show()
end



--´ò¿ª ½ÁîÈÎÎñ½çÃæ
function ShengWang_Pass_MissionPageOpen(nMissionData, nMissionGetAwardData)	
	
	--List
	ShengWang_Pass_ClearMissionList()
	this:Show()
	for i = 1 , table.getn(g_MissionInfoList) do

		local bar = ShengWang_Pass_RewardTask:AddChild("ShengWang_Pass_RewardTaskContent")
		if not bar then 
			break
		end
		--½×¶Î»ý·Ö
		local name = bar:GetSubItem("ShengWang_Pass_RewardTaskName")
		name:SetText(g_MissionInfoList[i].name)
		
		local nOneMissionData = ShengWang_Pass_GetMissionDataByIndex(nMissionData, i)
		local nOneMissionGetAwardData = ShengWang_Pass_GetMissionGetAwardDataByIndex(nMissionGetAwardData, i)
		
		local times = bar:GetSubItem("ShengWang_Pass_RewardTaskNum")
		--°´Å¥
		-- local basicButton = bar:GetSubItem("ShengWang_Pass_RewardTaskGet")
		-- local basicHaveGetImg = bar:GetSubItem("ShengWang_Pass_RewardTaskGetMark")
		-- local basicCannotGetImg = bar:GetSubItem("ShengWang_Pass_RewardTaskDisableMark")
		if times  then
			--button°ó¶¨ÊÂ¼þ
			--basicButton:SetEvent("Clicked",string.format( "ShengWang_Pass_GetMissionAward(%d)",i))
			-- ´ïµ½ÐèÒª´ÎÊý
			if nOneMissionData >= g_MissionInfoList[i].maxtime then
				times:SetText(g_MissionInfoList[i].finshtext)
				-- if nOneMissionGetAwardData == 1 then
					-- basicButton:Hide()
					-- basicHaveGetImg:Show()
					-- basicCannotGetImg:Hide()
				-- else
					-- basicButton:Show()
					-- basicHaveGetImg:Hide()
					-- basicCannotGetImg:Hide()
				-- end
			else
				times:SetText(ScriptGlobal_Format(g_MissionInfoList[i].notfinshtext,nOneMissionData))
				-- basicButton:Hide()
				-- basicHaveGetImg:Hide()
				-- basicCannotGetImg:Show()
			end		
		end
	end
end


--**********************************
-- È¡µ¥¸öÈÎÎñÊý¾Ý DDCCBBAA AA£ºÖÜ³£ÈÎÎñ BB£ºÍÚ¿ó CC£º×öÒ»¼þÌì¼ø×°±¸ DD£º³¤´º¹Èpvp 
--**********************************
function ShengWang_Pass_GetMissionDataByIndex(data, index)
	local nNum = 1
	if index == 1 then
		nNum = 1 
	elseif index == 2 then
		nNum = 100
	elseif index == 3 then
		nNum = 10000
	elseif index == 4 then
		nNum = 1000000
	end
	local nData = math.mod(math.floor(data/nNum), 100)
	return nData
end

--**********************************
-- È¡µ¥¸öÈÎÎñÁìÈ¡½±ÀøÊý¾Ý DDCCBBAA AA£ºÖÜ³£ÈÎÎñ BB£ºÍÚ¿ó CC£º×öÒ»¼þÌì¼ø×°±¸ DD£º³¤´º¹Èpvp 
--**********************************
function ShengWang_Pass_GetMissionGetAwardDataByIndex(data, index)
	
	local nNum = 1
	if index == 1 then
		nNum = 1 
	elseif index == 2 then
		nNum = 100
	elseif index == 3 then
		nNum = 10000
	elseif index == 4 then
		nNum = 1000000
	end
	local nData = math.mod(math.floor(data/nNum), 100)
	return nData
	
end

function ShengWang_Pass_Arouse()
	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AskActRMBReward")  --????
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_Parameter(1,1)
			Set_XSCRIPT_ScriptID(890215) --???? 
			Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function ShengWang_Pass_Arouse2()
	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AskActRMBReward")  --????
			Set_XSCRIPT_Parameter(0,0)
			Set_XSCRIPT_Parameter(1,2)
			Set_XSCRIPT_ScriptID(890215) --???? 
			Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--ÁìÈ¡ nType£ºÇàÁú-1 ÖìÈ¸-2
function ShengWang_Pass_GetPrize(nIndex,nType)
	Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AskGetReward")  --????
			Set_XSCRIPT_ScriptID(890215) --???? 
			Set_XSCRIPT_Parameter(0,nIndex)
			Set_XSCRIPT_Parameter(1,nType)
			Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function ShengWang_Pass_GetMissionAward(index)
	-- Clear_XSCRIPT()
			-- Set_XSCRIPT_Function_Name("AskMissionAward")  --½Å±¾½Ó¿Ú
			-- Set_XSCRIPT_ScriptID(890215) --½Å±¾±àºÅ 
			-- Set_XSCRIPT_Parameter(0,index)
			-- Set_XSCRIPT_ParamCount(1)
	-- Send_XSCRIPT()
end

function ShengWang_Pass_Help_Clicked()
	-- ½èÓÃÒ»ÏÂ±ðÈËµÄÍ¨µÀ
	PushEvent("CCSHOP_HELP", 13)
end

--Ð¡ºìµã
function ShengWang_Pass_UpdateRedPointUI()

end

function ShengWang_Pass_ClearRewardList()
	for i = 1, table.getn(g_ShengWang_Pass_ActionBtn) do 
		if g_ShengWang_Pass_ActionBtn[i] ~= nil then
			g_ShengWang_Pass_ActionBtn[i]:SetActionItem(-1)
			g_ShengWang_Pass_ActionBtn[i] = nil
		end
	end
	ShengWang_Pass_RewardList:Clear()	
end

function ShengWang_Pass_ClearMissionList()
	ShengWang_Pass_RewardTask:Clear()	
end

function ShengWang_Pass_OnHide()
	ShengWang_Pass_ClearRewardList()
	ShengWang_Pass_ClearMissionList()
end

function ShengWang_Pass_OnClose()
	this:Hide()
	g_NowCheck = 0
	if IsWindowShow("ShengWang_BuySpeed") then
		CloseWindow("ShengWang_BuySpeed", true)
	end
end


function ShengWang_Pass_CloseClicked()
	ShengWang_Pass_OnClose()
	
end

function ShengWang_Pass_OnResetPos()
	ShengWang_Pass_Frame:SetProperty("UnifiedPosition", g_ShengWang_Pass_Frame_UnifiedPosition)
end

function ShengWang_Pass_OnSetLastPos()

end

function ShengWang_Pass_GetBitTable(nOct)
	local BitTable = {}
	local oct = nOct
	for i = 1 , g_MAX_LEVEL do
		BitTable[i] = math.mod(oct , 2)
		oct = math.floor(oct / 2)
	end
	return BitTable
end

function ShengWang_Pass_GetMonthLeftDays(nTime, nEndTime)
	local days = math.mod(nTime , 100)
	nTime = math.floor(nTime / 100)
	local month = math.mod(nTime , 100)
	local year = math.floor(nTime / 100)
	
	local nEndDays = math.mod(nEndTime , 100)
	nEndTime = math.floor(nEndTime / 100)
	local nEndMonth = math.mod(nEndTime , 100)
	local nEndYear = math.floor(nEndTime / 100)
	
	if days < 1 or days >31 or month < 1 or month > 12 then
		return 0
	end
	
	if nEndDays < 1 or nEndDays >31 or nEndMonth < 1 or nEndMonth > 12 then
		return 0
	end
	
	if nEndMonth == month then
		return nEndDays - days 
	else
		if 4 == month or 6 == month or 9 == month or 11 == month  then
			return (30 + nEndDays - days )
		elseif 2 == month then
			if ( 0 == math.mod(year , 4) and 0 ~= math.mod(year,100) ) or 0 == math.mod(year , 400) then
				--ÈòÄê
				return (29 + nEndDays - days )
			else
				return (28 + nEndDays - days )
			end
		else
			return (31 + nEndDays - days )
		end
	end
	

	return 0
end

function ShengWang_Pass_OnCheckClick(index)

	if g_NowCheck == index then
		return 
	end
	
	if index == 0 then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskOpenMainUI" )
		Set_XSCRIPT_ScriptID( 890215 )
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		g_NowCheck = 0
	elseif index == 1 then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskOpenMissionUI" )
		Set_XSCRIPT_ScriptID( 890215 )
		Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		g_NowCheck = 1
	end
	
	if IsWindowShow("ShengWang_BuySpeed") then
		CloseWindow("ShengWang_BuySpeed", true)
	end

	
end

function ShengWang_Pass_ClickBuy()
	--Í¨Öª·þÎñ¶Ë½Å±¾´«Êý¾Ý
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name( "AskOpenAddProgressUI" )
	Set_XSCRIPT_ScriptID( 890215 )
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end
