
-- 紫禁城boss 界面
local g_FC_SceneBoss_SceneIDResMin = 745
local g_FC_SceneBoss_SceneIDResMax = 751

local g_FC_SceneBoss_UnifiedPosition;


local g_FC_SceneBoss_SceneType = 0
local g_FC_SceneBoss_MaxCount = {
[1]={4,4},--?:? ?
[2]={4,1},--?:? ?
}

local g_FC_SceneBoss_DayJoinCount = 1

function FC_SceneBoss_PreLoad()
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SHOW_ZJCBOSS_MAX");
	
	--this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function FC_SceneBoss_OnLoad()

	g_FC_SceneBoss_UnifiedPosition = FC_SceneBoss_Frame:GetProperty("UnifiedPosition");
		
end

function FC_SceneBoss_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99883301) then
	
		g_FC_SceneBoss_SceneType = Get_XParam_INT(0)
		if g_FC_SceneBoss_SceneType <= 0 then
			this:Hide()
			return
		end
		
		if(IsWindowShow("FC_SceneBoss_Mini")) then
			return
		end
		
		local SmallBossCount = Get_XParam_INT(1)
		local MidBossCount = Get_XParam_INT(2)
		local BigBossCount = Get_XParam_INT(3)
		local BossReady = Get_XParam_INT(4)
		local StopWatchTime = Get_XParam_INT(5)
		local nDayJoinCount = Get_XParam_INT(6)

		if g_FC_SceneBoss_SceneType == 1 then
			--紫禁城中央
			FC_SceneBoss_DragTitle:SetText("#{SWZJ_250328_31}")
			--界面介绍性文字
			FC_SceneBoss_Up_Text:SetText("#{SWZJ_250328_32}")
			--不加杀气场景BOSS信息
			FC_SceneBoss_Pair_Title1:SetText("#{SWZJ_250328_33}")

			FC_SceneBoss_NumTitle2:SetText("#{SWZJ_250328_29}")
			FC_SceneBoss_NumTitle3:SetText("#{SWZJ_250328_34}")
			local str = ""
			if BossReady <= 0 then
				FC_SceneBoss_Num2:SetText("#{SWZJ_250328_42}")
				FC_SceneBoss_Num3:SetText("#{SWZJ_250328_42}")
			else
				--剩余中级boss数量
				if MidBossCount > 0 then
					str = ScriptGlobal_Format("#{SWZJ_250328_27}", MidBossCount, g_FC_SceneBoss_MaxCount[1][1])
				else
					str = ScriptGlobal_Format("#{SWZJ_250328_28}", MidBossCount, g_FC_SceneBoss_MaxCount[1][1])
				end
				FC_SceneBoss_Num2:SetText(str)
				--剩余高级boss数量
				if BigBossCount > 0 then
					str = ScriptGlobal_Format("#{SWZJ_250328_27}", BigBossCount, g_FC_SceneBoss_MaxCount[1][2])
				else
					str = ScriptGlobal_Format("#{SWZJ_250328_28}", BigBossCount, g_FC_SceneBoss_MaxCount[1][2])
				end
				FC_SceneBoss_Num3:SetText(str)
			end
			
			if nDayJoinCount >= g_FC_SceneBoss_DayJoinCount then
				--红色
				str = ScriptGlobal_Format("#{SWZJ_250328_28}", nDayJoinCount, g_FC_SceneBoss_DayJoinCount)
				FC_SceneBoss_Num4:SetText(str)
			else
				--绿色
				str = ScriptGlobal_Format("#{SWZJ_250328_27}", nDayJoinCount, g_FC_SceneBoss_DayJoinCount)
				FC_SceneBoss_Num4:SetText(str)
			end

			FC_SceneBoss_Time:SetProperty("Timer", tostring(StopWatchTime))
			
		elseif g_FC_SceneBoss_SceneType == 2 then
			--紫禁城边缘
			FC_SceneBoss_DragTitle:SetText("#{SWZJ_250328_14}")
			--界面介绍性文字
			FC_SceneBoss_Up_Text:SetText("#{SWZJ_250328_01}")
			--加杀气场景BOSS信息
			FC_SceneBoss_Pair_Title1:SetText("#{SWZJ_250328_15}")
			local str = ""
			FC_SceneBoss_NumTitle2:SetText("#{SWZJ_250328_26}")
			FC_SceneBoss_NumTitle3:SetText("#{SWZJ_250328_29}")
			if BossReady <= 0 then
				FC_SceneBoss_Num2:SetText("#{SWZJ_250328_42}")
				FC_SceneBoss_Num3:SetText("#{SWZJ_250328_42}")
			else
				--剩余低级boss数量
				if SmallBossCount > 0 then
					str = ScriptGlobal_Format("#{SWZJ_250328_27}", SmallBossCount, g_FC_SceneBoss_MaxCount[2][1])
				else
					str = ScriptGlobal_Format("#{SWZJ_250328_28}", SmallBossCount, g_FC_SceneBoss_MaxCount[2][1])
				end
				FC_SceneBoss_Num2:SetText(str)
				--剩余中级boss数量
				if MidBossCount > 0 then
					str = ScriptGlobal_Format("#{SWZJ_250328_27}", MidBossCount, g_FC_SceneBoss_MaxCount[2][2])
				else
					str = ScriptGlobal_Format("#{SWZJ_250328_28}", MidBossCount, g_FC_SceneBoss_MaxCount[2][2])
				end
				FC_SceneBoss_Num3:SetText(str)
			end
			
			if nDayJoinCount >= g_FC_SceneBoss_DayJoinCount then
				--红色
				str = ScriptGlobal_Format("#{SWZJ_250328_28}", nDayJoinCount, g_FC_SceneBoss_DayJoinCount)
				FC_SceneBoss_Num4:SetText(str)
			else
				--绿色
				str = ScriptGlobal_Format("#{SWZJ_250328_27}", nDayJoinCount, g_FC_SceneBoss_DayJoinCount)
				FC_SceneBoss_Num4:SetText(str)
			end

			FC_SceneBoss_Time:SetProperty("Timer", tostring(StopWatchTime))
			
		else
			this:Hide()
		end
		
		this:Show()
	
	elseif (event == "ADJEST_UI_POS") then
		FC_SceneBoss_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FC_SceneBoss_Frame_On_ResetPos()
		
	elseif (event=="PLAYER_LEAVE_WORLD") then 
		if( this:IsVisible() ) then
			this:Hide()
		end
		
	elseif (event == "SCENE_TRANSED") then

		if GetSceneID() < g_FC_SceneBoss_SceneIDResMin or GetSceneID() > g_FC_SceneBoss_SceneIDResMax then
			this:Hide()
			return
		end
		
		if arg0 == "zijinnei" or arg0 == "zijinwai1" or arg0 == "zijinwai2" or arg0 == "zijinwai3" or arg0 == "zijinwai4" then
			
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnOpenZJCBossUI" )
				Set_XSCRIPT_ScriptID( 998833 )
				Set_XSCRIPT_Parameter(0, 1); 
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()
						
		else
			this:Hide()
		end
		
	elseif (event == "SHOW_ZJCBOSS_MAX") then
		if GetSceneID() < g_FC_SceneBoss_SceneIDResMin or GetSceneID() > g_FC_SceneBoss_SceneIDResMax then
			return
		end
		
		if arg0 == "1" then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnOpenZJCBossUI" )
				Set_XSCRIPT_ScriptID( 998833 )
				Set_XSCRIPT_Parameter(0, 0); 
				Set_XSCRIPT_ParamCount(1)
			Send_XSCRIPT()	
		end	
	end			

end

function FC_SceneBoss_Frame_On_ResetPos()

	FC_SceneBoss_Frame:SetProperty("UnifiedPosition", g_FC_SceneBoss_UnifiedPosition);
	
end

function FC_SceneBoss_OnTimer()
	this:Hide()
	return
end

function FC_SceneBoss_ClickClose()

	this:Hide()
	PushEvent("SHOW_ZJCBOSS_MINI", 1, g_FC_SceneBoss_SceneType)
	
end

function FC_SceneBoss_ZeroClose()
	this:Hide()
	PushEvent("SHOW_ZJCBOSS_MINI", 0)
end
