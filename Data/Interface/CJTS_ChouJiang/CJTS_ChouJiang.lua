
local g_CJTS_ChouJiang_UnifiedPosition;

local g_CJTSLottery_Button = {};
local g_CJTSLottery_ButtonTips = {};

local g_CJTS_ChouJiang_bIsOpen = 0
local g_CJTS_ChouJiang_LotteryDay=0
local g_CJTS_ChouJiang_State = { 0, 0 }
local g_CJTS_ChouJiang_ZiGe = { 0, 0 }
local g_CJTS_ChouJiang_Day = { 0, 0 }
local g_CJTS_ChouJiang_DayStr = { "#{CTCJ_20250703_46}", "#{CTCJ_20250703_58}" }
local g_CJTS_ChouJiang_Page = 0

--===============================================
-- PreLoad()
--===============================================
function CJTS_ChouJiang_PreLoad()

	this:RegisterEvent( "UI_COMMAND" )
	
	this:RegisterEvent( "PLAYER_LEAVE_WORLD" )			-- 离开场景
	this:RegisterEvent( "ADJEST_UI_POS" )				-- 游戏窗口尺寸发生了变化
	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" )	  	-- 游戏分辨率发生了变化
		
end

--===============================================
-- OnEvent()
--===============================================
function CJTS_ChouJiang_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 99969201) then

		g_CJTS_ChouJiang_bIsOpen = Get_XParam_INT(0)
		if g_CJTS_ChouJiang_bIsOpen == 0 then
			CJTS_ChouJiang_OnClose()
			return
		end
		
		if g_CJTS_ChouJiang_bIsOpen == 1 and this:IsVisible() then
			CJTS_ChouJiang_OnClose()
			return
		end
		
		g_CJTS_ChouJiang_LotteryDay = Get_XParam_INT(1);
		g_CJTS_ChouJiang_ZiGe[1] = Get_XParam_INT(2);
		g_CJTS_ChouJiang_ZiGe[2] = Get_XParam_INT(3);
		g_CJTS_ChouJiang_State[1] = Get_XParam_INT(4);
		g_CJTS_ChouJiang_State[2] = Get_XParam_INT(5);
		g_CJTS_ChouJiang_Day[1] = Get_XParam_INT(6);
		g_CJTS_ChouJiang_Day[2] = Get_XParam_INT(7);
		
		CJTS_ChouJiang_PageShow()

		if g_CJTS_ChouJiang_bIsOpen == 1 then
			this:Show()	
		end

	elseif (event == "PLAYER_LEAVE_WORLD") then
		CJTS_ChouJiang_OnClose()
	elseif (event == "ADJEST_UI_POS") then
		CJTS_ChouJiang_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CJTS_ChouJiang_On_ResetPos()
	end
end

--===============================================
-- OnLoad()
--===============================================
function CJTS_ChouJiang_OnLoad()

	g_CJTS_ChouJiang_UnifiedPosition = CJTS_ChouJiang_Frame:GetProperty("UnifiedPosition")
	
	g_CJTSLottery_Button[1] = CJTS_ChouJiang_Button1
	g_CJTSLottery_Button[2] = CJTS_ChouJiang_Button2

	g_CJTSLottery_ButtonTips[1] = CJTS_ChouJiang_Button1_Tips
	g_CJTSLottery_ButtonTips[2] = CJTS_ChouJiang_Button2_Tips
	
end

function CJTS_ChouJiang_PageShow( )

	local nDay = {0, 0} 
	local nMonth = {0, 0}
	local nYear = {0, 0}
	nDay[1] = math.mod(g_CJTS_ChouJiang_Day[1],100)
	nMonth[1] = math.floor(math.mod(g_CJTS_ChouJiang_Day[1],10000)/100)
	nYear[1] = math.floor(g_CJTS_ChouJiang_Day[1]/10000)

	nDay[2] = math.mod(g_CJTS_ChouJiang_Day[2],100)
	nMonth[2] = math.floor(math.mod(g_CJTS_ChouJiang_Day[2],10000)/100)
	nYear[2] = math.floor(g_CJTS_ChouJiang_Day[2]/10000)

	if nMonth[1] > 0 and nDay[1] > 0 and nMonth[2] > 0 and nDay[2] > 0 then
		local nDetailStr = ScriptGlobal_Format( "#{CTCJ_20250703_8}", nMonth[1], nDay[1], nMonth[2], nDay[2], nMonth[1], nDay[1], nMonth[2], nDay[2] )
		CJTS_ChouJiang_Text1:SetText( nDetailStr )
	end

	local nStr1 = ScriptGlobal_Format("#{CTCJ_20250703_50}", g_CJTS_ChouJiang_ZiGe[1])
	CJTS_ChouJiang_Text2:SetText( nStr1 )
	local nStr2 = ScriptGlobal_Format("#{CTCJ_20250703_55}", g_CJTS_ChouJiang_ZiGe[2])
	CJTS_ChouJiang_Text3:SetText( nStr2 )

	for i = 1, table.getn(g_CJTSLottery_Button) do	
		g_CJTSLottery_ButtonTips[i]:Hide();		
		if g_CJTS_ChouJiang_State[i] == 2 and i == g_CJTS_ChouJiang_LotteryDay then	-- 可领奖
			g_CJTSLottery_ButtonTips[i]:Show();
		end

		if g_CJTS_ChouJiang_State[i] >= 3 then	-- 已领奖
			g_CJTSLottery_Button[i]:Disable();
		else
			g_CJTSLottery_Button[i]:Enable();
		end
		if nYear[i] > 0 and  nMonth[i] > 0 and nDay[i] > 0 then
			local nTipstr = ScriptGlobal_Format(g_CJTS_ChouJiang_DayStr[i], nYear[i], nMonth[i], nDay[i])
			g_CJTSLottery_Button[i]:SetToolTip( nTipstr )
		end
	end

end

function CJTS_ChouJiang_Clicked( nIdx )

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnGetChouJiangPrize" )
		Set_XSCRIPT_ScriptID( 999692 )
		Set_XSCRIPT_Parameter(0, nIdx)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()

end

function CJTS_ChouJiang_HelpClicked()

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnCJTSLotteryShowHelp" )
		Set_XSCRIPT_ScriptID( 999692 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()

end

--===============================================
-- Hidden()
--===============================================
function CJTS_ChouJiang_OnHidden()
	
end

--===============================================
-- Close()
--===============================================
function CJTS_ChouJiang_OnClose()
		
	CJTS_ChouJiang_OnHidden()

	this:Hide();
end

--===============================================
-- ResetPos()
--===============================================
function CJTS_ChouJiang_On_ResetPos()

	CJTS_ChouJiang_Frame:SetProperty("UnifiedPosition", g_CJTS_ChouJiang_UnifiedPosition)
	
end


