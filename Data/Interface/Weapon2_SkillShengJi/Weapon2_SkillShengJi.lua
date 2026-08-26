--!!!reloadscript =Weapon2_SkillShengJi

local g_Weapon2_SkillShengJi_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ShenBing_BagIndex = -1

local g_LimitLevel = 65

local g_ActionButtonDropIndex = 53

local g_CurSel = 0
local g_SkillAction = {}
local g_SkillActionLock = {}
local g_ActionAnimate = {}

function Weapon2_SkillShengJi_PreLoad()
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

function Weapon2_SkillShengJi_OnLoad()
	g_Weapon2_SkillShengJi_Frame_UnifiedPosition = Weapon2_SkillShengJi_Frame:GetProperty("UnifiedPosition")
	
	g_SkillAction[1] = Weapon2_SkillShengJi_Skill1
	g_SkillAction[2] = Weapon2_SkillShengJi_Skill2
	g_SkillAction[3] = Weapon2_SkillShengJi_Skill3
	g_SkillAction[4] = Weapon2_SkillShengJi_Skill4
	g_SkillAction[5] = Weapon2_SkillShengJi_Skill5
	
	g_SkillActionLock[1] = Weapon2_SkillShengJi_Skill1Lock
	g_SkillActionLock[2] = Weapon2_SkillShengJi_Skill2Lock
	g_SkillActionLock[3] = Weapon2_SkillShengJi_Skill3Lock
	g_SkillActionLock[4] = Weapon2_SkillShengJi_Skill4Lock
	g_SkillActionLock[5] = Weapon2_SkillShengJi_Skill5Lock
	
end

function Weapon2_SkillShengJi_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881503 then
		if not this:IsVisible() then
			Weapon2_SkillShengJi_CleanUp()
			this:Show()
			Weapon2_SkillShengJi_Update()
			Weapon2_SkillShengJi_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_SkillShengJi_ItemCheck()	
		Weapon2_SkillShengJi_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_SkillShengJi_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Weapon2_SkillShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Weapon2_SkillShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex and tonumber(arg1) ~= nil then
			Weapon2_SkillShengJi_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_SkillShengJi" and tonumber(arg0) ~= nil then
			Weapon2_SkillShengJi_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex then
			Weapon2_SkillShengJi_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Weapon2_SkillShengJi_ItemCheck()	
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

function Weapon2_SkillShengJi_Update()
	
	local strTemp = ""
	Weapon2_SkillShengJi_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Weapon2_SkillShengJi_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Weapon2_SkillShengJi_Item:SetActionItem(-1)
	Weapon2_SkillShengJi_DemandMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_SkillShengJi_OK:Disable()

	for i = 1, 5 do
		g_SkillAction[i]:SetActionItem(-1)
		g_SkillActionLock[i]:Hide()
	end
	
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 1)
		local theAction = EnumAction(g_ShenBing_BagIndex, "packageitem")
		Weapon2_SkillShengJi_Item:SetActionItem(theAction:GetID())

		for i = 1, 5 do
			local skill_action = DataPool:LuaFnEnumBagShenBingSkillAction(g_ShenBing_BagIndex, i - 1 + 2)
			g_SkillAction[i]:SetActionItem(skill_action:GetID())
			
			if i >= 3 and i <= 5 then
				local skill_active = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "SKILL_LOCK", i - 3)
				if skill_active ~= 1 then
					g_SkillActionLock[i]:Show()
				end
			end
			
			if g_CurSel == i then
				g_SkillAction[i]:SetPushed(1)
			end
		end
		
		local skill_id = -1	
		if g_CurSel == 1 then
			local sb_skill, _ = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "COMMONSKILL")
			skill_id = sb_skill
		elseif g_CurSel == 2 then
			local _, sb_skill = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "COMMONSKILL")
			skill_id = sb_skill
		elseif g_CurSel >= 3 and g_CurSel <= 5 then
			skill_id = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "LIMITSKILL", g_CurSel - 3)
		end
		
		if skill_id ~= -1 then
			local _, _, _, _, need_money = PlayerPackage:LuaFnGetShenBingSkillUpInfo(skill_id)
			if tonumber(need_money) ~= nil and tonumber(need_money) > 0 then
				Weapon2_SkillShengJi_DemandMoney:SetProperty("MoneyNumber", tostring(need_money))
			end
			Weapon2_SkillShengJi_OK:Enable()
		end
	end
	
	Weapon2_SkillShengJi_UpdateSkillDesc()
end

function Weapon2_SkillShengJi_UpdateSkillDesc()
	
	local strTemp = ""
	Weapon2_SkillShengJi_BeforeSkillText:SetText("")
	Weapon2_SkillShengJi_AfterSkillText:SetText("")
	
	Weapon2_SkillShengJi_Now:SetText("")
	Weapon2_SkillShengJi_Give:SetText("")
	
	if g_ShenBing_BagIndex ~= -1 then	
		if g_CurSel >= 1 and g_CurSel <= 5 then
			local skill_id = -1	
			if g_CurSel == 1 then
				local sb_skill, _ = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "COMMONSKILL")
				skill_id = sb_skill
			elseif g_CurSel == 2 then
				local _, sb_skill = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "COMMONSKILL")
				skill_id = sb_skill
			elseif g_CurSel >= 3 and g_CurSel <= 5 then
				skill_id = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "LIMITSKILL", g_CurSel - 3)
			end
			
			local sb_skill_level, new_id, need_item, need_item_count, _ =PlayerPackage:LuaFnGetShenBingSkillUpInfo(skill_id)
			strTemp = ScriptGlobal_Format("#{SBFW_20230707_251}", tostring(sb_skill_level))
			Weapon2_SkillShengJi_Now:SetText(strTemp)
			
			local strSkillDesc = DataPool:LuaFnGetShenBingSkillDesc(skill_id)
			Weapon2_SkillShengJi_BeforeSkillText:SetText(tostring(strSkillDesc))
			if sb_skill_level == 10 then
				Weapon2_SkillShengJi_AfterSkillText:SetText("#{SBFW_20230707_168}")
				Weapon2_SkillShengJi_Give:SetText("#{SBFW_20230707_254}")
			else
				strSkillDesc = DataPool:LuaFnGetShenBingSkillDesc(new_id)
				Weapon2_SkillShengJi_AfterSkillText:SetText(tostring(strSkillDesc))
				
				local need_item_name = DataPool:LuaFnGetItemNameByTableIndex(need_item)
				strTemp = ScriptGlobal_Format("#{SBFW_20230707_253}", tostring(need_item_count), tostring(need_item_name))
				Weapon2_SkillShengJi_Give:SetText(strTemp)
			end
		end
	end
end

function Weapon2_SkillShengJi_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_SkillShengJi_Item_OnItemDragedDropFromBag(iBagIndex)
	
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
	g_CurSel = 0

	Weapon2_SkillShengJi_Update()	
end

function Weapon2_SkillShengJi_Item_OnBagItemRClicked(iBagIndex)
	Weapon2_SkillShengJi_Item_OnItemDragedDropFromBag(iBagIndex)
end

function Weapon2_SkillShengJi_Item_OnItemDragedDropAway()
	Weapon2_SkillShengJi_ShenBing_OnRBClicked()
end

function Weapon2_SkillShengJi_ShenBing_OnRBClicked()
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
		Weapon2_SkillShengJi_Update()
	end
end

function Weapon2_SkillShengJi_CleanUp()
	Weapon2_SkillShengJi_DemandMoney:SetProperty("MoneyNumber", "0")
	Weapon2_SkillShengJi_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Weapon2_SkillShengJi_SelfMoney:SetProperty("MoneyNumber", "0")
	
	Weapon2_SkillShengJi_Item:SetActionItem(-1)
	if g_ShenBing_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
	end
	
	Weapon2_SkillShengJi_OK:Disable()
end

function Weapon2_SkillShengJi_OnHidden()
	Weapon2_SkillShengJi_CleanUp()
	m_ObjServerId = -1
	g_CurSel = 0
	LuaFnCloseMessageBox(419)
end

function Weapon2_SkillShengJi_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LimitLevel then
		PushDebugMessage("#{SBFW_20230707_173}")
		return
	end
	
	if g_ShenBing_BagIndex == -1 then
		PushDebugMessage("#{SBFW_20230707_151}")
		return
	end
	
	if g_CurSel == 0 then
		PushDebugMessage("#{SBFW_20230707_169}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888815)
		Set_XSCRIPT_Function_Name("ShenBingSkillUp")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_BagIndex)
		Set_XSCRIPT_Parameter(2, g_CurSel)
		Set_XSCRIPT_Parameter(3, 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Weapon2_SkillShengJi_HelpClicked()

end

function Weapon2_SkillShengJi_SelectSkill(idx)
	if g_CurSel ~= idx then
		g_CurSel = idx
		Weapon2_SkillShengJi_Update()
	end
end

--Care Obj
function Weapon2_SkillShengJi_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_SkillShengJi_Frame_On_ResetPos()
	if g_Weapon2_SkillShengJi_Frame_UnifiedPosition ~= nil then
		Weapon2_SkillShengJi_Frame:SetProperty("UnifiedPosition", g_Weapon2_SkillShengJi_Frame_UnifiedPosition)
	end
end
