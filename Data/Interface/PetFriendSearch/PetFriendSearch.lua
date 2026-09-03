
local cooldownTime =15*1000;		--??????
local pageCoolDownTime = 5*1000;	--??????,??????
local PET_AITYPE = {};
local FlashTextHeader = "#ecc33cc#cffcccc";		--??????????????
local showPrevPage = true;
local showNextPage = true;

function PetFriendSearch_PreLoad()
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OPEN_WINDOW");
end

function PetFriendSearch_OnLoad()
	PET_AITYPE[0] = "Nhát gan";
	PET_AITYPE[1] = "C¦n th§n";
	PET_AITYPE[2] = "Trung Thành";
	PET_AITYPE[3] = "Nhanh trí";
	PET_AITYPE[4] = "Dûng Mãnh";
end

function PetFriendSearch_OnEvent(event)

	if(event == "UPDATE_PETINVITEFRIEND") then
		if("searchlist" == arg0) then
			showPrevPage = true;
			showNextPage = true;
			PetFriendSearch_ShowWindow();
		elseif("searchlistbegin" == arg0) then
			showPrevPage = false;
			PetFriendSearch_ShowWindow();
		elseif("searchnonextpage" == arg0) then
			PetFriendSearch_PageDown:Disable();
			showNextPage = false;
		elseif("searchnoprevpage" == arg0) then
			PetFriendSearch_PageUp:Disable();
			showPrevPage = false;
		end
	elseif ( event == "OPEN_WINDOW") then
		if( arg0 == "Show_Pet_Search") then
			this:Show();
		end
	end
end

function PetFriendSearch_ShowWindow()
	local num = PetInviteFriend:GetInviteNum("search")
	if( num <= 0 ) then
		PushDebugMessage("Không tìm th¤y dæ li®u Trân Thú thích hþp");
		return;
	end
	PetFriendSearch_Clear_All();
	if( num == 1 ) then
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		showNextPage = false;
	else
		showNextPage = true;
	end
	for i=1, num do
		PetFriendSearch_Update(i);
	end
	this:Show();
end

function PetFriendSearch_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	idx = idx + 4;

	--»ñÈ¡ äÊÞÖ÷ÈËÐÅÏ¢
	local humanName = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local humanMenPai = PetInviteFriend:GetHumanINFO(idx, "MENPAI");
	local humanLevel = PetInviteFriend:GetHumanINFO(idx, "LEVEL");
	local humanSex  = PetInviteFriend:GetHumanINFO(idx, "SEX");
	humanMenPai = PetFriendSearch_ConvertNumToMenPai(humanMenPai);
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
	petTypeName = FlashTextHeader .. petTypeName .. "Bäo Bäo";
	if( petSex == 0 ) then
		petSex = "Cái";
	else
		petSex = "Ðñc";
	end
	local strTbl = {"Thß¶ng ","¿u ","Ki®t ","Trác ","Tuy®t "};

	if(petGrow >= 0) then
		petGrow = petGrow + 1;	--c???0?????
		if(strTbl[petGrow]) then
			petGrow = strTbl[petGrow];
		else
			petGrow = "Chßa rõ";
		end
	else
		petGrow = "Chßa rõ";
	end

	if(petAI>4 or petAI <0) then
		petAI = "Sai sót ";
	else
		petAI =	PET_AITYPE[petAI];
	end


	if( idx == 5 ) then
	  --ÉèÖÃ äÊÞÐÅÏ¢
		PetFriendSearch_Master1Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master1Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master1Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master1Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Type1:SetText(petAI);
		PetFriendSearch_Flash_Name1:SetText(petTypeName);

		--ÉèÖÃÖ÷ÈËÐÅÏ¢
		PetFriendSearch_Master1_NameInfo:SetText(humanName);
		PetFriendSearch_Master1_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master1_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master1_GenderInfo:SetText(humanSex);

		--ÉèÖÃÄ£ÐÍÐÅÏ¢
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel1:SetFakeObject("My_PetSearchFriend01");

		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_PetModel1_TurnRight:Enable();
		PetFriendSearch_PetModel1_TurnLeft:Enable();
		if showPrevPage then
			PetFriendSearch_PageUp:Enable();
		else
			PetFriendSearch_PageUp:Disable();
		end


	elseif( idx == 6 ) then
	  --ÉèÖÃ äÊÞÐÅÏ¢
		PetFriendSearch_Master2Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master2Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master2Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master2Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Flash_Name2:SetText(petTypeName);
		PetFriendSearch_Type2:SetText(petAI);

		--ÉèÖÃÖ÷ÈËÐÅÏ¢
		PetFriendSearch_Master2_NameInfo:SetText(humanName);
		PetFriendSearch_Master2_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master2_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master2_GenderInfo:SetText(humanSex);

		--ÉèÖÃÄ£ÐÍÐÅÏ¢
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel2:SetFakeObject("My_PetSearchFriend02");

		--¼¤»î°´Å¥
		PetFriendSearch_Pet2_Investigate:Enable();
		PetFriendSearch_Pet2_Acquaintance:Enable();
		PetFriendSearch_PetModel2_TurnRight:Enable();
		PetFriendSearch_PetModel2_TurnLeft:Enable();
		if showNextPage then
			PetFriendSearch_PageDown:Enable()
		end

		--ÏÔÊ¾ÎÄ±¾
		PetFriendSearch_Master2Pet_Name:Show();
		PetFriendSearch_Master2Pet_Gender:Show();
		PetFriendSearch_Master2Pet_ChenZhang:Show();
		PetFriendSearch_Master2Pet_Level:Show();
		PetFriendSearch_Master2_Name:Show();
		PetFriendSearch_Master2_Level:Show();
		PetFriendSearch_Master2_ManPai:Show();
		PetFriendSearch_Master2_Gender:Show();
		PetFriendSearch_Master2Pet_NameInfo:Show();
		PetFriendSearch_Master2Pet_GenderInfo:Show();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Show();
		PetFriendSearch_Master2Pet_LevelInfo:Show();
		PetFriendSearch_Master2_NameInfo:Show();
		PetFriendSearch_Master2_LevelInfo:Show();
		PetFriendSearch_Master2_ManPaiInfo:Show();
		PetFriendSearch_Master2_GenderInfo:Show();
		PetFriendSearch_Type2:Show();
		PetFriendSearch_Flash_Name2:Show();
	end

end

--Òþ²ØÒ»Ð© ´°¿Ú
function PetFriendSearch_HideWindow(idx)
	if( idx == 0 ) then
		PetFriendSearch_Master1Pet_Name:Hide();
		PetFriendSearch_Master1Pet_Gender:Hide();
		PetFriendSearch_Master1Pet_ChenZhang:Hide();
		PetFriendSearch_Master1Pet_Level:Hide();
		PetFriendSearch_Master1_Name:Hide();
		PetFriendSearch_Master1_Level:Hide();
		PetFriendSearch_Master1_ManPai:Hide();
		PetFriendSearch_Master1_Gender:Hide();
	else
		PetFriendSearch_Master2Pet_Name:Hide();
		PetFriendSearch_Master2Pet_Gender:Hide();
		PetFriendSearch_Master2Pet_ChenZhang:Hide();
		PetFriendSearch_Master2Pet_Level:Hide();
		PetFriendSearch_Master2_Name:Hide();
		PetFriendSearch_Master2_Level:Hide();
		PetFriendSearch_Master2_ManPai:Hide();
		PetFriendSearch_Master2_Gender:Hide();
		PetFriendSearch_Master2Pet_NameInfo:Hide();
		PetFriendSearch_Master2Pet_GenderInfo:Hide();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Hide();
		PetFriendSearch_Master2Pet_LevelInfo:Hide();
		PetFriendSearch_Master2_NameInfo:Hide();
		PetFriendSearch_Master2_LevelInfo:Hide();
		PetFriendSearch_Master2_ManPaiInfo:Hide();
		PetFriendSearch_Master2_GenderInfo:Hide();
		PetFriendSearch_Type2:Hide();
		PetFriendSearch_Flash_Name2:Hide();
	end
end

--½ûÓÃÒ»Ð©°´Å¥
function PetFriendSearch_DisableButton(idx)
	if( idx == 0 ) then
		PetFriendSearch_Pet1_Investigate:Disable();
		PetFriendSearch_Pet1_Acquaintance:Disable();
		PetFriendSearch_PetModel1_TurnRight:Disable();
		PetFriendSearch_PetModel1_TurnLeft:Disable();
	else
		PetFriendSearch_Pet2_Investigate:Disable();
		PetFriendSearch_Pet2_Acquaintance:Disable();
		PetFriendSearch_PetModel2_TurnRight:Disable();
		PetFriendSearch_PetModel2_TurnLeft:Disable();
		--Ã»ÓÐÏÂÒ»Ò³µÄÐÅÏ¢ÁË
		PetFriendSearch_PageDown:Disable();
	end
end


function PetFriendSearch_Clear_All()
	--for i=0, 2 do
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		PetFriendSearch_PetModel1:SetFakeObject("");
		PetFriendSearch_PetModel2:SetFakeObject("");

	--end
end


function PetFriendSearch_ShowTargetFrame(who)
	PetInviteFriend:ShowTargetPet(who);
end

function PetFriendSearch_Hide()
	this:Hide();
end


function PetFriendSearch_ConvertNumToMenPai( MenPaiId )
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
		strMenPai = "Tiêu Dao";

	elseif(9 == MenPaiId) then
		strMenPai = "Tñ do";

	elseif(10== MenPaiId) then
		strMenPai = "Mµ Dung";

	end

	return strMenPai;
end
----------------------------------------------------------------------------------
--
-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
--
function PetFriendSearch_Modle_TurnLeft(modelIdx,start)

		if( modelIdx == 5 ) then
		--Ïò×óÐý×ª¿ªÊ¼
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(-0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
		end
		if( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(-0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	 end
end

----------------------------------------------------------------------------------
--
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function PetFriendSearch_Modle_TurnRight(modelIdx, start)
	if( modelIdx == 5 ) then
		--Ïò×óÐý×ª¿ªÊ¼
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
	elseif( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(0.3);
			--Ïò×óÐý×ª½áÊø
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	end
end

--²éÑ¯ÉÏÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetFriendSearch_PrevPage()
	PetInviteFriend:ShowSearchPage(-1);
	PetFriendSearch_PageUp:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageUp();",pageCoolDownTime);
end

function PetFriendSearch_CoolPageUp()
	if showPrevPage then
		PetFriendSearch_PageUp:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageUp();");
end

--²éÑ¯ÏÂÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetFriendSearch_NextPage()
	PetInviteFriend:ShowSearchPage(1);
	PetFriendSearch_PageDown:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageDown();",pageCoolDownTime);
end
function PetFriendSearch_CoolPageDown()
	if showNextPage then
		PetFriendSearch_PageDown:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageDown();");
end

--¸ø äÊÞÖ÷ÈË·¢ÓÊ¼þ£¬ËµÃ÷Ïë ÷ÓÑ
function PetFriendSearch_SendMail( idx )
	if( idx == 5 or idx == 6 ) then
		local owner = PetInviteFriend:GetHumanINFO(idx, "NAME");
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("Không th¬ tñ kªt thân Trân Thú");
			return;
		end
			--¸ø¸Ã äÊÞÖ÷ÈË·¢ËÍÓÊ¼þ¸æËßËûËýÄãµÄ äÊÞÏëºÍËûËýµÄ äÊÞ½áÊ¶
		DataPool:OpenMail( owner,"Ta mu¯n kªt thân v¾i Bäo Bäo cüa bÕn" );
	end

	if( idx == 5 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown3();" ,cooldownTime);
		PetFriendSearch_Pet1_Acquaintance:Disable();
	elseif(idx == 6 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown4();" ,cooldownTime);
		PetFriendSearch_Pet2_Acquaintance:Disable();
	end
end

function PetFriendSearch_CoolDown3()
		PetFriendSearch_Pet1_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown3();");
end
function PetFriendSearch_CoolDown4()
		PetFriendSearch_Pet2_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown4();");
end
