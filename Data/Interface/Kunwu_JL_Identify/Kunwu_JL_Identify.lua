--!!!reloadscript =Kunwu_JL_Identify

local g_Kunwu_JL_Identify_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_Elf_BagIndex = -1
local g_Elf_PerfectItemBagIndex = -1

local g_ActionButtonAcceptNum = 58
local g_ActionButtonAcceptNumEx = 59

local g_AttrNameLable = {}
local g_AttrValueLable = {}

local g_Identify_YuanbaoPay = 1
local g_NeedMoney = 50000

local g_Identify_NeedItem = 38003463

function Kunwu_JL_Identify_PreLoad()
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

function Kunwu_JL_Identify_OnLoad()
	g_Kunwu_JL_Identify_Frame_UnifiedPosition = Kunwu_JL_Identify_Frame:GetProperty("UnifiedPosition")
	
	g_AttrNameLable[1] = Kunwu_JL_Identify_Zizhi_Text2
	g_AttrNameLable[2] = Kunwu_JL_Identify_Zizhi_Text3
	g_AttrNameLable[3] = Kunwu_JL_Identify_Zizhi_Text4
	g_AttrNameLable[4] = Kunwu_JL_Identify_Zizhi_Text5
	g_AttrNameLable[5] = Kunwu_JL_Identify_Zizhi_Text6
	
	g_AttrValueLable[1] = Kunwu_JL_Identify_Zizhi_Text2_1
	g_AttrValueLable[2] = Kunwu_JL_Identify_Zizhi_Text3_1
	g_AttrValueLable[3] = Kunwu_JL_Identify_Zizhi_Text4_1
	g_AttrValueLable[4] = Kunwu_JL_Identify_Zizhi_Text5_1
	g_AttrValueLable[5] = Kunwu_JL_Identify_Zizhi_Text6_1
end

function Kunwu_JL_Identify_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883001 then
		if not this:IsVisible() then
			Kunwu_JL_Identify_CleanUp()
			if g_Identify_YuanbaoPay == 1 or g_Identify_YuanbaoPay == 0 then
	--			Kunwu_JL_Identify_Yuanbao_Bind:SetCheck(g_Identify_YuanbaoPay)
			end
			this:Show()
			OpenWindow("Packet")
			Kunwu_JL_Identify_Update()
			Kunwu_JL_Identify_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Kunwu_JL_Identify_ItemCheck()	
		Kunwu_JL_Identify_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Identify_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_JL_Identify_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_JL_Identify_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonAcceptNum and tonumber(arg1) ~= nil then
			Kunwu_JL_Identify_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		
		if tonumber(arg0) == g_ActionButtonAcceptNumEx and tonumber(arg1) ~= nil then
			Kunwu_JL_Identify_Item_OnItemDragedDropFromBagEx(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Kunwu_JL_Identify" and tonumber(arg0) ~= nil then
			Kunwu_JL_Identify_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonAcceptNum then
			Kunwu_JL_Identify_Item_OnItemDragedDropAway()
		end
		
		if tonumber(arg0) == g_ActionButtonAcceptNumEx then
			Kunwu_JL_Identify_Item_OnItemDragedDropAwayEx()
		end
		return
	end
end

function Kunwu_JL_Identify_ItemCheck()	
	if g_Elf_BagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_Elf_BagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
			g_Elf_BagIndex = -1
		end
	end
	
	if g_Elf_PerfectItemBagIndex ~= -1 then
		local need_remove = 0
		local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_PerfectItemBagIndex)
		if item_table_index ~= g_Identify_NeedItem then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_Elf_PerfectItemBagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_Elf_PerfectItemBagIndex, 0)
			g_Elf_PerfectItemBagIndex = -1
		end	
	end

end

function Kunwu_JL_Identify_Update()
	
	local strTemp = ""
	Kunwu_JL_Identify_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_JL_Identify_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Kunwu_JL_Identify_Object:SetActionItem(-1)
	Kunwu_JL_Identify_Money:SetProperty("MoneyNumber", "0")
	
	Kunwu_JL_Identify_PetModel:SetFakeObject("")
	
	for i = 1, 5 do
		g_AttrNameLable[i]:SetText("")
		g_AttrValueLable[i]:SetText("")
	end
	
	Kunwu_JL_Identify_Object2:SetActionItem(-1)
	Kunwu_JL_Identify_Object2_Num:Hide()
	Kunwu_JL_Identify_Object2_NumBK:Hide()
	
	if g_Elf_PerfectItemBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_PerfectItemBagIndex, 1)
		local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_PerfectItemBagIndex)
		local lay_num = PlayerPackage:GetBagItemNum(g_Elf_PerfectItemBagIndex)
		if GetItemBindStatus(g_Elf_PerfectItemBagIndex) == 1 then
			local theAction = DataPool:CreateBindActionItemForShow(g_Identify_NeedItem, 1)
			Kunwu_JL_Identify_Object2:SetActionItem(theAction:GetID())
		else
			local theAction = DataPool:CreateActionItemForShow(g_Identify_NeedItem, 1)
			Kunwu_JL_Identify_Object2:SetActionItem(theAction:GetID())
		end
		
		Kunwu_JL_Identify_Object2_NumBK:Show()
		Kunwu_JL_Identify_Object2_Num:Show()
		strTemp = ScriptGlobal_Format("#{JLYC_241217_147}", tostring(lay_num))
		Kunwu_JL_Identify_Object2_Num:SetText(strTemp)
	end

	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 1)
		local theAction = EnumAction(g_Elf_BagIndex, "packageitem")
		Kunwu_JL_Identify_Object:SetActionItem(theAction:GetID())
		
		Kunwu_JL_Identify_Money:SetProperty("MoneyNumber", tostring(g_NeedMoney))
		
		local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex)
		local iModel = DataPool:LuaFnGetItemPetElfModel(item_table_index)
		
		Kunwu_JL_Identify_PetModel:SetFakeObject("")
		DataPool:LuaFnSetItemPetElfAvatar1Model(iModel)
		Kunwu_JL_Identify_PetModel:SetFakeObject("Item_PetElf1")
		
		if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) == 1 then
			for i = 1, 5 do
				local attr_id, attr_value = PlayerPackage:LuaFnGetItemPetElfAttr(g_Elf_BagIndex, i - 1, 1)
				if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
					local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
					g_AttrNameLable[i]:SetText("#cfff263"..tostring(attr_name))
					g_AttrValueLable[i]:SetText("#cfff263+"..tostring(attr_value_string))
				end
			end
		else
			for i = 1, 5 do
				g_AttrNameLable[i]:SetText("#{JLYC_241217_20}")
			end
		end
	end
end

function Kunwu_JL_Identify_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Kunwu_JL_Identify_Item_OnItemDragedDropFromBag(iBagIndex)

	if PlayerPackage:LuaFnIsPetElf(iBagIndex) ~= 1 then
		PushDebugMessage("#{JLYC_241217_18}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
	end
	g_Elf_BagIndex = iBagIndex
	Kunwu_JL_Identify_Update()	
end

--从背包拖拽到UI
function Kunwu_JL_Identify_Item_OnItemDragedDropFromBagEx(iBagIndex)
	
	local item_table_index = PlayerPackage:GetItemTableIndex(iBagIndex)
	if item_table_index ~= g_Identify_NeedItem then
		PushDebugMessage("#{JLYC_241217_146}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	if g_Elf_PerfectItemBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_PerfectItemBagIndex, 0)
	end
	g_Elf_PerfectItemBagIndex = iBagIndex
	Kunwu_JL_Identify_Update()	
end

function Kunwu_JL_Identify_Item_OnBagItemRClicked(iBagIndex)
	local item_table_index = PlayerPackage:GetItemTableIndex(iBagIndex)
	if item_table_index ~= g_Identify_NeedItem then
		Kunwu_JL_Identify_Item_OnItemDragedDropFromBag(iBagIndex)
	else
		Kunwu_JL_Identify_Item_OnItemDragedDropFromBagEx(iBagIndex)
	end
end

function Kunwu_JL_Identify_Item_OnItemDragedDropAway()
	Kunwu_JL_Identify_Elf_OnRBClicked()
end

function Kunwu_JL_Identify_Item_OnItemDragedDropAwayEx()
	Kunwu_JL_Identify_Elf_OnRBClicked2()
end

function Kunwu_JL_Identify_Elf_OnRBClicked()
	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
		g_Elf_BagIndex = -1
		Kunwu_JL_Identify_Update()
	end
end

function Kunwu_JL_Identify_Elf_OnRBClicked2()
	if g_Elf_PerfectItemBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_PerfectItemBagIndex, 0)
		g_Elf_PerfectItemBagIndex = -1
		Kunwu_JL_Identify_Update()
	end
end

function Kunwu_JL_Identify_CleanUp()
	Kunwu_JL_Identify_Money:SetProperty("MoneyNumber", "0")
	Kunwu_JL_Identify_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Kunwu_JL_Identify_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Kunwu_JL_Identify_Object:SetActionItem(-1)
	if g_Elf_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
		g_Elf_BagIndex = -1
	end
	
	Kunwu_JL_Identify_Object2:SetActionItem(-1)
	if g_Elf_PerfectItemBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_PerfectItemBagIndex, 0)
		g_Elf_PerfectItemBagIndex = -1
	end
end

function Kunwu_JL_Identify_OnHidden()
	Kunwu_JL_Identify_CleanUp()
	m_ObjServerId = -1
--	g_Identify_YuanbaoPay = Kunwu_JL_Identify_Yuanbao_Bind:GetCheck()
	Kunwu_JL_Identify_PetModel:SetFakeObject("")
end

function Kunwu_JL_Identify_OK_Clicked()

	local my_level = Player:GetData("LEVEL")
	if my_level < 65 then
		PushDebugMessage("#{JLYC_241217_12}")
		return
	end
	
	if g_Elf_BagIndex == -1 then
		PushDebugMessage("#{JLYC_241217_35}")
		return
	end
	
	if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) == 1 then
		PushDebugMessage("#{JLYC_241217_36}")
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888830)
		Set_XSCRIPT_Function_Name("DoElfIdentify")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_Elf_BagIndex)
		Set_XSCRIPT_Parameter(2, g_Elf_PerfectItemBagIndex)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Kunwu_JL_Identify_HelpClicked()

end
--Care Obj
function Kunwu_JL_Identify_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_JL_Identify_Frame_On_ResetPos()
	if g_Kunwu_JL_Identify_Frame_UnifiedPosition ~= nil then
		Kunwu_JL_Identify_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Identify_Frame_UnifiedPosition)
	end
end

function Kunwu_JL_Identify_ModelTurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Identify_PetModel:RotateBegin(-0.3)
	--stop
	else
		Kunwu_JL_Identify_PetModel:RotateEnd()
	end
end

function Kunwu_JL_Identify_ModelTurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Identify_PetModel:RotateBegin(0.3)
	--stop
	else
		Kunwu_JL_Identify_PetModel:RotateEnd()
	end
end

function Kunwu_JL_Identify_YBPay_Clicked()

end