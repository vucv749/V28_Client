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
local TARGETPETSKILL_BUTTONS_NUM = 12;
local TARGETPETSKILL_BUTTONS = {};
local Currend_Pet = -1;
local PET_AITYPE = {};
--2023 äÊŞ·±Ö³ÓÅ»¯
local PET_TYPE = {
	[1] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hui", tooltip1 = "#{FZDJ_120717_1}", tooltip2 = "#{FZDJ_120717_2}", tooltip3 = "#{FZDJ_120717_3}", tooltip4 = "#{FZDJ_120717_4}", tooltip5 = "#{FZDJ_120717_5}" },
	[2] = {image = "set:CommonFrame2 image:ZhenShouHeart_Hong", tooltip1 = "#{FZDJ_120717_6}", tooltip2 = "#{FZDJ_120717_7}", tooltip3 = "#{FZDJ_120717_8}" } 
}
local g_isShowPeach = 0

function TargetPet_PreLoad()
--	this:RegisterEvent("TOGLE_PET_PAGE");
	this:RegisterEvent("UPDATE_TARGETPET_PAGE");
	this:RegisterEvent("VIEW_EXCHANGE_PET")
	this:RegisterEvent("UPDATE_PETINVITEFRIEND")
	this:RegisterEvent("CLOSE_PET_FRAME")
	this:RegisterEvent("TOGLE_PET_PAGE");
	this:RegisterEvent("YBMARKET_PETVIEW")
	this:RegisterEvent("TOGLE_OPEN_PET_PETBANK")

end

function TargetPet_OnLoad()
	TARGETPETSKILL_BUTTONS[1] = TargetPet_Skill1;
	TARGETPETSKILL_BUTTONS[2] = TargetPet_Skill2;
	TARGETPETSKILL_BUTTONS[3] = TargetPet_Skill3;
	TARGETPETSKILL_BUTTONS[4] = TargetPet_Skill4;
	TARGETPETSKILL_BUTTONS[5] = TargetPet_Skill5;
	TARGETPETSKILL_BUTTONS[6] = TargetPet_Skill6;
	TARGETPETSKILL_BUTTONS[7] = TargetPet_Skill7;
	TARGETPETSKILL_BUTTONS[8] = TargetPet_Skill8;
	TARGETPETSKILL_BUTTONS[9] = TargetPet_Skill9;
	TARGETPETSKILL_BUTTONS[10] = TargetPet_Skill10;
	TARGETPETSKILL_BUTTONS[11] = TargetPet_Skill11;
	TARGETPETSKILL_BUTTONS[12] = TargetPet_Skill12;

	PET_AITYPE[0] = "Nhát gan";
	PET_AITYPE[1] = "C¦n th§n";
	PET_AITYPE[2] = "Trung Thành";
	PET_AITYPE[3] = "Nhanh trí";
	PET_AITYPE[4] = "Dûng Mãnh";
end

function TargetPet_OnEvent(event)
--	if ( event == "TOGLE_PET_PAGE" ) then
--	this:TogleShow();
--		Pet_Update();
--		return;
--	else
	if ( event == "UPDATE_TARGETPET_PAGE" ) then
		if( tonumber(arg0) >= 0) then		
			Currend_Pet = tonumber(arg0);
			TargetPet : CopyMyPet(Currend_Pet);
		end
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		-- zchw
		if IsWindowShow("TargetPet2") then
			CloseWindow("TargetPet2", true);
		end
		TargetPet_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel();
		TargetPet_FakeObject : SetFakeObject( "My_TargetPet" );
		g_isShowPeach = 0
		TargetPet_Update();
		this:Show();
		
	--½»Ò×¹ı³ÌÖĞµÄ äÊŞÏÔÊ¾	
	elseif (event == "VIEW_EXCHANGE_PET")  then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		--zchw
		if IsWindowShow("TargetPet2") then
			CloseWindow("TargetPet2", true);
		end
		TargetPet_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel();
		TargetPet_FakeObject : SetFakeObject( "My_TargetPet" );		
		g_isShowPeach = 1	
		TargetPet_Update();
		this:Show();
		
	elseif (event == "UPDATE_PETINVITEFRIEND") then
		if("target" == tostring(arg0)) then
			if(IsWindowShow("OtherPet")) then
				CloseWindow("OtherPet", true);
			end
			--zchw
			if IsWindowShow("TargetPet2") then
				CloseWindow("TargetPet2", true);
			end
			TargetPet_FakeObject : SetFakeObject( "" );
			TargetPet:SetModel();
			TargetPet_FakeObject : SetFakeObject( "My_TargetPet" );
			g_isShowPeach = 0
			TargetPet_Update();
			this:Show();
		end
		
	elseif ( event == "CLOSE_PET_FRAME" and this:IsVisible() ) then
		this:Hide();
		return
	elseif ( event == "TOGLE_PET_PAGE" and this:IsVisible() ) then
		this:Hide();
		return
	elseif event == "YBMARKET_PETVIEW" then
		if(IsWindowShow("OtherPet")) then
			CloseWindow("OtherPet", true);
		end
		if IsWindowShow("TargetPet2") then
			CloseWindow("TargetPet2", true);
		end
		TargetPet_FakeObject : SetFakeObject( "" );
		TargetPet : SetModel();
		TargetPet_FakeObject : SetFakeObject( "My_TargetPet" );	
		g_isShowPeach = 1	
		TargetPet_Update();
		this:Show();
	end
	
end

function TargetPet_OnShown()

	TargetPet_Page_Clear();

	if( TargetPet:IsPresent() ) then
		TargetPet_Update();
		return;
	end;

end

function TargetPet_Page_Clear()

--	TargetPet_PetName : SetText( "" );
	TargetPet_PageHeader : SetText( "#gFF0FA0" );
	TargetPet_ConsortID : SetText( "" );
	TargetPet_Model_Protect_Text : SetText( "" );
	TargetPet_Skin : SetText( "" );
	TargetPet_TargetPetID : SetText( "" );
	TargetPet_Sex : SetText("");
	TargetPet_Life : SetText( "" );
	TargetPet_Happy : SetText("");
--	Pet_LoyalgGade : SetText( "" );
	TargetPet_Level : SetText( "" );
--	Pet_Type : SetText( "" );
	TargetPet_StrAptitude : SetText( "" );
	TargetPet_PhysicalStrengthAptitude : SetText( "" );
	TargetPet_DexterityAptitude : SetText( "" );
	TargetPet_NimbusAptitude : SetText( "" );
	TargetPet_StabilityAptitude : SetText( "" );
--	TargetPet_Exp : SetText( "" );
	TargetPet_Blood : SetText( "" .. "  " .. "" );
--	Pet_MP : SetText( "" .. " / " .. "" );
	TargetPet_Str : SetText( "" );
	TargetPet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_Nimbus : SetText( "" );
	TargetPet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_Dexterity : SetText( "" );
	TargetPet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_PhysicalStrength : SetText( "" );
	TargetPet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_Stability : SetText( "" );
	TargetPet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_GenGu : SetText( "" );
	TargetPet_WuXing : SetText( "" );
	TargetPet_Potential : SetText( "" );
	TargetPet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	TargetPet_PhysicsAttack : SetText( "" );
	TargetPet_MagicAttack : SetText( "" );
	TargetPet_PhysicsRecovery : SetText( "" );
	TargetPet_MagicRecovery : SetText( "" );
	TargetPet_Miss : SetText( "" );
	TargetPet_ShootProbability : SetText( "" );
	TargetPet_CriticalAttack:SetText("");
	TargetPet_CriticalDefence:SetText("");
	TargetPet_Growth:SetText("")
	TargetPet_Lingxing : SetText("")
	--TargetPet_FakeObject : SetFakeObject( "" );
	for i=1, TARGETPETSKILL_BUTTONS_NUM do
		TARGETPETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
	TargetPetFood_Type : Hide()
	TargetPet_NeedLevel : SetText("")
	TargetPet_lock:Hide();
	TargetPetAttack_Type:Hide();
	TargetPet_Jian : Hide();
end

function TargetPet_Update()

	local i;

	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	
	local strName, strName2, sex
	TargetPet_Page_Clear();
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
 	    strName2 = "Ğ¶i thÑ 2 "..strTypeName
 	end
	TargetPet_PetName : SetText( strName2 );
	TargetPet_PageHeader : SetText( "#gFF0FA0"..strName2 );
	TargetPet_Type : SetText("#gFF8E92"..strAI)

	strName,strName2,sex = TargetPet : GetID();
	TargetPet_TargetPetID : SetText( "ID thú:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);
	
	strName = TargetPet : GetConsort();
	
	if (strName == "00000000") then
		TargetPet_ConsortID : SetText( "Chßa có bÕn ğ¶i" );
	else
		TargetPet_ConsortID : SetText( "ID bÕn ğ¶i:".. strName );
	end
	
	if TargetPet : GetGoodsProtect_Pet() == 1 then
		TargetPet_Model_Protect_Text : SetText( "#{GDWPBH_090507_4}" );
	else
		TargetPet_Model_Protect_Text : SetText( "" );
	end
		
	if(sex == 1) then 
		strName = "Ğñc";
	else
		strName = "Cái";
	end

	local nGeneration  = TargetPet : GetGeneration()
	if nGeneration ~= nil and nGeneration >= 100 then
		strName = "#{RXZS_XML_35}";
	end

	TargetPet_Sex : SetText( strName );
	--------------------------------------------------------------------------------------------------
	TargetPet_Peach:Hide()
	if g_isShowPeach == 1 then
		TargetPet_Peach:Show()
		--¸Ã äÊŞµÄ·±Ö³Çé¿ö
		local nPetType = TargetPet : GetPetType();
		local nColor = 1;
		if (nGeneration == 1) then
			--1:¶ş´ú
			nColor = 1;
			TargetPet_Peach : SetToolTip(PET_TYPE[1].tooltip4);
		elseif (nGeneration >= 100) then
			-->=100:»Ã»¯
			nColor = 1;
			TargetPet_Peach : SetToolTip(PET_TYPE[1].tooltip1);
		else
			if (nPetType == 0) then
				--0:±¦±¦ 2013Äê ĞŞ¸Ä ÓÉ¼ÇÂ¼ ÉÏ´Î·±Ö³µÈ¼¶ ¸Ä³É¼ÇÂ¼ ÒÑ¾­·±Ö³´ÎÊı
				--ÓÉÓÚÒª¼æÈİÖ®Ç°µÄÊı¾İ£¬ÔÙ¸üĞÂºóÃ»·±Ö³Ö®Ç°  â¸öÊıÖµÈÔÈ»¼ÇÂ¼ÉÏ´Î·±Ö³µÈ¼¶£¬·±Ö³Ö®ºó¼ÇÂ¼ÒÑ¾­·±Ö³´ÎÊı
				local nLevel = TargetPet:GetLevel();
				local nLastProcreateLevel = TargetPet:GetLastProcreateLevel();
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
				TargetPet_Peach : SetToolTip(ScriptGlobal_Format("#{ZSFZYH_220606_01}", nRemainCounts));

			elseif (nPetType == 1) then
				--1:±äÒì
				nColor = 1;
				TargetPet_Peach : SetToolTip(PET_TYPE[1].tooltip3);
			elseif (nPetType == 2) then
				--2:³ÉÄê
				nColor = 1;
				TargetPet_Peach : SetToolTip(PET_TYPE[1].tooltip2);
			end
		end
		TargetPet_Peach : SetProperty("Image", PET_TYPE[nColor].image);
	end
	------------------------------------------------------------------------------------------------------------------
	strName = TargetPet : GetNaturalLife();
	TargetPet_Life : SetText( "Th÷: "..strName );

	strName = TargetPet : GetLevel();
	TargetPet_Level : SetText( "C¤p: "..strName.." c¤p" );
	
	strName = TargetPet : GetHappy();
	TargetPet_Happy : SetText( "Hoan hï:"..strName );
	
	strName = TargetPet : GetBasic();
	TargetPet_GenGu : SetText( "Cån c¯t:"..strName );
	
	strName = TargetPet : GetLixing(nIndex);
	TargetPet_Lingxing : SetText("#{RXZS_XML_28}"..strName)

	strName = TargetPet : GetSavvy();
	AxTrace(0,0,"targetpet savvy="..strName)
	TargetPet_WuXing : SetText( "Ngµ tính:".. strName);
	
	local WuXingVal = tonumber(strName);
	strName = TargetPet : GetStrAptitude();
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	TargetPet_StrAptitude : SetText( strName );

	strName = TargetPet : GetPFAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	TargetPet_PhysicalStrengthAptitude : SetText( strName );
	
	strName = TargetPet : GetDexAptitude();
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	TargetPet_DexterityAptitude : SetText( strName );
	
	strName = TargetPet : GetIntAptitude();
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	TargetPet_NimbusAptitude : SetText( strName );
	
	strName = TargetPet : GetStaAptitude();
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	TargetPet_StabilityAptitude : SetText( strName );
	
--	strName = TargetPet : GetExp();
--	TargetPet_Exp : SetText( "¾­Ñé:"..strName );
	
	strName = TargetPet : GetHP(nIndex);
	strName2 = TargetPet:	GetMaxHP(nIndex);
	TargetPet_Blood : SetText( "Sinh lñc:"..strName .." / ".. strName2);

	strName = TargetPet : GetStr();
	TargetPet_Str : SetText( strName );
	TargetPet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetInt();
	TargetPet_Nimbus : SetText( tonumber(strName) );
	TargetPet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetDex();
	TargetPet_Dexterity : SetText( tonumber(strName) );
	TargetPet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetPF();
	TargetPet_PhysicalStrength : SetText( tonumber(strName) );
	TargetPet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = TargetPet : GetSta();
	TargetPet_Stability : SetText( tonumber(strName) );
	TargetPet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
--	strName = TargetPet : GetBasic();
--	TargetPet_Basic : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalAttack();
	TargetPet_CriticalAttack : SetText( tonumber(strName) );

	strName = TargetPet : GetCriticalDefence();
	TargetPet_CriticalDefence : SetText( tonumber(strName) );

	strName = TargetPet : GetPotential();
	strName2 = tonumber(strName);
	TargetPet_Potential : SetText( strName2 );
	TargetPet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");

	strName = TargetPet : GetPhysicsAttack();
	TargetPet_PhysicsAttack : SetText( strName );
	
	strName = TargetPet : GetMagicAttack();
	TargetPet_MagicAttack : SetText( strName );
	
	strName = TargetPet : GetPhysicsRecovery();
	TargetPet_PhysicsRecovery : SetText( strName );
	
	strName = TargetPet : GetMagicRecovery ();
	TargetPet_MagicRecovery : SetText( strName );

	--ÉÁ±ÜÂÊ
	strName = TargetPet : GetMiss();
	TargetPet_Miss : SetText( strName );

	--ÃüÖĞÂÊ
	strName = TargetPet : GetShootProbability();
	TargetPet_ShootProbability : SetText( strName );
	
	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	
	for i=1, SumPetSkill+TARGETPETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet : EnumPetSkill( 100, i-1, "petskill");
		if( theSkillAction ~= nil and (theSkillAction : GetPetSkillOwner() == 100) and (k <= TARGETPETSKILL_BUTTONS_NUM ) ) then
			TARGETPETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k + 1;
		end
	end
	
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = TargetPet:GetTakeLevel();
	
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).." c¤p#W mang theo";

	TargetPet_NeedLevel : SetText(strNeedLevel)

	strName = TargetPet : GetGrowRate();
	TargetPet_Growth : SetText("#GChßa biªt")
	local nGrowLevel = TargetPet : GetPetGrowLevel(tonumber(strName));
	local strTbl = {"Thß¶ng ","¿u ","Ki®t ","Trác ","Tuy®t "};
	
	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c???0?????
		local nGrowRate = TargetPet : GetGrowRate();
		if(strTbl[nGrowLevel]) then
			TargetPet_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
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
	TargetPetFood_Type : Show();
	TargetPetFood_Type : SetToolTip( strName );
	
	strName,strIcon = TargetPet : GetAttackTrait();
	AxTrace(0,0,"strIcon="..strIcon)
	AxTrace(0,0,"strName="..strName)
	if strIcon ~= "" then
		TargetPetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		TargetPetAttack_Type : SetToolTip(strName)
		TargetPetAttack_Type : Show();
	end

	TargetPet_Jian : Show();
	
end

function TargetPet_Skill_Button_Clicked(nIndex)
--½«À´Ö÷¶¯¼¼ÄÜºÍ±»¶¯¼¼ÄÜ£¬¿ÉÒÔÔÚ±íÀï²éµ½¡£
--	if(nIndex < 3) then
		
--	end

--	PETSKILL_BUTTONS[nIndex] : DoAction();

--	local SumPetSkill = GetActionNum("petskill");
--	local k=1;
--	for i=1, SumPetSkill do
--		local theSkillAction = EnumAction( i-1, "petskill");
--		if( (theSkillAction : GetPetSkillOwner() == nIndex) and (k <= TARGETPETSKILL_BUTTONS_NUM ) ) then
--			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
--			k = k + 1;
--		end
--	end
end

----------------------------------------------------------------------------------
--
-- Ğı×ª äÊŞÄ£ĞÍ£¨Ïò×ó)
--
function TargetPet_Modle_TurnLeft(start)
	--Ïò×óĞı×ª¿ªÊ¼
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--Ïò×óĞı×ª¿ªÊ¼
		if(start == 1) then
			TargetPet_FakeObject:RotateBegin(-0.3);
		--Ïò×óĞı×ª½áÊø
		else
			TargetPet_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ª äÊŞÄ£ĞÍ£¨ÏòÓÒ)
--
function TargetPet_Modle_TurnRight(start)
	--ÏòÓÒĞı×ª¿ªÊ¼
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--ÏòÓÒĞı×ª¿ªÊ¼
		if(start == 1) then
			TargetPet_FakeObject:RotateBegin(0.3);
		--ÏòÓÒĞı×ª½áÊø
		else
			TargetPet_FakeObject:RotateEnd();
		end
	end
end

function TargetPet_Jian_Clicked()
	if(not (TargetPet:IsPresent()) ) then
		return;
	end
	Pet:PetOpenPetJian(-1,"target");
end
