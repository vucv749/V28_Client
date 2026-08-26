local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local EQUIP_QUALITY = -1
local EQUIP_BUTTON
local CHARM_QUALITY = -1
local CHARM_BUTTON
local EB_BINDED = 1;				-- ????
local GEM_BUTTONS = {};

local g_LastEquipID = -1;
local g_LastNeedItemID = -1;

local GEM_SELECTED = -1

local g_CharmIdList = { 
	30900012,
	30900036,
	30900037,
	30900038,
	30900039,
	30900040,
	30900041,
	30900042,
	30900043,
	30900044,
	} 

local g_SplitGem_Frame_UnifiedPosition;
function SplitGem_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_SPLITGEM");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function SplitGem_OnLoad()
	EQUIP_BUTTON	 = SplitGem_Item
	CHARM_BUTTON	 = SplitGem_Gem4
	GEM_BUTTONS[1] = SplitGem_Gem1
	GEM_BUTTONS[2] = SplitGem_Gem2
	GEM_BUTTONS[3] = SplitGem_Gem3
	
	 g_SplitGem_Frame_UnifiedPosition=SplitGem_Frame:GetProperty("UnifiedPosition");
end

function SplitGem_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 27) then
			this:Show();
			-- Çé¿öÎïÆ·²Û zchw
			SplitGem_Clear();
			if(CHARM_BUTTON : GetActionItem() == -1) then
			  SplitGem_Explain3:Hide();
			end
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
					return;
			end
			BeginCareObject_SplitGem(objCared)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			SplitGem_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		
		g_LastEquipID = -1;
	  g_LastNeedItemID = -1;	  
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end		

		if (EQUIP_QUALITY == tonumber(arg0) ) then
				SplitGem_Clear()
				SplitGem_Update(1,tonumber(arg0))
				SplitGem_Explain3:Hide();
		end
		if (CHARM_QUALITY == tonumber(arg0) ) then
				CHARM_BUTTON : SetActionItem(-1);
				SplitGem_Update(2,tonumber(arg0))
		end
		
	elseif( event == "UPDATE_SPLITGEM") then
		if arg0 ~= nil then
			SplitGem_Update(arg0,arg1);
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		if(arg0~=nil and (tonumber(arg0) == 29 or tonumber(arg0) == 30)) then
			Resume_Equip_Gem(tonumber(arg0)-28)
			if(tonumber(arg0) == 30) then
					SplitGem_Explain3:Hide();
			end
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		SplitGem_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SplitGem_Frame_On_ResetPos()
		
	end

end

function SplitGem_OnShown()
	SplitGem_Clear();
end

function SplitGem_Clear()
	EQUIP_BUTTON : SetActionItem(-1);
	CHARM_BUTTON : SetActionItem(-1);
	if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	end
	if(CHARM_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(CHARM_QUALITY,0);
	end
	EQUIP_QUALITY = -1
	CHARM_QUALITY = -1
	GEM_BUTTONS[1] : SetActionItem(-1);
	GEM_BUTTONS[2] : SetActionItem(-1);
	GEM_BUTTONS[3] : SetActionItem(-1);
	GEM_SELECTED = -1
	g_LastEquipID = -1
	g_LastNeedItemID = -1
end

function SplitGem_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)

	local theAction = EnumAction(i_index, "packageitem");
	
	
	if u_index == 1 then
		
		-- âÀïÏÈ¸ÄÒ»ÏÂ£¬¿ÉÄÜÊÇÓÐÈË¸ÄActionButtonÁË
        if PlayerPackage : IsLock(i_index) > 0 then
			PushDebugMessage("#{ZBDW_091105_3}")
			return
		end	
			
		if theAction:GetID() ~= 0 then
			local EquipPoint = LifeAbility : Get_Equip_Point(i_index)

			if EquipPoint==16 then --??
				PushDebugMessage("#{GMGameInterface_Script_LifeAbility_13}")
				return
			end			
			if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
				if EquipPoint ~= -1 then
					PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
				end
				return
			end
			
			--modi:lby20080522 34479 µ±µÚËÄ¸ö¿ ÓÐ±¦Ê¯²»ÄÜ ª³ý
			local gemNum = LifeAbility : GetEquip_GemCount(i_index)
			
			
			if gemNum > 3 then
				--PushDebugMessage(tostring(gemNum))
				PushDebugMessage("#{GCRemoveGemResult_REMOVE_FORTH}")
				return
			end
				
			
			if EQUIP_QUALITY ~= -1 then
				--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ	
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			end
			
			EQUIP_BUTTON:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = i_index;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTON:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			return;
		end
		
		if not LifeAbility:SplitGem_Update(i_index) then
			for i=1,3 do
				GEM_BUTTONS[i] : SetActionItem(-1)
			end
		else
			local ActionID,nItemID
		
			for i=1,3 do
				nItemID = LifeAbility : GetSplitGem_Gem (i-1);
				AxTrace(0,1,"nItemID="..nItemID.." i="..i)
				
				if nItemID ~= -1 then
					ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
					GEM_BUTTONS[i] : SetActionItem(ActionID);
				else
					GEM_BUTTONS[i] : SetActionItem(-1)
				end

			end
			
		end
		GEM_SELECTED = -1
	else
		if theAction:GetID() ~= 0 then
			local result = 0		  
		  for i, v in g_CharmIdList do
		    if PlayerPackage : GetItemTableIndex( i_index ) == v then
			    result = 1;
			    break
		    end
	    end
	    
	    if result == 0 then
	       PushDebugMessage("N½i này phäi ð¬ vào Bäo ThÕch Trích Tr× Phù.")
	       return
	    end			
			
			--ÅÐ¶ÏÊÇÄÄÖÖ±¦Ê¯ ª³ý·û
			if PlayerPackage : GetItemTableIndex( i_index ) == 30900012 then
				SplitGem_Explain3:SetText("#{INTERFACE_XML_138}");
			elseif (PlayerPackage : GetItemTableIndex( i_index ) >= 30900036 and PlayerPackage : GetItemTableIndex( i_index ) <= 30900044) then
				SplitGem_Explain3:SetText("#{BSZC_20071116}");
			end				
			SplitGem_Explain3:Show();
			
			if CHARM_QUALITY ~= -1 then
				--ÈÃÖ®Ç°µÄ¶«Î÷±äÁÁ	
				LifeAbility : Lock_Packet_Item(CHARM_QUALITY,0);
			end
			
			CHARM_BUTTON : SetActionItem(theAction:GetID());
			CHARM_QUALITY = i_index;
			LifeAbility : Lock_Packet_Item(CHARM_QUALITY,1);
		else
			CHARM_BUTTON:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(CHARM_QUALITY,0);
			CHARM_QUALITY = -1;
			return;
		end
	end
		
end

function SplitGem_Buttons_Clicked()
	
	if GEM_SELECTED == -1 then
		PushDebugMessage("Thïnh lña ch÷n Yêu bö ði Ðích bäo thÕch.")
		return
	end
	
	if CHARM_QUALITY == -1 then
		PushDebugMessage("Không có Bäo ThÕch Trích Tr× Phù Tß¾ng không th¬ bö ði bäo thÕch.")
		return
	end
	
	if EQUIP_QUALITY == -1 then
		PushDebugMessage("Thïnh ð¬ ð£t Yêu bö ði bäo thÕch Ðích trang b¸.")
		return
	end
	
	local EquipId = PlayerPackage : GetItemTableIndex( EQUIP_QUALITY )
	local CharmId = PlayerPackage : GetItemTableIndex( CHARM_QUALITY )
  local Gem_Level = LifeAbility : GetEquip_GemLevel(EQUIP_QUALITY,GEM_SELECTED-1)
  
  local result = 1
  
  if CharmId == 30900044 then             --9????????????
     result = 1
  elseif CharmId == 30900043 then         --8??????????8??8???
     if (Gem_Level > 8) then
       result = 0
     end
  elseif CharmId == 30900042 then         --7??????????7??7???
     if (Gem_Level > 7) then
       result = 0
     end
  elseif CharmId == 30900041 then         --6??????????6??6???
     if (Gem_Level > 6) then
       result = 0
     end
  elseif CharmId == 30900040 then         --5??????????5??5???
     if (Gem_Level > 5) then
       result = 0
     end
  elseif CharmId == 30900039 then         --4??????????4??4???
     if (Gem_Level > 4) then
       result = 0
     end
  elseif CharmId == 30900038 then         --3??????????3??3???
     if (Gem_Level > 3) then
       result = 0
     end
  elseif CharmId == 30900037 then         --72??????????2??2???
     if (Gem_Level > 2) then
       result = 0
     end
  elseif CharmId == 30900036 then         --1??????????1??1???
     if (Gem_Level > 1) then
       result = 0
     end
  else
     result = 1
  end
  
  if result == 0 then
     PushDebugMessage("Cao C¤p Bäo ThÕch Trích Tr× Phù ð¯i Ñng c¤p b§c không phù hþp")
     return
  end
  
	if(g_LastEquipID ~= EquipId or g_LastNeedItemID ~= CharmId) then
	  g_LastEquipID = EquipId;
	  g_LastNeedItemID = CharmId;
	--Èç¹ûÊÇµÍ¼¶ ª³ý·û£¬ÐèÒªÅÐ¶ÏµÍ¼¶ ª³ý·ûÊÇ·ñÊÇ°ó¶¨µÄ£¬ºÃ¾ö¶¨ ª³ýºóµÄ±¦Ê¯ÊÇ·ñ°ó¶¨
	--ºöÂÔ×°±¸ÊÇ·ñ°ó¶¨£¬ºöÂÔ¸ß¼¶ ª³ý·û
	  if CharmId == 30900012 then
	    if (GetItemBindStatus(CHARM_QUALITY) == EB_BINDED) then
	      ShowSystemInfo("BSZC_20071121");
		    --LifeAbility:Separate_Confirm(EQUIP_QUALITY,GEM_SELECTED-1,CHARM_QUALITY);
		  return
	    end
	  end
	end
	
	LifeAbility : Do_SeparateGem(EQUIP_QUALITY,GEM_SELECTED-1,CHARM_QUALITY);

end

function SplitGem_Close()
	this:Hide()
end

function SplitGem_Cancel_Clicked()
	SplitGem_Close();
	return;
end

function SplitGem_OnHiden()
	StopCareObject_SplitGem(objCared)
	SplitGem_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_SplitGem(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "SplitGem");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_SplitGem(objCaredId)
	this:CareObject(objCaredId, 0, "SplitGem");
	g_Object = -1;

end

function Resume_Equip_Gem(nIndex)

	if( this:IsVisible() ) then
		if nIndex == 1 then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTON : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				GEM_BUTTONS[1] : SetActionItem(-1);
				GEM_BUTTONS[2] : SetActionItem(-1);
				GEM_BUTTONS[3] : SetActionItem(-1);
				GEM_SELECTED = -1
			end
			
		else
		
			if(CHARM_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(CHARM_QUALITY,0);
				CHARM_BUTTON : SetActionItem(-1);
				CHARM_QUALITY	= -1;
			end
		end
		
    if nIndex == 2 then
      if(SplitGem_Explain3:IsVisible()) then
      	SplitGem_Explain3:Hide();
      end
    end
	end
	
end

function SplitGem_Selected(Gem_Index)

	if GEM_BUTTONS[Gem_Index]:GetActionItem() == -1 then

		return
	end
	
	if GEM_SELECTED ~= -1 then
		GEM_BUTTONS[GEM_SELECTED] : SetPushed(0)
	end
	
	GEM_SELECTED = Gem_Index
	GEM_BUTTONS[GEM_SELECTED] : SetPushed(1)
	
end


function SplitGem_Frame_On_ResetPos()
  SplitGem_Frame:SetProperty("UnifiedPosition", g_SplitGem_Frame_UnifiedPosition);
end
