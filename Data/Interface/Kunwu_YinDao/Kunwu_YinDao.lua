--Kunwu_YinDao.lua
local g_Kunwu_YinDaoFrame_UnifiedXPosition
local g_Kunwu_YinDaoFrame_UnifiedYPosition
local g_Kunwu_YinDao_ModTableMDIndex      = {
	[1] = { pos = 0, len = 1 },
	[2] = { pos = 1, len = 1 },
	[3] = { pos = 2, len = 1 },
	[4] = { pos = 3, len = 1 },
	[5] = { pos = 4, len = 1 },
	[6] = { pos = 5, len = 1 },
	[7] = { pos = 6, len = 1 },
	[8] = { pos = 7, len = 1 },
	[9] = { pos = 8, len = 1 },
	[10] = { pos = 9, len = 1 },
	[11] = { pos = 10, len = 1 },
	[12] = { pos = 11, len = 1 },
	[13] = { pos = 12, len = 1 },
}
--local ret = LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(pos) error:ret = -1
local g_Kunwu_YinDao_MDIndex_IsZhiluGet   = 4
local g_Kunwu_YinDao_ZhiluItemUIIndex     = 1
local g_Kunwu_YinDao_ModTable             =
{
	[1] = {
		name = "set:Kunwu_YinDao image:Kunwu_YinDao_QH_Hover",
		intro = "#{ZSYD_241218_13}",
		conditionNum = 1,
		missionFlag = 1332,
		conditionTable = { --g_Kunwu_YinDao_ModTableMDIndex
			[1] = { mdIndex = 5, conStr = "#{ZSYD_241218_23}", },
		},
		itemNum = 1,
		itemTable = {
			[1] = {itemId = 38002625, itemNum = 2},
		},
	},
	[2] = {
		name = "set:Kunwu_YinDao image:Kunwu_YinDao_SW_Hover",
		intro = "#{ZSYD_241218_17}",
		conditionNum = 1,
		missionFlag = 1334,
		conditionTable = {
			[1] = { mdIndex = 10, conStr = "#{ZSYD_241218_18}" },
		},
		itemNum = 2,
		itemTable = {
			[1] = {itemId = 38002625, itemNum = 2},
			[2] = {itemId = 38003439, itemNum = 1},
		},
	},
	[3] = {
		name = "set:Kunwu_YinDao image:Kunwu_YinDao_XLuo_Hover",
		intro = "#{ZSYD_241218_19}",
		conditionNum = 1,
		missionFlag = 1335,
		conditionTable = {
			[1] = { mdIndex = 11, conStr = "#{ZSYD_241218_20}", },
		},
		itemNum = 2,
		itemTable = {
			[1] = {itemId = 38002625, itemNum = 2},
			[2] = {itemId = 38003489, itemNum = 1},
		},
	},
	[4] = {
		name = "set:Kunwu_YinDao image:Kunwu_YinDao_XL_Hover",
		intro = "#{ZSYD_241218_15}",
		conditionNum = 3,
		missionFlag = 1333,
		conditionTable = {
			[1] = { mdIndex = 7, conStr = "#{ZSYD_241218_38}", },
			[2] = { mdIndex = 8, conStr = "#{ZSYD_241218_39}", },
			[3] = { mdIndex = 9, conStr = "#{ZSYD_241218_16}", },
		},
		itemNum = 1,
		itemTable = {
			[1] = {itemId = 38002625, itemNum = 2},
		},
	},
	[5] = {
		name = "set:Kunwu_YinDao image:Kunwu_YinDao_ZS_Hover",
		intro = "#{ZSYD_241218_21}",
		conditionNum = 2,
		missionFlag = 1336,
		conditionTable = {
			[1] = { mdIndex = 12, conStr = "#{ZSYD_241218_40}", },
			[2] = { mdIndex = 13, conStr = "#{ZSYD_241218_22}", },
		},
		itemNum = 1,
		itemTable = {
			[1] = {itemId = 38002625, itemNum = 2},
		},
	},
}
local g_Kunwu_YinDao_ModTableCount        = 5
local g_Kunwu_YinDao_CurSelectMod         = 1
local g_Kunwu_YinDao_MaxConditionStr      = 3
local g_Kunwu_YinDao_MaxItemBtnNum        = 3


local g_Kunwu_YinDao_Button = {}
local g_Kunwu_YinDao_TaskOver = {}
local g_Kunwu_YinDao_Item = {}
local g_Kunwu_YinDao_ItemMask = {}
local g_Kunwu_YinDao_ItemAnim = {}
local g_Kunwu_YinDao_ItemMaxCount = 3

local g_Kunwu_YinDaoFrame_Intro2_Image = {}
local g_Kunwu_YinDaoFrame_Intro2_Text = {}

local g_Kunwu_YinDao_ButtonImage = 
{
	[1] = { normal = "set:Kunwu_YinDao image:Kunwu_YinDao_QH_Normal", hover="set:Kunwu_YinDao image:Kunwu_YinDao_QH_Over"},
	[2] = { normal = "set:Kunwu_YinDao image:Kunwu_YinDao_SW_Normal", hover="set:Kunwu_YinDao image:Kunwu_YinDao_SW_Over"},
	[3] = { normal = "set:Kunwu_YinDao image:Kunwu_YinDao_XLuo_Normal", hover="set:Kunwu_YinDao image:Kunwu_YinDao_XLuo_Over"},
	[4] = { normal = "set:Kunwu_YinDao image:Kunwu_YinDao_XL_Normal", hover="set:Kunwu_YinDao image:Kunwu_YinDao_XL_Over"},
	[5] = { normal = "set:Kunwu_YinDao image:Kunwu_YinDao_ZS_Normal", hover="set:Kunwu_YinDao image:Kunwu_YinDao_ZS_Over"},
}

local g_Kunwu_YinDao_SpeModIdx1        = 2
local g_Kunwu_YinDao_SpeModIdx1_MdPos  = 13
local g_Kunwu_YinDao_SpeModIdx2        = 3
local g_Kunwu_YinDao_SpeModIdx2_MdPos  = 14


function Kunwu_YinDao_PreLoad()
	--第二个参数代表界面隐藏时事件是否有效,默认为true
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function Kunwu_YinDao_OnLoad()
	g_Kunwu_YinDaoFrame_UnifiedXPosition = Kunwu_YinDaoFrame:GetProperty("UnifiedXPosition")
	g_Kunwu_YinDaoFrame_UnifiedYPosition = Kunwu_YinDaoFrame:GetProperty("UnifiedYPosition")
	Kunwu_YinDaoFrame_InitControlerOnLoad()
end

--=========================================================
-- 事件处理
--=========================================================
function Kunwu_YinDao_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 21222201) then
		local opType = Get_XParam_INT(0)
		if opType == 1 then
			Kunwu_YinDaoFrame_Show(Get_XParam_INT(1))
		elseif opType == 2 then
			if this:IsVisible() then
				Kunwu_YinDaoFrame_UpdateLeftControler()
				Kunwu_YinDaoFrame_UpdateRightControler()
			end
		elseif opType == 99 then
			Kunwu_YinDaoFrame_Charts_CloseClick()
		end
	end

	if (event == "ADJEST_UI_POS") then
		Kunwu_YinDao_ResetPos()
	end

	if (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_YinDao_ResetPos()
	end

	if (event == "HIDE_ON_SCENE_TRANSED") then
		Kunwu_YinDaoFrame_Charts_CloseClick()
	end

end

function Kunwu_YinDaoFrame_Init()
	g_Kunwu_YinDao_CurSelectMod = 1
	Kunwu_YinDaoFrame_Intro:SetText("")
	for i = g_Kunwu_YinDao_ZhiluItemUIIndex + 1, g_Kunwu_YinDao_ItemMaxCount do
		if g_Kunwu_YinDao_Item[i] ~= nil then
			g_Kunwu_YinDao_Item[i]:Hide()
			g_Kunwu_YinDao_Item[i]:SetActionItem( -1 )
		end
		if g_Kunwu_YinDao_ItemMask[i] ~= nil then
			g_Kunwu_YinDao_ItemMask[i]:Hide()
		end
		if g_Kunwu_YinDao_ItemAnim[i] ~= nil then
			g_Kunwu_YinDao_ItemAnim[i]:Hide()
		end
	end
end

function Kunwu_YinDaoFrame_Show(id)
	if id == 0 then --????
		Kunwu_YinDaoFrame_BK1:Hide()
		Kunwu_YinDaoFrame_BK2:Show()
		this:Show()
	elseif id == 1 then --????
		Kunwu_YinDaoFrame_BK1:Show()
		Kunwu_YinDaoFrame_BK2:Hide()
		Kunwu_YinDaoFrame_Init()
		Kunwu_YinDaoFrame_UpdateLeftControler()
		Kunwu_YinDaoFrame_UpdateRightControler()
		this:Show()
	else
		Kunwu_YinDaoFrame_Charts_CloseClick()
	end
end

function Kunwu_YinDaoFrame_InitControlerOnLoad()
	--button
	g_Kunwu_YinDao_Button[1] = Kunwu_YinDaoFrame_Button1
	g_Kunwu_YinDao_Button[2] = Kunwu_YinDaoFrame_Button2
	g_Kunwu_YinDao_Button[3] = Kunwu_YinDaoFrame_Button3
	g_Kunwu_YinDao_Button[4] = Kunwu_YinDaoFrame_Button4
	g_Kunwu_YinDao_Button[5] = Kunwu_YinDaoFrame_Button5
	--taskover
	g_Kunwu_YinDao_TaskOver[1] = Kunwu_YinDaoFrame_Button1_Cover
	g_Kunwu_YinDao_TaskOver[2] = Kunwu_YinDaoFrame_Button2_Cover
	g_Kunwu_YinDao_TaskOver[3] = Kunwu_YinDaoFrame_Button3_Cover
	g_Kunwu_YinDao_TaskOver[4] = Kunwu_YinDaoFrame_Button4_Cover
	g_Kunwu_YinDao_TaskOver[5] = Kunwu_YinDaoFrame_Button5_Cover
	--right
	Kunwu_YinDaoFrame_Intro:SetText("")
	--actionbutton
	g_Kunwu_YinDao_Item[1] = Kunwu_YinDaoFrame_Item1
	g_Kunwu_YinDao_Item[2] = Kunwu_YinDaoFrame_Item2
	g_Kunwu_YinDao_Item[3] = Kunwu_YinDaoFrame_Item3
	--itemmask
	g_Kunwu_YinDao_ItemMask[1] = Kunwu_YinDaoFrame_Item1_Mask
	g_Kunwu_YinDao_ItemMask[2] = Kunwu_YinDaoFrame_Item2_Mask
	g_Kunwu_YinDao_ItemMask[3] = Kunwu_YinDaoFrame_Item3_Mask
	--itemanim
	g_Kunwu_YinDao_ItemAnim[1] = Kunwu_YinDaoFrame_Item1_Animate
	g_Kunwu_YinDao_ItemAnim[2] = Kunwu_YinDaoFrame_Item2_Animate
	g_Kunwu_YinDao_ItemAnim[3] = Kunwu_YinDaoFrame_Item3_Animate
	--hide item
	for i = g_Kunwu_YinDao_ZhiluItemUIIndex + 1, g_Kunwu_YinDao_ItemMaxCount do
		if g_Kunwu_YinDao_Item[i] ~= nil then
			g_Kunwu_YinDao_Item[i]:Hide()
			g_Kunwu_YinDao_Item[i]:SetActionItem( -1 )
		end
		if g_Kunwu_YinDao_ItemMask[i] ~= nil then
			g_Kunwu_YinDao_ItemMask[i]:Hide()
		end
		if g_Kunwu_YinDao_ItemAnim[i] ~= nil then
			g_Kunwu_YinDao_ItemAnim[i]:Hide()
		end
	end
	if g_Kunwu_YinDao_Item[g_Kunwu_YinDao_ZhiluItemUIIndex] ~= nil then
		local theAction = DataPool:CreateBindActionItemForShow(38002781, 1)
		if theAction:GetID() ~= 0 then
			g_Kunwu_YinDao_Item[g_Kunwu_YinDao_ZhiluItemUIIndex]:SetActionItem( theAction:GetID() )
		else
			g_Kunwu_YinDao_Item[g_Kunwu_YinDao_ZhiluItemUIIndex]:SetActionItem( -1 );
		end
	end
	if g_Kunwu_YinDao_ItemMask[g_Kunwu_YinDao_ZhiluItemUIIndex] ~= nil then
		g_Kunwu_YinDao_ItemMask[g_Kunwu_YinDao_ZhiluItemUIIndex]:Hide()
	end
	if g_Kunwu_YinDao_ItemAnim[g_Kunwu_YinDao_ZhiluItemUIIndex] ~= nil then
		g_Kunwu_YinDao_ItemAnim[g_Kunwu_YinDao_ZhiluItemUIIndex]:Hide()
	end
	--intro
	g_Kunwu_YinDaoFrame_Intro2_Image[1] = Kunwu_YinDaoFrame_Intro2_Image1
	g_Kunwu_YinDaoFrame_Intro2_Image[2] = Kunwu_YinDaoFrame_Intro2_Image2
	g_Kunwu_YinDaoFrame_Intro2_Image[3] = Kunwu_YinDaoFrame_Intro2_Image3

	g_Kunwu_YinDaoFrame_Intro2_Text[1] = Kunwu_YinDaoFrame_Intro2_Text1
	g_Kunwu_YinDaoFrame_Intro2_Text[2] = Kunwu_YinDaoFrame_Intro2_Text3
	g_Kunwu_YinDaoFrame_Intro2_Text[3] = Kunwu_YinDaoFrame_Intro2_Text5
end

function Kunwu_YinDaoFrame_UpdateLeftControler()
	for i = 1, g_Kunwu_YinDao_ModTableCount do
		if g_Kunwu_YinDao_Button[i] ~= nil and g_Kunwu_YinDao_TaskOver[i] ~= nil and g_Kunwu_YinDao_ModTable[i] ~= nil then
			local allDone = 1
			local maxMissionNeed = g_Kunwu_YinDao_ModTable[i].conditionNum
			local conditionTbl = {}
			conditionTbl = g_Kunwu_YinDao_ModTable[i].conditionTable
			for j = 1, maxMissionNeed do
				if conditionTbl ~= nil and conditionTbl[j] ~= nil then
					local mdIndex = conditionTbl[j].mdIndex
					if g_Kunwu_YinDao_ModTableMDIndex[mdIndex] ~= nil then
						local mdPos = g_Kunwu_YinDao_ModTableMDIndex[mdIndex].pos
						local value = DataPool:LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(mdPos)
						if value ~= 1 then
							allDone = 0
						end
					end
				end
			end
			--icon
			if allDone == 1 then
				g_Kunwu_YinDao_TaskOver[i]:Show()
			else
				g_Kunwu_YinDao_TaskOver[i]:Hide()
			end
			--button check
			if g_Kunwu_YinDao_Button[i] ~= nil then
				g_Kunwu_YinDao_Button[i]:SetProperty("NormalImage", g_Kunwu_YinDao_ButtonImage[i].normal)
			end
		end
	end
	--button check
	if g_Kunwu_YinDao_Button[g_Kunwu_YinDao_CurSelectMod] ~= nil then
		g_Kunwu_YinDao_Button[g_Kunwu_YinDao_CurSelectMod]:SetProperty("NormalImage", g_Kunwu_YinDao_ButtonImage[g_Kunwu_YinDao_CurSelectMod].hover)
	end
end

function Kunwu_YinDaoFrame_UpdateRightControler()
	if g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod] ~= nil then
		Kunwu_YinDaoFrame_Lace3_Title:SetProperty("Image",g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].name)
		Kunwu_YinDaoFrame_Intro:SetText(g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].intro)

		local allDone = 1
		local maxMissionNeed = g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].conditionNum
		local conditionTbl = {}
		conditionTbl = g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].conditionTable
		for i = 1, g_Kunwu_YinDao_MaxConditionStr do
			g_Kunwu_YinDaoFrame_Intro2_Image[i]:Hide()
			g_Kunwu_YinDaoFrame_Intro2_Text[i]:Hide()
		end
		for i = 1, maxMissionNeed do
			if conditionTbl ~= nil and conditionTbl[i] ~= nil then
				local mdIndex = conditionTbl[i].mdIndex
				local conStr = conditionTbl[i].conStr
				local strIsFinish = ""
				if g_Kunwu_YinDao_ModTableMDIndex[mdIndex] ~= nil then
					local mdPos = g_Kunwu_YinDao_ModTableMDIndex[mdIndex].pos
					local value = 0
					value = DataPool:LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(mdPos)
					if value == 1 then
						strIsFinish = "#{ZSYD_241218_26}"
					else
						allDone = 0
						strIsFinish = "#{ZSYD_241218_25}"
					end
					strIsFinish = ScriptGlobal_Format(conStr, tostring(value), strIsFinish)
				end
				if strIsFinish ~= "" then
					g_Kunwu_YinDaoFrame_Intro2_Image[i]:Show()
					g_Kunwu_YinDaoFrame_Intro2_Text[i]:Show()
					g_Kunwu_YinDaoFrame_Intro2_Text[i]:SetText(strIsFinish)
				end
			end
		end
		--getbutton itemImage
		local itemNum = g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].itemNum
		local itemTbl = {}
		itemTbl = g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].itemTable
		local isThisModItemGet = {1,1}
		isThisModItemGet[1] = DataPool:LuaFnGetMF(g_Kunwu_YinDao_ModTable[g_Kunwu_YinDao_CurSelectMod].missionFlag)
		if g_Kunwu_YinDao_CurSelectMod == g_Kunwu_YinDao_SpeModIdx1 then
			isThisModItemGet[2] = DataPool:LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(g_Kunwu_YinDao_SpeModIdx1_MdPos)
		end
		if g_Kunwu_YinDao_CurSelectMod == g_Kunwu_YinDao_SpeModIdx2 then
			isThisModItemGet[2] = DataPool:LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(g_Kunwu_YinDao_SpeModIdx2_MdPos)
		end
		for i = 2, g_Kunwu_YinDao_ItemMaxCount do
			local itemUiIndex = i
			local itemTblIndex = i - 1
			if itemTblIndex >= 1 and itemTblIndex <= itemNum and itemTbl ~= nil and itemTbl[itemTblIndex] ~= nil then
				g_Kunwu_YinDao_Item[itemUiIndex]:Show()
				local theAction = DataPool:CreateBindActionItemForShow(itemTbl[itemTblIndex].itemId, itemTbl[itemTblIndex].itemNum)
				if theAction:GetID() ~= 0 then
					g_Kunwu_YinDao_Item[itemUiIndex]:SetActionItem( theAction:GetID() )
				else
					g_Kunwu_YinDao_Item[itemUiIndex]:SetActionItem( -1 )
				end
				if isThisModItemGet[itemTblIndex] == 1 then
					if g_Kunwu_YinDao_ItemMask[itemUiIndex] ~= nil then
						g_Kunwu_YinDao_ItemMask[itemUiIndex]:Show() --pickup
					end
					if g_Kunwu_YinDao_ItemAnim[itemUiIndex] ~= nil then
						g_Kunwu_YinDao_ItemAnim[itemUiIndex]:Hide()
					end
				else
					if g_Kunwu_YinDao_ItemMask[itemUiIndex] ~= nil then
						g_Kunwu_YinDao_ItemMask[itemUiIndex]:Hide()
					end
					if g_Kunwu_YinDao_ItemAnim[itemUiIndex] ~= nil then
						if allDone == 1 then
							g_Kunwu_YinDao_ItemAnim[itemUiIndex]:Show()
						else
							g_Kunwu_YinDao_ItemAnim[itemUiIndex]:Hide()
						end
					end
				end
			else
				if g_Kunwu_YinDao_ItemMask[itemUiIndex] ~= nil then
					g_Kunwu_YinDao_ItemMask[itemUiIndex]:Hide()
				end
				if g_Kunwu_YinDao_Item[itemUiIndex] ~= nil then
					g_Kunwu_YinDao_Item[itemUiIndex]:Hide()
					g_Kunwu_YinDao_Item[itemUiIndex]:SetActionItem( -1 )
				end
				if g_Kunwu_YinDao_ItemAnim[itemUiIndex] ~= nil then
					g_Kunwu_YinDao_ItemAnim[itemUiIndex]:Hide()
				end
			end
		end
		--zhilu item pickup anim
		local mdPos = g_Kunwu_YinDao_ModTableMDIndex[g_Kunwu_YinDao_MDIndex_IsZhiluGet].pos
		local isGetZhilu = DataPool:LuaFnGet2025Q1ZSBBYDMD_ConditionIsFinish(mdPos)
		local theAction = DataPool:CreateBindActionItemForShow(38002781, 1)
		if theAction:GetID() ~= 0 then
			g_Kunwu_YinDao_Item[g_Kunwu_YinDao_ZhiluItemUIIndex]:SetActionItem( theAction:GetID() )
		else
			g_Kunwu_YinDao_Item[g_Kunwu_YinDao_ZhiluItemUIIndex]:SetActionItem( -1 );
		end
		if isGetZhilu == 1 then
			g_Kunwu_YinDao_ItemMask[g_Kunwu_YinDao_ZhiluItemUIIndex]:Show()
		else
			g_Kunwu_YinDao_ItemMask[g_Kunwu_YinDao_ZhiluItemUIIndex]:Hide()
		end
		if allDone == 1 and isGetZhilu == 0 then
			g_Kunwu_YinDao_ItemAnim[g_Kunwu_YinDao_ZhiluItemUIIndex]:Show()
		else
			g_Kunwu_YinDao_ItemAnim[g_Kunwu_YinDao_ZhiluItemUIIndex]:Hide()
		end
	else
		--error
		Kunwu_YinDaoFrame_Charts_CloseClick()
	end
end

function Kunwu_YinDaoFrame_Charts_CloseClick()
	Kunwu_YinDaoFrame_Init()
	this:Hide()
end

function Kunwu_YinDaoFrame_Item(idx)
	if g_Kunwu_YinDao_CurSelectMod >= 1 and g_Kunwu_YinDao_CurSelectMod <= g_Kunwu_YinDao_ModTableCount and idx >= 1 and idx <= g_Kunwu_YinDao_MaxItemBtnNum then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GetClick")
		Set_XSCRIPT_ScriptID(212222)
		Set_XSCRIPT_Parameter(0, g_Kunwu_YinDao_CurSelectMod)
		Set_XSCRIPT_Parameter(1, idx)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function Kunwu_YinDaoFrame_Button1_Click(idx)
	if idx >= 1 and idx <= g_Kunwu_YinDao_ModTableCount then
		g_Kunwu_YinDao_CurSelectMod = idx
		Kunwu_YinDaoFrame_UpdateLeftControler()
		Kunwu_YinDaoFrame_UpdateRightControler()
	else
		Kunwu_YinDaoFrame_Charts_CloseClick()
	end
end

function Kunwu_YinDaoFrame_Charts_ButtonClick()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnClickKQYD")
	Set_XSCRIPT_ScriptID(212222)
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function Kunwu_YinDaoFrame_HelpClick()
	PushEvent("QUEST_HELPINFO", "#{ZSYD_241218_06}")
end

function Kunwu_YinDao_ResetPos()
	Kunwu_YinDaoFrame:SetProperty("UnifiedXPosition", g_Kunwu_YinDaoFrame_UnifiedXPosition)
	Kunwu_YinDaoFrame:SetProperty("UnifiedYPosition", g_Kunwu_YinDaoFrame_UnifiedYPosition)
end
