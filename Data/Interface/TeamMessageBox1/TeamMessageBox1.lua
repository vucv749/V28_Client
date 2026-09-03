g_InitiativeClose = 0;

local InviteIndex = 0;

local g_Frame = {};
local g_ShowText = {};

--===============================================
-- OnLoad()
--===============================================
function TeamMessageBox1_PreLoad()

	-- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ.
	this:RegisterEvent("TEAM_MEMBER_INVITE");

end

function TeamMessageBox1_OnLoad()

	-- ¶Ô»°¿ò
	g_Frame[1] = TeamMessageBox1_Frame;
	g_Frame[2] = TeamMessageBox2_Frame;
	g_Frame[3] = TeamMessageBox3_Frame;
	g_Frame[4] = TeamMessageBox4_Frame;
	g_Frame[5] = TeamMessageBox5_Frame;

	-- ÏÔÊ¾ÎÄ×Ö
	g_ShowText[1] = TeamMessageBox1_Text;
	g_ShowText[2] = TeamMessageBox2_Text;
	g_ShowText[3] = TeamMessageBox3_Text;
	g_ShowText[4] = TeamMessageBox4_Text;
	g_ShowText[5] = TeamMessageBox5_Text;

	this:Show();


end

--===============================================
-- OnEvent()
--===============================================
function TeamMessageBox1_OnEvent(event)

	-- ¶ÓÔ±ÑûÇëÄ³ÈË¼ÓÈë¶ÓÎéÇëÄãÍ¬Òâ
	if ( event == "TEAM_MEMBER_INVITE" ) then
		TeamMessageBox_Show_Message(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
	end;

	TeamMessageBox1_UpdateFrame();

end

--===============================================
-- UpdateFrame
--===============================================
function TeamMessageBox1_UpdateFrame()


end

--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function TeamMessageBox1_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox1_Cancel_Clicked()

	--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();

end



--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function TeamMessageBox2_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox2_Cancel_Clicked()

	--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();


end




--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function TeamMessageBox3_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox3_Cancel_Clicked()

	--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();


end





--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function TeamMessageBox4_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox4_Cancel_Clicked()

	--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();


end






--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function TeamMessageBox5_OK_Clicked()

	Player:SendAgreeJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox5_Cancel_Clicked()

	--´¦ÀíÓĞÈËÑûÇëÄã¼ÓÈë¶ÓÎé
		Player:SendRejectJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();


end


function TeamMessageBox_Show_Message(strInviter, strDesName, strInvZoneWorldID, strDesZoneWorldID, strDesLevel,strDestMenpai,strPos)

	local menpai = tonumber(strDestMenpai);
	local indexMess = tonumber(strPos);
	local strMenPai

	if(0 == menpai) then
		strMenPai = "Thiªu Lâm";

		elseif(1 == menpai) then
			strMenPai = "Minh Giáo";

		elseif(2 == menpai) then
			strMenPai = "Cái Bang";

		elseif(3 == menpai) then
			strMenPai = "Võ Ğang";

		elseif(4 == menpai) then
			strMenPai = "Nga Mi";

		elseif(5 == menpai) then
			strMenPai = "Tinh Túc";

		elseif(6 == menpai) then
			strMenPai = "Thiên Long";

		elseif(7 == menpai) then
			strMenPai = "Thiên S½n";

		elseif(8 == menpai) then
			strMenPai = "Tiêu Dao";

		elseif(10== menpai) then
			strMenPai = "Mµ Dung";

	else
		strMenPai = "Tñ do";
	end


	if(-1 == indexMess) then
		return;
	end;

	indexMess = indexMess+ 1;
	this:Show();
	g_Frame[indexMess]:Show();

    local invZoneWorldID  = tonumber( strInvZoneWorldID )   --- ????ZoneWorldID
    local desZoneWorldID  = tonumber( strDesZoneWorldID )   --- ?????ZoneWorldID
    local selfZoneWorldID = DataPool:GetSelfZoneWorldID()   --- ???ZoneWorldID

    --- Èç¹ûÑûÇë ßºÍ¶Ó³¤²»ÔÚÍ¬Ò»·şÎñÆ÷£¬ÒªÏÔÊ¾ÑûÇë ßµÄ·şÎñÆ÷Ãû
    if invZoneWorldID ~= selfZoneWorldID and selfZoneWorldID ~= -1 and invZoneWorldID ~= 0 and invZoneWorldID ~= -1 then
        strInviter = strInviter .. "@" .. DataPool:GetServerName( invZoneWorldID )
    end

    --- Èç¹û±»ÑûÇë ßºÍ¶Ó³¤²»ÔÚÍ¬Ò»·şÎñÆ÷£¬ÒªÏÔÊ¾±»ÑûÇë ßµÄ·şÎñÆ÷Ãû
    if desZoneWorldID ~= selfZoneWorldID and selfZoneWorldID ~= -1 and desZoneWorldID ~= 0 and desZoneWorldID ~= -1 then
        strDesName = strDesName .. "@" .. DataPool:GetServerName( desZoneWorldID )
    end
	local strShowInfo ="";
	strShowInfo ="#R" ..strInviter.. "#cfff263M¶i#R " .. strDesName .. "#G["..strDesLevel.." c¤p"..strMenPai.."]#cfff263 Các hÕ ğ°ng ı gia nh§p ğµi không?";
	g_ShowText[indexMess]:SetText(strShowInfo);
end
