local TBossTime_AcceptBox_ConfirmUICommand_LT = 81015301
local TBossTime_AcceptBox_ConfirmUICommand_LT_Close = 81015302
local TBossTime_AcceptBox_ConfirmUICommand_GT = 81015201
local TBossTime_AcceptBox_ConfirmUICommand_GT_Close = 81015202
local TBossTime_AcceptBox_SvrScriptId_LT = 810153
local TBossTime_AcceptBox_ActType = -1
local TBossTime_AcceptBox_EventId = -1
local TBossTime_AcceptBox_TeamFlag = -1
local TBossTime_AcceptBox_CloseFlag = -1
-- 关注NPC
local TBossTime_AcceptBox_CareObjId = -1
local TBossTime_AcceptBox_TargetSvrId = -1
local TBossTime_AcceptBox_MAX_OBJ_DISTANCE = 5.0

local TBossTime_AcceptBox_UnifiedPosition = nil



function TBossTime_AcceptBox_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func TBossTime_AcceptBox_PreLoad()

function TBossTime_AcceptBox_OnEvent(event)
    if (event == "UI_COMMAND") then
		if (tonumber(arg0) == TBossTime_AcceptBox_ConfirmUICommand_LT or 
			tonumber(arg0) == TBossTime_AcceptBox_ConfirmUICommand_GT) then
			-- 打开二次确认窗口
			local targetSvrId = Get_XParam_INT(0)
			local actType = Get_XParam_INT(1)
			local eventId = Get_XParam_INT(2)
			local teamFlag = Get_XParam_INT(3)

			TBossTime_AcceptBox_ActType = tonumber(actType)
			TBossTime_AcceptBox_EventId = tonumber(eventId)
			TBossTime_AcceptBox_TeamFlag = tonumber(teamFlag)

			TBossTime_AcceptBox_Show(tonumber(targetSvrId), tonumber(arg0))

			-- 因为之前的对话提示框可能还开着 所以犫里需要关睜一下
			PushEvent("UI_COMMAND", 1000)
		elseif (tonumber(arg0) == TBossTime_AcceptBox_ConfirmUICommand_LT_Close or 
				tonumber(arg0) == TBossTime_AcceptBox_ConfirmUICommand_GT_Close) then
			-- 关睜二次确认窗口
			if (this:IsVisible()) then
				TBossTime_AcceptBox_CloseFlag = 101
				TBossTime_AcceptBox_Hide()
			end
        end
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		if (this:IsVisible()) then
			TBossTime_AcceptBox_Cancel(11)
			TBossTime_AcceptBox_Hide()
		end
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TBossTime_AcceptBox_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		TBossTime_AcceptBox_UnifiedPos()
	end
end -- end func TBossTime_AcceptBox_OnEvent()

function TBossTime_AcceptBox_OnLoad()
	TBossTime_AcceptBox_UnifiedPosition = TBossTime_AcceptBox_Frame:GetProperty("UnifiedPosition")

	--TBossTime_AcceptBox_Text:SetText("#{KFRC_240326_39}")
end -- end func TBossTime_AcceptBox_OnLoad()

function TBossTime_AcceptBox_Frame_OnHiden()
	if (TBossTime_AcceptBox_CloseFlag <= 0 and this:IsVisible()) then
		-- 犫应该是远离之后的自动关睜 需要发送一个取消的消息
		TBossTime_AcceptBox_Cancel(12)
	end

	TBossTime_AcceptBox_CloseFlag = -1
end -- end func TBossTime_AcceptBox_Frame_OnHiden()

-- 界面默认位置
function TBossTime_AcceptBox_UnifiedPos()
	if (TBossTime_AcceptBox_UnifiedPosition ~= nil) then
		TBossTime_AcceptBox_Frame:SetProperty("UnifiedPosition", TBossTime_AcceptBox_UnifiedPosition)
	end
end -- end func TBossTime_AcceptBox_UnifiedPos()

function TBossTime_AcceptBox_Show(targetId, commandId)
	TBossTime_AcceptBox_Text:SetText("")
	if (commandId == TBossTime_AcceptBox_ConfirmUICommand_LT) then
		TBossTime_AcceptBox_Text:SetText("#{KFRC_240326_02}")
	else
		TBossTime_AcceptBox_Text:SetText("#{KFRC_240326_39}")
	end
	
	if (targetId >= 0) then
		TBossTime_AcceptBox_BeginCareObject(targetId)
	end

	this:Show()
end -- end func TBossTime_AcceptBox_Show()

function TBossTime_AcceptBox_Hide(arg)
	if (this:IsVisible()) then
        TBossTime_AcceptBox_StopCareObject()
        this:Hide()
    end
end -- end func TBossTime_AcceptBox_Hide()

-- 开启NPC关注
function TBossTime_AcceptBox_BeginCareObject(targetSvrId)
	TBossTime_AcceptBox_TargetSvrId = targetSvrId
	TBossTime_AcceptBox_CareObjId = Target:GetServerId2ClientId(targetSvrId)
	if (TBossTime_AcceptBox_CareObjId >= 0) then
		this:CareObject(TBossTime_AcceptBox_CareObjId, 1, "TBossTime_AcceptBox")
	end
end -- end func TBossTime_AcceptBox_BeginCareObject()

-- 取消NPC关注
function TBossTime_AcceptBox_StopCareObject()
	if (TBossTime_AcceptBox_CareObjId >= 0) then
		this:CareObject(TBossTime_AcceptBox_CareObjId, 0, "TBossTime_AcceptBox")
		TBossTime_AcceptBox_CareObjId = -1
		TBossTime_AcceptBox_TargetSvrId = -1
	end
end -- end func TBossTime_AcceptBox_StopCareObject()

-- 确认按钮事件
function TBossTime_AcceptBox_OK_Clicked()
	TBossTime_AcceptBox_Confirm()

	TBossTime_AcceptBox_Hide()
end -- end func TBossTime_AcceptBox_OK_Clicked()

-- 窗口关睜、取消按钮事件
function TBossTime_AcceptBox_Cancel_Clicked(arg)
	TBossTime_AcceptBox_Cancel(arg)

	TBossTime_AcceptBox_Hide()
end -- end func TBossTime_AcceptBox_Cancel_Clicked()

-- 确认操作
function TBossTime_AcceptBox_Confirm()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(TBossTime_AcceptBox_SvrScriptId_LT)
		Set_XSCRIPT_Function_Name("CCallBack_EnterConfirm")
		Set_XSCRIPT_Parameter(0, TBossTime_AcceptBox_TargetSvrId)
		Set_XSCRIPT_Parameter(1, TBossTime_AcceptBox_EventId)
		Set_XSCRIPT_Parameter(2, TBossTime_AcceptBox_TeamFlag)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()

	TBossTime_AcceptBox_CloseFlag = 100
end -- end func TBossTime_AcceptBox_Confirm()

-- 取消操作
function TBossTime_AcceptBox_Cancel(arg)
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(TBossTime_AcceptBox_SvrScriptId_LT)
		Set_XSCRIPT_Function_Name("CCallBack_EnterCancel")
		Set_XSCRIPT_Parameter(0, TBossTime_AcceptBox_TargetSvrId)
		Set_XSCRIPT_Parameter(1, TBossTime_AcceptBox_EventId)
		Set_XSCRIPT_Parameter(2, TBossTime_AcceptBox_TeamFlag)
		Set_XSCRIPT_Parameter(3, arg)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

	TBossTime_AcceptBox_CloseFlag = arg
end -- end func TBossTime_AcceptBox_Cancel()
