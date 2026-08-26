
local Enchange_Item1 = -1
local Enchange_Item2 = -1
local g_Object = -1
local g_check = -1--??????

local g_EquipNewStrengthen_Frame_UnifiedPosition;
local EB_FREE_BIND = 0;				-- ?????
local EB_BINDED = 1;				-- ????
local EB_GETUP_BIND =2			-- ????
local EB_EQUIP_BIND =3			-- ????

local g_EquipName = {
	[0]		="Vû khí",
	[1]		="Mão",
	[2]		="Y Phøc",
	[3]		="Hµ Thü",
	[4]		="Hài"  ,
	[5]		="Yêu Ðai",
	[6]		="Gi¾i Chï",
	[7]	    ="HÕng Liên",
	[8]		="KÜ Th×a",
	[9]		="Túi",
	[10]	="Tß½ng Cách",
	[11]	="Gi¾i Chï",
	[12]	="Hµ Phù",
	[13]    ="Hµ Phù",
	[14]	="Hµ Uy¬n",
	[15]    ="Hµ Kiên",
	[16]	="Th¶i Trang",
	[17]  ="Ám Khí",
	[18]  ="Võ H°n",
	[37] ="Th¤t tình Nhçn",
	}

function EquipNewStrengthen_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)

	this:RegisterEvent("PUT_NEW_STENGTHEN_ITEM")
	this:RegisterEvent("TAKE_STENGTHEN_ITEM")
end

function EquipNewStrengthen_OnLoad()
	g_EquipNewStrengthen_Frame_UnifiedPosition=EquipNewStrengthen_Frame:GetProperty("UnifiedPosition");
end

function EquipNewStrengthen_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20130521 then
			EquipNewStrengthen_Clear(0);
			local xx = Get_XParam_INT(0);
			if tonumber(xx) == -1 then
				return
			end
			objCared = -1
			objCared = DataPool : GetNPCIDByServerID(xx);
			if tonumber(objCared)==nil or  tonumber(objCared)== -1 then
				PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
				return
			end
			this:Show()
			EquipNewStrengthen_BeginCareObject(objCared)
		end
	elseif  ( event == "PUT_NEW_STENGTHEN_ITEM" and this:IsVisible()) then
		--¸üÐÂ´°¿ÚÉÏµÄ×°±¸
		if tonumber(arg0) == 0 or tonumber(arg0) == 1 or tonumber(arg0) == 2 then
			EquipNewStrengthen_Update(arg0,arg1);
		end

		local playerMoney = Player:GetData("MONEY");
		EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw

	elseif	( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if (tonumber(Enchange_Item1) == tonumber(arg0)) then
			EquipNewStrengthen_Clear(0);
		end
		if (tonumber(Enchange_Item2) == tonumber(arg0)) then
			EquipNewStrengthen_Clear(1);
		end
	elseif (event == "TAKE_STENGTHEN_ITEM" and this:IsVisible()) then
		if arg0 == "I12" then		--????,?????????
			EquipNewStrengthen_Clear(0)
		elseif arg0 == "I13" then		--????,???????
			EquipNewStrengthen_Clear(1)
		end
	elseif (event == "ADJEST_UI_POS" ) then
		EquipNewStrengthen_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipNewStrengthen_Frame_On_ResetPos()
	elseif	( event == "UNIT_MONEY" and this:IsVisible()) then
		EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	end
end


function EquipNewStrengthen_BeginCareObject(objCared)
	g_Object = objCared;
	this:CareObject(tonumber(g_Object), 1, "EquipNewStrengthen");
end


function EquipNewStrengthen_OnHiden()
	EquipNewStrengthen_Clear(0)
	this:CareObject(tonumber(g_Object), 0, "EquipNewStrengthen");
	g_Object = -1
end

function EquipNewStrengthen_Frame_On_ResetPos()
  EquipNewStrengthen_Frame:SetProperty("UnifiedPosition", g_EquipNewStrengthen_Frame_UnifiedPosition);
end


function EquipNewStrengthen_Object1_RClicked()
	EquipNewStrengthen_Clear(0)
end

function EquipNewStrengthen_Object2_RClicked()
	EquipNewStrengthen_Clear(1)
end

function EquipNewStrengthen_Clear(pos)
	if tonumber(pos) == 0 then
		if Enchange_Item1 ~= -1 then
			EquipNewStrengthen_Object1:SetActionItem(-1)
			LifeAbility : Lock_Packet_Item(Enchange_Item1,0)
			Enchange_Item1 = -1
		end
		EquipNewStrengthen_Info4:SetText("")
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", "0")
	end
	if Enchange_Item2 ~= -1 then
		EquipNewStrengthen_Object2:SetActionItem(-1)
		LifeAbility : Lock_Packet_Item(Enchange_Item2,0)
		Enchange_Item2 = -1
	end
	EquipNewStrengthen_Info7:SetText("")

	g_check = -1;
	EquipNewStrengthen_OK:Disable()

	local playerMoney = Player:GetData("MONEY")
	EquipNewStrengthen_SelfMoney:SetProperty("MoneyNumber", playerMoney)
	EquipNewStrengthen_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
end

function EquipNewStrengthen_Update(boxpos,Item_index)

	--ÔÝÊ±Ã»ÓÐ°²È«Ê±¼äºÍÃÜ±£µÄapi
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	local msg = ""

	if tonumber(boxpos) == 0 then
		-- ÅÐ¶Ï×ó±ßµÄ
		local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint == -1 then	--??????,?????????????
			return
		end
		if EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint > 37 then
			return
		end
		if PlayerPackage:IsBagItemKFS(i_index) ==1 then  --?????
			PushDebugMessage("#{ZBQH_130521_11}")
			return
		end
		
		if EquipPoint >= 19 and EquipPoint <= 24 then  --?????
			PushDebugMessage("#{SZXT_221216_213}")
			return
		end

		local nitemTableIndex = PlayerPackage : GetItemTableIndex( i_index )
		if nil == nitemTableIndex then
			return
		end

		local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
		if tonumber(curlevel) <= 0 then
			PushDebugMessage("#{ZBQH_130521_12}")
			return
		end
		if PlayerPackage:IsLock(i_index) == 1 then
			PushDebugMessage("#{ZBQH_130521_13}");
			return
		end
		EquipNewStrengthen_Clear(0)
		local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index)
		EquipNewStrengthen_Info4:SetText(""..tonumber(curlevel));
		if tonumber(Enchange_Item1) ~= -1 then
			LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
		end

		EquipNewStrengthen_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Enchange_Item1 = i_index

	end

	if tonumber(boxpos) == 1 then
		--ÅÐ¶ÏÓÒ±ßµÄ
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--??????,?????????????
			return
		end
		if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 37 then
				PushDebugMessage("#{ZBQH_130521_14}")	--???? ?????????
				return
		end

		if PlayerPackage:IsBagItemKFS(i_index) ==1 then  --?????
			PushDebugMessage("#{ZBQH_130521_15}")
			return
		end
		
		if EquipPoint2 >= 19 and EquipPoint2 <= 24 then  --?????
			PushDebugMessage("#{SZXT_221216_213}")
			return
		end
		
		local nitemTableIndex = PlayerPackage : GetItemTableIndex( i_index )
		if nil == nitemTableIndex then
			return
		end

		if tonumber(Enchange_Item1) < 0 then
			PushDebugMessage("#{ZBQH_130521_16}")
			return
		end

		local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
		local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
		local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
		local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
		local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(i_index);

		if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			--??????

			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()

			if tonumber(Equip_Level1) < 40 then
				msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
			end

			if tonumber(Equip_Level1) >= 40 then
				msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
			end

			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
			PushDebugMessage(msg)
			return
		end

		if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
			local theAction1 = EnumAction(Enchange_Item1, "packageitem");
			local leftItemName = theAction1:GetName()
			msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
			PushDebugMessage(msg)
			return
		end

		if tonumber(curlevel1) <= tonumber(curlevel2) then
			msg =  ScriptGlobal_Format("#{ZBQH_130521_19}",curlevel1)
			PushDebugMessage(msg)
			return
		end

		EquipNewStrengthen_Clear(1)
		EquipNewStrengthen_Info7:SetText(""..tonumber(curlevel2));

		EquipNewStrengthen_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(i_index,1);
		Enchange_Item2 = i_index

	end

	if tonumber(boxpos) == 2 then
		--ÓÒ¼üµã»÷±³°üµÄÎïÆ·
		local EquipPoint2 = LifeAbility : Get_Equip_Point(i_index)
		if EquipPoint2 == -1 then	--??????,?????????????
			return
		end
		if  EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 37 then
				PushDebugMessage("#{ZBQH_130521_14}")	--????
				return
		end

		if PlayerPackage:IsBagItemKFS(i_index) ==1 then  --?????
			PushDebugMessage("#{ZBQH_130521_15}")
			return
		end
		
		if EquipPoint2 >= 19 and EquipPoint2 <= 24 then  --?????
			PushDebugMessage("#{SZXT_221216_213}")
			return
		end
		
		local nitemTableIndex = PlayerPackage : GetItemTableIndex( i_index )
		if nil == nitemTableIndex then
			return
		end

		if tonumber(Enchange_Item1) >= 0 then
			--ÓÒ¼üµã»÷·Åµ½ÓÒ±ß
			local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
			local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
			local Equip_Level2 = LifeAbility : Get_Equip_Level(i_index);
			local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
			local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(i_index);

			if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()

				if tonumber(Equip_Level1) < 40 then
					msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
				end

				if tonumber(Equip_Level1) >= 40 then
					msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
				end

				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
				PushDebugMessage(msg)
				return
			end

			if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
				local theAction1 = EnumAction(Enchange_Item1, "packageitem");
				local leftItemName = theAction1:GetName()
				msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
				PushDebugMessage(msg)
				return
			end

			if tonumber(curlevel1) <= tonumber(curlevel2) then
				msg =  ScriptGlobal_Format("#{ZBQH_130521_19}",curlevel1)
				PushDebugMessage(msg)
				return
			end

			EquipNewStrengthen_Clear(1)
			EquipNewStrengthen_Info7:SetText(""..tonumber(curlevel2));

			EquipNewStrengthen_Object2:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item2 = i_index
		else
			--ÓÒ¼üµã»÷·Åµ½×ó±ß
			local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index);
			if tonumber(curlevel) <= 0 then
				PushDebugMessage("#{ZBQH_130521_21}")
				return
			end
			if PlayerPackage:IsLock(i_index) == 1 then
				PushDebugMessage("#{ZBQH_130521_20}");
				return
			end

			EquipNewStrengthen_Clear(0)
			local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(i_index)
			EquipNewStrengthen_Info4:SetText(""..tonumber(curlevel));
			if tonumber(Enchange_Item1) ~= -1 then
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
			end

			EquipNewStrengthen_Object1:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(i_index,1);
			Enchange_Item1 = i_index
		end
	end
	if tonumber(Enchange_Item1) >= 0 and tonumber(Enchange_Item2) >= 0 then
		EquipNewStrengthen_OK:Enable()
		g_check = -1
	else
		EquipNewStrengthen_OK:Disable()
	end

	if tonumber(Enchange_Item1) >= 0 then
		local lv = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
		local NeedMoney = lv*5
		if tonumber(NeedMoney) > 100 then
			NeedMoney = 100
		end
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", tostring(NeedMoney*10000));
	else
		EquipNewStrengthen_Money : SetProperty("MoneyNumber", "0");
	end

end


function EquipNewStrengthen_Buttons_Clicked()

	local msg = "";
	--ÔÝÊ±Ã»ÓÐ°²È«Ê±¼äºÍÃÜ±£µÄapi
	if tonumber(Enchange_Item1) < 0 then
		PushDebugMessage("#{ZBQH_130521_21}")
		return
	end
	local EquipPoint1 = LifeAbility : Get_Equip_Point(Enchange_Item1)
	if EquipPoint1 == -1 then	--??????,?????????????
		return
	end
	if  EquipPoint1 == 8 or EquipPoint1 == 9 or EquipPoint1 == 10 or EquipPoint1 > 37 then
			PushDebugMessage("#{ZBQH_130521_21}")	--????
			return
	end

	if PlayerPackage:IsBagItemKFS(Enchange_Item1) ==1 then  --?????
		PushDebugMessage("#{ZBQH_130521_15}")
		return
	end
	
	if EquipPoint1 >= 19 and EquipPoint1 <= 24 then  --?????
		PushDebugMessage("#{SZXT_221216_213}")
		return
	end

	local curlevel = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	if tonumber(curlevel) <= 0 then
		PushDebugMessage("#{ZBQH_130521_22}")
		return
	end

	if PlayerPackage:IsLock(Enchange_Item1) == 1 then
		PushDebugMessage("#{ZBQH_130521_20}");
		return
	end

	if tonumber(Enchange_Item2) < 0 then
		PushDebugMessage("#{ZBQH_130521_23}")
		return
	end

	local EquipPoint2 = LifeAbility : Get_Equip_Point(Enchange_Item2)
		if EquipPoint2 == -1 then	--??????,?????????????
			return
		end
	if EquipPoint2 == 8 or EquipPoint2 == 9 or EquipPoint2 == 10 or EquipPoint2 > 37 then
			PushDebugMessage("#{ZBQH_130521_23}")	--???? ?????????
			return
	end

	if PlayerPackage:IsBagItemKFS(Enchange_Item2) ==1 then  --?????
		PushDebugMessage("#{ZBQH_130521_15}")
		return
	end
	
	if EquipPoint2 >= 19 and EquipPoint2 <= 24 then  --?????
		PushDebugMessage("#{SZXT_221216_213}")
		return
	end

	local Equip_Level1 = LifeAbility : Get_Equip_Level(Enchange_Item1);
	local Equip_Level2 = LifeAbility : Get_Equip_Level(Enchange_Item2);
	local curlevel1 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item1);
	local curlevel2 = LifeAbility:Get_Equip_CurStrengthLevel(Enchange_Item2);

	if tonumber(EquipPoint1) ~= tonumber(EquipPoint2) then			
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()

		if tonumber(Equip_Level1) < 40 then
			msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
		end

		if tonumber(Equip_Level1) >= 40 then
			msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
		end

		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) < 40 and tonumber(Equip_Level2) >= 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  ScriptGlobal_Format("#{ZBQH_130521_17}",leftItemName, tostring(g_EquipName[EquipPoint1]))
		PushDebugMessage(msg)
		return
	end

	if tonumber(Equip_Level1) >= 40 and tonumber(Equip_Level2) < 40 then
		local theAction1 = EnumAction(Enchange_Item1, "packageitem");
		local leftItemName = theAction1:GetName()
		msg =  ScriptGlobal_Format("#{ZBQH_130521_18}",leftItemName, tostring(g_EquipName[EquipPoint1]))
		PushDebugMessage(msg)
		return
	end

	if tonumber(curlevel1) <= tonumber(curlevel2) then
		msg =  ScriptGlobal_Format("#{ZBQH_130521_19}",curlevel1)
		PushDebugMessage(msg)
		return
	end

	local NeedMoney = curlevel1*5
	if tonumber(NeedMoney) > 100 then
		NeedMoney = 100
	end

	local playerMoney = Player:GetData("MONEY");
	local playerMoney_JZ = Player:GetData("MONEY_JZ");
	if playerMoney+playerMoney_JZ < NeedMoney*10000 then
		PushDebugMessage("#{ZBQH_130521_24}")
		return
	end

	local BindState1 = PlayerPackage:GetItemBindStatusByIndex(tonumber(Enchange_Item1));
	local BindState2 = PlayerPackage:GetItemBindStatusByIndex(tonumber(Enchange_Item2));

	if BindState1 == EB_BINDED and BindState2 ~= EB_BINDED and tonumber(g_check) ~= 1 then
		msg =  ScriptGlobal_Format("#{ZBQH_130521_27}", curlevel1)

		GameProduceLogin : ShowMessageBox( msg, "Close", "-1")
		g_check = 1;
		return
	end

	if tonumber(curlevel2) > 0 and tonumber(g_check) ~= 1 then
		--µÈ¼¶¸²¸ÇÌáÊ¾
		msg =  ScriptGlobal_Format("#{ZBQH_130521_26}", curlevel1)

		GameProduceLogin : ShowMessageBox( msg, "Close", "-1")
		g_check = 1;
		return
	end

	g_check = -1;

	-- PushDebugMessage(Enchange_Item1)
	-- PushDebugMessage(Enchange_Item2)
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("FinishMoveEnhance")
	Set_XSCRIPT_ScriptID(809262);
	Set_XSCRIPT_Parameter(0,Enchange_Item1)
	Set_XSCRIPT_Parameter(1,Enchange_Item2)
	Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT();

end
