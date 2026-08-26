--»ªÉ½ÂÛ½£ ÐÂ±ÈÎä´ó»á

local g_HuaShanLunJian_Frame_UnifiedPosition;
local g_HuaShanLunJian_Star3 = {} --3???
local g_HuaShanLunJian_Star4 = {} --4???
local g_HuaShanLunJian_Star5 = {} --5???
local g_HuaShanLunJian_Star6 = {} --6???
local g_HuaShanLunJian_Star8 = {} --8???

local g_HuaShanLunJian_Dw2_Button = {} --???? ?????
local g_HuaShanLunJian_Rank_Button = {} --???? ?????

local g_HuaShanLunJian_DuanWei_ActionItem = {}
local g_HuaShanLunJian_DuanWei_LingQu = {}

local g_HuaShanLunJian_Rank_ActionItem = {}

local g_HuaShanLunJian_PrizeButton = {}
local g_HuaShanLunJian_DuanWei_1
local g_HuaShanLunJian_DuanWei_2
local g_HuaShanLunJian_Rank_1
local g_HuaShanLunJian_Rank_2
local g_HuaShanLunJian_MyRank 
local g_HuaShanLunJian_Rank_LingQu = {}
local g_HuaShanLunJian_TargetId

local g_HuaShanLunJian_RedPoint_Duan
local g_HuaShanLunJian_RedPoint_Jie = {} 
local g_HuaShanLunJian_RedPoint_Button

local g_Duanwei1_Image = {

	[0] = {
		[1] = "set:HSLJ_04 image:HSLJ_Hawk1",
		[2] = "set:HSLJ_04 image:HSLJ_Hawk2",
		[3] = "set:HSLJ_04 image:HSLJ_Hawk3",
		[4] = "set:HSLJ_04 image:HSLJ_Hawk4",
		[5] = "set:HSLJ_04 image:HSLJ_Hawk5",
		[6] = "set:HSLJ_04 image:HSLJ_Hawk6",
	},
	
	[1] = {
		[1] = "set:HSLJ_01 image:HSLJ_Tiger1",
		[2] = "set:HSLJ_01 image:HSLJ_Tiger2",
		[3] = "set:HSLJ_02 image:HSLJ_Tiger3",
		[4] = "set:HSLJ_02 image:HSLJ_Tiger4",
		[5] = "set:HSLJ_02 image:HSLJ_Tiger5",
		[6] = "set:HSLJ_02 image:HSLJ_Tiger6",
	},	

	[2] = {
		[1] = "set:HSLJ_01 image:HSLJ_Dragon1",
		[2] = "set:HSLJ_01 image:HSLJ_Dragon2",
		[3] = "set:HSLJ_01 image:HSLJ_Dragon3",
		[4] = "set:HSLJ_01 image:HSLJ_Dragon4",
		[5] = "set:HSLJ_01 image:HSLJ_Dragon5",
		[6] = "set:HSLJ_01 image:HSLJ_Dragon6",
	},
}
local g_Duanwei1_name = {
	[1] = "#{HSLJ_190919_145}",
	[2] = "#{HSLJ_190919_146}",
	[3] = "#{HSLJ_190919_147}",
	[4] = "#{HSLJ_190919_148}",
	[5] = "#{HSLJ_190919_149}",
	[6] = "#{HSLJ_190919_157}",
}

local g_Duanwei2_Info = {
	[1] = {image="set:HSLJ_Match1 image:Number1", name="#{HSLJ_190919_154}"},
	[2] = {image="set:HSLJ_Match1 image:Number2", name="#{HSLJ_190919_153}"},
	[3] = {image="set:HSLJ_Match1 image:Number3", name="#{HSLJ_190919_152}"},
	[4] = {image="set:HSLJ_Match1 image:Number4", name="#{HSLJ_190919_151}"},
	[5] = {image="set:HSLJ_Match1 image:Number5", name="#{HSLJ_190919_150}"},
}

local g_FightLevel = {
	[1] = "#{HSLJ_190919_142}",
	[2] = "#{HSLJ_190919_143}",
	[3] = "#{HSLJ_190919_144}",
	}

local g_RankText = {
	[1] = "#{HSLJ_190919_229}",
	[2] = "#{HSLJ_190919_230}",
	[3] = "#{HSLJ_190919_231}",
	[4] = "#{HSLJ_190919_232}",
}

local g_RankEggText = {
	[1] = "#{HSLJ_190919_384}",
	[2] = "#{HSLJ_190919_385}",
}

local g_RankAward = {
	[0] = {
		[1] = { {id=10125736, num=1, bind=1}, {id=30310127, num=1, bind=0}, {id=38002485, num=1, bind=1}, {id=38003177, num=1, bind=1} },
		[2] = { {id=10125736, num=1, bind=1}, {id=30310127, num=1, bind=0}, {id=38002486, num=1, bind=1} },
		[3] = { {id=10125736, num=1, bind=1}, {id=38002487, num=1, bind=1} },
	},
	[1] = {
		[1] = { {id=10125736, num=1, bind=1}, {id=30310128, num=1, bind=0}, {id=38002418, num=1, bind=1}, {id=38003177, num=1, bind=1} },
		[2] = { {id=10125736, num=1, bind=1}, {id=30310128, num=1, bind=0}, {id=38002419, num=1, bind=1} },
		[3] = { {id=10125736, num=1, bind=1}, {id=38002420, num=1, bind=1} },
	},	
	[2] = {
		[1] = { {id=10125736, num=1, bind=1}, {id=30310129, num=1, bind=0}, {id=38002421, num=1, bind=1}, {id=38003177, num=1, bind=1} },
		[2] = { {id=10125736, num=1, bind=1}, {id=30310129, num=1, bind=0}, {id=38002422, num=1, bind=1} },
		[3] = { {id=10125736, num=1, bind=1}, {id=38002423, num=1, bind=1} },
	},
}

local g_Bright_Stars = "set:HSLJ_01 image:HSLJ_Star"
local g_Gray_Stars = "set:HSLJ_01 image:HSLJ_StarGray"

local g_DwWangzhe = 6

local g_Reward_Btn_Pos = {}
local g_Reward_Btn_Pos_OnlyOne = "{{0.500000,-25.000000},{0.500000,-40.000000}}"
function HuaShanLunJian_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("XBW_SELF_DETAIL_UPDATE")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_OnLoad()
	g_HuaShanLunJian_Frame_UnifiedPosition = HuaShanLunJian_Frame:GetProperty("UnifiedPosition");

	g_HuaShanLunJian_Star3[1] = HuaShanLunJian_Stage_Star1
	g_HuaShanLunJian_Star3[2] = HuaShanLunJian_Stage_Star2
	g_HuaShanLunJian_Star3[3] = HuaShanLunJian_Stage_Star3

	g_HuaShanLunJian_Star4[1] = HuaShanLunJian_Stage_Star1_1
	g_HuaShanLunJian_Star4[2] = HuaShanLunJian_Stage_Star1_2
	g_HuaShanLunJian_Star4[3] = HuaShanLunJian_Stage_Star1_3
	g_HuaShanLunJian_Star4[4] = HuaShanLunJian_Stage_Star1_4

	g_HuaShanLunJian_Star5[1] = HuaShanLunJian_Stage_Star2_1
	g_HuaShanLunJian_Star5[2] = HuaShanLunJian_Stage_Star2_2
	g_HuaShanLunJian_Star5[3] = HuaShanLunJian_Stage_Star2_3
	g_HuaShanLunJian_Star5[4] = HuaShanLunJian_Stage_Star2_4
	g_HuaShanLunJian_Star5[5] = HuaShanLunJian_Stage_Star2_5
  
	g_HuaShanLunJian_Star6[1] = HuaShanLunJian_Stage_Star4_1
	g_HuaShanLunJian_Star6[2] = HuaShanLunJian_Stage_Star4_2
	g_HuaShanLunJian_Star6[3] = HuaShanLunJian_Stage_Star4_3
	g_HuaShanLunJian_Star6[4] = HuaShanLunJian_Stage_Star4_4
	g_HuaShanLunJian_Star6[5] = HuaShanLunJian_Stage_Star4_5
	g_HuaShanLunJian_Star6[6] = HuaShanLunJian_Stage_Star4_6
  
	g_HuaShanLunJian_Star8[1] = HuaShanLunJian_Stage_Star5_1
	g_HuaShanLunJian_Star8[2] = HuaShanLunJian_Stage_Star5_2
	g_HuaShanLunJian_Star8[3] = HuaShanLunJian_Stage_Star5_3
	g_HuaShanLunJian_Star8[4] = HuaShanLunJian_Stage_Star5_4
	g_HuaShanLunJian_Star8[5] = HuaShanLunJian_Stage_Star5_5
	g_HuaShanLunJian_Star8[6] = HuaShanLunJian_Stage_Star5_6
	g_HuaShanLunJian_Star8[7] = HuaShanLunJian_Stage_Star5_7
	g_HuaShanLunJian_Star8[8] = HuaShanLunJian_Stage_Star5_8
  
	g_HuaShanLunJian_Dw2_Button[1] = HuaShanLunJian_DanAward_LiftOne
	g_HuaShanLunJian_Dw2_Button[2] = HuaShanLunJian_DanAward_LiftTwo
	g_HuaShanLunJian_Dw2_Button[3] = HuaShanLunJian_DanAward_LiftThree
	g_HuaShanLunJian_Dw2_Button[4] = HuaShanLunJian_DanAward_LiftFour
  
	g_HuaShanLunJian_Rank_Button[1] = HuaShanLunJian_DanAward_RightOne
	g_HuaShanLunJian_Rank_Button[2] = HuaShanLunJian_DanAward_RightTwo
	g_HuaShanLunJian_Rank_Button[3] = HuaShanLunJian_DanAward_RightThree
	g_HuaShanLunJian_Rank_Button[4] = HuaShanLunJian_DanAward_RightFour
	
	g_HuaShanLunJian_DuanWei_ActionItem[1] = HuaShanLunJian_LiftBtn01
	g_HuaShanLunJian_DuanWei_ActionItem[2] = HuaShanLunJian_LiftBtn02
	g_HuaShanLunJian_DuanWei_ActionItem[3] = HuaShanLunJian_LiftBtn03
	
	g_HuaShanLunJian_DuanWei_LingQu[1] = HuaShanLunJian_LiftBtn01YiLing
	g_HuaShanLunJian_DuanWei_LingQu[2] = HuaShanLunJian_LiftBtn02YiLing
	g_HuaShanLunJian_DuanWei_LingQu[3] = HuaShanLunJian_LiftBtn03YiLing
	
	g_HuaShanLunJian_Rank_ActionItem[1] = HuaShanLunJian_RightBtn01
	g_HuaShanLunJian_Rank_ActionItem[2] = HuaShanLunJian_RightBtn02
	g_HuaShanLunJian_Rank_ActionItem[3] = HuaShanLunJian_RightBtn03
	g_HuaShanLunJian_Rank_ActionItem[4] = HuaShanLunJian_RightBtn04

	g_HuaShanLunJian_PrizeButton[1] = HuaShanLunJian_GetAward
	g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_15}")
	g_HuaShanLunJian_PrizeButton[1]:Enable()	
	g_HuaShanLunJian_PrizeButton[2] = HuaShanLunJian_GetAward2
	g_HuaShanLunJian_PrizeButton[2]:SetText("#{HSLJ_190919_15}")
	g_HuaShanLunJian_PrizeButton[2]:Enable()		
	g_HuaShanLunJian_DuanWei_1 = -1
	g_HuaShanLunJian_DuanWei_2 = -1
	g_HuaShanLunJian_Rank_1 = -1
	g_HuaShanLunJian_Rank_2 = -1 
	g_HuaShanLunJian_MyRank	= -1
	g_HuaShanLunJian_TargetId = -1
	g_HuaShanLunJian_Rank_LingQu[1] = HuaShanLunJian_RightBtn01YiLing
	g_HuaShanLunJian_Rank_LingQu[2] = HuaShanLunJian_RightBtn02YiLing
	g_HuaShanLunJian_Rank_LingQu[3] = HuaShanLunJian_RightBtn03YiLing	
	
	g_HuaShanLunJian_RedPoint_Duan = HuaShanLunJian_DanAward_LiftList_Tips
	g_HuaShanLunJian_RedPoint_Jie[1] = HuaShanLunJian_DanAward_LiftOne_Tips
	g_HuaShanLunJian_RedPoint_Jie[2] = HuaShanLunJian_DanAward_LiftTwo_Tips
	g_HuaShanLunJian_RedPoint_Jie[3] = HuaShanLunJian_DanAward_LiftThree_Tips
	g_HuaShanLunJian_RedPoint_Jie[4] = HuaShanLunJian_DanAward_LiftFour_Tips
	g_HuaShanLunJian_RedPoint_Button = HuaShanLunJian_GetAward_Tips

	g_Reward_Btn_Pos[1] = g_HuaShanLunJian_DuanWei_ActionItem[1]:GetProperty("UnifiedPosition")
	g_Reward_Btn_Pos[2] = g_HuaShanLunJian_DuanWei_ActionItem[2]:GetProperty("UnifiedPosition")
	g_Reward_Btn_Pos[3] = g_HuaShanLunJian_DuanWei_ActionItem[3]:GetProperty("UnifiedPosition")
end

-- OnEvent
function HuaShanLunJian_OnEvent(event)
	--
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89289503 ) then 
		if Get_XParam_INT(0) == 0 then
			HuaShanLunJian_CloseWindow()
		else
			HuaShanLunJian_BeginCare( Get_XParam_INT(1) )
			g_HuaShanLunJian_TargetId = Get_XParam_INT(1)
		end
	elseif ( event == "XBW_SELF_DETAIL_UPDATE" ) then
		local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
		if levelIndex < 0 or levelIndex > 2 then
			return
		end

		local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
		if nCurDuanWei1 <= 0 or nCurDuanWei1 > 6 then
			PushDebugMessage("ÐÕi ðÆng c¤p sai l¥m")
			return
		end

		local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
		if nCurDuanWei2 <= 0 or nCurDuanWei2 > 4 then
			PushDebugMessage("ÐoÕn ng¡n V¸ sai l¥m")
			return
		end

		local nCurDuanWei3 = Player:Lua_GetXbwData( "CuruanWei3" )
		if nCurDuanWei3 < 0 then
			PushDebugMessage("Tinh S± sai l¥m")
			return
		end

		g_HuaShanLunJian_MyRank = tonumber(arg0)
		
		HuaShanLunJian_Init()
		HuaShanLunJian_Update_Top()
			
		HuaShanLunJian_Update_RankAward( )
		HuaShanLunJian_Update_DuanWeiAward( )
		
		this:Show()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_CloseWindow()

	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_ResetPos()
		
	end
end

--=========
--Care Obj
--=========
function HuaShanLunJian_BeginCare( serverObjId )
	local objCared = DataPool : GetNPCIDByServerID(serverObjId)
	this:CareObject(objCared, 1)
end

function HuaShanLunJian_Init( )
	HuaShanLunJian_Stage_StarSet:Hide()
	HuaShanLunJian_Stage_StarSet1:Hide()
	HuaShanLunJian_Stage_StarSet2:Hide()
	HuaShanLunJian_Stage_StarSet3:Hide()
	HuaShanLunJian_Stage_StarSet4:Hide()
	HuaShanLunJian_Stage_StarSet5:Hide()
	g_HuaShanLunJian_RedPoint_Duan:Hide()
	g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[4]:Hide()
	g_HuaShanLunJian_RedPoint_Button:Hide()
end


function HuaShanLunJian_Update_Top( )

	local curDay = tonumber(DataPool:GetServerDayTime());
	local nIndex,seasonBeg,seasonEnd = XBW:GetXbwGetRecentSeasonInfo(curDay)
	if nIndex == nil or nIndex < 0 then
		return
	end
	local yearBeg = math.floor(seasonBeg / 10000)
	local monthBeg = math.mod(math.floor(seasonBeg / 100), 100)
	local dayBeg = math.mod(seasonBeg, 100)
	
	local yearEnd = math.floor(seasonEnd / 10000)
	local monthEnd = math.mod(math.floor(seasonEnd / 100), 100)
	local dayEnd = math.mod(seasonEnd, 100)
	
	local dayText = ScriptGlobal_Format("#{HSLJ_190919_215}", tostring(monthBeg), tostring(dayBeg), tostring(monthEnd), tostring(dayEnd))
	HuaShanLunJian_Text8Info:SetText( dayText )

	--´ó¶ÎÎ»
	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	HuaShanLunJian_Dan_Image:SetProperty("Image", g_Duanwei1_Image[levelIndex][nCurDuanWei1])

	--Ð¡¶ÎÎ»
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	if nCurDuanWei1 ~= g_DwWangzhe then
		HuaShanLunJian_Dan_Text:SetProperty("Image", g_Duanwei2_Info[nCurDuanWei2].image)
		HuaShanLunJian_Dan_Text:Show()
	else
		HuaShanLunJian_Dan_Text:Hide()
	end

	--ÐÇÐÇ
	local nCurDuanWei3 = Player:Lua_GetXbwData( "CuruanWei3" )
	if nCurDuanWei3 == nil then
		return
	end

	local nMaxDuanWei3 = XBW:GetXbwDuanweinfo(nCurDuanWei1, nCurDuanWei2)
	if  nCurDuanWei1 == g_DwWangzhe then --??
		HuaShanLunJian_Stage_StarSet3:Show()
		HuaShanLunJian_Stage_Star3_1:SetProperty("Image", g_Bright_Stars)
		HuaShanLunJian_Stage_Star3_1:SetToolTip("#{HSLJ_190919_326}")
			
		local dw3Text = ScriptGlobal_Format("#{HSLJ_190919_25}", tostring(nCurDuanWei3))
		HuaShanLunJian_Stage_Star3Text:SetText(dw3Text)

	elseif nMaxDuanWei3 == 3 then
		HuaShanLunJian_Stage_StarSet:Show()
		for i=1, nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star3[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star3[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star3[i]:SetToolTip("#{HSLJ_190919_326}")
		end

	elseif nMaxDuanWei3 == 4 then
		HuaShanLunJian_Stage_StarSet1:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star4[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star4[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star4[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 5 then
		HuaShanLunJian_Stage_StarSet2:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star5[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star5[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star5[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 6 then
		HuaShanLunJian_Stage_StarSet4:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star6[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star6[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star6[i]:SetToolTip("#{HSLJ_190919_326}")
		end
		
	elseif nMaxDuanWei3 == 8 then
		HuaShanLunJian_Stage_StarSet5:Show()
		for i=1,nMaxDuanWei3 do
			if i <= nCurDuanWei3 then
				g_HuaShanLunJian_Star8[i]:SetProperty("Image", g_Bright_Stars)
			else
				g_HuaShanLunJian_Star8[i]:SetProperty("Image", g_Gray_Stars)
			end
			g_HuaShanLunJian_Star8[i]:SetToolTip("#{HSLJ_190919_326}")
		end
	end

	--»ªÉ½ÂÛ½£µÚXÈü¼¾ AAA
	local levelName = g_FightLevel[levelIndex + 1]
	local titleText = ScriptGlobal_Format("#{HSLJ_190919_27}", tostring(nIndex+1), levelName)
	HuaShanLunJian_UpRight_Title:SetText(titleText)
	
	--µ±Ç°¶ÎÎ»
	local curDwText = ""
	if nCurDuanWei1 < g_DwWangzhe then
		curDwText = ScriptGlobal_Format("#{HSLJ_190919_23}", g_Duanwei1_name[nCurDuanWei1], g_Duanwei2_Info[nCurDuanWei2].name)
	else
		curDwText = "#{HSLJ_190919_157}"
	end
	HuaShanLunJian_Text1Info:SetText(curDwText)
	
	--Èü¼¾ÅÅÃû
	local mRank,mName,mLevel,nMenPai = XBW:GetSelfInfo()
	if mRank == 255 then
		HuaShanLunJian_Text2Info:SetText("#{HSLJ_190919_210}")
	else
		local rankText = ScriptGlobal_Format("#{HSLJ_190919_211}", tostring(mRank+1))
		HuaShanLunJian_Text2Info:SetText(rankText)
	end

	--Èü¼¾µÄ²ÎÓë´ÎÊý
	local nSeasonPartCnt = Player:Lua_GetXbwData( "SeasonPartCnt" )
	local partCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonPartCnt))
	HuaShanLunJian_Text3Info:SetText( partCntText )

	--	»ñÊ¤³¡´Î
	local nSeasonWinCnt = Player:Lua_GetXbwData( "SeasonWinCnt" )
	local winCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonWinCnt))
	HuaShanLunJian_Text4Info:SetText(winCntText)
	
	--Èü¼¾Ê¤ÂÊ
	if nSeasonPartCnt == 0 then
		HuaShanLunJian_Text5Info:SetText("#{HSLJ_190919_31}")
	else
		local nSeasonWinCnt = Player:Lua_GetXbwData( "SeasonWinCnt" )
		local result = math.floor( (nSeasonWinCnt/nSeasonPartCnt) * 100 )
		local text6 = ScriptGlobal_Format("#{HSLJ_190919_164}", tostring(result))
		HuaShanLunJian_Text5Info:SetText(text6)
	end

	--	µ±Ç°Á¬Ê¤³¡´Î
	local nCurConWinCnt = Player:Lua_GetXbwData( "CurConWinCnt" )
	local curConWinCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nCurConWinCnt))
	HuaShanLunJian_Text6Info:SetText(curConWinCntText)
	
	--Èü¼¾×î¸ßÁ¬Ê¤³¡´Î
	local nSeasonConWinCnt = Player:Lua_GetXbwData( "SeasonConWinCnt" )
	local conWinCntText = ScriptGlobal_Format("#{HSLJ_190919_207}", tostring(nSeasonConWinCnt))
	HuaShanLunJian_Text7Info:SetText(conWinCntText)

	--  ½¶ÓÃû×Ö
	local teamName = ""
	local xbwTeamName = Player:Lua_GetXbwData( "GetTeamName" )
	if xbwTeamName ~= "" and xbwTeamName ~= "???" then
		teamName ="#cfff263"..tostring(xbwTeamName)
	end
	HuaShanLunJian_Text9Info:SetText(teamName)

end

function HuaShanLunJian_Update_DuanWeiAward( )

	--µ±Ç°£º¶ÎÎ»¡¢½×
	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	
	--Ä¿Ç°×îµÍÎ´Áì½±µÄÐÅÏ¢£º¶ÎÎ»¡¢½×
	local nStopDuanWei = -1
	local nStopJie = -1
	
	--ÒÑÁìÈ¡È«²¿¿ÉÁìÈ¡µÄ½±Àø
	local LingQuPrizeAll = 1
	for i=1, nCurDuanWei1 do
		for j=1, XBW:GetXbwMaxDuanWei2(i) do
			if i==nCurDuanWei1 and j<nCurDuanWei2 then
				break
			end
			--ÒòÎª½×ÊÇÄæÐòµÄ£¬ÊýÔ½´ó£¬½×Ô½µÍ£¬ËùÒÔ±éÀúÁì½±Ê±£¬ÐèÒªÔÙÄæ»ØÀ´
			local HaveLingQuPrize = Player:Lua_GetXbwData("GetDuanWeiReward",i-1, j-1)	
			--ÌØÐ´
			if i==1 and j==2 then
				HaveLingQuPrize = 1
			end
			if HaveLingQuPrize == 0 then
				LingQuPrizeAll = 0
			end
		end
	end
	
	--±éÀúÁì½±Çé¿ö£º´ÓµÍµ½¸ß£¬È·¶¨×îµÍÎ´Áì½±µÄ£º¶ÎÎ»¡¢½×
	for i=1, nCurDuanWei1 do
		for j=1, XBW:GetXbwMaxDuanWei2(i) do
			--ÒòÎª½×ÊÇÄæÐòµÄ£¬ÊýÔ½´ó£¬½×Ô½µÍ£¬ËùÒÔ±éÀúÁì½±Ê±£¬ÐèÒªÔÙÄæ»ØÀ´
			local k = XBW:GetXbwMaxDuanWei2(i)-j+1
			local HaveLingQuPrize = Player:Lua_GetXbwData("GetDuanWeiReward",i-1, k-1)
			--ÌØÐ´
			if i==1 and k==2 then
				HaveLingQuPrize = 1
			end
			--ÌØÐ´
			-- if (i == nCurDuanWei1) and (j < nCurDuanWei2) then
				-- nStopDuanWei = i
				-- nStopJie = k				
				-- i = 999
				-- break			
			-- end
			if HaveLingQuPrize ~= 1 then
				nStopDuanWei = i
				nStopJie = k
				--LingQuPrizeAll = 0
				i = 999
				break
			else
				nStopDuanWei = i
				nStopJie = k				
			end
		end
		if (i == 999) then
			break
		end
	end
	local nextDw1 = nStopDuanWei
	local nextDw2 = nStopJie
	
	--Èç¹ûÊÇ³õÊ¼¶ÎÎ»£¬ÏÔÊ¾£ºÒ»¶ÎÒ»½×
	if (nCurDuanWei1 == 1) and (nCurDuanWei2 == 2) then
		nextDw1 = 1
		nextDw2 = 1
	--Èç¹ûÒÑ´ïµ½×î¸ß¶ÎÎ»£¬ÇÒÁìÈ¡Íê½±Àø£¬ÏÔÊ¾£º°Ô½£
	elseif (nCurDuanWei1 == g_DwWangzhe) and (LingQuPrizeAll == 1)then
		nextDw1 = g_DwWangzhe
		nextDw2 = 1
	--·ñÔò
	else
		--¿ÉÁì£ºÒÑÁìÍê£¬ÏÔÊ¾£ºÏÂÒ»¼¶
		if (LingQuPrizeAll == 1) then
			if nextDw2 == 1 then
				if (nStopDuanWei < g_DwWangzhe) then
					nextDw1 = nStopDuanWei + 1
					nextDw2 = XBW:GetXbwMaxDuanWei2(nextDw1)
				else
					nextDw1 = g_DwWangzhe --nStopDuanWei
				end
				
			else
				nextDw1 = nStopDuanWei
				--nextDw2 = nStopJie - 1
				nextDw2 = nStopJie				
			end
		--¿ÉÁì£ºÃ»ÁìÍê£¬ÏÔÊ¾£ºµ±Ç°¼¶
		else
			nextDw1 = nStopDuanWei
			nextDw2 = nStopJie
			if (nextDw1 == 1) and (nextDw2 == 2) then
				nextDw2 = 1
			end
		end
	end
	
	HuaShanLunJian_DanAward_LiftList:ResetList()

	for i = 1, table.getn(g_Duanwei1_name) do 
		HuaShanLunJian_DanAward_LiftList:AddTextItem(g_Duanwei1_name[i], i) 
	end 
	
	--ÈÝ´í´¦Àí
	if nextDw1 < 1 or nextDw1 > g_DwWangzhe or nextDw2 < 1 or nextDw2 > 4 then
		nextDw1 = nCurDuanWei1
		nextDw2 = nCurDuanWei2 - 1
		if nCurDuanWei2 == 1 then
			nextDw1 = nCurDuanWei1 + 1
			nextDw2 = XBW:GetXbwMaxDuanWei2(nextDw1)
		end		
	end

	if LingQuPrizeAll == 1 then
		g_HuaShanLunJian_RedPoint_Duan:Hide()
	else
		g_HuaShanLunJian_RedPoint_Duan:Show()
	end
	
	HuaShanLunJian_DanAward_LiftList:SetCurrentSelect(nextDw1 - 1)
	HuaShanLunJian_DanAward_AwardButton(nextDw1, nextDw2)
end


function HuaShanLunJian_Update_RankAward( )

	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	
	HuaShanLunJian_DanAward_RightList:ResetList()
	
	for i = 1, table.getn(g_FightLevel) do 
		HuaShanLunJian_DanAward_RightList:AddTextItem(g_FightLevel[i], i-1) 
	end 
	
	HuaShanLunJian_DanAward_RightList:SetCurrentSelect(levelIndex)
	HuaShanLunJian_Rank_AwardButton( levelIndex, 1 )
end


function HuaShanLunJian_CloseWindow()
	this:Hide()
end

function HuaShanLunJian_DuanWeiHelp()
	PushEvent("QUEST_HELPINFO","#{HSLJ_190919_206}")
end

function HuaShanLunJian_RankHelp()
	PushEvent("QUEST_HELPINFO","#{HSLJ_190919_212}")
end

function HuaShanLunJian_DanAward_LineChanged()
	local _name, comIdx = HuaShanLunJian_DanAward_LiftList:GetCurrentSelect()
	
	if comIdx == 1 then
		HuaShanLunJian_DanAward_AwardButton(comIdx, 1)
	
	elseif comIdx >= 2 and comIdx <= g_DwWangzhe then 
		local maxCurDw2 = XBW:GetXbwMaxDuanWei2(comIdx)
		HuaShanLunJian_DanAward_AwardButton(comIdx, maxCurDw2)
	end
end

function HuaShanLunJian_DanAward_ButtonChanged( buttonIndex )
	local _name, comIdx = HuaShanLunJian_DanAward_LiftList:GetCurrentSelect()	
	HuaShanLunJian_DanAward_AwardButton(comIdx, buttonIndex)
end

function HuaShanLunJian_DanAward_AwardButton(dw1, dw2)
	g_HuaShanLunJian_DuanWei_1 = dw1
	g_HuaShanLunJian_DuanWei_2 = dw2

	local nCurDuanWei1 = Player:Lua_GetXbwData( "CuruanWei1" )
	local nCurDuanWei2 = Player:Lua_GetXbwData( "CuruanWei2" )
	g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
	g_HuaShanLunJian_RedPoint_Jie[4]:Hide()	
	g_HuaShanLunJian_RedPoint_Button:Hide()	
			
	local maxDw2 = XBW:GetXbwMaxDuanWei2(dw1)
	for index=1, maxDw2 do
		if index == dw2 then
			g_HuaShanLunJian_Dw2_Button[index]:SetCheck(1)
		else
			g_HuaShanLunJian_Dw2_Button[index]:SetCheck(0)
		end
		g_HuaShanLunJian_Dw2_Button[index]:Show()
		--¸÷½×ÊÇ·ñÒÑ¾­Áì½±
		--Ñ¡ÔñµÄ¶ÎÎ» >  æÊµ¶ÎÎ»£ºHide
		if (dw1 > nCurDuanWei1) then
			g_HuaShanLunJian_RedPoint_Jie[1]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[2]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[3]:Hide()
			g_HuaShanLunJian_RedPoint_Jie[4]:Hide()
		--Ñ¡ÔñµÄ¶ÎÎ» =  æÊµ¶ÎÎ»£º
		--½×Êý >=  æÊµ½×ÊýµÄ£ºÁì¹ý½±ÀøµÄ£¬Hide£»Î´Áì¹ý½±ÀøµÄ£¬Show
		--½×Êý <  æÊµ½×ÊýµÄ£ºHide
		elseif (dw1 == nCurDuanWei1) then
			if (index >= nCurDuanWei2) then
				local GetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, index-1)
				--ÌØÐ´
				if dw1 == 1 and index == 2 then
					GetPrize = 1
				end	
				
				if GetPrize == 1 then
					g_HuaShanLunJian_RedPoint_Jie[index]:Hide()
				else
					g_HuaShanLunJian_RedPoint_Jie[index]:Show()
				end			
			else
				g_HuaShanLunJian_RedPoint_Jie[index]:Hide()	
			end

		--Ñ¡ÔñµÄ¶ÎÎ» <  æÊµ¶ÎÎ»£ºÁì¹ý½±ÀøµÄ£¬Hide£»Î´Áì¹ý½±ÀøµÄ£¬Show
		else
			local GetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, index-1)
			if GetPrize == 1 then
				g_HuaShanLunJian_RedPoint_Jie[index]:Hide()
			else
				--ÌØÐ´
				if dw1 == 1 and index == 2 then
				
				else
					g_HuaShanLunJian_RedPoint_Jie[index]:Show()
				end
			end
		end
		
	end	
	
	for index=maxDw2+1, table.getn(g_HuaShanLunJian_Dw2_Button) do
		g_HuaShanLunJian_Dw2_Button[index]:Hide()
	end
	
	--×ö¸öÐÞ ý
	if dw1 == 1 then
		g_HuaShanLunJian_Dw2_Button[2]:Hide()
	end
	
	--°Ô½££ºÒþ²Ø âÒ»ÐÐ
	if dw1 == g_DwWangzhe then
		for i=1, table.getn(g_HuaShanLunJian_Dw2_Button) do
			g_HuaShanLunJian_Dw2_Button[i]:Hide()
		end
		--dw2 = 1		
	end
	
	for i=1, table.getn(g_HuaShanLunJian_DuanWei_ActionItem) do
		g_HuaShanLunJian_DuanWei_ActionItem[i]:SetActionItem(-1)
		g_HuaShanLunJian_DuanWei_ActionItem[i]:Hide()
		g_HuaShanLunJian_DuanWei_ActionItem[i]:SetProperty("UnifiedPosition", g_Reward_Btn_Pos[i])
		g_HuaShanLunJian_DuanWei_LingQu[i]:Hide()		
	end
	
	if dw1 > g_DwWangzhe then
		return
	end
	
	local onlyOne = 0
	local HaveGetPrize = Player:Lua_GetXbwData("GetDuanWeiReward",dw1-1, dw2-1)
	local levelIndex = Player:Lua_GetXbwData( "LevelIndex" )
	for i=1, table.getn(g_HuaShanLunJian_DuanWei_ActionItem) do
		local itemId, itemNum = XBW:GetXbwSeasonAward(dw1, dw2, levelIndex, i-1)
		local theAction = DataPool:CreateBindActionItemForShow(itemId, itemNum)
		if theAction:GetID() ~= 0 then
			g_HuaShanLunJian_DuanWei_ActionItem[i]:Show()
			g_HuaShanLunJian_DuanWei_ActionItem[i]:SetActionItem(theAction:GetID())
			if HaveGetPrize == 1 then
				g_HuaShanLunJian_DuanWei_LingQu[i]:Show()
			else
				g_HuaShanLunJian_DuanWei_LingQu[i]:Hide()
			end
			onlyOne = onlyOne + 1
		end	
	end
	
	if onlyOne == 1 then
		g_HuaShanLunJian_DuanWei_ActionItem[1]:SetProperty("UnifiedPosition", g_Reward_Btn_Pos_OnlyOne)
	end

	if HaveGetPrize == 1 then
		g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_16}")
		g_HuaShanLunJian_PrizeButton[1]:Disable()
		g_HuaShanLunJian_RedPoint_Button:Hide()
	else
		g_HuaShanLunJian_PrizeButton[1]:SetText("#{HSLJ_190919_15}")
		g_HuaShanLunJian_PrizeButton[1]:Enable()
	end
	
	--Ñ¡¶¨½×µÄÁì½±°´Å¥£º¿ÉÁì½±£¬²¢ÇÒÎ´Áì½±£¬²ÅÏÔÊ¾
	local  canshow = -1	
	if ((dw1 < nCurDuanWei1) or (dw1==nCurDuanWei1 and dw2>=nCurDuanWei2) )
		and (HaveGetPrize ~= 1) then
		canshow = 1
	end
	if canshow == 1 then
		g_HuaShanLunJian_RedPoint_Button:Show()	
	else
		g_HuaShanLunJian_RedPoint_Button:Hide()	
	end	
end

function HuaShanLunJian_Rank_LineChanged()
	local _name, comIdx = HuaShanLunJian_DanAward_RightList:GetCurrentSelect()
	
	if comIdx >= 0 and comIdx <= 2 then 
		HuaShanLunJian_Rank_AwardButton( comIdx, 1 )
	end
end

function HuaShanLunJian_Rank_ButtonChange( rankIndex )
	local _name, comIdx = HuaShanLunJian_DanAward_RightList:GetCurrentSelect()
	HuaShanLunJian_Rank_AwardButton( comIdx, rankIndex )
end

function HuaShanLunJian_Rank_AwardButton( levelIndex, rankIndex )
	g_HuaShanLunJian_Rank_1 = levelIndex
	g_HuaShanLunJian_Rank_2 = rankIndex
	
	for index=1, table.getn(g_HuaShanLunJian_Rank_Button) do
		if index == rankIndex then
			g_HuaShanLunJian_Rank_Button[index]:SetCheck(1)
		else
			g_HuaShanLunJian_Rank_Button[index]:SetCheck(0)
		end
	end
	
	--½±Àø
	for i=1, table.getn(g_HuaShanLunJian_Rank_ActionItem) do
		g_HuaShanLunJian_Rank_ActionItem[i]:SetActionItem(-1)
		g_HuaShanLunJian_Rank_ActionItem[i]:Hide()		
	end

	for i=1, table.getn(g_HuaShanLunJian_Rank_LingQu) do
		g_HuaShanLunJian_Rank_LingQu[i]:Hide()		
	end

	--local HaveGetPrize = Player:Lua_GetXbwData("GetRankReward")
	
	local awardList = g_RankAward[levelIndex][rankIndex]
	for i=1, table.getn(awardList) do
		if awardList[i].bind == nil or awardList[i].bind == 1 then
			local theAction = DataPool:CreateBindActionItemForShow(awardList[i].id, awardList[i].num)
			if theAction:GetID() ~= 0 then
				g_HuaShanLunJian_Rank_ActionItem[i]:Show()
				g_HuaShanLunJian_Rank_ActionItem[i]:SetActionItem(theAction:GetID())
			end
		else
			local theAction = DataPool:CreateActionItemForShow(awardList[i].id, awardList[i].num)
			if theAction:GetID() ~= 0 then
				g_HuaShanLunJian_Rank_ActionItem[i]:Show()
				g_HuaShanLunJian_Rank_ActionItem[i]:SetActionItem(theAction:GetID())
			end
		end
	end
	
	HuaShanLunJian_RightText2:SetText( g_RankText[rankIndex] )

	local eggTxt = g_RankEggText[rankIndex]
	if eggTxt ~= nil and eggTxt ~= "" then
		HuaShanLunJian_RightBtn02Text:SetText(eggTxt)
		HuaShanLunJian_RightBtn02Text:Show()
	else
		HuaShanLunJian_RightBtn02Text:Hide()
	end
end

function HuaShanLunJian_ResetPos()
	HuaShanLunJian_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Frame_UnifiedPosition);
end

function HuaShanLunJian_GetAward_Clicked(index)
	if index ~= 1 and index ~= 2 then
		return
	end

	if index == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GetTruePrize1")
			Set_XSCRIPT_ScriptID(892895)
			Set_XSCRIPT_Parameter( 0, g_HuaShanLunJian_DuanWei_1 )
			Set_XSCRIPT_Parameter( 1, g_HuaShanLunJian_DuanWei_2 )
			Set_XSCRIPT_Parameter( 2, g_HuaShanLunJian_TargetId )
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
end
