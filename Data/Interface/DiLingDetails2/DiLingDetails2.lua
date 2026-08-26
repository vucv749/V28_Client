-- 帝陵再现PVP活动 场景选择UI（帝陵深渊场景）
local DiLingDetails2_SvrScriptId = 998260
local DiLingDetails2_Select1_ScenDataIndex_Begin = 1        -- ?????????????
local DiLingDetails2_Select1_ScenDataIndex_End = 5          -- ?????????????
local DiLingDetails2_Select2_ScenDataIndex_Begin = 6        -- ?????????????
local DiLingDetails2_Select2_ScenDataIndex_End = 10         -- ?????????????
local DiLingDetails2_Select3_ScenDataIndex_Begin = 11       -- ?????????????
local DiLingDetails2_Select3_ScenDataIndex_End = 15         -- ?????????????
local DiLingDetails2_Select4_ScenDataIndex_Begin = 16       -- ?????????????
local DiLingDetails2_Select4_ScenDataIndex_End = 20         -- ?????????????
local DiLingDetails2_Select5_ScenDataIndex_Begin = 21       -- ?????????????
local DiLingDetails2_Select5_ScenDataIndex_End = 25         -- ?????????????
local DiLingDetails2_MaxPlayerNum = 500                     -- ???????
local DiLingDetails2_PlayerNum_VeryGood = 20                -- ????(??)
local DiLingDetails2_PlayerNum_Good = 50                    -- ????(??)
local DiLingDetails2_PlayerNum_Busy = 100                   -- ????(??)
-- 关注NPC
local DiLingDetails2_CareObjId = -1
local DiLingDetails2_CareObjSvrId = -1
local DiLingDetails2_MAX_OBJ_DISTANCE = 5.0
-- 默认位置
local DiLingDetails2_UnifiedPosition = nil
-- 控件表
local DiLingDetails2_CtrlList = nil

-- 场景等级段
local DiLingDetails2_SceneLevel =
{
    [1] = {level_begin = 60, level_end = 69},       -- 60~69?
    [2] = {level_begin = 60, level_end = 89},       -- 60~89?
    [3] = {level_begin = 60, level_end = 119},      -- 60~119?
} -- end DiLingDetails2_SceneLevel

-- 按钮文本字典表
local DiLingDetails2_BtnTextList =
{
    -- 青龙
    select1 = 
    {
        [1] = {"#{DLZX_230314_29}", "#{DLZX_230314_49}", "#{DLZX_230314_69}", "#{DLZX_230314_89}"},   -- ??1
        [2] = {"#{DLZX_230314_30}", "#{DLZX_230314_50}", "#{DLZX_230314_70}", "#{DLZX_230314_90}"},   -- ??2
        [3] = {"#{DLZX_230314_31}", "#{DLZX_230314_51}", "#{DLZX_230314_71}", "#{DLZX_230314_91}"},   -- ??3
        [4] = {"#{DLZX_230314_32}", "#{DLZX_230314_52}", "#{DLZX_230314_72}", "#{DLZX_230314_92}"},   -- ??4
        [5] = {"#{DLZX_230314_33}", "#{DLZX_230314_53}", "#{DLZX_230314_73}", "#{DLZX_230314_93}"},   -- ??5
    },
    -- 白虎
    select2 =
    {
        [1] = {"#{DLZX_230314_39}", "#{DLZX_230314_59}", "#{DLZX_230314_79}", "#{DLZX_230314_99}"},   -- ??1
        [2] = {"#{DLZX_230314_40}", "#{DLZX_230314_60}", "#{DLZX_230314_80}", "#{DLZX_230314_100}"},  -- ??2
        [3] = {"#{DLZX_230314_41}", "#{DLZX_230314_61}", "#{DLZX_230314_81}", "#{DLZX_230314_101}"},  -- ??3
        [4] = {"#{DLZX_230314_42}", "#{DLZX_230314_62}", "#{DLZX_230314_82}", "#{DLZX_230314_102}"},  -- ??4
        [5] = {"#{DLZX_230314_43}", "#{DLZX_230314_63}", "#{DLZX_230314_83}", "#{DLZX_230314_103}"},  -- ??5
    },
    -- 朱雀
    select3 = 
    {
        [1] = {"#{DLZX_230314_34}", "#{DLZX_230314_54}", "#{DLZX_230314_74}", "#{DLZX_230314_94}"},   -- ??1
        [2] = {"#{DLZX_230314_35}", "#{DLZX_230314_55}", "#{DLZX_230314_75}", "#{DLZX_230314_95}"},   -- ??2
        [3] = {"#{DLZX_230314_36}", "#{DLZX_230314_56}", "#{DLZX_230314_76}", "#{DLZX_230314_96}"},   -- ??3
        [4] = {"#{DLZX_230314_37}", "#{DLZX_230314_57}", "#{DLZX_230314_77}", "#{DLZX_230314_97}"},   -- ??4
        [5] = {"#{DLZX_230314_38}", "#{DLZX_230314_58}", "#{DLZX_230314_78}", "#{DLZX_230314_98}"},   -- ??5
    },
    -- 玄武
    select4 = 
    {
        [1] = {"#{DLZX_230314_44}", "#{DLZX_230314_64}", "#{DLZX_230314_84}", "#{DLZX_230314_104}"},   -- ??1
        [2] = {"#{DLZX_230314_45}", "#{DLZX_230314_65}", "#{DLZX_230314_85}", "#{DLZX_230314_105}"},   -- ??2
        [3] = {"#{DLZX_230314_46}", "#{DLZX_230314_66}", "#{DLZX_230314_86}", "#{DLZX_230314_106}"},   -- ??3
        [4] = {"#{DLZX_230314_47}", "#{DLZX_230314_67}", "#{DLZX_230314_87}", "#{DLZX_230314_107}"},   -- ??4
        [5] = {"#{DLZX_230314_48}", "#{DLZX_230314_68}", "#{DLZX_230314_88}", "#{DLZX_230314_108}"},   -- ??5
    },
    -- 麒麟
    select5 =
    {
        [1] = {"#{DLZX_230518_121}", "#{DLZX_230518_130}", "#{DLZX_230518_135}", "#{DLZX_230518_140}"},   -- ??1
        [2] = {"#{DLZX_230518_122}", "#{DLZX_230518_131}", "#{DLZX_230518_136}", "#{DLZX_230518_141}"},   -- ??2
        [3] = {"#{DLZX_230518_123}", "#{DLZX_230518_132}", "#{DLZX_230518_137}", "#{DLZX_230518_142}"},   -- ??3
        [4] = {"#{DLZX_230518_124}", "#{DLZX_230518_133}", "#{DLZX_230518_138}", "#{DLZX_230518_143}"},   -- ??4
        [5] = {"#{DLZX_230518_125}", "#{DLZX_230518_134}", "#{DLZX_230518_139}", "#{DLZX_230518_144}"},   -- ??5
    },
} -- end DiLingDetails2_BtnTextList



function DiLingDetails2_PreLoad()
    this:RegisterEvent("DLZXPVP_OPEN_DLSY", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func DiLingDetails2_PreLoad()

function DiLingDetails2_OnEvent(event)
    if (event == "DLZXPVP_OPEN_DLSY") then
        if (not this:IsVisible()) then
            DiLingDetails2_BeginCareObject(arg0, arg1)
            DiLingDetails2_UpdateSceneInfo(arg2)
            DiLingDetails2_Show()
        end
    elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(DiLingDetails2_CareObjId < 0 or tonumber(arg0) ~= DiLingDetails2_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            DiLingDetails2_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DiLingDetails2_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DiLingDetails2_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DiLingDetails2_UnifiedPos()
	end
end -- end func DiLingDetails2_OnEvent()

function DiLingDetails2_OnLoad()
	DiLingDetails2_UnifiedPosition = DiLingDetails2_Frame:GetProperty("UnifiedPosition")
	DiLingDetails2_InitCtrlList()
end -- end func DiLingDetails2_OnLoad()

function DiLingDetails2_InitCtrlList()
    if (DiLingDetails2_CtrlList ~= nil) then
        DiLingDetails2_CtrlList = nil
    end

    DiLingDetails2_CtrlList = {}
    DiLingDetails2_CtrlList.btnctrl = {}
    -- 青龙
    DiLingDetails2_CtrlList.btnctrl.select1 = {}
    DiLingDetails2_CtrlList.btnctrl.select1[1] = {}
    DiLingDetails2_CtrlList.btnctrl.select1[1].btn = DiLingDetails2_Select1_Shenyuan1
    DiLingDetails2_CtrlList.btnctrl.select1[1].btntxt = DiLingDetails2_Select1_Shenyuan1_Text
    DiLingDetails2_CtrlList.btnctrl.select1[1].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select1[2] = {}
    DiLingDetails2_CtrlList.btnctrl.select1[2].btn = DiLingDetails2_Select1_Shenyuan2
    DiLingDetails2_CtrlList.btnctrl.select1[2].btntxt = DiLingDetails2_Select1_Shenyuan2_Text
    DiLingDetails2_CtrlList.btnctrl.select1[2].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select1[3] = {}
    DiLingDetails2_CtrlList.btnctrl.select1[3].btn = DiLingDetails2_Select1_Shenyuan3
    DiLingDetails2_CtrlList.btnctrl.select1[3].btntxt = DiLingDetails2_Select1_Shenyuan3_Text
    DiLingDetails2_CtrlList.btnctrl.select1[3].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select1[4] = {}
    DiLingDetails2_CtrlList.btnctrl.select1[4].btn = DiLingDetails2_Select1_Shenyuan4
    DiLingDetails2_CtrlList.btnctrl.select1[4].btntxt = DiLingDetails2_Select1_Shenyuan4_Text
    DiLingDetails2_CtrlList.btnctrl.select1[4].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select1[5] = {}
    DiLingDetails2_CtrlList.btnctrl.select1[5].btn = DiLingDetails2_Select1_Shenyuan5
    DiLingDetails2_CtrlList.btnctrl.select1[5].btntxt = DiLingDetails2_Select1_Shenyuan5_Text
    DiLingDetails2_CtrlList.btnctrl.select1[5].btnani = nil
    -- 白虎
    DiLingDetails2_CtrlList.btnctrl.select2 = {}
    DiLingDetails2_CtrlList.btnctrl.select2[1] = {}
    DiLingDetails2_CtrlList.btnctrl.select2[1].btn = DiLingDetails2_Select2_Shenyuan1
    DiLingDetails2_CtrlList.btnctrl.select2[1].btntxt = DiLingDetails2_Select2_Shenyuan1_Text
    DiLingDetails2_CtrlList.btnctrl.select2[1].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select2[2] = {}
    DiLingDetails2_CtrlList.btnctrl.select2[2].btn = DiLingDetails2_Select2_Shenyuan2
    DiLingDetails2_CtrlList.btnctrl.select2[2].btntxt = DiLingDetails2_Select2_Shenyuan2_Text
    DiLingDetails2_CtrlList.btnctrl.select2[2].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select2[3] = {}
    DiLingDetails2_CtrlList.btnctrl.select2[3].btn = DiLingDetails2_Select2_Shenyuan3
    DiLingDetails2_CtrlList.btnctrl.select2[3].btntxt = DiLingDetails2_Select2_Shenyuan3_Text
    DiLingDetails2_CtrlList.btnctrl.select2[3].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select2[4] = {}
    DiLingDetails2_CtrlList.btnctrl.select2[4].btn = DiLingDetails2_Select2_Shenyuan4
    DiLingDetails2_CtrlList.btnctrl.select2[4].btntxt = DiLingDetails2_Select2_Shenyuan4_Text
    DiLingDetails2_CtrlList.btnctrl.select2[4].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select2[5] = {}
    DiLingDetails2_CtrlList.btnctrl.select2[5].btn = DiLingDetails2_Select2_Shenyuan5
    DiLingDetails2_CtrlList.btnctrl.select2[5].btntxt = DiLingDetails2_Select2_Shenyuan5_Text
    DiLingDetails2_CtrlList.btnctrl.select2[5].btnani = nil
    -- 朱雀
    DiLingDetails2_CtrlList.btnctrl.select3 = {}
    DiLingDetails2_CtrlList.btnctrl.select3[1] = {}
    DiLingDetails2_CtrlList.btnctrl.select3[1].btn = DiLingDetails2_Select3_Shenyuan1
    DiLingDetails2_CtrlList.btnctrl.select3[1].btntxt = DiLingDetails2_Select3_Shenyuan1_Text
    DiLingDetails2_CtrlList.btnctrl.select3[1].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select3[2] = {}
    DiLingDetails2_CtrlList.btnctrl.select3[2].btn = DiLingDetails2_Select3_Shenyuan2
    DiLingDetails2_CtrlList.btnctrl.select3[2].btntxt = DiLingDetails2_Select3_Shenyuan2_Text
    DiLingDetails2_CtrlList.btnctrl.select3[2].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select3[3] = {}
    DiLingDetails2_CtrlList.btnctrl.select3[3].btn = DiLingDetails2_Select3_Shenyuan3
    DiLingDetails2_CtrlList.btnctrl.select3[3].btntxt = DiLingDetails2_Select3_Shenyuan3_Text
    DiLingDetails2_CtrlList.btnctrl.select3[3].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select3[4] = {}
    DiLingDetails2_CtrlList.btnctrl.select3[4].btn = DiLingDetails2_Select3_Shenyuan4
    DiLingDetails2_CtrlList.btnctrl.select3[4].btntxt = DiLingDetails2_Select3_Shenyuan4_Text
    DiLingDetails2_CtrlList.btnctrl.select3[4].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select3[5] = {}
    DiLingDetails2_CtrlList.btnctrl.select3[5].btn = DiLingDetails2_Select3_Shenyuan5
    DiLingDetails2_CtrlList.btnctrl.select3[5].btntxt = DiLingDetails2_Select3_Shenyuan5_Text
    DiLingDetails2_CtrlList.btnctrl.select3[5].btnani = nil
    -- 玄武
    DiLingDetails2_CtrlList.btnctrl.select4 = {}
    DiLingDetails2_CtrlList.btnctrl.select4[1] = {}
    DiLingDetails2_CtrlList.btnctrl.select4[1].btn = DiLingDetails2_Select4_Shenyuan1
    DiLingDetails2_CtrlList.btnctrl.select4[1].btntxt = DiLingDetails2_Select4_Shenyuan1_Text
    DiLingDetails2_CtrlList.btnctrl.select4[1].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select4[2] = {}
    DiLingDetails2_CtrlList.btnctrl.select4[2].btn = DiLingDetails2_Select4_Shenyuan2
    DiLingDetails2_CtrlList.btnctrl.select4[2].btntxt = DiLingDetails2_Select4_Shenyuan2_Text
    DiLingDetails2_CtrlList.btnctrl.select4[2].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select4[3] = {}
    DiLingDetails2_CtrlList.btnctrl.select4[3].btn = DiLingDetails2_Select4_Shenyuan3
    DiLingDetails2_CtrlList.btnctrl.select4[3].btntxt = DiLingDetails2_Select4_Shenyuan3_Text
    DiLingDetails2_CtrlList.btnctrl.select4[3].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select4[4] = {}
    DiLingDetails2_CtrlList.btnctrl.select4[4].btn = DiLingDetails2_Select4_Shenyuan4
    DiLingDetails2_CtrlList.btnctrl.select4[4].btntxt = DiLingDetails2_Select4_Shenyuan4_Text
    DiLingDetails2_CtrlList.btnctrl.select4[4].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select4[5] = {}
    DiLingDetails2_CtrlList.btnctrl.select4[5].btn = DiLingDetails2_Select4_Shenyuan5
    DiLingDetails2_CtrlList.btnctrl.select4[5].btntxt = DiLingDetails2_Select4_Shenyuan5_Text
    DiLingDetails2_CtrlList.btnctrl.select4[5].btnani = nil
    -- 麒麟
    DiLingDetails2_CtrlList.btnctrl.select5 = {}
    DiLingDetails2_CtrlList.btnctrl.select5[1] = {}
    DiLingDetails2_CtrlList.btnctrl.select5[1].btn = DiLingDetails2_Select5_Shenyuan1
    DiLingDetails2_CtrlList.btnctrl.select5[1].btntxt = DiLingDetails2_Select5_Shenyuan1_Text
    DiLingDetails2_CtrlList.btnctrl.select5[1].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select5[2] = {}
    DiLingDetails2_CtrlList.btnctrl.select5[2].btn = DiLingDetails2_Select5_Shenyuan2
    DiLingDetails2_CtrlList.btnctrl.select5[2].btntxt = DiLingDetails2_Select5_Shenyuan2_Text
    DiLingDetails2_CtrlList.btnctrl.select5[2].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select5[3] = {}
    DiLingDetails2_CtrlList.btnctrl.select5[3].btn = DiLingDetails2_Select5_Shenyuan3
    DiLingDetails2_CtrlList.btnctrl.select5[3].btntxt = DiLingDetails2_Select5_Shenyuan3_Text
    DiLingDetails2_CtrlList.btnctrl.select5[3].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select5[4] = {}
    DiLingDetails2_CtrlList.btnctrl.select5[4].btn = DiLingDetails2_Select5_Shenyuan4
    DiLingDetails2_CtrlList.btnctrl.select5[4].btntxt = DiLingDetails2_Select5_Shenyuan4_Text
    DiLingDetails2_CtrlList.btnctrl.select5[4].btnani = nil
    DiLingDetails2_CtrlList.btnctrl.select5[5] = {}
    DiLingDetails2_CtrlList.btnctrl.select5[5].btn = DiLingDetails2_Select5_Shenyuan5
    DiLingDetails2_CtrlList.btnctrl.select5[5].btntxt = DiLingDetails2_Select5_Shenyuan5_Text
    DiLingDetails2_CtrlList.btnctrl.select5[5].btnani = nil
end -- end func DiLingDetails2_InitCtrlList()

-- 界面默认位置
function DiLingDetails2_UnifiedPos()
	if (DiLingDetails2_UnifiedPosition ~= nil) then
		DiLingDetails2_Frame:SetProperty("UnifiedPosition", DiLingDetails2_UnifiedPosition)
	end
end -- end func DiLingDetails2_UnifiedPos()

-- 开启NPC关注
function DiLingDetails2_BeginCareObject(objSvrId, objId)
	DiLingDetails2_CareObjId = tonumber(objId)
    if (DiLingDetails2_CareObjId >= 0) then
        DiLingDetails2_CareObjSvrId = tonumber(objSvrId)
        DiLingDetails2_TargetNPC = tonumber(objSvrId)
        this:CareObject(DiLingDetails2_CareObjId, 1, "DiLingDetails2")
    else
        DiLingDetails2_CareObjId = -1
        DiLingDetails2_CareObjSvrId = -1
	end
end -- end func DiLingDetails2_BeginCareObject()

-- 取消NPC关注
function DiLingDetails2_StopCareObject()
	if (DiLingDetails2_CareObjId >= 0) then
		this:CareObject(DiLingDetails2_CareObjId, 0, "DiLingDetails2")
		DiLingDetails2_CareObjId = -1
        DiLingDetails2_CareObjSvrId = -1
    else
        DiLingDetails2_CareObjId = -1
        DiLingDetails2_CareObjSvrId = -1
	end
end -- end func DiLingDetails2_StopCareObject()

function DiLingDetails2_Show()
    this:Show()
end -- end func DiLingDetails2_Show()

function DiLingDetails2_Hide()
    DiLingDetails2_StopCareObject()
    this:Hide()
end -- end func DiLingDetails2_Hide()

-- 关睜按钮点击事件
function DiLingDetails2_Clicked_Close()
    DiLingDetails2_Hide()
end -- end func DiLingDetails2_Clicked_Close()

-- 返回帝陵再现场景选择UI
function DiLingDetails2_OpenDiLingDetails()
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryOpenDLZXSceneChooseUI")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()

    DiLingDetails2_Hide()
end -- end func DiLingDetails2_OpenDiLingDetails()

-- 场景按钮点击事件1
function DiLingDetails2_Clicked_Select1(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails2_Select1_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails2_Select1_ScenDataIndex_Begin or sceneIndex > DiLingDetails2_Select1_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData_DLSY(sceneIndex - 1)
    if (playerNum >= DiLingDetails2_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_DLSY")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails2_Clicked_Select1()

-- 场景按钮点击事件2
function DiLingDetails2_Clicked_Select2(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails2_Select2_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails2_Select2_ScenDataIndex_Begin or sceneIndex > DiLingDetails2_Select2_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData_DLSY(sceneIndex - 1)
    if (playerNum >= DiLingDetails2_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_DLSY")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails2_Clicked_Select2()

-- 场景按钮点击事件3
function DiLingDetails2_Clicked_Select3(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails2_Select3_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails2_Select3_ScenDataIndex_Begin or sceneIndex > DiLingDetails2_Select3_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData_DLSY(sceneIndex - 1)
    if (playerNum >= DiLingDetails2_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_DLSY")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails2_Clicked_Select3()

-- 场景按钮点击事件4
function DiLingDetails2_Clicked_Select4(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails2_Select4_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails2_Select4_ScenDataIndex_Begin or sceneIndex > DiLingDetails2_Select4_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData_DLSY(sceneIndex - 1)
    if (playerNum >= DiLingDetails2_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_DLSY")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails2_Clicked_Select4()

-- 场景按钮点击事件5
function DiLingDetails2_Clicked_Select5(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails2_Select5_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails2_Select5_ScenDataIndex_Begin or sceneIndex > DiLingDetails2_Select5_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData_DLSY(sceneIndex - 1)
    if (playerNum >= DiLingDetails2_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails2_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_DLSY")
        Set_XSCRIPT_Parameter(0, DiLingDetails2_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails2_Clicked_Select5()

-- 刷新按钮信息
function DiLingDetails2_UpdateSceneInfo(sceneFlag)
    if (DiLingDetails2_CtrlList == nil) then
        DiLingDetails2_InitCtrlList()
    end

    local btnIndexBegin = -1
    local btnIndexEnd = -1
    local btnTbl = nil
    local txtTbl = nil

    local enterFlag = -1
    if (sceneFlag ~= nil) then
        enterFlag = tonumber(sceneFlag)
    end

    -- select1
    btnIndexBegin = DiLingDetails2_Select1_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails2_Select1_ScenDataIndex_End
    btnTbl = DiLingDetails2_CtrlList.btnctrl.select1
    txtTbl = DiLingDetails2_BtnTextList.select1
    DiLingDetails2_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl, enterFlag)

    -- select2
    btnIndexBegin = DiLingDetails2_Select2_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails2_Select2_ScenDataIndex_End
    btnTbl = DiLingDetails2_CtrlList.btnctrl.select2
    txtTbl = DiLingDetails2_BtnTextList.select2
    DiLingDetails2_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl, enterFlag)

    -- select3
    btnIndexBegin = DiLingDetails2_Select3_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails2_Select3_ScenDataIndex_End
    btnTbl = DiLingDetails2_CtrlList.btnctrl.select3
    txtTbl = DiLingDetails2_BtnTextList.select3
    DiLingDetails2_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl, enterFlag)

    -- select4
    btnIndexBegin = DiLingDetails2_Select4_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails2_Select4_ScenDataIndex_End
    btnTbl = DiLingDetails2_CtrlList.btnctrl.select4
    txtTbl = DiLingDetails2_BtnTextList.select4
    DiLingDetails2_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl, enterFlag)

    -- select5
    btnIndexBegin = DiLingDetails2_Select5_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails2_Select5_ScenDataIndex_End
    btnTbl = DiLingDetails2_CtrlList.btnctrl.select5
    txtTbl = DiLingDetails2_BtnTextList.select5
    DiLingDetails2_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl, enterFlag)
end -- end func DiLingDetails2_UpdateSceneInfo()

function DiLingDetails2_UpdateSceneBtn(btnBeginIndex, btnEndIndex, btnCtrlTbl, btnTextTbl, enterSceneFlag)
    if (btnBeginIndex <= 0 or btnBeginIndex > btnEndIndex) then
        return -1
    end
    if (btnEndIndex <= 0 or btnEndIndex < btnBeginIndex) then
        return -2
    end
    if (btnCtrlTbl == nil) then
        return -3
    end
    if (btnTextTbl == nil) then
        return -4
    end

    --DiLingDetails2_Info:SetText("#{DLZX_230314_28}")

    for i=btnBeginIndex, btnEndIndex, 1 do
        local btnIndex = i - btnBeginIndex + 1
        local playerNum, todayDead, totalDead, levelStage = DLZXPVP:GetSceneData_DLSY(i-1)
        local btn = btnCtrlTbl[btnIndex].btn
        local btnTxt = btnCtrlTbl[btnIndex].btntxt
        local btnAni = btnCtrlTbl[btnIndex].btnani
        if (btn ~= nil and btnTxt ~= nil) then
            local btnText = ""
            local txtIndex = 1
            if (playerNum >= 0) then
                if (playerNum <= DiLingDetails2_PlayerNum_VeryGood) then
                    -- 极佳
                    txtIndex = 4
                elseif (playerNum > DiLingDetails2_PlayerNum_VeryGood and playerNum <= DiLingDetails2_PlayerNum_Good) then
                    -- 良好
                    txtIndex = 3
                elseif (playerNum > DiLingDetails2_PlayerNum_Good and playerNum <= DiLingDetails2_PlayerNum_Busy) then
                    -- 繁忙
                    txtIndex = 2
                elseif (playerNum > DiLingDetails2_PlayerNum_Busy) then
                    -- 爆满
                    txtIndex = 1
                end

                -- 设置按钮文本
                btnText = btnTextTbl[btnIndex][txtIndex]
                btnTxt:SetText(btnText)

                -- 设置按钮牻火燃蔂状态
                if (enterSceneFlag == i or enterSceneFlag <= 0) then
                    if (btnAni ~= nil) then
                        if (todayDead < 500) then
                            -- 没有牻火燃蔂状态
                            btnAni:Play(false)
                            btnAni:Hide()
                        elseif (todayDead >= 500 and todayDead < 3000) then
                            -- 牻火燃蔂状态
                            btnAni:SetProperty("Animate", "DiLing_AnimateFire")
                            btnAni:Show()
                            btnAni:Play(true)
                        else
                            -- 牻火超级燃蔂状态
                            btnAni:SetProperty("Animate", "DiLing_AnimateSuperFire")
                            btnAni:Show()
                            btnAni:Play(true)
                        end
                    end
                else
                    if (btnAni ~= nil) then
                        btnAni:Play(false)
                        btnAni:Hide()
                    end
                end

                -- 场景对应等级段起止等级
                local tipLevel = ""
                local levelInfo = DiLingDetails2_SceneLevel[levelStage]
                if (levelInfo ~= nil) then
                    tipLevel = ScriptGlobal_Format("#{DLZX_230518_126}", levelInfo.level_end)
                end

                -- 设置按钮tooltip
                local tipPlayerNum = ScriptGlobal_Format("#{DLZX_230314_109}", btnText, playerNum)
                -- local tipTodayDead = ScriptGlobal_Format("#{DLZX_230314_110}", todayDead)
                -- local tipTotalDead = ScriptGlobal_Format("#{DLZX_230314_111}", totalDead)
                local toolTip = string.format("%s\n%s", tipPlayerNum, tipLevel)
                btn:SetToolTip(tipPlayerNum)

                if (enterSceneFlag == i or enterSceneFlag <= 0) then
                    btn:Enable()
                else
                    btn:Disable()
                end
            else
                if (btnAni ~= nil) then
                    btnAni:Play(false)
                    btnAni:Hide()
                end

                -- 设置按钮文本
                btnText = btnTextTbl[btnIndex][txtIndex]
                btnTxt:SetText(btnText)
                btn:Disable()
            end
        else
        end
    end -- end for

    return 1
end -- end func DiLingDetails2_UpdateSceneBtn()
