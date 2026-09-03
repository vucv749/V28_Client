local COMMON_BUTTONS = {};
--local COMMON_LEVEL = {};
local COMMON_INDEX = {};
local Current = 1;
local COMMON_BUTTONS_NUM = 20;
local Current_Page = 0;

-- ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
local g_CommonSkill_Frame_UnifiedXPosition;
local g_CommonSkill_Frame_UnifiedYPosition;

local g_commonskill_longrangeskill = {
	_start = 3266,
	_end = 3269,
}
function CommonSkill_PreLoad()
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("UPDATE_LIFESKILL_PAGE");
	this:RegisterEvent("SKILL_UPDATE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end
	
function CommonSkill_OnLoad()
	COMMON_BUTTONS[1] = CommonSkill_Skill1;
	COMMON_BUTTONS[2] = CommonSkill_Skill2;
	COMMON_BUTTONS[3] = CommonSkill_Skill3;
	COMMON_BUTTONS[4] = CommonSkill_Skill4;
	COMMON_BUTTONS[5] = CommonSkill_Skill5;
	COMMON_BUTTONS[6] = CommonSkill_Skill6;
	COMMON_BUTTONS[7] = CommonSkill_Skill7;
	COMMON_BUTTONS[8] = CommonSkill_Skill8;
	COMMON_BUTTONS[9] = CommonSkill_Skill9;
	COMMON_BUTTONS[10] = CommonSkill_Skill10;
	COMMON_BUTTONS[11] = CommonSkill_Skill11;
	COMMON_BUTTONS[12] = CommonSkill_Skill12;
	COMMON_BUTTONS[13] = CommonSkill_Skill13;
	COMMON_BUTTONS[14] = CommonSkill_Skill14;
	COMMON_BUTTONS[15] = CommonSkill_Skill15;
	COMMON_BUTTONS[16] = CommonSkill_Skill16;
	COMMON_BUTTONS[17] = CommonSkill_Skill17;
	COMMON_BUTTONS[18] = CommonSkill_Skill18;
	COMMON_BUTTONS[19] = CommonSkill_Skill19;
	COMMON_BUTTONS[20] = CommonSkill_Skill20;
	
--	COMMON_LEVEL[1] = CommonSkill_Skill1_Text;
--	COMMON_LEVEL[2] = CommonSkill_Skill2_Text;
--	COMMON_LEVEL[3] = CommonSkill_Skill3_Text;
--	COMMON_LEVEL[4] = CommonSkill_Skill4_Text;
--	COMMON_LEVEL[5] = CommonSkill_Skill5_Text;
--	COMMON_LEVEL[6] = CommonSkill_Skill6_Text;
--	COMMON_LEVEL[7] = CommonSkill_Skill7_Text;
--	COMMON_LEVEL[8] = CommonSkill_Skill8_Text;
--	COMMON_LEVEL[9] = CommonSkill_Skill9_Text;
--	COMMON_LEVEL[10] = CommonSkill_Skill10_Text;
--	COMMON_LEVEL[11] = CommonSkill_Skill11_Text;
--	COMMON_LEVEL[12] = CommonSkill_Skill12_Text;
--	COMMON_LEVEL[13] = CommonSkill_Skill13_Text;
--	COMMON_LEVEL[14] = CommonSkill_Skill14_Text;
--	COMMON_LEVEL[15] = CommonSkill_Skill15_Text;
--	COMMON_LEVEL[16] = CommonSkill_Skill16_Text;
--	COMMON_LEVEL[17] = CommonSkill_Skill17_Text;
--	COMMON_LEVEL[18] = CommonSkill_Skill18_Text;
--	COMMON_LEVEL[19] = CommonSkill_Skill19_Text;
--	COMMON_LEVEL[20] = CommonSkill_Skill20_Text;

	for i=1,20 do
		COMMON_INDEX[i] = -1;
--		COMMON_LEVEL[i] :SetText("");
	end;
	
	CommonSkill_SetTabColor();

	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_CommonSkill_Frame_UnifiedXPosition	= CommonSkill_Frame : GetProperty("UnifiedXPosition");
	g_CommonSkill_Frame_UnifiedYPosition	= CommonSkill_Frame : GetProperty("UnifiedYPosition");

end

function CommonSkill_OnEvent(event)

	if ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		local selfUnionPos = Variable:GetVariable("SkillUnionPos");
		if(selfUnionPos ~= nil) then
			CommonSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		CommonSkill_Open();
		CommonSkill_Update();
		return;
	elseif ( event == "SKILL_UPDATE" and this:IsVisible() ) then
		CommonSkill_Update();
	elseif ( event == "TOGLE_SKILL_BOOK" ) then
		CommonSkill_Close();
	elseif ( event == "TOGLE_LIFE_PAGE" ) then
		CommonSkill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		CommonSkill_Close();
	elseif ( event == "OPEN_SHENFEN_PAGE" ) then
		CommonSkill_Close();
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ
		CommonSkill_Frame_On_ResetPos()

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ¸üÐÂ±³°ü½çÃæÎ»ÖÃ	
		CommonSkill_Frame_On_ResetPos()
	end

end

function CommonSkill_OnShown()
	CommonSkill_Update();
end

function CommonSkill_Update()
	AxTrace(0,1,"here")

	CommonSkill_Target_Skill_Name : SetText("");
	CommonSkill_Target_Skill_Explain : SetText("");
	CommonSkill_Target_Skill:SetActionItem(-1);
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_ShenFenSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);

	if Current_Page == 0 then
		CommonSkill_PageUp : Disable();
	else
		CommonSkill_PageUp : Enable();
	end
	
--	local nLifeAbilityCount = GetActionNum("life");
--	local i=1;

--	while i <= nLifeAbilityCount do
--		local theAction = EnumAction(i-1, "life");

--		if theAction:GetID() ~= 0 then
--			LIFE_BUTTONS[i]:SetActionItem(theAction:GetID());
--			LIFE_INDEX[i] = theAction:GetID();

--			local lifeid =	LifeAbility : GetLifeAbility_Number(LIFE_INDEX[i]);
--			local life_level= Player:GetAbilityInfo(lifeid,"level");
--			LIFE_LEVEL[i] : SetText(life_level);
--		end
--		i = i+1;
--	end
	
	local nSumSkill = GetActionNum("skill");
	local nCommonIndex = 1;
	
	for i=1, COMMON_BUTTONS_NUM do
		COMMON_BUTTONS[i]:SetActionItem(-1);
		COMMON_INDEX[i] = -1;
	end
	local Begin_Index = 0;
	local nSumCommonSkill = 0;
	if(Current_Page==0)then
		nCommonIndex = 3;
		local thePetFight = Pet:GetPetFightAction();
		local thePetRelex = Pet:GetPetRelaxAction();
		if(thePetFight:GetID() and thePetRelex:GetID())then
			COMMON_BUTTONS[1]:SetActionItem(thePetFight:GetID());
			COMMON_BUTTONS[2]:SetActionItem(thePetRelex:GetID());
			COMMON_INDEX[1] = thePetFight:GetID();
			COMMON_INDEX[2] = thePetRelex:GetID();
		end
	end
	for i=1, nSumSkill do
		theAction = EnumAction(i-1, "skill");
		if theAction:GetOwnerXinfa() == -9999 then			
			nSumCommonSkill = nSumCommonSkill + 1;
			if(Current_Page==0) then
				if(nSumCommonSkill == 1)then
					Begin_Index = i;
				end
			else
				if nSumCommonSkill == Current_Page*COMMON_BUTTONS_NUM+1-2  then
					Begin_Index = i;
				end	
			end
	
		end
	end
	
	
	AxTrace(0,1,"nSumCommonSkill="..nSumCommonSkill)
	
	--PushDebugMessage("sumcommon:"..tostring(nSumCommonSkill)..",index:"..tostring(Begin_Index)..",page:"..tostring(Current_Page)..",sumskill:"..tostring(nSumSkill))
	
	--bug30290£¬alan£¬2007-12-26
	--Ç°ÃæµÄ´úÂëÔÚÆ Í¨¼¼ÄÜµÚÒ»Ò³Ìí¼ÓÁË äÊÞ³ö ½Óë äÊÞÐÝÏ¢Á½¸ö¼¼ÄÜ£¬ âÑùÏàµ±ÓÚÆ Í¨¼¼ÄÜµÄ×ÜÊýÊµ¼ÊÉÏ¶àÁË2¸ö
	--ÔÚÅÐ¶ÏÊÇ·ñÔÊÐí·­Ò³°´Å¥Ê±Ò²ÐèÒª¿¼ÂÇ â¶à³öÀ´µÄ2¸ö¼¼ÄÜ
	--if (Current_Page+1)*COMMON_BUTTONS_NUM <= nSumCommonSkill then
	if (Current_Page+1)*COMMON_BUTTONS_NUM < nSumCommonSkill+2 then
		CommonSkill_PageDown : Enable();
	else
		CommonSkill_PageDown : Disable();
	end

	local Hideskill = function(skillid)
		if skillid >= g_commonskill_longrangeskill._start and skillid <= g_commonskill_longrangeskill._end then
			return 1
		end

		if skillid == 3293 or skillid == 3296 then
			return 1
		end

		if skillid >= 3593 and skillid <= 3598 then		--????
			return 1
		end

		return 0

	end
	
	AxTrace(0,1,"Current_Page="..Current_Page)
	--1+Current_Page*COMMON_BUTTONS_NUM
	if Begin_Index~=0 then
		for i=Begin_Index, nSumSkill do
			theAction = EnumAction(i-1, "skill");
			if theAction:GetOwnerXinfa() == -9999 then
				if Hideskill(theAction:GetDefineID()) == 0 then
					COMMON_BUTTONS[nCommonIndex]:SetActionItem(theAction:GetID());
					COMMON_INDEX[nCommonIndex] = theAction:GetID();
					local nCommonId = LifeAbility : GetLifeAbility_Number(COMMON_INDEX[nCommonIndex]);
					
					if(Player:GetSkillInfo(nCommonId,"learn")) then
						COMMON_BUTTONS[nCommonIndex] : Enable();
					else
						COMMON_BUTTONS[nCommonIndex] : Disable();
					end
					
					nCommonIndex = nCommonIndex+1;
		
					if nCommonIndex > COMMON_BUTTONS_NUM then
						break;
					end
				end
			end
		end
	end
	
	if(COMMON_INDEX[Current] ~= -1) then
		CommonSkill_Buttons_Clicked(Current);
	end;
	
end

function CommonSkill_Buttons_Clicked(nIndex)

	if( COMMON_INDEX[nIndex] == -1) then
		return;
	end;

	COMMON_BUTTONS[Current]:SetPushed(0);
	

--	if( Current == nIndex) then
--		return;
--	end;

	Current = nIndex;
	COMMON_BUTTONS[Current]:SetPushed(1);
	if(Current_Page==0 and (nIndex ==1 or nIndex ==2))then
		local strName = "";
		local strExplan ="";
		local thisAction;
		if(nIndex ==1 )then
			thisAction = Pet:GetPetFightAction();
			strExplan = "#{Action_Pet_Fight_Exp}"; --"#c54FF00(kéo vào thanh phím t¡t sØ døng)#r#cFFFFFFv§n khí th¶i gian: 2. 5Sao#rg÷i v« trß¾c m£t lña ch÷n Ðích Trân Thú Xu¤t Chiªn, c¥n Trân Thú Khoái LÕc TÕi 60ðã ngoài."
		else
			thisAction = Pet:GetPetRelaxAction();
			strExplan = "#{Action_Pet_Relex_Exp}";--"#c54FF00(kéo vào thanh phím t¡t sØ døng)#r#cFFFFFFv§n khí th¶i gian: 2. 5Sao#rg÷i v« trß¾c m£t lña ch÷n Ðích Trân Thú Xu¤t Chiªn, c¥n Trân Thú Khoái LÕc TÕi 60ðã ngoài."
		end
		strName = thisAction:GetName();
		CommonSkill_Target_Skill_Name : SetText( strName );
		CommonSkill_Target_Skill_Explain : SetText( strExplan);

	else
		local commonid =	LifeAbility : GetLifeAbility_Number(COMMON_INDEX[nIndex]);
		local strName = Player:GetSkillInfo(commonid,"name");
		CommonSkill_Target_Skill_Name : SetText( strName );
	
		strName = Player:GetSkillInfo(commonid,"explain");
		strName2 = Player:GetSkillInfo(commonid,"skilldata");
		CommonSkill_Target_Skill_Explain : SetText( strName.."\n"..strName2 );
	end



	
	CommonSkill_Target_Skill:SetActionItem(COMMON_INDEX[nIndex]);

	if(Player:GetSkillInfo(commonid,"passivity") == 0) then
		CommonSkill_Use : Show();
--	else
--		CommonSkill_OnClose();
	end
	
end

function CommonSkill_Button_Clicked()

	if (Current ~= -1 and COMMON_INDEX[Current] ~= -1) then	
		if(Current_Page==0 and (Current ==1 or Current ==2))then
			local thisAction;
			if(Current ==1 )then
				thisAction = Pet:GetPetFightAction();
			else
				thisAction = Pet:GetPetRelaxAction();
			end
			if(thisAction:GetID()~=0)then
				CommonSkill_Target_Skill:DoAction();
			end
		else
			local commonid =	LifeAbility : GetLifeAbility_Number(COMMON_INDEX[Current]);
		
			if(Player:GetSkillInfo(commonid,"passivity") == 0) then
				CommonSkill_Target_Skill:DoAction();
			end
		end

	end
		
end

function CommonSkill_ShenFen_Page_Switch()
	local CanOpen = 1
	local myLevel = Player:GetData("LEVEL")
	if myLevel < 50 then
		PushDebugMessage("#{YCGZ_231225_01}")
		CanOpen = 0
	end
	
	-- ÊÇ·ñÓÐÉí·Ý YCGZ_231225_02
	if CanOpen == 1 and Player:GetData("IBIDENTITYID") <= 0 then
		PushDebugMessage("#{YCGZ_231225_02}")
		CanOpen = 0
	end
	
	if CanOpen == 1 then
		OpenShenFenPage();
		CommonSkill_OnClose();
	end
	CommonSkill_ActionSkill : SetCheck(0)
	CommonSkill_LifeSkill : SetCheck(0)
	CommonSkill_AutoAttack : SetCheck(0)
	CommonSkill_ShenFenSkill : SetCheck(0)
	CommonSkill_CommonlySkill : SetCheck(1)
end

function Common_Action_Page_Switch()
	local menpai = Player:GetData("MEMPAI");
	if(menpai == 9) then
		CommonSkill_ActionSkill : SetCheck(0);
		CommonSkill_LifeSkill : SetCheck(0);
		CommonSkill_ShenFenSkill : SetCheck(0);
		CommonSkill_CommonlySkill : SetCheck(1);
		PushDebugMessage("Chßa gia nh§p môn phái.");
		return; 
	end;
	OpenSkillBook();
	CommonSkill_OnClose();
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_AutoAttack : SetCheck(0)
	CommonSkill_ShenFenSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);
end

function Common_Life_Page_Switch()
	OpenLifePage();
	CommonSkill_OnClose();
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_AutoAttack : SetCheck(0)
	CommonSkill_ShenFenSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);
end

function CommonSkill_AutoAttack_Page_Switch()
	local myLevel = Player:GetData("LEVEL")
	if myLevel >= 30 then
		PushEvent("TRIGGER_ZIDONGZHANDOU","config")
		CommonSkill_OnClose()
	else
		PushDebugMessage("#{ZDZD_200724_54}")
	end
	CommonSkill_ActionSkill : SetCheck(0)
	CommonSkill_LifeSkill : SetCheck(0)
	CommonSkill_AutoAttack : SetCheck(0)
	CommonSkill_ShenFenSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1)
end

function CommonSkill_SetTabColor()
	
	--AxTrace(0,0,tostring(idx));
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = CommonSkill_CommonlySkill,
								CommonSkill_ActionSkill,
								CommonSkill_LifeSkill,
								CommonSkill_ShenFenSkill,
							};

	local TAB_TEXT = {
		[0] = "S½ C¤p",
		"Môn phái",
		"Cuµc s¯ng",
		"Minh Hµi",
	};
	
	tab[0]:SetText(selColor..TAB_TEXT[0]);
	tab[1]:SetText(noselColor..TAB_TEXT[1]);
	tab[2]:SetText(noselColor..TAB_TEXT[2]);
	tab[3]:SetText(noselColor..TAB_TEXT[3]);
end

function CommonSkill_Page(nPage)
	
	Current_Page = Current_Page + nPage;

	CommonSkill_Update();

end

function CommonSkill_OnClose()
	Variable:SetVariable("SkillUnionPos", CommonSkill_Frame:GetProperty("UnifiedPosition"), 1);
	CommonSkill_Close();
end



function CommonSkill_Open()
	this:Show();
end
function CommonSkill_Close()
	this:Hide();
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function CommonSkill_Frame_On_ResetPos()

	CommonSkill_Frame : SetProperty("UnifiedXPosition", g_CommonSkill_Frame_UnifiedXPosition);
	CommonSkill_Frame : SetProperty("UnifiedYPosition", g_CommonSkill_Frame_UnifiedYPosition);

end
