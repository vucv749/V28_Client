
--µ±Ç°³¡¾°ÀàĞÍ....²»ÓÃµÄ³¡¾°ÀàĞÍËùĞèÏÔÊ¾µÄTabÒ³²»Í¬....
-- -1 ÎŞĞ§
--  0 ³ÇÊĞ   --È«²¿£¬¹¦ÄÜ£¬ÉÌµê£¬ÈÎÎñ
--  1 ÃÅÅÉ   --È«²¿£¬¹¦ÄÜ
--  2 ĞşÎäµº --È«²¿£¬ÈËÎï£¬¼ÒÊŞ£¬ÃÍÊŞ
--  3 ÆäËü   --È«²¿£¬¹ÖÎï£¬ÈËÎï
local g_CurSceneType = -1
local g_AutoSearch_Frame_UnifiedPosition;
--³ÇÊĞ³¡¾°µÄIDÁĞ±í....
local g_CitySceneIDList = { 0, 1, 2, 242, 246, 260 }
--ÃÅÅÉ³¡¾°µÄIDÁĞ±í....
local g_MenpaiSceneIDList = { 9, 10, 11, 12, 13, 14, 15, 16, 17, 592 }
--³èÎï³¡¾°µÄIDÁĞ±í....
local g_PetSceneIDList = { 112, 201 }

--µ±Ç°Ñ¡ÔñµÄTabÒ³....
local g_CurSelectTabIndex = 1;

--²»Í¬³¡¾°ÀàĞÍÏÂ¸÷¸öTab°´Å¥Ëù¶ÔÓ¦µÄ·ÖÀàÀàĞÍ....
--½çÃæÉÏÒ»¹²ÓĞ5¸öTab....
--·ÖÀàÀàĞÍ ÎŞĞ§=-1£¬È«=0£¬¹Ö=1£¬ÈË=2£¬ÊŞ=3£¬ÃÍ=4£¬¹¦=5£¬µê=6£¬ÈÎ=7£¬ÎŞ·ÖÀà±êÇ©=99
local g_TableTabIndex2TabType = {
	{	0,	5,	6,	7,	-1,	},
	{	0,	5,	-1,	-1,	-1,	},
	{	0,	2,	3,	4,	-1,	},
	{	0,	1,	2,	-1,	-1,	},
}

--ÉÏ´Î¸üĞÂ±¾´°¿ÚÊ±Íæ¼ÒËùÔÚ³¡¾°ID....
local g_LastUpdateSceneID = -1;

--¸÷¸öTabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İ....»»³¡¾°µÄÊ±ºò²ÅÖØĞÂ¼ÆËã....
local g_TabListData = {};
g_TabListData[1] = {};
g_TabListData[2] = {};
g_TabListData[3] = {};
g_TabListData[4] = {};
g_TabListData[5] = {};


function AutoSearch_PreLoad()
	this:RegisterEvent("OPEN_AUTOSEARCH");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("TOGLE_AUTOSEARCH")
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end


function AutoSearch_OnLoad()

	--´°¿Ú¼ÓÔØÊ±¶¯Ì¬µÄ²åÈëÁĞ....Ö±½ÓÔÚxmlÀïÅäÖÃÁĞµÄ»°ÎŞ·¨ÒıÓÃ×Öµä....
	AutoSearch_List:AddColumn( "Tên", 0, 0.6 );
	AutoSearch_List:AddColumn( "Bän tóm t¡t", 1, 0.4 );

	--*****************************************
	--CEGUIÓĞÒ»´¦Ğ´µÄ²»ºÏÀíµÄµØ·½(Bug?)....µ¼ÖÂ¶àÁĞÁĞ±íÉèÖÃÊôĞÔÊ±»á³öÏÖÒ»Ğ©´íÎó....
	--¾ßÌåÎª£º
	--ÔÚXMLÖĞ¸ø¶àÁĞÁĞ±íÅäÖÃÁËColumnsSizable=True....¾Í»áÉèÖÃ¸Ã¿Ø¼şµÄColumnsSizable=True....»¹»áÉèÖÃÆäËùÓĞÁĞµÄColumnsSizable=True....
	--ÓĞĞ©¶àÁĞÁĞ±íÈç±¾´°¿ÚµÄĞèÒªÔÚ½Å±¾ÖĞ¶¯Ì¬µÄ²åÈëÁĞ.... âÊ±XMLÖĞÅäÖÃµÄColumnsSizable=TrueÖ»»áÉèÖÃ¸Ã¿Ø¼şµÄColumnsSizable=True....²»»áÉèÖÃÁĞµÄColumnsSizable=True(ÒòÎªµ±Ê±Ò»¸öÁĞ¶¼Ã»ÓĞ)....
	--Òò´ËÔÚ½Å±¾ÖĞ¶¯Ì¬²åÈëÁĞºóÁĞµÄColumnsSizableÒòÎªÃ»±»ÉèÖÃ¹ı¾Í²»ÊÇTrue....
	--Èç¹ûÏëÔÚ¶¯Ì¬²åÈëÁĞºóÔÚ½Å±¾ÀïÔÙÖØĞÂ¸ø¶àÁĞÁĞ±íÉèÖÃColumnsSizable=TrueÒ²²»ĞĞ....
	--ÒòÎªÉèÖÃ¸ÃÊôĞÔµÄÖµÊ±»áÅĞ¶ÏÊÇ·ñÓëµ±Ç°¸ÃÊôĞÔµÄÖµÒ»Ñù....Èç¹ûÒ»Ñù¾ÍÖ±½Ó·µ»Ø....¶ø¸Ã¿Ø¼şµÄColumnsSizableÔÚ³õÊ¼»¯XMLµÄÊ±ºò±»Éè³ÉTrueÁËËùÒÔ»áÖ±½Ó·µ»Ø....Ò²¾Í²»»á¸øËüµÄÁĞÉèÖÃ¸ÃÊôĞÔ....
	--Òò´ËÈç¹ûÏë¶¯Ì¬²åÈëÁĞ¾ÍĞèÒªÔÚ¶¯Ì¬²åÈëºóÔÙÉèÖÃºÍÁĞÓĞ¹ØµÄÊôĞÔ....Í¬Ê±ÔÚXMLÖĞ²»ÄÜ¶ÔºÍÁĞÓĞ¹ØµÄÊôĞÔ½øĞĞÉèÖÃ....
	--*****************************************
	AutoSearch_List:SetProperty( "ColumnsSizable", "False" );
	AutoSearch_List:SetProperty( "ColumnsAdjust", "True" );
	AutoSearch_List:SetProperty( "ColumnsMovable", "False" );
  g_AutoSearch_Frame_UnifiedPosition=AutoSearch_Frame:GetProperty("UnifiedPosition");
end

-- OnEvent
function AutoSearch_OnEvent(event)

	if ( event == "OPEN_AUTOSEARCH" ) then

		if( this:IsVisible() ) then
			this:Hide();
		else
			AutoSearch_Open();
		end

	elseif ( event == "SCENE_TRANSED" ) then

		--ÇĞ»»³¡¾°Ê±¹Ø± ±¾´°¿Ú
		this:Hide();
		local curSceneID = GetSceneID();
		if (curSceneID == 112) then
			AutoSearch_Open();
		end
	elseif(event == "UI_COMMAND" and tonumber(arg0)==831021) then
		if( this:IsVisible() ) then
			return;
		else
			AutoSearch_Open();
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0)==807036 ) then
		AutoSearch_SearchTo(Get_XParam_INT(0),Get_XParam_INT(1),Get_XParam_INT(2))
	elseif ( event == "TOGLE_AUTOSEARCH" ) then
		if ( arg0 == "1" ) then
			AutoSearch_Frame:SetProperty("UnifiedXPosition", "{1.0,-149.0}")
			AutoSearch_Frame:SetProperty("UnifiedYPosition", "{0.0,226.0}")
			AutoSearch_Open()
		else
			this:Hide();
		end
	end

		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		AutoSearch_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AutoSearch_Frame_On_ResetPos()
	end

end


--**********************************
--´ò¿ª×Ô¶¯Ñ°Â·´°¿Ú....
--**********************************
function AutoSearch_Open()
	--Çå¿ ×ø±êÊäÈë¿ò
	InputPosition_x:SetText("");
	InputPosition_y:SetText("");
	--´ò¿ª´°¿ÚÊ±Ä¬ÈÏÊÇTab1....
	if ( true == AutoSearch_UpdateFrame(1) ) then
		--ÉèÖÃTab1°´Å¥ÎªÑ¡ÖĞ×´Ì¬....
		AutoSearch_Tab1:SetCheck(1);
		this:Show();
	else
		--Ôö¼Ó×ø±êÊäÈë·½Ê½Ö®ºó£¬µ±Ç°³¡¾°Ã»ÓĞ¿ÉÑ°Â·Ä¿±ê£¬Ò²Òªµ¯³ö£¬ËùÒÔ×¢ÊÍÏÂÃæ â¾ä
		--Èç¹ûÃ»ÓĞÈÎºÎ¿ÉÑ°Â·µÄÎ»ÖÃ£¬ÔòÏÔÊ¾"µ±Ç°µÄ³¡¾°Ã»ÓĞ¿ÉÑ°Â·µÄÄ¿±ê¡£"
		--PushDebugMessage("µ±Ç°µÄ³¡¾°Ã»ÓĞ¿ÉÑ°Â·µÄÄ¿±ê¡£");
		this:Show();
	end

end

--**********************************
--¸üĞÂ×Ô¶¯Ñ°Â·´°¿Ú....
--Èçµ±Ç°³¡¾°Ã»ÓĞ¿ÉÑ°Â·µÄÎ»ÖÃÔò·µ»Øfalse....
--**********************************
function AutoSearch_UpdateFrame( tabIndex )

	g_CurSelectTabIndex = tabIndex;

	--¸üĞÂÍæ¼Òµ±Ç°ËùÔÚ³¡¾°µÄ³¡¾°ÀàĞÍ....
	UpdateCurrentSceneType();

	--¸ù¾İµ±Ç°µÄ³¡¾°ÀàĞÍ¸üĞÂTab°´Å¥....
	UpdateTabButton();

	--¸üĞÂ×Ô¶¯Ñ°Â·ÁĞ±í....
	return UpdateList( tabIndex );

end

--**********************************
--¸üĞÂÍæ¼Òµ±Ç°ËùÔÚ³¡¾°µÄ³¡¾°ÀàĞÍ....
--**********************************
function UpdateCurrentSceneType()

	local curSceneID = GetSceneID();

	--³ÇÊĞ
	for i, sceneId in g_CitySceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 0;
			return;
		end
	end

	--ÃÅÅÉ
	for i, sceneId in g_MenpaiSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 1;
			return;
		end
	end

	--³èÎï
	for i, sceneId in g_PetSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 2;
			return;
		end
	end

	--ÆäËü³¡¾°
	g_CurSceneType = 3;

end

--**********************************
--¸ù¾İµ±Ç°µÄ³¡¾°ÀàĞÍ¸üĞÂTab°´Å¥....
--**********************************
function UpdateTabButton()

	--³ÇÊĞ
	if g_CurSceneType == 0 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("Toàn");
		AutoSearch_Tab2:SetText("Công");
		AutoSearch_Tab3:SetText("Ğiªm");
		AutoSearch_Tab4:SetText("Nh§m");

	--ÃÅÅÉ
	elseif g_CurSceneType == 1 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Hide();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("Toàn");
		AutoSearch_Tab2:SetText("Công");

	--³èÎï
	elseif g_CurSceneType == 2 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("Toàn");
		AutoSearch_Tab2:SetText("Nhân");
		AutoSearch_Tab3:SetText("Thú");
		AutoSearch_Tab4:SetText("Mãnh");

	--ÆäËü
	elseif g_CurSceneType == 3 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("Toàn");
		AutoSearch_Tab2:SetText("Quái");
		AutoSearch_Tab3:SetText("Nhân");

	end

end

--**********************************
--¸üĞÂ×Ô¶¯Ñ°Â·ÁĞ±í....
--Èç¹ûµ±Ç°³¡¾°Ã»ÓĞ¿ÉÑ°Â·µÄÎ»ÖÃÔò·µ»Øfalse....
--**********************************
function UpdateList( tabIndex )

	--Çå¿ List¿Ø¼şÖĞµÄÄÚÈİ....
	AutoSearch_List:RemoveAllItem();

	--Èç¹û´ÓÉÏ´Î¸üĞÂÊı¾İÖ®ºó³¡¾°¸Ä±äÁË....ÔòÇå¿ ÉÏ´Î¼ÆËãºÃµÄ¸÷TabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İ....
	local curSceneID = GetSceneID();
	if g_LastUpdateSceneID ~= curSceneID then
		g_TabListData[1] = nil;
		g_TabListData[2] = nil;
		g_TabListData[3] = nil;
		g_TabListData[4] = nil;
		g_TabListData[5] = nil;
		g_LastUpdateSceneID = curSceneID;
	end

	--»ñÈ¡ÅäÖÃÎÄ¼şÖĞ....±¾³¡¾°×Ô¶¯Ñ°Â·Êı¾İµÄÆğÊ¼Óë½áÊøÎ»ÖÃ....
	local nStart, nEnd = DataPool:GetAutoSearchSceneStartEnd( GetSceneID() )

	--Èç¹û±¾³¡¾°Ã»ÓĞ¿ÉÑ°Â·µÄÎ»ÖÃÔò·µ»Øfalse....
	if nStart == -1 then
		return false;
	end

	--Èç¹ûÃ»ÓĞ±¾TabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İÔòÖØĞÂ¼ÆËã....
	local g_TabListDataTablePtr = g_TabListData[tabIndex];

	if not g_TabListDataTablePtr then

		----PushDebugMessage("±¾tabÒ³µÄÊı¾İ»¹Ã»ÓĞ£¬µÃÖØËã")
		g_TabListData[tabIndex] = {};
		g_TabListDataTablePtr = g_TabListData[tabIndex];

		--Ìî³ä±¾³¡¾°×Ô¶¯Ñ°Â·Êı¾İµÄIDºÍÓÅÏÈ¼¶µ½±í¸ñ....
		local tblPriority = {};
		local nCount = nEnd - nStart + 1;
		local k = 1;
		for i=nStart, nEnd do
			tblPriority[k] = {};
			tblPriority[k].id = i;
			tblPriority[k].pri = DataPool:GetAutoSearchPriority(i);
			k = k + 1;
		end

		--°´ÓÅÏÈ¼¶¶Ô±í¸ñ½øĞĞÅÅĞò....
		--Ëã·¨ÓĞµã²»ºÃÀí½â....²ß»®ÒªÇóÈ¨ÖµÏàÍ¬µÄÅÅĞòºóÏà¶ÔÎ»ÖÃ²»ÄÜ¸Ä±ä....¾ÍÏÈ âÃ´Ğ´ÁË....
		local temp1,temp2;
		for m=nCount, 1, -1 do
			for n=m-1, 1, -1 do
				if tblPriority[m].pri >= tblPriority[n].pri then
					temp1 = tblPriority[m].id;
					temp2 = tblPriority[m].pri;
					tblPriority[m].id = tblPriority[n].id;
					tblPriority[m].pri = tblPriority[n].pri;
					tblPriority[n].id = temp1;
					tblPriority[n].pri = temp2;
				end
			end
		end

		--°´ÅÅĞòºóµÄIDË³Ğò½«×Ô¶¯Ñ°Â·µÄÊı¾İ¼Óµ½±¾TabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İ±íÖĞ....
		local curTabType = TabIndex2TabType(tabIndex);
		local x, y, name, tooltips, info, tabtype;
		k = 1;
		for i=1, nCount do
			x, y, name, tooltips, info, tabtype = DataPool:GetAutoSearch( tblPriority[nCount-i+1].id );
			if 0 == curTabType or curTabType == tabtype then
				g_TabListDataTablePtr[k] = {};
				g_TabListDataTablePtr[k].ID = tblPriority[nCount-i+1].id;
				g_TabListDataTablePtr[k].nPosX = x;
				g_TabListDataTablePtr[k].nPosY = y;
				g_TabListDataTablePtr[k].strName = name;
				g_TabListDataTablePtr[k].strToolTips = tooltips;
				g_TabListDataTablePtr[k].strInfo = info;
				--g_TabListDataTablePtr[k].strInfo = tostring(tblPriority[nCount-i+1].pri).."£¬"..tostring(tblPriority[nCount-i+1].id);
				k = k + 1;
			end
		end

	end --end of (if not g_TabListDataTablePtr then)

	--Ìî³ä±¾Ò³µÄ×Ô¶¯Ñ°Â·Êı¾İµ½ListÖĞ....
	local nTabListCount = table.getn( g_TabListDataTablePtr );
	----PushDebugMessage("count ="..tostring(nTabListCount) )
	for i=1, nTabListCount do
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strName, 0, i-1 );
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strInfo, 1, i-1 );
		AutoSearch_List:SetRowTooltip( i-1, g_TabListDataTablePtr[i].strToolTips );
	end

	return true;

end

--**********************************
--»ñÈ¡ÔÚµ±Ç°³¡¾°ÏÂÖ¸¶¨Tab°´Å¥Ëù¶ÔÓ¦µÄ·ÖÀàÀàĞÍ....
--**********************************
function TabIndex2TabType( tabIndex )

	if g_CurSceneType ~= -1 and tabIndex >= 1 and tabIndex <= 5 then
		return g_TableTabIndex2TabType[g_CurSceneType+1][tabIndex];
	else
		return -1;
	end

end

--**********************************
--×Ô¶¯Ñ°Â·µ½Ö¸¶¨×ø±ê....
--**********************************
function AutoMoveTo()
	local nPosX = tonumber(InputPosition_x:GetText());
	local nPosY = tonumber(InputPosition_y:GetText());
	if not nPosX or nPosX <= 0 or not nPosY or nPosY <= 0 then
		return;
	end

	--»ñÈ¡µ±Ç°TabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İ....
	local str = GetDictionaryString("ZDXL_90520_2")
	AutoSearchTargetFlashPos(nPosX, nPosY, str)
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if TabListDataTablePtr then
		--Ñ¡ÖĞÁËµÚ¼¸Ïî....
		local nSelIndex = AutoSearch_List:GetSelectItem();
		if nSelIndex >= 0 then
			nSelIndex = nSelIndex + 1;
			if TabListDataTablePtr[nSelIndex].nPosX == nPosX and TabListDataTablePtr[nSelIndex].nPosY == nPosY then
				--ÉèÖÃÄ¿±êNPCµÄÃû×Ö£¬µ½´ï¸ÃNPC´¦ºó»á×Ô¶¯ÓëÆä¶Ô»°
				SetAutoRunTargetNPCName( TabListDataTablePtr[nSelIndex].strName );
				AutoSearchTargetFlashPos(nPosX, nPosY, TabListDataTablePtr[nSelIndex].strName)
			end
		end
	end

	--×Ô¶¯ÒÆ¶¯µ½Ö¸¶¨Î»ÖÃ
	local ret = AutoRunToTarget( nPosX, nPosY );
	if ret == 0 then
		PushDebugMessage("#{ZDXL_90520_3}")
	end
end

--**********************************
--Ë«»÷....
--**********************************
function OnDoubleClick()
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if TabListDataTablePtr then
		--Ñ¡ÖĞÁËµÚ¼¸Ïî....
		local nSelIndex = AutoSearch_List:GetSelectItem();
		if nSelIndex >= 0 then
		--Ö»ÓĞµ±ÓĞÑ¡ÖĞÏîÊ±£¬²ÅÏìÓ¦Ë«»÷ĞÅÏ¢£¬·ÀÖ¹³öÏÖË«»÷¿ ÁĞ±íÀ¸Ò²ÒÆ¶¯µÄÇé¿ö
			AutoMoveTo()
		end
	end
end

--****************************************
--¿½±´×Ô¶¯Ñ°Â·ÁĞ±íÖĞµÄNPC×ø±êµ½×ø±êÊäÈë¿ò
--****************************************
function CopyPosition()

	--»ñÈ¡µ±Ç°TabÒ³µÄ×Ô¶¯Ñ°Â·Êı¾İ....
	local TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if not TabListDataTablePtr then
		return;
	end

	--Ñ¡ÖĞÁËµÚ¼¸Ïî....
	local nSelIndex = AutoSearch_List:GetSelectItem();
	if nSelIndex < 0 then
		return;
	end

	nSelIndex = nSelIndex + 1;
	local strPosX = tostring(TabListDataTablePtr[nSelIndex].nPosX);
	local strPosY = tostring(TabListDataTablePtr[nSelIndex].nPosY);
	InputPosition_x:SetText(strPosX);
	InputPosition_y:SetText(strPosY);
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function AutoSearch_Frame_On_ResetPos()
  AutoSearch_Frame:SetProperty("UnifiedPosition", g_AutoSearch_Frame_UnifiedPosition);
end

function AutoSearch_SearchTo(scnid, posx, posz)
	AutoRunToTargetEx(posx,posz,scnid)
end


--================================================
-- Enter¼üÑ°Â·
--================================================
function AutoSearch_XEnter()
	if (this:IsVisible()) then
		InputPosition_y:SetProperty("DefaultEditBox", "True");
		InputPosition_x:SetProperty("DefaultEditBox", "False");
	end
end

function AutoSearch_YEnter()
	if (this:IsVisible()) then
		AutoMoveTo()
	end
end
