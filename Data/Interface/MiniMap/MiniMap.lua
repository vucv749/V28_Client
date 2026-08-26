local g_CurMap = "Minimap";
local TimeDot = {}
local strNetDelayMessage = nil

local g_myAsk = 0;

-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
local g_ZhanJiangHu_ShowButton = 0
local g_ZhanJiangHu_FlexTipState =
{
	[1] = 0,
	[2] = 0,
}

local g_2021_JuQing_RedPoint = 0

--OnLoad
--  0 Animy
--  1 ExpNPC
--  2 Teamate
--  3 OtherPlayer
--  4 ExpObj
function MiniMap_PreLoad()


	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UPDATE_MAP");
	this:RegisterEvent("OPEN_MINIMAP" );
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("UPDATE_NETSTATUS");
	this:RegisterEvent("PKMODE_CHANGE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SHOW_NEEDREPAIR")

	this:RegisterEvent("FLAH_MINIMAP");

	this:RegisterEvent("STOP_FLAH_MINIMAP");

	this:RegisterEvent("PLAYERASK_INGAME");

	this:RegisterEvent("MINMAP_PLAYERLIST_SHOW");

	this:RegisterEvent("UPDATE_SKY_TIME");

	this:RegisterEvent("SHOW_BUGFBBTN");
	this:RegisterEvent("UPDATE_FATIGUE");

	this:RegisterEvent("BATTLE_ASSIST_EVENT")
	this:RegisterEvent("ACCE_CHANGED")
		
	this:RegisterEvent("XINCHUNYINGJING_FLEX_UPDATE")-- ??-??????-???????
		
	this:RegisterEvent("RESET_ALLUI");
    
	this:RegisterEvent("GE_ALD_SHOWENTRY");
	this:RegisterEvent("GE_ALD_HIDEENTRY");
	this:RegisterEvent("GE_ALD_SHOWMARK");
	this:RegisterEvent("GE_ALD_HIDEMARK");
	this:RegisterEvent("MINIMAP_GSCHAT_SHOW");
	this:RegisterEvent("MINIMAP_GSCHAT_FLASH");
	this:RegisterEvent("OPEN_DAHUA_MINITIPS");

end

function MiniMap_PK_Mode_Show_Menu_Func()

	 Player:PVP_ShowMenu();
end;

function MiniMap_OnLoad()
	TimeDot[1] = MiniMap_TimeDot1
	TimeDot[2] = MiniMap_TimeDot2
	TimeDot[3] = MiniMap_TimeDot3
	TimeDot[4] = MiniMap_TimeDot4
	TimeDot[5] = MiniMap_TimeDot5
	TimeDot[6] = MiniMap_TimeDot6
	TimeDot[7] = MiniMap_TimeDot7
	TimeDot[8] = MiniMap_TimeDot8
	TimeDot[9] = MiniMap_TimeDot9
	TimeDot[10] = MiniMap_TimeDot10
	TimeDot[11] = MiniMap_TimeDot11
	TimeDot[12] = MiniMap_TimeDot12
	MiniMap_EquipEndurance:Hide();
	AxTrace(12,12,"MiniMap_OnLoad is called begin");

	Minimap_Max();
	MiniMap_Yuanbao:SetToolTip("Nguyên bäo cØa hàng");
	MiniMap_AutoSearch:SetToolTip("#{INTERFACE_XML_983}");
	MiniMap_NetStatus_Flash:Play( false );

	MiniMap_Fangchengmi_Btn	: Hide()
	MiniMap_XinShouNew:Hide()
	MiniMap_FeelFeedBack500:Hide()
	MiniMap_FeelFeedBack800:Hide()
	MiniMap_HeXinChun:Hide()-- ??-??????-???????
	MiniMap_ZhenShouYuRe:Hide()-- 2022??????
	MiniMap_ThreeDayFeedBack:Hide() --?????? 2022Q3 ???

	g_2021_JuQing_RedPoint = 0
	MiniMap_AlaDingBtnCheck();
	MiniMap_AlaDing_tips:Hide()
	MiniMap_GSChat:Hide()
	MiniMap_GSChat_Flash:Hide()
end
function MiniMap_UpdateSceneName()
	local scenename;
	scenename = GetCurrentSceneName();
	local len = string.len(scenename);
	if( len < 10 ) then
		MiniMap_Placename:SetProperty( "Font", "YouYuan9.75" );
	else
		MiniMap_Placename:SetProperty( "Font", "SongTiBmp12" );
	end
	MiniMap_Placename:SetText("#gFF0FA0".. scenename );
end

function MiniMap_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1238 ) then
			local sceneId = Get_XParam_INT(0)
			return
	end

	if ( event == "SCENE_TRANSED" ) then
		MiniMap_Update( arg0 );
		MiniMap_UpdateSceneName();
		UpdateMinimapState();

	elseif ( event == "UPDATE_MAP" ) then
		if( tonumber( arg0 ) == 1 ) then
			MiniMap_UpdateSceneName();
		end
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
	elseif( event == "OPEN_MINIMAP" ) then
		Variable:SetVariable( "MinimapState","mini", 1 );
		UpdateMinimapState();
	elseif( event == "ACCELERATE_KEYSEND" ) then
		MiniMap_HandleAccKey(arg0);
	elseif( event =="UPDATE_NETSTATUS") then
	  local strNetState = ""
		if tonumber(arg0) < 250 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState1")
			strNetState = "Ði¬m Kích Khä xem xét hôm nay hoÕt ðµng Li®t Bi¬u#rinternet trÕng hu¯ng: Không rãnh".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 500 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState2")
			strNetState = "Ði¬m Kích Khä xem xét hôm nay hoÕt ðµng Li®t Bi¬u#rinternet trÕng hu¯ng: Bình thß¶ng".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 1000 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState3")
			strNetState = "Ði¬m Kích Khä xem xét hôm nay hoÕt ðµng Li®t Bi¬u#rinternet trÕng hu¯ng: Ch§t chµi".."("..tostring(arg0).."ms)"
		else
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState4")
			strNetState = "Ði¬m Kích Khä xem xét hôm nay hoÕt ðµng Li®t Bi¬u#rinternet trÕng hu¯ng: Bª t¡c".."("..tostring(arg0).."ms)"
		end

		strNetDelayMessage = strNetState
		MiniMap_MiniMap_NetStatus : SetToolTip( strNetDelayMessage )
	elseif( event =="SHOW_NEEDREPAIR") then
		if tonumber(arg0) == 1 then
			MiniMap_EquipEndurance:Show();
			MiniMap_EquipEndurance:SetToolTip("#{ZBXL_081009_01}");
		else
			MiniMap_EquipEndurance:Hide();
		end;

	elseif( event == "PKMODE_CHANGE" ) then
		Minimap_UpdatePKMode();

	elseif( event == "OPEN_DAHUA_MINITIPS" ) then  
		local IsShowButton = tonumber(arg0)
		local IsShowTips = tonumber(arg1) 
		if IsShowButton == 1 then
			MiniMap_Dahua_Incom:Show()
		else
			MiniMap_Dahua_Incom:Hide()
		end
		if IsShowTips == 1 then
			MiniMap_Dahua_Incom_Tips:Show()
			MiniMap_Dahua_Incom_Animate:Show()
		else
			MiniMap_Dahua_Incom_Tips:Hide()
			MiniMap_Dahua_Incom_Animate:Hide()
		end
	elseif( event == "FLAH_MINIMAP" ) then
		MiniMap_FlashHuodong();
	elseif( event == "STOP_FLAH_MINIMAP" ) then
		MiniMap_StopFlashHuodong();
	elseif event == "UPDATE_SKY_TIME" then
		local skyTime = tonumber(arg0)
		local skyHour = math.floor(skyTime / 3600)
		local skyMinute = math.floor(math.mod(skyTime, 3600) / 60)
		local skySecond = math.mod(skyTime, 60)
		local skyTimeString = "Trß¾c m£t th¶i gian:"
		if skyHour < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skyHour) .. ":"
		if skyMinute < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skyMinute) .. ":"
		if skySecond < 10 then
			skyTimeString = skyTimeString .. "0"
		end
		skyTimeString = skyTimeString .. tostring(skySecond)
		if strNetDelayMessage ~= nil then
			MiniMap_MiniMap_NetStatus:SetToolTip(strNetDelayMessage .. "#r" .. skyTimeString)
		else
			MiniMap_MiniMap_NetStatus:SetToolTip(skyTimeString)
		end
	end

	if (event == "PLAYERASK_INGAME" )  then
		MiniMap_JiangHu:Hide();
		MiniMap_PlayerAsk_Bn:Show();
		MiniMap_PlayerAsk:Show();
		g_myAsk = tonumber(arg0)
	end

	if (event == "MINMAP_PLAYERLIST_SHOW") then
		MiniMap_LiebiaoFunc();
	end

	if (event == "SHOW_BUGFBBTN") then
		if(tonumber(arg0) == 1) then
			MiniMap_BugUpdate:Show();
		elseif(tonumber(arg0) == 0) then
			MiniMap_BugUpdate:Hide();
		end
	end
	
	if (event == "UPDATE_FATIGUE") then
		local bIsFatigue = Player:GetIsFatigue();
		if bIsFatigue ~= nil and bIsFatigue > 0 then
			MiniMap_Fangchengmi_Btn:Show();
		else
			MiniMap_Fangchengmi_Btn:Hide();
		end
	end
	if event == "BATTLE_ASSIST_EVENT" or event == "ACCE_CHANGED" then
		MiniMap_UpdateZdzdState()
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 89267901) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1)
--		PushDebugMessage("aa "..IsShowButton.." "..IsShowTips)
		if IsShowButton==1 then
			MiniMap_XinShouNew:Show()
			if IsShowTips==1 then
				MiniMap_XinShouNew_tips:Show()
				MiniMap_XinShouNewAnimate:Show();
				MiniMap_XinShouNewAnimate:Play(true);
			else
				MiniMap_XinShouNew_tips:Hide()
				MiniMap_XinShouNewAnimate:Hide();
			end
		else
			MiniMap_XinShouNew:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89267802) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1)
--		PushDebugMessage("aa "..IsShowButton.." "..IsShowTips)
		if IsShowButton==1 then
			MiniMap_LandReward:Show()
			if IsShowTips==1 then
				MiniMap_LandReward_tips:Show()
				MiniMap_LandRewardAnimate:Show();
				MiniMap_LandRewardAnimate:Play(true);
			else
				MiniMap_LandReward_tips:Hide()
				MiniMap_LandRewardAnimate:Hide();
			end
		else
			MiniMap_LandReward:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79101002) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1) 		 
		if IsShowButton==1 then			
			Lua_ShowQuickEnter(6,1) 
			if IsShowTips==1 then				
				Lua_ShowQuickEnterPointTip(6,1) 
			else
				Lua_ShowQuickEnterPointTip(6,0) 
			end
		else
			Lua_ShowQuickEnter(6,0) 
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 79201201) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1)
		-- PushDebugMessage("aa "..IsShowButton.." "..IsShowTips)
		if IsShowButton==1 then
			MiniMap_FeelFeedBack800:Show()
			if IsShowTips==1 then
				MiniMap_FeelFeedBack800_tips:Show()
				MiniMap_FeelFeedBack800_Animate:Show();
				MiniMap_FeelFeedBack800_Animate:Play(true);
			else
				MiniMap_FeelFeedBack800_tips:Hide()
				MiniMap_FeelFeedBack800_Animate:Hide();
			end
		else
			MiniMap_FeelFeedBack800:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 88991203) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1) 
		if IsShowButton == 1 then
			MiniMap_Dahua_Incom:Show()
		else
			MiniMap_Dahua_Incom:Hide()
		end
		if IsShowTips == 1 then
			MiniMap_Dahua_Incom_Tips:Show()
		else
			MiniMap_Dahua_Incom_Tips:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89306901) then-- 2022??????
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1)
		-- PushDebugMessage("aa "..IsShowButton.." "..IsShowTips)
		if IsShowButton==1 then
			MiniMap_ZhenShouYuRe:Show()
			if IsShowTips==1 then
				MiniMap_ZhenShouYuRe_tips:Show()
				MiniMap_ZhenShouYuRe_Animate:Show();
				MiniMap_ZhenShouYuRe_Animate:Play(true);
			else
				MiniMap_ZhenShouYuRe_tips:Hide()
				MiniMap_ZhenShouYuRe_Animate:Hide();
			end
		else
			MiniMap_ZhenShouYuRe:Hide()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89111912) then
		local IsShowButton = Get_XParam_INT(0)   
		if IsShowButton==1 then 
			MiniMap_ZLHeroMeeting:Show()
		else
			MiniMap_ZLHeroMeeting:Hide()
		end
	--//2021¾çÇéÈÎÎñ-ypl
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 8910800 ) then
		local param1 = Get_XParam_INT(0)
		local param2 = Get_XParam_INT(1)
		if param1 == 1 then
			if param2 == 1 then
				MiniMap_ZLLetterEnter_tips:Show()
				MiniMap_ZLLetterEnter_Animate:Show();
				MiniMap_ZLLetterEnter_Animate:Play(true);				
			else
				local param3 = Get_XParam_INT(2)
				g_2021_JuQing_RedPoint = param3
				if param3 == 1 then
					MiniMap_ZLLetterEnter_tips:Show()
					MiniMap_ZLLetterEnter_Animate:Show();
					MiniMap_ZLLetterEnter_Animate:Play(true);
				else
					MiniMap_ZLLetterEnter_Animate:Hide();
					MiniMap_ZLLetterEnter_tips:Hide()
				end
				
			end
			MiniMap_ZLLetterEnter:Show()
		else
			MiniMap_ZLLetterEnter:Hide()
		end
	--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 89121802 ) then
		local param1 = Get_XParam_INT(0)
		if param1 == 1 then			
			--Lua_TDU_Log("89121802-1");
			Lua_ShowQuickEnter(4,1) 
		else			
			--Lua_TDU_Log("89121802-0");
			Lua_ShowQuickEnter(4,0) 
		end		
	--//2022ÊÞ»êÒýµ¼ÈÎÎñ-ypl		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 8930400 ) then
		local param1 = Get_XParam_INT(0)
		local param2 = Get_XParam_INT(1)
		Lua_ShowQuickEnter(5,param1)
		Lua_ShowQuickEnterPointTip(5,param2) 
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 88998601) then
		local IsShowButton = Get_XParam_INT(0)
		local IsShowTips = Get_XParam_INT(1)
		if IsShowButton==1 then
			MiniMap_ThreeDayFeedBack:Show()
			if IsShowTips==1 then
				MiniMap_ThreeDayFeedBack_tips:Show()
				MiniMap_ThreeDayFeedBack_Animate:Show();
				MiniMap_ThreeDayFeedBack_Animate:Play(true);
			else
				MiniMap_ThreeDayFeedBack_tips:Hide()
				MiniMap_ThreeDayFeedBack_Animate:Hide();
			end
		else
			MiniMap_ThreeDayFeedBack:Hide()
		end
	end
	
	-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
	if (event == "RESET_ALLUI") then
		g_ZhanJiangHu_FlexTipState[1] = 0
		g_ZhanJiangHu_FlexTipState[2] = 0

		MiniMap_FeelFeedBack800:Hide()
		MiniMap_ZhenShouYuRe:Hide()-- 2022??????
		MiniMap_ThreeDayFeedBack:Hide() --?????? 2022Q3 ???
	end

	-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2018010603) then
		g_ZhanJiangHu_ShowButton = Get_XParam_INT(0)
		--Ë¢ÐÂ°´Å¥+Ð¡ºìµãÏÔÊ¾
		MiniMap_UpdateHeXinChun()
	end
	-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
	if (event == "XINCHUNYINGJING_FLEX_UPDATE") then	
		local nIndex = tonumber(arg0)
		local nValue = tonumber(arg1)
		if g_ZhanJiangHu_FlexTipState[nIndex] ~= nil then
			g_ZhanJiangHu_FlexTipState[nIndex] = nValue
		end		
		--Ë¢ÐÂ°´Å¥+Ð¡ºìµãÏÔÊ¾
		MiniMap_UpdateHeXinChun()
	end

	if (event == "GE_ALD_SHOWENTRY") then
		MiniMap_AlaDing:Show()
	end
	if (event == "GE_ALD_HIDEENTRY") then
	    MiniMap_AlaDing:Hide()
	end
	
	if (event == "GE_ALD_SHOWMARK")  then
		MiniMap_AlaDing_tips:Show()
	end
	
	if (event == "GE_ALD_HIDEMARK")  then
		MiniMap_AlaDing_tips:Hide()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89297502) then
		--Ë¢ÐÂ°´Å¥+Ð¡ºìµãÏÔÊ¾
		MiniMap_UpdateChunJieQianDao(Get_XParam_INT(0),Get_XParam_INT(1))
	end
	if (event == "MINIMAP_GSCHAT_SHOW") then
		if tonumber(arg0)==1 then
			MiniMap_GSChat:Show()
		else
			MiniMap_GSChat:Hide()
		end
	elseif (event == "MINIMAP_GSCHAT_FLASH") then
		if tonumber(arg0)==1 then
			--ÉÁË¸
			MiniMap_GSChat_Flash:Show()
		else
			--²»ÉÁ
			MiniMap_GSChat_Flash:Hide()
		end
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99838702) then 
		local isshow = Get_XParam_INT(0)
		if isshow == 0 then
			MiniMap_ThemeShop:Hide()
		else
			MiniMap_ThemeShop:Show()
		end
	end

end

function MiniMap_FangChenMi_MouseEnter()
	local nOnlineTime = Player:GetFatigueOnlineTime();
	local strTooltip = "#{CMXT_191210_06}"..math.floor(nOnlineTime/60000).."#{CMXT_191210_19}";
	MiniMap_Fangchengmi_Btn:SetToolTip( strTooltip );
end
function MiniMap_FangChenMi_MouseLeave()
end

function MiniMap_FlashHuodong()
	--AxTrace( 8,3,"init minimap" );
	MiniMap_NetStatus_Flash:Play( true );
end

function MiniMap_StopFlashHuodong()
	MiniMap_NetStatus_Flash:Play( false );
end

function Minimap_UpdatePKMode()
	local nPKMode = Player:GetPKMode();
	if( tonumber( nPKMode ) == 0 ) then
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "Peace" );
	else
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "War" );
	end

	local strPKMode = ""
	if( tonumber( nPKMode ) == 0 ) then
		--MiniMap_PK_Mode:SetToolTip( "ºÍÆ½" );
		strPKMode = "Hòa bình\\nThØ hình thÑc HÕ chï có th¬ Phän Kích công kích chính mình Ðích ngß¶i ch½i, không th¬ chü ðµng công kích ngß¶i ch½i khác."
	elseif( tonumber( nPKMode ) == 1 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_ALL" );
		strPKMode = "Cá nhân h²n chiªn"

	elseif( tonumber( nPKMode ) == 2 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_MORAL" );
		strPKMode = "Thi®n ác hình thÑc\\nThØ hình thÑc HÕ có th¬ công kích sát khí l¾n h½n 0Ðích ngß¶i ch½i."

	elseif( tonumber( nPKMode ) == 3 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_TEAM" );
		strPKMode = "T± ðµi h²n chiªn"

	elseif( tonumber( nPKMode ) == 4 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_GUILD" );
		strPKMode = "Bang phái ð°ng minh h²n chiªn"
		
	elseif( tonumber( nPKMode ) == 5 ) then
		strPKMode = "#{TDGZ_XML_19}"
	end

	local strTime = ""
	local iTime = Player:GetTimeToPeace()

	if( -1 ~= iTime ) then
	    iTime = math.floor( iTime / 1000 )
	    local iSec = math.mod( iTime, 60 )
	    local iMin = math.floor( iTime / 60 )

	    --strTime = "#r("..( tonumber(iTime) ).."ÃëºóÇÐ»»µ½ºÍÆ½»òÉÆ¶ñÄ£Ê½)"
	    if( iMin > 0 ) then
	        strTime = "#r"..(iMin).."Phút"..( tonumber(iSec) ).."Sao H§u c¡t Ðáo hòa bình Ho£c thi®n ác hình thÑc"
	    else
	        strTime = "#r"..( tonumber(iSec) ).."Sao H§u c¡t Ðáo hòa bình Ho£c thi®n ác hình thÑc"
	    end

	end

	MiniMap_PK_Mode:SetToolTip( strPKMode..strTime )


end
			--IMAGE_TYPE_Animy	= 0, // µÐÈË
			--IMAGE_TYPE_ExpNpc	= 1, // ÌØÊânpc
			--IMAGE_TYPE_Team		= 2, // ¶ÓÓÑ
			--IMAGE_TYPE_Player	= 3, // ±ðµÄÍæ¼Ò
			--IMAGE_TYPE_ExpObj	= 4, // Éú³¤µã
			--IMAGE_TYPE_Active	= 5, // ¼¤»î·½Ïòµã
			--IMAGE_TYPE_ScenePos = 6, // ³¡¾°Ìø×ªµã
			--IMAGE_TYPE_Flash	= 7, // ÉÁ¹âµã
			--IMAGE_TYPE_Pet		= 8, // ³èÎï
			--IMAGE_TYPE_Direction = 9,// ·½Ïò¼ýÍ·
function UpdateMinimapState()

		this:Show();
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
		Minimap_UpdatePKMode();
		MiniMap_UpdateZdzdState()
end

function MiniMap_Update( filename )
	--AxTrace( 0,0,"init minimap" );
	local sceneX, sceneY;
	sceneX,sceneY = GetSceneSize();
	MiniMap_MapArea:SetSceneFileName( sceneX,sceneY,filename,1 );
	MiniMap_Frame:SetForce();
end

function MiniMap_PosModify()
	if( this:IsVisible() ) then
		MiniMap_MapArea:UpdateFlag();
	end
end

function Minimap_Max()
	MiniMap_CloseButtons:Show()
	MiniMap_OpenButtons:Hide()
	MiniMap_Background_Frame:Show();
end

function Minimap_Min()
	MiniMap_CloseButtons:Hide()
	MiniMap_OpenButtons:Show()
	MiniMap_Background_Frame:Hide();
end

function Minimap_CoordinateUpdate()

	local coordinatex,coordinatey,direct;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	MiniMap_Coordinate:SetText( "#cFDFF73"..tostring( coordinatex ).."  "..tostring( coordinatey ) );

	for i=1,12 do
		TimeDot[i]:Hide()
	end
	local hour = GetCurrentTime() + 1;
	MiniMap_ChineseTime:SetProperty("SetCurrentImage", "Time"..tostring( hour ) );
	--AxTrace( 8,0,"µ±Ç°Ê±¼ä"..tostring( hour ) );
	TimeDot[ hour ]:Show();

end

function MiniMap_HandleAccKey( op )
	if(op == "acc_resetcamera") then
		ResetCamera();
	elseif(op == "acc_worldmap") then
		ToggleLargeMap();
	end
end

function Do_OpenAutoSearch()
	OpenAutoSearch();
end

function MiniMap_YuanBaoFunc()
	ToggleYuanbaoShop()
end

function MiniMap_GotoDirectly()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	AutoRunToTarget(coordinatex, coordinatey);
end

function MiniMap_NetStatus_MouseEnter()
end

function MiniMap_NetStatus_MouseLeave()

end

function MiniMap_NetStatus_MouseLButtonDown()
	OpenTodayCampaignList();
	MiniMap_NetStatus_Flash:Play( false );
end

function MiniMap_PlayerAsk_Bn_Clicked()
	local menpai = Player:GetData("MEMPAI");
	local strName = "";

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == menpai) then
		strName = "Thiªu Lâm";

	elseif(1 == menpai) then
		strName = "Minh Giáo";

	elseif(2 == menpai) then
		strName = "Cái Bang";

	elseif(3 == menpai) then
		strName = "Võ Ðang";

	elseif(4 == menpai) then
		strName = "Nga Mi";

	elseif(5 == menpai) then
		strName = "Tinh Túc";

	elseif(6 == menpai) then
		strName = "Thiên Long";

	elseif(7 == menpai) then
		strName = "Thiên S½n";

	elseif(8 == menpai) then
		strName = "Tiêu dao";

	elseif(9 == menpai) then
		strName = "Tñ do";

	elseif(10== menpai) then
		strName = "MÕn Ðà S½n Trang";

	end

	local urlStr = "{gameName:tlbb";
	urlStr = urlStr..",accountId:"..Player:GetData("ACCOUNTNAME");
	
	local idWorld = Variable:GetVariable("Login_World")
	if idWorld ~= nil then
		urlStr = urlStr..",serverId:"..idWorld
	end
	
	urlStr = urlStr..",roleName:"..Player:GetName()	
	
	local szGuid = GetSelfGUID();
	urlStr = urlStr..",roleId:"..ConvertGuidToShow( szGuid )
	urlStr = urlStr..",roleGrade:"..Player:GetData("LEVEL")	
	urlStr = urlStr..",vipGrade:"..DataPool:GetAccVipLevel()
	urlStr = urlStr..",Profession:"..strName	--??
	urlStr = urlStr..",gameVersion:"..GetGameVersion();	
	urlStr = urlStr.."}";
	
	local vcode = CalciDiaoYanVCode(urlStr.."345341234567353534/Vo48a31bd=");   --???SECRET_KEY
	urlStr = ConvertStringToURLCoding(urlStr)
	GameProduceLogin:OpenURL( GetWeblink("WEB_ACTIVITY_SEARCH")..tostring(g_myAsk).."/?appdata="..urlStr.."&vcode="..vcode );
	MiniMap_PlayerAsk_Bn:Hide();
	MiniMap_PlayerAsk:Hide();
	MiniMap_JiangHu:Show();
end

function MiniMap_LiebiaoFunc()
	Guild:AskGuildNameList();
end

function MiniMap_KeFu()
	if GameProduceLogin:IsWeGameClient() <= 0 then
		local urlStr = GetWeblink("WEB_CHANGYOU_GM");
		urlStr = ConvertStringToURLCoding(urlStr);
		GameProduceLogin:OpenURL( urlStr );
	else
		local urlStr = GetWeblink("WEB_WEGAME_KF");
		urlStr = ConvertStringToURLCoding(urlStr);
		GameProduceLogin:OpenURL( urlStr );
	end

	--ÏòServer·¢ËÍÈ Ö¾Í³¼ÆÇëÇó
	local ASKCG_LOG_TYPE = 1;	--CGAskNoteLog??????
	RequestServerNoteLog(ASKCG_LOG_TYPE);
end
--bug·´À¡
function MiniMap_BugFeedBack()
	OpenBugFeedBack();
end

-- ×Ô¶¯ ½¶·
function MiniMap_ZDZD()
	if BattleAssist:IsWorking() then
		PushEvent("TRIGGER_ZIDONGZHANDOU","stop")
	else
		PushEvent("TRIGGER_ZIDONGZHANDOU","start")
	end
end

function MiniMap_GongLue()
	local urlStr = GetWeblink("WEB_GUIDE")
	urlStr = ConvertStringToURLCoding(urlStr)
	GameProduceLogin:OpenURL( urlStr )
end
function MiniMap_UpdateZdzdState()
	if BattleAssist:IsWorking() then
		MiniMap_Zidongzhandou:SetProperty("NormalImage","set:Logon01 image:ZiDongZhanDOU_Lv")
		MiniMap_Zidongzhandou:SetProperty("HoverImage","set:Logon01 image:ZiDongZhanDOU_LvLiang")
		local keystr = ScriptGlobal_Format("#{ZDZD_200724_04}",SystemSetup:GetAcceFullTip(54 + 10))
		MiniMap_Zidongzhandou:SetToolTip("#{ZDZD_200724_03}".."#r"..keystr)
	else
		MiniMap_Zidongzhandou:SetProperty("NormalImage","set:Logon01 image:ZiDongZhanDOU_Nomal")
		MiniMap_Zidongzhandou:SetProperty("HoverImage","set:Logon01 image:ZiDongZhanDOU_Lv")
		local keystr = ScriptGlobal_Format("#{ZDZD_200724_02}",SystemSetup:GetAcceFullTip(54 + 10))
		MiniMap_Zidongzhandou:SetToolTip("#{ZDZD_200724_01}".."#r"..keystr)
	end
	
end

function MiniMap_XinShouNewBtnClk()
	if(IsWindowShow("XinShouNew")) then
		CloseWindow("XinShouNew", true)
		return
	end
	--todo
	MiniMap_XinShouNew_tips:Hide()
	MiniMap_XinShouNewAnimate:Hide();
--	MiniMap_Xinfu:PlayWarning( 0 );
--	MiniMap_XinShouNew:PlayWarning( 0 );
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenXinShouNewWindow" ); 		-- ???
		Set_XSCRIPT_ScriptID( 892679 );						-- ????
		Set_XSCRIPT_ParamCount( 0 );						-- ????
	Send_XSCRIPT()
end

function MiniMap_LandRewardBtnClk()
	if(IsWindowShow("LandReward")) then
		CloseWindow("LandReward", true)
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenPrizeUI" ); 		-- ???
		Set_XSCRIPT_ScriptID( 892678 );						-- ????
		Set_XSCRIPT_ParamCount( 0 );						-- ????
	Send_XSCRIPT()
end

function MiniMap_PetSoulAwards_Clicked()
	if(IsWindowShow("PetSoul_FengHunLu")) then
		CloseWindow("PetSoul_FengHunLu", true)
		return
	end

	--	MiniMap_FeelFeedBack200_tips:Hide()
	--	MiniMap_FeelFeedBack200_Animate:Hide();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "AskOpenMainUI" ); 	
		Set_XSCRIPT_ScriptID( 791010 );						-- ????
		Set_XSCRIPT_ParamCount( 0 );						-- ????
	Send_XSCRIPT()
end

function MiniMap_FeelFeedBack500BtnClk()
	if(IsWindowShow("ChunJieQianDao")) then
		CloseWindow("ChunJieQianDao", true)
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenUI" ); 	
		Set_XSCRIPT_ScriptID( 892975 );						-- ????
		Set_XSCRIPT_Parameter( 0, 0 )
		Set_XSCRIPT_ParamCount( 1 );						-- ????
	Send_XSCRIPT()
end

function MiniMap_FeelFeedBack800BtnClk()
	if(IsWindowShow("FeelFeedBack800")) then
		CloseWindow("FeelFeedBack800", true)
		return
	end
	--2023ÖÜ»îÔ¾½±Àø·Å³ö by ypl
	if(IsWindowShow("ZhouHuoYue_Award")) then
		CloseWindow("ZhouHuoYue_Award", true)
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnOpenMainWindow" ); 	
		Set_XSCRIPT_ScriptID( 792012 );						-- ????
		Set_XSCRIPT_ParamCount( 0 );						-- ????
	Send_XSCRIPT()
end

function MiniMap_ThreeDayFeedBackBtnClk()
	if(IsWindowShow("ThreeDayFeedBack")) then
		CloseWindow("ThreeDayFeedBack", true)
		return
	end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "UpdateInterface" )
		Set_XSCRIPT_ScriptID( 889986 )
		Set_XSCRIPT_Parameter( 0, 1 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
function MiniMap_UpdateHeXinChun()

	--²»ÏÔÊ¾
	if g_ZhanJiangHu_ShowButton ~= 1 then
		MiniMap_HeXinChun : Hide()
		return
	end
	
	--ÏÔÊ¾
	MiniMap_HeXinChun : Show()

	--°´Å¥tips
	local curDay = tonumber(DataPool:GetServerDayTime());
	if(curDay >= 20210211 and curDay <= 20210218) then
		MiniMap_HeXinChun:SetToolTip("#{CJYJ_180104_07}")
	elseif(curDay >= 20210219 and curDay <= 20210226) then
		MiniMap_HeXinChun:SetToolTip("#{CJYJ_180104_10}")
	end
	
	--Ð¡ºìµã
	local bShowTip = 0
	for i=1,table.getn(g_ZhanJiangHu_FlexTipState) do
		if(g_ZhanJiangHu_FlexTipState[i] == 1) then
			bShowTip = 1
		end
	end
	if bShowTip==1 then
		MiniMap_HeXinChun_tips:Show()
		MiniMap_HeXinChunAnimate:Show()
		MiniMap_HeXinChunAnimate:Play(true)
	else
		MiniMap_HeXinChun_tips:Hide()
		MiniMap_HeXinChunAnimate:Hide()
	end

end

-- ÒÆÖ²-ÐÂ´ºÇ©µ½»î¶¯-Ìììû´º»ª ½½­ºþ
function MiniMap_HeXinChunBtnClk()

	local curDay = tonumber(DataPool:GetServerDayTime());
	local nLevel = Player:GetData("LEVEL")
	if nLevel < 30 then
		PushDebugMessage("#{CJYJ_180104_09}")
		return
	end
	if(curDay >= 20210211 and curDay <= 20210218) then
		PushEvent("OPEN_HEXINCHUN",1,-1,-1)
		return
	end
	if(curDay >= 20210219 and curDay <= 20210226) then
		PushEvent("OPEN_ZHANJIANGHU",1,-1,-1)
		return
	end
	
	PushDebugMessage("#{CJYJ_180104_08}")

end

function MiniMap_ZLHeroMeetingBtnClk()
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name( "YXZ_Open" ); 	
	Set_XSCRIPT_ScriptID( 891119 );						-- ????
	Set_XSCRIPT_ParamCount( 0 );						-- ????
	Send_XSCRIPT()
end

--//2021¾çÇéÈÎÎñ-ypl
function MiniMap_ZLLetterEnter_Clicked()

	local open = 0

	if(IsWindowShow("ZLLetter_Guide")) then
		CloseWindow("ZLLetter_Guide", true)
		open = 1
	end

	if(IsWindowShow("ZLHeroicPosts")) then
		CloseWindow("ZLHeroicPosts", true)
		open = 1
	end	
	
	if(IsWindowShow("ZLMysteriousLetter1")) then
		CloseWindow("ZLMysteriousLetter1", true)
		open = 1
	end	

	if(IsWindowShow("ZLSecretLetter")) then
		CloseWindow("ZLSecretLetter", true)
		open = 1
	end	

	if(IsWindowShow("ZLMysteriousLetter2")) then
		CloseWindow("ZLMysteriousLetter2", true)
		open = 1
	end		
	
	if open == 1 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUI")
		Set_XSCRIPT_ScriptID(891080)
		Set_XSCRIPT_Parameter( 0, 6 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
	
	if g_2021_JuQing_RedPoint ~= 1 then
		MiniMap_ZLLetterEnter_tips:Hide()
		MiniMap_ZLLetterEnter_Animate:Hide();
	end
end

--Ìì¸³Òýµ¼ÈÎÎñ-2021 by yuanpeilong
function MiniMap_TalentGuideLetter_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("UILogic")
		Set_XSCRIPT_ScriptID(891218)
		Set_XSCRIPT_Parameter( 0, 1 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
end

--//2022ÊÞ»êÒýµ¼ÈÎÎñ-ypl
function MiniMap_ShouHunLetter_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenUI")
		Set_XSCRIPT_ScriptID(893040)
		Set_XSCRIPT_Parameter( 0, 1 )
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()	
end

function MiniMap_XiuChang()

	OpenXiuChang()
end;

function MiniMap_AlaDingBtn()
	Lua_ShowAladdin();
	Lua_ShowEntryEvent();
end	

function MiniMap_AlaDingBtnCheck()
	if Lua_ShowEntry()==1 then
		MiniMap_AlaDing:Show()
	else
		MiniMap_AlaDing:Hide()
	end
end	
function MiniMap_UpdateChunJieQianDao(showBtn,showTips)
	if showBtn == 1 then
		MiniMap_FeelFeedBack500:Show()
	else
		MiniMap_FeelFeedBack500:Hide()
	end
	if showTips == 1 then
		MiniMap_FeelFeedBack500_tips:Show()
	else
		MiniMap_FeelFeedBack500_tips:Hide()
	end
end

-- 2022 äÊÞÔ¤ÈÈ»î¶¯
function MiniMap_ZhenShouYuReBtnClk()

	if(IsWindowShow("ZhenShou_YuRe")) then
		CloseWindow("ZhenShou_YuRe", true)
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnOpenYuRe")
		Set_XSCRIPT_ScriptID(893069)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()

end

function MiniMap_GSChatClk()
	OpenGSChitChat()
	--ÉÁË¸Òþ²Ø
	MiniMap_GSChat_Flash:Hide()
end

function MiniMap_ThemeShopBtnClk() 
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAskOpenShop")
		Set_XSCRIPT_ScriptID( 998387 ) 
		Set_XSCRIPT_ParamCount( 0 ); 
	Send_XSCRIPT() 
end

function MiniMap_Dahua_BtnClk() 
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OpenChouJiang")
		Set_XSCRIPT_ScriptID( 889912 ) 
		Set_XSCRIPT_ParamCount( 0 ); 
	Send_XSCRIPT() 
end

--·ÖÏß ¸Ä ÍòÄÜ´«ËÍ @XueWu
function MiniMap_FenxianClicked()
	--DataPool:OpenFenxianDlg()
	--MiniMap_FenxianFlashUpdata(false)
	
	-- PushDebugMessage("¿ì½Ý´«ËÍ¹¦ÄÜÔÝÎ´¿ª·Å")
	local curSceneID = GetSceneID();
	if curSceneID > 2 then
		PushDebugMessage( "VÕn nång truy«n t¯ng chï có th¬ TÕi Chü bên trong thành sØ døng!" )
		return
	end
	PushEvent("OPEN_CHUANSONG_SYSTEM");
end
