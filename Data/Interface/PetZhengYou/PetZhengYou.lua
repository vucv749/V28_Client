
local cooldownTime = 15*1000;		--???????
local pageCoolDownTime = 5*1000;	--??????,??????
local PET_AITYPE = {};
local FlashTextHeader = "#ecc33cc#cffcccc";		--??????????????
local showWindowFlag = false;
local listflag = 0;
local showPrevPage = true;
local showNextPage = true;

local g_PetZhengYou_Frame_UnifiedPosition;

function PetZhengYou_PreLoad()
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end


function PetZhengYou_OnLoad()
	PET_AITYPE[0] = "#gFF0FA0nhát gan";
	PET_AITYPE[1] = "#gFF0FA0c¦n th§n";
	PET_AITYPE[2] = "#gFF0FA0trung thành";
	PET_AITYPE[3] = "#gFF0FA0khôn khéo";
	PET_AITYPE[4] = "#gFF0FA0dûng mãnh";
	
	 g_PetZhengYou_Frame_UnifiedPosition=PetZhengYou_Frame:GetProperty("UnifiedPosition");
	 
end

function PetZhengYou_Hide()
	this:Hide();
end

function PetZhengYou_OnEvent(event)
	if(event == "UPDATE_PETINVITEFRIEND") then
		if("notifypetlist" == arg0) then
			PetZhengYou_ShowWindow(listflag);
		elseif("searchlist" == arg0 or "searchlistbegin" == arg0) then
			this:Hide();
		elseif("noprevpage" == arg0) then
			showPrevPage = false;
			PetZhengYou_PageUp:Disable();
			PushDebugMessage("Ðã Th¸ thÑ nh¤t Di®p Li­u");
		elseif("notifypetlistnone" == arg0) then
			if listflag == -1 then
				showPrevPage = false;
				PetZhengYou_PageUp:Disable();
				PushDebugMessage("Ðã Th¸ thÑ nh¤t Di®p Li­u");
			elseif listflag == 1 then
				showNextPage = false;
				PetZhengYou_PageDown:Disable();
				PushDebugMessage("Ðã Th¸ cu¯i cùng mµt t¶ Li­u");
			else
				PetZhengYou_ShowWindow(-2);
			end
		end

	elseif ( event == "OPEN_WINDOW") then
		if( arg0 == "Show_Pet_Friends") then
			if(this:IsVisible()) then
				this:Hide();
			else
				PetInviteFriend:ShowPetFriends(0);
				listflag = 0;
			end
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetZhengYou_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetZhengYou_Frame_On_ResetPos()
		
	end
end
--Ê µ½WorldµÄÊý¾Ýºóµ÷ÓÃÏÔÊ¾½çÃæ
local needEnable = false;
function PetZhengYou_ShowWindow(who)
	local num = PetInviteFriend:GetInviteNum("friends")
	if who == -2 then
		PetZhengYou_DisableAllWindow();
		this:Show();
		needEnable = true;
		return;
	end
	if needEnable then
		PetZhengYou_EnableAllWindow();
		needEnable = false;
	end
	if( num <= 0) then
		if who == -1 then
			PushDebugMessage("Phøc vø Khí Thßþng không có Trân Thú Chinh Hæu Ðích s¯ li®u");
			showPrevPage = false;
		elseif who == 1 then
			PushDebugMessage("Phøc vø Khí Thßþng không có Trân Thú Chinh Hæu Ðích s¯ li®u");
			showNextPage = false;
		else
			PetZhengYou_DisableAllWindow();
			showWindowFlag = true;
			this:Show();
		end
		return;
	else
		showNextPage = true;
		showPrevPage = true;
	end
	if who == 0 then
		showPrevPage = false;
	end
	if num <= 1 then
		showNextPage = false;
	end
	PetZhengYou_Clear_All();
	for i=1, num do
		PetZhengYou_Update(i);
	end
	if( num == 1 ) then
		PetZhengYou_DisableButton(1);
		PetZhengYou_HideWindow(1);
	end
	if showNextPage then
		PetZhengYou_PageDown:Enable();
	end
	if showPrevPage then
		PetZhengYou_PageUp:Enable();
	end
	this:Show();
end

function PetZhengYou_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	idx = idx + 2;

	--»ñÈ¡ äÊÞÖ÷ÈËÐÅÏ¢
	local humanName = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local humanMenPai = PetInviteFriend:GetHumanINFO(idx, "MENPAI");
	local humanLevel = PetInviteFriend:GetHumanINFO(idx, "LEVEL");
	local humanSex  = PetInviteFriend:GetHumanINFO(idx, "SEX");
	humanMenPai = PetZhengYou_ConvertNumToMenPai(humanMenPai);
	if( humanSex == 0 ) then
		humanSex = "Næ";
	else
		humanSex = "Nam";
	end

	--»ñÈ¡ äÊÞÐÅÏ¢
	local petName = PetInviteFriend:GetPetINFO(idx, "NAME");
	local petGrow = PetInviteFriend:GetPetINFO(idx, "GROW");
	local petLevel = PetInviteFriend:GetPetINFO(idx, "LEVEL");
	local petSex  = PetInviteFriend:GetPetINFO(idx, "SEX");
	local petAI   = PetInviteFriend:GetPetINFO(idx, "AITYPE");
	local petTypeName = PetInviteFriend:GetPetINFO(idx, "TYPENAME");
	petTypeName = FlashTextHeader .. petTypeName .. "Cøc cßng";
	if( petSex == 0 ) then
		petSex = "Thß";
	else
		petSex = "Hùng";
	end
	local strTbl = {"S½ C¤p","Xu¤t S¡c","Ki®t Xu¤t","Trác Vi®t","Toàn MÛ"};

	if(petGrow >= 0) then
		petGrow = petGrow + 1;	--c???0?????
		if(strTbl[petGrow]) then
			petGrow = strTbl[petGrow];
		else
			petGrow = "Không biªt";
		end
	else
		petGrow = "Không biªt";
	end

	if(petAI>4 or petAI <0) then
		petAI = "Sai l¥m Ðích";
	else
		petAI =	PET_AITYPE[petAI];
	end
	--PushDebugMessage("idx = " .. tostring(idx));
	--PushDebugMessage(humanName);

	if( idx == 3 ) then
	  --ÉèÖÃ äÊÞÐÅÏ¢
		PetZhengYou_Master1Pet_NameInfo:SetText(petName);
		PetZhengYou_Master1Pet_GenderInfo:SetText(petSex);
		PetZhengYou_Master1Pet_ChenZhangInfo:SetText(petGrow);
		PetZhengYou_Master1Pet_LevelInfo:SetText(petLevel);
		PetZhengYou_Type1:SetText(petAI);
		PetZhengYou_Flash_Name1:SetText(petTypeName);

		--ÉèÖÃÖ÷ÈËÐÅÏ¢
		PetZhengYou_Master1_NameInfo:SetText(humanName);
		PetZhengYou_Master1_LevelInfo:SetText(humanLevel);
		PetZhengYou_Master1_ManPaiInfo:SetText(humanMenPai);
		PetZhengYou_Master1_GenderInfo:SetText(humanSex);

		--ÉèÖÃÄ£ÐÍÐÅÏ¢
		PetInviteFriend:SetPetModel(idx);
		PetZhengYou_PetModel1:SetFakeObject("My_PetFriend01");

		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_PetModel1_TurnRight:Enable();
		PetZhengYou_PetModel1_TurnLeft:Enable();


	elseif( idx == 4 ) then
	  --ÉèÖÃ äÊÞÐÅÏ¢
		PetZhengYou_Master2Pet_NameInfo:SetText(petName);
		PetZhengYou_Master2Pet_GenderInfo:SetText(petSex);
		PetZhengYou_Master2Pet_ChenZhangInfo:SetText(petGrow);
		PetZhengYou_Master2Pet_LevelInfo:SetText(petLevel);
		PetZhengYou_Type2:SetText(petAI);
		PetZhengYou_Flash_Name2:SetText(petTypeName);

		--ÉèÖÃÖ÷ÈËÐÅÏ¢
		PetZhengYou_Master2_NameInfo:SetText(humanName);
		PetZhengYou_Master2_LevelInfo:SetText(humanLevel);
		PetZhengYou_Master2_ManPaiInfo:SetText(humanMenPai);
		PetZhengYou_Master2_GenderInfo:SetText(humanSex);

		--ÉèÖÃÄ£ÐÍÐÅÏ¢
		PetInviteFriend:SetPetModel(idx);
		PetZhengYou_PetModel2:SetFakeObject("My_PetFriend02");

		--¼¤»î°´Å¥
		PetZhengYou_Pet2_Investigate:Enable();
		PetZhengYou_Pet2_Acquaintance:Enable();
		PetZhengYou_PetModel2_TurnRight:Enable();
		PetZhengYou_PetModel2_TurnLeft:Enable();


		--ÏÔÊ¾ÎÄ±¾
		PetZhengYou_Master2Pet_Name:Show();
		PetZhengYou_Master2Pet_Gender:Show();
		PetZhengYou_Master2Pet_ChenZhang:Show();
		PetZhengYou_Master2Pet_Level:Show();
		PetZhengYou_Master2_Name:Show();
		PetZhengYou_Master2_Level:Show();
		PetZhengYou_Master2_ManPai:Show();
		PetZhengYou_Master2_Gender:Show();
		PetZhengYou_Master2Pet_NameInfo:Show();
		PetZhengYou_Master2Pet_GenderInfo:Show();
		PetZhengYou_Master2Pet_ChenZhangInfo:Show();
		PetZhengYou_Master2Pet_LevelInfo:Show();
		PetZhengYou_Master2_NameInfo:Show();
		PetZhengYou_Master2_LevelInfo:Show();
		PetZhengYou_Master2_ManPaiInfo:Show();
		PetZhengYou_Master2_GenderInfo:Show();
		PetZhengYou_Master2Info2:Show();
		PetZhengYou_Type2:Show();
		PetZhengYou_Flash_Name2:Show();
	end

end

--Òþ²ØÒ»Ð© ´°¿Ú
function PetZhengYou_HideWindow(idx)
	if( idx == 0 ) then
		PetZhengYou_Master1Pet_Name:Hide();
		PetZhengYou_Master1Pet_Gender:Hide();
		PetZhengYou_Master1Pet_ChenZhang:Hide();
		PetZhengYou_Master1Pet_Level:Hide();
		PetZhengYou_Master1_Name:Hide();
		PetZhengYou_Master1_Level:Hide();
		PetZhengYou_Master1_ManPai:Hide();
		PetZhengYou_Master1_Gender:Hide();
	else
		PetZhengYou_Master2Pet_Name:Hide();
		PetZhengYou_Master2Pet_Gender:Hide();
		PetZhengYou_Master2Pet_ChenZhang:Hide();
		PetZhengYou_Master2Pet_Level:Hide();
		PetZhengYou_Master2_Name:Hide();
		PetZhengYou_Master2_Level:Hide();
		PetZhengYou_Master2_ManPai:Hide();
		PetZhengYou_Master2_Gender:Hide();
		PetZhengYou_Master2Pet_NameInfo:Hide();
		PetZhengYou_Master2Pet_GenderInfo:Hide();
		PetZhengYou_Master2Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master2Pet_LevelInfo:Hide();
		PetZhengYou_Master2_NameInfo:Hide();
		PetZhengYou_Master2_LevelInfo:Hide();
		PetZhengYou_Master2_ManPaiInfo:Hide();
		PetZhengYou_Master2_GenderInfo:Hide();
		PetZhengYou_Master2Info2:Hide();
		PetZhengYou_Type2:Hide();
		PetZhengYou_Flash_Name2:Hide();
	end
end

--½ûÓÃÒ»Ð©°´Å¥
function PetZhengYou_DisableButton(idx)
	if( idx == 0 ) then
		PetZhengYou_Pet1_Investigate:Disable();
		PetZhengYou_Pet1_Acquaintance:Disable();
		PetZhengYou_PetModel1_TurnRight:Disable();
		PetZhengYou_PetModel1_TurnLeft:Disable();
	else
		PetZhengYou_Pet2_Investigate:Disable();
		PetZhengYou_Pet2_Acquaintance:Disable();
		PetZhengYou_PetModel2_TurnRight:Disable();
		PetZhengYou_PetModel2_TurnLeft:Disable();

	end
end


function PetZhengYou_Clear_All()

		if showWindowFlag then
			PetZhengYou_EnableAllWindow();
			showWindowFlag = false;
		end
		PetZhengYou_DisableButton(1);
		PetZhengYou_HideWindow(1);
		PetZhengYou_PetModel1:SetFakeObject("");
		PetZhengYou_PetModel2:SetFakeObject("");
		if( Pet:GetPet_Count() == 0 ) then
			PetZhengYou_Search:Disable();
		else
			PetZhengYou_Search:Enable();
		end
		PetZhengYou_PageDown:Disable();
		PetZhengYou_PageUp:Disable();
	--end
end


function PetZhengYou_ShowTargetFrame(who)
	PetInviteFriend:ShowTargetPet(who);
end

function PetZhengYou_ConvertNumToMenPai( MenPaiId )
	local strMenPai = "???";
	-- µÃµ½ÃÅÅÉÃû³Æ.
	if(0 == MenPaiId) then
		strMenPai = "Thiªu Lâm";

	elseif(1 == MenPaiId) then
		strMenPai = "Minh Giáo";

	elseif(2 == MenPaiId) then
		strMenPai = "Cái Bang";

	elseif(3 == MenPaiId) then
		strMenPai = "Võ Ðang";

	elseif(4 == MenPaiId) then
		strMenPai = "Nga Mi";

	elseif(5 == MenPaiId) then
		strMenPai = "Tinh Túc";

	elseif(6 == MenPaiId) then
		strMenPai = "Thiên Long";

	elseif(7 == MenPaiId) then
		strMenPai = "Thiên S½n";

	elseif(8 == MenPaiId) then
		strMenPai = "Tiêu dao";

	elseif(9 == MenPaiId) then
		strMenPai = "Tñ do";

	elseif(10== MenPaiId) then
		strMenPai = "MÕn Ðà S½n Trang";

	end

	return strMenPai;
end
----------------------------------------------------------------------------------
--
-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
--
function PetZhengYou_Modle_TurnLeft(modelIdx,start)

		if( modelIdx == 3 ) then
		--Ïò×óÐý×ª¿ªÊ¼
			if(start == 1) then
				PetZhengYou_PetModel1:RotateBegin(-0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetZhengYou_PetModel1 :RotateEnd();
			end
		end
		if( modelIdx == 4 ) then
			if(start == 1) then
				PetZhengYou_PetModel2:RotateBegin(-0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetZhengYou_PetModel2 :RotateEnd();
			end
	 end
end

----------------------------------------------------------------------------------
--
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function PetZhengYou_Modle_TurnRight(modelIdx, start)
	if( modelIdx == 3 ) then
		--Ïò×óÐý×ª¿ªÊ¼
			if(start == 1) then
				PetZhengYou_PetModel1:RotateBegin(0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetZhengYou_PetModel1 :RotateEnd();
			end
	elseif( modelIdx == 4 ) then
			if(start == 1) then
				PetZhengYou_PetModel2:RotateBegin(0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetZhengYou_PetModel2 :RotateEnd();
			end
	end
end

--²éÑ¯ÉÏÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetZhengYou_PrevPage()
	listflag = -1;
	PetInviteFriend:ShowPetFriends(-1);
	PetZhengYou_PageUp:Disable();
	if showPrevPage then
		SetTimer("PetZhengYou","PetZhengYou_CoolPageUp();", pageCoolDownTime);
	end
end

function PetZhengYou_CoolPageUp()
	if showPrevPage then
		PetZhengYou_PageUp:Enable();
	else
		PetZhengYou_PageUp:Disable();
	end
	KillTimer("PetZhengYou_CoolPageUp();");
end


--²éÑ¯ÏÂÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetZhengYou_NextPage()
	listflag = 1;
	PetInviteFriend:ShowPetFriends(1);
	PetZhengYou_PageDown:Disable();
	if showNextPage then
		SetTimer("PetZhengYou","PetZhengYou_CoolPageDown();", pageCoolDownTime);
	end
end

function PetZhengYou_CoolPageDown()
	if showNextPage then
		PetZhengYou_PageDown:Enable();
	else
		PetZhengYou_PageDown:Disable();
	end
	KillTimer("PetZhengYou_CoolPageDown();");
end


--¸ø äÊÞÖ÷ÈË·¢ÓÊ¼þ£¬ËµÃ÷Ïë ÷ÓÑ
function PetZhengYou_SendMail( idx )
	if( idx == 3 or idx == 4 ) then
		local owner = PetInviteFriend:GetHumanINFO(idx, "NAME");
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("Không th¬ Hoà chính mình Ðích Trân Thú kªt các\\u0020hÕ");
			return;
		end
			--¸ø¸Ã äÊÞÖ÷ÈË·¢ËÍÓÊ¼þ¸æËßËûËýÄãµÄ äÊÞÏëºÍËûËýµÄ äÊÞ½áÊ¶
		DataPool:OpenMail( owner,"Ta nghî kªt các\\u0020hÕ cüa ngß½i cøc cßng" );
	end

	if( idx == 3 ) then
		SetTimer("PetZhengYou","PetZhengYou_CoolDown3();" ,cooldownTime);
		PetZhengYou_Pet1_Acquaintance:Disable();
	elseif(idx == 4 ) then
		SetTimer("PetZhengYou","PetZhengYou_CoolDown4();" ,cooldownTime);
		PetZhengYou_Pet2_Acquaintance:Disable();
	end
end

function PetZhengYou_CoolDown3()
		PetZhengYou_Pet1_Acquaintance:Enable();
		KillTimer("PetZhengYou_CoolDown3();");
end
function PetZhengYou_CoolDown4()
		PetZhengYou_Pet2_Acquaintance:Enable();
		KillTimer("PetZhengYou_CoolDown4();");
end

--ËÑË÷ºÏÊÊ äÊÞ
function PetZhengYou_OnSearch()
	Pet:ShowPetList(1);
	--this:Hide();
end

-- â¸öº¯ÊýÐ´µÄºÜÎÞÄÎÑ½£¡£¬´°¿ÚÃ»ÓÐÉè¼ÆºÃ£¬Èç¹ûÓÐ¸ö¸¸´°¿Ú£¬¾ÍºÃÁË
function PetZhengYou_DisableAllWindow()
		PetZhengYou_Master1Pet_Name:Hide();
		PetZhengYou_Master1Pet_Gender:Hide();
		PetZhengYou_Master1Pet_ChenZhang:Hide();
		PetZhengYou_Master1Pet_Level:Hide();
		PetZhengYou_Master1_Name:Hide();
		PetZhengYou_Master1_Level:Hide();
		PetZhengYou_Master1_ManPai:Hide();
		PetZhengYou_Master1_Gender:Hide();
		PetZhengYou_Master1Pet_NameInfo:Hide();
		PetZhengYou_Master1Pet_GenderInfo:Hide();
		PetZhengYou_Master1Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master1Pet_LevelInfo:Hide();
		PetZhengYou_Master1_NameInfo:Hide();
		PetZhengYou_Master1_LevelInfo:Hide();
		PetZhengYou_Master1_ManPaiInfo:Hide();
		PetZhengYou_Master1_GenderInfo:Hide();
		PetZhengYou_Master1Info:Hide();
		PetZhengYou_Type1:Hide();
		PetZhengYou_Flash_Name1:Hide();

		PetZhengYou_Master2Pet_Name:Hide();
		PetZhengYou_Master2Pet_Gender:Hide();
		PetZhengYou_Master2Pet_ChenZhang:Hide();
		PetZhengYou_Master2Pet_Level:Hide();
		PetZhengYou_Master2_Name:Hide();
		PetZhengYou_Master2_Level:Hide();
		PetZhengYou_Master2_ManPai:Hide();
		PetZhengYou_Master2_Gender:Hide();
		PetZhengYou_Master2Pet_NameInfo:Hide();
		PetZhengYou_Master2Pet_GenderInfo:Hide();
		PetZhengYou_Master2Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master2Pet_LevelInfo:Hide();
		PetZhengYou_Master2_NameInfo:Hide();
		PetZhengYou_Master2_LevelInfo:Hide();
		PetZhengYou_Master2_ManPaiInfo:Hide();
		PetZhengYou_Master2_GenderInfo:Hide();
		PetZhengYou_Master2Info2:Hide();
		PetZhengYou_Type2:Hide();
		PetZhengYou_Flash_Name2:Hide();

		PetZhengYou_Pet1_Investigate:Disable();
		PetZhengYou_Pet1_Acquaintance:Disable();
		PetZhengYou_PetModel1_TurnRight:Disable();
		PetZhengYou_PetModel1_TurnLeft:Disable();
		PetZhengYou_Pet2_Investigate:Disable();
		PetZhengYou_Pet2_Acquaintance:Disable();
		PetZhengYou_PetModel2_TurnRight:Disable();
		PetZhengYou_PetModel2_TurnLeft:Disable();
		PetZhengYou_PageDown:Disable();
		PetZhengYou_PageUp:Disable();
		PetZhengYou_Search:Disable();
		PetZhengYou_PetModel1:SetFakeObject("");
		PetZhengYou_PetModel2:SetFakeObject("");
end

-- â¸öº¯ÊýÐ´µÄºÜÎÞÄÎÑ½£¡£¬´°¿ÚÃ»ÓÐÉè¼ÆºÃ£¬Èç¹ûÓÐ¸ö¸¸´°¿Ú£¬¾ÍºÃÁË
function PetZhengYou_EnableAllWindow()
		PetZhengYou_Master1Pet_Name:Show();
		PetZhengYou_Master1Pet_Gender:Show();
		PetZhengYou_Master1Pet_ChenZhang:Show();
		PetZhengYou_Master1Pet_Level:Show();
		PetZhengYou_Master1_Name:Show();
		PetZhengYou_Master1_Level:Show();
		PetZhengYou_Master1_ManPai:Show();
		PetZhengYou_Master1_Gender:Show();
		PetZhengYou_Master1Pet_NameInfo:Show();
		PetZhengYou_Master1Pet_GenderInfo:Show();
		PetZhengYou_Master1Pet_ChenZhangInfo:Show();
		PetZhengYou_Master1Pet_LevelInfo:Show();
		PetZhengYou_Master1_NameInfo:Show();
		PetZhengYou_Master1_LevelInfo:Show();
		PetZhengYou_Master1_ManPaiInfo:Show();
		PetZhengYou_Master1_GenderInfo:Show();
		PetZhengYou_Master1Info:Show();
		PetZhengYou_Type1:Show();
		PetZhengYou_Flash_Name1:Show();

		PetZhengYou_Master2Pet_Name:Show();
		PetZhengYou_Master2Pet_Gender:Show();
		PetZhengYou_Master2Pet_ChenZhang:Show();
		PetZhengYou_Master2Pet_Level:Show();
		PetZhengYou_Master2_Name:Show();
		PetZhengYou_Master2_Level:Show();
		PetZhengYou_Master2_ManPai:Show();
		PetZhengYou_Master2_Gender:Show();
		PetZhengYou_Master2Pet_NameInfo:Show();
		PetZhengYou_Master2Pet_GenderInfo:Show();
		PetZhengYou_Master2Pet_ChenZhangInfo:Show();
		PetZhengYou_Master2Pet_LevelInfo:Show();
		PetZhengYou_Master2_NameInfo:Show();
		PetZhengYou_Master2_LevelInfo:Show();
		PetZhengYou_Master2_ManPaiInfo:Show();
		PetZhengYou_Master2_GenderInfo:Show();
		PetZhengYou_Master2Info2:Show();
		PetZhengYou_Type2:Show();
		PetZhengYou_Flash_Name2:Show();

		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_Pet1_Acquaintance:Enable();
		PetZhengYou_PetModel1_TurnRight:Enable();
		PetZhengYou_PetModel1_TurnLeft:Enable();
		PetZhengYou_Pet2_Investigate:Enable();
		PetZhengYou_Pet2_Acquaintance:Enable();
		PetZhengYou_PetModel2_TurnRight:Enable();
		PetZhengYou_PetModel2_TurnLeft:Enable();
		PetZhengYou_PageDown:Enable();
		PetZhengYou_PageUp:Enable();
		PetZhengYou_Search:Enable();
end

function PetZhengYou_Frame_On_ResetPos()
  PetZhengYou_Frame:SetProperty("UnifiedPosition", g_PetZhengYou_Frame_UnifiedPosition);
end
