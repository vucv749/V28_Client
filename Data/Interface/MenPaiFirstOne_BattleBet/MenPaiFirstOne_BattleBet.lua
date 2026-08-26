-------押注
-------!!!reloadscript =MenPaiFirstOne_BattleBet

local g_MenPaiFirstOne_BattleBet_Frame_UnifiedXPosition;
local g_MenPaiFirstOne_BattleBet_Frame_UnifiedYPosition;

local g_MaxPlayer = 16
local g_NeedLevel = 60

local g_SeverData = { 
		targetId = -1,
		yazhuWeek = -1,
		yazhuGuid = -1,
		yazhuPrize = 0,
		matchWeek = -1,
		isInYaZhu = 0,
		huodongType = 0,
		isInBaoMing = 0,
		yazhuItem = -1,
}

local g_MenPaiFirstOne_BattleBet_InfoList = {}

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
		[10] = "#{MPZH_180719_16}",    --曼陀
}

local g_YaZhuItem = 38002585
local g_YaZhuItemEx = 38002639

local g_YaZhuPrize = {

	[0] = 	--押注失败
	{
		[g_YaZhuItem] = 100000,
		[g_YaZhuItemEx] = 200000,
	},
	
	[1] = 	--押注成功
	{
		[g_YaZhuItem] = 200000,
		[g_YaZhuItemEx] = 300000, 
	},
}


function MenPaiFirstOne_BattleBet_PreLoad()
	--
	this:RegisterEvent("DDZ_OPEN_YAZHU");
	this:RegisterEvent("DDZ_UPDATE_YAZHU");
	
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function MenPaiFirstOne_BattleBet_OnLoad()
	--
	g_MenPaiFirstOne_BattleBet_Frame_UnifiedXPosition	= MenPaiFirstOne_BattleBet_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiFirstOne_BattleBet_Frame_UnifiedYPosition	= MenPaiFirstOne_BattleBet_Frame : GetProperty("UnifiedYPosition");
	
end

function MenPaiFirstOne_BattleBet_OnEvent(event)

	if event == "DDZ_OPEN_YAZHU" then
		
		if this:IsVisible() == true then
			MenPaiFirstOne_BattleBet_Close()
			return
		end
		
		g_SeverData.targetId = tonumber(arg0)
		if g_SeverData.targetId == -1 then
			MenPaiFirstOne_BattleBet_Close()
			return
		end

		local objId = DataPool : GetNPCIDByServerID(g_SeverData.targetId)
		if objId == -1 then
			return
		end
		
		this : CareObject( objId, 1, "MenPaiFirstOne_BattleBet" )
		
		MenPaiFirstOne_BattleBet_Update()
		this : Show()

	elseif (event=="DDZ_UPDATE_YAZHU") then 
		if this:IsVisible() == false then
			return
		end
	
		MenPaiFirstOne_BattleBet_Update()	
		
	elseif (event=="UI_COMMAND" and tonumber(arg0) == 89316802 ) then 
		if this:IsVisible() == false then
			return
		end
		
		g_SeverData.yazhuWeek = Get_XParam_INT(0)
		g_SeverData.yazhuGuid = Get_XParam_INT(1)
		g_SeverData.yazhuPrize = Get_XParam_INT(2)
		g_SeverData.matchWeek = Get_XParam_INT(3)
		g_SeverData.isInYaZhu = Get_XParam_INT(4)
		g_SeverData.huodongType = Get_XParam_INT(5)
		g_SeverData.isInBaoMing = Get_XParam_INT(6)
		g_SeverData.yazhuItem = Get_XParam_INT(7)
		
		MenPaiFirstOne_BattleBet_Update()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		MenPaiFirstOne_BattleBet_Close()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		MenPaiFirstOne_BattleBet_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiFirstOne_BattleBet_Frame_On_ResetPos()
		
	end
end


function MenPaiFirstOne_BattleBet_Update()	

	MenPaiFirstOne_BattleBet_MemberInfo()	
	MenPaiFirstOne_BattleBet_PrizeInfo()
	
end


function MenPaiFirstOne_BattleBet_Init( )
	
	for i = 1, table.getn(g_MenPaiFirstOne_BattleBet_InfoList) do
		if g_MenPaiFirstOne_BattleBet_InfoList[i] ~= nil then
			g_MenPaiFirstOne_BattleBet_InfoList[i] = nil
		end
    end
	
	MenPaiFirstOne_BattleBet_List:Clear()
end


function MenPaiFirstOne_BattleBet_MemberInfo( )
		
	MenPaiFirstOne_BattleBet_Init( )
	
	local menpai = Player : GetData("MEMPAI");
	local title = ScriptGlobal_Format("#{MPDYR_20220427_126}", g_MenPaiName[menpai])
	MenPaiFirstOne_BattleBet_DragTitle : SetText(title)
	
	local isYaZhu = 0
	if g_SeverData.yazhuWeek == g_SeverData.matchWeek and g_SeverData.yazhuGuid > 0 then
		DataPool:Lua_SortDDZRankInfo(2) --按押注人数排序
		isYaZhu = 1
	else
		DataPool:Lua_SortDDZRankInfo(1) --按副本完成时间排序
		isYaZhu = 0
	end
	
	local menpai = Player : GetData("MEMPAI")
	
	for index=0, g_MaxPlayer-1 do
		local name, guid, level, yazhuNum = DataPool:Lua_GetDDZYaZhuInfo(menpai, index)
		if name == nil or name == "" then
			break
		end
			
		local bar1 = MenPaiFirstOne_BattleBet_List:AddChild("MenPaiFirstOne_BattleBet_ListItem1BK")
		if not bar1 then
    	   break
		end
		
		bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Number"):SetText(index + 1)   
        bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Name"):SetText(name)   
        bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Level"):SetText(level)   
		
		if yazhuNum == 0 then
			bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Count"):SetText("#{MPDYR_20220427_142}")   
		else
			local msg = ScriptGlobal_Format("#{MPDYR_20220427_143}", yazhuNum)
			bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Count"):SetText(yazhuNum)   
		end
		
		local yazhuButton = bar1:GetSubItem("MenPaiFirstOne_BattleBet_ListItem1_Bet")
		if isYaZhu == 0 then
			yazhuButton : Show()
			yazhuButton : Enable()
			yazhuButton : SetText("#{MPDYR_20220427_151}")
			yazhuButton : SetEvent("MouseLButtonDown", string.format("MenPaiFirstOne_BattleBet_YaZhu_Click(%d)", index))   
			
		elseif isYaZhu == 1 and guid == g_SeverData.yazhuGuid then
			yazhuButton : Show()
			yazhuButton : Disable()
			yazhuButton : SetText("#{MPDYR_20220427_144}")
			
		else
			yazhuButton : Hide()
		end
		
		g_MenPaiFirstOne_BattleBet_InfoList[index + 1] = bar1
	end
	
end


function MenPaiFirstOne_BattleBet_PrizeInfo( )
	local isYaZhu = 0
	if g_SeverData.yazhuWeek == g_SeverData.matchWeek and g_SeverData.yazhuGuid > 0 then
		isYaZhu = 1
	end
	
	local successPrize = 0
	local failPrize = 0
	if isYaZhu == 1 and g_SeverData.yazhuItem > 0 then
		successPrize = g_YaZhuPrize[1][g_SeverData.yazhuItem]
		failPrize = g_YaZhuPrize[0][g_SeverData.yazhuItem]
	end
	
	if g_SeverData.huodongType == 0 then --活动未开始
		MenPaiFirstOne_BattleBet_AwardInfo : SetText("#{MPDYR_20220427_156}")
		
	elseif g_SeverData.huodongType == 1 then	-- 活动期间 
		
		if g_SeverData.isInBaoMing == 1 then --报名期间
			MenPaiFirstOne_BattleBet_AwardInfo : SetText("#{MPDYR_20220427_156}")
		else --押注比赛期间
			if isYaZhu == 1 then
				local name, pkResult, prizeflag = MenPaiFirstOne_BattleBet_GetYaZhuInfo() 
				local msg = ScriptGlobal_Format("#{MPDYR_20220427_146}", name)
				MenPaiFirstOne_BattleBet_AwardInfo : SetText( msg )
			else
				MenPaiFirstOne_BattleBet_AwardInfo : SetText( "#{MPDYR_20220427_145}" )
			end
		end
		 
		
	elseif g_SeverData.huodongType == 2 then	--活动结束后
		MenPaiFirstOne_BattleBet_AwardInfo : SetText( "#{MPDYR_20220427_147}" )
	end
end

 
function MenPaiFirstOne_BattleBet_YaZhu_Click( index )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPDYR_20220427_153}")
		return
	end
	
	if g_SeverData.isInYaZhu ~= 1 then
		PushDebugMessage("#{MPDYR_20220427_152}")
		return
	end
	
	if g_SeverData.yazhuWeek == g_SeverData.matchWeek and g_SeverData.yazhuGuid > 0 then
		PushDebugMessage("#{MPDYR_20220427_131}")
		return
	end
	
	local menpai = Player : GetData("MEMPAI")
	local name, guid, level, yazhuNum = DataPool:Lua_GetDDZYaZhuInfo(menpai, index)
	if name == nil or name == "" then
		PushDebugMessage("#{MPDYR_20220427_132}")
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnYaZhu")
		Set_XSCRIPT_ScriptID(893168)
		Set_XSCRIPT_Parameter(0, g_SeverData.targetId)
		Set_XSCRIPT_Parameter(1, guid)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();
	
end


--领奖
function MenPaiFirstOne_BattleBet_Prize_Click( )
	
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPDYR_20220427_113}")
		return
	end
	
	if g_SeverData.yazhuWeek ~= g_SeverData.matchWeek or g_SeverData.yazhuGuid <= 0 then
		PushDebugMessage("#{MPDYR_20220427_138}")
		return
	end
	
	local name, pkResult, prizeflag = MenPaiFirstOne_BattleBet_GetYaZhuInfo()
	if name == "" then
		PushDebugMessage("#{MPDYR_20220427_138}")
		return
	end
	
	if g_SeverData.yazhuPrize == 1 then
		PushDebugMessage("#{MPDYR_20220427_139}")
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetYaZhuPrize")
		Set_XSCRIPT_ScriptID(893168);
		Set_XSCRIPT_Parameter(0, g_SeverData.targetId);
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT();
	
end


function MenPaiFirstOne_BattleBet_Frame_On_ResetPos()

	MenPaiFirstOne_BattleBet_Frame : SetProperty("UnifiedXPosition", g_MenPaiFirstOne_BattleBet_Frame_UnifiedXPosition);
	MenPaiFirstOne_BattleBet_Frame : SetProperty("UnifiedYPosition", g_MenPaiFirstOne_BattleBet_Frame_UnifiedYPosition);

end


function MenPaiFirstOne_BattleBet_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{MPDYR_20220427_128}")
end

function MenPaiFirstOne_BattleBet_Close()
	if( this:IsVisible() == true ) then
		this:Hide()
	end
end

function MenPaiFirstOne_BattleBet_GetYaZhuInfo( )
	
	local menpai = Player : GetData("MEMPAI")
	
	for index=0, g_MaxPlayer-1 do
		local name, guid, sourceRank, rank0, rank1, rank2, rank3, pkResult, prizeFlag = DataPool:Lua_GetDDZMatchInfo(menpai, index)
		
		if guid ~= nil and guid == g_SeverData.yazhuGuid then
			return name, pkResult, prizeFlag
		end
	end
	
	return "", 0

end

function MenPaiFirstOne_BattleBet_GetFirst( )
	
	local menpai = Player : GetData("MEMPAI")
	
	for index=0, g_MaxPlayer-1 do
		local name, guid, sourceRank, rank0, rank1, rank2, rank3, pkResult, prizeFlag = DataPool:Lua_GetDDZMatchInfo(menpai, index)
		
		if guid ~= nil and pkResult == 1 then
			return name
		end
	end
	
	return "" 

end

