
local g_Levelup_TopList_Position = nil
local g_BranchingScene  = {}
local g_Levelup_TopListRankType = {}
local g_Levelup_TopListRedPoint = {}
local g_CurRankType = 1

local g_Levleup_ButtonCDTime = 3; --??????
local g_Levleup_ButtonLastTime = 0;
local g_Levelup_MessageType = 0

local g_LevelUp_TopListBk = {
	[1] = "set:Levelup_TopList image:Levelup_TopList1",			--???
	[2] = "set:Levelup_TopList image:Levelup_TopList2",			--???
	[3] = "set:Levelup_TopList image:Levelup_TopList3",			--???
	}


local g_LevelUpInfo =
{
	[1] = {name = "#{TXLY_240904_2}"},
	[2] = {name = "#{TXLY_240904_3}"},
	[3] = {name = "#{TXLY_240904_4}"},
	[4] = {name = "#{TXLY_240904_5}"},
	[5] = {name = "#{TXLY_240904_6}"},
}

--=========
-- PreLoad()
--=========
function Levelup_TopList_PreLoad()

	this:RegisterEvent("UI_COMMAND", true)--??or????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("OPEN_NORMAL_RANK_LIST",true)
	this:RegisterEvent("UPDATE_NORMAL_RANK_RED_POINT",true)
end

--=========
-- OnLoad()
--=========
function Levelup_TopList_OnLoad()
	g_Levelup_TopList_Position = Levelup_TopList_Frame:GetProperty("UnifiedPosition")	

	g_Levelup_TopListRankType[1] = Levelup_TopList_Rank1
	g_Levelup_TopListRankType[2] = Levelup_TopList_Rank2
	g_Levelup_TopListRankType[3] = Levelup_TopList_Rank3
	g_Levelup_TopListRankType[4] = Levelup_TopList_Rank4
	g_Levelup_TopListRankType[5] = Levelup_TopList_Rank5


	g_Levelup_TopListRedPoint[1] = Levelup_TopList_Rank1_Tips
	g_Levelup_TopListRedPoint[2] = Levelup_TopList_Rank2_Tips
	g_Levelup_TopListRedPoint[3] = Levelup_TopList_Rank3_Tips
	g_Levelup_TopListRedPoint[4] = Levelup_TopList_Rank4_Tips
	g_Levelup_TopListRedPoint[5] = Levelup_TopList_Rank5_Tips


end

--=========
-- Event
--=========
function Levelup_TopList_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 999494001) then
		if this:IsVisible() then
			Levelup_TopList_UpMainRedPoint()
			Levelup_TopList_UpRedPoint(g_CurRankType) --?????????
		end
	elseif event == "OPEN_NORMAL_RANK_LIST" then
		g_CurRankType = tonumber(arg0)
		g_Levelup_MessageType = tonumber(arg1)
		Levelup_TopList_Ranking_Update(g_CurRankType)
	elseif event == "HIDE_ON_SCENE_TRANSED" then
		Levelup_TopList_Close()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		Levelup_TopList_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		Levelup_TopList_On_ResetPos()
	elseif event == "UPDATE_NORMAL_RANK_RED_POINT" then
		Levelup_TopList_UpMainRedPoint()
		if this:IsVisible() then
			Levelup_TopList_UpRedPoint(g_CurRankType) --?????????
		end
	end
end

--=========
-- 重置
--=========
function Levelup_TopList_On_ResetPos()
	Levelup_TopList_Frame:SetProperty("UnifiedPosition", g_Levelup_TopList_Position)
end

--更换榜单
function Levelup_TopList_Rank_Click(nRankType)
	DataPool:lua_UpdateNormalRankInfo(nRankType+1)
	PushEvent("CLOSE_NORMAL_RANK_REWARD", nRankType)
end	

--=========
-- 打开
--=========
function Levelup_TopList_Ranking_Update( rankType)

	--local StrValue = ScriptGlobal_Format("#{TXLY_240904_17}",g_LevelUpInfo[rankType].name )
	--Levelup_TopList_Awards:SetText(StrValue)

	local StrValue = ScriptGlobal_Format("#{TXLY_240904_18}",g_LevelUpInfo[rankType].name )
	Levelup_TopList_Awards:SetToolTip(StrValue)

	local nMonth, nDay = DataPool:lua_GetNormalRankingStopTime(rankType)
	StrValue = ScriptGlobal_Format("#{TXLY_240904_59}",nMonth,nDay)
	Levelup_TopList_TimeText:SetText(StrValue)

	local nServerType = DataPool:lua_GetRankServerType()
	if nServerType == 0 then
		Levelup_TopList_Info:SetText("#{TXLY_240904_85}")
	else
		local nStartTime, nEndTime,nRewardEnd =  DataPool:lua_GetNormalRankGetRankTime(rankType)
		local nStartData =  math.mod(nStartTime,10000)
		local nStartYear =  math.floor(nStartTime/10000)
		local nStartMonth = math.floor(nStartData/100)
		local nStartDay = math.mod(nStartData,100)

		local nEndData =  math.mod(nEndTime,10000)
		local nEndMonth = math.floor(nEndData/100)
		local nEndDay = math.mod(nEndData,100)

		StrValue = ScriptGlobal_Format("#{TXLY_240904_53}", nStartYear,nStartMonth,nStartDay,nEndMonth,nEndDay)
		Levelup_TopList_Info:SetText(StrValue)
	end

	local nInsert, nreward,nMyrank  = DataPool:lua_GetNormalRankPlayerRewardInfo(rankType)

	-- 更新选择
	Levelup_TopList_Rank_Init(rankType)

	-- 更新红点
	Levelup_TopList_UpRedPoint(rankType)

	Levelup_TopList_List:Clear()
	local nMaxCount = DataPool:lua_GetNormalRankingMaxRankNum(rankType)
	local dataCnt = DataPool:lua_GetNormalRankListCount(rankType)
	for index=0, nMaxCount-1 do 
		if index < dataCnt then
			Levelup_TopList_AddRecord(rankType, index,nMyrank )
		else
			Levelup_TopList_AddEmptyRecord(rankType,index)
		end	
	end

	g_Levelup_MessageType = 0
	this:Show()
end

-- 更新选择
function Levelup_TopList_Rank_Init( rankType )

	for index=1, table.getn(g_Levelup_TopListRankType) do
		if g_Levelup_TopListRankType[index] ~= nil then
			g_Levelup_TopListRankType[index]:SetCheck(0)
		end
	end

	g_Levelup_TopListRankType[rankType]:SetCheck(1)
end

-- 添加一行数据
function Levelup_TopList_AddRecord(rankType,  index ,nMyrank)
	local nRank, name,nguid, menpai, ntime = DataPool:lua_GetNormalRankListInfo(rankType, index);
	if nRank == nil then
		return
	end
			
	local ItemBar = Levelup_TopList_List:AddChild( "Levelup_TopList_ListInfoBK")
	if ItemBar == nil then
		return 
	end

	--名次
	local numButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListNumber")
	local StrValue = ScriptGlobal_Format("#{TXLY_240904_58}", nRank)
	numButton:SetText(StrValue)

	local ImageButton = ItemBar:GetSubItem("Levelup_TopList_ListNumBK")
	if ImageButton ~= nil then
		if g_LevelUp_TopListBk[index+1] ~= nil then
			ImageButton:SetProperty("Image",g_LevelUp_TopListBk[nRank])
			numButton:Hide()
		else
			ImageButton:SetProperty("Image","")
		end
	end

	
	local NotInButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListNot")
	NotInButton:Hide()

	--名字
	local nameButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListName")
	StrValue = ScriptGlobal_Format("#{TXLY_240904_58}", name)
	nameButton:SetText(StrValue)

	-- 闪图
	local AnimateButton= ItemBar:GetSubItem("Levelup_TopList_ListItem_ListName_Animate")
	if g_Levelup_MessageType == 1  and  nMyrank == index +1 then
		AnimateButton:Show()
	else
		AnimateButton:Hide()
	end

	--门派
	local menpaiButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListSchool")
	StrValue = ScriptGlobal_Format("#{TXLY_240904_58}", DataPool:GetMenPaiName(menpai))
	menpaiButton:SetText(StrValue)

	--上榜时间
	local timeButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListTime")

	local nMonth = math.floor(ntime/100000000)
	local nData = math.mod(ntime,100000000)
	local nDay = math.floor(nData/1000000)
	nData = math.mod(nData,1000000)
	local nHour = math.floor(nData/10000)
	nData = math.mod(nData,10000)
	local nMinute = math.floor(nData/100)
	nData =  math.mod(nData,100)

	StrValue = ScriptGlobal_Format("#{TXLY_240904_57}", nMonth,nDay,nHour,nMinute,nData)
	timeButton:SetText(StrValue)

	--详情按钮
	local SubButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListBtn")
	SubButton:SetEvent("Clicked", string.format("Levelup_TopList_ListItem_ListBtn_Click(%d)", index))
	SubButton:Show()
end

--添加繝行
function Levelup_TopList_AddEmptyRecord(rankType,  index )		
	local ItemBar = Levelup_TopList_List:AddChild( "Levelup_TopList_ListInfoBK")
	if ItemBar == nil then
		return 
	end

	
	--名次
	local numButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListNumber")
	numButton:SetText(index+1)

	local ImageButton = ItemBar:GetSubItem("Levelup_TopList_ListNumBK")
	if ImageButton ~= nil then
		if g_LevelUp_TopListBk[index+1] ~= nil then
			ImageButton:SetProperty("Image",g_LevelUp_TopListBk[index+1])
			numButton:Hide()
		else
			ImageButton:SetProperty("Image","")
		end
	end		

	local NotInButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListNot")
	NotInButton:Show()

	--名字
	local nameButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListName")
	nameButton:Hide()
	--nameButton:SetText("")

	-- 闪图
	local AnimateButton= ItemBar:GetSubItem("Levelup_TopList_ListItem_ListName_Animate")
	AnimateButton:Hide()

	--门派
	local menpaiButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListSchool")
	--menpaiButton:SetText("")
	menpaiButton:Hide()

	--上榜时间
	local timeButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListTime")
	--timeButton:SetText("")
	timeButton:Hide()

	--详情按钮
	local SubButton = ItemBar:GetSubItem("Levelup_TopList_ListItem_ListBtn")
	SubButton:Hide()
end

--=========
-- 问号帮助
--=========
function Levelup_TopList_Help_Click()

	local nServerType = DataPool:lua_GetRankServerType()
	if nServerType == 0 then
		PushEvent("CCSHOP_HELP", 28)
	else
		PushEvent("CCSHOP_HELP", 27,g_CurRankType)
	end
end

--=========
-- Close
--=========
function Levelup_TopList_Close()
	PushEvent("CLOSE_NORMAL_RANK_REWARD", g_CurRankType)
	this:Hide()
end

-- 奖励预览
function Levelup_TopList_Sign_Click()
	PushEvent("OPEN_NORMAL_RANK_REWARD", g_CurRankType)
end  

-- 刷新
function Levelup_TopList_Refresh_Click()
	local curTime = OSAPI:GetTickCount();
	if ( curTime - g_Levleup_ButtonLastTime < g_Levleup_ButtonCDTime * 1000) then 
   	    PushDebugMessage("#{TXLY_240904_14}"); --??????,?????????
		return
	end
	g_Levleup_ButtonLastTime = curTime;
	
	DataPool:lua_UpdateNormalRankInfo(g_CurRankType)
end

-- 更新红点
function Levelup_TopList_UpRedPoint(rankType)
	Levelup_TopList_Awards_Tips:Hide()
	for i = 1, 5 do 
		local nInsert, nreward,nIndex = DataPool:lua_GetNormalRankPlayerRewardInfo(i)
		if nInsert ~= 0 and nreward ~= 1 then
			g_Levelup_TopListRedPoint[i]:Show()
			if i == rankType then
				Levelup_TopList_Awards_Tips:Show()
			end
		else
			g_Levelup_TopListRedPoint[i]:Hide()
		end
	end
end

-- 更新主界面红点
function Levelup_TopList_UpMainRedPoint(rankType)

	local nShow = Lua_IsShowQuickEnterPointTip(32) 
	for i = 1, 5 do 
		local nInsert, nreward,nIndex = DataPool:lua_GetNormalRankPlayerRewardInfo(i)
		if nInsert ~= 0 and nreward ~= 1 then
			if nShow == 0 then
				Lua_ShowQuickEnterPointTip(32,1)
			end
			return
		end
	end

	if nShow == 1 then
		Lua_ShowQuickEnterPointTip(32,0)
	end
end

function Levelup_TopList_ListItem_ListBtn_Click(index)

	local nRank, name,nguid, menpai, ntime = DataPool:lua_GetNormalRankListInfo(g_CurRankType, index);
	if nRank == nil then
		return
	end

	if( Friend:IsPlayerIsFriend( name ) == 1 ) then	
		DataPool:ShowFriendInfo( name )
	else
		DataPool:ShowChatInfo( name )
	end

end	
