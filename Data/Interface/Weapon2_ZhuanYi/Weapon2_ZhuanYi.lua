--!!!reloadscript =Weapon2_ZhuanYi

local g_Weapon2_ZhuanYi_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ShenBing_FromBagIndex = -1
local g_ShenBing_ToBagIndex = -1

local g_ActionButtonDropFromIndex = 49
local g_ActionButtonDropToIndex = 50

local g_LimitLevel = 65
local g_Need_Item = 20101001
local g_Need_Mondy = 100000

function Weapon2_ZhuanYi_PreLoad()
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

function Weapon2_ZhuanYi_OnLoad()
	g_Weapon2_ZhuanYi_Frame_UnifiedPosition = Weapon2_ZhuanYi_Frame:GetProperty("UnifiedPosition")
end

function Weapon2_ZhuanYi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881205 then
		if not this:IsVisible() then
			Weapon2_ZhuanYi_CleanUp()
			this:Show()
			Weapon2_ZhuanYi_Update()
			Weapon2_ZhuanYi_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_ZhuanYi_ItemCheck()
		Weapon2_ZhuanYi_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_ZhuanYi_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Weapon2_ZhuanYi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Weapon2_ZhuanYi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropFromIndex and tonumber(arg1) ~= nil then
			Weapon2_ZhuanYi_OnItemDragedDropFromBag(tonumber(arg1), 0)
		end
		
		if tonumber(arg0) == g_ActionButtonDropToIndex and tonumber(arg1) ~= nil then
			Weapon2_ZhuanYi_OnItemDragedDropFromBag(tonumber(arg1), 1)
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_ZhuanYi" and tonumber(arg0) ~= nil then
			Weapon2_ZhuanYi_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropFromIndex then
			Weapon2_ZhuanYi_OnItemDragedDropAway(0)
		end
		
		if tonumber(arg0) == g_ActionButtonDropToIndex then
			Weapon2_ZhuanYi_OnItemDragedDropAway(1)
		end
		return
	end
end

function Weapon2_ZhuanYi_ItemCheck()

	local need_remove_from = 0
	local need_remove_to = 0
	
	if g_ShenBing_FromBagIndex ~= -1 then
		if PlayerPackage:LuaFnIsBagItemShenBing(g_ShenBing_FromBagIndex) ~= 1 then
			need_remove_from = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_ShenBing_FromBagIndex) == 1 then
			need_remove_from = 1
		end
		
		if need_remove_from == 0 then
			local sb_level = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_FromBagIndex, "LEVEL")
			local have_skill_not_1 = 0
			local common_skill_1, common_skill_2 = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_FromBagIndex, "COMMONSKILL")
			local skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(common_skill_1)
			if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
				have_skill_not_1 = 1
			end

			skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(common_skill_2)
			if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
				have_skill_not_1 = 1
			end
		
			for i = 1, 3 do
				local limit_skill = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_FromBagIndex, "LIMITSKILL", i - 1)
				skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(limit_skill)
				if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
					have_skill_not_1 = 1
				end
			end
		
			if sb_level == 1 and have_skill_not_1 == 0 then
				need_remove_from = 1
				need_remove_to = 1
			end
		end
		
		if need_remove_from == 1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_FromBagIndex, 0)
			g_ShenBing_FromBagIndex = -1
		end
	end
	
	if g_ShenBing_ToBagIndex ~= -1 then
		if PlayerPackage:LuaFnIsBagItemShenBing(g_ShenBing_ToBagIndex) ~= 1 then
			need_remove_to = 1
		end

		--加锁
		if PlayerPackage:IsLock(g_ShenBing_ToBagIndex) == 1 then
			need_remove_to = 1
		end
		
		if need_remove_to == 1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_ToBagIndex, 0)
			g_ShenBing_ToBagIndex = -1
		end
	end
end

function Weapon2_ZhuanYi_Update()
	
	local strTemp = ""
	Weapon2_ZhuanYi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Weapon2_ZhuanYi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Weapon2_ZhuanYi_From:SetActionItem(-1)
	Weapon2_ZhuanYi_To:SetActionItem(-1)
	Weapon2_ZhuanYi_DemandMoney:SetProperty("MoneyNumber", "0")

	Weapon2_ZhuanYi_OK:Disable()
	
	if g_ShenBing_FromBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_FromBagIndex, 1)
		local theAction = EnumAction(g_ShenBing_FromBagIndex, "packageitem")
		Weapon2_ZhuanYi_From:SetActionItem(theAction:GetID())
		Weapon2_ZhuanYi_DemandMoney:SetProperty("MoneyNumber", tostring(g_Need_Mondy))
	end
	
	if g_ShenBing_ToBagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_ToBagIndex, 1)
		local theAction = EnumAction(g_ShenBing_ToBagIndex, "packageitem")
		Weapon2_ZhuanYi_To:SetActionItem(theAction:GetID())
		Weapon2_ZhuanYi_DemandMoney:SetProperty("MoneyNumber", tostring(g_Need_Mondy))
	end
	
	if g_ShenBing_FromBagIndex ~= -1 and g_ShenBing_ToBagIndex ~= -1 then
		Weapon2_ZhuanYi_OK:Enable()
	end
end

function Weapon2_ZhuanYi_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_ZhuanYi_OnItemDragedDropFromBag(iBagIndex, flag)
	
	if PlayerPackage:LuaFnIsBagItemShenBing(iBagIndex) ~= 1 then
		PushDebugMessage("#{SBFW_20230707_138}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if flag == 0 then

		local sb_level = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "LEVEL")
		local have_skill_not_1 = 0
		local common_skill_1, common_skill_2 = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "COMMONSKILL")
		local skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(common_skill_1)
		if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
			have_skill_not_1 = 1
		end

		skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(common_skill_2)
		if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
			have_skill_not_1 = 1
		end
		
		for i = 1, 3 do
			local limit_skill = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "LIMITSKILL", i - 1)
			skill_level, _, _, _, _ = PlayerPackage:LuaFnGetShenBingSkillUpInfo(limit_skill)
			if tonumber(skill_level) ~= nil and tonumber(skill_level) > 1 then
				have_skill_not_1 = 1
			end
		end
		
		if sb_level == 1 and have_skill_not_1 == 0 then
			PushDebugMessage("#{SBFW_20230707_139}")
			return
		end
		
		if g_ShenBing_FromBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_FromBagIndex, 0)
		end
		g_ShenBing_FromBagIndex = iBagIndex
	else
		if g_ShenBing_ToBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_ToBagIndex, 0)
		end
		g_ShenBing_ToBagIndex = iBagIndex
	end
	Weapon2_ZhuanYi_Update()
end

function Weapon2_ZhuanYi_OnBagItemRClicked(iBagIndex)
	if g_ShenBing_FromBagIndex == -1 then
		Weapon2_ZhuanYi_OnItemDragedDropFromBag(iBagIndex, 0)
	else
		Weapon2_ZhuanYi_OnItemDragedDropFromBag(iBagIndex, 1)
	end
end

function Weapon2_ZhuanYi_OnItemDragedDropAway(flag)
	Weapon2_ZhuanYi_ShenBing_OnRBClicked(flag)
end

function Weapon2_ZhuanYi_ShenBing_OnRBClicked(flag)
	if flag == 0 then
		if g_ShenBing_FromBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_FromBagIndex, 0)
			g_ShenBing_FromBagIndex = -1
			Weapon2_ZhuanYi_Update()
		end
	else
		if g_ShenBing_ToBagIndex ~= -1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_ToBagIndex, 0)
			g_ShenBing_ToBagIndex = -1
			Weapon2_ZhuanYi_Update()
		end
	end
end

function Weapon2_ZhuanYi_CleanUp()
	Weapon2_ZhuanYi_DemandMoney:SetProperty("MoneyNumber", "0")
	Weapon2_ZhuanYi_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Weapon2_ZhuanYi_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_ZhuanYi_From:SetActionItem(-1)
	Weapon2_ZhuanYi_To:SetActionItem(-1)
	if g_ShenBing_FromBagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_FromBagIndex, 0)
		g_ShenBing_FromBagIndex = -1
	end
	
	if g_ShenBing_ToBagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_ToBagIndex, 0)
		g_ShenBing_ToBagIndex = -1
	end
	
	Weapon2_ZhuanYi_OK:Disable()
end

function Weapon2_ZhuanYi_OnHidden()
	Weapon2_ZhuanYi_CleanUp()
	m_ObjServerId = -1
	LuaFnCloseMessageBox(415)
	LuaFnCloseMessageBox(417)
end

function Weapon2_ZhuanYi_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LimitLevel then
		PushDebugMessage("#{SBFW_20230707_140}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888812)
		Set_XSCRIPT_Function_Name("ShenBingTransition")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_FromBagIndex)
		Set_XSCRIPT_Parameter(2, g_ShenBing_ToBagIndex)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_Parameter(4, 1)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
end

function Weapon2_ZhuanYi_HelpClicked()

end

--Care Obj
function Weapon2_ZhuanYi_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_ZhuanYi_Frame_On_ResetPos()
	if g_Weapon2_ZhuanYi_Frame_UnifiedPosition ~= nil then
		Weapon2_ZhuanYi_Frame:SetProperty("UnifiedPosition", g_Weapon2_ZhuanYi_Frame_UnifiedPosition)
	end
end
