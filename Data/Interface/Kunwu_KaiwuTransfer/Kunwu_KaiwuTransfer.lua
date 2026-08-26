--!!!reloadscript =Kunwu_KaiwuTransfer

local g_Kunwu_KaiwuTransfer_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_SelPetIndex_L = -1
local g_SelPetIndex_R = -1

local g_NeedMoney = {100000, 150000, 200000, 300000, 400000}

local g_Elf_Button_L = {}
local g_Elf_LockImg_L = {}
local g_Elf_Button_R = {}
local g_Elf_LockImg_R = {}

local g_KW_LevelText = {
	"#{KWCC_241219_73}",
	"#{KWCC_241219_74}",
	"#{KWCC_241219_75}",
	"#{KWCC_241219_76}",
	"#{KWCC_241219_77}",
}

function Kunwu_KaiwuTransfer_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("SELECT_PET_FOR_KWTS")
	this:RegisterEvent("UPDATE_PET_PAGE")
	this:RegisterEvent("KWTS_PETLIST_STAT")
end

function Kunwu_KaiwuTransfer_OnLoad()
	g_Kunwu_KaiwuTransfer_Frame_UnifiedPosition = Kunwu_KaiwuTransfer_Frame:GetProperty("UnifiedPosition")
	
	g_Elf_Button_L[1] = Kunwu_KaiwuTransfer_ActionLeftItem1
	g_Elf_Button_L[2] = Kunwu_KaiwuTransfer_ActionLeftItem2
	g_Elf_Button_L[3] = Kunwu_KaiwuTransfer_ActionLeftItem3
	g_Elf_Button_L[4] = Kunwu_KaiwuTransfer_ActionLeftItem4
	g_Elf_Button_L[5] = Kunwu_KaiwuTransfer_ActionLeftItem5
	
	g_Elf_LockImg_L[1] = Kunwu_KaiwuTransfer_ActionLeftItem1Lock
	g_Elf_LockImg_L[2] = Kunwu_KaiwuTransfer_ActionLeftItem2Lock
	g_Elf_LockImg_L[3] = Kunwu_KaiwuTransfer_ActionLeftItem3Lock
	g_Elf_LockImg_L[4] = Kunwu_KaiwuTransfer_ActionLeftItem4Lock
	g_Elf_LockImg_L[5] = Kunwu_KaiwuTransfer_ActionLeftItem5Lock
	
	g_Elf_Button_R[1] = Kunwu_KaiwuTransfer_ActionRightItem1
	g_Elf_Button_R[2] = Kunwu_KaiwuTransfer_ActionRightItem2
	g_Elf_Button_R[3] = Kunwu_KaiwuTransfer_ActionRightItem3
	g_Elf_Button_R[4] = Kunwu_KaiwuTransfer_ActionRightItem4
	g_Elf_Button_R[5] = Kunwu_KaiwuTransfer_ActionRightItem5
	
	g_Elf_LockImg_R[1] = Kunwu_KaiwuTransfer_ActionRightItem1Lock
	g_Elf_LockImg_R[2] = Kunwu_KaiwuTransfer_ActionRightItem2Lock
	g_Elf_LockImg_R[3] = Kunwu_KaiwuTransfer_ActionRightItem3Lock
	g_Elf_LockImg_R[4] = Kunwu_KaiwuTransfer_ActionRightItem4Lock
	g_Elf_LockImg_R[5] = Kunwu_KaiwuTransfer_ActionRightItem5Lock
end

function Kunwu_KaiwuTransfer_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883203 then
		if not this:IsVisible() then
			Kunwu_KaiwuTransfer_CleanUp()
			this:Show()
			--Pet:LuaFnShowPetListKWTS(1, 0)
			Kunwu_KaiwuTransfer_Update()
			Kunwu_KaiwuTransfer_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end	
	
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_KaiwuTransfer_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_KaiwuTransfer_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_KaiwuTransfer_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "SELECT_PET_FOR_KWTS" and this:IsVisible() then
		if tonumber(arg1) == 0 then
			Kunwu_KaiwuTransfer_SelectPetLeft(tonumber(arg0))
		else
			Kunwu_KaiwuTransfer_SelectPetRight(tonumber(arg0))
		end
		return
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		Kunwu_KaiwuTransfer_Update()
		return
	end
	
	if event == "KWTS_PETLIST_STAT" then
		if tonumber(arg0) == 0 then
			Kunwu_KaiwuTransfer_ActionLeft_Chooice:Enable()
			Kunwu_KaiwuTransfer_ActionRight_Chooice:Enable()
		elseif tonumber(arg0) == 1 then
			Kunwu_KaiwuTransfer_ActionLeft_Chooice:Disable()
			Kunwu_KaiwuTransfer_ActionRight_Chooice:Enable()
		elseif tonumber(arg0) == 2 then
			Kunwu_KaiwuTransfer_ActionLeft_Chooice:Enable()
			Kunwu_KaiwuTransfer_ActionRight_Chooice:Disable()
		end
		return
	end
end

--选择犱兽
function Kunwu_KaiwuTransfer_SelectPetLeft(selidx)
	if selidx == -1 then
		return
	end
	
	if selidx == g_SelPetIndex_L then
		Pet:LuaFnShowPetListKWTS(0)
		return
	end
	
	--犱兽已被其它界面选中
	if Pet:GetPetLocation(selidx) ~= -1 and Pet:GetPetLocation(selidx) ~= 23 then
		return
	end
	
	local active = Pet:LuaFnIsPetElfActived(selidx, 0)
	if active ~= 1 then
		PushDebugMessage("#{KWCC_241219_65}")
		return
	end
	
	if g_SelPetIndex_L ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex_L, -1)
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
	
	if g_SelPetIndex_R == selidx then
		Pet:SetPetLocation(g_SelPetIndex_R, -1)
		g_SelPetIndex_R = -1
	end
	
	g_SelPetIndex_L = selidx
	Pet:SetPetLocation(g_SelPetIndex_L, 22)
	
	Kunwu_KaiwuTransfer_Update()
	Pet:LuaFnShowPetListKWTS(0)
end

--选择犱兽
function Kunwu_KaiwuTransfer_SelectPetRight(selidx)
	if selidx == -1 then
		return
	end
	
	if selidx == g_SelPetIndex_R then
		Pet:LuaFnShowPetListKWTS(0)
		return
	end
	
	--犱兽已被其它界面选中
	if Pet:GetPetLocation(selidx) ~= -1 and Pet:GetPetLocation(selidx) ~= 22 then
		return
	end

	if g_SelPetIndex_R ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex_R, -1)
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
	
	if g_SelPetIndex_L == selidx then
		Pet:SetPetLocation(g_SelPetIndex_L, -1)
		g_SelPetIndex_L = -1
	end
	
	g_SelPetIndex_R = selidx
	Pet:SetPetLocation(g_SelPetIndex_R, 23)
	Kunwu_KaiwuTransfer_Update()
	Pet:LuaFnShowPetListKWTS(0)
end

function Kunwu_KaiwuTransfer_Update()

	local strTemp = ""
	Kunwu_KaiwuTransfer_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_KaiwuTransfer_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_KaiwuTransfer_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	Kunwu_KaiwuTransfer_FakeObjectLeft:SetFakeObject("")
	Kunwu_KaiwuTransfer_FakeObjectRight:SetFakeObject("")
	
	Kunwu_KaiwuTransfer_ActionLeft_Locked:SetText("#{KWCC_241219_116}")
	Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Wuxing:Hide()
	Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Lingxing:Hide()
	Kunwu_KaiwuTransfer_ActionRight_Locked:SetText("#{KWCC_241219_117}")
	Kunwu_KaiwuTransfer_FakeObjectRight_Model_Wuxing:Hide()
	Kunwu_KaiwuTransfer_FakeObjectRight_Model_Lingxing:Hide()
	
	for i = 1, 5 do
		g_Elf_Button_L[i]:SetActionItem(-1)
		g_Elf_LockImg_L[i]:Hide()
		g_Elf_Button_R[i]:SetActionItem(-1)
		g_Elf_LockImg_R[i]:Hide()
	end
	
	if g_SelPetIndex_L ~= -1 then
		local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_L, 0)
		if active ~= 1 then
		--	Pet:SetPetLocation(g_SelPetIndex_L, -1)
		--	g_SelPetIndex_L = -1
		end
	end
	
	local active_count_L = 0
	local active_count_R = 0
	if g_SelPetIndex_L ~= -1 then

		DataPool:LuaFnSetPetKaiWuPetModel(g_SelPetIndex_L)
		Kunwu_KaiwuTransfer_FakeObjectLeft:SetFakeObject("Pet_KaiWu")
		
		local iSavvy = Pet:GetSavvy(g_SelPetIndex_L)
		local iLingXing = Pet:GetLixing(g_SelPetIndex_L)
		
		Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Wuxing:Show()
		Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Lingxing:Show()
	
		strTemp = ScriptGlobal_Format("#{KWCC_241219_56}", tostring(iSavvy))
		Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Wuxing:SetText(strTemp)

		strTemp = ScriptGlobal_Format("#{KWCC_241219_57}", tostring(iLingXing))
		Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Lingxing:SetText(strTemp)
		
		local kw_level = 0
		for i = 1, 5 do
			local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_L, i - 1)
			if active == 1 then
				kw_level = kw_level + 1
			else
				break
			end
		end
		
		if kw_level ~= 0 then
			Kunwu_KaiwuTransfer_ActionLeft_Locked:SetText(tostring(g_KW_LevelText[kw_level]))
			local max_elf_num = LuaFnGetPetElfMaxNum()
			for i = 1, 5 do
				g_Elf_Button_L[i]:SetActionItem(-1)
				local ActionElf = EnumAction(max_elf_num * g_SelPetIndex_L + i - 1, "my_pet_elf")
				g_Elf_Button_L[i]:SetActionItem(ActionElf:GetID())
				
				g_Elf_LockImg_L[i]:Show()
				local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_L, i - 1)
				if active == 1 then
					g_Elf_LockImg_L[i]:Hide()
					active_count_L = active_count_L + 1
				end
			end
		else
			Kunwu_KaiwuTransfer_ActionLeft_Locked:SetText("#{KWCC_241219_23}")
			for i = 1, 5 do
				g_Elf_Button_L[i]:SetActionItem(-1)
				g_Elf_LockImg_L[i]:Show()
			end
		end
	end
	
	if g_SelPetIndex_R ~= -1 then
		DataPool:LuaFnSetPetKaiWuTargetPetModel(g_SelPetIndex_R)
		Kunwu_KaiwuTransfer_FakeObjectRight:SetFakeObject("Pet_KaiWu_Target")
		
		local iSavvy = Pet:GetSavvy(g_SelPetIndex_R)
		local iLingXing = Pet:GetLixing(g_SelPetIndex_R)
		
		Kunwu_KaiwuTransfer_FakeObjectRight_Model_Wuxing:Show()
		Kunwu_KaiwuTransfer_FakeObjectRight_Model_Lingxing:Show()
		
		strTemp = ScriptGlobal_Format("#{KWCC_241219_56}", tostring(iSavvy))
		Kunwu_KaiwuTransfer_FakeObjectRight_Model_Wuxing:SetText(strTemp)

		strTemp = ScriptGlobal_Format("#{KWCC_241219_57}", tostring(iLingXing))
		Kunwu_KaiwuTransfer_FakeObjectRight_Model_Lingxing:SetText(strTemp)
		
		local kw_level = 0
		for i = 1, 5 do
			local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_R, i - 1)
			if active == 1 then
				kw_level = kw_level + 1
			else
				break
			end
		end
		
		if kw_level ~= 0 then
			Kunwu_KaiwuTransfer_ActionRight_Locked:SetText(tostring(g_KW_LevelText[kw_level]))
			local max_elf_num = LuaFnGetPetElfMaxNum()
			for i = 1, 5 do
				g_Elf_Button_R[i]:SetActionItem(-1)
				local ActionElf = EnumAction(max_elf_num * g_SelPetIndex_R + i - 1, "my_pet_elf")
				g_Elf_Button_R[i]:SetActionItem(ActionElf:GetID())
				
				g_Elf_LockImg_R[i]:Show()
				local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_R, i - 1)
				if active == 1 then
					g_Elf_LockImg_R[i]:Hide()
					active_count_R = active_count_R + 1
				end
			end
		else
			Kunwu_KaiwuTransfer_ActionRight_Locked:SetText("#{KWCC_241219_23}")
			for i = 1, 5 do
				g_Elf_Button_R[i]:SetActionItem(-1)
				g_Elf_LockImg_R[i]:Show()
			end
		end
		
		if active_count_L > 0 then
			Kunwu_KaiwuTransfer_DemandMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney[active_count_L]))
		end
	end
end

function Kunwu_KaiwuTransfer_CloseClicked()
	this:Hide()
end

function Kunwu_KaiwuTransfer_CleanUp()
	Kunwu_KaiwuTransfer_FakeObjectLeft:SetFakeObject("")
	Kunwu_KaiwuTransfer_FakeObjectRight:SetFakeObject("")
	Kunwu_KaiwuTransfer_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_KaiwuTransfer_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Kunwu_KaiwuTransfer_SelfMoney:SetProperty("MoneyNumber", "0")
	for i = 1, 5 do
		g_Elf_Button_L[i]:SetActionItem(-1)
		g_Elf_Button_R[i]:SetActionItem(-1)
		g_Elf_LockImg_L[i]:Hide()
		g_Elf_LockImg_R[i]:Hide()
	end
	
	Kunwu_KaiwuTransfer_ActionLeft_Locked:SetText("")
	Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Wuxing:Hide()
	Kunwu_KaiwuTransfer_FakeObjectLeft_Model_Lingxing:Hide()
	Kunwu_KaiwuTransfer_ActionRight_Locked:SetText("")
	Kunwu_KaiwuTransfer_FakeObjectRight_Model_Wuxing:Hide()
	Kunwu_KaiwuTransfer_FakeObjectRight_Model_Lingxing:Hide()
end

function Kunwu_KaiwuTransfer_OnHidden()
	Kunwu_KaiwuTransfer_CleanUp()
	m_ObjServerId = -1

	if g_SelPetIndex_L ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex_L, -1)
		g_SelPetIndex_L = -1
	end
	
	if g_SelPetIndex_R ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex_R, -1)
		g_SelPetIndex_R = -1
	end
	Pet:LuaFnShowPetListKWTS(0)
end

function Kunwu_KaiwuTransfer_OK_Clicked()

	local my_level = Player:GetData("LEVEL")
	if my_level < 65 then
		PushDebugMessage("#{KWCC_241219_46}")
		return
	end
	
	if g_SelPetIndex_L == -1 or g_SelPetIndex_R == -1 then
		PushDebugMessage("#{KWCC_241219_47}")
		return
	end
	
	local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex_L, 0)
	if active ~= 1 then
		PushDebugMessage("#{KWCC_241219_118}")
		return
	end
	
	local hid_L, lid_L = Pet:GetGUID(g_SelPetIndex_L)
	local hid_R, lid_R = Pet:GetGUID(g_SelPetIndex_R)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(888832)
		Set_XSCRIPT_Function_Name("KaiWuTransfer")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, hid_L)
		Set_XSCRIPT_Parameter(2, lid_L)
		Set_XSCRIPT_Parameter(3, hid_R)
		Set_XSCRIPT_Parameter(4, lid_R)
		Set_XSCRIPT_Parameter(5, 1)			--??????
		Set_XSCRIPT_ParamCount(6)
	Send_XSCRIPT()
end

function Kunwu_KaiwuTransfer_HelpClicked()

end

--Care Obj
function Kunwu_KaiwuTransfer_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_KaiwuTransfer_Frame_On_ResetPos()
	if g_Kunwu_KaiwuTransfer_Frame_UnifiedPosition ~= nil then
		Kunwu_KaiwuTransfer_Frame:SetProperty("UnifiedPosition", g_Kunwu_KaiwuTransfer_Frame_UnifiedPosition)
	end
end

function Kunwu_KaiwuTransfer_OpenPetList(flag)
	if flag == 0 then
		Pet:LuaFnShowPetListKWTS(1, 0)
	else
		Pet:LuaFnShowPetListKWTS(1, 1)
	end
	
end
