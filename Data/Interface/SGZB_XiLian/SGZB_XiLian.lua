--!!!reloadscript =SGZB_XiLian

local g_SGZB_XiLian_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_Equip_BagIndex = -1
local g_Equip_ActionButton_AcceptNum = 54

local g_LevelLimit = 60

local g_Washed = 0
local g_Need_Item_ID7 = 38003056
local g_Need_Item_ID8 = 38003055
local g_Need_Item_Count = 1
local g_Bind_Confirmed = 0

function SGZB_XiLian_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("BAG_ITEM_DRAGDROP_TO_UI")
	this:RegisterEvent("BAG_ITEM_RBCLICK_TO_UI")
	this:RegisterEvent("BAG_ITEM_DRAGAWAY_FROM_UI")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_EQUIP_REFRESH_POOL")
	this:RegisterEvent("EQUIP_REFRESH_EQUIP_CHANGE_CONFIRMED")
	this:RegisterEvent("EQUIP_REFRESH_CLOSE_CONFIRMED")
	this:RegisterEvent("EQUIP_REFRESH_BIND_CONFIRMED")
end

function SGZB_XiLian_OnLoad()
	g_SGZB_XiLian_Frame_UnifiedPosition = SGZB_XiLian_Frame:GetProperty("UnifiedPosition")
end

function SGZB_XiLian_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88882001 then
		if not this:IsVisible() then
			SGZB_XiLian_CleanUp()
			this:Show()
			SGZB_XiLian_OnShown()
			SGZB_XiLian_Update()
			SGZB_XiLian_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		SGZB_XiLian_ItemCheck()	
		SGZB_XiLian_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		SGZB_XiLian_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			SGZB_XiLian_CurrentlyJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			SGZB_XiLian_CurrentlyMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_Equip_ActionButton_AcceptNum and tonumber(arg1) ~= nil then
			SGZB_XiLian_Item_OnItemDragedDropFromBag(tonumber(arg1), 1)
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "SGZB_XiLian" and tonumber(arg0) ~= nil then
			SGZB_XiLian_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_Equip_ActionButton_AcceptNum then
			SGZB_XiLian_Item_OnItemDragedDropAway()
		end
		return
	end
	
	if event == "UPDATE_EQUIP_REFRESH_POOL" and this:IsVisible() then
		if tonumber(arg0) == 1 then
			g_Washed = 0
			g_Bind_Confirmed = 0
			SGZB_XiLian_Update()
		elseif tonumber(arg0) == 2 then
			g_Washed = 1
			g_Bind_Confirmed = 0
			SGZB_XiLian_Update()
		end
	end
	
	if event == "EQUIP_REFRESH_EQUIP_CHANGE_CONFIRMED" and this:IsVisible() then
		local from_bag_index = tonumber(arg0)
		local to_bag_index = tonumber(arg1)
		if to_bag_index < 0 then
			SGZB_XiLian_Equip_OnRBClicked(0)
		else
			SGZB_XiLian_Item_OnItemDragedDropFromBag(to_bag_index, 0)
		end
		return
	end
	
	if event == "EQUIP_REFRESH_CLOSE_CONFIRMED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "EQUIP_REFRESH_BIND_CONFIRMED" and this:IsVisible() then
		g_Bind_Confirmed = 1
	end
end

function SGZB_XiLian_OnShown()
	OpenWindow("Packet")
end

function SGZB_XiLian_ItemCheck()
	if g_Equip_BagIndex ~= -1 then
		local need_remove = 0
		--加锁
		if PlayerPackage:IsLock(g_Equip_BagIndex) == 1 then
		--	need_remove = 1
		end

		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
			g_Equip_BagIndex = -1
		end
	end
end

function SGZB_XiLian_Update()
	if g_Equip_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 1)
		local theAction = EnumAction(g_Equip_BagIndex, "packageitem")
		SGZB_XiLian_Object:SetActionItem(theAction:GetID())
		
		local equip_item_index = PlayerPackage:GetItemTableIndex(g_Equip_BagIndex)
		local equip_icon = DataPool:LuaFnGetItemIconByTableIndex(equip_item_index)
		SGZB_XiLian_Object2:SetImage(tostring(equip_icon))

		local attr_count = PlayerPackage:LuaFnGetEquipAttrCount(g_Equip_BagIndex)
		local attrString = ""
		for i = 1, attr_count do
			local tempstr = PlayerPackage:LuaFnEnumEquipExtAttr(g_Equip_BagIndex, i - 1)
			if i ~= 1 then
				attrString = attrString.."#r"..tempstr
			else
				attrString = attrString..tempstr
			end
		end
		SGZB_XiLian_Bk1_Text2:SetText(attrString)
		
		local refresh_times = PlayerPackage:LuaFnGetEquipAttrRefreshTimes(g_Equip_BagIndex)
		if refresh_times == 3 then
			SGZB_XiLian_CaiLiaoText:SetText("#{SGCX_20231227_31}")
		else
			if PlayerPackage:LuaFnGetEquipQual(g_Equip_BagIndex) == 7 then
				local need_item_name = DataPool:LuaFnGetItemNameByTableIndex(g_Need_Item_ID7)
				local strNeedItem = ScriptGlobal_Format("#{SGCX_20231227_64}", tostring(g_Need_Item_Count), tostring(need_item_name))
				SGZB_XiLian_CaiLiaoText:SetText(strNeedItem)
			else
				local need_item_name = DataPool:LuaFnGetItemNameByTableIndex(g_Need_Item_ID8)
				local strNeedItem = ScriptGlobal_Format("#{SGCX_20231227_64}", tostring(g_Need_Item_Count), tostring(need_item_name))
				SGZB_XiLian_CaiLiaoText:SetText(strNeedItem)
			end
		end
		
		if g_Washed == 1 then
			SGZB_XiLian_OK:Disable()
			SGZB_XiLian_Bk1_Btn:Enable()
			SGZB_XiLian_Bk2_Btn:Enable()

			local new_attr_count = DataPool:LuaFnGetEquipRefreshAttrCount()
			local newAttrString = ""
			for i = 1, new_attr_count do
				local tempstr = DataPool:LuaFnEnumEquipRefreshAttr(i - 1)
				if i ~= 1 then
					newAttrString = newAttrString.."#r"..tempstr
				else
					newAttrString = newAttrString..tempstr
				end
			end
			SGZB_XiLian_Bk2_Text2:SetText(newAttrString)
		else
			SGZB_XiLian_OK:Enable()
			SGZB_XiLian_Bk1_Btn:Disable()
			SGZB_XiLian_Bk2_Btn:Disable()
			SGZB_XiLian_Bk2_Text2:SetText("")
		end
		SGZB_XiLian_DemandMoney:SetProperty("MoneyNumber", "200000")
	else
		--SGZB_XiLian_Object:SetToolTip("#{SGCX_20231227_44}")
		SGZB_XiLian_Object:SetActionItem(-1)
		SGZB_XiLian_Object2:SetImage("")
		SGZB_XiLian_CaiLiaoText:SetText("")
		SGZB_XiLian_Bk1_Text2:SetText("")
		SGZB_XiLian_Bk2_Text2:SetText("")
		SGZB_XiLian_OK:Disable()
		SGZB_XiLian_Bk1_Btn:Disable()
		SGZB_XiLian_Bk2_Btn:Disable()
		SGZB_XiLian_DemandMoney:SetProperty("MoneyNumber", "0")
	end
	
	SGZB_XiLian_CurrentlyJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	SGZB_XiLian_CurrentlyMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
end

function SGZB_XiLian_CloseClicked()
	if g_Equip_BagIndex ~= -1 and g_Washed == 1 then
		DataPool:LuaFnShowEquipRefreshCloseConfirm()
		return
	end
	this:Hide()
end

function SGZB_XiLian_CancelClicked()
	if g_Equip_BagIndex ~= -1 and g_Washed == 1 then
		DataPool:LuaFnShowEquipRefreshCloseConfirm()
		return
	end
	this:Hide()
end

--从背包拖拽到UI
function SGZB_XiLian_Item_OnItemDragedDropFromBag(iBagIndex, need_confirm)
	
	if PlayerPackage:LuaFnIsEquip(iBagIndex) ~= 1 then
		PushDebugMessage("#{SGCX_20231227_32}")
		return
	end
	
	if PlayerPackage:LuaFnIsHandMakeEquip(iBagIndex) ~= 1 then
		PushDebugMessage("#{SGCX_20231227_32}")
		return
	end
	
	local ep = PlayerPackage:LuaFnGetBagItemEquipPoint(iBagIndex)
	if SGZB_XiLian_IsEquipPointValid(ep) ~= 1 then
		PushDebugMessage("#{SGCX_20231227_32}")
		return
	end
	
	if PlayerPackage:LuaFnGetEquipQual(iBagIndex) < 7 then
		PushDebugMessage("#{SGCX_20231227_33}")
		return
	end
	
	if PlayerPackage:LuaFnGetEquipAttrRefreshTimes(iBagIndex) == 3 then
	--	PushDebugMessage("#{SGCX_20231227_36}")
	--	return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
	--	PushDebugMessage("#{Item_Locked}")
	--	return
	end
	
	if g_Equip_BagIndex ~= -1 then
		if g_Washed == 1  then
			if need_confirm == 1 then
				DataPool:LuaFnShowEquipRefreshEquipChangeConfirm(g_Equip_BagIndex, iBagIndex)
				return
			else
				Clear_XSCRIPT()
					Set_XSCRIPT_ScriptID(888820)
					Set_XSCRIPT_Function_Name("DiscardNewEquipAttr")
					Set_XSCRIPT_Parameter(0, g_Equip_BagIndex)
					Set_XSCRIPT_Parameter(1, 0)
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
				LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
				g_Washed = 0
			end
		else
			LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
		end
	end
	g_Equip_BagIndex = iBagIndex
	g_Bind_Confirmed = 0
	SGZB_XiLian_Update()
end

function SGZB_XiLian_Item_OnBagItemRClicked(iBagIndex)
	SGZB_XiLian_Item_OnItemDragedDropFromBag(iBagIndex, 1)	
end

function SGZB_XiLian_Item_OnItemDragedDropAway()
	SGZB_XiLian_Equip_OnRBClicked(1)
end

function SGZB_XiLian_Equip_OnRBClicked(need_confirm)
	if g_Equip_BagIndex ~= -1 then
		if g_Washed == 1 then
			if need_confirm == 1 then
				DataPool:LuaFnShowEquipRefreshEquipChangeConfirm(g_Equip_BagIndex, -1)
				return
			else
				Clear_XSCRIPT()
					Set_XSCRIPT_ScriptID(888820)
					Set_XSCRIPT_Function_Name("DiscardNewEquipAttr")
					Set_XSCRIPT_Parameter(0, g_Equip_BagIndex)
					Set_XSCRIPT_Parameter(1, 0)
					Set_XSCRIPT_ParamCount(2)
				Send_XSCRIPT()
				SGZB_XiLian_Object:SetActionItem(-1)
				LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
				g_Equip_BagIndex = -1
				g_Washed = 0
				g_Bind_Confirmed = 0
				SGZB_XiLian_Update()
			end		
		else
			SGZB_XiLian_Object:SetActionItem(-1)
			LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
			g_Equip_BagIndex = -1
			g_Bind_Confirmed = 0
			SGZB_XiLian_Update()
		end		
	end
end

function SGZB_XiLian_CleanUp()
	SGZB_XiLian_Object:SetActionItem(-1)
	if g_Equip_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Equip_BagIndex, 0)
		g_Equip_BagIndex = -1
	end
	SGZB_XiLian_DemandMoney:SetProperty("MoneyNumber", "0")
end

function SGZB_XiLian_OnHidden()
	SGZB_XiLian_CleanUp()
	m_ObjServerId = -1
	g_Washed = 0
	g_Bind_Confirmed = 0
end

function SGZB_XiLian_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LevelLimit then
		PushDebugMessage("#{SGCX_20231227_20}")
		return
	end
	
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888820)
		Set_XSCRIPT_Function_Name("RefreshEquipAttr")
		Set_XSCRIPT_Parameter(0, g_Equip_BagIndex)
		Set_XSCRIPT_Parameter(1, g_Bind_Confirmed)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function SGZB_XiLian_DiscardNewAttr()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888820)
		Set_XSCRIPT_Function_Name("DiscardNewEquipAttr")
		Set_XSCRIPT_Parameter(0, g_Equip_BagIndex)
		Set_XSCRIPT_Parameter(1, 1)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function SGZB_XiLian_SwitchAttr()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888820)
		Set_XSCRIPT_Function_Name("SwitchEquipAttr")
		Set_XSCRIPT_Parameter(0, g_Equip_BagIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function SGZB_XiLian_HelpClicked()

end
--Care Obj
function SGZB_XiLian_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	--this:CareObject(npc_id, 1)
end

function SGZB_XiLian_Frame_On_ResetPos()
	if g_SGZB_XiLian_Frame_UnifiedPosition ~= nil then
		SGZB_XiLian_Frame:SetProperty("UnifiedPosition", g_SGZB_XiLian_Frame_UnifiedPosition)
	end
end

function SGZB_XiLian_IsEquipPointValid(ep)
	local valid_ep = {1, 2, 3, 4, 5, 6, 7, 12, 14, 15}
	for i = 1, table.getn(valid_ep) do
		if ep == valid_ep[i] then
			return 1
		end
	end
	return 0
end
