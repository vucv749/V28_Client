local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Current = 0;

local g_Object = -1;
local Prompt_Text = {}

function Service_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_SERVICE");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function Service_OnLoad()
	EQUIP_BUTTONS = Service_Item
	Prompt_Text[1] = "Nhî có th¬ TÕi ðúc Ðài sØa chæa b«n r½i ch§m lÕi Ðích vû khí. Yêu sØa chæa Ðích vû khí Ðích nhu c¥u c¤p b§c ít nh¤t Yêu>=C¤p 40. C¤p 40 dß¾i vû khí Thïnh Träo Thø Hoá thß½ng nhân trñc tiªp sØa chæa. #r sØa chæa vû khí c¥n cüa ngß½i ðúc kÛ nång c¤p b§c*12không nhö Vu vû khí Ðích nhu c¥u c¤p b§c. #r sØa chæa m¾i có th¬ th¤t bÕi, luy kª th¤t bÕi 3ThÑ vû khí báo höng. Cüa ngß½i ðúc kÛ nång c¤p b§c càng cao, th¤t bÕi Ðích có th¬ Tính càng nhö. #r Thïnh Bä Yêu sØa chæa Ðích vû khí Ðà Ðµng khi ðªn Di®n Ðích v§t ph¦m Lan Trung, Ði¬m Kích'sØa chæa'. #r m²i l¥n sØa chæa tiêu hao sÑc s¯ng =vû khí c¤p b§c +4. #r vû khí c¤p b§c =vû khí nhu c¥u c¤p b§c/10+1H§u Thü Chïnh."
	Prompt_Text[2] = "Nhî có th¬ TÕi may Ðài sØa chæa b«n r½i ch§m lÕi Ðích Phòng Cø. Yêu sØa chæa Ðích Phòng Cø Ðích nhu c¥u c¤p b§c ít nh¤t Yêu>=C¤p 40. C¤p 40 dß¾i Phòng Cø Thïnh Träo Thø Hoá thß½ng nhân trñc tiªp sØa chæa. #r sØa chæa Phòng Cø c¥n cüa ngß½i may kÛ nång c¤p b§c*12không nhö Vu Phòng Cø Ðích nhu c¥u c¤p b§c. #r sØa chæa m¾i có th¬ th¤t bÕi, luy kª th¤t bÕi 3ThÑ Phòng Cø báo höng. Cüa ngß½i may kÛ nång c¤p b§c càng cao, th¤t bÕi Ðích có th¬ Tính càng nhö. #r Thïnh Bä Yêu sØa chæa Ðích Phòng Cø Ðà Ðµng khi ðªn Di®n Ðích v§t ph¦m Lan Trung, Ði¬m Kích'sØa chæa'. #r m²i l¥n sØa chæa tiêu hao sÑc s¯ng =Phòng Cø c¤p b§c +4. #r Phòng Cø c¤p b§c =Phòng Cø nhu c¥u c¤p b§c/10+1H§u Thü Chïnh."
	Prompt_Text[3] = "Nhî có th¬ TÕi công ngh® Ðài sØa chæa b«n r½i ch§m lÕi Ðích v§t ph¦m trang sÑc. Yêu sØa chæa Ðích v§t ph¦m trang sÑc Ðích nhu c¥u c¤p b§c ít nh¤t Yêu>=C¤p 40. C¤p 40 dß¾i v§t ph¦m trang sÑc Thïnh Träo Thø Hoá thß½ng nhân trñc tiªp sØa chæa. #r sØa chæa v§t ph¦m trang sÑc yêu c¥u cüa ngß½i công ngh® kÛ nång c¤p b§c*12không nhö Vu v§t ph¦m trang sÑc Ðích nhu c¥u c¤p b§c. #r sØa chæa m¾i có th¬ th¤t bÕi, luy kª th¤t bÕi 3ThÑ v§t ph¦m trang sÑc báo höng. Cüa ngß½i công ngh® kÛ nång c¤p b§c càng cao, th¤t bÕi Ðích có th¬ Tính càng nhö. #r Thïnh Bä Yêu sØa chæa Ðích v§t ph¦m trang sÑc Ðà Ðµng khi ðªn Di®n Ðích v§t ph¦m Lan Trung, Ði¬m Kích'sØa chæa'. #r m²i l¥n sØa chæa tiêu hao sÑc s¯ng =v§t ph¦m trang sÑc c¤p b§c +4. #r v§t ph¦m trang sÑc c¤p b§c =v§t ph¦m trang sÑc nhu c¥u c¤p b§c/10+1H§u Thü Chïnh."
end

function Service_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 41) then
			this:Show();

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
					return;
			end
			BeginCareObject_Service(objCared)
			Current = Get_XParam_INT(1);
			Service_Text:SetText(Prompt_Text[Current]);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			Service_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				Service_Clear()
				Service_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_SERVICE") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			Service_Clear()
			Service_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 5) then
			Service_Clear()
		end
		
	end
	
end

function Service_OnShown()
	Service_Clear()
end

function Service_Clear()

	EQUIP_BUTTONS : SetActionItem(-1);
	Service_Item_Explain:SetText("")
	LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	EQUIP_QUALITY = -1;

end

function Service_Update(pos0)
	local pos_packet;
	pos_packet = tonumber(pos0);

	local theAction = EnumAction(pos_packet, "packageitem");
	
	if theAction:GetID() ~= 0 then
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());
		Service_Item_Explain:SetText(theAction:GetName());
		if EQUIP_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
		--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ
		EQUIP_QUALITY = pos_packet;
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
	else
		EQUIP_BUTTONS:SetActionItem(-1);
		Service_Item_Explain:SetText("")
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
		return;
	end

--add here
end

function Service_Buttons_Clicked()

	if EQUIP_QUALITY ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnService");
			Set_XSCRIPT_ScriptID(801015);
			Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	else
		PushDebugMessage("Thïnh Bä Yêu sØa chæa Ðích trang b¸ Ðà Ðµng Ðáo v§t ph¦m Khuông Trung.")
	end
	
end

function Service_Close()
	--²¢ÉèÖÃ£¬ÈÃ±³°üÀïµÄÎ»ÖÃ±äÁÁ
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	Service_Clear();
	StopCareObject_Service(objCared)
end

function Service_Cancel_Clicked()
	Service_Close();
	return;
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Service(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Service");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Service(objCaredId)
	this:CareObject(objCaredId, 0, "Service");
	g_Object = -1;

end

function Resume_Equip()

	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			Service_Item_Explain:SetText("")
			EQUIP_QUALITY	= -1;
		end	
	end
	
end
