

------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿Çø
--
--
local g_iYesNoType = -1;	-- yes-no ?????
													-- -1 -- Æ Í¨ÐÅÏ¢ÌáÊ¾
													-- 0 - ÍË³öÓÎÏ·
													-- 1 - É¾³ý½ÇÉ«
													-- 2 - ¸ü»» ÊºÅ
													-- 3 - ¶Ï¿ªÍøÂç
													-- 4 - È·ÈÏÊÇ·ñÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
													-- 5 - 7ÌìÄÚÌáÐÑÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
													-- 6 - 7Ììºó£¬14ÌìÄÚÌáÐÑÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
													-- 7 - ÊÇ·ñÉ¾³ý10¼¶ÒÔÏÂÍæ¼Ò
													-- 8 É¾³ýÍæ¼Ò
													-- 9 ÊÇ·ñ×¢²á
													--29 ½ûÖ¹µÇÂ¼
													--30 3Ìì½ûÖ¹µÇÂ¼
													--31  ËºÅ¶³½á
													--32 Íæ¼ÒÔÚÆäËü·þÔÚÏß
													--33 Íæ¼ÒÒÑÔÚÏß
													--34 Íæ¼ÒÎ´ÈÏÖ¤ÊÖ»ú
													--35 ¸üÐÂ·þÎñÆ÷ÁÐ±í
													--36 ÃÜÂë´íÎó
													--37 ÏÞÖÆµÇÂ¼£¬Î´ÊµÃû
													--38 ÏÞÖÆµÇÂ¼£¬×¢Ïú ÊºÅ
													--39 ÏÞÖÆµÇÂ¼£¬ÊµÃû¸ñÊ½²»¶Ô
													--40 ¼¤»î
													--41 1009¼¤»î
													--42 Èý¾«²ÄÁÏÅúÁ¿ºÏ³É
													--43 Èó»êÊ¯ÅúÁ¿ºÏ³É
													--44 ÁéÊÞµ¤ºÏ³É
													--45 Ê±×°È¾É«¶þ´ÎÈ·ÈÏ
													--46 Ê±×°È¾É«°ó¶¨¶þ´ÎÈ·ÈÏ
													--47 Ê¹ÓÃ¹ú¼Ò·À³ÁÃÔÐÅÏ¢¿âÇÒ·À³ÁÃÔÐÅÏ¢²» ýÈ·
													--48 ÏÞÖÆµÇÂ¼£¬Î´³ÉÄêÈË£¬Î´Âú18Ëê 
													--49 ÏÞÖÆµÇÂ¼£¬Î´³ÉÄêÈË£¬Î´Âú18Ëê
													--50 ÏÞÖÆµÇÂ¼£¬ ýÔÚÉóºËÖÐ
													--51 ·â»êÂ¼
													--52 »ê±ùÖéÅúÁ¿ºÏ³É
													--53 ÎåÒ»·ÅÑÌ»¨
													--54 ÐÂÃÅÅÉ·ö³Ö
													--60 Ê¥µ®Ó¦¾°-È¤Î¶Ê¥µ®Ê÷
													--62 ´º½Ú´ò¹¤ÍÃ
													--65 ½á»é½»»»ÐÅÎï¹«¸æ¶þ´ÎÈ·ÈÏ
													--66 ±äÐÔ
													--76 ´ú±Ò ûºÏ¶Ò»» Ù»½È¯£¬¶þ´ÎÈ·ÈÏ
													--77 ¶þ´ÎÈ·ÈÏ
													--78 ¶þ´ÎÈ·ÈÏ
													--79 ¶þ´ÎÈ·ÈÏ
local g_strMessageData;

local g_bagIndex = -1
local g_bagIndex2 = -1
local g_item = -1
local g_itemNum = -1
local g_objCared = -1
local g_pos = -1
local g_YanHua_From = -1
local g_YanHua_Param = -1

local CaiLiaoCompound_Data = {0, 0, 0, 0}			-- ???????? ????
local DaGongTu_Data = {0, 0}						-- ????? ????
local RunHunShiCompound_Data = {0, 0, 0, 0}			-- ??????? ????
local HunBingZhuCompound_Data = {0, 0, 0}			-- ??????? ????
local LingShouDanCompound_Data = {0, 0, 0, 0}		-- ????? ????
local FengHunLu_Data = {0, 0}						-- ????? ????
local g_SelecQuest_Data= {0,0,0,0}
local g_ZBS_Data = {-1, -1, -1}
local changchunlibao_data = {0,0}
local g_DLZX_Data = {-1, -1, -1, -1, -1, -1, -1}		-- ????PVP??

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectServerQuest_PreLoad()

	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO");

	-- ¹Ø± ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_SYSTEM_INFO");


	-- µã»÷È·¶¨°´Å¥¹Ø± ÍøÂç
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET");

	-- ÏÔÊ¾²»´ø°´Å¥µÄÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");
	-- ÏÔÊ¾yes-noÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_YESNO");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_OK");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CANCEL");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CLOSE");
	this:RegisterEvent("UI_COMMAND");
	--  äÊÞ×°±¸·Ö½âÈ·ÈÏ
	this:RegisterEvent("PET_EQUIP_DEPART_CONFIRM")
	-- °ó¶¨Ôª±¦ÉÌµêÍæ¼Ò°ó¶¨Ôª±¦²»×ãÊ±£¬¶þ´ÎÈ·ÈÏµÄ½çÃæ
	this:RegisterEvent("BINDYUANBAO_NOTENOUGH_YESNO")
	this:RegisterEvent("DISPLACEGEM_CONFIRM",true)
	this:RegisterEvent( "DISPLACE_CLOSE_MSGBOX",true )
	--Ê±×°È¾É«¶þ´ÎÈ·ÈÏ
	this:RegisterEvent( "DRESSPAINT_SELECTSERVER")
	this:RegisterEvent( "DRESSPAINT_BINDDRESS")
	this:RegisterEvent( "WEGAME_FORCEQUIT")

	--½á»é½»»»ÐÅÎï¹«¸æ¶þ´ÎÈ·ÈÏ
	this:RegisterEvent( "PLDGELOVE_CONFIRM")
end

function LoginSelectServerQuest_OnLoad()

	-- ÉèÖÃ×ÜÊÇÔÚ×îÉÏ²ãÏÔÊ¾
	SelectServerQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");

	--


end
function LoginSelectUpdateRect()
	local nWidth, nHeight = SelectServerQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	local nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	SelectServerQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	AxTrace( 0,0, "LastWindowSize ="..tostring( nWindowWidth )..","..tostring(nWindowHeight) );
	--SelectServerQuest_Frame_sub:SetWindowSize( nWindowWidth, nWindowHeight );
end

local TimerArg = "";
local g_QuitType = 0;    --??3, ????????0??????????!
local g_bIsQuitMsgBox = 0;
-- OnEvent
function LoginSelectServerQuest_OnEvent(event)

	--Èç¹û´¦ÓÚÏÔÊ¾ÖÐ£¬²»Òª³õÊ¼»¯,·ñÔòUI_COMMANDÀ´³öÏÖbug
	if (not this:IsVisible()) then
	
		g_bIsQuitMsgBox = 0;
    SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )

		--AxTrace( 0,0, "get event");
		SelectServerQuest_Button2:Hide();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_LostPassword:Hide()
		SelectServerQuest_Time_Text : Hide();
		SelectServerQuest_InfoWindow:Show();
	
	end
	
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO" ) then

		g_iYesNoType = -1;
		--AxTrace( 0,0, "ÏÔÊ¾ÏµÍ³ÐÅÏ¢");
		if( arg1 ~= "WAITFORQUIT" ) then
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
		end
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ðóng");
		SelectServerQuest_Button1:Enable()


		if( arg1 == "USERONLINE" ) then
			g_iYesNoType = 33;
		  SelectServerQuest_LostPassword:Show();
		  SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "OTHERSEVER_ONLINE") then
			g_iYesNoType = 32;
		  SelectServerQuest_LostPassword:Show();
		  SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "NO_IPHONE") then
			g_iYesNoType = 34;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_130}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "MUST_STOPTIME") then
			g_iYesNoType = 31;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "UserId_Password_Err") then
			g_iYesNoType = 36;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "NO_SHIMING") then
			g_iYesNoType = 37;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_16}");
			SelectServerQuest_LostPassword:Enable()

		elseif (arg1 == "CN_REMOVEACCOUNT") then
			g_iYesNoType = 38;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_12}");
			SelectServerQuest_LostPassword:Enable()
			
		elseif (arg1 == "CN_SHIMING_INVALID") then
			g_iYesNoType = 39;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_14}");
			SelectServerQuest_LostPassword:Enable()
			
		elseif (arg1 == "OB_REGISTER_LOGIN") then
			g_iYesNoType = 40;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{LSOB_200304_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "TLBBGREEN_NOT_ACTIVE_TLPH_TG") then
			g_iYesNoType = 41;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{LSOB_200304_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "LOGIN_FCM_CERTNUM_CHECKERROR") then		--47 ???????????????????
			g_iYesNoType = 47;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_21}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERAGE_18") then
			g_iYesNoType = 48;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_23}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERAGE_18_2021") then
			g_iYesNoType = 49;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_25}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERREVIEW_2021") then
			g_iYesNoType = 50;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_27}");
			SelectServerQuest_LostPassword:Enable()
		elseif(arg1 == "USERFROMMAINPRO") then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Hide();
		    SelectServerQuest_Button2:Hide();
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "MIBAOERROR" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(30));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "TURNOVER" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(8));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "WAITFORQUIT" ) then
		    if(arg3~=nil and tonumber(arg3)~=nil)then
			if(tonumber(arg3)>0)then
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(10));
				SelectServerQuest_InfoWindow:SetText("Sau 10 giây s¨ thoát khöi trò ch½i");
				LoginSelectUpdateRect();

			else
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
				SelectServerQuest_InfoWindow:SetText("Sau 3 giây s¨ thoát khöi trò ch½i!");
				LoginSelectUpdateRect();
			end
		    else
			 SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
			 SelectServerQuest_InfoWindow:SetText("Sau 3 giây s¨ thoát khöi trò ch½i!");
			LoginSelectUpdateRect();
		    end
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:SetText("Hüy");
		    SelectServerQuest_Button1:Show();
		    SelectServerQuest_Button1:Enable();
		    TimerArg = arg1;
		    g_QuitType = tonumber(arg2);
		    if g_QuitType == 3 then
		    	SelectServerQuest_Button1:Hide();
		    end
		    g_bIsQuitMsgBox = 1;
		    arg1 = nil;
		elseif( arg1 == "LoginCounting" ) then
				local countTime = tonumber(arg2)
				if(countTime >= 0 and countTime <= 20000) then--?????arg2????0?20000????
					countTime = math.floor(countTime/1000) + 1
					if countTime==21 then
						countTime=20
					end
					SelectServerQuest_Time_Text : SetProperty("Timer",tostring(countTime));
		    	SelectServerQuest_Time_Text : Show()
		    	SelectServerQuest_Button1:Disable()
		    	TimerArg = arg1;
				end
			  arg1 = nil
			  arg2 = nil
		elseif(arg1 == "ThreedAccForbit") then
			g_iYesNoType = 30;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_131}");
			SelectServerQuest_LostPassword:Enable()
			TimerArg = nil;
		    arg1 = nil;
		elseif(arg1 == "LOGNR_Forbit") then
			g_iYesNoType = 29;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_131}");
			SelectServerQuest_LostPassword:Enable()
			TimerArg = nil;
		    arg1 = nil;
		else
		    TimerArg = nil;
		    arg1 = nil;
		    SelectServerQuest_Time_Text : Hide()
		end

		this:Show();
		return;
	end




	if( event == "GAMELOGIN_CLOSE_SYSTEM_INFO") then

		g_iYesNoType = -1;
		this:Hide();
		return;
	end

	--AxTrace( 0,0, "event yes no");
	if( event == "GAMELOGIN_SYSTEM_INFO_YESNO") then

		--AxTrace( 0,0, "ÏÔÊ¾yes no");
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		g_iYesNoType = tonumber(arg1);

		if g_iYesNoType == 20 and arg2 ~= nil  and arg3 ~= nil then
			g_objCared = tonumber(arg2)
			g_bagIndex = tonumber(arg3)
		end
		
		if g_iYesNoType == 66 then --??
			g_objCared = tonumber(arg2)
		end		
		
		SelectServerQuest_Button1:SetText("Xác nh§n");
		SelectServerQuest_Button2:SetText("Hüy bö");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		return;
	end
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON" ) then

	    if( nil ~= arg1 ) then
	        local strArg = tostring( arg1 )
			if( strArg == "CharSel_EnterGame" ) then
			--if( strArg == "CharSel_EnterGam" ) then
				SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.900000,-118.000000}}" )
			end
		arg1 = nil;
	    end

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		this:Show();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_OK" ) then
		AxTrace( 0,0,"GAMELOGIN_SYSTEM_INFO_OK" );
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		if g_iYesNoType == 0 then
			SelectServerQuest_Button1:SetText("Ðóng");
		else
			SelectServerQuest_Button1:SetText("Ð°ng ý");
		end
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CANCEL" ) then

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Hüy");
		this:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CLOSE" ) then

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("Ðóng");
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end



	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET") then

		--AxTrace( 0,0, "ÐèÒª¹Ø± ÍøÂç.");
		g_iYesNoType = 3;
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ðóng");
		this:Show();
		return;
	end

	-- ÑªÔ¡Éñ±ø¡ª¡ªÉñÆ÷ÖýÔì
	if ( event == "UI_COMMAND" and tonumber(arg0) == 13906) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263#{XYSB_080925_001}");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ðóng");
		SelectServerQuest_Button1:Enable()

		this:Show();
	end

	-- ÑªÔ¡Éñ±ø¡ª¡ªÉñÆ÷ÖØÖý
	if ( event == "UI_COMMAND" and tonumber(arg0) == 12032203) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cfff263Sau khi luy®n lÕi, Th¥n Khí s¨ b¸ #Ghüy#cfff263, nªu xác nh§n giao hãy ðóng nh¡c nh· này r°i nh¤p nút #GXác nh§n#cfff263 mµt l¥n næa.");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("Ðóng");
		SelectServerQuest_Button1:Enable()

		this:Show();
	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 300077) then
		g_iYesNoType = 12;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{SLZSDSJ_090915_2}%s#{SLZSDSJ_090915_3}%d#{SLZSDSJ_090915_4}",petClass,slzExp)
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			--Éý¼¶½çÃæ²»ÔÚ âÀï£¬ÔÚPetShelizi_MsgÖÐ
			return
		end

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	--ÌìÔª½ðµ¤ hzp
	if( event == "UI_COMMAND" and tonumber(arg0) == 332004) then
		g_iYesNoType = 13;
		g_bagIndex = Get_XParam_INT( 0 )
		SelectServerQuest_InfoWindow:SetText("#{TSXF_090408_03}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	--°µÆ÷Éý¼¶
	if( event == "UI_COMMAND" and tonumber(arg0) == 260001) then
		g_iYesNoType = -1;
		g_bagIndex = Get_XParam_INT( 0 );
		g_bagIndex2 = Get_XParam_INT( 1 )
		SelectServerQuest_InfoWindow:SetText("#{AQSJ_090709_10}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();

	end

	--ÉñÆ÷Éý¼¶
	if( event == "UI_COMMAND" and tonumber(arg0) == 500505) then
		g_iYesNoType = -1;
		g_bagIndex = Get_XParam_INT( 0 );
		g_bagIndex2 = Get_XParam_INT( 1 )
		SelectServerQuest_InfoWindow:SetText("#{SQSJ_0708_09}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();
	end

	--ÎåÒ»·ÅÑÌ»¨
	if( event == "UI_COMMAND" and tonumber(arg0) == 89312103) then
		g_iYesNoType = 53;
		g_YanHua_From = Get_XParam_INT( 0 );
		g_YanHua_Param = Get_XParam_INT( 1 );
		SelectServerQuest_InfoWindow:SetText("#{FYH_220407_76}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button2:Enable()
		this:Show();
	end

	--ÐÂÉáÀû×Ó add by hzp 09-06-29
	if( event == "UI_COMMAND" and tonumber(arg0) == 300088) then
		g_iYesNoType = 14;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_21}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_28}%d#{ZSKSSJ_081113_29}%d#{ZSKSSJ_081113_30}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		end

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 808147) then
		g_iYesNoType = 24;
		g_objCared = Get_XParam_INT(0)
		g_bagIndex = Get_XParam_INT(1)
		local itemName = Get_XParam_STR(0)
		local strText = string.format("#{MYHK_100128_03}%s#{MYHK_100128_04}",itemName)
		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	if (event == "PET_EQUIP_DEPART_CONFIRM") then
		local equipname = arg0
		g_iYesNoType = tonumber(arg1)
		SelectServerQuest_InfoWindow:SetText("#{ZSZBSJ_XML_17}" .. equipname .. "#{ZSZBSJ_XML_18}")
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
	end

	if (event == "BINDYUANBAO_NOTENOUGH_YESNO" ) then
		g_iYesNoType = tonumber(arg0)
		g_item 		 = tonumber(arg1)
		g_itemNum 	 = tonumber(arg2)
		local nPriceOne = tonumber(arg3)
		local nNeedBindYuanbao = nPriceOne * g_itemNum
		g_pos = tonumber(arg4)
		local name = arg6
		local nHaveBindYuanbao = Player : GetData( "BIND_YUANBAO" )
		local nCostYuanbao = nNeedBindYuanbao - nHaveBindYuanbao
		--È·¶¨ÄãÊÇ·ñ¹ºÂò â¸ö¶«Î÷ .. g_itemNum.."#{ZSZBSJ_XML_17}"
		SelectServerQuest_InfoWindow:SetText("#{BDYB_XML_1}#G" ..name .."#{BDYB_XML_2}#G"..nNeedBindYuanbao.."#{BDYB_XML_3}#G"..nHaveBindYuanbao.."#{BDYB_XML_4}#G"..nCostYuanbao.."#{BDYB_XML_5}")
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("Ð°ng ý");
		SelectServerQuest_Button2:SetText("Hüy");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
	end

	if (event == "DISPLACEGEM_CONFIRM") then
		g_iYesNoType = tonumber(arg0)
		SelectServerQuest_Frame_sub:SetProperty( "UnifiedSize", "{{0.000000,346.000000},{0.000000,128.000000}}" )
		local infotype = tonumber(arg1);
		if infotype == 1 then
			SelectServerQuest_InfoWindow:SetText("#{CLJY_120813_04}");
		else
			SelectServerQuest_InfoWindow:SetText("#{BSQKY_20110506_22}");
		end
		SelectServerQuest_Button1:SetText("#{INTERFACE_XML_1173}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();
	end
	if (event == "DISPLACE_CLOSE_MSGBOX") then
		g_iYesNoType = -1
		this:Hide();
	end
	-- Ôª±¦¿ì½ÝÇ¿»¯µÄ¶þ´ÎÈ·ÈÏ
	if( event == "UI_COMMAND" and tonumber(arg0) == 80926201) then
		g_iYesNoType = 30
		g_bagIndex = Get_XParam_INT( 0 )
		local strMsg = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strMsg)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("Ð°ng ý")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()
		SelectServerQuest_Button2:SetText("Hüy")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	-- Èý¾«²ÄÁÏÅúÁ¿ºÏ³É
	if( event == "UI_COMMAND" and tonumber(arg0) == 920170826) then
		g_iYesNoType = 42

		CaiLiaoCompound_Data[1] =  Get_XParam_INT(0)
		CaiLiaoCompound_Data[2] =  Get_XParam_INT(1)
		CaiLiaoCompound_Data[3] =  Get_XParam_INT(2)
		CaiLiaoCompound_Data[4] =  Get_XParam_INT(3)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("Ð°ng ý")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("Hüy")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- Èó»êÊ¯ÅúÁ¿ºÏ³É
	if( event == "UI_COMMAND" and tonumber(arg0) == 2016110702) then
		g_iYesNoType = 43

		RunHunShiCompound_Data[1] =  Get_XParam_INT(0)
		RunHunShiCompound_Data[2] =  Get_XParam_INT(1)
		RunHunShiCompound_Data[3] =  Get_XParam_INT(2)
		RunHunShiCompound_Data[4] =  Get_XParam_INT(3)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("Ð°ng ý")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("Hüy")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- »ê±ùÖéÅúÁ¿ºÏ³É
	if( event == "UI_COMMAND" and tonumber(arg0) == 79007502) then
		g_iYesNoType = 52

		HunBingZhuCompound_Data[1] =  Get_XParam_INT(0)
		HunBingZhuCompound_Data[2] =  Get_XParam_INT(1)
		HunBingZhuCompound_Data[3] =  Get_XParam_INT(2)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("Ð°ng ý")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("Hüy")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- ÁéÊÞµ¤ºÏ³É
	if( event == "UI_COMMAND" and tonumber(arg0) == 31111201) then
		g_iYesNoType = 44

		LingShouDanCompound_Data[1] =  Get_XParam_INT(0)
		LingShouDanCompound_Data[2] =  Get_XParam_INT(1)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("Ð°ng ý")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("Hüy")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	if ( event == "DRESSPAINT_SELECTSERVER" ) then
		g_iYesNoType = 45
		local strDressPaint = ScriptGlobal_Format("#{SZRSYH_120912_20}",tostring(arg0))
		SelectServerQuest_InfoWindow:SetText(strDressPaint)
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("#{SZRSYH_210315_02}")
		this:Show()
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button2:Hide()
		return;
	end

	if ( event == "DRESSPAINT_BINDDRESS" ) then
		g_iYesNoType = 46
		SelectServerQuest_InfoWindow:SetText("#{YJRS_140613_19}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{SZRSYH_210315_04}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{SZRSYH_210315_05}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return;
	end
	if ( event == "WEGAME_FORCEQUIT" ) then
		EnterQuitWait(3);
		return
	end

	-- ·â»êÂ¼Àñ°ü
	if( event == "UI_COMMAND" and tonumber(arg0) == 79101102) then

		-- 0 ¹Ø± , 1 ´ò¿ª, 2 Ë¢ÐÂ, 3 ¶þ´ÎÈ·ÈÏ¿ò
		local nOpType 	= Get_XParam_INT(0)
		if nil == nOpType or 3 ~= nOpType then
			return
		end


		g_iYesNoType = 51

		FengHunLu_Data[1] 	=  Get_XParam_INT(1)
		FengHunLu_Data[2] 	=  Get_XParam_INT(2)
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{XYSHFC_20211229_160}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{XYSHFC_20211229_161}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end
	
	-- ·â»êÂ¼Àñ°ü
	if( event == "UI_COMMAND" and tonumber(arg0) == 88892103) then 

		g_iYesNoType = 54

		g_SelecQuest_Data[1] 	=  Get_XParam_INT(0) 
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()
 				
		SelectServerQuest_Button1:SetText("#{MPFC_220622_122}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{MPFC_220622_123}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()

	end

	--  ù°ÔÈü ÑûÇëÍæ¼ÒÈë¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022090601) then
		g_iYesNoType = 55

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)
		g_ZBS_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_124}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_125}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	--  ù°ÔÈü ½âÉ¢ ½¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022090801) then
		g_iYesNoType = 56

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	--  ù°ÔÈü ÇëÀë ½¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022091401) then
		g_iYesNoType = 57

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	--  ù°ÔÈü ÍË³ö ½¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022091501) then
		g_iYesNoType = 58

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89004901) then
		--Ê¥µ®Ó¦¾°-È¤Î¶Ê¥µ®Ê÷
		g_iYesNoType = 60
		g_bagIndex = Get_XParam_INT(0);
		SelectServerQuest_InfoWindow:SetText("#{QWSD_20221017_35}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QWSD_20221017_36}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QWSD_20221017_37}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end


	-- Ìì»ú³Ç£¨²»ÀÏµî£© ¿ç·þPVP Èë³¡È·ÈÏ
	if (event == "UI_COMMAND" and tonumber(arg0) == 89011104) then
		g_iYesNoType = 61

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		SelectServerQuest_InfoWindow:SetText("#{BLDPVP_221214_33}")

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{BLDPVP_221214_34}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{BLDPVP_221214_35}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 79109002) then
		-- ´º½Ú´ò¹¤ÍÃ
		g_iYesNoType = 62
		DaGongTu_Data[1] = Get_XParam_INT(0);
		DaGongTu_Data[2] = Get_XParam_INT(1);
		SelectServerQuest_InfoWindow:SetText("#{YCDGT_221109_27}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{YCDGT_221109_28}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{YCDGT_221109_29}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end
	
	-- ³¤´ºÀñ°ü
	if( event == "UI_COMMAND" and tonumber(arg0) == 89017402) then

		g_iYesNoType = 63

		changchunlibao_data[1] 	=  Get_XParam_INT(0)
		changchunlibao_data[2] 	=  Get_XParam_INT(1)
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{ZXJQ_221225_553}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{ZXJQ_221225_554}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- µÛÁêÔÙÏÖPVP»î¶¯
	if( event == "UI_COMMAND" and tonumber(arg0) == 99826001) then
		g_iYesNoType = 64
		
		g_DLZX_Data[1] = Get_XParam_INT(0)
		g_DLZX_Data[2] = Get_XParam_INT(1)
		g_DLZX_Data[3] = Get_XParam_INT(2)
		g_DLZX_Data[4] = Get_XParam_INT(3)
		g_DLZX_Data[5] = Get_XParam_INT(4)
		g_DLZX_Data[6] = Get_XParam_INT(5)
		g_DLZX_Data[7] = Get_XParam_INT(6)

		local msg = ScriptGlobal_Format("#{DLZX_230314_22}", g_DLZX_Data[3], g_DLZX_Data[4], g_DLZX_Data[5])
		SelectServerQuest_InfoWindow:SetText(msg)
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("#{DLZX_230314_23}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button2:SetText("#{DLZX_230314_24}")
		SelectServerQuest_Button2:Show()
		this:Show()
	end


	if ( event == "PLDGELOVE_CONFIRM" ) then
		--½á»é½»»»ÐÅÎï¹«¸æ¶þ´ÎÈ·ÈÏ
		g_iYesNoType = 65
		g_bagIndex = tonumber(arg0)
		SelectServerQuest_InfoWindow:SetText("#{JHYH_230330_187}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{JHYH_230330_188}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{JHYH_230330_189}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end


	-- ÐÂ6v6 ÑûÇëÈë¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849701) then
		g_iYesNoType = 70

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_75}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_76}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- ÐÂ6v6 ½âÉ¢ ½¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849702) then
		g_iYesNoType = 71

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		SelectServerQuest_InfoWindow:SetText("#{JZGN_20230710_98}")

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_99}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_100}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- ÐÂ6v6 ÍË³ö ½¶Ó
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849704) then
		g_iYesNoType = 72

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_99}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_100}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99853701) then
		g_iYesNoType = 73
		g_bagIndex = Get_XParam_INT(0);
		SelectServerQuest_InfoWindow:SetText("#{QWSD_20221017_35}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QWSD_20221017_36}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QWSD_20221017_37}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end

	-- ¿ç·þÅÀËþ¶á±¦ Áì½±£¨¸öÈË½áËã£©
	if (event == "UI_COMMAND" and tonumber(arg0) == 99856301) then
		g_iYesNoType = 74

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- ¿ç·þÅÀËþ¶á±¦ Áì½±£¨°ï»á½áËã£©
	if (event == "UI_COMMAND" and tonumber(arg0) == 99856302) then
		g_iYesNoType = 75

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99873903) then
		g_iYesNoType = 76
		local ItemId;
		local changeStrFlag;
		--´Ë´¦´«ÈëµÄtypeID,·ÇbagIndex
		g_bagIndex = Get_XParam_INT(0);
		changeStrFlag = Get_XParam_INT(1);
		if g_bagIndex == 1 then
			ItemId = 38003116
		else
			ItemId = 38003117
end
		local text
		if changeStrFlag == 1 then
			text = ScriptGlobal_Format("#{ZNDB_230215_120}",1,PlayerPackage:GetItemName( ItemId ));
		else
			text = ScriptGlobal_Format("#{ZNDB_230215_152}",PlayerPackage:GetItemName( ItemId ));
		end
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99883104) then
		g_iYesNoType = 77
		--´«Èë½çÃæIndex
		g_SelecQuest_Data[1] = tonumber(arg1);
		g_SelecQuest_Data[2] = tonumber(arg2);
		local ItemName = tostring(arg3)
		local text = ScriptGlobal_Format("#{QEYD_240402_160}",ItemName);
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99883105) then
		g_iYesNoType = 78
		g_SelecQuest_Data[1] = tonumber(arg1);
		local text = ScriptGlobal_Format("#{QEYD_240402_112}",PlayerPackage:GetItemName( 38003158 ));
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99926202) then
		g_iYesNoType = 79
		--´«Èë½çÃæIndex
		g_SelecQuest_Data[1] = tonumber(arg1);
		g_SelecQuest_Data[2] = tonumber(arg2);
		local ItemName = tostring(arg3)
		local text = ScriptGlobal_Format("#{QEYD_240402_160}",ItemName);
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

end

function SelectServerQuest_LostPassWord()
	
	if g_iYesNoType == 29 then
		if GameProduceLogin:IsWeGameClient() <= 0 then
			GameProduceLogin:OpenURL(GetWeblink("WEB_THREEDDAYFORBIT"))
		else
			GameProduceLogin:OpenURL(GetWeblink("WEB_WEGAME_KF"))
		end
	elseif g_iYesNoType == 30 then
		if GameProduceLogin:IsWeGameClient() <= 0 then
			GameProduceLogin:OpenURL(GetWeblink("WEB_THREEDDAYFORBIT"))
		else
			GameProduceLogin:OpenURL(GetWeblink("WEB_WEGAME_KF"))
		end
	elseif g_iYesNoType == 31 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))	
	elseif g_iYesNoType == 32 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
	elseif g_iYesNoType == 33 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
	elseif g_iYesNoType == 34 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_INPUTAUTHPHONE"))
	elseif g_iYesNoType == 36 then
		if(Variable:GetVariable("System_CodePage") == "1258") then
			GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
		else
  	  GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
		end
	
	elseif g_iYesNoType == 37 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT3"))
		
	elseif g_iYesNoType == 38 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT1"))
		
	elseif g_iYesNoType == 39 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT2"))	
	elseif g_iYesNoType == 40 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_LSOB"))	
	elseif g_iYesNoType == 41 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_ZHJH"))	
	elseif g_iYesNoType == 47 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT4"))	
	elseif g_iYesNoType == 48 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT6"))
	elseif g_iYesNoType == 49 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT7"))
	elseif g_iYesNoType == 50 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT4"))	
	end
	
end

-------------------------------------------------------------
--
-- °´Å¥1 µã»÷ÊÂ¼þ
--
function SelectServerQuest_Bn1Click()
-- 0 - ÍË³öÓÎÏ·
-- 4 - È·ÈÏÊÇ·ñÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
-- 5 - 7ÌìÄÚÌáÐÑÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
-- 6 - 7Ììºó£¬14ÌìÄÚÌáÐÑÉ¾³ý10¼¶ÒÔÉÏÍæ¼Ò
-- 7 - ÊÇ·ñÉ¾³ý10¼¶ÒÔÏÂÍæ¼Ò
-- 8 - ´óÓÚ10¼¶µÃÌáÊ¾
	if( -1 == g_iYesNoType and 1 == g_bIsQuitMsgBox) then
		CancelQuitWait(); --????
	end
	if(0 == g_iYesNoType) then
		QuitApplication("quit");
	elseif(1 == g_iYesNoType) then
	elseif(2==g_iYesNoType) then
		GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
	elseif( 3 == g_iYesNoType ) then
		GameProduceLogin:CloseNetConnect();
	elseif( 4 == g_iYesNoType ) then
			local strInfo;
		  strInfo ="Nhân v§t cüa các hÕ không th¬ xóa ngay ðßþc, xin 3 ngày sau trong vòng 14 ngày ðång nh§p vào trò ch½i, ðªn LÕc Dß½ng (268, 46) tìm Quan Hán Th÷ ho£c ÐÕi Lý (80, 136) tìm Châu Xß½ng xác nh§n, là có th¬ xóa. Lúc xác nh§n xóa nhân v§t không th¬ có bang hµi, kªt hôn, kªt bái, m· ti®m trÕng thái, nªu không vi®c xóa nhân v§t s¨ b¸ hüy. Quá 14 ngày không xác nh§n thao tác xóa nhân v§t s¨ vô hi®u."
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "8" );
	elseif( 5 == g_iYesNoType ) then
	elseif( 6 == g_iYesNoType ) then
	elseif( 7 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 8 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:LoginPlayer( 1 );
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Có kích hoÕt không_Nh¤p ch÷n OK");
	elseif(11 == g_iYesNoType) then
		GameProduceLogin:CheckAccountNoMibao();
	elseif(12 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300077 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_Parameter( 1, 0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif(13 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseTianYuanJinDan" )
			Set_XSCRIPT_ScriptID( 332004 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif(14 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300088 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif(15 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Anqi2Shenzhen" )
			Set_XSCRIPT_ScriptID( 260001 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_Parameter( 1, g_bagIndex2 )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (17 == g_iYesNoType) then
		PetEquipSuitDepart:ConfirmDepart()
	elseif (18 == g_iYesNoType) then
		--°ó¶¨Ôª±¦²»×ãÊ±£¬È·¶¨
		NpcShop:BindYuanBaoNotEnough(g_itemNum, g_item,g_pos)
	elseif (19 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenShike(1)
	elseif (20 == g_iYesNoType) then
		if g_objCared ~= -1 and g_bagIndex ~= -1 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("DelProtectGoods");
				Set_XSCRIPT_ScriptID(124);
				Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
				Set_XSCRIPT_Parameter(1,tonumber(g_bagIndex));
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	elseif (21 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenHecheng(1)
	elseif (22 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenQianghua(1)
	elseif (23 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenShike(2)
	elseif (24 == g_iYesNoType) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GivePrize");
			Set_XSCRIPT_ScriptID(808147)
			Set_XSCRIPT_Parameter(0,tonumber(g_objCared))
			Set_XSCRIPT_Parameter(1,tonumber(g_bagIndex))
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (25 == g_iYesNoType) then --?????????
		--Èç¹ûÉ±Launch½ø³ÌÊ§°Ü£¬²»Òþ²Ø
		if (GameProduceLogin:KillLaunchProcess() == 0) then
			return;
		end
	elseif (30 == g_iYesNoType) then
		-- Ôª±¦¿ì½ÝÇ¿»¯µÄ¶þ´ÎÈ·ÈÏ
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoQuickQiangHuaByYB")
			Set_XSCRIPT_ScriptID(809262)
			Set_XSCRIPT_Parameter(0, tonumber(g_bagIndex))
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (42 == g_iYesNoType) then
		-- Èý¾«²ÄÁÏÅúÁ¿ºÏ³É
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "CaiLiaoCompound_New" )
			Set_XSCRIPT_ScriptID(701602)
			Set_XSCRIPT_Parameter(0,CaiLiaoCompound_Data[1])--npcid
			Set_XSCRIPT_Parameter(1,CaiLiaoCompound_Data[2])--1??2??
			Set_XSCRIPT_Parameter(2,CaiLiaoCompound_Data[3])--??
			Set_XSCRIPT_Parameter(3,CaiLiaoCompound_Data[4])--???
			Set_XSCRIPT_Parameter(4,1)--????
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif (43 == g_iYesNoType) then
		-- Èó»êÊ¯ÅúÁ¿ºÏ³É
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "RunHunShiCompound_New" )
			Set_XSCRIPT_ScriptID(809270)
			Set_XSCRIPT_Parameter(0,RunHunShiCompound_Data[1])--npcid
			Set_XSCRIPT_Parameter(1,RunHunShiCompound_Data[2])--1??2??
			Set_XSCRIPT_Parameter(2,RunHunShiCompound_Data[3])--??
			Set_XSCRIPT_Parameter(3,RunHunShiCompound_Data[4])--???
			Set_XSCRIPT_Parameter(4,1)--????
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif (44 == g_iYesNoType) then
		-- ÁéÊÞµ¤ºÏ³É
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "PetMedicineHC_ForCheck" )
			Set_XSCRIPT_ScriptID(311112)
			Set_XSCRIPT_Parameter(0,LingShouDanCompound_Data[1]) -- npcid
			Set_XSCRIPT_Parameter(1,LingShouDanCompound_Data[2]) -- standardStuff
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif(46 == g_iYesNoType) then
		-- g_DressPaint_TipsBind = 1 -- Ô­¾­µäÎªÈ«¾Ö±äÁ¿£¬±ä»»ÐÎÊÆ°É
		DressReplaceColor:SetDressPaint_TipsBind(1)
	elseif (51 == g_iYesNoType) then
		-- ·â»êÂ¼Àñ°ü
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
			Set_XSCRIPT_ScriptID(791011)
			Set_XSCRIPT_Parameter(0, FengHunLu_Data[1])
			Set_XSCRIPT_Parameter(1, FengHunLu_Data[2]) 
			Set_XSCRIPT_Parameter(2, 1) 
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (52 == g_iYesNoType) then
		-- »ê±ùÖéÅúÁ¿ºÏ³É
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnHunBingZhuCompoundNew" )
			Set_XSCRIPT_ScriptID(790075)
			-- Set_XSCRIPT_Parameter(0, g_nServerObjID)					
			-- Set_XSCRIPT_Parameter(1, g_nCurSelectedPage)					
			-- Set_XSCRIPT_Parameter(2, g_nCurSelectedIndex)		
			Set_XSCRIPT_Parameter(0, HunBingZhuCompound_Data[1])					
			Set_XSCRIPT_Parameter(1, HunBingZhuCompound_Data[2])					
			Set_XSCRIPT_Parameter(2, HunBingZhuCompound_Data[3])			
			Set_XSCRIPT_Parameter(3, 1)	
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (53 == g_iYesNoType) then
		-- ÎåÒ»·ÅÑÌ»¨
		if g_YanHua_From == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenUICommand" )
				Set_XSCRIPT_ScriptID(893123)	
				Set_XSCRIPT_Parameter(0, 1)		
				Set_XSCRIPT_Parameter(1, g_YanHua_Param)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif g_YanHua_From == 2 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnClickFire" )
				Set_XSCRIPT_ScriptID(893124)	
				Set_XSCRIPT_Parameter(0, g_YanHua_Param)	
				Set_XSCRIPT_Parameter(1, 0)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		else
			--error
		end
	elseif (54 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetPage3Gift" )
			Set_XSCRIPT_ScriptID(888921)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])	
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (55 == g_iYesNoType) then
		--  ù°ÔÈü ÑûÇëÍæ¼ÒÈë¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_Parameter(2, g_ZBS_Data[2])
			Set_XSCRIPT_Parameter(3, g_ZBS_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (56 == g_iYesNoType) then
		--  ù°ÔÈü ½âÉ¢ ½¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_DismissConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (57 == g_iYesNoType) then
		--  ù°ÔÈü ÇëÀë ½¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_DeleteMemberConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[2])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (58 == g_iYesNoType) then
		--  ù°ÔÈü ÍË³ö ½¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_QuitConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (60 == g_iYesNoType) then
		--Ê¥µ®Ó¦¾°-È¤Î¶Ê¥µ®Ê÷
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Confim")
			Set_XSCRIPT_ScriptID(890049)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (61 == g_iYesNoType) then
		-- Ìì»ú³Ç£¨²»ÀÏµî£© ¿ç·þPVP
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Callback_EnterConfirmed")
			Set_XSCRIPT_ScriptID(890111)
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (62 == g_iYesNoType) then
		-- ´º½Ú´ò¹¤ÍÃ
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnSubmitDaiBi")
			Set_XSCRIPT_ScriptID(791090)
			Set_XSCRIPT_Parameter(0, DaGongTu_Data[1])
			Set_XSCRIPT_Parameter(1, DaGongTu_Data[2])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (63 == g_iYesNoType) then
		-- ³¤´ºÀñ°ü
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
			Set_XSCRIPT_ScriptID(890174)
			Set_XSCRIPT_Parameter(0, changchunlibao_data[1])
			Set_XSCRIPT_Parameter(1, changchunlibao_data[2]) 
			Set_XSCRIPT_Parameter(2, 1) 
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (64 == g_iYesNoType) then
		-- µÛÁêÔÙÏÖPVP»î¶¯
		if (g_DLZX_Data[1] == 1) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("CallBack_BuyPermision_Confirm")
				Set_XSCRIPT_ScriptID(998260)
				Set_XSCRIPT_Parameter(0, g_DLZX_Data[2])
				Set_XSCRIPT_Parameter(1, g_DLZX_Data[6])
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif (g_DLZX_Data[1] == 2) then
			Clear_XSCRIPT()
				if (g_DLZX_Data[7] > 0) then
					Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_BuyConfirm_DLSY")
				else
					Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_BuyConfirm")
				end
				Set_XSCRIPT_ScriptID(998260)
				Set_XSCRIPT_Parameter(0, g_DLZX_Data[2])
				Set_XSCRIPT_Parameter(1, g_DLZX_Data[6])
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		end
	elseif (65 == g_iYesNoType) then
		--½á»é½»»»ÐÅÎï¹«¸æ¶þ´ÎÈ·ÈÏ
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SaveItemData");
			Set_XSCRIPT_ScriptID(401030);
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_Parameter(1,1);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (70 == g_iYesNoType) then
		-- ÐÂ6v6 ÑûÇëÍæ¼ÒÈë¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_Parameter(2, g_SelecQuest_Data[2])
			Set_XSCRIPT_Parameter(3, g_SelecQuest_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (71 == g_iYesNoType) then
		-- ÐÂ6v6 ½âÉ¢ ½¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_DismissConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (72 == g_iYesNoType) then
		-- ÐÂ6v6 ÍË³ö ½¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_QuitConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (73 == g_iYesNoType) then
		--ÇéÈË½Ú´ò¿¨
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Confirm")
			Set_XSCRIPT_ScriptID(998537)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (74 == g_iYesNoType) then
		-- ¿ç·þÅÀËþ¶á±¦ Áì½±£¨¸öÈË½áËã£©
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TryRewardConfirm_Self")
			Set_XSCRIPT_ScriptID(998563)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (75 == g_iYesNoType) then
		-- ¿ç·þÅÀËþ¶á±¦ Áì½±£¨¸öÈË½áËã£©
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TryRewardConfirm_Guild")
			Set_XSCRIPT_ScriptID(998563)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif 66 == g_iYesNoType then --??????
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ChangeSexSure")
			Set_XSCRIPT_ScriptID(250557)
			Set_XSCRIPT_Parameter(0, g_objCared)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (76 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ExchangeCheckAgain")
			Set_XSCRIPT_ScriptID(998739)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (77 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(998831)
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_Parameter(1,g_SelecQuest_Data[2]);
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (78 == g_iYesNoType) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GiveGiftBox");
			Set_XSCRIPT_ScriptID(998831);
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	elseif (79 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(999262)
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_Parameter(1,g_SelecQuest_Data[2]);
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	this:Hide();
end


-------------------------------------------------------------
--
-- °´Å¥2 µã»÷ÊÂ¼þ
--
function SelectServerQuest_Bn2Click()

	if(3 == g_iYesNoType) then
		GameProduceLogin:CloseNetConnect();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:PassportButNotReg();
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "Hay không kích hoÕt_Ði¬m Kích Li­u NO");
	elseif (55 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_Parameter(2, g_ZBS_Data[2])
			Set_XSCRIPT_Parameter(3, g_ZBS_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()

	elseif (65 == g_iYesNoType) then
		--½á»é½»»»ÐÅÎï¹«¸æ¶þ´ÎÈ·ÈÏ
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SaveItemData");
			Set_XSCRIPT_ScriptID(401030);
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (70 == g_iYesNoType) then
		-- ÐÂ6v6 ÑûÇëÍæ¼ÒÈë¶Ó
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_Parameter(2, g_SelecQuest_Data[2])
			Set_XSCRIPT_Parameter(3, g_SelecQuest_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end

	this:Hide();
end

function SelectServerQuest_TimeOut()
  if(TimerArg == "MIBAOERROR" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "USERFROMMAINPRO") then
	this:Hide();
	TimerArg = nil
  elseif(TimerArg == "WAITFORQUIT") then
	if(tonumber(g_QuitType)==0 or tonumber(g_QuitType)==3)then
		QuitApplication("quit");
	else
		AskRet2SelServer();
	end
	this:Hide();
	TimerArg = nil
	g_QuitType = nil
  elseif(TimerArg == "TURNOVER") then
	SelectServerQuest_Button1:Enable()
	TimerArg = nil
	elseif( TimerArg == "LoginCounting" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
	end
end

function SelectServerQuest_Frame_OnHiden()
	if(IsWindowShow("AntiJDY")) then          --??????????,?????? for 69994
		DataPool:SetCanUseHotKey(0);
	else
		DataPool:SetCanUseHotKey(1);
	end
end
