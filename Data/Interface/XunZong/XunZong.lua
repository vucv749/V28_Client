
--===============================================
-- OnLoad()
--===============================================
function XunZong_PreLoad()

	this:RegisterEvent("TOGLE_XUN_ZONG");
	this:RegisterEvent("UPDATE_XUN_ZONG");
end

function XunZong_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function XunZong_OnEvent( event )
	
	if ( event == "TOGLE_XUN_ZONG" ) then	
		XunZong_Show( -1, -1 );
	elseif( event == "UPDATE_XUN_ZONG" ) then
		XunZong_Update( arg0, arg1 );
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function XunZong_Update( nResult, nIndex )
	
	if( tonumber(nResult) == 0 ) then
		XunZong_Explain:Show();
		XunZong_Agname:Show();
		XunZong_Locus:Show();
		XunZong_fettle:Show();
		XunZong_TeamInfo:Show()
		local strFaceImage = DataPool:GetLookUpPartInfo( "PORTRAIT" );
		XunZong_PlayerHead:SetProperty("Image", tostring(strFaceImage));
		XunZong_ID:SetText( "ID:"..tostring( DataPool:GetLookUpPartInfo( "ID_TEXT" ) ) );
		XunZong_Name:SetText( "Tên: "..DataPool:GetLookUpPartInfo("NAME"  ) );
		XunZong_Level:SetText( "C¤p: "..tostring( DataPool:GetLookUpPartInfo( "LEVEL" ) ) );
		XunZong_MenPai:SetText( "Phái: "..DataPool:GetLookUpPartInfo( "MENPAI_TEXT" ) );
		XunZong_Confraternity:SetText( "Bang: "..DataPool:GetLookUpPartInfo(  "GUID_NAME" ) );
		XunZong_GuildLeague:SetText( "#{TM_20080311_30}"..DataPool:GetLookUpPartInfo("GUILD_LEAGUE_NAME") );
		XunZong_Explain:SetText( "T.TrÕng: "..DataPool:GetLookUpPartInfo(  "MOOD" ) );
		XunZong_Agname:SetText( "D.Hi®u: "..DataPool:GetLookUpPartInfo( "TITLE" ) );
		XunZong_Locus:SetText( "V¸ trí: "..DataPool:GetLookUpPartInfo( "POS" ) );
		--DataPool:GetLookUpPartInfo( "POS" );
		XunZong_fettle:SetText( "TrÕng thái: "..DataPool:GetLookUpPartInfo( "STATE" ) );
		XunZong_TeamInfo:SetText( "Ðµi: "..DataPool:GetLookUpPartInfo( "TEAM_NUMBER" ) );
		this:Show();
	else
		XunZong_OnHide();
		--PushDebugMessage(tostring(nResult));
	end
end

function XunZong_Show( arg_0, arg_1 )
	XunZong_PlayerHead:SetProperty("Image", "");
	XunZong_ID:SetText( "ID:");
	XunZong_Name:SetText( "Tên: " );
	XunZong_Level:SetText( "C¤p: " );
	XunZong_MenPai:SetText( "Phái: ");
		--XunZong_Confraternity:SetText( "°ï»áÃû³Æ:");
	XunZong_Confraternity:SetText( "#RÐang tìm, xin hãy ðþi ..." );
	XunZong_GuildLeague:SetText( "#{TM_20080311_30}");
		--XunZong_Explain:SetText( "ÐÄÇé:" );
	XunZong_Explain:Hide();
		--XunZong_Agname:SetText( "³ÆºÅ:" );
	XunZong_Agname:Hide();
		--XunZong_Locus:SetText( "Î»ÖÃ:" );
	XunZong_Locus:Hide();
		--XunZong_fettle:SetText( "×´Ì¬:");
	XunZong_fettle:Hide();
		--XunZong_TeamInfo:SetText( "¶ÓÎé:" );
	XunZong_TeamInfo:Hide();
	
	this : Show();
end

function XunZong_OnHide()
	this:Hide();
end

function XunZong_AddFriend()
	local szName = DataPool:GetLookUpPartInfo("NAME")
	if nil ~= szName and "" ~= szName then
		DataPool:AddFriendAndGrouping(szName)
	end
end

function XunZong_SetPrivateName()
	local szName = DataPool:GetLookUpPartInfo("NAME");
	if(nil ~= szName and "" ~= szName) then
		Talk:ContexMenuTalk(szName);
	end
end

function XunZong_ShengQingTeam()
	local szName = DataPool:GetLookUpPartInfo("NAME");
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamApply(szName);
	end
end


function XunZong_YaoQingTeam()
	local szName = DataPool:GetLookUpPartInfo("NAME");
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamRequest(szName);
	end
end







