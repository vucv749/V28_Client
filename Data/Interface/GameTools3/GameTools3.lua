--===================================================
-- 刷隐藏属性GM内部工具 V3.0
-- 雪舞[Q785055837] 2022-8-26 09:33:21
-- 优化重构版本 - 使用字符串传输方式
--===================================================
-- 服务端传输方式:
--   BeginUICommand(sceneId)
--   UICommand_AddString(sceneId, "值1,值2,值3,...,值32")
--   EndUICommand(sceneId)
--   DispatchUICommand(sceneId, selfId, 20220902)
-- 客户端接收:
--   Get_XParam_STR(0) -> "值1,值2,...,值32"
--   Split(str, ",") -> {值1, 值2, ..., 值32}
--===================================================

local g_GameTools3_Frame_UnifiedPosition
local MenPaiId = -1

--===================================================
-- 属性配置表
-- 顺序必须与服务端拼接字符串的顺序一致!
-- {编辑框编号, 服务端nType}
--===================================================
-- 服务端MDEX常量参考:
-- MDEX_MAX_HP=234  MDEX_STR=236  MDEX_SPR=237
-- MDEX_CON=238     MDEX_INT=239  MDEX_DEX=240
-- MDEX_WG=241      MDEX_NG=423   MDEX_WF=242
-- MDEX_NF=244      MDEX_HUIXINGONG=247  MDEX_HUIXINFANG=248
-- MDEX_ICE_ATTR=249    MDEX_FIRE_ATTR=250
-- MDEX_LIGHT_ATTR=251  MDEX_POSION_ATTR=252
-- MDEX_ICE_DEC=253     MDEX_FIRE_DEC=254
-- MDEX_LIGHT_DEC=255   MDEX_POSION_DEC=256
-- MDEX_ICE_SUB_DEC=257     MDEX_FIRE_SUB_DEC=258
-- MDEX_LIGHT_SUB_DEC=259   MDEX_POSION_SUB_DEC=260
-- MDEX_ICE_SUB_LIMIT=261   MDEX_FIRE_SUB_LIMIT=262
-- MDEX_LIGHT_SUB_LIMIT=263 MDEX_POSION_SUB_LIMIT=264
-- MDEX_HIT=246     MDEX_MISS=245
-- MDEX_CHUANCI_SH=266  MDEX_CHUANCI_JM=267
--===================================================
local ATTR_CONFIG = {
    {522, 44},  -- 血量(MAX_HP)
    {523, 45},  -- 力量(STR)
    {524, 46},  -- 灵气(SPR)
    {525, 47},  -- 体力(CON)
    {526, 48},  -- 定力(INT)
    {527, 49},  -- 身法(DEX)
    {528, 50},  -- 外功攻击(WG)
    {529, 51},  -- 内功攻击(NG)
    {530, 52},  -- 外功防御(WF)
    {531, 53},  -- 内功防御(NF)
    {532, 54},  -- 会心攻击(HUIXINGONG)
    {533, 55},  -- 会心防御(HUIXINFANG)
    {534, 56},  -- 冰攻(ICE_ATTR)
    {535, 57},  -- 火攻(FIRE_ATTR)
    {536, 58},  -- 玄攻(LIGHT_ATTR)
    {537, 59},  -- 毒攻(POSION_ATTR)
    {538, 60},  -- 冰抗(ICE_DEC)
    {539, 61},  -- 火抗(FIRE_DEC)
    {540, 62},  -- 玄抗(LIGHT_DEC)
    {541, 63},  -- 毒抗(POSION_DEC)
    {542, 64},  -- 减冰抗(ICE_SUB_DEC)
    {543, 65},  -- 减火抗(FIRE_SUB_DEC)
    {544, 66},  -- 减玄抗(LIGHT_SUB_DEC)
    {545, 67},  -- 减毒抗(POSION_SUB_DEC)
    {546, 68},  -- 减冰抗下限(ICE_SUB_LIMIT)
    {547, 69},  -- 减火抗下限(FIRE_SUB_LIMIT)
    {548, 70},  -- 减玄抗下限(LIGHT_SUB_LIMIT)
    {549, 71},  -- 减毒抗下限(POSION_SUB_LIMIT)
    {550, 72},  -- 命中(HIT)
    {551, 73},  -- 闪避(MISS)
    {552, 74},  -- 穿刺伤害(CHUANCI_SH)
    {553, 75},  -- 穿刺减免(CHUANCI_JM)
}

local ATTR_COUNT = 32  -- 属性总数，与ATTR_CONFIG长度一致

--===================================================
-- 通用工具函数
--===================================================

-- 获取目标玩家GUID，未选中则返回0并提示
local function GetTargetGuidSafe()
    local guid = GetTargetPlayerGUID()
    if guid == nil then
        PushDebugMessage("您还没有选择目标玩家，请先选中玩家头像！")
        return 0
    end
    return guid
end

-- 获取编辑框控件引用 (按编号)
local function GetEditBox(id)
    return _G["GameTools3_" .. id .. "Edix"]
end

-- 通用属性刷取: 发送XSCRIPT到服务端
local function SendAttrCommand(nType, index, value)
    local guid = GetTargetGuidSafe()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("GMToolType")
    Set_XSCRIPT_ScriptID(666666)
    Set_XSCRIPT_Parameter(0, nType)
    Set_XSCRIPT_Parameter(1, index)
    Set_XSCRIPT_Parameter(2, tonumber(value))
    Set_XSCRIPT_Parameter(3, guid)
    Set_XSCRIPT_ParamCount(4)
    Send_XSCRIPT()
end

-- 批量设置所有编辑框的值
local function SetAllEditBoxValues(value)
    for _, cfg in ATTR_CONFIG do
        local editBox = GetEditBox(cfg[1])
        if editBox then
            editBox:SetText(tostring(value))
        end
    end
end

-- 从服务端字符串刷新所有编辑框
-- 服务端通过 UICommand_AddString 传输逗号分隔的属性值字符串
-- 格式: "血量,力量,灵气,体力,...,穿刺减免"
-- 顺序与 ATTR_CONFIG 一一对应
local function RefreshFromServerString()
    local attrStr = Get_XParam_STR(0)
    if attrStr == nil or attrStr == "" then
        PushDebugMessage("服务端返回数据为空")
        return
    end
    local values = Split(attrStr, ",")
    for i, cfg in ATTR_CONFIG do
        local editBox = GetEditBox(cfg[1])
        if editBox and values[i] ~= nil then
            editBox:SetText(tostring(values[i]))
        end
    end
end

--===================================================
-- 生命周期函数
--===================================================

function GameTools3_PreLoad()
    this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("UPDATE_NOTIFY")
    this:RegisterEvent("ADJEST_UI_POS", false)
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED")

end

function GameTools3_OnLoad()
    g_GameTools3_Frame_UnifiedPosition = GameTools3_Frame:GetProperty("UnifiedPosition")
end

function GameTools3_OnEvent(event)
    if event == "UI_COMMAND" and arg0 == "202004273" then
        GameTools3_Init()
        GameTools3_FenYe3:SetCheck(1)
        this:Show()
    elseif event == "UI_COMMAND" and arg0 == "20220902" then
        -- 服务端通过字符串返回所有属性数据
        RefreshFromServerString()
        GameTools3_Init()
        this:Show()
    elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
        GameTools3_Frame_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
    end
end

function GameTools3_Init()
end

function GameTools3_Frame_On_ResetPos()
    GameTools3_Frame:SetProperty("UnifiedPosition", g_GameTools3_Frame_UnifiedPosition)
end

--===================================================
-- 动态生成属性操作函数
-- 为每个属性创建 GameTools3_XXX(index) 全局函数
-- XML中按钮事件调用: GameTools3_522(1) / GameTools3_522(2)
--===================================================
for _, cfg in ATTR_CONFIG do
    local editId  = cfg[1]
    local nType   = cfg[2]
    _G["GameTools3_" .. editId] = function(index)
        local editBox = GetEditBox(editId)
        if editBox then
            SendAttrCommand(nType, index, editBox:GetText())
        end
    end
end

--===================================================
-- 生效/取消/获取/归零/全满 操作
-- index: 1=生效 2=取消 3=获取 4=归零 5=全999999
--===================================================
function GameTools3_ShengXiao(index)
    if index == 4 then
        SetAllEditBoxValues(0)
        return
    elseif index == 5 then
        SetAllEditBoxValues(999999)
    end
    -- 1=生效 2=取消 3=获取 -> 发送到服务端
    local guid = GetTargetGuidSafe()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("GMToolType")
    Set_XSCRIPT_ScriptID(666666)
    Set_XSCRIPT_Parameter(0, 76)
    Set_XSCRIPT_Parameter(1, index)
    Set_XSCRIPT_Parameter(2, 0)
    Set_XSCRIPT_Parameter(3, guid)
    Set_XSCRIPT_ParamCount(4)
    Send_XSCRIPT()
end

function GameTools3_ListBox_Selected()
    local str
    str, MenPaiId = GameTools3_529Edix:GetCurrentSelect()
end

function GameTools3_ItemSelectChanged()
end

--===================================================
-- TAB分页切换
--===================================================
local TAB_UI_MAP = {
    [1] = 20200427,
    [2] = 202004272,
    -- [3] = 当前页(属性)，不切换
    [4] = 202004274,
    [5] = 202004275,
    [6] = 202004276,
    [7] = 316022021,
}

function GameTools3_ChangeTabIndex(nIndex)
    local nUI = TAB_UI_MAP[nIndex]
    if nUI then
        PushEvent("UI_COMMAND", nUI)
        this:Hide()
    end
end
