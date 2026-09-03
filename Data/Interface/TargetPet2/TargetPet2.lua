local WuXingTbl = {
			{level =1,	per = "1.0%" ,	maxlevel=1,	color = "#c00D000"},
			{level =2,	per = "1.5%" ,	maxlevel=1,	color = "#c00D000"},
			{level =3,	per = "2.1%" ,	maxlevel=2,	color = "#c00D000"},
			{level =4,	per = "3.0%" ,	maxlevel=2,	color = "#c00D000"},
			{level =5,	per = "8.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =6,	per = "11.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =7,	per = "14.5%" ,	maxlevel=4,	color = "#c43DBFF"},
			{level =8,	per = "23.5%" ,	maxlevel=4,	color = "#cFF8001"},
			{level =9,	per = "30.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =10,	per = "39.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =11,	per = "42.3%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =12,	per = "46.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =13,	per = "50.2%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =14,	per = "54.7%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =15,	per = "59.5%", maxlevel=5,	color = "#cFF8001"},
}
local ShowColor = "#H";
local TargetPet2SKILL_BUTTONS_NUM = 12;
local TargetPet2SKILL_BUTTONS = {};
local Currend_Pet = -1;
local PET_AITYPE = {};

local OpenPetBank = 0	-- ??????????"Xem xét"?????, ???, ?????, ????????.
----------------------------
-- äÊÞ×°±¸°´Å¥Êý¾Ý¶¨Òå zchw
local g_Pet_Head; 		--?
local g_Pet_Claw;			--?
local g_Pet_Body; 		--??
local g_Pet_Neck;			--??
local g_Pet_Charm;		--??

----------------------------
local TARGETPET2_TYPE = {
[1] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hui", tooltip1 = "#{FZDJ_120717_1}", tooltip2 = "#{FZDJ_120717_2}", tooltip3 = "#{FZDJ_120717_3}", tooltip4 = "#{FZDJ_120717_4}", tooltip5 = "#{FZDJ_120717_5}" },
[2] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hong", tooltip1 = "#{FZDJ_120717_6}", tooltip2 = "#{FZDJ_120717_7}", tooltip3 = "#{FZDJ_120717_8}" } };


function TargetPet2_PreLoad()

	this:RegisterEvent("SHOW_CONTEXT_SEL_PET");
	this:RegisterEvent("CLOSE_PET_FRAME")
	this:RegisterEvent("TOGLE_OPEN_PET_PETBANK")
	
end

function TargetPet2_OnLoad()
	TargetPet2SKILL_BUTTONS[1] = TargetPet2_Skill1;
	TargetPet2SKILL_BUTTONS[2] = TargetPet2_Skill2;
	TargetPet2SKILL_BUTTONS[3] = TargetPet2_Skill3;
	TargetPet2SKILL_BUTTONS[4] = TargetPet2_Skill4;
	TargetPet2SKILL_BUTTONS[5] = TargetPet2_Skill5;
	TargetPet2SKILL_BUTTONS[6] = TargetPet2_Skill6;
	TargetPet2SKILL_BUTTONS[7] = TargetPet2_Skill7;
	TargetPet2SKILL_BUTTONS[8] = TargetPet2_Skill8;
	TargetPet2SKILL_BUTTONS[9] = TargetPet2_Skill9;
	TargetPet2SKILL_BUTTONS[10] = TargetPet2_Skill10;
	TargetPet2SKILL_BUTTONS[11] = TargetPet2_Skill11;
	TargetPet2SKILL_BUTTONS[12] = TargetPet2_Skill12;

	PET_AITYPE[0] = "Nhát gan";
	PET_AITYPE[1] = "C¦n th§n";
	PET_AITYPE[2] = "Trung Thành";
	PET_AITYPE[3] = "Nhanh trí";
	PET_AITYPE[4] = "Dûng Mãnh";
	
	--------------------------
	--  äÊÞ×°±¸ÓëÈ«¾Ö±äÁ¿¹ØÁª zchw
	g_Pet_Head = TargetPetEquip_1;
	g_Pet_Claw = TargetPetEquip_2;	
	g_Pet_Body = TargetPetEquip_3;
	g_Pet_Neck = TargetPetEquip_4;		
	g_Pet_Charm = TargetPetEquip_5;
	---------------------------
end

function TargetPet2_OnEvent(event)

	--½»Ò×¹ý³ÌÖÐµÄ äÊÞÏÔÊ¾	
	if (event == "SHOW_CONTEXT_SEL_PET")  then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		if IsWindowShow("TargetPet") then
			CloseWindow("TargetPet", true);
		end
		TargetPet2_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel2();
		TargetPet2_FakeObject : SetFakeObject( "My_TargetPet2" );		
		TargetPet2_Update();
		TargetPet2_SetStateTooltip();
		this:Show();		
	elseif ( event == "CLOSE_PET_FRAME" and this:IsVisible() ) then
		this:Hide();
		return
	-- äÊÞÒøÐÐ äÊÞÏÔÊ¾	
	elseif (event == "TOGLE_OPEN_PET_PETBANK")  then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		--zchw
		if IsWindowShow("TargetPet") then
			CloseWindow("TargetPet", true);
		end

		OpenPetBank = 1;	-- ????????UI
	  TargetPet2_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel2();
		TargetPet2_FakeObject : SetFakeObject( "My_TargetPet2" );		
		TargetPet2_Update();
		TargetPet2_SetStateTooltip();
		this:Show();

	end
	
end

function TargetPet2_Refresh_Equip()

	g_Pet_Head:SetActionItem(-1)
	g_Pet_Claw:SetActionItem(-1)
	g_Pet_Body:SetActionItem(-1)
	g_Pet_Neck:SetActionItem(-1)
	g_Pet_Charm:SetActionItem(-1)
	
	local ActionClaw = EnumAction(0, "target_pet_equip")
	local ActionHead = EnumAction(1, "target_pet_equip")
	local ActionBody = EnumAction(2, "target_pet_equip")
	local ActionNeck = EnumAction(3, "target_pet_equip")
	local ActionCharm = EnumAction(4, "target_pet_equip")
	
	g_Pet_Head:SetActionItem(ActionHead:GetID())
	g_Pet_Claw:SetActionItem(ActionClaw:GetID())
	g_Pet_Body:SetActionItem(ActionBody:GetID())
	g_Pet_Neck:SetActionItem(ActionNeck:GetID())
	g_Pet_Charm:SetActionItem(ActionCharm:GetID())
	
	TargetPet2_PetSoul_Equip:SetActionItem(-1)
	TargetPet_PetSoul1:SetActionItem(-1)
	TargetPet2_PetSoul2:SetProperty("BackImage", "")
	TargetPet2_PetSoul_Equip_Check:Disable()

	if TargetPet:LuaFnIsPetEquipPetSoul() == 1 then
		local ActionSoul = EnumAction(5, "target_pet_equip")
		TargetPet2_PetSoul_Equip:SetActionItem(ActionSoul:GetID())
	
		local skillAction = TargetPet:LuaFnEnumPetSoulSkillActionOnPet(PET_CURRENT_SELECT)
		if skillAction ~= nil then
			TargetPet_PetSoul1:SetActionItem(skillAction:GetID())
		end

		TargetPet2_PetSoul_Equip_Check:Enable()
		
		local _, szPetPossSkillIcon, _, _ = Pet:LuaFnGetPetSoulPossSkillInfo(-1, 2)
		if szPetPossSkillIcon ~= "" then
			TargetPet2_PetSoul2:SetProperty( "BackImage", szPetPossSkillIcon )
		end
	end
		
end

function TargetPetEquip_Equip_Click(num, type)
end

function TargetPet2_OnShown()

	TargetPet2_Page_Clear();

	if( TargetPet:IsPresent() ) then
		TargetPet2_Update();
		return;
	end;

end

function TargetPet2_Page_Clear()

--	TargetPet2_PetName : SetText( "" );
	TargetPet2_PageHeader : SetText( "#gFF0FA0" );
	TargetPet2_ConsortID : SetText( "" );
	TargetPet2_Model_Protect_Text : SetText( "" );
	TargetPet2_Skin : SetText( "" );
	TargetPet2_TargetPetID : SetText( "" );
	TargetPet2_Sex : SetText("");
	TargetPet2_Life : SetText( "" );
	TargetPet2_Happy : SetText("");
--	Pet_LoyalgGade : SetText( "" );
	TargetPet2_Level : SetText( "" );
--	Pet_Type : SetText( "" );
	TargetPet2_StrAptitude : SetText( "" );
	TargetPet2_PhysicalStrengthAptitude : SetText( "" );
	TargetPet2_DexterityAptitude : SetText( "" );
	TargetPet2_NimbusAptitude : SetText( "" );
	TargetPet2_StabilityAptitude : SetText( "" );
	TargetPet2_Exp : SetText( "" );
	TargetPet2_Blood : SetText( "" .. "  " .. "" );
--	Pet_MP : SetText( "" .. " / " .. "" );
	TargetPet2_Str : SetText( "" );
	TargetPet2_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Nimbus : SetText( "" );
	TargetPet2_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Dexterity : SetText( "" );
	TargetPet2_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_PhysicalStrength : SetText( "" );
	TargetPet2_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_Stability : SetText( "" );
	TargetPet2_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_GenGu : SetText( "" );
	TargetPet2_WuXing : SetText( "" );
	TargetPet2_Potential : SetText( "" );
	TargetPet2_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet2_PhysicsAttack : SetText( "" );
	TargetPet2_MagicAttack : SetText( "" );
	TargetPet2_PhysicsRecovery : SetText( "" );
	TargetPet2_MagicRecovery : SetText( "" );
	TargetPet2_Miss : SetText( "" );
	TargetPet2_ShootProbability : SetText( "" );
	TargetPet2_CriticalAttack:SetText("");
	TargetPet2_CriticalDefence:SetText("");
	TargetPet2_Growth:SetText("")
	TargetPet2_Lingxing : SetText("")
	TargetPet2_Lingxing_Info:SetText("")
	--TargetPet2_FakeObject : SetFakeObject( "" );
	TargetPet2_Peach:Hide()
	g_Pet_Head : SetActionItem(-1);
	g_Pet_Claw : SetActionItem(-1);
	g_Pet_Body : SetActionItem(-1);
	g_Pet_Neck : SetActionItem(-1);
	g_Pet_Charm : SetActionItem(-1);
	for i=1, TargetPet2SKILL_BUTTONS_NUM do
		TargetPet2SKILL_BUTTONS[i]:SetActionItem(-1);
	end
	TargetPet2Food_Type : Hide()
	TargetPet2_NeedLevel : SetText("")
	TargetPet2_lock:Hide();
	TargetPet2Attack_Type:Hide();
	TargetPet2_Jian : Hide();
	TargetPet2_ClearStateTooltip();
end

function TargetPet2_Update()

	local i;

	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	
	TargetPet2_Page_Clear();
	strName = TargetPet:GetAIType(nIndex);
 	
	local strAI,strIcon;
	if(strName>4 or strName <0) then
		strAI = "Sai sót ";
	else
		strAI =	PET_AITYPE[strName];
	end
	
 	strName,strName2 = TargetPet:GetName();
	local nEra, strTypeName = TargetPet:GetPetTypeName(nIndex);
 	if( 1 == nEra ) then
 	    strName2 = "Ð¶i thÑ 2 "..strTypeName
 	end
	TargetPet2_PetName : SetText( strName );
	TargetPet2_PageHeader : SetText( "#gFF0FA0"..strName2 );
	TargetPet2_Type : SetText("#gFF8E92"..strAI)

	strName,strName2,sex = TargetPet : GetID();
	TargetPet2_TargetPetID : SetText( "ID thú:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);
	
	strName = TargetPet : GetConsort();
	if tonumber(strName) == 0 then
		TargetPet2_ConsortID : SetText( "Chßa có bÕn ð¶i" );
	else
		TargetPet2_ConsortID : SetText( "ID bÕn ð¶i:".. strName );
	end
	
	if TargetPet : GetGoodsProtect_Pet() == 1 then
		TargetPet2_Model_Protect_Text : SetText( "#{GDWPBH_090507_4}" );
	else
		TargetPet2_Model_Protect_Text : SetText( "" );
	end
	
	if(sex == 1) then 
		strName = "Ðñc";
	else
		strName = "Cái";
	end

	local nGeneration  = TargetPet : GetGeneration()
	if nGeneration ~= nil and nGeneration >= 100 then
		strName = "#{RXZS_XML_35}";
	end

	TargetPet2_Sex : SetText( strName );
	----------------------------------------------------------------------------------------------------

	if ( OpenPetBank == 1 ) then
		TargetPet2_Peach : Show();
		local nPetType = TargetPet : GetPetType();
		local nColor = 1;
		if ( nGeneration == 1 ) then
			--1: ¶þ´ú
			nColor = 1;
			TargetPet2_Peach : SetToolTip( TARGETPET2_TYPE[ 1 ].tooltip4 );
		elseif ( nGeneration >= 100 ) then
			-->=100:»Ã»¯
			nColor = 1;
			TargetPet2_Peach : SetToolTip( TARGETPET2_TYPE[ 1 ].tooltip1 );
		else
			if ( nPetType == 0 ) then
				--0:±¦±¦ 2022Äê6ÔÂ ÐÞ¸Ä ÓÉ¼ÇÂ¼ ÉÏ´Î·±Ö³µÈ¼¶ ¸Ä³É¼ÇÂ¼ ÒÑ¾­·±Ö³´ÎÊý
			--ÓÉÓÚÒª¼æÈÝÖ®Ç°µÄÊý¾Ý£¬ÔÙ¸üÐÂºóÃ»·±Ö³Ö®Ç°  â¸öÊýÖµÈÔÈ»¼ÇÂ¼ÉÏ´Î·±Ö³µÈ¼¶£¬·±Ö³Ö®ºó¼ÇÂ¼ÒÑ¾­·±Ö³´ÎÊý
				local nLevel = TargetPet:GetLevel();
				local nLastProcreateLevel = TargetPet:GetLastProcreateLevel(nIndex);
				if nLastProcreateLevel < 0 then
					nLastProcreateLevel = 0
				end
				local nTarget = {30, 50, 70, 90, 110}
				local nTimes = 0
				local nCounts = 0
				local nRemainCounts = 0
				if nLastProcreateLevel >= 30 then --??????
					if nLastProcreateLevel >= nTarget[5] then
						nRemainCounts = 0
					else
						for i = 1, table.getn(nTarget) do
							if nLastProcreateLevel < nTarget[i] then
								nTimes = i - 1
								break
							end
						end
						for i = 1, table.getn(nTarget) do
							if nLevel < nTarget[i] then
								nCounts = i - 1
								break
							end
						end
						if nLevel >= nTarget[5] then
							nCounts = 5
						end

						nRemainCounts = nCounts - nTimes
					end
				else
					if nLevel >= nTarget[5] then
						nCounts = 5
					else
						for i = 1, table.getn(nTarget) do
							if nLevel < nTarget[i] then
								nCounts = i - 1
								break
							end
						end
					end
					nRemainCounts = nCounts - nLastProcreateLevel
				end

				if nRemainCounts > 0 or nLevel < nTarget[5] then
					nColor = 2
				else
					nColor = 1
				end
				TargetPet2_Peach : SetToolTip(ScriptGlobal_Format("#{ZSFZYH_220606_01}", nRemainCounts));
			elseif (nPetType == 1 ) then
				--1:±äÒì
				nColor = 1;
				TargetPet2_Peach : SetToolTip(TARGETPET2_TYPE[1].tooltip3);
			elseif ( nPetType == 2 ) then
				--2:³ÉÄê
				nColor = 1;
				TargetPet2_Peach : SetToolTip(TARGETPET2_TYPE[1].tooltip2);
			else
				TargetPet2_Peach : Hide();
			end
		end
		TargetPet2_Peach : SetProperty("Image", TARGETPET2_TYPE[nColor].image);
		OpenPetBank = 0;	-- ??0
	end
	----------------------------------------------------------------------------------------------------
	strName = TargetPet : GetNaturalLife();
	TargetPet2_Life : SetText( "Th÷: "..strName );

	strName = TargetPet : GetLevel();
	TargetPet2_Level : SetText( "C¤p: "..strName.." c¤p" );
	
	strName = TargetPet : GetHappy();
	TargetPet2_Happy : SetText( "Hoan hï:"..strName );
	
	strName = TargetPet : GetBasic();
	TargetPet2_GenGu : SetText( "Cån c¯t:"..strName );
	
	strName = TargetPet : GetLixing(nIndex);
	TargetPet2_Lingxing : SetText("#{RXZS_XML_28}"..strName)

	strName = TargetPet : GetPercent_Lx()
	if tonumber(strName) ~= nil and tonumber(strName) > 0 then
		local rateStr = string.format("%0.1f" , strName / 10.0)
		TargetPet2_Lingxing_Info:SetText("#cFF00FF(+"..rateStr.."%)")
	end

	local iSavvy = TargetPet:GetSavvy()
	TargetPet2_WuXing:SetText("Ngµ tính:".. tostring(iSavvy))
	
	local iStrAptitude = TargetPet:GetStrAptitude()
	local iSprAptitude = TargetPet:GetIntAptitude()
	local iConAptitude = TargetPet:GetPFAptitude()
	local iIntAptitude = TargetPet:GetStaAptitude()
	local iDexAptitude = TargetPet:GetDexAptitude()
	
	local bHavePetSoul = TargetPet:LuaFnIsPetEquipPetSoul()
	local iStrAptitude_ps = TargetPet:LuaFnGetStrAptitude_ps()
	local iSprAptitude_ps = TargetPet:LuaFnGetSprAptitude_ps()
	local iConAptitude_ps = TargetPet:LuaFnGetConAptitude_ps()
	local iIntAptitude_ps = TargetPet:LuaFnGetIntAptitude_ps()
	local iDexAptitude_ps = TargetPet:LuaFnGetDexAptitude_ps()
	
	if WuXingTbl[iSavvy] ~= nil then
		if bHavePetSoul == 1 then
			TargetPet2_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			TargetPet2_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			TargetPet2_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			TargetPet2_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")".."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			TargetPet2_StrAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iStrAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_NimbusAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iSprAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iConAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_StabilityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iIntAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
			TargetPet2_DexterityAptitude:SetText(WuXingTbl[iSavvy].color..tostring(iDexAptitude)..ShowColor.."(+"..WuXingTbl[iSavvy].per..")")
	end
	else
		if bHavePetSoul == 1 then
			TargetPet2_StrAptitude:SetText(tostring(iStrAptitude).."#cFFCC99(+"..tostring(iStrAptitude_ps)..")")
			TargetPet2_NimbusAptitude:SetText(tostring(iSprAptitude).."#cFFCC99(+"..tostring(iSprAptitude_ps)..")")
			TargetPet2_PhysicalStrengthAptitude:SetText(tostring(iConAptitude).."#cFFCC99(+"..tostring(iConAptitude_ps)..")")
			TargetPet2_StabilityAptitude:SetText(tostring(iIntAptitude).."#cFFCC99(+"..tostring(iIntAptitude_ps)..")")
			TargetPet2_DexterityAptitude:SetText(tostring(iDexAptitude).."#cFFCC99(+"..tostring(iDexAptitude_ps)..")")
		else
			TargetPet2_StrAptitude:SetText(tostring(iStrAptitude))
			TargetPet2_NimbusAptitude:SetText(tostring(iSprAptitude))
			TargetPet2_PhysicalStrengthAptitude:SetText(tostring(iConAptitude))
			TargetPet2_StabilityAptitude:SetText(tostring(iIntAptitude))
			TargetPet2_DexterityAptitude:SetText(tostring(iDexAptitude))		
	end
	end
	
	strName = TargetPet : GetExp();
	TargetPet2_Exp : SetText( "EXP:"..strName );
	
	strName = TargetPet : GetHP(nIndex);
	strName2 = TargetPet:	GetMaxHP(nIndex);
	TargetPet2_Blood : SetText( "Sinh lñc:"..strName .." / ".. strName2);

	strName = TargetPet : GetStr();
	TargetPet2_Str : SetText( strName );
	TargetPet2_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetInt();
	TargetPet2_Nimbus : SetText( tonumber(strName) );
	TargetPet2_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetDex();
	TargetPet2_Dexterity : SetText( tonumber(strName) );
	TargetPet2_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetPF();
	TargetPet2_PhysicalStrength : SetText( tonumber(strName) );
	TargetPet2_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetSta();
	TargetPet2_Stability : SetText( tonumber(strName) );
	TargetPet2_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
--	strName = TargetPet : GetBasic();
--	TargetPet2_Basic : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalAttack();
	TargetPet2_CriticalAttack : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalDefence();
	TargetPet2_CriticalDefence : SetText( tonumber(strName) );

	strName = TargetPet : GetPotential();
	strName2 = tonumber(strName);
	TargetPet2_Potential : SetText( strName2 );
	TargetPet2_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = TargetPet : GetPhysicsAttack();
	TargetPet2_PhysicsAttack : SetText( strName );
	
	strName = TargetPet : GetMagicAttack();
	TargetPet2_MagicAttack : SetText( strName );
	
	strName = TargetPet : GetPhysicsRecovery();
	TargetPet2_PhysicsRecovery : SetText( strName );
	
	strName = TargetPet : GetMagicRecovery ();
	TargetPet2_MagicRecovery : SetText( strName );

	--ÉÁ±ÜÂÊ
	strName = TargetPet : GetMiss();
	TargetPet2_Miss : SetText( strName );

	--ÃüÖÐÂÊ
	strName = TargetPet : GetShootProbability();
	TargetPet2_ShootProbability : SetText( strName );
	
	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	
	for i=1, SumPetSkill+TargetPet2SKILL_BUTTONS_NUM do
		local theSkillAction = Pet : EnumPetSkill( 100, i-1, "petskill");
		if( theSkillAction ~= nil and (theSkillAction : GetPetSkillOwner() == 100) and (k <= TargetPet2SKILL_BUTTONS_NUM ) ) then
			TargetPet2SKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k + 1;
		end
	end
	
	--zchw
	TargetPet2_Refresh_Equip();
	
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = TargetPet:GetTakeLevel();
	
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).." c¤p#W mang theo";

	TargetPet2_NeedLevel : SetText(strNeedLevel)

	strName = TargetPet : GetGrowRate();
	TargetPet2_Growth : SetText("#GChßa biªt")
	local nGrowLevel = TargetPet : GetPetGrowLevel(tonumber(strName));
	local strTbl = {"Thß¶ng ","¿u ","Ki®t ","Trác ","Tuy®t "};
	
	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c???0?????
		local nGrowRate = TargetPet : GetGrowRate();
		if(strTbl[nGrowLevel]) then
			TargetPet2_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	local food = TargetPet : GetFoodType();
	strName = "";
	AxTrace(0,1,"food="..food);
	if(food >= 1000) then
		strName = strName .. "Th¸t";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "Cö";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "Sâu";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "Ngû c¯c";
	end
	TargetPet2Food_Type : Show();
	TargetPet2Food_Type : SetToolTip( strName );
	
	strName,strIcon = TargetPet : GetAttackTrait();
	AxTrace(0,0,"strIcon="..strIcon)
	AxTrace(0,0,"strName="..strName)
	if strIcon ~= "" then
		TargetPet2Attack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		TargetPet2Attack_Type : SetToolTip(strName)
		TargetPet2Attack_Type : Show();
	end

	TargetPet2_Jian : Show();
	
end

function TargetPet2_Skill_Button_Clicked(nIndex)
--½«À´Ö÷¶¯¼¼ÄÜºÍ±»¶¯¼¼ÄÜ£¬¿ÉÒÔÔÚ±íÀï²éµ½¡£
--	if(nIndex < 3) then
		
--	end

--	PETSKILL_BUTTONS[nIndex] : DoAction();

--	local SumPetSkill = GetActionNum("petskill");
--	local k=1;
--	for i=1, SumPetSkill do
--		local theSkillAction = EnumAction( i-1, "petskill");
--		if( (theSkillAction : GetPetSkillOwner() == nIndex) and (k <= TargetPet2SKILL_BUTTONS_NUM ) ) then
--			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
--			k = k + 1;
--		end
--	end
end

----------------------------------------------------------------------------------
--
-- Ðý×ª äÊÞÄ£ÐÍ£¨Ïò×ó)
--
function TargetPet2_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--Ïò×óÐý×ª¿ªÊ¼
		if(start == 1) then
			TargetPet2_FakeObject:RotateBegin(-0.3);
		--Ïò×óÐý×ª½áÊø
		else
			TargetPet2_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function TargetPet2_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--ÏòÓÒÐý×ª¿ªÊ¼
		if(start == 1) then
			TargetPet2_FakeObject:RotateBegin(0.3);
		--ÏòÓÒÐý×ª½áÊø
		else
			TargetPet2_FakeObject:RotateEnd();
		end
	end
end

function TargetPet2_Jian_Clicked()
	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	Pet:PetOpenPetJian(-1,"target");
end

function TargetPet2_SetStateTooltip( )

	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceAttack  		= TargetPet : GetAttackCold( nIndex );
	local iFireAttack 		= TargetPet : GetAttackFire( nIndex );
	local iThunderAttack	= TargetPet : GetAttackLight( nIndex );
	local iPoisonAttack		= TargetPet : GetAttackPoison( nIndex );

	local iIceDefine  		= TargetPet : GetDefenceCold( nIndex );
	local iFireDefine 		= TargetPet : GetDefenceFire( nIndex );
	local iThunderDefine	= TargetPet : GetDefenceLight( nIndex );
	local iPoisonDefine		= TargetPet : GetDefencePoison( nIndex );

	local iIceResistOther		= TargetPet : GetResistCold( nIndex );
	local iFireResistOther		= TargetPet : GetResistFire( nIndex );
	local iThunderResistOther	= TargetPet : GetResistLight( nIndex );
	local iPoisonResistOther	= TargetPet : GetResistPoison( nIndex );
	
	------------------------------
	if( iIceAttack == nil ) then
		iIceAttack = 0;
	end
	if( iFireAttack == nil ) then
		iFireAttack = 0;
	end
	if( iThunderAttack == nil ) then
		iThunderAttack = 0;
	end
	if( iPoisonAttack == nil ) then
		iPoisonAttack = 0;
	end
	------------------------------
	if( iIceDefine == nil ) then
		iIceDefine = 0;
	end
	
	if( iFireDefine == nil ) then
		iFireDefine = 0;
	end
	
	if( iPoisonDefine == nil ) then
		iPoisonDefine = 0;
	end
	if( iThunderDefine == nil ) then
		iThunderDefine = 0;
	end
	------------------------------
	if( iIceResistOther == nil ) then
		iIceResistOther = 0;
	end
	if( iFireResistOther == nil ) then
		iFireResistOther = 0;
	end
	if( iThunderResistOther == nil ) then
		iThunderResistOther = 0;
	end
	if( iPoisonResistOther == nil ) then
		iPoisonResistOther = 0;
	end


	Pet2_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rKháng Bång:"..tostring(iIceDefine).."#rGiäm kháng Bång: "..tostring(iIceResistOther) );
	Pet2_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rKháng Höa: "..tostring(iFireDefine).."#rGiäm kháng Höa: "..tostring(iFireResistOther) );
	Pet2_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rKháng Huy«n:"..tostring(iThunderDefine).."#rGiäm kháng Huy«n: "..tostring(iThunderResistOther) );
	Pet2_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rKháng Ðµc:"..tostring(iPoisonDefine).."#rGiäm kháng Ðµc: "..tostring(iPoisonResistOther) );

end

function TargetPet2_ClearStateTooltip()
	-- µÃµ½×´Ì¬ÊôÐÔ
	local iIceAttack  		= 0;
	local iFireAttack 		= 0;
	local iThunderAttack	= 0;
	local iPoisonAttack		= 0;

	local iIceDefine  		= 0;
	local iFireDefine 		= 0;
	local iThunderDefine	= 0;
	local iPoisonDefine		= 0;

	local iIceResistOther		= 0;
	local iFireResistOther		= 0;
	local iThunderResistOther	= 0;
	local iPoisonResistOther	= 0;

	Pet2_IceFastness:SetToolTip("Bång công:"..tostring(iIceAttack).."#rKháng Bång:"..tostring(iIceDefine).."#rGiäm kháng Bång: "..tostring(iIceResistOther) );
	Pet2_FireFastness:SetToolTip("Höa công:"..tostring(iFireAttack).."#rKháng Höa: "..tostring(iFireDefine).."#rGiäm kháng Höa: "..tostring(iFireResistOther) );
	Pet2_ThunderFastness:SetToolTip("Huy«n công:"..tostring(iThunderAttack).."#rKháng Huy«n:"..tostring(iThunderDefine).."#rGiäm kháng Huy«n: "..tostring(iThunderResistOther) );
	Pet2_PoisonFastness:SetToolTip("Ðµc công:"..tostring(iPoisonAttack).."#rKháng Ðµc:"..tostring(iPoisonDefine).."#rGiäm kháng Ðµc: "..tostring(iPoisonResistOther) );

end

function TargetPet2_OnHidden()
	Pet:LuaFnClosePetSoulInfo(2)
end

function TargetPet2_PetSoul_ShowInfo()
	
	if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
		return
	end
	
	Pet:LuaFnShowPetSoulInfo(2, -1)

end

function TargetPet2_PetSoul2_MouseEnter()
	
	if TargetPet:LuaFnIsPetEquipPetSoul() ~= 1 then
		return
	end
	
	local left, right, top, bottom = TargetPet2_PetSoul2:GetPixelRect()
	
	TargetPet:LuaFnShowPetSoulPossSkillInfo(1, left, top, right, bottom)
	
end

function TargetPet2_PetSoul2_MouseLeave()
	
	local left, right, top, bottom = TargetPet2_PetSoul2:GetPixelRect()
	TargetPet:LuaFnShowPetSoulPossSkillInfo(0, left, top, right, bottom)

end
