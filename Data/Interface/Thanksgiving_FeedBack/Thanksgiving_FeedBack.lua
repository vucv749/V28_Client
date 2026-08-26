
local g_Thanksgiving_FeedBack_UnifiedPosition
local g_Thanksgiving_FeedBack_RewardUITalbe = {}
local g_Thanksgiving_FeedBack_DayNum = 7
local g_Thanksgiving_MaxDianShu = 3

local g_Thanksgiving_DianShu = 0
local g_Thanksgiving_RewardInfo = 0
local g_Thanksgiving_NeedCountTime = 120 * 60

local g_Thanksgiving_FeedBack_Reward = 
{
	[1] ={id=20800013, num =6},
	[2] ={id=20600002, num =1},
	[3] ={id=38003677, num =5},
	[4] ={id=10125059, num =1},
	[5] ={id=38002519, num =1},
	[6] ={id=10142002, num =1},
	[7] ={id=38003164, num =1},
}
local g_Thanksgiving_FeedBack_Reward_OriginalHJ = 
{
	[1] ={id=30700241, num =3},
	[2] ={id=39920018, num =1},
	[3] ={id=30503140, num =3},
	[4] ={id=10125059, num =1},
	[5] ={id=39920017, num =1},
	[6] ={id=10142002, num =1},
	[7] ={id=38003617, num =1},
}

function Thanksgiving_FeedBack_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )	
	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" )
	this:RegisterEvent( "HIDE_ON_SCENE_TRANSED" )	
	this:RegisterEvent( "ADJEST_UI_POS" )
end

function Thanksgiving_FeedBack_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2025101701 then
		local isOpen = Get_XParam_INT(0)
		g_Thanksgiving_DianShu = Get_XParam_INT(1)
		g_Thanksgiving_RewardInfo = Get_XParam_INT(2)
		g_Thanksgiving_NeedCountTime = Get_XParam_INT(3)
		if isOpen == 1 then
			SetTimer("Thanksgiving_FeedBack","Thanksgiving_FeedBack_OnTimer()", 1000);--计时
			this:Show()
		end
		Thanksgiving_FeedBack_Refresh()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Thanksgiving_FeedBack_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Thanksgiving_FeedBack_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Thanksgiving_FeedBack_Close()
	end
end

--获取奖励情况 0未激活 1已激活可领取 2已经领取 
function Thanksgiving_FeedBack_GetRewardInfo(nIndex)
    local nMD = g_Thanksgiving_RewardInfo
    local CurCount = 1
	if nIndex == 1 then
		CurCount = math.mod(nMD,10)
	elseif nIndex == 2 then
		CurCount = math.mod(tonumber(math.floor(nMD/10)),10)
	elseif nIndex == 3 then
        CurCount = math.mod(tonumber(math.floor(nMD/100)),10)
    elseif nIndex == 4 then
        CurCount = math.mod(tonumber(math.floor(nMD/1000)),10)
    elseif nIndex == 5 then
        CurCount = math.mod(tonumber(math.floor(nMD/10000)),10)
    elseif nIndex == 6 then
        CurCount = math.mod(tonumber(math.floor(nMD/100000)),10)
    elseif nIndex == 7 then
		CurCount = math.mod(tonumber(math.floor(nMD/1000000)),10)
	end
    return CurCount 
end

--1打卡 2稳活 3活跃值200 4活跃值500   X/X/X/X
function Thanksgiving_FeedBack_IfDianShuGot(nType)
    local nMD = g_Thanksgiving_DianShu
	local CurCount = 1
	if nType == 1 then
		CurCount = math.mod(nMD,10)
	elseif nType == 2 then
		CurCount = math.mod(tonumber(math.floor(nMD/10)),10)
	elseif nType == 3 then
        CurCount = math.mod(tonumber(math.floor(nMD/100)),10)
    elseif nType == 4 then
		CurCount = math.mod(tonumber(math.floor(nMD/1000)),10)
	end
    return CurCount 
end

--1打卡 2稳活 3活跃值200 4活跃值500    X/X/X/X
function Thanksgiving_FeedBack_GetTotleDianShu()
    local nDianShu = 0
    local nMD = g_Thanksgiving_DianShu
    if math.mod(nMD,10) == 1 then
        nDianShu = nDianShu +1
    end
    if math.mod(tonumber(math.floor(nMD/10)),10) == 1 then
        nDianShu = nDianShu +1
    end
    if math.mod(tonumber(math.floor(nMD/100)),10) == 1 then
        nDianShu = nDianShu +1
    end
    if math.mod(tonumber(math.floor(nMD/1000)),10) == 1 then
        nDianShu = nDianShu +1
	end
	if nDianShu > g_Thanksgiving_MaxDianShu then
		nDianShu = g_Thanksgiving_MaxDianShu
	end
    return nDianShu
end

function Thanksgiving_FeedBack_Refresh()
	Thanksgiving_FeedBack_FinshFrame_1_OK:Hide()
	if g_Thanksgiving_NeedCountTime<= 0 then
		Thanksgiving_FeedBack_FinshFrame_1_OK:Show()
	end
	Thanksgiving_FeedBack_FinshFrame_2_OK:Hide()
	Thanksgiving_FeedBack_RuleText_2:SetText(ScriptGlobal_Format("#{JSQH_20250929_8}",Thanksgiving_FeedBack_GetTotleDianShu()))
	if Thanksgiving_FeedBack_GetTotleDianShu() >= g_Thanksgiving_MaxDianShu then
		Thanksgiving_FeedBack_FinshFrame_2_OK:Show()
	end
	if Thanksgiving_FeedBack_IfDianShuGot(1) == 1 then
		Thanksgiving_FeedBack_ListFinish_1:Show()
		Thanksgiving_FeedBack_GoButton1:Hide()
	else
		Thanksgiving_FeedBack_ListFinish_1:Hide()
		Thanksgiving_FeedBack_GoButton1:Show()
	end
	if Thanksgiving_FeedBack_IfDianShuGot(2) == 1 then
		Thanksgiving_FeedBack_ListFinish_2:Show()
		Thanksgiving_FeedBack_GoButton2:Hide()
	else
		Thanksgiving_FeedBack_ListFinish_2:Hide()
		Thanksgiving_FeedBack_GoButton2:Show()
	end
	if Thanksgiving_FeedBack_IfDianShuGot(3) == 1 then
		Thanksgiving_FeedBack_ListFinish_3:Show()
		Thanksgiving_FeedBack_GoButton3:Hide()
	else
		Thanksgiving_FeedBack_ListFinish_3:Hide()
		Thanksgiving_FeedBack_GoButton3:Show()
	end
	if Thanksgiving_FeedBack_IfDianShuGot(4) == 1 then
		Thanksgiving_FeedBack_ListFinish_4:Show()
		Thanksgiving_FeedBack_GoButton4:Hide()
	else
		Thanksgiving_FeedBack_ListFinish_4:Hide()
		Thanksgiving_FeedBack_GoButton4:Show()
	end

	local nRewardData = g_Thanksgiving_FeedBack_Reward
	if Player:GetData("IsOriginalHJ") == 1 then
		nRewardData = g_Thanksgiving_FeedBack_Reward_OriginalHJ
	end

	local nHaveGotNum = 0
	for i =1, g_Thanksgiving_FeedBack_DayNum do
		local theAction = DataPool:CreateBindActionItemForShow(nRewardData[i].id, nRewardData[i].num) 
		if (theAction:GetID() ~= 0) then
			g_Thanksgiving_FeedBack_RewardUITalbe[i].RewardBtn:SetActionItem(theAction:GetID())  
		end 
		g_Thanksgiving_FeedBack_RewardUITalbe[i].HaveGotMark:Hide()
		g_Thanksgiving_FeedBack_RewardUITalbe[i].CanGetAnimate:Hide()
		if Thanksgiving_FeedBack_GetRewardInfo(i) == 2 then
			g_Thanksgiving_FeedBack_RewardUITalbe[i].HaveGotMark:Show()
			nHaveGotNum = nHaveGotNum + 1
		end
		if Thanksgiving_FeedBack_GetRewardInfo(i) == 1 then
			g_Thanksgiving_FeedBack_RewardUITalbe[i].CanGetAnimate:Show()
		end
	end 

	if nHaveGotNum >= g_Thanksgiving_FeedBack_DayNum then
		Thanksgiving_FeedBack_RuleInfo1:Hide()
		Thanksgiving_FeedBack_RuleInfo2:Show()
	else
		Thanksgiving_FeedBack_RuleInfo1:Show()
		Thanksgiving_FeedBack_RuleInfo2:Hide()
	end

	local needTime = g_Thanksgiving_NeedCountTime
	local showmin = math.floor(needTime/60)
	local showsec = math.mod(needTime,60)

	local showhour = math.floor(showmin/60)
	showmin = math.mod(showmin,60)

	local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
	Thanksgiving_FeedBack_RuleText_1:SetText(ScriptGlobal_Format("#{JSQH_20250929_7}",nStr))

end

function Thanksgiving_FeedBack_OnTimer()
	g_Thanksgiving_NeedCountTime = g_Thanksgiving_NeedCountTime - 1
	if g_Thanksgiving_NeedCountTime<=0 then
		g_Thanksgiving_NeedCountTime = 0
		Thanksgiving_FeedBack_FinshFrame_1_OK:Show()
		KillTimer("Thanksgiving_FeedBack_OnTimer()")
	end
	local needTime = g_Thanksgiving_NeedCountTime
	local showmin = math.floor(needTime/60)
	local showsec = math.mod(needTime,60)

	local showhour = math.floor(showmin/60)
	showmin = math.mod(showmin,60)

	local nStr = string.format("%02d:%02d:%02d", showhour, showmin, showsec)
	Thanksgiving_FeedBack_RuleText_1:SetText(ScriptGlobal_Format("#{JSQH_20250929_7}",nStr))
end

function Thanksgiving_FeedBack_Clicked(nIndex)
	if nIndex < 1 or nIndex > 4 then
		return
	end
	local myLevel = Player:GetData("LEVEL")
	if myLevel < 30 then
		PushDebugMessage( "#{JSQH_20250929_23}" )
		return
	end
	if nIndex == 1 or nIndex == 2 then
		AutoRuntoTargetExWithName(177, 98, 0, "阿呜")
	end
	if nIndex == 3 or nIndex == 4 then
		Clear_XSCRIPT()		
			Set_XSCRIPT_Function_Name("OpenZhouHuoYue")
			Set_XSCRIPT_ScriptID(999927)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
end

function Thanksgiving_FeedBack_PrizeClicked(nIndex)
	if nIndex < 1 or nIndex > 7 then
		return
	end
	Clear_XSCRIPT()		
		Set_XSCRIPT_Function_Name("GetReward")
		Set_XSCRIPT_ScriptID(999927)
		Set_XSCRIPT_Parameter(0, nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Thanksgiving_FeedBack_OnClickHelp()
	if Player:GetData("IsOriginalHJ") == 1 then 
		PushEvent("QUEST_HELPINFO", "#{JSQH_20250929_25}")
	else
		PushEvent("QUEST_HELPINFO", "#{JSQH_20250929_24}")
	end
	
end

function Thanksgiving_FeedBack_On_ResetPos()
	Thanksgiving_FeedBack_Frame:SetProperty("UnifiedPosition", g_Thanksgiving_FeedBack_UnifiedPosition)
end

function Thanksgiving_FeedBack_Close()
	KillTimer("Thanksgiving_FeedBack_OnTimer()")
	this:Hide()
end

function Thanksgiving_FeedBack_OnLoad()
	g_Thanksgiving_FeedBack_UnifiedPosition = Thanksgiving_FeedBack_Frame:GetProperty("UnifiedPosition")

	g_Thanksgiving_FeedBack_RewardUITalbe = 
	{
		[1]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_1,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_1_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_1_Mark,
		},
		[2]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_2,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_2_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_2_Mark,
		},
		[3]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_3,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_3_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_3_Mark,
		},
		[4]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_4,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_4_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_4_Mark,
		},
		[5]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_5,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_5_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_5_Mark,
		},
		[6]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_6,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_6_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_6_Mark,
		},
		[7]={
			RewardBtn = Thanksgiving_FeedBack_Reward1_7,
			CanGetAnimate = Thanksgiving_FeedBack_Reward1_7_Tips,
			HaveGotMark = Thanksgiving_FeedBack_Reward1_7_Mark,
		},
	}

end