local strMenPaiName =
{
	"Thiªu Lâm",
	"Minh Giáo",
	"Cái Bang",
	"Võ Ðang",
	"Nga Mi",
	"Tinh Túc",
	"Thiên Long",
	"Thiên S½n",
	"Tiêu Dao",
	"Tân thü",
	"Mµ Dung",
	"ÐÕi T¯ng",
	"ÐÕi T¯ng",
	"ÐÕi T¯ng",
	"ÐÕi Liêu",
	"ÐÕi Liêu",
	"ÐÕi Lý",
	"Tây HÕ",
	"Phiên Bang",
	"Mãng Cái",
	"Di Dân",
	"Lang Nhân",
	"BÕch Miêu",
	"H¡c Miêu",
	"Tu La",
	"VÕn Næ",
	"VÕn Nam",
	"NgÕc Th¥n",
	"Dã thú",
	"Løc Lâm",
	"Yêu ma",
	"Rß½ng",
	"Rß½ng",
};

local g_NowWDBossHp = 1

function TargetFrame_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_RELATIVE");
	this:RegisterEvent("MAINTARGET_OPEN")
	this:RegisterEvent("CHANGE_DIYFRAME")
	this:RegisterEvent("UI_COMMAND",true)
end

function TargetFrame_OnLoad()

end

function TargetFrame_OnEvent(event)

--	local ct = Target:GetData("CHAR_TYPE");
	-- ÊÇ·ñÍæ¼ÒµÄ½ÇÉ«
--	if (ct == 0 or ct == 1) then
		-- ÊÇ·ñÓÐDIYÍ·Ïñ
--		local styleId;
--		if (Target:IsTargetTeamMember() ~= 0) then
--			styleId = Target:TargetFrame_Update_DIYFrame_Team();
--		else
--			styleId = Target:GetData("DIYFRAME");
--		end
--		if styleId > 0 then
--			this:Hide();
--			return;
--		end;
--	end;

	if ( event == "MAINTARGET_OPEN" ) then

		--AxTrace(0,0,"´ò¿ªmain target");
		if 1 == Target:IsTargetRaidMember() then
			TargetFrame_DataBack:Show()
			TargetFrame_DataBack2:Hide()
			TargetFrame_Update_Name_Raid()
			TargetFrame_Update_HP_Raid()
			TargetFrame_Update_MP_Raid()
			TargetFrame_Update_Rage_Raid()
			TargetFrame_Update_Level_Raid()
		else
			TargetFrame_DataBack:Show();
			TargetFrame_DataBack2:Hide();
			TargetFrame_Update_Name_Team();
			TargetFrame_Update_HP_Team();
			TargetFrame_Update_MP_Team();
			TargetFrame_Update_Rage_Team();
			TargetFrame_Update_Level_Team();
		end
		this:Show();
		return;
	end;

	if ( event == "MAINTARGET_CHANGED" ) then

		AxTrace(0,0,"id === "..tostring(arg0));
	  if(-1 == tonumber(arg0)) then

	  	this:Hide();
	  	return;
	  end;

		if( Target:IsPresent()) then
			this:Show();
			TargetFrame_Update_Name();
			TargetFrame_Update_HP();
			TargetFrame_Update_MP();
			TargetFrame_Update_Rage();
			TargetFrame_Update_Level();
		else

			if(Target:IsTargetTeamMember() ~= 0) then

				this:Show();
				TargetFrame_DataBack:Show();
				TargetFrame_DataBack2:Hide();
			else
				this:Hide();
			end;

		end
		return;
	end


	if event == "UI_COMMAND" and tonumber(arg0) == 890391001 then
		g_NowWDBossHp = Get_XParam_INT(0)
		if Target:IsPresent() then
			TargetFrame_Update_HP();
		end
		return
	end

	if( (event == "UNIT_MP") and Target:IsPresent()) then
		TargetFrame_Update_MP();
		return;
	end

	if( (event == "UNIT_HP") and Target:IsPresent()) then
		TargetFrame_Update_HP();
		return;
	end

	if( (event == "UNIT_RAGE") and Target:IsPresent()) then
		TargetFrame_Update_Rage();
		return;
	end

	if( (event == "UNIT_LEVEL") and Target:IsPresent()) then
		TargetFrame_Update_Level();
		return;
	end

	if( (event == "UNIT_RELATIVE") and Target:IsPresent()) then
		TargetFrame_Update_Name();
		return;
	end




	-------------------------------------------------------------------------------------------------
	--
	-- µ±targetÊÇ×Ô¼ºµÄÊ±ºòÎÞ·¨Ë¢ÐÂ¡£
	--

	--if( (event == "UNIT_MP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_MP();
	--	return;
	--end

	--if( (event == "UNIT_HP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_HP();
	--	return;
	--end

	--if( (event == "UNIT_RAGE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Rage();
	--	return;
	--end

	--if( (event == "UNIT_LEVEL") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Level();
	--	return;
	--end

	--if( (event == "UNIT_RELATIVE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Name();
	--	return;
	--end
end

function TargetFrame_Update_Name()
	local txtColor="#cFFFFFF";
--or Target:GetData("ISNPC") == 0
--ÒÔÇ°Íæ¼ÒÍ³Ò»ÏÔÊ¾Îª°×É«£¬¸ù¾ÝÈîÃ¶5ÔÂ27È ÎÄµµ¸ü¸Ä£¬Íæ¼ÒºÍNPC×ßÍ¬Ò»¹æÔò¡£
	if Target:GetData( "RELATIVE" ) == 2  then
		txtColor = "#W"
	else
		txtColor = "#R"
	end
	TargetFrame_NameBar : Show();
	local occupation = Target:GetData("OCCUPATION")

	AxTrace(0,1,"OCCUPATION="..occupation)
	if(occupation == -1) then
		TargetFrame_NameBar : SetImageColor("FF00FF00")
	elseif(occupation == 0) then
		TargetFrame_NameBar : SetImageColor("FFFFFFFF")
	elseif(occupation == 1) then
		TargetFrame_NameBar : SetImageColor("FFFF0000")
	end

	TargetFrame_Name:SetText( txtColor..Target:GetFullName());
	TargetFrame_Name:Show();
	AxTrace( 8,0,txtColor..Target:GetFullName() );
	local szIcon = Target : GetData("PORTRAIT");
	TargetFrame_Icon:SetProperty("Image", szIcon);
--Ìí¼ÓÅÐ¶ÏÄ¿±êÊôÐÔµÄÉè¼Æ
	--¡°³è¡±¡°ÈË¡±¡°¿þ¡±¡°ÊÞ¡±¡°Ã§¡±¡°ÐÞ¡±¡°Ñý¡±
	local nNpcType = Target:GetData( "TYPE" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName"..tostring( nNpcType ) );

	--1.ÓÑºÃ
	--2.ÖÐÁ¢
	--3. äÊÞ
	--4.Æ Í¨µÐÈË
	--5.¾«Ó¢µÐÈË
	--6.µÐ·½boss
	local nNpcRelation = Target:GetData( "RELATION" );
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame"..tostring( nNpcRelation ) );

	--¸úÐÂÃÅÅÉ
	local nNpcReputation = Target:GetData( "MEMPAI" );
	if( nNpcReputation == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		--×¢Òâ£º âÀïÊÇºÜÎÞÄÎµÄÌØÐ´£¬¾ßÌåÊýÖµÇë²Î¿¼¿Í»§¶Ë´úÂëÖÐ
		--Client\Game\Interface\GMGameInterface_Script_Character.cpp
		--INT Character::GetData(LuaPlus::LuaState* state) º¯Êý
		local npcReputationImageIndex = nNpcReputation
		if npcReputationImageIndex == 10 then
			npcReputationImageIndex = 32
		elseif npcReputationImageIndex >= 11 and npcReputationImageIndex <= 32 then
			npcReputationImageIndex = npcReputationImageIndex - 1
		end
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( npcReputationImageIndex ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nNpcReputation + 1 ] );
	end

end

function TargetFrame_Update_HP()
	local nNpcRelation = Target:GetData( "RELATION" );
	local nRaceId = Target:GetData("RACE")

	if ( nRaceId == 52704 and GetSceneID() == 709) or ( nRaceId == 52706 and GetSceneID() == 711) then
		TargetFrame_DataBack:Hide();
		TargetFrame_DataBack2:Show();
		local hp = 1-(0.01*g_NowWDBossHp)
		TargetFrame_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrame_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrame_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );

	elseif( tonumber( nNpcRelation ) == 6 ) then
		TargetFrame_DataBack:Hide();
		TargetFrame_DataBack2:Show();
		local hp = Target:GetHPPercent();
		TargetFrame_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrame_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrame_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );
	else
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_HP:SetProgress(Target:GetHPPercent(), 1);
		TargetFrame_Update_Name();
	end
end

function TargetFrame_Update_MP()
	TargetFrame_MP:SetProgress(Target:GetMPPercent(), 1);
end

function TargetFrame_Update_Rage()
	TargetFrame_SP:SetProgress(Target:GetRagePercent(), 1);
end

function TargetFrame_Update_Level()

	local txtColor="#cFFFFFF";
	local level =  Target:GetData( "LEVEL" ) - Player:GetData( "LEVEL" );

	AxTrace( 0,0, "C¤p chênh l®ch"..tostring( level ) );
--¸ù¾ÝÈîÃ¶5ÔÂ27È ²ß»®ÎÄµµÐÞ¸Ä
--	if( level > 12 ) then
--		txtColor = "#R";
--	elseif( level > 4 ) then
--		txtColor = "#cff9000";
--		--ÒÔÇ°ÊÇc9ccf00£¬¸ù¾ÝÑîÒ«Ìá¹©µÄ.jpgÐÞ¸Ä
--	elseif( level > -4 ) then
--		txtColor="#Y";
--	elseif( level > -12 ) then
--		txtColor="#G"
--	else
--		txtColor="#c4b4b4b";
--¸ù¾ÝÑîÒ«¿ÚÊöÐÞ¸Ä
--		txtColor="#c240c0c";
--	end

--¸ù¾ÝÈîÃ¶5ÔÂ27È ²ß»®ÎÄµµÐÞ¸ÄÈçÏÂ
	if( level > 5 ) then
		txtColor = "#R";
	elseif( level > 2 ) then
		txtColor = "#cff9000";
		--ÒÔÇ°ÊÇc9ccf00£¬¸ù¾ÝÑîÒ«Ìá¹©µÄ.jpgÐÞ¸Ä
	elseif( level >= -2 ) then
		txtColor="#Y";
	elseif( level >= -5 ) then
		txtColor="#W"
	else
--		txtColor="#c4b4b4b";
--¸ù¾ÝÑîÒ«¿ÚÊöÐÞ¸Ä
		txtColor="#W";
	end



	if( tonumber( Target:GetData( "LEVEL" ) ) >= 200 ) then
		TargetFrame_LevelText:SetText(txtColor .."?");
	else
		TargetFrame_LevelText:SetText(txtColor .. tostring(Target:GetData( "LEVEL" )));
	end
	local checkHaveMaskBuff = Lua_CheckMainTargetHaveMaskBuff()
	if checkHaveMaskBuff == 1 then
		TargetFrame_LevelText:SetText(txtColor .."?");
	end
end

function TargetFrame_ArtLayout_Click()
	ShowContexMenu("other_player");
end

-- ÏÔÊ¾ÓÒ¼ü²Ëµ¥
function TargetFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Target ÓÒ¼ü²Ëµ¥!");
	OpenTargetMenu();
end


function	TargetFrame_Update_Name_Team()

	local strName = Target:TargetFrame_Update_Name_Team();
	local nMenpai = Target:TargetFrame_Update_Menpai_Team();
	TargetFrame_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Team();
	TargetFrame_Icon:SetProperty("Image", strIcon);
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame1" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName2" );
end;

function 	TargetFrame_Update_HP_Team()

	local TeamHP = Target:TargetFrame_Update_HP_Team();
	TargetFrame_HP:SetProgress(TeamHP, 1);
end;

function	TargetFrame_Update_MP_Team()

	local TeamMp = Target:TargetFrame_Update_MP_Team();
	TargetFrame_MP:SetProgress(TeamMp, 1);
end;

function	TargetFrame_Update_Rage_Team()

	local TeamRange = Target:TargetFrame_Update_Rage_Team();
	TargetFrame_SP:SetProgress(TeamRange, 1000);
end;

function	TargetFrame_Update_Level_Team()

	local TeamLevel = Target:TargetFrame_Update_Level_Team();
	TargetFrame_LevelText:SetText(tostring(TeamLevel));
end;

function        TargetFrame_Select_TargetOfTarget_Func()
         SelectTargetOfTarget();
end;

function TargetFrame_OnShow()
	PushEvent("SHOW_PHOENIXPLAINWAR_SCORE_S",2)
end

function	TargetFrame_Update_Name_Raid()
	local strName = Target:TargetFrame_Update_Name_Raid();
	local nMenpai = Target:TargetFrame_Update_Menpai_Raid();
	TargetFrame_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Raid();
	TargetFrame_Icon:SetProperty("Image", strIcon);
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame1" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName2" );
end;

function TargetFrame_Update_HP_Raid()

	local RaidHP = Target:TargetFrame_Update_HP_Raid();
	TargetFrame_HP:SetProgress(RaidHP, 1);
end;

function TargetFrame_Update_MP_Raid()

	local RaidMp = Target:TargetFrame_Update_MP_Raid();
	TargetFrame_MP:SetProgress(RaidMp, 1);
end;

function	TargetFrame_Update_Rage_Raid()

	local RaidRange = Target:TargetFrame_Update_Rage_Raid();
	TargetFrame_SP:SetProgress(RaidRange, 1000);
end;

function	TargetFrame_Update_Level_Raid()

	local RaidLevel = Target:TargetFrame_Update_Level_Raid();
	TargetFrame_LevelText:SetText(tostring(RaidLevel));
end;
