--ShenbingGuideLetter½çÃæ
local g_ShenbingGuideLetter_Frame_UnifiedXPosition;
local g_ShenbingGuideLetter_Frame_UnifiedYPosition;
local ShenbingGuideLetter_g_zidonxunlu1 = 89027202 --????? ????
local ShenbingGuideLetter_g_npc1 ={
	posX = 228,
	posZ = 103,
	sceneid = 2,
	Name = "Âu Dã An",
}
local ShenbingGuideLetter_g_npc2 ={
	posX = 245,
	posZ = 59,
	sceneid = 2,
	Name = "Tiêu Phong",
}
local ShenbingGuideLetter_g_npc3 ={
	posX = 245,
	posZ = 56,
	sceneid = 2,
	Name = "Täo Ğ¸a Th¥n Tång",
}
local ShenbingGuideLetter_g_OnpenUI = 89027302 --?????????
local ShenbingGuideLetter_g_MF1 = 955 --?????
local ShenbingGuideLetter_g_MF2 = 956 --?????
local ShenbingGuideLetter_g_ShenbingJuqingMissionId = 2220 --??????
local ShenbingGuideLetter_g_curYe = 1 --1??????? 2???????
local ShenbingGuideLetter_g_isRedPoint1 = 0 --???????????????
local ShenbingGuideLetter_g_isRedPoint2 = 0 --????????????
local ShenbingGuideLetter_g_isFinish7Mission = 0 --??????????
local ShenbingGuideLetter_g_isFinishYD1 = 0 --?????????
local ShenbingGuideLetter_g_isFinishJQ1 = 0 --?????????
local ShenbingGuideLetter_g_isLonMen = 0


--local ShenbingGuideLetter_g_ShowHelp = 89027402 --Éñ±ø¹Å¾í ´ò¿ª°ïÖú¶Ô»°¿ò

--===============================================
-- PreLoad()
--===============================================
function ShenbingGuideLetter_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--===============================================
-- OnLoad()
--===============================================
function ShenbingGuideLetter_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_ShenbingGuideLetter_Frame_UnifiedXPosition	= ShenbingGuideLetter_Frame:GetProperty("UnifiedXPosition");
    g_ShenbingGuideLetter_Frame_UnifiedYPosition	= ShenbingGuideLetter_Frame:GetProperty("UnifiedYPosition");
end

--===============================================
-- OnEvent()
--===============================================
function ShenbingGuideLetter_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == ShenbingGuideLetter_g_OnpenUI) then
		local isLonmen = Get_XParam_INT(0)
		ShenbingGuideLetter_g_isLonMen = isLonmen
		if isLonmen == 1 then--??? ???????????????1
			ShenbingGuideLetter_Btn2:Disable()
		else
			ShenbingGuideLetter_Btn2:Enable()
		end
		ShenbingGuideLetter_g_isFinish7Mission = Get_XParam_INT(1)
		ShenbingGuideLetter_g_isFinishYD1 = Get_XParam_INT(2)
		ShenbingGuideLetter_g_isFinishJQ1 = Get_XParam_INT(3)
		this:Show();
		ShenbingGuideLetter_g_isRedPoint1 = 0--?????18?????,???????
		ShenbingGuideLetter_g_isRedPoint2 = 0
		ShenbingGuideLetter_Update()
		ShenbingGuideLetter_RedPoint()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == ShenbingGuideLetter_g_zidonxunlu1) then
		local xunluOrRedPoint = Get_XParam_INT(0)
		if xunluOrRedPoint == 1 then
			ShenbingGuideLetter_AutoRun()
		elseif xunluOrRedPoint == 0 then
			ShenbingGuideLetter_g_isRedPoint1 = 1 --????????????
			ShenbingGuideLetter_RedPoint()
		elseif xunluOrRedPoint == 2 then
			ShenbingGuideLetter_g_isRedPoint1 = 0 --????????????
			ShenbingGuideLetter_RedPoint()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99839601) then--???????
		local param = Get_XParam_INT(0)
		local nOpen = Get_XParam_INT(1)
		local nRedPoint = Get_XParam_INT(2)		
		if param == 0 then
			--¹Ø± ½çÃæ
			ShenbingGuideLetter_OnHiden()
		else
			if nRedPoint == 1 then
				ShenbingGuideLetter_g_isRedPoint2 = 0
				ShenbingGuideLetter_RedPoint()	
			else
				ShenbingGuideLetter_g_isRedPoint2 = 0
				ShenbingGuideLetter_RedPoint()	
			end
			if param == 1 then--????
				this:Show()
				ShenbingGuideLetter_Update()
			elseif param == 2 then--????:?npc
				ShenbingGuideLetter_MengQianChenGoToFindNpc()
			elseif param == 3 then
			end
		end
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		ShenbingGuideLetter_UpdateUIPos()
	elseif ( event == "ADJEST_UI_POS" ) then
		ShenbingGuideLetter_UpdateUIPos()
	end
end
--¹Ø± ½çÃæ
function ShenbingGuideLetter_OnHiden()
	ShenbingGuideLetter_g_curYe = 1
	ShenbingGuideLetter_g_isRedPoint1=0
	ShenbingGuideLetter_g_isRedPoint2=0
	ShenbingGuideLetter_g_isFinish7Mission =0
	ShenbingGuideLetter_g_isFinishYD1 = 0
	ShenbingGuideLetter_g_isFinishJQ1 = 0
	ShenbingGuideLetter_g_isLonMen = 0
	ShenbingGuideLetter_background1:SetProperty("Image","ShenbingGuide image:Letter_zts");
	this:Hide()
end
--·ÖÒ³°´Å¥
function ShenbingGuideLetter_OnFenYeClicked(index)
	ShenbingGuideLetter_g_curYe = index
	ShenbingGuideLetter_Update()
end
--Ë¢ĞÂ½çÃæ
function ShenbingGuideLetter_Update()
	--·ÖÒ³°´Å¥×´Ì¬³õÊ¼»¯
	ShenbingGuideLetter_Btn1:Show();
	ShenbingGuideLetter_Btn2:Show();
	ShenbingGuideLetter_Btn1:SetCheck(0);
	ShenbingGuideLetter_Btn2:SetCheck(0);
	--¸ù¾İÈÎÎñÍê³ÉÇé¿ö¿ØÖÆÖ®ºóµÄ½çÃæÏÔÊ¾
	if ShenbingGuideLetter_g_isFinishYD1 == 1 then
		ShenbingGuideLetter_Btn1:Hide()
		ShenbingGuideLetter_g_curYe = 2
	elseif ShenbingGuideLetter_g_isFinishJQ1 == 1 then
		ShenbingGuideLetter_Btn2:Hide()
		ShenbingGuideLetter_g_curYe = 1
	end
	if ShenbingGuideLetter_g_curYe == 1 then
		ShenbingGuideLetter_Btn1:SetCheck(1);
	elseif ShenbingGuideLetter_g_curYe == 2 then
		ShenbingGuideLetter_Btn2:SetCheck(1);
	end
	--½çÃæÏÔÊ¾
	if ShenbingGuideLetter_g_curYe == 1 then
		--ÏÔÊ¾Éñ±ø¸±ÎäÆ÷Òıµ¼ÈÎÎñ½çÃæ
		ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_zts");
		if ShenbingGuideLetter_g_isFinish7Mission == 0 then
			ShenbingGuideLetter_QianWang:Show()
		else
			ShenbingGuideLetter_QianWang:Hide()
		end
		--Òş²ØÉñ±ø¾çÇéÈÎÎñÒıµ¼½çÃæ
		ShenbingGuideLetter_QianWang2:Hide()
	elseif ShenbingGuideLetter_g_curYe == 2  then
		--Òş²ØÉñ±ø¸±ÎäÆ÷Òıµ¼ÈÎÎñ½çÃæ
		ShenbingGuideLetter_QianWang:Hide()
		--ÏÔÊ¾Éñ±ø¾çÇéÈÎÎñÒıµ¼½çÃæ
		ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_sds");
		ShenbingGuideLetter_QianWang2:Show()
		if ShenbingGuideLetter_g_isLonMen == 1 then--????,??????????
			ShenbingGuideLetter_Btn2:SetCheck(0)
			ShenbingGuideLetter_Btn2:Disable()
			ShenbingGuideLetter_QianWang2:Hide()
			ShenbingGuideLetter_QianWang:Hide()
			ShenbingGuideLetter_background1:SetProperty("Image","set:ShenbingGuide image:Letter_zts");
		end
	end
end
--Ë¢ĞÂºìµã
function ShenbingGuideLetter_RedPoint()
	--ºìµã
	if ShenbingGuideLetter_g_isRedPoint2 == 1 or ShenbingGuideLetter_g_isRedPoint1 == 1 then--???????????????
		Lua_ShowQuickEnterPointTip(18, 1)
	else
		Lua_ShowQuickEnterPointTip(18, 0)
	end
end
--×Ô¶¯Ñ°Â· Ç°Íù°´Å¥
function ShenbingGuideLetter_Clicked()
	if ShenbingGuideLetter_g_isFinishYD1 ~= 1 then
		AutoRuntoTargetExWithName(ShenbingGuideLetter_g_npc1.posX, ShenbingGuideLetter_g_npc1.posZ, ShenbingGuideLetter_g_npc1.sceneid, ShenbingGuideLetter_g_npc1.Name)
		PushDebugMessage("#{SQYD_230802_107}")
	end
	ShenbingGuideLetter_OnHiden()
end
--ÊÊÓ¦ÆÁÄ»±ä»¯
function ShenbingGuideLetter_UpdateUIPos()
	ShenbingGuideLetter_Frame:SetProperty("UnifiedXPosition", g_ShenbingGuideLetter_Frame_UnifiedXPosition);
	ShenbingGuideLetter_Frame:SetProperty("UnifiedYPosition", g_ShenbingGuideLetter_Frame_UnifiedYPosition);
end
-----ºÏ²¢½çÃæĞÂÔö------
--Éñ±ø¾çÇéÈÎÎñÒıµ¼µã»÷Ç°Íù°´Å¥
function ShenbingGuideLetter_MengQianChenClicked()
	if ShenbingGuideLetter_g_isLonMen == 1 then
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GotoFindNpc");
		Set_XSCRIPT_ScriptID(998388);
		--Set_XSCRIPT_Parameter(0, 2);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
end
--Éñ±ø¾çÇéÈÎÎñÒıµ¼ÏìÓ¦£ºÍ¨¹ıserverÅĞ¶Ï£¬¿ÉÒÔÑ°Â· Ònpc
function ShenbingGuideLetter_MengQianChenGoToFindNpc()
	AutoRuntoTargetExWithName(277, 151, 3, "Tiêu Phong")
	ShenbingGuideLetter_OnHiden()
end
