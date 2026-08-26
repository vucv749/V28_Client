-- 双人休闲玩法 游戏类型选择UI

local DoublePlay_Choose_SvrScriptId = 890260
local DoublePlay_Choose_UICommandIndex = 2023040601
local DoublePlay_Choose_MaxEnterCount = 20
local DoublePlay_Choose_LastChosen = -1

-- 关注NPC
local DoublePlay_Choose_CareObjId = -1
local DoublePlay_Choose_CareObjSvrId = -1
local DoublePlay_Choose_MAX_OBJ_DISTANCE = 5.0

-- 游戏信息
local DoublePlay_Choose_GameInfo =
{
    [1] = {name = "#{SRWF_230329_138}", type = 1},      -- 随机
    [2] = {name = "#{SRWF_230329_29}", type = 2},       -- 算术游戏
    [3] = {name = "#{SRWF_230329_30}", type = 3},       -- 寻找游戏
    [4] = {name = "#{SRWF_230329_31}", type = 4},       -- 躲避游戏
} -- end DoublePlay_Choose_GameInfo



function DoublePlay_Choose_PreLoad()
    this:RegisterEvent("DOUBLEGAME_OPENCHOOSE", true)
    this:RegisterEvent("DOUBLEGAME_CLOSECHOOSE", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func DoublePlay_Choose_PreLoad()

function DoublePlay_Choose_OnEvent(event)
    if (event == "DOUBLEGAME_OPENCHOOSE") then
        if (not this:IsVisible()) then
            DoublePlay_Choose_BeginCareObject(arg0, arg1)
            DoublePlay_Choose_UpdateCtrl(arg2, arg3, arg4)
            DoublePlay_Choose_Show()
        end
    elseif (event == "DOUBLEGAME_CLOSECHOOSE") then
        if (this:IsVisible()) then
            DoublePlay_Choose_Hide()
        end
    elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(DoublePlay_Choose_CareObjId < 0 or tonumber(arg0) ~= DoublePlay_Choose_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            DoublePlay_Choose_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePlay_Choose_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePlay_Choose_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePlay_Choose_UnifiedPos()
	end
end -- end func DoublePlay_Choose_OnEvent()

function DoublePlay_Choose_OnLoad()
	DoublePlay_Choose_UnifiedPosition = DoublePlay_Choose_Frame:GetProperty("UnifiedPosition")
end -- end func DoublePlay_Choose_OnLoad()

-- 界面默认位置
function DoublePlay_Choose_UnifiedPos()
	if (DoublePlay_Choose_UnifiedPosition ~= nil) then
		DoublePlay_Choose_Frame:SetProperty("UnifiedPosition", DoublePlay_Choose_UnifiedPosition)
	end
end -- end func DoublePlay_Choose_UnifiedPos()

-- 关闭事件
function DoublePlay_Choose_Close()
    DoublePlay_Choose_Hide()
end -- end func DoublePlay_Choose_Close()

-- 详情按钮事件
function DoublePlay_Choose_NPCInfo_Click(arg)
    PushEvent("DOUBLEGAME_GAMEDESC", arg)
end -- end func DoublePlay_Choose_NPCInfo_Click()

-- 选择按钮事件
function DoublePlay_Choose_NPCGo_Click(arg)
    local name, idx = DoublePlay_Choose_PlayGame:GetCurrentSelect()
    local gameInfo = DoublePlay_Choose_GameInfo[idx]
    if (gameInfo == nil) then
        return
    end

    DoublePlay_Choose_LastChosen = idx

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DoublePlay_Choose_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_SetGameType")
        Set_XSCRIPT_Parameter(0, DoublePlay_Choose_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, gameInfo.type)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()

    DoublePlay_Choose_Hide()
end -- end func DoublePlay_Choose_NPCGo_Click()

-- 取消按钮事件
function DoublePlay_Choose_No_Click()
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DoublePlay_Choose_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_CancelMatch")
        Set_XSCRIPT_Parameter(0, DoublePlay_Choose_CareObjSvrId)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()

    DoublePlay_Choose_Hide()
end -- end func DoublePlay_Choose_No_Click()

-- 开启NPC关注
function DoublePlay_Choose_BeginCareObject(objSvrId, objId)
	DoublePlay_Choose_CareObjId = tonumber(objId)
    if (DoublePlay_Choose_CareObjId >= 0) then
        DoublePlay_Choose_CareObjSvrId = tonumber(objSvrId)
        DoublePlay_Choose_TargetNPC = tonumber(objSvrId)
		this:CareObject(DoublePlay_Choose_CareObjId, 1, "DoublePlay_Choose")
	end
end -- end func DoublePlay_Choose_BeginCareObject()

-- 取消NPC关注
function DoublePlay_Choose_StopCareObject()
	if (DoublePlay_Choose_CareObjId >= 0) then
		this:CareObject(DoublePlay_Choose_CareObjId, 0, "DoublePlay_Choose")
		DoublePlay_Choose_CareObjId = -1
		DoublePlay_Choose_CareObjSvrId = -1
	end
end -- end func DoublePlay_Choose_StopCareObject()

function DoublePlay_Choose_Show()
    this:Show()
end -- end func DoublePlay_Choose_Show()

function DoublePlay_Choose_Hide()
    DoublePlay_Choose_StopCareObject()
    this:Hide()
end -- end func DoublePlay_Choose_Hide()

-- 刷新UI
function DoublePlay_Choose_UpdateCtrl(enterCount, awardNum, matchType)
    local leftCount = DoublePlay_Choose_MaxEnterCount - tonumber(enterCount)
    local curMatchType = tonumber(matchType)
    if (curMatchType <= 0) then
        DoublePlay_Choose_OK:Enable()
        DoublePlay_Choose_No:Disable()
    else
        DoublePlay_Choose_OK:Disable()
        DoublePlay_Choose_No:Enable()
    end

    if (DoublePlay_Choose_PlayGame ~= nil) then
        DoublePlay_Choose_PlayGame:ResetList()

        -- for i=1, table.getn(DoublePlay_Choose_GameInfo), 1 do
        --     if (DoublePlay_Choose_GameInfo[i] ~= nil) then
        --         DoublePlay_Choose_PlayGame:AddTextItem(DoublePlay_Choose_GameInfo[i].name, DoublePlay_Choose_GameInfo[i].type)
        --     end
        -- end
        DoublePlay_Choose_PlayGame:AddTextItem(DoublePlay_Choose_GameInfo[1].name, DoublePlay_Choose_GameInfo[1].type)

        if (DoublePlay_Choose_LastChosen > 0) then
            DoublePlay_Choose_PlayGame:SetCurrentSelect(DoublePlay_Choose_LastChosen-1)
        else
            DoublePlay_Choose_PlayGame:SetCurrentSelect(0)
        end
    end
    -- 临时隐藏掉下拉列表
    DoublePlay_Choose_PlayGame:Hide()

    -- 剩余次数
    local strTemp = ScriptGlobal_Format("#{SRWF_230329_141}", leftCount)
    DoublePlay_Choose_Num:SetText(strTemp)

    -- 同心玉佩
    local strTemp2 = ScriptGlobal_Format("#{SRWF_230329_196}", tonumber(awardNum))
    DoublePlay_Choose_Num2:SetText(strTemp2)
end -- end func DoublePlay_Choose_UpdateCtrl()