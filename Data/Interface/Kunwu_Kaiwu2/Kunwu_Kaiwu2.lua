--!!!reloadscript =Kunwu_Kaiwu2

local g_Kunwu_Kaiwu2_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_SelPetIndex = -1

local g_NeedMoney = {200000, 300000, 400000, 600000, 800000}
local g_NeedSumLevel = {0, 3, 7, 12, 18}
local g_NeedSavvy = {5, 5, 6, 6, 7}
local g_NeedLX = {3, 3, 5, 5, 7}

local g_KW_LevelText = {
	"#{KWCC_241219_98}",
	"#{KWCC_241219_100}",
	"#{KWCC_241219_102}",
	"#{KWCC_241219_104}",
	"#{KWCC_241219_106}",
}

local g_KW_LevelInfo = {
	"#{KWCC_241219_99}",
	"#{KWCC_241219_101}",
	"#{KWCC_241219_103}",
	"#{KWCC_241219_105}",
	"#{KWCC_241219_107}",
}

function Kunwu_Kaiwu2_PreLoad()
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

function Kunwu_Kaiwu2_OnLoad()
	g_Kunwu_Kaiwu2_Frame_UnifiedPosition = Kunwu_Kaiwu2_Frame:GetProperty("UnifiedPosition")
end

function Kunwu_Kaiwu2_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883202 then
		if not this:IsVisible() then
			Kunwu_Kaiwu2_CleanUp()
			this:Show()
			Kunwu_Kaiwu2_Update()
			Kunwu_Kaiwu2_BeginCareObj(Get_XParam_INT(0))
		end
		return
	end

	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_Kaiwu2_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
	
	if event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		if this:IsVisible() then
			Kunwu_Kaiwu2_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
			Kunwu_Kaiwu2_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
		end
		return
	end
	
	if event == "SELECT_PET_FOR_KW" and this:IsVisible() then
		Kunwu_Kaiwu2_SelectPet(tonumber(arg0))
		return
	end
	
	if event == "UPDATE_PET_PAGE" and this:IsVisible() then
		Kunwu_Kaiwu2_Update()
		return
	end
end

function Kunwu_Kaiwu2_CheckPet()
	if Kunwu_Kaiwu2_NeedRemovePet() == 1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
end

function Kunwu_Kaiwu2_NeedRemovePet()
	if g_SelPetIndex == -1 then
		return 0
	end
	
	local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, 0)
	if active ~= 1 then
		return 1
	end
	
	active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, 4)
	if active == 1 then
	--	return 1
	end
	
	return 0
end

--选择珍兽
function Kunwu_Kaiwu2_SelectPet(selidx)
	if selidx == -1 then
		return
	end
	
	--珍兽已被其它界面选中
	if Pet:GetPetLocation(selidx) ~= -1 then
		return
	end

	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
	end
	
	local active = Pet:LuaFnIsPetElfActived(selidx, 0)
	if active ~= 1 then
		PushDebugMessage("#{KWCC_241219_39}")
		return
	end
	
	active = Pet:LuaFnIsPetElfActived(selidx, 4)
	if active == 1 then
		PushDebugMessage("#{KWCC_241219_40}")
		return
	end

	g_SelPetIndex = selidx
	Pet:SetPetLocation(g_SelPetIndex, 21)
	Kunwu_Kaiwu2_Update()
end

function Kunwu_Kaiwu2_Update()
	
	Kunwu_Kaiwu2_CheckPet()
	
	local strTemp = ""
	
	Kunwu_Kaiwu2_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu2_SelfJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"))
	Kunwu_Kaiwu2_SelfMoney:SetProperty("MoneyNumber", Player:GetData("MONEY"))
	
	Kunwu_Kaiwu2_Model_Wuxing:Hide()
	Kunwu_Kaiwu2_Model_Lingxing:Hide()
	Kunwu_Kaiwu2_KaiwuTJ:Hide()
	
	Kunwu_Kaiwu2_Pet_Choose_Text:SetText("")
	
	Kunwu_Kaiwu2_Update_TextLeft:SetText("")
	Kunwu_Kaiwu2_Update_TextRight:SetText("")
	Kunwu_Kaiwu2_UpdateInfo_TextLeft:SetText("")
	Kunwu_Kaiwu2_UpdateInfo_TextRight:SetText("")
	
	if g_SelPetIndex ~= -1 then
		local szPetName = Pet:GetPetList_Appoint(g_SelPetIndex)
		Kunwu_Kaiwu2_Pet_Choose_Text:SetText(tostring(szPetName))

		local kw_level = 0
		for i = 1, 5 do
			local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, i - 1)
			if active ~= 1 then
				break
			else
				kw_level = kw_level + 1
			end
		end
		
		if kw_level >= 1 and kw_level < 5 then
			Kunwu_Kaiwu2_Update_TextLeft:SetText(g_KW_LevelText[kw_level])
			Kunwu_Kaiwu2_UpdateInfo_TextLeft:SetText(g_KW_LevelInfo[kw_level])
			Kunwu_Kaiwu2_Update_TextRight:SetText(g_KW_LevelText[kw_level + 1])
			Kunwu_Kaiwu2_UpdateInfo_TextRight:SetText(g_KW_LevelInfo[kw_level + 1])

			Kunwu_Kaiwu2_Model_Wuxing:Show()
			Kunwu_Kaiwu2_Model_Lingxing:Show()
			Kunwu_Kaiwu2_KaiwuTJ:Show()
		
			local iSavvy = Pet:GetSavvy(g_SelPetIndex)
			local iLingXing = Pet:GetLixing(g_SelPetIndex)
		
			if iSavvy >= g_NeedSavvy[kw_level + 1] then
				Kunwu_Kaiwu2_Model_Wuxing:SetText("#G"..tostring(iSavvy).."/"..tostring(g_NeedSavvy[kw_level + 1]))
			else
				Kunwu_Kaiwu2_Model_Wuxing:SetText("#cFF0000"..tostring(iSavvy).."/"..tostring(g_NeedSavvy[kw_level + 1]))
			end

			if iLingXing >= g_NeedLX[kw_level + 1] then
				Kunwu_Kaiwu2_Model_Lingxing:SetText("#G"..tostring(iLingXing).."/"..tostring(g_NeedLX[kw_level + 1]))
			else
				Kunwu_Kaiwu2_Model_Lingxing:SetText("#cFF0000"..tostring(iLingXing).."/"..tostring(g_NeedLX[kw_level + 1]))
			end
		
			local level_sum = 0
			for i = 1, 5 do
				local active = Pet:LuaFnIsPetElfActived(g_SelPetIndex, i - 1)
				if active == 1 then
					if Pet:LuaFnIsPetElfDefault(g_SelPetIndex, i - 1) ~= 1 then
						local lv = Pet:LuaFnGetPetElfLevel(g_SelPetIndex, i - 1)
						level_sum = level_sum + lv
					end
				end
			end
		
			if level_sum >= g_NeedSumLevel[kw_level + 1] then
				Kunwu_Kaiwu2_KaiwuTJ:SetText("#G"..tostring(level_sum).."/"..tostring(g_NeedSumLevel[kw_level + 1]))
			else
				Kunwu_Kaiwu2_KaiwuTJ:SetText("#cFF0000"..tostring(level_sum).."/"..tostring(g_NeedSumLevel[kw_level + 1]))
			end

			Kunwu_Kaiwu2_DemandMoney:SetProperty("MoneyNumber", tostring(g_NeedMoney[kw_level + 1]))
		elseif kw_level == 5 then
			Kunwu_Kaiwu2_Update_TextLeft:SetText(g_KW_LevelText[kw_level])
			Kunwu_Kaiwu2_UpdateInfo_TextLeft:SetText(g_KW_LevelInfo[kw_level])
			Kunwu_Kaiwu2_Update_TextRight:SetText("#{KWCC_241219_108}")
			Kunwu_Kaiwu2_UpdateInfo_TextRight:SetText("#{KWCC_241219_109}")
		else

		end
	end
end

function Kunwu_Kaiwu2_CloseClicked()
	this:Hide()
end

function Kunwu_Kaiwu2_CleanUp()

	Kunwu_Kaiwu2_DemandMoney:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu2_SelfJiaozi:SetProperty("MoneyNumber", "0")
	Kunwu_Kaiwu2_SelfMoney:SetProperty("MoneyNumber", "0")

	Kunwu_Kaiwu2_Model_Wuxing:Hide()
	Kunwu_Kaiwu2_Model_Lingxing:Hide()
	Kunwu_Kaiwu2_KaiwuTJ:Hide()
end

function Kunwu_Kaiwu2_OnHidden()
	Kunwu_Kaiwu2_CleanUp()
	m_ObjServerId = -1
	Pet:ShowPetList(0)
	if g_SelPetIndex ~= -1 then
		Pet:SetPetLocation(g_SelPetIndex, -1)
		g_SelPetIndex = -1
	end
	Pet:LuaFnShowPetListKW(0)
end

function Kunwu_Kaiwu2_OK_Clicked(flag)

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
		Set_XSCRIPT_Function_Name("DoKW_II")
		Set_XSCRIPT_Parameter(0, m_ObjServerId)
		Set_XSCRIPT_Parameter(1, hid)
		Set_XSCRIPT_Parameter(2, lid)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function Kunwu_Kaiwu2_HelpClicked()

end
--Care Obj
function Kunwu_Kaiwu2_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function Kunwu_Kaiwu2_Frame_On_ResetPos()
	if g_Kunwu_Kaiwu2_Frame_UnifiedPosition ~= nil then
		Kunwu_Kaiwu2_Frame:SetProperty("UnifiedPosition", g_Kunwu_Kaiwu2_Frame_UnifiedPosition)
	end
end


function Kunwu_Kaiwu2_Elf_Clicked(idx)

end

function Kunwu_Kaiwu2_Reset()

end

function Kunwu_Kaiwu2_ChoosePet_Clicked()
	Pet:LuaFnShowPetListKW(1)
end