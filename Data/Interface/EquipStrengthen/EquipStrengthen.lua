local Enchange_Item1 = -1;
local Enchange_Item2 = -1;
local g_Object = -1;
local QianghualuId = 30900045

local g_EquipStrengthen_Frame_UnifiedPosition;

function EquipStrengthen_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("PUT_STENGTHEN_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("TAKE_STENGTHEN_ITEM")
	this:RegisterEvent("MONEYJZ_CHANGE"); --zchw
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function EquipStrengthen_OnLoad()

	g_EquipStrengthen_Frame_UnifiedPosition=EquipStrengthen_Frame:GetProperty("UnifiedPosition");
end

function EquipStrengthen_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 1002 then
			EquipStrengthen_Clear();
			Init_EquipStrengthen_Frame();
			objCared = -1
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return;
			end
			this:Show();
			BeginCareObject_EquipStrengthen(objCared);
		end
	elseif  ( event == "PUT_STENGTHEN_ITEM" ) then
		if arg0~= nil then
			EquipStrengthen_Update(arg0);
		end
		local playerMoney = Player:GetData("MONEY");
		EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
		EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if(tonumber(arg0) and PlayerPackage:GetItemTableIndex(tonumber(arg0)) == Enchange_Item2) then
				if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
					--pushÊÂ¼þ¸Éµômsgbox
					LifeAbility:CloseStrengthMsgBox();
					return;
				end
		end
		if (Enchange_Item1 == tonumber(arg0)) then
			--if(PlayerPackage:IsLock(tonumber(Enchange_Item1)) == 1) then
				--EquipStrengthen_Clear();
				--Init_EquipStrengthen_Frame();
				--return
			--end
			EquipStrengthen_Update(arg0);
		end
	elseif (event == "TAKE_STENGTHEN_ITEM") then
		EquipStrengthen_Clear();
		Init_EquipStrengthen_Frame();
		
	elseif (event == "ADJEST_UI_POS" ) then
		EquipStrengthen_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipStrengthen_Frame_On_ResetPos()
	end
end

function Init_EquipStrengthen_Frame()
	local playerMoney = Player:GetData("MONEY");
	EquipStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
	EquipStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	EquipStrengthen_Info2:Hide();
	EquipStrengthen_Info6:Hide();
	EquipStrengthen_Info5:Hide();
	EquipStrengthen_Info8:Hide();
	EquipStrengthen_Info7:Hide();
	EquipStrengthen_Info9:Hide();
end

function BeginCareObject_EquipStrengthen(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "EquipStrengthen");
end

function EquipStrengthen_Update(Item_index)
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local NeedMoney
	local Property
	
	--PushDebugMessage(tostring(Item_index));
	
	if theAction:GetID() ~= 0 then
			local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
			
			if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 
			or PlayerPackage:IsBagItemKFS(i_index) ==1 then --?????
				if EquipPoint ~= -1 then
					PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
				end
				return
			end
			
			if EquipPoint >= 19 and EquipPoint <= 24 then
				PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
				return
			end
			
			NeedMoney,Property = LifeAbility : Get_Equip_StrengthLevel(i_index);
			
			--BUG30523,alan,2007-12-29
			--½«×°±¸ÍÏµ½Ç¿»¯´°¿ÚÓëÃ¿´ÎÇ¿»¯½áÊø¶¼»áµ÷ÓÃ´Ëº¯Êý£¬9¼¶×°±¸ÊÇ²»ÔÊÐí·Åµ½Ç¿»¯´°¿ÚµÄ£¬µ«ÊÇÇ¿»¯µ½9¼¶Ê±
			--ÐèÒªÏÔÊ¾9¼¶×°±¸Ç¿»¯µÄ½á¹û£¬ âÀïÓÃÇ¿»¯´°¿ÚµÄÎïÆ·¸ñÊÇ·ñÓÐÎïÆ·À´Ê¶±ð âÁ½ÀàÇéÐÎ¡£
			--ºóÒ»ÇéÐÎÏÂ½ûÓÃOK°´Å¥
			
			if(NeedMoney<=0 or tonumber(Property)==nil or tonumber(Property)<0) then
				if Enchange_Item1 ~= -1 then
					NeedMoney = 0
					EquipStrengthen_OK:Disable()
					EquipStrengthen_Quick:Disable()
				else
					PushDebugMessage("Trang b¸ này không th¬ cß¶ng hóa.")
					return
				end
			else				
					EquipStrengthen_OK:Enable()
					EquipStrengthen_Quick:Enable()
			end

			if Enchange_Item1 ~= -1 then
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
			end
			--pushÊÂ¼þ¸Éµômsgbox
			LifeAbility:CloseStrengthMsgBox();
			EquipStrengthen_Info5:Show();
			EquipStrengthen_Info5:SetText(""..tonumber(Property).."%");
			local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
			EquipStrengthen_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item1 = i_index
			EquipStrengthen_Money : SetProperty("MoneyNumber", tostring(NeedMoney));
			
			local StrongLevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
			
			--PushDebugMessage("EquipPoint:"..tostring(EquipPoint)..",StrongLevel:"..tostring(StrongLevel))
			
			if(tonumber(StrongLevel)~=nil and tonumber(StrongLevel)>=0)then
				EquipStrengthen_Info2:Show();
				EquipStrengthen_Info6:Show();
				if(tonumber(StrongLevel) == 0)then
					EquipStrengthen_Info6:SetText("Không");
				else
					EquipStrengthen_Info6:SetText(""..tonumber(StrongLevel));
				end
			end

			local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
			--PushDebugMessage(tostring(Equip_Level));
			
			EquipStrengthen_Info8:Show();
			EquipStrengthen_Info7:Show();
			if Equip_Level < 40 then
				Enchange_Item2 = 30900005;
				EquipStrengthen_Info7 : SetText("#G#{_ITEM30900005}")
			else
				Enchange_Item2 = 30900006;
				EquipStrengthen_Info7 : SetText("#G#{_ITEM30900006}#W ho£c #G#{_ITEM30900045}")
			end
			
			EquipStrengthen_Info9:Show();
			
	else			
			return;
	end	
end

local EB_FREE_BIND = 0;				-- ?????
local EB_BINDED = 1;				-- ????
local	EB_GETUP_BIND =2			-- ????
local	EB_EQUIP_BIND =3			-- ????
function EquipStrengthen_Buttons_Clicked()
	if Enchange_Item1 == -1 then
		PushDebugMessage("Hãy ð£t 1 trang b¸ vào!")
		return
	end
	local StrongLevel = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	if StrongLevel >= 9 then
		PushDebugMessage("#{CLXZ_220623_5}")
		return
	end
	local playerMoney = Player:GetData("MONEY");
	local playerJZ = Player:GetData("MONEY_JZ")
	local NeedMoney,Property = LifeAbility : Get_Equip_StrengthLevel(Enchange_Item1);
	if  (playerMoney + playerJZ) < NeedMoney then
		PushDebugMessage("#{CLXZ_220623_6}")
		return
	end

	local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Enchange_Item2));

	--PushDebugMessage("Çë·ÅÈëÒ»¸ö×°±¸1¡£")
 --ÏÈ ÒÇ¿»¯¾«»ª
	if index == -1 and Enchange_Item2 == 30900006 then
		local index1,BindState1 = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(QianghualuId));
		--PushDebugMessage("Çë·ÅÈëÒ»¸ö×°±¸21¡£")
		if(index1 == -1)then
			local str = " C¥n #{_ITEM"..Enchange_Item2.."} ho£c #{_ITEM"..QianghualuId.."}";
		--PushDebugMessage("Çë·ÅÈëÒ»¸ö×°±¸321¡£")
			PushDebugMessage(str);
			return
		end
		
		index = index1;
		BindState =BindState1;
		Enchange_Item2 = QianghualuId;
	end
	
	if(index == -1)then
		local str =  "Thiªu #{_Item"..Enchange_Item2.."}, ho£c #{_Item"..Enchange_Item2.."} ðã khóa.";
		PushDebugMessage(str);
		return
	end
	
	if(BindState == EB_BINDED)then
		--Èç¹ûÒÑ°ó¶¨
		local tmp = PlayerPackage:GetItemBindStatusByIndex(Enchange_Item1);
		if(tmp == EB_BINDED)then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809262);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,index);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		else
			local equip_index = PlayerPackage:GetItemTableIndex( Enchange_Item1 ); 
			--ÐÂÔöÐÞ¸Ä ·Ç°ó¶¨µÄÖØÂ¥¿ÉÊÇÊ¹ÓÃ°ó¶¨µÄ²ÄÁÏ
			-- if (equip_index ==10423024) or (equip_index == 10422016) then --ÖØÂ¥Óñ£¬ÖØÂ¥½ä
			-- 	ShowSystemInfo("CLBD_091211_6");
			--   	return
			-- else
			PlayerPackage:OpenStengMsgBox(tonumber(Enchange_Item1),tonumber(index));
			-- end
		end
	else	
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809262);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,index);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		
	end
end

-- Ôª±¦¿ìËÙÇ¿»¯
-- !!!reloadscript =EquipStrengthen
function EquipStrengthen_DoQuickQiangHuaByYB()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoQuickQiangHuaByYB")
		Set_XSCRIPT_ScriptID(809262)
		Set_XSCRIPT_Parameter(0, Enchange_Item1)
		Set_XSCRIPT_Parameter(1, 0)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
		
function EquipStrengthen_Clear()
	if Enchange_Item1 ~= -1 then
		EquipStrengthen_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
		Enchange_Item1 = -1
		--pushÊÂ¼þ¸Éµômsgbox
		LifeAbility:CloseStrengthMsgBox();
	end
	Enchange_Item2 = -1
	EquipStrengthen_Money : SetProperty("MoneyNumber", 0)
end

function EquipStrengthen_OnHiden()
	EquipStrengthen_Clear();
end

function EquipStrengthen_Frame_On_ResetPos()
  EquipStrengthen_Frame:SetProperty("UnifiedPosition", g_EquipStrengthen_Frame_UnifiedPosition);
end
