--===================================================
-- À¢“˛≤ÿ Ù–‘GMƒ⁄≤øπ§æﬂ V3.0
-- —©ŒË[Q785055837] 2022-8-26 09:33:21
-- ”≈ªØ÷ÿππ∞Ê±æ -  π”√◊÷∑˚¥Æ¥´ ‰∑Ω Ω
--===================================================
-- ∑˛ŒÒ∂À¥´ ‰∑Ω Ω:
--   BeginUICommand(sceneId)
--   UICommand_AddString(sceneId, "÷µ1,÷µ2,÷µ3,...,÷µ32")
--   EndUICommand(sceneId)
--   DispatchUICommand(sceneId, selfId, 20220902)
-- øÕªß∂ÀΩ” †:
--   Get_XParam_STR(0) -> "÷µ1,÷µ2,...,÷µ32"
--   Split(str, ",") -> {÷µ1, ÷µ2, ..., ÷µ32}
--===================================================

local g_GameTools3_Frame_UnifiedPosition
local MenPaiId = -1

--===================================================
--  Ù–‘≈‰÷√±Ì
-- À≥–Ú±ÿ–Î”Î∑˛ŒÒ∂À∆¥Ω”◊÷∑˚¥ÆµƒÀ≥–Ú“ª÷¬!
-- {±‡º≠øÚ±‡∫≈, ∑˛ŒÒ∂ÀnType}
--===================================================
-- ∑˛ŒÒ∂ÀMDEX≥£¡ø≤Œøº:
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
    {522, 44},  -- ??(MAX_HP)
    {523, 45},  -- ??(STR)
    {524, 46},  -- ??(SPR)
    {525, 47},  -- ??(CON)
    {526, 48},  -- ??(INT)
    {527, 49},  -- ??(DEX)
    {528, 50},  -- ????(WG)
    {529, 51},  -- ????(NG)
    {530, 52},  -- ????(WF)
    {531, 53},  -- ????(NF)
    {532, 54},  -- ????(HUIXINGONG)
    {533, 55},  -- ????(HUIXINFANG)
    {534, 56},  -- ??(ICE_ATTR)
    {535, 57},  -- ??(FIRE_ATTR)
    {536, 58},  -- ??(LIGHT_ATTR)
    {537, 59},  -- ??(POSION_ATTR)
    {538, 60},  -- ??(ICE_DEC)
    {539, 61},  -- ??(FIRE_DEC)
    {540, 62},  -- ??(LIGHT_DEC)
    {541, 63},  -- ??(POSION_DEC)
    {542, 64},  -- ???(ICE_SUB_DEC)
    {543, 65},  -- ???(FIRE_SUB_DEC)
    {544, 66},  -- ???(LIGHT_SUB_DEC)
    {545, 67},  -- ???(POSION_SUB_DEC)
    {546, 68},  -- ?????(ICE_SUB_LIMIT)
    {547, 69},  -- ?????(FIRE_SUB_LIMIT)
    {548, 70},  -- ?????(LIGHT_SUB_LIMIT)
    {549, 71},  -- ?????(POSION_SUB_LIMIT)
    {550, 72},  -- ??(HIT)
    {551, 73},  -- ??(MISS)
    {552, 74},  -- ????(CHUANCI_SH)
    {553, 75},  -- ????(CHUANCI_JM)
}

local ATTR_COUNT = 32  -- ????,?ATTR_CONFIG????

--===================================================
-- Õ®”√π§æﬂ∫Ø ˝
--===================================================

-- ªÒ»°ƒø±ÍÕÊº“GUID£¨Œ¥—°÷–‘Ú∑µªÿ0≤¢Ã· æ
local function GetTargetGuidSafe()
    local guid = GetTargetPlayerGUID()
    if guid == nil then
        PushDebugMessage("NhÁm cÚn khÙng cÛ lÒa ch˜n m¯c tiÍu ngﬂ∂i chΩi, ThÔnh TiÍn lÒa ch˜n ngﬂ∂i chΩi hÏnh c·i •u!")
        return 0
    end
    return guid
end

-- ªÒ»°±‡º≠øÚøÿº˛“˝”√ (∞¥±‡∫≈)
local function GetEditBox(id)
    return _G["GameTools3_" .. id .. "Edix"]
end

-- Õ®”√ Ù–‘À¢»°: ∑¢ÀÕXSCRIPTµΩ∑˛ŒÒ∂À
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

-- ≈˙¡ø…Ë÷√À˘”–±‡º≠øÚµƒ÷µ
local function SetAllEditBoxValues(value)
    for _, cfg in ATTR_CONFIG do
        local editBox = GetEditBox(cfg[1])
        if editBox then
            editBox:SetText(tostring(value))
        end
    end
end

-- ¥”∑˛ŒÒ∂À◊÷∑˚¥ÆÀ¢–¬À˘”–±‡º≠øÚ
-- ∑˛ŒÒ∂ÀÕ®π˝ UICommand_AddString ¥´ ‰∂∫∫≈∑÷∏Ùµƒ Ù–‘÷µ◊÷∑˚¥Æ
-- ∏Ò Ω: "—™¡ø,¡¶¡ø,¡È∆¯,ÃÂ¡¶,...,¥©¥Ãºı√‚"
-- À≥–Ú”Î ATTR_CONFIG “ª“ª∂‘”¶
local function RefreshFromServerString()
    local attrStr = Get_XParam_STR(0)
    if attrStr == nil or attrStr == "" then
        PushDebugMessage("Ph¯c v¯ –oan ph‰n h∞i sØ liÆu Vi KhÙng")
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
-- …˙√¸÷‹∆⁄∫Ø ˝
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
        -- ∑˛ŒÒ∂ÀÕ®π˝◊÷∑˚¥Æ∑µªÿÀ˘”– Ù–‘ ˝æ›
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
-- ∂ØÃ¨…˙≥… Ù–‘≤Ÿ◊˜∫Ø ˝
-- Œ™√ø∏ˆ Ù–‘¥¥Ω® GameTools3_XXX(index) »´æ÷∫Ø ˝
-- XML÷–∞¥≈• ¬º˛µ˜”√: GameTools3_522(1) / GameTools3_522(2)
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
-- …˙–ß/»°œ˚/ªÒ»°/πÈ¡„/»´¬˙ ≤Ÿ◊˜
-- index: 1=…˙–ß 2=»°œ˚ 3=ªÒ»° 4=πÈ¡„ 5=»´999999
--===================================================
function GameTools3_ShengXiao(index)
    if index == 4 then
        SetAllEditBoxValues(0)
        return
    elseif index == 5 then
        SetAllEditBoxValues(999999)
    end
    -- 1=…˙–ß 2=»°œ˚ 3=ªÒ»° -> ∑¢ÀÕµΩ∑˛ŒÒ∂À
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
-- TAB∑÷“≥«–ªª
--===================================================
local TAB_UI_MAP = {
    [1] = 20200427,
    [2] = 202004272,
    -- [3] = µ±«∞“≥( Ù–‘)£¨≤ª«–ªª
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
