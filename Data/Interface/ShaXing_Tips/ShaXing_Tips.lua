--******************************************
--ÐÂÉ±ÐÇ¸±±¾	Íæ¼Ò»ý·Ö½çÃæ
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXing_Tips_Frame_UnifiedXPosition;
local g_ShaXing_Tips_Frame_UnifiedYPosition;


--·þÎñÆ÷²»´«×Öµä Ö±½Ó´«±àºÅÌáÊ¾
local g_ShaXing_Tips_BossIdxList = 
{
	[1] = {tips="#{XSX_220705_357}"},--??????????“????”??????,???????????
	[2] = {tips="#{XSX_220705_358}"},--????????????????,?????????? 
	[3] = {tips="#{XSX_220705_359}"},--?????,????????????????,??????????? 
	[4] = {tips="#{XSX_220705_364}"},--#W????,???#R????#W?????,??????#G????#W?
}


--=========================================================
--PreLoad
--=========================================================
function ShaXing_Tips_PreLoad()
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
function ShaXing_Tips_OnLoad()
	g_ShaXing_Tips_Frame_UnifiedXPosition	= ShaXing_Tips : GetProperty("UnifiedXPosition");
	g_ShaXing_Tips_Frame_UnifiedYPosition	= ShaXing_Tips : GetProperty("UnifiedYPosition");
end

--=========================================================
--»Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--=========================================================
function ShaXing_Tips_On_ResetPos()

	
	ShaXing_Tips : SetProperty("UnifiedXPosition", g_ShaXing_Tips_Frame_UnifiedXPosition);
	ShaXing_Tips : SetProperty("UnifiedYPosition", g_ShaXing_Tips_Frame_UnifiedYPosition);

end

--=========================================================
--OnEvent
--=========================================================
function ShaXing_Tips_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89331105 ) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("ShaXing_Tips")) then
			CloseWindow("ShaXing_Tips", true)
		end
		ShaXing_Tips_Open(Get_XParam_INT(0))
	end
	-- ´°¿Ú±ä»¯
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXing_Tips_On_ResetPos();
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		ShaXing_Tips_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       ShaXing_Tips_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--´ò¿ª½çÃæ
--=========================================================
function ShaXing_Tips_Open(nTipsIdx)
	if nTipsIdx < 0 then
		--¹Ø± ½çÃæ
		ShaXing_Tips_Close()
	else
		if g_ShaXing_Tips_BossIdxList[nTipsIdx] then
			ShaXing_Tips_Text:SetText(g_ShaXing_Tips_BossIdxList[nTipsIdx].tips)
			this:Show()
		end
	end

end
--=========================================================
--¹Ø± ½çÃæ
--=========================================================
function ShaXing_Tips_Close()
	this:Hide()
end
