-- 双人玩法 猜拳UI

-- 默认位置
local DoublePK_CaiQuan_UnifiedPosition = nil
-- 控件表
local DoublePK_CaiQuan_CtrlList = nil
local DoublePK_CaiQuan_SvrScriptId = 998319
-- 选择的控件
local DoublePK_CaiQuan_Select = 0
local DoublePK_CaiQuan_Type = {
    Type_A = 1,
    Type_B = 2,
    Type_C = 3,
}
-- 字典
local DoublePK_CaiQuan_TxtList = {
    [1] = {name="#{SRPK_230331_60}", desc="#{SRPK_230331_63}",},
    [2] = {name="#{SRPK_230331_61}", desc="#{SRPK_230331_64}",},
    [3] = {name="#{SRPK_230331_62}", desc="#{SRPK_230331_65}",},
}
function DoublePK_CaiQuan_PreLoad()
    this:RegisterEvent("OPEN_DOUBLEPK_GUESS", true)
    this:RegisterEvent("CLOSE_DOUBLEPK_ALL", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
end

function DoublePK_CaiQuan_OnEvent(event)
    if (event == "OPEN_DOUBLEPK_GUESS") then
        DoublePK_CaiQuan_Show()
    elseif (event == "CLOSE_DOUBLEPK_ALL") then
        DoublePK_CaiQuan_Hide()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_CaiQuan_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_CaiQuan_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_CaiQuan_UnifiedPos()
	end
end

function DoublePK_CaiQuan_OnLoad()
	DoublePK_CaiQuan_UnifiedPosition = DoublePK_CaiQuan_Frame:GetProperty("UnifiedPosition")
	DoublePK_CaiQuan_InitCtrlList()
end

function DoublePK_CaiQuan_InitCtrlList()
    DoublePK_CaiQuan_CtrlList = {}

    DoublePK_CaiQuan_CtrlList.list = {}
    DoublePK_CaiQuan_CtrlList.list[1] = DoublePK_CaiQuan_Buff1Btn
    DoublePK_CaiQuan_CtrlList.list[2] = DoublePK_CaiQuan_Buff2Btn
    DoublePK_CaiQuan_CtrlList.list[3] = DoublePK_CaiQuan_Buff3Btn

    DoublePK_CaiQuan_CtrlList.timer = DoublePK_CaiQuan_Time
end

-- 界面默认位置
function DoublePK_CaiQuan_UnifiedPos()
	if (DoublePK_CaiQuan_UnifiedPosition ~= nil) then
		DoublePK_CaiQuan_Frame:SetProperty("UnifiedPosition", DoublePK_CaiQuan_UnifiedPosition)
	end
end

function DoublePK_CaiQuan_Show()
    DoublePK_CaiQuan_Select = 0
    DoublePK_CaiQuan_BaseShow()
    this:Show()
end

function DoublePK_CaiQuan_BaseShow()
    local timer = DoublePK:GetGuessRemainTime()
    if timer > 0 then
        DoublePK_CaiQuan_CtrlList.timer:SetProperty("Timer", timer)
    else
        DoublePK_CaiQuan_CtrlList.timer:SetProperty("Timer", 0)
    end
    DoublePK_CaiQuan_CtrlList.timer:SetProperty("TextColor","FFFFF263")

    local step, select = DoublePK:GetGuessInfo()
    DoublePK_CaiQuan_Select = select
    for _, data in (DoublePK_CaiQuan_CtrlList.list or {}) do
        data:SetCheck(0)
    end

    if DoublePK_CaiQuan_CtrlList.list[select] ~= nil then
        DoublePK_CaiQuan_CtrlList.list[select]:SetCheck(1)
    end
end

-- 选择答案
function DoublePK_CaiQuan_OnSelectClick(nSelect)
    -- 验证选择的号是否正确
    if nSelect < DoublePK_CaiQuan_Type.Type_A or nSelect > DoublePK_CaiQuan_Type.Type_C then
        PushDebugMessage("#{SRPK_230331_67}")
        return
    end
    -- 相同的选项无法二次选择
    local step, select = DoublePK:GetGuessInfo()
    if select == nSelect then
        return
    end
    
    DoublePK_CaiQuan_Select = nSelect

    for _, data in (DoublePK_CaiQuan_CtrlList.list or {}) do
        data:SetCheck(0)
    end

    if DoublePK_CaiQuan_CtrlList.list[select] ~= nil then
        DoublePK_CaiQuan_CtrlList.list[select]:SetCheck(1)
    end
    DoublePK_CaiQuan_OnClickOk(nSelect)
end

function DoublePK_CaiQuan_OnClickOk(nSelect)
    --local nSelect = DoublePK_CaiQuan_Select
    -- 验证选择的号是否正确
    if nSelect < DoublePK_CaiQuan_Type.Type_A or nSelect > DoublePK_CaiQuan_Type.Type_C then
        PushDebugMessage("#{SRPK_230331_67}")
        return
    end
    -- 相同的选项无法二次选择
    local step, select = DoublePK:GetGuessInfo()
    if select == nSelect then
        return
    end
    
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DoublePK_CaiQuan_SvrScriptId)
        Set_XSCRIPT_Function_Name("PlayerSelectGuess")
        Set_XSCRIPT_Parameter(0, step)
        Set_XSCRIPT_Parameter(1, nSelect)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

-- 打开规则界面
function DoublePK_CaiQuan_OnOpenRuleUI()
    PushEvent("OPEN_DOUBLEPK_RULE")
end

function DoublePK_CaiQuan_OnTimerEnd()
    DoublePK_CaiQuan_Clicked_Close()
end

function DoublePK_CaiQuan_Hide()
    -- 关闭关联UI
    if IsWindowShow("DoublePK_CaiQuanGuiZe") then
		CloseWindow("DoublePK_CaiQuanGuiZe", true)
	end
    this:Hide()
end

-- 关闭按钮点击事件
function DoublePK_CaiQuan_Clicked_Close()
    DoublePK_CaiQuan_Hide()
end


