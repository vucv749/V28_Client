-- 跨服爬塔 详情界面

-- 默认位置
local g_towerbox_unifiedposition = nil
local g_towerbox_uicommand = 99855901
local g_towerbox_yaota_max = 3
local g_towerbox_select = 1
local g_towerbox_ui = {}

local g_towerbox_def = {
    yaota = 1,
    longta = 2,
}

local g_towerbox_str = {
    yaota = {
        [1] = {time = "#{PTDB_231225_60}", name = "#{PTDB_231225_55}", opentime=200000, total=8,},
        [2] = {time = "#{PTDB_231225_61}", name = "#{PTDB_231225_56}", opentime=201000, total=3,},
        [3] = {time = "#{PTDB_231225_62}", name = "#{PTDB_231225_57}", opentime=202000, total=2,},
        [4] = {time = "#{PTDB_231225_63}", name = "#{PTDB_231225_58}", opentime=203000, total=1,},
    },
    longta = {
        [1] = {time = "#{PTDB_231225_64}", name = "#{PTDB_231225_55}", opentime=200000, total=3,},
        [2] = {time = "#{PTDB_231225_65}", name = "#{PTDB_231225_56}", opentime=201000, total=2,},
        [3] = {time = "#{PTDB_231225_66}", name = "#{PTDB_231225_57}", opentime=202000, total=1,},
        [4] = {time = "#{PTDB_231225_251}", name = "#{PTDB_231225_57}", opentime=203000, total=1,},
    },
}

local g_towerbox_opentime = {
    {begin=200000,over=201000,},
    {begin=201000,over=202000,},
    {begin=202000,over=203000,},
    {begin=203000,over=210000,},
}

-- 对应奖励值对应的权重
local g_towerbox_reward = {
    {weight=50,item={38003103,39920140},},
    {weight=40,item={38003102,39920141},},
    {weight=30,item={38003101,},},
    {weight=20,item={38003100,},},
    {weight=10,item={38003099,},},
}

local g_towerbox_award = {
    [1] = {
        reward=1,
        list = {
            {2,4,0,},                       -- 龙塔4层
        }                        
    },
    [2] = {
        reward=2,
        list = {
            {1,4,1,},                       -- 妖塔1号4层
            {1,4,2,},                       -- 妖塔2号4层
            {1,4,3,},                       -- 妖塔3号4层
        }
    },
    [3] = {
        reward=2,
        list = {
            {2,3,0},                        -- 龙塔3层
        }
    },
    [4] = {
        reward=3,
        list = {
            {1,3,1,},                       -- 妖塔1号3层
            {1,3,2,},                       -- 妖塔2号3层
            {1,3,3,},                       -- 妖塔3号3层
        }
    },
    [5] = {
        reward=3,
        list = {
            {2,2,0},                        -- 龙塔2层
        }
    },
    [6] = {
        reward=4,
        list = {
            {1,2,1,},                       -- 妖塔1号2层
            {1,2,2,},                       -- 妖塔2号2层
            {1,2,3,},                       -- 妖塔3号2层
        }
    },
    [7] = {
        reward=4,
        list = {
            {2,1,0},                        -- 龙塔1层
        }
    },
    [8] = {
        reward=5,
        list = {
            {1,1,1,},                       -- 妖塔1号1层
            {1,1,2,},                       -- 妖塔2号1层
            {1,1,3,},                       -- 妖塔3号1层
        }
    },
}

local g_towerbox_scenegroup = {
    [658] = {fst=1,sec=1,tower=1},
    [659] = {fst=1,sec=2,tower=1},
    [660] = {fst=1,sec=3,tower=1},
    [661] = {fst=1,sec=4,tower=1},

    [662] = {fst=1,sec=1,tower=2},
    [663] = {fst=1,sec=2,tower=2},
    [664] = {fst=1,sec=3,tower=2},
    [665] = {fst=1,sec=4,tower=2},

    [666] = {fst=1,sec=1,tower=3},
    [667] = {fst=1,sec=2,tower=3},
    [668] = {fst=1,sec=3,tower=3},
    [669] = {fst=1,sec=4,tower=3},

    [670] = {fst=2,sec=2,tower=0},
    [671] = {fst=2,sec=3,tower=0},
    [672] = {fst=2,sec=4,tower=0},
    [679] = {fst=2,sec=1,tower=0},
}

local g_towerbox_combolist = {
    [1] = {str="#{PTDB_231225_255}",select={},},
    [2] = {str="#{PTDB_231225_256}",select={8},},
    [3] = {str="#{PTDB_231225_257}",select={6,7},},
    [4] = {str="#{PTDB_231225_258}",select={4,5},},
    [5] = {str="#{PTDB_231225_259}",select={2,3},},
    [6] = {str="#{PTDB_231225_260}",select={1},},
}

function TowerBox_ProjectInfo_PreLoad()
    this:RegisterEvent("PTDB_OPEN_TOWERBOX_DETAILSUI", true)
    this:RegisterEvent("PTDB_UPDATE_TOWERBOX_UI", false)
    this:RegisterEvent("UI_COMMAND", false)
    this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
    this:RegisterEvent("PLAYER_LEAVE_WORLD", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- 窗口分辨率发生变化
	this:RegisterEvent("ADJEST_UI_POS",false)               -- 窗口尺寸发生变化
end

function TowerBox_ProjectInfo_OnEvent(event)
    if event == "PTDB_OPEN_TOWERBOX_DETAILSUI" then
        TowerBox_ProjectInfo_Show()
    elseif event == "PTDB_UPDATE_TOWERBOX_UI" then
        TowerBox_ProjectInfo_UpdateUI()
    elseif (event == "UI_COMMAND" and tonumber(arg0) == g_towerbox_uicommand) then
        TowerBox_ProjectInfo_Hide()
    elseif (event == "PLAYER_LEAVE_WORLD") then
        TowerBox_ProjectInfo_Hide()
    elseif (event == "VIEW_RESOLUTION_CHANGED") then
        TowerBox_ProjectInfo_UnifiedPos()
    elseif (event == "ADJEST_UI_POS") then
        TowerBox_ProjectInfo_UnifiedPos()
	end
end

function TowerBox_ProjectInfo_OnLoad()
    g_towerbox_ui = {}
    local _prefix = "TowerBox_ProjectInfo_Tower"
    local makeTowerGroup = function(idx, name)
        local prefixname = _prefix..idx..name
        return {
            ["time"] = _G[prefixname.."Time"],
            ["bg"] = _G[prefixname.."BK"],
            ["box"] = _G[prefixname.."Box1"],
            ["box2"] = _G[prefixname.."Box2"],
            ["line"] = _G[prefixname.."Line"],
            ["line2"] = _G[prefixname.."Line2"],
            ["now"] = _G[prefixname.."Now"],
        }
    end
    local makeAwardGroup = function(_prefix)
        return {
            ["name"] = _G[_prefix.."Get"],
            --["bg"] = _G[_prefix.."BK"],
        }
    end
    local makeTimeGroup = function(_prefix, open, close, now, over)
        return {
            ["open"] = _G[_prefix..open],
            ["close"] = _G[_prefix..close],
            ["over"] = _G[_prefix..over],
            ["now"] = _G[_prefix..now],
        }
    end

    g_towerbox_ui.yaota = {}
    for i=1, g_towerbox_yaota_max do
        g_towerbox_ui.yaota[i] = {
            makeTowerGroup(tostring(i), "_4"),
            makeTowerGroup(tostring(i), "_3"),
            makeTowerGroup(tostring(i), "_2"),
            makeTowerGroup(tostring(i), "_1"),
        }
    end
    g_towerbox_ui.longta = {
        makeTowerGroup("4", "_3"),
        makeTowerGroup("4", "_2"),
        makeTowerGroup("4", "_1"),
        makeTowerGroup("4", "_0"),
    }
    g_towerbox_ui.timelist = {
        makeTimeGroup("TowerBox_ProjectInfo_Award","_5Time","_5Time2","2_Item5_Now","2_Item5_End"),
        makeTimeGroup("TowerBox_ProjectInfo_Award","_4Time","_4Time2","2_Item4_Now","2_Item4_End"),
        makeTimeGroup("TowerBox_ProjectInfo_Award","_3Time","_3Time2","2_Item3_Now","2_Item3_End"),
        makeTimeGroup("TowerBox_ProjectInfo_Award","_2Time","_2Time2","2_Item2_Now","2_Item2_End"),
    }
    g_towerbox_ui.award = {
        {
            name=TowerBox_ProjectInfo_Award_2Get2,
            get={TowerBox_ProjectInfo_Award2_Item2_3Get,TowerBox_ProjectInfo_Award2_Item2_4Get},
            mask={TowerBox_ProjectInfo_Award2_Item2_3Mask,TowerBox_ProjectInfo_Award2_Item2_4Mask},
            now={TowerBox_ProjectInfo_Award2_Item2_3Now,TowerBox_ProjectInfo_Award2_Item2_4Now},
            action={TowerBox_ProjectInfo_Award2_Item2_3,TowerBox_ProjectInfo_Award2_Item2_4},
        },
        {
            name=TowerBox_ProjectInfo_Award_2Get,
            get={TowerBox_ProjectInfo_Award2_Item2_1Get,TowerBox_ProjectInfo_Award2_Item2_2Get},
            mask={TowerBox_ProjectInfo_Award2_Item2_1Mask,TowerBox_ProjectInfo_Award2_Item2_2Mask},
            now={TowerBox_ProjectInfo_Award2_Item2_1Now,TowerBox_ProjectInfo_Award2_Item2_2Now},
            action={TowerBox_ProjectInfo_Award2_Item2_1,TowerBox_ProjectInfo_Award2_Item2_2},
        },
        {
            name=TowerBox_ProjectInfo_Award_3Get2,
            get={TowerBox_ProjectInfo_Award2_Item3_2Get,TowerBox_ProjectInfo_Award2_Item3_3Get},
            mask={TowerBox_ProjectInfo_Award2_Item3_2Mask,TowerBox_ProjectInfo_Award2_Item3_3Mask},
            now={TowerBox_ProjectInfo_Award2_Item3_2Now,TowerBox_ProjectInfo_Award2_Item3_3Now},
            action={TowerBox_ProjectInfo_Award2_Item3_2,TowerBox_ProjectInfo_Award2_Item3_3},
        },
        {
            name=TowerBox_ProjectInfo_Award_3Get,
            get={TowerBox_ProjectInfo_Award2_Item3_1Get},
            mask={TowerBox_ProjectInfo_Award2_Item3_1Mask},
            now={TowerBox_ProjectInfo_Award2_Item3_1Now},
            action={TowerBox_ProjectInfo_Award2_Item3_1},
        },
        {
            name=TowerBox_ProjectInfo_Award_4Get2,
            get={TowerBox_ProjectInfo_Award2_Item4_2Get},
            mask={TowerBox_ProjectInfo_Award2_Item4_2Mask},
            now={TowerBox_ProjectInfo_Award2_Item4_2Now},
            action={TowerBox_ProjectInfo_Award2_Item4_2},
        },
        {
            name=TowerBox_ProjectInfo_Award_4Get,
            get={TowerBox_ProjectInfo_Award2_Item4_1Get},
            mask={TowerBox_ProjectInfo_Award2_Item4_1Mask},
            now={TowerBox_ProjectInfo_Award2_Item4_1Now},
            action={TowerBox_ProjectInfo_Award2_Item4_1},
        },
        {
            name=TowerBox_ProjectInfo_Award_5Get2,
            get={TowerBox_ProjectInfo_Award2_Item5_2Get},
            mask={TowerBox_ProjectInfo_Award2_Item5_2Mask},
            now={TowerBox_ProjectInfo_Award2_Item5_2Now},
            action={TowerBox_ProjectInfo_Award2_Item5_2},
        },
        {
            name=TowerBox_ProjectInfo_Award_5Get,
            get={TowerBox_ProjectInfo_Award2_Item5_1Get},
            mask={TowerBox_ProjectInfo_Award2_Item5_1Mask},
            now={TowerBox_ProjectInfo_Award2_Item5_1Now},
            action={TowerBox_ProjectInfo_Award2_Item5_1},
        },
    }
    
    g_towerbox_unifiedposition = TowerBox_ProjectInfo_Frame:GetProperty("UnifiedPosition")
end

-- 界面默认位置
function TowerBox_ProjectInfo_UnifiedPos()
	if (g_towerbox_unifiedposition ~= nil) then
		TowerBox_ProjectInfo_Frame:SetProperty("UnifiedPosition", g_towerbox_unifiedposition)
	end
end

function TowerBox_ProjectInfo_Show()
    --if IsWindowShow("TowerBox") then
    --    CloseWindow("TowerBox", true)
    --end

    --TowerBox_ProjectInfo_InitTimer()
    TowerBox_ProjectInfo_UpdateComboListUI()
    TowerBox_ProjectInfo_UpdateUI()
    this:Show()
end

-- 刷新UI内容
function TowerBox_ProjectInfo_UpdateUI()
    TowerBox_ProjectInfo_UpdateTowerUI()
    TowerBox_ProjectInfo_UpdateRewardUI()
end

-- 刷新Tower内容
function TowerBox_ProjectInfo_UpdateTowerUI()
    -- 妖塔细节
    for i=1, g_towerbox_yaota_max do
        local tower = g_towerbox_ui.yaota[i]
        if tower ~= nil then
            for sub, ui in (tower or {}) do
                local towerdata = g_towerbox_str.yaota[sub]
                if towerdata ~= nil then
                    -- 开启时间
                    ui.time:SetText(towerdata.time)
                    -- 开启显示的都关闭
                    ui.bg:Hide()
                    ui.box:Hide()
                    ui.line2:Hide()
                    ui.now:Hide()
                    -- 关闭显示的都开启
                    ui.box2:Show()
                    ui.line:Show()

                    local nowTower = TowerBox_ProjectInfo_IsInTower(g_towerbox_def.yaota, sub, i)
                    if nowTower > 0 then
                        ui.now:Show()
                    end
                end

                local data = PTDB:LuaFnGetTowerDetailData(g_towerbox_def.yaota, sub , i)
                if data ~= nil and type(data) == "table" and towerdata ~= nil then
                    -- 该场景箱子全在
                    if data.active < 1 then
                        -- 判断当前开启情况
                        local curHMS = tonumber(DataPool:GetServerMinuteTime())
                        if curHMS > towerdata.opentime then
                            -- 按最大的显示
                            local remainstr = ScriptGlobal_Format("#{PTDB_231225_59}", towerdata.total)
                            ui.time:SetText(remainstr)
                            local bgshow = TowerBox_ProjectInfo_IsTowerShow(g_towerbox_def.yaota, sub, i)
                            if bgshow > 0 then
                                ui.bg:Show()
                                ui.box:Show()
                                ui.line2:Show()
                                ui.box2:Hide()
                                ui.line:Hide()
                            else

                            end
                        end
                    else
                        -- 正常显示
                        local remainstr = ScriptGlobal_Format("#{PTDB_231225_59}", data.reaminbox)
                        ui.time:SetText(remainstr)
                        local bgshow = TowerBox_ProjectInfo_IsTowerShow(g_towerbox_def.yaota, sub, i)
                        if bgshow > 0 then
                            ui.bg:Show()
                            ui.box:Show()
                            ui.line2:Show()
                            ui.box2:Hide()
                            ui.line:Hide()
                        end
                    end
                end
            end
        end
    end

    for sub, ui in (g_towerbox_ui.longta or {}) do
        local towerdata = g_towerbox_str.longta[sub]
        if towerdata ~= nil then
            -- 开启时间
            ui.time:SetText(towerdata.time)
            ui.bg:Hide()
            ui.box:Hide()
            ui.line2:Hide()
            ui.now:Hide()
            -- 关闭显示的都开启
            ui.box2:Show()
            ui.line:Show()

            local nowTower = TowerBox_ProjectInfo_IsInTower(g_towerbox_def.longta, sub, 0)
            if nowTower > 0 then
                ui.now:Show()
            end
        end
        local data = PTDB:LuaFnGetTowerDetailData(g_towerbox_def.longta, sub, 0)
        if data ~= nil and type(data) == "table" and towerdata ~= nil then
            -- 该场景箱子全在
            if data.active < 1 then
                -- 判断当前开启情况
                local curHMS = tonumber(DataPool:GetServerMinuteTime())
                if curHMS > towerdata.opentime then
                    -- 按最大的显示
                    local remainstr = ScriptGlobal_Format("#{PTDB_231225_59}", towerdata.total)
                    ui.time:SetText(remainstr)

                    local bgshow = TowerBox_ProjectInfo_IsTowerShow(g_towerbox_def.longta, sub, 0)
                    if bgshow > 0 then
                        ui.bg:Show()
                        ui.box:Show()
                        ui.line2:Show()
                        ui.box2:Hide()
                        ui.line:Hide()
                    end
                end
            else
                -- 正常显示
                local remainstr = ScriptGlobal_Format("#{PTDB_231225_59}", data.reaminbox)
                ui.time:SetText(remainstr)
                local bgshow = TowerBox_ProjectInfo_IsTowerShow(g_towerbox_def.longta, sub, 0)
                if bgshow > 0 then
                    ui.bg:Show()
                    ui.box:Show()
                    ui.line2:Show()
                    ui.box2:Hide()
                    ui.line:Hide()
                end
            end
        end
    end
end

-- 刷新奖励内容
function TowerBox_ProjectInfo_UpdateRewardUI()
    -- 处理奖励
    local idx = -1
    local realIdx = -1
    for i, ui in (g_towerbox_ui.award or {}) do
        local time = -1
        local name = ""
        local list = g_towerbox_award[i]
        if list ~= nil then
            for j, data in (list.list or {}) do
                local info = PTDB:LuaFnGetTowerDetailData(data[1], data[2] , data[3])
                if info ~= nil and type(info) == "table" then
                    -- 每个奖励找到时间最早的
                    if info.award > 0 and (info.time < time or time < 0) then
                        idx = i
                        time = info.time
                        name = info.name
                        if i < realIdx or realIdx < 0 then
                            realIdx = i
                        end
                    end
                end
            end
        end
        -- 显示名字
        if name == "" then
            ui.name:Hide()
        else
            local ownername = ScriptGlobal_Format("#{PTDB_231225_73}", name)
            ui.name:SetText(ownername)
            ui.name:Show()
        end
        -- 处理黑白框
        if idx > 0 and idx <= i then
            --ui.bg:Hide()
        else
            --ui.bg:Show()
        end
    end
    
    -- 还原UI显示
    for i, ui in (g_towerbox_ui.award or {}) do
        for j, uiget in (ui.get or {}) do
            uiget:Hide()
        end
        for j, uimask in (ui.mask or {}) do
            uimask:Hide()
        end
        for j, uinow in (ui.now or {}) do
            uinow:Hide()
        end
    end

    -- 显示内容块
    for i, ui in (g_towerbox_ui.award or {}) do
        -- 高亮
        if realIdx > 0 and realIdx <= i then
            -- 已经领取的
            if realIdx == i then
                for _, uinow in (ui.now or {}) do
                    uinow:Show()
                end
            end
            -- 已经激活的
            if realIdx < i then
                for _, uimask in (ui.mask or {}) do
                    uimask:Show()
                end
            end
        else
            -- 还没有激活的
            --if realIdx >= i then
                for _, uiget in (ui.get or {}) do
                    uiget:Show()
                end
            --end
        end
    end
        
    -- 显示action
    for i, ui in (g_towerbox_ui.award or {}) do
        local itemdata = g_towerbox_award[i]
        if itemdata ~= nil then
            local rewardlist = g_towerbox_reward[itemdata.reward]
            if rewardlist ~= nil then
                for j, itemId in (rewardlist.item or {}) do
                    if ui.action[j] ~= nil then
                        local theAction = DataPool:CreateActionItemForShow(itemId, 1)
                        if theAction:GetID() ~= 0 then
                            ui.action[j]:SetActionItem(theAction:GetID())
                        end
                    end
                end
            end
        end
    end

    -- 显示开启时间
    local curHMS = tonumber(DataPool:GetServerMinuteTime())
    for i, data in (g_towerbox_ui.timelist or {}) do
        local time = g_towerbox_opentime[i]
        if time ~= nil then
            -- 时间显示
            if curHMS >= time.begin then
                data.open:Show()
                data.close:Hide()
            else
                data.open:Hide()
                data.close:Show()
            end
            -- 背景显示
            if curHMS >= time.begin and curHMS < time.over then
                -- 正在开启
                data.now:Show()
                data.over:Hide()
            elseif curHMS >= time.over then
                -- 已经开启
                data.now:Hide()
                data.over:Show()
            else
                -- 没开启
                data.now:Hide()
                data.over:Hide()
            end
        end
    end
end

-- 显示下拉框
function TowerBox_ProjectInfo_UpdateComboListUI()
    g_towerbox_select = 0
    TowerBox_ProjectInfo_SearchMode:ResetList()
    for i, data in (g_towerbox_combolist or {}) do
        TowerBox_ProjectInfo_SearchMode:AddTextItem(data.str, i-1)
    end

    TowerBox_ProjectInfo_SearchMode:SetCurrentSelect(0)
end

-- 激活心跳
function TowerBox_ProjectInfo_InitTimer()
end

-- 心跳
function TowerBox_ProjectInfo_Timer()
end

-- 选择宝箱类型
function TowerBox_ProjectInfo_Box_Changed()
    local szname, idx = TowerBox_ProjectInfo_SearchMode:GetCurrentSelect()
    if idx >= 0 and idx ~= g_towerbox_select then
        g_towerbox_select = idx
        TowerBox_ProjectInfo_UpdateTowerUI()
    end
    
    -- 对选中塔的情况进行处理
    
end

-- 关闭界面回调
function TowerBox_ProjectInfo_OnHidden()
end


function TowerBox_ProjectInfo_Hide()
    this:Hide()
end

function TowerBox_ProjectInfo_OnClosed()
    TowerBox_ProjectInfo_OpenDetail()
end

-- 显示详情信息
function TowerBox_ProjectInfo_OpenDetail()
    TowerBox_ProjectInfo_Hide()
    PushEvent("PTDB_OPEN_TOWERBOX_UI")
end

function TowerBox_ProjectInfo_IsInTower(fst, sec, tower)
    local curSceneID = GetSceneID()
    local data = g_towerbox_scenegroup[curSceneID]
    if data ~= nil then
        if data.fst == fst and data.sec == sec and data.tower == tower then
            return 1
        end 
    end

    return -1
end

-- 是否现在应该显示出来的背景塔图
function TowerBox_ProjectInfo_IsTowerShow(fst, floor, tower)
    if g_towerbox_select == nil or g_towerbox_select <= 0 then
        return 1
    end

    local idx = g_towerbox_select+1
    local data = g_towerbox_combolist[idx]
    if data ~= nil and data.select ~= nil then
        for i, select in (data.select or {}) do
            local award = g_towerbox_award[select]
            if award ~= nil and award.list ~= nil then
                for j, info in (award.list or {}) do
                    if info[1] == fst and info[2] == floor and info[3] == tower then
                        return 1
                    end
                end
            end
        end
    end

    return 0
end

function TowerBox_ProjectInfo_Award2_Item1(index)
end