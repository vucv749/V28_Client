--******************************************
--±ùÑ©ÊÀ½çÔªµ©´ò¿¨-ÅÝÎÂÈª
--ÈÎÎñ½ø¶È½çÃæ
--create by  limengyue 
--2024-10-09
--******************************************

local g_Frozen_HotSpring_Frame_UnifiedPosition;

--ÌåÎÂ¶ÔÓ¦·ÖÊý
local g_MaxTime = 30*60
local g_MaxHappy = 1000
local g_HappySuper = 60
local g_HappySuperTemp = 74
local g_Frozen_HotSpring_Temp =
{
	[1] = {nInfo="Thái lÕnh",nMin=0,nMax=20,nPoint=1,nTips="#{BXPWQ_240927_106}",nImg="set:Frozen_HotSpring image:Frozen_HotSpring_GGL",nShowImg="set:Frozen_HotSpring image:Frozen_HotSpring_GGL1",}, --[nMin,nMax)
	[2] = {nInfo="Bình thß¶ng",nMin=20,nMax=70,nPoint=10,nTips="#{BXPWQ_240927_107}",nImg="set:Frozen_HotSpring image:Frozen_HotSpring_ST",nShowImg="set:Frozen_HotSpring image:Frozen_HotSpring_ST10",},
	[3] = {nInfo="H°ng Ôn",nMin=70,nMax=80,nPoint=30,nTips="#{BXPWQ_240927_109}",nImg="set:Frozen_HotSpring image:Frozen_HotSpring_ZTK",nShowImg="set:Frozen_HotSpring image:Frozen_HotSpring_ZTK60",},
	[4] = {nInfo="Quá nóng Li­u",nMin=80,nMax=100,nPoint=1,nTips="#{BXPWQ_240927_110}",nImg="set:Frozen_HotSpring image:Frozen_HotSpring_ZLR",nShowImg="set:Frozen_HotSpring image:Frozen_HotSpring_ZLR1",},
}

--½±Àø
local g_Frozen_HotSpring_Award =
{
	[1] = {nInfo="Nh¤t ðÆng Tß·ng",nTime=3*60,nImgok="set:Frozen_HotSpring image:RY_Hover",nImgNo="set:Frozen_HotSpring image:RY_Disabled",},
	[2] = {nInfo="Giäi nhì",nTime=5*60,nImgok="set:Frozen_HotSpring image:QY_Hover",nImgNo="set:Frozen_HotSpring image:QY_Disabled",},
	[3] = {nInfo="Tam ÐÆng Tß·ng",nTime=100*60,nImgok="set:Frozen_HotSpring image:SY_Hover",nImgNo="set:Frozen_HotSpring image:SY",},
}

--¿Ø¼þ
local g_Frozen_HotSpring_AwardList = {}	--??
local g_Frozen_HotSpring_ShowImgList = {}	--????

--===============================================
-- PreLoad()
--===============================================
function Frozen_HotSpring_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("BXSJ_PAOWENQUAN_MINI")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	
	--ÇÐ³¡¾°ÊÂ¼þ
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad()
--===============================================
function Frozen_HotSpring_OnLoad()   
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frozen_HotSpring_Frame_UnifiedPosition = Frozen_HotSpring_Frame:GetProperty("UnifiedPosition");
	--¿Ø¼þ
	g_Frozen_HotSpring_AwardList[1] = Frozen_HotSpring_TimeReward1
	g_Frozen_HotSpring_AwardList[2] = Frozen_HotSpring_TimeReward2
	g_Frozen_HotSpring_AwardList[3] = Frozen_HotSpring_TimeReward3
	--ÎÂ¶ÈÏÔÊ¾
	g_Frozen_HotSpring_ShowImgList[1] = Frozen_HotSpring_Icon1
	g_Frozen_HotSpring_ShowImgList[2] = Frozen_HotSpring_Icon3
	g_Frozen_HotSpring_ShowImgList[3] = Frozen_HotSpring_Icon5
	g_Frozen_HotSpring_ShowImgList[4] = Frozen_HotSpring_Icon6
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function Frozen_HotSpring_Frame_On_ResetPos()
	Frozen_HotSpring_Frame:SetProperty("UnifiedPosition", g_Frozen_HotSpring_Frame_UnifiedPosition);
end

--===============================================
-- OnEvent()
--===============================================
function Frozen_HotSpring_OnEvent(event)

    if(event == "UI_COMMAND" and tonumber(arg0) == 99957401) then
		
		local bUpdate = Get_XParam_INT(0)
		--PushDebugMessage(" Frozen_HotSpring_Open bUpdate="..bUpdate)
		if bUpdate == 1 then
			--¸üÐÂÊý¾Ý
			if(IsWindowShow("Frozen_HotSpring_Mini")) then
				--
			else
				--Ã»ÓÐmini½çÃæ¾ÍÓ¦¸ÃÒ»Ö±¸üÐÂ
				Frozen_HotSpring_Open(Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4))
			end
		else
			--´ò¿ª½çÃæ
			if(IsWindowShow("Frozen_HotSpring_Mini")) then
				CloseWindow("Frozen_HotSpring_Mini", true)
			end
			if(IsWindowShow("Frozen_HotSpring")) then
				CloseWindow("Frozen_HotSpring", true)
			end
			Frozen_HotSpring_Open(Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4))
		end
	elseif(event == "UI_COMMAND" and tonumber(arg0) == 99957402) then
		--¹Ø± ½çÃæ
		if(IsWindowShow("Frozen_HotSpring")) then
			 Frozen_HotSpring_OnHiden()
		end
	end
    -- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		Frozen_HotSpring_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Frozen_HotSpring_Frame_On_ResetPos()
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       Frozen_HotSpring_OnHiden()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			Frozen_HotSpring_OnHiden()
		end
    end
         
end

--===============================================
-- Frozen_HotSpring_OnHiden()
--===============================================
function Frozen_HotSpring_OnHiden()
	this:Hide()
end


--=========================================================
--Ä¬ÈÏ´ò¿ª½çÃæ
--=========================================================
function Frozen_HotSpring_Open(mOkTick,mBodyTemp,mHappyNum,mTotalTick)
	--PushDebugMessage(" Frozen_HotSpring_Open mOkTick="..mOkTick.." mBodyTemp="..mBodyTemp.." mHappyNum="..mHappyNum.." mTotalTick="..mTotalTick)
	--µ¹¼ÆÊ±
	--Frozen_HotSpring_Text7:SetText(ScriptGlobal_Format("#{BXPWQ_240927_50}",tonumber(mOkTick)));
	--×´Ì¬Í¼Æ¬
	local  mIdx = 1
	local  nLength = table.getn(g_Frozen_HotSpring_Temp)
	for index=1,table.getn(g_Frozen_HotSpring_Temp)  do
		if mBodyTemp >= g_Frozen_HotSpring_Temp[nLength].nMax then
			mIdx = nLength
			break
		end
		if mBodyTemp >= g_Frozen_HotSpring_Temp[index].nMin and mBodyTemp < g_Frozen_HotSpring_Temp[index].nMax then
			mIdx = index
			break
		end
	end
	Frozen_HotSpring_image:SetProperty( "Image", g_Frozen_HotSpring_Temp[mIdx].nImg )
	Frozen_HotSpring_Text8:SetText(g_Frozen_HotSpring_Temp[mIdx].nTips);
	--ÏÔÊ¾½ø¶ÈÌõ
	Frozen_HotSpring_EXP:SetProgress( mBodyTemp , g_Frozen_HotSpring_Temp[nLength].nMax );
	--½ø¶ÈÌõbgÑ É«
	if mIdx == 1 then
		--Ì«ÀäÁË À¶É«
		Frozen_HotSpring_Blue:Show()
		Frozen_HotSpring_Red:Hide()
	elseif mIdx == nLength then
		--Ì«ÈÈÁË ºìÉ«
		Frozen_HotSpring_Blue:Hide()
		Frozen_HotSpring_Red:Show()
	else
		-- ý³£
		Frozen_HotSpring_Blue:Hide()
		Frozen_HotSpring_Red:Hide()
	end
	
	-- --ÏÔÊ¾¼Ó·ÖÍ¼Æ¬
	-- for index=1,table.getn(g_Frozen_HotSpring_Temp)  do
		-- g_Frozen_HotSpring_ShowImgList[index]:SetProperty( "Image", g_Frozen_HotSpring_Temp[index].nShowImg )
	-- end
	--µ±Ç°ÂúÒâ¶È
	Frozen_HotSpring_Text:SetText(ScriptGlobal_Format("#{BXPWQ_240927_58}",mHappyNum));
	
	--ÀÛ¼ÆÊ±¼ä
	local  skyTimeString = ""
	local skyMinute = math.floor(mTotalTick / 60)
	local skySecond = math.mod(mTotalTick, 60)
	if skyMinute < 10 then
		skyTimeString = skyTimeString .. "0"
	end
	skyTimeString = skyTimeString .. tostring(skyMinute) .. ":"
	if skySecond < 10 then
		skyTimeString = skyTimeString .. "0"
	end
	skyTimeString = skyTimeString .. tostring(skySecond)
	Frozen_HotSpring_TimeText:SetText(ScriptGlobal_Format("#{BXPWQ_240927_118}",skyTimeString));
	--Ä¬ÈÏ½±Àø¶¼²»ÏÔÊ¾
	for index=1,table.getn(g_Frozen_HotSpring_AwardList)  do
		g_Frozen_HotSpring_AwardList[index]:SetProperty( "Image", g_Frozen_HotSpring_Award[index].nImgNo )
	end

	if mHappyNum >= g_MaxHappy then
		if mTotalTick <= g_Frozen_HotSpring_Award[1].nTime then
			-- ¹Ê¾½±Àø
			g_Frozen_HotSpring_AwardList[1]:SetProperty( "Image", g_Frozen_HotSpring_Award[1].nImgok )
		elseif mTotalTick <= g_Frozen_HotSpring_Award[2].nTime then
			-- ¹Ê¾½±Àø
			g_Frozen_HotSpring_AwardList[2]:SetProperty( "Image", g_Frozen_HotSpring_Award[2].nImgok )
		else
			-- ¹Ê¾½±Àø
			g_Frozen_HotSpring_AwardList[3]:SetProperty( "Image", g_Frozen_HotSpring_Award[3].nImgok )
		end
	end
	this:Show()		
end

--===============================================
--×îÐ¡»¯
--===============================================
function Frozen_HotSpring_Mini()
	PushEvent( "BXSJ_PAOWENQUAN_MINI" )
	--PushEvent("BXSJ_PAOWENQUAN_MINI",index)
end

--=========================================================
--°ïÖú
--=========================================================
function Frozen_HotSpring_Help()
	PushEvent("QUEST_HELPINFO", "Khuyªt tñ ði¬n")
end
