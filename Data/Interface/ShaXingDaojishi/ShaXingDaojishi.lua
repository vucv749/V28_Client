--******************************************
--ÐÂÉ±ÐÇ¸±±¾	Íæ¼Ò»ý·Ö½çÃæ
--create by  limengyue 
--2022-07-29
--******************************************

local g_ShaXingDaojishi_Frame_UnifiedXPosition;
local g_ShaXingDaojishi_Frame_UnifiedYPosition;

--»ý·ÖMDÖµ
local g_ShaXingDaojishi_MD = 769
local g_ShaXingDaojishi_SelectBossIdx = -1	--??boss??
--±¸×¢¿´µÄ  ²¢ÎÞÒýÓÃ
local g_ShaXingDaojishi_BossIdxList = 
{
	[1] = {nName="T¯ng Khß½ng"},
	[2] = {nName="Lß Quân D§t"},
	[3] = {nName="Lý Khôi"},
	[4] = {nName="L² Chí Sinh"},
	[5] = {nName="Quan Th¸nh"},
	[6] = {nName="Ngô Vînh"},
	[7] = {nName="Công Tôn Thánh"},
}
local g_ShaXingDaojishi_RandomList = 
{
	[0] = {nwarning="Liên tøc b¦y r§p",nName="#{XSX_220705_262}"},
	[1] = {nwarning="Gia Huyªt Khuyên",nName="#{XSX_220705_263}"},
	[2] = {nwarning="Giäm Tr¸ Li®u",nName="#{XSX_220705_264}"},
	[3] = {nwarning="H¤p Lam",nName="#{XSX_220705_265}"},
	[4] = {nwarning="Mê muµi",nName="#{XSX_220705_266}"},
	[5] = {nwarning="Khüng Cø Hß Nhßþc",nName="#{XSX_240326_13}"},
	[6] = {nwarning="Tâm linh kh¯ng chª",nName="#{XSX_240326_15}"},
	[7] = {nwarning="G÷i v« Ti¬u Quái",nName="#{XSX_240326_17}"},
	[8] = {nwarning="Liên Tuyªn",nName="#{XSX_240326_19}"},
	[9] = {nwarning="Bom",nName="#{XSX_240326_21}"},
}


--=========================================================
--PreLoad
--=========================================================
function ShaXingDaojishi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("XINSHAXING_MINI");
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
function ShaXingDaojishi_OnLoad()
	g_ShaXingDaojishi_Frame_UnifiedXPosition	= ShaXingDaojishi : GetProperty("UnifiedXPosition");
	g_ShaXingDaojishi_Frame_UnifiedYPosition	= ShaXingDaojishi : GetProperty("UnifiedYPosition");
end

--=========================================================
--»Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--=========================================================
function ShaXingDaojishi_On_ResetPos()

	
	ShaXingDaojishi : SetProperty("UnifiedXPosition", g_ShaXingDaojishi_Frame_UnifiedXPosition);
	ShaXingDaojishi : SetProperty("UnifiedYPosition", g_ShaXingDaojishi_Frame_UnifiedYPosition);

end

--=========================================================
--OnEvent
--=========================================================
function ShaXingDaojishi_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 89331103 ) then
		--´ò¿ª½çÃæ
		if(IsWindowShow("ShaXingDaojishi")) then
			CloseWindow("ShaXingDaojishi", true)
		end
		if Get_XParam_INT(0) >= 0 then --???boss
			ShaXingDaojishi_Open(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2),Get_XParam_INT(3),Get_XParam_INT(4),Get_XParam_INT(5))
		end
	end
	-- ´°¿Ú±ä»¯
	if (event == "XINSHAXING_MINI" ) then
		if arg0=="1" then
			ShaXingDaojishi_Mini_Show(tonumber(arg1))
		end
	end
	if (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		ShaXingDaojishi_On_ResetPos();
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then	
		ShaXingDaojishi_On_ResetPos();
    elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
       ShaXingDaojishi_Close()
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
    end	
end

--=========================================================
--´ò¿ª½çÃæ
--=========================================================
function ShaXingDaojishi_Open(nSelectBossIdx,nBossIdx,nPoint,nRandomList,bRandomChoice, nMode)
	g_ShaXingDaojishi_SelectBossIdx = nSelectBossIdx
	--¹Ø¿¨ÐÅÏ¢
	local nGuanqia = "Mµt"
	if nSelectBossIdx == 2 then
		nGuanqia = "Nh¸"
	elseif nSelectBossIdx == 3 then
		nGuanqia = "Tam"
	elseif nSelectBossIdx == 4 then
		nGuanqia = "TÑ"
	end
	ShaXingDaojishi_DragTitle:SetText(ScriptGlobal_Format("#{XSX_220705_111}",nGuanqia));
	
	--µ±Ç°ÀÛ¼Æ»ý·Ö
	local nMDPoint = DataPool:GetPlayerMission_DataRound(g_ShaXingDaojishi_MD)
	ShaXingDaojishi_Score:SetText(ScriptGlobal_Format("#{XSX_220705_119}",tostring(nMDPoint)));
	--Ä¿±ê
	ShaXingDaojishi_Text:SetText(ScriptGlobal_Format("#{XSX_220705_112}",g_ShaXingDaojishi_BossIdxList[nBossIdx].nName));
	--Í¨¹Ø½±Àø
	ShaXingDaojishi_Text2:SetText(ScriptGlobal_Format("#{XSX_220705_117}",tostring(nPoint)));
	--³¡µØÐÅÏ¢
	local g_ShaXing_RandomIdxList={1,2,3,4,6,8}--6???????(?????)
	g_ShaXing_RandomIdxList[1] = math.mod(nRandomList,10)
	g_ShaXing_RandomIdxList[2] = math.floor(math.mod(nRandomList,100)/10)  
	g_ShaXing_RandomIdxList[3] = math.floor(math.mod(nRandomList,1000)/100)  
	g_ShaXing_RandomIdxList[4] = math.floor(math.mod(nRandomList,10000)/1000) 
	g_ShaXing_RandomIdxList[5] = math.floor(math.mod(nRandomList,100000)/10000) 
	g_ShaXing_RandomIdxList[6] = math.floor(math.mod(nRandomList,1000000)/100000) 
	
	local bRandom1 = math.mod(bRandomChoice,10)
	local bRandom2 = math.floor(math.mod(bRandomChoice,100)/10)  
	local bRandom3 = math.floor(math.mod(bRandomChoice,1000)/100)  
	local bRandom4 = math.floor(math.mod(bRandomChoice,10000)/1000) 
	local bRandom5 = math.floor(math.mod(bRandomChoice,100000)/10000) 
	local bRandom6 = math.floor(math.mod(bRandomChoice,1000000)/100000) 
		
	local nRandomMSg = ""
	if bRandom1 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[1]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom1).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[1]].nName.." "
		end
	end
	if bRandom2 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[2]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom2).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[2]].nName.." "
		end
	end
	if bRandom3 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[3]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom3).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[3]].nName.." "
		end
	end
	if bRandom4 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[4]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom4).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[4]].nName.." "
		end
	end	
	if bRandom5 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[5]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom5).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[5]].nName.." "
		end
	end	
	if bRandom6 > 0 then
		if nMode == 4 then
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[6]].nName..ScriptGlobal_Format("#{XSX_240326_110}",bRandom6).." "
		else
			nRandomMSg=nRandomMSg..g_ShaXingDaojishi_RandomList[g_ShaXing_RandomIdxList[6]].nName.." "
		end
	end	
	--PushDebugMessage("test name="..nRandomMSg);
	--Ãû×ÖÎª¿ Ê±ºòÏÔÊ¾ÔÝÎÞ
	if nRandomMSg == "" then
		nRandomMSg = "#{XSX_220705_281}"
	end
	
	ShaXingDaojishi_Text4:SetText(nRandomMSg);
	this:Show()
end
--=========================================================
--¹Ø± ½çÃæ
--=========================================================
function ShaXingDaojishi_Close()

end
--=========================================================
--ÇÐ»»µ½mini
--=========================================================
function ShaXingDaojishi_OpenMini()

	this:Hide()
	PushEvent("XINSHAXING_MINI",0,g_ShaXingDaojishi_SelectBossIdx)
end
