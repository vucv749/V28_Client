-- 双人休闲玩法 双人PK玩法 确认UI

local DoublePK_Accept_UnifiedPosition = nil
-- 关注NPC
local DoublePK_Accept_CareObjId = -1
local DoublePK_Accept_CareObjSvrId = -1
local DoublePK_Accept_MAX_OBJ_DISTANCE = 5.0

-- 当前激活UI的游戏类型
local DoublePK_Accept_CurGameType = 0
-- 逻辑已处理标记
local DoublePK_Accept_DealFlag = 0
-- 临时数据
local DoublePK_Accept_Data = {0, 0, 0, 0}

-- 游戏类型
local DoublePK_Accept_GameType =
{
    doublegame_enter = 1,           -- 双人休闲玩法 入场时绑定关系确认
    doublegame_makebinding = 2,     -- 双人休闲玩法 建立绑定关系
    doublegame_cancelbinding = 3,   -- 双人休闲玩法 取消绑定关系
    doublepk_enter = 11,            -- 双人PK玩法 入场时绑定关系确认
    doublepk_makebinding = 12,      -- 双人PK玩法 建立绑定关系
    doublepk_cancelbinding = 13,    -- 双人PK玩法 取消绑定关系
} -- end DoublePK_Accept_GameType



function DoublePK_Accept_PreLoad()
    this:RegisterEvent("UI_COMMAND", true)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
    this:RegisterEvent("OBJECT_CARED_EVENT", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end -- end func DoublePK_Accept_PreLoad()

function DoublePK_Accept_OnEvent(event)
    if (event == "UI_COMMAND") then
        DoublePK_Accept_DealUICommand(tonumber(arg0))
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        if (this:IsVisible()) then
            DoublePK_Accept_Cancel_Clicked(0)
            DoublePK_Accept_Hide()
        end
    elseif (event == "OBJECT_CARED_EVENT") then
        if(DoublePK_Accept_CareObjId < 0 or tonumber(arg0) ~= DoublePK_Accept_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            DoublePK_Accept_Hide()
        end
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Accept_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Accept_UnifiedPos()
	end
end -- end func DoublePK_Accept_OnEvent()

function DoublePK_Accept_OnLoad()
	DoublePK_Accept_UnifiedPosition = DoublePK_Accept_Frame:GetProperty("UnifiedPosition")
end -- end func DoublePK_Accept_OnLoad()

function DoublePK_Accept_UnifiedPos()
    if (DoublePK_Accept_UnifiedPosition ~= nil) then
		DoublePK_Accept_Frame:SetProperty("UnifiedPosition", DoublePK_Accept_UnifiedPosition)
	end
end -- end func DoublePK_Accept_UnifiedPos()

function DoublePK_Accept_Show(objId)
    if (this:IsVisible()) then
        return
    end

    if (objId ~= nil and objId > 0) then
        DoublePK_Accept_BeginCareObject(objId)
    end

    this:Show()
end -- end func DoublePK_Accept_Show()

function DoublePK_Accept_Hide()
    if (this:IsVisible()) then
        this:Hide()
    end
end -- end func DoublePK_Accept_Hide()

-- 开启NPC关注
function DoublePK_Accept_BeginCareObject(objSvrId)
	DoublePK_Accept_CareObjId = DataPool:GetNPCIDByServerID(objSvrId)
    if (DoublePK_Accept_CareObjId >= 0) then
        DoublePK_Accept_CareObjSvrId = objSvrId
        DoublePK_Accept_TargetNPC = objSvrId
		this:CareObject(DoublePK_Accept_CareObjId, 1, "DoublePK_Accept")
	end
end -- end func DoublePK_Accept_BeginCareObject()

-- 取消NPC关注
function DoublePK_Accept_StopCareObject()
	if (DoublePK_Accept_CareObjId >= 0) then
		this:CareObject(DoublePK_Accept_CareObjId, 0, "DoublePK_Accept")
		DoublePK_Accept_CareObjId = -1
		DoublePK_Accept_CareObjSvrId = -1
	end
end -- end func DoublePK_Accept_StopCareObject()

-- UI关闭事件
function DoublePK_Accept_OnHide()
    DoublePK_Accept_StopCareObject()

    if (DoublePK_Accept_DealFlag <= 0) then
        DoublePK_Accept_Cancel_Clicked(0)
    end
end -- end func DoublePK_Accept_OnHide()

-- 确定按钮事件
function DoublePK_Accept_OK_Clicked()
    -- 双人休闲玩法
    if (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_enter) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_TryEnter_BindingConfirm")
			Set_XSCRIPT_ScriptID(890259)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_makebinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_MakeBinding_Confirm")
			Set_XSCRIPT_ScriptID(890259)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
        Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_cancelbinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_CancelBinding_Confirm")
			Set_XSCRIPT_ScriptID(890259)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    end

    -- 双人PK玩法
    if (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_enter) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_TryEnter_BindingConfirm")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_Parameter(1, DoublePK_Accept_Data[3])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_makebinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_MakeBinding_Confirm")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_cancelbinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_CancelBinding_Confirm")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    end

    DoublePK_Accept_DealFlag = 1
    DoublePK_Accept_Hide()
end -- end func DoublePK_Accept_OK_Clicked()

-- 取消、关闭按钮事件
function DoublePK_Accept_Cancel_Clicked(arg)
    -- 双人休闲玩法
    if (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_enter) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_TryEnter_BindingCancel")
			Set_XSCRIPT_ScriptID(890259)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_makebinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_MakeBinding_Cancel")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublegame_cancelbinding) then
        -- 这个地方不需要处理
    end

    -- 双人PK玩法
    if (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_enter) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_TryEnter_BindingCancel")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_Parameter(1, DoublePK_Accept_Data[3])
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_makebinding) then
        Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("CallBack_MakeBinding_Cancel")
			Set_XSCRIPT_ScriptID(890262)
			Set_XSCRIPT_Parameter(0, DoublePK_Accept_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
    elseif (DoublePK_Accept_CurGameType == DoublePK_Accept_GameType.doublepk_cancelbinding) then
        -- 这个地方不需要处理
    end

    DoublePK_Accept_DealFlag = 1
    if (arg > 0) then
        DoublePK_Accept_Hide()
    end
end -- end func DoublePK_Accept_Cancel_Clicked()

function DoublePK_Accept_DealUICommand(cmdIndex)
    for i=1, 4, 1 do
        DoublePK_Accept_Data[i] = 0
    end -- end for

    -- 双人休闲玩法
    if (cmdIndex == 89025901) then
        -- 入场时绑定关系提示
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)

        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublegame_enter

        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("")
            DoublePK_Accept_Text:SetText("#{SRWF_230329_161}")

            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    elseif (cmdIndex == 89025902) then
        -- 建立绑定关系
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)

        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublegame_makebinding

        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("#{SRWF_230329_176}")
            DoublePK_Accept_Text:SetText(Get_XParam_STR(0))
            
            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    elseif (cmdIndex == 89025903) then
        -- 取消绑定关系
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)

        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublegame_cancelbinding

        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("#{SRWF_230329_226}")
            local msg = ScriptGlobal_Format("#{SRWF_230329_203}", Get_XParam_STR(0))
            DoublePK_Accept_Text:SetText(msg)

            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    end

    -- 双人PK玩法
    if (cmdIndex == 89026201) then
        -- 入场时绑定关系提示
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)
        DoublePK_Accept_Data[3] = Get_XParam_INT(2)

        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublepk_enter

        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("")
            DoublePK_Accept_Text:SetText("#{SRPK_230331_232}")

            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    elseif (cmdIndex == 89026202) then
        -- 建立绑定关系
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)

        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublepk_makebinding
        
        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("#{SRPK_230331_250}")
            DoublePK_Accept_Text:SetText(Get_XParam_STR(0))

            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    elseif (cmdIndex == 89026203) then
        -- 取消绑定关系
        DoublePK_Accept_Data[1] = Get_XParam_INT(0)
        DoublePK_Accept_Data[2] = Get_XParam_INT(1)
        
        -- 设置当前激活的游戏类型
        DoublePK_Accept_CurGameType = DoublePK_Accept_GameType.doublepk_cancelbinding

        if (DoublePK_Accept_Data[2] > 0) then
            DoublePK_Accept_PageHeader_Name:SetText("#{SRPK_230331_301}")
            local msg = ScriptGlobal_Format("#{SRPK_230331_261}", Get_XParam_STR(0))
            DoublePK_Accept_Text:SetText(msg)

            DoublePK_Accept_DealFlag = 0
            DoublePK_Accept_Show(DoublePK_Accept_Data[1])
        else
            DoublePK_Accept_DealFlag = 1
            DoublePK_Accept_Hide()
        end
    end
end -- end func DoublePK_Accept_DealUICommand()