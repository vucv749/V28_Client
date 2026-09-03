local Current = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Enchange_Item1 = -1
local Enchange_Item2 = -1
local g_Object = -1;

local Enchange_Cost = {}
local g_EquipEnchange_Frame_UnifiedPosition;

function EquipEnchange_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_ENHANCE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function EquipEnchange_OnLoad()
	Enchange_Cost[1] = 20000
	Enchange_Cost[2] = 30000
	Enchange_Cost[3] = 40000
	Enchange_Cost[4] = 50000
	Enchange_Cost[5] = 60000
	Enchange_Cost[6] = 70000
	Enchange_Cost[7] = 80000
	Enchange_Cost[8] = 90000
	Enchange_Cost[9] = 100000
	Enchange_Cost[10] = 0
	
	g_EquipEnchange_Frame_UnifiedPosition=EquipEnchange_Frame:GetProperty("UnifiedPosition");
end

function EquipEnchange_OnEvent(event)


	if ( event == "UI_COMMAND" ) then
			local playerMoney = Player:GetData("MONEY");
			EquipEnchange_SelfMoney:SetProperty("MoneyNumber", playerMoney);
			EquipEnchange_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
			if tonumber(arg0) == 1003 then
				EquipEnchange_Info4  : SetText("Tång c¤p trang b¸ giúp tång thuµc tính c½ bän")
				EquipEnchange_Info : SetText("Ð£t trang b¸ vào ô này!")
				EquipEnchange_Info2 : SetText("Tång c¤p c¥n")
				EquipEnchange_Title : SetText("#gFF0FA0Tång c¤p")
				EquipEnchange_Object2 : SetToolTip(" C¥n #{_ITEM30900008}")
				Current = 3
				if this:IsVisible() then
					EquipEnchange_Close();
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
				BeginCareObject_EquipEnchange(objCared)
			elseif tonumber(arg0) == 1004 then
				EquipEnchange_Info4  : SetText("")
				EquipEnchange_Info : SetText("Ð£t trang b¸ c¥n tång s¯ l¥n sØa chæa vào!")
				EquipEnchange_Info2 : SetText("C¥n nguyên li®u ð£c bi®t")
				EquipEnchange_Title : SetText("#gFF0FA0Tång s¯ l¥n sØa chæa")
				EquipEnchange_Object2 : SetToolTip(" C¥n #{_ITEM30900007}")
				Current = 4
				if this:IsVisible() then
					EquipEnchange_Close();
				end
	
				this:Show();
				objCared = -1
				local xx = Get_XParam_INT(0);
				if xx ~= -1 then
					objCared = DataPool : GetNPCIDByServerID(xx);
					AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
					if objCared == -1 then
							PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
							return;
					end
					BeginCareObject_EquipEnchange(objCared)
				end
			end
	elseif  ( event == "UPDATE_ENHANCE" ) then
		AxTrace(5,5,"enchange arg0="..arg0.." arg1 =="..arg1)
		if arg0~= nil then
			EquipEnchange_Update(arg0,arg1)

		end
		local playerMoney = Player:GetData("MONEY");
		EquipEnchange_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipEnchange_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipEnchange_Resume_Gem(tonumber(arg0));
		end
		local playerMoney = Player:GetData("MONEY");
		EquipEnchange_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipEnchange_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			EquipEnchange_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Enchange_Item1 == tonumber(arg0) ) then
				EquipEnchange_Resume_Gem(21)			
			end
			if (Enchange_Item2 == tonumber(arg0) ) then
				EquipEnchange_Resume_Gem(22)			
			end

		end
		local playerMoney = Player:GetData("MONEY");
		EquipEnchange_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		EquipEnchange_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); --zchw
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipEnchange_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then --zchw
		EquipEnchange_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		
	elseif (event == "ADJEST_UI_POS" ) then
		EquipEnchange_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipEnchange_Frame_On_ResetPos()

	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
			EquipEnchange_Close() 	
	end


end

function EquipEnchange_OnShown()
	EquipEnchange_Clear();
end

function EquipEnchange_Clear()
	if Enchange_Item1 ~= -1 then
		EquipEnchange_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
		Enchange_Item1 = -1
	end
	if Enchange_Item2 ~= -1 then
		EquipEnchange_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Enchange_Item2,0);
		Enchange_Item2 = -1
	end
	EquipEnchange_Money : SetProperty("MoneyNumber", 0)
end

function EquipEnchange_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");
	local NeedMoney

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
			
				if Enchange_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
				end
				local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
				EquipEnchange_Object1:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Enchange_Item1 = i_index
				if Current == 4 then
					NeedMoney = Equip_Level * 200
				elseif Current == 3 then
					NeedMoney = Equip_Level * 20000
				elseif Current == 2 then
					NeedMoney = LifeAbility : Get_Equip_StrengthLevel(i_index);
					if(NeedMoney<=0) then
						return;
					end
				end
				EquipEnchange_Money : SetProperty("MoneyNumber", tostring(NeedMoney));
				if Current == 2 then
					local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
						if Equip_Level < 40 then
							EquipEnchange_Object2 : SetToolTip(" C¥n #{_ITEM30900005}")
						else
							EquipEnchange_Object2 : SetToolTip(" C¥n #{_ITEM30900006}")
						end
				end
		else
				EquipEnchange_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);		
				Enchange_Item1 = -1;
				EquipEnchange_Money : SetProperty("MoneyNumber", 0)
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
				if Current == 2 then--????
					if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900005 and
						 PlayerPackage : GetItemTableIndex( i_index ) ~= 30900006 then
						PushDebugMessage("Phäi ð£t #{_ITEM30900005} ho£c #{_ITEM30900006} vào. ")
						return
					end
				end
				if Current == 3 then--????
					if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900008 then
						PushDebugMessage("Phäi ð£t #{_ITEM30900008} vào. ")
						return
					end
				end
				if Current == 4 then--????
					if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900007 and
						 PlayerPackage : GetItemTableIndex( i_index ) ~= 30900000 and
						 PlayerPackage : GetItemTableIndex( i_index ) ~= 31000102	then
						PushDebugMessage("N½i này phäi ð¬ vào#{_ITEM30900007}ho£c là#{_ITEM30900000}ho£c là#{_ITEM31000102}.")
						return
					end
				end
				if Enchange_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Enchange_Item2,0);
				end
				EquipEnchange_Object2:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Enchange_Item2 = i_index
		else
				EquipEnchange_Object2:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Enchange_Item2,0);		
				Enchange_Item2 = -1;
		end
	end
	
end

function EquipEnchange_Buttons_Clicked()
	if Enchange_Item1 == -1 then
		PushDebugMessage("Hãy ð£t 1 trang b¸ vào!")
		return
	end
	
	if Current == 2 then--????
		if Enchange_Item2 == -1 then
			PushDebugMessage("Hãy ð£t #{_ITEM30900005} ho£c #{_ITEM30900006} vào. ")
			return
		end
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishEnhance");
				Set_XSCRIPT_ScriptID(809262);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,Enchange_Item2);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
	elseif Current == 3 then--????
		if Enchange_Item2 == -1 then
			PushDebugMessage("Hãy ð£t #{_ITEM30900008} vào. ")
			return
		end
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("EquipLevelUp");
				Set_XSCRIPT_ScriptID(809263);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,Enchange_Item2);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
	elseif Current == 4 then--????
		if Enchange_Item2 == -1 then
			PushDebugMessage("Hãy ð£t #{_ITEM30900007} vào")
			return
		end
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("EquipFaileTimes");
				Set_XSCRIPT_ScriptID(809265);
				Set_XSCRIPT_Parameter(0,Enchange_Item1);
				Set_XSCRIPT_Parameter(1,Enchange_Item2);
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
	end
end

function EquipEnchange_Close()
	this:Hide()
end

function EquipEnchange_Cancel_Clicked()
	EquipEnchange_Close();
	return;
end

function EquipEnchange_OnHiden()
	StopCareObject_EquipEnchange(objCared)
	EquipEnchange_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_EquipEnchange(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipEnchange");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_EquipEnchange(objCaredId)
	this:CareObject(objCaredId, 0, "EquipEnchange");
	g_Object = -1;

end

function EquipEnchange_Resume_Gem(nIndex)
	if nIndex < 21 or nIndex > 22 then
		return
	end

	nIndex = nIndex - 20
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Enchange_Item1 ~= -1 then
				EquipEnchange_Object1:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Enchange_Item1,0);
				Enchange_Item1 = -1
				EquipEnchange_Money : SetProperty("MoneyNumber", 0)
			end
		else
			if Enchange_Item2 ~= -1 then
				EquipEnchange_Object2:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Enchange_Item2,0);
				Enchange_Item2 = -1
			end
		end
	end
	
end

function EquipEnchange_Frame_On_ResetPos()
  EquipEnchange_Frame:SetProperty("UnifiedPosition", g_EquipEnchange_Frame_UnifiedPosition);
end
