--2025周年庆预热活动

-- 界面的默认相对位置
local g_PetLairPvpTime_Frame_UnifiedXPosition
local g_PetLairPvpTime_Frame_UnifiedYPosition

local g_PetLairPvpTime_Frame_Param1
local g_PetLairPvpTime_Frame_Param2
local g_PetLairPvpTime_StopWatch

function PetLairPvpTime_PreLoad()
	this:RegisterEvent("UI_COMMAND")

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	--离开场景，自动关闭
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent( "PLAYER_LEAVE_WORLD" )			-- 离开场景
	this:RegisterEvent("UPDATE_MAP",false)
	this:RegisterEvent("SCENE_TRANSED",false)
end

function PetLairPvpTime_OnLoad()
	-- 保存界面的默认相对位置
	g_PetLairPvpTime_Frame_UnifiedXPosition	= PetLairPvpTime_Frame : GetProperty("UnifiedXPosition");
	g_PetLairPvpTime_Frame_UnifiedYPosition	= PetLairPvpTime_Frame : GetProperty("UnifiedYPosition");
	
	g_PetLairPvpTime_Frame_Param1 = 0
	g_PetLairPvpTime_Frame_Param2 = 0

end

function PetLairPvpTime_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99974901 ) then
		local nFuncType = Get_XParam_INT(0)
		if nFuncType == 0 then
			this:Hide()
		elseif nFuncType == 1 then
			PetLairPvpTime_Frame_Update()
			this:Show()
		elseif nFuncType == 2 then
			if this:IsVisible() then			
				PetLairPvpTime_Frame_Update()		
			end
		elseif nFuncType == 3 then
			--为了绕一圈，相当于延时打开界面
			local nType = Get_XParam_INT(1)
			if nType == 2 then
				if IsWindowShow("PetLairPvpTime_Mini") then
				else
					if (not this:IsVisible()) then
						nType = 1
					end
				end
			end
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenUI2" )
				Set_XSCRIPT_ScriptID( 999749 )
				Set_XSCRIPT_Parameter(0, nType)
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()		
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 99974903 ) then
		Player:SendReliveMessage_OutGhost()
	-- 游戏窗口尺寸发生了变化	
	elseif (event == "ADJEST_UI_POS" ) then
		PetLairPvpTime_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetLairPvpTime_Frame_On_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED") then
		--this:Hide();
	elseif ( event == "SCENE_TRANSED") then 
        if (112 ~= GetSceneID()) then
			this:Hide()
			return
		end
	elseif ( event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif ( event == "UPDATE_MAP") then 
		-- if( this:IsVisible() ) then
			-- PetLairPvpTime_Frame_Update()
		-- end
		
	end
end

function PetLairPvpTime_Frame_Update()
	local nTeamNum = Get_XParam_INT(1)
	g_PetLairPvpTime_StopWatch = Get_XParam_INT(2)
	PetLairPvpTime_Text4:Show()
	PetLairPvpTime_Text4_TimeWatch:SetProperty("Timer", tostring(g_PetLairPvpTime_StopWatch))
	PetLairPvpTime_Text5:SetText(ScriptGlobal_Format("#{SXRC_250326_73}",Get_XParam_INT(3)))	
	PetLairPvpTime_Text2:SetText(ScriptGlobal_Format("#{SXRC_250326_33}", nTeamNum))
	PetLairPvpTime_Skill:SetActionItem(-1)
	local nSumSkill = GetActionNum("skill")
	local nSkillIndex = 1;
	for i=1, nSumSkill do
		theAction = EnumAction(i-1, "skill")
		if theAction:GetDefineID() == 5355 then
		--if theAction:GetName() == "复活" then
			PetLairPvpTime_Skill:SetActionItem(theAction:GetID());
			PetLairPvpTime_Skill:Enable()
			nSkillIndex = nSkillIndex+1;
			PetLairPvpTime_Skill_Mask:Hide()
			return
		end
	end
	PetLairPvpTime_Skill_Mask:Show()	
end
	
function PetLairPvpTime_SkillCliked()
	PetLairPvpTime_Skill:DoAction()
end

function PetLairPvpTime_OpenMini()
	PetLairPvpTime_Frame_Close()
	OpenWindow("PetLairPvpTime_Mini")
end

--================================================
-- 关闭界面
--================================================
function PetLairPvpTime_Frame_Close()
	this:Hide()
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function PetLairPvpTime_Frame_On_ResetPos()
	PetLairPvpTime_Frame : SetProperty("UnifiedXPosition", g_PetLairPvpTime_Frame_UnifiedXPosition);
	PetLairPvpTime_Frame : SetProperty("UnifiedYPosition", g_PetLairPvpTime_Frame_UnifiedYPosition);
end

function PetLairPvpTime_OnTimer()
	PetLairPvpTime_Text4:Hide()
	--this:Hide()
	return
end
