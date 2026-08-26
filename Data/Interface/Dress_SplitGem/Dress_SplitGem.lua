local objCared = -1
local g_Object = -1
local MAX_OBJ_DISTANCE = 3.0
local Dress_QUALITY = -1
local Dress_CHARM_QUALITY = -1
local Dress_GEM_BUTTONS={}
local Dress_BUTTON
local Dress_CHARM_BUTTON
local GEM_SELECTED = -1

local g_Dress_SplitGem_Frame_UnifiedPosition;

function Dress_SplitGem_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");	
	this:RegisterEvent("UPDATE_DRESS_SPLITGEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

function Dress_SplitGem_OnLoad()

	Dress_BUTTON	 = Dress_SplitGem_Item --????
	Dress_CHARM_BUTTON	 = Dress_SplitGem_Gem4			 --???????
	Dress_GEM_BUTTONS[1] = Dress_SplitGem_Gem1			 --????	
	Dress_GEM_BUTTONS[2] = Dress_SplitGem_Gem2
	Dress_GEM_BUTTONS[3] = Dress_SplitGem_Gem3
	
	g_Dress_SplitGem_Frame_UnifiedPosition=Dress_SplitGem_Frame:GetProperty("UnifiedPosition");
end

function Dress_SplitGem_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0)==19851274 then
		this:Show()
		PushEvent( "CLOSE_DRESSPREVIEW") 
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")
		Dress_SplitGem_Clear()
		
		local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			if objCared == -1 then
					return;
			end
			BeginCareObject_Dress_SplitGem(objCared)
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Dress_SplitGem_Cancel_Clicked()
		end
		
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then		
		--g_LastEquipID = -1;
	  --g_LastNeedItemID = -1;	  
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end		

		if (Dress_QUALITY == tonumber(arg0) ) then
				Dress_SplitGem_Clear()
				Dress_SplitGem_Update(23,tonumber(arg0))
				Dress_SplitGem_Explain3:Hide();
		end
		if (Dress_CHARM_QUALITY == tonumber(arg0) ) then
				Dress_CHARM_BUTTON : SetActionItem(-1);
				Dress_SplitGem_Update(25,tonumber(arg0))
		end
	elseif( event == "UPDATE_DRESS_SPLITGEM") then
		if arg0 ~= nil then
			Dress_SplitGem_Update(arg0,arg1);
		end
	elseif( event == "RESUME_ENCHASE_GEM") then
		if(arg0~=nil and (tonumber(arg0) == 23 or tonumber(arg0) == 25)) then
			Resume_Dress_Split_Gem(tonumber(arg0))
			if(tonumber(arg0) == 25) then
					Dress_SplitGem_Explain3:Hide() 
			end
		end

	elseif ( event == "OPEN_STALL_SALE" and this:IsVisible() ) then
		--和摆摊界面互斥
		this:Hide()
	
	-- 时装预览
	elseif  ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then
		this:Hide()

	elseif (event == "ADJEST_UI_POS" ) then
		Dress_SplitGem_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Dress_SplitGem_Frame_On_ResetPos()

	end
	
	
end

function Dress_SplitGem_Clear()
	Dress_BUTTON : SetActionItem(-1);
	Dress_CHARM_BUTTON : SetActionItem(-1);
	if(Dress_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(Dress_QUALITY,0);
	end
	if(CHARM_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(Dress_CHARM_QUALITY,0);
	end
	Dress_QUALITY = -1
	Dress_CHARM_QUALITY = -1
	Dress_GEM_BUTTONS[1] : SetActionItem(-1);
	Dress_GEM_BUTTONS[2] : SetActionItem(-1);
	Dress_GEM_BUTTONS[3] : SetActionItem(-1);
	GEM_SELECTED = -1
	--g_LastEquipID = -1
	--g_LastNeedItemID = -1
end

function BeginCareObject_Dress_SplitGem(objCared)
	g_Object = objCared;
	this:CareObject(g_Object, 1, "Dress_SplitGem");
end

function Dress_SplitGem_Cancel_Clicked()
	Dress_SplitGem_Closed()
end

function Dress_SplitGem_Closed()
	this:Hide()
end

function Dress_SplitGem_OnHiden()
	StopCareObject_Dress_SplitGem(objCared)
	Dress_SplitGem_Clear()
	return
end


function StopCareObject_Dress_SplitGem(objCaredId)
	this:CareObject(objCaredId, 0, "Dress_SplitGem");
	g_Object = -1;
end

function Dress_SplitGem_OnShown()
	Dress_SplitGem_Clear()
end

function Dress_SplitGem_Update(arg0,arg1)
	local ui_Index = tonumber(arg0)
	local bagPos = tonumber(arg1)
	
	local theActionItem = EnumAction(bagPos, "packageitem")
	if ui_Index == 23 then --??
		if theActionItem:GetID() ~= 0 then
			local dressEquipPoint = LifeAbility : Get_Equip_Point(bagPos)
			if dressEquipPoint~=16 then
				PushDebugMessage("#{SZPR_091023_77}")
				return
			end
			local dress_GemNum = LifeAbility : GetEquip_GemCount(bagPos)
						
			if dress_GemNum > 3 then--???????????
				return
			end
			
			--将之前放入UI的物品解锁
			if Dress_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(Dress_QUALITY,0)
			end
			Dress_QUALITY = bagPos
			Dress_BUTTON:SetActionItem(theActionItem:GetID())
			LifeAbility : Lock_Packet_Item(Dress_QUALITY,1)
		else
			Dress_BUTTON:SetActionItem(-1);
			Dress_QUALITY = -1
			LifeAbility : Lock_Packet_Item(Dress_QUALITY,0)
			return
		end
		--放上宝石
		--设置DataPool中的m_vGemSeparateList
		if not LifeAbility:SplitGem_Update(bagPos) then --????
			for i=1,3 do
				Dress_GEM_BUTTONS[i] : SetActionItem(-1)
			end
		else
			local ActionID,nItemID
		
			for i=1,3 do
				nItemID = LifeAbility : GetSplitGem_Gem (i-1);			
				if nItemID ~= -1 then
					ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
					Dress_GEM_BUTTONS[i] : SetActionItem(ActionID);
				else
					Dress_GEM_BUTTONS[i] : SetActionItem(-1)
				end
			end			
		end
		GEM_SELECTED = -1
		
	elseif ui_Index == 25 then --???
		if PlayerPackage : GetItemTableIndex( bagPos ) ~= 30503136 then
			PushDebugMessage("#{SZPR_091023_78}")
			return
		else
			--解锁之前的牚除符

			if(Dress_CHARM_QUALITY ~= -1) then
				LifeAbility : Lock_Packet_Item(Dress_CHARM_QUALITY,0)
			end

			Dress_CHARM_BUTTON:SetActionItem(theActionItem:GetID());
			Dress_CHARM_QUALITY = bagPos
			LifeAbility : Lock_Packet_Item(Dress_CHARM_QUALITY,1);

		end		
	end	
end

function Resume_Dress_Split_Gem(index)
	if index ~= 23 and index ~=25 then
		return
	end
	
	if index == 23 then
		if Dress_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(Dress_QUALITY,0)
			Dress_BUTTON : SetActionItem(-1);
			Dress_QUALITY = -1
			Dress_GEM_BUTTONS[1] : SetActionItem(-1);
			Dress_GEM_BUTTONS[2] : SetActionItem(-1);
			Dress_GEM_BUTTONS[3] : SetActionItem(-1);
			GEM_SELECTED = -1
		end
	else --index == 25
		if(Dress_CHARM_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(Dress_CHARM_QUALITY,0)
			Dress_CHARM_BUTTON : SetActionItem(-1)
			Dress_CHARM_QUALITY	= -1
		end 
		if(Dress_SplitGem_Explain3:IsVisible()) then
    	Dress_SplitGem_Explain3:Hide();
  	end
  end
end


function Dress_SplitGem_Selected(Gem_Index)

	if Dress_GEM_BUTTONS[Gem_Index]:GetActionItem() == -1 then
		return
	end
	
	if GEM_SELECTED ~= -1 then
		Dress_GEM_BUTTONS[GEM_SELECTED] : SetPushed(0)
	end
	
	GEM_SELECTED = Gem_Index
	Dress_GEM_BUTTONS[GEM_SELECTED] : SetPushed(1)
end

function Dress_SplitGem_Buttons_Clicked()
	if GEM_SELECTED == -1 then
		PushDebugMessage("#{SZPR_091023_79}")
		return
	end
	
	if Dress_CHARM_QUALITY == -1 then
		PushDebugMessage("#{SZPR_091023_80}")
		return
	end
	
	if Dress_QUALITY == -1 then
		PushDebugMessage("#{SZPR_XML_74}")
		return
	end
	
	DressEnchasing : Do_Dress_SeparateGem(Dress_QUALITY,GEM_SELECTED-1,Dress_CHARM_QUALITY);
	Resume_Dress_Split_Gem(23)--????
	Resume_Dress_Split_Gem(25)
	Dress_CHARM_QUALITY = -1

end

function Dress_SplitGem_Frame_On_ResetPos()
  Dress_SplitGem_Frame:SetProperty("UnifiedPosition", g_Dress_SplitGem_Frame_UnifiedPosition);
end

