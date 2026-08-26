--!!!reloadscript =ShiZhuang_ZhanShi

local g_ShiZhuang_ZhanShi_Frame_UnifiedPosition = ""
local m_ObjServerId = -1

local g_CurLotteryIndex = 0
local g_day_btn = {}
local g_lottery_num_text = {}

function ShiZhuang_ZhanShi_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	
	--this:RegisterEvent("OPEN_FASHION_LOTTERY")
	--this:RegisterEvent("REFRESH_FASHION_LOTTERY")
	this:RegisterEvent("OPEN_LOTTERY_NUM")
end

function ShiZhuang_ZhanShi_OnLoad()
	g_ShiZhuang_ZhanShi_Frame_UnifiedPosition = ShiZhuang_ZhanShi_Frame:GetProperty("UnifiedPosition")
	
	g_day_btn[1] = ShiZhuang_ZhanShi_Time1
	g_day_btn[2] = ShiZhuang_ZhanShi_Time2
	g_day_btn[3] = ShiZhuang_ZhanShi_Time3
	g_day_btn[4] = ShiZhuang_ZhanShi_Time4
	g_day_btn[5] = ShiZhuang_ZhanShi_Time5
	g_day_btn[6] = ShiZhuang_ZhanShi_Time6
	g_day_btn[7] = ShiZhuang_ZhanShi_Time7
	
	g_lottery_num_text[1] = ShiZhuang_ZhanShi_Text1
	g_lottery_num_text[2] = ShiZhuang_ZhanShi_Text2
	g_lottery_num_text[3] = ShiZhuang_ZhanShi_Text3
	g_lottery_num_text[4] = ShiZhuang_ZhanShi_Text4
	g_lottery_num_text[5] = ShiZhuang_ZhanShi_Text5
	g_lottery_num_text[6] = ShiZhuang_ZhanShi_Text6
	g_lottery_num_text[7] = ShiZhuang_ZhanShi_Text7
	g_lottery_num_text[8] = ShiZhuang_ZhanShi_Text8
	g_lottery_num_text[9] = ShiZhuang_ZhanShi_Text9
	g_lottery_num_text[10] = ShiZhuang_ZhanShi_Text10
	g_lottery_num_text[11] = ShiZhuang_ZhanShi_Text11
	g_lottery_num_text[12] = ShiZhuang_ZhanShi_Text12
	g_lottery_num_text[13] = ShiZhuang_ZhanShi_Text13
	g_lottery_num_text[14] = ShiZhuang_ZhanShi_Text14
	g_lottery_num_text[15] = ShiZhuang_ZhanShi_Text15

end

function ShiZhuang_ZhanShi_OnEvent(event)

	if event == "OPEN_LOTTERY_NUM" then
		if not this:IsVisible() then
			local targetId = tonumber(arg0)
			ShiZhuang_ZhanShi_CleanUp()
			this:Show()
			ShiZhuang_ZhanShi_Update()
			ShiZhuang_ZhanShi_BeginCareObj(tonumber(targetId))
		else
			ShiZhuang_ZhanShi_Frame:SetForce()
			ShiZhuang_ZhanShi_Update()
		end
		return
	end
	
	if event == "REFRESH_FASHION_LOTTERY" then
		if this:IsVisible() then
			ShiZhuang_ZhanShi_Update()
		end
		return
	end
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		ShiZhuang_ZhanShi_Frame_On_ResetPos()
		return
	end
	
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return
	end
end

function ShiZhuang_ZhanShi_Update()
	
	for i = 1, 7 do
		if i == g_CurLotteryIndex then
			g_day_btn[i]:SetCheck(1)
		else
			g_day_btn[i]:SetCheck(0)
		end
	end
	
	local is_lottery_draw = DataPool:LuaFnIsLotteryDraw(g_CurLotteryIndex - 1)
	
	for i = 1, 15 do
		g_lottery_num_text[i]:SetText("")
		if is_lottery_draw == 1 then
			local lottery_num = DataPool:LuaFnGetLotteryNumber(g_CurLotteryIndex - 1, i - 1)
			if lottery_num ~= nil and lottery_num ~= 0 then
				local strTemp = string.format("%07d", lottery_num)
				g_lottery_num_text[i]:SetText(tostring(strTemp))
			end
		end
	end

end

function ShiZhuang_ZhanShi_ChooseDay(index)
	if index >= 1 and index <= 7 then
		if g_CurLotteryIndex == index then
			return
		end		
		g_CurLotteryIndex = index
		ShiZhuang_ZhanShi_Update()
	end	
end

function ShiZhuang_ZhanShi_CloseClicked()
	this:Hide()
end

function ShiZhuang_ZhanShi_CleanUp()
	for i = 1, 15 do
		g_lottery_num_text[i]:SetText("")
	end
	g_CurLotteryIndex = 1
end

function ShiZhuang_ZhanShi_OnHidden()
	ShiZhuang_ZhanShi_CleanUp()
	m_ObjServerId = -1
end

function ShiZhuang_ZhanShi_OK_Clicked()

end

function ShiZhuang_ZhanShi_HelpClicked()

end
--Care Obj
function ShiZhuang_ZhanShi_BeginCareObj(obj_id)	
	m_ObjServerId = obj_id
	local npc_id = DataPool:GetNPCIDByServerID(obj_id)
	this:CareObject(npc_id, 1)
end

function ShiZhuang_ZhanShi_Frame_On_ResetPos()
	if g_ShiZhuang_ZhanShi_Frame_UnifiedPosition ~= nil then
		ShiZhuang_ZhanShi_Frame:SetProperty("UnifiedPosition", g_ShiZhuang_ZhanShi_Frame_UnifiedPosition)
	end
end
