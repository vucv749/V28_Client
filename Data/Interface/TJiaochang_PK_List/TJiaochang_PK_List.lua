-- Ð£³¡¹Û ½List

local g_Timers = 0
local g_Seconds = 2

local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;

local g_List_PageCount = 20;
local g_Challenge_CurPage = 0;


local CHALLENGE_TYPE_ICON_LEFT = {};		--	??????
local CHALLENGE_TYPE_ICON_RIGHT = {};

-- SJBW_210415_01	#HÇëÏÈ½« äÊÞÊ »ØºóÔÙ½øÐÐ¹Û ½
-- SJBW_210415_02	#HÇëÏÈÈ¡ÏûÄúµÄÆï³Ë×´Ì¬ÔÙ½øÐÐ¹Û ½
-- SJBW_210415_03	#H×é¶Ó¸úËæ×´Ì¬ÏÂÎÞ·¨½øÐÐ¹Û ½
-- SJBW_210415_04	ÉÙÁÖ
-- SJBW_210415_05	Ã÷½Ì
-- SJBW_210415_06	Ø¤°ï
-- SJBW_210415_07	Îäµ±
-- SJBW_210415_08	¶ëÃ¼
-- SJBW_210415_09	ÐÇËÞ
-- SJBW_210415_10	ÌìÁú
-- SJBW_210415_11	ÌìÉ½
-- SJBW_210415_12	åÐÒ£
-- SJBW_210415_13	ÎÞÃÅÅÉ
-- SJBW_210415_14	#HÄ¿Ç°Ã»ÓÐÌô ½µÄÍæ¼Ò£¬ÄúÎÞ·¨¹Û ½
-- SJBW_210415_15	ÔÝÎÞ±ÈÈü

local g_MenPaiCount = 10; -- ???? 

local CHALLENGE_MENPAISTRINFO = 
{
	[0]	=	"#{SJBW_210415_04}",	--"Thiªu Lâm",
	[1]	=	"#{SJBW_210415_05}",	--"Minh Giáo",
	[2]	=	"#{SJBW_210415_06}",	--"Cái Bang",
	[3]	=	"#{SJBW_210415_07}",	--"Võ Ðang",
	[4]	=	"#{SJBW_210415_08}",	--"Nga Mi",
	[5]	=	"#{SJBW_210415_09}",	--"Tinh Túc",
	[6]	=	"#{SJBW_210415_10}",	--"Thiên Long",
	[7]	=	"#{SJBW_210415_11}",	--"Thiên S½n",
	[8]	=	"#{SJBW_210415_12}",	--"Tiêu dao",
	[9]	=	"#{SJBW_210415_13}",	--"Tñ do"
	[10]=	"#{GMGameInterface_Script_DataPool_Info_ManTuoShanZhuang}",--"MÕn Ðà S½n Trang",
	-- [11]="#{}",--"ÌÆÃÅ",
	-- [12]="#{}",--"¹í¹È",
	-- [13]="#{}",--"ÌÒ»¨µº",
}

function TJiaochang_PK_List_PreLoad()
    this:RegisterEvent("SHOW_CHALLENGE_LIST")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function TJiaochang_PK_List_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frame_UnifiedXPosition	= TJiaochang_PK_List_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= TJiaochang_PK_List_Frame:GetProperty("UnifiedYPosition");
	
	CHALLENGE_TYPE_ICON_LEFT[1] = TJiaochang_TeamImage1_1
	CHALLENGE_TYPE_ICON_LEFT[2] = TJiaochang_TeamImage2_1
	CHALLENGE_TYPE_ICON_LEFT[3] = TJiaochang_TeamImage3_1
	CHALLENGE_TYPE_ICON_LEFT[4] = TJiaochang_TeamImage4_1
	CHALLENGE_TYPE_ICON_LEFT[5] = TJiaochang_TeamImage5_1
	CHALLENGE_TYPE_ICON_LEFT[6] = TJiaochang_TeamImage6_1
	CHALLENGE_TYPE_ICON_LEFT[7] = TJiaochang_TeamImage7_1
	CHALLENGE_TYPE_ICON_LEFT[8] = TJiaochang_TeamImage8_1
	CHALLENGE_TYPE_ICON_LEFT[9] = TJiaochang_TeamImage9_1
	CHALLENGE_TYPE_ICON_LEFT[10] = TJiaochang_TeamImage10_1
	CHALLENGE_TYPE_ICON_LEFT[11] = TJiaochang_TeamImage11_1
	CHALLENGE_TYPE_ICON_LEFT[12] = TJiaochang_TeamImage12_1
	CHALLENGE_TYPE_ICON_LEFT[13] = TJiaochang_TeamImage13_1
	CHALLENGE_TYPE_ICON_LEFT[14] = TJiaochang_TeamImage14_1
	CHALLENGE_TYPE_ICON_LEFT[15] = TJiaochang_TeamImage15_1
	CHALLENGE_TYPE_ICON_LEFT[16] = TJiaochang_TeamImage16_1
	CHALLENGE_TYPE_ICON_LEFT[17] = TJiaochang_TeamImage17_1
	CHALLENGE_TYPE_ICON_LEFT[18] = TJiaochang_TeamImage18_1
	CHALLENGE_TYPE_ICON_LEFT[19] = TJiaochang_TeamImage19_1
	CHALLENGE_TYPE_ICON_LEFT[20] = TJiaochang_TeamImage20_1
	
	CHALLENGE_TYPE_ICON_RIGHT[1] = TJiaochang_TeamImage1_2
	CHALLENGE_TYPE_ICON_RIGHT[2] = TJiaochang_TeamImage2_2
	CHALLENGE_TYPE_ICON_RIGHT[3] = TJiaochang_TeamImage3_2
	CHALLENGE_TYPE_ICON_RIGHT[4] = TJiaochang_TeamImage4_2
	CHALLENGE_TYPE_ICON_RIGHT[5] = TJiaochang_TeamImage5_2
	CHALLENGE_TYPE_ICON_RIGHT[6] = TJiaochang_TeamImage6_2
	CHALLENGE_TYPE_ICON_RIGHT[7] = TJiaochang_TeamImage7_2
	CHALLENGE_TYPE_ICON_RIGHT[8] = TJiaochang_TeamImage8_2
	CHALLENGE_TYPE_ICON_RIGHT[9] = TJiaochang_TeamImage9_2
	CHALLENGE_TYPE_ICON_RIGHT[10] = TJiaochang_TeamImage10_2
	CHALLENGE_TYPE_ICON_RIGHT[11] = TJiaochang_TeamImage11_2
	CHALLENGE_TYPE_ICON_RIGHT[12] = TJiaochang_TeamImage12_2
	CHALLENGE_TYPE_ICON_RIGHT[13] = TJiaochang_TeamImage13_2
	CHALLENGE_TYPE_ICON_RIGHT[14] = TJiaochang_TeamImage14_2
	CHALLENGE_TYPE_ICON_RIGHT[15] = TJiaochang_TeamImage15_2
	CHALLENGE_TYPE_ICON_RIGHT[16] = TJiaochang_TeamImage16_2
	CHALLENGE_TYPE_ICON_RIGHT[17] = TJiaochang_TeamImage17_2
	CHALLENGE_TYPE_ICON_RIGHT[18] = TJiaochang_TeamImage18_2
	CHALLENGE_TYPE_ICON_RIGHT[19] = TJiaochang_TeamImage19_2
	CHALLENGE_TYPE_ICON_RIGHT[20] = TJiaochang_TeamImage20_2

end

function TJiaochang_PK_List_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		TJiaochang_PK_List_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TJiaochang_PK_List_ResetPos()
	elseif( event == "SHOW_CHALLENGE_LIST" ) then
		local curSceneID = GetSceneID(); --
		if curSceneID ~= 611 then
			return 
		end
		TJiaochang_PK_List_FirstFillData()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end
end
function TJiaochang_PK_List_ClearItemList()
	TJiaochang_PK_List_PkList:RemoveAllItem()
	for i = 1,20 do
		CHALLENGE_TYPE_ICON_LEFT[i]:Hide()
		CHALLENGE_TYPE_ICON_RIGHT[i]:Hide()
	end
	TJiaochang_PK_List_UpButton:Disable()
	TJiaochang_PK_List_DownButton:Disable()
end

function TJiaochang_PK_List_FirstFillData()
	TJiaochang_PK_List_ClearItemList()
	local nCount = DataPool:GetChallengeCount()
	if nCount <= 0 then
		-- SJBW_210415_15	ÔÝÎÞ±ÈÈü
		PushDebugMessage("#{SJBW_210415_15}")
		g_Challenge_CurPage = 0
		TJiaochang_PK_List_ClearItemList()
		TJiaochang_PK_List_CountFenye : SetText("")
	else
		g_Challenge_CurPage = 0
		TJiaochang_PK_List_FillListData()
	end

	this:Show()
end

function TJiaochang_PK_List_NextPage()
	local nCount = DataPool:GetChallengeCount()
	if g_Challenge_CurPage * g_List_PageCount + g_List_PageCount >= nCount then
		return
	end
	g_Challenge_CurPage = g_Challenge_CurPage + 1
	TJiaochang_PK_List_FillListData()
end
function TJiaochang_PK_List_PrePage()
	if g_Challenge_CurPage <= 0 then
		return
	end
	g_Challenge_CurPage = g_Challenge_CurPage - 1
	TJiaochang_PK_List_FillListData()
end
function TJiaochang_PK_List_FillListData()
	
	TJiaochang_PK_List_ClearItemList()
	local startpos = g_Challenge_CurPage * g_List_PageCount
	local endpos = startpos + 20
	local nCount = DataPool:GetChallengeCount()
	if startpos >= nCount then
		return
	end
	
	if startpos > 0 then
		TJiaochang_PK_List_UpButton:Enable()
	else	
		TJiaochang_PK_List_UpButton:Disable()
	end
	
	if endpos < nCount then
		TJiaochang_PK_List_DownButton:Enable()
	else
		TJiaochang_PK_List_DownButton:Disable()
	end
	
	local maxpages = math.ceil( tonumber(nCount/g_List_PageCount) )
	TJiaochang_PK_List_CountFenye : SetText(tostring(g_Challenge_CurPage+1).."/"..tostring(maxpages))

	for i=startpos, endpos-1 do
	
		local curpos = i - startpos
		if curpos < 0 or curpos >= 20 then
			break
		end
		
		local ret,nameA,typeA,menpaiA,levelA,zoneWorldIdA,nameB,typeB,menpaiB,levelB,zoneWorldIdB = DataPool:GetChallengeInfo(i)
		
		if ret == 0 then
			break
		end
		
		-- 10TL ²»´æÔÚÉÍ½ð ½  âÀïÍ³Ò»ÓÃÄ¬ÈÏµÄ
		-- SJBW_130823_31	×é¶ÓÌô ½
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		-- CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()

		-- if typeA == 2 then
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:Button2 image:Icon_GoldCoin")
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_27}" )
		-- 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()
		if typeA == 1 then
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		 	CHALLENGE_TYPE_ICON_LEFT[curpos+1]:Show()
		end

		-- 10TL »¹Ã»ÓÐÌìÍâ£¬ â¿éÂß¼­ÔÝÊ±×¢ÊÍµô
		local selfZoneWorldID = DataPool:GetSelfZoneWorldID()
		if selfZoneWorldID ~= 0 and selfZoneWorldID ~= zoneWorldIdA then
			local serverName = DataPool:GetServerName( zoneWorldIdA )
			nameA = nameA.."@"..tostring(serverName)
		end
		
		TJiaochang_PK_List_PkList:AddNewItem("",0,curpos)
		TJiaochang_PK_List_PkList:AddNewItem(nameA,1,curpos)
		if menpaiA >= 0 and menpaiA <= g_MenPaiCount then
			TJiaochang_PK_List_PkList:AddNewItem(CHALLENGE_MENPAISTRINFO[menpaiA],2,curpos)
		else
			TJiaochang_PK_List_PkList:AddNewItem("",2,curpos)
		end
		TJiaochang_PK_List_PkList:AddNewItem(tostring(levelA),3,curpos)
		TJiaochang_PK_List_PkList:AddNewItem("#RVS",4,curpos)
		
		-- 10TL ²»´æÔÚÉÍ½ð ½  âÀïÍ³Ò»ÓÃÄ¬ÈÏµÄ
		-- SJBW_130823_31	×é¶ÓÌô ½
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		-- CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()

		-- if typeB == 2 then
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:Button2 image:Icon_GoldCoin")
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_27}" )
		-- 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()
		if typeB == 1 then
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetProperty("Image","set:UIIcons image:LeaderOpening")
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:SetToolTip( "#{SJBW_130823_31}" )
		 	CHALLENGE_TYPE_ICON_RIGHT[curpos+1]:Show()
		end
		
		-- 10TL »¹Ã»ÓÐÌìÍâ£¬ â¿éÂß¼­ÔÝÊ±×¢ÊÍµô
		if selfZoneWorldID ~= 0 and selfZoneWorldID ~= zoneWorldIdB then
			local serverName = DataPool:GetServerName( zoneWorldIdB )
			nameB = nameB.."@"..tostring(serverName)
		end

		TJiaochang_PK_List_PkList:AddNewItem("",5,curpos)
		TJiaochang_PK_List_PkList:AddNewItem(nameB,6,curpos)
		if menpaiB >= 0 and menpaiB <= g_MenPaiCount then
			TJiaochang_PK_List_PkList:AddNewItem(CHALLENGE_MENPAISTRINFO[menpaiB],7,curpos)
		else
			TJiaochang_PK_List_PkList:AddNewItem("",7,curpos)
		end
		TJiaochang_PK_List_PkList:AddNewItem(tostring(levelB),8,curpos)
	end
end

function TJiaochang_PK_List_PkList_On_SelectionChanged()

end

function TJiaochang_PK_List_CloseClicked()
    this:Hide()
end

function TJiaochang_PK_List_RefreshButtonClicked()
	if not TJiaochang_PK_List_PassTime(g_Seconds) then
		PushDebugMessage("#{SJBW_130823_52}");
		return
	end

	--this:Hide()
	--TJiaochang_PK_List_ClearItemList()
	DataPool:AskChallengeList();

end

function TJiaochang_PK_List_WatchButtonClicked()
	local nIndex = TJiaochang_PK_List_PkList:GetSelectItem()
	if nIndex == -1 then
		-- SJBW_210415_14	#HÄ¿Ç°Ã»ÓÐÌô ½µÄÍæ¼Ò£¬ÄúÎÞ·¨¹Û ½
		PushDebugMessage("#{SJBW_210415_14}")
		return
	end

	local ret = DataPool:EnterChallengeView(g_Challenge_CurPage * g_List_PageCount+nIndex)
	--if ret == 1 then
	--	this:Hide();
	--end
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function TJiaochang_PK_List_ResetPos()
	TJiaochang_PK_List_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	TJiaochang_PK_List_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function TJiaochang_PK_List_PassTime(iSeconds)
   local iCur = FindFriendDataPool:GetTickCount()
   if ( iCur - g_Timers < iSeconds * 1000) then
      return false;
   else
      g_Timers = iCur;
   	  return true;
   end
end
