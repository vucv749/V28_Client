--!!!reloadscript =Kunwu_JL_Gather

local g_Kunwu_JL_Gather_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_Elf_BagIndex = {-1, -1, -1, -1, -1}

local g_ActionButtonAcceptNumMin = 66
local g_ActionButtonAcceptNumMax = 70

local g_ActionBtn = {}

local g_CompoundItem = {
--经验丹
38003475,
38003476,
38003477,
38003478,
38003479,
38003480,
}

local g_NeedMoney = {
20000,
25000,
30000,
35000,
40000,
50000,
}

local g_NeedToken = {
20,
25,
30,
35,
40,
50,
}


local g_PayMode = 0

function Kunwu_JL_Gather_PreLoad()
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
	this:RegisterEvent("UINT_IBPOWER")
end

function Kunwu_JL_Gather_OnLoad()
	g_Kunwu_JL_Gather_Frame_UnifiedPosition = Kunwu_JL_Gather_Frame:GetProperty("UnifiedPosition")
	
	g_ActionBtn[1] = Kunwu_JL_Gather_Button1
	g_ActionBtn[2] = Kunwu_JL_Gather_Button2
	g_ActionBtn[3] = Kunwu_JL_Gather_Button3
	g_ActionBtn[4] = Kunwu_JL_Gather_Button4
	g_ActionBtn[5] = Kunwu_JL_Gather_Button5
end

function Kunwu_JL_Gather_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883007 then
		if not this:IsVisible() then
			Kunwu_JL_Gather_CleanUp()
			this:Show()
			OpenWindow("Packet")
			g_PayMode = 0
			Kunwu_JL_Gather_Update()
			Kunwu_JL_Gather_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Kunwu_JL_Gather_ItemCheck()	
		Kunwu_JL_Gather_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Gather_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_JL_Gather_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_JL_Gather_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) >= g_ActionButtonAcceptNumMin and tonumber(arg0) <= g_ActionButtonAcceptNumMax and tonumber(arg1) ~= nil then
			Kunwu_JL_Gather_Item_OnItemDragedDropFromBag(tonumber(arg0) - g_ActionButtonAcceptNumMin + 1, tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Kunwu_JL_Gather" and tonumber(arg0) ~= nil then
			Kunwu_JL_Gather_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) >= g_ActionButtonAcceptNumMin and tonumber(arg0) <= g_ActionButtonAcceptNumMax then
			Kunwu_JL_Gather_Item_OnItemDragedDropAway(tonumber(arg0) - g_ActionButtonAcceptNumMin + 1)
		end
		return
	end
	
	if event == "UINT_IBPOWER" and arg0 == "player" then
		Kunwu_JL_Gather_Update()
	end
end

function Kunwu_JL_Gather_ItemCheck()
	for i = 1, 5 do
		if Kunwu_JL_Gather_NeedRemove(i) == 1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
			g_Elf_BagIndex[i] = -1
		end
	end
end

function Kunwu_JL_Gather_NeedRemove(idx)
	if idx >= 1 and idx <= 5  then
		if g_Elf_BagIndex[idx] ~= -1 then
			if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[idx]) ~= 1 then
				return 1
			end
			
			if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex[idx]) ~= 1 then
			--	return 1
			end
			
			--加锁
			if PlayerPackage:IsLock(g_Elf_BagIndex[idx]) == 1 then
				return 1
			end
			
			for i = 1, 5 do
				if g_Elf_BagIndex[i] ~= -1 and i ~= idx then
					local elf_qual = PlayerPackage:LuaFnGetPetElfItemQual(g_Elf_BagIndex[i])
					if PlayerPackage:LuaFnGetPetElfItemQual(g_Elf_BagIndex[idx]) ~= elf_qual then
						return 1
					end
				end
			end
		end
	end
	return 0
end

function Kunwu_JL_Gather_Update()
	
	local strTemp = ""
	Kunwu_JL_Gather_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_JL_Gather_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	local iIBPower = Player:GetData("IBPOWER")
	local need_token = 0
	
	Kunwu_JL_Gather_Button6:SetActionItem(-1)
	Kunwu_JL_Gather_Money:SetProperty("MoneyNumber", "0")
	
	if g_PayMode == 1 then
		Kunwu_JL_Gather_Info2_Item1:SetCheck(0)
		Kunwu_JL_Gather_Info2_Item2:SetCheck(1)
	else
		Kunwu_JL_Gather_Info2_Item1:SetCheck(1)
		Kunwu_JL_Gather_Info2_Item2:SetCheck(0)
	end
	
	local qual = 0
	local need_bind = 0
	for i = 1, 5 do
		g_ActionBtn[i]:SetActionItem(-1)		
		if g_Elf_BagIndex[i] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 1)
			local theAction = EnumAction(g_Elf_BagIndex[i], "packageitem")
			g_ActionBtn[i]:SetActionItem(theAction:GetID())
			
			if qual == 0 then
				qual = PlayerPackage:LuaFnGetPetElfItemQual(g_Elf_BagIndex[i])
			end
			
			if GetItemBindStatus(g_Elf_BagIndex[i]) == 1 then
				need_bind = 1
			end
		end
	end

	if qual >= 1 and qual <= 6 then
		if need_bind == 1 then
			local theAction = DataPool:CreateBindActionItemForShow(g_CompoundItem[qual], 1)
			Kunwu_JL_Gather_Button6:SetActionItem(theAction:GetID())
		else
			local theAction = DataPool:CreateActionItemForShow(g_CompoundItem[qual], 1)
			Kunwu_JL_Gather_Button6:SetActionItem(theAction:GetID())
		end
		if g_PayMode == 0 then
			Kunwu_JL_Gather_Money:SetProperty("MoneyNumber", tostring(g_NeedMoney[qual]))
		end
		
		need_token = g_NeedToken[qual]
	end
	
	if iIBPower >= need_token then
		strTemp = ScriptGlobal_Format("#{JLYC_241217_203}", tostring(iIBPower), tostring(need_token))
		Kunwu_JL_Gather_Info2_Item2_Text1:SetText(strTemp)
	else
		strTemp = ScriptGlobal_Format("#{JLYC_241217_227}", tostring(iIBPower), tostring(need_token))
		Kunwu_JL_Gather_Info2_Item2_Text1:SetText(strTemp)
	end

end

function Kunwu_JL_Gather_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Kunwu_JL_Gather_Item_OnItemDragedDropFromBag(idx, iBagIndex)

	if PlayerPackage:LuaFnIsPetElf(iBagIndex) ~= 1 then
		PushDebugMessage("#{JLYC_241217_18}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if PlayerPackage:LuaFnIsPetElfIdentified(iBagIndex) ~= 1 then
	--	PushDebugMessage("#{JLYC_241217_134}")
	--	return
	end
	
	for i = 1, 5 do
		if g_Elf_BagIndex[i] ~= -1 and i ~= idx then
			local elf_qual = PlayerPackage:LuaFnGetPetElfItemQual(g_Elf_BagIndex[i])
			if PlayerPackage:LuaFnGetPetElfItemQual(iBagIndex) ~= elf_qual then
				PushDebugMessage("#{JLYC_241217_135}")
				return
			end
		end	
	end

	if g_Elf_BagIndex[idx] ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[idx], 0)
	end
	g_Elf_BagIndex[idx] = iBagIndex
	Kunwu_JL_Gather_Update()	
end

function Kunwu_JL_Gather_Item_OnBagItemRClicked(iBagIndex)
	local idx = 0
	for i = 1, 5 do
		if g_Elf_BagIndex[i] == -1 then
			idx = i
			break
		end
	end
	
	if idx == 0 then
		PushDebugMessage("#{JLYC_241217_187}")
	else
		Kunwu_JL_Gather_Item_OnItemDragedDropFromBag(idx, iBagIndex)
	end
end

function Kunwu_JL_Gather_Item_OnItemDragedDropAway(idx)
	Kunwu_JL_Gather_Elf_OnRBClicked(idx)
end

function Kunwu_JL_Gather_Elf_OnRBClicked(idx)
	if idx >= 1 and idx <= 5 then
		if g_Elf_BagIndex[idx] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[idx], 0)
			g_Elf_BagIndex[idx] = -1
			Kunwu_JL_Gather_Update()
		end
	end
end

function Kunwu_JL_Gather_CleanUp()
	Kunwu_JL_Gather_Money:SetProperty("MoneyNumber", "0")
	Kunwu_JL_Gather_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Kunwu_JL_Gather_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Kunwu_JL_Gather_Button6:SetActionItem(-1)
	for i = 1, 5 do
		g_ActionBtn[i]:SetActionItem(-1)
		if g_Elf_BagIndex[i] ~= -1 then	
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
			g_Elf_BagIndex[i] = -1
		end
	end
end

function Kunwu_JL_Gather_OnHidden()
	Kunwu_JL_Gather_CleanUp()
	m_ObjServerId = -1
	g_PayMode = 0
end

function Kunwu_JL_Gather_OK_Clicked(flag)

	local my_level = Player:GetData("LEVEL")
	if my_level < 65 then
		PushDebugMessage("#{JLYC_241217_12}")
		return
	end
	
	for i = 1, 5 do
		if g_Elf_BagIndex[i] == -1 then
			PushDebugMessage("#{JLYC_241217_137}")
			return
		end
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888830)
		Set_XSCRIPT_Function_Name("DoCompound")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_Elf_BagIndex[1])
		Set_XSCRIPT_Parameter(2, g_Elf_BagIndex[2])
		Set_XSCRIPT_Parameter(3, g_Elf_BagIndex[3])
		Set_XSCRIPT_Parameter(4, g_Elf_BagIndex[4])
		Set_XSCRIPT_Parameter(5, g_Elf_BagIndex[5])
		Set_XSCRIPT_Parameter(6, g_PayMode)
		Set_XSCRIPT_Parameter(7, 1)
		Set_XSCRIPT_ParamCount(8)
	Send_XSCRIPT()
end

function Kunwu_JL_Gather_HelpClicked()

end
--Care Obj
function Kunwu_JL_Gather_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_JL_Gather_Frame_On_ResetPos()
	if g_Kunwu_JL_Gather_Frame_UnifiedPosition ~= nil then
		Kunwu_JL_Gather_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Gather_Frame_UnifiedPosition)
	end
end

function Kunwu_JL_Gather_SelectPay(flag)
	if flag ~= g_PayMode then
		g_PayMode = flag
		Kunwu_JL_Gather_Update()
	end
end
