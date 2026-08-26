--!!!reloadscript =Weapon2_FenJie

local g_Weapon2_FenJie_Frame_UnifiedPosition = ""
local g_ObjServerId = -1

local g_ShenBing_BagIndex = -1

local g_LimitLevel = 65
local g_Need_Item = 20101001
local g_Need_Mondy = 50000
local g_Max_ShenBingLevel = 50

local g_ActionButtonDropIndex = 46

local g_MeltToItem = {	
	[4] = {id = 38002944, count = 2},
	[5] = {id = 38002945, count = 2},
	[6] = {id = 38002945, count = 5},
}


function Weapon2_FenJie_PreLoad()
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

function Weapon2_FenJie_OnLoad()
	g_Weapon2_FenJie_Frame_UnifiedPosition = Weapon2_FenJie_Frame:GetProperty("UnifiedPosition")
end

function Weapon2_FenJie_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881202 then
		if not this:IsVisible() then
			g_ObjServerId = Get_XParam_INT(0)
			this:Show()
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_FenJie_ItemCheck()	
		Weapon2_FenJie_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_FenJie_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Weapon2_FenJie_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Weapon2_FenJie_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex and tonumber(arg1) ~= nil then
			Weapon2_FenJie_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_FenJie" and tonumber(arg0) ~= nil then
			Weapon2_FenJie_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex then
			Weapon2_FenJie_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Weapon2_FenJie_OnShown()
	Weapon2_FenJie_CleanUp()
	Weapon2_FenJie_Update()
	Weapon2_FenJie_BeginCareObj(g_ObjServerId)
end

function Weapon2_FenJie_ItemCheck()	
	if g_ShenBing_BagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemShenBing(g_ShenBing_BagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_ShenBing_BagIndex) == 1 then
			need_remove = 1
		end
	
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
			g_ShenBing_BagIndex = -1
		end
	end
end

function Weapon2_FenJie_Update()
	
	local strTemp = ""
	Weapon2_FenJie_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Weapon2_FenJie_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Weapon2_FenJie_Item:SetActionItem(-1)
	Weapon2_FenJie_DemandMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_FenJie_OK:Disable()
	Weapon2_FenJie_Give:SetText("")

	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 1)
		local theAction = EnumAction(g_ShenBing_BagIndex, "packageitem")
		Weapon2_FenJie_Item:SetActionItem(theAction:GetID())		

		local sb_level = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "LEVEL")		
		local sb_star = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "STAR")
		
		if sb_star == 4 or sb_star == 5 or sb_star == 6 then
			local item_name = DataPool:LuaFnGetItemNameByTableIndex(g_MeltToItem[sb_star].id)
			local strTemp = ScriptGlobal_Format("#{SBFW_20230707_275}", tostring(g_MeltToItem[sb_star].count), tostring(item_name))
			Weapon2_FenJie_Give:SetText(strTemp)
			Weapon2_FenJie_DemandMoney:SetProperty("MoneyNumber", tostring(g_Need_Mondy))
			Weapon2_FenJie_OK:Enable()
		end
	end
end

function Weapon2_FenJie_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_FenJie_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsBagItemShenBing(iBagIndex) ~= 1 then
		PushDebugMessage("#{SBFW_20230707_138}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
	end
	g_ShenBing_BagIndex = iBagIndex
	Weapon2_FenJie_Update()	
end

function Weapon2_FenJie_Item_OnBagItemRClicked(iBagIndex)
	Weapon2_FenJie_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Weapon2_FenJie_Item_OnItemDragedDropAway()
	Weapon2_FenJie_ShenBing_OnRBClicked()
end

function Weapon2_FenJie_ShenBing_OnRBClicked()
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
		Weapon2_FenJie_Update()
	end
end

function Weapon2_FenJie_CleanUp()
	Weapon2_FenJie_DemandMoney:SetProperty("MoneyNumber", "0")
	Weapon2_FenJie_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Weapon2_FenJie_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_FenJie_Item:SetActionItem(-1)
	if g_ShenBing_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
	end
	
	Weapon2_FenJie_OK:Disable()
	
	Weapon2_FenJie_Give:SetText("")
end

function Weapon2_FenJie_OnHidden()
	Weapon2_FenJie_CleanUp()
	g_ObjServerId = -1
end

function Weapon2_FenJie_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888812)
		Set_XSCRIPT_Function_Name("ShenBingMelt")
		Set_XSCRIPT_Parameter(0, g_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_BagIndex)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Weapon2_FenJie_HelpClicked()

end
--Care Obj
function Weapon2_FenJie_BeginCareObj(obj_id)
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_FenJie_Frame_On_ResetPos()
	if g_Weapon2_FenJie_Frame_UnifiedPosition ~= nil then
		Weapon2_FenJie_Frame:SetProperty("UnifiedPosition", g_Weapon2_FenJie_Frame_UnifiedPosition)
	end
end
