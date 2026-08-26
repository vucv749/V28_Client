--È¾É«Í¼¼ø
local g_PlanCount = 0
local g_Plan = 0
local g_CurSelExteriorID = 0
local g_HunJingText = {
	"1-2T¢ng",
	"3-5T¢ng",
	"6T¢ng",
}

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_PetSoul_RanSe_Jian_Frame_UnifiedXPosition
local g_PetSoul_RanSe_Jian_Frame_UnifiedYPosition

function PetSoul_RanSe_Jian_PreLoad()
	this:RegisterEvent("OPEN_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("CLOSE_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("CHANGE_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_RanSe_Jian_OnLoad()

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_PetSoul_RanSe_Jian_Frame_UnifiedXPosition	= PetSoul_RanSe_Jian_Frame : GetProperty("UnifiedXPosition")
	g_PetSoul_RanSe_Jian_Frame_UnifiedYPosition	= PetSoul_RanSe_Jian_Frame : GetProperty("UnifiedYPosition")

end

function PetSoul_RanSe_Jian_OnEvent(event)
	if ( event == "OPEN_PETSOUL_RANSE_JIAN" ) then
		g_CurSelExteriorID = tonumber(arg0)
		if g_CurSelExteriorID <= 0 then
			return
		end

		PetSoul_RanSe_Jian_Init()
		this:Show()
	elseif ( event == "CHANGE_PETSOUL_RANSE_JIAN" ) then
		if this:IsVisible() then
			g_CurSelExteriorID = tonumber(arg0)
			if g_CurSelExteriorID <= 0 then
				return
			end
			PetSoul_RanSe_Jian_Init()
		end

	elseif ( event == "CLOSE_PETSOUL_RANSE_JIAN" ) then
		this:Hide()
		PetSoul_RanSe_Jian_DataCleanUp()
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		PetSoul_RanSe_Jian_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üĞÂ±³°ü½çÃæÎ»ÖÃ
		PetSoul_RanSe_Jian_Frame_On_ResetPos()
	end

end

function PetSoul_RanSe_Jian_Init()

	

	Exterior:LuaFnInitCurrentRanSeJianSet(1)
	Exterior:LuaFnSetCurrentRanSeJianSetInfo("RANSE", g_CurSelExteriorID, 0)
	Exterior:LuaFnUpdatePetSoulRanSeJianData()

	PetSoul_RanSe_Jian_List : ClearListBox()

	local nPlanCount = Exterior:LuaFnGetRanSePlanCount(g_CurSelExteriorID)
	if nPlanCount == 0 then
		return 
	end

	g_PlanCount = nPlanCount

	PetSoul_RanSe_Jian_List:Show()
	PetSoul_RanSe_Jian_List:AddItem("Nguyên thüy phong cách", 0)

	for i = 1, nPlanCount do
		local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, i)
		if planstr ~= nil then
			PetSoul_RanSe_Jian_List:AddItem(planstr, i)
		end
	end

	-- ÉèÖÃÊ¹ÓÃÄÄ¸öÄ£ĞÍ
	PetSoul_RanSe_UpdateHunJing()
	PetSoul_RanSe_Jian_FakeObject : SetFakeObject("");
	PetSoul_RanSe_Jian_FakeObject : SetFakeObject("PetSoul_RanSe_Jian")
	PetSoul_RanSe_Jian_SetFakeCamera()

end

function PetSoul_RanSe_Jian_Onshow()

	Exterior:LuaFnUpdatePetSoulRanSeJianData()
	
	PetSoul_RanSe_Jian_SetFakeCamera()
end

function PetSoul_RanSe_Jian_SelectOneType(typeIdx)
	if(g_Plan == typeIdx or typeIdx > g_PlanCount) then
		return
	end
	
	g_Plan = typeIdx
	Exterior:LuaFnSetCurrentRanSeJianSetInfo("RANSE", g_CurSelExteriorID, g_Plan)
	PetSoul_RanSe_Jian_Onshow()
end

----------------------------------------------------------------------------------
--
-- Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨Ïò×ó)
--
function PetSoul_RanSe_Jian_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--Ïò×óĞı×ª¿ªÊ¼
		if(start == 1) then
			PetSoul_RanSe_Jian_FakeObject:RotateBegin(-0.3)
		--Ïò×óĞı×ª½áÊø
		else
			PetSoul_RanSe_Jian_FakeObject:RotateEnd()
		end
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ªÈËÎïÍ·ÏñÄ£ĞÍ£¨ÏòÓÒ)
--
function PetSoul_RanSe_Jian_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--ÏòÓÒĞı×ª¿ªÊ¼
		if(start == 1) then
			PetSoul_RanSe_Jian_FakeObject:RotateBegin(0.3)
		--ÏòÓÒĞı×ª½áÊø
		else
			PetSoul_RanSe_Jian_FakeObject:RotateEnd()
		end
	end
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function PetSoul_RanSe_Jian_Frame_On_ResetPos()

	PetSoul_RanSe_Jian_Frame : SetProperty("UnifiedXPosition", g_PetSoul_RanSe_Jian_Frame_UnifiedXPosition)
	PetSoul_RanSe_Jian_Frame : SetProperty("UnifiedYPosition", g_PetSoul_RanSe_Jian_Frame_UnifiedYPosition)

end

function PetSoul_RanSe_Jian_CloseOnclick()
	PetSoul_RanSe_Jian_OnHiden()
end

function PetSoul_RanSe_Jian_SetFakeCamera()
	FakeObj_SetCamera( "PetSoul_RanSe_Jian", 2,7)
end

function PetSoul_RanSe_Jian_OnHiden()
	PetSoul_RanSe_Jian_List:ClearListBox()

	PetSoul_RanSe_Jian_FakeObject:SetFakeObject("")

	PetSoul_RanSe_Jian_DataCleanUp()
	
	this:Hide()
end

function PetSoul_RanSe_Jian_DataCleanUp()
	g_PlanCount = 0
	g_Plan = 0
	g_CurSelExteriorID = 0
end

function PetSoul_RanSe_Jian_List_Click()
	local typeIdx =  PetSoul_RanSe_Jian_List : GetFirstSelectItem()

	PetSoul_RanSe_Jian_SelectOneType(typeIdx)
end

function PetSoul_RanSe_UpdateHunJing()
	PetSoul_RanSe_Jian_SearchMode:ResetList()  
	if(g_CurSelExteriorID <= 0) then
		PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem("", 0)
		PetSoul_RanSe_Jian_SearchMode:SetCurrentSelect(0)
		PetSoul_RanSe_Jian_SearchMode:Hide()
		return
	end

	PetSoul_RanSe_Jian_SearchMode:Show()
	PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem("H°n Cänh Dñ Lãm", 0)
	PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem(g_HunJingText[1], 1)
	PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem(g_HunJingText[2], 2)
	PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem(g_HunJingText[3], 3)

	PetSoul_RanSe_Jian_SearchMode:SetCurrentSelect(0)

end

function PetSoul_RanSe_Jian_HunJingChanged()
	
	local str, nIndex = PetSoul_RanSe_Jian_SearchMode:GetCurrentSelect()

	if nIndex < 1 then
		Exterior:LuaFnSetCurrentRanSeJianSetInfo("POSS", g_CurSelExteriorID, 0)
	else
		Exterior:LuaFnSetCurrentRanSeJianSetInfo("POSS", g_CurSelExteriorID, nIndex - 1)
	end

	PetSoul_RanSe_Jian_Onshow()
end
