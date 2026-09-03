local Current = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Bind_Item1 = -1
local Bind_Item2 = -1
local g_Object = -1;

local LastItem1 = -1;
local LastItem2 = -1;

local g_EquipBind_Frame_UnifiedPosition;

function EquipBind_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_EQUIPBIND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function EquipBind_OnLoad()

	g_EquipBind_Frame_UnifiedPosition=EquipBind_Frame:GetProperty("UnifiedPosition");

end

function EquipBind_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1005) then
		if this:IsVisible() then
			EquipBind_Close();
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
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
		BeginCareObject_EquipBind(objCared)
	elseif ( event == "UPDATE_EQUIPBIND" ) then
		if arg0~= nil then
			EquipBind_Update(arg0,arg1)
			
		end	
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipBind_Resume_Gem(tonumber(arg0));
			
		end
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			EquipBind_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Bind_Item1 == tonumber(arg0) ) then
				EquipBind_Resume_Gem(31)			
			end
			if (Bind_Item2 == tonumber(arg0) ) then
				EquipBind_Resume_Gem(32)			
			end
			
		end
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw

		LastItem1 = -1;
		LastItem2 = -1;
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
	elseif (event == "ADJEST_UI_POS" ) then
		EquipBind_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipBind_Frame_On_ResetPos()
	end


end

function EquipBind_OnShown()
	EquipBind_Clear();
end

function EquipBind_Clear()
	if Bind_Item1 ~= -1 then
		EquipBind_MainItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item1,0);
		Bind_Item1 = -1

	end
	if Bind_Item2 ~= -1 then
		EquipBind_OtherItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item2,0);
		Bind_Item2 = -1
	end
	EquipBind_NeedMoney:SetProperty("MoneyNumber", "");
		
	LastItem1 = -1;
	LastItem2 = -1;
end

function EquipBind_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint == 18 then
					if EquipPoint ~= -1 then
						PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
					end
					return
				end
				if EquipPoint >= 19 and EquipPoint <= 24 then
					PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
					return
				end
				if Bind_Item2 ~= -1 and PlayerPackage : GetItemTableIndex( i_index ) == 10124391 and 
					GetItemBindStatus( i_index ) == 0 and GetItemBindStatus( Bind_Item2 ) ~= GetItemBindStatus( i_index ) then
					PushDebugMessage("#{HCWL_220624_04}")
					return
				end
				
				local nItemId = PlayerPackage : GetItemTableIndex( i_index )
				local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemId, "Number")
				if Bind_Item2 ~= -1 and nFashionNumber > 0 and 
					GetItemBindStatus( i_index ) == 0 and GetItemBindStatus( Bind_Item2 ) ~= GetItemBindStatus( i_index ) then
					PushDebugMessage("#{SZBH_231103_24}")
					return
				end
				if Bind_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				end
				EquipBind_MainItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item1 = i_index
				local equip_level = LifeAbility : Get_Equip_Level(i_index);
				local equip_point = LifeAbility : Get_Equip_Point(i_index);
				local needmoney
				
				if equip_point == 0 or equip_point == 2 then
					needmoney = 500 + equip_level * 200
				else
					needmoney = 250 + equip_level * 100
				end
				
				EquipBind_NeedMoney:SetProperty("MoneyNumber", tostring(needmoney));
		else
				EquipBind_MainItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);		
				Bind_Item1 = -1;
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900013 and
					 PlayerPackage : GetItemTableIndex( i_index ) ~= 30900014 then
					PushDebugMessage("C¥n ð£t Kh¡c Danh Phù vào")
					return
				end
				if Bind_Item1 ~= -1 and PlayerPackage : GetItemTableIndex( Bind_Item1 ) == 10124391 and 
					GetItemBindStatus( Bind_Item1 ) == 0 and GetItemBindStatus( Bind_Item1 ) ~= GetItemBindStatus( i_index ) then
					PushDebugMessage("#{HCWL_220624_04}")
					return
				end
				local nItemId = PlayerPackage : GetItemTableIndex( Bind_Item1 )
				local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemId, "Number")
				if Bind_Item1 ~= -1 and nFashionNumber > 0 and 
					GetItemBindStatus( Bind_Item1 ) == 0 and GetItemBindStatus( Bind_Item1 ) ~= GetItemBindStatus( i_index ) then
					PushDebugMessage("#{SZBH_231103_24}")
					return
				end
				
				if Bind_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				end
				EquipBind_OtherItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item2 = i_index
		else
				EquipBind_OtherItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);		
				Bind_Item2 = -1;
		end
	end

	LastItem1 = -1;
	LastItem2 = -1;
end

function EquipBind_Buttons_Clicked()
	--AxTrace(0,5,"Bind_Item1="..Bind_Item1.." Bind_Item2="..Bind_Item2)
	
	if Bind_Item1 == -1 then 
		PushDebugMessage("Hãy ð£t trang b¸ c¥n kh¡c vào!")
		return
	end
	if Bind_Item2 == -1 then
		PushDebugMessage("Hãy ð£t Kh¡c Danh Phù vào.")
		return
	end
	if PlayerPackage : GetItemTableIndex( Bind_Item1 ) == 10124391 and 
		GetItemBindStatus( Bind_Item1 ) == 0 and GetItemBindStatus( Bind_Item1 ) ~= GetItemBindStatus( Bind_Item2 ) then
		PushDebugMessage("#{HCWL_220624_04}")
		return
	end	
	local nItemId = PlayerPackage : GetItemTableIndex( Bind_Item1 )
	local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nItemId, "Number")
	if nFashionNumber > 0 and 
		GetItemBindStatus( Bind_Item1 ) == 0 and GetItemBindStatus( Bind_Item1 ) ~= GetItemBindStatus( Bind_Item2 ) then
		PushDebugMessage("#{SZBH_231103_24}")
		return
	end	
	-- Èç¹û×°±¸ÊÇ·Ç°ó¶¨£¬¶ø¿ÌÃú·ûÊÇ°ó¶¨
	if( Bind_Item1 and Bind_Item2 and GetItemBindStatus( Bind_Item1 ) == 0 and GetItemBindStatus( Bind_Item2 ) == 1 ) then
		-- ¿´×°±¸ÊÇ·ñ±äÁË£¬Èç¹ûÃ»ÓÐ±ä±íÊ¾ÉÏ´ÎÒÑ¾­ÌáÐÑ¹ýÁË
		if ( LastItem1 ~= Bind_Item1 ) or ( LastItem2 ~= Bind_Item2 ) then
			LastItem1 = Bind_Item1;
			LastItem2 = Bind_Item2;
			ShowSystemInfo("QZBDDJ_090901_01");
			return
		end		
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("FinishBind");
		Set_XSCRIPT_ScriptID(809266);
		Set_XSCRIPT_Parameter(0,Bind_Item1);
		Set_XSCRIPT_Parameter(1,Bind_Item2);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function EquipBind_Close()
	this:Hide()
end

function EquipBind_Cancel_Clicked()
	EquipBind_Close();
	return;
end

function EquipBind_OnHiden()
	StopCareObject_EquipBind(objCared)
	EquipBind_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_EquipBind(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipBind");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_EquipBind(objCaredId)
	this:CareObject(objCaredId, 0, "EquipBind");
	g_Object = -1;

end

function EquipBind_Resume_Gem(nIndex)
	if nIndex < 31 or nIndex > 32 then
		return
	end

	nIndex = nIndex - 30
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Bind_Item1 ~= -1 then
				EquipBind_MainItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				Bind_Item1 = -1
				EquipBind_NeedMoney:SetProperty("MoneyNumber", 0);
			end
		else
			if Bind_Item2 ~= -1 then
				EquipBind_OtherItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				Bind_Item2 = -1
			end
		end
	end
	
	LastItem1 = -1;
	LastItem2 = -1;
end

function EquipBind_Frame_On_ResetPos()
  EquipBind_Frame:SetProperty("UnifiedPosition", g_EquipBind_Frame_UnifiedPosition);
end
