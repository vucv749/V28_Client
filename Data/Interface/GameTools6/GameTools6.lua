--Công cø quän lý trò ch½i (GM): giao di®n chính
--by.Fjqh For Entertainment or Communication Only
--By.Fjqh The computer To Write!!!
local g_UIPos;
local GameTools6_CurName,GameTools6_CurGuid = "","";
local GameTools6_SelectObject = 1;
local GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
local GameTools6_SelfTab = {}
local GameTools6_TarTab = {}
local GameTools6_AllTab = {}
local GameTools6_EditBoxTab = {}
local GameTools6_EditBoxTabRed = {}
local GameTools6_Info = {};

--===============================================
-- OnLoad()
--===============================================
function GameTools6_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("NEW_DEBUGMESSAGE")
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("CHAT_SHOWUSERINFO");
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

--===============================================
-- OnLoad()
--===============================================
function GameTools6_OnLoad()
	GameTools6_EditBoxTab = {GameTools6_BoxPar1,GameTools6_BoxPar2,GameTools6_BoxPar3};
	GameTools6_EditBoxTabRed = {GameTools6_BoxPar1_Background,GameTools6_BoxPar2_Background,GameTools6_BoxPar3_Background};
	
	--==========Toàn bµ: b¡t ð¥u==========
	GameTools6_AllTab[1] = {"ID quái","Hß¾ng quái","Script g¡n","ID quái = P1 (ID trong bäng quái)\nHß¾ng quái = P2, m£c ð¸nh thì nh§p -1\nScript g¡n = P3 (mã script), không có thì nh§p -1","TÕo quái (quái v§t)"};
	GameTools6_AllTab[2] = {"ID quái","Hß¾ng quái","Script g¡n","ID quái = P1 (ID trong bäng quái)\nHß¾ng quái = P2, m£c ð¸nh thì nh§p -1\nScript g¡n = P3 (mã script), không có thì nh§p -1","TÕo quái (NPC)"};
	GameTools6_AllTab[3] = {"ID quái","Không dùng","Không dùng","ID quái = ID trong bäng quái\nXóa m÷i quái/NPC ðã tÕo có ID này trong cänh hi®n tÕi","Xóa quái"};
	GameTools6_AllTab[4] = {"ID script","Không dùng","Không dùng","ID script = ID 6 chæ s¯\nNÕp lÕi mµt script LUA b¤t kÏ","NÕp lÕi script LUA"};
	GameTools6_AllTab[5] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi script toàn cøc ScriptGlobal.lua, hàm và script ðã sØa có hi®u lñc ngay","NÕp lÕi script toàn cøc"};
	GameTools6_AllTab[6] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi file TXT cØa hàng\nNÕp lÕi file, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi cØa hàng"};
	GameTools6_AllTab[7] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi file TXT tï l® r½i\nNÕp lÕi file, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi tï l® r½i"};
	GameTools6_AllTab[8] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi file TXT quái\nNÕp lÕi file, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi file quái"};
	GameTools6_AllTab[9] = {"Có m· không","Không dùng","Không dùng","Có cho dùng Ti¬u LÕt Bá không\nM· = 0, ðóng = 1","B§t/t¡t Ti¬u LÕt Bá"};
	GameTools6_AllTab[10] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi vån bän thông báo r½i ð° DropNotify.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi thông báo r½i ð°"};
	GameTools6_AllTab[11] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi EquipBase.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi file trang b¸"};
	GameTools6_AllTab[12] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi bäng phân b¯ ph¦m ch¤t ð° thü công và bäng ðoÕn giá tr¸ kh·i ð¥u ItemSegAffect.txt, ItemSegValue.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi file thuµc tính trang b¸"};
	GameTools6_AllTab[13] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi AllowableScriptFunc.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng cho phép script"};
	GameTools6_AllTab[14] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi CommonItem.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng v§t ph¦m"};
	GameTools6_AllTab[15] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi GemInfo.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng Bäo ThÕch"};
	GameTools6_AllTab[16] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi PetAttrTable.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng Trân Thú"};
	GameTools6_AllTab[17] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi MonsterAttrExTable.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng quái"};
	GameTools6_AllTab[18] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi PetLingXing.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng Linh Tính"};
	GameTools6_AllTab[19] = {"Không dùng","Không dùng","Không dùng","NÕp lÕi PetHuanhuaTable.txt, thay ð±i trong file có hi®u lñc ngay","NÕp lÕi bäng Huy­n Hóa"};
	--==========Toàn bµ: kªt thúc==========
	
	--==========Ngß¶i khác: b¡t ð¥u==========
	GameTools6_TarTab[1] = {"Không dùng","Không dùng","Không dùng","Xem tài sän cüa nhân v§t møc tiêu","Xem tài sän"};
	GameTools6_TarTab[2] = {"#GID v§t ph¦m hþp l®","#GS¯ lßþng phát","Không dùng","Phát cho nhân v§t møc tiêu P2 cái P1 trong mµt l¥n","Phát v§t ph¦m"};
	GameTools6_TarTab[3] = {"S¯ lßþng phát","Không dùng","Không dùng","Phát cho nhân v§t møc tiêu P1 Vàng","Phát Vàng"};
	GameTools6_TarTab[4] = {"S¯ lßþng phát","Không dùng","Không dùng","Phát cho nhân v§t møc tiêu P1 Vàng Khóa","Phát Vàng Khóa"};
	GameTools6_TarTab[5] = {"S¯ lßþng phát","Không dùng","Không dùng","Phát cho nhân v§t møc tiêu P1 Nguyên Bäo","Phát Nguyên Bäo"};
	GameTools6_TarTab[6] = {"S¯ lßþng phát","Không dùng","Không dùng","Phát cho nhân v§t møc tiêu P1 Nguyên Bäo Khóa","Phát Nguyên Bäo Khóa"};
	GameTools6_TarTab[7] = {"S¯ MD [0-511]","Không dùng","Không dùng","Tra giá tr¸ MD s¯ P1 cüa nhân v§t møc tiêu","Tra MD"};
	GameTools6_TarTab[8] = {"S¯ EX [0-1535]","Không dùng","Không dùng","Tra giá tr¸ EX s¯ P1 cüa nhân v§t møc tiêu","Tra EX"};
	GameTools6_TarTab[9] = {"S¯ FLAG [0-319]","Không dùng","Không dùng","Tra giá tr¸ FLAG s¯ P1 cüa nhân v§t møc tiêu","Tra FLAG"};
	GameTools6_TarTab[10] = {"S¯ MD [0-511]","Giá tr¸ c¥n ð£t","Không dùng","Ð£t giá tr¸ MD s¯ P1 cüa nhân v§t møc tiêu","Ð£t MD"};
	GameTools6_TarTab[11] = {"S¯ EX [0-1535]","Giá tr¸ c¥n ð£t","Không dùng","Ð£t giá tr¸ EX s¯ P1 cüa nhân v§t møc tiêu","Ð£t EX"};
	GameTools6_TarTab[12] = {"S¯ FLAG [0-319]","Giá tr¸ c¥n ð£t [0-1]","Không dùng","Ð£t giá tr¸ FLAG s¯ P1 cüa nhân v§t møc tiêu","Ð£t FLAG"};
	GameTools6_TarTab[13] = {"Không dùng","Không dùng","Không dùng","Cho ngß¶i ch½i thuµc tính BT siêu c¤p","Thuµc tính GM siêu c¤p"};
	GameTools6_TarTab[14] = {"P1: ID Trân Thú","P2: tß ch¤t 5 chï s¯","P3: tï l® trß·ng thành","Ch÷n xong b¤m Ð°ng ý","Nh§n Trân Thú"};
	GameTools6_TarTab[15] = {"Không dùng","Không dùng","Không dùng","Tra m÷i BUFF trên ngß¶i","Tra BUFF"};
	GameTools6_TarTab[16] = {"P1: c¤p c¥n lên","Không dùng","Không dùng","Tång c¤p ngß¶i ch½i (chï tång ðßþc, không giäm ðßþc)","Tång c¤p"};
	--==========Ngß¶i khác: kªt thúc==========
	
	--==========Bän thân: b¡t ð¥u==========
	GameTools6_SelfTab[1] = {"#GID v§t ph¦m hþp l®","#GS¯ lßþng nh§n","Không dùng","Nh§n P2 cái P1 trong mµt l¥n","Nh§n v§t ph¦m"};
	GameTools6_SelfTab[2] = {"Ô túi ho£c ô trang b¸ #G[0-59]","Không dùng","Không dùng","Tra chu²i thông tin cüa v§t ph¦m · ô P1","Tra chu²i thông tin v§t ph¦m"};
	GameTools6_SelfTab[3] = {"Ô b¡t ð¥u #G[0-89]","Ô kªt thúc #G[0-89]","Không dùng","Xóa v§t ph¦m trong túi t× ô P1 ðªn ô P2","D÷n túi"};
	GameTools6_SelfTab[4] = {"S¯ lßþng nh§n","Không dùng","Không dùng","Nh§n Vàng = P1","Nh§n Vàng"};
	GameTools6_SelfTab[5] = {"S¯ lßþng tr×","Không dùng","Không dùng","Tr× Vàng = P1; nªu Vàng trên ngß¶i ít h½n P1 thì tr× hªt","Tr× Vàng"};
	GameTools6_SelfTab[6] = {"S¯ lßþng nh§n","Không dùng","Không dùng","Nh§n Vàng Khóa = P1","Nh§n Vàng Khóa"};
	GameTools6_SelfTab[7] = {"S¯ lßþng tr×","Không dùng","Không dùng","Tr× Vàng Khóa = P1; nªu Vàng Khóa trên ngß¶i ít h½n P1 thì tr× hªt","Tr× Vàng Khóa"};
	GameTools6_SelfTab[8] = {"S¯ lßþng nh§n","Không dùng","Không dùng","Nh§n Nguyên Bäo = P1","Nh§n Nguyên Bäo"};
	GameTools6_SelfTab[9] = {"S¯ lßþng tr×","Không dùng","Không dùng","Tr× Nguyên Bäo = P1; nªu Nguyên Bäo trên ngß¶i ít h½n P1 thì tr× hªt","Tr× Nguyên Bäo"};
	GameTools6_SelfTab[10] = {"S¯ lßþng nh§n","Không dùng","Không dùng","Nh§n Nguyên Bäo Khóa = P1","Nh§n Nguyên Bäo Khóa"};
	GameTools6_SelfTab[11] = {"S¯ lßþng tr×","Không dùng","Không dùng","Tr× Nguyên Bäo Khóa = P1; nªu Nguyên Bäo Khóa trên ngß¶i ít h½n P1 thì tr× hªt","Tr× Nguyên Bäo Khóa"};
	GameTools6_SelfTab[12] = {"S¯ lßþng nh§n","Không dùng","Không dùng","Nh§n kinh nghi®m = P1","Nh§n kinh nghi®m"};
	GameTools6_SelfTab[13] = {"S¯ lßþng tr×","Không dùng","Không dùng","Tr× kinh nghi®m = P1; nªu kinh nghi®m trên ngß¶i ít h½n P1 thì tr× hªt","Tr× kinh nghi®m"};
	GameTools6_SelfTab[14] = {"C¤p [1-119]","Không dùng","Không dùng","C¤p = P1","Ð£t c¤p"};
	GameTools6_SelfTab[15] = {"Mã môn phái [0-8]","Không dùng","Không dùng","Khi chßa có môn phái thì gia nh§p môn phái = P1","Gia nh§p môn phái"};
	GameTools6_SelfTab[16] = {"Không dùng","Không dùng","Không dùng","H÷c các tâm pháp chßa h÷c cüa môn phái mình","H÷c tâm pháp"};
	GameTools6_SelfTab[17] = {"C¤p tâm pháp [1-119]","Không dùng","Không dùng","Ð£t c¤p các tâm pháp ðã h÷c cüa môn phái mình = P1","Ð£t c¤p tâm pháp"};
	GameTools6_SelfTab[18] = {"Không dùng","Không dùng","Không dùng","Tra m÷i BUFF trên ngß¶i","Tra BUFF"};
	GameTools6_SelfTab[19] = {"S¯ MD [0-511]","Không dùng","Không dùng","Tra giá tr¸ MD s¯ P1","Tra MD"};
	GameTools6_SelfTab[20] = {"S¯ EX [0-1535]","Không dùng","Không dùng","Tra giá tr¸ EX s¯ P1","Tra EX"};
	GameTools6_SelfTab[21] = {"S¯ FLAG [0-319]","Không dùng","Không dùng","Tra giá tr¸ FLAG s¯ P1","Tra FLAG"};
	GameTools6_SelfTab[22] = {"S¯ WORLD [1-100]","Không dùng","Không dùng","Tra giá tr¸ WORLD s¯ P1","Tra WORLD"};
	GameTools6_SelfTab[23] = {"Mã kÛ nång","Không dùng","Không dùng","H÷c kÛ nång có mã = P1","H÷c kÛ nång"};
	GameTools6_SelfTab[24] = {"Mã kÛ nång","Không dùng","Không dùng","Xóa kÛ nång có mã = P1","Xóa kÛ nång"};
	GameTools6_SelfTab[25] = {"ID BUFF","Không dùng","Không dùng","Thêm BUFF = P1","Thêm BUFF"};
	GameTools6_SelfTab[26] = {"ID BUFF","Không dùng","Không dùng","Xóa BUFF = P1","Xóa BUFF"};
	GameTools6_SelfTab[27] = {"Không dùng","Không dùng","Không dùng","Dæ li®u cänh hi®n tÕi","Tra dæ li®u cänh"};
	GameTools6_SelfTab[28] = {"ID cänh","T÷a ðµ X","T÷a ðµ Z","D¸ch chuy¬n t¾i cänh P1, v¸ trí [P2, P3]","Ð±i cänh"};
	GameTools6_SelfTab[29] = {"S¯ MD [0-511]","Giá tr¸ c¥n ð£t","Không dùng","Ð£t giá tr¸ MD s¯ P1","Ð£t MD"};
	GameTools6_SelfTab[30] = {"S¯ EX [0-1535]","Giá tr¸ c¥n ð£t","Không dùng","Ð£t giá tr¸ EX s¯ P1","Ð£t EX"};
	GameTools6_SelfTab[31] = {"S¯ FLAG [0-319]","Giá tr¸ c¥n ð£t [0-1]","Không dùng","Ð£t giá tr¸ FLAG s¯ P1","Ð£t FLAG"};
	GameTools6_SelfTab[32] = {"S¯ WORLD [1-100]","Giá tr¸ c¥n ð£t","Không dùng","Ð£t giá tr¸ WORLD s¯ P1","Ð£t WORLD"};
	GameTools6_SelfTab[33] = {"Không dùng","Không dùng","Không dùng","Cho ngß¶i ch½i thuµc tính BT siêu c¤p","Thuµc tính GM siêu c¤p"};
	GameTools6_SelfTab[34] = {"Không dùng","Không dùng","Không dùng","Ch÷n xong b¤m Ð°ng ý","Nh§n trÕng thái GM"};
	GameTools6_SelfTab[35] = {"P1: ID Trân Thú","P2: tß ch¤t 5 chï s¯","P3: tï l® trß·ng thành","Ch÷n xong b¤m Ð°ng ý","Nh§n Trân Thú"};
	GameTools6_SelfTab[36] = {"Không dùng","Không dùng","Không dùng","Ch÷n xong b¤m Ð°ng ý","H°i ð¥y máu, nµi lñc, khí, nµ"};
	GameTools6_SelfTab[37] = {"Không dùng","Không dùng","Không dùng","Ch÷n xong b¤m Ð°ng ý","Xóa m÷i th¶i gian h°i kÛ nång"};
	--==========Bän thân: kªt thúc==========
	
	g_UIPos = GameTools6_Frame:GetProperty("UnifiedPosition")
end

--===============================================
-- OnEvent()
--===============================================
function GameTools6_OnEvent(event)
	if event == "UI_COMMAND" then
		local UIID = tonumber(arg0);
		if UIID == 316022021 then
			if not this:IsVisible() then
				GameTools6_Select_Clicked(1);
				this:Show();
				if GameTools6_SelectShowServer:GetCheck() == 1 then
					GameTools6_SelectShowServer:SetCheck(0);
				end
				GameTools6_SelectShowServer_Clicked()
			end
		elseif UIID == 316022022 then
			if this:IsVisible() then
				if Get_XParam_INT(0) == UIID then
					GameTools6_CurName,GameTools6_CurGuid = Get_XParam_STR(0),Get_XParam_STR(1);
					GameTools6_SetCheck(2);
				end
			end
		elseif UIID == 707022021 then
			if this:IsVisible() then
				if GameTools6_SelectObject == 2 then
					if GameTools6_CurGuid == "" then
						return
					end
				end
				if arg1 == arg0 then
					GameTools6_EditBoxTab[1]:SetText(arg2);
					GameTools6_EditBoxTab[2]:SetText(arg3);
				elseif tonumber(arg1) == 881122334 then
					GameTools6_EditBoxTab[1]:SetText(arg2);
				end
			end
		end
	elseif event == "NEW_DEBUGMESSAGE" then
		if this:IsVisible() then
			GameTools6_GetInfo()
		end
	elseif event == "MAINTARGET_CHANGED" then
		if this:IsVisible() and GameTools6_SelectObject == 2 then
			if Target:IsPresent() then
				local int1 = tonumber(arg0);
				if int1 and int1 >= 15000 then
					int2 = GetTargetPlayerGUID();
					if int2 and int2 > 100000000 then
						local str1 = Target:GetName();
						local str2 = string.format("%.7X",int2);
						GameTools6_EditBoxTab[1]:SetText(str1);
						GameTools6_EditBoxTab[2]:SetText(str2);
					end
				end
			end
		end
	elseif event == "CHAT_SHOWUSERINFO" then
		if this:IsVisible() and GameTools6_SelectObject == 2 then
			local str1 = tostring( DataPool:GetFriend( "chat", "ID_TEXT" ) );
			if str1 and str1 ~= "" then
				local int1 = tonumber(str1,16);
				if int1 and int1 > 100000000 then
					GameTools6_EditBoxTab[1]:SetText(DataPool:GetFriend( "chat", "NAME"  ));
					GameTools6_EditBoxTab[2]:SetText(str1);
				end
			end
		end
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		GameTools6_Frame:SetProperty("UnifiedPosition", g_UIPos)
	end
end

--===============================================
--M· giao di®n tìm v§t ph¦m
--===============================================
function GameTools6_Loadini_Clicked()
	-- PushEvent("UI_COMMAND",707022022);
	
	local yPos = GameTools6_Frame:GetProperty("AbsoluteYPosition")
	local xPos = GameTools6_Frame:GetProperty("AbsoluteXPosition")
	local nWidth = GameTools6_Frame:GetProperty("AbsoluteWidth")
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OpenGameMasterControl_ItemSearch" );
		Set_XSCRIPT_ScriptID(199998);	
		Set_XSCRIPT_Parameter(0,tonumber(xPos)-tonumber(nWidth));
		Set_XSCRIPT_Parameter(1,tonumber(yPos));
		Set_XSCRIPT_ParamCount(2);	
	Send_XSCRIPT()
	
end
function GameTools6_Close_Clicked()
	GameTools6_CurName,GameTools6_CurGuid = "","";
	GameTools6_SelectObject = 1;
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	this:Hide();
end

function GameTools6_SelectShowServer_Clicked()
	if GameTools6_SelectShowServer:GetCheck() == 0 then
		GameTools6_CallBk:Hide();
		GameTools6_Frame:SetProperty("AbsoluteHeight",612);
	else
		GameTools6_CallBk:Show();
		GameTools6_Frame:SetProperty("AbsoluteHeight",680);
	end
end

function GameTools6_ServerCallOne()
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameMasterControl_ServerCallOne")
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function GameTools6_ServerCallTwo()
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("GameMasterControl_ServerCallTwo")
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
end

function GameTools6_ClientCallOne()
	PushDebugMessage("Møc này chßa m· (ðang chïnh sØa)")
end

function GameTools6_ClientCallTwo()
	-- PushEvent("UI_COMMAND",426022021);
	PushDebugMessage("Møc này chßa m· (ðang chïnh sØa)")
end

function GameTools6_Use_Clicked()
	if GameTools6_SelectProjectIdx < 1 then
		PushDebugMessage("Hãy ch÷n hÕng møc c¥n thao tác")
		return
	end
	local tab1;
	local str1 = "GameMasterControl_AllUse"
	if GameTools6_SelectObject == 1 then
		str1 = "GameMasterControl_SelfUse"
		tab1 = GameTools6_SelfTab[GameTools6_SelectProjectIdx];
	elseif GameTools6_SelectObject == 2 then
		str1 = "GameMasterControl_TarUse"
		tab1 = GameTools6_TarTab[GameTools6_SelectProjectIdx];
	else
		tab1 = GameTools6_AllTab[GameTools6_SelectProjectIdx];
	end
	local tab2 = {0,0,0};
	local int1
	for i,j in GameTools6_EditBoxTab do
		j:SetProperty("DefaultEditBox","False");
		if tab1[i] ~= "Không dùng" then
			int1 = tonumber(j:GetText());
			if not int1 then
				msg = "P"..i.." nh§p chßa ðúng, hãy ki¬m tra lÕi."
				PushDebugMessage(msg)
				j:SetProperty("DefaultEditBox","True");
				return
			end
			tab2[i] = int1;
		end
	end
	GameTools6_Oncd:Show();
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name(str1)
		Set_XSCRIPT_ScriptID(199998)
		Set_XSCRIPT_Parameter(0,GameTools6_SelectProjectIdx )
		for i = 1,3 do
			Set_XSCRIPT_Parameter(i,tab2[i] );
		end
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function GameTools6_AddTar_Clicked()
	if GameTools6_SelectObject == 2 then
		local str1 = GameTools6_EditBoxTab[1]:GetText();
		local str2 = GameTools6_EditBoxTab[2]:GetText();
		local int1 = string.len(str1);
		local int2 = string.len(str2);
		if int1 == 0 then
			PushDebugMessage("Hãy nh§p tên nhân v§t")
			return
		elseif int1 > 12 then
			PushDebugMessage("Tên nhân v§t không hþp l®. Nªu ch¡c ch¡n møc tiêu ðúng là tên này, hãy dùng khu vñc thñc thi mã ð¬ khóa tài khoän ngay")
			return
		elseif int2 ~= 7 then
			PushDebugMessage("Hãy nh§p GUID dÕng h® 16");
			return
		end
		local str3 = str2..str1;
		GameTools6_Oncd:Show();
		NewUserCard(str3,-1,0);
	end
end

function GameTools6_Select_Clicked(Par)
	GameTools6_SelectObject = Par;
	if Par == 1 then
		GameTools6_SelectSelf:SetCheck(1);
		GameTools6_SelectTar:SetCheck(0);
		GameTools6_SelectAll:SetCheck(0);
		GameTools6_CurName = Player:GetName();
		GameTools6_CurGuid = string.format("%.8X",Player:GetGUID());
		GameTools6_SetCheck(1)
	elseif Par == 2 then
		GameTools6_SelectSelf:SetCheck(0);
		GameTools6_SelectTar:SetCheck(1);
		GameTools6_SelectAll:SetCheck(0);
		GameTools6_SetCheck(0)
	else
		GameTools6_SelectSelf:SetCheck(0);
		GameTools6_SelectTar:SetCheck(0);
		GameTools6_SelectAll:SetCheck(1);
		GameTools6_CurName = "T¤t cä nhân v§t ðang online";
		GameTools6_CurGuid = "";
		GameTools6_SetCheck(1)
	end
end

function GameTools6_SetCheck(Par)
	local str0 = "";
	if Par > 0 then
		GameTools6_Use:Enable();
		if Par == 1 then
			GameTools6_AddTar:Disable();
		else
			str0 = string.format("#BThêm møc tiêu thành công.\nTên nhân v§t [%s]\nGUID [%s]\nKi¬m tra ðúng r°i ch÷n hÕng møc ð¬ thao tác lên møc tiêu này.",GameTools6_CurName,GameTools6_CurGuid)
			GameTools6_AddTar:Enable();
		end
		GameTools6_Server1:Enable();
		GameTools6_Server2:Enable();
		GameTools6_Client1:Enable();
		GameTools6_Client2:Enable();
		for i,j in GameTools6_EditBoxTab do
			j:SetProperty("DefaultEditBox","False");
			j:SetText("");
			j:Disable();
			GameTools6_EditBoxTabRed[i]:Show();
		end
		local tab1 = GameTools6_SelfTab;
		if GameTools6_SelectObject == 2 then
			tab1 = GameTools6_TarTab;
		elseif GameTools6_SelectObject == 3 then
			tab1 = GameTools6_AllTab;
		end
		GameTools6_SelectBox:SetText("Ch÷n hÕng møc c¥n thao tác")
		GameTools6_SelectBox:ResetList();
		for i,j in tab1 do
			if i < 10 then
				GameTools6_SelectBox:AddTextItem("["..i.."] "..j[5],i);
			elseif i < 100 then
				GameTools6_SelectBox:AddTextItem("["..i.."] "..j[5],i);
			else
				GameTools6_SelectBox:AddTextItem("["..i.."] "..j[5],i);
			end
		end
	else
		str0 = "#BTñ l¤y thông tin: ch÷n møc tiêu (nªu không tñ ði«n thì ð±i møc tiêu mµt l¥n là ðßþc) ho£c xem thông tin nhân v§t cüa ngß¶i khác trong khung chat ð¬ tñ ði«n\nNh§p tay: P1 nh§p tên nhân v§t, P2 nh§p GUID cüa nhân v§t"
		GameTools6_CurName = "";
		GameTools6_CurGuid = "";
		GameTools6_Use:Disable();
		GameTools6_Server1:Disable();
		GameTools6_Server2:Disable();
		GameTools6_Client1:Disable();
		GameTools6_Client2:Disable();
		GameTools6_AddTar:Enable();
		for i,j in GameTools6_EditBoxTab do
			j:SetText("");
			j:SetProperty("DefaultEditBox","False");
			if i ~= 3 then
				j:Enable();
				GameTools6_EditBoxTabRed[i]:Hide();
			else
				j:Disable();
				GameTools6_EditBoxTabRed[i]:Show();
			end
		end
		GameTools6_SelectBox:SetText("Hãy thêm møc tiêu trß¾c")
		GameTools6_SelectBox:ResetList();
	end
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	local str1 = GameTools6_CurName ~= "" and "#G"..GameTools6_CurName or "#cff0000Chßa thêm møc tiêu";
	local str2 = "#cFF00FFMøc tiêu: "..str1;
	local str3 = GameTools6_CurGuid ~= "" and str2.."|"..GameTools6_CurGuid.."#cff0000(quan tr÷ng)" or str2.."#cff0000(quan tr÷ng)";
	GameTools6_SelectTip:SetText(str3);
	GameTools6_SetTipBox(str0);
end

function GameTools6_SetTipBox(Par)
	GameTools6_TipBox:SetText(Par);
end

function GameTools6_GetInfo()
	if arg0 == "FJQHGM" then
		GameTools6_Info = {};
	elseif arg0 == "FJQHTOOL" then
		local str1 = table.concat(GameTools6_Info);
		GameTools6_SetTipBox(GameTools6_SelectProjectInfo.."\n=====Kªt quä thao tác=====\n"..str1);
		GameTools6_Info = {};
	elseif string.sub(arg0,1,6) == "FJQHGM" then
		local str1 = string.sub(arg0,7,-1)
		table.insert(GameTools6_Info,str1)
	end
end

function GameTools6_SelectBox_Clicked()
	local _,int1 = GameTools6_SelectBox:GetCurrentSelect();
	if int1 < 1 or int1 == GameTools6_SelectProjectIdx then
		return
	end
	local tab1;
	if GameTools6_SelectObject == 1 then
		tab1 = GameTools6_SelfTab[int1];
	elseif GameTools6_SelectObject == 2 then
		if GameTools6_CurGuid == "" then
			return
		end
		tab1 = GameTools6_TarTab[int1];
	else
		tab1 = GameTools6_AllTab[int1];
	end
	if not tab1 then
		return
	end
	GameTools6_SelectProjectIdx = int1;
	GameTools6_SelectProjectInfo = "#WÐ¯i v¾i møc tiêu: #G["..GameTools6_CurName.."]#W, thñc hi®n:\n#B"..tab1[5].."\n";
	for i,j in GameTools6_EditBoxTab do
		j:SetProperty("DefaultEditBox","False");
		GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cfff263P"..i
		if tab1[i] == "Không dùng" then
			j:SetText("Không dùng");
			j:Disable();
			GameTools6_EditBoxTabRed[i]:Show();
			GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cFF0000Không dùng\n";
		else
			j:SetText("");
			j:Enable();
			GameTools6_EditBoxTabRed[i]:Hide();
			GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#W"..tab1[i].."\n";
		end
	end
	GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#B"..tab1[4];
	GameTools6_SetTipBox(GameTools6_SelectProjectInfo)
end

function GameTools6_FrameClose()
	GameTools6_SelectBox:ResetList();
	GameTools6_CurName,GameTools6_CurGuid = "","";
	GameTools6_SelectObject = 1;
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	GameTools6_Info = {};
end
