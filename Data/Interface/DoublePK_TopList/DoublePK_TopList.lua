-------DoublePK_TopList

local g_DoublePK_TopList_Frame_UnifiedXPosition;
local g_DoublePK_TopList_Frame_UnifiedYPosition;

local g_MaxPlayer = 50
local g_NeedLevel = 60
local g_TargetId = -1
local g_nType = -1
local g_State = -1

local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --??
		[1] = "#{XQ_MP_2}",    --??
		[2] = "#{XQ_MP_3}",    --??
		[3] = "#{XQ_MP_4}",    --??
		[4] = "#{XQ_MP_5}",    --??
		[5] = "#{XQ_MP_6}",    --??
		[6] = "#{XQ_MP_7}",    --??
		[7] = "#{XQ_MP_8}",    --??
		[8] = "#{XQ_MP_9}",    --??
		[9] = "",         --???
		[10] = "#{MPDYR_20220427_190}",    --??
}

local g_relationtext = {
	[0] = "#{SRPK_230331_284}",
	[1] = "#{SRPK_230331_282}",
	[2] = "#{SRPK_230331_283}",
}

local g_TopListType = {
	[1] = 12,
	[2] = 13,
	[3] = 14,
}

function DoublePK_TopList_PreLoad()
	--
	this:RegisterEvent("OPEN_DOUBLE_PK_RANKINGLIST");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function DoublePK_TopList_OnLoad()
	--
	g_DoublePK_TopList_Frame_UnifiedXPosition	= DoublePK_TopList_MainFrame : GetProperty("UnifiedXPosition");
	g_DoublePK_TopList_Frame_UnifiedYPosition	= DoublePK_TopList_MainFrame : GetProperty("UnifiedYPosition");
	
end

function DoublePK_TopList_OnEvent(event)

	if (event=="OPEN_DOUBLE_PK_RANKINGLIST") then 
		g_nType = tonumber(arg0)
		DoublePK_TopList_BeginCareObject( tonumber(arg1) )
		DoublePK_TopList_Update()	
		this : Show()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		DoublePK_TopList_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		DoublePK_TopList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		DoublePK_TopList_Frame_On_ResetPos()
		
	end
end


function DoublePK_TopList_Update()	

	DoublePK_TopList_RecordInfo()	
	DoublePK_TopList_PrizeInfo()
	
end


function DoublePK_TopList_Init( )
	
	DoublePK_TopList:Clear()
	
end


function DoublePK_TopList_RecordInfo( )
		
	DoublePK_TopList_Init( )
	
	if g_nType == 12 then
		DoublePK_TopList_DragTitle:SetText("#{SRPK_230331_289}")
	elseif g_nType == 13 then
		DoublePK_TopList_DragTitle:SetText("#{SRPK_230331_290}")
	elseif g_nType == 14 then
		DoublePK_TopList_DragTitle:SetText("#{SRPK_230331_291}")
	end
	
	local dataCnt = DataPool:lua_GetJSRankingListDataCount( g_nType )
	for index=0, g_MaxPlayer-1 do
		if index < dataCnt then
			DoublePK_TopList_HaveRecord( index )
		else
			DoublePK_TopList_NoRecord( index )
		end
	end
	
end


function DoublePK_TopList_HaveRecord( index )
	local nRank, name, score, state = DataPool:lua_GetJSRankingListInfo(g_nType, index);
		

	if nRank == nil then
		return
	end
			
	local ItemBar = DoublePK_TopList:AddChild( "DoublePK_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("DoublePK_TopList_ItemBK")
	teamBKButton:Show()
	--local teamBKImage = ItemBar:GetSubItem("DoublePK_TopList_ItemBKImage")
	--teamBKImage:Show()
	--teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK1")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("DoublePK_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("DoublePK_TopList_Number")
		numButton:SetText("#cfff263"..tostring(index+1))
	else
		local numImageButton = ItemBar:GetSubItem("DoublePK_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("DoublePK_TopList_Number")
		numButton:SetText("#cfff263"..tostring(index+1))
	end
		
	--队员
	local noTeamButton = ItemBar:GetSubItem("DoublePK_TopList_TeamNull")
	noTeamButton:Hide()
	
	local teamButton = ItemBar:GetSubItem("DoublePK_TopList_Team")
	teamButton:Show()
	
	local mennum = 0
	for j = 1,2 do
		local bValid, memguid, memname, menpai, level = DataPool:lua_GetJSRankingListMemberInfo(g_nType, index, j-1);
		local nZoneWorldId = DataPool:lua_GetJSRankingListParam(g_nType, index, 1+j);
		if bValid ~= nil and bValid == 1 then
			local world_name = DataPool:GetServerName(tonumber(nZoneWorldId))
			memname = memname .."@"..tostring(world_name)
			DoublePK_TopList_HaveMember( ItemBar, j, memname, menpai, level )

			mennum = j
		else
			DoublePK_TopList_NoMember( ItemBar, j )
		end
	end
	--关系
	local relation = DataPool:lua_GetJSRankingListParam(g_nType, index, 1);
	ItemBar:GetSubItem("DoublePK_TopList_Relation"):SetText(g_relationtext[relation])
	--分数
	local timeButton = ItemBar:GetSubItem("DoublePK_TopList_Num")
	timeButton:SetText(ScriptGlobal_Format("#{SRPK_230331_101}",score))
end


function DoublePK_TopList_NoRecord( index )
	local ItemBar = DoublePK_TopList:AddChild( "DoublePK_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("DoublePK_TopList_ItemBK")
	teamBKButton:Show()
	--local teamBKImage = ItemBar:GetSubItem("DoublePK_TopList_ItemBKImage")
	--teamBKImage:Show()
	--teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK2")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("DoublePK_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:DoubleGame_TopList image:DoubleGame_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("DoublePK_TopList_Number")
		numButton:SetText("#cfff263"..tostring(index+1))
	else
		local numImageButton = ItemBar:GetSubItem("DoublePK_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("DoublePK_TopList_Number")
		numButton:SetText("#cfff263"..tostring(index+1))
	end
	
	--队员
	local noTeamButton = ItemBar:GetSubItem("DoublePK_TopList_TeamNull")
	noTeamButton:Show()
	
	local teamButton = ItemBar:GetSubItem("DoublePK_TopList_Team")
	teamButton:Hide()
	
end


function DoublePK_TopList_HaveMember( ItemBar, index, memname, menpai, level )
	local szMember = string.format( "DoublePK_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Show()
	
	local szName = string.format( "DoublePK_TopList_Name%d", index )
	local nameButton = ItemBar:GetSubItem(szName)
	nameButton:SetText("#cfff263"..memname)
	
	local szMenPai = string.format( "DoublePK_TopList_School%d", index )
	local menpaiButton = ItemBar:GetSubItem(szMenPai)
	menpaiButton:SetText( "#cfff263"..g_MenPaiName[menpai] )
	
	local szLevel = string.format( "DoublePK_TopList_Level%d", index )
	local LevelButton = ItemBar:GetSubItem(szLevel)
	LevelButton:SetText( "#cfff263"..tostring(level) )

	--if index ~= 1 then
	--	local nullteam = string.format( "DoublePK_TopList_TeamNull%d", index )
	--	local nullteamButton = ItemBar:GetSubItem(nullteam)
	--	nullteamButton:Hide()
	--end
end


function DoublePK_TopList_NoMember( ItemBar, index )
	local szMember = string.format( "DoublePK_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Hide()

	--if index ~= 1 then
	--	local nullteam = string.format( "DoublePK_TopList_TeamNull%d", index )
	--	local nullteamButton = ItemBar:GetSubItem(nullteam)
	--	nullteamButton:Show()
	--end
end

--	RankingListData_DB_DataStatus_Free,
--	RankingListData_DB_DataStatus_Ranking,
--	RankingListData_DB_DataStatus_Settle,
function DoublePK_TopList_PrizeInfo()
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
		DoublePK_TopList_ReachTop:SetText("#{SRPK_230331_107}")
		DoublePK_TopList_ReachTop:Show()
	else
		DoublePK_TopList_ReachTop:SetText(ScriptGlobal_Format("#{SRPK_230331_106}",myRank+1))
		DoublePK_TopList_ReachTop:Show()
	end

	--显示绑定关系和分数
	local myscore, scoretype, bindname = DataPool:lua_GetDoubleRankingListMyvalue(g_nType)
	if myscore == nil or bindname == nil then
		DoublePK_TopList_ReachNum:SetText("#{SRPK_230331_274}")
		DoublePK_TopList_ReachNum:Show()
	else
		if bindname ~= "" then
			if scoretype > 0 and g_TopListType[scoretype] == g_nType then --??????
				DoublePK_TopList_ReachNum:SetText(ScriptGlobal_Format("#{SRPK_230331_272}",bindname,myscore))
				DoublePK_TopList_ReachNum:Show()
			else--???????
				DoublePK_TopList_ReachNum:SetText(ScriptGlobal_Format("#{SRPK_230331_292}",bindname))
				DoublePK_TopList_ReachNum:Show()			
			end

		else --???
			DoublePK_TopList_ReachNum:SetText("#{SRPK_230331_274}")
			DoublePK_TopList_ReachNum:Show()
		end
	end

	--未结算时显示
	if state == 0 or state == 1 then 
		DoublePK_TopList_MyNumber:SetText("#{SRPK_230331_111}")
		DoublePK_TopList_Btn:Disable()
		return
	end

	local myuset, myrewardflag = DataPool:lua_GetJSRankingListMyInfo(g_nType)

	DoublePK_TopList_ReachNum:Hide()
	DoublePK_TopList_ReachTop:Hide()
	
	--已结算
	if myRank < 0 then
		DoublePK_TopList_MyNumber:SetText("#{SRPK_230331_110}")
		DoublePK_TopList_Btn:Disable()
		return
	else
		if myrewardflag == 0 then
			local msg = ScriptGlobal_Format("#{SRPK_230331_108}", myRank+1)
			DoublePK_TopList_MyNumber:SetText(msg)
			DoublePK_TopList_Btn:Enable()
		else
			local msg = ScriptGlobal_Format("#{SRPK_230331_109}", myRank+1)
			DoublePK_TopList_MyNumber:SetText(msg)
			DoublePK_TopList_Btn:Disable()
		end
		
		return
	end
	
end


--领奖
function DoublePK_TopList_Prize_Click( )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{SRWF_230329_115}")
		return
	end
	
	DataPool : lua_GetJSRankingListGetReward(g_nType)
	
end


function DoublePK_TopList_Preview_Click()
	PushEvent("OPEN_DOUBLE_PK_RANKINGLIST_REWARD", g_nType, g_TargetId)
end


function DoublePK_TopList_Frame_On_ResetPos()

	DoublePK_TopList_MainFrame : SetProperty("UnifiedXPosition", g_DoublePK_TopList_Frame_UnifiedXPosition);
	DoublePK_TopList_MainFrame : SetProperty("UnifiedYPosition", g_DoublePK_TopList_Frame_UnifiedYPosition);

end


function DoublePK_TopList_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{SRPK_230331_95}")
end


function DoublePK_TopList_Close()
	if(IsWindowShow("DoublePK_TopListAward")) then
		CloseWindow("DoublePK_TopListAward", true)
	end 	
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function DoublePK_TopList_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		DoublePK_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "DoublePK_TopList" )
end

function DoublePK_TopList_FormatTime(nSec)
	local min = math.floor(nSec/60)
	local sec = math.mod(nSec,60)
	
	if min < 10 then
		return string.format("%02d:%02d",min,sec)
	else
		return string.format("%d:%02d",min,sec)
	end
	
end

