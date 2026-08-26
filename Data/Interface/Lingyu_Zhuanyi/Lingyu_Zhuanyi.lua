--!!!reloadscript =Lingyu_Zhuanyi

local g_Lingyu_Zhuanyi_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_LingYu_FromBagIndex = -1
local g_LingYu_ToBagIndex = -1

function Lingyu_Zhuanyi_PreLoad()
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

function Lingyu_Zhuanyi_OnLoad()
	g_Lingyu_Zhuanyi_Frame_UnifiedPosition = Lingyu_Zhuanyi_Frame:GetProperty("UnifiedPosition")
end

function Lingyu_Zhuanyi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880805 then
		if not this:IsVisible() then
			Lingyu_Zhuanyi_CleanUp()
			this:Show()
			Lingyu_Zhuanyi_Update()
			Lingyu_Zhuanyi_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Lingyu_Zhuanyi_ItemCheck()	
		Lingyu_Zhuanyi_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Lingyu_Zhuanyi_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Lingyu_Zhuanyi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Lingyu_Zhuanyi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 39 and tonumber(arg1) ~= nil then
			Lingyu_Zhuanyi_OnItemDragedDropFromBag(tonumber(arg1), 0)
		end
		
		if tonumber(arg0) == 40 and tonumber(arg1) ~= nil then
			Lingyu_Zhuanyi_OnItemDragedDropFromBag(tonumber(arg1), 1)
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Lingyu_Zhuanyi" and tonumber(arg0) ~= nil then
			Lingyu_Zhuanyi_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 39 then
			Lingyu_Zhuanyi_OnItemDragedDropAway(0)
		end
		
		if tonumber(arg0) == 40 then
			Lingyu_Zhuanyi_OnItemDragedDropAway(1)
		end
		return
	end
end

function Lingyu_Zhuanyi_ItemCheck()	
	if g_LingYu_FromBagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemLingYu(g_LingYu_FromBagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_LingYu_FromBagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_FromBagIndex, 0)
			g_LingYu_FromBagIndex = -1
		end
	end
	
	if g_LingYu_ToBagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemLingYu(g_LingYu_ToBagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_LingYu_ToBagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_ToBagIndex, 0)
			g_LingYu_ToBagIndex = -1
		end
	end
end

function Lingyu_Zhuanyi_Update()
	
	local strTemp = ""
	Lingyu_Zhuanyi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Lingyu_Zhuanyi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Lingyu_Zhuanyi_From:SetActionItem(-1)
	Lingyu_Zhuanyi_To:SetActionItem(-1)
	Lingyu_Zhuanyi_DemandMoney:SetProperty("MoneyNumber", "0")

	if g_LingYu_FromBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_FromBagIndex, 1)
		local theAction = EnumAction(g_LingYu_FromBagIndex, "packageitem")
		Lingyu_Zhuanyi_From:SetActionItem(theAction:GetID())
		Lingyu_Zhuanyi_DemandMoney:SetProperty("MoneyNumber", "100000")
	end
	
	if g_LingYu_ToBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_ToBagIndex, 1)
		local theAction = EnumAction(g_LingYu_ToBagIndex, "packageitem")
		Lingyu_Zhuanyi_To:SetActionItem(theAction:GetID())
		Lingyu_Zhuanyi_DemandMoney:SetProperty("MoneyNumber", "100000")
	end
end

function Lingyu_Zhuanyi_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Lingyu_Zhuanyi_OnItemDragedDropFromBag(iBagIndex, flag)
	
	if PlayerPackage:LuaFnIsBagItemLingYu(iBagIndex) ~= 1 then
		PushDebugMessage("#{SZXT_221216_154}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if flag == 0 then		
		if g_LingYu_FromBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_FromBagIndex, 0)
		end
		g_LingYu_FromBagIndex = iBagIndex
	else
		if g_LingYu_ToBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_ToBagIndex, 0)
		end
		g_LingYu_ToBagIndex = iBagIndex
	end
	Lingyu_Zhuanyi_Update()
end

function Lingyu_Zhuanyi_OnBagItemRClicked(iBagIndex)
	if g_LingYu_FromBagIndex == -1 then
		Lingyu_Zhuanyi_OnItemDragedDropFromBag(iBagIndex, 0)
	else
		Lingyu_Zhuanyi_OnItemDragedDropFromBag(iBagIndex, 1)
	end
end

function Lingyu_Zhuanyi_OnItemDragedDropAway(flag)
	Lingyu_Zhuanyi_LingYu_OnRBClicked(flag)
end

function Lingyu_Zhuanyi_LingYu_OnRBClicked(flag)
	if flag == 0 then
		if g_LingYu_FromBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_FromBagIndex, 0)
			g_LingYu_FromBagIndex = -1
			Lingyu_Zhuanyi_Update()
		end
	else
		if g_LingYu_ToBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_LingYu_ToBagIndex, 0)
			g_LingYu_ToBagIndex = -1
			Lingyu_Zhuanyi_Update()
		end
	end
end

function Lingyu_Zhuanyi_CleanUp()
	Lingyu_Zhuanyi_DemandMoney:SetProperty("MoneyNumber", "0")
	Lingyu_Zhuanyi_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Lingyu_Zhuanyi_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_Zhuanyi_From:SetActionItem(-1)
	Lingyu_Zhuanyi_To:SetActionItem(-1)
	if g_LingYu_FromBagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_LingYu_FromBagIndex, 0)
		g_LingYu_FromBagIndex = -1
	end
	
	if g_LingYu_ToBagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_LingYu_ToBagIndex, 0)
		g_LingYu_ToBagIndex = -1
	end
end

function Lingyu_Zhuanyi_OnHidden()
	Lingyu_Zhuanyi_CleanUp()
	m_ObjServerId = -1
end

function Lingyu_Zhuanyi_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_221216_155}")
		return
	end
	
	if DataPool:Lua_IsMissionComplete(2169) ~= 1 then
	--	PushDebugMessage("#{SZXT_221216_111}")
	--	return
	end	

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYuTransition")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_LingYu_FromBagIndex)
		Set_XSCRIPT_Parameter(2, g_LingYu_ToBagIndex)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Lingyu_Zhuanyi_HelpClicked()

end

--Care Obj
function Lingyu_Zhuanyi_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Lingyu_Zhuanyi_Frame_On_ResetPos()
	if g_Lingyu_Zhuanyi_Frame_UnifiedPosition ~= nil then
		Lingyu_Zhuanyi_Frame:SetProperty("UnifiedPosition", g_Lingyu_Zhuanyi_Frame_UnifiedPosition)
	end
end
