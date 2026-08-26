-------比赛界面
-------!!!reloadscript =MenPaiFirstOne_BattleTable

local MenPaiFirstOne_BattleTable_Normal = "set:MenPaiFirstOne_BattleTable image:MenPaiFirstOne_BattleTable_NameBK"
local MenPaiFirstOne_BattleTable_Sheng = "set:MenPaiFirstOne_BattleTable image:MenPaiFirstOne_BattleTable_ShengBK"
local MenPaiFirstOne_BattleTable_Fu = "set:MenPaiFirstOne_BattleTable image:MenPaiFirstOne_BattleTable_FuBK"

local g_MenPaiFirstOne_BattleTable_Frame_UnifiedXPosition;
local g_MenPaiFirstOne_BattleTable_Frame_UnifiedYPosition;

local g_SeverData = {
		targetId = -1,
		isInBaoMing = 0,
		isInYaZhu = 0,
		yazhuWeek = -1,
		yazhuGuid = -1,
		matchWeek = -1,
		isInMatch = 0,
		yazhuPrize = 0,
		huodongType = 0,
}

local g_CurMenPai = 0

local g_MaxPlayer = 16
local g_NeedLevel = 60
local g_LastClickTime = 0
local g_CDTime = 2

local g_MenPaiFirstOne_BattleTable_Table0_Name = {}
local g_MenPaiFirstOne_BattleTable_Table0_BK = {}
local g_MenPaiFirstOne_BattleTable_Table0_Animate = {}
local g_MenPaiFirstOne_BattleTable_Table0_Line = {}

local g_MenPaiFirstOne_BattleTable_Table1_Name = {}
local g_MenPaiFirstOne_BattleTable_Table1_BK = {}
local g_MenPaiFirstOne_BattleTable_Table1_Animate = {}
local g_MenPaiFirstOne_BattleTable_Table1_Line = {}

local g_MenPaiFirstOne_BattleTable_Table2_Name = {}
local g_MenPaiFirstOne_BattleTable_Table2_BK = {}
local g_MenPaiFirstOne_BattleTable_Table2_Animate = {}
local g_MenPaiFirstOne_BattleTable_Table2_Line = {}

local g_MenPaiFirstOne_BattleTable_Table3_Name = {}
local g_MenPaiFirstOne_BattleTable_Table3_BK = {}
local g_MenPaiFirstOne_BattleTable_Table3_Animate = {}
local g_MenPaiFirstOne_BattleTable_Table3_Line = {}

local g_MenPaiFirstOne_BattleTable_Table4_Name = {}
local g_MenPaiFirstOne_BattleTable_Table4_Animate = {}

local g_MenPaiFirstOne_BattleTable_MenPai = {}

local g_SourceRank = {1, 9, 5, 13, 3, 11, 7, 15, 2, 10, 6, 14, 4, 12, 8, 16}
local g_FixRank = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}


function MenPaiFirstOne_BattleTable_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--
	this:RegisterEvent("DDZ_OPEN_RANKINGCHARTS");
	this:RegisterEvent("DDZ_UPDATE_RANKINGCHARTS");

	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function MenPaiFirstOne_BattleTable_OnLoad()
	--
	g_MenPaiFirstOne_BattleTable_Frame_UnifiedXPosition	= MenPaiFirstOne_BattleTable_Frame : GetProperty("UnifiedXPosition");
	g_MenPaiFirstOne_BattleTable_Frame_UnifiedYPosition	= MenPaiFirstOne_BattleTable_Frame : GetProperty("UnifiedYPosition");

	g_MenPaiFirstOne_BattleTable_MenPai[1] = MenPaiFirstOne_BattleTable_MenPai1
	g_MenPaiFirstOne_BattleTable_MenPai[2] = MenPaiFirstOne_BattleTable_MenPai2
	g_MenPaiFirstOne_BattleTable_MenPai[3] = MenPaiFirstOne_BattleTable_MenPai3
	g_MenPaiFirstOne_BattleTable_MenPai[4] = MenPaiFirstOne_BattleTable_MenPai4
	g_MenPaiFirstOne_BattleTable_MenPai[5] = MenPaiFirstOne_BattleTable_MenPai5
	g_MenPaiFirstOne_BattleTable_MenPai[6] = MenPaiFirstOne_BattleTable_MenPai6
	g_MenPaiFirstOne_BattleTable_MenPai[7] = MenPaiFirstOne_BattleTable_MenPai7
	g_MenPaiFirstOne_BattleTable_MenPai[8] = MenPaiFirstOne_BattleTable_MenPai8
	g_MenPaiFirstOne_BattleTable_MenPai[9] = MenPaiFirstOne_BattleTable_MenPai9
	g_MenPaiFirstOne_BattleTable_MenPai[11] = MenPaiFirstOne_BattleTable_MenPai10


	g_MenPaiFirstOne_BattleTable_Table0_Name[1] = MenPaiFirstOne_BattleTable_Name1
	g_MenPaiFirstOne_BattleTable_Table0_Name[2] = MenPaiFirstOne_BattleTable_Name2
	g_MenPaiFirstOne_BattleTable_Table0_Name[3] = MenPaiFirstOne_BattleTable_Name3
	g_MenPaiFirstOne_BattleTable_Table0_Name[4] = MenPaiFirstOne_BattleTable_Name4
	g_MenPaiFirstOne_BattleTable_Table0_Name[5] = MenPaiFirstOne_BattleTable_Name5
	g_MenPaiFirstOne_BattleTable_Table0_Name[6] = MenPaiFirstOne_BattleTable_Name6
	g_MenPaiFirstOne_BattleTable_Table0_Name[7] = MenPaiFirstOne_BattleTable_Name7
	g_MenPaiFirstOne_BattleTable_Table0_Name[8] = MenPaiFirstOne_BattleTable_Name8
	g_MenPaiFirstOne_BattleTable_Table0_Name[9] = MenPaiFirstOne_BattleTable_Name9
	g_MenPaiFirstOne_BattleTable_Table0_Name[10] = MenPaiFirstOne_BattleTable_Name10
	g_MenPaiFirstOne_BattleTable_Table0_Name[11] = MenPaiFirstOne_BattleTable_Name11
	g_MenPaiFirstOne_BattleTable_Table0_Name[12] = MenPaiFirstOne_BattleTable_Name12
	g_MenPaiFirstOne_BattleTable_Table0_Name[13] = MenPaiFirstOne_BattleTable_Name13
	g_MenPaiFirstOne_BattleTable_Table0_Name[14] = MenPaiFirstOne_BattleTable_Name14
	g_MenPaiFirstOne_BattleTable_Table0_Name[15] = MenPaiFirstOne_BattleTable_Name15
	g_MenPaiFirstOne_BattleTable_Table0_Name[16] = MenPaiFirstOne_BattleTable_Name16

	g_MenPaiFirstOne_BattleTable_Table0_BK[1] = MenPaiFirstOne_BattleTable_Name1BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[2] = MenPaiFirstOne_BattleTable_Name2BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[3] = MenPaiFirstOne_BattleTable_Name3BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[4] = MenPaiFirstOne_BattleTable_Name4BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[5] = MenPaiFirstOne_BattleTable_Name5BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[6] = MenPaiFirstOne_BattleTable_Name6BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[7] = MenPaiFirstOne_BattleTable_Name7BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[8] = MenPaiFirstOne_BattleTable_Name8BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[9] = MenPaiFirstOne_BattleTable_Name9BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[10] = MenPaiFirstOne_BattleTable_Name10BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[11] = MenPaiFirstOne_BattleTable_Name11BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[12] = MenPaiFirstOne_BattleTable_Name12BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[13] = MenPaiFirstOne_BattleTable_Name13BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[14] = MenPaiFirstOne_BattleTable_Name14BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[15] = MenPaiFirstOne_BattleTable_Name15BK
	g_MenPaiFirstOne_BattleTable_Table0_BK[16] = MenPaiFirstOne_BattleTable_Name16BK

	g_MenPaiFirstOne_BattleTable_Table0_Animate[1] = MenPaiFirstOne_BattleTable_Name1Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[2] = MenPaiFirstOne_BattleTable_Name2Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[3] = MenPaiFirstOne_BattleTable_Name3Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[4] = MenPaiFirstOne_BattleTable_Name4Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[5] = MenPaiFirstOne_BattleTable_Name5Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[6] = MenPaiFirstOne_BattleTable_Name6Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[7] = MenPaiFirstOne_BattleTable_Name7Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[8] = MenPaiFirstOne_BattleTable_Name8Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[9] = MenPaiFirstOne_BattleTable_Name9Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[10] = MenPaiFirstOne_BattleTable_Name10Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[11] = MenPaiFirstOne_BattleTable_Name11Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[12] = MenPaiFirstOne_BattleTable_Name12Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[13] = MenPaiFirstOne_BattleTable_Name13Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[14] = MenPaiFirstOne_BattleTable_Name14Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[15] = MenPaiFirstOne_BattleTable_Name15Animate
	g_MenPaiFirstOne_BattleTable_Table0_Animate[16] = MenPaiFirstOne_BattleTable_Name16Animate

	g_MenPaiFirstOne_BattleTable_Table0_Line[1] = MenPaiFirstOne_BattleTable_Line1
	g_MenPaiFirstOne_BattleTable_Table0_Line[2] = MenPaiFirstOne_BattleTable_Line2
	g_MenPaiFirstOne_BattleTable_Table0_Line[3] = MenPaiFirstOne_BattleTable_Line3
	g_MenPaiFirstOne_BattleTable_Table0_Line[4] = MenPaiFirstOne_BattleTable_Line4
	g_MenPaiFirstOne_BattleTable_Table0_Line[5] = MenPaiFirstOne_BattleTable_Line5
	g_MenPaiFirstOne_BattleTable_Table0_Line[6] = MenPaiFirstOne_BattleTable_Line6
	g_MenPaiFirstOne_BattleTable_Table0_Line[7] = MenPaiFirstOne_BattleTable_Line7
	g_MenPaiFirstOne_BattleTable_Table0_Line[8] = MenPaiFirstOne_BattleTable_Line8
	g_MenPaiFirstOne_BattleTable_Table0_Line[9] = MenPaiFirstOne_BattleTable_Line9
	g_MenPaiFirstOne_BattleTable_Table0_Line[10] = MenPaiFirstOne_BattleTable_Line10
	g_MenPaiFirstOne_BattleTable_Table0_Line[11] = MenPaiFirstOne_BattleTable_Line11
	g_MenPaiFirstOne_BattleTable_Table0_Line[12] = MenPaiFirstOne_BattleTable_Line12
	g_MenPaiFirstOne_BattleTable_Table0_Line[13] = MenPaiFirstOne_BattleTable_Line13
	g_MenPaiFirstOne_BattleTable_Table0_Line[14] = MenPaiFirstOne_BattleTable_Line14
	g_MenPaiFirstOne_BattleTable_Table0_Line[15] = MenPaiFirstOne_BattleTable_Line15
	g_MenPaiFirstOne_BattleTable_Table0_Line[16] = MenPaiFirstOne_BattleTable_Line16

	g_MenPaiFirstOne_BattleTable_Table1_Name[1] = MenPaiFirstOne_BattleTable_Name21
	g_MenPaiFirstOne_BattleTable_Table1_Name[2] = MenPaiFirstOne_BattleTable_Name22
	g_MenPaiFirstOne_BattleTable_Table1_Name[3] = MenPaiFirstOne_BattleTable_Name23
	g_MenPaiFirstOne_BattleTable_Table1_Name[4] = MenPaiFirstOne_BattleTable_Name24
	g_MenPaiFirstOne_BattleTable_Table1_Name[5] = MenPaiFirstOne_BattleTable_Name25
	g_MenPaiFirstOne_BattleTable_Table1_Name[6] = MenPaiFirstOne_BattleTable_Name26
	g_MenPaiFirstOne_BattleTable_Table1_Name[7] = MenPaiFirstOne_BattleTable_Name27
	g_MenPaiFirstOne_BattleTable_Table1_Name[8] = MenPaiFirstOne_BattleTable_Name28

	g_MenPaiFirstOne_BattleTable_Table1_BK[1] = MenPaiFirstOne_BattleTable_Name21BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[2] = MenPaiFirstOne_BattleTable_Name22BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[3] = MenPaiFirstOne_BattleTable_Name23BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[4] = MenPaiFirstOne_BattleTable_Name24BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[5] = MenPaiFirstOne_BattleTable_Name25BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[6] = MenPaiFirstOne_BattleTable_Name26BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[7] = MenPaiFirstOne_BattleTable_Name27BK
	g_MenPaiFirstOne_BattleTable_Table1_BK[8] = MenPaiFirstOne_BattleTable_Name28BK

	g_MenPaiFirstOne_BattleTable_Table1_Animate[1] = MenPaiFirstOne_BattleTable_Name21Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[2] = MenPaiFirstOne_BattleTable_Name22Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[3] = MenPaiFirstOne_BattleTable_Name23Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[4] = MenPaiFirstOne_BattleTable_Name24Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[5] = MenPaiFirstOne_BattleTable_Name25Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[6] = MenPaiFirstOne_BattleTable_Name26Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[7] = MenPaiFirstOne_BattleTable_Name27Animate
	g_MenPaiFirstOne_BattleTable_Table1_Animate[8] = MenPaiFirstOne_BattleTable_Name28Animate

	g_MenPaiFirstOne_BattleTable_Table1_Line[1] = MenPaiFirstOne_BattleTable_Line17
	g_MenPaiFirstOne_BattleTable_Table1_Line[2] = MenPaiFirstOne_BattleTable_Line18
	g_MenPaiFirstOne_BattleTable_Table1_Line[3] = MenPaiFirstOne_BattleTable_Line19
	g_MenPaiFirstOne_BattleTable_Table1_Line[4] = MenPaiFirstOne_BattleTable_Line20
	g_MenPaiFirstOne_BattleTable_Table1_Line[5] = MenPaiFirstOne_BattleTable_Line21
	g_MenPaiFirstOne_BattleTable_Table1_Line[6] = MenPaiFirstOne_BattleTable_Line22
	g_MenPaiFirstOne_BattleTable_Table1_Line[7] = MenPaiFirstOne_BattleTable_Line23
	g_MenPaiFirstOne_BattleTable_Table1_Line[8] = MenPaiFirstOne_BattleTable_Line24

	g_MenPaiFirstOne_BattleTable_Table2_Name[1] = MenPaiFirstOne_BattleTable_Name31
	g_MenPaiFirstOne_BattleTable_Table2_Name[2] = MenPaiFirstOne_BattleTable_Name32
	g_MenPaiFirstOne_BattleTable_Table2_Name[3] = MenPaiFirstOne_BattleTable_Name33
	g_MenPaiFirstOne_BattleTable_Table2_Name[4] = MenPaiFirstOne_BattleTable_Name34

	g_MenPaiFirstOne_BattleTable_Table2_BK[1] = MenPaiFirstOne_BattleTable_Name31BK
	g_MenPaiFirstOne_BattleTable_Table2_BK[2] = MenPaiFirstOne_BattleTable_Name32BK
	g_MenPaiFirstOne_BattleTable_Table2_BK[3] = MenPaiFirstOne_BattleTable_Name33BK
	g_MenPaiFirstOne_BattleTable_Table2_BK[4] = MenPaiFirstOne_BattleTable_Name34BK

	g_MenPaiFirstOne_BattleTable_Table2_Animate[1] = MenPaiFirstOne_BattleTable_Name31Animate
	g_MenPaiFirstOne_BattleTable_Table2_Animate[2] = MenPaiFirstOne_BattleTable_Name32Animate
	g_MenPaiFirstOne_BattleTable_Table2_Animate[3] = MenPaiFirstOne_BattleTable_Name33Animate
	g_MenPaiFirstOne_BattleTable_Table2_Animate[4] = MenPaiFirstOne_BattleTable_Name34Animate

	g_MenPaiFirstOne_BattleTable_Table2_Line[1] = MenPaiFirstOne_BattleTable_Line25
	g_MenPaiFirstOne_BattleTable_Table2_Line[2] = MenPaiFirstOne_BattleTable_Line26
	g_MenPaiFirstOne_BattleTable_Table2_Line[3] = MenPaiFirstOne_BattleTable_Line27
	g_MenPaiFirstOne_BattleTable_Table2_Line[4] = MenPaiFirstOne_BattleTable_Line28

	g_MenPaiFirstOne_BattleTable_Table3_Name[1] = MenPaiFirstOne_BattleTable_Name41
	g_MenPaiFirstOne_BattleTable_Table3_Name[2] = MenPaiFirstOne_BattleTable_Name42

	g_MenPaiFirstOne_BattleTable_Table3_BK[1] = MenPaiFirstOne_BattleTable_Name41BK
	g_MenPaiFirstOne_BattleTable_Table3_BK[2] = MenPaiFirstOne_BattleTable_Name43BK

	g_MenPaiFirstOne_BattleTable_Table3_Animate[1] = MenPaiFirstOne_BattleTable_Name41Animate
	g_MenPaiFirstOne_BattleTable_Table3_Animate[2] = MenPaiFirstOne_BattleTable_Name42Animate

	g_MenPaiFirstOne_BattleTable_Table3_Line[1] = MenPaiFirstOne_BattleTable_Line29
	g_MenPaiFirstOne_BattleTable_Table3_Line[2] = MenPaiFirstOne_BattleTable_Line30

	g_MenPaiFirstOne_BattleTable_Table4_Name[1] = MenPaiFirstOne_BattleTable_Name51
	g_MenPaiFirstOne_BattleTable_Table4_Animate[1] = MenPaiFirstOne_BattleTable_Name51Animate
end

function MenPaiFirstOne_BattleTable_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89316801 ) then
        local targetId = Get_XParam_INT(0)
		if targetId == -1 then
			MenPaiFirstOne_BattleTable_Close()
			return
		end

		local objId = DataPool : GetNPCIDByServerID(targetId)
		if objId == -1 then
			return
		end

		g_SeverData.targetId = targetId
		this : CareObject( objId, 1, "MenPaiFirstOne_BattleTable" )

		g_SeverData.isInBaoMing = Get_XParam_INT(1)
		g_SeverData.isInYaZhu = Get_XParam_INT(2)
		g_SeverData.yazhuWeek = Get_XParam_INT(3)
		g_SeverData.yazhuGuid = Get_XParam_INT(4)
		g_SeverData.matchWeek = Get_XParam_INT(5)
		g_SeverData.isInMatch = Get_XParam_INT(6)
		g_SeverData.yazhuPrize = Get_XParam_INT(7)
		g_SeverData.huodongType = Get_XParam_INT(8)

	elseif event == "DDZ_OPEN_RANKINGCHARTS" then

		g_CurMenPai = Player : GetData("MEMPAI");		--获取玩家门派ID
		if g_CurMenPai == 9 then
			g_CurMenPai = 0
		end

		if(IsWindowShow("MenPaiFirstOne_BattleBet")) then
			CloseWindow("MenPaiFirstOne_BattleBet", true);
		end

		MenPaiFirstOne_BattleTable_Update()
		this : Show()

	elseif ( event=="DDZ_UPDATE_RANKINGCHARTS" ) then
		if( this:IsVisible() == false ) then
			return
		end

		MenPaiFirstOne_BattleTable_Update()

	elseif (event=="PLAYER_LEAVE_WORLD") then
		MenPaiFirstOne_BattleTable_Close()

	elseif (event == "ADJEST_UI_POS" ) then
		MenPaiFirstOne_BattleTable_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		MenPaiFirstOne_BattleTable_Frame_On_ResetPos()

	end
end


function MenPaiFirstOne_BattleTable_Update()

	MenPaiFirstOne_BattleTable_YaZhuInfo( )
	MenPaiFirstOne_BattleTable_MatchInfo(g_CurMenPai)

end

function MenPaiFirstOne_BattleTable_YaZhuInfo( )

	if g_SeverData.isInBaoMing == 1 then
		MenPaiFirstOne_BattleTable_Bet_Info:SetText("#{MPDYR_20220427_118}")

	elseif g_SeverData.isInYaZhu == 1 then
		if g_SeverData.yazhuWeek == g_SeverData.matchWeek and g_SeverData.yazhuGuid > 0 then
			local menpai = Player : GetData("MEMPAI")
			local name = MenPaiFirstOne_BattleTable_GetYaZhuInfo(menpai, g_SeverData.yazhuGuid)
			local msg = ScriptGlobal_Format("#{MPDYR_20220427_120}", name)
			MenPaiFirstOne_BattleTable_Bet_Info:SetText(msg)
		else
			MenPaiFirstOne_BattleTable_Bet_Info:SetText("#{MPDYR_20220427_119}")
		end

	elseif g_SeverData.isInMatch == 1 then
		if g_SeverData.yazhuWeek == g_SeverData.matchWeek and g_SeverData.yazhuGuid > 0 then
			local menpai = Player : GetData("MEMPAI")
			local name = MenPaiFirstOne_BattleTable_GetYaZhuInfo(menpai, g_SeverData.yazhuGuid)
			local msg = ScriptGlobal_Format("#{MPDYR_20220427_120}", name)
			MenPaiFirstOne_BattleTable_Bet_Info:SetText(msg)
		else
			MenPaiFirstOne_BattleTable_Bet_Info:SetText("#{MPDYR_20220427_121}")
		end

	elseif g_SeverData.huodongType == 0 then
		MenPaiFirstOne_BattleTable_Bet_Info:SetText("#{MPDYR_20220427_118}")
		
	elseif g_SeverData.huodongType == 2 then
		MenPaiFirstOne_BattleTable_Bet_Info:SetText("#{MPDYR_20220427_122}")
	end
end


function MenPaiFirstOne_BattleTable_MenPai_Click( menpai )
	--local curTime = OSAPI:GetTickCount()
	--if ( curTime - g_LastClickTime < g_CDTime * 1000) then
	--	PushDebugMessage("#{MPDYR_20220427_49}")
	--	return
	--end
	--g_LastClickTime = curTime

	g_CurMenPai = menpai
	MenPaiFirstOne_BattleTable_MatchInfo(g_CurMenPai)
end


function MenPaiFirstOne_BattleTable_Init( menpai )

	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_MenPai) do
		if g_MenPaiFirstOne_BattleTable_MenPai[index] ~= nil then
			g_MenPaiFirstOne_BattleTable_MenPai[index] : SetCheck(0)
		end
	end
	g_MenPaiFirstOne_BattleTable_MenPai[menpai + 1] : SetCheck(1)


	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_Table0_Name) do
		g_MenPaiFirstOne_BattleTable_Table0_Name[index] : SetText("#{MPDYR_20220427_55}")
		g_MenPaiFirstOne_BattleTable_Table0_BK[index] : SetProperty("Image", MenPaiFirstOne_BattleTable_Normal)
		g_MenPaiFirstOne_BattleTable_Table0_Animate[index] : Hide()
		g_MenPaiFirstOne_BattleTable_Table0_Line[index] : Hide()
	end

	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_Table1_Name) do
		g_MenPaiFirstOne_BattleTable_Table1_Name[index] : SetText("#{MPDYR_20220427_55}")
		g_MenPaiFirstOne_BattleTable_Table1_BK[index] : SetProperty("Image", MenPaiFirstOne_BattleTable_Normal)
		g_MenPaiFirstOne_BattleTable_Table1_Animate[index] : Hide()
		g_MenPaiFirstOne_BattleTable_Table1_Line[index] : Hide()
	end

	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_Table2_Name) do
		g_MenPaiFirstOne_BattleTable_Table2_Name[index] : SetText("#{MPDYR_20220427_55}")
		g_MenPaiFirstOne_BattleTable_Table2_BK[index] : SetProperty("Image", MenPaiFirstOne_BattleTable_Normal)
		g_MenPaiFirstOne_BattleTable_Table2_Animate[index] : Hide()
		g_MenPaiFirstOne_BattleTable_Table2_Line[index] : Hide()
	end

	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_Table3_Name) do
		g_MenPaiFirstOne_BattleTable_Table3_Name[index] : SetText("#{MPDYR_20220427_55}")
		g_MenPaiFirstOne_BattleTable_Table3_BK[index] : SetProperty("Image", MenPaiFirstOne_BattleTable_Normal)
		g_MenPaiFirstOne_BattleTable_Table3_Animate[index] : Hide()
		g_MenPaiFirstOne_BattleTable_Table3_Line[index] : Hide()
	end

	for index=1, table.getn(g_MenPaiFirstOne_BattleTable_Table4_Name) do
		g_MenPaiFirstOne_BattleTable_Table4_Name[index] : SetText("#{MPDYR_20220427_55}")
		g_MenPaiFirstOne_BattleTable_Table4_Animate[index] : Hide()
	end
end


function MenPaiFirstOne_BattleTable_MatchInfo( menpai )

	MenPaiFirstOne_BattleTable_Init( menpai )

	for index=0, g_MaxPlayer-1 do
		local name, guid, sourceRank, rank0, rank1, rank2, rank3, pkResult, prizeFlag = DataPool:Lua_GetDDZMatchInfo(menpai, index)
		if name == nil or name == "" then
			break
		end

		local fixRank = MenPaiFirstOne_BattleTable_FixSourceRank(sourceRank)
		if fixRank >= 1 then
			g_MenPaiFirstOne_BattleTable_Table0_Name[fixRank]:SetText(name)

			if guid == GetSelfGUID() then
				g_MenPaiFirstOne_BattleTable_Table0_Animate[fixRank]:Show()
			end
		end

		if rank0 >= 1 and fixRank >= 1 then
			g_MenPaiFirstOne_BattleTable_Table1_Name[rank0]:SetText(name)
			g_MenPaiFirstOne_BattleTable_Table0_BK[fixRank]:SetProperty("Image", MenPaiFirstOne_BattleTable_Sheng)
			g_MenPaiFirstOne_BattleTable_Table0_Line[fixRank] : Show()

			if guid == GetSelfGUID() then
				g_MenPaiFirstOne_BattleTable_Table1_Animate[rank0]:Show()
			end
		end

		if rank1 >= 1 and rank0 >= 0 then
			g_MenPaiFirstOne_BattleTable_Table2_Name[rank1]:SetText(name)
			g_MenPaiFirstOne_BattleTable_Table1_BK[rank0]:SetProperty("Image", MenPaiFirstOne_BattleTable_Sheng)
			g_MenPaiFirstOne_BattleTable_Table1_Line[rank0] : Show()

			if guid == GetSelfGUID() then
				g_MenPaiFirstOne_BattleTable_Table2_Animate[rank1]:Show()
			end
		end

		if rank2 >= 1 and rank1 >= 1 then
			g_MenPaiFirstOne_BattleTable_Table3_Name[rank2]:SetText(name)
			g_MenPaiFirstOne_BattleTable_Table2_BK[rank1]:SetProperty("Image", MenPaiFirstOne_BattleTable_Sheng)
			g_MenPaiFirstOne_BattleTable_Table2_Line[rank1] : Show()

			if guid == GetSelfGUID() then
				g_MenPaiFirstOne_BattleTable_Table3_Animate[rank2]:Show()
			end
		end

		if rank3 == 1 and rank2 >= 1 then
			g_MenPaiFirstOne_BattleTable_Table4_Name[rank3]:SetText(name)

			g_MenPaiFirstOne_BattleTable_Table3_BK[rank2]:SetProperty("Image", MenPaiFirstOne_BattleTable_Sheng)
			g_MenPaiFirstOne_BattleTable_Table3_Line[rank2] : Show()

			if guid == GetSelfGUID() then
				g_MenPaiFirstOne_BattleTable_Table4_Animate[rank3]:Show()
			end
		end

	end

	local haveQualified, haveGetPrize = MenPaiFirstOne_BattleTable_GetPrizeFlag(menpai)
	if haveQualified == 1 then
		MenPaiFirstOne_BattleTable_Get:Enable()
	else
		MenPaiFirstOne_BattleTable_Get:Disable()
	end
end

function MenPaiFirstOne_BattleTable_Prize_Click( )
	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPDYR_20220427_57}")
		return
	end

	local haveQualified, haveGetPrize = MenPaiFirstOne_BattleTable_GetPrizeFlag(g_CurMenPai)

	if haveQualified == 0 then
		PushDebugMessage("#{MPDYR_20220427_60}")
		return
	end

	if haveGetPrize == 1 then
		PushDebugMessage("#{MPDYR_20220427_61}")
		return
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("TryToTakePrize")
		Set_XSCRIPT_ScriptID(893171);
		Set_XSCRIPT_Parameter(0, g_SeverData.targetId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();

end


function MenPaiFirstOne_BattleTable_GetPrizeFlag(menpai)

	local haveQualified = 0
	local haveGetPrize = 0

	local myGUID = Player:GetGUID()
	for index=0, g_MaxPlayer-1 do
		local name, guid, sourceRank, rank0, rank1, rank2, rank3, pkResult, prizeFlag = DataPool:Lua_GetDDZMatchInfo(menpai, index)

		if guid ~= nil and guid == myGUID then
			haveQualified = 1
			haveGetPrize = prizeFlag
			break
		end
	end

	return haveQualified, haveGetPrize

end


function MenPaiFirstOne_BattleTable_GetYaZhuInfo(menpai, yazhuGuid)

	for index=0, g_MaxPlayer-1 do
		local name, guid, sourceRank, rank0, rank1, rank2, rank3, pkResult, prizeFlag = DataPool:Lua_GetDDZMatchInfo(menpai, index)

		if guid ~= nil and guid == yazhuGuid then
			return name
		end
	end

	return ""

end

function MenPaiFirstOne_BattleTable_Frame_On_ResetPos()

	MenPaiFirstOne_BattleTable_Frame : SetProperty("UnifiedXPosition", g_MenPaiFirstOne_BattleTable_Frame_UnifiedXPosition);
	MenPaiFirstOne_BattleTable_Frame : SetProperty("UnifiedYPosition", g_MenPaiFirstOne_BattleTable_Frame_UnifiedYPosition);

end


function MenPaiFirstOne_BattleTable_Preview_Click()
	PushEvent("DDZ_OPEN_PRIZE")
end

function MenPaiFirstOne_BattleTable_Help_Click()
	PushEvent("QUEST_HELPINFO", "#{MPDYR_20220427_26}")
end

function MenPaiFirstOne_BattleTable_Close()
	if( this:IsVisible() == true ) then
		this:Hide()
	end
end

function MenPaiFirstOne_BattleTable_FixSourceRank( rank )

	for i=1, table.getn(g_SourceRank) do
		if g_SourceRank[i] == rank then
			return g_FixRank[i]
		end
	end

	return -1
end

function MenPaiFirstOne_BattleTable_YaZhu_Click()

	local myLevel = Player:GetData("LEVEL")
	if myLevel < g_NeedLevel then
		PushDebugMessage("#{MPDYR_20220427_124}")
		return
	end

	local menpai = Player : GetData("MEMPAI");
	if menpai == 9 then
		PushDebugMessage("#{MPDYR_20220427_125}")
		return
	end

	PushEvent("DDZ_OPEN_YAZHU", g_SeverData.targetId)
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("UpdateYaZhuPrize")
		Set_XSCRIPT_ScriptID(893168);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	 
	this:Hide()
end

