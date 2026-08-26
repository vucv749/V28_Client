--******************************************
--×é¶Ó²Ø±¦Í¼¸±±¾ ½ø±¾µÄtips½çÃæ
--create by  limengyue 
--2024-07-09
--******************************************
local g_CangBao_Daojishi_Frame_UnifiedPosition;

--boss ý¼ÆÊ±
local g_CangBao_BossTimer = 0
--ÐÒÔËµÈ¼¶
local g_CangBao_LuckyPoint = 
{
	[1] = {nMin=0,nMax=199,nLevel=1},
	[2] = {nMin=200,nMax=499,nLevel=2},
	[3] = {nMin=500,nMax=699,nLevel=3},
	[4] = {nMin=700,nMax=2000,nLevel=4},
}

--Ã¿¸ö½×¶ÎÏÔÊ¾Ê²Ã´
local g_CangBao_RoomTips = 
{
	[1] = {Title="#{ZDBT_240703_272}",nTips1="#{ZDBT_240703_78}",nMemo="M¾i b¡t ð¥u phòng",},
	[2] = {Title="#{ZDBT_240703_273}",nTips1="#{ZDBT_240703_82}",nMemo="ÐÕi Boss phòng",},
	[3] = {Title="#{ZDBT_240703_275}",nTips1="#{ZDBT_240703_84}",nMemo="Khai Bäo Tß½ng phòng",},
	[4] = {Title="#{ZDBT_240703_277}",nTips1="#{ZDBT_240703_296}",nMemo="Ki¬m Kim T® phòng",},
	[5] = {Title="#{ZDBT_240703_276}",nTips1="#{ZDBT_240703_294}",nMemo="Ti¬u Quái phòng",},
	[6] = {Title="#{ZDBT_240703_278}",nTips1="#{ZDBT_240703_298}",nMemo="Tiªp Bäo Tß½ng phòng",},
	[7] = {Title="#{ZDBT_240703_279}",nTips1="#{ZDBT_240703_300}",nMemo="Tránh né C¥u phòng",},
	[8] = {Title="#{ZDBT_240703_274}",nTips1="#{ZDBT_240703_83}",nMemo="Ti¬u Boss phòng",},
	[9] = {Title="#{ZDBT_240703_280}",nTips1="#{ZDBT_240703_281}",nMemo="Kªt toán phòng",},
}


--=========================================================
--PreLoad
--=========================================================
function CangBao_Daojishi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	--¾àÀëNPC¾àÀë
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--ÇÐ³¡¾°ÊÂ¼þ
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--=========================================================
--OnLoad
--=========================================================
function CangBao_Daojishi_OnLoad()
	g_CangBao_Daojishi_Frame_UnifiedPosition = CangBao_Daojishi:GetProperty("UnifiedPosition");
end

--=========================================================
--»Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--=========================================================
function CangBao_Daojishi_On_ResetPos()

	CangBao_Daojishi:SetProperty("UnifiedPosition", g_CangBao_Daojishi_Frame_UnifiedPosition);
end

--=========================================================
--OnEvent
--=========================================================
function CangBao_Daojishi_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89340310 ) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("CangBao_Daojishi")) then
			CloseWindow("CangBao_Daojishi", true)
		end
		CangBao_Daojishi_Open(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4))
	end
	-- ´°¿Ú±ä»¯
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		CangBao_Daojishi_On_ResetPos();
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		CangBao_Daojishi_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       CangBao_Daojishi_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--´ò¿ª½çÃæ
--nLuckyPointÐÒÔËÖµ
--nStage ½×¶Î ¶ÔÓ¦g_CangBao_RoomTipsµÄidx
--nState ×´Ì¬ 0 1 2 ¹Ø¿¨Î´¿ªÆô  ÒÑ¿ªÆô  ÒÑ½áÊø 3¹Ø¿¨½áÊøºÄ¾¡
--nRemainTimeÍæ·¨Ê£ÓàÊ±¼ä
--nParam1 ²ÎÊý±äÁ¿
--=========================================================
function CangBao_Daojishi_Open(nLuckyPoint,nStage,nState,nRemainTime,nParam1)
	--PushDebugMessage("test open nLuckyPoint="..nLuckyPoint.." nStage="..nStage.." nState="..nState.." nRemainTime="..nRemainTime.." nParam1="..nParam1 )
	if nStage < 1 or nStage >  table.getn(g_CangBao_RoomTips) then
		PushDebugMessage("S¯ li®u phi pháp")
		return
	end
	--×Ô¼ºËã·ÖÖµ¶Î
	local nLevel = g_CangBao_LuckyPoint[1].nLevel
	local nCurMax = g_CangBao_LuckyPoint[1].nMax - g_CangBao_LuckyPoint[1].nMin
	local nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[1].nMin --???????????????????
	local nMaxLen = table.getn(g_CangBao_LuckyPoint)
	if nLuckyPoint > g_CangBao_LuckyPoint[nMaxLen].nMax then
		nLevel = g_CangBao_LuckyPoint[nMaxLen].nLevel
		nCurMax = g_CangBao_LuckyPoint[nMaxLen].nMax - g_CangBao_LuckyPoint[nMaxLen].nMin+1
		nCurValue =  nCurMax
	else
		for index=1,table.getn(g_CangBao_LuckyPoint)  do
			if index == 1 then
				if nLuckyPoint >= g_CangBao_LuckyPoint[index].nMin and nLuckyPoint <= g_CangBao_LuckyPoint[index].nMax then
					nLevel = g_CangBao_LuckyPoint[index].nLevel
					nCurMax = g_CangBao_LuckyPoint[index].nMax - g_CangBao_LuckyPoint[index].nMin
					nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[index].nMin
				end
			else
				if nLuckyPoint >= g_CangBao_LuckyPoint[index].nMin and nLuckyPoint <= g_CangBao_LuckyPoint[index].nMax then
					nLevel = g_CangBao_LuckyPoint[index].nLevel
					nCurMax = g_CangBao_LuckyPoint[index].nMax - g_CangBao_LuckyPoint[index].nMin+1
					nCurValue =  nLuckyPoint - g_CangBao_LuckyPoint[index-1].nMax 
				end
			end
		end
	end

	--½ø¶ÈÌõÏÔÊ¾
	CangBao_Daojishi_Text2:SetText(nLevel);
	CangBao_Daojishi_Text3:SetText(nCurValue.."/"..nCurMax);
	CangBao_Daojishi_Progress:SetProgress(nCurValue, nCurMax)
	
	--title
	CangBao_Daojishi_Pair_Title1:SetText(g_CangBao_RoomTips[nStage].Title);
	--¹Ì¶¨ÎÄ×Ö
	CangBao_Daojishi_Pair_Text1:SetText(g_CangBao_RoomTips[nStage].nTips1);
	--Ä¬ÈÏ
	CangBao_Daojishi_Pair_Text2:Hide();
	KillTimer("CangBao_Daojishi_Timer()")
	--½×¶Î
	if nState == 0 then
		if nStage == 3 or nStage == 9 then
			CangBao_Daojishi_Pair_Text3:Hide();
		else
			CangBao_Daojishi_Time:Hide();
			CangBao_Daojishi_Pair_Text3:Show();
			CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_81}");
		end
	elseif nState == 1 then
		CangBao_Daojishi_Pair_Text3:Show();
		--Èç¹ûÊÇboss½×¶Î
		if nStage == 1 or nStage == 2 or nStage == 8 then
			-- ý¼ÆÊ±
			CangBao_Daojishi_Time:Hide();
			g_CangBao_BossTimer = nRemainTime
			local  nTimeStringMin = ""
			local  nTimeStringSec = ""
			local mMinute = math.floor(g_CangBao_BossTimer / 60)
			local mSecond = math.mod(g_CangBao_BossTimer, 60)
			if mMinute < 10 then
				nTimeStringMin =  "0"..tostring(mMinute)
			else
				nTimeStringMin = tostring(mMinute)
			end
			if mSecond < 10 then
				nTimeStringSec = "0"..tostring(mSecond)
			else
				nTimeStringSec = tostring(mSecond)
			end
			
			CangBao_Daojishi_Pair_Text3:SetText(ScriptGlobal_Format("#{ZDBT_240703_306}",nTimeStringMin,nTimeStringSec));	
			--¹Ò¼ÆÊ±Æ÷
			SetTimer("CangBao_Daojishi","CangBao_Daojishi_Timer()", 1000);--??
		else
			CangBao_Daojishi_Time:Show();
			CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_92}");
			--Ê£ÓàÊ±¼ä
			if nRemainTime > 0 then
				CangBao_Daojishi_Time:SetProperty("Timer", tostring(nRemainTime))
			else
				CangBao_Daojishi_Time:SetProperty("Timer", "0")
			end
		end
	elseif nState == 2 then
		CangBao_Daojishi_Time:Hide();
		CangBao_Daojishi_Pair_Text3:Show();
		CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_80}");
	else
		CangBao_Daojishi_Time:Hide();
		CangBao_Daojishi_Pair_Text3:Show();
		CangBao_Daojishi_Pair_Text3:SetText("#{ZDBT_240703_90}");
	end
	--Íæ·¨½øÐÐÊ±µÄÏÔÊ¾
	if nState == 1 then
		if nStage == 4 then
			--¼ñ½ð±Ò
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_297}",nParam1));		
		elseif nStage == 5 then
			--É±Ð¡¹Ö
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_295}",nParam1));	
		elseif nStage == 6 then
			--½Ó±¦Ïä
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_299}",nParam1));	
		elseif nStage == 7 then
			--¶ã±ÜÇò
			CangBao_Daojishi_Pair_Text2:Show();
			CangBao_Daojishi_Pair_Text2:SetText(ScriptGlobal_Format("#{ZDBT_240703_301}",nParam1));	
		end
	end
	
	this:Show()
end


--=========================================================
--¼ÆÊ±Æ÷
--=========================================================
function CangBao_Daojishi_Timer()
	KillTimer("CangBao_Daojishi_Timer()")
	if(IsWindowShow("CangBao_Daojishi")) then
		g_CangBao_BossTimer = g_CangBao_BossTimer + 1
		local  nTimeStringMin = ""
		local  nTimeStringSec = ""
		local mMinute = math.floor(g_CangBao_BossTimer / 60)
		local mSecond = math.mod(g_CangBao_BossTimer, 60)
		if mMinute < 10 then
			nTimeStringMin =  "0"..tostring(mMinute)
		else
			nTimeStringMin = tostring(mMinute)
		end
		
		if mSecond < 10 then
			nTimeStringSec = "0"..tostring(mSecond)
		else
			nTimeStringSec = tostring(mSecond)
		end
		
		CangBao_Daojishi_Pair_Text3:SetText(ScriptGlobal_Format("#{ZDBT_240703_306}",nTimeStringMin,nTimeStringSec));	
		--¹Ò¼ÆÊ±Æ÷
		SetTimer("CangBao_Daojishi","CangBao_Daojishi_Timer()", 1000);--??
	end
end

--=========================================================
--¹Ø± ½çÃæ
--=========================================================
function CangBao_Daojishi_Close()
	KillTimer("CangBao_Daojishi_Timer()")
	this:Hide()
end

--=========================================================
--°ïÖú
--=========================================================
function CangBao_Daojishi_Help()
	PushEvent("QUEST_HELPINFO", "#{ZDBT_240703_217}")
end


--=========================================================
--ÏÔÊ¾½±ÀøÔ¤ÀÀ
--=========================================================
function CangBao_Daojishi_ShowItem()
	--PushEvent("OPEN_CANGBAOTU_AWARD")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenCangBaoAward")
		Set_XSCRIPT_ScriptID(893403)
	Send_XSCRIPT()
end
