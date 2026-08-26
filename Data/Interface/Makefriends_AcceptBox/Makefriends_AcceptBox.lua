
local g_Makefriends_AcceptBox_Frame_UnifiedPosition;

local FrameInfoList = {
		MK_EXPRESSING_EMOTIONS=400,
};

local g_MK_EP_EM_N = 0
local g_MK_EP_EM_M = 0
local g_MK_EP_EM_STR = ""
function Makefriends_AcceptBox_CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		Makefriends_AcceptBox_Cancel_Clicked(0);
	end
end
--===============================================
-- OnLoad()
--===============================================
function Makefriends_AcceptBox_PreLoad()
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM")
end

--===============================================
-- OnLoad()
--===============================================
function Makefriends_AcceptBox_OnLoad()
  g_Makefriends_AcceptBox_Frame_UnifiedPosition=Makefriends_AcceptBox_Frame:GetProperty("UnifiedPosition");
end

function  Makefriends_AcceptBox_UpdateRect()

	local nWidth, nHeight = Makefriends_AcceptBox_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	Makefriends_AcceptBox_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
--===============================================
-- OnEvent()
--===============================================
function Makefriends_AcceptBox_OnEvent(event)
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		Makefriends_AcceptBox_Frame_On_ResetPos()
		return 0
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_AcceptBox_Frame_On_ResetPos()
		return 0
	elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide();
	end

	if( event == "MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM" ) then
		g_MK_EP_EM_STR = tostring(arg0);
		g_MK_EP_EM_N = tonumber(arg1);
		g_MK_EP_EM_M = tonumber(arg2);
		Makefriends_AcceptBox_DragTitle:SetText("#{JYHD_230331_160}");
		Makefriends_AcceptBox_CancelLastOp(FrameInfoList.MK_EXPRESSING_EMOTIONS);
		g_FrameInfo = FrameInfoList.MK_EXPRESSING_EMOTIONS;
		Makefriends_AcceptBox_Text:SetText( g_MK_EP_EM_STR );
		--Makefriends_AcceptBox_UpdateRect();
		this:Show()
		return 
	end
end

--===============================================
-- 点击确定（IDOK）
--===============================================
function Makefriends_AcceptBox_OK_Clicked_Ex()
	if g_FrameInfo == FrameInfoList.MK_EXPRESSING_EMOTIONS then
		Clear_XSCRIPT()

			Set_XSCRIPT_Function_Name("ExpressingEmotions")
			Set_XSCRIPT_ScriptID(018114)
			Set_XSCRIPT_Parameter(0, g_MK_EP_EM_N )
			Set_XSCRIPT_Parameter(1, g_MK_EP_EM_M )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
		this:Hide()
	end

end
--===============================================
-- 点击确定（IDOK）
--===============================================
function Makefriends_AcceptBox_Hide()

	this:Hide()
	

end

--===============================================
-- 点击确定（IDOK）
--===============================================
function Makefriends_AcceptBox_OK_Clicked()

	Makefriends_AcceptBox_OK_Clicked_Ex();
	this:Hide();
end

function Makefriends_AcceptBox_Help()
	if( g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE ) then
		Helper:GotoHelper( "61" );
	else
		Helper:GotoHelper("*Makefriends_AcceptBox");
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function Makefriends_AcceptBox_Frame_On_ResetPos()
  Makefriends_AcceptBox_Frame:SetProperty("UnifiedPosition", g_Makefriends_AcceptBox_Frame_UnifiedPosition);
end
