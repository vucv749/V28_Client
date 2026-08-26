--新构架:无需改动UI自适应server更新模式
--每日豪礼
--代码信条：全面，简洁，全都要
--***************************************************
--*【For Entertainment or Communication Only】 *
--***************************************************
local CuruiPos
local PayReward_Istrue,PayReward_Need,PayReward_Receive
local PayReward_CurSelectAct,PayReward_CurSelectCount,PayReward_NotSelect
local PayReward_SelectAct,PayReward_SelectCount,PayReward_SelectIconG
local PayReward_OptionalItemInfo,PayReward_OptionalItemCount
local PayReward_SelectIndex = 0
local PayReward_SelectItemIndex = {0,0,0,0}
local PayReward_SelectGrade = 0
local datacount = 4
local maxdatacount = 8
local maxoptionalcount = 30
local maxheight = 322 + 120

local RankListInfo = {
	[1] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[2] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[3] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[4] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[5] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[6] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[7] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
	[8] = {"XinShouNew_WDC",0,0,0,0,0,0,0},
}--{未达成图标,需要点数,选择1,选择2,选择3,选择4,领取情况0未达成1可领取2已领取}

local MuDingPayRewardItems = {}
local MuDingPayRewardPlayerPoint = 0
local MuDingPlayerMissionData = {391, 392, 393, 394}

local g_rechargeMissionId = 389  -- 充值点数任务ID
local g_dateCheckMissionId = 390  -- 日期检查任务ID

function PayReward_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end
function PayReward_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 418042021 then
		local PayRItemIDStr = Get_XParam_STR(0);--物品ID
		local PayRItemCountStr = Get_XParam_STR(1);--物品数量
		local PayRPointInfo = Get_XParam_STR(2); --每日充值的档位
		local PayRInfoStr = {}
		MuDingPayRewardPlayerPoint = DataPool:GetPlayerMission_DataRound(g_rechargeMissionId)
		if PayRItemIDStr == nil then PushDebugMessage("PayRItemIDStr错误!") return end
		if PayRItemCountStr == nil then PushDebugMessage("PayRItemCountStr错误!") return end
		if PayRPointInfo == nil then PushDebugMessage("PayRPointInfo错误!") return end

		PayRItemIDStr = Split(PayRItemIDStr,",")	--物品ID
		PayRItemCountStr = Split(PayRItemCountStr,",")	--物品数量
		for i =1,4 do--包含选择的索引,对应的领取情况(10203042)
			PayRInfoStr[i]=DataPool:GetPlayerMission_DataRound(MuDingPlayerMissionData[i])
		end		
		PayRPointInfo =  Split(PayRPointInfo,",")	--每日充值的档位
		local tempNum = table.getn(PayRPointInfo)
		local tempPlayerDataInfo = {}
		
		for i=1,tempNum do
			RankListInfo[i][2]=tonumber(PayRPointInfo[i])--需求点数
			tempPlayerDataInfo=PayReward_PlayerNumToData(tonumber(PayRInfoStr[i])) --{选择1,选择2,选择3,选择4,领取情况0未达成1可领取2已领取}
			RankListInfo[i][3]=tonumber(tempPlayerDataInfo[1]) --选择1
			RankListInfo[i][4]=tonumber(tempPlayerDataInfo[2]) --选择2
			RankListInfo[i][5]=tonumber(tempPlayerDataInfo[3]) --选择3
			RankListInfo[i][6]=tonumber(tempPlayerDataInfo[4]) --选择4
			RankListInfo[i][7]=tonumber(tempPlayerDataInfo[5])--领取情况
			if MuDingPayRewardPlayerPoint >= RankListInfo[i][2] and RankListInfo[i][7] == 0 then
				RankListInfo[i][7]=1
			end
			MuDingPayRewardItems[i] = {--每个档位的详细物品信息(物品ID,物品数量)
				{tonumber(PayRItemIDStr[i*4-3]),tonumber(PayRItemCountStr[i*4-3])},
				{tonumber(PayRItemIDStr[i*4-2]),tonumber(PayRItemCountStr[i*4-2])},
				{tonumber(PayRItemIDStr[i*4-1]),tonumber(PayRItemCountStr[i*4-1])},
				{tonumber(PayRItemIDStr[i*4]),tonumber(PayRItemCountStr[i*4])},
			}
		end
		PayReward_OpenUI()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 202501281 then
		local selectLine = tonumber(Get_XParam_INT(0))
		if selectLine < 1 or selectLine > 8 then return end
		local tempItemId = Get_XParam_STR(0);
		local tempItemCount = Get_XParam_STR(1);
		if tempItemId == nil or tempItemId == "" or tempItemCount == nil or tempItemCount == "" then return end
		tempItemId = Split(tempItemId,",")
		tempItemCount = Split(tempItemCount,",")
		MuDingPayRewardItems[selectLine] = {}
		local tempNum = table.getn(tempItemId)
		for i = 1, tempNum do
			MuDingPayRewardItems[selectLine][i]={tonumber(tempItemId[i]),tonumber(tempItemCount[i])}
			
		end
		--RankListInfo[selectLine][8] = 1
		PayReward_OpenOptionalAward1(selectLine)
	elseif event == "UI_COMMAND" and tonumber(arg0) == 202501291 then
		local selectLine = tonumber(Get_XParam_INT(0))
		if selectLine < 1 or selectLine > 4 then return end
		local tempPlayerDataInfo = DataPool:GetPlayerMission_DataRound(MuDingPlayerMissionData[selectLine])
		tempPlayerDataInfo = PayReward_PlayerNumToData(tonumber(tempPlayerDataInfo))
		
		PayReward_Receive[selectLine]:Disable()
		PayReward_Receive[selectLine]:SetProperty("DisabledImage","set:XinShouNewBK image:XinShouNew_YLQ");
		
		for i = 1,4 do
			PayReward_NotSelect[selectLine][i]:SetProperty("Image","set:Seven image:Seven_ke");
			PayReward_NotSelect[selectLine][i]:Show()
			RankListInfo[selectLine][i+2] = tempPlayerDataInfo[i]
		end
		
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		--PayReward_Frame:SetProperty("UnifiedPosition",CuruiPos)
	elseif event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
	end
end





function PayReward_OpenUI()
	if not this:IsVisible() then
		this:Show()
	end
	PayReward_CloseOptionalAward()
	local opencount = 0	--用于高度标记
	local nTempText = ""
	for i=1,8 do
		if RankListInfo[i][2] ~= 0 then--需要的点数 大于0就显示出来对应的行
			opencount = opencount + 1
			PayReward_Istrue[i]:Show()
			PayReward_GetSelfSelect(i,1,1)
			PayReward_GetSelfSelect(i,2,2)
			PayReward_GetSelfSelect(i,3,3)
			PayReward_GetSelfSelect(i,4,4)
			if RankListInfo[i][7] == 1 then--领取情况0未达成1可领取2已领取
				PayReward_Receive[i]:Enable()
				nTempText = string.format("#G需求点数:%s/%s",tostring(MuDingPayRewardPlayerPoint),tostring(RankListInfo[i][2]))
			elseif RankListInfo[i][7] == 2 then
				PayReward_Receive[i]:Disable()
				PayReward_Receive[i]:SetProperty("DisabledImage","set:XinShouNewBK image:XinShouNew_YLQ");
				nTempText = string.format("#G需求点数:%s/%s",tostring(MuDingPayRewardPlayerPoint),tostring(RankListInfo[i][2]))
			else
				PayReward_Receive[i]:Disable()
				PayReward_Receive[i]:SetProperty("DisabledImage","set:XinShouNewBK image:XinShouNew_WDC");
				nTempText = string.format("#cff0000需求点数:%s/%s",tostring(MuDingPayRewardPlayerPoint),tostring(RankListInfo[i][2]))
			end
			
			PayReward_Need[i]:SetText(nTempText)
		else
			PayReward_Istrue[i]:Hide()
		end
	end
	maxheight = opencount * 54 + 120
	PayReward_Frame:SetProperty("AbsoluteHeight",maxheight);
end
function PayReward_GetSelfSelect(index,idx,value)
	if index < 1 or index > 8 then return end
	if value < 1 or value > maxoptionalcount then return end
	if not MuDingPayRewardItems[index][value][1] then return end
	local theAction = MuDingPayRewardItems[index][value][1]
	local count = MuDingPayRewardItems[index][value][2]
	--theAction = DataPool:CreateActionItemForShow(theAction, count)
	theAction = DataPool:CreateActionItemForShow(theAction, 1)
	if theAction:GetID() ~= 0 then
		PayReward_CurSelectAct[index][idx]:SetActionItem(theAction:GetID())
		if count and count > 1 then
			PayReward_CurSelectCount[index][idx]:SetText("#e010101#cffffff"..tostring(count));
		else
			PayReward_CurSelectCount[index][idx]:SetText("")
		end
		if RankListInfo[index][7] == 0 then --未达成图标
			PayReward_NotSelect[index][idx]:SetProperty("Image","set:UIIcons image:Icon_Lock");
			PayReward_NotSelect[index][idx]:Show()
		elseif RankListInfo[index][7] == 1 then --可领取
			PayReward_NotSelect[index][idx]:Hide()
		elseif RankListInfo[index][7] == 2 then --已领取
			PayReward_NotSelect[index][idx]:SetProperty("Image","set:Seven image:Seven_ke");
			PayReward_NotSelect[index][idx]:Show()
		end
		RankListInfo[index][idx+2] = value
	else
		PayReward_CurSelectAct[index][idx]:SetActionItem(-1)
		PayReward_CurSelectCount[index][idx]:SetText("")
		PayReward_NotSelect[index][idx]:Show()
	end
end


function PayReward_OpenOptionalAward1(index)
	if maxheight < 322 + 120 then
		PayReward_Frame:SetProperty("AbsoluteHeight",322 + 120);
	end
	PayReward_FrameSelectBox:Show()
	for i,j in PayReward_SelectIconG do
		j:Hide()
	end
	for i,j in PayReward_Need do
		j:Hide()
	end
	for i,j in PayReward_CurSelectCount do
		for k,l in j do
			l:Hide()
		end
	end
	PayReward_SelectGrade = index
	--重新填充一下选择吧
	local tempArr = PayReward_PlayerNumToData(tonumber(DataPool:GetPlayerMission_DataRound(g_dateCheckMissionId+index)))
	
	for i = 1,4	do
		RankListInfo[index][i+2]=tempArr[i]
	end
	
	local theAction,itemId,itemCount,numtext
	for i = 1, table.getn(MuDingPayRewardItems[index]) do
		itemId=MuDingPayRewardItems[index][i][1]
		itemCount=MuDingPayRewardItems[index][i][2]
		--theAction = DataPool:CreateActionItemForShow(itemId, itemCount)
		theAction = DataPool:CreateActionItemForShow(itemId, 1)
		numtext = ""
		if itemCount and itemCount > 1 then
			numtext = "#e010101#cffffff"..tostring(itemCount)
		end
		if theAction:GetID() ~= 0 then
			PayReward_OptionalItemInfo[i]:SetActionItem(theAction:GetID())
		else
			PayReward_OptionalItemInfo[i]:SetActionItem(-1)
		end
		PayReward_OptionalItemCount[i]:SetText(numtext);
		PayReward_OptionalItemInfo[i]:Enable()
		for k = 1 , 4 do
			if i == RankListInfo[index][k+2] then
				PayReward_SelectItemIndex[k]=i
				PayReward_OptionalItemInfo[i]:Disable()
				PayReward_SelectAct[k]:SetActionItem(theAction:GetID())
				PayReward_SelectCount[k]:SetText(numtext)
				break
			end
		end
	end
end

function PayReward_OpenOptionalAward(index)
	if index < 1 or index > 8 then return end
	if RankListInfo[index][8] == 1 then
		PayReward_OpenOptionalAward1(index)
		return
	end
	Clear_XSCRIPT() --获取这行回馈的详细物品
		Set_XSCRIPT_Function_Name( "MuDingOpenPagePayReward" );
		Set_XSCRIPT_ScriptID( 330083 );	
		Set_XSCRIPT_Parameter(0,tonumber(index))
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT()
end


function PayReward_SelectClickTwo(index)
	if PayReward_SelectIndex == 0 then
		PushDebugMessage("请先勾选上方的位置选择框")
		return
	elseif PayReward_SelectGrade == 0 then
		PushDebugMessage("error")
		return
	end
	if RankListInfo[PayReward_SelectGrade][7] and RankListInfo[PayReward_SelectGrade][7] == 2 then
		PushDebugMessage("领取过了!")
		return
	end
	local GradeArrCount = table.getn(MuDingPayRewardItems[PayReward_SelectGrade])
	if GradeArrCount < index then return end
	local itemId=MuDingPayRewardItems[PayReward_SelectGrade][index][1]
	local itemCount=MuDingPayRewardItems[PayReward_SelectGrade][index][2]
	local theAction = DataPool:CreateActionItemForShow(itemId, 1)
	--local theAction = DataPool:CreateActionItemForShow(itemId, itemCount)
	if theAction:GetID() ~= 0 then
		PayReward_SelectAct[PayReward_SelectIndex]:SetActionItem(theAction:GetID())
	else
		PushDebugMessage("error:"..tostring(itemId))
		return
	end
	if itemCount and itemCount > 1 then
		PayReward_SelectCount[PayReward_SelectIndex]:SetText("#e010101#cffffff"..tostring(itemCount))
	else
		PayReward_SelectCount[PayReward_SelectIndex]:SetText("")
	end
	local oldindex = PayReward_SelectItemIndex[PayReward_SelectIndex]
	if oldindex > 0 then
		PayReward_OptionalItemInfo[oldindex]:Enable()
	end
	PayReward_SelectItemIndex[PayReward_SelectIndex] = index
	PayReward_OptionalItemInfo[index]:Disable()
	
	RankListInfo[PayReward_SelectGrade][PayReward_SelectIndex+2] = index
	
end

--提交
function PayReward_SubmitSecect()
	if PayReward_SelectGrade == 0 then
		PushDebugMessage("error")
		return
	end
	for i = 1,4 do
		if RankListInfo[PayReward_SelectGrade][i+2] == 0 then 
			PushDebugMessage("请选择奖励物品!")
			return 
		end
		for k = 1,4 do 
			if i ~= k and RankListInfo[PayReward_SelectGrade][i+2] == RankListInfo[PayReward_SelectGrade][k+2] then
				PushDebugMessage("无法选择同一件物品或没有选择物品!")
				return
			end
		end
	end
	
	PayReward_GetSelfSelect(PayReward_SelectGrade,1,RankListInfo[PayReward_SelectGrade][3])
	PayReward_GetSelfSelect(PayReward_SelectGrade,2,RankListInfo[PayReward_SelectGrade][4])
	PayReward_GetSelfSelect(PayReward_SelectGrade,3,RankListInfo[PayReward_SelectGrade][5])
	PayReward_GetSelfSelect(PayReward_SelectGrade,4,RankListInfo[PayReward_SelectGrade][6])
	--下面发送给服务端 存起来 玩家大退再打开的时候看到的依然是选择好的物品
	Clear_XSCRIPT() 
		Set_XSCRIPT_Function_Name( "MuDingSetPayRewardSelect" );
		Set_XSCRIPT_ScriptID( 330083 );	
		Set_XSCRIPT_Parameter(0,tonumber(PayReward_SelectGrade))
		for i=1,4 do
			Set_XSCRIPT_Parameter(i,tonumber(RankListInfo[PayReward_SelectGrade][i+2]))
		end
		Set_XSCRIPT_ParamCount(5);
	Send_XSCRIPT()
	PayReward_CloseOptionalAward()
end

function PayReward_UpdateSelfSelect()

end

function PayReward_PlayerNumToData(num)
	local tempArr = {}
	tempArr[5] = math.mod(num,10)
	tempArr[4] = math.mod(math.floor(num/10),100) 
	tempArr[3] = math.mod(math.floor(num/1000),100) 
	tempArr[2] = math.mod(math.floor(num/100000),100) 
	tempArr[1] = math.mod(math.floor(num/10000000),100) 
	return tempArr
end

function PayReward_CloseOptionalAward()
	for i,j in PayReward_Need do
		j:Show()
	end
	for _,j in PayReward_CurSelectCount do
		for _,l in j do
			l:Show()
		end
	end
	for i,j in PayReward_OptionalItemInfo do
		j:SetActionItem(-1)
	end
	for i,j in PayReward_OptionalItemCount do
		j:SetText("")
	end
	for i,j in PayReward_SelectAct do
		j:SetActionItem(-1)
	end
	for i,j in PayReward_SelectCount do
		j:SetText("")
	end
	for i,j in PayReward_SelectIconG do
		j:Hide()
	end
	PayReward_SelectIndex = 0
	PayReward_SelectItemIndex = {0,0,0,0}
	PayReward_SelectGrade = 0
	PayReward_FrameSelectBox:Hide()
	PayReward_Frame:SetProperty("AbsoluteHeight",maxheight);
end
function PayReward_OnHiden()
	for i,j in PayReward_OptionalItemInfo do
		j:SetActionItem(-1)
	end
	for i,j in PayReward_OptionalItemCount do
		j:SetText("")
	end
	for i,j in PayReward_SelectAct do
		j:SetActionItem(-1)
	end
	for i,j in PayReward_SelectCount do
		j:SetText("")
	end
	for _,j in PayReward_CurSelectCount do
		for _,l in j do
			l:SetText("")
		end
	end
	for _,j in PayReward_CurSelectAct do
		for _,l in j do
			l:SetActionItem(-1)
		end
	end
end
function PayReward_SelectClick(index)
	if index == PayReward_SelectIndex then
		return
	end
	if PayReward_SelectGrade == 0 then
		PushDebugMessage("error")
		return
	end
	if RankListInfo[PayReward_SelectGrade][7] and RankListInfo[PayReward_SelectGrade][7] == 2 then
		PushDebugMessage("领取过了!")
		return
	end
	if PayReward_SelectIndex ~= 0 then
		PayReward_SelectIconG[PayReward_SelectIndex]:Hide()
	end
	PayReward_SelectIndex = index
	PayReward_SelectIconG[PayReward_SelectIndex]:Show()
	PushDebugMessage("位置已勾选，请在下方选择一项奖励")
end


function PayReward_AwardClicked(index)
	if index < 1 or index > 8 then return end
	if RankListInfo[index][7] and RankListInfo[index][7] == 2 then
		PushDebugMessage("领取过了!")
		return
	end
	local PlayerSelectItem = {RankListInfo[index][3],RankListInfo[index][4],RankListInfo[index][5],RankListInfo[index][6]}
	for i = 1 ,4 do
		for k = 1 , 4 do
			if i~=k and PlayerSelectItem[i] == PlayerSelectItem[k] then
				PushDebugMessage("无法选择同一件物品!")
				return
			end
		end
	end
	
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("MuDingGetPayReward")
	Set_XSCRIPT_ScriptID(330083)
	Set_XSCRIPT_Parameter(0, tonumber(index) )
	for i=1,4 do
		Set_XSCRIPT_Parameter(i, tonumber(PlayerSelectItem[i]) )
	end
	Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end


function PayReward_OnLoad()
--	CuruiPos = PayReward_Frame:GetProperty("UnifiedPosition")
	PayReward_Istrue = {
		PayReward_AwardShowbk1,
		PayReward_AwardShowbk2,
		PayReward_AwardShowbk3,
		PayReward_AwardShowbk4,
		PayReward_AwardShowbk5,
		PayReward_AwardShowbk6,
		PayReward_AwardShowbk7,
		PayReward_AwardShowbk8,
	};
	PayReward_Need = {
		PayReward_AwardNeed1,
		PayReward_AwardNeed2,
		PayReward_AwardNeed3,
		PayReward_AwardNeed4,
		PayReward_AwardNeed5,
		PayReward_AwardNeed6,
		PayReward_AwardNeed7,
		PayReward_AwardNeed8,
	};
	PayReward_Receive = {
		PayReward_AwardClick1,
		PayReward_AwardClick2,
		PayReward_AwardClick3,
		PayReward_AwardClick4,
		PayReward_AwardClick5,
		PayReward_AwardClick6,
		PayReward_AwardClick7,
		PayReward_AwardClick8,
	};
	PayReward_CurSelectAct = {
		{PayReward_AwardInfo1_1,PayReward_AwardInfo1_2,PayReward_AwardInfo1_3,PayReward_AwardInfo1_4},
		{PayReward_AwardInfo2_1,PayReward_AwardInfo2_2,PayReward_AwardInfo2_3,PayReward_AwardInfo2_4},
		{PayReward_AwardInfo3_1,PayReward_AwardInfo3_2,PayReward_AwardInfo3_3,PayReward_AwardInfo3_4},
		{PayReward_AwardInfo4_1,PayReward_AwardInfo4_2,PayReward_AwardInfo4_3,PayReward_AwardInfo4_4},
		{PayReward_AwardInfo5_1,PayReward_AwardInfo5_2,PayReward_AwardInfo5_3,PayReward_AwardInfo5_4},
		{PayReward_AwardInfo6_1,PayReward_AwardInfo6_2,PayReward_AwardInfo6_3,PayReward_AwardInfo6_4},
		{PayReward_AwardInfo7_1,PayReward_AwardInfo7_2,PayReward_AwardInfo7_3,PayReward_AwardInfo7_4},
		{PayReward_AwardInfo8_1,PayReward_AwardInfo8_2,PayReward_AwardInfo8_3,PayReward_AwardInfo8_4},
	};
	PayReward_CurSelectCount = {
		{PayReward_AwardNum1_1,PayReward_AwardNum1_2,PayReward_AwardNum1_3,PayReward_AwardNum1_4},
		{PayReward_AwardNum2_1,PayReward_AwardNum2_2,PayReward_AwardNum2_3,PayReward_AwardNum2_4},
		{PayReward_AwardNum3_1,PayReward_AwardNum3_2,PayReward_AwardNum3_3,PayReward_AwardNum3_4},
		{PayReward_AwardNum4_1,PayReward_AwardNum4_2,PayReward_AwardNum4_3,PayReward_AwardNum4_4},
		{PayReward_AwardNum5_1,PayReward_AwardNum5_2,PayReward_AwardNum5_3,PayReward_AwardNum5_4},
		{PayReward_AwardNum6_1,PayReward_AwardNum6_2,PayReward_AwardNum6_3,PayReward_AwardNum6_4},
		{PayReward_AwardNum7_1,PayReward_AwardNum7_2,PayReward_AwardNum7_3,PayReward_AwardNum7_4},
		{PayReward_AwardNum8_1,PayReward_AwardNum8_2,PayReward_AwardNum8_3,PayReward_AwardNum8_4},
	};
	PayReward_NotSelect = {
		{PayReward_AwardSAward1_1,PayReward_AwardSAward1_2,PayReward_AwardSAward1_3,PayReward_AwardSAward1_4},
		{PayReward_AwardSAward2_1,PayReward_AwardSAward2_2,PayReward_AwardSAward2_3,PayReward_AwardSAward2_4},
		{PayReward_AwardSAward3_1,PayReward_AwardSAward3_2,PayReward_AwardSAward3_3,PayReward_AwardSAward3_4},
		{PayReward_AwardSAward4_1,PayReward_AwardSAward4_2,PayReward_AwardSAward4_3,PayReward_AwardSAward4_4},
		{PayReward_AwardSAward5_1,PayReward_AwardSAward5_2,PayReward_AwardSAward5_3,PayReward_AwardSAward5_4},
		{PayReward_AwardSAward6_1,PayReward_AwardSAward6_2,PayReward_AwardSAward6_3,PayReward_AwardSAward6_4},
		{PayReward_AwardSAward7_1,PayReward_AwardSAward7_2,PayReward_AwardSAward7_3,PayReward_AwardSAward7_4},
		{PayReward_AwardSAward8_1,PayReward_AwardSAward8_2,PayReward_AwardSAward8_3,PayReward_AwardSAward8_4},
	};
	PayReward_SelectAct = {
		PayReward_SelectInfoOne,PayReward_SelectInfoTwo,PayReward_SelectInfoThree,PayReward_SelectInfoFour
	};
	PayReward_SelectCount = {
		PayReward_SelectNumOne,PayReward_SelectNumTwo,PayReward_SelectNumThree,PayReward_SelectNumFour
	};
	PayReward_SelectIconG = {
		PayReward_SelectGou1,PayReward_SelectGou2,PayReward_SelectGou3,PayReward_SelectGou4
	};
	PayReward_OptionalItemInfo = {
		PayReward_SelectInfo1 ,
		PayReward_SelectInfo2 ,
		PayReward_SelectInfo3 ,
		PayReward_SelectInfo4 ,
		PayReward_SelectInfo5 ,
		PayReward_SelectInfo6 ,
		PayReward_SelectInfo7 ,
		PayReward_SelectInfo8 ,
		PayReward_SelectInfo9 ,
		PayReward_SelectInfo10,
		PayReward_SelectInfo11,
		PayReward_SelectInfo12,
		PayReward_SelectInfo13,
		PayReward_SelectInfo14,
		PayReward_SelectInfo15,
		PayReward_SelectInfo16,
		PayReward_SelectInfo17,
		PayReward_SelectInfo18,
		PayReward_SelectInfo19,
		PayReward_SelectInfo20,
		PayReward_SelectInfo21,
		PayReward_SelectInfo22,
		PayReward_SelectInfo23,
		PayReward_SelectInfo24,
		PayReward_SelectInfo25,
		PayReward_SelectInfo26,
		PayReward_SelectInfo27,
		PayReward_SelectInfo28,
		PayReward_SelectInfo29,
		PayReward_SelectInfo30,
	};
	PayReward_OptionalItemCount = {
		PayReward_SelectNum1 ,
		PayReward_SelectNum2 ,
		PayReward_SelectNum3 ,
		PayReward_SelectNum4 ,
		PayReward_SelectNum5 ,
		PayReward_SelectNum6 ,
		PayReward_SelectNum7 ,
		PayReward_SelectNum8 ,
		PayReward_SelectNum9 ,
		PayReward_SelectNum10,
		PayReward_SelectNum11,
		PayReward_SelectNum12,
		PayReward_SelectNum13,
		PayReward_SelectNum14,
		PayReward_SelectNum15,
		PayReward_SelectNum16,
		PayReward_SelectNum17,
		PayReward_SelectNum18,
		PayReward_SelectNum19,
		PayReward_SelectNum20,
		PayReward_SelectNum21,
		PayReward_SelectNum22,
		PayReward_SelectNum23,
		PayReward_SelectNum24,
		PayReward_SelectNum25,
		PayReward_SelectNum26,
		PayReward_SelectNum27,
		PayReward_SelectNum28,
		PayReward_SelectNum29,
		PayReward_SelectNum30,
	};
	
end