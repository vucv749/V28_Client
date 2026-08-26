-- 帝陵再现PVP活动 场景选择UI
local DiLingDetails_SvrScriptId = 998260
local DiLingDetails_QingLong_ScenDataIndex_Begin = 1        -- 青龙场景对应的场景数据索引
local DiLingDetails_QingLong_ScenDataIndex_End = 5          -- 青龙场景对应的场景数据索引
local DiLingDetails_BaiHu_ScenDataIndex_Begin = 6           -- 白虎场景对应的场景数据索引
local DiLingDetails_BaiHu_ScenDataIndex_End = 10            -- 白虎场景对应的场景数据索引
local DiLingDetails_ZhuQue_ScenDataIndex_Begin = 11         -- 朱雀场景对应的场景数据索引
local DiLingDetails_ZhuQue_ScenDataIndex_End = 15           -- 朱雀场景对应的场景数据索引
local DiLingDetails_XuanWu_ScenDataIndex_Begin = 16         -- 玄武场景对应的场景数据索引
local DiLingDetails_XuanWu_ScenDataIndex_End = 20           -- 玄武场景对应的场景数据索引
local DiLingDetails_QiLin_ScenDataIndex_Begin = 21          -- 麒麟场景对应的场景数据索引
local DiLingDetails_QiLin_ScenDataIndex_End = 25            -- 麒麟场景对应的场景数据索引
local DiLingDetails_MaxPlayerNum = 500                      -- 场景内最大人数
local DiLingDetails_PlayerNum_VeryGood = 20                 -- 人数提示（极佳）
local DiLingDetails_PlayerNum_Good = 50                     -- 人数提示（良好）
local DiLingDetails_PlayerNum_Busy = 100                    -- 人数提示（繁忙）
-- 关注NPC
local DiLingDetails_CareObjId = -1
local DiLingDetails_CareObjSvrId = -1
local DiLingDetails_MAX_OBJ_DISTANCE = 5.0
-- 是否开启帝陵深渊场景标记
local DiLingDetails_DLSYOpenFlag = 0
-- 默认位置
local DiLingDetails_UnifiedPosition = nil
-- 控件表
local DiLingDetails_CtrlList = nil

-- 场景等级段
local DiLingDetails_SceneLevel =
{
    [1] = {level_begin = 60, level_end = 69},       -- 60~69级
    [2] = {level_begin = 60, level_end = 89},       -- 60~89级
    [3] = {level_begin = 60, level_end = 119},      -- 60~119级
} -- end DiLingDetails_SceneLevel

-- 按钮文本字典表
local DiLingDetails_BtnTextList =
{
    -- 青龙
    qinglong = 
    {
        [1] = {"#{DLZX_230314_29}", "#{DLZX_230314_49}", "#{DLZX_230314_69}", "#{DLZX_230314_89}", "#{DLZX_230518_116}"},   -- 青龙1
        [2] = {"#{DLZX_230314_30}", "#{DLZX_230314_50}", "#{DLZX_230314_70}", "#{DLZX_230314_90}", "#{DLZX_230518_116}"},   -- 青龙2
        [3] = {"#{DLZX_230314_31}", "#{DLZX_230314_51}", "#{DLZX_230314_71}", "#{DLZX_230314_91}", "#{DLZX_230518_116}"},   -- 青龙3
        [4] = {"#{DLZX_230314_32}", "#{DLZX_230314_52}", "#{DLZX_230314_72}", "#{DLZX_230314_92}", "#{DLZX_230518_116}"},   -- 青龙4
        [5] = {"#{DLZX_230314_33}", "#{DLZX_230314_53}", "#{DLZX_230314_73}", "#{DLZX_230314_93}", "#{DLZX_230518_116}"},   -- 青龙5
    },
    -- 白虎
    baihu =
    {
        [1] = {"#{DLZX_230314_39}", "#{DLZX_230314_59}", "#{DLZX_230314_79}", "#{DLZX_230314_99}", "#{DLZX_230518_117}"},   -- 白虎1
        [2] = {"#{DLZX_230314_40}", "#{DLZX_230314_60}", "#{DLZX_230314_80}", "#{DLZX_230314_100}", "#{DLZX_230518_117}"},  -- 白虎2
        [3] = {"#{DLZX_230314_41}", "#{DLZX_230314_61}", "#{DLZX_230314_81}", "#{DLZX_230314_101}", "#{DLZX_230518_117}"},  -- 白虎3
        [4] = {"#{DLZX_230314_42}", "#{DLZX_230314_62}", "#{DLZX_230314_82}", "#{DLZX_230314_102}", "#{DLZX_230518_117}"},  -- 白虎4
        [5] = {"#{DLZX_230314_43}", "#{DLZX_230314_63}", "#{DLZX_230314_83}", "#{DLZX_230314_103}", "#{DLZX_230518_117}"},  -- 白虎5
    },
    -- 朱雀
    zhuque = 
    {
        [1] = {"#{DLZX_230314_34}", "#{DLZX_230314_54}", "#{DLZX_230314_74}", "#{DLZX_230314_94}", "#{DLZX_230518_116}"},   -- 朱雀1
        [2] = {"#{DLZX_230314_35}", "#{DLZX_230314_55}", "#{DLZX_230314_75}", "#{DLZX_230314_95}", "#{DLZX_230518_116}"},   -- 朱雀2
        [3] = {"#{DLZX_230314_36}", "#{DLZX_230314_56}", "#{DLZX_230314_76}", "#{DLZX_230314_96}", "#{DLZX_230518_116}"},   -- 朱雀3
        [4] = {"#{DLZX_230314_37}", "#{DLZX_230314_57}", "#{DLZX_230314_77}", "#{DLZX_230314_97}", "#{DLZX_230518_116}"},   -- 朱雀4
        [5] = {"#{DLZX_230314_38}", "#{DLZX_230314_58}", "#{DLZX_230314_78}", "#{DLZX_230314_98}", "#{DLZX_230518_116}"},   -- 朱雀5
    },
    -- 玄武
    xuanwu = 
    {
        [1] = {"#{DLZX_230314_44}", "#{DLZX_230314_64}", "#{DLZX_230314_84}", "#{DLZX_230314_104}", "#{DLZX_230518_116}"},   -- 玄武1
        [2] = {"#{DLZX_230314_45}", "#{DLZX_230314_65}", "#{DLZX_230314_85}", "#{DLZX_230314_105}", "#{DLZX_230518_116}"},   -- 玄武2
        [3] = {"#{DLZX_230314_46}", "#{DLZX_230314_66}", "#{DLZX_230314_86}", "#{DLZX_230314_106}", "#{DLZX_230518_116}"},   -- 玄武3
        [4] = {"#{DLZX_230314_47}", "#{DLZX_230314_67}", "#{DLZX_230314_87}", "#{DLZX_230314_107}", "#{DLZX_230518_116}"},   -- 玄武4
        [5] = {"#{DLZX_230314_48}", "#{DLZX_230314_68}", "#{DLZX_230314_88}", "#{DLZX_230314_108}", "#{DLZX_230518_116}"},   -- 玄武5
    },
    -- 麒麟
    qilin =
    {
        [1] = {"#{DLZX_230518_121}", "#{DLZX_230518_130}", "#{DLZX_230518_135}", "#{DLZX_230518_140}", "#{DLZX_230518_127}"},   -- 麒麟1
        [2] = {"#{DLZX_230518_122}", "#{DLZX_230518_131}", "#{DLZX_230518_136}", "#{DLZX_230518_141}", "#{DLZX_230518_127}"},   -- 麒麟2
        [3] = {"#{DLZX_230518_123}", "#{DLZX_230518_132}", "#{DLZX_230518_137}", "#{DLZX_230518_142}", "#{DLZX_230518_127}"},   -- 麒麟3
        [4] = {"#{DLZX_230518_124}", "#{DLZX_230518_133}", "#{DLZX_230518_138}", "#{DLZX_230518_143}", "#{DLZX_230518_127}"},   -- 麒麟4
        [5] = {"#{DLZX_230518_125}", "#{DLZX_230518_134}", "#{DLZX_230518_139}", "#{DLZX_230518_144}", "#{DLZX_230518_127}"},   -- 麒麟5
    },
} -- end DiLingDetails_BtnTextList



function DiLingDetails_PreLoad()
    this:RegisterEvent("DLZXPVP_OPEN", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end -- end func DiLingDetails_PreLoad()

function DiLingDetails_OnEvent(event)
    if (event == "DLZXPVP_OPEN") then
        if (not this:IsVisible()) then
            DiLingDetails_DLSYOpenFlag = tonumber(arg2)
            DiLingDetails_BeginCareObject(arg0, arg1)
            DiLingDetails_UpdateSceneInfo()
            DiLingDetails_Show()
        end
    elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(DiLingDetails_CareObjId < 0 or tonumber(arg0) ~= DiLingDetails_CareObjId) then
			return
        end
        
		-- 如果和NPC的距离大于一定距离或者被删除，自动关闭
        if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
            DiLingDetails_Hide()
        end
    elseif (event == "HIDE_ON_SCENE_TRANSED") then
        DiLingDetails_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        DiLingDetails_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        DiLingDetails_UnifiedPos()
	end
end -- end func DiLingDetails_OnEvent()

function DiLingDetails_OnLoad()
	DiLingDetails_UnifiedPosition = DiLingDetails_Frame:GetProperty("UnifiedPosition")
	DiLingDetails_InitCtrlList()
end -- end func DiLingDetails_OnLoad()

function DiLingDetails_InitCtrlList()
    if (DiLingDetails_CtrlList ~= nil) then
        DiLingDetails_CtrlList = nil
    end

    DiLingDetails_CtrlList = {}
    DiLingDetails_CtrlList.btnctrl = {}
    -- 青龙
    DiLingDetails_CtrlList.btnctrl.qinglong = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[1] = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[1].btn = DiLingDetails_Select_QingLong1
    DiLingDetails_CtrlList.btnctrl.qinglong[1].btntxt = DiLingDetails_Select_QingLong1_Text
    DiLingDetails_CtrlList.btnctrl.qinglong[1].btnani = DiLingDetails_Select_QingLong1_Animate
    DiLingDetails_CtrlList.btnctrl.qinglong[2] = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[2].btn = DiLingDetails_Select_QingLong2
    DiLingDetails_CtrlList.btnctrl.qinglong[2].btntxt = DiLingDetails_Select_QingLong2_Text
    DiLingDetails_CtrlList.btnctrl.qinglong[2].btnani = DiLingDetails_Select_QingLong2_Animate
    DiLingDetails_CtrlList.btnctrl.qinglong[3] = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[3].btn = DiLingDetails_Select_QingLong3
    DiLingDetails_CtrlList.btnctrl.qinglong[3].btntxt = DiLingDetails_Select_QingLong3_Text
    DiLingDetails_CtrlList.btnctrl.qinglong[3].btnani = DiLingDetails_Select_QingLong3_Animate
    DiLingDetails_CtrlList.btnctrl.qinglong[4] = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[4].btn = DiLingDetails_Select_QingLong4
    DiLingDetails_CtrlList.btnctrl.qinglong[4].btntxt = DiLingDetails_Select_QingLong4_Text
    DiLingDetails_CtrlList.btnctrl.qinglong[4].btnani = DiLingDetails_Select_QingLong4_Animate
    DiLingDetails_CtrlList.btnctrl.qinglong[5] = {}
    DiLingDetails_CtrlList.btnctrl.qinglong[5].btn = DiLingDetails_Select_QingLong5
    DiLingDetails_CtrlList.btnctrl.qinglong[5].btntxt = DiLingDetails_Select_QingLong5_Text
    DiLingDetails_CtrlList.btnctrl.qinglong[5].btnani = DiLingDetails_Select_QingLong5_Animate
    -- 白虎
    DiLingDetails_CtrlList.btnctrl.baihu = {}
    DiLingDetails_CtrlList.btnctrl.baihu[1] = {}
    DiLingDetails_CtrlList.btnctrl.baihu[1].btn = DiLingDetails_Select_BaiHu1
    DiLingDetails_CtrlList.btnctrl.baihu[1].btntxt = DiLingDetails_Select_BaiHu1_Text
    DiLingDetails_CtrlList.btnctrl.baihu[1].btnani = DiLingDetails_Select_BaiHu1_Animate
    DiLingDetails_CtrlList.btnctrl.baihu[2] = {}
    DiLingDetails_CtrlList.btnctrl.baihu[2].btn = DiLingDetails_Select_BaiHu2
    DiLingDetails_CtrlList.btnctrl.baihu[2].btntxt = DiLingDetails_Select_BaiHu2_Text
    DiLingDetails_CtrlList.btnctrl.baihu[2].btnani = DiLingDetails_Select_BaiHu2_Animate
    DiLingDetails_CtrlList.btnctrl.baihu[3] = {}
    DiLingDetails_CtrlList.btnctrl.baihu[3].btn = DiLingDetails_Select_BaiHu3
    DiLingDetails_CtrlList.btnctrl.baihu[3].btntxt = DiLingDetails_Select_BaiHu3_Text
    DiLingDetails_CtrlList.btnctrl.baihu[3].btnani = DiLingDetails_Select_BaiHu3_Animate
    DiLingDetails_CtrlList.btnctrl.baihu[4] = {}
    DiLingDetails_CtrlList.btnctrl.baihu[4].btn = DiLingDetails_Select_BaiHu4
    DiLingDetails_CtrlList.btnctrl.baihu[4].btntxt = DiLingDetails_Select_BaiHu4_Text
    DiLingDetails_CtrlList.btnctrl.baihu[4].btnani = DiLingDetails_Select_BaiHu4_Animate
    DiLingDetails_CtrlList.btnctrl.baihu[5] = {}
    DiLingDetails_CtrlList.btnctrl.baihu[5].btn = DiLingDetails_Select_BaiHu5
    DiLingDetails_CtrlList.btnctrl.baihu[5].btntxt = DiLingDetails_Select_BaiHu5_Text
    DiLingDetails_CtrlList.btnctrl.baihu[5].btnani = DiLingDetails_Select_BaiHu5_Animate
    -- 朱雀
    DiLingDetails_CtrlList.btnctrl.zhuque = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[1] = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[1].btn = DiLingDetails_Select_ZhuQue1
    DiLingDetails_CtrlList.btnctrl.zhuque[1].btntxt = DiLingDetails_Select_ZhuQue1_Text
    DiLingDetails_CtrlList.btnctrl.zhuque[1].btnani = DiLingDetails_Select_ZhuQue1_Animate
    DiLingDetails_CtrlList.btnctrl.zhuque[2] = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[2].btn = DiLingDetails_Select_ZhuQue2
    DiLingDetails_CtrlList.btnctrl.zhuque[2].btntxt = DiLingDetails_Select_ZhuQue2_Text
    DiLingDetails_CtrlList.btnctrl.zhuque[2].btnani = DiLingDetails_Select_ZhuQue2_Animate
    DiLingDetails_CtrlList.btnctrl.zhuque[3] = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[3].btn = DiLingDetails_Select_ZhuQue3
    DiLingDetails_CtrlList.btnctrl.zhuque[3].btntxt = DiLingDetails_Select_ZhuQue3_Text
    DiLingDetails_CtrlList.btnctrl.zhuque[3].btnani = DiLingDetails_Select_ZhuQue3_Animate
    DiLingDetails_CtrlList.btnctrl.zhuque[4] = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[4].btn = DiLingDetails_Select_ZhuQue4
    DiLingDetails_CtrlList.btnctrl.zhuque[4].btntxt = DiLingDetails_Select_ZhuQue4_Text
    DiLingDetails_CtrlList.btnctrl.zhuque[4].btnani = DiLingDetails_Select_ZhuQue4_Animate
    DiLingDetails_CtrlList.btnctrl.zhuque[5] = {}
    DiLingDetails_CtrlList.btnctrl.zhuque[5].btn = DiLingDetails_Select_ZhuQue5
    DiLingDetails_CtrlList.btnctrl.zhuque[5].btntxt = DiLingDetails_Select_ZhuQue5_Text
    DiLingDetails_CtrlList.btnctrl.zhuque[5].btnani = DiLingDetails_Select_ZhuQue5_Animate
    -- 玄武
    DiLingDetails_CtrlList.btnctrl.xuanwu = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[1] = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[1].btn = DiLingDetails_Select_XuanWu1
    DiLingDetails_CtrlList.btnctrl.xuanwu[1].btntxt = DiLingDetails_Select_XuanWu1_Text
    DiLingDetails_CtrlList.btnctrl.xuanwu[1].btnani = DiLingDetails_Select_XuanWu1_Animate
    DiLingDetails_CtrlList.btnctrl.xuanwu[2] = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[2].btn = DiLingDetails_Select_XuanWu2
    DiLingDetails_CtrlList.btnctrl.xuanwu[2].btntxt = DiLingDetails_Select_XuanWu2_Text
    DiLingDetails_CtrlList.btnctrl.xuanwu[2].btnani = DiLingDetails_Select_XuanWu2_Animate
    DiLingDetails_CtrlList.btnctrl.xuanwu[3] = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[3].btn = DiLingDetails_Select_XuanWu3
    DiLingDetails_CtrlList.btnctrl.xuanwu[3].btntxt = DiLingDetails_Select_XuanWu3_Text
    DiLingDetails_CtrlList.btnctrl.xuanwu[3].btnani = DiLingDetails_Select_XuanWu3_Animate
    DiLingDetails_CtrlList.btnctrl.xuanwu[4] = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[4].btn = DiLingDetails_Select_XuanWu4
    DiLingDetails_CtrlList.btnctrl.xuanwu[4].btntxt = DiLingDetails_Select_XuanWu4_Text
    DiLingDetails_CtrlList.btnctrl.xuanwu[4].btnani = DiLingDetails_Select_XuanWu4_Animate
    DiLingDetails_CtrlList.btnctrl.xuanwu[5] = {}
    DiLingDetails_CtrlList.btnctrl.xuanwu[5].btn = DiLingDetails_Select_XuanWu5
    DiLingDetails_CtrlList.btnctrl.xuanwu[5].btntxt = DiLingDetails_Select_XuanWu5_Text
    DiLingDetails_CtrlList.btnctrl.xuanwu[5].btnani = DiLingDetails_Select_XuanWu5_Animate
    -- 麒麟
    DiLingDetails_CtrlList.btnctrl.qilin = {}
    DiLingDetails_CtrlList.btnctrl.qilin[1] = {}
    DiLingDetails_CtrlList.btnctrl.qilin[1].btn = DiLingDetails_Select_QiLin1
    DiLingDetails_CtrlList.btnctrl.qilin[1].btntxt = DiLingDetails_Select_QiLin1_Text
    DiLingDetails_CtrlList.btnctrl.qilin[1].btnani = DiLingDetails_Select_QiLin1_Animate
    DiLingDetails_CtrlList.btnctrl.qilin[2] = {}
    DiLingDetails_CtrlList.btnctrl.qilin[2].btn = DiLingDetails_Select_QiLin2
    DiLingDetails_CtrlList.btnctrl.qilin[2].btntxt = DiLingDetails_Select_QiLin2_Text
    DiLingDetails_CtrlList.btnctrl.qilin[2].btnani = DiLingDetails_Select_QiLin2_Animate
    DiLingDetails_CtrlList.btnctrl.qilin[3] = {}
    DiLingDetails_CtrlList.btnctrl.qilin[3].btn = DiLingDetails_Select_QiLin3
    DiLingDetails_CtrlList.btnctrl.qilin[3].btntxt = DiLingDetails_Select_QiLin3_Text
    DiLingDetails_CtrlList.btnctrl.qilin[3].btnani = DiLingDetails_Select_QiLin3_Animate
    DiLingDetails_CtrlList.btnctrl.qilin[4] = {}
    DiLingDetails_CtrlList.btnctrl.qilin[4].btn = DiLingDetails_Select_QiLin4
    DiLingDetails_CtrlList.btnctrl.qilin[4].btntxt = DiLingDetails_Select_QiLin4_Text
    DiLingDetails_CtrlList.btnctrl.qilin[4].btnani = DiLingDetails_Select_QiLin4_Animate
    DiLingDetails_CtrlList.btnctrl.qilin[5] = {}
    DiLingDetails_CtrlList.btnctrl.qilin[5].btn = DiLingDetails_Select_QiLin5
    DiLingDetails_CtrlList.btnctrl.qilin[5].btntxt = DiLingDetails_Select_QiLin5_Text
    DiLingDetails_CtrlList.btnctrl.qilin[5].btnani = DiLingDetails_Select_QiLin5_Animate
end -- end func DiLingDetails_InitCtrlList()

-- 界面默认位置
function DiLingDetails_UnifiedPos()
	if (DiLingDetails_UnifiedPosition ~= nil) then
		DiLingDetails_Frame:SetProperty("UnifiedPosition", DiLingDetails_UnifiedPosition)
	end
end -- end func DiLingDetails_UnifiedPos()

-- 开启NPC关注
function DiLingDetails_BeginCareObject(objSvrId, objId)
	DiLingDetails_CareObjId = tonumber(objId)
    if (DiLingDetails_CareObjId >= 0) then
        DiLingDetails_CareObjSvrId = tonumber(objSvrId)
        DiLingDetails_TargetNPC = tonumber(objSvrId)
		this:CareObject(DiLingDetails_CareObjId, 1, "DiLingDetails")
	end
end -- end func DiLingDetails_BeginCareObject()

-- 取消NPC关注
function DiLingDetails_StopCareObject()
	if (DiLingDetails_CareObjId >= 0) then
		this:CareObject(DiLingDetails_CareObjId, 0, "DiLingDetails")
		DiLingDetails_CareObjId = -1
		DiLingDetails_CareObjSvrId = -1
	end
end -- end func DiLingDetails_StopCareObject()

function DiLingDetails_Show()
    this:Show()
end -- end func DiLingDetails_Show()

function DiLingDetails_Hide()
    DiLingDetails_StopCareObject()
    this:Hide()
end -- end func DiLingDetails_Hide()

-- 关闭按钮点击事件
function DiLingDetails_Clicked_Close()
    DiLingDetails_Hide()
end -- end func DiLingDetails_Clicked_Close()

-- 进入帝陵深渊按钮点击事件
function DiLingDetails_Clicked_EnterDLSY()
    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryOpenDLSYSceneChooseUI")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()

    DiLingDetails_Hide()
end -- end func DiLingDetails_Clicked_EnterDLSY()

-- 青龙场景按钮点击事件
function DiLingDetails_Clicked_QingLong(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails_QingLong_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails_QingLong_ScenDataIndex_Begin or sceneIndex > DiLingDetails_QingLong_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData(sceneIndex - 1)
    if (playerNum >= DiLingDetails_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails_Clicked_QingLong()

-- 白虎场景按钮点击事件
function DiLingDetails_Clicked_BaiHu(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails_BaiHu_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails_BaiHu_ScenDataIndex_Begin or sceneIndex > DiLingDetails_BaiHu_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData(sceneIndex - 1)
    if (playerNum >= DiLingDetails_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails_Clicked_BaiHu()

-- 朱雀场景按钮点击事件
function DiLingDetails_Clicked_ZhuQue(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails_ZhuQue_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails_ZhuQue_ScenDataIndex_Begin or sceneIndex > DiLingDetails_ZhuQue_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData(sceneIndex - 1)
    if (playerNum >= DiLingDetails_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails_Clicked_ZhuQue()

-- 玄武场景按钮点击事件
function DiLingDetails_Clicked_XuanWu(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails_XuanWu_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails_XuanWu_ScenDataIndex_Begin or sceneIndex > DiLingDetails_XuanWu_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData(sceneIndex - 1)
    if (playerNum >= DiLingDetails_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails_Clicked_XuanWu()

-- 麒麟场景按钮点击事件
function DiLingDetails_Clicked_QiLin(arg)
    local btnIndex = tonumber(arg)
    local sceneIndex = DiLingDetails_QiLin_ScenDataIndex_Begin + btnIndex - 1
    if (sceneIndex < DiLingDetails_QiLin_ScenDataIndex_Begin or sceneIndex > DiLingDetails_QiLin_ScenDataIndex_End) then
        return
    end

    local playerNum, todayDead, totalDead = DLZXPVP:GetSceneData(sceneIndex - 1)
    if (playerNum >= DiLingDetails_MaxPlayerNum) then
        -- 场景人数已满
        PushDebugMessage("DLZX_230314_117")
        return
    end

    Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID(DiLingDetails_SvrScriptId)
        Set_XSCRIPT_Function_Name("CallBack_TryEnterScene")
        Set_XSCRIPT_Parameter(0, DiLingDetails_CareObjSvrId)
        Set_XSCRIPT_Parameter(1, sceneIndex)
        Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end -- end func DiLingDetails_Clicked_QiLin()

-- 刷新按钮信息
function DiLingDetails_UpdateSceneInfo()
    if (DiLingDetails_CtrlList == nil) then
        DiLingDetails_InitCtrlList()
    end

    local btnIndexBegin = -1
    local btnIndexEnd = -1
    local btnTbl = nil
    local txtTbl = nil

    -- 青龙
    btnIndexBegin = DiLingDetails_QingLong_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails_QingLong_ScenDataIndex_End
    btnTbl = DiLingDetails_CtrlList.btnctrl.qinglong
    txtTbl = DiLingDetails_BtnTextList.qinglong
    DiLingDetails_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl)

    -- 白虎
    btnIndexBegin = DiLingDetails_BaiHu_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails_BaiHu_ScenDataIndex_End
    btnTbl = DiLingDetails_CtrlList.btnctrl.baihu
    txtTbl = DiLingDetails_BtnTextList.baihu
    DiLingDetails_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl)

    -- 朱雀
    btnIndexBegin = DiLingDetails_ZhuQue_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails_ZhuQue_ScenDataIndex_End
    btnTbl = DiLingDetails_CtrlList.btnctrl.zhuque
    txtTbl = DiLingDetails_BtnTextList.zhuque
    DiLingDetails_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl)

    -- 玄武
    btnIndexBegin = DiLingDetails_XuanWu_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails_XuanWu_ScenDataIndex_End
    btnTbl = DiLingDetails_CtrlList.btnctrl.xuanwu
    txtTbl = DiLingDetails_BtnTextList.xuanwu
    DiLingDetails_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl)

    -- 麒麟
    btnIndexBegin = DiLingDetails_QiLin_ScenDataIndex_Begin
    btnIndexEnd = DiLingDetails_QiLin_ScenDataIndex_End
    btnTbl = DiLingDetails_CtrlList.btnctrl.qilin
    txtTbl = DiLingDetails_BtnTextList.qilin
    DiLingDetails_UpdateSceneBtn(btnIndexBegin, btnIndexEnd, btnTbl, txtTbl)

    if (DiLingDetails_DLSYOpenFlag > 0) then
        DiLingDetails_Button:Show()
    else
        DiLingDetails_Button:Hide()
    end
end -- end func DiLingDetails_UpdateSceneInfo()

function DiLingDetails_UpdateSceneBtn(btnBeginIndex, btnEndIndex, btnCtrlTbl, btnTextTbl)
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

    --DiLingDetails_Info:SetText("#{DLZX_230314_28}")

    for i=btnBeginIndex, btnEndIndex, 1 do
        local btnIndex = i - btnBeginIndex + 1
        local playerNum, todayDead, totalDead, levelStage = DLZXPVP:GetSceneData(i-1)
        local btn = btnCtrlTbl[btnIndex].btn
        local btnTxt = btnCtrlTbl[btnIndex].btntxt
        local btnAni = btnCtrlTbl[btnIndex].btnani
        if (btn ~= nil and btnAni ~= nil) then
            local btnText = ""
            local txtIndex = 1
            if (playerNum >= 0) then
                if (playerNum <= DiLingDetails_PlayerNum_VeryGood) then
                    -- 极佳
                    txtIndex = 4
                elseif (playerNum > DiLingDetails_PlayerNum_VeryGood and playerNum <= DiLingDetails_PlayerNum_Good) then
                    -- 良好
                    txtIndex = 3
                elseif (playerNum > DiLingDetails_PlayerNum_Good and playerNum <= DiLingDetails_PlayerNum_Busy) then
                    -- 繁忙
                    txtIndex = 2
                elseif (playerNum > DiLingDetails_PlayerNum_Busy) then
                    -- 爆满
                    txtIndex = 1
                end

                -- 设置按钮文本
                btnText = btnTextTbl[btnIndex][txtIndex]
                btnTxt:SetText(btnText)

                -- 设置按钮战火燃烧状态
                if (todayDead < 500) then
                    -- 没有战火燃烧状态
                    btnAni:Play(false)
                    btnAni:Hide()
                elseif (todayDead >= 500 and todayDead < 3000) then
                    -- 战火燃烧状态
                    btnAni:SetProperty("Animate", "DiLing_AnimateFire")
                    btnAni:Show()
                    btnAni:Play(true)
                else
                    -- 战火超级燃烧状态
                    btnAni:SetProperty("Animate", "DiLing_AnimateSuperFire")
                    btnAni:Show()
                    btnAni:Play(true)
                end

                -- 场景对应等级段起止等级
                local tipLevel = ""
                local levelInfo = DiLingDetails_SceneLevel[levelStage]
                if (levelInfo ~= nil) then
                    tipLevel = ScriptGlobal_Format("#{DLZX_230518_126}", levelInfo.level_end)
                end

                -- 设置按钮tooltip
                local tipPlayerNum = ScriptGlobal_Format("#{DLZX_230314_109}", btnText, playerNum)
                local tipTodayDead = ScriptGlobal_Format("#{DLZX_230314_110}", todayDead)
                local tipTotalDead = ScriptGlobal_Format("#{DLZX_230314_111}", totalDead)
                local toolTip = string.format("%s\n%s\n%s\n%s\n%s", tipPlayerNum, tipTodayDead, tipTotalDead, btnTextTbl[btnIndex][5], tipLevel)
                btn:SetToolTip(toolTip)

                btn:Enable()
            else
                btnAni:Play(false)
                btnAni:Hide()

                -- 设置按钮文本
                btnText = btnTextTbl[btnIndex][txtIndex]
                btnTxt:SetText(btnText)
                btn:Disable()
            end
        end
    end -- end for

    return 1
end -- end func DiLingDetails_UpdateSceneBtn()