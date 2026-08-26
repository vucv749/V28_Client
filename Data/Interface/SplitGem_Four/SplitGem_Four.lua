local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local EQUIP_QUALITY = -1
local EQUIP_BUTTON
local CHARM_QUALITY = -1
local CHARM_BUTTON
local EB_BINDED = 1;				-- ????
--local GEM_BUTTONS = {};

local g_LastEquipID = -1;
local g_LastNeedItemID = -1;

local GEM_SELECTED_FOUR = 4

local IsTishiFour = 1;

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

function SplitGem_Four_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_SPLITGEM_FOUR");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
end

function SplitGem_Four_OnLoad()
	EQUIP_BUTTON	 = SplitGem_Four_Item
	CHARM_BUTTON	 = SplitGem_Four_Gem4
	--GEM_BUTTONS[1] = SplitGem_Four_Gem1
	--GEM_BUTTONS[2] = SplitGem_Four_Gem2
	--GEM_BUTTONS[3] = SplitGem_Four_Gem3
end

function SplitGem_Four_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 25702) then
			this:Show();
			--if(CHARM_BUTTON : GetActionItem() == -1) then
			  --SplitGem_Four_Explain3:Hide();
			--end
			SplitGem_Four_Explain3:SetText("#{INTERFACE_XML_JX_08}")
			
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
					return;
			end
			BeginCareObject_SplitGem_Four(objCared)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			SplitGem_Four_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		
		g_LastEquipID = -1;
	  g_LastNeedItemID = -1;	  
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end		

		if (EQUIP_QUALITY == tonumber(arg0) ) then
				SplitGem_Four_Clear()
				IsTishiFour = 0;
				SplitGem_Four_Update(1,tonumber(arg0))
		end
		if (CHARM_QUALITY == tonumber(arg0) ) then
				SplitGem_Four_Clear()
				CHARM_BUTTON : SetActionItem(-1);
				SplitGem_Four_Update(2,tonumber(arg0))
		end
		
	elseif( event == "UPDATE_SPLITGEM_FOUR") then
		if arg0 ~= nil then
			SplitGem_Four_Update(arg0,arg1);
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		
			
		if(arg0~=nil and (tonumber(arg0) == 54 or tonumber(arg0) == 55)) then
			Resume_Equip_Gem_Four(tonumber(arg0)-53)
			--if(tonumber(arg0) == 30) then
					--SplitGem_Four_Explain3:Hide();
			--end
		end
	end

end

function SplitGem_Four_OnShown()
	SplitGem_Four_Clear();
end

function SplitGem_Four_Clear()
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
	--GEM_BUTTONS[1] : SetActionItem(-1);
	--GEM_BUTTONS[2] : SetActionItem(-1);
	--GEM_BUTTONS[3] : SetActionItem(-1);
	GEM_SELECTED_FOUR = 4
	g_LastEquipID = -1
	g_LastNeedItemID = -1
end

function SplitGem_Four_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)

	local theAction = EnumAction(i_index, "packageitem");
	
	
	if u_index == 1 then
		
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
					
			if gemNum < 4 and IsTishiFour == 1 then
				PushDebugMessage("#{XQC_20080509_22}")
				return
			end
			
			IsTishiFour = 1;	
			
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
			--for i=1,3 do
				--GEM_BUTTONS[i] : SetActionItem(-1)
			--end
		--else
			--local ActionID,nItemID
		
		--	for i=1,3 do
				--nItemID = LifeAbility : GetSplitGem_Four_Gem (i-1);
				--AxTrace(0,1,"nItemID="..nItemID.." i="..i)
				
				--if nItemID ~= -1 then
					--ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
					--GEM_BUTTONS[i] : SetActionItem(ActionID);
				--else
					--GEM_BUTTONS[i] : SetActionItem(-1)
				--end

			--end	
		end
		--GEM_SELECTED_FOUR = -1
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
				SplitGem_Four_Explain3:SetText("#{INTERFACE_XML_138}");
			elseif (PlayerPackage : GetItemTableIndex( i_index ) >= 30900036 and PlayerPackage : GetItemTableIndex( i_index ) <= 30900044) then
				SplitGem_Four_Explain3:SetText("#{BSZC_20071116}");
			end				
			--SplitGem_Four_Explain3:Show();
			
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

function SplitGem_Four_Buttons_Clicked()
	
	
	if CHARM_QUALITY == -1 then
		PushDebugMessage("#{XQC_20080509_27}")
		return
	end
	
	if EQUIP_QUALITY == -1 then
		PushDebugMessage("#{XQC_20080509_26}")
		return
	end
	
	local EquipId = PlayerPackage : GetItemTableIndex( EQUIP_QUALITY )
	local CharmId = PlayerPackage : GetItemTableIndex( CHARM_QUALITY )
  local Gem_Level = LifeAbility : GetEquip_GemLevel(EQUIP_QUALITY,GEM_SELECTED_FOUR-1)
  
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
     PushDebugMessage("#{XQC_20080509_28}")
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
		  return
	    end
	  end
	end
	
	LifeAbility : Do_SeparateGem(EQUIP_QUALITY,GEM_SELECTED_FOUR-1,CHARM_QUALITY);

end

function SplitGem_Four_Close()
	this:Hide()
end

function SplitGem_Four_Cancel_Clicked()
	SplitGem_Four_Close();
	return;
end

function SplitGem_Four_OnHiden()
	StopCareObject_SplitGem_Four(objCared)
	SplitGem_Four_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_SplitGem_Four(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "SplitGem_Four");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_SplitGem_Four(objCaredId)
	this:CareObject(objCaredId, 0, "SplitGem_Four");
	g_Object = -1;

end

function Resume_Equip_Gem_Four(nIndex)


	if( this:IsVisible() ) then
		if nIndex == 1 then
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTON : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				--GEM_BUTTONS[1] : SetActionItem(-1);
				--GEM_BUTTONS[2] : SetActionItem(-1);
				--GEM_BUTTONS[3] : SetActionItem(-1);
				
			end
			
		else
		
			if(CHARM_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(CHARM_QUALITY,0);
				CHARM_BUTTON : SetActionItem(-1);
				CHARM_QUALITY	= -1;
			end
		end
		
    --if nIndex == 2 then
     -- if(SplitGem_Four_Explain3:IsVisible()) then
      	--SplitGem_Four_Explain3:Hide();
     -- end
    --end
	end
	
end

--function SplitGem_Four_Selected(Gem_Index)

	--if GEM_BUTTONS[Gem_Index]:GetActionItem() == -1 then

		--return
	--end
	
	--if GEM_SELECTED_FOUR ~= -1 then
		--GEM_BUTTONS[GEM_SELECTED_FOUR] : SetPushed(0)
	--end
	
	--GEM_SELECTED_FOUR = Gem_Index
	--GEM_BUTTONS[GEM_SELECTED_FOUR] : SetPushed(1)
	
--end
