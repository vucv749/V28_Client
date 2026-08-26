--!!!reloadscript =Lingyu_HuiShou

local g_Lingyu_HuiShou_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_LingYu_BagIndex = -1

local g_Return_Item = {20600005, 20600006, 20600045, 20600046}
local g_Need_Mondy = {20000, 40000, 60000, 100000}

function Lingyu_HuiShou_PreLoad()
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

function Lingyu_HuiShou_OnLoad()
	g_Lingyu_HuiShou_Frame_UnifiedPosition = Lingyu_HuiShou_Frame:GetProperty("UnifiedPosition")
end

function Lingyu_HuiShou_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88880804 then
		if not this:IsVisible() then
			Lingyu_HuiShou_CleanUp()
			this:Show()
			Lingyu_HuiShou_Update()
			Lingyu_HuiShou_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Lingyu_HuiShou_ItemCheck()	
		Lingyu_HuiShou_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Lingyu_HuiShou_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Lingyu_HuiShou_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Lingyu_HuiShou_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == 38 and tonumber(arg1) ~= nil then
			Lingyu_HuiShou_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Lingyu_HuiShou" and tonumber(arg0) ~= nil then
			Lingyu_HuiShou_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == 38 then
			Lingyu_HuiShou_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Lingyu_HuiShou_ItemCheck()	
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
end

function Lingyu_HuiShou_Update()
	
	local strTemp = ""
	Lingyu_HuiShou_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Lingyu_HuiShou_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Lingyu_HuiShou_Item:SetActionItem(-1)
	Lingyu_HuiShou_YuPei:SetActionItem(-1)
	Lingyu_HuiShou_DemandMoney:SetProperty("MoneyNumber", "0")

	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 1)
		local theAction = EnumAction(g_LingYu_BagIndex, "packageitem")
		Lingyu_HuiShou_Item:SetActionItem(theAction:GetID())

		local lyQual = PlayerPackage:LuaFnGetBagLingYuData(g_LingYu_BagIndex, "QUAL")
		local give_item = g_Return_Item[1]
		if g_Return_Item[lyQual + 1] ~= nil then
			give_item = g_Return_Item[lyQual + 1]
		end
		
		local need_money = g_Need_Mondy[1]
		if g_Need_Mondy[lyQual + 1] ~= nil then
			need_money = g_Need_Mondy[lyQual + 1]
		end
		Lingyu_HuiShou_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
		
		local lyBindStatus = GetItemBindStatus(g_LingYu_BagIndex)
		if lyBindStatus == 1 then
			local ypAction = DataPool:CreateBindActionItemForShow(give_item, 1)
			Lingyu_HuiShou_YuPei:SetActionItem(ypAction:GetID())
		else
			local ypAction = DataPool:CreateActionItemForShow(give_item, 1)
			Lingyu_HuiShou_YuPei:SetActionItem(ypAction:GetID())
		end
	end
end

function Lingyu_HuiShou_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Lingyu_HuiShou_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsBagItemLingYu(iBagIndex) ~= 1 then
		PushDebugMessage("#{SZXT_221216_154}")
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
	Lingyu_HuiShou_Update()	
end

function Lingyu_HuiShou_Item_OnBagItemRClicked(iBagIndex)
	Lingyu_HuiShou_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Lingyu_HuiShou_Item_OnItemDragedDropAway()
	Lingyu_HuiShou_LingYu_OnRBClicked()
end

function Lingyu_HuiShou_LingYu_OnRBClicked()
	if g_LingYu_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
		Lingyu_HuiShou_Update()
	end
end

function Lingyu_HuiShou_CleanUp()
	Lingyu_HuiShou_DemandMoney:SetProperty("MoneyNumber", "0")
	Lingyu_HuiShou_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Lingyu_HuiShou_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Lingyu_HuiShou_YuPei:SetActionItem(-1)
	Lingyu_HuiShou_Item:SetActionItem(-1)
	if g_LingYu_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_LingYu_BagIndex, 0)
		g_LingYu_BagIndex = -1
	end
end

function Lingyu_HuiShou_OnHidden()
	Lingyu_HuiShou_CleanUp()
	m_ObjServerId = -1
end

function Lingyu_HuiShou_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < 85 then
		PushDebugMessage("#{SZXT_221216_175}")
		return
	end
	
	if DataPool:Lua_IsMissionComplete(2169) ~= 1 then
	--	PushDebugMessage("#{SZXT_221216_113}")
	--	return
	end	

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888808)
		Set_XSCRIPT_Function_Name("LingYuRecycle")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_LingYu_BagIndex)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Lingyu_HuiShou_HelpClicked()

end
--Care Obj
function Lingyu_HuiShou_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Lingyu_HuiShou_Frame_On_ResetPos()
	if g_Lingyu_HuiShou_Frame_UnifiedPosition ~= nil then
		Lingyu_HuiShou_Frame:SetProperty("UnifiedPosition", g_Lingyu_HuiShou_Frame_UnifiedPosition)
	end
end
