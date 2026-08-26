--!!!reloadscript =Lingyu_XiShuxing

local g_Lingyu_XiShuxing_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_LingYu_BagIndex = -1
local g_Item_BagIndex = -1

local g_Attr_Before_Text = {}
local g_Attr_After_Text = {}

local g_NeedItemTableIndex = {20600005, 20600006, 20600045, 20600046}

local g_ExtraWashItem1 = 20600007
local g_ExtraWashItem2 = 20600008
local g_Need_Mondy = {10000, 20000, 30000, 50000}

function Lingyu_XiShuxing_PreLoad()
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
end

function Lingyu_XiShuxing_OnLoad()
	g_Lingyu_XiShuxing_Frame_UnifiedPosition = Lingyu_XiShuxing_Frame:GetProperty("UnifiedPosition")
	
	g_Attr_Before_Text[1] = Lingyu_XiShuxing_BeforeAttr1
	g_Attr_Before_Text[2] = Lingyu_XiShuxing_BeforeAttr2
	g_Attr_Before_Text[3] = Lingyu_XiShuxing_BeforeAttr3
	
	g_Attr_After_Text[1] = Lingyu_XiShuxing_AfterAttr1
	g_Attr_After_Text[2] = Lingyu_XiShuxing_AfterAttr2
	g_Attr_After_Text[3] = Lingyu_XiShuxing_AfterAttr3
end

function Lingyu_XiShuxing_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880801 then
		if not this:IsVisible() then
			Lingyu_XiShuxing_CleanUp()
			this:Show()
			Lingyu_XiShuxing_Update()
			Lingyu_XiShuxing_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Lingyu_XiShuxing_ItemCheck()
		Lingyu_XiShuxing_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Lingyu_XiShuxing_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Lingyu_XiShuxing_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Lingyu_XiShuxing_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 36 then
			Lingyu_XiShuxing_OnItemDragedDropFromBag(tonumber(arg1), 0)
		end
		
		if tonumber(arg0) == 37 then		
			Lingyu_XiShuxing_OnItemDragedDropFromBag(tonumber(arg1), 1)
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Lingyu_XiShuxing" and tonumber(arg0) ~= nil then
			Lingyu_XiShuxing_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 36 then
			Lingyu_XiShuxing_OnItemDragedDropAway(0)
		end
		
		if tonumber(arg0) == 37 then		
			Lingyu_XiShuxing_OnItemDragedDropAway(1)
		end
		
		return
	end
end

function Lingyu_XiShuxing_ItemCheck()
	if g_LingYu_BagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemLingYu(g_LingYu_BagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_LingYu_BagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
			g_LingYu_BagIndex = -1
		end
	end
	
	if g_Item_BagIndex ~= 1 then
		local need_remove = 0
		if g_LingYu_BagIndex == -1 then
			need_remove = 1
		end
		
		--加锁
		if PlayerPackage:IsLock(g_Item_BagIndex) == 1 then
			need_remove = 1
		end
		
		if g_LingYu_BagIndex ~= -1 then
			local iQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
			if iQual < 0 or iQual > 3 then
				iQual = 0
			end
			
			local bag_item_index = PlayerPackage:GetItemTableIndex(g_Item_BagIndex)
			
			if bag_item_index == g_ExtraWashItem1 then
				if iQual ~= 2 then
					need_remove = 1
				end
			elseif bag_item_index == g_ExtraWashItem2 then
				if iQual ~= 3 then
					need_remove = 1
				end
			else
				if bag_item_index ~= g_NeedItemTableIndex[iQual + 1] then
					need_remove = 1
				end
			end
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
			g_Item_BagIndex = -1
		end
	end
end

function Lingyu_XiShuxing_Update()
	
	local strTemp = ""
	Lingyu_XiShuxing_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Lingyu_XiShuxing_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	for i = 1, 3 do
		g_Attr_Before_Text[i]:SetText("")
		g_Attr_After_Text[i]:SetText("")
	end
	
	Lingyu_XiShuxing_Item:SetActionItem(-1)
	Lingyu_XiShuxing_Need_Item:SetActionItem(-1)
	Lingyu_XiShuxing_DemandMoney:SetProperty("MoneyNumber", "0")

	if g_LingYu_BagIndex ~= -1 then		
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 1)
		local theAction = EnumAction(g_LingYu_BagIndex, "packageitem")
		Lingyu_XiShuxing_Item:SetActionItem(theAction:GetID())
		
		local lyQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
		
		local need_money = g_Need_Mondy[1]
		if g_Need_Mondy[lyQual + 1] ~= nil then
			need_money = g_Need_Mondy[lyQual + 1]
		end
		Lingyu_XiShuxing_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
		
		local ex_count = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "EX_COUNT")
		
		for i = 1, 3 do
			if i > ex_count then
				break
			end
			
			local before_rate = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "FIXRATE", i - 1)
			local after_rate = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "NEWFIXRATE", i - 1)

			local before_attr_str = PlayerPackage:LuaFnGetBagItemLingYuExAttrDesc(g_LingYu_BagIndex, i - 1, before_rate)
			g_Attr_Before_Text[i]:SetText(before_attr_str)
			
			if after_rate ~= 0 then
				local after_attr_str = PlayerPackage:LuaFnGetBagItemLingYuExAttrDesc(g_LingYu_BagIndex, i - 1, after_rate)
				g_Attr_After_Text[i]:SetText(after_attr_str)
			end			
		end
		
		if g_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 1)
			local theAction = EnumAction(g_Item_BagIndex, "packageitem")
			Lingyu_XiShuxing_Need_Item:SetActionItem(theAction:GetID())
		end
	end	
end

function Lingyu_XiShuxing_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Lingyu_XiShuxing_OnItemDragedDropFromBag(iBagIndex, flag)
	
	--拖到灵玉框
	if flag == 0 then
		if PlayerPackage:LuaFnIsBagItemLingYu(iBagIndex) ~= 1 then
			PushDebugMessage("#{SZXT_221216_105}")
			return
		end

		--加锁
		if PlayerPackage:IsLock(iBagIndex) == 1 then
			PushDebugMessage("#{Item_Locked}")
			return
		end
		
		if g_LingYu_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		end
		g_LingYu_BagIndex = iBagIndex
		
		--如果洗炼材料不符合，清繝
		if g_Item_BagIndex ~= -1 then
			local iQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
			if iQual < 0 or iQual > 3 then
				iQual = 0
			end
			
			local bag_item_index = PlayerPackage:GetItemTableIndex(g_Item_BagIndex)
			if bag_item_index == g_ExtraWashItem1 then
				if iQual ~= 2 then
					LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
					g_Item_BagIndex = -1
				end
			elseif bag_item_index == g_ExtraWashItem2 then
				if iQual ~= 3 then
					LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
					g_Item_BagIndex = -1
				end
			else
				if bag_item_index ~= g_NeedItemTableIndex[iQual + 1] then
					LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
					g_Item_BagIndex = -1
				end
			end
		end
		Lingyu_XiShuxing_Update()
	end
	
	--拖到材料框
	if flag == 1 then
		if g_LingYu_BagIndex == -1 then
			PushDebugMessage("#{SZXT_221216_140}")
			return
		end
		
		local iQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
		if iQual < 0 or iQual > 3 then
			iQual = 0
		end
		
		local bag_item_index = PlayerPackage:GetItemTableIndex(iBagIndex)
		
		if bag_item_index == g_ExtraWashItem1 then
			if iQual ~= 2 then
				PushDebugMessage("#{SZXT_221216_142}")
				return
			end
		elseif bag_item_index == g_ExtraWashItem2 then
			if iQual ~= 3 then
				PushDebugMessage("#{SZXT_221216_141}")
				return
			end
		else
			if bag_item_index ~= g_NeedItemTableIndex[iQual + 1] then
				local need_item_name = DataPool:LuaFnGetItemNameByTableIndex(g_NeedItemTableIndex[iQual + 1])
				local strTemp = ScriptGlobal_Format("#{SZXT_221216_109}", need_item_name)
				PushDebugMessage(strTemp)
				return
			end
		end

		--加锁
		if PlayerPackage:IsLock(iBagIndex) == 1 then
			PushDebugMessage("#{Item_Locked}")
			return
		end
		
		if g_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
		end
		g_Item_BagIndex = iBagIndex
		Lingyu_XiShuxing_Update()
	end
	
end

function Lingyu_XiShuxing_OnBagItemRClicked(iBagIndex)
	if PlayerPackage:LuaFnIsBagItemLingYu(iBagIndex) == 1 then
		Lingyu_XiShuxing_OnItemDragedDropFromBag(iBagIndex, 0)
		return
	end
	
	if g_LingYu_BagIndex == -1 then
		PushDebugMessage("#{SZXT_221216_105}")
	else
		Lingyu_XiShuxing_OnItemDragedDropFromBag(iBagIndex, 1)	
	end	
end

function Lingyu_XiShuxing_OnItemDragedDropAway(flag)
	if flag == 0 then
		if g_LingYu_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
			g_LingYu_BagIndex = -1
		end

		if g_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
			g_Item_BagIndex = -1
		end
		Lingyu_XiShuxing_Update()
	else
		if g_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
			g_Item_BagIndex = -1
		end
		Lingyu_XiShuxing_Update()
	end
end

function Lingyu_XiShuxing_LingYu_OnRBClicked()
	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
		if g_Item_BagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
			g_Item_BagIndex = -1
		end
		Lingyu_XiShuxing_Update()
	end	
end

function Lingyu_XiShuxing_Need_Item_OnRBClicked()
	if g_Item_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
		g_Item_BagIndex = -1
		Lingyu_XiShuxing_Update()
	end
end

function Lingyu_XiShuxing_CleanUp()
	
	for i = 1, 3 do
		g_Attr_Before_Text[i]:SetText("")
		g_Attr_After_Text[i]:SetText("")
	end

	Lingyu_XiShuxing_DemandMoney:SetProperty("MoneyNumber", "0")
	Lingyu_XiShuxing_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Lingyu_XiShuxing_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_XiShuxing_Item:SetActionItem(-1)
	if g_LingYu_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
	end
	
	Lingyu_XiShuxing_Need_Item:SetActionItem(-1)
	if g_Item_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_Item_BagIndex, 0)
		g_Item_BagIndex = -1
	end

end

function Lingyu_XiShuxing_OnHidden()
	Lingyu_XiShuxing_CleanUp()
	m_ObjServerId = -1
end

function Lingyu_XiShuxing_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_221216_114}")
		return
	end
	
	if DataPool:Lua_IsMissionComplete(2169) ~= 1 then
	--	PushDebugMessage("#{SZXT_221216_115}")
	--	return
	end	

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYu_Wash")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_LingYu_BagIndex)
		Set_XSCRIPT_Parameter(2, g_Item_BagIndex)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Lingyu_XiShuxing_Switch()
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_221216_133}")
		return
	end
	
	if DataPool:Lua_IsMissionComplete(2169) ~= 1 then
	--	PushDebugMessage("#{SZXT_221216_134}")
	--	return
	end	

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYu_Switch")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_LingYu_BagIndex)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Lingyu_XiShuxing_HelpClicked()

end
--Care Obj
function Lingyu_XiShuxing_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Lingyu_XiShuxing_Frame_On_ResetPos()
	if g_Lingyu_XiShuxing_Frame_UnifiedPosition ~= nil then
		Lingyu_XiShuxing_Frame:SetProperty("UnifiedPosition", g_Lingyu_XiShuxing_Frame_UnifiedPosition)
	end
end
