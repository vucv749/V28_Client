--!!!reloadscript =PetSoul
local g_PetSoul_Frame_UnifiedXPosition
local g_PetSoul_Frame_UnifiedYPosition
local g_PetIndex = -1
local g_bSwitchModelBusy = 0

local g_PetType = -1			--0.自己的珍兽 1.目标的珍兽 2.场景中珍兽
local g_bInit = 0
local g_MaxCategoryNum = 0
local g_CategoryList = {}
local g_MaxExtensionNum = 6
local g_UnfoldExtension = 0
local g_RealExtensionCount = 0

function PetSoul_PreLoad()

	this:RegisterEvent("SHOW_PETSOUL_INFO")
	this:RegisterEvent("UPDATE_PET_PAGE")

	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("UPDATE_OTHERPET_PAGE")
	this:RegisterEvent("CLOSE_PETSOUL_INFO")
	this:RegisterEvent("SHOW_CONTEXT_SEL_PET")
end

function PetSoul_OnLoad()
	g_PetSoul_Frame_UnifiedXPosition = PetSoul_Frame:GetProperty("UnifiedXPosition")
	g_PetSoul_Frame_UnifiedYPosition = PetSoul_Frame:GetProperty("UnifiedYPosition")
end

function PetSoul_OnEvent(event)

	if event == "SHOW_PETSOUL_INFO" then
		g_PetType = tonumber(arg0)
		g_PetIndex = tonumber(arg1)
		PetSoul_CleanUp()
		this:Show()
		PetSoul_Show()
	end
	
	if event == "CLOSE_PETSOUL_INFO" then		
		local iType = tonumber(arg0)
		if g_PetType == iType or iType < 0 then
			this:Hide()
		end
	end
	
    if event == "PLAYER_LEAVE_WORLD" then
		this:Hide()
		return
    end
    
    if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		PetSoul_Frame_On_ResetPos()
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		if g_PetType == 0 then
		PetSoul_Show()
		end
		return
	end
	
	if event == "UPDATE_OTHERPET_PAGE" and this:IsVisible() then
		if g_PetType == 1 then
			PetSoul_Show()
		end
		return
	end
	
	if event == "SHOW_CONTEXT_SEL_PET" and this:IsVisible() then
		if g_PetType == 2 then
			PetSoul_Show()
		end
		return
	end
	
	
end

function PetSoul_Frame_On_ResetPos()
	PetSoul_Frame:SetProperty("UnifiedXPosition", g_PetSoul_Frame_UnifiedXPosition)
	PetSoul_Frame:SetProperty("UnifiedYPosition", g_PetSoul_Frame_UnifiedYPosition)
end

function PetSoul_InitList()	
	if g_bInit == 0 then		
		g_MaxCategoryNum = 0
		for i = 1, g_MaxExtensionNum do
			local bar = PetSoul_Explain_Info:AddChild("PetSoul_Explain_InfoItem1")
			g_MaxCategoryNum = g_MaxCategoryNum + 1
			g_CategoryList[g_MaxCategoryNum] = bar
			
			bar:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText("Category")
			bar:SetEvent("MouseButtonDown", string.format("PetSoul_ExtensionClick(%d)", i))
			
			local sub_bar = PetSoul_Explain_Info:AddChild("PetSoul_Explain_InfoItem2")
			g_MaxCategoryNum = g_MaxCategoryNum + 1
			g_CategoryList[g_MaxCategoryNum] = sub_bar
			
			local max_width = sub_bar:GetProperty("AbsoluteWidth")
			sub_bar:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetProperty("MaxWidth", max_width)
			
			local height = sub_bar:GetSubItem("PetSoul_Explain_InfoItem2Text"):GetProperty("AbsoluteHeight")
			sub_bar:SetProperty("AbsoluteHeight", height)
		end
		g_bInit = 1	
	end
end

function PetSoul_Update_ExtensionList(extension_num)
	
	local category_index = 0

	for i = 1, g_MaxExtensionNum do		
		if i <= extension_num then
			category_index = category_index + 1
			g_CategoryList[category_index]:Show()
			
			if i == g_UnfoldExtension then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Image"):SetProperty("Image", "set:Button1 image:BtnUp_Normal")
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Image"):SetProperty("Image", "set:Button1 image:BtnDown_Normal")
			end
			
			category_index = category_index + 1
			if i == g_UnfoldExtension then				
				g_CategoryList[category_index]:Show()
			else
				g_CategoryList[category_index]:Hide()
			end		
		else
			category_index = category_index + 1
			g_CategoryList[category_index]:Hide()
			category_index = category_index + 1
			g_CategoryList[category_index]:Hide()		
		end
	end
end

function PetSoul_ExtensionClick(extension_index)
	
	if g_UnfoldExtension == extension_index then
		g_UnfoldExtension = 0
	else
		g_UnfoldExtension = extension_index
	end
	
	PetSoul_Update_ExtensionList(g_RealExtensionCount)
	PetSoul_Explain_Info:RefreshLayout()
end

function PetSoul_Show()

	PetSoul_InitList()

	if g_PetType == 0 then
		PetSoul_ShowMyPet()
	elseif g_PetType == 1 then
		PetSoul_ShowOtherPet()
	elseif g_PetType == 2 then
		PetSoul_ShowTargetPet()
	else
		PetSoul_CleanUp()
	end
end

function PetSoul_ShowMyPet()
	if g_PetIndex < 0 then
		PetSoul_CleanUp()
		return
	end
	
	if Pet:LuaFnIsPetEquipPetSoul(g_PetIndex) ~= 1 then
		PetSoul_CleanUp()
		return
	end
	
	local iLevel = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "LEVEL")
	PetSoul_LevelText:SetText(tostring(iLevel))
	
	local iBloodRank = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "BR")
	PetSoul_BloodStageText:SetText(tostring(iBloodRank + 1))
	
	local iConcentrate = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "BC")
	local iMaxConcentrate = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "MAXBC")	
	if iBloodRank == 5 then
		PetSoul_BloodNumText:SetText(tostring(iMaxConcentrate).."/"..tostring(iMaxConcentrate))
	else
		PetSoul_BloodNumText:SetText(tostring(iConcentrate).."/"..tostring(iMaxConcentrate))
	end
	
	local skillAction = Pet:LuaFnEnumPetSoulSkillActionOnPet(g_PetIndex)
	if skillAction ~= nil then
		PetSoul_SoulSkill:SetActionItem(skillAction:GetID())
		local strSkillName = Pet:LuaFnGetPetSoulSkillNameOnPet(g_PetIndex, 0)
		PetSoul_SoulSkill_Info1:SetText("#cfff263"..strSkillName)
		PetSoul_SoulSkill_Info2:SetText("#{SHXT_20211230_224}")
	end
	
	local szPetPossSkillName, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(g_PetIndex, 0)
	if szPetPossSkillIcon ~= "" and szPetPossSkillName ~= "" then
		PetSoul_InterGrowthSkill:SetProperty( "BackImage", szPetPossSkillIcon )
		PetSoul_InterGrowthSkill_Info1:SetText("#cfff263"..szPetPossSkillName)
		PetSoul_InterGrowthSkill_Info2:SetText("#{SHXT_20211230_225}")
	end
	
	local _, szStrAptitude = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "STR_APT")
	PetSoul_StrAptitude:SetText("+"..szStrAptitude.."%")
	
	local _, szSprAptitude = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "SPR_APT")
	PetSoul_SprAptitude:SetText("+"..szSprAptitude.."%")
	
	local _, szConAptitude = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "CON_APT")
	PetSoul_ConAptitude:SetText("+"..szConAptitude.."%")

	local _, szIntAptitude = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "INT_APT")
	PetSoul_IntAptitude:SetText("+"..szIntAptitude.."%")
	
	local _, szDexAptitude = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "DEX_APT")
	PetSoul_DexAptitude:SetText("+"..szDexAptitude.."%")
	
	local tempStr = "#{SHXT_20211230_223}#r"
	
	local iQual = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "QUAL")
	if iQual == 0 then
		g_RealExtensionCount = 4
	elseif iQual == 1 then
		g_RealExtensionCount = 5
	elseif iQual == 2 then
		g_RealExtensionCount = 6
	elseif iQual == 3 then
		g_RealExtensionCount = 6
	end
	
	local category_index = 0
	local strExtensionQual = ""
	for i = 0, g_RealExtensionCount - 1 do
		
		local iExtensionId, iExtensionValue, szShort, szFight, szPoss = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "EXTENSION", i)
		
		if tonumber(iExtensionId) ~= nil and tonumber(iExtensionValue) ~= nil then
			
			strExtensionQual = ""
			local iExtensionQual = Pet:LuaFnGetPetSoulExtensionQual(tonumber(iExtensionId), tonumber(iExtensionValue))
			if iExtensionQual == 0 then
				strExtensionQual = "#W"
			elseif iExtensionQual == 1 then
				strExtensionQual = "#G"
			elseif iExtensionQual == 2 then
				strExtensionQual = "#B"
			elseif iExtensionQual == 3 then
				strExtensionQual = "#cCC33CC"
			elseif iExtensionQual == 4 then
				strExtensionQual = "#cFF9900"
			elseif iExtensionQual == 5 then
				strExtensionQual = "#Y"
			end

			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText(strExtensionQual..tostring(szShort))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText("#c605C4F"..tostring(szShort))
			end
			
			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#cFFF263"..tostring(szFight).."#r#cFFF263"..tostring(szPoss))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#c605C4F"..tostring(szFight).."#r#c605C4F"..tostring(szPoss))
			end
			
			local height = g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):GetProperty("AbsoluteHeight")
			g_CategoryList[category_index]:SetProperty("AbsoluteHeight", height)
		end
	end
	
	PetSoul_Update_ExtensionList(g_RealExtensionCount)
	PetSoul_Explain_Info:RefreshLayout()
	
	if iQual ~= 0 then
	
	local iModel = Pet:LuaFnGetPetSoulDataOnPet(g_PetIndex, "MODEL")
	
	PetSoul_FakeObject:SetFakeObject("")
	DataPool:LuaFnSetPetSoulAvatarModel(iModel)
	PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	else
		PetSoul_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdatePetSoulAvatarFromPet(0, g_PetIndex)
		PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	end
end

function PetSoul_ShowOtherPet()
	if g_PetIndex < 0 then
		PetSoul_CleanUp()
		return
	end
	
	if Pet:LuaFnIsOtherPetEquipPetSoul(g_PetIndex) ~= 1 then
		PetSoul_CleanUp()
		return
	end
	
	local iLevel = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "LEVEL")
	PetSoul_LevelText:SetText(tostring(iLevel))
	
	local iBloodRank = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "BR")
	PetSoul_BloodStageText:SetText(tostring(iBloodRank + 1))
	
	local iConcentrate = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "BC")
	local iMaxConcentrate = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "MAXBC")	
	if iBloodRank == 5 then
		PetSoul_BloodNumText:SetText(tostring(iMaxConcentrate).."/"..tostring(iMaxConcentrate))
	else
		PetSoul_BloodNumText:SetText(tostring(iConcentrate).."/"..tostring(iMaxConcentrate))
	end
	
	local skillAction = Pet:LuaFnEnumOtherPetSoulSkillActionOnPet(g_PetIndex)
	if skillAction ~= nil then
		PetSoul_SoulSkill:SetActionItem(skillAction:GetID())
		local strSkillName = Pet:LuaFnGetPetSoulSkillNameOnPet(g_PetIndex, 1)
		PetSoul_SoulSkill_Info1:SetText("#cfff263"..strSkillName)
		PetSoul_SoulSkill_Info2:SetText("#{SHXT_20211230_224}")
	end
	
	local szPetPossSkillName, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(g_PetIndex, 1)
	if szPetPossSkillIcon ~= "" and szPetPossSkillName ~= "" then
		PetSoul_InterGrowthSkill:SetProperty( "BackImage", szPetPossSkillIcon )
		PetSoul_InterGrowthSkill_Info1:SetText("#cfff263"..szPetPossSkillName)
		PetSoul_InterGrowthSkill_Info2:SetText("#{SHXT_20211230_225}")
	end
	
	local _, szStrAptitude = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "STR_APT")
	PetSoul_StrAptitude:SetText("+"..szStrAptitude.."%")
	
	local _, szSprAptitude = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "SPR_APT")
	PetSoul_SprAptitude:SetText("+"..szSprAptitude.."%")
	
	local _, szConAptitude = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "CON_APT")
	PetSoul_ConAptitude:SetText("+"..szConAptitude.."%")

	local _, szIntAptitude = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "INT_APT")
	PetSoul_IntAptitude:SetText("+"..szIntAptitude.."%")
	
	local _, szDexAptitude = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "DEX_APT")
	PetSoul_DexAptitude:SetText("+"..szDexAptitude.."%")
	
	local tempStr = "#{SHXT_20211230_223}#r"
	
	local iQual = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "QUAL")
	if iQual == 0 then
		g_RealExtensionCount = 4
	elseif iQual == 1 then
		g_RealExtensionCount = 5
	elseif iQual == 2 then
		g_RealExtensionCount = 6
	elseif iQual == 3 then
		g_RealExtensionCount = 6
	end	
	
	local category_index = 0
	local strExtensionQual = ""
	for i = 0, g_RealExtensionCount - 1 do
		
		local iExtensionId, iExtensionValue, szShort, szFight, szPoss = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "EXTENSION", i)
		
		if tonumber(iExtensionId) ~= nil and tonumber(iExtensionValue) ~= nil then
			
			strExtensionQual = ""
			local iExtensionQual = Pet:LuaFnGetPetSoulExtensionQual(tonumber(iExtensionId), tonumber(iExtensionValue))
			if iExtensionQual == 0 then
				strExtensionQual = "#W"
			elseif iExtensionQual == 1 then
				strExtensionQual = "#G"
			elseif iExtensionQual == 2 then
				strExtensionQual = "#B"
			elseif iExtensionQual == 3 then
				strExtensionQual = "#cCC33CC"
			elseif iExtensionQual == 4 then
				strExtensionQual = "#cFF9900"
			elseif iExtensionQual == 5 then
				strExtensionQual = "#Y"
			end	

			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText(strExtensionQual..tostring(szShort))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText("#c605C4F"..tostring(szShort))
			end
			
			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#cFFF263"..tostring(szFight).."#r#cFFF263"..tostring(szPoss))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#c605C4F"..tostring(szFight).."#r#c605C4F"..tostring(szPoss))
			end
			
			local height = g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):GetProperty("AbsoluteHeight")
			g_CategoryList[category_index]:SetProperty("AbsoluteHeight", height)
		
		end
	end
	
	PetSoul_Update_ExtensionList(g_RealExtensionCount)
	PetSoul_Explain_Info:RefreshLayout()
	
	if iQual ~= 0 then
	
		local iModel = Pet:LuaFnGetPetSoulDataOnOtherPet(g_PetIndex, "MODEL")
	
		PetSoul_FakeObject:SetFakeObject("")
		DataPool:LuaFnSetPetSoulAvatarModel(iModel)
		PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	else
		PetSoul_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdatePetSoulAvatarFromPet(1, g_PetIndex)
		PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	end
end

function PetSoul_ShowTargetPet()

	if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
		PetSoul_CleanUp()
		return
	end
	
	local iLevel = TargetPet:LuaFnGetPetSoulDataOnPet("LEVEL")
	PetSoul_LevelText:SetText(tostring(iLevel))
	
	local iBloodRank = TargetPet:LuaFnGetPetSoulDataOnPet("BR")
	PetSoul_BloodStageText:SetText(tostring(iBloodRank + 1))
	
	local iConcentrate = TargetPet:LuaFnGetPetSoulDataOnPet("BC")
	local iMaxConcentrate = TargetPet:LuaFnGetPetSoulDataOnPet("MAXBC")	
	if iBloodRank == 5 then
		PetSoul_BloodNumText:SetText(tostring(iMaxConcentrate).."/"..tostring(iMaxConcentrate))
	else
		PetSoul_BloodNumText:SetText(tostring(iConcentrate).."/"..tostring(iMaxConcentrate))
	end
	
	local skillAction = TargetPet:LuaFnEnumPetSoulSkillActionOnPet()
	if skillAction ~= nil then
		PetSoul_SoulSkill:SetActionItem(skillAction:GetID())
		local strSkillName = Pet:LuaFnGetPetSoulSkillNameOnPet(g_PetIndex, 2)
		PetSoul_SoulSkill_Info1:SetText("#cfff263"..strSkillName)
		PetSoul_SoulSkill_Info2:SetText("#{SHXT_20211230_224}")
	end
	
	local szPetPossSkillName, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(-1, 2)
	if szPetPossSkillIcon ~= "" and szPetPossSkillName ~= "" then
		PetSoul_InterGrowthSkill:SetProperty( "BackImage", szPetPossSkillIcon )
		PetSoul_InterGrowthSkill_Info1:SetText("#cfff263"..szPetPossSkillName)
		PetSoul_InterGrowthSkill_Info2:SetText("#{SHXT_20211230_225}")
	end
	
	local _, szStrAptitude = TargetPet:LuaFnGetPetSoulDataOnPet("STR_APT")
	PetSoul_StrAptitude:SetText("+"..szStrAptitude.."%")
	
	local _, szSprAptitude = TargetPet:LuaFnGetPetSoulDataOnPet("SPR_APT")
	PetSoul_SprAptitude:SetText("+"..szSprAptitude.."%")
	
	local _, szConAptitude = TargetPet:LuaFnGetPetSoulDataOnPet("CON_APT")
	PetSoul_ConAptitude:SetText("+"..szConAptitude.."%")

	local _, szIntAptitude = TargetPet:LuaFnGetPetSoulDataOnPet("INT_APT")
	PetSoul_IntAptitude:SetText("+"..szIntAptitude.."%")
	
	local _, szDexAptitude = TargetPet:LuaFnGetPetSoulDataOnPet("DEX_APT")
	PetSoul_DexAptitude:SetText("+"..szDexAptitude.."%")
	
	local tempStr = "#{SHXT_20211230_223}#r"
	
	local iQual = TargetPet:LuaFnGetPetSoulDataOnPet("QUAL")
	if iQual == 0 then
		g_RealExtensionCount = 4
	elseif iQual == 1 then
		g_RealExtensionCount = 5
	elseif iQual == 2 then
		g_RealExtensionCount = 6
	elseif iQual == 3 then
		g_RealExtensionCount = 6
	end	
	
	local category_index = 0
	local strExtensionQual = ""
	for i = 0, g_RealExtensionCount - 1 do
		
		local iExtensionId, iExtensionValue, szShort, szFight, szPoss = TargetPet:LuaFnGetPetSoulDataOnPet("EXTENSION", i)
		
		if tonumber(iExtensionId) ~= nil and tonumber(iExtensionValue) ~= nil then
			
			strExtensionQual = ""
			local iExtensionQual = Pet:LuaFnGetPetSoulExtensionQual(tonumber(iExtensionId), tonumber(iExtensionValue))
			if iExtensionQual == 0 then
				strExtensionQual = "#W"
			elseif iExtensionQual == 1 then
				strExtensionQual = "#G"
			elseif iExtensionQual == 2 then
				strExtensionQual = "#B"
			elseif iExtensionQual == 3 then
				strExtensionQual = "#cCC33CC"
			elseif iExtensionQual == 4 then
				strExtensionQual = "#cFF9900"
			elseif iExtensionQual == 5 then
				strExtensionQual = "#Y"
			end

			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText(strExtensionQual..tostring(szShort))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem1_Text1"):SetText("#c605C4F"..tostring(szShort))
			end
			
			category_index = category_index + 1
			if i <= iBloodRank then
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#cFFF263"..tostring(szFight).."#r#cFFF263"..tostring(szPoss))
			else
				g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):SetText("#c605C4F"..tostring(szFight).."#r#c605C4F"..tostring(szPoss))
			end
			
			local height = g_CategoryList[category_index]:GetSubItem("PetSoul_Explain_InfoItem2Text"):GetProperty("AbsoluteHeight")
			g_CategoryList[category_index]:SetProperty("AbsoluteHeight", height)
		end
	end
	
	PetSoul_Update_ExtensionList(g_RealExtensionCount)
	PetSoul_Explain_Info:RefreshLayout()
	
	if iQual ~= 0 then
	
		local iModel = TargetPet:LuaFnGetPetSoulDataOnPet("MODEL")
	
		PetSoul_FakeObject:SetFakeObject("")
		DataPool:LuaFnSetPetSoulAvatarModel(iModel)
		PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	else
		PetSoul_FakeObject:SetFakeObject("")
		DataPool:LuaFnUpdatePetSoulAvatarFromPet(2, g_PetIndex)
		PetSoul_FakeObject:SetFakeObject("My_PetSoul")
	end
end

function PetSoul_CleanUp()
	PetSoul_FakeObject:SetFakeObject("")
	PetSoul_SoulSkill:SetActionItem(-1)
	PetSoul_InterGrowthSkill:SetProperty( "BackImage", "" )
	
	PetSoul_BloodStageText:SetText("")
	PetSoul_BloodNumText:SetText("")
	PetSoul_LevelText:SetText("")
	
	PetSoul_StrAptitude:SetText("")
	PetSoul_SprAptitude:SetText("")
	PetSoul_ConAptitude:SetText("")
	PetSoul_IntAptitude:SetText("")
	PetSoul_DexAptitude:SetText("")	
	
	g_RealExtensionCount = 0
--	PetSoul_Explain_Info:SetText("")

	PetSoul_SoulSkill_Info1:SetText("")
	PetSoul_SoulSkill_Info2:SetText("")
	
	PetSoul_InterGrowthSkill_Info1:SetText("")
	PetSoul_InterGrowthSkill_Info2:SetText("")
	
end

function PetSoul_OnHidden()
	PetSoul_CleanUp()
	g_PetType = -1
end

function PetSoul_OnCloseClicked()
    this:Hide()
end

function PetSoul_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		if start == 1 then
			PetSoul_FakeObject:RotateBegin(-0.3)
		else
			PetSoul_FakeObject:RotateEnd()
		end
	end
end

function PetSoul_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if mouse_button == "LeftButton" then
		if start == 1 then
			PetSoul_FakeObject:RotateBegin(0.3)
		else
			PetSoul_FakeObject:RotateEnd()
		end
	end
end

function PetSoul_Model_Preview()
	--PushDebugMessage("PetSoul_Model_Preview()")
	PushEvent("SHOW_PETSOUL_HANDBOOK",g_PetIndex)
end

function PetSoul_MouseEnter()
	
	local left, right, top, bottom = PetSoul_InterGrowthSkill:GetPixelRect()
	
	if g_PetType == 0 then	
		if Pet:LuaFnIsPetEquipPetSoul(g_PetIndex) ~= 1 then
			return
		end
		Pet:LuaFnShowPetSoulPossSkillInfo(g_PetIndex, 1, left, top, right, bottom)
	elseif g_PetType == 1 then	
		if Pet:LuaFnIsOtherPetEquipPetSoul(g_PetIndex) ~= 1 then
			return
		end
		Pet:LuaFnShowOtherPetSoulPossSkillInfo(g_PetIndex, 1, left, top, right, bottom)
	elseif g_PetType == 2 then	
		if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
			return
		end		
		TargetPet:LuaFnShowPetSoulPossSkillInfo(1, left, top, right, bottom)
	end
	
end

function PetSoul_MouseLeave()
	
	local left, right, top, bottom = PetSoul_InterGrowthSkill:GetPixelRect()
	
	if g_PetType == 0 then	
		Pet:LuaFnShowPetSoulPossSkillInfo(g_PetIndex, 0, left, top, right, bottom)
	elseif g_PetType == 1 then	
		Pet:LuaFnShowOtherPetSoulPossSkillInfo(g_PetIndex, 0, left, top, right, bottom)
	elseif g_PetType == 2 then	
		TargetPet:LuaFnShowPetSoulPossSkillInfo(0, left, top, right, bottom)
	end
	
end

function PetSoul_FightSkill_Clicked()
	
	if g_PetType == 0 then		
		if Pet:LuaFnIsPetSoulSkillPassiveOnPet(g_PetIndex) ~= 1 then
			PushDebugMessage("#{SHXT_20211230_21}")
		end
	end
	
end
