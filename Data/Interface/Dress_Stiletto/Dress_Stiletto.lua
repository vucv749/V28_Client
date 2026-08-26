local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local MATERIAL_BUTTONS;
local MATERIAL_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=-1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local costMoneyArray = {3000, 3600, 4200}
local g_Object = -1;
local Max_Dress_Bore_Count = 3
local Dress_Stiletto_CostItemIndex = -1;

local g_Dress_Stiletto_Frame_UnifiedPosition;

function Dress_Stiletto_PreLoad()

	this:RegisterEvent("DRESS_STILETTO_UPDATE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function Dress_Stiletto_OnLoad()
	EQUIP_BUTTONS = Dress_Stiletto_Item
	MATERIAL_BUTTONS = Dress_Stiletto_Material
	
	g_Dress_Stiletto_Frame_UnifiedPosition=Dress_Stiletto_Frame:GetProperty("UnifiedPosition");
end

function Dress_Stiletto_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20091027) then
			this:Show();
			PushEvent( "CLOSE_DRESSPREVIEW") 
			PushEvent( "CLOSE_GEMEFFECTPREVIEW")
			-- 清繝物品槽
			Dress_Stiletto_Clear();
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					return;
			end
			BeginCareObject_Dress_Stiletto(objCared)

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Dress_Stiletto_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		if (EQUIP_QUALITY == tonumber(arg0) ) then
			Dress_Stiletto_Update(1,tonumber(arg0))
		end
			
		if (MATERIAL_QUALITY == tonumber(arg0) ) then
			if Dress_Stiletto_CostItemIndex ~= -1 then		
			  local nextPos = PlayerPackage : GetBagPosByItemIndex(Dress_Stiletto_CostItemIndex)
			  if nextPos >=0 then
			  	 Dress_Stiletto_Update(2,nextPos)
			  else
			  	Dress_Stiletto_Clear()
			  end
			else
				Dress_Stiletto_Clear()
			end
		end
		
	elseif( event == "DRESS_STILETTO_UPDATE") then
		if arg0 == nil or arg1 == nil then
			return
		end 

		Dress_Stiletto_Update(tonumber(arg0),tonumber(arg1));		

	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 1) then---xml?????D1
			Resume_Equip_Dress_Stiletto(1);
		end
		
	elseif ( event == "OPEN_STALL_SALE" and this:IsVisible() ) then
		--和摆摊界面互斥
		this:Hide()
		
	elseif  ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then
		this:Hide()
		
	elseif (event == "ADJEST_UI_POS" ) then
		Dress_Stiletto_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_Stiletto_Frame_On_ResetPos()
	end
end

function Dress_Stiletto_OnShown()
	Dress_Stiletto_Clear()
end

function Dress_Stiletto_Clear()
	if(EQUIP_QUALITY ~= -1) then
		EQUIP_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
	end
	
	if(MATERIAL_QUALITY ~= -1) then
		MATERIAL_BUTTONS : SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(MATERIAL_QUALITY,0);
		MATERIAL_QUALITY = -1;
	end
	Dress_Stiletto_Money : SetProperty("MoneyNumber", "");
	Dress_Stiletto_State: SetText("")
	Dress_Stiletto_CostItemIndex=-1
end

function Dress_Stiletto_Update(pos1,pos0)
	local pos_packet,pos_ui;
	pos_packet = tonumber(pos0);
	pos_ui		 = tonumber(pos1)
	
	local theAction = EnumAction(pos_packet, "packageitem");
	if pos_ui == 1 then
		if theAction:GetID() ~= 0 then
			Bore_Count = LifeAbility : GetEquip_HoleCount(pos_packet)
			if Bore_Count > 2 then 
				PushDebugMessage("#{SZPR_091023_35}")
				return
			end
			
			--将之前加锁物品解锁
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				Dress_Stiletto_Money : SetProperty("MoneyNumber", "");
				Dress_Stiletto_State: SetText("")
			end

			--加锁
			EQUIP_BUTTONS:SetActionItem(theAction:GetID());
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			Dress_Stiletto_Money : SetProperty("MoneyNumber", "");
			Dress_Stiletto_State: SetText("")
			return;
		end
		Dress_Stiletto_Money : SetProperty("MoneyNumber", tostring(costMoneyArray[Bore_Count+1]));
		Dress_Stiletto_State : SetText("#{SZPR_XML_31}"..Bore_Count.."#{SZPR_XML_32}"..tostring(3-Bore_Count))

	elseif pos_ui == 2 then
		local itemindex = PlayerPackage : GetItemTableIndex(pos_packet)
		Dress_Stiletto_CostItemIndex =itemindex
		return		

	end
	
end

function Dress_Stiletto_Buttons_Clicked()
	if EQUIP_QUALITY ~= -1 and Bore_Count ~= -1 then
		if Bore_Count > Max_Dress_Bore_Count-1 then
			PushDebugMessage("#{SZPR_091023_35}")
			return 
		end
		if Player:GetData("MONEY") + Player:GetData("MONEY_JZ") < costMoneyArray[Bore_Count+1] then
			PushDebugMessage("#{RXZS_090804_11}")
			return
		else
			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnDress_Stiletto");
				Set_XSCRIPT_ScriptID(830011);
				Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
		end
		Resume_Equip_Dress_Stiletto(1)
	else
		PushDebugMessage("#{SZPR_091023_84}")
	end	
end

function Dress_Stiletto_Close()
	--将加锁物品解锁
	this:Hide();
	Dress_Stiletto_Clear();
	StopCareObject_Dress_Stiletto(objCared)
end

function Dress_Stiletto_Cancel_Clicked()
	Dress_Stiletto_Close();
	return;
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Dress_Stiletto(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Dress_Stiletto");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Dress_Stiletto(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_Stiletto");
	g_Object = -1;

end

function Resume_Equip_Dress_Stiletto(nIndex)
	if( this:IsVisible() ) then	
			if(EQUIP_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EQUIP_BUTTONS : SetActionItem(-1);
				EQUIP_QUALITY	= -1;
				Dress_Stiletto_Money : SetProperty("MoneyNumber", "");
				Dress_Stiletto_State: SetText("")
			end
	end	
end

function Dress_Stiletto_Frame_On_ResetPos()
  Dress_Stiletto_Frame:SetProperty("UnifiedPosition", g_Dress_Stiletto_Frame_UnifiedPosition);
end
