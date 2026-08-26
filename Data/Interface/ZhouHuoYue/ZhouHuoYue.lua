local g_Frame_UnifiedPosition
local g_NowSelect = 0;

local g_StartTime = 20240930
local g_EndTime = 20241006



local g_MaxPage = 4
local g_PerpageProgressNunMax = 5

local g_ZhouHuoYue_ZhanLingMax = 2000

local g_ZhouHuoYueItem = {

}

local g_ZhouHuoYueItemGrey = {

}

local g_ZhouHuoYuePageTips = {

}

local g_ZhouHuoYue_ZhanLingRMBItem = {

}

local g_ZhouHuoYue_ZhanLingRMBItemGrey = {
}

local g_ZhouHuoYue_ZhanLingPregerssText = {

}

local g_ZhouHuoYue_ZhanLingPregerssTextNum = {

}

-- local g_ZhouHuoYue_ScrollBar = {
-- }

local g_ZhouHuoYue_LevelLimit = {
	[1] = 40,
	[2] = 60,
	[3] = 70,
	[4] = 75,
}

local g_ZhouHuoYue_Lock = {
	
}

local g_ZhouHuoYue_Stage = {
	
}

local g_isShowTips = {}
local g_GutLine = {}
local g_AwardTips = 0
local g_IsFirstOpen = 0

local g_ZhouHuoYueItemId = {
	[1] = {item = 30900006, num = 2},
	[2] = {item = 38002224, num = 1},
	[3] = {item = 30503133, num = 1},
	[4] = {item = 38002224, num = 1},
	[5] = {item = 20310168, num = 3},
	[6] = {item = 38002224, num = 1},
	[7] = {item = 30502002, num = 2},
	[8] = {item = 38002224, num = 1},
	[9] = {item = 20502002, num = 1},
	[10] = {item = 38002225, num = 1},
	[11] = {item = 20501002, num = 1},
	[12] = {item = 38002225, num = 1},
	[13] = {item = 50213004, num = 1},
	[14] = {item = 38002225, num = 1},
	[15] = {item = 20310168, num = 5},
	[16] = {item = 38000202, num = 1},
	[17] = {item = 20800013, num = 5},
	[18] = {item = 38002226, num = 1},
	[19] = {item = 38002221, num = 1},
	[20] = {item = 38002227, num = 1},
}

local g_ProcessLimit = {
	[1] = {neednum = 200, itemspace = 2, materialspace = 0},
	[2] = {neednum = 400, itemspace = 2, materialspace = 0},
	[3] = {neednum = 600, itemspace = 1, materialspace = 1},
	[4] = {neednum = 800, itemspace = 2, materialspace = 0},
	[5] = {neednum = 1000, itemspace = 1, materialspace = 1},
	[6] = {neednum = 1200, itemspace = 1, materialspace = 1},
	[7] = {neednum = 1400, itemspace = 1, materialspace = 1},
	[8] = {neednum = 1600, itemspace = 1, materialspace = 1},
	[9] = {neednum = 1800, itemspace = 1, materialspace = 1},
	[10] = {neednum = 2000, itemspace = 2, materialspace = 0},
}

local g_ZhouHuoYue_ZhanLingProcessLimit = {
	[1] = {
		[1] = {neednum = 400,},
		[2] = {neednum = 800,},
		[3] = {neednum = 1200,},
		[4] = {neednum = 1600,},
		[5] = {neednum = 2000,},
		},
	[2] = {
		[1] = {neednum = 2400,},
		[2] = {neednum = 2800,},
		[3] = {neednum = 3200,},
		[4] = {neednum = 3600,},
		[5] = {neednum = 4000,},
		},
	[3] = {
		[1] = {neednum = 4400,},
		[2] = {neednum = 4800,},
		[3] = {neednum = 5200,},
		[4] = {neednum = 5600,},
		[5] = {neednum = 6000,},
		},
	[4] = {
		[1] = {neednum = 6400,},
		[2] = {neednum = 6800,},
		[3] = {neednum = 7200,},
		[4] = {neednum = 7600,},
		[5] = {neednum = 8000,},
		},
	
}

local g_Image = {
	[0] = "set:NewZhanLing image:NewZhanLing0",
	[1] = "set:NewZhanLing image:NewZhanLing1",
	[2] = "set:NewZhanLing image:NewZhanLing2",
	[3] = "set:NewZhanLing image:NewZhanLing3",
	[4] = "set:NewZhanLing image:NewZhanLing4",
	[5] = "set:NewZhanLing image:NewZhanLing5",
	[6] = "set:NewZhanLing image:NewZhanLing6",
	[7] = "set:NewZhanLing image:NewZhanLing7",
	[8] = "set:NewZhanLing image:NewZhanLing8",
	[9] = "set:NewZhanLing image:NewZhanLing9",
}


local g_ZhouHuoYueMax = 2200
local g_PerNewZhanLingNeedEXP = 400

local g_CurAwardPage = 1
local g_CurHuoYueZhi = 0
local g_CurHuoYueZhiDay = 0
local g_AwardProcess = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}
local g_RMBAwardProcess = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}

local g_SBHotPoint = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
}


--=========
-- PreLoad()
--=========
function ZhouHuoYue_PreLoad()

	this:RegisterEvent("ZHOUHUOYUE_UPDATE")--??or????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("YUEKA_UPDATE")--??or????
	this:RegisterEvent("PLAYER_LEAVE_WORLD")

end

--=========
-- OnLoad()
--=========
function ZhouHuoYue_OnLoad()

	g_Frame_UnifiedPosition = ZhouHuoYue_FrameFull:GetProperty("UnifiedPosition")

	g_ZhouHuoYueItem[1] = ZhouHuoYue_ItemA_1
	g_ZhouHuoYueItem[2] = ZhouHuoYue_ItemA_2
	g_ZhouHuoYueItem[3] = ZhouHuoYue_ItemB_1
	g_ZhouHuoYueItem[4] = ZhouHuoYue_ItemB_2
	g_ZhouHuoYueItem[5] = ZhouHuoYue_ItemC_1
	g_ZhouHuoYueItem[6] = ZhouHuoYue_ItemC_2
	g_ZhouHuoYueItem[7] = ZhouHuoYue_ItemD_1
	g_ZhouHuoYueItem[8] = ZhouHuoYue_ItemD_2
	g_ZhouHuoYueItem[9] = ZhouHuoYue_ItemE_1
	g_ZhouHuoYueItem[10] = ZhouHuoYue_ItemE_2
	g_ZhouHuoYueItem[11] = ZhouHuoYue_ItemF_1
	g_ZhouHuoYueItem[12] = ZhouHuoYue_ItemF_2
	g_ZhouHuoYueItem[13] = ZhouHuoYue_ItemG_1
	g_ZhouHuoYueItem[14] = ZhouHuoYue_ItemG_2
	g_ZhouHuoYueItem[15] = ZhouHuoYue_ItemH_1
	g_ZhouHuoYueItem[16] = ZhouHuoYue_ItemH_2
	g_ZhouHuoYueItem[17] = ZhouHuoYue_ItemI_1
	g_ZhouHuoYueItem[18] = ZhouHuoYue_ItemI_2
	g_ZhouHuoYueItem[19] = ZhouHuoYue_ItemJ_1
	g_ZhouHuoYueItem[20] = ZhouHuoYue_ItemJ_2

	g_ZhouHuoYueItemGrey[1] = ZhouHuoYue_ItemA1_Grey
	g_ZhouHuoYueItemGrey[2] = ZhouHuoYue_ItemA2_Grey
	g_ZhouHuoYueItemGrey[3] = ZhouHuoYue_ItemB1_Grey
	g_ZhouHuoYueItemGrey[4] = ZhouHuoYue_ItemB2_Grey
	g_ZhouHuoYueItemGrey[5] = ZhouHuoYue_ItemC1_Grey
	g_ZhouHuoYueItemGrey[6] = ZhouHuoYue_ItemC2_Grey
	g_ZhouHuoYueItemGrey[7] = ZhouHuoYue_ItemD1_Grey
	g_ZhouHuoYueItemGrey[8] = ZhouHuoYue_ItemD2_Grey
	g_ZhouHuoYueItemGrey[9] = ZhouHuoYue_ItemE1_Grey
	g_ZhouHuoYueItemGrey[10] = ZhouHuoYue_ItemE2_Grey
	g_ZhouHuoYueItemGrey[11] = ZhouHuoYue_ItemF1_Grey
	g_ZhouHuoYueItemGrey[12] = ZhouHuoYue_ItemF2_Grey
	g_ZhouHuoYueItemGrey[13] = ZhouHuoYue_ItemG1_Grey
	g_ZhouHuoYueItemGrey[14] = ZhouHuoYue_ItemG2_Grey
	g_ZhouHuoYueItemGrey[15] = ZhouHuoYue_ItemH1_Grey
	g_ZhouHuoYueItemGrey[16] = ZhouHuoYue_ItemH2_Grey
	g_ZhouHuoYueItemGrey[17] = ZhouHuoYue_ItemI1_Grey
	g_ZhouHuoYueItemGrey[18] = ZhouHuoYue_ItemI2_Grey
	g_ZhouHuoYueItemGrey[19] = ZhouHuoYue_ItemJ1_Grey
	g_ZhouHuoYueItemGrey[20] = ZhouHuoYue_ItemJ2_Grey
	
	g_ZhouHuoYue_ZhanLingRMBItem[1] = ZhouHuoYue_ZhanLing_ItemA
	g_ZhouHuoYue_ZhanLingRMBItem[2] = ZhouHuoYue_ZhanLing_ItemB
	g_ZhouHuoYue_ZhanLingRMBItem[3] = ZhouHuoYue_ZhanLing_ItemC
	g_ZhouHuoYue_ZhanLingRMBItem[4] = ZhouHuoYue_ZhanLing_ItemD
	g_ZhouHuoYue_ZhanLingRMBItem[5] = ZhouHuoYue_ZhanLing_ItemE
	
	
	g_ZhouHuoYue_ZhanLingRMBItemGrey[1] = ZhouHuoYue_ZhanLing_ItemA_Grey
	g_ZhouHuoYue_ZhanLingRMBItemGrey[2] = ZhouHuoYue_ZhanLing_ItemB_Grey
	g_ZhouHuoYue_ZhanLingRMBItemGrey[3] = ZhouHuoYue_ZhanLing_ItemC_Grey
	g_ZhouHuoYue_ZhanLingRMBItemGrey[4] = ZhouHuoYue_ZhanLing_ItemD_Grey
	g_ZhouHuoYue_ZhanLingRMBItemGrey[5] = ZhouHuoYue_ZhanLing_ItemE_Grey
	
	
	g_ZhouHuoYue_ZhanLingPregerssText[1] = ZhouHuoYue_ZhanLing_Text_Progress1
	g_ZhouHuoYue_ZhanLingPregerssText[2] = ZhouHuoYue_ZhanLing_Text_Progress2
	g_ZhouHuoYue_ZhanLingPregerssText[3] = ZhouHuoYue_ZhanLing_Text_Progress3
	g_ZhouHuoYue_ZhanLingPregerssText[4] = ZhouHuoYue_ZhanLing_Text_Progress4
	g_ZhouHuoYue_ZhanLingPregerssText[5] = ZhouHuoYue_ZhanLing_Text_Progress5
	
	g_ZhouHuoYue_ZhanLingPregerssTextNum[1] = ZhouHuoYue_ZhanLing_Text_ProgressNum1
	g_ZhouHuoYue_ZhanLingPregerssTextNum[2] = ZhouHuoYue_ZhanLing_Text_ProgressNum2
	g_ZhouHuoYue_ZhanLingPregerssTextNum[3] = ZhouHuoYue_ZhanLing_Text_ProgressNum3
	g_ZhouHuoYue_ZhanLingPregerssTextNum[4] = ZhouHuoYue_ZhanLing_Text_ProgressNum4
	g_ZhouHuoYue_ZhanLingPregerssTextNum[5] = ZhouHuoYue_ZhanLing_Text_ProgressNum5
	

	g_ZhouHuoYuePageTips[1] = ZhouHuoYue_Daily_tips
	g_ZhouHuoYuePageTips[2] = ZhouHuoYue_Fuben_tips
	g_ZhouHuoYuePageTips[3] = ZhouHuoYue_Huodong_tips
	g_ZhouHuoYuePageTips[4] = ZhouHuoYue_Zhandou_tips
	g_ZhouHuoYuePageTips[5] = ZhouHuoYue_Xiuxian_tips
	g_ZhouHuoYuePageTips[6] = ZhouHuoYue_All_tips
	
	g_ZhouHuoYue_Lock[1] = ZhouHuoYue_Lock1
	g_ZhouHuoYue_Lock[2] = ZhouHuoYue_Lock2
	g_ZhouHuoYue_Lock[3] = ZhouHuoYue_Lock3
	g_ZhouHuoYue_Lock[4] = ZhouHuoYue_Lock4
	
	g_ZhouHuoYue_Stage[1] = ZhouHuoYue_Stage1
	g_ZhouHuoYue_Stage[2] = ZhouHuoYue_Stage2
	g_ZhouHuoYue_Stage[3] = ZhouHuoYue_Stage3
	g_ZhouHuoYue_Stage[4] = ZhouHuoYue_Stage4
	
	g_GutLine[1] = ZhouHuoYue_Section1
	g_GutLine[2] = ZhouHuoYue_Section2
	g_GutLine[3] = ZhouHuoYue_Section3
	g_GutLine[4] = ZhouHuoYue_Section4

	g_NowSelect = 0;

end

--=========
-- Event
--=========
function ZhouHuoYue_OnEvent(event)

	if(event == "ZHOUHUOYUE_UPDATE") then
		local nHuoYueZhi = 	tonumber( arg0 )
		local nType = tonumber( arg1 )
		local nAwardProcess = tonumber( arg2 )

		-- 犫个每葼活跃点数也同步到了封魂录界面，如果犫里参数要变，需要同步修改封魂录的界面逻辑 PetSoul_FengHunLu
		local nHuoYueZhiDay = tonumber( arg4 )
		local nPlayerLevel = Player:GetLevel()
		if nType == 0 then
			ZhouHuoYue_UpdataTop(nHuoYueZhi, nAwardProcess,nHuoYueZhiDay)
			ZhouHuoYue_UpdataBottom(0, nPlayerLevel)
			ZhouHuoYue_All:SetCheck(1)
			g_NowSelect = 0
			this:Show()
			ZhouHuoYue_HuoyueBK:Show()
			ZhouHuoYue_ZhanLing_HuoyueBK:Hide()
			ZhouHuoYue_Page1_Btn:SetCheck(1)
			ZhouHuoYue_Page2_Btn:SetCheck(0)
		else
			if this:IsVisible() then
				ZhouHuoYue_UpdataTop(nHuoYueZhi, nAwardProcess, nHuoYueZhiDay)
				ZhouHuoYue_UpdataBottom(g_NowSelect, nPlayerLevel)
			end
		end

	elseif event == "HIDE_ON_SCENE_TRANSED" then

		ZhouHuoYue_Close()

	elseif event == "VIEW_RESOLUTION_CHANGED" then

		ZhouHuoYue_On_ResetPos()

	elseif event == "ADJEST_UI_POS" then

		ZhouHuoYue_On_ResetPos()
		
	elseif(event == "YUEKA_UPDATE") then
		local nHuoYueZhi = 	tonumber( arg0 )
		g_CurHuoYueZhi = nHuoYueZhi
		local nType = tonumber( arg1 )
		local nAwardProcess = tonumber( arg2 )
		g_AwardProcess[4] = math.mod(nAwardProcess, 100)
		g_AwardProcess[3] = math.mod(math.floor(nAwardProcess/100), 100)
		g_AwardProcess[2] = math.mod(math.floor(nAwardProcess/10000), 100)
		g_AwardProcess[1]= math.floor(nAwardProcess/1000000)
		
		local nRMBAwardProcess = tonumber( arg5 )
		g_RMBAwardProcess[4] = math.mod(nRMBAwardProcess, 100)
		g_RMBAwardProcess[3] = math.mod(math.floor(nRMBAwardProcess/100), 100)
		g_RMBAwardProcess[2] = math.mod(math.floor(nRMBAwardProcess/10000), 100)
		g_RMBAwardProcess[1]= math.floor(nRMBAwardProcess/1000000)
		
		for i = 1, table.getn(g_SBHotPoint) do
			g_SBHotPoint[i] = 0
		end
		for page = 1, table.getn(g_SBHotPoint) do
			for i = 1, table.getn(g_ZhouHuoYue_ZhanLingProcessLimit[page]) do
				if nHuoYueZhi >= g_ZhouHuoYue_ZhanLingProcessLimit[page][i].neednum and g_RMBAwardProcess[page] == i - 1 then
					g_SBHotPoint[page] = 1
					break
				end
			end
		end
		
		
		-- 犫个每葼活跃点数也同步到了封魂录界面，如果犫里参数要变，需要同步修改封魂录的界面逻辑 PetSoul_FengHunLu
		local nHuoYueZhiDay = tonumber( arg4 )
		g_CurHuoYueZhiDay = nHuoYueZhiDay
		local nPlayerLevel = Player:GetLevel()
		if nType == 0 then
			ZhouHuoYue_ZhanLing_UpdataTop(g_CurAwardPage, nHuoYueZhi, g_AwardProcess[g_CurAwardPage], g_RMBAwardProcess[g_CurAwardPage])
			ZhouHuoYue_HuoyueBK:Hide()
			ZhouHuoYue_ZhanLing_HuoyueBK:Show()
		elseif nType == 2 then
			if this:IsVisible() then
				ZhouHuoYue_ZhanLing_UpdataTop(g_CurAwardPage, nHuoYueZhi, g_AwardProcess[g_CurAwardPage], g_RMBAwardProcess[g_CurAwardPage])
			end
		else
			if this:IsVisible() then
				ZhouHuoYue_ZhanLing_UpdataTop(g_CurAwardPage, nHuoYueZhi, g_AwardProcess[g_CurAwardPage], g_RMBAwardProcess[g_CurAwardPage])
			end
		end
		
		if g_IsFirstOpen == 0 then
			g_IsFirstOpen = 1
		end
		
	elseif event == "PLAYER_LEAVE_WORLD" then
		g_CurAwardPage = 1
		for i =1, table.getn(g_AwardProcess) do
			g_AwardProcess[i] = 0
		end
		for i =1, table.getn(g_RMBAwardProcess) do
			g_RMBAwardProcess[i] = 0
		end
		for i =1, table.getn(g_SBHotPoint) do
			g_SBHotPoint[i] = 0
		end
		g_CurHuoYueZhi = 0
		g_IsFirstOpen = 0
		
	end

end

function ZhouHuoYue_Close()
	g_NowSelect = 0
	this:Hide()
	for i = 1, 5 do
		g_isShowTips[i] = 0
	end
	g_AwardTips = 0
	for i = 1, table.getn(g_ZhouHuoYue_Lock) do
		g_ZhouHuoYue_Lock[i]:Hide()
		g_ZhouHuoYue_Stage[i]:Hide()
		g_GutLine[i]:Hide()
	end
	g_IsFirstOpen = 0
end

--=========
-- 重置
--=========
function ZhouHuoYue_On_ResetPos()

	ZhouHuoYue_FrameFull:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)

end


--=========
-- 填充上半部分数据
--=========
function ZhouHuoYue_UpdataTop(num, nAwardProcess, nHuoYueZhiDay)

	
	ZhouHuoYue_Condition:Show()
	ZhouHuoYue_ZhanLing_Condition:Hide()
	local nLevel = Player:GetLevel()

	for i = 1, table.getn(g_ZhouHuoYueItem) do
		g_ZhouHuoYueItem[i]:SetActionItem(-1)
	end

	for i = 1, table.getn(g_ZhouHuoYueItem) do
		local theAction = DataPool:CreateBindActionItemForShow(g_ZhouHuoYueItemId[i].item, g_ZhouHuoYueItemId[i].num)
		if theAction:GetID() ~= 0 then
			g_ZhouHuoYueItem[i]:SetActionItem(theAction:GetID());
		end
		if nAwardProcess*2 >= i then
			g_ZhouHuoYueItemGrey[i]:Show()
		else
			g_ZhouHuoYueItemGrey[i]:Hide()
		end
	end
	
	local curDay = tonumber(DataPool:GetServerDayTime());
	local times = 1
	if curDay >= g_StartTime and curDay <= g_EndTime then
		ZhouHuoYue_HuoyueBK_DoubleL:Show()
		ZhouHuoYue_HuoyueBK_DoubleR:Show()
	else
		ZhouHuoYue_HuoyueBK_DoubleL:Hide()
		ZhouHuoYue_HuoyueBK_DoubleR:Hide()
	end

	if num > g_ZhouHuoYueMax then
		ZhouHuoYue_Text2:SetText("#G"..num)
		ZhouHuoYue_EXP:SetProgress(g_ZhouHuoYueMax, g_ZhouHuoYueMax)
		ZhouHuoYue_EXPTip:SetToolTip(ScriptGlobal_Format("#{ZHY_210301_05}", num))
	else
		ZhouHuoYue_Text2:SetText("#G"..num)
		ZhouHuoYue_EXP:SetProgress(num, g_ZhouHuoYueMax)
		ZhouHuoYue_EXPTip:SetToolTip(ScriptGlobal_Format("#{ZHY_210301_05}", num))
	end

	local mark = 0
	for i = 1, table.getn(g_ProcessLimit) do
		if num >= g_ProcessLimit[i].neednum and nAwardProcess == i - 1 then
			ZhouHuoYue_GetAward_tips:Show()
			g_AwardTips = 1
			mark = 1
			break
		else
			ZhouHuoYue_GetAward_tips:Hide()
		end
	end

	if mark == 0 then
		g_AwardTips = 0
	end
	
	if g_AwardTips >= 1 then
		ZhouHuoYue_Page1_Btn_Tips:Show()
	else
		ZhouHuoYue_Page1_Btn_Tips:Hide()
	end
	
	for i = 1, table.getn(g_ZhouHuoYue_LevelLimit) do
		--if nLevel < g_ZhouHuoYue_LevelLimit[i] then
			g_ZhouHuoYue_Lock[i]:Hide()
			g_ZhouHuoYue_Stage[i]:Hide()
			g_GutLine[i]:Hide()
		--end
	end
	ZhouHuoYue_Condition_Text:SetText(ScriptGlobal_Format("#{ZHY_210301_70}",nHuoYueZhiDay))

end

--=========
-- 填充上半部分数据
--=========
function  ZhouHuoYue_ZhanLing_UpdataTop(page, num, nAwardProcess, nRMBAwardProcess)

	if page == 1 then
		ZhouHuoYue_ZhanLing_UpPage:Disable()
		ZhouHuoYue_ZhanLing_DownPage:Enable()
	elseif page == g_MaxPage then
		ZhouHuoYue_ZhanLing_UpPage:Enable()
		ZhouHuoYue_ZhanLing_DownPage:Disable()
	else
		ZhouHuoYue_ZhanLing_UpPage:Enable()
		ZhouHuoYue_ZhanLing_DownPage:Enable()
	end
	
	local nLevel = Player:GetLevel()
	local misData = DataPool:GetPlayerMission_DataRound(1019)

	for i = 1, table.getn(g_ZhouHuoYue_ZhanLingRMBItem) do
		g_ZhouHuoYue_ZhanLingRMBItem[i]:SetActionItem(-1)
	end
	local curDay = tonumber(DataPool:GetServerDayTime());
	
	for i = 1, g_PerpageProgressNunMax do
		local bRet,nPoint,
			nShowA1,nItemNumA1,
			nShowA2,nItemNumA2,
			nShowA3,nItemNumA3,
			nShowA4,nItemNumA4,
			nShowA5,nItemNumA5,
			nShowB1,nItemNumB1,
			nShowB2,nItemNumB2,
			nShowB3,nItemNumB3,
			nShowB4,nItemNumB4,
			nShowB5,nItemNumB5,
			nShowB6,nItemNumB6
			=GetNewZhanLingPrizeInfo(curDay,(page-1)*g_PerpageProgressNunMax+i)
		if nil == bRet or 0 == bRet then
			return 0 
		end
		
		local theAction3 = DataPool:CreateBindActionItemForShow(nShowB1, nItemNumB1)
		if theAction3:GetID() ~= 0 then
			g_ZhouHuoYue_ZhanLingRMBItem[i]:SetActionItem(theAction3:GetID());
		end
		
		
		
		if nRMBAwardProcess >= i then
			g_ZhouHuoYue_ZhanLingRMBItemGrey[i]:Show()
		else
			g_ZhouHuoYue_ZhanLingRMBItemGrey[i]:Hide()
		end
	end
	
	local nStartTime = {}
	nStartTime[1], nStartTime[2], nStartTime[3], nStartTime[4], nEndTime = GetNewZhanLingStartTimeAndEndTime(curDay)
	local nLeaveDay = ZhouHuoYue_GetMonthLeftDays(curDay, nEndTime)
	local nTimeInfo = nStartTime[page]
	local days = math.mod(nTimeInfo , 100)
	nTimeInfo  = math.floor(nTimeInfo  / 100)
	local month = math.mod(nTimeInfo  , 100)
	local year = math.floor(nTimeInfo  / 100)
	
	if curDay >= nStartTime[page] then
		ZhouHuoYue_ZhanLing_TextTime2:SetText(ScriptGlobal_Format("#{ZLSJ_231106_99}",month, days))
	else
		ZhouHuoYue_ZhanLing_TextTime2:SetText(ScriptGlobal_Format("#{ZLSJ_231106_113}",month, days))
	end
	
	if nLeaveDay <= 7 then
		ZhouHuoYue_ZhanLing_TimeText:SetText(ScriptGlobal_Format("#{ZLSJ_231106_14}",nLeaveDay))
	else
		ZhouHuoYue_ZhanLing_TimeText:SetText(ScriptGlobal_Format("#{ZLSJ_231106_13}",nLeaveDay))
	end
	
	
	if nLeaveDay == 0 then
		ZhouHuoYue_ZhanLing_TimeText:SetText("#{ZLSJ_231106_115}")
	end
	
	local g_ExpEachpage = {}
	if num <= g_ZhouHuoYue_ZhanLingProcessLimit[1][g_PerpageProgressNunMax].neednum then
		g_ExpEachpage[1] = num
		g_ExpEachpage[2] = 0
		g_ExpEachpage[3] = 0
		g_ExpEachpage[4] = 0
	elseif num >= g_ZhouHuoYue_ZhanLingProcessLimit[1][g_PerpageProgressNunMax].neednum and num <= g_ZhouHuoYue_ZhanLingProcessLimit[2][g_PerpageProgressNunMax].neednum then
		g_ExpEachpage[1] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[2] = num - g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[3] = 0
		g_ExpEachpage[4] = 0
	elseif num >= g_ZhouHuoYue_ZhanLingProcessLimit[2][g_PerpageProgressNunMax].neednum and num <= g_ZhouHuoYue_ZhanLingProcessLimit[3][g_PerpageProgressNunMax].neednum then
		g_ExpEachpage[1] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[2] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[3] = num - g_ZhouHuoYue_ZhanLingMax*2
		g_ExpEachpage[4] = 0
	elseif num >= g_ZhouHuoYue_ZhanLingProcessLimit[3][g_PerpageProgressNunMax].neednum and num <= g_ZhouHuoYue_ZhanLingProcessLimit[4][g_PerpageProgressNunMax].neednum then
		g_ExpEachpage[1] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[2] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[3] = g_ZhouHuoYue_ZhanLingMax
		g_ExpEachpage[4] = num - g_ZhouHuoYue_ZhanLingMax*3
	end
	
	if g_ExpEachpage[page] >= g_ZhouHuoYue_ZhanLingMax then
		ZhouHuoYue_ZhanLing_EXP:SetProgress(g_ZhouHuoYue_ZhanLingMax+400, g_ZhouHuoYue_ZhanLingMax+400)
	else
		ZhouHuoYue_ZhanLing_EXP:SetProgress(g_ExpEachpage[page], g_ZhouHuoYue_ZhanLingMax+400)
	end
	
	ZhouHuoYue_ZhanLing_EXPTip:SetToolTip(ScriptGlobal_Format("#{ZLSJ_231106_83}", num))
	
	ZhouHuoYue_ZhanLing_TextNum:SetText("#{ZLSJ_231106_87}")
	ZhouHuoYue_ZhanLing_TextNum2:SetText(ScriptGlobal_Format("#{ZLSJ_231106_86}", num))

	local mark = 0
	for i = 1, table.getn(g_ZhouHuoYue_ZhanLingProcessLimit[page]) do
		if num >= g_ZhouHuoYue_ZhanLingProcessLimit[page][i].neednum and nRMBAwardProcess == i - 1 then
			if misData > 0 and  curDay >= nStartTime[page] then
				ZhouHuoYue_ZhanLing_GetAward_tips:Show()
				mark = 1
			else
				ZhouHuoYue_ZhanLing_GetAward_tips:Hide()
			end
			break
		else
			ZhouHuoYue_ZhanLing_GetAward_tips:Hide()
		end
		
	end
	ZhouHuoYue_ZhanLing_UpPage_Tips:Hide()
	ZhouHuoYue_ZhanLing_DownPage_Tips:Hide()
	for i = 1, table.getn(g_SBHotPoint) do
		if i < page and g_SBHotPoint[i] == 1 and misData > 0 and curDay >= nStartTime[i] then
			ZhouHuoYue_ZhanLing_UpPage_Tips:Show()
			mark = 1
		end
		if i > page and g_SBHotPoint[i] == 1 and misData > 0 and curDay >= nStartTime[i] then
			ZhouHuoYue_ZhanLing_DownPage_Tips:Show()
			mark = 1
		end
	end
	
	
	for i = 1, table.getn(g_ZhouHuoYue_ZhanLingPregerssText) do
		g_ZhouHuoYue_ZhanLingPregerssText[i]:SetText("#c6a3906"..(i+(page-1)*g_PerpageProgressNunMax).."C")
	end
	
	for i = 1, table.getn(g_ZhouHuoYue_ZhanLingPregerssTextNum) do
		g_ZhouHuoYue_ZhanLingPregerssTextNum[i]:SetText("#c6a3906"..g_ZhouHuoYue_ZhanLingProcessLimit[page][i].neednum)
	end
	
	local nNewZhanLingLevel = math.floor(num/g_PerNewZhanLingNeedEXP)
	local nHighNum = math.floor(nNewZhanLingLevel/10)
	local nLowNum = math.mod(nNewZhanLingLevel, 10)
	if nHighNum >= 1 then
		ZhouHuoYue_ZhanLing_Level1:SetProperty("Image", g_Image[nHighNum])
		ZhouHuoYue_ZhanLing_Level1:Show()
	else
		ZhouHuoYue_ZhanLing_Level1:Hide()
	end
	ZhouHuoYue_ZhanLing_Level2:SetProperty("Image", g_Image[nLowNum])
	local nPlayerLevel = Player:GetData("LEVEL")
	local bHotPoint = DataPool:LuaFnGetMF(1082)
	if (mark >= 1 and misData > 0 ) or bHotPoint == 0 and nPlayerLevel >= 70 then
		ZhouHuoYue_Page2_Btn_Tips:Show()
	else
		ZhouHuoYue_Page2_Btn_Tips:Hide()
	end
	
	ZhouHuoYue_Condition:Show()
	ZhouHuoYue_ZhanLing_Condition:Hide()
	
	
	if misData > 0 then
		ZhouHuoYue_ZhanLing_GetAward:Show()
		ZhouHuoYue_ZhanLing_BuyGetAward2:Hide()
		ZhouHuoYue_ZhanLing_Awards:Hide()
	else
		ZhouHuoYue_ZhanLing_GetAward:Hide()
		ZhouHuoYue_ZhanLing_BuyGetAward2:Show()
		ZhouHuoYue_ZhanLing_Awards:Show()
	end
end

--=========
-- 填充下半部分数据 index 为分类 全部 副本 活动 .........
--=========
function ZhouHuoYue_UpdataBottom(index, nPlayerLevel)


	ZhouHuoYue_Lace:Clear()
	local nMaxRecord = Lua_GetZhouHuoYueMaxRecord()
	if nMaxRecord <= 0 then
		return
	end
	
	local curDay = tonumber(DataPool:GetServerDayTime());
	local times = 1
	if curDay >= g_StartTime and curDay <= g_EndTime then
		--times = 2 --周活跃国庆犫次不是活跃值翻倍，是奖励翻倍了 所以犫地方注销掉了
	end
	
	if index == 0 then
		for i = 1, 5 do
			g_isShowTips[i] = 0
		end
		for i = 1,nMaxRecord do

			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
				local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)

				if  nProcessInfo == nSmallClassIndex - 1 and nGetAwardInfo >= nNeedTimes then
					local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
					if not bar1 then
						break
					end
					bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
					bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
					bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nNeedTimes).."/"..tostring(nNeedTimes) );
					bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Hide();
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Show();
					bar1:GetSubItem("ZhouHuoYue_Received"):Hide()
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):SetEvent( "Clicked", string.format("ZhouHuoYue_GetZhouHuoYueAddHuoYueZhi(%d)", i))
					bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
					bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Show()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
					g_isShowTips[nBigClass] = 1
					--g_ZhouHuoYue_ScrollBar[i] = bar1
				end
			end

		end

		for i = 1,nMaxRecord do
			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
				local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)

				if nProcessInfo == nSmallClassIndex - 1 and nGetAwardInfo < nNeedTimes then
					local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
					if not bar1 then
						break
					end
					bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
					bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
					bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nGetAwardInfo).."/"..tostring(nNeedTimes) );
					bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Show();
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Hide();
					bar1:GetSubItem("ZhouHuoYue_Received"):Hide()
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):SetEvent( "Clicked", string.format("ZhouHuoYue_GotoClick(%d)", i))
					bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
					bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Hide()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
					--g_ZhouHuoYue_ScrollBar[i] = bar1
				end
			end
		end

		for i = 1,nMaxRecord do
			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
				local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
				local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)

				if nProcessInfo == nSmallClassMaxIndex and nSmallClassIndex == nSmallClassMaxIndex then
					local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
					if not bar1 then
						break
					end
					bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
					bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
					bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nNeedTimes).."/"..tostring(nNeedTimes) );
					bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Hide();
					bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Hide();
					bar1:GetSubItem("ZhouHuoYue_Received"):Show()
					bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
					bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Hide()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
					bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
					--g_ZhouHuoYue_ScrollBar[i] = bar1
				end
			end
		end

		g_ZhouHuoYuePageTips[6]:Hide()--?????
		local mark = 0
		for i = 1, 5 do
			if g_isShowTips[i] == 1 then
				g_ZhouHuoYuePageTips[i]:Show()
				mark = 1
			else
				g_ZhouHuoYuePageTips[i]:Hide()
			end
		end

		if mark == 1 then
			g_ZhouHuoYuePageTips[6]:Show()	
			ZhouHuoYue_Page1_Btn_Tips:Show()
		elseif g_AwardTips == 0 and mark == 0 then
			ZhouHuoYue_Page1_Btn_Tips:Hide()
		end

	else
		g_isShowTips[index]	= 0
		for i = 1, nMaxRecord do
			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				if nBigClass == index then
					local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)


					if  nProcessInfo == nSmallClassIndex - 1 and nGetAwardInfo >= nNeedTimes then
						local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
						if not bar1 then
							break
						end
						bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
						bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
						bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nNeedTimes).."/"..tostring(nNeedTimes) );
						bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Hide();
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Show();
						bar1:GetSubItem("ZhouHuoYue_Received"):Hide()
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):SetEvent( "Clicked", string.format("ZhouHuoYue_GetZhouHuoYueAddHuoYueZhi(%d)", i))
						bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
						bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Show()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
						g_isShowTips[nBigClass] = 1
						--g_ZhouHuoYue_ScrollBar[i] = bar1
					end
				end
			end
		end

		for i = 1, nMaxRecord do
			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				if nBigClass == index then

					local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)
					if nProcessInfo == nSmallClassIndex - 1 and nGetAwardInfo < nNeedTimes then
						local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
						if not bar1 then
							break
						end
						bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
						bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
						bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nGetAwardInfo).."/"..tostring(nNeedTimes) );
						bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Show();
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Hide();
						bar1:GetSubItem("ZhouHuoYue_Received"):Hide()
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):SetEvent( "Clicked", string.format("ZhouHuoYue_GotoClick(%d)", i))
						bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
						bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Hide()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
						--g_ZhouHuoYue_ScrollBar[i] = bar1
					end
				end
			end
		end

		for i = 1, nMaxRecord do
			local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(i-1)
			if nPlayerLevel >= nLevel then
				if nBigClass == index then

					local nGetAwardInfo = Lua_GetZhouHuoYueNum(nSmallClass-1)
					local nProcessInfo = Lua_GetZhouHuoYueProcess(nSmallClass-1)
					local nSmallClassMaxIndex = Lua_GetZhouHuoYueSmallClassMax(nSmallClass)
					if nProcessInfo == nSmallClassMaxIndex and nSmallClassIndex == nSmallClassMaxIndex then
						local bar1 = ZhouHuoYue_Lace:AddChild("ZhouHuoYue_Item")
						if not bar1 then
							break
						end
						bar1:GetSubItem("ZhouHuoYue_Item_Text1"):SetText( strName );
						bar1:GetSubItem("ZhouHuoYue_Item_Text2"):SetText( strDesc );
						bar1:GetSubItem("ZhouHuoYue_Item_Text3"):SetText( tostring(nNeedTimes).."/"..tostring(nNeedTimes) );
						bar1:GetSubItem("ZhouHuoYue_Item_Text4"):SetText( "#G"..nHuoYueZhi*times );
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGoto"):Hide();
						bar1:GetSubItem("ZhouHuoYue_Item_ButtonGet"):Hide();
						bar1:GetSubItem("ZhouHuoYue_Received"):Show()
						bar1:GetSubItem("ZhouHuoYue_Item_Icon1"):SetProperty("Image", strTubiao);
						bar1:GetSubItem("ZhouHuoYue_Item_Tips"):Hide()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):Show()
						bar1:GetSubItem("ZhouHuoYue_Mission_Help"):SetEvent( "Clicked", string.format("ZhouHuoYue_MissionHelpClick(%d)", i))
						--g_ZhouHuoYue_ScrollBar[i] = bar1
					end
				end
			end
		end
		local mark = 0
		for i = 1, 5 do
			if g_isShowTips[i] == 1 then
				g_ZhouHuoYuePageTips[i]:Show()
				mark = 1
			else
				g_ZhouHuoYuePageTips[i]:Hide()
			end
		end
		if mark == 1 then
			g_ZhouHuoYuePageTips[6]:Show()
		else
			g_ZhouHuoYuePageTips[6]:Hide()
		end

		if mark == 1 then
			PushEvent("ZHOUHUOYUE_HOTPOINT", 1)
		elseif g_AwardTips == 0 and mark == 0 then
			PushEvent("ZHOUHUOYUE_HOTPOINT", 0)
		end
	end


end



function ZhouHuoYue_GotoClick(index)

	local nIndex, nBigClass, nSmallClass, nSmallClassIndex, strName, strDesc, strTubiao, nNeedTimes, nHuoYueZhi, nGotoType, nParam1, nParam2, nParam3, nParam4, nLevel = Lua_GetZhouHuoYueInfo(index-1)
	-- 1需要特殊处理 因为是打开界面
	if nGotoType == 1 then
		if nSmallClass == 8 then -- ??????
			ToggleYuanbaoShop()
		elseif nSmallClass == 9 then -- ????????
			PushEvent("OPEN_BINDYUANBAOSHOP")
		end
	elseif nGotoType == 2 then

        -- if Player:GetLevel() < g_LevelLimit then
            -- PushDebugMessage("#{QXHF_190620_18}")
            -- return
        -- end
		AutoRunToTargetEx(nParam2,nParam3,nParam1)
		SetAutoRunTargetNPCName( nParam4 )
		--PushDebugMessage("#{QXHF_190620_76}")
	elseif nGotoType == 3 then
		PushDebugMessage(nParam4)
	end

end

function ZhouHuoYue_GetAwardClick()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetZhouHuoYueAward");
		Set_XSCRIPT_ScriptID(800121);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();

end

function ZhouHuoYue_GetZhouHuoYueAddHuoYueZhi(index)

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AddHuoYueZhi");
		Set_XSCRIPT_ScriptID(800121);
		Set_XSCRIPT_Parameter(0,index);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();

end

function ZhouHuoYue_MissionHelpClick(index)
	PushEvent("ZHOUHUIYUE_HELP", index-1)
end



--=========
-- 问号帮助
--=========
function ZhouHuoYue_OnClickHelp()
	PushEvent("CCSHOP_HELP", 1)
end


--=========
-- 分页切换
--=========
function ZhouHuoYue_PageClick(index)
	local nLevel = Player:GetLevel()
	ZhouHuoYue_UpdataBottom(index, nLevel)
	g_NowSelect = index
end

function ZhouHuoYue_GetMonthLeftDays(nTime, nEndTime)
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
				--闰年
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

function ZhouHuoYue_ZhanLing_GetAwardClick(bIsRMB)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetYueKaAward");
		Set_XSCRIPT_ScriptID(998526);
		Set_XSCRIPT_Parameter(0,g_CurAwardPage);
		Set_XSCRIPT_Parameter(1,bIsRMB);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function ZhouHuoYue_ZhanLing_ClickBuy()
	--通知服务端脚本传数据
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name( "AskOpenAddProgressUI" )
	Set_XSCRIPT_ScriptID( 998526 )
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--=========
-- 激活月卡
--=========
function ZhouHuoYue_ZhanLing_ActiveYueKa()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ActiveYueKa")
		Set_XSCRIPT_ScriptID(998526)
		Set_XSCRIPT_Parameter(0, 0 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--=========
-- 上一页
--=========
function ZhouHuoYue_ZhanLing_PageUp()
	if g_CurAwardPage - 1 <= 0 then
		return 0
	end
	g_CurAwardPage = g_CurAwardPage -1
	ZhouHuoYue_ZhanLing_UpdataTop(g_CurAwardPage, g_CurHuoYueZhi, g_AwardProcess[g_CurAwardPage], g_RMBAwardProcess[g_CurAwardPage])
	
end

--=========
-- 下一页
--=========
function ZhouHuoYue_ZhanLing_PageDown()
	if g_CurAwardPage + 1 > g_MaxPage then
		return 0
	end
	g_CurAwardPage = g_CurAwardPage + 1
	ZhouHuoYue_ZhanLing_UpdataTop(g_CurAwardPage, g_CurHuoYueZhi, g_AwardProcess[g_CurAwardPage], g_RMBAwardProcess[g_CurAwardPage])
end

function ZhouHuoYue_ZhanLing_FenYeClick(index)
	if index == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI");
			Set_XSCRIPT_ScriptID(800121);
			Set_XSCRIPT_Parameter(0, 1 )
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		ZhouHuoYue_HuoyueBK:Show()
		ZhouHuoYue_ZhanLing_HuoyueBK:Hide()
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ClickHotPoint")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
		
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OpenUI")
			Set_XSCRIPT_ScriptID(998526)
			Set_XSCRIPT_Parameter(0, 1 )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		ZhouHuoYue_HuoyueBK:Hide()
		ZhouHuoYue_ZhanLing_HuoyueBK:Show()
		
	end
end

--=========
-- 问号帮助
--=========
function ZhouHuoYue_ZhanLing_OnClickHelp()
	PushEvent("CCSHOP_HELP", 22)
end
