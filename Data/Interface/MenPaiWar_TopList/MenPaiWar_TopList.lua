-------排行榜
-------!!!reloadscript =MenPaiWar_TopList

local g_MenPaiWar_TopList_Frame_UnifiedXPosition;
local g_MenPaiWar_TopList_Frame_UnifiedYPosition;

local g_MaxPlayer = 20
local g_NeedLevel = 60
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


function MenPaiWar_TopList_PreLoad()
	--
	this:RegisterEvent("OPEN_MENPAICHALLENGE_RANKINGLIST");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function MenPaiWar_TopList_OnLoad()
	--
	g_MenPaiWar_TopList_Frame_UnifiedXPosition	= MenPaiWar_TopList_MainFrame : GetProperty("UnifiedXPosition");
	g_MenPaiWar_TopList_Frame_UnifiedYPosition	= MenPaiWar_TopList_MainFrame : GetProperty("UnifiedYPosition");
	
end

function MenPaiWar_TopList_OnEvent(event)

	if (event=="OPEN_MENPAICHALLENGE_RANKINGLIST") then 
	
		g_nType = tonumber(arg0)
		MenPaiWar_TopList_BeginCareObject( tonumber(arg1) )
		MenPaiWar_TopList_Update()	
		this : Show()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiWar_TopList_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiWar_TopList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiWar_TopList_Frame_On_ResetPos()
		
	end
end


function MenPaiWar_TopList_Update()	

	MenPaiWar_TopList_RecordInfo()	
	MenPaiWar_TopList_PrizeInfo()
	
end


function MenPaiWar_TopList_Init( )
	
	MenPaiWar_TopList:Clear()
	
end


function MenPaiWar_TopList_RecordInfo( )
		
	MenPaiWar_TopList_Init( )
	
	local dataCnt = DataPool:lua_GetJSRankingListDataCount( g_nType )
	for index=0, g_MaxPlayer-1 do
		if index < dataCnt then
			MenPaiWar_TopList_HaveRecord( index )
		else
			MenPaiWar_TopList_NoRecord( index )
		end
	end
	
end


function MenPaiWar_TopList_HaveRecord( index )
	local nRank, name, usetime, state = DataPool:lua_GetJSRankingListInfo(g_nType, index);
	if nRank == nil then
		return
	end
			
	local ItemBar = MenPaiWar_TopList:AddChild( "MenPaiWar_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("MenPaiWar_TopList_ItemBK")
	teamBKButton:Show()
	local teamBKImage = ItemBar:GetSubItem("MenPaiWar_TopList_ItemBKImage")
	teamBKImage:Show()
	teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK1")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("MenPaiWar_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("MenPaiWar_TopList_Number")
		numButton:SetText(index+1)
	else
		local numImageButton = ItemBar:GetSubItem("MenPaiWar_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("MenPaiWar_TopList_Number")
		numButton:SetText(index+1)
	end
		
	--队员
	local noTeamButton = ItemBar:GetSubItem("MenPaiWar_TopList_TeamNull")
	noTeamButton:Hide()
	
	local teamButton = ItemBar:GetSubItem("MenPaiWar_TopList_Team")
	teamButton:Show()
	
	local mennum = 0
	for j = 1,6 do
		local bValid, memguid, memname, menpai, level = DataPool:lua_GetJSRankingListMemberInfo(g_nType, index, j-1);

		if bValid ~= nil and bValid == 1 then
			MenPaiWar_TopList_HaveMember( ItemBar, j, memname, menpai, level )

			mennum = j
		else
			MenPaiWar_TopList_NoMember( ItemBar, j )
		end
	end

	--副本时间
	local timeShow = MenPaiWar_TopList_FormatTime(usetime)
	local timeButton = ItemBar:GetSubItem("MenPaiWar_TopList_Time")
	timeButton:SetText(timeShow)
end


function MenPaiWar_TopList_NoRecord( index )
	local ItemBar = MenPaiWar_TopList:AddChild( "MenPaiWar_TopList_Item")
	if ItemBar == nil then
		return 
	end

	local teamBKButton = ItemBar:GetSubItem("MenPaiWar_TopList_ItemBK")
	teamBKButton:Show()
	local teamBKImage = ItemBar:GetSubItem("MenPaiWar_TopList_ItemBKImage")
	teamBKImage:Show()
	teamBKImage:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListBK2")
		
	--名次
	if index <= 2 then
		local numImageButton = ItemBar:GetSubItem("MenPaiWar_TopList_NumberImage")
		numImageButton:Show()
		if index == 0 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop1")
		elseif index == 1 then
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop2")
		else
			numImageButton:SetProperty("Image","set:MenPaiWar_TopList image:MenPaiWar_TopListTop3")
		end
		local numButton = ItemBar:GetSubItem("MenPaiWar_TopList_Number")
		numButton:SetText(index+1)
	else
		local numImageButton = ItemBar:GetSubItem("MenPaiWar_TopList_NumberImage")
		numImageButton:Hide()
		local numButton = ItemBar:GetSubItem("MenPaiWar_TopList_Number")
		numButton:SetText(index+1)
	end
	
	--队员
	local noTeamButton = ItemBar:GetSubItem("MenPaiWar_TopList_TeamNull")
	noTeamButton:Show()
	
	local teamButton = ItemBar:GetSubItem("MenPaiWar_TopList_Team")
	teamButton:Hide()
	
	--副本时间
	local timeButton = ItemBar:GetSubItem("MenPaiWar_TopList_Time")
	timeButton:SetText("#{MPCG_191029_338}")
end


function MenPaiWar_TopList_HaveMember( ItemBar, index, memname, menpai, level )
	local szMember = string.format( "MenPaiWar_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Show()
	
	local szName = string.format( "MenPaiWar_TopList_Name%d", index )
	local nameButton = ItemBar:GetSubItem(szName)
	nameButton:SetText(memname)
	
	local szMenPai = string.format( "MenPaiWar_TopList_School%d", index )
	local menpaiButton = ItemBar:GetSubItem(szMenPai)
	menpaiButton:SetText( g_MenPaiName[menpai] )
	
	local szLevel = string.format( "MenPaiWar_TopList_Level%d", index )
	local LevelButton = ItemBar:GetSubItem(szLevel)
	LevelButton:SetText( level )

	if index ~= 1 then
		local nullteam = string.format( "MenPaiWar_TopList_TeamNull%d", index )
		local nullteamButton = ItemBar:GetSubItem(nullteam)
		nullteamButton:Hide()
	end
end


function MenPaiWar_TopList_NoMember( ItemBar, index )
	local szMember = string.format( "MenPaiWar_TopList_TeamMember%d", index )
	local memberButton = ItemBar:GetSubItem(szMember)
	memberButton:Hide()

	if index ~= 1 then
		local nullteam = string.format( "MenPaiWar_TopList_TeamNull%d", index )
		local nullteamButton = ItemBar:GetSubItem(nullteam)
		nullteamButton:Show()
	end
end

--	RankingListData_DB_DataStatus_Free,
--	RankingListData_DB_DataStatus_Ranking,
--	RankingListData_DB_DataStatus_Settle,
function MenPaiWar_TopList_PrizeInfo()
	local nRank,name,usetime,state = DataPool:lua_GetJSRankingListInfo(g_nType,0)
	g_State = state

	local myRank = -1
	local myRankTime = 0

	local nDataCount = DataPool:lua_GetJSRankingListDataCount(g_nType)
	if nDataCount <= 0 then
		MenPaiWar_TopList_ReachTime:SetText("#{MPCG_191029_365}")
		MenPaiWar_TopList_ReachTop:SetText("#{MPCG_191029_370}")
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_340}")
		MenPaiWar_TopList_ReachTime:Show()
		MenPaiWar_TopList_ReachTop:Show()
		MenPaiWar_TopList_Btn:Disable()
		return
	end

	for i = 0, nDataCount-1 do
		local nRank,name,usetime,state = DataPool:lua_GetJSRankingListInfo(g_nType,i)
		for j = 1,6 do
			local bValid, memguid, membname,menpai,level,score = DataPool:lua_GetJSRankingListMemberInfo(g_nType,i,j-1);
			if bValid == 1 and myRank < 0 then
				if memguid == Player:GetGUID() then
					myRank = nRank
					myRankTime = usetime

					break
				end
			end
		end

		if myRank ~= -1 then
			break
		end
	end

	if myRank == -1 then
		MenPaiWar_TopList_ReachTop:SetText("#{MPCG_191029_370}")
		MenPaiWar_TopList_ReachTop:Show()
	else
		MenPaiWar_TopList_ReachTop:SetText(ScriptGlobal_Format("#{MPCG_191029_360}",myRank+1))
		MenPaiWar_TopList_ReachTop:Show()
	end

	local mytime = math.floor(DataPool:lua_GetMenPaiWarRankingListMyvalue()/10000)
	if mytime == 0 then
		MenPaiWar_TopList_ReachTime:SetText("#{MPCG_191029_365}")
		MenPaiWar_TopList_ReachTime:Show()
	else
		local mintime = math.floor(mytime/60)
		local sectime = math.mod(mytime,60)
		MenPaiWar_TopList_ReachTime:SetText(ScriptGlobal_Format("#{MPCG_191029_359}",mintime,sectime))
		MenPaiWar_TopList_ReachTime:Show()
	end

	--未结算时显示
	if state == 0 or state == 1 then 
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_340}")
		MenPaiWar_TopList_Btn:Disable()
		return
	end

	local myuset, myrewardflag = DataPool:lua_GetJSRankingListMyInfo(g_nType)

	MenPaiWar_TopList_ReachTime:Hide()
	MenPaiWar_TopList_ReachTop:Hide()
	
	--已结算
	if myRank < 0 then
		MenPaiWar_TopList_MyNumber:SetText("#{MPCG_191029_369}")
		MenPaiWar_TopList_Btn:Disable()
		return
	else
		if myrewardflag == 0 then
			local msg = ScriptGlobal_Format("#{MPCG_191029_367}", myRank+1)
			MenPaiWar_TopList_MyNumber:SetText(msg)
			MenPaiWar_TopList_Btn:Enable()
		else
			local msg = ScriptGlobal_Format("#{MPCG_191029_368}", myRank+1)
			MenPaiWar_TopList_MyNumber:SetText(msg)
			MenPaiWar_TopList_Btn:Enable()
		end
		
		return
	end
	
end


--领奖
function MenPaiWar_TopList_Prize_Click( )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPCG_191029_349}")
		return
	end
	
	DataPool : lua_GetJSRankingListGetReward(g_nType)
	
end


function MenPaiWar_TopList_Preview_Click()
	PushEvent("OPEN_MENPAICHALLENGE_RANKINGLIST_AWARD", g_nType, g_TargetId)
end


function MenPaiWar_TopList_Frame_On_ResetPos()

	MenPaiWar_TopList_MainFrame : SetProperty("UnifiedXPosition", g_MenPaiWar_TopList_Frame_UnifiedXPosition);
	MenPaiWar_TopList_MainFrame : SetProperty("UnifiedYPosition", g_MenPaiWar_TopList_Frame_UnifiedYPosition);

end


function MenPaiWar_TopList_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{MPCG_191029_332}")
end


function MenPaiWar_TopList_Close()
	this:Hide()
end

--=========================================================
--开始关心NPC
--=========================================================
function MenPaiWar_TopList_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		MenPaiWar_TopList_Close()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "MenPaiWar_TopList" )
end

function MenPaiWar_TopList_FormatTime(nSec)
	local min = math.floor(nSec/60)
	local sec = math.mod(nSec,60)
	
	if min < 10 then
		return string.format("%02d:%02d",min,sec)
	else
		return string.format("%d:%02d",min,sec)
	end
	
end

