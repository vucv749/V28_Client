local g_FrameInfo
local g_ClickOk
local g_ClickCancel

--ÇÐpk³¡¾°ÌáÊ¾Ïà¹Ø
local Server_Script_Function = "";
local Server_Script_ID = "";
local Server_Return = {0,0,0,0,0,0};
local Server_Return_Num = 0;

local PVPFLAG = { ACCEPTDUEL = 205, DuelGUID = "", DuelName = "" }

local FrameInfoList = {
LOGIN_PK_SCENE_CONFIRM = 0;--????????
ENTER_PK_SCENE_CONFIRM = 1;--??pk??????
}

local FrameSize_Original = 0
local AcceptBox_Blank_Orignial_Size = 0
local g_AcceptBox_Frame_UnifiedXPosition = 0
local g_AcceptBox_Frame_UnifiedYPosition = 0
--===============================================
-- OnLoad()
--===============================================
function AcceptBox_PreLoad()
    this:RegisterEvent("MSGBOX_ACCEPTDUEL");
    this:RegisterEvent("UI_COMMAND");
    	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
		this:RegisterEvent("ADJEST_UI_POS");
    	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
		this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
		this:RegisterEvent("PLAYER_LEAVE_WORLD");--???
end

--===============================================
-- OnLoad()
--===============================================
function AcceptBox_OnLoad()
	FrameSize_Original = AcceptBox_Frame:GetProperty("AbsoluteSize")
	AcceptBox_Blank_Orignial_Size = AcceptBox_Blank:GetProperty("UnifiedSize")
	g_AcceptBox_Frame_UnifiedXPosition = AcceptBox_Frame:GetProperty("UnifiedXPosition")
	g_AcceptBox_Frame_UnifiedYPosition = AcceptBox_Frame:GetProperty("UnifiedYPosition")
end

--===============================================
-- OnEvent()
--===============================================
function AcceptBox_OnEvent(event)
	
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		AcceptBox_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		AcceptBox_Frame_On_ResetPos()
		--ÇÐ³¡¾°
	elseif (event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		if (g_FrameInfo == FrameInfoList.LOGIN_PK_SCENE_CONFIRM) then
			this:Hide()
		end
	end
	 
	if this:IsVisible() then
		return
	end
    g_ClickOk = 0
    g_ClickCancel = 0
    g_FrameInfo = 0
    
	AcceptBox_ResetFrame();

	if ( event == "MSGBOX_ACCEPTDUEL" ) then
	AxTrace( 0, 0, "AcceptBox_OnEvent MSGBOX_ACCEPTDUEL" )
			AcceptBox_PageHeader_Name:SetText("#gFF0FA0Xác nh§n quyªt ð¤u");
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;	    
	    local MsgText = "#c0000FF"..Name.."#W".."GØi yêu c¥u #cFF0000quyªt ð¤u#W, ð°ng ý?#rChú ý: Khi quyªt ð¤u tr÷ng thß½ng s¨ b¸ tr×ng phÕt."
	    AcceptBox_Text:SetText( MsgText )
	    this:Show();		
	end
	
	if event == "UI_COMMAND" then
	local commandIndex = tonumber(arg0)
		if commandIndex == 20100716 then
			if ( Get_XParam_INT_Count() < 1 ) then
				return
			end
			AcceptBox_Frame:SetProperty("AbsoluteSize", "w:265 h:182")
			AcceptBox_Blank:SetProperty("UnifiedSize", "{{1.000000,-54.000000},{0.000000,20.000000}}")
			local pvpType = Get_XParam_INT(0)
			local msg = ""
			if pvpType == 2 then--?????
				msg = "#{QZDZ_100715_01}"
			elseif pvpType == 3 then --??????
				msg = "#{QZDZ_100715_02}"
			end
			g_FrameInfo = FrameInfoList.LOGIN_PK_SCENE_CONFIRM
			AcceptBox_Text:SetText(msg)
			AcceptBox_OK_Button:Hide()
			AcceptBox_Cancel_Button:SetText("#{INTERFACE_XML_302}")
			this:Show()
		end
		
		if commandIndex == 20100717 then
			AcceptBox_Frame:SetProperty("AbsoluteSize", "w:265 h:192")
			g_FrameInfo = FrameInfoList.ENTER_PK_SCENE_CONFIRM
			Server_Script_Function = Get_XParam_STR(0)
			Server_Script_ID = Get_XParam_INT(0)
			szContent = Get_XParam_STR(1)
			AcceptBox_Text:SetText(szContent)
			Server_Return_Num = Get_XParam_INT_Count() - 1; 
			local i = 0;
			for i =1, Server_Return_Num do
				Server_Return[i] = Get_XParam_INT(i)
			end 
			
			--¿ç³¡¾°Ñ°Â·ÒÑ¾­´¦Àí¹ýµ¯´°ÁË
			if (IsAcrossSceneMoveto() == 1) then
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name(Server_Script_Function);
					Set_XSCRIPT_ScriptID(Server_Script_ID);
					local i = 0;
					for i = 1, Server_Return_Num do
						Set_XSCRIPT_Parameter(i - 1,Server_Return[i]);
					end 
					Set_XSCRIPT_ParamCount(Server_Return_Num);
				Send_XSCRIPT();
				return
			end

			this:Show()
		end
	end
end


--===============================================
-- ResetFrame
--===============================================
function AcceptBox_ResetFrame()
	AcceptBox_PageHeader_Name:SetText("")
	AcceptBox_OK_Button:Enable()
	AcceptBox_OK_Button:Show()
	AcceptBox_OK_Button:SetText("#{INTERFACE_XML_557}")
	AcceptBox_Cancel_Button:Enable()
	AcceptBox_Cancel_Button:Show()
	AcceptBox_Cancel_Button:SetText("#{INTERFACE_XML_542}")
	AcceptBox_Frame:SetProperty("AbsoluteSize", FrameSize_Original)
	AcceptBox_Blank:SetProperty("UnifiedSize", AcceptBox_Blank_Orignial_Size)
end


--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function AcceptBox_OK_Clicked()
    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        AxTrace( 0, 0, "AcceptBox_OK_Clicked" )
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end
    
    if (FrameInfoList.ENTER_PK_SCENE_CONFIRM == g_FrameInfo) then
    	Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name(Server_Script_Function);
				Set_XSCRIPT_ScriptID(Server_Script_ID);
				local i = 0;
				for i = 1, Server_Return_Num do
					Set_XSCRIPT_Parameter(i - 1,Server_Return[i]);
				end 
				Set_XSCRIPT_ParamCount(Server_Return_Num);
			Send_XSCRIPT();
    end
    
    g_ClickOk = 1
	this:Hide();
end

--===============================================
-- ·ÅÆú°ÚÌ¯(IDCONCEL)
--===============================================
function AcceptBox_Cancel_Clicked(bClick)
    AxTrace( 0, 0, "AcceptBox_Cancel_Clicked"..tostring( bClick ) )
    g_ClickCancel = 1
    
	--if( 0 == g_ClickOk ) then
	    if( 1 == bClick ) then
			if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			    AxTrace( 0, 0,  "Duel Cancel......AcceptBox_Cancel_Clicked........................................" )
				DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
			end
		end
	--end    
    
	this:Hide();
end

function AcceptBox_OnHide()
    if( 0 == g_ClickCancel ) then
        if( 0 == g_ClickOk ) then
            if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
                AxTrace( 0, 0,  "Duel Cancel......AcceptBox_OnHide........................................" )
                DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
            end
        end
    end
    
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function AcceptBox_Frame_On_ResetPos()
	AcceptBox_Frame : SetProperty("UnifiedXPosition", g_AcceptBox_Frame_UnifiedXPosition);
	AcceptBox_Frame : SetProperty("UnifiedYPosition", g_AcceptBox_Frame_UnifiedYPosition);
end
