
local g_Anniversary_Frame_UnifiedPosition;

local g_ZidianLottery_ActionButton = {};
local g_ZidianLottery_CheckButton = {};
local g_ZidianLottery_CheckTips = {};

local g_Anniversary_bIsOpen = 0
local g_Anniversary_DiffDay=0
local g_Anniversary_ActivePoint=0
local g_Anniversary_Limit=0
local g_Anniversary_State = 0
local g_Anniversary_CurPage = 0
local g_Anniversary_Page = 0

local g_Anniversary_gift = {
[1] = {10141869, 10141868, 10142214, 38003131},
[2] = {10142517, 10142523, 10142214, 38003131},
[3] = {10141988, 10141247, 10142214, 38003131},
}

local g_Anniversary_Image = {
[1] = "set:Anniversary06 image:Anniversary06_BK1",
[2] = "set:Anniversary06 image:Anniversary06_BK2",
[3] = "set:Anniversary06 image:Anniversary06_BK3",
}

--===============================================
-- PreLoad()
--===============================================
function Anniversary_PreLoad()

	this:RegisterEvent( "UI_COMMAND" )
	
	this:RegisterEvent( "PLAYER_LEAVE_WORLD" )			-- 离开场景
	this:RegisterEvent( "ADJEST_UI_POS" )				-- 游戏窗口尺寸发生了变化
	this:RegisterEvent( "VIEW_RESOLUTION_CHANGED" )	  	-- 游戏分辨率发生了变化
		
end

--===============================================
-- OnEvent()
--===============================================
function Anniversary_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 99858401) then

		g_Anniversary_bIsOpen = Get_XParam_INT(0)
		if g_Anniversary_bIsOpen == 0 then
			Anniversary_OnClose()
			return
		end
		
		if g_Anniversary_bIsOpen == 1 and this:IsVisible() then
			Anniversary_OnClose()
			return
		end
		
		g_Anniversary_ActivePoint = Get_XParam_INT(1);
		g_Anniversary_DiffDay = Get_XParam_INT(2);
		g_Anniversary_Limit = Get_XParam_INT(3);
		g_Anniversary_State = Get_XParam_INT(4);
		
		Anniversary_OpenZiDian()

		if g_Anniversary_bIsOpen == 1 then
			this:Show()	
		end

	elseif (event == "PLAYER_LEAVE_WORLD") then
		Anniversary_OnClose()
	elseif (event == "ADJEST_UI_POS") then
		Anniversary_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Anniversary_On_ResetPos()
	end
end

--===============================================
-- OnLoad()
--===============================================
function Anniversary_OnLoad()

	g_Anniversary_Frame_UnifiedPosition = Anniversary_Frame:GetProperty("UnifiedPosition")
	
	g_ZidianLottery_ActionButton[1] = Anniversary_BK2_Button1;
	g_ZidianLottery_ActionButton[2] = Anniversary_BK2_Button2;
	g_ZidianLottery_ActionButton[3] = Anniversary_BK2_Button3;
	g_ZidianLottery_ActionButton[4] = Anniversary_BK2_Button4;

	g_ZidianLottery_CheckButton[1] = Anniversary_CheckButton1
	g_ZidianLottery_CheckButton[2] = Anniversary_CheckButton2
	g_ZidianLottery_CheckButton[3] = Anniversary_CheckButton3
	
	g_ZidianLottery_CheckTips[1] = Anniversary_CheckButton1_Tips
	g_ZidianLottery_CheckTips[2] = Anniversary_CheckButton2_Tips
	g_ZidianLottery_CheckTips[3] = Anniversary_CheckButton3_Tips
	
end

--===============================================
-- Close()
--===============================================
function Anniversary_OnClose()
		
	for i = 1 , table.getn(g_ZidianLottery_ActionButton) do
		g_ZidianLottery_ActionButton[i]:SetActionItem(-1)
	end

	this:Hide();
end

--===============================================
-- ResetPos()
--===============================================
function Anniversary_On_ResetPos()

	Anniversary_Frame:SetProperty("UnifiedPosition", g_Anniversary_Frame_UnifiedPosition)
	
end

function Anniversary_PageShow( nIndex )
		
	for i = 1 , table.getn(g_ZidianLottery_ActionButton) do
		g_ZidianLottery_ActionButton[i]:SetActionItem(-1)
	end
	
	for i = 1 , table.getn(g_ZidianLottery_CheckButton) do
		g_ZidianLottery_CheckButton[i]:SetCheck(0)
	end
	
	for i = 1 , table.getn(g_ZidianLottery_CheckTips) do
		g_ZidianLottery_CheckTips[i]:Hide()
	end
	
	if g_Anniversary_gift[nIndex] ~= nil and g_Anniversary_Image[nIndex] ~= nil and g_ZidianLottery_CheckButton[nIndex] ~= nil then	
		for i = 1 , table.getn(g_ZidianLottery_ActionButton) do
			if g_Anniversary_gift[nIndex][i] ~= nil and g_Anniversary_gift[nIndex][i] > 0 then
				local theAction = DataPool:CreateActionItemForShow(g_Anniversary_gift[nIndex][i], 1) 
				if (theAction:GetID() ~= 0) then
					g_ZidianLottery_ActionButton[i]:SetActionItem(theAction:GetID())  
				else
					g_ZidianLottery_ActionButton[i]:SetActionItem(-1)
				end 
			else
				g_ZidianLottery_ActionButton[i]:SetActionItem(-1)
			end
		end
		
		Anniversary_Left_Image:SetProperty("Image", g_Anniversary_Image[nIndex])
		
		g_ZidianLottery_CheckButton[nIndex]:SetCheck(1)
	end
	
	if g_Anniversary_State == 2 and g_ZidianLottery_CheckTips[g_Anniversary_CurPage] ~= nil then
		g_ZidianLottery_CheckTips[g_Anniversary_CurPage]:Show()
	end
	
	if g_Anniversary_CurPage == nIndex then
		Anniversary_ClientBottom:Show()
		Anniversary_Button:Show();
		Anniversary_Button_Received:Hide();
		Anniversary_Button_Tips:Hide();
		Anniversary_Text2BK:Show();
		if g_Anniversary_State <= 0 then 		-- 未开始
			Anniversary_Text2:SetText("#{WYCJ_20240320_10}")
		elseif g_Anniversary_State == 1 then	-- 已开始
			Anniversary_Text2:SetText("#{WYCJ_20240320_11}")
		elseif g_Anniversary_State == 2 then	-- 可领奖
			Anniversary_Text2:SetText("#{WYCJ_20240320_12}")
			Anniversary_Button_Tips:Show();
		elseif g_Anniversary_State >= 3 then	-- 已领奖
			Anniversary_Text2:SetText("")
			Anniversary_Button:Hide();
			Anniversary_Button_Received:Show();
			Anniversary_Text2BK:Hide();
		end
	else
		Anniversary_ClientBottom:Hide()
		if nIndex < g_Anniversary_CurPage then
			Anniversary_Text2BK:Show();
			Anniversary_Text2:SetText("#{WYCJ_20240320_51}")
		end
		if nIndex > g_Anniversary_CurPage then
			Anniversary_Text2BK:Show();
			Anniversary_Text2:SetText("#{WYCJ_20240320_10}")
		end
	end

end

function Anniversary_OpenZiDian()

	Anniversary_Text1:SetText(ScriptGlobal_Format("#{WYCJ_20240320_8}", g_Anniversary_Limit))
		
	-- 底图修改
	g_Anniversary_CurPage = 0
	if g_Anniversary_DiffDay <= 1 then -- 第一天
		g_Anniversary_CurPage = 1	
	elseif g_Anniversary_DiffDay >= 3 then -- 第三天
		g_Anniversary_CurPage = 3
	else
		g_Anniversary_CurPage = 2
	end
	
	Anniversary_PageShow( g_Anniversary_CurPage )	
	
	g_Anniversary_Page = g_Anniversary_CurPage
	
end

function Anniversary_Zidian_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnGetPrize" )
		Set_XSCRIPT_ScriptID( 998584 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function Anniversary_Zidian_HelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnZiDianShowHelp" )
		Set_XSCRIPT_ScriptID( 998584 )
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function Anniversary_PageClicked( nPage )
	
	if g_Anniversary_gift[nPage] ~= nil and g_Anniversary_Image[nPage] ~= nil then
	
		g_Anniversary_Page = nPage
		
		Anniversary_PageShow( nPage )
		
	end

end


