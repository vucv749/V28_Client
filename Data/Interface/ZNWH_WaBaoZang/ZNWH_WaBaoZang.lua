local ZNWH_objCared = -1
local MAX_OBJ_DISTANCE = 5.0

local ZNWH_WaBaoZang_UnifiedPosition
local ZNWH_WaBaoZang_NPC_ObjId = -1
local ZNWH_WaBaoZang_FinishTimes = 0

-- local ZNWH_WaBaoZang_Titles = {}
local ZNWH_WaBaoZang_Buttons = {}
local ZNWH_WaBaoZang_Anims = {}     --在可以领取时显示
local ZNWH_WaBaoZang_Marks = {}     --在已经领取时显示

local ZNWH_WaBaoZang_Reward = {
	[1] = {itemid = 20800013, num = 6, times = 2 }, --累积2次礼
	[2] = {itemid = 38002532, num = 10,times = 5 }, --累积5次礼
	[3] = {itemid = 38002519, num = 2, times = 8 }  --累积8次礼
}

-- 注册窗口关心的所有事件
function ZNWH_WaBaoZang_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
	this:RegisterEvent("OBJECT_CARED_EVENT", false)
end

-- 初始化
function ZNWH_WaBaoZang_OnLoad()
    for i = 1, table.getn(ZNWH_WaBaoZang_Reward) do
        local pre_s = "ZNWH_WaBaoZang_CUM"..i
        ZNWH_WaBaoZang_Anims[i]     = _G[pre_s.."Btn_ItemAnimate"]
        ZNWH_WaBaoZang_Marks[i]     = _G[pre_s.."BtnOK"]
        ZNWH_WaBaoZang_Buttons[i]   = _G[pre_s.."Btn"]
        ZNWH_WaBaoZang_Buttons[i]:SetToolTip("#{ZNWB_230625_8"..i.."}")
        _G[pre_s.."Text"]:SetText("#G"..ZNWH_WaBaoZang_Reward[i].times)
    end
	ZNWH_WaBaoZang_UnifiedPosition = ZNWH_WaBaoZangFrame:GetProperty("UnifiedPosition")
end

-- 事件处理
function ZNWH_WaBaoZang_OnEvent(event)
	if event == "UI_COMMAND" and tonumber(arg0) == 2505532 then
        local awd_size = table.getn(ZNWH_WaBaoZang_Reward)
        ZNWH_WaBaoZang_NPC_ObjId = Get_XParam_INT(0)
        ZNWH_WaBaoZang_FinishTimes = Get_XParam_INT(awd_size + 1)
		if not this:IsVisible() then
			for i = 1, awd_size do
				local theAction = DataPool:CreateBindActionItemForShow(ZNWH_WaBaoZang_Reward[i].itemid, ZNWH_WaBaoZang_Reward[i].num)
				if theAction:GetID() ~= 0 then
					ZNWH_WaBaoZang_Buttons[i]:SetActionItem(theAction:GetID())
				end
			end
		end
        ZNWH_WaBaoZang_Refresh()
        this:Show()

	elseif event == "OBJECT_CARED_EVENT" then
		if tonumber(arg0) ~= ZNWH_objCared then
			return
		end
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			if this:IsVisible() then
				ZNWH_WaBaoZangOnHiden()
			end
		end

	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ZNWH_WaBaoZangFrame:SetProperty("UnifiedPosition", ZNWH_WaBaoZang_UnifiedPosition)

	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ZNWH_WaBaoZangOnHiden()
	end
end

-- 界面刷新
function ZNWH_WaBaoZang_Refresh()
	ZNWH_objCared = DataPool:GetNPCIDByServerID(ZNWH_WaBaoZang_NPC_ObjId)
	if ZNWH_objCared ~= -1 then
		this:CareObject(ZNWH_objCared, 1, "ZNWH_WaBaoZang")
	end

	ZNWH_WaBaoZang_CUMText:SetText(ScriptGlobal_Format("#{ZNWB_230625_80}", ZNWH_WaBaoZang_FinishTimes))

    local btn_size = table.getn(ZNWH_WaBaoZang_Reward)
	local max_progress_value = ZNWH_WaBaoZang_Reward[btn_size].times
	if ZNWH_WaBaoZang_FinishTimes > max_progress_value then
		ZNWH_WaBaoZang_FinishTimes = max_progress_value
	end

    local title_id = 0
    local can_get = false
	for i = 1, btn_size do
        -- 1 已领取
		if Get_XParam_INT(i) == 1 then
			-- ZNWH_WaBaoZang_Buttons[i]:Disable()
			ZNWH_WaBaoZang_Marks[i]:Show()
            ZNWH_WaBaoZang_Anims[i]:Play(false)
            ZNWH_WaBaoZang_Anims[i]:Hide()
        -- 2 未领取
		else
			ZNWH_WaBaoZang_Marks[i]:Hide()
            -- 2.1 可领取
			if ZNWH_WaBaoZang_FinishTimes >= ZNWH_WaBaoZang_Reward[i].times and false == can_get then
                ZNWH_WaBaoZang_Anims[i]:Play(true)
                ZNWH_WaBaoZang_Anims[i]:Show()
                -- can_get = true
            -- 2.2 不可领取
			else
                ZNWH_WaBaoZang_Anims[i]:Play(false)
                ZNWH_WaBaoZang_Anims[i]:Hide()
			end
		end
        -- 设置头衔
        if ZNWH_WaBaoZang_FinishTimes >= ZNWH_WaBaoZang_Reward[i].times then
            title_id = i
        end
	end
    -- 头衔显隐
    -- for i = 1, btn_size do
    --     if i ~= title_id then
    --         ZNWH_WaBaoZang_Titles[i]:Hide()
    --     else
    --         ZNWH_WaBaoZang_Titles[i]:Show()
    --     end
    -- end
	-- 进度条
	ZNWH_WaBaoZang_Progress:SetProgress(ZNWH_WaBaoZang_FinishTimes, max_progress_value)
end

-- 控件事件: 领取奖励
function ZNWH_WaBaoZang_OnRewardClick(idx)
	if type(idx) ~= "number" then
		return
	end
	if idx > table.getn(ZNWH_WaBaoZang_Reward) or idx < 1 then
		return
	end
	-- if ZNWH_WaBaoZang_Buttons[idx]:GetProperty("Disabled") == "True" then
	-- 	return
	-- end
	if ZNWH_WaBaoZang_FinishTimes < ZNWH_WaBaoZang_Reward[idx].times then
		PushDebugMessage("#{BBWH_211230_24}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGetBaoTu")
		Set_XSCRIPT_ScriptID(250553)
		Set_XSCRIPT_Parameter(0, ZNWH_WaBaoZang_NPC_ObjId)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

-- 界面关闭事件
function ZNWH_WaBaoZangOnHiden()
	this:CareObject(ZNWH_objCared, 0, "ZNWH_WaBaoZang")
	ZNWH_objCared = -1
	this:Hide()
end