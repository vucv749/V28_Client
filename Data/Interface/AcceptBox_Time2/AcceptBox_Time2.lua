
local g_AcceptBox_Time2_Time_FrameInfo
local g_AcceptBox_Time2_Time_ClickOk
local g_AcceptBox_Time2_Time_ClickCancel

local g_AcceptBox_Time2_FrameVar = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}

local FrameInfoList = {
	JIHESHAO_USE_CONFIRM = 1;	--集合哨
	ZIDIAN_PICKONE_CONFIRM = 2, -- 飞凰礼包二选一
}

local AcceptBox_Time2_FrameSize_Original = 0
local g_AcceptBox_Time2_UnifiedXPosition = 0
local g_AcceptBox_Time2_UnifiedYPosition = 0

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_Time2_PreLoad()

    this:RegisterEvent("UI_COMMAND");
	
    -- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
    -- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");--切场景
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_Time2_OnLoad()

	AcceptBox_Time2_FrameSize_Original = AcceptBox_Time2_Frame:GetProperty("AbsoluteSize")
	
	g_AcceptBox_Time2_UnifiedXPosition = AcceptBox_Time2_Frame:GetProperty("UnifiedXPosition")
	g_AcceptBox_Time2_UnifiedYPosition = AcceptBox_Time2_Frame:GetProperty("UnifiedYPosition")
	
end

function  AcceptBox_Time2_UpdateRect()

	local nWidth, nHeight = AcceptBox_Time2_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	local nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	AcceptBox_Time2_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	
end

--===============================================
-- OnEvent()
--===============================================
function AcceptBox_Time2_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		AcceptBox_Time2_Frame_On_ResetPos()
		return
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AcceptBox_Time2_Frame_On_ResetPos()
		return
		
	--切场景
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		AcceptBox_Time2_Hidden()
		return
			
	elseif (event == "PLAYER_ENTERING_WORLD" and this:IsVisible()) then
		AcceptBox_Time2_Hidden()
		return
		
	end
	 
    g_AcceptBox_Time2_Time_ClickOk = 0
    g_AcceptBox_Time2_Time_ClickCancel = 0
    g_AcceptBox_Time2_Time_FrameInfo = 0
	
	if event == "UI_COMMAND" then
	
		local commandIndex = tonumber(arg0)
		if commandIndex == 99871101 then
			
			g_AcceptBox_Time2_FrameVar[1] = Get_XParam_INT(0);
			g_AcceptBox_Time2_FrameVar[2] = Get_XParam_INT(1);
			
			AcceptBox_Time2_PageHeader_Name:SetText( "#{SFDJ_240117_53}" );	-- 设置题目
			
			local str = Get_XParam_STR(0);
			AcceptBox_Time2_Text:SetText( str );	-- 设置内容
			
			g_AcceptBox_Time2_Time_FrameInfo = FrameInfoList.JIHESHAO_USE_CONFIRM
			
			AcceptBox_Time2_ResetFrame()
			DataPool:SetCanUseHotKey(0)
			
			this:Show()
			
		elseif commandIndex == 99859602 then	--飞凰礼包二选一
			
			g_AcceptBox_Time2_FrameVar[1] = Get_XParam_INT(0);
			
			AcceptBox_Time2_PageHeader_Name:SetText( "#{WYCJ_20240320_27}" );	-- 设置题目
			
			AcceptBox_Time2_Text:SetText( "#{WYCJ_20240320_35}" );	-- 设置内容
			
			g_AcceptBox_Time2_Time_FrameInfo = FrameInfoList.ZIDIAN_PICKONE_CONFIRM
			
			AcceptBox_Time2_ResetFrame()
			DataPool:SetCanUseHotKey(0)
			
			this:Show()
		end
		
	end
end


--===============================================
-- ResetFrame
--===============================================
function AcceptBox_Time2_ResetFrame()

	AcceptBox_Time2_OK_Button:Enable()
	AcceptBox_Time2_OK_Button:Show()
	AcceptBox_Time2_OK_Button:SetText("#{SFDJ_240117_90}")
	
	AcceptBox_Time2_Cancel_Button:Enable()
	AcceptBox_Time2_Cancel_Button:Show()
	AcceptBox_Time2_Cancel_Button:SetText("#{SFDJ_240117_96}")
	
	AcceptBox_Time2_Frame:SetProperty("AbsoluteSize", AcceptBox_Time2_FrameSize_Original)
		
	AcceptBox_Time2_UpdateRect()
	
end


--===============================================
-- 点击确定（IDOK）
--===============================================
function AcceptBox_Time2_OK_Clicked()
    
    if (FrameInfoList.JIHESHAO_USE_CONFIRM == g_AcceptBox_Time2_Time_FrameInfo) then  
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ActivateFromClient")
			Set_XSCRIPT_ScriptID(998711)
			Set_XSCRIPT_Parameter(0, g_AcceptBox_Time2_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_AcceptBox_Time2_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
		
		AcceptBox_Time2_Hidden()
	
	elseif (FrameInfoList.ZIDIAN_PICKONE_CONFIRM == g_AcceptBox_Time2_Time_FrameInfo) then  
		Clear_XSCRIPT();
			if g_AcceptBox_Time2_FrameVar[1] == 2 then
				Set_XSCRIPT_Function_Name("OnChooseRight")
			else
				Set_XSCRIPT_Function_Name("OnChooseLeft")
			end
			Set_XSCRIPT_ScriptID(998596);
			Set_XSCRIPT_Parameter(0, 0);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		
		AcceptBox_Time2_Hidden()
    end
    
    g_AcceptBox_Time2_Time_ClickOk = 1
	
	--AcceptBox_Time2_Hidden()
end

--===============================================
-- 放弃(IDCONCEL)
--===============================================
function AcceptBox_Time2_Cancel_Clicked(bClick)	
	
	if (FrameInfoList.JIHESHAO_USE_CONFIRM == g_AcceptBox_Time2_Time_FrameInfo) then  
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ResetJiHeShaoSkillCD")
			Set_XSCRIPT_ScriptID(998711)
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end

    g_AcceptBox_Time2_Time_ClickCancel = 1
    	
	if( 1 == bClick ) then
	
	end		
	
   AcceptBox_Time2_Hidden()
   
end

function AcceptBox_Time2_Hidden()

	DataPool:SetCanUseHotKey(1);
	this:Hide();
	
end

function AcceptBox_Time2_TimeOut()

	AcceptBox_Time2_Hidden()
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function AcceptBox_Time2_Frame_On_ResetPos()

	AcceptBox_Time2_Frame : SetProperty("UnifiedXPosition", g_AcceptBox_Time2_UnifiedXPosition);
	AcceptBox_Time2_Frame : SetProperty("UnifiedYPosition", g_AcceptBox_Time2_UnifiedYPosition);
	
end
