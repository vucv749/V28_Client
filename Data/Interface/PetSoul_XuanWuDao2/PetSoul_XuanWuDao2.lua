--2025兽穴PVP活动

local g_PetSoul_XuanWuDao2_SceneXuanwu = 112
local g_PetSoul_XuanWuDao2_SceneXuanwuJing = 579

local g_PetSoul_XuanWuDao2_UnifiedPosition;

local g_PetSoul_XuanWuDao2_LingBossCount = 0 
local g_PetSoul_XuanWuDao2_HuangBossCount = 0 
local g_PetSoul_XuanWuDao2_ShenBossCount = 0 
local g_PetSoul_XuanWuDao2_SceneType = 0
local g_PetSoul_XuanWuDao2_LingDropCount = 0 
local g_PetSoul_XuanWuDao2_HuangDropCount = 0 
local g_PetSoul_XuanWuDao2_ShenDropCount = 0 

local g_PetSoul_XuanWuDao2_LingDrop = 10
local g_PetSoul_XuanWuDao2_HuangDrop = 6
local g_PetSoul_XuanWuDao2_ShenDrop = 2

local g_PetSoul_XuanWuDao2_NextTime = 0

local g_PetSoul_XuanWuDao2_NextTimeStr = {
"#{XWDSSH_20220801_13}", 
"#{XWDSSH_20220801_14}", 
"#{XWDSSH_20220801_34}", 
"#{XWDSSH_20220801_15}", 

"#{XWDSSH_20220801_16}", 
"#{XWDSSH_20220801_17}",  
"#{XWDSSH_20220801_35}", 
"#{XWDSSH_20220801_15}",
}

function PetSoul_XuanWuDao2_PreLoad()
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SHOW_PETSOULWAR2_MINI");
	
	--this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSoul_XuanWuDao2_OnLoad()

	g_PetSoul_XuanWuDao2_UnifiedPosition = PetSoul_XuanWuDao2_Frame:GetProperty("UnifiedPosition");
		
end

function PetSoul_XuanWuDao2_OnEvent(event)
	
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 89334201) then
	
		g_PetSoul_XuanWuDao2_SceneType = Get_XParam_INT(0)
		if g_PetSoul_XuanWuDao2_SceneType <= 0 then
			this:Hide()
			return
		end
		
		if(IsWindowShow("PetSoul_XuanWuDao2_Mini")) then
			return
		end
		
		g_PetSoul_XuanWuDao2_LingBossCount = Get_XParam_INT(1)
		g_PetSoul_XuanWuDao2_HuangBossCount = Get_XParam_INT(2)
		g_PetSoul_XuanWuDao2_ShenBossCount = Get_XParam_INT(3)
		
		g_PetSoul_XuanWuDao2_LingDropCount = Get_XParam_INT(4)
		g_PetSoul_XuanWuDao2_HuangDropCount = Get_XParam_INT(5)
		g_PetSoul_XuanWuDao2_ShenDropCount = Get_XParam_INT(6)
		
		g_PetSoul_XuanWuDao2_StopWatch = Get_XParam_INT(7)
		
		g_PetSoul_XuanWuDao2_NextTime = Get_XParam_INT(8)
		
		if g_PetSoul_XuanWuDao2_SceneType == 1 then
			--2025兽穴PVP活动
			if Get_XParam_INT(9) == 0 then
				this:Hide()
				return
			end
			
			PetSoul_XuanWuDao2_DragTitle:SetText("#{XWDSSH_20220801_31}")
			PetSoul_XuanWuDao2_InfpText:SetText("#{XWDSSH_20220801_06}")
			PetSoul_XuanWuDao2_Title2:SetText("#{XWDSSH_20220801_07}")
			
			PetSoul_XuanWuDao2_ToDayTime1:SetText("#{XWDSSH_20220801_08}")
			local nHaveGet = g_PetSoul_XuanWuDao2_HuangDrop - g_PetSoul_XuanWuDao2_HuangDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_09}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao2_HuangDrop then
				PetSoul_XuanWuDao2_ToDay_Num1:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao2_ToDay_Num1:SetText("#G"..str)
			end
			
			PetSoul_XuanWuDao2_ToDayTime2:SetText("#{XWDSSH_20220801_10}")
			nHaveGet = g_PetSoul_XuanWuDao2_LingDrop - g_PetSoul_XuanWuDao2_LingDropCount
			if nHaveGet < 0 then
				nHaveGet = 0
			end
			local str = ScriptGlobal_Format("#{XWDSSH_20220801_11}", nHaveGet)
			if nHaveGet >= g_PetSoul_XuanWuDao2_LingDrop then
				PetSoul_XuanWuDao2_ToDay_Num2:SetText("#cff0000"..str)
			else
				PetSoul_XuanWuDao2_ToDay_Num2:SetText("#G"..str)
			end
			
			if g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime] == nil then
				PetSoul_XuanWuDao2_NextTime:SetText("#{XWDSSH_20220801_18}")
				PetSoul_XuanWuDao2_NextTime2:Hide()
			else
				if g_PetSoul_XuanWuDao2_NextTime == 4 or g_PetSoul_XuanWuDao2_NextTime == 8 then
					PetSoul_XuanWuDao2_NextTime:SetText(g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime])
					PetSoul_XuanWuDao2_NextTime2:Hide()
				else
					PetSoul_XuanWuDao2_NextTime:SetText("#{XWDSSH_20220801_12}")
					PetSoul_XuanWuDao2_NextTime2:Show()
					PetSoul_XuanWuDao2_NextTime2:SetText(g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime])
				end
			end
			
			PetSoul_XuanWuDao2_Remain1:SetText("#{XWDSSH_20220801_19}")
			PetSoul_XuanWuDao2_Remain1_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao2_HuangBossCount))
			
			PetSoul_XuanWuDao2_Remain2:SetText("#{XWDSSH_20220801_21}")
			PetSoul_XuanWuDao2_Remain2_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao2_LingBossCount))
			
			PetSoul_XuanWuDao2_Remain_TimeWatch:SetProperty("Timer", tostring(g_PetSoul_XuanWuDao2_StopWatch))
			
			--2025兽穴PVP活动 新增数据1 今葼剩余神兽奖励次数
			PetSoul_XuanWuDao2_ToDayTime3:SetText("#{SXRC_250326_31}")
			local str = ""
			local num = Get_XParam_INT(10)
			if num<1 then
				str = ScriptGlobal_Format("#{SXRC_250326_38}", g_PetSoul_XuanWuDao2_ShenDrop-num)
			else
				str = ScriptGlobal_Format("#{SXRC_250326_37}", g_PetSoul_XuanWuDao2_ShenDrop-num)
			end
			PetSoul_XuanWuDao2_ToDay_Num3:SetText(str)
			
			--2025兽穴PVP活动 新增数据2 本波次裂隙进入次数
			-- PetSoul_XuanWuDao2_PetLairText:SetText("#{SXRC_250326_30}")
			-- num = Get_XParam_INT(11)
			-- if num<1 then
				-- str = ScriptGlobal_Format("#{SXRC_250326_36}", num)
			-- else
				-- str = ScriptGlobal_Format("#{SXRC_250326_56}", num)
			-- end		
			-- PetSoul_XuanWuDao2_PetLairNum:SetText(str)
			
			--2025兽穴PVP活动 新增数据3 场景内还没满员的入口数量
			PetSoul_XuanWuDao2_PetLairMenText:SetText("#{SXRC_250326_39}")
			num = Get_XParam_INT(12)
			if num<1 then
				str = ScriptGlobal_Format("#{SXRC_250326_57}", num)
			else
				str = ScriptGlobal_Format("#{SXRC_250326_40}", num)
			end				
			PetSoul_XuanWuDao2_PetLairMenNum:SetText(str)
			
		--2025兽穴PVP活动 注释掉
		-- elseif g_PetSoul_XuanWuDao2_SceneType == 2 then
		
			-- PetSoul_XuanWuDao2_DragTitle:SetText("#{XWDSSH_20220801_24}")
			-- PetSoul_XuanWuDao2_InfpText:SetText("#{XWDSSH_20220801_25}")
			-- PetSoul_XuanWuDao2_Title2:SetText("#{XWDSSH_20220801_26}")
			
			-- PetSoul_XuanWuDao2_ToDayTime1:SetText("#{XWDSSH_20220801_27}")
			-- local nHaveGet = g_PetSoul_XuanWuDao2_ShenDrop - g_PetSoul_XuanWuDao2_ShenDropCount
			-- if nHaveGet < 0 then
				-- nHaveGet = 0
			-- end
			-- local str = ScriptGlobal_Format("#{XWDSSH_20220801_28}", nHaveGet)
			-- if nHaveGet >= g_PetSoul_XuanWuDao2_ShenDrop then
				-- PetSoul_XuanWuDao2_ToDay_Num1:SetText("#cff0000"..str)
			-- else
				-- PetSoul_XuanWuDao2_ToDay_Num1:SetText("#G"..str)
			-- end
			
			-- PetSoul_XuanWuDao2_ToDayTime2:SetText("#{XWDSSH_20220801_08}")
			-- nHaveGet = g_PetSoul_XuanWuDao2_HuangDrop - g_PetSoul_XuanWuDao2_HuangDropCount
			-- if nHaveGet < 0 then
				-- nHaveGet = 0
			-- end
			-- local str = ScriptGlobal_Format("#{XWDSSH_20220801_29}", nHaveGet)
			-- if nHaveGet >= g_PetSoul_XuanWuDao2_HuangDrop then
				-- PetSoul_XuanWuDao2_ToDay_Num2:SetText("#cff0000"..str)
			-- else
				-- PetSoul_XuanWuDao2_ToDay_Num2:SetText("#G"..str)
			-- end
			
			-- if g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime] == nil then
				-- PetSoul_XuanWuDao2_NextTime:SetText("#{XWDSSH_20220801_18}")
				-- PetSoul_XuanWuDao2_NextTime2:Hide()
			-- else
				-- if g_PetSoul_XuanWuDao2_NextTime == 4 or g_PetSoul_XuanWuDao2_NextTime == 8 then
					-- PetSoul_XuanWuDao2_NextTime:SetText(g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime])
					-- PetSoul_XuanWuDao2_NextTime2:Hide()
				-- else
					-- PetSoul_XuanWuDao2_NextTime:SetText("#{XWDSSH_20220801_12}")
					-- PetSoul_XuanWuDao2_NextTime2:Show()
					-- PetSoul_XuanWuDao2_NextTime2:SetText(g_PetSoul_XuanWuDao2_NextTimeStr[g_PetSoul_XuanWuDao2_NextTime])
				-- end
			-- end
			
			-- PetSoul_XuanWuDao2_Remain1:SetText("#{XWDSSH_20220801_30}")
			-- PetSoul_XuanWuDao2_Remain1_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao2_ShenBossCount))
			
			-- PetSoul_XuanWuDao2_Remain2:SetText("#{XWDSSH_20220801_19}")
			-- PetSoul_XuanWuDao2_Remain2_Num:SetText(ScriptGlobal_Format("#{XWDSSH_20220801_20}", g_PetSoul_XuanWuDao2_HuangBossCount))
			
			-- PetSoul_XuanWuDao2_Remain_TimeWatch:SetProperty("Timer", tostring(g_PetSoul_XuanWuDao2_StopWatch))
			
		else
			this:Hide()
			return
		end
		
		this:Show()
	elseif (event  == "UI_COMMAND") and (tonumber(arg0) == 99974801) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnOpenXuanWuDaoUI" )
			Set_XSCRIPT_ScriptID( 893342 )
			Set_XSCRIPT_Parameter(0, 1); 
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()	
	elseif (event == "ADJEST_UI_POS") then
		PetSoul_XuanWuDao2_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSoul_XuanWuDao2_Frame_On_ResetPos()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		if( this:IsVisible() ) then
			this:Hide()
		end
		
	elseif (event == "SCENE_TRANSED") then
        if (g_PetSoul_XuanWuDao2_SceneXuanwu ~= GetSceneID()) then
			this:Hide()
			return
		end
		
		if arg0 == "petisland" then --???
			
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnOpenXuanWuDaoUI" )
				Set_XSCRIPT_ScriptID( 893342 )
				Set_XSCRIPT_Parameter(0, 1); 
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
						
		else
			this:Hide()
		end
		
	elseif (event == "SHOW_PETSOULWAR2_MINI") then
        if (g_PetSoul_XuanWuDao2_SceneXuanwu ~= GetSceneID()) then
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

function PetSoul_XuanWuDao2_Frame_On_ResetPos()

	PetSoul_XuanWuDao2_Frame:SetProperty("UnifiedPosition", g_PetSoul_XuanWuDao2_UnifiedPosition);
	
end

function PetSoul_XuanWuDao2_OnTimer()
	this:Hide()
	return
end

function PetSoul_XuanWuDao2_ClickClose()

	this:Hide()
	PushEvent("SHOW_PETSOULWAR2_MINI", 1)
	
end

