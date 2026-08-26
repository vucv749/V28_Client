local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local Change_Item1 = -1
local Change_Item2 = -1
local Original_Visual_ID = -1
local List_String = {}

function EquipChange_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_EQUIPCHANGE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("SEX_CHANGED");
end

function EquipChange_OnLoad()

	List_String[1]  = "Có th¬ biªn ð±i ngoÕi hình Nh¤t"
	List_String[2]  = "Có th¬ biªn ð±i ngoÕi hình Nh¸"
	List_String[3]  = "Có th¬ biªn ð±i ngoÕi hình Tam"
	List_String[4]  = "Có th¬ biªn ð±i ngoÕi hình TÑ"
	List_String[5]  = "Có th¬ biªn ð±i ngoÕi hình Ngû"

	List_String[6]  = "Có th¬ biªn ð±i ngoÕi hình Løc"
	List_String[7]  = "Có th¬ biªn ð±i ngoÕi hình Th¤t"
	List_String[8]  = "Có th¬ biªn ð±i ngoÕi hình Bát"
	List_String[9]  = "Có th¬ biªn ð±i ngoÕi hình CØu"
	List_String[10] = "Có th¬ biªn ð±i ngoÕi hình Th§p"
	
end

function EquipChange_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
			if tonumber(arg0) == 1010 then
				if this:IsVisible() then
					EquipChange_Close();
					return
				end
				this:Show();
				EquipChange_FakeObject:SetFakeObject("");	
				EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
				objCared = -1
				local xx = Get_XParam_INT(0);
				objCared = DataPool : GetNPCIDByServerID(xx);
				AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
				if objCared == -1 then
						PushDebugMessage("Dæ li®u máy chü có v¤n ð«");
						return;
				end
				BeginCareObject_EquipChange(objCared)
			end
	elseif  ( event == "UPDATE_EQUIPCHANGE" ) then
		AxTrace(5,5,"Change arg0="..arg0.." arg1 =="..arg1)
		if arg0~= nil then
			EquipChange_Update(arg0,arg1)
		end
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipChange_Resume_Gem(tonumber(arg0));
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--È¡Ïû¹ØÐÄ
			EquipChange_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Change_Item1 == tonumber(arg0) ) then
				EquipChange_Resume_Gem(23)			
			end
			if (Change_Item2 == tonumber(arg0) ) then
				EquipChange_Resume_Gem(24)			
			end
		end
		
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			EquipChange_FakeObject : Hide();
			EquipChange_FakeObject : Show();
			EquipChange_FakeObject:SetFakeObject("EquipChange_Player");
	end
end

function EquipChange_OnShown()
	EquipChange_Clear();
end

function EquipChange_Clear()
	if Change_Item1 ~= -1 then
		LifeAbility : Update_Equip_VisualID()
		EquipChange_CurrentEquip:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Change_Item1,0);
		Change_Item1 = -1
	end

	if Change_Item2 ~= -1 then
		EquipChange_NeedObject:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Change_Item2,0);
		Change_Item2 = -1
	end
	EquipChange_EquiptShapeList : ClearListBox()
	EquipChange_NeedMoney : SetProperty("MoneyNumber",0)
end

function EquipChange_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");
	local Exterior_id
	
	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
					if EquipPoint ~= -1 then
						PushDebugMessage("Không th¬ ð£t trang b¸ này vào")
					end
					return
				end
				Original_Visual_ID = LifeAbility : Get_Equip_VisualID(i_index);

				if Original_Visual_ID < 10000 then
					PushDebugMessage("Cái này trang b¸ không th¬ thay ð±i ngoÕi hình.")
					EquipChange_Resume_Gem(23)
					return

				end
				if Change_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Change_Item1,0);
				end
				EquipChange_CurrentEquip:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Change_Item1 = i_index
		
				local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
				EquipChange_NeedMoney : SetProperty("MoneyNumber", Equip_Level * 20000)
				
				EquipChange_EquiptShapeList : ClearListBox()
				
				for i = 1,10 do
					Exterior_id = LifeAbility : Get_Equip_Exterior(i_index,i-1);
					if Exterior_id ~= -1 then
						EquipChange_EquiptShapeList:AddItem(List_String[i],i-1);
					end
				end
			
		else
				EquipChange_Resume_Gem(23)
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
		
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900004 then
					PushDebugMessage("Chï có th¬ ð¬ vào biªn hình Phù.")
					return
				end

				if Change_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Change_Item2,0);
				end
				EquipChange_NeedObject:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Change_Item2 = i_index
		else
				EquipChange_NeedObject:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Change_Item2,0);		
				Change_Item2 = -1;
		end
	end
	EquipChange_FakeObject:SetFakeObject("");	
	EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
end

function EquipChange_ListBox_Selected()
	local nSelIndex = EquipChange_EquiptShapeList:GetFirstSelectItem();
	
	if nSelIndex == -1 then
		return
	end
	
	EquipChange_FakeObject:SetFakeObject("");	
	EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
	--ÈÃÈË´©ÉÏ
	local Visual_ID = LifeAbility : Get_Equip_Exterior(Change_Item1,nSelIndex);
	LifeAbility : Wear_Equip_VisualID(Change_Item1,Visual_ID)
end

function EquipChange_Buttons_Clicked()
	local nSelIndex = EquipChange_EquiptShapeList:GetFirstSelectItem();
	
	if Change_Item1 == -1 then
		PushDebugMessage("Thïnh ð¬ vào Yêu thay ð±i ngoÕi hình Ðích trang b¸.")
		return
	end
	
	if Change_Item2 == -1 then
		PushDebugMessage("Thïnh ð¬ vào biªn hình Phù.")
		return
	end
	
	if nSelIndex== -1 then
		PushDebugMessage("Thïnh lña ch÷n mµt loÕi ngoÕi hình.")
		return
	end
	
	local Visual_ID = LifeAbility : Get_Equip_Exterior(Change_Item1,nSelIndex);

	if Visual_ID == -1 then
		return
	end

	if Visual_ID ~= Original_Visual_ID then
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ChangeVisual");
			Set_XSCRIPT_ScriptID(809264);
			Set_XSCRIPT_Parameter(0,Change_Item1);
			Set_XSCRIPT_Parameter(1,Change_Item2);
			Set_XSCRIPT_Parameter(2,nSelIndex);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();

	end

end

function EquipChange_Close()
	EquipChange_FakeObject:SetFakeObject("");	
	this:Hide()
end

function EquipChange_Cancel_Clicked()
	EquipChange_Close();
	return;
end

function EquipChange_OnHidden()
	EquipChange_FakeObject:SetFakeObject("");
	StopCareObject_EquipChange(objCared)
	EquipChange_Clear()
	return
end
--=========================================================
--¿ªÊ¼¹ØÐÄNPC£¬
--ÔÚ¿ªÊ¼¹ØÐÄÖ®Ç°ÐèÒªÏÈÈ·¶¨ â¸ö½çÃæÊÇ²»ÊÇÒÑ¾­ÓÐ¡°¹ØÐÄ¡±µÄNPC£¬
--Èç¹ûÓÐµÄ»°£¬ÏÈÈ¡ÏûÒÑ¾­ÓÐµÄ¡°¹ØÐÄ¡±
--=========================================================
function BeginCareObject_EquipChange(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipChange");

end

--=========================================================
--Í£Ö¹¶ÔÄ³NPCµÄ¹ØÐÄ
--=========================================================
function StopCareObject_EquipChange(objCaredId)
	this:CareObject(objCaredId, 0, "EquipChange");
	g_Object = -1;

end

function EquipChange_Resume_Gem(nIndex)
	if nIndex < 23 or nIndex > 24 then
		return
	end

	nIndex = nIndex - 22
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Change_Item1 ~= -1 then
				LifeAbility : Update_Equip_VisualID()
				EquipChange_CurrentEquip:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Change_Item1,0);
				Change_Item1 = -1
				EquipChange_NeedMoney : SetProperty("MoneyNumber", 0)
				EquipChange_EquiptShapeList : ClearListBox()
			end
		else
			if Change_Item2 ~= -1 then
				EquipChange_NeedObject:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Change_Item2,0);
				Change_Item2 = -1
			end
		end
	end
	
end
