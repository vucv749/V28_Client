--!!!reloadscript =Weapon2_SkillXuanZe

local g_Weapon2_SkillXuanZe_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ShenBing_BagIndex = -1

local g_LimitLevel = 65
local g_Need_Item = 20101001
local g_Need_Mondy = 10000

local g_ActionButtonDropIndex = 51

local g_Sel_Skill_Index_1 = 0
local g_Sel_Skill_Index_2 = 0

local g_SkillPoolAction_1 = {}
local g_SkillPoolAction_2 = {}

function Weapon2_SkillXuanZe_PreLoad()
	this:RegisterEvent("UI_COMMAND")	
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("BAG_ITEM_DRAGDROP_TO_UI")
	this:RegisterEvent("BAG_ITEM_RBCLICK_TO_UI")
	this:RegisterEvent("BAG_ITEM_DRAGAWAY_FROM_UI")	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Weapon2_SkillXuanZe_OnLoad()
	g_Weapon2_SkillXuanZe_Frame_UnifiedPosition = Weapon2_SkillXuanZe_Frame:GetProperty("UnifiedPosition")
	
	g_SkillPoolAction_1[1] = Weapon2_SkillXuanZe_Kong01
	g_SkillPoolAction_1[2] = Weapon2_SkillXuanZe_Kong02
	g_SkillPoolAction_1[3] = Weapon2_SkillXuanZe_Kong03
	g_SkillPoolAction_1[4] = Weapon2_SkillXuanZe_Kong04
	
	g_SkillPoolAction_2[1] = Weapon2_SkillXuanZe_Kong05
	g_SkillPoolAction_2[2] = Weapon2_SkillXuanZe_Kong06
	g_SkillPoolAction_2[3] = Weapon2_SkillXuanZe_Kong07
	g_SkillPoolAction_2[4] = Weapon2_SkillXuanZe_Kong08
end

function Weapon2_SkillXuanZe_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88881501 then
		if not this:IsVisible() then
			Weapon2_SkillXuanZe_CleanUp()
			this:Show()
			Weapon2_SkillXuanZe_Update()
			Weapon2_SkillXuanZe_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Weapon2_SkillXuanZe_ItemCheck()	
		Weapon2_SkillXuanZe_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Weapon2_SkillXuanZe_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end	
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex and tonumber(arg1) ~= nil then
			Weapon2_SkillXuanZe_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Weapon2_SkillXuanZe" and tonumber(arg0) ~= nil then
			Weapon2_SkillXuanZe_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonDropIndex then
			Weapon2_SkillXuanZe_Item_OnItemDragedDropAway()
		end
		return
	end
end

function Weapon2_SkillXuanZe_ItemCheck()	
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
			g_Sel_Skill_Index_1 = 0
			g_Sel_Skill_Index_2 = 0
		end
	end
end

function Weapon2_SkillXuanZe_Update()
	
	local strTemp = ""
	
	Weapon2_SkillXuanZe_Item:SetActionItem(-1)
	
	for i = 1, 4 do
		g_SkillPoolAction_1[i]:SetActionItem(-1)
		g_SkillPoolAction_2[i]:SetActionItem(-1)
		g_SkillPoolAction_1[i]:SetPushed(0)
		g_SkillPoolAction_2[i]:SetPushed(0)
	end
	
	Weapon2_SkillXuanZe_Accept:Disable()

	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 1)
		local theAction = EnumAction(g_ShenBing_BagIndex, "packageitem")
		Weapon2_SkillXuanZe_Item:SetActionItem(theAction:GetID())
		
		local sb_table_index = PlayerPackage:GetItemTableIndex(g_ShenBing_BagIndex)
		local sb_skill_1, sb_skill_2 = PlayerPackage:LuaFnGetBagShenBingData(g_ShenBing_BagIndex, "COMMONSKILL")
		
		for i = 1, 4 do
			local skill_action_1 = DataPool:LuaFnEnumBagShenBingSkillAction(g_ShenBing_BagIndex, i - 1 + 7)
			g_SkillPoolAction_1[i]:SetActionItem(skill_action_1:GetID()) 
			
			local skill_action_2 = DataPool:LuaFnEnumBagShenBingSkillAction(g_ShenBing_BagIndex, i - 1 + 7 + 4)
			g_SkillPoolAction_2[i]:SetActionItem(skill_action_2:GetID())
			
			local pool_skill_1 = PlayerPackage:LuaFnGetShenBingCustomSkillFromPool(g_ShenBing_BagIndex, 0, i - 1)
			local pool_skill_2 = PlayerPackage:LuaFnGetShenBingCustomSkillFromPool(g_ShenBing_BagIndex, 1, i - 1)

			if g_Sel_Skill_Index_1 == 0 and sb_skill_1 == pool_skill_1 then
				g_Sel_Skill_Index_1 = i
			end
			
			if g_Sel_Skill_Index_2 == 0 and sb_skill_2 == pool_skill_2 then
				g_Sel_Skill_Index_2 = i
			end
		end
		
		for i = 1, 4 do
			if i == g_Sel_Skill_Index_1 then
				g_SkillPoolAction_1[i]:SetPushed(1)
			else
				g_SkillPoolAction_1[i]:SetPushed(0)
			end
			
			if i == g_Sel_Skill_Index_2 then
				g_SkillPoolAction_2[i]:SetPushed(1)
			else
				g_SkillPoolAction_2[i]:SetPushed(0)
			end
		end
	
		Weapon2_SkillXuanZe_Accept:Enable()
	end
	
	Weapon2_SkillXuanZe_UpdateSkillDesc()
end

function Weapon2_SkillXuanZe_UpdateSkillDesc()
	
	Weapon2_SkillXuanZe_Explain3_Info:SetText("")
	Weapon2_SkillXuanZe_Explain4_Info:SetText("")

	if g_ShenBing_BagIndex ~= -1 then
		if g_Sel_Skill_Index_1 ~= 0 then		
			local skill_id = PlayerPackage:LuaFnGetShenBingCommonSkillFromPool(g_ShenBing_BagIndex, 0, g_Sel_Skill_Index_1 - 1)
			local strSkillDesc = DataPool:LuaFnGetShenBingSkillDesc(skill_id)
			Weapon2_SkillXuanZe_Explain3_Info:SetText(tostring(strSkillDesc))
		end
		
		if g_Sel_Skill_Index_2 ~= 0 then		
			local skill_id = PlayerPackage:LuaFnGetShenBingCommonSkillFromPool(g_ShenBing_BagIndex, 1, g_Sel_Skill_Index_2 - 1)
			local strSkillDesc = DataPool:LuaFnGetShenBingSkillDesc(skill_id)
			Weapon2_SkillXuanZe_Explain4_Info:SetText(tostring(strSkillDesc))
		end	
	end
end

function Weapon2_SkillXuanZe_CloseClicked()
	this:Hide()
end

--从背包拖拽到UI
function Weapon2_SkillXuanZe_Item_OnItemDragedDropFromBag(iBagIndex)
	
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
	g_Sel_Skill_Index_1 = 0
	g_Sel_Skill_Index_2 = 0
	Weapon2_SkillXuanZe_Update()
end

function Weapon2_SkillXuanZe_Item_OnBagItemRClicked(iBagIndex)
	Weapon2_SkillXuanZe_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Weapon2_SkillXuanZe_Item_OnItemDragedDropAway()
	Weapon2_SkillXuanZe_ShenBing_OnRBClicked()
end

function Weapon2_SkillXuanZe_ShenBing_OnRBClicked()
	if g_ShenBing_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
		Weapon2_SkillXuanZe_Update()
	end
end

function Weapon2_SkillXuanZe_CleanUp()
	Weapon2_SkillXuanZe_Item:SetActionItem(-1)
	if g_ShenBing_BagIndex ~= -1 then	
		LifeAbility:Lock_Packet_Item(g_ShenBing_BagIndex, 0)
		g_ShenBing_BagIndex = -1
	end
	
	for i = 1, 4 do
		g_SkillPoolAction_1[i]:SetActionItem(-1)
		g_SkillPoolAction_2[i]:SetActionItem(-1)
	end
	
	Weapon2_SkillXuanZe_Accept:Disable()
end

function Weapon2_SkillXuanZe_OnHidden()
	Weapon2_SkillXuanZe_CleanUp()
	m_ObjServerId = -1
end

function Weapon2_SkillXuanZe_OK_Clicked()
	
	local my_level = Player:GetData("LEVEL")
	if my_level < g_LimitLevel then
		PushDebugMessage("#{SBFW_20230707_46}")
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888815)
		Set_XSCRIPT_Function_Name("ShenBingSelectSkill")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, g_ShenBing_BagIndex)
		Set_XSCRIPT_Parameter(2, g_Sel_Skill_Index_1 - 1)
		Set_XSCRIPT_Parameter(3, g_Sel_Skill_Index_2 - 1)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Weapon2_SkillXuanZe_HelpClicked()

end

function Weapon2_SkillXuanZe_SelectSkill(flag, skill_index)
	if flag == 0 then
		if g_Sel_Skill_Index_1 ~= skill_index then
			g_Sel_Skill_Index_1 = skill_index
			for i = 1, 4 do
				if i == skill_index then
					g_SkillPoolAction_1[i]:SetPushed(1)
				else
					g_SkillPoolAction_1[i]:SetPushed(0)
				end
			end
		end
	else
		if g_Sel_Skill_Index_2 ~= skill_index then
			g_Sel_Skill_Index_2 = skill_index
			for i = 1, 4 do
				if i == skill_index then
					g_SkillPoolAction_2[i]:SetPushed(1)
				else
					g_SkillPoolAction_2[i]:SetPushed(0)
				end
			end
		end
	end
	Weapon2_SkillXuanZe_UpdateSkillDesc()
end
--Care Obj
function Weapon2_SkillXuanZe_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Weapon2_SkillXuanZe_Frame_On_ResetPos()
	if g_Weapon2_SkillXuanZe_Frame_UnifiedPosition ~= nil then
		Weapon2_SkillXuanZe_Frame:SetProperty("UnifiedPosition", g_Weapon2_SkillXuanZe_Frame_UnifiedPosition)
	end
end
