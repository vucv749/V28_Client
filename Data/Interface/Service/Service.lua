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
	Prompt_Text[1] = "  Có th¬ sØa vû khí trên Lv40 ðµ b«n th¤p tÕi B® Ðúc. Vû khí dß¾i Lv40 có th¬ sØa tÕi ti®m.#rSØa vû khí c¥n c¤p kÛ nång ðúc x12 không nhö h½n c¤p yêu c¥u cüa vû khí.#rSØa có th¬ th¤t bÕi, th¤t bÕi 3 l¥n vû khí s¨ höng. C¤p kÛ nång ðúc càng cao, khä nång th¤t bÕi càng nhö.#rÐ£t vû khí c¥n sØa vào ô dß¾i, ch÷n SØa.#rM²i l¥n sØa tiêu hao hoÕt lñc = c¤p vû khí +4.#rC¤p vû khí = C¤p yêu c¥u cüa vû khí /10 + 1 l¤y chÇn."
	Prompt_Text[2] = "  Có th¬ sØa phòng cø trên Lv40 ðµ b«n th¤p tÕi Bàn May Vá. Phòng cø dß¾i Lv40 có th¬ sØa tÕi ti®m.#rSØa phòng cø c¥n c¤p kÛ nång may vá x12 không nhö h½n c¤p yêu c¥u cüa phòng cø.#rSØa có th¬ th¤t bÕi, th¤t bÕi 3 l¥n phòng cø s¨ höng. C¤p kÛ nång may vá càng cao, khä nång th¤t bÕi càng nhö.#rÐ£t phòng cø c¥n sØa vào ô dß¾i, ch÷n SØa.#rM²i l¥n sØa tiêu hao hoÕt lñc = c¤p phòng cø +4.#rC¤p phòng cø = C¤p yêu c¥u cüa phòng cø /10 + 1 l¤y chÇn."
	Prompt_Text[3] = "  Có th¬ sØa trang sÑc trên Lv40 ðµ b«n th¤p tÕi Bàn Thü Công. Trang sÑc dß¾i Lv40 có th¬ sØa tÕi ti®m.#rSØa trang sÑc c¥n c¤p kÛ nång công ngh® x12 không nhö h½n c¤p yêu c¥u cüa trang sÑc.#rSØa có th¬ th¤t bÕi, th¤t bÕi 3 l¥n trang sÑc s¨ höng. C¤p kÛ nång công ngh® càng cao, khä nång th¤t bÕi càng nhö.#rÐ£t trang sÑc c¥n sØa vào ô dß¾i, ch÷n SØa.#rM²i l¥n sØa tiêu hao hoÕt lñc = c¤p trang sÑc +4.#rC¤p trang sÑc = C¤p yêu c¥u cüa trang sÑc /10 + 1 l¤y chÇn."
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
		PushDebugMessage("Kéo trang b¸ c¥n sØa vào ô v§t ph¦m.")
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
