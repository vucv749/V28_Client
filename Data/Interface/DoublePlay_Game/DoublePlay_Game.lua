local g_DoublePlay_Game_Frame_UnifiedPosition
local g_DoublePlay_MiniOpen = 1

local DoublePlay_TeamInfo= {}
local DoublePlay_TeamStr= 
{
	[1] = "#{SRWF_230329_217}",
	[2] = "#{SRWF_230329_218}",
	[3] = "#{SRWF_230329_219}",
	[4] = "#{SRWF_230329_220}",
	[5] = "#{SRWF_230329_221}",
}

--ÕÊº“”√R 
local DoublePlay_Game1PIC_TIMU =
{
	[0] = {image = "set:DoubleGame01 image:DoubleGame_Y0"},
	[1] = {image = "set:DoubleGame01 image:DoubleGame_Y1"},
	[2] = {image = "set:DoubleGame01 image:DoubleGame_Y2"},
	[3] = {image = "set:DoubleGame01 image:DoubleGame_Y3"},
	[4] = {image = "set:DoubleGame01 image:DoubleGame_Y4"},
	[5] = {image = "set:DoubleGame01 image:DoubleGame_Y5"},
	[6] = {image = "set:DoubleGame01 image:DoubleGame_Y6"},
	[7] = {image = "set:DoubleGame01 image:DoubleGame_Y7"},
	[8] = {image = "set:DoubleGame01 image:DoubleGame_Y8"},
	[9] = {image = "set:DoubleGame01 image:DoubleGame_Y9"},
}

--Ã‚ƒø”√Y
local DoublePlay_Game1PIC =
{
	[0] = {image = "set:DoubleGame01 image:DoubleGame_R0"},
	[1] = {image = "set:DoubleGame01 image:DoubleGame_R1"},
	[2] = {image = "set:DoubleGame01 image:DoubleGame_R2"},
	[3] = {image = "set:DoubleGame01 image:DoubleGame_R3"},
	[4] = {image = "set:DoubleGame01 image:DoubleGame_R4"},
	[5] = {image = "set:DoubleGame01 image:DoubleGame_R5"},
	[6] = {image = "set:DoubleGame01 image:DoubleGame_R6"},
	[7] = {image = "set:DoubleGame01 image:DoubleGame_R7"},
	[8] = {image = "set:DoubleGame01 image:DoubleGame_R8"},
	[9] = {image = "set:DoubleGame01 image:DoubleGame_R9"},
}

local DoublePlay_Game1OP =
{
	[1] = {image = "set:DoubleGame01 image:DoubleGame_YJH"}, --+
	[2] = {image = "set:DoubleGame01 image:DoubleGame_YCH"}, --*
}

local DoublePlay_Game1DD =
{
	[1] = {image = "set:DoubleGame01 image:DoubleGame_BKHover"}, --+
	[2] = {image = "set:DoubleGame01 image:DoubleGame_BKnormal"}, --*
}

local DoublePlay_Game2PIC =
{
	[1]  = {image = "set:DoubleGame01 image:DoubleGame_BSSCH"},
	[2]  = {image = "set:DoubleGame01 image:DoubleGame_FSSCH"},
	[3]  = {image = "set:DoubleGame01 image:DoubleGame_HSSCH"},
	[4]  = {image = "set:DoubleGame01 image:DoubleGame_HSSCH2"},
	[5]  = {image = "set:DoubleGame01 image:DoubleGame_LSSCH"},
	[6]  = {image = "set:DoubleGame01 image:DoubleGame_DDLJ"},
	[7]  = {image = "set:DoubleGame01 image:DoubleGame_DD"},
	[8]  = {image = "set:DoubleGame01 image:DoubleGame_GQZ"},
	[9]  = {image = "set:DoubleGame01 image:DoubleGame_HG"},
	[10] = {image = "set:DoubleGame01 image:DoubleGame_SCHD"},
}

local DoublePlay_Game1Right = 
{
	[1] = {image = "set:DoubleGame01 image:DoubleGame_Wrong"},
	[2] = {image = "set:DoubleGame01 image:DoubleGame_Right"},
}

local DoublePlay_Game_GameRound ={}
local DoublePlay_Game_GameRank ={}
local DoublePlay_Game_GameNum ={}
local DoublePlay_Game_RankText1 = {}
local DoublePlay_Game_RankText2 = {}
local DoublePlay_Game_RankText3 = {}
local DoublePlay_Game_RankText32 = {}
local DoublePlay_Game_RankText4 = {}
local DoublePlay_Game_MyTeam = {}

function DoublePlay_Game_PreLoad()

	this:RegisterEvent("UI_COMMAND",true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)

end


function DoublePlay_Game_OnLoad()

	g_DoublePlay_Game_Frame_UnifiedPosition = DoublePlay_Game_Frame:GetProperty("UnifiedPosition")
	
	--∂”ŒÈ–≈œ¢
	DoublePlay_TeamInfo[1]	= DoublePlay_ListContent_TeamInfo2
	DoublePlay_TeamInfo[2]	= DoublePlay_ListContent_TeamInfo3
	DoublePlay_TeamInfo[3]	= DoublePlay_ListContent_TeamInfo4
	DoublePlay_TeamInfo[4]	= DoublePlay_ListContent_TeamInfo5
	DoublePlay_TeamInfo[5]	= DoublePlay_ListContent_TeamInfo6


	DoublePlay_Game_GameRound[1] = DoublePlay_Game_Game1Round
	DoublePlay_Game_GameRound[2] = DoublePlay_Game_Game2Round
	DoublePlay_Game_GameRound[3] = DoublePlay_Game_Game3Round
	
	DoublePlay_Game_GameRank[1] = DoublePlay_Game_Game1Rank
	DoublePlay_Game_GameRank[2] = DoublePlay_Game_Game2Rank
	DoublePlay_Game_GameRank[3] = DoublePlay_Game_Game3Rank

	DoublePlay_Game_GameNum[1] = DoublePlay_Game_Game1Num
	DoublePlay_Game_GameNum[2] = DoublePlay_Game_Game2Num
	DoublePlay_Game_GameNum[3] = DoublePlay_Game_Game3Num

	DoublePlay_Game_RankText1[1] = DoublePlay_Game_Rank1Text1
	DoublePlay_Game_RankText1[2] = DoublePlay_Game_Rank2Text1
	DoublePlay_Game_RankText1[3] = DoublePlay_Game_Rank3Text1
	DoublePlay_Game_RankText1[4] = DoublePlay_Game_Rank4Text1
	DoublePlay_Game_RankText1[5] = DoublePlay_Game_Rank5Text1

	DoublePlay_Game_RankText2[1] = DoublePlay_Game_Rank1Text2
	DoublePlay_Game_RankText2[2] = DoublePlay_Game_Rank2Text2
	DoublePlay_Game_RankText2[3] = DoublePlay_Game_Rank3Text2
	DoublePlay_Game_RankText2[4] = DoublePlay_Game_Rank4Text2
	DoublePlay_Game_RankText2[5] = DoublePlay_Game_Rank5Text2

	DoublePlay_Game_RankText3[1] = DoublePlay_Game_Rank1Text3
	DoublePlay_Game_RankText3[2] = DoublePlay_Game_Rank2Text3
	DoublePlay_Game_RankText3[3] = DoublePlay_Game_Rank3Text3
	DoublePlay_Game_RankText3[4] = DoublePlay_Game_Rank4Text3
	DoublePlay_Game_RankText3[5] = DoublePlay_Game_Rank5Text3

	DoublePlay_Game_RankText32[1] = DoublePlay_Game_Rank1Text3_2
	DoublePlay_Game_RankText32[2] = DoublePlay_Game_Rank2Text3_2
	DoublePlay_Game_RankText32[3] = DoublePlay_Game_Rank3Text3_2
	DoublePlay_Game_RankText32[4] = DoublePlay_Game_Rank4Text3_2
	DoublePlay_Game_RankText32[5] = DoublePlay_Game_Rank5Text3_2

	DoublePlay_Game_RankText4[1] = DoublePlay_Game_Rank1Text4
	DoublePlay_Game_RankText4[2] = DoublePlay_Game_Rank2Text4
	DoublePlay_Game_RankText4[3] = DoublePlay_Game_Rank3Text4
	DoublePlay_Game_RankText4[4] = DoublePlay_Game_Rank4Text4
	DoublePlay_Game_RankText4[5] = DoublePlay_Game_Rank5Text4

	DoublePlay_Game_MyTeam[1] = DoublePlay_Game_Rank1Line2
	DoublePlay_Game_MyTeam[2] = DoublePlay_Game_Rank2Line2
	DoublePlay_Game_MyTeam[3] = DoublePlay_Game_Rank3Line2
	DoublePlay_Game_MyTeam[4] = DoublePlay_Game_Rank4Line2
	DoublePlay_Game_MyTeam[5] = DoublePlay_Game_Rank5Line2

end


function DoublePlay_Game_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99829701) then		
        local nRight = Get_XParam_INT(0) --Right
		local remainingtTime = Get_XParam_INT(1)
		local GameType = Get_XParam_INT(2) --????
		local Round   = Get_XParam_INT(3) --??
		local MyRTData  = Get_XParam_INT(4) --????
		local MyScore = Get_XParam_INT(5) --????
		local PicData = Get_XParam_INT(6) --PIC??
		local nReOpen = Get_XParam_INT(7) --NULL Game2??
		-----------œ¬√ÊΩÁ√Ê ˝æ›---------------
		local RankData1  = Get_XParam_INT(8) --????
		local RankData2  = Get_XParam_INT(9) --????
		local TeamData1 = Get_XParam_INT(10) --??????1
		local TeamData2 = Get_XParam_INT(11) --??????2
		local TeamData3 = Get_XParam_INT(12) --??????3
		local TeamData4 = Get_XParam_INT(13) --??????4
		local TeamData5 = Get_XParam_INT(14) --??????5

		local MyRank = math.floor(math.mod(MyRTData/10,10))
		local MyTeam = math.floor(math.mod(MyRTData/1,10))
		--…œ√ÊΩÁ√Ê–≈œ¢
		DoublePlay_Game_SetData(GameType,Round,MyRank,MyScore,PicData,nRight,nReOpen)
		--œ¬√ÊΩÁ√Ê–≈œ¢
		DoublePlay_Game_SetTeamData(GameType,RankData1,RankData2,TeamData1,TeamData2,TeamData3,TeamData4,TeamData5,MyTeam)
		--º∆ ±∆˜
		DoublePlay_Game_TimerProc(remainingtTime)
        this:Show()
	elseif event=="HIDE_ON_SCENE_TRANSED"  then
		DoublePlay_Game_Game1Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",0))
		DoublePlay_Game_Game2Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",0))
		DoublePlay_Game_Game3Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",0))
		this:Hide()
    end
	
	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			DoublePlay_Game_ResetPos()
        end
	end
	
end


function DoublePlay_Game_TimerProc(countTime)

	if countTime <= 0 then
		countTime = 0
    end

    -- £”‡ ±º‰
	DoublePlay_Game_Game1Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",countTime))
	DoublePlay_Game_Game2Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",countTime))
	DoublePlay_Game_Game3Time:SetText(ScriptGlobal_Format("#{SRWF_230329_53}",countTime))
	
end

--…Ë÷√ΩÁ√Ê ˝æ› ¬÷¥Œ ∫Õ ≈≈√˚
function DoublePlay_Game_SetData(GameType,Round,MyRank,MyScore,PicData,nRight,nReOpen)

	--∏ˆŒª
	local PicData1 = math.floor(math.mod(PicData/1,10))
	-- ÆŒª 
	local PicData2 = math.floor(math.mod(PicData/10,10))
	--∞ŸŒª «ßŒª
	local PicData3 = math.floor(math.mod(PicData/100,100))
	--ÕÚŒª
	local PicData4 = math.floor(math.mod(PicData/10000,10)) --???? 1:+ 2:x

	--”Œœ∑¿‡–Õ
	if GameType == 1 then
		--∏ˆŒª  ÆŒª/ÕÊº“À˘≤» ˝◊÷£¨∞ŸŒª «ßŒª/ÀÊª˙µƒ ˝◊÷£¨ÕÚŒª/‘ÀÀ„∑˚∫≈
		DoublePlay_Game_Game1:Show()
		DoublePlay_Game_Game2:Hide()
		DoublePlay_Game_Game3:Hide()
		--PicData1 PicData2 0-9
		if PicData1 == 0 then
			DoublePlay_Game_Game1Image1:SetProperty("Image", "")
			DoublePlay_Game_Game1Image1BK:SetProperty("Image", DoublePlay_Game1DD[1].image)
		else
			DoublePlay_Game_Game1Image1:SetProperty("Image",DoublePlay_Game1PIC[PicData1].image);
			DoublePlay_Game_Game1Image1BK:SetProperty("Image", DoublePlay_Game1DD[2].image)
		end
		if PicData2 == 0 then
			DoublePlay_Game_Game1Image2:SetProperty("Image", "")
			DoublePlay_Game_Game1Image2BK:SetProperty("Image", DoublePlay_Game1DD[1].image)
		else
			DoublePlay_Game_Game1Image2:SetProperty("Image",DoublePlay_Game1PIC[PicData2].image);
			DoublePlay_Game_Game1Image2BK:SetProperty("Image", DoublePlay_Game1DD[2].image)
		end
		local shiwei =  math.floor(math.mod(PicData3/10,10))
		local gewei  =  math.floor(math.mod(PicData3/1,10))
		if PicData3 == 0 then
			DoublePlay_Game_Game1Image3:SetProperty("Image", "");
			DoublePlay_Game_Game1Image4:SetProperty("Image", "");
			DoublePlay_Game_Game1Mark2:SetProperty("Image", "");
			DoublePlay_Game_Game1Image1BK:SetProperty("Image", "");
			DoublePlay_Game_Game1Image2BK:SetProperty("Image", "");
		else
			DoublePlay_Game_Game1Image3:SetProperty("Image",DoublePlay_Game1PIC_TIMU[shiwei].image);
			DoublePlay_Game_Game1Image4:SetProperty("Image",DoublePlay_Game1PIC_TIMU[gewei].image);
			DoublePlay_Game_Game1Mark2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_YDH");
		end
		--‘ÀÀ„∑˚
		if PicData4 == 0 then
			DoublePlay_Game_Game1Mark:SetProperty("Image", "");
		else
			DoublePlay_Game_Game1Mark:SetProperty("Image",DoublePlay_Game1OP[PicData4].image);
		end
		if nRight == 0 then
			DoublePlay_Game_Game1Image5:SetProperty("Image", "");
		else
			DoublePlay_Game_Game1Image5:SetProperty("Image",DoublePlay_Game1Right[nRight].image);
		end
	elseif GameType == 2 then
		DoublePlay_Game_Game1:Hide()
		DoublePlay_Game_Game2:Show()
		DoublePlay_Game_Game3:Hide()
		--PicData1 PicData1 0-10
		PicData1 = math.floor(math.mod(PicData/1,100))
		PicData2 = math.floor(math.mod(PicData/100,100))

		DoublePlay_Game_Game2Image1_2:Show() --set:DoubleGame01 image:DoubleGame_BKHover ??
		DoublePlay_Game_Game2Image2_2:Show() --set:DoubleGame01 image:DoubleGame_BKNormal ??

		local nReOpenAll = math.floor(math.mod(nReOpen/100,10))
		local nReOpen1 = math.floor(math.mod(nReOpen/10,10))
		local nReOpen2 = math.floor(math.mod(nReOpen/1,10))

		if nReOpenAll == 1 then
			DoublePlay_Game_Game2Image1_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKHover");
			DoublePlay_Game_Game2Image1Get:SetProperty("Image","set:DoubleGame01 image:DoubleGame_yihuode");

			DoublePlay_Game_Game2Image2_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKHover");
			DoublePlay_Game_Game2Image2Get:SetProperty("Image","set:DoubleGame01 image:DoubleGame_yihuode");

			DoublePlay_Game_Game2Get1:SetProperty("Image","set:DoubleGame01 image:DoubleGame_WanCheng");
		else
			if nReOpen1 == 1 then
				DoublePlay_Game_Game2Image1_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKHover");
				DoublePlay_Game_Game2Image1Get:SetProperty("Image","set:DoubleGame01 image:DoubleGame_yihuode");
				--DoublePlay_Game_Game2Image1Get:Show()
			else
				--DoublePlay_Game_Game2Image1_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKNormal");
				DoublePlay_Game_Game2Image1Get:SetProperty("Image", "")
				--DoublePlay_Game_Game2Image1Get:Hide()
			end
			if nReOpen2 == 1 then
				DoublePlay_Game_Game2Image2_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKHover");
				DoublePlay_Game_Game2Image2Get:SetProperty("Image","set:DoubleGame01 image:DoubleGame_yihuode");
				--DoublePlay_Game_Game2Image2Get:Show()
			else
				--DoublePlay_Game_Game2Image2_2:SetProperty("Image","set:DoubleGame01 image:DoubleGame_BKNormal");
				DoublePlay_Game_Game2Image2Get:SetProperty("Image", "")
				--DoublePlay_Game_Game2Image2Get:Hide()
			end
			DoublePlay_Game_Game2Get1:SetProperty("Image", "")
		end



		if PicData1 == 0 then
			DoublePlay_Game_Game2Image1:SetProperty("Image", "")
		else
			DoublePlay_Game_Game2Image1:SetProperty("Image",DoublePlay_Game2PIC[PicData1].image);
		end
		if PicData2 == 0 then
			DoublePlay_Game_Game2Image2:SetProperty("Image", "")
		else
			DoublePlay_Game_Game2Image2:SetProperty("Image",DoublePlay_Game2PIC[PicData2].image);
		end
	else
		DoublePlay_Game_Game1:Hide()
		DoublePlay_Game_Game2:Hide()
		DoublePlay_Game_Game3:Show()
	end

	DoublePlay_Game_GameRound[GameType]:SetText(ScriptGlobal_Format("#{SRWF_230329_52}",Round)) --??
	DoublePlay_Game_GameRank[GameType]:SetText("Trﬂæc m£t b‡i danh:"..MyRank) --??

	--Œ“µƒ∑÷ ˝
	if MyScore < 0 then
		MyScore = 0
	end

	DoublePlay_Game_GameNum[GameType]:SetText(ScriptGlobal_Format("#{SRWF_230329_54}", MyScore)) --????:%s0?

end

function DoublePlay_Game_OnHiden()
	this:Hide()
end

function DoublePlay_Game_Close()

end

function DoublePlay_Game_ResetPos()
    DoublePlay_Game_Frame:SetProperty("UnifiedPosition", g_DoublePlay_Game_Frame_UnifiedPosition)
end

function DoublePlay_Game_GameRankInfo_Click()
	if this:IsVisible() then
		if g_DoublePlay_MiniOpen == 1 then
			g_DoublePlay_MiniOpen = 0
			DoublePlay_Game_Rank:Hide()
		else
			g_DoublePlay_MiniOpen = 1
			DoublePlay_Game_Rank:Show()
		end
	end
end

--…Ë÷√∂”ŒÈ ˝æ› ¬÷¥Œ ∫Õ ≈≈√˚
function DoublePlay_Game_SetTeamData(GameType,TeamNumData,TeamRankData,TeamData1,TeamData2,TeamData3,TeamData4,TeamData5,MyTeam)

	--∂”ŒÈ≈≈√˚ TeamRankData
	--∂”ŒÈ√˚◊÷ TeamNumData

	local TeamRank = {}

	TeamRank[1] = math.floor(math.mod(TeamRankData/10000,10))
	TeamRank[2] = math.floor(math.mod(TeamRankData/1000,10))
	TeamRank[3] = math.floor(math.mod(TeamRankData/100,10))
	TeamRank[4] = math.floor(math.mod(TeamRankData/10,10))
	TeamRank[5] = math.floor(math.mod(TeamRankData/1,10))

	local TeamNum = {}
	TeamNum[1] = math.floor(math.mod(TeamNumData/10000,10))
	TeamNum[2] = math.floor(math.mod(TeamNumData/1000,10))
	TeamNum[3] = math.floor(math.mod(TeamNumData/100,10))
	TeamNum[4] = math.floor(math.mod(TeamNumData/10,10))
	TeamNum[5] = math.floor(math.mod(TeamNumData/1,10))

	local TeamData = {TeamData1,TeamData2,TeamData3,TeamData4,TeamData5}
	local EachTeam =
	{
		[1] = {0,0,0},
		[2] = {0,0,0},
		[3] = {0,0,0},
		[4] = {0,0,0},
		[5] = {0,0,0},
	}

	for i = 1,5 do
		EachTeam[i][1] = math.floor(math.mod(TeamData[i]/10000,1000))
		EachTeam[i][2] = math.floor(math.mod(TeamData[i]/10,1000))
		EachTeam[i][3] = math.floor(math.mod(TeamData[i]/1,10))
	end

	for i = 1,5 do
		DoublePlay_Game_RankText1[i]:SetText(TeamRank[i])
		DoublePlay_Game_RankText2[i]:SetText(DoublePlay_TeamStr[TeamNum[i]])
		DoublePlay_Game_RankText3[i]:SetText(EachTeam[i][1])
		if GameType == 1 or GameType == 2 then
			DoublePlay_Game_RankText32[i]:Show()
			DoublePlay_Game_RankText32[i]:SetText(ScriptGlobal_Format("#{SRWF_230329_222}",EachTeam[i][2]))
		else
			DoublePlay_Game_RankText32[i]:Hide()
		end
		if EachTeam[i][3] ~= 0 then
			if GameType == 3 then
				DoublePlay_Game_RankText4[i]:SetText("TrÊ h‡ng")
			else
				DoublePlay_Game_RankText4[i]:SetText("Ho‡n th‡nh")
			end
		else
			if GameType == 3 then
				DoublePlay_Game_RankText4[i]:SetText("Tÿ vong")
			else
				DoublePlay_Game_RankText4[i]:SetText("Chﬂa xong Th‡nh")
			end
		end
	end

	for i=1,5 do
		if MyTeam == TeamNum[i] then
			DoublePlay_Game_MyTeam[i]:Show()
		else
			DoublePlay_Game_MyTeam[i]:Hide()
		end
	end

end
