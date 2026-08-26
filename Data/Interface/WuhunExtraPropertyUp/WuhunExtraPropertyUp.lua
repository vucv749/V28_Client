local m_UI_NUM = 20090720

local m_ObjCared = -1
local m_Equip_Idx = -1
local m_Equip_Item = -1

local m_sel = -1

local INDEX_ATTRUP_BEGIN	= 20310122	--润魂石·御（1级）
local INDEX_ATTRUP_END		= 20310157	--润魂石·暴（9级）

local m_AttrBnList = {}
--PreLoad
function WuhunExtraPropertyUp_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_KFSATTRLEVELUP")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
end

--Onload
function WuhunExtraPropertyUp_OnLoad()
	m_AttrBnList[1] = WuhunExtraPropertyUp_Property1
	m_AttrBnList[2] = WuhunExtraPropertyUp_Property2
	m_AttrBnList[3] = WuhunExtraPropertyUp_Property3
	m_AttrBnList[4] = WuhunExtraPropertyUp_Property4
	m_AttrBnList[5] = WuhunExtraPropertyUp_Property5
	m_AttrBnList[6] = WuhunExtraPropertyUp_Property6
	m_AttrBnList[7] = WuhunExtraPropertyUp_Property7
	m_AttrBnList[8] = WuhunExtraPropertyUp_Property8
	m_AttrBnList[9] = WuhunExtraPropertyUp_Property9
	m_AttrBnList[10] = WuhunExtraPropertyUp_Property10
end

--OnEvent
function WuhunExtraPropertyUp_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		
		WuhunExtraPropertyUp_BeginCareObj( Get_XParam_INT(0) );
		
		WuhunExtraPropertyUp_Update(-1)
		WuhunExtraPropertyUp_Update_Sub(-1)
		this:Show();

	elseif (event == "UPDATE_KFSATTRLEVELUP" and this:IsVisible() ) then
		if arg1 ~= nil and tonumber(arg1) == 0 and arg0 ~= nil then
			WuhunExtraPropertyUp_Update( tonumber(arg0) )
	
		elseif arg1 ~= nil and tonumber(arg1) == 1 and arg0 ~= nil then
			WuhunExtraPropertyUp_Update_Sub( tonumber(arg0) )
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		if arg0 ~= nil and tonumber(arg0) == m_Equip_Idx then
			WuhunExtraPropertyUp_Update(m_Equip_Idx)
		elseif  arg0 ~= nil and tonumber(arg0) == m_Equip_Item then
			WuhunExtraPropertyUp_Update_Sub(m_Equip_Item)
		end 
	end
end

--Update UI
function WuhunExtraPropertyUp_Update(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		local attrNum = PlayerPackage:GetBagKfsAttrExNum(itemIdx)
		if attrNum ~= nil and attrNum <= 0 then
			if m_Equip_Idx == itemIdx then
				WuhunExtraPropertyUp_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
				m_Equip_Idx = -1;
				return
			end
			PushDebugMessage("#{WH_090729_57}")	--没有扩展属性
			return
		end

		if m_Equip_Idx ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);
		end
		WuhunExtraPropertyUp_Object1:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Idx = itemIdx
	else
		WuhunExtraPropertyUp_Object1:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Idx,0);		
		m_Equip_Idx = -1;
		
	end
	WuhunExtraPropertyUp_UICheck()
end

function WuhunExtraPropertyUp_Update_Sub(itemIdx)
	
	local theAction = EnumAction(itemIdx, "packageitem");
	if theAction:GetID() ~= 0 then
		
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		if itemID < INDEX_ATTRUP_BEGIN or itemID > INDEX_ATTRUP_END then
			PushDebugMessage("#{WH_090729_29}") -- 此处只能放入润魂石。
			return
		end

		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WH_090729_07}")	--润魂石上锁了
			return
		end

		if m_Equip_Item ~= -1 then
			LifeAbility : Lock_Packet_Item(m_Equip_Item,0);
		end

		WuhunExtraPropertyUp_Object2:SetActionItem(theAction:GetID());
		LifeAbility : Lock_Packet_Item(itemIdx,1);
		m_Equip_Item = itemIdx
	else
		WuhunExtraPropertyUp_Object2:SetActionItem(-1);			
		LifeAbility : Lock_Packet_Item(m_Equip_Item,0);		
		m_Equip_Item = -1;
	end
	WuhunExtraPropertyUp_UICheck()
end

--Care Obj
function WuhunExtraPropertyUp_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end

--OK
function WuhunExtraPropertyUp_OK_Clicked()

	if m_Equip_Idx == -1 or m_Equip_Item == -1 then
		return
	end
	
	if m_sel == -1 then
		PushDebugMessage("#{WH_090729_30}")   --请选择需要升级的属性
		return
	end
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local needMoney = PlayerPackage:GetBagKfsAttrExUpMoney(m_Equip_Idx , m_sel - 1)
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")   --对不起，你身上金钱不足，无法继续进行。
		return
	end
	
	local itemIndex = PlayerPackage:GetItemTableIndex(m_Equip_Item)
	local needItem = PlayerPackage:GetBagKfsAttrExUpItem(m_Equip_Idx , m_sel - 1)

	if needItem == nil then
		return
	end
	
	if needItem <= 0 then
		return
	end

	if needItem ~= nil and needItem > 0 and itemIndex ~= needItem then
		local needItemName = PlayerPackage:GetItemName(needItem)
		PushDebugMessage("#{WH_xml_XX(98)}"..needItemName)	 --升级该属性需要道具：XXX
		return
	elseif needItem ~= nil and needItem <= 0 then
		PushDebugMessage("#{WH_090828_01}")	 --该属性已经达到最高等级，不能继续升级！
		return
	end
	
	PlayerPackage:Kfs_Op_Do(1 , m_Equip_Idx , m_Equip_Item ,m_sel - 1)

end

--Select 1 Attr
function WuhunExtraPropertyUp_Select_AttrEx(idx)
	m_sel = idx
	local needMoney = PlayerPackage:GetBagKfsAttrExUpMoney(m_Equip_Idx , m_sel - 1)
	WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
end

--Close UI
function WuhunExtraPropertyUp_Close()
	this:Hide();
end

--Handle UI Closed
function WuhunExtraPropertyUp_OnHiden()
	WuhunExtraPropertyUp_Update(-1)
	WuhunExtraPropertyUp_Update_Sub(-1)
end

--
function WuhunExtraPropertyUp_Resume_Equip()
	WuhunExtraPropertyUp_Update(-1)
end

function WuhunExtraPropertyUp_Resume_Item()
	WuhunExtraPropertyUp_Update_Sub(-1)
end


function WuhunExtraPropertyUp_UICheck()
	WuhunExtraPropertyUp_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"));
	WuhunExtraPropertyUp_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ")); 
	WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", 0)
	WuhunExtraPropertyUp_OK:Disable()

	for i = 1 , 10 do
		m_AttrBnList[i]:Disable()
		m_AttrBnList[i]:SetText("")
		m_AttrBnList[i]:SetCheck(0)
	end

	if m_Equip_Idx ~= -1 then
		local attrNum = PlayerPackage:GetBagKfsAttrExNum(m_Equip_Idx)
		if attrNum ~= nil and attrNum > 0 then
			for i = 1 , attrNum do
				local iText , iValue = PlayerPackage:GetKfsAttrEx(m_Equip_Idx , i - 1 )
				if iValue ~= nil and iValue > 0 and iText ~= nil then
					m_AttrBnList[i]:Enable()
					m_AttrBnList[i]:SetText(iText)
				end
			end
			if m_sel <= 0 or m_sel > attrNum then
				m_sel = 1
				m_AttrBnList[1]:SetCheck(1)
			else
				m_AttrBnList[m_sel]:SetCheck(1)
			end
		
			local needMoney = PlayerPackage:GetBagKfsAttrExUpMoney(m_Equip_Idx , m_sel - 1)
			WuhunExtraPropertyUp_DemandMoney : SetProperty("MoneyNumber", needMoney)
		end
	else
		m_sel = -1
	end
	
	if m_Equip_Idx ~= -1 and m_Equip_Item ~= -1 then
		WuhunExtraPropertyUp_OK:Enable()
	end
end