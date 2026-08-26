--!!!reloadscript =ERenGu_Yure

local g_ERenGu_Yure_Frame_UnifiedPosition = ""
local g_UICOMMAND = 99944101
local g_CloseCaseUICOMMAND = 99944102
local g_MissionScrpitID = 999430
local g_ClueClickBackup    = -1 
local g_CurQuestPhrase   = -1
local g_CurActivityPhrase = -1
local g_IsHaveMissionState = -1
local g_IsMissionComplete = -1
local g_ChosenNpcData = 0
local g_CurClurPage 	= -1
local g_IsIntergtation  = 0
local g_IsCloseCase     = 0	--?????????????????
local g_CloseCasePhase	= 0 --????????index
local g_CluePageContent = {}
local g_ClueIntergrations = {}
local g_CloseCase_Component = {}
local g_IntergrationLock = {}
local g_Clue = {}
local g_ClueTips = {}
local g_CluePaging = {}
local g_CluePageTips = {}
local g_Client = {}
local g_Client1_Info = {}
local g_Client_Finished_ArtComponent = {}
function ERenGu_Yure_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	this:RegisterEvent("OPEN_FASHION_LOTTERY")
	this:RegisterEvent("REFRESH_FASHION_LOTTERY")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)	--???????
end

function ERenGu_Yure_OnLoad()
	g_ERenGu_Yure_Frame_UnifiedPosition = ERenGu_Yure_Frame:GetProperty("UnifiedPosition")
	g_CluePageContent = {
		[1] = { Getclues = {"#{ERYR_240701_41}","#{ERYR_240701_42}","#{ERYR_240701_43}","#{ERYR_240701_44}","#{ERYR_240701_45}","#{ERYR_240701_46}"}, 
				UnknownClue = "#{ERYR_240701_313}"},
		[2] = { Getclues = {"#{ERYR_240701_47}","#{ERYR_240701_48}","#{ERYR_240701_49}","#{ERYR_240701_50}","#{ERYR_240701_51}","#{ERYR_240701_52}"}, 
				UnknownClue = "#{ERYR_240701_313}"},
		--[3] = { Getclues = {"#{ERYR_240701_53}","#{ERYR_240701_54}","#{ERYR_240701_55}","#{ERYR_240701_56}","#{ERYR_240701_57}","#{ERYR_240701_58}"}, 
		--		UnknownClue = "#{ERYR_240701_313}"},
		[3] = { Getclues = {"#{ERYR_240701_59}","#{ERYR_240701_60}","#{ERYR_240701_61}","#{ERYR_240701_62}","#{ERYR_240701_63}","#{ERYR_240701_64}"}, 
				UnknownClue = "#{ERYR_240701_313}"},
	}
	g_ClueIntergrations = {
		Flag = {0,0,0},
		Component = {
			ERenGu_Yure_Client2_Clue_AnswerText1,
			ERenGu_Yure_Client2_Clue_AnswerText2,
			ERenGu_Yure_Client2_Clue_AnswerText3,
		},
		Content = {	--??????,????????????,?????????????????,?????1???2?6,??index=2/6?????????
			[1] = { "#{ERYR_240701_70}","#{ERYR_240701_69}","#{ERYR_240701_71}","#{ERYR_240701_70}","#{ERYR_240701_69}","#{ERYR_240701_71}" },
			[2] = { "#{ERYR_240701_73}","#{ERYR_240701_74}","#{ERYR_240701_72}","#{ERYR_240701_74}","#{ERYR_240701_72}","#{ERYR_240701_73}" },
			--[3] = { "#{ERYR_240701_77}","#{ERYR_240701_76}","#{ERYR_240701_77}","#{ERYR_240701_75}","#{ERYR_240701_76}","#{ERYR_240701_75}" },
			[3] = { "#{ERYR_240701_80}","#{ERYR_240701_78}","#{ERYR_240701_80}","#{ERYR_240701_79}","#{ERYR_240701_78}","#{ERYR_240701_79}" },
		}
	}
	g_CloseCase_Component = {
		EvidenceText_Component = {
			ERenGu_Yure_Client2_CluePage_CloseCase_EvidenceText1,
			ERenGu_Yure_Client2_CluePage_CloseCase_EvidenceText2,
			ERenGu_Yure_Client2_CluePage_CloseCase_EvidenceText3,
			--ERenGu_Yure_Client2_CluePage_CloseCase_EvidenceText4
		},
		EvideneceNote_Component = {
			ERenGu_Yure_Client2_CluePage_CloseCase_NewEvidence1,
			ERenGu_Yure_Client2_CluePage_CloseCase_NewEvidence2,
			ERenGu_Yure_Client2_CluePage_CloseCase_NewEvidence3,
			--ERenGu_Yure_Client2_CluePage_CloseCase_NewEvidence4
		},
		GotoBtn = {State = 0 }, --Component = ERenGu_Yure_Client2_CluePage_CloseCase_GotoBtn },
		AnimateComponent = ERenGu_Yure_Client2_CluePage_CloseCase_SuspectAnimate

	}
	g_IntergrationLock = ERenGu_Yure_Client2_Clue_LockText1
	g_Clue = {
		Num  = 0, 
		Flag = { 0,0,0,0,0,0 },
		Btn = {	
			ERenGu_Yure_Client2_CluePage_ClueBtn1,
			ERenGu_Yure_Client2_CluePage_ClueBtn2,
			ERenGu_Yure_Client2_CluePage_ClueBtn3,
			ERenGu_Yure_Client2_CluePage_ClueBtn4,
			ERenGu_Yure_Client2_CluePage_ClueBtn5,
			ERenGu_Yure_Client2_CluePage_ClueBtn6,
			},
		ClueMatch = {
			[1] = { {[2] = 5,[5] = 2},{[1] = 4,[4] = 1},{[3] = 6, [6] = 3} },
			[2] = { {[5] = 3,[3] = 5},{[6] = 1,[1] = 6},{[4] = 2, [2] = 4} },
			--[3] = { {[4] = 6,[6] = 4},{[2] = 5,[5] = 2},{[1] = 3, [3] = 1} },
			[3] = { {[2] = 5,[5] = 2},{[4] = 6,[6] = 4},{[3] = 1, [1] = 3} },
		},
		SelectBKTXTConponent = {
			[1] = { ERenGu_Yure_Client2_CluePage_SelectInfo3,ERenGu_Yure_Client2_CluePage_SelectInfo1,
					ERenGu_Yure_Client2_CluePage_SelectInfo5,ERenGu_Yure_Client2_CluePage_SelectInfo4,
					ERenGu_Yure_Client2_CluePage_SelectInfo2,ERenGu_Yure_Client2_CluePage_SelectInfo6},
			[2] = { ERenGu_Yure_Client2_CluePage_SelectInfo4,ERenGu_Yure_Client2_CluePage_SelectInfo6,
					ERenGu_Yure_Client2_CluePage_SelectInfo2,ERenGu_Yure_Client2_CluePage_SelectInfo5,
					ERenGu_Yure_Client2_CluePage_SelectInfo1,ERenGu_Yure_Client2_CluePage_SelectInfo3},
			[3] = { ERenGu_Yure_Client2_CluePage_SelectInfo6,ERenGu_Yure_Client2_CluePage_SelectInfo1,
					ERenGu_Yure_Client2_CluePage_SelectInfo5,ERenGu_Yure_Client2_CluePage_SelectInfo3,
					ERenGu_Yure_Client2_CluePage_SelectInfo2,ERenGu_Yure_Client2_CluePage_SelectInfo4},
		},
		g_ClueTips = {
			--µÚÒ»´ÎÊ ¼¯ÆëÏßË÷Ê±ºòµÄtips
			ERenGu_Yure_Client2_CluePage_ClueBtn1_Animate,ERenGu_Yure_Client2_CluePage_ClueBtn2_Animate,ERenGu_Yure_Client2_CluePage_ClueBtn3_Animate,
			ERenGu_Yure_Client2_CluePage_ClueBtn4_Animate,ERenGu_Yure_Client2_CluePage_ClueBtn5_Animate,ERenGu_Yure_Client2_CluePage_ClueBtn6_Animate,
		}
	}
	g_CluePaging = {
		ERenGu_Yure_Client2_Clue_FenYe1,
		ERenGu_Yure_Client2_Clue_FenYe2,
		ERenGu_Yure_Client2_Clue_FenYe3,
		--ERenGu_Yure_Client2_Clue_FenYe4
	}
	g_CluePageTips = {Component = {ERenGu_Yure_Client2_Clue_FenYe2Tips,ERenGu_Yure_Client2_Clue_FenYe3Tips} , tipsText = {"#{ERYR_240701_345}","#{ERYR_240701_348}"},DebugMessage = {"#{ERYR_240701_346}","#{ERYR_240701_347}"}}
	g_Client = { ERenGu_Yure_Client1 , ERenGu_Yure_Client2 , ERenGu_Yure_Client3}
	g_Client1_Info = {
		Component = ERenGu_Yure_Client1_Info,
		InfoText = {
			"set:ERenGu_Yure_02 image:Letter_Day1",
			"set:ERenGu_Yure_02 image:Letter_Day2",
			"set:ERenGu_Yure_02 image:Letter_Day3",
			"set:ERenGu_Yure_02 image:Letter_Day4"
		}
	}
	g_Client_Finished_ArtComponent = {ERenGu_Yure_Client3_Finished1,ERenGu_Yure_Client3_Finished2}
end

function ERenGu_Yure_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND ) then
		g_CurQuestPhrase   = Get_XParam_INT(0)
		g_CurActivityPhrase  = Get_XParam_INT(1)
		g_IsHaveMissionState = Get_XParam_INT(2)
		g_IsMissionComplete = Get_XParam_INT(3)
		g_ChosenNpcData = Get_XParam_INT(4)
		ERenGu_Yure_Init()
		KillTimer("ERenGu_Yure_CloseCaseTimer()");
		KillTimer("ERenGu_Yure_CloseAnimateTimer()");
		if g_CurQuestPhrase == 0 and g_IsHaveMissionState < 1 then
			ERenGu_Yure_UIPhase(1)	--???????
			ERenGu_Yure_SetImage(1)
			this:Show()
			return 
		end
		--¼ÇÂ¼Íæ¼ÒÈÎÎñ½ø¶È
		if (g_CurQuestPhrase >= 0 and g_CurQuestPhrase < 3) or (g_CurQuestPhrase == 3 and g_IsHaveMissionState < 1) then
			--Íê³ÉÖÁÉÙÒ»¸öÈÎÎñÇÒÎ´³ÖÓÐÈÎÎñÊ±
			if g_IsHaveMissionState < 1 then
				if g_CurQuestPhrase > g_CurActivityPhrase then

					g_CurQuestPhrase = g_CurActivityPhrase
					ERenGu_Yure_UIPhase(2)	--???????

					ERenGu_Yure_Client2_CluePage_Init()
					ERenGu_Yure_Client2_PageClick(g_CurQuestPhrase)
				else
					ERenGu_Yure_UIPhase(1)	--???????
					g_CurQuestPhrase = math.min(3,g_CurQuestPhrase)
					ERenGu_Yure_SetImage(g_CurQuestPhrase+1)
				end
				this:Show()
				return
			end
			ERenGu_Yure_UIPhase(2)	--???????
			g_Clue.Num 	   = Get_XParam_INT(5)
			g_Clue.Flag[1] = Get_XParam_INT(6)
			g_Clue.Flag[2] = Get_XParam_INT(7)
			g_Clue.Flag[3] = Get_XParam_INT(8)
			g_Clue.Flag[4] = Get_XParam_INT(9)
			g_Clue.Flag[5] = Get_XParam_INT(10)
			g_Clue.Flag[6] = Get_XParam_INT(11)
			g_IsIntergtation = Get_XParam_INT(12)
		else
			if g_IsHaveMissionState >= 1 then
				ERenGu_Yure_UIPhase(3)	--???????
				if g_IsMissionComplete == 1 then
					ERenGu_Yure_Client3_GotoBtn:Disable()
					g_Client_Finished_ArtComponent[math.min(g_CurQuestPhrase-2,2)]:Show()
				end
			else
				if g_CurQuestPhrase > g_CurActivityPhrase then
					if g_CurQuestPhrase == 3 then
						--»¹Î´ ýÊ½½øÈë×·Ð×½×¶Î
						ERenGu_Yure_UIPhase(2)	--???????
						ERenGu_Yure_Client2_CluePage_Init()
						ERenGu_Yure_Client2_PageClick(g_CurQuestPhrase)
					else
						--½øÈë×·Ð×½×¶Î(¼´×îÆðÂëÍê³ÉÁËÒ»¸ö×·Ð×ÈÎÎñ)
						ERenGu_Yure_UIPhase(3)	--???????
						g_Client_Finished_ArtComponent[g_CurQuestPhrase-3]:Show()
						-- PushDebugMessage("×·Ð×½×¶Î"..(g_CurQuestPhrase-3).."ÒÑÍê³É")
						ERenGu_Yure_Client3_GotoBtn:Disable()
					end
				else
					ERenGu_Yure_UIPhase(1)	--???????
					g_CurQuestPhrase = math.min(3,g_CurQuestPhrase)
					ERenGu_Yure_SetImage(g_CurQuestPhrase+1)
				end
			end
			this:Show()
			return
		end
		ERenGu_Yure_Client2_CluePage_Init()
		ERenGu_Yure_Client2_PageClick( g_CurQuestPhrase)
		this:Show()
		return
	elseif (event == "UI_COMMAND" and tonumber(arg0) == g_CloseCaseUICOMMAND) then
		g_CloseCase_Component.AnimateComponent:Hide()
		g_CurQuestPhrase   = Get_XParam_INT(0)
		g_CurActivityPhrase  = Get_XParam_INT(1)
		g_IsHaveMissionState = Get_XParam_INT(2)
		g_IsIntergtation     = Get_XParam_INT(3)
		g_ChosenNpcData = Get_XParam_INT(4)
		g_IsCloseCase        = Get_XParam_INT(5)
		--½×¶Î¶þµÄµÚ¶þ½×¶Î£¬Ö±½ÓÔÚº¯ÊýÀï×öÌØÅÐ£¬ËùÒÔ âÀï¾Í²»Çø·ÖUIPhaseÁË
		KillTimer("ERenGu_Yure_CloseCaseTimer()");
		KillTimer("ERenGu_Yure_CloseAnimateTimer()");
		ERenGu_Yure_UIPhase(2)
		ERenGu_Yure_Phase2CloseCase_Init()
		this:Show()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ERenGu_Yure_CloseFunc()
	end
end
--ÉèÖÃclient1ÏÔÊ¾µÄÊéÐÅÄÚÈÝ
function ERenGu_Yure_SetImage(Index)
	ERenGu_Yure_Client1_InfoImage: SetProperty("Image",g_Client1_Info.InfoText[Index])
end
function ERenGu_Yure_Init()
	ERenGu_Yure_Client3_GotoBtn:Enable()
	for i = 1 , 2 do
		g_Client_Finished_ArtComponent[i]:Hide()
	end
	ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Show()
	ERenGu_Yure_Client2_Clue_Answer_GotoBtn:SetToolTip("")
end
function ERenGu_Yure_CloseFunc()
	KillTimer("ERenGu_Yure_CloseCaseTimer()");
	KillTimer("ERenGu_Yure_CloseAnimateTimer()");
	g_ClueClickBackup    = -1 
	g_CurQuestPhrase   = -1
	g_IsHaveMissionState = -1
	g_CurClurPage 		 = -1
	g_IsIntergtation  	 = 0
	g_IsCloseCase     	 = 0
	g_CloseCasePhase	 = 0
	this:Hide()
	return 
end
function ERenGu_Yure_Client1_Goto_Clicked()
	AutoRuntoTargetExWithName(137, 183, 1, "Ngß¶i n±i tiªng Ngæ")
	PushDebugMessage("#{ERYR_240701_34}")
	ERenGu_Yure_CloseFunc()
end
--·ÖÒ³³õÊ¼»¯
function ERenGu_Yure_Client2_CluePage_Init()
	for i = 1 , 3 do
		g_CluePaging[i]:Disable()
	end
	for i = 1 , (math.min(3,g_CurQuestPhrase+1)) do
		g_CluePaging[i]:Enable()
	end
	for i = 1 , 6 do 
		g_Clue.g_ClueTips[i]:Hide()
	end
	--ÐÞ¸Ä·ÖÒ³ÉÏ·½¿ °´Å¥µÄÏÔÒþºÍtips
	for i = 1 , 2 do 
		g_CluePageTips.Component[i]:Hide()
	end
	--µ±Íæ¼ÒÈÎÎñ½ø¶ÈÐ¡ÓÚ²é°¸3ÆÚÊ±£¨Î´½ÓÈÎÎñ£©
	if (g_CurQuestPhrase+1) < 3 then
		-- g_CurQuestPhrase+1 = 1 Ê± £¬Á½¸ö¶¼ÏÔÊ¾ 2
		-- g_CurQuestPhrase+1 = 2 Ê± £¬1¸öÏÔÊ¾    1
		-- g_CurQuestPhrase+1 = 3 Ê± £¬²»¸öÏÔÊ¾   
		for i = 2, (g_CurQuestPhrase+1),-1 do 
			g_CluePageTips.Component[i]:Show()
		end 
		-- g_CurActivityPhrase + 1 = 1 Ê± Á½¸ö¶¼²»¸Ä
		-- g_CurActivityPhrase + 1 = 2 Ê± µÚÒ»¸ö¸Ä
		-- g_CurActivityPhrase + 1 = 3 Ê± Á½¸ö¶¼¸Ä¸Ä
		if (g_CurActivityPhrase+1) > 1 then
			for i = 1, math.min(2,(g_CurActivityPhrase+1)-1) do

				g_CluePageTips.Component[i]:SetToolTip(g_CluePageTips.tipsText[i])
			end
		end
	end
end
--ÇÐ»»²é°¸·ÖÒ³
function ERenGu_Yure_Client2_PageClick(cluePageIndex)
	cluePageIndex = cluePageIndex + 1
	cluePageIndex = math.min(3,cluePageIndex)
	-- if g_CurClurPage == cluePageIndex then
	-- 	return
	-- end

	--µãµ½»¹Ã»½ÓÈ¡»òÍê³ÉµÄÈÎÎñÊ±£¬³·»Ø²Ù×÷
	if cluePageIndex > g_CurQuestPhrase+1 then
		return 
	end

	g_ClueClickBackup = -1
	g_IntergrationLock:Hide()
	ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Show()
	ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Enable()
	ERenGu_Yure_Client2_Clue_Answer_Finished:Show()
	ERenGu_Yure_Client2_SuspectImage1:Hide()
	ERenGu_Yure_Client2_SuspectImage2:Hide()
	for i = 1 , 6 do 
		g_Clue.Btn[i]:SetProperty("Selected", "False");
	end
	--Ñ¡ÖÐ°´Å¥Ð§¹û
	g_CluePaging[cluePageIndex]:SetProperty("Selected", "True");
	g_CurClurPage = cluePageIndex
	-- µ±Ñ¡ÔñµÄ·ÖÒ³Îªµ±Ç°½øÐÐÖÐµÄÈÎÎñÒ³ÃæÊ±
	if cluePageIndex-1 == g_CurQuestPhrase and g_IsHaveMissionState >= 1 then
		--µ±ÆÚÈÎÎñ²»ÏÔÊ¾°¸ÇéÒÑÊáÀí
		ERenGu_Yure_Client2_Clue_Answer_Finished:Hide()
		-- ûºÏ½áÊø£¨¼´ÈÎÎñÍê³É£©
		if g_IsIntergtation == 1 then
			--µ±Ç°·ÖÒ³¶ÔÓ¦µÄÏßË÷
			for i = 1 , 6 do 
				if g_Clue.Flag[i] >= 1 then
					g_Clue.Btn[i]:SetText(g_CluePageContent[cluePageIndex].Getclues[i])
					g_Clue.Btn[i]:Disable()
					g_Clue.SelectBKTXTConponent[cluePageIndex][i]:Show()
					g_Clue.SelectBKTXTConponent[cluePageIndex][i]:SetText(g_CluePageContent[cluePageIndex].Getclues[i])
				end
			end
			-- ûºÏÏßË÷ÏÔÊ¾
			local content = ""
			for i = 1 ,3 do
				g_ClueIntergrations.Component[i]:Show()
				g_ClueIntergrations.Flag[i] = 1
				for j = 1,6 do
					-- ûºÏÏßË÷£¨ÈýÌõ£©¶ÔÓ¦µÄÏßË÷ÐòºÅ
					if g_Clue.ClueMatch[cluePageIndex][i][j]~= nil then
							content = g_ClueIntergrations.Content[cluePageIndex][j]
							g_ClueIntergrations.Component[i]:SetText(content)
						break
					end
				end
			end
		else
			ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Disable()
			ERenGu_Yure_Client2_Clue_Answer_GotoBtn:SetToolTip("#{ERYR_240701_37}")
			g_IntergrationLock:Show()
			--ÈÎÎñ½øÐÐÖÐ
			--µ±Ç°·ÖÒ³¶ÔÓ¦µÄÏßË÷
			for i = 1 , 6 do 
				--Èç¹ûÏßË÷Ã»¼¯ÆëÁù¸ö£¬Ôò°´Å¥Ëø¶¨
				if g_Clue.Num < 6 then
					g_Clue.Btn[i]:Disable()
				else
					g_Clue.Btn[i]:Enable()
				end
				if g_Clue.Flag[i] < 1 then
					g_Clue.Btn[i]:SetText(g_CluePageContent[cluePageIndex].UnknownClue)
				else
					g_Clue.Btn[i]:SetText(g_CluePageContent[cluePageIndex].Getclues[i])
				end
				g_Clue.SelectBKTXTConponent[cluePageIndex][i]:Hide()
			end
			-- ûºÏÏßË÷Òþ²Ø£¨ÈÃÆäÄ¬ÈÏÒþ²Ø£¨ÖØÖÃ£©£©
			-- ûºÏÏßË÷ÏÔÊ¾
			for i = 1 ,3 do
				g_ClueIntergrations.Component[i]:Hide()
				g_ClueIntergrations.Flag[i] = 0
			end
		end
	else
		--µ±Ñ¡Ôñ·ÖÒ³ÎªÍùÆÚ·ÖÒ³Ê±
		for i = 1 , 6 do 
			g_Clue.Btn[i]:SetText(g_CluePageContent[cluePageIndex].Getclues[i])
			g_Clue.Btn[i]:Disable()
			g_Clue.SelectBKTXTConponent[cluePageIndex][i]:Show()
			g_Clue.SelectBKTXTConponent[cluePageIndex][i]:SetText(g_CluePageContent[cluePageIndex].Getclues[i])
		end
		--ÏÔÊ¾ ûºÏÏßË÷
		for i = 1 ,3 do
			g_ClueIntergrations.Component[i]:Show()
			g_ClueIntergrations.Flag[i] = 1
			for j = 1,6 do
				-- ûºÏÏßË÷£¨ÈýÌõ£©¶ÔÓ¦µÄÏßË÷ÐòºÅ
				if g_Clue.ClueMatch[cluePageIndex][i][j]~= nil then
						local content = g_ClueIntergrations.Content[cluePageIndex][j]
						g_ClueIntergrations.Component[i]:SetText(content)
					break
				end
			end
		end
		--ÏÔÊ¾Íæ¼ÒÑ¡ÔñµÄNPC
		local divisor = math.pow(10,cluePageIndex-1)
		local shiftednumber = math.floor(g_ChosenNpcData/divisor)
		local getPlayerChosen = shiftednumber - math.floor(shiftednumber/10)*10
		if getPlayerChosen == 1 then
			ERenGu_Yure_Client2_SuspectImage1:Show()
		elseif getPlayerChosen == 2 then
			ERenGu_Yure_Client2_SuspectImage2:Show()
		end
		ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Hide()
	end
end
--µã»÷ÏßË÷°´Å¥
function ERenGu_Yure_Client2_CluePage_ClueCheck_Clicked(clueIndex)
	local matchClue = nil
	local clueMatch = g_Clue.ClueMatch[g_CurClurPage]
	if g_ClueClickBackup == -1 then
		--²é Òµ±Ç°°´µÄ°´Å¥¶ÔÓ¦µÄÏßË÷°´Å¥
		for i = 1 ,3 do 
			if clueMatch[i][clueIndex] ~=nil then
				matchClue = g_Clue.g_ClueTips[clueMatch[i][clueIndex]]
			end
		end
		if matchClue~=nil then
			--ÏÔÊ¾ÌáÊ¾Ð§¹û
			matchClue:Show()
		end
		g_ClueClickBackup = clueIndex
		g_Clue.SelectBKTXTConponent[g_CurClurPage][clueIndex]:Show()
		g_Clue.SelectBKTXTConponent[g_CurClurPage][clueIndex]:SetText(g_CluePageContent[g_CurClurPage].Getclues[clueIndex])
	else
		--²é ÒÒÑÑ¡°´Å¥¶ÔÓ¦µÄÏßË÷°´Å¥
		for i = 1 ,3 do 
			if clueMatch[i][g_ClueClickBackup] ~=nil then
				matchClue = g_Clue.g_ClueTips[clueMatch[i][g_ClueClickBackup]]
			end
		end
		if matchClue~=nil then
			--µÚ¶þ´Îµã»÷£¬²»¹Üµã»÷µÄ°´Å¥ÊÇ·ñ ýÈ·£¬ÏÈÒþ²ØÌáÊ¾Ð§¹û
			matchClue:Hide()
		end
		--ÖØ¸´µã»÷Í¬Ò»¸ö
		if g_ClueClickBackup == clueIndex then
			g_Clue.Btn[g_ClueClickBackup]:SetProperty("Selected", "False");
			g_Clue.SelectBKTXTConponent[g_CurClurPage][g_ClueClickBackup]:Hide()
			g_ClueClickBackup = -1
			return 
		end
		--³õÊ¼»¯Ê§°Ü
		if g_CurQuestPhrase == -1 then
			g_Clue.Btn[g_ClueClickBackup]:SetProperty("Selected", "False");
			g_Clue.SelectBKTXTConponent[g_CurClurPage][g_ClueClickBackup]:Hide()
			g_ClueClickBackup = -1
			return
		end
		--·Çµ±Ç°½øÐÐÖÐ·ÖÒ³
		if g_CurClurPage < g_CurQuestPhrase then
			g_Clue.Btn[g_ClueClickBackup]:SetProperty("Selected", "False");
			g_Clue.SelectBKTXTConponent[g_CurClurPage][g_ClueClickBackup]:Hide()
			g_ClueClickBackup = -1
			return 
		end
		--µã»÷ÁËÁ½¸ö²»Í¬µÄ°´Å¥£¬ÏÈ¸øºóÒ»¸öµã»÷µÄ°´Å¥È¡ÏûÑ¡ÖÐ£¬ÔÙ½øÐÐÏßË÷ÅÐ¶¨
		g_Clue.Btn[clueIndex]:SetProperty("Selected", "False");
		g_Clue.Btn[g_ClueClickBackup]:SetProperty("Selected", "False");

		if g_CurClurPage == g_CurQuestPhrase+1 then
			local isTrueMatch = false
			--Ò»¶ÔÏßË÷Ñ¡Ôñ³É¹¦£¬°´Å¥Ñ¡ÖÐÖØÖÃ£¬½øÐÐÏßË÷Æ¥ÅäÅÐ¶¨
			local clueMatch = g_Clue.ClueMatch[g_CurClurPage]
			for i = 1 ,3 do 
				if clueMatch[i][g_ClueClickBackup] ~=nil and clueMatch[i][g_ClueClickBackup] == clueIndex then
					g_ClueIntergrations.Component[i]:Show()
					g_ClueIntergrations.Flag[i] = 1
					local content = g_ClueIntergrations.Content[g_CurClurPage][clueIndex]
					g_ClueIntergrations.Component[i]:SetText(content)
					g_Clue.Btn[g_ClueClickBackup]:Disable()
					g_Clue.Btn[clueIndex]:Disable()
					
					g_Clue.SelectBKTXTConponent[g_CurClurPage][clueIndex]:Show()
					g_Clue.SelectBKTXTConponent[g_CurClurPage][clueIndex]:SetText(g_CluePageContent[g_CurClurPage].Getclues[clueIndex])
					isTrueMatch = true
					g_IntergrationLock:Hide()
					PushDebugMessage("#{ERYR_240701_81}")
					break
				end
			end
			--Ã»ÓÐÏßË÷Æ¥ÅäÏî
			if isTrueMatch ~= true then
				PushDebugMessage("#{ERYR_240701_83}")
				g_Clue.SelectBKTXTConponent[g_CurClurPage][g_ClueClickBackup]:Hide()
			end
			--²é¿´ÊÇ·ñÒÑ¾­Íê³ÉÈý¸öÏßË÷µÄ ûºÏÐÐÎª£¬Èç¹ûÒÑÍê³ÉÔò½çÃæÏÔÊ¾ÈÎÎñÍê³É£¬²¢Í¨Öª·þÎñÆ÷¸üÐÂÈÎÎñ½ø¶È
			local isFinishIntergration = true
			for i = 1,3 do
				if g_ClueIntergrations.Flag[i] ~= 1 then
					isFinishIntergration = false
					break
				end 
			end 
			--ÈÎÎñÍê³É£¬¸üÐÂ½çÃæ²¢Í¨ÖªÈÎÎñ¸üÐÂ
			if isFinishIntergration then
				g_IsIntergtation = 1
				PushDebugMessage("#{ERYR_240701_82}")
				ERenGu_Yure_Client2_Clue_Answer_GotoBtn:Enable()

				ERenGu_Yure_Phase2UpdateQuest()

				-- ERenGu_Yure_Client2_PageClick( g_CurQuestPhrase)
			end
			-- g_Clue.Btn[g_ClueClickBackup]:SetProperty("Selected", "False");
			g_ClueClickBackup = -1
		end
	end
end
function ERenGu_Yure_Phase2UpdateQuest()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(g_MissionScrpitID)
		Set_XSCRIPT_Function_Name("UpdateFromUI")
		Set_XSCRIPT_Parameter(0,g_CurQuestPhrase)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
--µã»÷help°´Å¥
function ERenGu_Yure_ClickHelp()
	PushEvent("QUEST_HELPINFO", "#{ERYR_240701_35}")
end
function ERenGu_Yure_Phase2CloseCase_Init()
	for i = 1,3 do
		g_CloseCase_Component.EvideneceNote_Component[i]:StartFade(1,0,0)
	end
	SetTimer("ERenGu_Yure","ERenGu_Yure_CloseCaseTimer()", 1000)
	g_CloseCase_Component.GotoBtn.State = 0
	--ËÆÓÐõèõÎ£¬ÄÑµÀ
	ERenGu_Yure_Client2_CluePage_CloseCase_GotoBtn1:Show()
	ERenGu_Yure_Client2_CluePage_CloseCase_GotoBtn2:Hide()
	-- g_CloseCase_Component.GotoBtn.Component:SetText("#{ERYR_240701_85}")
end
function ERenGu_Yure_CloseCaseTimer()
	g_CloseCasePhase = g_CloseCasePhase + 1 
	--ËÄ¸ö×ïÖ¤×¢ÊÍÒ»´ÎÏÔÊ¾
	if g_CloseCasePhase <=3 then
		g_CloseCase_Component.EvideneceNote_Component[g_CloseCasePhase]:StartFade(0,1,2)
	end
	--×îºóÏÔÊ¾¶¯»­²¢³ÖÐøËÄÃë
	if g_CloseCasePhase == 4 then
		g_CloseCasePhase = 0
		g_CloseCase_Component.GotoBtn.State = 1
		--¾¹È»¡­¡­
		ERenGu_Yure_Client2_CluePage_CloseCase_GotoBtn2:Show()
		ERenGu_Yure_Client2_CluePage_CloseCase_GotoBtn1:Hide()
		-- g_CloseCase_Component.GotoBtn.Component:SetText("#{ERYR_240701_86}")
		KillTimer("ERenGu_Yure_CloseCaseTimer()");
	end
end
function ERenGu_Yure_Client2_CluePage_Goto_Clicked()
	g_CloseCase_Component.AnimateComponent:Show()
	SetTimer("ERenGu_Yure","ERenGu_Yure_CloseAnimateTimer()", 4000)
	PushDebugMessage("#{ERYR_240701_87}")
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID(g_MissionScrpitID)
			Set_XSCRIPT_Function_Name("CloseCaseUpdateFromUI")
			Set_XSCRIPT_Parameter(0,g_CurQuestPhrase)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	AutoRuntoTargetExWithName(137, 183, 1, "Ngß¶i n±i tiªng Ngæ")
	local GotoBtnState = g_CloseCase_Component.GotoBtn.State
	if GotoBtnState == 1 then
		g_CloseCase_Component.AnimateComponent:Play(true)
		g_CloseCase_Component.AnimateComponent:Show()
	end
end
function ERenGu_Yure_Client3_Goto_Clicked()
	if g_IsHaveMissionState < 1 then
		-- PushDebugMessage("#{ERYR_240701_88}")
		ERenGu_Yure_CloseFunc()
	else
		if g_CurQuestPhrase == 3 then
			AutoRuntoTargetExWithName(149, 268, 1, "Thi cu°n cuµn")
		else
			AutoRunToTargetEx(168,109,30)
			PushDebugMessage("#{ERYR_240701_328}")
		end
		ERenGu_Yure_CloseFunc()
	end
end
function ERenGu_Yure_Client2_Clue_FenYeTipsClick(Index)
	local cIndex = Index
	PushDebugMessage(g_CluePageTips.DebugMessage[cIndex]) 
end
function ERenGu_Yure_CloseAnimateTimer()
	g_CloseCase_Component.AnimateComponent:Play(false)
	g_CloseCase_Component.AnimateComponent:Hide()
	ERenGu_Yure_CloseFunc()
end
function ERenGu_Yure_UIPhase(UIPhase)
	for i = 1 , 3 do
		if UIPhase == i then
			g_Client[i]:Show();
		else
			g_Client[i]:Hide();
		end
	end
	--¶Ô½×¶Î¶þ×öÒ»¶¨ÌØÅÐ£¬ÐèÒª°Ñ½×¶Î¶þ·Ö¿ª³ÉÁ½¸ö½×¶Î
	if UIPhase == 2 and g_IsCloseCase == 1 then
		ERenGu_Yure_Client2_CluePage_CloseCaseFrame:Show()
		ERenGu_Yure_Client2_ClueFrame:Hide()
	else
		ERenGu_Yure_Client2_CluePage_CloseCaseFrame:Hide()
		ERenGu_Yure_Client2_ClueFrame:Show()
	end
end
