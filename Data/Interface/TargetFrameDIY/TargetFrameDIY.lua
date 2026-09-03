local g_nCurrentFrameID = -1;			--??UI???ID
local strPlayerMenPaiName ={
						"Thiªu Lâm",
						"Minh Giáo",	
						"Cái Bang",	
						"Võ Ðang",	
						"Nga Mi",	
						"Tinh Túc",	
						"Thiên Long",	
						"Thiên S½n",	
						"Tiêu dao",
						"Tân thü",
						"MÕn Ðà S½n Trang",};


function TargetFrameDIY_PreLoad()
--	this:RegisterEvent("MAINTARGET_CHANGED")
--	this:RegisterEvent("UNIT_HP");
--	this:RegisterEvent("UNIT_MP");
--	this:RegisterEvent("UNIT_RAGE");
--	this:RegisterEvent("UNIT_LEVEL");
--	this:RegisterEvent("UNIT_RELATIVE");
--	this:RegisterEvent("MAINTARGET_OPEN")
--	this:RegisterEvent("CHANGE_DIYFRAME")
end

function TargetFrameDIY_OnLoad()	
end

function TargetFrameDIY_OnEvent(event)
	
	local ct = Target:GetData("CHAR_TYPE");
	-- ²»ÊÇÍæ¼ÒµÄ½ÇÉ«
	if (ct ~= 0 and ct ~= 1) then
		this:Hide();
		return;
	end
	-- »ñÈ¡DIYÍ·ÏñµÄid
	local styleId;
	if (Target:IsTargetTeamMember() ~= 0) then
		styleId = Target:TargetFrame_Update_DIYFrame_Team();
	else
		styleId = Target:GetData("DIYFRAME");
	end
	if styleId <= 0 then
		this:Hide();
		return;
	end	
	
	-- ¶ÁÈ¡ËùÐèÊý¾Ý
	local FrameID, FrameName, ItemSerial, ItemCount, IconFile, CostMoney, Duration = DataPool : Get_DIYFrame_Item(styleId);
	if (FrameID ~= g_nCurrentFrameID) then 
		TargetFrameDIY_ReaggrangeFrame(FrameID);
		g_nCurrentFrameID = FrameID;
	end;			
		
	if ( event == "CHANGE_DIYFRAME" ) then
		TargetFrameDIY_Name:SetText( "#W"..Target:GetName() );
		TargetFrameDIY_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( Target:GetData("MEMPAI")) );
		TargetFrameDIY_LevelText:SetText( "#W"..tostring( Target:GetData("LEVEL")) );
		TargetFrameDIY_Icon:SetProperty("Image", Target:GetData("PORTRAIT"))
		this:Show();
		return;
	end
	
	if ( event == "MAINTARGET_OPEN" ) then	
		--AxTrace(0,0,"´ò¿ªmain target");
		TargetFrameDIY_DataBack:Show();
		TargetFrameDIY_Update_Name_Team();
		TargetFrameDIY_Update_HP_Team();
		TargetFrameDIY_Update_MP_Team();
		TargetFrameDIY_Update_Rage_Team();
		TargetFrameDIY_Update_Level_Team();
		this:Show();
		return;
	end
	
	if ( event == "MAINTARGET_CHANGED" ) then			
		AxTrace(0,0,"id === "..tostring(arg0));		  
		if(-1 == tonumber(arg0)) then
	  	  	this:Hide();
		  	return;
		end;
	  
		if( Target:IsPresent()) then
			this:Show();
			TargetFrameDIY_Update_Name();
			TargetFrameDIY_Update_HP();
			TargetFrameDIY_Update_MP();
			TargetFrameDIY_Update_Rage();
			TargetFrameDIY_Update_Level();
		else		
			if(Target:IsTargetTeamMember() ~= 0) then			
				this:Show();
				TargetFrameDIY_DataBack:Show();
			else
				this:Hide();
			end;				
		end
		return;
	end			
	
	if( event == "UNIT_MP" and Target:IsPresent()) then
		TargetFrameDIY_Update_MP();
		return;
	end

	if( event == "UNIT_HP" and Target:IsPresent()) then
		TargetFrameDIY_Update_HP();
		return;
	end

	if( event == "UNIT_RAGE" and Target:IsPresent()) then
		TargetFrameDIY_Update_Rage();
		return;
	end

	if( event == "UNIT_LEVEL" and Target:IsPresent()) then
		TargetFrameDIY_Update_Level();
		return;
	end

	if( event == "UNIT_RELATIVE" and Target:IsPresent()) then
		TargetFrameDIY_Update_Name();
		return;
	end	

end

function TargetFrameDIY_Update_Name()
	local txtColor="#cFFFFFF";
--or Target:GetData("ISNPC") == 0
--ÒÔÇ°Íæ¼ÒÍ³Ò»ÏÔÊ¾Îª°×É«£¬¸ù¾ÝÈîÃ¶5ÔÂ27È ÎÄµµ¸ü¸Ä£¬Íæ¼ÒºÍNPC×ßÍ¬Ò»¹æÔò¡£
	if Target:GetData( "RELATIVE" ) == 2  then 
		txtColor = "#W"
	else
		txtColor = "#R"
	end
	TargetFrameDIY_NameBar : Show();
	TargetFrameDIY_Name:SetText( txtColor..Target:GetName());
	TargetFrameDIY_Name:Show();
	AxTrace( 8,0,txtColor..Target:GetName() );
	local szIcon = Target : GetData("PORTRAIT");
	TargetFrameDIY_Icon:SetProperty("Image", szIcon);
		
	--¸úÐÂÃÅÅÉ
	local nNpcReputation = Target:GetData( "MEMPAI" );
	if( nNpcReputation == -1 ) then
		TargetFrameDIY_CampFrame:Hide();
	else
		TargetFrameDIY_CampFrame:Show();
		TargetFrameDIY_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nNpcReputation ) );
		TargetFrameDIY_CampFrame:SetToolTip( strPlayerMenPaiName[ nNpcReputation + 1 ] );
	end
	
end

function TargetFrameDIY_Update_HP()
	local nNpcRelation = Target:GetData( "RELATION" );
	if( tonumber( nNpcRelation ) == 6 ) then
		TargetFrameDIY_DataBack:Hide();
		local hp = Target:GetHPPercent();
		TargetFrameDIY_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrameDIY_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrameDIY_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );
	else
		TargetFrameDIY_DataBack:Show();
		TargetFrameDIY_HP:SetProgress(Target:GetHPPercent(), 1);
		TargetFrameDIY_Update_Name();
	end
end

function TargetFrameDIY_Update_MP()
	TargetFrameDIY_MP:SetProgress(Target:GetMPPercent(), 1);
end

function TargetFrameDIY_Update_Rage()
	TargetFrameDIY_SP:SetProgress(Target:GetRagePercent(), 1);
end

function TargetFrameDIY_Update_Level()

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
		TargetFrameDIY_LevelText:SetText(txtColor .."?");
	else
		TargetFrameDIY_LevelText:SetText(txtColor .. tostring(Target:GetData( "LEVEL" )));
	end
end

function TargetFrameDIY_ArtLayout_Click()
	ShowContexMenu("other_player");
end

-- ÏÔÊ¾ÓÒ¼ü²Ëµ¥
function TargetFrameDIY_Show_Menu_Func()

	--AxTrace( 0,0, "Target ÓÒ¼ü²Ëµ¥!");
	OpenTargetMenu();
end


function	TargetFrameDIY_Update_Name_Team()

	local strName = Target:TargetFrame_Update_Name_Team();
	local nMenpai = Target:TargetFrame_Update_Menpai_Team();
	TargetFrameDIY_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrameDIY_CampFrame:Hide();
	else
		TargetFrameDIY_CampFrame:Show();
		TargetFrameDIY_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrameDIY_CampFrame:SetToolTip( strPlayerMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Team();
	TargetFrameDIY_Icon:SetProperty("Image", strIcon);
end;

function 	TargetFrameDIY_Update_HP_Team()

	local TeamHP = Target:TargetFrame_Update_HP_Team();
	TargetFrameDIY_HP:SetProgress(TeamHP, 1);
end;
	
function	TargetFrameDIY_Update_MP_Team()
	
	local TeamMp = Target:TargetFrame_Update_MP_Team();
	TargetFrameDIY_MP:SetProgress(TeamMp, 1);
end;

function	TargetFrameDIY_Update_Rage_Team()

	local TeamRange = Target:TargetFrame_Update_Rage_Team();
	TargetFrameDIY_SP:SetProgress(TeamRange, 1000);
end;

function	TargetFrameDIY_Update_Level_Team()

	local TeamLevel = Target:TargetFrame_Update_Level_Team();
	TargetFrameDIY_LevelText:SetText(tostring(TeamLevel));
end;

function        TargetFrameDIY_Select_TargetOfTarget_Func()
         SelectTargetOfTarget();                
end;

function TargetFrameDIY_OnShow()
	PushEvent("SHOW_PHOENIXPLAINWAR_SCORE_S",2)
end

-- ÖØÖÃ½çÃæ
function TargetFrameDIY_ReaggrangeFrame(FrameID)
	
	--´ÓÅäÖÃ±í¶ÁÈ¡²¼¾Ö²ÎÊý	
	local MainFramePos, MainFrameSize, MainFrameImage, TopFramePos, TopFrameSize, TopFrameImage, CharIconPos, NameBarPos, NameBarSize, NameBarImage, CampFramePos, CampFrameSize, CampImageMap0, CampImageMap1, CampImageMap2, CampImageMap3, CampImageMap4, CampImageMap5, CampImageMap6, CampImageMap7, CampImageMap8, CampImageMap9, DataBackPos, DataBackSize, DataBackImage, DataFrontImage, DataOffset, DataHeight, LevelFramePos, LevelFrameSize, LevelFrameImage, XiezhuPos, XiezhuSize, XiezhuHoverImage, XiezhuNormalImage, XiezhuPushedImage, TypeIconPos, TypeIconSize, TypeIconImage, TypeFramePos, TypeFrameSize, TypeFrameImage = Target : GetDIYFrameLayout(FrameID);
	if (MainFramePos == nil or MainFramePos == "") then
		-- ÒâÍâÇé¿ö
		return;
	end;
	
	TargetFrameDIY2 : SetProperty("AbsolutePosition", MainFramePos);
	TargetFrameDIY2 : SetProperty("AbsoluteSize", MainFrameSize);
	TargetFrameDIY2 : SetProperty("Image", MainFrameImage);
	TargetFrameDIY_TopFrame : SetProperty("AbsolutePosition", TopFramePos);
	TargetFrameDIY_TopFrame : SetProperty("AbsoluteSize", TopFrameSize);
	TargetFrameDIY_TopFrame : SetProperty("Image", TopFrameImage);
	TargetFrameDIY_Icon : SetProperty("AbsolutePosition", CharIconPos);
	TargetFrameDIY_NameBar : SetProperty("AbsolutePosition", NameBarPos);
	TargetFrameDIY_NameBar : SetProperty("AbsoluteSize", NameBarSize);
	TargetFrameDIY_NameBar : SetProperty("Image", NameBarImage);
	TargetFrameDIY_CampFrame : SetProperty("AbsolutePosition", CampFramePos);
	TargetFrameDIY_CampFrame : SetProperty("AbsoluteSize", CampFrameSize);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap0);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap1);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap2);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap3);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap4);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap5);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap6);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap7);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap8);
	TargetFrameDIY_CampFrame : SetProperty("ChildImage", CampImageMap9);
	TargetFrameDIY_DataBack : SetProperty("AbsolutePosition", DataBackPos);
	TargetFrameDIY_DataBack : SetProperty("AbsoluteSize", DataBackSize);
	TargetFrameDIY_DataBack : SetProperty("Image", DataBackImage);
	TargetFrameDIY_DataFront : SetProperty("Image", DataFrontImage);
	TargetFrameDIY_LevelFrame : SetProperty("AbsolutePosition", LevelFramePos);
	TargetFrameDIY_LevelFrame : SetProperty("AbsoluteSize", LevelFrameSize);
	TargetFrameDIY_LevelFrame : SetProperty("Image", LevelFrameImage);
	TargetFrameDIY_Xiezhugongji_Icon : SetProperty("AbsolutePosition", XiezhuPos);
	TargetFrameDIY_Xiezhugongji_Icon : SetProperty("AbsoluteSize", XiezhuSize);
	TargetFrameDIY_Xiezhugongji_Icon : SetProperty("HoverImage", XiezhuHoverImage);
	TargetFrameDIY_Xiezhugongji_Icon : SetProperty("NormalImage", XiezhuNormalImage);
	TargetFrameDIY_Xiezhugongji_Icon : SetProperty("PushedImage", XiezhuPushedImage);
	TargetFrameDIY_TypeIcon : SetProperty("AbsolutePosition", TypeIconPos);
	TargetFrameDIY_TypeIcon : SetProperty("AbsoluteSize", TypeIconSize);
	TargetFrameDIY_TypeIcon : SetProperty("Image", TypeIconImage);
	TargetFrameDIY_TypeFrame : SetProperty("AbsolutePosition", TypeFramePos);
	TargetFrameDIY_TypeFrame : SetProperty("AbsoluteSize", TypeFrameSize);
	TargetFrameDIY_TypeFrame : SetProperty("Image", TypeFrameImage);
	--¼ÆËãÑªÆøÅ­ÌõÎ»ÖÃºÍ¸ß¶È
	TargetFrameDIY_HP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset) );
	TargetFrameDIY_HP : SetProperty("UnifiedSize", "{{1.000000,-2.000000},{0.000000,"..tostring(DataHeight).."}}");
	TargetFrameDIY_MP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset+DataHeight+1) );
	TargetFrameDIY_MP : SetProperty("UnifiedSize", "{{1.000000,-2.000000},{0.000000,"..tostring(DataHeight).."}}");
	TargetFrameDIY_SP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset+DataHeight*2+2) );
	TargetFrameDIY_SP : SetProperty("UnifiedSize", "{{1.000000,-2.000000},{0.000000,"..tostring(DataHeight).."}}");
end
