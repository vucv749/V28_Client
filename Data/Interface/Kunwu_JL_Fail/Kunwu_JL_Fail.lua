--!!!reloadscript =Kunwu_JL_Fail

local g_nSelect_Index = -1

local g_Kunwu_JL_Fail_Frame_UnifiedPosition

local g_Ok = 0
local g_PetIndex = -1
local g_CurElfIndex = 0

function Kunwu_JL_Fail_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	

end

function Kunwu_JL_Fail_OnLoad()
	 g_Kunwu_JL_Fail_Frame_UnifiedPosition = Kunwu_JL_Fail_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_JL_Fail_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 88883010 then
		g_Ok = Get_XParam_INT(0)
		local selPetGuidH = Get_XParam_INT(1)
		local selPetGuidL = Get_XParam_INT(2)
		g_PetIndex = Pet:GetPetIndexByGUID(selPetGuidH, selPetGuidL)
		g_CurElfIndex = Get_XParam_INT(3)
		local pet_elf_level = Get_XParam_INT(4)
		local new_level = Get_XParam_INT(5)
		if g_Ok == 0 or g_Ok == 1 then
			this:Show()
			Kunwu_JL_Fail_UpdateFrame(pet_elf_level, new_level)
			this:Activate()
		end
		return
	end

	-- 游戏窗口尺寸发生了变化
	if event == "ADJEST_UI_POS" then
		Kunwu_JL_Fail_Frame_On_ResetPos()
		return
	end
	
	-- 游戏分辨率发生了变化
	if event == "VIEW_RESOLUTION_CHANGED" then
		Kunwu_JL_Fail_Frame_On_ResetPos()
		return
	end
end

-- 更新界面
function Kunwu_JL_Fail_UpdateFrame(pet_elf_level, new_level)
	local strTemp = ""
	if g_Ok == 0 then
		Kunwu_JL_Fail_ImageBK:SetProperty("Image", "set:Kunwu_JL_Identify image:Kunwu_JL_Fail")
	elseif g_Ok == 1 then
		Kunwu_JL_Fail_ImageBK:SetProperty("Image", "set:Kunwu_JL_Identify image:Kunwu_JL_Succeed")
	end
	
	Kunwu_JL_Fail_Icon1:SetActionItem(-1)
	Kunwu_JL_Fail_Icon2:SetActionItem(-1)
	Kunwu_JL_Fail_Name1:SetText("")
	Kunwu_JL_Fail_Name2:SetText("")
	Kunwu_JL_Fail_Level1:SetText("")
	Kunwu_JL_Fail_Level2:SetText("")
		
	if g_PetIndex ~= -1 and g_CurElfIndex ~= 0 then
		local max_elf_num = LuaFnGetPetElfMaxNum()
		local ActionElf = EnumAction(max_elf_num * g_PetIndex + g_CurElfIndex - 1, "my_pet_elf")
		Kunwu_JL_Fail_Icon1:SetActionItem(ActionElf:GetID())
		Kunwu_JL_Fail_Icon2:SetActionItem(ActionElf:GetID())
			
		local pet_elf_item = Pet:LuaFnGetPetElfItem(g_PetIndex, g_CurElfIndex - 1)
		local pet_elf_item_name = DataPool:LuaFnGetItemNameByTableIndex(tonumber(pet_elf_item))
		Kunwu_JL_Fail_Name1:SetText("#cfff263"..tostring(pet_elf_item_name))
		Kunwu_JL_Fail_Name2:SetText("#cfff263"..tostring(pet_elf_item_name))
		
		strTemp = ScriptGlobal_Format("#{JLYC_241217_185}", tostring(pet_elf_level))
		Kunwu_JL_Fail_Level1:SetText(strTemp)
		strTemp = ScriptGlobal_Format("#{JLYC_241217_185}", tostring(new_level))
		Kunwu_JL_Fail_Level2:SetText(strTemp)
	end
end

function Kunwu_JL_Fail_OnCloseClicked()
	this:Hide()
end

function Kunwu_JL_Fail_OnHidden()
	g_Ok = 0
	g_PetIndex = -1
	g_CurElfIndex = 0
	Kunwu_JL_Fail_Icon1:SetActionItem(-1)
	Kunwu_JL_Fail_Icon2:SetActionItem(-1)
	Kunwu_JL_Fail_Name1:SetText("")
	Kunwu_JL_Fail_Name2:SetText("")
	Kunwu_JL_Fail_Level1:SetText("")
	Kunwu_JL_Fail_Level2:SetText("")
end

-- 恢复界面的默认相对位置
function Kunwu_JL_Fail_Frame_On_ResetPos()
	Kunwu_JL_Fail_Frame:SetProperty("UnifiedPosition", g_Kunwu_JL_Fail_Frame_UnifiedPosition)
end
