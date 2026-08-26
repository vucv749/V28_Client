--Kunwu_ZhiLu.lua
local g_Kunwu_ZhiLu_Frame_UnifiedXPosition
local g_Kunwu_ZhiLu_Frame_UnifiedYPosition
local g_Kunwu_ZhiLu_BtnTblNum = 3
local g_Kunwu_ZhiLu_BtnTbl = {
	[0] = {
		name = "#{ZSYD_241218_43}",
		text = "#{ZSYD_241218_46}",
	},
	[1] = {
		name = "#{ZSYD_241218_44}",
		text = "#{ZSYD_241218_47}",
	},
	[2] = {
		name = "#{ZSYD_241218_45}",
		text = "#{ZSYD_241218_48}",
	},
}
local g_Kunwu_ZhiLu_CurLayer = 0


function Kunwu_ZhiLu_PreLoad()
	--第二个参数代表界面隐藏时事件是否有效,默认为true
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)
end

function Kunwu_ZhiLu_OnLoad()
	g_Kunwu_ZhiLu_Frame_UnifiedXPosition = Kunwu_ZhiLu_Frame:GetProperty("UnifiedXPosition")
	g_Kunwu_ZhiLu_Frame_UnifiedYPosition = Kunwu_ZhiLu_Frame:GetProperty("UnifiedYPosition")
	--Kunwu_ZhiLu_Help:Hide()
end

--=========================================================
-- 事件处理
--=========================================================
function Kunwu_ZhiLu_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 21222301) then
		--打开界面显示一级介绍和一级按钮
		Kunwu_ZhiLuGreeting_Desc:ClearAllElement()
		Kunwu_ZhiLuGreeting_Desc:AddTextElement("#{ZSYD_241218_37}")
		g_Kunwu_ZhiLu_CurLayer = 0
		for i = 0, g_Kunwu_ZhiLu_BtnTblNum - 1 do
			local strContex = g_Kunwu_ZhiLu_BtnTbl[i].name

			local strTemp = strContex .. "&" .. g_Kunwu_ZhiLu_CurLayer .. "," .. i .. "$0" --$ buttonIcon
			Kunwu_ZhiLuGreeting_Desc:AddOptionElement(strTemp)
		end
		this:Show()
	end

	if (event == "ADJEST_UI_POS") then
		Kunwu_ZhiLu_ResetPos()
	end

	if (event == "VIEW_RESOLUTION_CHANGED") then
		Kunwu_ZhiLu_ResetPos()
	end

	if (event == "HIDE_ON_SCENE_TRANSED") then
		this:Hide()
	end

end

function Kunwu_ZhiLuOption_Clicked()
	--Kunwu_ZhiLuGreeting_Desc__option__01#1,1
	--__index#CurLayer,btnIndex
	--Lua_TDU_Log(arg0)
	if arg0 == nil then
		return 
	end
	local pos1, pos2 = string.find(arg0, "#")
	local pos3, pos4 = string.find(arg0, ",")
	if pos1 == nil or pos2  == nil or pos3 == nil or pos4 == nil then
		return
	end
	local strOptionID = -1
	local strOptionExtra1 = string.sub(arg0, pos2 + 1, pos3 - 1)
	local strOptionExtra2 = string.sub(arg0, pos4 + 1)
	local Data1 = tonumber(strOptionExtra1) --CurLayer
	local Data2 = tonumber(strOptionExtra2) --btnIndex
	if Data1 == 0 then
		if Data2 >= 0 and Data2 < g_Kunwu_ZhiLu_BtnTblNum and g_Kunwu_ZhiLu_BtnTbl[Data2] ~= nil then
			Kunwu_ZhiLuGreeting_Desc:ClearAllElement()
			Kunwu_ZhiLuGreeting_Desc:AddTextElement(g_Kunwu_ZhiLu_BtnTbl[Data2].text)
			g_Kunwu_ZhiLu_CurLayer = 1
			local strTemp = "#{ZSYD_241218_49}&" .. g_Kunwu_ZhiLu_CurLayer .. "," .. 99 .. "$0"
			Kunwu_ZhiLuGreeting_Desc:AddOptionElement(strTemp)
		end
	elseif Data1 == 1 then
		Kunwu_ZhiLuGreeting_Desc:ClearAllElement()
		Kunwu_ZhiLuGreeting_Desc:AddTextElement("#{ZSYD_241218_37}")
		g_Kunwu_ZhiLu_CurLayer = 0
		for i = 0, g_Kunwu_ZhiLu_BtnTblNum - 1 do
			local strContex = g_Kunwu_ZhiLu_BtnTbl[i].name

			local strTemp = strContex .. "&" .. g_Kunwu_ZhiLu_CurLayer .. "," .. i .. "$0" --$ buttonIcon
			Kunwu_ZhiLuGreeting_Desc:AddOptionElement(strTemp)
		end
	end
end

function Kunwu_ZhiLu_ResetPos()
	Kunwu_ZhiLu_Frame:SetProperty("UnifiedXPosition", g_Kunwu_ZhiLu_Frame_UnifiedXPosition)
	Kunwu_ZhiLu_Frame:SetProperty("UnifiedYPosition", g_Kunwu_ZhiLu_Frame_UnifiedYPosition)

end
