
-----------------------------------------------------------------------------------------------------------------
--
-- È«¾Ö±äÁ¿Çø
--

-- Ãû×Ö
local g_RoleName = {};

-- ÃÅÅÉ
local g_iMenPai = {};

-- µÈ¼¶
local g_iLevel = {};

-- Ê£ÓàÉ¾³ýÊ±¼ä
local g_iDelTime = {};

-- Í·Ïñ×ÊÔ´Ãû³Æ
local g_FaceImg = {};

-- ÔÚ½çÃæÉÏÏÔÊ¾µÄuiÄ£ÐÍ
local g_UIModel = {};

-- Ñ¡Ôñ°´Å¥
local g_BnSelCheck = {};

-- µ±Ç°Ñ¡ÔñµÄ½ÇÉ«
local g_iCurSelRole = 0;

-- µ±Ç°½ÇÉ«µÄ¸öÊý
local g_iCurRoleCount = 0;

-- Èç¹ûÊÇ´´½¨³É¹¦ºóË¢ÐÂ½çÃæ£¬ ÒªÑ¡ÖÐ×îºó´´½¨µÄ â¸ö½ÇÉ«.
--
-- 0 -- ´´½¨½ÇÉ«Ê§°Ü¡£
-- 1 -- ´´½¨½ÇÉ«³É¹¦¡£
local g_bCreateSuccess = 0;

-- UI½çÃæ×ÊÔ´
local g_RolName_Text	= {};
local g_MenPai_Text	= {};
local g_Level_Text	= {};
local g_Delete_Text	= {};
local g_RolFace_Icon	= {};
local g_HighLightBack	= {};
local g_CreateInfo_Text = {};
------------------------------------------------------------------------------------------------------------------
--
-- º¯ÊýÇø
--

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectRole_PreLoad()
	-- ´ò¿ª½çÃæ
	this:RegisterEvent("GAMELOGIN_OPEN_SELECT_CHARACTOR");

	-- ¹Ø± ½çÃæ
	this:RegisterEvent("GAMELOGIN_CLOSE_SELECT_CHARACTOR");

	-- Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
	this:RegisterEvent("GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR");

	-- ´´½¨½ÇÉ«³É¹¦¡£
	this:RegisterEvent("GAMELOGIN_CREATE_ROLE_OK");

	this:RegisterEvent("ENTER_GAME");

	this:RegisterEvent("GAMELOGIN_SELECTCHARACTER");

end

-- ×¢²áonLoadÊÂ¼þ
function LoginSelectRole_OnLoad()

	-- ½ÇÉ«Ãû×Ö
	--g_RoleName[1] = SelectRole_Role1_Name;
	--g_RoleName[2] = SelectRole_Role2_Name;
	--g_RoleName[3] = SelectRole_Role3_Name;

	g_RoleName[1] = ""
	g_RoleName[2] = ""
	g_RoleName[3] = ""

	-- ½ÇÉ«ÃÅÅÉ
	g_iMenPai[1] = 0;
	g_iMenPai[2] = 0;
	g_iMenPai[3] = 0;

	-- ½ÇÉ«µÈ¼¶
	g_iLevel[1] = 0;
	g_iLevel[2] = 0;
	g_iLevel[3] = 0;

	g_iDelTime[1] = 0;
	g_iDelTime[2] = 0;
	g_iDelTime[3] = 0;

	-- ½ÇÉ«Í·ÏñÐÅÏ¢
	g_FaceImg[1] = ""
	g_FaceImg[2] = ""
	g_FaceImg[3] = ""

	-- ½ÇÉ«Ñ¡Ôñ°´Å¥
	--g_BnSelCheck[1] = SelectRole_Role1;
	--g_BnSelCheck[2] = SelectRole_Role2;
	--g_BnSelCheck[3] = SelectRole_Role3;

	-- Ñ¡Ôñ°´Å¥
	--g_BnSelCheck[1]:SetProperty("CheckMode", "1");
	--g_BnSelCheck[2]:SetProperty("CheckMode", "1");
	--g_BnSelCheck[3]:SetProperty("CheckMode", "1");

	--g_BnSelCheck[1]:SetCheck( 0 );
	--g_BnSelCheck[2]:SetCheck( 0 );
	--g_BnSelCheck[3]:SetCheck( 0 );
	-- uiÄ£ÐÍÃû×Ö
	--g_UIModel[1] = SelectRole_Role1_Model;
	--g_UIModel[2] = SelectRole_Role2_Model;
	--g_UIModel[3] = SelectRole_Role3_Model;

	--SelectRole_Role1_Model:SetProperty("MouseHollow", "True");
	--SelectRole_Role2_Model:SetProperty("MouseHollow", "True");
	--SelectRole_Role3_Model:SetProperty("MouseHollow", "True");

	g_RolName_Text[1] = SelectRole_TargetInfo_Name_Text;
	g_RolName_Text[2] = SelectRole_TargetInfo_Name_Text2;
	g_RolName_Text[3] = SelectRole_TargetInfo_Name_Text3;

	g_MenPai_Text[1] = SelectRole_TargetInfo_Menpai_Text;
	g_MenPai_Text[2] = SelectRole_TargetInfo_Menpai_Text2;
	g_MenPai_Text[3] = SelectRole_TargetInfo_Menpai_Text3;

	g_Level_Text[1] = SelectRole_TargetInfo_Level_Text;
	g_Level_Text[2] = SelectRole_TargetInfo_Level_Text2;
	g_Level_Text[3] = SelectRole_TargetInfo_Level_Text3;

	g_Delete_Text[1] = SelectRole_TargetInfo_Delete;
	g_Delete_Text[2] = SelectRole_TargetInfo_Delete2;
	g_Delete_Text[3] = SelectRole_TargetInfo_Delete3;

	g_RolFace_Icon[1] = SelectRole_Icon;
	g_RolFace_Icon[2] = SelectRole_Icon2;
	g_RolFace_Icon[3] = SelectRole_Icon3;

	g_HighLightBack[1] = SelectRole_TargetInfo_Gaoliang1;
	g_HighLightBack[2] = SelectRole_TargetInfo_Gaoliang2;
	g_HighLightBack[3] = SelectRole_TargetInfo_Gaoliang3;

	g_CreateInfo_Text[1] = SelectRole_TargetInfo_Create;
	g_CreateInfo_Text[2] = SelectRole_TargetInfo_Create2;
	g_CreateInfo_Text[3] = SelectRole_TargetInfo_Create3;

	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:SetText("");
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end

-- OnEvent
function LoginSelectRole_OnEvent(event)

	if( event == "GAMELOGIN_OPEN_SELECT_CHARACTOR" ) then

	    local CurSelIndex = GameProduceLogin:GetCurSelectRole();

		-- Ä¬ÈÏÑ¡ÔñµÚÒ»¸öÈËÎï¡£
		g_iCurSelRole = CurSelIndex + 1  --1;

		AxTrace( 1, 0, g_iCurSelRole )

		SelectRole_ClearInfo();
		SelectRole_RefreshRoleInfo();
		this:Show();
		return;
	end


	if( event == "GAMELOGIN_CLOSE_SELECT_CHARACTOR" ) then

		-- Çå¿ Êý¾Ý
		SelectRole_ClearInfo();
		this:Hide();
		return;
	end


	-- Ë¢ÐÂ½ÇÉ«
	if( event == "GAMELOGIN_REFRESH_ROLE_SELECT_CHARACTOR") then

		SelectRole_RefreshRoleInfo();
		return;
	end


	-- ´´½¨½ÇÉ«³É¹¦¡£
	if( event == "GAMELOGIN_CREATE_ROLE_OK") then

		g_bCreateSuccess = 1;
		return;
	end

	if( event == "ENTER_GAME" ) then
		GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
		return;
	end

	if( event == "GAMELOGIN_SELECTCHARACTER" ) then
	   local CurSel = tonumber( arg0 )

	   if( 0 == CurSel ) then
	     SelectRole_SelectRole1()
	   end

	   if( 1 == CurSel ) then
	     SelectRole_SelectRole2()
	   end

	   if( 2 == CurSel ) then
	     SelectRole_SelectRole3()
	   end

	end


end



---------------------------------------------------------------------------------------------
--
-- ½øÈëÓÎÏ·
--
function SelectRole_EnterGame()

	-- ·¢ËÍ½øÈëÓÎÏ·ÏûÏ¢
	GameProduceLogin:SendEnterGameMsg(g_iCurSelRole - 1);
end

---------------------------------------------------------------------------------------------
--
-- ´´½¨½ÇÉ«
--
function SelectRole_CreateRole()

	--GameProduceLogin:ChangeToCreateRoleDlgFromSelectRole();
	
	--´´½¨½ÇÉ«
	DataPool:AskCreateChar();

end



---------------------------------------------------------------------------------------------
--
-- É¾³ý½ÇÉ«
--
function SelectRole_DelRole()

	GameProduceLogin:SetCurSelect( g_iCurSelRole - 1 );
	-- ´ÓÈËÎïÑ¡Ôñ½çÃæÇÐ»»µ½ÈËÎï´´½¨½çÃæ.
		local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	,iMenPai
	,iLevel
	,iDelTime
	,strImgName
	= GameProduceLogin:GetRoleInfo(g_iCurSelRole-1);
	if( iLevel == 0 ) then --??????
		strInfo="Không có lña ch÷n vai di­n";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		return;
	end
	if( iLevel >= 1 ) then --????10?
		if( iDelTime >= 11 ) then--????????,??????
			strInfo="Xóa bö xin ðã ð® trình"..tostring( 14 - iDelTime ).."Thiên Li­u, Thïnh TÕi xóa bö vai di­n 3ngày sau, 14Thiên trong vòng ðång ký trò ch½i, Ðáo LÕc Dß½ng(268, 46) tìm ðßþc Quan Hán Th÷ ho£c là ðªn l¾n Lý(80, 136) tìm ðßþc Chu Thß½ng xác nh§n.";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "6" );
		elseif( iDelTime > 0 ) then		--???????,??????
			strInfo="Thïnh ðång ký trò ch½i, Ðáo LÕc Dß½ng(268, 46) tìm ðßþc Quan Hán Th÷ ho£c là ðªn l¾n Lý(80, 136) tìm ðßþc Chu Thß½ng xác nh§n, có th¬ vînh cØu xóa bö. Nhî phäi không có bang hµi, kªt hôn, Khai Ðiªm, kªt bái, th¥y trò quan h® m¾i có th¬ xóa bö.";
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "5" );
		else --??????,???????
			strInfo = "Nhî xác ð¸nh phäi"..tostring( iLevel ).."C¤p Ðích vai di­n#c00ff00"..strName.."#cffffffxóa bö Ma?";
			GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "4" );
		end
	else --??????,????
		strInfo = "Nhî xác ð¸nh phäi"..tostring( iLevel ).."C¤p Ðích vai di­n#c00ff00"..strName.."#cffffffxóa bö Ma?";
		GameProduceLogin:ShowMessageBox( strInfo, "YesNo", "7" );
	end

end


---------------------------------------------------------------------------------------------
--
-- ·µ»Øµ½ÉÏÒ»²½
--
function SelectRole_Return()

	GameProduceLogin:ExitToAccountInput_YesNo();
	--GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
end


---------------------------------------------------------------------------------------------------------------
--
--   Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
--
function SelectRole_RefreshRoleInfo()

	-- Çå¿ ½çÃæ.
	SelectRole_ClearInfo();

	g_iCurRoleCount = GameProduceLogin:GetRoleCount();
	-- µÃµ½ÈËÎïµÄ¸öÊý
	AxTrace( 0,0, "Nh§n ðßþc vai di­n Cá S±"..tostring(g_iCurRoleCount));

	if(0 == g_iCurRoleCount) then

		return;
	end;

	for index =0 , g_iCurRoleCount-1 do

	 		AxTrace( 0,0, "Bi¬u hi®n vai di­n"..tostring(index));
			SelectRole_GetRoleInfo(index);
	end

	-- Ñ¡Ôñ½ÇÉ«
	if(1 == g_bCreateSuccess) then

			-- ´´½¨³É¹¦ºó
			g_iCurSelRole = g_iCurRoleCount;
			g_bCreateSuccess = 0;
	end

	for index =1 , g_iCurRoleCount do
		SelectRole_ShowSelRoleInfo(index);
	end

	SelectRole_HighLight();
end


---------------------------------------------------------------------------------------------------------------
--
--   Ë¢ÐÂ½ÇÉ«ÐÅÏ¢
--
function SelectRole_GetRoleInfo(index)

	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strFaceImgName;

	strName
	,iMenPai
	,iLevel
	,iDelTime
	,strFaceImgName
	= GameProduceLogin:GetRoleInfo(index);

	-- ÉèÖÃÃû×Ö
	--g_RoleName[index+1]:SetText(strName);
	g_RoleName[index+1] = strName;
	g_iMenPai[index+1] = iMenPai;
	g_iLevel[index+1]  = iLevel;
	g_iDelTime[index+1] = iDelTime;
	g_FaceImg[index+1] = strFaceImgName;

end

---------------------------------------------------------------------------------------------------------------
--
--   Çå¿ ½ÇÉ«ÐÅÏ¢.
--
function SelectRole_ClearInfo()
	for i = 1, 3 do
		g_RolName_Text[i]:SetText("");
		g_MenPai_Text[i]:SetText("");
		g_Level_Text[i]:SetText("");
		g_Delete_Text[i]:Hide();
		g_RolFace_Icon[i]:SetProperty("Image", "");
		g_HighLightBack[i]:Hide();
		g_CreateInfo_Text[i]:Show();
	end
end


---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«1.
--
function SelectRole_SelectRole1()

	AxTrace( 0,0, "Tuy¬n 1");
	g_iCurSelRole = 1;
	if(g_iCurRoleCount < g_iCurSelRole) then

		AxTrace( 0,0, "V¸ lña ch÷n Nh¤t");
		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end

	--SelectRole_ShowSelRoleInfo(g_iCurSelRole);

end

---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«2.
--
function SelectRole_SelectRole2()

	AxTrace( 0,0, "Tuy¬n 2");
	g_iCurSelRole = 2;
	if(g_iCurRoleCount < g_iCurSelRole) then

		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end

	--SelectRole_ShowSelRoleInfo(g_iCurSelRole);

end


---------------------------------------------------------------------------------------------------------------
--
--   Ñ¡Ôñ½ÇÉ«3.
--
function SelectRole_SelectRole3()

	AxTrace( 0,0, "Tuy¬n 3");
	g_iCurSelRole = 3;
	if(g_iCurRoleCount < g_iCurSelRole) then

		SelectRole_TargetInfo_Name_Text:SetText("");
		SelectRole_TargetInfo_Menpai_Text:SetText("");
		SelectRole_TargetInfo_Level_Text:SetText("");
		return;
	end

	--SelectRole_ShowSelRoleInfo(g_iCurSelRole);

end


---------------------------------------------------------------------------------------------------------------
--
--   Í¨¹ýË÷Òý, Ñ¡Ôñ½ÇÉ«
--
function SelectRole_ShowSelRoleInfo(index)

	if(g_iCurRoleCount < index or 0 >= index ) then
		return;
	end

	if(index < 1)	then
		return;
	end;

	-- ÏÔÊ¾Ãû×Ö
	AxTrace(0, 0, "show sel info index="..index);
	--SelectRole_TargetInfo_Name_Text:SetText(g_RoleName[index]:GetText());
	--added by dun.liu 2008-04-18
	g_RolName_Text[index]:SetText( ""..g_RoleName[index] );


	-- ÏÔÊ¾ÃÅÅÉ
	local strName = "Tñ do";
	local Family  = g_iMenPai[index];

	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == Family) then
		strName = "Thiªu Lâm";

	elseif(1 == Family) then
		strName = "Minh Giáo";

	elseif(2 == Family) then
		strName = "Cái Bang";

	elseif(3 == Family) then
		strName = "Võ Ðang";

	elseif(4 == Family) then
		strName = "Nga Mi";

	elseif(5 == Family) then
		strName = "Tinh Túc";

	elseif(6 == Family) then
		strName = "Thiên Long";

	elseif(7 == Family) then
		strName = "Thiên S½n";

	elseif(8 == Family) then
		strName = "Tiêu dao";

	elseif(9 == Family) then
		strName = "Tñ do";
	elseif(10 == Family) then
		strName = "MÕn Ðà S½n Trang";

	elseif(11 == Family) then--MPTODO menpai11
		strName = "Ác Nhân C¯c";
	end
	g_MenPai_Text[index]:SetText("#c00ff00môn phái: #cffffff"..strName);

	-- ÏÔÊ¾µÈ¼¶
	g_Level_Text[index]:SetText("#c00ff00c¤p b§c: #cffffff"..tostring(g_iLevel[index]));

	if(tonumber(g_iDelTime[index])>0)then
		if(g_iDelTime[index]>=11)then
			g_Delete_Text[index]:SetText("#c00ff00"..(3-(14-g_iDelTime[index])).."Ngày sau Khä xóa bö vai di­n");
		else
			g_Delete_Text[index]:SetText("#c00ff00Dî Khä xóa bö vai di­n");
		end

		g_Delete_Text[index]:Show();
	else
		g_Delete_Text[index]:Hide();
	end
	-- ÉèÎªÑ¡Ôñ×´Ì¬
	--g_BnSelCheck[index]:SetCheck(1);

	g_RolFace_Icon[index]:SetProperty("Image", g_FaceImg[index]);

	g_CreateInfo_Text[index]:Hide();

end


function SelectRole_SelRole_MouseEnter(index)

	SelectRole_Info:SetText("Lña ch÷n trß¾c m£t ðång ký vai di­n");
end

function SelectRole_MouseLeave()

	SelectRole_Info:SetText("");
end

function SelectRole_Play_MouseEnter()

	SelectRole_Info:SetText("Tiªn vào trò ch½i");
end

function SelectRole_Create_MouseEnter()

	SelectRole_Info:SetText("Sáng tÕo mµt cái Tân vai di­n");
end

function SelectRole_Delete_MouseEnter()

	SelectRole_Info:SetText("Xóa bö mµt cái ðã có vai di­n");
end

function SelectRole_Last_MouseEnter()

	SelectRole_Info:SetText("Phän h°i Ðáo tài khoän ðång ký m£t biên");	--??  to  ??
end;


function SelectRole_Role_Modle_TurnRightBegin(index)

	if(1 == index) then

		SelectRole_Role1_Model:RotateBegin(0.3);

	elseif(2 == index) then

		SelectRole_Role2_Model:RotateBegin(0.3);

	elseif(3 == index) then

		SelectRole_Role3_Model:RotateBegin(0.3);

	end;

end;


function SelectRole_Role_Modle_TurnRightEnd(index)

	if(1 == index) then

		SelectRole_Role1_Model:RotateEnd();

	elseif(2 == index) then

		SelectRole_Role2_Model:RotateEnd();

	elseif(3 == index) then

		SelectRole_Role3_Model:RotateEnd();

	end;

end;

function SelectRole_Role_Modle_TurnLeftBegin(index)

	if(1 == index) then

		SelectRole_Role1_Model:RotateBegin(-0.3);

	elseif(2 == index) then

		SelectRole_Role2_Model:RotateBegin(-0.3);

	elseif(3 == index) then

		SelectRole_Role3_Model:RotateBegin(-0.3);

	end;

end;


function SelectRole_Role_Modle_TurnLeftEnd(index)

	if(1 == index) then

		SelectRole_Role1_Model:RotateEnd();

	elseif(2 == index) then

		SelectRole_Role2_Model:RotateEnd();

	elseif(3 == index) then

		SelectRole_Role3_Model:RotateEnd();

	end;

end;





function SelectRole_Role_Modle_TurnRight( start )
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1) then
        --GameProduceLogin:ModelRotBegin(0.3)
            GameProduceLogin:ModelRotBegin(1.0)   --????
	--ÏòÓÒÐý×ª½áÊø
	else
        GameProduceLogin:ModelRotEnd( 0.0 )
	end

end

function SelectRole_Role_Modle_TurnLeft( start )
	if(start == 1) then
            --GameProduceLogin:ModelRotBegin(-0.3)
            GameProduceLogin:ModelRotBegin(-1.0)   --??-1?
	else
        GameProduceLogin:ModelRotEnd( 0.0 )
	end

end

function SelectRole_Modle_ZoomOut( start )
	if(start == 1) then
	    GameProduceLogin:ModelZoom( -1.0 )
	else
	    GameProduceLogin:ModelZoom( 0.0 )
	end

end

function SelectRole_Modle_ZoomIn( start )
    if(start == 1) then
         GameProduceLogin:ModelZoom( 1.0 )
	else
	     GameProduceLogin:ModelZoom( 0.0 )
	end

end

function SelectRole_Clicked( index )
	if(g_iCurRoleCount <= index or 0 > index ) then
		return;
	end

	GameProduceLogin:MoveToCharacter( index );
	g_iCurSelRole = index + 1;
	SelectRole_HighLight();
end

function SelectRole_HighLight()
	if(g_iCurRoleCount < g_iCurSelRole or 0 >= g_iCurSelRole ) then
		return;
	end

	for i = 1, 3 do
		g_HighLightBack[i]:Hide();
	end
	g_HighLightBack[g_iCurSelRole]:Show();
end

function SelectRole_DoubleClicked( index )
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	,iMenPai
	,iLevel
	,iDelTime
	,strImgName
	= GameProduceLogin:GetRoleInfo(index);
	if( iLevel == 0 ) then --??????
		SelectRole_CreateRole();
	else
		if(g_iCurRoleCount <= index or 0 > index) then
			return;
		end

		if (g_iCurSelRole ~= index + 1) then
			g_iCurSelRole = index + 1;
			GameProduceLogin:MoveToCharacter(index);
			SelectRole_HighLight();
		end

		SelectRole_EnterGame();
	end
end

function SelectRole_MouseEnterCharArea(index)
	local strName;
	local iMenPai;
	local iLevel;
	local iDelTime;
	local strInfo;
	local strImgName;
	strName
	,iMenPai
	,iLevel
	,iDelTime
	,strImgName
	= GameProduceLogin:GetRoleInfo(index);
	if( iLevel == 0 ) then --??????
		SelectRole_Info:SetText("#{DLJM_XML_5}");
	else
		SelectRole_Info:SetText("#{DLJM_XML_6}");
	end
end
