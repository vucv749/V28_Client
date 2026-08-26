local Current = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Bind_Item1 = -1
local Bind_Item2 = -1
local g_Object = -1;

function EquipUnBind_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_EQUIPUNBIND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function EquipUnBind_OnLoad()

end

function EquipUnBind_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1006) then
		if this:IsVisible() then
			EquipUnBind_Close();
		end
		this:Show();
		
		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return;
		end
		EquipUnBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipUnBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
		BeginCareObject_EquipUnBind(objCared)
	elseif ( event == "UPDATE_EQUIPUNBIND" ) then
		if arg0~= nil then
			EquipUnBind_Update(arg0,arg1)
			
		end	
		EquipUnBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipUnBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipUnBind_Resume_Gem(tonumber(arg0));
			
		end
		EquipUnBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipUnBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			EquipUnBind_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Bind_Item1 == tonumber(arg0) ) then
				EquipUnBind_Resume_Gem(51)			
			end
			if (Bind_Item2 == tonumber(arg0) ) then
				EquipUnBind_Resume_Gem(52)			
			end
			
		end
		EquipUnBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipUnBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipUnBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipUnBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end


end

function EquipUnBind_OnShown()
	EquipUnBind_Clear();
end

function EquipUnBind_Clear()
	if Bind_Item1 ~= -1 then
		EquipUnBind_MainItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item1,0);
		Bind_Item1 = -1

	end
	if Bind_Item2 ~= -1 then
		EquipUnBind_OtherItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item2,0);
		Bind_Item2 = -1
	end
	EquipUnBind_NeedMoney:SetProperty("MoneyNumber", "");
end

function EquipUnBind_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
					if EquipPoint ~= -1 then
						PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
					end
					return
				end
				if Bind_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				end
				EquipUnBind_MainItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item1 = i_index

				local needmoney  = 10000;
				
				EquipUnBind_NeedMoney:SetProperty("MoneyNumber", tostring(needmoney));
		else
				EquipUnBind_MainItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);		
				Bind_Item1 = -1;
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900049 then
					PushDebugMessage("N½i này phäi ð¬ vào Tr× Minh Phù.")
					return
				end
				if Bind_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				end
				EquipUnBind_OtherItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item2 = i_index
		else
				EquipUnBind_OtherItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);		
				Bind_Item2 = -1;
		end
	end

end

function EquipUnBind_Buttons_Clicked()
	if Bind_Item1 == -1 then 
		PushDebugMessage("Thñc xin l²i, Thïnh Tiên ð¬ vào Nhî Tß·ng kh¡c minh Ðích trang b¸.")
		return
	end
	if Bind_Item2 == -1 then
		PushDebugMessage("Trang b¸ Tr× Minh c¥n Tr× Minh Phù.")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("FinishUnBind");
		Set_XSCRIPT_ScriptID(809266);
		Set_XSCRIPT_Parameter(0,Bind_Item1);
		Set_XSCRIPT_Parameter(1,Bind_Item2);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function EquipUnBind_Close()
	this:Hide()
end

function EquipUnBind_Cancel_Clicked()
	EquipUnBind_Close();
	return;
end

function EquipUnBind_OnHiden()
	StopCareObject_EquipUnBind(objCared)
	EquipUnBind_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_EquipUnBind(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipUnBind");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_EquipUnBind(objCaredId)
	this:CareObject(objCaredId, 0, "EquipUnBind");
	g_Object = -1;

end

function EquipUnBind_Resume_Gem(nIndex)
	if nIndex < 51 or nIndex > 52 then
		return
	end

	nIndex = nIndex - 50
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Bind_Item1 ~= -1 then
				EquipUnBind_MainItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				Bind_Item1 = -1
				EquipUnBind_NeedMoney:SetProperty("MoneyNumber", 0);
			end
		else
			if Bind_Item2 ~= -1 then
				EquipUnBind_OtherItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				Bind_Item2 = -1
			end
		end
	end
	
end
