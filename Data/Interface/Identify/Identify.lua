--0 ¼ø¶¨×°±¸×ÊÖÊ
--1 ÖØÐÂ¼ø¶¨×°±¸×ÊÖÊ
local Current = 0;
local Identify_Item = -1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Tb_idx = 30008034;
local jingangcuo_id = 30008048;
local g_Object = -1;

local g_Identify_Frame_UnifiedPosition;

function Identify_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_IDENTIFY")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Identify_OnLoad()

	g_Identify_Frame_UnifiedPosition=Identify_Frame:GetProperty("UnifiedPosition");
end

function Identify_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
	
			if tonumber(arg0) == 1001 then
				Current = 0;
				Identify_Title:SetText( "#{INTERFACE_XML_93}" );
				Identify_Info:SetText( "#{INTERFACE_XML_883}" );
				Identify_Info2:SetText( "#{INTERFACE_XML_506}" );
			elseif tonumber(arg0) == 112233 then
				Current = 1;
				Identify_Title:SetText( "#gFF0FA0Giám ð¸nh lÕi tß ch¤t trang b¸" );
				Identify_Info:SetText( "#{INTERFACE_XML_987}" );
				Identify_Info2:SetText( "Ð£t trang b¸ vào ô này!" );
			else
				return;
			end
			
			if this:IsVisible() then
				Identify_Close();
			end

			this:Show();
			objCared = -1
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
					return;
			end
			local playerMoney = Player:GetData("MONEY");
			Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
			--zchw
			Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		BeginCareObject_Identify(objCared)
	elseif  ( event == "UPDATE_IDENTIFY" ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if arg0~= nil then
			Identify_Update(arg0)

		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if(arg0~=nil and tonumber(arg0) == 20 ) then
			Identify_Resume_Equip_Gem(1)
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			Identify_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil and Current~=1) then	--??????????????....??????....
			if (Identify_Item == tonumber(arg0) ) then
				Identify_Resume_Equip_Gem(1)			
			end
		end
		if( arg0~= nil and Current==1) then
			--if (Identify_Item == tonumber(arg0) ) then
				--if(PlayerPackage:IsLock(tonumber(Identify_Item)) == 1) then
					--Identify_Resume_Equip_Gem(1)	
					--return;
				--end
			--end
			if(tonumber(arg0) and PlayerPackage:GetItemTableIndex(tonumber(arg0)) == Tb_idx) then
				if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
					--pushÊÂ¼þ¸Éµômsgbox
					LifeAbility:CloseReIdentifyMsgBox();
					return;
				end
			end
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Identify_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Identify_DemandJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif (event == "ADJEST_UI_POS" ) then
		Identify_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Identify_Frame_On_ResetPos()
		
	end


end

function Identify_OnShown()
	Identify_Clear();
end

function Identify_Clear()
	if Identify_Item ~= -1 then
		Identify_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Identify_Item,0);
		Identify_Item = -1
		--pushÊÂ¼þ¸Éµômsgbox
		LifeAbility:CloseReIdentifyMsgBox();
		Identify_DemandMoney : SetProperty("MoneyNumber", 0);
	end

end

function Identify_Update(Item_index)
	local index = tonumber(Item_index)
	local theAction = EnumAction(index, "packageitem");
	
	if theAction:GetID() ~= 0 then
	
			-- ¼ì²éÊÔÍ¼·ÅÈëµÄÊÇ·ñÎª äÊÞ×°±¸
			local PetEquipPoint = LifeAbility:Is_PetEquip(index)
			if PetEquipPoint ~= -1 then
				if Current == 0 then
					PushDebugMessage("#{ZSZB_0629_04}")
				elseif Current == 1 then
					PushDebugMessage("#{ZSZB_0629_05}")
				end
				return
			end


			local EquipPoint = LifeAbility : Get_Equip_Point(index)
			if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 
			or PlayerPackage:IsBagItemKFS(index) ==1 then --?????
				if EquipPoint ~= -1 then
					PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
				end
				return
			end
			
			if EquipPoint >= 19 and EquipPoint <= 24 then
				PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
				return
			end
			
			if Current == 1 then			
				local haveIndentify = LifeAbility:IsIndentify(index)
				if haveIndentify ~= 1 then
					PushDebugMessage("Trang b¸ các hÕ chßa giám ð¸nh, hãy ch÷n giám ð¸nh trß¾c")
					return
				end
			end
			
			
			if Identify_Item ~= -1 then
				LifeAbility : Lock_Packet_Item(Identify_Item,0);
			end
			--pushÊÂ¼þ¸Éµômsgbox
			LifeAbility:CloseReIdentifyMsgBox();
			Identify_Object:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(index,1);
			Identify_Item = index
			local Equip_Level = LifeAbility : Get_Equip_Level(index);
			local NeedMoney 
			
			if Current == 0 then
				if Equip_Level >= 1 and Equip_Level <= 9 then
						NeedMoney = 10 
					elseif Equip_Level >= 10 and Equip_Level <= 19 then
						NeedMoney = 100 
					elseif Equip_Level >= 20 and Equip_Level <= 29 then
						NeedMoney = 1000 
					elseif Equip_Level >= 30 and Equip_Level <= 39 then
						NeedMoney = 3000 
					elseif Equip_Level >= 40 and Equip_Level <= 49 then
						NeedMoney = 4000 
					elseif Equip_Level >= 50 and Equip_Level <= 59 then
						NeedMoney = 5000 
					elseif Equip_Level >= 60 and Equip_Level <= 69 then
						NeedMoney = 6000 
					elseif Equip_Level >= 70 and Equip_Level <= 79 then
						NeedMoney = 7000 
					elseif Equip_Level >= 80 and Equip_Level <= 89 then
						NeedMoney = 8000 
					elseif Equip_Level >= 90 and Equip_Level <= 99 then
						NeedMoney = 10000 
					elseif Equip_Level < 110 then
						NeedMoney = 20000
					elseif Equip_Level < 120 then
						NeedMoney = 30000
					else
						NeedMoney = 40000
					end
					
			elseif Current == 1 then
				NeedMoney = Equip_Level * 20 + 50;
			end
			
			Identify_DemandMoney : SetProperty("MoneyNumber", tostring(NeedMoney));
			
	else
			Identify_Object:SetActionItem(-1);			
			LifeAbility : Lock_Packet_Item(Identify_Item,0);		
			Identify_Item = -1;
			--pushÊÂ¼þ¸Éµômsgbox
			LifeAbility:CloseReIdentifyMsgBox();
	end
	
end
local EB_FREE_BIND = 0;				-- ?????
local EB_BINDED = 1;				-- ????
local	EB_GETUP_BIND =2			-- ????
local	EB_EQUIP_BIND =3			-- ????
function Identify_Buttons_Clicked()
	if Identify_Item ~= -1 and PlayerPackage : GetItemTableIndex( Identify_Item ) ~= -1 then
		
		if Current == 0 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishAdjust");
				Set_XSCRIPT_ScriptID(809261);
				Set_XSCRIPT_Parameter(0,Identify_Item);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
		elseif Current == 1 then
			local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Tb_idx));
			local index2,BindState2 = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(jingangcuo_id));
			if(index == -1 and index2 == -1)then
				local str = "Thiªu #{_Item"..Tb_idx.."} ho£c #{_ITEM"..jingangcuo_id.."}, ho£c ðã b¸ khóa.";
				PushDebugMessage(str);
				return
			end
			if(BindState == EB_BINDED or BindState2 == EB_BINDED)then
				--Èç¹ûÒÑ°ó¶¨
				local tmp = PlayerPackage:GetItemBindStatusByIndex(Identify_Item);
				if(tmp == EB_BINDED)then
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("FinishReAdjust");
						Set_XSCRIPT_ScriptID(809261);
						Set_XSCRIPT_Parameter(0,Identify_Item);
						Set_XSCRIPT_ParamCount(1);
					Send_XSCRIPT();
				else
					PlayerPackage:OpenReIdentifyMsgBox(tonumber(Identify_Item));
				end
			else
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("FinishReAdjust");
					Set_XSCRIPT_ScriptID(809261);
					Set_XSCRIPT_Parameter(0,Identify_Item);
					Set_XSCRIPT_ParamCount(1);
				Send_XSCRIPT();
			end
		end

	else
		PushDebugMessage("Nh§p trang b¸ mu¯n giám ð¸nh tß ch¤t vào.")
	end
end

function Identify_Close()
	this:Hide()
end

function Identify_Cancel_Clicked()
	Identify_Close();
	return;
end

function Identify_OnHiden()
	StopCareObject_Identify(objCared)
	Identify_Clear()
	return
end

--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_Identify(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Identify");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_Identify(objCaredId)
	this:CareObject(objCaredId, 0, "Identify");
	g_Object = -1;

end

function Identify_Resume_Equip_Gem(nIndex)

	if( this:IsVisible() ) then
		if nIndex == 1 then
			if(Identify_Item ~= -1) then
				LifeAbility : Lock_Packet_Item(Identify_Item,0);
				Identify_Object : SetActionItem(-1);
				Identify_Item	= -1;
				Identify_DemandMoney : SetProperty("MoneyNumber", 0);
				--pushÊÂ¼þ¸Éµômsgbox
				LifeAbility:CloseReIdentifyMsgBox();
			end
		end
	end

end

function Identify_Frame_On_ResetPos()
  Identify_Frame:SetProperty("UnifiedPosition", g_Identify_Frame_UnifiedPosition);
end
