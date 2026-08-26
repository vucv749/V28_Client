local g_nSelect_Index = -1;
local g_PreSelect = -1;
local g_PetIndex  = {};
local PET_MAX_NUMBER = 10	--???????? --add by xindefeng
local g_PetList_Frame_UnifiedPosition;
--===============================================
-- OnLoad()
--===============================================
function PetList_PreLoad()

	this:RegisterEvent("OPEN_PET_LIST");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("CLOSE_PET_LIST");
	this:RegisterEvent("CLOSE_PET_FRAME");
	this:RegisterEvent("CLOSE_MISSION_REPLY");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("TOGGLE_PETLIST");
	this:RegisterEvent("UPDATE_PET_LIST");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this : RegisterEvent("DELETE_PET");
			-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function PetList_OnLoad()

	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	 g_PetList_Frame_UnifiedPosition=PetList_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent()
--===============================================
function PetList_OnEvent(event)
	--PushDebugMessage("PetList : "..event);

	-- ´ò¿ª äÊÞÁÐ±í½çÃæ	
	if(event == "OPEN_PET_LIST") then
		this:Show();
		PetList_UpdateFrame();
		PetList_Frame:SetProperty("UnifiedXPosition","{1.0,-215}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,201}");

	-- ´ò¿ªÈÎÎñÌá½»½çÃæ
	elseif(event == "REPLY_MISSION") then
		-- ¡°ÑªÔ¡Éñ±ø¡±ÈÎÎñÊ±£¬²»ÐèÒª´ò¿ª äÊÞÁÐ±í½çÃæ,modify by chendejia
		if (arg1~=nil and (tonumber(arg1) == 500503 or tonumber(arg1) == 500504 )) then
			return		
		end
		this:Show();
		PetList_Frame:SetProperty("UnifiedXPosition","{0.0,604}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,71}");
		PetList_UpdateFrame();

	-- ´ò¿ª½»Ò×½çÃæ
	elseif( event == "OPEN_EXCHANGE_FRAME" )  then
		this:Show();
		PetList_UpdateFrame();
		PetList_Frame:SetProperty("UnifiedXPosition","{0.0,510}");
		PetList_Frame:SetProperty("UnifiedYPosition","{0.0,206}");

	-- ¸üÐÂ äÊÞÁÐ±í½çÃæ
	elseif ( event == "UPDATE_PET_LIST" ) then
		PetList_UpdateFrame();

	-- Íæ¼ÒÉíÉÏµÄ äÊÞÊý¾Ý·¢Éú±ä»¯£¬°üÀ¨ äÊÞ³ö ½¡¢ÐÝÏ¢¡¢Ôö¼ÓÒ»Ö» äÊÞ
	elseif ( event == "UPDATE_PET_PAGE" ) then
		PetList_UpdateFrame();
	
	-- Íæ¼Ò´ÓÁÐ±íÑ¡¶¨Ò»Ö» äÊÞ
	elseif(event == "REPLY_MISSION_PET") then
		PetList_UpdateFrame();
		
	-- Íæ¼ÒÉíÉÏ¼õÉÙ1Ö» äÊÞ
	elseif (event == "DELETE_PET") then
		PetList_UpdateFrame();
	
	-- ¹Ø± ÈÎÎñÌá½»½çÃæ
	elseif ( event == "CLOSE_MISSION_REPLY" ) then
		PetList_Refuse_Click();

	-- ¹Ø±  äÊÞÁÐ±í½çÃæ
	elseif ( event == "CLOSE_PET_LIST" ) then
		PetList_Refuse_Click();
		
	elseif ( event == "CLOSE_PET_FRAME" ) then
		PetList_Refuse_Click();

	elseif ( event == "TOGGLE_PETLIST" ) then
--		this:TogleShow();

	end
			-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		PetList_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetList_Frame_On_ResetPos()
	end
end

--===============================================
-- ¸üÐÂ½çÃæ
--===============================================
function PetList_UpdateFrame()

	-- ÏÈÇå¿ µ±Ç°ÁÐ±í
	PetList_List:ClearListBox();
	
	local PetInListIndex = 0;
	for	i=0, PET_MAX_NUMBER-1 do	--modify by xindfeng	??????????,??????????????
		local szPetName,szOn = Pet:GetPetList_Appoint(i);
		local strToolTips = "";

		if(szPetName ~= "")   then
			--  äÊÞ²»ÔÚ±³°üÀï
			if ( szOn ~= "on_packa" ) then 
				szPetName = "#c808080" .. szPetName;		-- ????
			end
			
			--  äÊÞÔÚ±³°üÀï£¬²¢ÇÒÒÑ¾­Ìá½»µ½Ä³½çÃæ
			--local nLocation = Pet:GetPetLocation(i)
			--if ( szOn == "on_packa" ) and ( nLocation ~= -1 ) then
			--	szPetName = "#G" .. szPetName;					-- ÂÌÉ«ÏÔÊ¾
			--end

			if(PlayerPackage:IsPetLock(i) == 1)    then
			  local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i);
				if( nUnlockElapsedTime == 0 ) then
					szPetName = szPetName.. "  #-05";
					strToolTips =  "Ðã khóa" ;
				else
					szPetName = szPetName.. "  #-10";
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
					strToolTips = strLeftTime ;
				end
			end
			PetList_List:AddItem(szPetName, i);
			PetList_List:SetItemTooltip( PetInListIndex, strToolTips );
			PetInListIndex = PetInListIndex + 1 ;
		end
	end

end

--===============================================
-- Ñ¡Ôñ
--===============================================
function PetList_Choose_Click()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();
	if( g_nSelect_Index == -1 )  then
		return;
	end

	local NeedCheckLock = 1
	if 	IsWindowShow("PetLingXingUp")
		or IsWindowShow("PetSkillStudy")
		or IsWindowShow("PetSavvy")
		or IsWindowShow("PetSavvyGGD")
		or IsWindowShow("PetXingGe")
		or IsWindowShow("PetProcreate")
		or IsWindowShow("PetZhengYou")
		or IsWindowShow("PetFriendSearch")
		or IsWindowShow("PetLevelup")
		or IsWindowShow("PetStudyNewSkill")
		or IsWindowShow("PetPropagateCheck")
		or IsWindowShow("PetExterior_Gain")
		or IsWindowShow("PetExterior_Change")
		or IsWindowShow("Pethuantong") then
		NeedCheckLock = 0
	end

	if IsWindowShow("PetHuanhua")  then
		NeedCheckLock = 0
	end

	if NeedCheckLock == 1 and PlayerPackage:IsPetLock(g_nSelect_Index) == 1 then
		PushDebugMessage("Ðã thêm khóa v¾i Trân Thú")
		return;
	end

	Exchange:AddPet(g_nSelect_Index);
end

--===============================================
-- ·ÅÆú
--===============================================
function PetList_Refuse_Click()
	--if g_nSelect_Index ~= -1 then
	--	Pet:SetPetLocation(g_nSelect_Index,-1);
	--end
	this:Hide();
end

--===============================================
-- Ñ¡ÖÐÁÐ±íÖÐµÄ äÊÞ
--===============================================
function PetList_List_Selected()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();
end

--===============================================
--¸ù¾ÝÑ¡ÔñµÄ äÊÞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ÐÅÏ¢
--===============================================
function PetList_ShowTargetPet()
	g_nSelect_Index = PetList_List:GetFirstSelectItem();

	if( -1 == g_nSelect_Index ) then
		return;
	end
	Pet:ShowTargetPet(g_nSelect_Index);

end



--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function PetList_Frame_On_ResetPos()
  PetList_Frame:SetProperty("UnifiedPosition", g_PetList_Frame_UnifiedPosition);
end
