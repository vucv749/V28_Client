
local FlashPoint = 1/5;
local PlayerHP = 0;
local PlayerMaxHP = 0;

local PlayerMP = 0;
local PlayerMaxMP = 0;

local PlayerRage = 0;
local PlayerMaxRage = 100;

local iMouseInPos = 0;	-- 0 :???
												-- 1 : ÔÚÑªÌõ´¦
												-- 2 : ÔÚ·¨Á¦Ìõ´¦
                        -- 3 : ÔÚÅ­ÆøÌõ´¦
local DoubleHit = {}
local EngHit = {}

--local PetFlashTime = 10*1000			-- äÊÞ°´Å¥ÉÁË¸Ê±¼ä10ÃëÖÓ£¬µ¥Î»ÊÇºÁÃë£¬ËùÒÔ³ËÒÔ1000×ª»»ÎªÃë
local HuoDongTime  = 30*1000      --????????30??


local LEVEL_LIMIT = 10;						--10???????

--OnLoad

function PlayerFrame_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME");
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_HP_PERCENT");
	this:RegisterEvent("UNIT_MP_PERCENT");
	this:RegisterEvent("UNIT_RAGE");			-- ????
	
	this:RegisterEvent("UNIT_MAX_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_MAX_MP");
	
	this:RegisterEvent("UNIT_STRIKEPOINT");
	this:RegisterEvent("UNIT_FACE_IMAGE");

	this:RegisterEvent("TEAM_REFRESH_MEMBER");
	this:RegisterEvent("TEAM_NOTIFY_APPLY");
	--this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("FLAH_MINIMAP");
	
	this:RegisterEvent("STOP_FLAH_MINIMAP");
	this:RegisterEvent("UPDATE_BTN_FLASH");	--zchw
	this:RegisterEvent("SHOW_UPDATE_UI");	--zchw
	
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UNIT_ENGPOINT");

	this:RegisterEvent("RAID_UPDATE_RAID_ICON",false);

		
end

function PlayerFrame_OnLoad()
	DoubleHit[1] = PlayerFrame_DoubleHit1;
	DoubleHit[2] = PlayerFrame_DoubleHit2;
	DoubleHit[3] = PlayerFrame_DoubleHit3;
	DoubleHit[4] = PlayerFrame_DoubleHit4;
	DoubleHit[5] = PlayerFrame_DoubleHit5;
	DoubleHit[6] = PlayerFrame_DoubleHit6;
	DoubleHit[7] = PlayerFrame_DoubleHit7;
	DoubleHit[8] = PlayerFrame_DoubleHit8;
	DoubleHit[9] = PlayerFrame_DoubleHit9;
	EngHit[1] = PlayerFrame_ManTuoHit1;
	EngHit[2] = PlayerFrame_ManTuoHit2;
	EngHit[3] = PlayerFrame_ManTuoHit3;
	EngHit[4] = PlayerFrame_ManTuoHit4;
	EngHit[5] = PlayerFrame_ManTuoHit5;
	EngHit[6] = PlayerFrame_ManTuoHit6;
	EngHit[7] = PlayerFrame_ManTuoHit7;
	PlayerFrame_Captain:Hide();
	--PlayerFrame_ZhengShouZhenYouFlash:Hide();
	--PlayerFrame_UpdateBtnFlash:Hide();
	--Ó¦¸Ã²ß»®Ð´µ½×ÖµäºÍxml²¼¾ÖÎÄ¼þÀï PlayerFrame_ZhenShouZhengYou:SetToolTip("´ò¿ª ÷ÓÑ½»»¥½çÃæ");
	--PlayerFrame_ZhenShouZhengYou:SetToolTip("#{ZYPT_081103_001}");
	
end

function PlayerFrame_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
	
	
		----AxTrace( 0,0, "enter word!");
		this:Show();
		
		--PlayerFrame_HP_Text:SetClippedByParent(0);
		--PlayerFrame_MP_Text:SetClippedByParent(0);
		--PlayerFrame_SP_Text:SetClippedByParent(0);
		
		PlayerFrame_Update();
		-- ¸üÐÂÍ·ÏñÐÅÏ¢.
		
		--AxTrace( 0,0, "enter word!");
		--AxTrace( 0,0, "¸üÐÂÍ·Ïñ");
		PlayerFrame_Update_Image();
		return;
	end

	--AxTrace( 0,0, tostring(event));
	if( (event == "UNIT_NAME") and (arg0 == "player")) then
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MAX_MP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MAX_MP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MAX_HP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MAX_HP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_HP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_HP");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_MANA") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MANA");
		PlayerFrame_Update();
		return;
	end
	
	if( (event == "UNIT_MP_PERCENT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_MP_PERCENT");
		PlayerFrame_Update();
		return;
	end
	
	if( (event == "UNIT_RAGE") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_RAGE");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_HP_PERCENT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_HP_PERCENT");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_STRIKEPOINT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_STRIKEPOINT");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_ENGPOINT") and (arg0 == "player") ) then

		----AxTrace( 0,0, "UNIT_STRIKEPOINT");
		PlayerFrame_Update();
		return;
	end

	--AxTrace( 0,0, "¿ªÊ¼µÃµ½Í·Ïñ");
	-- Í·ÏñÐÅÏ¢¸Ä±ä
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
	
		--AxTrace( 0,0, "UNIT_FACE_IMAGE");
		PlayerFrame_Update_Image();
		return;
	end

	if( event == "TEAM_REFRESH_MEMBER" ) then
		if( tonumber( Player:IsLeader() ) == 1 ) then
			PlayerFrame_Captain:SetProperty("Image", "set:UIIcons image:LeaderOpening")
			PlayerFrame_Captain:Show();
		else
			PlayerFrame_Captain:Hide();
		end
		PlayerFrame_Update();
	end
	if( event == "TEAM_NOTIFY_APPLY" ) then
		if( tonumber( Player:IsLeader() ) == 1 ) then
			PlayerFrame_Captain:SetProperty("Image", "set:UIIcons image:LeaderOpening")
			PlayerFrame_Captain:Show();
		else
			PlayerFrame_Captain:Hide();
		end
		PlayerFrame_Update();
	end
	--if( event == "UPDATE_PETINVITEFRIEND" ) then
	--	if( arg0 == "notifynew" ) then
	--		PlayerFrame_Flash_PetFriend(0);
	--		SetTimer( "PlayerFrame", "PlayerFrame_Flash_PetFriend(1)",PetFlashTime);
	--	end
	--end
	
	if (event == "UPDATE_BTN_FLASH") then
		--PlayerFrame_UpdateBtnFlash:Show();		
	end
	
	if (event == "SHOW_UPDATE_UI") then
		--Helper:GotoRecUpdate();
	end
	
	if( event == "UI_COMMAND" and tonumber(arg0) == 89266602 ) then
		PlayerFrame_YueKaBtn:Show()
		PlayerFrame_UpdateButtonLayout()
	end
	
	if( event == "UI_COMMAND" and tonumber(arg0) == 89266603 ) then
		PlayerFrame_YueKaBtn:Hide()
		PlayerFrame_UpdateButtonLayout()
	end
	if (event == "RAID_UPDATE_RAID_ICON") then
		--ÏÔÊ¾ÍÅ¶ÓºÍÖúÀíÍ¼±ê
		if Player:IsRaidLeader() == 1 then
			PlayerFrame_Captain:SetProperty("Image", "set:Union1 image:Union_LeaderIcon_S")
			PlayerFrame_Captain:Show()
		elseif Player:IsRaidAssitant() == 1 then
			PlayerFrame_Captain:SetProperty("Image", "set:Union1 image:Union_MemberIcon_S")
			PlayerFrame_Captain:Show()
		else
			PlayerFrame_Captain:Hide()
		end
	end
end

function PlayerFrame_UpdateBtnOnClicked()
	-- PlayerFrame_UpdateBtnFlash:Hide();
	-- Player:ClearUpdateBtnFlashFlag();
	-- Helper:GotoRecUpdate();		
end

function PlayerFrame_Flash_PetFriend( who )
	--who == 0 ¿ªÊ¼ÉÁË¸ £¬·ñÔòÍ£Ö¹ÉÁË¸
	--if( who == 0 ) then
	--	PlayerFrame_ZhengShouZhenYouFlash:Show();
	--else
	--	PlayerFrame_ZhengShouZhenYouFlash:Hide();
	--	KillTimer("PlayerFrame_Flash_PetFriend(1)");
	--end
end

function PlayerFrame_Update()

	--AxTrace( 0,0, "1");
	
	PlayerHP= Player:GetData( "HP" );
	PlayerMaxHP = Player:GetData("MAXHP");
	if(0 == PlayerMaxHP) then
	
		PlayerMaxHP = 1;
	end;
	PlayerFrame_HP:SetProgress(PlayerHP, PlayerMaxHP);
	if( PlayerHP / PlayerMaxHP > FlashPoint ) then
		PlayerFrame_Mask:Hide();
		PlayerFrame_HP_Flash:Play( false );
	else
		local Width ,Height= PlayerFrame_HP:GetWindowSize();
		Width =Width * PlayerHP / PlayerMaxHP;
		PlayerFrame_HP_Flash:SetWindowSize(Width,Height)
		PlayerFrame_HP_Flash:Play( true );
		PlayerFrame_Mask:Show();
	end

	PlayerMP = Player:GetData( "MP" );
	PlayerMaxMP = Player:GetData("MAXMP");
	if(0 == PlayerMaxMP) then
	
		PlayerMaxMP = 1;
	end;	
	PlayerFrame_MP:SetProgress(PlayerMP, PlayerMaxMP);
	
	--AxTrace( 0,0, "ÏÔÊ¾Å­Æø"..tostring(PlayerRage));
	-- ÏÔÊ¾Å­Æø
	PlayerRage = Player:GetData( "RAGE" );
  PlayerMaxRage = Player:GetData( "MAXRAGE" );
  if(0 == PlayerMaxRage) then
  
  	PlayerMaxRage = 1;
  end;
 	PlayerFrame_SP:SetProgress(PlayerRage, PlayerMaxRage);
	
	--AxTrace( 0,0, "4");
	-- ÏÔÊ¾Ãû×Ö
	local strName = Player:GetName();
	
	strName = "#cDED784"..strName;
	PlayerFrame_Name:SetText( strName );
	
	--AxTrace( 0,0, "5");
	local EngPoint = 0;
	local StrikePoint = 0;
	local pMenpai = Player:GetData("MEMPAI");

	if 10 == pMenpai then
		EngPoint = Player:GetData("ENGPOINT");
	elseif 2 == pMenpai then
		StrikePoint = Player:GetData("STRIKEPOINT");
	end
	
--	----AxTrace(0,1,"StrikePoint="..StrikePoint);
	
	--AxTrace( 0,0, "6");
	for	i=1, 9 do
		if i <= StrikePoint then
--			DoubleHit[i] : SetImageColor("FF00FF00");	
			DoubleHit[i] : Show();
		else
--			DoubleHit[i] : SetImageColor("FFFFFFFF");	
			DoubleHit[i] : Hide();
		end
	end
	
	for	i=1, 7 do
		if i <= EngPoint and pMenpai == 10 then
--			DoubleHit[i] : SetImageColor("FF00FF00");
			EngHit[i] : Show();
        else
--			DoubleHit[i] : SetImageColor("FFFFFFFF");
			EngHit[i] : Hide();
		end
	end

	--AxTrace( 0,0, "7");
	--ÏÔÊ¾µÈ¼¶
	local nNumber = Player:GetData( "LEVEL" );
	PlayerFrame_Level:SetText("#cDED784"..tostring(nNumber));
	
	
	
end

--ÓÃ»§µ¥»÷ÁË ÷ÓÑÆ½Ì¨µÄ°´Å¥ modified by dun.liu
function PlayerFrame_HitZhengShou()

	--if DataPool:Lua_IsInTServer() == 1 then
	--	PushDebugMessage("#{HSLJ_190919_268}")
	--	return
	--end

	--local level = Player:GetData("LEVEL");
	--if level < LEVEL_LIMIT then
	--	PushDebugMessage("#{ZYPT_081103_002}");
	--	return;
	--end
	--OpenWindow("ZhengyouWindow")
	--RequestServerNoteLog(0);      --Ïòserver·¢ËÍÇëÇó£¬¼ÇÂ¼Ò»ÌõÈ Ö¾
end

function PlayerFrame_ShouJiOnClicked()
	AskMobiePhoneStatus(1);
end

function PlayerFrame_HP_Text_MouseEnter()
	PlayerFrame_HP_Text:SetText( tostring( PlayerHP ) .. "/" .. tostring( PlayerMaxHP) );
	iMouseInPos = 1;
end

function PlayerFrame_HP_Text_MouseLeave()
	PlayerFrame_HP_Text:SetText("");
	iMouseInPos = 0;
end

function PlayerFrame_MP_Text_MouseEnter()
	
	PlayerFrame_MP_Text:SetText( tostring( PlayerMP ) .. "/" .. tostring( PlayerMaxMP) );
	iMouseInPos = 2;
end

function PlayerFrame_MP_Text_MouseLeave()
	PlayerFrame_MP_Text:SetText("");
	iMouseInPos = 0;
end


function PlayerFrame_SP_Text_MouseEnter()
	PlayerFrame_SP_Text:SetText( tostring( PlayerRage ) .. "/" .. tostring( 1000) );
	iMouseInPos = 3;
end

function PlayerFrame_SP_Text_MouseLeave()
	PlayerFrame_SP_Text:SetText("");
	iMouseInPos = 0;
end


function PlayerFrame_Update_Image()

	local strFaceImage = Player:GetData( "PORTRAIT" );
	
	--AxTrace( 0,0, "Í·ÏñÐÅÏ¢!" .. tostring(strFaceImage));
	-- ÉèÖÃÍ·ÏñÐÅÏ¢
	PlayerFrame_Icon:SetProperty("Image", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("NormalImage", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("HoverImage", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("PushedImage", tostring(strFaceImage));
end

-- ÓÒ¼ü²Ëµ¥
function PlayerFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Player ÓÒ¼ü²Ëµ¥!");
	--OpenTargetMenu();
	Player:ShowMySelfContexMenu();
end

-- ×ó¼üÑ¡ÖÐ×Ô¼º
function PlayerFrame_SelectMyselfAsTarget()
	Player:SelectMyselfAsTarget();
	
end
function PlayerFrame_ShowTooltip( type )
	local strTooltip = "Sinh lñc:"..tostring( PlayerHP ) .. "/" .. tostring( PlayerMaxHP).."#r".."Khí: "..tostring( PlayerMP ) .. "/" .. tostring( PlayerMaxMP).."#r".."Nµ: "..tostring( PlayerRage ) .. "/" .. tostring( 1000);
	if( type == 1 )	then
		PlayerFrame_HP:SetToolTip( strTooltip );
	elseif( type == 2 ) then
		PlayerFrame_MP:SetToolTip( strTooltip );
	else
		PlayerFrame_SP:SetToolTip( strTooltip );
	end

end

function PlayerFrame_HideTooltip()
	
end

function PlayerFrame_YueKaBtnOnClicked()
	local isInHell = IsInHell()
	if isInHell == 1 then--??????????
		PushDebugMessage("#{HJYK_201223_46}")
    	return
	end
	
	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OnClickOpenBtn")
	Set_XSCRIPT_ScriptID(892666) 
	Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function PlayerFrame_UpdateButtonLayout()
	if PlayerFrame_YueKaBtn:IsVisible() then
		PlayerFrame_ShouJiBtn:SetProperty("UnifiedPosition", "{{0.000000,30.000000},{0.000000,66.000000}}")
		PlayerFrame_RedenvelopeBtn:SetProperty("UnifiedPosition", "{{0.000000,60.000000},{0.000000,66.000000}}")
		--ÁÙÊ±ÆÁ±Î
		PlayerFrame_RedenvelopeBtn:Hide()
	else
		PlayerFrame_ShouJiBtn:SetProperty("UnifiedPosition", "{{0.000000,0.000000},{0.000000,66.000000}}")
		PlayerFrame_RedenvelopeBtn:SetProperty("UnifiedPosition", "{{0.000000,30.000000},{0.000000,66.000000}}")
		--ÁÙÊ±ÆÁ±Î
		PlayerFrame_RedenvelopeBtn:Hide()
	end
end

function PlayerFrame_RedenvelopeClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SendRedEnvelopeUI")
		Set_XSCRIPT_ScriptID(890253)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

--ÄÚ²¿¹¤¾ß
function PlayerFrame_GMToolsFunc()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameMasterControl_ServerCallOne")
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_Parameter(0,76)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end
