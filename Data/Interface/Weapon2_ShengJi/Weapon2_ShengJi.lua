--!!!reloadscript =Weapon2_ShengJi

local g_Weapon2_ShengJi_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ShenBing_BagIndex = -1

local g_LimitLevel = 65
local g_Need_Item = 20101001
local g_Need_Mondy = 10000
local g_Max_ShenBingLevel = 50

local g_ActionButtonDropIndex = 45

function Weapon2_ShengJi_PreLoad()
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

function Weapon2_ShengJi_OnLoad()
	g_Weapon2_ShengJi_Frame_UnifiedPosition = Weapon2_ShengJi_Frame:GetProperty("UnifiedPosition")
end

function Weapon2_ShengJi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881201 then
		if not this:IsVisible() then
			Weapon2_ShengJi_CleanUp()
			this:Show()
			Weapon2_ShengJi_Update()
			Weapon2_ShengJi_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_ShengJi_ItemCheck()	
		Weapon2_ShengJi_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_ShengJi_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Weapon2_ShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Weapon2_ShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex and tonumber(arg1) ~= nil then
			Weapon2_ShengJi_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_ShengJi" and tonumber(arg0) ~= nil then
			Weapon2_ShengJi_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex then
			Weapon2_ShengJi_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Weapon2_ShengJi_ItemCheck()	
	if g_ShenBing_BagIndex ~= -1 then
		local need_remove = 0
		if PlayerPackage:LuaFnIsBagItemShenBing(g_ShenBing_BagIndex) ~= 1 then
			need_remove = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_ShenBing_BagIndex) == 1 then
			need_remove = 1
		end
		
		if need_remove == 0 then
			local sb_level = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "LEVEL")
			if sb_level >= g_Max_ShenBingLevel then
				need_remove = 1
			end
		end
	
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
			g_ShenBing_BagIndex = -1
		end
	end
end

function Weapon2_ShengJi_Update()
	
	local strTemp = ""
	Weapon2_ShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Weapon2_ShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Weapon2_ShengJi_Item:SetActionItem(-1)
	Weapon2_ShengJi_DemandMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_ShengJi_OK:Disable()
	Weapon2_ShengJi_Give:SetText("")
	Weapon2_ShengJi_Now:SetText("")
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 1)
		local theAction = EnumAction(g_ShenBing_BagIndex, "packageitem")
		Weapon2_ShengJi_Item:SetActionItem(theAction:GetID())		

		local sb_level = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "LEVEL")		
		local strLevel = ScriptGlobal_Format("#{SBFW_20230707_245}", tostring(sb_level))
		Weapon2_ShengJi_Now:SetText(strLevel)
		local need_item, need_item_count, need_money = PlayerPackage:LuaFnGetShenBingLevelUpInfo(sb_level)		
		if tonumber(need_item) ~= nil and tonumber(need_item_count) ~= nil and tonumber(need_money) ~= nil then
			if tonumber(need_item) > 0 and tonumber(need_item_count) > 0 and tonumber(need_money) > 0 then
				local item_name = DataPool:LuaFnGetItemNameByTableIndex(need_item)
				local strTemp = ScriptGlobal_Format("#{SBFW_20230707_36}", tostring(need_item_count))
				Weapon2_ShengJi_Give:SetText(strTemp)				
				Weapon2_ShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
				Weapon2_ShengJi_OK:Enable()
			end
		end
	end
end

function Weapon2_ShengJi_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_ShengJi_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsBagItemShenBing(iBagIndex) ~= 1 then
		PushDebugMessage("#{SBFW_20230707_44}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	local sb_level = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "LEVEL")
	if sb_level >= g_Max_ShenBingLevel then
		PushDebugMessage("#{SBFW_20230707_45}")
		return
	end
		
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
	end
	g_ShenBing_BagIndex = iBagIndex
	Weapon2_ShengJi_Update()	
end

function Weapon2_ShengJi_Item_OnBagItemRClicked(iBagIndex)
	Weapon2_ShengJi_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Weapon2_ShengJi_Item_OnItemDragedDropAway()
	Weapon2_ShengJi_ShenBing_OnRBClicked()
end

function Weapon2_ShengJi_ShenBing_OnRBClicked()
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
		Weapon2_ShengJi_Update()
	end
end

function Weapon2_ShengJi_CleanUp()
	Weapon2_ShengJi_DemandMoney:SetProperty("MoneyNumber", "0")
	Weapon2_ShengJi_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Weapon2_ShengJi_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_ShengJi_Item:SetActionItem(-1)
	if g_ShenBing_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
	end
	
	Weapon2_ShengJi_OK:Disable()
	
	Weapon2_ShengJi_Give:SetText("")
	Weapon2_ShengJi_Now:SetText("")
end

function Weapon2_ShengJi_OnHidden()
	Weapon2_ShengJi_CleanUp()
	m_ObjServerId = -1
	LuaFnCloseMessageBox(416)
end

function Weapon2_ShengJi_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LimitLevel then
		PushDebugMessage("#{SBFW_20230707_46}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888812)
		Set_XSCRIPT_Function_Name("ShenBingLevelUp")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_BagIndex)
		Set_XSCRIPT_Parameter(2, 1)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Weapon2_ShengJi_HelpClicked()

end
--Care Obj
function Weapon2_ShengJi_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_ShengJi_Frame_On_ResetPos()
	if g_Weapon2_ShengJi_Frame_UnifiedPosition ~= nil then
		Weapon2_ShengJi_Frame:SetProperty("UnifiedPosition", g_Weapon2_ShengJi_Frame_UnifiedPosition)
	end
end
