-- 双人玩法 效果界面

-- 默认位置
local DoublePK_Buff_UnifiedPosition = nil
-- 控件表
local DoublePK_Buff_CtrlList = nil
local DoublePK_Buff_Select = 0
local DoublePK_Buff_SvrScriptId = 998319
local DoublePK_Buff_SelectMax = 2
local DoublePK_Buff_Type = {
    Type_A = 1,
    Type_B = 2,
}
local DoublePK_Buff_TxtList = {
    [1] = {name="#{SRPK_230331_147}", desc="#{SRPK_230331_148}",},
    [45773] = {name="#{SRPK_230331_147}", desc="#{SRPK_230331_148}",},
    [45770] = {name="#{SRPK_230331_149}", desc="#{SRPK_230331_150}",},
    [45767] = {name="#{SRPK_230331_151}", desc="#{SRPK_230331_152}",},
    [45776] = {name="#{SRPK_230331_153}", desc="#{SRPK_230331_154}",},
    [45779] = {name="#{SRPK_230331_155}", desc="#{SRPK_230331_156}",},
    [45782] = {name="#{SRPK_230331_157}", desc="#{SRPK_230331_158}",},
    [45785] = {name="#{SRPK_230331_159}", desc="#{SRPK_230331_160}",},
    [45787] = {name="#{SRPK_230331_161}", desc="#{SRPK_230331_162}",},
    [45774] = {name="#{SRPK_230331_147}", desc="#{SRPK_230331_163}",},
    [45771] = {name="#{SRPK_230331_149}", desc="#{SRPK_230331_164}",},
    [45768] = {name="#{SRPK_230331_151}", desc="#{SRPK_230331_165}",},
    [45777] = {name="#{SRPK_230331_153}", desc="#{SRPK_230331_166}",},
    [45780] = {name="#{SRPK_230331_155}", desc="#{SRPK_230331_167}",},
    [45783] = {name="#{SRPK_230331_157}", desc="#{SRPK_230331_168}",},
    [45786] = {name="#{SRPK_230331_159}", desc="#{SRPK_230331_169}",},
    [45775] = {name="#{SRPK_230331_147}", desc="#{SRPK_230331_170}",},
    [45772] = {name="#{SRPK_230331_149}", desc="#{SRPK_230331_171}",},
    [45769] = {name="#{SRPK_230331_151}", desc="#{SRPK_230331_172}",},
    [45778] = {name="#{SRPK_230331_153}", desc="#{SRPK_230331_173}",},
    [45781] = {name="#{SRPK_230331_155}", desc="#{SRPK_230331_174}",},
    [45784] = {name="#{SRPK_230331_157}", desc="#{SRPK_230331_175}",},
}
function DoublePK_Buff_PreLoad()
    this:RegisterEvent("OPEN_DOUBLEPK_BUFF", true)
    this:RegisterEvent("CLOSE_DOUBLEPK_ALL", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function DoublePK_Buff_OnEvent(event)
    if (event == "OPEN_DOUBLEPK_BUFF") then
        DoublePK_Buff_Show()
    elseif (event == "CLOSE_DOUBLEPK_ALL") then
        DoublePK_Buff_Hide()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Buff_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Buff_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Buff_UnifiedPos()
	end
end

function DoublePK_Buff_OnLoad()
	DoublePK_Buff_UnifiedPosition = DoublePK_Buff_Frame:GetProperty("UnifiedPosition")
	DoublePK_Buff_InitCtrlList()
end

function DoublePK_Buff_InitCtrlList()
    DoublePK_Buff_CtrlList = {}
    DoublePK_Buff_CtrlList.list = {}
    DoublePK_Buff_CtrlList.list[1] = {}
    DoublePK_Buff_CtrlList.list[1].name = DoublePK_Buff_Buff1
    DoublePK_Buff_CtrlList.list[1].desc = DoublePK_Buff_Buff1Info
    DoublePK_Buff_CtrlList.list[1].btn = DoublePK_Buff_Buff1Btn
    DoublePK_Buff_CtrlList.list[2] = {}
    DoublePK_Buff_CtrlList.list[2].name = DoublePK_Buff_Buff2
    DoublePK_Buff_CtrlList.list[2].desc = DoublePK_Buff_Buff2Info
    DoublePK_Buff_CtrlList.list[2].btn = DoublePK_Buff_Buff2Btn

    DoublePK_Buff_CtrlList.timer = DoublePK_Buff_Time
end

-- 界面默认位置
function DoublePK_Buff_UnifiedPos()
	if (DoublePK_Buff_UnifiedPosition ~= nil) then
		DoublePK_Buff_Frame:SetProperty("UnifiedPosition", DoublePK_Buff_UnifiedPosition)
	end
end

function DoublePK_Buff_Show()
    DoublePK_Buff_InitData()
    DoublePK_Buff_BaseShow()
    this:Show()
end

function DoublePK_Buff_InitData()
    DoublePK_Buff_Select = 0
    local step, select = DoublePK:GetBuffInfo()
    DoublePK_Buff_Select = select
end

function DoublePK_Buff_BaseShow()
    for i=1, DoublePK_Buff_SelectMax do
        local buffId = DoublePK:GetBuffListInfo(i-1)
        local data = DoublePK_Buff_TxtList[buffId]
        if data == nil then
            data = DoublePK_Buff_TxtList[1]
        end
        local uidata = DoublePK_Buff_CtrlList.list[i]
        if data ~= nil and uidata ~= nil then
            uidata.name:SetText(data.name)
            uidata.desc:SetText(data.desc)
            uidata.btn:SetCheck(0)
            if i == DoublePK_Buff_Select then
                uidata.btn:SetCheck(1)
            end
        end
    end

    local timer = DoublePK:GetBuffRemainTime()
    if timer > 0 then
        DoublePK_Buff_CtrlList.timer:SetProperty("Timer", timer)
    else
        DoublePK_Buff_CtrlList.timer:SetProperty("Timer", 0)
    end
    DoublePK_Buff_CtrlList.timer:SetProperty("TextColor","FFFFF263")
end

function DoublePK_Buff_Hide()
    this:Hide()
end

-- 点击选项
function DoublePK_Buff_SelectClicked(nSelect)
    if nSelect ~= DoublePK_Buff_Type.Type_A and nSelect ~= DoublePK_Buff_Type.Type_B then
        return
    end
    local step, select = DoublePK:GetBuffInfo()
    if select == nSelect then
        return
    end

    DoublePK_Buff_Select = nSelect


    for i=1, DoublePK_Buff_SelectMax do
        local uidata = DoublePK_Buff_CtrlList.list[i]
        if uidata ~= nil then
            uidata.btn:SetCheck(0)
        end
    end

    local uidata = DoublePK_Buff_CtrlList.list[select]
    if uidata ~= nil then
        uidata.btn:SetCheck(1)
    end
    DoublePK_Buff_OnClickedOK(nSelect)
end

function DoublePK_Buff_OnClickedOK(nSelect)
    --local nSelect = DoublePK_Buff_Select
    local step, select = DoublePK:GetBuffInfo()
    if select == nSelect then
        PushDebugMessage("#{SRPK_230331_73}")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DoublePK_Buff_SvrScriptId)
        Set_XSCRIPT_Function_Name("PlayerSelectBuff")
        Set_XSCRIPT_Parameter(0, step)
        Set_XSCRIPT_Parameter(1, nSelect)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end

function DoublePK_Buff_OnTimerEnd()
    DoublePK_Buff_Clicked_Close()
end

-- 关闭按钮点击事件
function DoublePK_Buff_Clicked_Close()
    DoublePK_Buff_Hide()
end


