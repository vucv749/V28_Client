local MISSION_BUTTONS_NUM =3;
local Pet_Index = -1;
local objCared = -1;
local MISSION_ITEM_BUTTONS = {};
local MISSION_ITEM_TEXT ={};
local MAX_OBJ_DISTANCE = 3.0;
local	Accept_Clicked_Num = 0;				-- ???????“??”
local	scriptId = -1;								-- “????”???,????????ID
local g_MissionReply_Frame_UnifiedPosition;
--ÈÎÎñÌá½»½çÃæ

--===============================================
-- OnLoad
--===============================================
function MissionReply_PreLoad()

	this:RegisterEvent("REPLY_MISSION");						-- ??????
	this:RegisterEvent("QUEST_AFTER_CONTINUE");			-- ??“??”??,??????
	this:RegisterEvent("REPLY_MISSION_PET");				-- ????
	this:RegisterEvent("UPDATE_REPLY_MISSION");			-- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT");				-- ????????????
	this:RegisterEvent("UPDATE_PET_PAGE");					-- ?????????????

		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	
end

function MissionReply_OnLoad()

	MISSION_ITEM_BUTTONS[1] = MissionReply_NeedItem1;
	MISSION_ITEM_BUTTONS[2] = MissionReply_NeedItem2;
	MISSION_ITEM_BUTTONS[3] = MissionReply_NeedItem3;
	
	MISSION_ITEM_TEXT[1] = MissionReply_NeedItem1_Info;
	MISSION_ITEM_TEXT[2] = MissionReply_NeedItem2_Info;
	MISSION_ITEM_TEXT[3] = MissionReply_NeedItem3_Info;
		g_MissionReply_Frame_UnifiedPosition=MissionReply_Frame:GetProperty("UnifiedPosition");
end

--===============================================
-- OnEvent
--===============================================
function MissionReply_OnEvent(event)
	
	--PushDebugMessage("MissionReply : "..event);

	-- Ìá½»ÈÎÎñ½çÃæ
	if ( event == "REPLY_MISSION" ) then		
		if (arg0~=nil) then
			objCared = tonumber(arg0);
			BeginCareObject_MissionReply(tonumber(arg0));
		end
		
		-- ¡°ÑªÔ¡Éñ±ø¡±ÈÎÎñÊ±£¬µÃµ½µ÷ÓÃ¸Ã½çÃæµÄ scriptId
		if (arg1~=nil) then
			scriptId = tonumber(arg1);			
		end
		
		MissionReply_Frame_Update();
		this:Show();
	
	-- Ë¢ĞÂÌá½»ÈÎÎñ½çÃæ
	elseif( event == "UPDATE_REPLY_MISSION" )  then
		MissionReply_Frame_Update();
	
	-- µã»÷¡°¼ÌĞø¡±Ö®ºó£¬½±Æ·Ñ¡Ôñ½çÃæ
	elseif ( event == "QUEST_AFTER_CONTINUE" and this:IsVisible() ) then
		StopCareObject_MissionReply(objCared)
		this:Hide();
	
	--  äÊŞË¢ĞÂ
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		-- äÊŞÒÑ±»ÆäËü½çÃæÑ¡ÖĞ
		if (Pet:GetPetLocation(tonumber(arg0)) ~= -1) then
			return;
		end

		-- È¡Ïûµ±Ç° äÊŞµÄËø¶¨×´Ì¬£¨Èç¹ûµ±Ç°Ñ¡µÄºÍÉÏÒ»´ÎÑ¡µÄÊÇÍ¬Ò»Ö» äÊŞ£¬²»ÄÜ½â³ıËø¶¨£©
		if (Pet_Index >= 0) and (Pet_Index ~= tonumber(arg0)) then			
			Pet : SetPetLocation( Pet_Index, -1 )			
		end		

		Pet_Index = tonumber(arg0)		
		MissionReply_PetInfo_Update();

	-- Ä³Âß¼­¶ÔÏóµÄÄ³Ğ©·¢Éú¸Ä±ä
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			
			--È¡Ïû¹ØĞÄ
			StopCareObject_MissionReply(objCared);
		end
	
	-- Íæ¼ÒÉíÉÏµÄ äÊŞÊı¾İ·¢Éú±ä»¯£¬°üÀ¨ äÊŞ³ö ½¡¢ĞİÏ¢¡¢Ôö¼ÓÒ»Ö» äÊŞ
	elseif (event == "UPDATE_PET_PAGE") then
		MissionReply_PetInfo_Update();
	end
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		MissionReply_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		MissionReply_Frame_On_ResetPos()
	end
end

--===============================================
-- ¸üĞÂÏÔÊ¾½çÃæÊı¾İ
--===============================================
function MissionReply_Frame_Update()
	
	--ÈÎÎñĞÅÏ¢£¬£¨ĞèÇó¡¢½±Àø¡¢ÃèÊöµÈ
	--½øÈëÇ°ÏÈÇå³ıÔ­ÓĞĞÅÏ¢
	MissionReply_Desc:ClearAllElement();

	--ÏÔÊ¾NPCÃû×Ö
	if( Target:IsPresent()) then
		MissionReply_PageHeader_Name:SetText("#gFF0FA0"..Target:GetDialogNpcName());
	end
	
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();
	if ( nTextNum>=1 ) then
		for i=1, nTextNum do
			local strInfo = DataPool:GetMissionDemand_Text(i-1);
			MissionReply_Desc:AddTextElement(strInfo);
		end
	end
	
	if ( nBonusNum>=1 ) then
		MissionReply_Desc:AddTextElement("C¥n v§t ph¦m");
		for i=1, nBonusNum do
			-- ĞèÒªµÄÀàĞÍ£¬ĞèÒªÎïÆ·ID£¬ĞèÒª¶àÉÙ¸ö
			local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
			MissionReply_Desc:AddItemElement(nItemID, nNum, 0);
		end
	end	

	-- ÈÎÎñĞèÒªµÄÎïÆ·À¸£¨Íæ¼Ò×Ô¼ºÍÏ·Å£©
	local i=1;
	while i<=MISSION_BUTTONS_NUM do
		local theAction = MissionReply:EnumItem(i-1);

		if theAction:GetID() ~= 0 then
			MISSION_ITEM_BUTTONS[i] : SetActionItem(theAction:GetID());
			MISSION_ITEM_TEXT[i] : SetText(theAction:GetName());
		else
			MISSION_ITEM_BUTTONS[i] : SetActionItem(-1);
			MISSION_ITEM_TEXT[i] : SetText("");
		end
		i = i+1;
	end

	-- ¸üĞÂ äÊŞµÄ½çÃæÊı¾İ
	MissionReply_PetInfo_Update();

end

--===============================================
-- ¸üĞÂ äÊŞÏÔÊ¾½çÃæÊı¾İ
--===============================================
function MissionReply_PetInfo_Update()
	
	--½øÈëÇ°ÏÈÇå³ıÔ­ÓĞÏÔÊ¾ĞÅÏ¢
	MissionReply_NeedPet_Info: SetText("");	
	
	--ÈÎÎñĞèÒªµÄ³èÎïÀ¸£¨Íæ¼Ò×Ô¼ºÑ¡Ôñ£©
	if Pet_Index ~= -1 then
		-- ÅĞ¶Ï äÊŞµÄ×´Ì¬
		local szPetName, szOn = Pet:GetPetList_Appoint(Pet_Index);
		if(szPetName ~= "")   then
			--  äÊŞÔÚ±³°üÀï
			if ( szOn == "on_packa" ) then
				-- ¸ø äÊŞÉÏËø£¬ÉèÖÃ äÊŞÒÑ¾­Ìá½»µ½7ºÅ½çÃæÈİÆ÷
				Pet : SetPetLocation( Pet_Index, 7 )
				MissionReply_NeedPet_Info : SetText(Pet:GetName(Pet_Index));
			else
				-- ¸ø äÊŞ½âËø£¬ÉèÖÃ äÊŞÒÑ¾­´Óµ±Ç°½çÃæÈİÆ÷ÊÍ·Å
				Pet : SetPetLocation( Pet_Index, -1 )
				Pet_Index = -1
				MissionReply_NeedPet_Info : SetText("");
			end
		end
	end
	-- ¸üĞÂ äÊŞÁĞ±í½çÃæ
	Pet:UpdatePetList();

end

--===============================================
-- ³èÎï (ÔİÊ±²»ÄÜÍê³É)
--===============================================
function MissionReply_Pet_Clicked()
	MissionReply:OpenPetFrame();
end

--===============================================
-- È·¶¨
--===============================================
function MissionReply_Accept_Clicked()
		
	-- Èç¹ûÊÇ¡°ÑªÔ¡Éñ±ø¡±ÖĞµÄ¡°ÉñÆ÷ÖıÔì¡±»ò¡°ÉñÆ÷ÖØÖı¡±ÈÎÎñµ÷ÓÃµÄ¸Ã½çÃæ
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then

		if (Accept_Clicked_Num == 0) then
			MissionReply:OpenSecondConfirmFrame(scriptId);		-- ????????scriptId,???????????
			Accept_Clicked_Num = 1;

		else 	 
			MissionReply:OnContinue(Pet_Index);
			StopCareObject_MissionReply(objCared)
			if Pet_Index >= 0 then
				Pet : SetPetLocation( Pet_Index, -1 )
			end
			Pet_Index = -1;
			Accept_Clicked_Num = 0; 													-- ?2???“??”?,?? Accept_Clicked_Num ????“??”???
			this:Hide();
		end
		
	else
		MissionReply:OnContinue(Pet_Index);
		StopCareObject_MissionReply(objCared)
		if Pet_Index >= 0 then
			Pet : SetPetLocation( Pet_Index, -1 )
		end
		Pet_Index = -1;
		this:Hide();
	end
	
end

--===============================================
-- È¡Ïû
--===============================================
function MissionReply_Cancel_Clicked()

	-- Èç¹ûÊÇ¡°ÑªÔ¡Éñ±ø¡±ÖĞµÄ¡°ÉñÆ÷ÖıÔì¡±»ò¡°ÉñÆ÷ÖØÖı¡±ÈÎÎñµ÷ÓÃµÄ¸Ã½çÃæ
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then
		Accept_Clicked_Num = 0; 														-- ??“??”?,?? Accept_Clicked_Num ????“??”???
	end
	
	StopCareObject_MissionReply(objCared)
	if Pet_Index >= 0 then
		Pet : SetPetLocation( Pet_Index, -1 )
	end
	Pet_Index = -1;
	this:Hide();

end

--=========================================================
--¿ªÊ¼¹ØĞÄNPC£¬
--ÔÚ¿ªÊ¼¹ØĞÄÖ®Ç°ĞèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓĞ¡°¹ØĞÄ¡±µÄNPC£¬
--Èç¹ûÓĞµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓĞµÄ¡°¹ØĞÄ¡±
--=========================================================
function BeginCareObject_MissionReply(objCaredId)

	AxTrace(0,0,"objCaredId =" .. objCaredId )
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "MissionReply");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function StopCareObject_MissionReply(objCaredId)
	this:CareObject(objCaredId, 0, "MissionReply");
	g_Object = -1;
end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØĞÄ
--=========================================================
function MissionReply_OnClose()
	DataPool:CloseMissionFrame();
	Pet : ShowPetList(0);
	MissionReply_Cancel_Clicked();
	if Pet_Index >= 0 then
		Pet : SetPetLocation( Pet_Index, -1 )
	end
	Pet_Index = -1
end

function MissionReply_ToggleShowPetList()
	DataPool : ToggleShowPetList();
end

--=========================================================
-- µã»÷Í¼±ê
--=========================================================
function MissionReply_NeedItem_Click(nIndex)
	MissionReply:DoAction(nIndex);
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function MissionReply_Frame_On_ResetPos()
  MissionReply_Frame:SetProperty("UnifiedPosition", g_MissionReply_Frame_UnifiedPosition);
end
