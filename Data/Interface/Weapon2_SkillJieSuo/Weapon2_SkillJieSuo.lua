--!!!reloadscript =Weapon2_SkillJieSuo

local g_Weapon2_SkillJieSuo_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ShenBing_BagIndex = -1

local g_LimitLevel = 65
local g_Need_Mondy = 200000

local g_ActionButtonDropIndex = 52

local g_CurSel = 0
local g_SkillAction = {}
local g_SkillActionLock = {}
local g_ActionAnimate = {}

function Weapon2_SkillJieSuo_PreLoad()
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

function Weapon2_SkillJieSuo_OnLoad()
	g_Weapon2_SkillJieSuo_Frame_UnifiedPosition = Weapon2_SkillJieSuo_Frame:GetProperty("UnifiedPosition")
	
	g_SkillAction[1] = Weapon2_SkillJieSuo_Skill1
	g_SkillAction[2] = Weapon2_SkillJieSuo_Skill2
	g_SkillAction[3] = Weapon2_SkillJieSuo_Skill3
	
	g_SkillActionLock[1] = Weapon2_SkillJieSuo_Skill1Lock
	g_SkillActionLock[2] = Weapon2_SkillJieSuo_Skill2Lock
	g_SkillActionLock[3] = Weapon2_SkillJieSuo_Skill3Lock
	
	g_ActionAnimate[1] = Weapon2_SkillJieSuoCheck1
	g_ActionAnimate[2] = Weapon2_SkillJieSuoCheck2
	g_ActionAnimate[3] = Weapon2_SkillJieSuoCheck3
end

function Weapon2_SkillJieSuo_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881502 then
		if not this:IsVisible() then
			Weapon2_SkillJieSuo_CleanUp()
			this:Show()
			Weapon2_SkillJieSuo_Update()
			Weapon2_SkillJieSuo_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_SkillJieSuo_ItemCheck()	
		Weapon2_SkillJieSuo_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_SkillJieSuo_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Weapon2_SkillJieSuo_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Weapon2_SkillJieSuo_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex and tonumber(arg1) ~= nil then
			Weapon2_SkillJieSuo_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_SkillJieSuo" and tonumber(arg0) ~= nil then
			Weapon2_SkillJieSuo_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex then
			Weapon2_SkillJieSuo_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Weapon2_SkillJieSuo_ItemCheck()	
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
			local skill_active_1 = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", 0)
			local skill_active_2 = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", 1)
			local skill_active_3 = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", 2)
			
			if skill_active_1 == 1 and skill_active_2 == 1 and skill_active_3 == 1 then
				need_remove = 1
			end
		end
	
		if need_remove == 1 then
			LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
			g_ShenBing_BagIndex = -1
		end
	end
end

function Weapon2_SkillJieSuo_Update()
	
	local strTemp = ""
	Weapon2_SkillJieSuo_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Weapon2_SkillJieSuo_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Weapon2_SkillJieSuo_Item:SetActionItem(-1)
	Weapon2_SkillJieSuo_DemandMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_SkillJieSuo_Give:SetText("")
	Weapon2_SkillJieSuo_OK:Disable()
	
	for i = 1, 3 do
		g_SkillAction[i]:SetActionItem(-1)
		g_ActionAnimate[i]:Hide()
		g_SkillActionLock[i]:Hide()
	end
	
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 1)
		local theAction = EnumAction(g_ShenBing_BagIndex, "packageitem")
		Weapon2_SkillJieSuo_Item:SetActionItem(theAction:GetID())
		
		for i = 1, 3 do
			local skill_action = DataPool:LuaFnEnumBagShenBingSkillAction(g_ShenBing_BagIndex, i -1 + 4)
			g_SkillAction[i]:SetActionItem(skill_action:GetID())
			local skill_active = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", i - 1)
			if skill_active ~= 1 then
				g_SkillActionLock[i]:Show()
			end
		end
		
		local need_money = g_Need_Mondy
		Weapon2_SkillJieSuo_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))

		Weapon2_SkillJieSuo_OK:Enable()
		
		if g_CurSel >= 1 and g_CurSel <= 3 then
			g_ActionAnimate[g_CurSel]:Show()
			local skill_active = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", g_CurSel - 1)
			if skill_active == 1 then
				Weapon2_SkillJieSuo_Give:SetText("#{SBFW_20230707_298}")
			else
				local need_item = PlayerPackage:LuaFnGetShenBingLimitSkillActiveNeed(g_ShenBing_BagIndex, g_CurSel - 1)
				local item_name = DataPool:LuaFnGetItemNameByTableIndex(need_item)
				strTemp = ScriptGlobal_Format("#{SBFW_20230707_253}", "1", item_name)
				Weapon2_SkillJieSuo_Give:SetText(strTemp)
			end
		end
	end
end

function Weapon2_SkillJieSuo_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_SkillJieSuo_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsBagItemShenBing(iBagIndex) ~= 1 then
		PushDebugMessage("#{SBFW_20230707_138}")
		return
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	local skill_active_1 = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "SKILL_LOCK", 0)
	local skill_active_2 = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "SKILL_LOCK", 1)
	local skill_active_3 = PlayerPackage:LuaFnGetBagShenBingData(iBagIndex, "SKILL_LOCK", 2)
	
	if skill_active_1 == 1 and skill_active_2 == 1 and skill_active_3 == 1 then
		PushDebugMessage("#{SBFW_20230707_156}")
		return
	end
		
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
	end
	g_ShenBing_BagIndex = iBagIndex
	g_CurSel = 0
	Weapon2_SkillJieSuo_Update()	
end

function Weapon2_SkillJieSuo_Item_OnBagItemRClicked(iBagIndex)
	Weapon2_SkillJieSuo_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Weapon2_SkillJieSuo_Item_OnItemDragedDropAway()
	Weapon2_SkillJieSuo_ShenBing_OnRBClicked()
end

function Weapon2_SkillJieSuo_ShenBing_OnRBClicked()
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
		Weapon2_SkillJieSuo_Update()
	end
end

function Weapon2_SkillJieSuo_CleanUp()
	Weapon2_SkillJieSuo_DemandMoney:SetProperty("MoneyNumber", "0")
	Weapon2_SkillJieSuo_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Weapon2_SkillJieSuo_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_SkillJieSuo_Item:SetActionItem(-1)
	if g_ShenBing_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
	end
	Weapon2_SkillJieSuo_Give:SetText("")
	Weapon2_SkillJieSuo_OK:Disable()
end

function Weapon2_SkillJieSuo_OnHidden()
	Weapon2_SkillJieSuo_CleanUp()
	m_ObjServerId = -1
	g_CurSel = 0
	LuaFnCloseMessageBox(418)
end

function Weapon2_SkillJieSuo_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LimitLevel then
		PushDebugMessage("#{SBFW_20230707_157}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888815)
		Set_XSCRIPT_Function_Name("ShenBingUnlockSkill")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_BagIndex)
		Set_XSCRIPT_Parameter(2, g_CurSel - 1)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Weapon2_SkillJieSuo_HelpClicked()

end

function Weapon2_SkillJieSuo_SelectSkill(idx)
	if g_CurSel ~= idx then
		g_CurSel = idx
		Weapon2_SkillJieSuo_Update()
	end
end

--Care Obj
function Weapon2_SkillJieSuo_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_SkillJieSuo_Frame_On_ResetPos()
	if g_Weapon2_SkillJieSuo_Frame_UnifiedPosition ~= nil then
		Weapon2_SkillJieSuo_Frame:SetProperty("UnifiedPosition", g_Weapon2_SkillJieSuo_Frame_UnifiedPosition)
	end
end
