local LIFE_BUTTONS = {};
local LIFE_INDEX = {};
local LIFE_LEVEL = {};
local Current = 1;
local IsHave26Ability = 0;
local Max_SkillExp = {};
local Current_Page = 0;
local MaxValidID = 0;
local LIFE_BUTTONS_NUM = 20;
local All_SkillID ={};

-- ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
local g_LifeSkill_Frame_UnifiedXPosition;
local g_LifeSkill_Frame_UnifiedYPosition;

function LifeSkill_PreLoad()
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("UPDATE_LIFESKILL_PAGE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
	
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

end

function LifeSkill_OnLoad()
	LIFE_BUTTONS[1] = LifeSkill_Skill1;
	LIFE_BUTTONS[2] = LifeSkill_Skill2;
	LIFE_BUTTONS[3] = LifeSkill_Skill3;
	LIFE_BUTTONS[4] = LifeSkill_Skill4;
	LIFE_BUTTONS[5] = LifeSkill_Skill5;
	LIFE_BUTTONS[6] = LifeSkill_Skill6;
	LIFE_BUTTONS[7] = LifeSkill_Skill7;
	LIFE_BUTTONS[8] = LifeSkill_Skill8;
	LIFE_BUTTONS[9] = LifeSkill_Skill9;
	LIFE_BUTTONS[10] = LifeSkill_Skill10;
	LIFE_BUTTONS[11] = LifeSkill_Skill11;
	LIFE_BUTTONS[12] = LifeSkill_Skill12;
	LIFE_BUTTONS[13] = LifeSkill_Skill13;
	LIFE_BUTTONS[14] = LifeSkill_Skill14;
	LIFE_BUTTONS[15] = LifeSkill_Skill15;
	LIFE_BUTTONS[16] = LifeSkill_Skill16;
	LIFE_BUTTONS[17] = LifeSkill_Skill17;
	LIFE_BUTTONS[18] = LifeSkill_Skill18;
	LIFE_BUTTONS[19] = LifeSkill_Skill19;
	LIFE_BUTTONS[20] = LifeSkill_Skill20;
	
--	LIFE_LEVEL[1] = LifeSkill_Skill1_Text;
--	LIFE_LEVEL[2] = LifeSkill_Skill2_Text;
--	LIFE_LEVEL[3] = LifeSkill_Skill3_Text;
--	LIFE_LEVEL[4] = LifeSkill_Skill4_Text;
--	LIFE_LEVEL[5] = LifeSkill_Skill5_Text;
--	LIFE_LEVEL[6] = LifeSkill_Skill6_Text;
--	LIFE_LEVEL[7] = LifeSkill_Skill7_Text;
--	LIFE_LEVEL[8] = LifeSkill_Skill8_Text;
--	LIFE_LEVEL[9] = LifeSkill_Skill9_Text;
--	LIFE_LEVEL[10] = LifeSkill_Skill10_Text;
--	LIFE_LEVEL[11] = LifeSkill_Skill11_Text;
--	LIFE_LEVEL[12] = LifeSkill_Skill12_Text;
--	LIFE_LEVEL[13] = LifeSkill_Skill13_Text;
--	LIFE_LEVEL[14] = LifeSkill_Skill14_Text;
--	LIFE_LEVEL[15] = LifeSkill_Skill15_Text;
--	LIFE_LEVEL[16] = LifeSkill_Skill16_Text;
--	LIFE_LEVEL[17] = LifeSkill_Skill17_Text;
--	LIFE_LEVEL[18] = LifeSkill_Skill18_Text;
--	LIFE_LEVEL[19] = LifeSkill_Skill19_Text;
--	LIFE_LEVEL[20] = LifeSkill_Skill20_Text;
	
	
	Max_SkillExp[1] = 10
	Max_SkillExp[2] = 30
	Max_SkillExp[3] = 60
	Max_SkillExp[4] = 100
	Max_SkillExp[5] = 150
	Max_SkillExp[6] = 210
	Max_SkillExp[7] = 280
	Max_SkillExp[8] = 360
	Max_SkillExp[9] = 450
	Max_SkillExp[10] = 5500
	Max_SkillExp[11] = 5500
	Max_SkillExp[12] = 5500
	for i=1,20 do
		LIFE_INDEX[i] = -1;
--		LIFE_LEVEL[i] :SetText("");
	end;
	
	LifeSkill_SetTabColor();

	-- ±£¥ÊΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
	g_LifeSkill_Frame_UnifiedXPosition	= LifeSkill_Frame : GetProperty("UnifiedXPosition");
	g_LifeSkill_Frame_UnifiedYPosition	= LifeSkill_Frame : GetProperty("UnifiedYPosition");

end

function LifeSkill_OnEvent(event)
	if ( event == "TOGLE_LIFE_PAGE" ) then
		local selfUnionPos = Variable:GetVariable("SkillUnionPos");
		if(selfUnionPos ~= nil) then
			LifeSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		Life_Skill_Open();
		LifeSkill_Update();
		return;
	elseif ( event == "UPDATE_LIFESKILL_PAGE" and this:IsVisible() ) then
		LifeSkill_Update();
	elseif ( event == "TOGLE_SKILL_BOOK" ) then
		Life_Skill_Close();
	elseif ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		Life_Skill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		Life_Skill_Close();
	elseif ( event == "OPEN_SHENFEN_PAGE" ) then
		Life_Skill_Close();

	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	elseif (event == "ADJEST_UI_POS" ) then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√
		LifeSkill_Frame_On_ResetPos()

	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- ∏¸–¬±≥∞¸ΩÁ√ÊŒª÷√	
		LifeSkill_Frame_On_ResetPos()

	end

end

function LifeSkill_OnShown()
	LifeSkill_Update();
end

function LifeSkill_Update()

	LifeSkill_Next1 : Hide();
--	LifeSkill_Next2 : Hide();
--	LifeSkill_Next3 : Hide();
	LifeSkill_Target_Skill_Name : SetText("");
	LifeSkill_Target_Skill_Explain : SetText("");
	LifeSkill_Target_Skill_Sleight:SetText( "" );
	LifeSkill_Target_Skill:SetActionItem(-1);
	LifeSkill_ActionSkill : SetCheck(0);
	LifeSkill_CommonlySkill : SetCheck(0);
	LifeSkill_ShenFenSkill : SetCheck(0)
	LifeSkill_LifeSkill : SetCheck(1);

	local nLifeAbilityCount = GetActionNum("life");
	local maxValidID = 1;
	for index = 0, nLifeAbilityCount do
		local theAction = EnumAction(index, "life");
		if theAction:GetID() ~= 0 then
			local defineID = theAction:GetDefineID()
			if defineID == 54 or defineID == 55 or defineID == 56 then
				local aLevel = Player:GetAbilityInfo(defineID, "level")
				if tonumber(aLevel) == nil or tonumber(aLevel) == 0 then
					continue
				end
			end
			--¥À¥¶ÃÌº”≤ªœ‘ æ‘⁄…˙ªÓººƒ‹ΩÁ√Ê¿Ôµƒ…˙ªÓººƒ‹
			if defineID ~= 26 and defineID ~= 38 and defineID ~= 50 and defineID ~= 51
			and defineID ~= 57 and defineID ~= 58 
			and defineID ~= 59 and defineID ~= 60 and defineID ~= 61 and defineID ~= 62
			and defineID ~= 63 and defineID ~= 64
			then
				All_SkillID[ maxValidID ] = theAction:GetID();
				maxValidID = maxValidID + 1;
			end
		end
	end
	--µ√µΩµ±«∞◊Ó∂‡ø…œ‘ æµƒid ˝¡ø
	MaxValidID = maxValidID - 1;
	
	--»Áπ˚µ±«∞Œ™µ⁄“ª“≥£¨…œ∑≠∞¥≈•ª“µÙ	
	if Current_Page == 0 then
		LifeSkill_UPdata1 : Disable();
	else
		LifeSkill_UPdata1 : Enable();
	end
		
	local curMaxNumber = 0;
	if( ( Current_Page + 1 ) * LIFE_BUTTONS_NUM <= MaxValidID ) then
		curMaxNumber = ( Current_Page + 1 ) * LIFE_BUTTONS_NUM;
		LifeSkill_UPdata2 : Enable();
	else
		curMaxNumber = MaxValidID;
		LifeSkill_UPdata2 : Disable();
	end
	
	for i=1, LIFE_BUTTONS_NUM do
		LIFE_BUTTONS[i]:SetActionItem(-1);
		LIFE_INDEX[i] = -1;
	end
	
	local Begin_Index = Current_Page * LIFE_BUTTONS_NUM + 1;
	AxTrace( 1,0,"MaxValidID="..tostring( MaxValidID ).."    Begin_Index="..tostring(Begin_Index).."    curMaxNumber="..tostring(curMaxNumber)     );
	i = 1;
	for idx=Begin_Index,curMaxNumber do
		AxTrace( 1,0,"idx="..tostring( idx ).."      id="..tostring(All_SkillID[idx])  );
		LIFE_BUTTONS[i]:SetActionItem( All_SkillID[idx] );
		LIFE_INDEX[i] = All_SkillID[idx];
		i = i + 1;
	end
	
	if(LIFE_INDEX[Current] ~= -1) then
		LifeSkill_Buttons_Clicked(Current);
	end

end


function LifeSkill_Buttons_Clicked(nIndex)

	if( LIFE_INDEX[nIndex] == -1) then
		return;
	end;

	LIFE_BUTTONS[Current]:SetPushed(0);
	local lifeid =	LifeAbility : GetLifeAbility_Number(LIFE_INDEX[nIndex]);

--	if( Current == nIndex) then
--		return;
--	end;

	Current = nIndex;
	LIFE_BUTTONS[Current]:SetPushed(1);
	local popup = Player:GetAbilityInfo(lifeid,"popup");
	if(tonumber(popup) == 2) then
		LifeSkill_Next1 : Show();
		LifeSkill_Next1 : SetText("Kh‰m")
--		LifeSkill_Next2 : Show();
--		LifeSkill_Next3 : Hide();
	elseif ( popup == 1 ) then
		LifeSkill_Next1 : Show();
		LifeSkill_Next1 : SetText("T’o")
--		LifeSkill_Next2 : Hide();
--		LifeSkill_Next3 : Hide();
	elseif popup == 3 then
		LifeSkill_Next1:Show()
		LifeSkill_Next1:SetText("Ch™ t·c")
	elseif popup == 4 then
		LifeSkill_Next1:Show()
		LifeSkill_Next1:SetText("Ch™ t·c")
	else
		LifeSkill_Next1 : Hide();
--		LifeSkill_Next2 : Hide();
--		LifeSkill_Next3 : Hide();
	end

	local realAbilityId = lifeid
	if lifeid == 65 then
		realAbilityId = Player:GetData("IBIDENTITYSKILLID")
		if realAbilityId == -1 or realAbilityId == nil then
			return
		end
	end
	
	local strName = Player:GetAbilityInfo(lifeid,"name");
 	local strName2= Player:GetAbilityInfo(lifeid,"level");
	if realAbilityId ~= -1 then
		strName2= Player:GetAbilityInfo(realAbilityId,"level");
	end
 	local level = tonumber(strName2);
	LifeSkill_Target_Skill_Name : SetText( strName );
	LifeSkill_Target_Skill_Level : SetText("C§p: " .. strName2);
	
	strName = Player:GetAbilityInfo(lifeid,"explain");
	LifeSkill_Target_Skill_Explain : SetText( strName );
	
	local max_exp;
	if level > 12 or level < 1 then
		max_exp = "8"
	else
--		max_exp = Max_SkillExp[level]
		max_exp = LifeAbility : GetLifeAbility_LimitExp(lifeid,level);
		
		if realAbilityId ~= -1 then
			max_exp = LifeAbility : GetLifeAbility_LimitExp(realAbilityId,level);
		end
	end
	
	strName = Player:GetAbilityInfo(lifeid,"skillexp");	
	if realAbilityId ~= -1 then
		strName = Player:GetAbilityInfo(realAbilityId,"skillexp");	
	end
	LifeSkill_Target_Skill_Sleight:SetText( "Thu•n th¯c –µ:"..strName.."/"..max_exp);

	LifeSkill_Target_Skill:SetActionItem( LIFE_INDEX[nIndex] );
--—Ó“´µƒ…Ëº∆£¨¡ıÃ˙Àµ≤ª“™£¨À˘“‘◊¢ Õ“‘œ¬¥˙¬Î
--	LifeAbility : Update_Synthesize(lifeid);
--------------------------------------------
end

function LifeSkill_Synthesize_Clicked()
	
	if Current ~= -1  then
		LifeSkill_Target_Skill:DoAction();
	end
		
end

--function Life_Page_Switch()
--	OpenSkillBook();
--	Life_Skill_Close();
--	LifeSkill_ActionSkill : SetCheck(0);
--	LifeSkill_LifeSkill : SetCheck(1);
--end

function LifeSkill_ShenFen_Page_Switch()
	local CanOpen = 1
	local myLevel = Player:GetData("LEVEL")
	if myLevel < 50 then
		PushDebugMessage("#{YCGZ_231225_01}")
		CanOpen = 0
	end
	
	--  «∑Ò”–…Ì∑› YCGZ_231225_02
	if CanOpen == 1 and Player:GetData("IBIDENTITYID") <= 0 then
		PushDebugMessage("#{YCGZ_231225_02}")
		CanOpen = 0
	end
	
	if CanOpen == 1 then
		OpenShenFenPage();
		Life_Skill_Close();
	end
	
	LifeSkill_CommonlySkill : SetCheck(0);
	LifeSkill_ActionSkill : SetCheck(0);
	LifeSkill_AutoAttack: SetCheck(0)
	LifeSkill_ShenFenSkill : SetCheck(0)
	LifeSkill_LifeSkill : SetCheck(1);
end

function LifeSkill_Compose_Gem_Clicked(arg)
	LifeAbility : Open_Compose_Gem_Page(arg);
end

function Life_Action_Page_Switch()
	local menpai = Player:GetData("MEMPAI");
	if(menpai == 9) then 
		LifeSkill_CommonlySkill : SetCheck(0);
		LifeSkill_ActionSkill : SetCheck(0);
		LifeSkill_ShenFenSkill : SetCheck(0)
		LifeSkill_LifeSkill : SetCheck(1);
		PushDebugMessage("Chﬂa gia nhßp mÙn ph·i.");
		return; 
	end;
	OpenSkillBook();
	Life_Skill_Close();
	LifeSkill_CommonlySkill : SetCheck(0);
	LifeSkill_ActionSkill : SetCheck(0);
	LifeSkill_AutoAttack: SetCheck(0)
	LifeSkill_ShenFenSkill : SetCheck(0)
	LifeSkill_LifeSkill : SetCheck(1);
end

function Life_Common_Page_Switch()
	OpenCommonSkillPage();
	Life_Skill_Close();
	LifeSkill_CommonlySkill : SetCheck(0);
	LifeSkill_ActionSkill : SetCheck(0);
	LifeSkill_AutoAttack: SetCheck(0)
	LifeSkill_ShenFenSkill : SetCheck(0)
	LifeSkill_LifeSkill : SetCheck(1);
end

function LifeSkill_AutoAttack_Page_Switch()
	local myLevel = Player:GetData("LEVEL")
	if myLevel >= 30 then
		Life_Skill_Close()
		PushEvent("TRIGGER_ZIDONGZHANDOU","config")
	else
		PushDebugMessage("#{ZDZD_200724_54}")
	end

	LifeSkill_CommonlySkill : SetCheck(0)
	LifeSkill_ActionSkill : SetCheck(0)
	LifeSkill_AutoAttack: SetCheck(0)
	LifeSkill_ShenFenSkill : SetCheck(0)
	LifeSkill_LifeSkill : SetCheck(1)
end

function Life_Skill_Close()
	Variable:SetVariable("SkillUnionPos", LifeSkill_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function LifeSkill_SetTabColor()
	
	--AxTrace(0,0,tostring(idx));
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = LifeSkill_CommonlySkill,
								LifeSkill_ActionSkill,
								LifeSkill_LifeSkill,
								LifeSkill_ShenFenSkill,
							};

	local TAB_TEXT = {
		[0] = "SΩ C§p",
		"MÙn ph·i",
		"Cuµc sØng",
		"Minh Hµi",
	};
	
	tab[0]:SetText(noselColor..TAB_TEXT[0]);
	tab[1]:SetText(noselColor..TAB_TEXT[1]);
	tab[2]:SetText(selColor..TAB_TEXT[2]);
	tab[3]:SetText(noselColor..TAB_TEXT[3]);
end

function Life_Skill_Open()
	this:Show();
end

function LifeSkill_Page(nPage)
	
	Current_Page = Current_Page + nPage;

	LifeSkill_Update();

end

--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function LifeSkill_Frame_On_ResetPos()

	LifeSkill_Frame : SetProperty("UnifiedXPosition", g_LifeSkill_Frame_UnifiedXPosition);
	LifeSkill_Frame : SetProperty("UnifiedYPosition", g_LifeSkill_Frame_UnifiedYPosition);

end
