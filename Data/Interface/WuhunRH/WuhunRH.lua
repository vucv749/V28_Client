local m_UI_NUM = 20090824
local m_ObjCared = -1

local m_slotItem = {-1 , -1 ,-1}
local m_itemAction = {}
local m_SlotDirty = {0 , 0 , 0}
local INDEX_ATTRUP_BEGIN	= 20310122	--???·?(1?)
local INDEX_ATTRUP_END		= 20310157	--???·?(9?)
local g_RunHunShi = { 
	
	{
		20310122,	--???·?(1?)
		20310123,	--???·?(2?)
		20310124,	--???·?(3?)
		20310125,	--???·?(4?)
		20310126,	--???·?(5?)
		20310127,	--???·?(6?)
		20310128,	--???·?(7?)
		20310129,	--???·?(8?)
		20310130,	--???·?(9?)
	},
	{
		20310131,	--???·?(1?)
		20310132,	--???·?(2?)
		20310133,	--???·?(3?)
		20310134,	--???·?(4?)
		20310135,	--???·?(5?)
		20310136,	--???·?(6?)
		20310137,	--???·?(7?)
		20310138,	--???·?(8?)
		20310139,	--???·?(9?)
	},
	{
		20310140,	--???·?(1?)
		20310141,	--???·?(2?)
		20310142,	--???·?(3?)
		20310143,	--???·?(4?)
		20310144,	--???·?(5?)
		20310145,	--???·?(6?)
		20310146,	--???·?(7?)
		20310147,	--???·?(8?)
		20310148,	--???·?(9?)
	},

	{
		20310149,	--???·?(1?)
		20310150,	--???·?(2?)
		20310151,	--???·?(3?)
		20310152,	--???·?(4?)
		20310153,	--???·?(5?)
		20310154,	--???·?(6?)
		20310155,	--???·?(7?)
		20310156,	--???·?(8?)
		20310157,	--???·?(9?)
	},
}

--Èó»êÊ¯ÏûºÄ½ðÇ®
local g_RunHunShi_Money = {5000 , 5000 ,10000 ,10000 ,15000 ,15000 ,20000, 20000 }

local isComfirmed = 0
--=========
--PreLoad==
--=========
function WuhunRH_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	
	this:RegisterEvent("RHHC_PUT_ONE");
end
--=========
--OnLoad
--=========
function WuhunRH_OnLoad()
	m_itemAction[1] = WuhunRH_Space1
	m_itemAction[2] = WuhunRH_Space2
	m_itemAction[3] = WuhunRH_Space3

end
--=========
--OnEvent
--=========
function WuhunRH_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == m_UI_NUM) then
		WuhunRH_BeginCareObj( Get_XParam_INT(0) );
		WuhunRh_CleanUp()
		this:Show();
		WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then 
		WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	
	elseif (event == "RHHC_PUT_ONE" and this:IsVisible()) then 
		if arg0 ~= nil and arg1 ~= nil then
			WuhunRH_Put_One(tonumber(arg0) , tonumber(arg1))
		end
	elseif event == "PACKAGE_ITEM_CHANGED" and this : IsVisible() then
		if not arg0 or tonumber( arg0 ) == -1 then
			return
		end

		for i = 1, 3 do
			if m_slotItem[i] == tonumber( arg0 ) then
				WuhunRH_TakeOff_One(i)
				break
			end
		end
	end
end

function WuhunRH_Put_One(itemIdx , slot_id)
	
	local theAction = EnumAction(itemIdx, "packageitem");

	if theAction:GetID() ~= 0 then
		local itemID = PlayerPackage:GetItemTableIndex(itemIdx)
		if itemID < INDEX_ATTRUP_BEGIN or itemID > INDEX_ATTRUP_END then
			PushDebugMessage("#{WH_090729_29}") -- ??????????
			return
		end

		for i =1 ,4 do
			if itemID == g_RunHunShi[i][9] then
				PushDebugMessage("#{WH_090729_38}") -- ???????????9?,???????
				return
			end
		end

		if PlayerPackage:IsLock( itemIdx ) == 1 then
			PushDebugMessage("#{WH_090729_07}")	--??????
			return
		end

		if slot_id == 0 then  --??????
			
			
			for i = 1, 3 do
				if m_slotItem[i] > 0 and PlayerPackage:GetItemTableIndex(m_slotItem[i]) ~= itemID then
					PushDebugMessage("#{WH_090729_39}")	--??????????????????????
					return
				end
			end
			
			local num = WuhunRH_GetNum()
			local level = WuhunRH_GetLevel()


			if level >= 5 and num >= 2 then
				PushDebugMessage("#{WH_090817_03}")	--5???(??5?)???????2??????????
				return
			end

			local changed = 0
			for i = 1, 3 do
				if m_slotItem[i] < 0 then
					m_slotItem[i] = itemIdx
					m_SlotDirty[i] = 1
					changed = 1	
					break;
				end
			end
			if changed == 1 then
				WuhunRH_Update()
			end

		elseif slot_id == 1 or slot_id == 2 or slot_id == 3 then
			for i = 1, 3 do
				if i ~= slot_id and m_slotItem[i] > 0 and PlayerPackage:GetItemTableIndex(m_slotItem[i]) ~= itemID then
					PushDebugMessage("#{WH_090729_39}")	--??????????????????????
					return
				end
			end
			
			local num = WuhunRH_GetNum()
			local level = WuhunRH_GetLevel()

			if m_slotItem[slot_id] > 0 then
				LifeAbility : Lock_Packet_Item(m_slotItem[slot_id],0);
				m_itemAction[slot_id]:SetActionItem(-1);	
			else
				if level >= 5 and num >= 2 then
					PushDebugMessage("#{WH_090817_03}")	--5???(??5?)???????2??????????
					return
				end
			end

			m_slotItem[slot_id] = itemIdx
			m_SlotDirty[slot_id] = 1

			WuhunRH_Update()
		end
	end
end
--=========
--Update UI
--=========
function WuhunRH_Update()
	WuhunRH_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	WuhunRH_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	for i=1 , 3 do
		if m_SlotDirty[i] == 1 then
			local theAction = EnumAction(m_slotItem[i], "packageitem");
			if theAction:GetID() ~= 0 then
				m_itemAction[i]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(m_slotItem[i],1);
			else
				m_itemAction[i]:SetActionItem(-1);
				LifeAbility : Lock_Packet_Item(m_slotItem[i],0);
			end
			m_SlotDirty[i] = 0
		end
	end
	
	local level = WuhunRH_GetLevel()
	if level > 0 and level < 9 then
		WuhunRH_NeedMoney:SetProperty("MoneyNumber", g_RunHunShi_Money[level])
	end

	local num = WuhunRH_GetNum()
	local level = WuhunRH_GetLevel()

	if level >= 5 and num >= 2 then
		WuhunRH_SuccessValue:SetText("#G100%")
		WuhunRH_OK:Enable()
	elseif level < 5 and num == 3 then
		WuhunRH_SuccessValue:SetText("#G100%")
		WuhunRH_OK:Enable()
	else
		WuhunRH_SuccessValue:SetText("#{WH_xml_XX(51)}")
		WuhunRH_OK:Disable()
	end

	isComfirmed = 0

end
--=========
--Care Obj
--=========
function WuhunRH_BeginCareObj(obj_id)
	
	m_ObjCared = DataPool : GetNPCIDByServerID(obj_id);
	this:CareObject(m_ObjCared, 1);
end
--=========
--OnOK
--=========
function WuhunRH_OK_Clicked()
	
	local num = WuhunRH_GetNum()
	if num == 0 then
		return
	end
	
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	local level = WuhunRH_GetLevel()
	local needMoney = 0
	if level >=7 then		--?? ???? ???
		PushDebugMessage("#{WH_090828_03}")		-- 5??????
		return
	end
	if level > 0 and level < 9 then
		needMoney = g_RunHunShi_Money[level]
	end
	
	if selfMoney < needMoney then
		PushDebugMessage("#{WH_090729_18}")   --???,???????,???????
		return
	end
		
	if isComfirmed == 0 then
		local bindStatus = 0
		for i=1 ,3 do
			if m_slotItem[i] > 0 and PlayerPackage:GetItemBindStatusByIndex(m_slotItem[i]) == 1 then
				bindStatus = 1
				break
			end			
		end
		if bindStatus == 1  then
			PopComfirm_Alpha0("#{WH_090729_04}")  --????
			isComfirmed = 1
			return
		end
	end

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("RunHun_Compound");
		Set_XSCRIPT_ScriptID( 809270 );
		Set_XSCRIPT_Parameter(0,m_slotItem[1]);
		Set_XSCRIPT_Parameter(1,m_slotItem[2]);
		Set_XSCRIPT_Parameter(2,m_slotItem[3]);
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT();

	WuhunRh_CleanUp()

end

--=========
--handle Hide Event
--=========
function WuhunRH_OnHiden()
	WuhunRh_CleanUp()
end

function WuhunRH_Close()
	this:Hide()
end

function WuhunRH_TakeOff_One(idx)
	if m_slotItem[idx] > 0 then
		LifeAbility : Lock_Packet_Item(m_slotItem[idx],0);
		m_itemAction[idx]:SetActionItem(-1);
		m_slotItem[idx] = -1
		m_SlotDirty[idx] = 1
		isComfirmed = 0
		WuhunRH_Update()
	end
end

function WuhunRh_CleanUp()
	for i =1 , 3 do
		if m_slotItem[i] > 0 then
			LifeAbility : Lock_Packet_Item(m_slotItem[i],0);
		end
		m_itemAction[i]:SetActionItem(-1);
		m_slotItem[i] = -1 
		m_m_SlotDirty[i] = 0
	end
	isComfirmed = 0
	WuhunRH_OK:Disable()
	WuhunRH_SuccessValue:SetText("#{WH_xml_XX(51)}")

end
--µÃµ½µ±Ç°UIÉÏÈó»êÊ¯µÈ¼¶
function WuhunRH_GetLevel()
	local level = 0
	for i=1 , 3 do
		if m_slotItem[i] >0 then			
			local itemID = PlayerPackage:GetItemTableIndex(m_slotItem[i])
			for j = 1, 4 do
				if itemID >= g_RunHunShi[j][1]  and itemID < g_RunHunShi[j][9]  then
					for k = 1 , 8 do
						if g_RunHunShi[j][k] == itemID then
							level = k
						end
					end
				end
			end
			break
		end
	end
	return level
end
--µÃµ½µ±Ç°UIÉÏÓÐ¼¸¿ÅÈó»êÊ¯
function WuhunRH_GetNum()
	local num = 0
	for i=1 , 3 do
		if m_slotItem[i] > 0 then
			num = num + 1
		end
	end
	return num
end
--Í¨¹ýÈó»êÊ¯µÄIDµÃµ½Èó»êÊ¯µÈ¼¶
function WuhunRH_GetLevel_By_TableIndex(tableidx)
	local level = 0
	for i = 1, 4 do
		for j = 1 , 9 do
			if g_RunHunShi[i][j] == tableidx then
				level = j
			end
		end
	end
	return level
end
