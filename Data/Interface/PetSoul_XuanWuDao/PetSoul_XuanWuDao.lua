
--  ﬁªÍ÷Æ¬“ ΩÁ√Ê
local g_PetSoul_XuanWuDao_SceneXuanwu = 112
local g_PetSoul_XuanWuDao_SceneXuanwuJing = 579

local g_PetSoul_XuanWuDao_UnifiedPosition;

local g_PetSoul_XuanWuDao_LingBossCount = 0 
local g_PetSoul_XuanWuDao_HuangBossCount = 0 
local g_PetSoul_XuanWuDao_ShenBossCount = 0 
local g_PetSoul_XuanWuDao_SceneType = 0
local g_PetSoul_XuanWuDao_LingDropCount = 0 
local g_PetSoul_XuanWuDao_HuangDropCount = 0 
local g_PetSoul_XuanWuDao_ShenDropCount = 0 

local g_PetSoul_XuanWuDao_LingDrop = 10
local g_PetSoul_XuanWuDao_HuangDrop = 6
local g_PetSoul_XuanWuDao_ShenDrop = 2

local g_PetSoul_XuanWuDao_NextTime = 0

local g_PetSoul_XuanWuDao_NextTimeStr = {
"#{XWDSSH_20220801_13}", 
"#{XWDSSH_20220801_14}", 
"#{XWDSSH_20220801_34}", 
"#{XWDSSH_20220801_15}", 

"#{XWDSSH_20220801_16}", 
"#{XWDSSH_20220801_17}",  
"#{XWDSSH_20220801_35}", 
"#{XWDSSH_20220801_15}",
}

function PetSoul_XuanWuDao_PreLoad()
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SHOW_PETSOULWAR_MINI");
	
	--this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_XuanWuDao_OnLoad()

	g_PetSoul_XuanWuDao_UnifiedPosition = PetSoul_XuanWuDao_Frame:GetProperty("UnifiedPosition");
		
end

function PetSoul_XuanWuDao_OnEvent(event)
	
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89334201) then
	
		g_PetSoul_XuanWuDao_SceneType = Get_XParam_INT(0)
		if g_PetSoul_XuanWuDao_SceneType <= 0 then
			this:Hide()
			return
		end
		
		if(IsWindowShow("PetSoul_XuanWuDao_Mini")) then
			return
		end
		
		g_PetSoul_XuanWuDao_LingBossCount = Get_XParam_INT(1)
		g_PetSoul_XuanWuDao_HuangBossCount = Get_XParam_INT(2)
		g_PetSoul_XuanWuDao_ShenBossCount = Get_XParam_INT(3)
		
		g_PetSoul_XuanWuDao_LingDropCount = Get_XParam_INT(4)
		g_PetSoul_XuanWuDao_HuangDropCount = Get_XParam_INT(5)
		g_PetSoul_XuanWuDao_ShenDropCount = Get_XParam_INT(6)
		
		g_PetSoul_XuanWuDao_StopWatch = Get_XParam_INT(7)
		
		g_PetSoul_XuanWuDao_NextTime = Get_XParam_INT(8)
		
		if g_PetSoul_XuanWuDao_SceneType == 1 then
		
			PetSoul_XuanWuDao_DragTitle:SetText("#{XWDSSH_20220801_31}")
			PetSoul_XuanWuDao_InfpText:SetText("#{XWDSSH_20220801_06}")
			PetSoul_XuanWuDao_Title2:SetText("#{XWDSSH_20220801_07}")
			
			PetSoul_XuanWuDao_ToDayTime1:SetText("#{XWDSSH_20220801_08}")
			local nHaveGet = g_PetSoul_XuanWuDao_HuangDrop - g_PetSoul_XuanWuDao_HuangDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_09}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao_HuangDrop then
				PetSoul_XuanWuDao_ToDay_Num1:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao_ToDay_Num1:SetText("#G"..str)
			end
			
			PetSoul_XuanWuDao_ToDayTime2:SetText("#{XWDSSH_20220801_10}")
			nHaveGet = g_PetSoul_XuanWuDao_LingDrop - g_PetSoul_XuanWuDao_LingDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_11}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao_LingDrop then
				PetSoul_XuanWuDao_ToDay_Num2:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao_ToDay_Num2:SetText("#G"..str)
			end
			
			if g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime] == nil then
				PetSoul_XuanWuDao_NextTime:SetText("#{XWDSSH_20220801_18}")
				PetSoul_XuanWuDao_NextTime2:Hide()
			else
				if g_PetSoul_XuanWuDao_NextTime == 4 or g_PetSoul_XuanWuDao_NextTime == 8 then
					PetSoul_XuanWuDao_NextTime:SetText(g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime])
					PetSoul_XuanWuDao_NextTime2:Hide()
				else
					PetSoul_XuanWuDao_NextTime:SetText("#{XWDSSH_20220801_12}")
					PetSoul_XuanWuDao_NextTime2:Show()
					PetSoul_XuanWuDao_NextTime2:SetText(g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime])
				end
			end
			
			PetSoul_XuanWuDao_Remain1:SetText("#{XWDSSH_20220801_19}")
			PetSoul_XuanWuDao_Remain1_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao_HuangBossCount))
			
			PetSoul_XuanWuDao_Remain2:SetText("#{XWDSSH_20220801_21}")
			PetSoul_XuanWuDao_Remain2_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao_LingBossCount))
			
			PetSoul_XuanWuDao_Remain_TimeWatch:SetProperty("Timer", tostring(g_PetSoul_XuanWuDao_StopWatch))
			
		elseif g_PetSoul_XuanWuDao_SceneType == 2 then
		
			PetSoul_XuanWuDao_DragTitle:SetText("#{XWDSSH_20220801_24}")
			PetSoul_XuanWuDao_InfpText:SetText("#{XWDSSH_20220801_25}")
			PetSoul_XuanWuDao_Title2:SetText("#{XWDSSH_20220801_26}")
			
			PetSoul_XuanWuDao_ToDayTime1:SetText("#{XWDSSH_20220801_27}")
			local nHaveGet = g_PetSoul_XuanWuDao_ShenDrop - g_PetSoul_XuanWuDao_ShenDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_28}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao_ShenDrop then
				PetSoul_XuanWuDao_ToDay_Num1:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao_ToDay_Num1:SetText("#G"..str)
			end
			
			PetSoul_XuanWuDao_ToDayTime2:SetText("#{XWDSSH_20220801_08}")
			nHaveGet = g_PetSoul_XuanWuDao_HuangDrop - g_PetSoul_XuanWuDao_HuangDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_29}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao_HuangDrop then
				PetSoul_XuanWuDao_ToDay_Num2:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao_ToDay_Num2:SetText("#G"..str)
			end
			
			if g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime] == nil then
				PetSoul_XuanWuDao_NextTime:SetText("#{XWDSSH_20220801_18}")
				PetSoul_XuanWuDao_NextTime2:Hide()
			else
				if g_PetSoul_XuanWuDao_NextTime == 4 or g_PetSoul_XuanWuDao_NextTime == 8 then
					PetSoul_XuanWuDao_NextTime:SetText(g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime])
					PetSoul_XuanWuDao_NextTime2:Hide()
				else
					PetSoul_XuanWuDao_NextTime:SetText("#{XWDSSH_20220801_12}")
					PetSoul_XuanWuDao_NextTime2:Show()
					PetSoul_XuanWuDao_NextTime2:SetText(g_PetSoul_XuanWuDao_NextTimeStr[g_PetSoul_XuanWuDao_NextTime])
				end
			end
			
			PetSoul_XuanWuDao_Remain1:SetText("#{XWDSSH_20220801_30}")
			PetSoul_XuanWuDao_Remain1_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao_ShenBossCount))
			
			PetSoul_XuanWuDao_Remain2:SetText("#{XWDSSH_20220801_19}")
			PetSoul_XuanWuDao_Remain2_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao_HuangBossCount))
			
			PetSoul_XuanWuDao_Remain_TimeWatch:SetProperty("Timer", tostring(g_PetSoul_XuanWuDao_StopWatch))
			
		else
			this:Hide()
		end
		
		this:Show()
	
	elseif (event == "ADJEST_UI_POS") then
		PetSoul_XuanWuDao_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_XuanWuDao_Frame_On_ResetPos()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		if( this:IsVisible() ) then
			this:Hide()
		end
		
	elseif (event == "SCENE_TRANSED") then
        if (g_PetSoul_XuanWuDao_SceneXuanwu ~= GetSceneID() and g_PetSoul_XuanWuDao_SceneXuanwuJing ~= GetSceneID()) then
			this:Hide()
			return
		end
		
		if arg0 == "petisland" or arg0 == "petislandHJ02" then 	--–˛Œ‰µ∫ ªÚ –˛Œ‰µ∫æµ
			
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnOpenXuanWuDaoUI" )
				Set_XSCRIPT_ScriptID( 893342 )
				Set_XSCRIPT_Parameter(0, 1); 
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
						
		else
			this:Hide()
		end
		
	elseif (event == "SHOW_PETSOULWAR_MINI") then
        if (g_PetSoul_XuanWuDao_SceneXuanwu ~= GetSceneID() and g_PetSoul_XuanWuDao_SceneXuanwuJing ~= GetSceneID()) then
			return
		end
		
		if arg0 ~= "0" then
			return
		end

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenXuanWuDaoUI" )
			Set_XSCRIPT_ScriptID( 893342 )
			Set_XSCRIPT_Parameter(0, 0); 
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()		
	end			

end

function PetSoul_XuanWuDao_Frame_On_ResetPos()

	PetSoul_XuanWuDao_Frame:SetProperty("UnifiedPosition", g_PetSoul_XuanWuDao_UnifiedPosition);
	
end

function PetSoul_XuanWuDao_OnTimer()
	this:Hide()
	return
end

function PetSoul_XuanWuDao_ClickClose()

	this:Hide()
	PushEvent("SHOW_PETSOULWAR_MINI", 1)
	
end

