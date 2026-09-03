local GEM_BUTTONS = {};
local GEM_QUALITY = {};
local GEM_EFFECT = {};
local INVALID_ID =-1;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local LastBaoshi = -1;
local LastZhuangbei = -1;
local LastCharm = -1;            --???????
local LastOdds = -1;             --????????
local SuccRate = 25;						 --??????


local g_Object = -1;

local Enchase_Cost = {}
local EquipGemTable = {}

local g_Enchase_Frame_UnifiedPosition;

function Enchase_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_ENHANCE")
	
	this:RegisterEvent("OPEN_COMPOSE_GEM");
	this:RegisterEvent("OPEN_COMPOSE_ITEM");
	this:RegisterEvent("UPDATE_COMPOSE_GEM");
--	this:RegisterEvent("UPDATE_COMPOSE_ITEM");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
--	this:RegisterEvent("TOGLE_SKILL_BOOK");
--	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
--	this:RegisterEvent("CLOSE_SKILL_BOOK");
	this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE"); --zchw
	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function Enchase_OnLoad()
	GEM_BUTTONS[1] = Enchase_Item;
	GEM_BUTTONS[2] = Enchase_Gem1;
	GEM_BUTTONS[3] = Enchase_Gem2;
	GEM_BUTTONS[4] = Enchase_Gem3;
	GEM_QUALITY[1] = -1;
	GEM_QUALITY[2] = -1;
	GEM_QUALITY[3] = -1;
	GEM_QUALITY[4] = -1;
	GEM_EFFECT[1] = Enchase_Effect1;
	GEM_EFFECT[2] = Enchase_Effect2;
	GEM_EFFECT[3] = Enchase_Effect3;
	
	Enchase_Cost[1] = 5000
	Enchase_Cost[2] = 6000
	Enchase_Cost[3] = 7000
	Enchase_Cost[4] = 8000
	Enchase_Cost[5] = 9000
	Enchase_Cost[6] = 10000
	Enchase_Cost[7] = 11000
	Enchase_Cost[8] = 12000
	Enchase_Cost[9] = 13000
	
	EquipGemTable[0] = { 1, 2, 3, 4, 21 }
	EquipGemTable[1] = { 11, 12, 13, 14 }
	EquipGemTable[2] = { 11, 12, 13, 14 }
	EquipGemTable[3] = { 11, 12, 13, 14 }
	EquipGemTable[4] = { 11, 12, 13, 14 }
	EquipGemTable[5] = { 11, 12, 13, 14 }
	EquipGemTable[6] = { 1, 2, 3, 4, 21 }
	EquipGemTable[7] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	EquipGemTable[11] = { 1, 2, 3, 4, 21 }
	EquipGemTable[12] = { 1, 2, 3, 4, 21 }
	EquipGemTable[13] = { 1, 2, 3, 4, 21 }
	EquipGemTable[14] = { 1, 2, 3, 4, 21 }
	EquipGemTable[15] = { 11, 12, 13, 14 }
	EquipGemTable[17] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	EquipGemTable[18] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }
	
	g_Enchase_Frame_UnifiedPosition=Enchase_Frame:GetProperty("UnifiedPosition");
end

function Enchase_Closed()
	LifeAbility : Enchase_CloseMsgBox();
end

function Enchase_OnEvent(event)
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			Enchase_Cancel_Clicked()
		end

--	elseif ( event == "OPEN_COMPOSE_GEM" ) then
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 19830424 ) then
--		if this:IsVisible() then
--			Enchase_Close();
--			return;
--		end
		Enchase_Close();
		this:Show();

		Enchase_Effect1:Hide();
		Enchase_Effect2:Hide();
		Enchase_Effect3:Hide();

		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return;
		end
		BeginCareObject_Enchase(objCared)
		return

	elseif ( event == "UPDATE_COMPOSE_GEM" and this:IsVisible() ) then
		Enchase_Update(arg0,arg1);
--Î¤ÇàËµ²»Òª
--	elseif (event == "UPDATE_COMPOSE_ITEM" and this:IsVisible()) then
--		Prescr_Ability = tonumber(arg0);
--		local popup = Player:GetAbilityInfo(Prescr_Ability,"popup");
--		if(popup < 2) then
--			Enchase_Close();
--			return
--		end
--	elseif ( event == "OPEN_COMPOSE_ITEM" and this:IsVisible()) then
--		Enchase_Close();
--		return;
-------------------------------------------------
--ÑîÒ«µÄÉè¼Æ£¬ÁõÌúËµ²»Òª£¬ËùÒÔ×¢ÊÍµôÒÔÏÂ¼¸ÐÐ´úÂë
--	elseif ( event == "TOGLE_SKILL_BOOK" and this:IsVisible()) then
--		Enchase_Close();
--		return;
--	elseif ( event == "TOGLE_COMMONSKILL_PAGE" and this:IsVisible()) then
--		Enchase_Close();
--		return;
--	elseif ( event == "CLOSE_SKILL_BOOK"and this:IsVisible() ) then
--		Enchase_Close();
--		return;
--------------------------------------------------
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
    --ÓÐÈÎºÎ¶«Î÷¸Ä±ä¶¼ÒªÖØÖÃ
    LastZhuangbei = -1;
	  LastBaoshi = -1;
	  LastCharm = -1;
	  LastOdds = -1;
	
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		
		if( arg0~= nil ) then
			local cancleMsgBox = 1;
			if (GEM_QUALITY[1] == tonumber(arg0) ) then
				Enchase_Resume_Gem(25)
			elseif ( GEM_QUALITY[2] == tonumber(arg0) ) then
				Enchase_Resume_Gem(26)
			elseif ( GEM_QUALITY[3] == tonumber(arg0) ) then
				Enchase_Resume_Gem(27)
			elseif ( GEM_QUALITY[4] == tonumber(arg0) ) then
				Enchase_Resume_Gem(28)	
			else
				cancleMsgBox = 0;
			end
			if(cancleMsgBox == 1)then
				Enchase_Closed();
			end
		end
	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		Enchase_Close();
		return;
	elseif ( event == "DISABLE_ENCHASE_ALL_GEM" ) then
		DisableAllGem();
		Enchase_Closed();
		return;
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			Enchase_Resume_Gem(tonumber(arg0));
			Enchase_Closed();
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
		
	elseif (event == "ADJEST_UI_POS" ) then
		Enchase_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Enchase_Frame_On_ResetPos()
		
	end

end

function Enchase_OnShown()
	Enchase_Clear();
	Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
end

function Enchase_Clear()
--	if Enchase_Item ~= -1 then
--		Enchase_Item:SetActionItem(-1);
--		LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
--		Enchange_Item1 = -1
--	end
	for i=1,4 do 
		if GEM_QUALITY[i] ~= -1 then
			GEM_BUTTONS[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(GEM_QUALITY[i],0);
			GEM_QUALITY[i] = -1
		end
	end
	
	for i = 1,3 do
		GEM_EFFECT[i] : Hide();
	end
	Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
	Enchase_Explain : SetText("")
	Update_Rate()
	
	LastZhuangbei = -1;
	LastBaoshi = -1;
	LastCharm = -1;
	LastOdds = -1;

end

function Enchase_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");
	
	Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
	
	if theAction:GetID() ~= 0 then

			
			AxTrace(0,0,"GEM_QUALITY[1]="..GEM_QUALITY[1])
			if u_index == 1 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint == 16 then --?????
					if EquipPoint ~= -1 then
						PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
					end
					return
				end
				local gem_count = LifeAbility : GetEquip_GemCount(i_index);

				if GEM_QUALITY[2] ~= -1 then
					local gem_count = LifeAbility : GetEquip_GemCount(i_index);
					local gem_level = LifeAbility : Get_Gem_Level(GEM_QUALITY[2],1);
					local gem_type  = LifeAbility : Get_Gem_Level(GEM_QUALITY[2],2);
					if gem_count < 0 then
						return
					end
					if gem_level <= 0 then
						Enchase_Resume_Gem(26)
						return
					end
					if not EquipGemTable[EquipPoint] then
						PushDebugMessage("Trang b¸ không th¬ khäm")
						return
					end
				
					local passFlag = 0
					for i, gt in EquipGemTable[EquipPoint] do
						if gt == gem_type then
							passFlag = 1
							break
						end
					end
					
					if passFlag == 0 then
						PushDebugMessage("Bäo thÕch không th¬ khäm trang b¸ loÕi này!")
						return
					end
					
					if gem_count == 3 then
--						PushDebugMessage("ÎÞ·¨ÏâÇ¶¸ü¶à±¦Ê¯")
						Enchase_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_DemandMoney : SetProperty("MoneyNumber", Enchase_Cost[gem_level]*(gem_count+1));
					end
					
					
				end
				if GEM_QUALITY[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY[u_index],0);
				end
				GEM_BUTTONS[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY[u_index] = i_index
				
				for i=1,3 do
					szIconName = LifeAbility : GetEquip_Gem(GEM_QUALITY[1], i-1);
					if szIconName and szIconName ~= "" then
						GEM_EFFECT[i] : SetProperty("ShortImage", szIconName);
						GEM_EFFECT[i] : Show();
					else
						GEM_EFFECT[i] : Hide();
					end
				end
				
			elseif u_index == 2 then
				local gem_level = LifeAbility : Get_Gem_Level(i_index,1);
				if gem_level <= 0 then
					return
				end
				local gem_type  = LifeAbility : Get_Gem_Level(i_index,2);
				local EquipPoint = LifeAbility : Get_Equip_Point(GEM_QUALITY[1])
				if(tonumber(EquipPoint)== INVALID_ID) then
					PushDebugMessage("Xin hãy ð£t trang b¸ c¥n khäm nÕm vào!")
					Enchase_Resume_Gem(25)
					return;
				end
				if not EquipGemTable[EquipPoint] then
					PushDebugMessage("Trang b¸ không th¬ khäm")
					Enchase_Resume_Gem(25)
					return
				end
				
				local passFlag = 0
				for i, gt in EquipGemTable[EquipPoint] do
					if gt == gem_type then
						passFlag = 1
						break
					end
				end
					
				if passFlag == 0 then
					PushDebugMessage("Bäo thÕch không th¬ khäm trang b¸ loÕi này!")
					return
				end
				
				if GEM_QUALITY[1] ~= -1 then
					local gem_count = LifeAbility : GetEquip_GemCount( GEM_QUALITY[1]);
					if gem_count < 0 then
						Enchase_Resume_Gem(25)
						return
					end
					if gem_count == 3 then
--						PushDebugMessage("ÎÞ·¨ÏâÇ¶¸ü¶à±¦Ê¯")
						Enchase_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_DemandMoney : SetProperty("MoneyNumber", Enchase_Cost[gem_level]*(gem_count+1));
					end
				end
				
				if GEM_QUALITY[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY[u_index],0);
				end
				GEM_BUTTONS[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY[u_index] = i_index
			elseif u_index == 3 then
				if PlayerPackage : GetItemTableIndex( i_index ) == 30900009 then
					Enchase_Explain : SetText("#cFF0000Thành công: 50%")
				elseif PlayerPackage : GetItemTableIndex( i_index ) == 30900010 then
					Enchase_Explain : SetText("#cFF0000Thành công: 75%")
				else
					PushDebugMessage("Phäi ð£t #{_ITEM30900009} ho£c #{_ITEM30900010} vào.")
					return
				end
				if GEM_QUALITY[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY[u_index],0);
				end
				GEM_BUTTONS[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY[u_index] = i_index
			elseif u_index == 4 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900011 then
					PushDebugMessage("Phäi ð£t #{_ITEM30900011} vào.")
					return
				end
				if GEM_QUALITY[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY[u_index],0);
				end
				GEM_BUTTONS[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY[u_index] = i_index				
				
			end
	else
			if i_index == 1 then
				GEM_EFFECT[i] : Hide();
			end
			GEM_BUTTONS[u_index]:SetActionItem(-1);			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY[u_index],0);		
			GEM_QUALITY[u_index] = -1;
	end
	Update_Rate()
	Enchase_Closed();
end

function Enchase_Buttons_Clicked()
--local LastBaoshi = -1;
--local LastZhuangbei = -1;
	local Notify = 0;

	if(LastZhuangbei ~= GEM_QUALITY[1] or LastBaoshi ~=	GEM_QUALITY[2]
	    or LastCharm ~= GEM_QUALITY[3] or LastOdds ~= GEM_QUALITY[4]) then
	--×°±¸ ±¦Ê¯ ÏâÇ¶·û ¼¸ÂÊÖ®Öé ±äÁË
	  LastZhuangbei = GEM_QUALITY[1];
	  LastBaoshi = GEM_QUALITY[2];
	  LastCharm = GEM_QUALITY[3];
	  LastOdds = GEM_QUALITY[4];		
		Notify = 1;		
	end
	
	if(Notify == 1) then
	  local ZhuangbeiBind = 0
	  local BaoshiBind = 0
	  local CharmBind = 0
	  local OddsBind = 0
	  
	  if(GEM_QUALITY[1] ~= -1) then
	    ZhuangbeiBind = Enchase_IsBind(GEM_QUALITY[1])
	  end
	  if(GEM_QUALITY[2] ~= -1) then
	    BaoshiBind = Enchase_IsBind(GEM_QUALITY[2])
	  end
	  if(GEM_QUALITY[3] ~= -1) then
	    CharmBind = Enchase_IsBind(GEM_QUALITY[3])
	  end
	  if(GEM_QUALITY[4] ~= -1) then
	    OddsBind = Enchase_IsBind(GEM_QUALITY[4])
	  end
	  
	  local equipTableIndex = PlayerPackage : GetItemTableIndex( GEM_QUALITY[1] )

  	  if(BaoshiBind == 1 or CharmBind == 1 or OddsBind ==1) then
		  -- Èç¹û ±¦Ê¯ ÏâÇ¶·û ¼¸ÂÊÖ®Öé ÈÎÒâÒ»ÏîÊÇ°ó¶¨µÄ

		  if(ZhuangbeiBind == 1) then
  			  --Èç¹û×°±¸ÊÇ°ó¶¨µÄ
			  ShowSystemInfo("GEM_ENCHASE_001");
			  return;
		  elseif(ZhuangbeiBind == 0) then
  			  --Èç¹û×°±¸ÊÇ²»°ó¶¨µÄ

		  	  -- ñÒÉÙÎ¢£¬2008.7.1¡£ÖØÂ¥½ä¡¢ÖØÂ¥ÓñµÄ»úÖÆÐÞ¸Ä£º1¡¢¿ÉÒÔ´ò¿×£»2¡¢¿ÉÒÔÏâÇ¶±¦Ê¯£¬µ«Ö»ÄÜÏâÇ¶²»°ó¶¨µÄ±¦Ê¯
			  -- Íõ¹Ú 2009-12-11 13:38:04 ÆäËû²ÄÁÏÒ²²»¿ÉÒÔÎª°ó¶¨
			  --ÐÂÔöÐÞ¸Ä ·Ç°ó¶¨µÄÖØÂ¥¿ÉÊÇÊ¹ÓÃ°ó¶¨µÄ²ÄÁÏ
			--   if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
			-- 	  ShowSystemInfo("CLBD_091211_10");
			-- 	  return
			--   end
			  if equipTableIndex ~= 10422016 and 
			  		equipTableIndex ~= 10423024 then
			  	ShowSystemInfo("GEM_ENCHASE_002");
				return;
			  end
		  end
	  end

	end
	
	
	if GEM_QUALITY[1] == -1 then
		PushDebugMessage("Hãy ð£t trang b¸ c¥n khäm vào!")
		return
	end
	
	if GEM_QUALITY[2] == -1 then
		PushDebugMessage("Hãy ð£t bäo thÕch c¥n khäm vào!")
		return
	end
	
	local Item_3=-1
	local Item_4=-1
	if GEM_QUALITY[3] ~= -1 then 
		Item_3 = PlayerPackage : GetItemTableIndex( GEM_QUALITY[3] )
	else
		PushDebugMessage("B.ThÕch Khäm NÕm Phù")
		return
	end
	
	if GEM_QUALITY[4] ~= -1 then 
	 Item_4 = PlayerPackage : GetItemTableIndex( GEM_QUALITY[4] )
	end
	
	if (Item_3 ~= 30900009 and Item_3 ~= 30900010 ) or 
			(Item_4 ~= 30900011) then
			if SuccRate ~= 100 then
				LifeAbility:Enchase_Confirm(GEM_QUALITY[1],GEM_QUALITY[2],GEM_QUALITY[3],GEM_QUALITY[4]);
				return
			end
	end

	LifeAbility : Do_Enchase(GEM_QUALITY[1],GEM_QUALITY[2],GEM_QUALITY[3],GEM_QUALITY[4]);
	Enchase_Close()
end

function Enchase_Close()
	this:Hide()
end

function Enchase_Cancel_Clicked()
	Enchase_Close();
	return;
end

function Enchase_OnHidden()
	StopCareObject_Enchase(objCared)
	Enchase_Clear()
	Enchase_Closed()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Enchase(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Enchase");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Enchase(objCaredId)
	this:CareObject(objCaredId, 0, "Enchase");
	g_Object = -1;

end

function Enchase_Resume_Gem(nIndex)
	if nIndex < 25 or nIndex > 28 then
		return
	end

	nIndex = nIndex - 24
	if( this:IsVisible() ) then
		if GEM_QUALITY[nIndex]~=nil and GEM_QUALITY[nIndex] ~= -1 then
			GEM_BUTTONS[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY[nIndex],0);
			GEM_QUALITY[nIndex] = -1
			if nIndex == 1 then
				for i = 1,3 do
					GEM_EFFECT[i] : Hide();
				end
				Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
			elseif nIndex == 2 then
				Enchase_DemandMoney : SetProperty("MoneyNumber", 0);
			end
		end
	end
	Update_Rate()
end

function Update_Rate()
	Enchase_Explain : SetText("#cFF0000Thành công: 25%")
	SuccRate = 25;
	if GEM_QUALITY[3] ~= -1 then
		if PlayerPackage : GetItemTableIndex( GEM_QUALITY[3] ) == 30900009 then
			Enchase_Explain : SetText("#cFF0000Thành công: 50%")
			SuccRate = 50;
		elseif PlayerPackage : GetItemTableIndex( GEM_QUALITY[3] ) == 30900010 then
			Enchase_Explain : SetText("#cFF0000Thành công: 100%")
			SuccRate = 100;
		end
	end
	Enchase_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
end

function Enchase_IsBind( ItemID )

	if(GetItemBindStatus(ItemID) == 1) then
		
		return 1;
		
	else
	
		return 0;
		
	end
	
end

function Enchase_Frame_On_ResetPos()
  Enchase_Frame:SetProperty("UnifiedPosition", g_Enchase_Frame_UnifiedPosition);
end
