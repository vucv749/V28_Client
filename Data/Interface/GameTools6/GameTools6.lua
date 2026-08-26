--ÓÎÏ·¹ÜÀíÔ±¹¤¾ßÖ÷½çÃæ
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
	
	--==========¶àÈË ¿ªÊ¼==========
	GameTools6_AllTab[1] = {"Quái v§t ID","Trß¶ng cänh v¸ trí","Bäng Ð¸nh k¸ch bän g¯c","Quái v§t ID=P1, quái v§t Bi¬u ID\\nquái v§t phß½ng hß¾ng =P2, Nhß cam ch¸u T¡c ðßa vào-1\\nBäng Ð¸nh k¸ch bän g¯c =P3k¸ch bän g¯c Hào, Nhß Vô k¸ch bän g¯c T¡c ðßa vào-1","Sáng tÕo quái v§t(quái v§t)"};
	GameTools6_AllTab[2] = {"Quái v§t ID","Trß¶ng cänh v¸ trí","Bäng Ð¸nh k¸ch bän g¯c","Quái v§t ID=P1, quái v§t Bi¬u ID\\nquái v§t phß½ng hß¾ng =P2, Nhß cam ch¸u T¡c ðßa vào-1\\nBäng Ð¸nh k¸ch bän g¯c =P3k¸ch bän g¯c Hào, Nhß Vô k¸ch bän g¯c T¡c ðßa vào-1","Sáng tÕo quái v§t(NPC)"};
	GameTools6_AllTab[3] = {"Quái v§t ID","Không có hi®u quä","Không có hi®u quä","Quái v§t ID=quái v§t Bi¬u ID\\nrØa sÕch trß¾c m£t trß¶ng cänh Thßþng t¤t cä Cai IDÐích sáng tÕo quái v§t Ho£c NPC","Xóa bö quái v§t"};
	GameTools6_AllTab[4] = {"K¸ch bän g¯c ID","Không có hi®u quä","Không có hi®u quä","K¸ch bän g¯c ID=sáu v¸ S± ID\\nTrùng Täi ý LUAk¸ch bän g¯c","Trùng Täi LUAk¸ch bän g¯c"};
	GameTools6_AllTab[5] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi toàn cøc k¸ch bän g¯c ScriptGlobal. Lua, sØa chæa Ðích hàm s¯ Hoà k¸ch bän g¯c l§p tÑc có hi®u lñc","Trùng Täi toàn cøc k¸ch bän g¯c"};
	GameTools6_AllTab[6] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi cØa hàng TXTvån ki®n\\nmµt l¥n næa Gia Täi vån ki®n, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi cØa hàng"};
	GameTools6_AllTab[7] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi Bµc Su¤t TXTvån ki®n\\nmµt l¥n næa Gia Täi vån ki®n, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi Bµc Su¤t"};
	GameTools6_AllTab[8] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi quái v§t TXTvån ki®n\\nmµt l¥n næa Gia Täi vån ki®n, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi quái v§t vån ki®n"};
	GameTools6_AllTab[9] = {"Hay không m· ra","Không có hi®u quä","Không có hi®u quä","Ti¬u LÕt Bát hay không m· ra sØ døng\\nm· ra Vi 0, ðóng cØa Vi 1","Ti¬u LÕt Bát hay không m· ra sØ døng"};
	GameTools6_AllTab[10] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi r½i xu¯ng thông cáo vån bän DropNotify. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi r½i xu¯ng thông cáo vån bän"};
	GameTools6_AllTab[11] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi EquipBase. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi trang b¸ vån ki®n"};
	GameTools6_AllTab[12] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi thü công ph¦m ch¤t phân b¯ Bi¬u/lúc ð¥u tr¸ s¯ ÐoÕn ð¯i Ñng vån ki®n ItemSegAffect. Txt ItemSegValue. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi trang b¸ thuµc tính vån ki®n"};
	GameTools6_AllTab[13] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi AllowableScriptFunc. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi k¸ch bän g¯c cho ði Bi¬u"};
	GameTools6_AllTab[14] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi CommonItem. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi v§t ph¦m Bi¬u"};
	GameTools6_AllTab[15] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi GemInfo. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi bäo thÕch Bi¬u"};
	GameTools6_AllTab[16] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi PetAttrTable. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi Trân Thú Bi¬u"};
	GameTools6_AllTab[17] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi MonsterAttrExTable. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi quái v§t Bi¬u"};
	GameTools6_AllTab[18] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi PetLingXing. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi linh tính Bi¬u"};
	GameTools6_AllTab[19] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trùng Täi PetHuanhuaTable. Txt, Ð¯i vån ki®n Ðích sØa chæa l§p tÑc có hi®u lñc","Trùng Täi biªn äo Bi¬u"};
	--==========¶àÈË ¿ªÊ¼==========
	
	--==========ËûÈË ¿ªÊ¼==========
	GameTools6_TarTab[1] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Xem xét møc tiêu Ðích vai di­n Ðích tài phú","Xem xét tài phú"};
	GameTools6_TarTab[2] = {"Hæu hi®u Ðích#Gv?t ph¦m ID","Cho vay Ðích#Gs lßþng","Không có hi®u quä","C¤p møc tiêu vai di­n duy nh¤t cho vay P2Cá P1","Cho vay v§t ph¦m"};
	GameTools6_TarTab[3] = {"Cho vay s¯ lßþng","Không có hi®u quä","Không có hi®u quä","C¤p møc tiêu vai di­n Phát P1Kim T®","Phát Kim T®"};
	GameTools6_TarTab[4] = {"Cho vay s¯ lßþng","Không có hi®u quä","Không có hi®u quä","C¤p møc tiêu vai di­n Phát P1Giao TØ","Phát Giao TØ"};
	GameTools6_TarTab[5] = {"Cho vay s¯ lßþng","Không có hi®u quä","Không có hi®u quä","C¤p møc tiêu vai di­n Phát P1nguyên bäo","Phát nguyên bäo"};
	GameTools6_TarTab[6] = {"Cho vay s¯ lßþng","Không có hi®u quä","Không có hi®u quä","C¤p møc tiêu vai di­n Phát P1Bäng Nguyên","Phát Bäng Nguyên"};
	GameTools6_TarTab[7] = {"MDðánh s¯[0-511]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra møc tiêu vai di­n P1Ðích MDTr¸","Tra MD"};
	GameTools6_TarTab[8] = {"EXðánh s¯[0-1535]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra møc tiêu vai di­n P1Ðích EXTr¸","Tra EX"};
	GameTools6_TarTab[9] = {"FLAGðánh s¯[0-319]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra møc tiêu vai di­n P1Ðích FLAGTr¸","Tra FLAG"};
	GameTools6_TarTab[10] = {"MDðánh s¯[0-511]","Thiªt trí giá tr¸","Không có hi®u quä","Thiªt trí møc tiêu vai di­n P1Ðích MDTr¸","Thiªt MD"};
	GameTools6_TarTab[11] = {"EXðánh s¯[0-1535]","Thiªt trí giá tr¸","Không có hi®u quä","Thiªt trí møc tiêu vai di­n P1Ðích EXTr¸","Thiªt EX"};
	GameTools6_TarTab[12] = {"FLAGðánh s¯[0-319]","Thiªt trí giá tr¸[0-1]","Không có hi®u quä","Thiªt trí møc tiêu vai di­n P1Ðích FLAGTr¸","Thiªt FLAG"};
	GameTools6_TarTab[13] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Thiªt trí ngß¶i ch½i có ðßþc siêu c¤p BTthuµc tính","GMsiêu c¤p thuµc tính"};
	GameTools6_TarTab[14] = {"P1Trân Thú ID","P2Ngû Duy tß ch¤t","P3l¾n d¥n Su¤t","Lña ch÷n H§u Ði¬m Kích xác ð¸nh","Lînh süng v§t"};
	GameTools6_TarTab[15] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Tu¥n tra trên ngß¶i t¤t cä BUFF","Tra BUFF"};
	GameTools6_TarTab[16] = {"P1tång lên c¤p b§c","Không có hi®u quä","Không có hi®u quä","Tång lên ngß¶i ch½i c¤p b§c(chï có th¬ tång lên, không th¬ r½i ch§m lÕi)","Tång lên c¤p b§c"};
	--==========ËûÈË ½áÊø==========
	
	--==========×Ô¼º ¿ªÊ¼==========
	GameTools6_SelfTab[1] = {"Hæu hi®u Ðích#Gv?t ph¦m ID","Lînh Ðích#Gs lßþng","Không có hi®u quä","Duy nh¤t lînh P2Cá P1","Lînh v§t ph¦m"};
	GameTools6_SelfTab[2] = {"Tay nãi Ho£c trang b¸ Cách V¸#G[0-59]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra P1v¸ trí Thßþng Ðích tñ phù tin tÑc","Tra v§t ph¦m tñ phù tin tÑc"};
	GameTools6_SelfTab[3] = {"Lúc ð¥u Cách V¸#G[0-89]","Kªt thúc Cách V¸#G[0-89]","Không có hi®u quä","RØa sÕch tay nãi P1-P2Cách V¸ Thßþng Ðích v§t ph¦m","Thanh tay nãi"};
	GameTools6_SelfTab[4] = {"Lînh s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Lînh Kim T® S± =P1","Lãnh Kim T®"};
	GameTools6_SelfTab[5] = {"Kh¤u tr× s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Kh¤u tr× Kim T® S± =P1, Ðang trên ngß¶i Kim T® nhö P1Th¶i T¡c Bä trên ngß¶i Kim T® toàn bµ kh¤u tr×","Kh¤u Kim T®"};
	GameTools6_SelfTab[6] = {"Lînh s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Lînh Giao TØ S± =P1","Lãnh Giao TØ"};
	GameTools6_SelfTab[7] = {"Kh¤u tr× s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Kh¤u tr× Giao TØ S± =P1, Ðang trên ngß¶i Giao TØ nhö P1Th¶i T¡c Bä trên ngß¶i Giao TØ toàn bµ kh¤u tr×","Kh¤u Giao TØ"};
	GameTools6_SelfTab[8] = {"Lînh s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Lînh nguyên bäo S± =P1","Lãnh nguyên bäo"};
	GameTools6_SelfTab[9] = {"Kh¤u tr× s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Kh¤u tr× nguyên bäo S± =P1, Ðang trên ngß¶i nguyên bäo nhö P1Th¶i T¡c Bä trên ngß¶i nguyên bäo toàn bµ kh¤u tr×","Kh¤u nguyên bäo"};
	GameTools6_SelfTab[10] = {"Lînh s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Lînh Bäng Nguyên S± =P1","Lãnh Bäng Nguyên"};
	GameTools6_SelfTab[11] = {"Kh¤u tr× s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Kh¤u tr× Bäng Nguyên S± =P1, Ðang trên ngß¶i Bäng Nguyên nhö P1Th¶i T¡c Bä trên ngß¶i Bäng Nguyên toàn bµ kh¤u tr×","Kh¤u Bäng Nguyên"};
	GameTools6_SelfTab[12] = {"Lînh s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Lînh kinh nghi®m S± =P1","Lãnh kinh nghi®m"};
	GameTools6_SelfTab[13] = {"Kh¤u tr× s¯ lßþng","Không có hi®u quä","Không có hi®u quä","Kh¤u tr× kinh nghi®m S± =P1, Ðang trên ngß¶i kinh nghi®m nhö P1Th¶i T¡c Bä trên ngß¶i kinh nghi®m toàn bµ kh¤u tr×","Kh¤u kinh nghi®m"};
	GameTools6_SelfTab[14] = {"C¤p b§c S±[1-119]","Không có hi®u quä","Không có hi®u quä","C¤p b§c =P1","Thiªt trí c¤p b§c"};
	GameTools6_SelfTab[15] = {"Môn phái Hào[0-8]","Không có hi®u quä","Không có hi®u quä","Không cØa Phái Th¶i gia nh§p môn phái =P1","Gia nh§p môn phái"};
	GameTools6_SelfTab[16] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Tß¾ng b±n môn Phái V¸ H÷c Ðích tâm pháp H÷c T§p","H÷c tâm pháp"};
	GameTools6_SelfTab[17] = {"Tâm pháp c¤p b§c[1-119]","Không có hi®u quä","Không có hi®u quä","Tß¾ng b±n môn Phái Dî h÷c ðßþc Ðích tâm pháp c¤p b§c =P1","Thiªt trí tâm pháp c¤p b§c"};
	GameTools6_SelfTab[18] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Tu¥n tra trên ngß¶i t¤t cä BUFF","Tra BUFF"};
	GameTools6_SelfTab[19] = {"MDðánh s¯[0-511]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra P1Ðích MDTr¸","Tra MD"};
	GameTools6_SelfTab[20] = {"EXðánh s¯[0-1535]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra P1Ðích EXTr¸","Tra EX"};
	GameTools6_SelfTab[21] = {"FLAGðánh s¯[0-319]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra P1Ðích FLAGTr¸","Tra FLAG"};
	GameTools6_SelfTab[22] = {"WORLDðánh s¯[1-100]","Không có hi®u quä","Không có hi®u quä","Tu¥n tra P1Ðích WORLDTr¸","Tra WORLD"};
	GameTools6_SelfTab[23] = {"KÛ nång ðánh s¯","Không có hi®u quä","Không có hi®u quä","H÷c T§p kÛ nång ðánh s¯ =P1","KÛ nång h÷c t§p"};
	GameTools6_SelfTab[24] = {"KÛ nång ðánh s¯","Không có hi®u quä","Không có hi®u quä","Xóa bö kÛ nång ðánh s¯ =P1","Xóa bö kÛ nång"};
	GameTools6_SelfTab[25] = {"BUFFID","Không có hi®u quä","Không có hi®u quä","Giao cho BUFF=P1","Gia BUFF"};
	GameTools6_SelfTab[26] = {"BUFFID","Không có hi®u quä","Không có hi®u quä","Xóa bö BUFF=P1","San BUFF"};
	GameTools6_SelfTab[27] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Trß¾c m£t trß¶ng cänh s¯ li®u","Tra trß¶ng cänh s¯ li®u"};
	GameTools6_SelfTab[28] = {"Trß¶ng cänh ID","V¸ trí X","V¸ trí Z","Truy«n t¯ng trình di®n Cänh P1[P2, P3]v¸ trí XØ","Hoán trß¶ng cänh"};
	GameTools6_SelfTab[29] = {"MDðánh s¯[0-511]","Thiªt trí giá tr¸","Không có hi®u quä","Thiªt trí P1Ðích MDTr¸","Thiªt MD"};
	GameTools6_SelfTab[30] = {"EXðánh s¯[0-1535]","Thiªt trí giá tr¸","Không có hi®u quä","Thiªt trí P1Ðích EXTr¸","Thiªt EX"};
	GameTools6_SelfTab[31] = {"FLAGðánh s¯[0-319]","Thiªt trí giá tr¸[0-1]","Không có hi®u quä","Thiªt trí P1Ðích FLAGTr¸","Thiªt FLAG"};
	GameTools6_SelfTab[32] = {"WORLDðánh s¯[1-100]","Thiªt trí giá tr¸","Không có hi®u quä","Thiªt trí P1Ðích WORLDTr¸","Thiªt WORLD"};
	GameTools6_SelfTab[33] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Thiªt trí ngß¶i ch½i có ðßþc siêu c¤p BTthuµc tính","GMsiêu c¤p thuµc tính"};
	GameTools6_SelfTab[34] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Lña ch÷n H§u Ði¬m Kích xác ð¸nh","Thu hoÕch GMtrÕng thái"};
	GameTools6_SelfTab[35] = {"P1Trân Thú ID","P2Ngû Duy tß ch¤t","P3l¾n d¥n Su¤t","Lña ch÷n H§u Ði¬m Kích xác ð¸nh","Lînh süng v§t"};
	GameTools6_SelfTab[36] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Lña ch÷n H§u Ði¬m Kích xác ð¸nh","Tr¸ li®u Huyªt Lam Khí Nµ"};
	GameTools6_SelfTab[37] = {"Không có hi®u quä","Không có hi®u quä","Không có hi®u quä","Lña ch÷n H§u Ði¬m Kích xác ð¸nh","Thanh Không vai di­n toàn bµ kÛ nång làm lÕnh"};
	--==========×Ô¼º ½áÊø==========
	
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
--´ò¿ªÎïÆ·ËÑË÷½çÃæ
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
	PushDebugMessage("ThØ hÕng møc sØa chæa Th¶i m· ra Ðích")
end

function GameTools6_ClientCallTwo()
	-- PushEvent("UI_COMMAND",426022021);
	PushDebugMessage("ThØ hÕng møc sØa chæa Th¶i m· ra Ðích")
end

function GameTools6_Use_Clicked()
	if GameTools6_SelectProjectIdx < 1 then
		PushDebugMessage("Thïnh lña ch÷n thao tác hÕng møc")
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
		if tab1[i] ~= "Không có hi®u quä" then
			int1 = tonumber(j:GetText());
			if not int1 then
				msg = "P"..i.."Ðßa vào b¤t chính Xác, Thïnh ki¬m tra."
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
			PushDebugMessage("Thïnh ðßa vào vai di­n Danh")
			return
		elseif int1 > 12 then
			PushDebugMessage("Cai vai di­n Danh phi pháp, Nhß møc tiêu xác nh§n là nên tên cüa, Thïnh mau chóng Døng s¯ hi®u ch¤p hành Âu tiªn hành phong hào")
			return
		elseif int2 ~= 7 then
			PushDebugMessage("Thïnh ðßa vào 16Tiªn GUID");
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
		GameTools6_CurName = "T¤t cä TÕi Tuyªn vai di­n";
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
			str0 = string.format("#BtÅng thêm møc tiêu thành công. \\nvai di­n Danh[%s]\\nGUID[%s]\\nxác nh§n không có l¥m H§u Khä lña ch÷n hÕng møc Ð¯i Cai møc tiêu tiªn hành thao tác.",GameTools6_CurName,GameTools6_CurGuid)
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
		GameTools6_SelectBox:SetText("Lña ch÷n s¡p sØa thao tác Ðích hÕng møc")
		GameTools6_SelectBox:ResetList();
		for i,j in tab1 do
			if i < 10 then
				GameTools6_SelectBox:AddTextItem("["..i.."] ?"..j[5].."?",i);
			elseif i < 100 then
				GameTools6_SelectBox:AddTextItem("["..i.."] ?"..j[5].."?",i);
			else
				GameTools6_SelectBox:AddTextItem("["..i.."] ?"..j[5].."?",i);
			end
		end
	else
		str0 = "#Bt¹ ðµng thu hoÕch tin tÑc: Lña ch÷n møc tiêu(không có tñ ðµng bö thêm vào trong l¶i nói c¡t HÕ møc tiêu có th¬)Ho£c ðàm ðÕo Song xem xét ngß¶i khác vai di­n tß li®u Khä tñ ðµng bö thêm vào ðßa vào\\nðßa vào tin tÑc: P1ðßa vào vai di­n Danh, P2ðßa vào vai di­n Ðích GUID"
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
		GameTools6_SelectBox:SetText("Thïnh Tiên tång thêm møc tiêu")
		GameTools6_SelectBox:ResetList();
	end
	GameTools6_SelectProjectIdx,GameTools6_SelectProjectInfo = -1,"";
	local str1 = GameTools6_CurName ~= "" and "#G"..GameTools6_CurName or "#cff0000chßa tång thêm møc tiêu";
	local str2 = "#cFF00FFmøc tiêu:"..str1;
	local str3 = GameTools6_CurGuid ~= "" and str2.."|"..GameTools6_CurGuid.."#cff0000(tr÷ng yªu)" or str2.."#cff0000(tr÷ng yªu)";
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
		GameTools6_SetTipBox(GameTools6_SelectProjectInfo.."\\n=====thao tác kªt quä =====\\n"..str1);
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
	GameTools6_SelectProjectInfo = "#WÐi møc tiêu: #G["..GameTools6_CurName.."]#WtIªn hành\\n#B?"..tab1[5].."#B?\\n";
	for i,j in GameTools6_EditBoxTab do
		j:SetProperty("DefaultEditBox","False");
		GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cfff263P"..i
		if tab1[i] == "Không có hi®u quä" then
			j:SetText("Không có hi®u quä");
			j:Disable();
			GameTools6_EditBoxTabRed[i]:Show();
			GameTools6_SelectProjectInfo = GameTools6_SelectProjectInfo.."#cFF0000không có hi®u quä\\n";
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
