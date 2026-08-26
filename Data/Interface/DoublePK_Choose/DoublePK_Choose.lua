-- 双人玩法 身份选择UI

-- 默认位置
local DoublePK_Choose_UnifiedPosition = nil
-- 控件表
local DoublePK_Choose_CtrlList = nil
local DoublePK_Choose_SvrScriptId = 998319
-- 描述相关
local DoublePK_Choose_Desc = {
    [1] = {name="#{SRPK_230331_51}", desc="#{SRPK_230331_53}",},
    [2] = {name="#{SRPK_230331_52}", desc="#{SRPK_230331_54}",},
}
-- 身份最大数量
local DoublePK_Choose_Type = {
    Type_A = 0,
    Type_B = 1,
    Type_Max = 2,
}
-- 身份种类
local DoublePK_Choose_Identity = {
    Invalid = 0,
    A = 1,
    B = 2,
}
local DoublePK_Choose_Icon = {
    [1] = {image = "set:DoubleGame01 image:DoubleGame_QinShi"},
    [2] = {image = "set:DoubleGame01 image:DoubleGame_JianKe"},
}
function DoublePK_Choose_PreLoad()
    this:RegisterEvent("OPEN_DOUBLEPK_IDENTITY", true)
    this:RegisterEvent("CLOSE_DOUBLEPK_ALL", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function DoublePK_Choose_OnEvent(event)
    if (event == "OPEN_DOUBLEPK_IDENTITY") then
        DoublePK_Choose_Show(tonumber(arg0))
    elseif (event == "CLOSE_DOUBLEPK_ALL") then
        DoublePK_Choose_Hide()
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DoublePK_Choose_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DoublePK_Choose_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DoublePK_Choose_UnifiedPos()
	end
end

function DoublePK_Choose_OnLoad()
	DoublePK_Choose_UnifiedPosition = DoublePK_Choose_Frame:GetProperty("UnifiedPosition")
	DoublePK_Choose_InitCtrlList()
end

function DoublePK_Choose_InitCtrlList()
    DoublePK_Choose_CtrlList = {}
    -- 第一个身份
    DoublePK_Choose_CtrlList[1] = {}
    --DoublePK_Choose_CtrlList[1].name = DoublePK_Choose_Gamer2
    --DoublePK_Choose_CtrlList[1].desc = DoublePK_Choose_Gamer2Info
    DoublePK_Choose_CtrlList[1].confirm = DoublePK_Choose_Gamer2Image1
    DoublePK_Choose_CtrlList[1].confirm2 = DoublePK_Choose_Gamer2Image2
    DoublePK_Choose_CtrlList[1].btn = DoublePK_Choose_OK2
    -- 第二个身份
    DoublePK_Choose_CtrlList[2] = {}
    --DoublePK_Choose_CtrlList[2].name = DoublePK_Choose_Gamer1
    --DoublePK_Choose_CtrlList[2].desc = DoublePK_Choose_Gamer1Info
    DoublePK_Choose_CtrlList[2].confirm = DoublePK_Choose_Gamer1Image1
    DoublePK_Choose_CtrlList[2].confirm2 = DoublePK_Choose_Gamer1Image2
    DoublePK_Choose_CtrlList[2].btn = DoublePK_Choose_OK1
end

-- 界面默认位置
function DoublePK_Choose_UnifiedPos()
	if (DoublePK_Choose_UnifiedPosition ~= nil) then
		DoublePK_Choose_Frame:SetProperty("UnifiedPosition", DoublePK_Choose_UnifiedPosition)
	end
end

function DoublePK_Choose_Show(isResult)
    if isResult > 0 then
        -- 身份确认结果
        DoublePK_Choose_IdentityResultShow()
    else
        -- 显示身份信息
        DoublePK_Choose_IdentityShow()
    end
    --if not this:IsVisible() then
    --    DoublePK_Choose_UnifiedPos()
    --end
    this:Show()
end

function DoublePK_Choose_IdentityShow()
    -- 通用处理
    DoublePK_Choose_IdentityUIRest()
    -- 获取玩家的ID
    local myguid = Player:GetGUID()
    -- 处理第一个人
    local guid,preidy,idy,name = DoublePK:GetIdentityInfo(DoublePK_Choose_Type.Type_A)
    if guid > 0 then
        if preidy == DoublePK_Choose_Identity.A then
            DoublePK_Choose_CtrlList[1].confirm:Show()
        elseif preidy == DoublePK_Choose_Identity.B then
            DoublePK_Choose_CtrlList[2].confirm:Show()
        end
    end
    -- 处理第二个人
    local guid2,preidy2,idy2,name2 = DoublePK:GetIdentityInfo(DoublePK_Choose_Type.Type_B)
    if guid2 > 0 then
        if preidy2 == DoublePK_Choose_Identity.A then
            DoublePK_Choose_CtrlList[1].confirm2:Show()
        elseif preidy2 == DoublePK_Choose_Identity.B then
            DoublePK_Choose_CtrlList[2].confirm2:Show()
        end
    end
    -- 进行相同的判定
    if guid > 0 and guid2 > 0 then
        if preidy == preidy2 and preidy > 0 then
            DoublePK_Choose_Gamer3Text:Show()
            if preidy == DoublePK_Choose_Identity.A then
                DoublePK_Choose_CtrlList[1].confirm:Show()
                DoublePK_Choose_CtrlList[1].confirm2:Show()
            elseif preidy == DoublePK_Choose_Identity.B then
                DoublePK_Choose_CtrlList[2].confirm:Show()
                DoublePK_Choose_CtrlList[2].confirm2:Show()
            end
        end
    end
    DoublePK_Choose_CtrlList[1].btn:Show()
    DoublePK_Choose_CtrlList[2].btn:Show()
end

function DoublePK_Choose_IdentityResultShow()
    DoublePK_Choose_IdentityUIRest()
    -- 获取玩家的ID
    local myguid = Player:GetGUID()

    -- 处理第一个人
    local guid,preidy,idy,name = DoublePK:GetIdentityInfo(DoublePK_Choose_Type.Type_A)
    if guid > 0 then
        if idy == DoublePK_Choose_Identity.A then
            DoublePK_Choose_CtrlList[1].confirm:Show()
        elseif idy == DoublePK_Choose_Identity.B then
            DoublePK_Choose_CtrlList[2].confirm:Show()
        end
    end
    -- 处理第二个人
    local guid2,preidy2,idy2,name2 = DoublePK:GetIdentityInfo(DoublePK_Choose_Type.Type_B)
    if guid2 > 0 then
        if idy2 == DoublePK_Choose_Identity.A then
            DoublePK_Choose_CtrlList[1].confirm2:Show()
        elseif idy2 == DoublePK_Choose_Identity.B then
            DoublePK_Choose_CtrlList[2].confirm2:Show()
        end
    end

    local mypreidy,myidy,myname = DoublePK:GetIdentityInfoByGuID(myguid)
    if mypreidy ~= nil and mypreidy > 0 then
        local data = DoublePK_Choose_Icon[myidy]
        if data ~= nil then
            DoublePK_Choose_GamerOK:SetProperty("Image", data.image)
        end
    end
    -- 进行相同的判定
    DoublePK_Choose_GamerOK:Show()
    DoublePK_Choose_TimeAnimate:Show()
    DoublePK_Choose_TimeAnimate:Play(true)
end

function DoublePK_Choose_IdentityUIRest()
    -- 通用处理
    --DoublePK_Choose_CtrlList[1].name:SetText("#{SRPK_230331_52}")
    --DoublePK_Choose_CtrlList[1].desc:SetText("#{SRPK_230331_54}")
    DoublePK_Choose_CtrlList[1].confirm:Hide()
    DoublePK_Choose_CtrlList[1].confirm2:Hide()
    DoublePK_Choose_CtrlList[1].btn:Hide()
    --DoublePK_Choose_CtrlList[2].name:SetText("#{SRPK_230331_51}")
    --DoublePK_Choose_CtrlList[2].desc:SetText("#{SRPK_230331_53}")
    DoublePK_Choose_CtrlList[2].confirm:Hide()
    DoublePK_Choose_CtrlList[2].confirm2:Hide()
    DoublePK_Choose_CtrlList[2].btn:Hide()
    DoublePK_Choose_GamerOK:Hide()
    DoublePK_Choose_Gamer3Text:Show()
    DoublePK_Choose_TimeAnimate:Hide()
end

-- 选择身份
function DoublePK_Choose_ClickSelect(nType)
    -- 确定身份情况
    if nType ~= DoublePK_Choose_Identity.A and nType ~= DoublePK_Choose_Identity.B then
        return
    end
    -- 判定是否相同的身份
    local myguid = Player:GetGUID()
    local preidy,idy,name = DoublePK:GetIdentityInfoByGuID(myguid)
    if preidy == nType then
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DoublePK_Choose_SvrScriptId)
        Set_XSCRIPT_Function_Name("PlayerSelectIdentity")
        Set_XSCRIPT_Parameter(0, nType)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end

function DoublePK_Choose_Hide()
    this:Hide()
end

-- 关闭按钮点击事件
function DoublePK_Choose_Clicked_Close()
    DoublePK_Choose_Hide()
end