--华山论剑 参赛奖励预览界面
local g_HuaShanLunJian_Award_Frame_UnifiedPosition;

local g_HuaShanLunJian_Award_ActionItem = {}
local g_HuaShanLunJian_Award_Info = {
	{dw=6,desc="#{HSPH_191120_81}"},
	{dw=5,desc="#{HSPH_191120_80}"},
	{dw=4,desc="#{HSPH_191120_79}"},
	{dw=3,desc="#{HSPH_191120_78}"},
	{dw=2,desc="#{HSPH_191120_77}"},
	{dw=1,desc="#{HSPH_191120_76}"},
}
function HuaShanLunJian_Award_PreLoad()
	this:RegisterEvent("XBW_AWRADSHOW_OPEN")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function HuaShanLunJian_Award_OnLoad()
	g_HuaShanLunJian_Award_ActionItem = {
		{item={HuaShanLunJian_TopListAward_Icon1,HuaShanLunJian_TopListAward_Icon1_2,},desc=HuaShanLunJian_TopListAward_AwardInfo1,},
		{item={HuaShanLunJian_TopListAward_Icon2,HuaShanLunJian_TopListAward_Icon2_2,},desc=HuaShanLunJian_TopListAward_AwardInfo2,},
		{item={HuaShanLunJian_TopListAward_Icon3,HuaShanLunJian_TopListAward_Icon3_2,},desc=HuaShanLunJian_TopListAward_AwardInfo3,},
		{item={HuaShanLunJian_TopListAward_Icon4,HuaShanLunJian_TopListAward_Icon4_2,},desc=HuaShanLunJian_TopListAward_AwardInfo4,},
		{item={HuaShanLunJian_TopListAward_Icon5,HuaShanLunJian_TopListAward_Icon5_2,},desc=HuaShanLunJian_TopListAward_AwardInfo5,},
		{item={HuaShanLunJian_TopListAward_Icon6,HuaShanLunJian_TopListAward_Icon6_2,},desc=HuaShanLunJian_TopListAward_AwardInfo6,},
	}
	g_HuaShanLunJian_Award_Frame_UnifiedPosition = HuaShanLunJian_TopListAward_Frame:GetProperty("UnifiedPosition")
end

-- OnEvent
function HuaShanLunJian_Award_OnEvent(event)
	if ( event == "XBW_AWRADSHOW_OPEN" ) then
		HuaShanLunJian_Award_Show()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		HuaShanLunJian_Award_Hide()
	elseif (event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Award_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_Award_ResetPos()
	end
end

function HuaShanLunJian_Award_Show()
	HuaShanLunJian_Award_Update()
	this:Show()
end

function HuaShanLunJian_Award_Update()
	-- 获取当前的等级段
	local levelIndex = Player:Lua_GetXbwData("LevelIndex")
	if levelIndex < 0 then
		levelIndex = 0
	end

	for i, data in (g_HuaShanLunJian_Award_Info or {}) do
		local ui = g_HuaShanLunJian_Award_ActionItem[i]
		if ui ~= nil then
			for idx, itemAction in (ui.item) do
				local itemId, itemNum = XBW:GetXbwDayAward_New(idx-1, levelIndex, data.dw)
				local theAction = DataPool:CreateActionItemForShow(itemId, itemNum)
				if theAction:GetID() ~= 0 then
					itemAction:SetActionItem(theAction:GetID())
				else
					itemAction:SetActionItem(-1)
				end
			end

			ui.desc:SetText(data.desc)
		end
	end
	
end

function HuaShanLunJian_TopListAward_Hide()
	HuaShanLunJian_Award_Hide()
end

function HuaShanLunJian_Award_Hide()
	this:Hide()
end

function HuaShanLunJian_Award_ResetPos()
	HuaShanLunJian_TopListAward_Frame:SetProperty("UnifiedPosition", g_HuaShanLunJian_Award_Frame_UnifiedPosition)
end
