-- 跨服爬塔夺宝 龙塔三层奖励（神龙祝福）宝箱信息牴示UI

-- 默认位置
local TowerBox_AwardInfo_UnifiedPosition = nil
-- 控件表
local TowerBox_AwardInfo_CtrlList = nil

-- 奖励物品
local TowerBox_AwardInfo_AwardItem =
{
    [1] = {id = 30502002, num = 10},
    [2] = {id = 30503020, num = 1},
    [3] = {id = 20310116, num = 4},
    [4] = {id = 38002532, num = 5},
    [5] = {id = 30310104, num = 1},
} -- end TowerBox_AwardInfo_AwardItem



function TowerBox_AwardInfo_PreLoad()
    this:RegisterEvent("PTDB_UI_AWARDINFO", true)
    this:RegisterEvent("PTDB_UI_CLOSEBOXINFO", true)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)     -- ?????????
	this:RegisterEvent("ADJEST_UI_POS",false)               -- ????????
end -- end func TowerBox_AwardInfo_PreLoad()

function TowerBox_AwardInfo_OnEvent(event)
	if (event == "PTDB_UI_AWARDINFO") then
		TowerBox_AwardInfo_UpdateBoxInfo()
		TowerBox_AwardInfo_Show()
    elseif (event == "PTDB_UI_CLOSEBOXINFO") then
        TowerBox_AwardInfo_Hide()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		TowerBox_AwardInfo_Hide()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TowerBox_AwardInfo_UnifiedPos()
	elseif (event == "ADJEST_UI_POS") then
		TowerBox_AwardInfo_UnifiedPos()
	end
end -- end func TowerBox_AwardInfo_OnEvent()

function TowerBox_AwardInfo_OnLoad()
	TowerBox_AwardInfo_UnifiedPosition = TowerBox_AwardInfo_Frame:GetProperty("UnifiedPosition")
end -- end func TowerBox_AwardInfo_OnLoad()

function TowerBox_AwardInfo_OnHidden()
end -- end func TowerBox_AwardInfo_OnHidden()

function TowerBox_AwardInfo_OnClosed()
	TowerBox_AwardInfo_Hide()
end -- end func TowerBox_AwardInfo_OnClosed()

-- 界面默认位置
function TowerBox_AwardInfo_UnifiedPos()
	if (TowerBox_AwardInfo_UnifiedPosition ~= nil) then
		TowerBox_AwardInfo_Frame:SetProperty("UnifiedPosition", TowerBox_AwardInfo_UnifiedPosition)
	end
end -- end func TowerBox_AwardInfo_UnifiedPos()

function TowerBox_AwardInfo_Show()
	this:Show()
end -- end func TowerBox_AwardInfo_Show()

function TowerBox_AwardInfo_Hide()
	this:Hide()
end -- end func TowerBox_AwardInfo_Hide()

function TowerBox_AwardInfo_UpdateBoxInfo()
    local itemId = -1
    local itemNum = 1

    -- 1
    if (TowerBox_AwardInfo_Item1 ~= nil and TowerBox_AwardInfo_Item1:GetActionItem() == -1) then
        itemId = TowerBox_AwardInfo_AwardItem[1].id
        itemNum = TowerBox_AwardInfo_AwardItem[1].num
        local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
        if theAction:GetID() ~= 0 then
            TowerBox_AwardInfo_Item1:SetActionItem(theAction:GetID())
        else
            TowerBox_AwardInfo_Item1:SetActionItem(-1)
        end
    end

    -- 2
    if (TowerBox_AwardInfo_Item2 ~= nil and TowerBox_AwardInfo_Item2:GetActionItem() == -1) then
        itemId = TowerBox_AwardInfo_AwardItem[2].id
        itemNum = TowerBox_AwardInfo_AwardItem[2].num
        local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
        if theAction:GetID() ~= 0 then
            TowerBox_AwardInfo_Item2:SetActionItem(theAction:GetID())
        else
            TowerBox_AwardInfo_Item2:SetActionItem(-1)
        end
    end

    -- 3
    if (TowerBox_AwardInfo_Item3 ~= nil and TowerBox_AwardInfo_Item3:GetActionItem() == -1) then
        itemId = TowerBox_AwardInfo_AwardItem[3].id
        itemNum = TowerBox_AwardInfo_AwardItem[3].num
        local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
        if theAction:GetID() ~= 0 then
            TowerBox_AwardInfo_Item3:SetActionItem(theAction:GetID())
        else
            TowerBox_AwardInfo_Item3:SetActionItem(-1)
        end
    end

    -- 4
    if (TowerBox_AwardInfo_Item4 ~= nil and TowerBox_AwardInfo_Item4:GetActionItem() == -1) then
        itemId = TowerBox_AwardInfo_AwardItem[4].id
        itemNum = TowerBox_AwardInfo_AwardItem[4].num
        local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
        if theAction:GetID() ~= 0 then
            TowerBox_AwardInfo_Item4:SetActionItem(theAction:GetID())
        else
            TowerBox_AwardInfo_Item4:SetActionItem(-1)
        end
    end

    -- 5
    if (TowerBox_AwardInfo_Item5 ~= nil and TowerBox_AwardInfo_Item5:GetActionItem() == -1) then
        itemId = TowerBox_AwardInfo_AwardItem[5].id
        itemNum = TowerBox_AwardInfo_AwardItem[5].num
        local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
        if theAction:GetID() ~= 0 then
            TowerBox_AwardInfo_Item5:SetActionItem(theAction:GetID())
        else
            TowerBox_AwardInfo_Item5:SetActionItem(-1)
        end
    end
end -- end func TowerBox_AwardInfo_UpdateBoxInfo()
