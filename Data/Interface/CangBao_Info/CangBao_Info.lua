--******************************************
--×é¶Ó²Ø±¦Í¼¸±±¾ ×îºóÁì½±½çÃæ
--create by  limengyue 
--2024-07-22
--******************************************
local g_CangBao_Info_Frame_UnifiedPosition;
--¹ØĞÄNPc
local g_CangBao_targetId = -1;
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local g_Object = -1

local g_CangBao_PlayerIdx = {}--??????? ?????
--g_CangBao_PlayerIdx[1]={nIndex = 1,nPlayerName = "aa", nItemID = 30000005, nAskIdx = 2, nAskRet = 0, nHeadID = 0}
--¿Ø¼ş
local g_CangBao_PlayerList = {} --6???
local g_CangBao_ItemList = {} --6???
local g_CangBao_GetFlagList = {} --6??????
local g_CangBao_TextList = {} --6????
local g_CangBao_ChangeBtnList = {} --6?????
local g_CangBao_AcceptBtnList = {} --6???????
local g_CangBao_PrizeBtnList = {} --6?????
local g_CangBao_HeadImgList = {} --6????
local g_CangBao_MyImgList = {} --6?????
local g_CangBao_ExchangeTxtList = {} --6???????
local g_CangBao_GetTxtList = {} --6??????

--=========================================================
--PreLoad
--=========================================================
function CangBao_Info_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--¾àÀëNPC¾àÀë
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--ÇĞ³¡¾°ÊÂ¼ş
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function CangBao_Info_OnLoad()
	g_CangBao_Info_Frame_UnifiedPosition = CangBao_Info_Frame:GetProperty("UnifiedPosition");
	--¿Ø¼ş
	--6¸öÍæ¼Ò
	g_CangBao_PlayerList[1] = CangBao_Info_Player1
	g_CangBao_PlayerList[2] = CangBao_Info_Player2
	g_CangBao_PlayerList[3] = CangBao_Info_Player3
	g_CangBao_PlayerList[4] = CangBao_Info_Player4
	g_CangBao_PlayerList[5] = CangBao_Info_Player5
	g_CangBao_PlayerList[6] = CangBao_Info_Player6
	--6¸ö½±Àø
	g_CangBao_ItemList[1] = CangBao_Info_Player1_Item
	g_CangBao_ItemList[2] = CangBao_Info_Player2_Item
	g_CangBao_ItemList[3] = CangBao_Info_Player3_Item
	g_CangBao_ItemList[4] = CangBao_Info_Player4_Item
	g_CangBao_ItemList[5] = CangBao_Info_Player5_Item
	g_CangBao_ItemList[6] = CangBao_Info_Player6_Item
	-- --6¸öÒÑÁìÈ¡±ê¼Ç
	-- g_CangBao_GetFlagList[1] = CangBao_Info_Player1_GetBK
	-- g_CangBao_GetFlagList[2] = CangBao_Info_Player2_GetBK
	-- g_CangBao_GetFlagList[3] = CangBao_Info_Player3_GetBK
	-- g_CangBao_GetFlagList[4] = CangBao_Info_Player4_GetBK
	-- g_CangBao_GetFlagList[5] = CangBao_Info_Player5_GetBK
	-- g_CangBao_GetFlagList[6] = CangBao_Info_Player6_GetBK
	--6¸öÍ·ÏñÇø
	g_CangBao_HeadImgList[1] = CangBao_Info_Player1_Image
	g_CangBao_HeadImgList[2] = CangBao_Info_Player2_Image
	g_CangBao_HeadImgList[3] = CangBao_Info_Player3_Image
	g_CangBao_HeadImgList[4] = CangBao_Info_Player4_Image
	g_CangBao_HeadImgList[5] = CangBao_Info_Player5_Image
	g_CangBao_HeadImgList[6] = CangBao_Info_Player6_Image
	--6¸öÎÄ±¾Çø
	g_CangBao_TextList[1] = CangBao_Info_Player1_Exchange
	g_CangBao_TextList[2] = CangBao_Info_Player2_Exchange
	g_CangBao_TextList[3] = CangBao_Info_Player3_Exchange
	g_CangBao_TextList[4] = CangBao_Info_Player4_Exchange
	g_CangBao_TextList[5] = CangBao_Info_Player5_Exchange
	g_CangBao_TextList[6] = CangBao_Info_Player6_Exchange
	--6¸öÏÔÊ¾×Ô¼º
	g_CangBao_MyImgList[1] = CangBao_Info_Player1Image
	g_CangBao_MyImgList[2] = CangBao_Info_Player2Image
	g_CangBao_MyImgList[3] = CangBao_Info_Player3Image
	g_CangBao_MyImgList[4] = CangBao_Info_Player4Image
	g_CangBao_MyImgList[5] = CangBao_Info_Player5Image
	g_CangBao_MyImgList[6] = CangBao_Info_Player6Image
	--6¸ö½»»»°´Å¥
	g_CangBao_ChangeBtnList[1] = CangBao_Info_Player1_ExchangeBtn
	g_CangBao_ChangeBtnList[2] = CangBao_Info_Player2_ExchangeBtn
	g_CangBao_ChangeBtnList[3] = CangBao_Info_Player3_ExchangeBtn
	g_CangBao_ChangeBtnList[4] = CangBao_Info_Player4_ExchangeBtn
	g_CangBao_ChangeBtnList[5] = CangBao_Info_Player5_ExchangeBtn
	g_CangBao_ChangeBtnList[6] = CangBao_Info_Player6_ExchangeBtn
	--6¸ö½ÓÊÜ½»»»°´Å¥
	g_CangBao_AcceptBtnList[1] = CangBao_Info_Player1_OKBtn
	g_CangBao_AcceptBtnList[2] = CangBao_Info_Player2_OKBtn
	g_CangBao_AcceptBtnList[3] = CangBao_Info_Player3_OKBtn
	g_CangBao_AcceptBtnList[4] = CangBao_Info_Player4_OKBtn
	g_CangBao_AcceptBtnList[5] = CangBao_Info_Player5_OKBtn
	g_CangBao_AcceptBtnList[6] = CangBao_Info_Player6_OKBtn
	--6¸öÁì½±°´Å¥
	g_CangBao_PrizeBtnList[1] = CangBao_Info_Player1_GetBtn
	g_CangBao_PrizeBtnList[2] = CangBao_Info_Player2_GetBtn
	g_CangBao_PrizeBtnList[3] = CangBao_Info_Player3_GetBtn
	g_CangBao_PrizeBtnList[4] = CangBao_Info_Player4_GetBtn
	g_CangBao_PrizeBtnList[5] = CangBao_Info_Player5_GetBtn
	g_CangBao_PrizeBtnList[6] = CangBao_Info_Player6_GetBtn
	--6¸öÏÔÊ¾½»»»×´Ì¬
	g_CangBao_ExchangeTxtList[1] = CangBao_Info_Player1_Exchange2
	g_CangBao_ExchangeTxtList[2] = CangBao_Info_Player2_Exchange2
	g_CangBao_ExchangeTxtList[3] = CangBao_Info_Player3_Exchange2
	g_CangBao_ExchangeTxtList[4] = CangBao_Info_Player4_Exchange2
	g_CangBao_ExchangeTxtList[5] = CangBao_Info_Player5_Exchange2
	g_CangBao_ExchangeTxtList[6] = CangBao_Info_Player6_Exchange2
	--6¸öÏÔÊ¾ÒÑÁìÈ¡
	g_CangBao_GetTxtList[1] = CangBao_Info_Player1_GetBK
	g_CangBao_GetTxtList[2] = CangBao_Info_Player2_GetBK
	g_CangBao_GetTxtList[3] = CangBao_Info_Player3_GetBK
	g_CangBao_GetTxtList[4] = CangBao_Info_Player4_GetBK
	g_CangBao_GetTxtList[5] = CangBao_Info_Player5_GetBK
	g_CangBao_GetTxtList[6] = CangBao_Info_Player6_GetBK
end

--=========================================================
--»Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--=========================================================
function CangBao_Info_On_ResetPos()

	CangBao_Info_Frame:SetProperty("UnifiedPosition", g_CangBao_Info_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_Info_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340320 ) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("CangBao_Info")) then
			CloseWindow("CangBao_Info", true)
		end
		--Ìí¼ÓNPC¹ØĞÄ ²»ĞèÒª
		g_CangBao_targetId = Get_XParam_INT(0)
		if g_CangBao_targetId >= 0 then
			objCared = DataPool : GetNPCIDByServerID(g_CangBao_targetId);
			CangBao_Info_BeginCareObject(objCared)
		end
		CangBao_Info_Open(Get_XParam_INT(1),Get_XParam_STR(0),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_STR(1),Get_XParam_INT(4),Get_XParam_INT(5),Get_XParam_STR(2),Get_XParam_INT(6),Get_XParam_INT(7),Get_XParam_STR(3),Get_XParam_INT(8),Get_XParam_INT(9),Get_XParam_STR(4),Get_XParam_INT(10),Get_XParam_INT(11),Get_XParam_STR(5),Get_XParam_INT(12),Get_XParam_INT(13))
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 89340321 ) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("CangBao_Info")) then
			--¸üĞÂÊı¾İ
			CangBao_Info_Update(Get_XParam_INT(0),Get_XParam_STR(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_STR(1),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_STR(2),Get_XParam_INT(5),Get_XParam_INT(6),Get_XParam_STR(3),Get_XParam_INT(7),Get_XParam_INT(8),Get_XParam_STR(4),Get_XParam_INT(9),Get_XParam_INT(10),Get_XParam_STR(5),Get_XParam_INT(11),Get_XParam_INT(12))
		end
	end
	-- ´°¿Ú±ä»¯
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Info_On_ResetPos();
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_Info_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_Info_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--´ò¿ª½çÃæ
--nAskRet 0 1 ıÔÚ½»»» 2ÊÇ½»»»³É¹¦ÁìÈ¡  3ÊÇÒÑÁìÈ¡
--=========================================================
function CangBao_Info_Open(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	CangBao_Info_Update(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	this:Show()
end

--=========================================================
--´ò¿ª½çÃæ
--nAskRet 0 1 ıÔÚ½»»» 2ÊÇ½»»»³É¹¦  3ÊÇÒÑÁìÈ¡½»»»½±Àø  4ÊÇ×Ô¼ºÁìÈ¡ÁË×Ô¼ºµÄ
--=========================================================
function CangBao_Info_Update(nItem1,nPlayer1,nPlayer1Info,nItem2,nPlayer2,nPlayer2Info,nItem3,nPlayer3,nPlayer3Info,nItem4,nPlayer4,nPlayer4Info,nItem5,nPlayer5,nPlayer5Info,nItem6,nPlayer6,nPlayer6Info,nTick)
	g_CangBao_PlayerIdx = {}
	
	--PushDebugMessage("ÈËÃû "..nPlayer1.." "..nPlayer2.." "..nPlayer3.." "..nPlayer4.." "..nPlayer5.." "..nPlayer6)
	--PushDebugMessage("¶ÔÓ¦ĞÅÏ¢"..nPlayer1Info.." "..nPlayer2Info.." "..nPlayer3Info.." "..nPlayer4Info.." "..nPlayer5Info.." "..nPlayer6Info)
	--Ê£ÓàÊ±¼ä
	if nTick > 0 then
		CangBao_Info_Time:SetProperty("Timer", tostring(nTick))
	else
		CangBao_Info_Time:SetProperty("Timer", "0")
	end
	
	local mAskPlayerIDx1 = math.mod(nPlayer1Info,10)
	local mAskResult1 = math.floor(math.mod(nPlayer1Info,100)/10) 
	local mHeadID1 = math.floor(math.mod(nPlayer1Info,100000)/100) 
	g_CangBao_PlayerIdx[1]={nIndex = 1,nPlayerName = tostring(nPlayer1), nItemID = tonumber(nItem1),nAskIdx = mAskPlayerIDx1, nAskRet = mAskResult1, nHeadID = mHeadID1}
	local mAskPlayerIDx2 = math.mod(nPlayer2Info,10)
	local mAskResult2 = math.floor(math.mod(nPlayer2Info,100)/10) 
	local mHeadID2 = math.floor(math.mod(nPlayer2Info,100000)/100) 
	g_CangBao_PlayerIdx[2]={nIndex = 2,nPlayerName = tostring(nPlayer2), nItemID = tonumber(nItem2),nAskIdx = mAskPlayerIDx2, nAskRet = mAskResult2, nHeadID = mHeadID2}
	local mAskPlayerIDx3 = math.mod(nPlayer3Info,10)
	local mAskResult3 = math.floor(math.mod(nPlayer3Info,100)/10) 
	local mHeadID3 = math.floor(math.mod(nPlayer3Info,100000)/100) 
	g_CangBao_PlayerIdx[3]={nIndex = 3,nPlayerName = tostring(nPlayer3), nItemID = tonumber(nItem3),nAskIdx = mAskPlayerIDx3, nAskRet = mAskResult3, nHeadID = mHeadID3}
	local mAskPlayerIDx4 = math.mod(nPlayer4Info,10)
	local mAskResult4 = math.floor(math.mod(nPlayer4Info,100)/10) 
	local mHeadID4 = math.floor(math.mod(nPlayer4Info,100000)/100) 
	g_CangBao_PlayerIdx[4]={nIndex = 4,nPlayerName = tostring(nPlayer4), nItemID = tonumber(nItem4),nAskIdx = mAskPlayerIDx4, nAskRet = mAskResult4, nHeadID = mHeadID4}
	local mAskPlayerIDx5 = math.mod(nPlayer5Info,10)
	local mAskResult5 = math.floor(math.mod(nPlayer5Info,100)/10) 
	local mHeadID5 = math.floor(math.mod(nPlayer5Info,100000)/100) 
	g_CangBao_PlayerIdx[5]={nIndex = 5,nPlayerName = tostring(nPlayer5), nItemID = tonumber(nItem5),nAskIdx = mAskPlayerIDx5, nAskRet = mAskResult5, nHeadID = mHeadID5}
	local mAskPlayerIDx6 = math.mod(nPlayer6Info,10)
	local mAskResult6 = math.floor(math.mod(nPlayer6Info,100)/10) 
	local mHeadID6 = math.floor(math.mod(nPlayer6Info,100000)/100) 
	g_CangBao_PlayerIdx[6]={nIndex = 6,nPlayerName = tostring(nPlayer6), nItemID = tonumber(nItem6),nAskIdx = mAskPlayerIDx6, nAskRet = mAskResult6, nHeadID = mHeadID6}
	local myName = Player:GetName()	
	local myIdx = -1
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--µ±Ç°Ãû×Ö
		local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
		--¶Ô±È
		if myName == nCurName then
			myIdx = index
			break
		end
	end
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--Íæ¼ÒÓĞ½±Àø²ÅÏÔÊ¾
		if g_CangBao_PlayerIdx[index].nItemID > 0 then
			g_CangBao_PlayerList[index]:Show();
			--µ±Ç°Ãû×Ö
			local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
			g_CangBao_TextList[index]:SetText(nCurName)
			--µ±Ç°Í·Ïñ
			local mHeadID = g_CangBao_PlayerIdx[index].nHeadID
			local portrait = DataPool:GetPortraitByID(mHeadID)
			--PushDebugMessage("test µÚ"..index.."¸öÍæ¼Ò"..nCurName.."Í·Ïñid="..mHeadID.." Í·ÏñÍ¼Æ¬="..portrait)
			g_CangBao_HeadImgList[index]:SetProperty("Image", portrait)
			--Ä¬ÈÏÒş²Ø×´Ì¬ÎÄ×Ö
			g_CangBao_ExchangeTxtList[index]:Hide();
			g_CangBao_GetTxtList[index]:Hide();
			--Ä¬ÈÏÎ´ÁìÈ¡
			--g_CangBao_GetFlagList[index]:Hide();
			--Ä¬ÈÏÒş²ØÈı¸ö°´Å¥
			--µ±Ç°ÇëÇó½»»»µÄidx
			local nAskIdx = g_CangBao_PlayerIdx[index].nAskIdx	
			--ÏÈ¿´ÊÇ²»ÊÇÎÒ×Ô¼º
			g_CangBao_PrizeBtnList[index]:Hide();
			g_CangBao_AcceptBtnList[index]:Hide();
			g_CangBao_ChangeBtnList[index]:Hide();
			
			--ÏÔÊ¾ÎÄ±¾
			if myName ==  nCurName then
				--ÏÔÊ¾ÎÒµÄ
				g_CangBao_MyImgList[index]:Show();
				--g_CangBao_TextList[index]:SetText("#{ZDBT_240703_153}")
				--ÁìÈ¡°´Å¥Ö»ÓĞ×Ô¼ºÓĞ ²¢ÇÒÊÇÎ´ÁìÈ¡×´Ì¬²ÅÏÔÊ¾
				if g_CangBao_PlayerIdx[index].nAskRet == 4 then
					--ÁìÁË×Ô¼ºµÄ½±Àø
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--ÏÔÊ¾Ï¸½Ú ×Ô¼ºµÄÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 3 then
					--ÒÑÁìÈ¡
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--ÏÔÊ¾Ï¸½Ú ½»»»À´µÄÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				else
					if g_CangBao_PlayerIdx[index].nAskRet == 2 then
						--ÏÔÊ¾Ï¸½Ú ±ğÈËµÄÎïÆ·
						local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
						if nShowActionA:GetID() ~= 0 then
							g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
						end
					else
						--ÏÔÊ¾Ï¸½Ú ×Ô¼ºµÄÎïÆ·
						local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
						if nShowActionA:GetID() ~= 0 then
							g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
						end
					end
					g_CangBao_PrizeBtnList[index]:Show();	
					g_CangBao_PrizeBtnList[index]:Enable();
				end
			else
				--±ğÈËÄÇ±ßÔõÃ´ÏÔÊ¾ ÁìÃ»Áì ÊÇÎÒµÄÄ¿±ê ÎÒÊÇ±ğÈËµÄÄ¿±ê ´óÏĞÈË
				g_CangBao_MyImgList[index]:Hide();
				--ÊÇ·ñÒÑ¾­ÁìÈ¡
				if g_CangBao_PlayerIdx[index].nAskRet == 4 then
					--ÒÑÁìÈ¡ ÁìÈ¡µÄ×Ô¼ºitem
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--%s0ÉÙÏÀ»ñµÃ
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--ÏÔÊ¾Ï¸½Ú ×Ô¼ºµÄÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 3 then
					--ÒÑÁìÈ¡ ÁìÈ¡µÄÄ¿±êµÄitem
					--g_CangBao_GetFlagList[index]:Show();
					g_CangBao_GetTxtList[index]:Show();
					--%s0ÉÙÏÀ»ñµÃ
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--ÏÔÊ¾Ï¸½Ú ÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				elseif g_CangBao_PlayerIdx[index].nAskRet == 2 then
					--¸ ½»»»Íê ÏÔÊ¾±ğÈËµÄitem
					--%s0ÉÙÏÀ»ñµÃ
					--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
					--ÏÔÊ¾Ï¸½Ú ÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[nAskIdx].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
				else
					--PushDebugMessage("»¹Ã»Áì")
					--ÏÔÊ¾Ï¸½Ú ×Ô¼ºµÄÎïÆ·
					local nShowActionA = DataPool:CreateBindActionItemForShow(g_CangBao_PlayerIdx[index].nItemID, 1)
					if nShowActionA:GetID() ~= 0 then
						g_CangBao_ItemList[index]:SetActionItem(nShowActionA:GetID())
					end
					--±ğÈË»¹Ã»Áì½±  ·ÖÎª ÊÇÎÒµÄÄ¿±ê ÎÒÊÇ±ğÈËµÄÄ¿±ê ´óÏĞÈË
					if g_CangBao_PlayerIdx[myIdx].nAskIdx == index then
						--PushDebugMessage("ÊÇÎÒµÄÄ¿±ê")
						--ÊÇÎÒµÄÄ¿±ê
						--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
						--°´Å¥´¦Àí
						g_CangBao_ChangeBtnList[index]:Show();
						g_CangBao_ChangeBtnList[index]:Disable();
						g_CangBao_ChangeBtnList[index]:SetText("#{ZDBT_240703_164}")--???
					else
						--²»ÊÇÎÒµÄÄ¿±ê
						--PushDebugMessage("²»ÊÇÎÒµÄÄ¿±ê ask="..g_CangBao_PlayerIdx[index].nAskIdx.." myIdx="..myIdx)
						if g_CangBao_PlayerIdx[index].nAskIdx == myIdx then 
							--µ«ÊÇÎÒÊÇËûµÄÄ¿±ê
							g_CangBao_ExchangeTxtList[index]:Show();
							--%s0ÉÙÏÀÇëÇó½»»»
							--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_165}", nCurName))
							--°´Å¥´¦Àí
							g_CangBao_AcceptBtnList[index]:Show();
							g_CangBao_AcceptBtnList[index]:Enable();
						else
							--´óÏĞÈË
							--g_CangBao_TextList[index]:SetText(ScriptGlobal_Format("#{ZDBT_240703_162}", nCurName))
							--¿´ÎÒÄÜ²»ÄÜÉêÇë
							if g_CangBao_PlayerIdx[myIdx].nAskRet < 1 then
								--ÎÒ²»ÔÚ½»»»ÖĞÒ²Ã»Áì½±
								g_CangBao_ChangeBtnList[index]:Show();
								g_CangBao_ChangeBtnList[index]:Enable();
								g_CangBao_ChangeBtnList[index]:SetText("#{ZDBT_240703_97}")--??
							else
								--Ëû°®¸ÉÂï¸ÉÂï ¸úÎÒÃ»¹ØÏµÁË
							end
						end
					end
				end
			end	
		else
			g_CangBao_PlayerList[index]:Hide();
		end
	end
	--¹Ø± ¶ş´ÎÈ·ÈÏ½çÃæ
	PushEvent("CONFIRM_CANGBAOTU",-1,-1,-1,-1)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",-1,-1,-1,-1)
end
--=========================================================
--¹Ø± ½çÃæ
--=========================================================
function CangBao_Info_Close()
	PushEvent("CONFIRM_CANGBAOTU",-1,-1,-1,-1)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",-1,-1,-1,-1)
	this:Hide()
end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC
--=========================================================
function CangBao_Info_BeginCareObject(objCaredId)
	if g_Object ~= -1 then
		this:CareObject(objCaredId, 0, "CangBao_Info");
	end
	g_Object = objCaredId
	this:CareObject(g_Object, 1, "CangBao_Info")
end


--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function CangBao_Info_StopCareObject()
	if g_Object ~= -1 then
		this:CareObject(g_Object, 0, "CangBao_Info");
		g_Object = -1;
	end
end

--=========================================================
--°ïÖú
--=========================================================
function CangBao_Info_Help()
	PushEvent("QUEST_HELPINFO", "Khuyªt tñ ği¬n")--"#{XSX_220705_170}")
end

--=========================================================
--Ä¬ÈÏÁìÈ¡½±Àø
--=========================================================
function CangBao_Info_GetMyAward()
	local myName = Player:GetName()	
	local myItem = -1
	for index=1,table.getn(g_CangBao_PlayerList)  do
		--Ãû×Ö
		local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
		if myName ==  nCurName then
			--ÏÔÊ¾ÎÒµÄ
			myItem = g_CangBao_PlayerIdx[index].nItemID
		end
	end
	--È«½»¸ø·şÎñÆ÷ÅĞ¶Ï
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetMyAward")
		Set_XSCRIPT_ScriptID(893403)
		Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		Set_XSCRIPT_Parameter( 1,myItem)
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end


--=========================================================
--½»»»°´Å¥
--=========================================================
function CangBao_Info_ExchangeClick(index)
	if index < 1 or index > 6 then
		PushDebugMessage("S¯ li®u sai l¥m ExchangeClick(index)"..index)
		return
	end
	--ÊÇ¸ö¶ş´ÎÈ·ÈÏ°´Å¥
	local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
	local nCurItem = g_CangBao_PlayerIdx[index].nItemID
	--PushDebugMessage("´«Èë±äÁ¿ "..g_CangBao_targetId.." "..nCurName.." "..nCurItem.." "..index)
	PushEvent("CONFIRM_CANGBAOTU",g_CangBao_targetId,nCurName,nCurItem,index)

	-- --²âÊÔ¸ø·şÎñÆ÷ÅĞ¶Ï
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name("ChangeAward")
		-- Set_XSCRIPT_ScriptID(893403)
		-- Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		-- Set_XSCRIPT_Parameter( 1,index)
		-- Set_XSCRIPT_ParamCount( 2 )
	-- Send_XSCRIPT()
end

--=========================================================
--½ÓÊÜ°´Å¥
--=========================================================
function CangBao_Info_AcceptClick(index)
	if index < 1 or index > 6 then
		PushDebugMessage("S¯ li®u sai l¥m AcceptClick(index)"..index)
		return
	end

	--ÊÇ¸ö¶ş´ÎÈ·ÈÏ°´Å¥
	local nCurName = g_CangBao_PlayerIdx[index].nPlayerName
	local nCurItem = g_CangBao_PlayerIdx[index].nItemID
	--PushDebugMessage("´«Èë±äÁ¿ "..g_CangBao_targetId.." "..nCurName.." "..nCurItem.." "..index)
	PushEvent("CONFIRM_CANGBAOTU_ACCEPT",g_CangBao_targetId,nCurName,nCurItem,index)

	
	-- --²âÊÔ¸ø·şÎñÆ÷ÅĞ¶Ï
	-- Clear_XSCRIPT()
		-- Set_XSCRIPT_Function_Name("AcceptAward")
		-- Set_XSCRIPT_ScriptID(893403)
		-- Set_XSCRIPT_Parameter( 0,g_CangBao_targetId)
		-- Set_XSCRIPT_Parameter( 1,index)
		-- Set_XSCRIPT_ParamCount( 2 )
	-- Send_XSCRIPT()
end
