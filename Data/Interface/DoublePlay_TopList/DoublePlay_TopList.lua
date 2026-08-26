-------排行榜
-------!!!reloadscript =DoublePlay_TopList

local g_DoublePlay_TopList_Frame_UnifiedXPosition;
local g_DoublePlay_TopList_Frame_UnifiedYPosition;

local g_MaxPlayer = 50
local g_NeedLevel = 30
local g_TargetId = -1
local g_nType = -1
local g_State = -1

local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --少林
		[1] = "#{XQ_MP_2}",    --明教
		[2] = "#{XQ_MP_3}",    --丐帮
		[3] = "#{XQ_MP_4}",    --武当
		[4] = "#{XQ_MP_5}",    --峨眉
		[5] = "#{XQ_MP_6}",    --星宿
		[6] = "#{XQ_MP_7}",    --天龙
		[7] = "#{XQ_MP_8}",    --天山
		[8] = "#{XQ_MP_9}",    --逍遥
		[9] = "",         --无门派
		[10] = "#{MPDYR_20220427_190}",    --曼陀
}

local g_relationtext = {
	[0] = "#{SRPK_230331_284}",
	[1] = "#{SRPK_230331_282}",
	[2] = "#{SRPK_230331_283}",
}

function DoublePlay_TopList_PreLoad()
	--
	this:RegisterEvent("OPEN_DOUBLE_XIUXIAN_RANKINGLIST");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function DoublePlay_TopList_OnLoad()
	--
	g_DoublePlay_TopList_Frame_UnifiedXPosition	= DoublePlay_TopList_MainFrame : GetProperty("UnifiedXPosition");
	g_DoublePlay_TopList_Frame_UnifiedYPosition	= DoublePlay_TopList_MainFrame : GetProperty("UnifiedYPosition");
	
end

function DoublePlay_TopList_OnEvent(event)

	if (event=="OPEN_DOUBLE_XIUXIAN_RANKINGLIST") then 
	
		g_nType = tonumber(arg0)
		DoublePlay_TopList_BeginCareObject( tonumber(arg1) )
		DoublePlay_TopList_Update()	
		this : Show()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		DoublePlay_TopList_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		DoublePlay_TopList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		DoublePlay_TopList_Frame_On_ResetPos()
		
	end
end


function DoublePlay_TopList_Update()	

	DoublePlay_TopList_RecordInfo()	
	DoublePlay_TopList_PrizeInfo()
	
end


function DoublePlay_TopList_Init( )
	
	DoublePlay_TopList:Clear()
	
end


function DoublePlay_TopList_RecordInfo( )
		
	DoublePlay_TopList_Init( )
	
	local dataCnt = DataPool:lua_GetJSRankingListDataCount( g_nType )
	for index=0, g_MaxPlayer-1 do
		if index < dataCnt then
			DoublePlay_TopList_HaveRecord( index )
		else
			DoublePlay_TopList_NoRecord( index )
		end
	end
	
end


function DoublePlay_TopList_HaveRecord( index )
	local nRank, name, score, state = DataPool:lua_GetJSRankingListInfo(g_nType, index);
	if nRank == nil then
		return
	end
			
	local ItemBar = DoublePlay_TopList:AddChild( "DoublePlay_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("DoublePlay_TopList_ItemBK")
	teamBKButton:Show()
	--local teamBKImage = ItemBar:GetSubItem("DoublePlay_TopList_ItemBKImage")
	--teamBKImage:Show()
	--teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK1")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("DoublePlay_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("DoublePlay_TopList_Number")
		numButton:SetText(index+1)
	else
		local numImageButton = ItemBar:GetSubItem("DoublePlay_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("DoublePlay_TopList_Number")
		numButton:SetText(index+1)
	end
		
	--队员
	local noTeamButton = ItemBar:GetSubItem("DoublePlay_TopList_TeamNull")
	noTeamButton:Hide()
	
	local teamButton = ItemBar:GetSubItem("DoublePlay_TopList_Team")
	teamButton:Show()
	
	local mennum = 0
	for j = 1,2 do
		local bValid, memguid, memname, menpai, level = DataPool:lua_GetJSRankingListMemberInfo(g_nType, index, j-1);
		local nZoneWorldId = DataPool:lua_GetJSRankingListParam(g_nType, index, 1+j);
		
		if bValid ~= nil and bValid == 1 then
			local world_name = DataPool:GetServerName(tonumber(nZoneWorldId))
			memname = memname .."@"..tostring(world_name)
			DoublePlay_TopList_HaveMember( ItemBar, j, memname, menpai, level )

			mennum = j
		else
			DoublePlay_TopList_NoMember( ItemBar, j )
		end
	end
	--关系
	local relation = DataPool:lua_GetJSRankingListParam(g_nType, index, 1);
	if relation < 0 or relation > 2 then
		relation = 0
	end
	ItemBar:GetSubItem("DoublePlay_TopList_Relation"):SetText(g_relationtext[relation])
	--分数
	local timeButton = ItemBar:GetSubItem("DoublePlay_TopList_Num")
	timeButton:SetText(ScriptGlobal_Format("#{SRWF_230329_95}",score))
end


function DoublePlay_TopList_NoRecord( index )
	local ItemBar = DoublePlay_TopList:AddChild( "DoublePlay_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("DoublePlay_TopList_ItemBK")
	teamBKButton:Show()
	--local teamBKImage = ItemBar:GetSubItem("DoublePlay_TopList_ItemBKImage")
	--teamBKImage:Show()
	--teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK2")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("DoublePlay_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("DoublePlay_TopList_Number")
		numButton:SetText(index+1)
	else
		local numImageButton = ItemBar:GetSubItem("DoublePlay_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("DoublePlay_TopList_Number")
		numButton:SetText(index+1)
	end
	
	--队员
	local noTeamButton = ItemBar:GetSubItem("DoublePlay_TopList_TeamNull")
	noTeamButton:Show()
	
	local teamButton = ItemBar:GetSubItem("DoublePlay_TopList_Team")
	teamButton:Hide()
	
end


function DoublePlay_TopList_HaveMember( ItemBar, index, memname, menpai, level )
	local szMember = string.format( "DoublePlay_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Show()
	
	local szName = string.format( "DoublePlay_TopList_Name%d", index )
	local nameButton = ItemBar:GetSubItem(szName)
	nameButton:SetText("#cfff263"..memname)
	
	local szMenPai = string.format( "DoublePlay_TopList_School%d", index )
	local menpaiButton = ItemBar:GetSubItem(szMenPai)
	menpaiButton:SetText( "#cfff263"..g_MenPaiName[menpai] )
	
	local szLevel = string.format( "DoublePlay_TopList_Level%d", index )
	local LevelButton = ItemBar:GetSubItem(szLevel)
	LevelButton:SetText( "#cfff263"..tostring(level)  )

	--if index ~= 1 then
	--	local nullteam = string.format( "DoublePlay_TopList_TeamNull%d", index )
	--	local nullteamButton = ItemBar:GetSubItem(nullteam)
	--	nullteamButton:Hide()
	--end
end


function DoublePlay_TopList_NoMember( ItemBar, index )
	local szMember = string.format( "DoublePlay_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Hide()

	--if index ~= 1 then
	--	local nullteam = string.format( "DoublePlay_TopList_TeamNull%d", index )
	--	local nullteamButton = ItemBar:GetSubItem(nullteam)
	--	nullteamButton:Show()
	--end
end

--	RankingListData_DB_DataStatus_Free,
--	RankingListData_DB_DataStatus_Ranking,
--	RankingListData_DB_DataStatus_Settle,
function DoublePlay_TopList_PrizeInfo()
	local nRank,name,score,state = DataPool:lua_GetJSRankingListInfo(g_nType,0)
	g_State = state

	local myRank = -1
	local myRankTime = 0

	local nDataCount = DataPool:lua_GetJSRankingListDataCount(g_nType)
	if nDataCount > 0 then
		for i = 0, nDataCount-1 do
			local nRank,name,score,state = DataPool:lua_GetJSRankingListInfo(g_nType,i)
			for j = 1,2 do
				local bValid, memguid, membname,menpai,level = DataPool:lua_GetJSRankingListMemberInfo(g_nType,i,j-1);
				if bValid == 1 and myRank < 0 then
					if memguid == Player:GetGUID() then
						myRank = nRank
						myRankTime = score

						break
					end
				end
			end

			if myRank ~= -1 then
				break
			end
		end
	end

	if myRank == -1 then
		DoublePlay_TopList_ReachTop:SetText("#{SRWF_230329_101}")
		DoublePlay_TopList_ReachTop:Show()
	else
		DoublePlay_TopList_ReachTop:SetText(ScriptGlobal_Format("#{SRWF_230329_100}",myRank+1))
		DoublePlay_TopList_ReachTop:Show()
	end

	--显示绑定关系和分数
	local myscore, scoretype, bindname = DataPool:lua_GetDoubleRankingListMyvalue(g_nType)
	if myscore == nil or bindname == nil then
		DoublePlay_TopList_ReachNum:SetText("#{SRWF_230329_215}")
		DoublePlay_TopList_ReachNum:Show()
	else
		if bindname ~= "" then
			DoublePlay_TopList_ReachNum:SetText(ScriptGlobal_Format("#{SRWF_230329_216}",bindname,myscore))
			DoublePlay_TopList_ReachNum:Show()
		else
			DoublePlay_TopList_ReachNum:SetText("#{SRWF_230329_215}")
			DoublePlay_TopList_ReachNum:Show()
		end

	end

	--未结算时显示
	if state == 0 or state == 1 then 
		DoublePlay_TopList_MyNumber:SetText("#{SRWF_230329_105}")
		DoublePlay_TopList_Btn:Disable()
		return
	end

	local myuset, myrewardflag = DataPool:lua_GetJSRankingListMyInfo(g_nType)

	DoublePlay_TopList_ReachNum:Hide()
	DoublePlay_TopList_ReachTop:Hide()
	
	--已结算
	if myRank < 0 then
		DoublePlay_TopList_MyNumber:SetText("#{SRWF_230329_106}")
		DoublePlay_TopList_Btn:Disable()
		return
	else
		if myrewardflag == 0 then
			local msg = ScriptGlobal_Format("#{SRWF_230329_102}", myRank+1)
			DoublePlay_TopList_MyNumber:SetText(msg)
			DoublePlay_TopList_Btn:Enable()
		else
			local msg = ScriptGlobal_Format("#{SRWF_230329_103}", myRank+1)
			DoublePlay_TopList_MyNumber:SetText(msg)
			DoublePlay_TopList_Btn:Disable()
		end
		
		return
	end
	
end


--领奖
function DoublePlay_TopList_Prize_Click( )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{SRWF_230329_115}")
		return
	end
	
	DataPool : lua_GetJSRankingListGetReward(g_nType)
	
end


function DoublePlay_TopList_Preview_Click()
	PushEvent("OPEN_DOUBLE_XIUXIAN_RANKINGLIST_REWARD", g_nType, g_TargetId)
end


function DoublePlay_TopList_Frame_On_ResetPos()

	DoublePlay_TopList_MainFrame : SetProperty("UnifiedXPosition", g_DoublePlay_TopList_Frame_UnifiedXPosition);
	DoublePlay_TopList_MainFrame : SetProperty("UnifiedYPosition", g_DoublePlay_TopList_Frame_UnifiedYPosition);

end


function DoublePlay_TopList_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{SRWF_230329_89}")
end


function DoublePlay_TopList_Close()
	if(IsWindowShow("DoublePlay_TopListAward")) then
		CloseWindow("DoublePlay_TopListAward", true)
	end 
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function DoublePlay_TopList_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		DoublePlay_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "DoublePlay_TopList" )
end

function DoublePlay_TopList_FormatTime(nSec)
	local min = math.floor(nSec/60)
	local sec = math.mod(nSec,60)
	
	if min < 10 then
		return string.format("%02d:%02d",min,sec)
	else
		return string.format("%d:%02d",min,sec)
	end
	
end

