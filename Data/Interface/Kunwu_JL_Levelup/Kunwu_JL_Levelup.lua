--!!!reloadscript =Kunwu_JL_Levelup

local g_Kunwu_JL_Levelup_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_ActionButtonAcceptNum = {61, 62, 63}

local g_SelPetIndex = -1
local g_CurElfIndex = 0

local g_petGUIDH = -1
local g_petGUIDL = -1

local g_Elf_Button = {}
local g_Elf_LockImg = {}

local g_Elf_ItemButton = {}
local g_Elf_ItemButtonLock = {}
local g_Elf_ItemButtonNum = {}
local g_Elf_ItemButtonNumBK = {}

local g_Elf_BagIndex = {-1, -1, -1}
local g_AttrNameLable = {}
local g_AttrValueLable = {}
local g_AttrNameLable2 = {}
local g_AttrValueLable2 = {}

local g_Elf_MaxLevel = 20

--昆吾月莲
local g_ReplacedItem = {
38003481,
38003482,
38003483,
38003484,
38003485,
38003486,
}
--经验丹
local g_ExpItem = {
38003475,
38003476,
38003477,
38003478,
38003479,
38003480,
}

local g_SkillStageStr = {
"#{JLYC_241217_178}",
"#{JLYC_241217_179}",
"#{JLYC_241217_180}",
"#{JLYC_241217_181}",
"#{JLYC_241217_182}",
"#{JLYC_241217_183}",
"#{JLYC_241217_184}",
}

local g_CheckProtect = 0
local g_YBPayConfirm = 1

function Kunwu_JL_Levelup_PreLoad()
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

function Kunwu_JL_Levelup_OnLoad()
	g_Kunwu_JL_Levelup_Frame_UnifiedPosition = Kunwu_JL_Levelup_Frame:GetProperty("UnifiedPosition")
	
	g_Elf_Button[1] = Kunwu_JL_Levelup_Function_Left_Set1_Icon
	g_Elf_Button[2] = Kunwu_JL_Levelup_Function_Left_Set2_Icon
	g_Elf_Button[3] = Kunwu_JL_Levelup_Function_Left_Set3_Icon
	g_Elf_Button[4] = Kunwu_JL_Levelup_Function_Left_Set4_Icon
	g_Elf_Button[5] = Kunwu_JL_Levelup_Function_Left_Set5_Icon
	
	g_Elf_LockImg[1] = Kunwu_JL_Levelup_Function_Left_Set1_Icon_LockImg
	g_Elf_LockImg[2] = Kunwu_JL_Levelup_Function_Left_Set2_Icon_LockImg
	g_Elf_LockImg[3] = Kunwu_JL_Levelup_Function_Left_Set3_Icon_LockImg
	g_Elf_LockImg[4] = Kunwu_JL_Levelup_Function_Left_Set4_Icon_LockImg
	g_Elf_LockImg[5] = Kunwu_JL_Levelup_Function_Left_Set5_Icon_LockImg
	
	g_AttrNameLable[1] = Kunwu_JL_Levelup_Attribute1_Text1
	g_AttrNameLable[2] = Kunwu_JL_Levelup_Attribute2_Text1
	g_AttrNameLable[3] = Kunwu_JL_Levelup_Attribute3_Text1
	g_AttrNameLable[4] = Kunwu_JL_Levelup_Attribute4_Text1
	g_AttrNameLable[5] = Kunwu_JL_Levelup_Attribute5_Text1
	
	g_AttrNameLable2[1] = Kunwu_JL_Levelup_Attribute6_Text1
	g_AttrNameLable2[2] = Kunwu_JL_Levelup_Attribute7_Text1
	g_AttrNameLable2[3] = Kunwu_JL_Levelup_Attribute8_Text1
	g_AttrNameLable2[4] = Kunwu_JL_Levelup_Attribute9_Text1
	g_AttrNameLable2[5] = Kunwu_JL_Levelup_Attribute10_Text1
	
	g_AttrValueLable[1] = Kunwu_JL_Levelup_Attribute1_Text2
	g_AttrValueLable[2] = Kunwu_JL_Levelup_Attribute2_Text2
	g_AttrValueLable[3] = Kunwu_JL_Levelup_Attribute3_Text2
	g_AttrValueLable[4] = Kunwu_JL_Levelup_Attribute4_Text2
	g_AttrValueLable[5] = Kunwu_JL_Levelup_Attribute5_Text2
	
	g_AttrValueLable2[1] = Kunwu_JL_Levelup_Attribute6_Text2
	g_AttrValueLable2[2] = Kunwu_JL_Levelup_Attribute7_Text2
	g_AttrValueLable2[3] = Kunwu_JL_Levelup_Attribute8_Text2
	g_AttrValueLable2[4] = Kunwu_JL_Levelup_Attribute9_Text2
	g_AttrValueLable2[5] = Kunwu_JL_Levelup_Attribute10_Text2
	
	g_Elf_ItemButton[1] = Kunwu_JL_Levelup_Skill1
	g_Elf_ItemButton[2] = Kunwu_JL_Levelup_Skill2
	g_Elf_ItemButton[3] = Kunwu_JL_Levelup_Skill3
	
	g_Elf_ItemButtonLock[1] = Kunwu_JL_Levelup_Skill1_LockImg
	g_Elf_ItemButtonLock[2] = Kunwu_JL_Levelup_Skill2_LockImg
	g_Elf_ItemButtonLock[3] = Kunwu_JL_Levelup_Skill3_LockImg
	
	g_Elf_ItemButtonNum[1] = Kunwu_JL_Levelup_Skill1_Num
	g_Elf_ItemButtonNum[2] = Kunwu_JL_Levelup_Skill2_Num
	g_Elf_ItemButtonNum[3] = Kunwu_JL_Levelup_Skill3_Num
	
	g_Elf_ItemButtonNumBK[1] = Kunwu_JL_Levelup_Skill1_NumBK
	g_Elf_ItemButtonNumBK[2] = Kunwu_JL_Levelup_Skill2_NumBK
	g_Elf_ItemButtonNumBK[3] = Kunwu_JL_Levelup_Skill3_NumBK
	
	local use_protect = Variable:GetVariable("PetElfLevelUpUseProtect")
	if use_protect == "1" then
		g_CheckProtect = 1
	else
		g_CheckProtect = 0
	end
	
	local yb_pay_confirm = Variable:GetVariable("PetElfLevelUpYBPayConfirm")
	if yb_pay_confirm == "0" then
		g_YBPayConfirm = 0
	else
		g_YBPayConfirm = 1
	end
end

function Kunwu_JL_Levelup_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883003 then
		if not this:IsVisible() then
			Kunwu_JL_Levelup_CleanUp()
			this:Show()
			OpenWindow("Packet")
			--Pet:LuaFnShowPetListJL(1)
			Kunwu_JL_Levelup_Update()
			Kunwu_JL_Levelup_BeginCareObj(Get_XParam_INT(0))
			if g_YBPayConfirm == 1 then
				Kunwu_JL_Levelup_Button:SetCheck(1)
			else
				Kunwu_JL_Levelup_Button:SetCheck(0)
			end
		end
		return
	end
	
	if event == "UI_COMMAND" and tonumber(arg0) == 88883006 then
		for i = 1, 3 do
			if g_Elf_BagIndex[i] ~= -1 then
				LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
			end
			g_Elf_BagIndex[i] = -1
		end
		return
	end
	
	if event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		Kunwu_JL_Levelup_ItemCheck()
		Kunwu_JL_Levelup_CacheProtectState()
		Kunwu_JL_Levelup_Update()
		return
	end
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Levelup_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "BAG_ITEM_DRAGDROP_TO_UI" and this:IsVisible() then
		local idx = Kunwu_JL_Levelup_GetActionIdx(tonumber(arg0))
		if idx >= 1 and idx <= 3 and tonumber(arg1) ~= nil then
			Kunwu_JL_Levelup_Item_OnItemDragedDropFromBag(idx, tonumber(arg1))
		end
		return
	end
	
	if event == "BAG_ITEM_RBCLICK_TO_UI" and this:IsVisible() then
		if arg1 == "Kunwu_JL_Levelup" and tonumber(arg0) ~= nil then
			Kunwu_JL_Levelup_Item_OnBagItemRClicked(tonumber(arg0))
		end
		return
	end
	
	if event == "BAG_ITEM_DRAGAWAY_FROM_UI" and this:IsVisible() then
		local idx = Kunwu_JL_Levelup_GetActionIdx(tonumber(arg0))
		if idx >= 1 and idx <= 3 then
			Kunwu_JL_Levelup_Item_OnItemDragedDropAway(idx)
		end
		return
	end
	
	if event == "SELECT_PET_FOR_JL" and this:IsVisible() then
		Kunwu_JL_Levelup_SelectPet(tonumber(arg0))
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_JL_Levelup_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_JL_Levelup_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		if g_SelPetIndex ~= -1 then
			local hid, lid = Pet:GetGUID(g_SelPetIndex)
			if g_petGUIDH ~= hid or g_petGUIDL ~= lid then
				Pet:SetPetLocation(g_SelPetIndex, -1)
				g_SelPetIndex = -1
			end
			Kunwu_JL_Levelup_ItemCheck()
			Kunwu_JL_Levelup_CacheProtectState()
			Kunwu_JL_Levelup_Update()
			return
		end
	end
end

function Kunwu_JL_Levelup_GetActionIdx(iAcceptNum)
	local idx = iAcceptNum - g_ActionButtonAcceptNum[1] + 1
	return idx
end

--选择珍兽
function Kunwu_JL_Levelup_SelectPet(selidx)
	if selidx == -1 then
		return
	end
	
	--珍兽已被其它界面选中
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
	g_CurElfIndex = 1
	Pet:SetPetLocation(g_SelPetIndex, 19)
	for i = 1, 3 do
		if g_Elf_BagIndex[i] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
		end	
		g_Elf_BagIndex[i] = -1
	end
	
	local hid, lid = Pet:GetGUID(g_SelPetIndex)
	g_petGUIDH = hid
	g_petGUIDL = lid
	Kunwu_JL_Levelup_CacheProtectState()
	Kunwu_JL_Levelup_Update()
end

function Kunwu_JL_Levelup_ItemCheck()
	--先检查精灵
	for i = 1, 3 do
		if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) == 1 then
			local need_remove = Kunwu_JL_Levelup_ItemNeedRemove(i)
			if need_remove == 1 then		
				LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
				g_Elf_BagIndex[i] = -1
			end
		end
	end

	--再检查可替换道具
	for i = 1, 3 do
		local idx = 3 - i + 1
		if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[idx]) ~= 1 then
			local need_remove = Kunwu_JL_Levelup_ItemNeedRemove(idx)
			if need_remove == 1 then		
				LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[idx], 0)
				g_Elf_BagIndex[idx] = -1
			end
		end
	end
end

function Kunwu_JL_Levelup_ItemNeedRemove(idx)
	if g_Elf_BagIndex[idx] == -1 then
		return 0
	end

	if g_SelPetIndex == -1 then
		return 1
	end
	
	if g_CurElfIndex == 0 then
		return 1
	end
	
	if Pet:LuaFnIsPetElfDefault(g_SelPetIndex, g_CurElfIndex - 1) == 1 then
		return 1
	end

	local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	if curLv == g_Elf_MaxLevel then
		return 1
	end
	
	local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(curLv)
	if need_qual < 1 or need_qual > 6 then
		return 1
	end

	if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[idx]) ~= 1 then
		local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex[idx])
		if Kunwu_JL_Levelup_IsReplacedItem(item_table_index) == 1 then
			if item_table_index ~= g_ReplacedItem[need_qual] then
				return 1
			else
				if Kunwu_JL_Levelup_CanPutMore(curLv, idx) == 0 then
					return 1
				end
			end
		else
			return 1
		end
	else
		if PlayerPackage:LuaFnIsPetElfIdentified(g_Elf_BagIndex[idx]) ~= 1 then
			return 1
		end
		
		local pet_elf_level = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_qual = PlayerPackage:LuaFnGetPetElfItemQual(g_Elf_BagIndex[idx])
		local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(pet_elf_level)
		
		local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(g_Elf_BagIndex[idx])
		
		local pet_elf_type = Pet:LuaFnGetPetElfType(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_type = PlayerPackage:LuaFnGetPetElfItemType(g_Elf_BagIndex[idx])

		if elf_qual ~= need_qual or elf_skill ~= pet_elf_skill or elf_type ~= pet_elf_type then
			return 1
		end
	end
	
	--加锁
	if PlayerPackage:IsLock(g_Elf_BagIndex[idx]) == 1 then
		return 1
	end
	
	return 0
end

function Kunwu_JL_Levelup_Update()
	
	local strTemp = ""
	Kunwu_JL_Levelup_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_JL_Levelup_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Kunwu_JL_Levelup_Info1_Text:SetText("")
	Kunwu_JL_Levelup_SpiritualityText:SetText("")
	Kunwu_JL_Levelup_ConsumptionText:SetText("")
	Kunwu_JL_Levelup_Spirituality:SetText("")
	Kunwu_JL_Levelup_Consumption:SetText("")
	
	Kunwu_JL_Levelup_Money:SetProperty("MoneyNumber", "0")
	
	Kunwu_JL_Levelup_Function_RightFrame_Mid:Show()
	Kunwu_JL_Levelup_Function_RightFrame_Top:Hide()
	Kunwu_JL_Levelup_Down_Text:SetText("#{JLYC_241217_118}")
	
	for i = 1, 5 do
		g_Elf_Button[i]:SetActionItem(-1)
		g_Elf_Button[i]:SetPushed(0)
		g_Elf_LockImg[i]:Hide()
	end

	Kunwu_JL_Levelup_SuccessText:Hide()
	Kunwu_JL_Levelup_Success:Hide()
	
	for i = 1, 5 do
		g_AttrNameLable[i]:SetText("")
		g_AttrValueLable[i]:SetText("")
		g_AttrNameLable2[i]:SetText("")
		g_AttrValueLable2[i]:SetText("")
	end
	
	Kunwu_JL_Levelup_Info2_Text:SetText("")
	Kunwu_JL_Levelup_Info2_Text2:SetText("")
	
	Kunwu_JL_Levelup_Function_Top_Object_Text2:SetText("#{JLYC_241217_149}")
	
	for i = 1, 3 do
		g_Elf_ItemButton[i]:SetActionItem(-1)
		g_Elf_ItemButton[i]:Disable()
		g_Elf_ItemButtonLock[i]:Show()
		g_Elf_ItemButtonNum[i]:Hide()
		g_Elf_ItemButtonNumBK[i]:Hide()
	end
	
	Kunwu_JL_Levelup_Info2_Title1:Hide()
	Kunwu_JL_Levelup_Info2_Name:Hide()
	Kunwu_JL_Levelup_Info2_Title2:Hide()
	Kunwu_JL_Levelup_Zizhi1_Lookup:Hide()
	
	Kunwu_JL_Levelup_Info3_Title1:Hide()
	Kunwu_JL_Levelup_Info3_Name:Hide()
	Kunwu_JL_Levelup_Info3_Title2:Hide()
	Kunwu_JL_Levelup_Zizhi2_Lookup:Hide()
	
	Kunwu_JL_Levelup_Function_Top_Object:SetProperty("Image", "")

	if g_SelPetIndex ~= -1 then
		local szPetName = Pet:GetPetList_Appoint(g_SelPetIndex)
		Kunwu_JL_Levelup_Function_Top_Object_Text2:SetText("#cfff263"..szPetName)
		
		local szPortrait = Pet:GetPetPortraitByIndex(g_SelPetIndex)
		Kunwu_JL_Levelup_Function_Top_Object:SetProperty("Image", szPortrait)
		
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
		
		local iLingXing = Pet:GetLixing(g_SelPetIndex)
		
		if g_CurElfIndex ~= 0 then
			local pet_elf_item = Pet:LuaFnGetPetElfItem(g_SelPetIndex, g_CurElfIndex - 1)
			local pet_elf_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(pet_elf_item))
			
			--初始兽灵
			if Pet:LuaFnIsPetElfDefault(g_SelPetIndex, g_CurElfIndex - 1) == 1 then
				
				Kunwu_JL_Levelup_Down_Text:SetText("#{JLYC_241217_91}")
				Kunwu_JL_Levelup_Spirituality:SetText("0/0")
				Kunwu_JL_Levelup_Consumption:SetText("0/0")
				
				local exp_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ExpItem[1]))
				strTemp = ScriptGlobal_Format("#{JLYC_241217_122}", exp_item_name)
				Kunwu_JL_Levelup_ConsumptionText:SetText(strTemp)
				
				Kunwu_JL_Levelup_SpiritualityText:SetText("#{JLYC_241217_121}")
			else
				local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
				--满级兽灵
				if curLv == g_Elf_MaxLevel then
					Kunwu_JL_Levelup_Down_Text:SetText("#{JLYC_241217_97}")
					Kunwu_JL_Levelup_Spirituality:SetText("0/0")
					Kunwu_JL_Levelup_Consumption:SetText("0/0")
					
					local exp_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ExpItem[6]))
					strTemp = ScriptGlobal_Format("#{JLYC_241217_122}", exp_item_name)
					Kunwu_JL_Levelup_ConsumptionText:SetText(strTemp)
					
					Kunwu_JL_Levelup_SpiritualityText:SetText("#{JLYC_241217_121}")
				else
					Kunwu_JL_Levelup_Function_RightFrame_Mid:Hide()
					Kunwu_JL_Levelup_Function_RightFrame_Top:Show()
	
					Kunwu_JL_Levelup_Info2_Title1:Show()
					Kunwu_JL_Levelup_Info2_Name:Show()
					Kunwu_JL_Levelup_Info2_Title2:Show()
					Kunwu_JL_Levelup_Zizhi1_Lookup:Show()
					
					Kunwu_JL_Levelup_Info3_Title1:Show()
					Kunwu_JL_Levelup_Info3_Name:Show()
					Kunwu_JL_Levelup_Info3_Title2:Show()
					Kunwu_JL_Levelup_Zizhi2_Lookup:Show()

					strTemp = ScriptGlobal_Format("#{JLYC_241217_177}", tostring(pet_elf_item_name), tostring(curLv))
					Kunwu_JL_Levelup_Info2_Text:SetText(strTemp)
					strTemp = ScriptGlobal_Format("#{JLYC_241217_177}", tostring(pet_elf_item_name), tostring(curLv + 1))
					Kunwu_JL_Levelup_Info2_Text2:SetText(strTemp)
					
					local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
					local pet_elf_skill_name = Pet:LuaFnPetElfSkillName(tonumber(pet_elf_skill))
					local stage = Kunwu_JL_Levelup_GetSkillStage(curLv)
					local next_stage = Kunwu_JL_Levelup_GetSkillStage(curLv + 1)
					if stage >= 1 and stage <= 7 then
						strTemp = ScriptGlobal_Format(g_SkillStageStr[stage], tostring(pet_elf_skill_name))
						Kunwu_JL_Levelup_Info2_Name:SetText(strTemp)
					end
					
					if next_stage >= 1 and next_stage <= 7 then
						strTemp = ScriptGlobal_Format(g_SkillStageStr[next_stage], tostring(pet_elf_skill_name))
						Kunwu_JL_Levelup_Info3_Name:SetText(strTemp)
					end
					
					for i = 1, 5 do
						local attr_id, attr_value = Pet:LuaFnGetPetElfAttr(g_SelPetIndex, g_CurElfIndex - 1, i - 1)
						if tonumber(attr_id) ~= nil and tonumber(attr_id) >= 0 then
							local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id, attr_value)
							g_AttrNameLable[i]:SetText("#cfff263"..tostring(attr_name))
							g_AttrValueLable[i]:SetText("#cfff263+"..tostring(attr_value_string))
						end
						
						local attr_id_new, attr_value_new = Pet:LuaFnGetPetElfLevelUpAttr(g_SelPetIndex, g_CurElfIndex - 1, i - 1)
						if tonumber(attr_id_new) ~= nil and tonumber(attr_id_new) >= 0 then
							local attr_name, attr_value_string = DataPool:LuaFnGetItemPetElfAttrDesc(attr_id_new, attr_value_new)
							g_AttrNameLable2[i]:SetText("#cfff263"..tostring(attr_name))
							g_AttrValueLable2[i]:SetText("#cfff263+"..tostring(attr_value_string))
						end
					end
					
					local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(curLv)
					local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
					local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(curLv)
					local pet_elf_type = Pet:LuaFnGetPetElfType(g_SelPetIndex, g_CurElfIndex - 1)
						
					local strSkill = Pet:LuaFnPetElfSkillName(tonumber(pet_elf_skill))
					local strType = ""
					if pet_elf_type == 0 then
						strType = "#{JLYC_241217_98}"
					elseif pet_elf_type == 1 then
						strType = "#{JLYC_241217_99}"
					elseif pet_elf_type == 2 then
						strType = "#{JLYC_241217_100}"
					end
					
					if need_qual >= 1 and need_qual <= 6 then
						local replace_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ReplacedItem[need_qual]))
						strTemp = ScriptGlobal_Format("#{JLYC_241217_119}", tostring(need_count), tostring(need_qual), strType, tostring(strSkill), replace_item_name)
						Kunwu_JL_Levelup_Info1_Text:SetText(strTemp)
					end
					
					local leak_count = need_count
					for i = 1, 3 do
						if i <= need_count then
							if g_Elf_BagIndex[i] ~= -1  then
								if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) == 1 then
									leak_count = leak_count - 1
								end
							end
						end
					end
					
					for i = 1, 3 do
						if i <= need_count then
							g_Elf_ItemButton[i]:Enable()
							g_Elf_ItemButtonLock[i]:Hide()
							if g_Elf_BagIndex[i] ~= -1  then
								LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 1)
								if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) == 1 then
									local theAction = EnumAction(g_Elf_BagIndex[i], "packageitem")
									g_Elf_ItemButton[i]:SetActionItem(theAction:GetID())
								else
									local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex[i])
									if Kunwu_JL_Levelup_IsReplacedItem(item_table_index) == 1 then
										g_Elf_ItemButtonNumBK[i]:Show()
										g_Elf_ItemButtonNum[i]:Show()
										local lay_num = PlayerPackage:GetBagItemNum(g_Elf_BagIndex[i])
										if GetItemBindStatus(g_Elf_BagIndex[i]) == 1 then
											local theAction = DataPool:CreateBindActionItemForShow(item_table_index, 1)
											g_Elf_ItemButton[i]:SetActionItem(theAction:GetID())
										else
											local theAction = DataPool:CreateActionItemForShow(item_table_index, 1)
											g_Elf_ItemButton[i]:SetActionItem(theAction:GetID())
										end
										strTemp = ScriptGlobal_Format("#{JLYC_241217_190}", tostring(lay_num), tostring(leak_count))
										g_Elf_ItemButtonNum[i]:SetText(strTemp)
									end
								end
							end
						end
					end
						
					local need_money = Pet:LuaFnGetPetElfLevelNeedMoney(curLv)
					Kunwu_JL_Levelup_Money:SetProperty("MoneyNumber", tostring(need_money))
						
					local need_lx = Pet:LuaFnGetPetElfLevelTPNeedPetLingXing(curLv)
					if iLingXing >= need_lx then
						Kunwu_JL_Levelup_Spirituality:SetText("#G"..tostring(iLingXing).."/"..tostring(need_lx))
					else
						Kunwu_JL_Levelup_Spirituality:SetText("#cff0000"..tostring(iLingXing).."/"..tostring(need_lx))
					end					
					Kunwu_JL_Levelup_SpiritualityText:SetText("#{JLYC_241217_121}")
					
					local exp_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ExpItem[need_qual]))
					local need_exp_count = Pet:LuaFnGetPetElfNeedExpItemCount(curLv)
					local have_exp_count = PlayerPackage:Lua_GetUnLockItemCount(g_ExpItem[need_qual])
					if have_exp_count >= need_exp_count then
						Kunwu_JL_Levelup_Consumption:SetText("#G"..tostring(have_exp_count).."/"..tostring(need_exp_count))
					else
						Kunwu_JL_Levelup_Consumption:SetText("#cff0000"..tostring(have_exp_count).."/"..tostring(need_exp_count))
					end
					
					strTemp = ScriptGlobal_Format("#{JLYC_241217_122}", exp_item_name)
					Kunwu_JL_Levelup_ConsumptionText:SetText(strTemp)
					
					Kunwu_JL_Levelup_SuccessText:Show()					
					local odds = Pet:LuaFnGetPetElfLevelTPOdds(curLv)
					Kunwu_JL_Levelup_Success:Show()
					strTemp = ScriptGlobal_Format("#{JLYC_241217_191}", tostring(odds))
					Kunwu_JL_Levelup_Success:SetText(strTemp)
					
					local need_protect_item, need_protect_item_count = Pet:LuaFnGetPetElfProtectNeedItem(curLv)
					if tonumber(need_protect_item) == nil or tonumber(need_protect_item) < 0 then
						Kunwu_JL_Levelup_Info_Item:Hide()
						Kunwu_JL_Levelup_Info_Item_Text1:Hide()
						Kunwu_JL_Levelup_Info_Item_Text2:Show()
					else
						Kunwu_JL_Levelup_Info_Item:Show()
						Kunwu_JL_Levelup_Info_Item_Text1:Show()
						Kunwu_JL_Levelup_Info_Item_Text2:Hide()
						
						if g_CheckProtect == 1 then
							Kunwu_JL_Levelup_Info_Item:SetCheck(1)
						else
							Kunwu_JL_Levelup_Info_Item:SetCheck(0)
						end
						
						local protect_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(need_protect_item))
						local have_protect_item_count = PlayerPackage:Lua_GetUnLockItemCount(tonumber(need_protect_item))
						strTemp = ScriptGlobal_Format("#{JLYC_241217_200}", protect_item_name, tostring(have_protect_item_count), tostring(need_protect_item_count))
						Kunwu_JL_Levelup_Info_Item_Text1:SetText(strTemp)
					end
				end
			
			end
			
			
		end
		
		if g_CurElfIndex == 0 then

		elseif Pet:LuaFnIsPetElfDefault(g_SelPetIndex, g_CurElfIndex - 1) == 1 then

		else
			
		end
	end
end

function Kunwu_JL_Levelup_CloseClicked()
	this:Hide()
end

function Kunwu_JL_Levelup_CanPutMore(lv, idx)
	local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(lv)
	if need_qual < 1 or need_qual > 6 then
		return 0
	end
	
	local put_count = 0
	local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(lv)
	local real_need_count = need_count
	for i = 1, 3 do
		if i <= need_count then
			if g_Elf_BagIndex[i] ~= -1 and i ~= idx then
				if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) == 1 then
					real_need_count = real_need_count - 1
				end
			end
		end
	end
	
	for i = 1, 3 do
		if i <= need_count then
			if g_Elf_BagIndex[i] ~= -1 and i ~= idx then
				local item_table_index = PlayerPackage:GetItemTableIndex(g_Elf_BagIndex[i])
				if item_table_index == g_ReplacedItem[need_qual] then
					local lay_num = PlayerPackage:GetBagItemNum(g_Elf_BagIndex[i])
					put_count = put_count + lay_num
				end
			end
		end
	end
	
	if put_count >= real_need_count then
		return 0
	else
		return 1
	end
end

--从背包拖拽到UI
function Kunwu_JL_Levelup_Item_OnItemDragedDropFromBag(idx, iBagIndex)

	if g_SelPetIndex == -1 then
		PushDebugMessage("#{JLYC_241217_156}")
		return
	end
	
	if g_CurElfIndex == 0 then
	--	PushDebugMessage("#{JLYC_241217_77}")
		return
	end
	
	if Pet:LuaFnIsPetElfDefault(g_SelPetIndex, g_CurElfIndex - 1) == 1 then
		return
	end

	local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	if curLv == g_Elf_MaxLevel then
		return
	end
	
	local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(curLv)
	if need_qual < 1 or need_qual > 6 then
		return
	end
	
	local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(curLv)
	if idx > need_count then
		return	
	end
	
	if PlayerPackage:LuaFnIsPetElf(iBagIndex) ~= 1 then
		local item_table_index = PlayerPackage:GetItemTableIndex(iBagIndex)
		if Kunwu_JL_Levelup_IsReplacedItem(item_table_index) == 1 then
			if item_table_index ~= g_ReplacedItem[need_qual] then
				local replace_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(g_ReplacedItem[need_qual]))
				local strTemp = ScriptGlobal_Format("#{JLYC_241217_127}", replace_item_name)
				PushDebugMessage(strTemp)
				return
			end
			
			if Kunwu_JL_Levelup_CanPutMore(curLv, idx) == 0 then
				PushDebugMessage("#{JLYC_241217_189}")
				return
			end			
		else
			PushDebugMessage("#{JLYC_241217_61}")
			return
		end
	else
		if PlayerPackage:LuaFnIsPetElfIdentified(iBagIndex) ~= 1 then
			PushDebugMessage("#{JLYC_241217_53}")
			return
		end
		
		local pet_elf_level = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_qual = PlayerPackage:LuaFnGetPetElfItemQual(iBagIndex)
		local need_qual = Pet:LuaFnGetPetElfLevelNeedQual(pet_elf_level)
		
		local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_skill = PlayerPackage:LuaFnGetPetElfItemSkill(iBagIndex)
		
		local pet_elf_type = Pet:LuaFnGetPetElfType(g_SelPetIndex, g_CurElfIndex - 1)
		local elf_type = PlayerPackage:LuaFnGetPetElfItemType(iBagIndex)

		if elf_qual ~= need_qual then
			PushDebugMessage("#{JLYC_241217_123}")
			return
		end
		
		if elf_type ~= pet_elf_type then
			PushDebugMessage("#{JLYC_241217_124}")
			return
		end
		
		if elf_skill ~= pet_elf_skill then
			PushDebugMessage("#{JLYC_241217_125}")
			return
		end
	end

	--加锁
	if PlayerPackage:IsLock(iBagIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	if g_Elf_BagIndex[idx] ~= -1 then
		LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[idx], 0)
	end
	g_Elf_BagIndex[idx] = iBagIndex
	Kunwu_JL_Levelup_CacheProtectState()
	Kunwu_JL_Levelup_Update()

end

function Kunwu_JL_Levelup_Item_OnBagItemRClicked(iBagIndex)
	if g_SelPetIndex == -1 then
		return
	end
	
	if g_CurElfIndex == 0 then
		return
	end
	
	local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	if curLv == g_Elf_MaxLevel then
		return
	end

	local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(curLv)
	for i = 1, 3 do
		if i <= need_count then
			if g_Elf_BagIndex[i] == -1 then
				Kunwu_JL_Levelup_Item_OnItemDragedDropFromBag(i, iBagIndex)
				return
			end
		end
	end
	
	Kunwu_JL_Levelup_Item_OnItemDragedDropFromBag(1, iBagIndex)
end

function Kunwu_JL_Levelup_Item_OnItemDragedDropAway(idx)
	Kunwu_JL_Levelup_Elf_OnRBClicked(idx)
end

function Kunwu_JL_Levelup_Elf_OnRBClicked(idx)
	if idx >= 1 and idx <= 3 then
		if g_Elf_BagIndex[idx] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[idx], 0)
			g_Elf_BagIndex[idx] = -1
			Kunwu_JL_Levelup_CacheProtectState()
			Kunwu_JL_Levelup_Update()
		end
	end
end

function Kunwu_JL_Levelup_CleanUp()

end

function Kunwu_JL_Levelup_OnHidden()
	Kunwu_JL_Levelup_CleanUp()
	Kunwu_JL_Levelup_Skill1:SetActionItem(-1)
	for i = 1, 3 do
		g_Elf_ItemButton[i]:SetActionItem(-1)
	end
	m_ObjServerId = -1
	Pet:LuaFnShowPetListJL(0)
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
	g_CurElfIndex = 0
	
	for i = 1, 3 do
		if g_Elf_BagIndex[i] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
		end
		g_Elf_BagIndex[i] = -1
	end
	
	CloseWindow("Kunwu_JL_Fail", true)
	
	if Kunwu_JL_Levelup_Button:GetCheck() == 1 then
		g_YBPayConfirm = 1
	else
		g_YBPayConfirm = 0
	end
	
	Variable:SetVariable("PetElfLevelUpYBPayConfirm", tostring(g_YBPayConfirm), 0)
	
	Kunwu_JL_Levelup_CacheProtectState()
end

function Kunwu_JL_Levelup_OK_Clicked()
	CloseWindow("Kunwu_JL_Fail", true)
	if g_SelPetIndex == -1 then
		PushDebugMessage("#{JLYC_241217_156}")
		return
	end
	
	if g_CurElfIndex == 0 then
		PushDebugMessage("#{JLYC_241217_157}")
		return
	end
	
	if Pet:LuaFnIsPetElfDefault(g_SelPetIndex, g_CurElfIndex - 1) == 1 then
		PushDebugMessage("#{JLYC_241217_158}")
		return
	end
	
	local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	if curLv == g_Elf_MaxLevel then
		PushDebugMessage("#{JLYC_241217_159}")
		return
	end
	
	local put_count = 0
	local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(curLv)
	local real_need_count = need_count
	for i = 1, 3 do
		if i <= need_count then
			if g_Elf_BagIndex[i] ~= -1 and i ~= idx then
				if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) == 1 then
					put_count = put_count + 1
				end
			end
		end
	end
	
	for i = 1, 3 do
		if i <= need_count then
			if g_Elf_BagIndex[i] ~= -1 then
				if PlayerPackage:LuaFnIsPetElf(g_Elf_BagIndex[i]) ~= 1 then
					local lay_num = PlayerPackage:GetBagItemNum(g_Elf_BagIndex[i])
					put_count = put_count + lay_num
				end
			end
		end
	end
	
	if put_count < need_count then
		PushDebugMessage("#{JLYC_241217_81}")
		return
	end
	
	local YBPay_Confirm = 0
	if Kunwu_JL_Levelup_Button:GetCheck() == 1 then
		YBPay_Confirm = 1
	end
	
	local check_protect = 0
	local need_protect_item, need_protect_item_count = Pet:LuaFnGetPetElfProtectNeedItem(curLv)
	if tonumber(need_protect_item) ~= nil and tonumber(need_protect_item) > 0 then
		if Kunwu_JL_Levelup_Info_Item:GetCheck() == 1 then
			check_protect = 1
		end
	end
	
	local hid, lid = Pet:GetGUID(g_SelPetIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888830)
		Set_XSCRIPT_Function_Name("PetElfTP")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, hid)
		Set_XSCRIPT_Parameter(2, lid)
		Set_XSCRIPT_Parameter(3, g_CurElfIndex - 1)
		Set_XSCRIPT_Parameter(4, g_Elf_BagIndex[1])
		Set_XSCRIPT_Parameter(5, g_Elf_BagIndex[2])
		Set_XSCRIPT_Parameter(6, g_Elf_BagIndex[3])
		Set_XSCRIPT_Parameter(7, check_protect)
		Set_XSCRIPT_Parameter(8, YBPay_Confirm)
		Set_XSCRIPT_ParamCount(9)
	Send_XSCRIPT()

end

function Kunwu_JL_Levelup_HelpClicked()

end
--Care Obj
function Kunwu_JL_Levelup_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_JL_Levelup_Frame_On_ResetPos()
	if g_Kunwu_JL_Levelup_Frame_UnifiedPosition ~= nil then
		Kunwu_JL_Levelup_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Levelup_Frame_UnifiedPosition)
	end
end

function Kunwu_JL_Levelup_ModelTurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Levelup_PetModel:RotateBegin(-0.3)
	--stop
	else
		Kunwu_JL_Levelup_PetModel:RotateEnd()
	end
end

function Kunwu_JL_Levelup_ModelTurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_JL_Levelup_PetModel:RotateBegin(0.3)
	--stop
	else
		Kunwu_JL_Levelup_PetModel:RotateEnd()
	end
end

function Kunwu_JL_Levelup_Elf_Clicked(idx)

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

	for i = 1, 3 do
		if g_Elf_BagIndex[i] ~= -1 then
			LifeAbility:Lock_Packet_Item(g_Elf_BagIndex[i], 0)
		end
		g_Elf_BagIndex[i] = -1
	end

	Kunwu_JL_Levelup_CacheProtectState()
	Kunwu_JL_Levelup_Update()
end

function Kunwu_JL_Levelup_ActionButtonIndexToItemIndex(idx)
	if g_SelPetIndex == -1 then
		return 0
	end
	
	if g_CurElfIndex == 0 then
		return 0
	end
	
	local curLv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, g_CurElfIndex - 1)
	if curLv == g_Elf_MaxLevel then
		return 0
	end
	
	local need_count = Pet:LuaFnGetPetElfLevelTPNeedCount(curLv)

	local item_idx = 0
	
	if need_count == 1 then
		if idx == 2 then
			return 1
		end
	elseif need_count == 2 then
		if idx == 4 then
			return 1
		end
		
		if idx == 5 then
			return 2
		end
	elseif need_count == 3 then
		if idx == 1 or idx == 2 or idx == 3 then
			return idx
		end
	end

	return item_idx
end

function Kunwu_JL_Levelup_OpenPetList()
	Pet:LuaFnShowPetListJL(1)
end

function Kunwu_JL_Levelup_IsReplacedItem(item_table_index)
	for i = 1, 6 do
		if item_table_index == g_ReplacedItem[i] then
			return 1
		end
	end
	return 0
end

function Kunwu_JL_Levelup_OpenSkill()
	if g_SelPetIndex == -1 then
		return
	end
	
	if g_CurElfIndex == 0 then
		return
	end

	local pet_elf_skill = Pet:LuaFnGetPetElfSkill(g_SelPetIndex, g_CurElfIndex - 1)
	Pet:LuaFnOpenPetElfBook(pet_elf_skill, m_ObjServerId)

end

function Kunwu_JL_Levelup_GetSkillStage(lv)
	if lv < 1 then
		return 0
	elseif lv < 4 then
		return 1
	elseif lv < 7 then
		return 2
	elseif lv < 10 then
		return 3
	elseif lv < 13 then
		return 4
	elseif lv < 16 then
		return 5
	elseif lv < 20 then
		return 6
	elseif lv == 20 then
		return 7
	end
	return 0
end

function Kunwu_JL_Levelup_Protect()

end

function Kunwu_JL_Levelup_YBPayConfirm()
	
end

function Kunwu_JL_Levelup_CacheProtectState()
	if Kunwu_JL_Levelup_Info_Item:GetCheck() == 1 then
		g_CheckProtect = 1
	else
		g_CheckProtect = 0
	end
	Variable:SetVariable("PetElfLevelUpUseProtect", tostring(g_CheckProtect), 0)
end