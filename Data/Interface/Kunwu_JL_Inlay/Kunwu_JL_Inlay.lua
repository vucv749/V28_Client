--!!!reloadscript =Kunwu_JL_Inlay

local g_Kunwu_JL_Inlay_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_Elf_BagIndex = -1
local g_SelPetIndex = -1
local g_CurElfIndex = 0
local g_ActionButtonAcceptNum = 60

local g_Elf_Button = {}
local g_Elf_LockImg = {}

local g_NeedMoney = 200000

local g_Elf_MaxLevel = 20

local g_AttrNameLable1 = {}
local g_AttrValueLable1 = {}
local g_AttrNameLable2 = {}
local g_AttrValueLable2 = {}

local g_SkillChangeMode = 0

local g_YBPayConfirm = 1

function Kunwu_JL_Inlay_PreLoad()
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
	this:RegisterEvent("SELECT_PET_FOR_JL")
	this:RegisterEvent("UPDATE_PET_PAGE")
end

function Kunwu_JL_Inlay_OnLoad()
	g_Kunwu_JL_Inlay_Frame_UnifiedPosition = Kunwu_JL_Inlay_Frame:GetProperty("UnifiedPosition")
	
	g_Elf_Button[1] = Kunwu_JL_Inlay_Skill1
	g_Elf_Button[2] = Kunwu_JL_Inlay_Skill2
	g_Elf_Button[3] = Kunwu_JL_Inlay_Skill3
	g_Elf_Button[4] = Kunwu_JL_Inlay_Skill4
	g_Elf_Button[5] = Kunwu_JL_Inlay_Skill5
	
	g_Elf_LockImg[1] = Kunwu_JL_Inlay_Function_Left_Set1_Icon_LockImg
	g_Elf_LockImg[2] = Kunwu_JL_Inlay_Function_Left_Set2_Icon_LockImg
	g_Elf_LockImg[3] = Kunwu_JL_Inlay_Function_Left_Set3_Icon_LockImg
	g_Elf_LockImg[4] = Kunwu_JL_Inlay_Function_Left_Set4_Icon_LockImg
	g_Elf_LockImg[5] = Kunwu_JL_Inlay_Function_Left_Set5_Icon_LockImg
	
	g_AttrNameLable1[1] = Kunwu_JL_Inlay_Zizhi1_Text2
	g_AttrNameLable1[2] = Kunwu_JL_Inlay_Zizhi1_Text3
	g_AttrNameLable1[3] = Kunwu_JL_Inlay_Zizhi1_Text4
	g_AttrNameLable1[4] = Kunwu_JL_Inlay_Zizhi1_Text5
	g_AttrNameLable1[5] = Kunwu_JL_Inlay_Zizhi1_Text6
	
	g_AttrValueLable1[1] = Kunwu_JL_Inlay_Zizhi1_Text2_1
	g_AttrValueLable1[2] = Kunwu_JL_Inlay_Zizhi1_Text3_1
	g_AttrValueLable1[3] = Kunwu_JL_Inlay_Zizhi1_Text4_1
	g_AttrValueLable1[4] = Kunwu_JL_Inlay_Zizhi1_Text5_1
	g_AttrValueLable1[5] = Kunwu_JL_Inlay_Zizhi1_Text6_1
	
	g_AttrNameLable2[1] = Kunwu_JL_Inlay_Zizhi2_Text2
	g_AttrNameLable2[2] = Kunwu_JL_Inlay_Zizhi2_Text3
	g_AttrNameLable2[3] = Kunwu_JL_Inlay_Zizhi2_Text4
	g_AttrNameLable2[4] = Kunwu_JL_Inlay_Zizhi2_Text5
	g_AttrNameLable2[5] = Kunwu_JL_Inlay_Zizhi2_Text6
	
	g_AttrValueLable2[1] = Kunwu_JL_Inlay_Zizhi2_Text2_1
	g_AttrValueLable2[2] = Kunwu_JL_Inlay_Zizhi2_Text3_1
	g_AttrValueLable2[3] = Kunwu_JL_Inlay_Zizhi2_Text4_1
	g_AttrValueLable2[4] = Kunwu_JL_Inlay_Zizhi2_Text5_1
	g_AttrValueLable2[5] = Kunwu_JL_Inlay_Zizhi2_Text6_1

end

function Kunwu_JL_Inlay_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883002 then
		if not this:IsVisible() then
			Kunwu_JL_Inlay_CleanUp()
			this:Show()
			OpenWindow("Packet")
			--Pet:LuaFnShowPetListJL(1)
			Kunwu_JL_Inlay_Update()
			Kunwu_JL_Inlay_BeginCareObj(Get_XParam_INT(0))
			
			if g_YBPayConfirm == 1 then
				Kunwu_JL_Inlay_Button:SetCheck(1)
			else
				Kunwu_JL_Inlay_Button:SetCheck(0)
			end
		end
		return
	end	
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Kunwu_JL_Inlay_ItemCheck()
		Kunwu_JL_Inlay_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Inlay_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonAcceptNum and tonumber(arg1) ~= nil then
			Kunwu_JL_Inlay_Item_OnItemDragedDropFromBag(tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Kunwu_JL_Inlay" and tonumber(arg0) ~= nil then
			Kunwu_JL_Inlay_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		if tonumber(arg0) == g_ActionButtonAcceptNum then
			Kunwu_JL_Inlay_Item_OnItemDragedDropAway()
		end
		return
	end
	
	if event == "SELECT_PET_FOR_JL" and this:IsVisible() then
		Kunwu_JL_Inlay_SelectPet(tonumber(arg0))
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_JL_Inlay_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_JL_Inlay_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		Kunwu_JL_Inlay_Update()
		return
	end
end

--选择犱兽
function Kunwu_JL_Inlay_SelectPet(selidx)
	if selidx == -1 then
		return
	end
	
	--犱兽已被其它界面选中
	if Pet:GetPetLocation(selidx) ~= -1 then
		return
	end
	
	local active = Pet:LuaFnIsPetElfActived(selidx, 0)
	if active ~= 1 then
		PushDebugMessage("#{JLYC_241217_84}")
		return
	end
	
	if g_SelPetIndex == selidx then
		return
	end
	
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
	end

	g_SelPetIndex = selidx
	Pet:SetPetLocation(g_SelPetIndex, 18)
	g_CurElfIndex = 0
	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
		g_Elf_BagIndex = -1
	end
	
	Kunwu_JL_Inlay_Update()
end

function Kunwu_JL_Inlay_ItemCheck()	
	if g_Elf_BagIndex ~= -1 then
		local need_remove = 0
		
		if g_SelPetIndex == -1 or g_CurElfIndex == 0 then
			need_remove = 1
		end
		
		if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex) ~= 1 then
			need_remove = 1
		end
		
		if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) ~= 1 then
			need_remove = 1
		end
		
		local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(g_Elf_BagIndex)
		for i = 1, 5 do
			local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, i - 1)
			if elf_skill == pet_elf_skill and i ~= g_CurElfIndex then
				need_remove = 1
				break
			end
		end
		
		local elf_item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex)
		local elf_item_mutual_id = DataPool:LuaFnGetItemPetElfMutualId(elf_item_table_index)
		if elf_item_mutual_id ~= 0 then
			for i = 1, 5 do
				local pet_elf_item = Pet:LuaFnGetPetElfItem(g_SelPetIndex, i - 1)
				local pet_elf_mutual_id = DataPool:LuaFnGetItemPetElfMutualId(pet_elf_item)
				if elf_item_mutual_id == pet_elf_mutual_id and i ~= g_CurElfIndex then
				--	need_remove = 1
				--	break
				end
			end
		end
		
		local skill_type = Pet:LuaFnPetElfSkillUseType(elf_skill)
		if g_CurElfIndex == 5 then
			if skill_type ~= 2 then
				need_remove = 1
			end
		end
		
		if g_CurElfIndex ~= 5 then
			if skill_type ~= 1 then
				need_remove = 1
			end
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
end

function Kunwu_JL_Inlay_Update()
	
	local strTemp = ""
	
	Kunwu_JL_Inlay_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_JL_Inlay_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Kunwu_JL_Inlay_Money:SetProperty("MoneyNumber", "0")
	
	Kunwu_JL_Inlay_Icon:SetActionItem(-1)
	Kunwu_JL_Inlay_Object:SetActionItem(-1)
	Kunwu_JL_Inlay_Object2:SetActionItem(-1)
	
	for i = 1, 5 do
		g_Elf_Button[i]:SetActionItem(-1)
		g_Elf_Button[i]:SetPushed(0)
		g_Elf_LockImg[i]:Hide()
	end
	
	for i = 1, 5 do
		g_AttrNameLable1[i]:SetText("")
		g_AttrValueLable1[i]:SetText("")
		g_AttrValueLable1[i]:Hide()
		g_AttrNameLable2[i]:SetText("")
		g_AttrValueLable2[i]:SetText("")
		g_AttrValueLable2[i]:Hide()
	end
	
	Kunwu_JL_Inlay_Info:Show()
	Kunwu_JL_Inlay_Info2:Hide()

	Kunwu_JL_Inlay_Function_Top_Object_Text2:SetText("#{JLYC_241217_149}")
	
	Kunwu_JL_Inlay_PetModel1_Text1:SetText("")
	Kunwu_JL_Inlay_PetModel1_Text2:SetText("")
	Kunwu_JL_Inlay_PetModel2_Text1:SetText("")
	Kunwu_JL_Inlay_PetModel2_Text2:SetText("")
	
	Kunwu_JL_Inlay_Zizhi1_Lookup:Hide()
	Kunwu_JL_Inlay_Zizhi2_Lookup:Hide()
	
	Kunwu_JL_Inlay_Function_Top_Object:SetProperty("Image", "")
	
	if g_SelPetIndex ~= -1 then

		local szPetName = Pet:GetPetList_Appoint(g_SelPetIndex)
		Kunwu_JL_Inlay_Function_Top_Object_Text2:SetText("#cfff263"..szPetName)
		
		local szPortrait = Pet:GetPetPortraitByIndex(g_SelPetIndex)
		Kunwu_JL_Inlay_Function_Top_Object:SetProperty("Image", szPortrait)
		
		local max_elf_num = LuaFnGetPetElfMaxNum()
		for i = 1, 5 do
			g_Elf_LockImg[i]:Show()
			local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, i - 1)
			local ActionElf = EnumAction(max_elf_num * g_SelPetIndex + i - 1, "my_pet_elf")
			g_Elf_Button[i]:SetActionItem(ActionElf:GetID())
			
			local pet_elf_item = Pet:LuaFnGetPetElfItem(g_SelPetIndex, i - 1)
			
			if active == 1 then
				g_Elf_LockImg[i]:Hide()
				if i == g_CurElfIndex then
					g_Elf_Button[i]:SetPushed(1)
				end
			end
		end
		
		if g_CurElfIndex ~= 0 then

			local pet_elf_item = Pet:LuaFnGetPetElfItem(g_SelPetIndex, g_CurElfIndex - 1)
			local pet_elf_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(pet_elf_item))
			Kunwu_JL_Inlay_PetModel1_Text1:SetText("#cfff263"..tostring(pet_elf_item_name))
			
			local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
			if pet_elf_skill ~= nil and pet_elf_skill > 0 then 
				Kunwu_JL_Inlay_Zizhi1_Lookup:Show()
				local pet_elf_skill_name = Pet:LuaFnPetElfSkillName(tonumber(pet_elf_skill))
				Kunwu_JL_Inlay_PetModel1_Text2:SetText("#cfff263"..tostring(pet_elf_skill_name))
			end

			local ActionElf = EnumAction(max_elf_num * g_SelPetIndex + g_CurElfIndex - 1, "my_pet_elf")
			Kunwu_JL_Inlay_Object2:SetActionItem(ActionElf:GetID())
			
			for i = 1, 5 do
				local attr_id, attr_value = Pet:LuaFnGetPetElfAttr(g_SelPetIndex, g_CurElfIndex - 1, i - 1)
				if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
					local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
					g_AttrValueLable1[i]:Show()
					g_AttrNameLable1[i]:SetText("#cfff263"..tostring(attr_name))
					g_AttrValueLable1[i]:SetText("#cfff263+"..tostring(attr_value_string))
				end
			end
			
			if g_Elf_BagIndex ~= -1 then
				LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 1)
				local theAction = EnumAction(g_Elf_BagIndex, "packageitem")
				Kunwu_JL_Inlay_Object:SetActionItem(theAction:GetID())
				Kunwu_JL_Inlay_Icon:SetActionItem(theAction:GetID())
				
				local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex)
				local item_table_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(item_table_index))
				Kunwu_JL_Inlay_PetModel2_Text1:SetText("#cfff263"..tostring(item_table_name))
				
				local pet_elf_level = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
				local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(g_Elf_BagIndex)
				
				local elf_skill_name = Pet:LuaFnPetElfSkillName(tonumber(elf_skill))
				Kunwu_JL_Inlay_PetModel2_Text2:SetText("#cfff263"..tostring(elf_skill_name))
				
				Kunwu_JL_Inlay_Zizhi2_Lookup:Show()
				
				if pet_elf_level > 1 and elf_skill ~= pet_elf_skill then
					Kunwu_JL_Inlay_Info:Hide()
					Kunwu_JL_Inlay_Info2:Show()
					Kunwu_JL_Inlay_Info2_Item1:SetCheck(0)
					Kunwu_JL_Inlay_Info2_Item2:SetCheck(0)
					if g_SkillChangeMode == 1 then
						Kunwu_JL_Inlay_Info2_Item1:SetCheck(1)
					elseif g_SkillChangeMode == 2 then
						Kunwu_JL_Inlay_Info2_Item2:SetCheck(1)
					end
					
					local keep_need_item, keep_need_item_ct = Pet:LuaFnGetPetElfLevelKeepNeedItem(pet_elf_level)
					local keep_need_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(keep_need_item))
					local have_keep_need_item_count = PlayerPackage:Lua_GetUnLockItemCount(tonumber(keep_need_item))
					
					strTemp = ScriptGlobal_Format("#{JLYC_241217_162}", keep_need_item_name)
					Kunwu_JL_Inlay_Info2_Item1_Text:SetText(strTemp)

					if have_keep_need_item_count >= keep_need_item_ct then
						Kunwu_JL_Inlay_Info2_Item1_Text3:SetText("#G"..tostring(have_keep_need_item_count).."/"..tostring(keep_need_item_ct))
					else
						Kunwu_JL_Inlay_Info2_Item1_Text3:SetText("#cff0000"..tostring(have_keep_need_item_count).."/"..tostring(keep_need_item_ct))
					end
					
					if g_SkillChangeMode == 1 then
						if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) == 1 then
							for i = 1, 5 do
								local attr_id, attr_value = PlayerPackage:LuaFnGetItemPetElfAttr(g_Elf_BagIndex, i - 1, pet_elf_level)
								if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
									local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
									g_AttrValueLable2[i]:Show()
									g_AttrNameLable2[i]:SetText("#cfff263"..tostring(attr_name))
									g_AttrValueLable2[i]:SetText("#cfff263+"..tostring(attr_value_string))
								end
							end
						end					
					elseif g_SkillChangeMode == 2 then
						if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) == 1 then
							for i = 1, 5 do
								local attr_id, attr_value = PlayerPackage:LuaFnGetItemPetElfAttr(g_Elf_BagIndex, i - 1, 1)
								if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
									local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
									g_AttrValueLable2[i]:Show()
									g_AttrNameLable2[i]:SetText("#cfff263"..tostring(attr_name))
									g_AttrValueLable2[i]:SetText("#cfff263+"..tostring(attr_value_string))
								end
							end
						end					
					end
				else
					Kunwu_JL_Inlay_Info:Show()
					Kunwu_JL_Inlay_Info2:Hide()
					
					if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex) == 1 then
						for i = 1, 5 do
							local attr_id, attr_value = PlayerPackage:LuaFnGetItemPetElfAttr(g_Elf_BagIndex, i - 1, 1)
							if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
								local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
								g_AttrValueLable2[i]:Show()
								g_AttrNameLable2[i]:SetText("#cfff263"..tostring(attr_name))
								g_AttrValueLable2[i]:SetText("#cfff263+"..tostring(attr_value_string))
							end
						end
					end
				end
				
				Kunwu_JL_Inlay_Money:SetProperty("MoneyNumber", tostring(g_NeedMoney))

			end
		end
	end
	
	
end

function Kunwu_JL_Inlay_CloseClicked()
	this:Hide()
end

function Kunwu_JL_Inlay_Elf_Clicked(idx)
	if g_SelPetIndex == -1 then
		return
	end
	
	local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, idx - 1)
	if active ~= 1 then
		PushDebugMessage("#{JLYC_241217_150}")
		return
	end
	
	if g_CurElfIndex == idx then
		return
	end
	
	g_CurElfIndex = idx
	for i = 1, 5 do
		if i == g_CurElfIndex then
			g_Elf_Button[i]:SetPushed(1)
		else
			g_Elf_Button[i]:SetPushed(0)
		end
	end
	
	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
	end
	g_Elf_BagIndex = -1
	g_SkillChangeMode = 0
	Kunwu_JL_Inlay_Update()
end

--从背包拖拽到UI
function Kunwu_JL_Inlay_Item_OnItemDragedDropFromBag(iBagIndex)
	
	if PlayerPackage:LuaFnIsPetElf(iBagIndex) ~= 1 then
		PushDebugMessage("#{JLYC_241217_52}")
		return
	end
	
	if g_SelPetIndex == -1 then
		PushDebugMessage("#{JLYC_241217_192}")
		return
	end
	
	if g_CurElfIndex == 0 then
		PushDebugMessage("#{JLYC_241217_72}")
		return
	end

	if PlayerPackage:LuaFnIsPetElfIdentified(iBagIndex) ~= 1 then
		PushDebugMessage("#{JLYC_241217_53}")
		return
	end

	local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(iBagIndex)
	for i = 1, 5 do
		local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, i - 1)
		if elf_skill == pet_elf_skill and i ~= g_CurElfIndex then
			local strSkill = Pet:LuaFnPetElfSkillName(tonumber(pet_elf_skill))
			local strTemp = ScriptGlobal_Format("#{JLYC_241217_101}", tostring(strSkill))
			PushDebugMessage(strTemp)
			return
		end
	end
	
	local elf_item_table_index = PlayerPackage:GetItemTableIndex(iBagIndex)
	local elf_item_mutual_id = DataPool:LuaFnGetItemPetElfMutualId(elf_item_table_index)
	if elf_item_mutual_id ~= 0 then
		for i = 1, 5 do
			local pet_elf_item = Pet:LuaFnGetPetElfItem(g_SelPetIndex, i - 1)
			local pet_elf_mutual_id = DataPool:LuaFnGetItemPetElfMutualId(pet_elf_item)
			if elf_item_mutual_id == pet_elf_mutual_id and i ~= g_CurElfIndex then
			--	PushDebugMessage("#{JLYC_241217_48}")
			--	return
			end
		end
	end
	
	local pet_type = Pet:LuaFnGetPetAttackType(g_SelPetIndex)
	local elf_type = PlayerPackage:LuaFnGetPetElfItemType(iBagIndex)
	if elf_type ~= pet_type then
		PushDebugMessage("#{JLYC_241217_87}")
		return
	end
	
	local skill_type = Pet:LuaFnPetElfSkillUseType(elf_skill)
	if g_CurElfIndex == 5 then
		if skill_type ~= 2 then
			PushDebugMessage("#{JLYC_241217_90}")
			return
		end
	end
	
	if g_CurElfIndex ~= 5 then
		if skill_type ~= 1 then
			PushDebugMessage("#{JLYC_241217_89}")
			return
		end
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
	g_SkillChangeMode = 0
	Kunwu_JL_Inlay_Update()	
end

function Kunwu_JL_Inlay_Item_OnBagItemRClicked(iBagIndex)
	Kunwu_JL_Inlay_Item_OnItemDragedDropFromBag(iBagIndex)	
end

function Kunwu_JL_Inlay_Item_OnItemDragedDropAway()
	Kunwu_JL_Inlay_Elf_OnRBClicked()
end

function Kunwu_JL_Inlay_Elf_OnRBClicked()
	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
		g_Elf_BagIndex = -1
		Kunwu_JL_Inlay_Update()
	end
end

function Kunwu_JL_Inlay_CleanUp()
	for i = 1, 5 do
		g_Elf_Button[i]:SetActionItem(-1)
		g_Elf_LockImg[i]:Hide()
	end
	Kunwu_JL_Inlay_Object:SetActionItem(-1)
	Kunwu_JL_Inlay_Object2:SetActionItem(-1)
	Kunwu_JL_Inlay_Icon:SetActionItem(-1)
end

function Kunwu_JL_Inlay_OnHidden()
	Kunwu_JL_Inlay_CleanUp()
	m_ObjServerId = -1
	Pet:LuaFnShowPetListJL(0)
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
	
	if g_Elf_BagIndex ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex, 0)
		g_Elf_BagIndex = -1
	end
	
	g_CurElfIndex = 0
end

function Kunwu_JL_Inlay_OK_Clicked()
	if g_SelPetIndex == -1 then
		return
	end
	
	if g_CurElfIndex == 0 then
		return
	end
	
	if g_Elf_BagIndex == -1 then
		PushDebugMessage("#{JLYC_241217_54}")
		return
	end
	
	local change_mode = 0
	local pet_elf_level = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
	local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(g_Elf_BagIndex)
	if pet_elf_level > 1 and elf_skill ~= pet_elf_skill then
		if g_SkillChangeMode ~= 1 and g_SkillChangeMode ~= 2 then
			PushDebugMessage("#{JLYC_241217_165}")
			return
		end
		change_mode = g_SkillChangeMode
	end
	
	local yb_buy_notify = Kunwu_JL_Inlay_Button:GetCheck()
	
	local hid, lid = Pet:GetGUID(g_SelPetIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888830)
		Set_XSCRIPT_Function_Name("PutInElf")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, hid)
		Set_XSCRIPT_Parameter(2, lid)
		Set_XSCRIPT_Parameter(3, g_CurElfIndex - 1)
		Set_XSCRIPT_Parameter(4, g_Elf_BagIndex)
		Set_XSCRIPT_Parameter(5, change_mode)
		Set_XSCRIPT_Parameter(6, yb_buy_notify)
		Set_XSCRIPT_Parameter(7, 1)
		Set_XSCRIPT_ParamCount(8)
	Send_XSCRIPT()
end

function Kunwu_JL_Inlay_HelpClicked()

end
--Care Obj
function Kunwu_JL_Inlay_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_JL_Inlay_Frame_On_ResetPos()
	if g_Kunwu_JL_Inlay_Frame_UnifiedPosition ~= nil then
		Kunwu_JL_Inlay_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Inlay_Frame_UnifiedPosition)
	end
end

function Kunwu_JL_Inlay_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Inlay_PetModel1:RotateBegin(-0.3)
	--stop
	else
		Kunwu_JL_Inlay_PetModel1:RotateEnd()
	end
end

function Kunwu_JL_Inlay_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Inlay_PetModel1:RotateBegin(0.3)
	--stop
	else
		Kunwu_JL_Inlay_PetModel1:RotateEnd()
	end
end

function Kunwu_JL_Inlay_OpenPetList()
	Pet:LuaFnShowPetListJL(1)
end

function Kunwu_JL_Inlay_SelectMode(idx)
	if g_SkillChangeMode ~= idx then
		g_SkillChangeMode = idx
		Kunwu_JL_Inlay_Info2_Item1:SetCheck(0)
		Kunwu_JL_Inlay_Info2_Item2:SetCheck(0)
		if g_SkillChangeMode == 1 then
			Kunwu_JL_Inlay_Info2_Item1:SetCheck(1)
		elseif g_SkillChangeMode == 2 then
			Kunwu_JL_Inlay_Info2_Item2:SetCheck(1)
		end
		Kunwu_JL_Inlay_Update()
	end
end

function Kunwu_JL_Inlay_OpenSkill(flag)
	if g_SelPetIndex == -1 then
		return
	end
	
	if g_CurElfIndex == 0 then
		return
	end
	
	if flag == 1 then
		local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
		Pet:LuaFnOpenPetElfBook(pet_elf_skill, m_ObjServerId)
	elseif flag == 2 then
		if g_Elf_BagIndex == -1 then
			return
		end
		
		local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(g_Elf_BagIndex)
		Pet:LuaFnOpenPetElfBook(elf_skill, m_ObjServerId)
	end
end

function Kunwu_JL_Inlay_YBPayConfirm()
	if g_YBPayConfirm == 1 then
		g_YBPayConfirm = 0
	else
		g_YBPayConfirm = 1
	end
end
