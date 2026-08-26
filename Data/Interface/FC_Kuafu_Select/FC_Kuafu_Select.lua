--- UI 相关
-- 界面的默认相对位置
local g_FC_Kuafu_Select_UnifiedXPosition
local g_FC_Kuafu_Select_UnifiedYPosition
local objCared = -1

local g_FC_Kuafu_Select_Texts
local g_FC_Kuafu_Select_Name = {
    { val = 20, [0] = "#{ZJKF_250331_33}", [1] = "#{ZJKF_250331_34}", [2] = "#{ZJKF_250331_35}", [3] = "#{ZJKF_250331_36}", [4] = "#{ZJKF_250331_53}"},
    { val = 50, [0] = "#{ZJKF_250331_29}", [1] = "#{ZJKF_250331_30}", [2] = "#{ZJKF_250331_31}", [3] = "#{ZJKF_250331_32}", [4] = "#{ZJKF_250331_52}"},
    { val = 200, [0] = "#{ZJKF_250331_25}", [1] = "#{ZJKF_250331_26}", [2] = "#{ZJKF_250331_27}", [3] = "#{ZJKF_250331_28}", [4] = "#{ZJKF_250331_51}"},
    { val = 10000, [0] = "#{ZJKF_250331_21}", [1] = "#{ZJKF_250331_22}", [2] = "#{ZJKF_250331_23}", [3] = "#{ZJKF_250331_24}", [4] = "#{ZJKF_250331_50}"},
    -- { val = 1, [0] = "#{ZJKF_250331_33}", [1] = "#{ZJKF_250331_34}", [2] = "#{ZJKF_250331_35}", [3] = "#{ZJKF_250331_36}", [4] = "#{ZJKF_250331_53}"},
    -- { val = 2, [0] = "#{ZJKF_250331_29}", [1] = "#{ZJKF_250331_30}", [2] = "#{ZJKF_250331_31}", [3] = "#{ZJKF_250331_32}", [4] = "#{ZJKF_250331_52}"},
    -- { val = 3, [0] = "#{ZJKF_250331_25}", [1] = "#{ZJKF_250331_26}", [2] = "#{ZJKF_250331_27}", [3] = "#{ZJKF_250331_28}", [4] = "#{ZJKF_250331_51}"},
    -- { val = 4, [0] = "#{ZJKF_250331_21}", [1] = "#{ZJKF_250331_22}", [2] = "#{ZJKF_250331_23}", [3] = "#{ZJKF_250331_24}", [4] = "#{ZJKF_250331_50}"},
}

-- 常量
local g_LevelLimit = 65
local g_ServerScriptId = 999781
local g_ServerFuncName = "Trans"
-- 玩家数据
local g_CaredNPCId

--- default funcs 
function FC_Kuafu_Select_PreLoad()
    -- this:RegisterEvent("UI_COMMAND")
    -- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	--离开场景，自动关闭
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
    -- 打开界面
    this:RegisterEvent("GE_ZJC_ENTRY_UI_SHOW")
end

function FC_Kuafu_Select_OnLoad()
    -- 保存界面的默认相对位置
	g_FC_Kuafu_Select_UnifiedXPosition	= FC_Kuafu_Select_Frame:GetProperty("UnifiedXPosition")
    g_FC_Kuafu_Select_UnifiedYPosition	= FC_Kuafu_Select_Frame:GetProperty("UnifiedYPosition")

    FC_Kuafu_Select_DragTitle:SetText("#{ZJKF_250331_19}")

    g_FC_Kuafu_Select_Texts = {
        [0] = FC_Kuafu_Select_SelectServerBtn1Text,
        [1] = FC_Kuafu_Select_SelectServerBtn2Text,
        [2] = FC_Kuafu_Select_SelectServerBtn3Text,
        [3] = FC_Kuafu_Select_SelectServerBtn4Text,
        [4] = FC_Kuafu_Select_SelectServerBtn5Text,
        [5] = FC_Kuafu_Select_SelectServerBtn6Text,
        [6] = FC_Kuafu_Select_SelectServerBtn7Text,
        [7] = FC_Kuafu_Select_SelectServerBtn8Text,
        [8] = FC_Kuafu_Select_SelectServerBtn9Text,
        [9] = FC_Kuafu_Select_SelectServerBtn10Text,
        [10] = FC_Kuafu_Select_SelectServerBtn11Text,
        [11] = FC_Kuafu_Select_SelectServerBtn12Text,
        [12] = FC_Kuafu_Select_SelectServerBtn13Text,
        [13] = FC_Kuafu_Select_SelectServerBtn14Text,
        [14] = FC_Kuafu_Select_SelectServerBtn15Text,
        [15] = FC_Kuafu_Select_SelectServerBtn16Text,
        [16] = FC_Kuafu_Select_SelectServerBtn17Text,
        [17] = FC_Kuafu_Select_SelectServerBtn18Text,
        [18] = FC_Kuafu_Select_SelectServerBtn19Text,
        [19] = FC_Kuafu_Select_SelectServerBtn20Text,
    }
end

function FC_Kuafu_Select_OnEvent(event)
    if event == "GE_ZJC_ENTRY_UI_SHOW" then
        g_CaredNPCId = tonumber(arg0)
        if g_CaredNPCId and g_CaredNPCId > 0 then
            objCared = DataPool:GetNPCIDByServerID(g_CaredNPCId)
            this:CareObject(objCared, 1, "FC_Kuafu_Select")
        end

        for i = 0, 19 do
            local num = Lua_GetZJCPlayerNum(i)
            for _, v in ipairs (g_FC_Kuafu_Select_Name) do
                if num <= v.val then
                    local str = v[math.mod(i, 5)]
                    g_FC_Kuafu_Select_Texts[i]:SetText(str)
                    break
                end
            end
        end

        this:Show()
    -- 游戏窗口尺寸发生了变化
	elseif event == "ADJEST_UI_POS" then
		FC_Kuafu_Select_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		FC_Kuafu_Select_On_ResetPos()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide();
    end
end
--- default end

--- ui funcs
-- 关闭
function FC_Kuafu_Select_Close()
    this:CareObject(objCared, 0, "FC_Kuafu_Select")
    this:Hide()
end

-- 进入场景
function FC_Kuafu_Select_Entry(idx)
    Clear_XSCRIPT()
        Set_XSCRIPT_Function_Name(g_ServerFuncName)
        Set_XSCRIPT_ScriptID(g_ServerScriptId)
        Set_XSCRIPT_Parameter(0, idx)
        Set_XSCRIPT_Parameter(1, g_CaredNPCId)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end
--- ui end

--- func 2 func
function FC_Kuafu_Select_On_ResetPos()
	FC_Kuafu_Select_Frame:SetProperty("UnifiedXPosition", g_FC_Kuafu_Select_UnifiedXPosition);
	FC_Kuafu_Select_Frame:SetProperty("UnifiedYPosition", g_FC_Kuafu_Select_UnifiedYPosition);
end
