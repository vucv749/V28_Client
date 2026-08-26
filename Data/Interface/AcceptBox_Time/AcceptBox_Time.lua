
local g_AcceptBox_Time_Time_FrameInfo
local g_AcceptBox_Time_Time_ClickOk
local g_AcceptBox_Time_Time_ClickCancel

local g_AcceptBox_Time_FrameVar = {
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
	JIHESHAO_USE_CONFIRM = 1;	--???
	JIHESHAO_RET_CONFIRM = 2;	--???
}

local AcceptBox_Time_FrameSize_Original = 0
local g_AcceptBox_Time_UnifiedXPosition = 0
local g_AcceptBox_Time_UnifiedYPosition = 0

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_Time_PreLoad()

    this:RegisterEvent("UI_COMMAND");
	
    -- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS");
    -- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");--???
	this:RegisterEvent("PLAYER_ENTERING_WORLD")
end

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_Time_OnLoad()

	AcceptBox_Time_FrameSize_Original = AcceptBox_Time_Frame:GetProperty("AbsoluteSize")
	
	g_AcceptBox_Time_UnifiedXPosition = AcceptBox_Time_Frame:GetProperty("UnifiedXPosition")
	g_AcceptBox_Time_UnifiedYPosition = AcceptBox_Time_Frame:GetProperty("UnifiedYPosition")
	
end

function  AcceptBox_Time_UpdateRect()

	local nWidth, nHeight = AcceptBox_Time_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	local nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	AcceptBox_Time_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	
end

--===============================================
-- OnEvent()
--===============================================
function AcceptBox_Time_OnEvent(event)
	
	-- 游戏分辨率发生了变化
	if (event == "ADJEST_UI_POS" ) then
		AcceptBox_Time_Frame_On_ResetPos()
		return
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AcceptBox_Time_Frame_On_ResetPos()
		return
		
	--切场景
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		AcceptBox_Time_Hidden()
		return
			
	elseif (event == "PLAYER_ENTERING_WORLD" and this:IsVisible()) then
		AcceptBox_Time_Hidden()
		return
		
	end
	 
    g_AcceptBox_Time_Time_ClickOk = 0
    g_AcceptBox_Time_Time_ClickCancel = 0
    g_AcceptBox_Time_Time_FrameInfo = 0
	
	if event == "UI_COMMAND" then
		local commandIndex = tonumber(arg0)
		if commandIndex == 99871101 then
		
			if 1 == 1 then
				return
			end
			
			g_AcceptBox_Time_FrameVar[1] = Get_XParam_INT(0);
			g_AcceptBox_Time_FrameVar[2] = Get_XParam_INT(1);
			
			local str = Get_XParam_STR(0);
			
			AcceptBox_Time_Text:SetText( str );	-- ????
			
			g_AcceptBox_Time_Time_FrameInfo = FrameInfoList.JIHESHAO_USE_CONFIRM
			
			-- 添加倒计时
			AcceptBox_Time_TikTok : Hide()
			
			AcceptBox_Time_ResetFrame()
			DataPool:SetCanUseHotKey(0)
			
			this:Show()
		end
		
		if commandIndex == 99871102 then
			
			if Get_XParam_INT(0) < 0 then
				AcceptBox_Time_Hidden()
				return 
			end
			
			g_AcceptBox_Time_FrameVar[1] = Get_XParam_INT(0);
			g_AcceptBox_Time_FrameVar[2] = Get_XParam_INT(1);
			g_AcceptBox_Time_FrameVar[3] = Get_XParam_INT(2);
					
			if g_AcceptBox_Time_FrameVar[1] == 242 then  --????- -
				g_AcceptBox_Time_FrameVar[1] = 0
			end
			
			local namestr = Get_XParam_STR(0);
			local scenename = GetSceneNameByResID(tonumber(g_AcceptBox_Time_FrameVar[1]))
			local str = "#{SFDJ_240117_58}"
			if scenename ~= nil and namestr ~= nil then
				str = ScriptGlobal_Format("#{SFDJ_240117_59}", namestr, scenename, g_AcceptBox_Time_FrameVar[2], g_AcceptBox_Time_FrameVar[3])
			end
			
			AcceptBox_Time_PageHeader_Name:SetText( "#{SFDJ_240117_58}" );	-- ????
			AcceptBox_Time_Text:SetText( str );	-- ????
			
			g_AcceptBox_Time_Time_FrameInfo = FrameInfoList.JIHESHAO_RET_CONFIRM
			
			-- 添加倒计时
			AcceptBox_Time_TikTok : SetProperty("Timer",tostring(30));
			AcceptBox_Time_TikTok : Show()
			
			AcceptBox_Time_ResetFrame()
			DataPool:SetCanUseHotKey(0)
			
			this:Show()
		end
	end
end


--===============================================
-- ResetFrame
--===============================================
function AcceptBox_Time_ResetFrame()

	AcceptBox_Time_OK_Button:Enable()
	AcceptBox_Time_OK_Button:Show()
	AcceptBox_Time_OK_Button:SetText("#{SFDJ_240117_90}")
	
	AcceptBox_Time_Cancel_Button:Enable()
	AcceptBox_Time_Cancel_Button:Show()
	AcceptBox_Time_Cancel_Button:SetText("#{SFDJ_240117_96}")
	
	AcceptBox_Time_Frame:SetProperty("AbsoluteSize", AcceptBox_Time_FrameSize_Original)
		
	AcceptBox_Time_UpdateRect()
	
end


--===============================================
-- 点击确定（IDOK）
--===============================================
function AcceptBox_Time_OK_Clicked()
    
    if (FrameInfoList.JIHESHAO_USE_CONFIRM == g_AcceptBox_Time_Time_FrameInfo) then  
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ActivateFromClient")
			Set_XSCRIPT_ScriptID(998711)
			Set_XSCRIPT_Parameter(0, g_AcceptBox_Time_FrameVar[1])
			Set_XSCRIPT_Parameter(1, g_AcceptBox_Time_FrameVar[2])
			Set_XSCRIPT_Parameter(2, 0)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
		
		AcceptBox_Time_Hidden()
    end
    
    if (FrameInfoList.JIHESHAO_RET_CONFIRM == g_AcceptBox_Time_Time_FrameInfo) then    	
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TransferMe")
			Set_XSCRIPT_ScriptID(998711)
			Set_XSCRIPT_Parameter(0, 1)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()  
    end
    
    g_AcceptBox_Time_Time_ClickOk = 1
	
	--AcceptBox_Time_Hidden()
end

--===============================================
-- 放弃(IDCONCEL)
--===============================================
function AcceptBox_Time_Cancel_Clicked(bClick)

    g_AcceptBox_Time_Time_ClickCancel = 1
    	
	if( 1 == bClick ) then
	
	end		
	
   AcceptBox_Time_Hidden()
   
end

function AcceptBox_Time_Hidden()

	DataPool:SetCanUseHotKey(1);
	this:Hide();
	
end

function AcceptBox_Time_TimeOut()

	AcceptBox_Time_Hidden()
	
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function AcceptBox_Time_Frame_On_ResetPos()

	AcceptBox_Time_Frame : SetProperty("UnifiedXPosition", g_AcceptBox_Time_UnifiedXPosition);
	AcceptBox_Time_Frame : SetProperty("UnifiedYPosition", g_AcceptBox_Time_UnifiedYPosition);
	
end
