--2025周年庆预热活动

-- 界面的默认相对位置
local g_PetLairPvpTime_Mini_Frame_UnifiedXPosition
local g_PetLairPvpTime_Mini_Frame_UnifiedYPosition

local g_PetLairPvpTime_Mini_Frame_Param1
local g_PetLairPvpTime_Mini_Frame_Param2

function PetLairPvpTime_Mini_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OPEN_WINDOW")
	this:RegisterEvent("UPDATE_MAP",false)
	this:RegisterEvent("SCENE_TRANSED",false)
end

function PetLairPvpTime_Mini_OnLoad()
	-- 保存界面的默认相对位置
	g_PetLairPvpTime_Mini_Frame_UnifiedXPosition	= PetLairPvpTime_Mini_Frame : GetProperty("UnifiedXPosition");
	g_PetLairPvpTime_Mini_Frame_UnifiedYPosition	= PetLairPvpTime_Mini_Frame : GetProperty("UnifiedYPosition");
	
	g_PetLairPvpTime_Mini_Frame_Param1 = 0
	g_PetLairPvpTime_Mini_Frame_Param2 = 0
	
end

function PetLairPvpTime_Mini_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99974901 ) then
		local nFuncType = Get_XParam_INT(0)
		if nFuncType == 0 then
			--this:Hide()
		elseif nFuncType == 1 then
			--PetLairPvpTime_Mini_Frame_Update()
			--this:Show()
		elseif nFuncType == 2 then
			--if this:IsVisible() then
			--	PetLairPvpTime_Mini_Frame_Update()		
			--end
		end
	elseif ( event == "OPEN_WINDOW" ) then
		if( arg0 == "PetLairPvpTime_Mini") then
			PetLairPvpTime_Mini_Frame_Update()
			this:Show()
		end		
	-- 游戏窗口尺寸发生了变化	
	elseif (event == "ADJEST_UI_POS" ) then
		PetLairPvpTime_Mini_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetLairPvpTime_Mini_Frame_On_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide();
	elseif ( event == "SCENE_TRANSED") then 
		this:Hide()
	elseif ( event == "UPDATE_MAP") then 
		-- if( this:IsVisible() ) then
			-- PetLairPvpTime_Mini_Frame_Update()
		-- end
		
	end
end

function PetLairPvpTime_Mini_Frame_Update()
	
end

function PetLairPvpTime_Mini_Open()
	PetLairPvpTime_Mini_Frame_Close()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenUI1" )
		Set_XSCRIPT_ScriptID( 999749 )
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--================================================
-- 关闭界面
--================================================
function PetLairPvpTime_Mini_Frame_Close()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function PetLairPvpTime_Mini_Frame_On_ResetPos()
	PetLairPvpTime_Mini_Frame : SetProperty("UnifiedXPosition", g_PetLairPvpTime_Mini_Frame_UnifiedXPosition);
	PetLairPvpTime_Mini_Frame : SetProperty("UnifiedYPosition", g_PetLairPvpTime_Mini_Frame_UnifiedYPosition);
end

