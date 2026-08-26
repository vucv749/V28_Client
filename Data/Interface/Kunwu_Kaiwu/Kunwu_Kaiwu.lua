--!!!reloadscript =Kunwu_Kaiwu

local g_Kunwu_Kaiwu_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_SelPetIndex = -1
local g_NeedMoney = 200000

local g_Elf_Button = {}
local g_Elf_LockImg = {}

local g_NeedSavvy = {5, 5, 6, 6, 7}
local g_NeedLX = {3, 3, 5, 5, 7}

local g_KW_LevelText = {
	"#{KWCC_241219_73}",
	"#{KWCC_241219_74}",
	"#{KWCC_241219_75}",
	"#{KWCC_241219_76}",
	"#{KWCC_241219_77}",
}

function Kunwu_Kaiwu_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SELECT_PET_FOR_KW")
	this:RegisterEvent("UPDATE_PET_PAGE")
end

function Kunwu_Kaiwu_OnLoad()
	g_Kunwu_Kaiwu_Frame_UnifiedPosition = Kunwu_Kaiwu_Frame:GetProperty("UnifiedPosition")
	
	g_Elf_Button[1] = Kunwu_Kaiwu_ActionItem1
	g_Elf_Button[2] = Kunwu_Kaiwu_ActionItem2
	g_Elf_Button[3] = Kunwu_Kaiwu_ActionItem3
	g_Elf_Button[4] = Kunwu_Kaiwu_ActionItem4
	g_Elf_Button[5] = Kunwu_Kaiwu_ActionItem5
	
	g_Elf_LockImg[1] = Kunwu_Kaiwu_ActionItem1Lock
	g_Elf_LockImg[2] = Kunwu_Kaiwu_ActionItem2Lock
	g_Elf_LockImg[3] = Kunwu_Kaiwu_ActionItem3Lock
	g_Elf_LockImg[4] = Kunwu_Kaiwu_ActionItem4Lock
	g_Elf_LockImg[5] = Kunwu_Kaiwu_ActionItem5Lock
end

function Kunwu_Kaiwu_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883201 then
		if not this:IsVisible() then
			Kunwu_Kaiwu_CleanUp()
			this:Show()
			--Pet:LuaFnShowPetListKW(1)
			Kunwu_Kaiwu_Update()
			Kunwu_Kaiwu_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_Kaiwu_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_Kaiwu_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_Kaiwu_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "SELECT_PET_FOR_KW" and this:IsVisible() then
		Kunwu_Kaiwu_SelectPet(tonumber(arg0))
		return
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		Kunwu_Kaiwu_Update()
		return
	end
end

--选择珍兽
function Kunwu_Kaiwu_SelectPet(selidx)
	if selidx == -1 then
		return
	end
	
	--珍兽已被其它界面选中
	if Pet:GetPetLocation(selidx) ~= -1 then
		return
	end
	
	local active = Pet:LuaFnIsPetElfActived(selidx, 0)
	if active == 1 then
		PushDebugMessage("#{KWCC_241219_33}")
		return
	end

	local iSavvy = Pet:GetSavvy(selidx)
	if iSavvy < 5 then
	--	PushDebugMessage("悟性小于5")
	--	return
	end
	
	local iLingXing = Pet:GetLixing(selidx)
	if iLingXing < 3 then
	--	PushDebugMessage("灵性小于3")
	--	return
	end
	
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
	end
	
	g_SelPetIndex = selidx
	Pet:SetPetLocation(g_SelPetIndex, 20)
	Kunwu_Kaiwu_Update()

end

function Kunwu_Kaiwu_CheckPet()
	if Kunwu_Kaiwu_NeedRemovePet() == 1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
end

function Kunwu_Kaiwu_NeedRemovePet()
	if g_SelPetIndex == -1 then
		return 0
	end
	
	local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, 0)
	if active == 1 then
	--	return 1
	end
	
	return 0
end

function Kunwu_Kaiwu_Update()
	
	Kunwu_Kaiwu_CheckPet()
	
	local strTemp = ""
	Kunwu_Kaiwu_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_Kaiwu_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Kunwu_Kaiwu_FakeObject:SetFakeObject("")
	Kunwu_Kaiwu_ActionLocked:Hide()
	
	Kunwu_Kaiwu_Model_Wuxing:Hide()
	Kunwu_Kaiwu_Model_Lingxing:Hide()
	
	Kunwu_Kaiwu_Pet_Choose_Text:SetText("")

	if g_SelPetIndex ~= -1 then
		DataPool:LuaFnSetPetKaiWuPetModel(g_SelPetIndex)
		Kunwu_Kaiwu_FakeObject:SetFakeObject("Pet_KaiWu")
		
		local szPetName = Pet:GetPetList_Appoint(g_SelPetIndex)
		Kunwu_Kaiwu_Pet_Choose_Text:SetText(tostring(szPetName))
		
		local kw_level = 0
		for i = 1, 5 do
			local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, i - 1)
			if active == 1 then
				kw_level = kw_level + 1
			else
				break
			end
		end
		
		Kunwu_Kaiwu_ActionLocked:Show()

		if kw_level ~= 0 then
			Kunwu_Kaiwu_ActionLocked_Text:SetText(tostring(g_KW_LevelText[kw_level]))
			local max_elf_num = LuaFnGetPetElfMaxNum()
			for i = 1, 5 do
				g_Elf_Button[i]:SetActionItem(-1)
				local ActionElf = EnumAction(max_elf_num * g_SelPetIndex + i - 1, "my_pet_elf")
				g_Elf_Button[i]:SetActionItem(ActionElf:GetID())
				
				g_Elf_LockImg[i]:Show()
				local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, i - 1)
				if active == 1 then
					g_Elf_LockImg[i]:Hide()
				end
			end
		else
			local iSavvy = Pet:GetSavvy(g_SelPetIndex)
			local iLingXing = Pet:GetLixing(g_SelPetIndex)
			
			Kunwu_Kaiwu_Model_Wuxing:Show()
			Kunwu_Kaiwu_Model_Lingxing:Show()
			
			if iSavvy >= g_NeedSavvy[1] then
				Kunwu_Kaiwu_Model_Wuxing:SetText("#G"..tostring(iSavvy).."/"..tostring(g_NeedSavvy[1]))
			else
				Kunwu_Kaiwu_Model_Wuxing:SetText("#cFF0000"..tostring(iSavvy).."/"..tostring(g_NeedSavvy[1]))
			end

			if iLingXing >= g_NeedLX[1] then
				Kunwu_Kaiwu_Model_Lingxing:SetText("#G"..tostring(iLingXing).."/"..tostring(g_NeedLX[1]))
			else
				Kunwu_Kaiwu_Model_Lingxing:SetText("#cFF0000"..tostring(iLingXing).."/"..tostring(g_NeedLX[1]))
			end
			
			for i = 1, 5 do
				g_Elf_Button[i]:SetActionItem(-1)
				g_Elf_LockImg[i]:Show()
			end
			Kunwu_Kaiwu_ActionLocked_Text:SetText("#{KWCC_241219_23}")
			Kunwu_Kaiwu_DemandMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney))
		end
	end
end

function Kunwu_Kaiwu_CloseClicked()
	this:Hide()
end

function Kunwu_Kaiwu_CleanUp()
	Kunwu_Kaiwu_FakeObject:SetFakeObject("")
	Kunwu_Kaiwu_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu_SelfMoney:SetProperty("MoneyNumber", "0")
	for i = 1, 5 do
		g_Elf_Button[i]:SetActionItem(-1)
		g_Elf_LockImg[i]:Hide()
	end
	Kunwu_Kaiwu_Model_Wuxing:Hide()
	Kunwu_Kaiwu_Model_Lingxing:Hide()
end

function Kunwu_Kaiwu_OnHidden()
	Kunwu_Kaiwu_CleanUp()
	m_ObjServerId = -1
	Pet:ShowPetList(0)
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
	Pet:LuaFnShowPetListKW(0)
end

function Kunwu_Kaiwu_OK_Clicked()

	local my_level = Player:GetData("LEVEL")
	if my_level < 65 then
		PushDebugMessage("#{KWCC_241219_30}")
		return
	end
	
	if g_SelPetIndex == -1 then
	--	PushDebugMessage("#{JLYC_241217_35}")
		return
	end
	
	local hid, lid = Pet:GetGUID(g_SelPetIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888832)
		Set_XSCRIPT_Function_Name("DoKW_I")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, hid)
		Set_XSCRIPT_Parameter(2, lid)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Kunwu_Kaiwu_HelpClicked()

end
--Care Obj
function Kunwu_Kaiwu_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_Kaiwu_Frame_On_ResetPos()
	if g_Kunwu_Kaiwu_Frame_UnifiedPosition ~= nil then
		Kunwu_Kaiwu_Frame:SetProperty("UnifiedPosition", g_Kunwu_Kaiwu_Frame_UnifiedPosition)
	end
end

function Kunwu_Kaiwu_Model_TurnLeft(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_Kaiwu_FakeObject:RotateBegin(-0.3)
	--stop
	else
		Kunwu_Kaiwu_FakeObject:RotateEnd()
	end
end

function Kunwu_Kaiwu_Model_TurnRight(start)
	--start
	if start == 1 and CEArg:GetValue("MouseButton")=="LeftButton" then
		Kunwu_Kaiwu_FakeObject:RotateBegin(0.3)
	--stop
	else
		Kunwu_Kaiwu_FakeObject:RotateEnd()
	end
end

function Kunwu_Kaiwu_Elf_Clicked(idx)

end

function Kunwu_Kaiwu_Reset()

end

function Kunwu_Kaiwu_ChoosePet_Clicked()
	Pet:LuaFnShowPetListKW(1)
end