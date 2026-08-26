local FuQi_Title_Target;
local EVENT_TYPE;
local strFrontTitle1
local strFrontTitle2
local g_FuQi_Title_Frame_UnifiedPosition;
local FuQiName 
local g_Fuqi_Gain_NPCID
--===============================================
-- PreLoad
--===============================================
function FuQi_Title_PreLoad()
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("UI_COMMAND")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

--===============================================
-- OnLoad
--===============================================
function FuQi_Title_OnLoad()
    g_FuQi_Title_Frame_UnifiedPosition=FuQi_Title_Frame:GetProperty("UnifiedPosition");	
end

--===============================================
-- OnEvent
--===============================================
function FuQi_Title_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 20230406 then
		FuQi_Title_Target = Get_XParam_INT(0) --targetId
		EVENT_TYPE = Get_XParam_INT(1) --
		FuQiName = Get_XParam_STR(0)
		FuQi_Title_ZiDingYi_Frame:Show();
		FuQi_Title_XiuGai_Frame:Hide();
		
		FuQi_Title_ZidingYi_PlayerName:SetText(FuQiName)
		FuQi_Title_ZidingYi_info:SetText( "的" )
		FuQi_Title_OK:SetText("#{FQCH_20230330_29}")
		FuQi_Title_Text:SetText("#{FQCH_20230330_54}")
		FuQi_Title_BeginCareObject(FuQi_Title_Target)
		FFuQi_Title_ZidingYi_Input:SetText("")
		FFuQi_Title_ZidingYi_Input:SetProperty("DefaultEditBox", "True")	
		this:Show()
	elseif event == "UI_COMMAND" and tonumber(arg0) == 20230407 then
		FuQi_Title_Target = Get_XParam_INT(0) --targetId
		EVENT_TYPE = Get_XParam_INT(1) --

		FuQiName = Get_XParam_STR(0)
		FuQi_Title_XiuGai_Text:SetText(FuQiName)
		FuQi_Title_XiuGai_Frame:Show();
		FuQi_Title_ZiDingYi_Frame:Hide();
		FuQi_Title_XiuGai_Info:SetText( "的" )
		FuQi_Title_Text:SetText("#{FQCH_20230330_27}")
		FuQi_Title_OK:SetText("#{FQCH_20230330_29}")
		FuQi_Title_BeginCareObject(FuQi_Title_Target)
		FuQi_Title_XiuGai_Input:SetText("")
		FuQi_Title_XiuGai_Input:SetProperty("DefaultEditBox", "True")
	    this:Show()
	end
	--this:Show()
		-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		FuQi_Title_Frame_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FuQi_Title_Frame_On_ResetPos()
	end			
end

--===============================================
-- 领取/修改称号
--===============================================
function FuQi_Title_Accept()
	--领取称号
	if EVENT_TYPE == 1 then
		local msg = FFuQi_Title_ZidingYi_Input:GetText();
		if msg == "" then
			AxTrace(0,0,"称号错了1")
			PushDebugMessage( "称号输入错误" )
			return
		end

		local	buf	= FuQi_Title_ZidingYi_PlayerName:GetText()..FuQi_Title_ZidingYi_info:GetText()..FFuQi_Title_ZidingYi_Input:GetText()
		if string.len( FFuQi_Title_ZidingYi_Input:GetText() ) > 8 then
			AxTrace(0,0,"称号错了9")
			PushDebugMessage( "#{FQCH_20230330_31}" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
			PushDebugMessage( "称号输入错误" )
			return
		end
			
		Player:DrawCoupleTitle(buf)
	end
	
	--修改称号
	if EVENT_TYPE == 2 then
		local msg = FuQi_Title_XiuGai_Input:GetText();
		if msg == "" then
			AxTrace(0,0,"称号错了4")
			PushDebugMessage( "称号输入错误" )
			return
		end
		local	buf	= FuQi_Title_XiuGai_Text:GetText()..FuQi_Title_XiuGai_Info:GetText()..FuQi_Title_XiuGai_Input:GetText()

		if string.len( FuQi_Title_XiuGai_Input:GetText() ) > 8 then
			AxTrace(0,0,"称号错了9："..buf)
			PushDebugMessage( "#{FQCH_20230330_31}" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
				PushDebugMessage( "称号输入错误" )
				return
		end

		Player:ChangeCoupleTitle(buf)
	end
	
	FuQi_Title_Cancel()
end

function FuQi_Title_Cancel()
	FuQi_Title_ZidingYi_PlayerName:SetText( "" )
	FuQi_Title_ZidingYi_info:SetText( "" )
	FFuQi_Title_ZidingYi_Input:SetText( "" )

	FuQi_Title_XiuGai_Text:SetText( "" )
	FuQi_Title_XiuGai_Info:SetText( "" )
	FuQi_Title_XiuGai_Input:SetText( "" )
	FuQi_Title_EndCareObject(FuQi_Title_Target)
	this:Hide();
end


--================================================
-- 恢复界面的默认相对位置
--================================================
function FuQi_Title_Frame_On_ResetPos()
  FuQi_Title_Frame:SetProperty("UnifiedPosition", g_FuQi_Title_Frame_UnifiedPosition);
end



function FuQi_Title_BeginCareObject( careObjID )
    g_Fuqi_Gain_NPCID = DataPool : GetNPCIDByServerID( careObjID )
    if -1 == g_Fuqi_Gain_NPCID then
        return 
    end
    this:CareObject( g_Fuqi_Gain_NPCID, 1, "FuQi_Title" )
end
function FuQi_Title_EndCareObject( careObjID )
	if g_Fuqi_Gain_NPCID ~= nil and g_Fuqi_Gain_NPCID >= 0 then
        this:CareObject( g_Fuqi_Gain_NPCID, 0, "FuQi_Title" )
    end
    g_Fuqi_Gain_NPCID = -1
end