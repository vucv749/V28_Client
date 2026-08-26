--Kunwu_SWSC.lua

-- 界面的默认相对位置
local g_Kunwu_SWSC_UnifiedXPosition
local g_Kunwu_SWSC_UnifiedYPosition

local g_Kunwu_SWSC_Param1 --????
local g_Kunwu_SWSC_Param2 --???
local g_Kunwu_SWSC_Param3 --npc?objid

local objCared = -1
local MAX_OBJ_DISTANCE = 5

function Kunwu_SWSC_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	--离开场景，自动关睜
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("UPDATE_MAP")
	this:RegisterEvent("SCENE_TRANSED")
end

function Kunwu_SWSC_OnLoad()
	-- 保存界面的默认相对位置
	g_Kunwu_SWSC_UnifiedXPosition	= Kunwu_SWSC_Frame : GetProperty("UnifiedXPosition");
	g_Kunwu_SWSC_UnifiedYPosition	= Kunwu_SWSC_Frame : GetProperty("UnifiedYPosition");
	
	g_Kunwu_SWSC_Param1 = 0
	g_Kunwu_SWSC_Param2 = 0
	g_Kunwu_SWSC_Param3 = 0
end

function Kunwu_SWSC_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99963001 ) then
		
		local nFuncType = Get_XParam_INT(0)
		if nFuncType == 0 then
			Kunwu_SWSC_OnHidden()
		elseif nFuncType == 1 then
			g_Kunwu_SWSC_Param1 = Get_XParam_INT(1)
			g_Kunwu_SWSC_Param2 = Get_XParam_INT(2)
			g_Kunwu_SWSC_Param3 = Get_XParam_INT(3)
			--关心NPC
			objCared = DataPool:GetNPCIDByServerID(g_Kunwu_SWSC_Param3)
			this:CareObject(objCared, 1, "Kunwu_SWSC");				
			Kunwu_SWSC_Update()
			this:Show()
		elseif nFuncType == 2 then
			if( this:IsVisible() ) then
				g_Kunwu_SWSC_Param1 = Get_XParam_INT(1)
				g_Kunwu_SWSC_Param2 = Get_XParam_INT(2)	
				g_Kunwu_SWSC_Param3 = Get_XParam_INT(3)	
				--关心NPC
				objCared = DataPool:GetNPCIDByServerID(g_Kunwu_SWSC_Param3)
				this:CareObject(objCared, 1, "Kunwu_SWSC");	
				Kunwu_SWSC_Update()
			end
		end
						
	-- 游戏窗口尺寸发生了变化	
	elseif (event == "ADJEST_UI_POS" ) then
		Kunwu_SWSC_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_SWSC_On_ResetPos()
	
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide();
		
	elseif ( event == "SCENE_TRANSED") then 
		this:Hide()
	elseif ( event == "UPDATE_MAP") then 
		if( this:IsVisible() ) then
			Kunwu_SWSC_Update()
		end
    elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "Kunwu_SWSC");
		end			
	end
end

function Kunwu_SWSC_Update()
	Kunwu_SWSC_SWLevel_Tips:SetText(ScriptGlobal_Format("#{ZSSW_241211_06}", g_Kunwu_SWSC_Param1, g_Kunwu_SWSC_Param2))
end

--================================================
-- 关睜界面
--================================================
function Kunwu_SWSC_OnHidden()
	--取消关心
	this:CareObject(objCared, 0, "Kunwu_SWSC")
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Kunwu_SWSC_On_ResetPos()
	Kunwu_SWSC_Frame : SetProperty("UnifiedXPosition", g_Kunwu_SWSC_UnifiedXPosition);
	Kunwu_SWSC_Frame : SetProperty("UnifiedYPosition", g_Kunwu_SWSC_UnifiedYPosition);
end
