--染色图鉴
local g_PlanCount = 0
local g_Plan = 0
local g_CurSelExteriorID = 0
local g_HunJingText = {
	"1-2层",
	"3-5层",
	"6层",
}

-- 界面的默认相对位置
local g_PetSoul_RanSe_Jian_Frame_UnifiedXPosition
local g_PetSoul_RanSe_Jian_Frame_UnifiedYPosition

function PetSoul_RanSe_Jian_PreLoad()
	this:RegisterEvent("OPEN_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("CLOSE_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("CHANGE_PETSOUL_RANSE_JIAN")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function PetSoul_RanSe_Jian_OnLoad()

	-- 保存界面的默认相对位置
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
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		PetSoul_RanSe_Jian_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
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
	PetSoul_RanSe_Jian_List:AddItem("原始风格", 0)

	for i = 1, nPlanCount do
		local planstr = Exterior:LuaFnGetRanSePlanName(g_CurSelExteriorID, i)
		if planstr ~= nil then
			PetSoul_RanSe_Jian_List:AddItem(planstr, i)
		end
	end

	-- 设置使用哪个模型
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
-- 旋转人物头像模型（向左)
--
function PetSoul_RanSe_Jian_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			PetSoul_RanSe_Jian_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			PetSoul_RanSe_Jian_FakeObject:RotateEnd()
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function PetSoul_RanSe_Jian_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			PetSoul_RanSe_Jian_FakeObject:RotateBegin(0.3)
		--向右旋转结束
		else
			PetSoul_RanSe_Jian_FakeObject:RotateEnd()
		end
	end
end

--================================================
-- 恢复界面的默认相对位置
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
	PetSoul_RanSe_Jian_SearchMode:ComboBoxAddItem("魂境预览", 0)
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
