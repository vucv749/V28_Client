--******************************
--倒计时
--******************************
local SpringFestival_Timing_Frame_UnifiedPosition;
local SpringFestival_Timing_param = -1
local SpringFestival_Timing_targetId = -1
local SpringFestival_Timing_Count = 0


function SpringFestival_Timing_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	--玩家切场景
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
end

function SpringFestival_Timing_OnLoad()
	SpringFestival_Timing_Frame_UnifiedPosition = SpringFestival_Timing_Frame:GetProperty("UnifiedPosition");
end

function SpringFestival_Timing_OnEvent(event)

  --5秒倒计时	
  if ( event == "UI_COMMAND" and tonumber(arg0) == 81011101) then
  	local param0 = Get_XParam_INT(0)
    if param0 == 1 then
    	--上工倒计时
    	SpringFestival_Timing_targetId = Get_XParam_INT(1)
			SpringFestival_Timing_Animate:Show()
			SpringFestival_Timing_Animate:Play(true)
			SetTimer("SpringFestival_Timing","SpringFestival_Timing_Animate_Close()", 5000)
			SpringFestival_Timing_VictoryImage:Hide()
			SpringFestival_Timing_FailImage:Hide()
			SpringFestival_Timing_Count = 0
			this:Show()
		elseif param0 == 0 then
			SpringFestival_Timing_CloseUI()
		elseif param0 == 2 then

			--local missionlistid = DataPool:GetPlayerMissionIndexByID(2118)
			--local ndata = DataPool:GetPlayerMission_Display(missionlistid, 3)
			--SpringFestival_Timing_param = Get_XParam_INT(1)
			SetTimer("SpringFestival_Timing","SpringFestival_Timing_Animate_7Tick()", 7000)
		elseif param0 == 3 then
			--成功
			SpringFestival_Timing_VictoryImage:Show()
			SpringFestival_Timing_FailImage:Hide()
			SpringFestival_Timing_Animate:Hide()
			SetTimer("SpringFestival_Timing","SpringFestival_Timing_Image_Close()", 3000)
		elseif param0 == 4 then
			--失败
			SpringFestival_Timing_FailImage:Show()
			SpringFestival_Timing_VictoryImage:Hide()
			SpringFestival_Timing_Animate:Hide()
			SetTimer("SpringFestival_Timing","SpringFestival_Timing_Image_Close()", 3000)
    end
  elseif event=="HIDE_ON_SCENE_TRANSED"  then
		SpringFestival_Timing_CloseUI()
  end

end

function SpringFestival_Timing_Animate_Close()
	KillTimer("SpringFestival_Timing_Animate_Close()")
	--停止倒计时动画
	PushDebugMessage("#{CJDG_221110_38}")--请少侠准备，即将上工！
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnDaGongBegin" )
		Set_XSCRIPT_ScriptID(810115)
		Set_XSCRIPT_Parameter(0,SpringFestival_Timing_targetId)
		Set_XSCRIPT_Parameter(1,1)--bstart
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function SpringFestival_Timing_Animate_7Tick()
	PushDebugMessage("#{CJDG_221110_40}")
	KillTimer("SpringFestival_Timing_Animate_7Tick()")
	SetTimer("SpringFestival_Timing","SpringFestival_Timing_Animate_3Tick()", 3000)
end

function SpringFestival_Timing_Animate_3Tick()
	KillTimer("SpringFestival_Timing_Animate_3Tick()")
	SpringFestival_Timing_Count = SpringFestival_Timing_Count+1
	if SpringFestival_Timing_Count >= 5 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnDaGongEnd" )
			Set_XSCRIPT_ScriptID(810115)
			Set_XSCRIPT_Parameter(0,SpringFestival_Timing_targetId)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnDaGongBegin" )
			Set_XSCRIPT_ScriptID(810115)
			Set_XSCRIPT_Parameter(0,SpringFestival_Timing_targetId)
			Set_XSCRIPT_Parameter(1,0)--bstart
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end
function SpringFestival_Timing_Image_Close()
	SpringFestival_Timing_CloseUI()
end
function SpringFestival_Timing_CloseUI()
	KillTimer("SpringFestival_Timing_Animate_Close()")
	KillTimer("SpringFestival_Timing_Animate_7Tick()")
	KillTimer("SpringFestival_Timing_Animate_3Tick()")
	KillTimer("SpringFestival_Timing_Image_Close()")
	this:Hide()
end
--=========================================================
--界面隐藏
--=========================================================
function SpringFestival_Timing_OnHiden()
    this:Hide()
end

function SpringFestival_Timing_Frame_On_ResetPos()
    SpringFestival_Timing_Frame:SetProperty("UnifiedPosition", SpringFestival_Timing_Frame_UnifiedPosition);
end