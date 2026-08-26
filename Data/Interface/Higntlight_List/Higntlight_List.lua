--Higntlight_List.lua
local Higntlight_List_Frame_UnifiedPosition
local Higntlight_List_DpsTable =
{
	--角色GUID	角色名字	角色门派	enum HigntLightDPSType		角色的牸比
	[1] = { guid = 0, name = 0, menpai = 0, DPSType = 0, DPSRate = 0 },
	[2] = { guid = 0, name = 0, menpai = 0, DPSType = 0, DPSRate = 0 },
	[3] = { guid = 0, name = 0, menpai = 0, DPSType = 0, DPSRate = 0 },
}
local Higntlight_List_DpsMaxCount = 3
--ui table
local Higntlight_List_ui_client = {}
local Higntlight_List_ui_positionText = {}
local Higntlight_List_ui_nameText = {}
local Higntlight_List_ui_hurtText = {}
local Higntlight_List_ui_progress = {}

function Higntlight_List_PreLoad()
	--第二个参数表示界面关睜时是否响应事件 默认为TRUE
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE", true)
	this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE_MINI", true)
	this:RegisterEvent("SHOW_HIGHLIGHT_DAMAGE_MAX", true)
	this:RegisterEvent("ON_SCENE_TRANSING", true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
end

function Higntlight_List_OnLoad()
	Higntlight_List_Frame_UnifiedPosition = Higntlight_List_Frame:GetProperty("UnifiedPosition")
	--ui init
	Higntlight_List_ui_client[1] = Higntlight_List_Frame_Client1
	Higntlight_List_ui_client[2] = Higntlight_List_Frame_Client2
	Higntlight_List_ui_client[3] = Higntlight_List_Frame_Client3

	Higntlight_List_ui_positionText[1] = Higntlight_List_Level_Text1
	Higntlight_List_ui_positionText[2] = Higntlight_List_Level_Text2
	Higntlight_List_ui_positionText[3] = Higntlight_List_Level_Text3

	Higntlight_List_ui_nameText[1] = Higntlight_List_Name_Text1
	Higntlight_List_ui_nameText[2] = Higntlight_List_Name_Text2
	Higntlight_List_ui_nameText[3] = Higntlight_List_Name_Text3

	Higntlight_List_ui_hurtText[1] = Higntlight_List_Hurt_Text1
	Higntlight_List_ui_hurtText[2] = Higntlight_List_Hurt_Text2
	Higntlight_List_ui_hurtText[3] = Higntlight_List_Hurt_Text3

	Higntlight_List_ui_progress[1] = Higntlight_List_Progress1
	Higntlight_List_ui_progress[2] = Higntlight_List_Progress2
	Higntlight_List_ui_progress[3] = Higntlight_List_Progress3
end

function Higntlight_List_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 20250716) then
		local op = Get_XParam_INT(0)
		if op == 1 then --????????
			this:Show()
			Higntlight_List_Update()
		elseif op == 0 then
			Higntlight_List_OnClose()
		end
	elseif event == "SHOW_HIGHLIGHT_DAMAGE" then --???? ??????
		Higntlight_List_Update()
	elseif event == "SHOW_HIGHLIGHT_DAMAGE_MINI" then --??????? ???????
		this:Hide()
	elseif event == "SHOW_HIGHLIGHT_DAMAGE_MAX" then --??????? ?????
		this:Show()
	elseif event == "ON_SCENE_TRANSING" then --?????????
		Higntlight_List_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		Higntlight_List_OnClose()
	elseif (event == "ADJEST_UI_POS") then
		Higntlight_List_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Higntlight_List_Frame_On_ResetPos()
	end
end

--刷新界面
function Higntlight_List_Update()
	--清繝界面数据
	Higntlight_List_CleanLocalData()
	--填充数据
	for i = 1, Higntlight_List_DpsMaxCount, 1 do
		local mRet, mName, mGuid, mMenpai, mDPSType, mDPSRate = HighLight:GetDamageUnitDataByIndex(i)
		if mRet == 0 or mName == nil or mGuid == nil or mMenpai == nil or mDPSType == nil or mDPSRate == nil then
			--有问题 那就置0
			Higntlight_List_DpsTable[i].guid = 0
			Higntlight_List_DpsTable[i].name = 0
			Higntlight_List_DpsTable[i].menpai = 0
			Higntlight_List_DpsTable[i].DPSType = 0
			Higntlight_List_DpsTable[i].DPSRate = 0
		else
			--没问题 保存值到界面表
			Higntlight_List_DpsTable[i].guid = mGuid
			Higntlight_List_DpsTable[i].name = mName
			Higntlight_List_DpsTable[i].menpai = mMenpai
			Higntlight_List_DpsTable[i].DPSType = mDPSType
			Higntlight_List_DpsTable[i].DPSRate = mDPSRate
		end
	end
	--根据数据填充界面
	for i = 1, Higntlight_List_DpsMaxCount, 1 do
		if Higntlight_List_DpsTable[i] ~= nil and Higntlight_List_DpsTable[i].guid > 0 then
			Higntlight_List_ui_client[i]:Show()
			Higntlight_List_ui_positionText[i]:SetText(tostring(i))
			Higntlight_List_ui_nameText[i]:SetText(tostring(Higntlight_List_DpsTable[i].name))
			Higntlight_List_ui_hurtText[i]:SetText(tostring(Higntlight_List_DpsTable[i].DPSRate))
			local rate = Higntlight_List_DpsTable[i].DPSRate
			if rate > 100 then
				rate = 99
			elseif rate < 1 then
				rate = 1
			end
			Higntlight_List_ui_progress[i]:SetProgress(rate, 100)
		else
			Higntlight_List_ui_client[i]:Hide()
		end
	end
end

--最小化按钮
function Higntlight_List_OpenMini()
	this:Hide()
	PushEvent("SHOW_HIGHLIGHT_DAMAGE_MINI")
end

--关睜
function Higntlight_List_OnClose()
	-- --清繝界面数据 清繝C++数据
	-- Higntlight_List_CleanData()
	-- this:Hide()
end

--清繝界面数据
function Higntlight_List_CleanLocalData()
	for i = 1, Higntlight_List_DpsMaxCount, 1 do
		Higntlight_List_DpsTable[i].guid = 0
		Higntlight_List_DpsTable[i].name = 0
		Higntlight_List_DpsTable[i].menpai = 0
		Higntlight_List_DpsTable[i].DPSType = 0
		Higntlight_List_DpsTable[i].DPSRate = 0
	end
end

--清繝界面数据 清繝C++数据
function Higntlight_List_CleanData()
	Higntlight_List_CleanLocalData()
	HighLight:ClearDamageUnitData()
end

function Higntlight_List_GetMenPai(menpai)
	local strName = ""
	strName = DataPool:GetMenPaiName(menpai)
	return strName
end

function Higntlight_List_Frame_On_ResetPos()
	Higntlight_List_Frame:SetProperty("UnifiedPosition", Higntlight_List_Frame_UnifiedPosition)
end
