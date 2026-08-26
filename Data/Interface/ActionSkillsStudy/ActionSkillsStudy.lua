
local XINFA_BUTTONS_NUM = 8;
local XINFA_BUTTONS = {};

local SKILL_BUTTONS_NUM = 5;
local SKILL_BUTTONS = {};

local g_XinfaID = {};
local g_XinfaDefineID = {};

local g_SkillID = {};

-- µ±Ç°Ñ¡ÖÐµÄButton£¬Èç¹ûÑ¡ÖÐµÄÊÇXinfa£¬ÖµµÈÓÚXinfaµÄnIndex
-- 									 Èç¹ûÑ¡ÖÐµÄÊÇSkill£¬ÖµµÈÓÚSkillµÄnIndex + XINFA_BUTTONS_NUM
local g_CurSelectButton;

-- µ±Ç°Ñ¡ÖÐµÄÐÄ·¨
local g_CurSelect;

--µ±Ç°Ñ¡ÖÐµÄÐÄ·¨Id
local g_CurSelectXinfaId;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


local MenPai_UsedAttr = {
[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--??
[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", Tooltip = "MPZSX_20071221_12",},				--??
[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", Tooltip = "MPZSX_20071221_15",},		--??
[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", Tooltip = "MPZSX_20071221_16",},			--??
[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", Tooltip = "MPZSX_20071221_17",},			--??
[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", Tooltip = "MPZSX_20071221_14",},			--??
[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", Tooltip = "MPZSX_20071221_18",}, 			--??
[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", Tooltip = "MPZSX_20071221_11",},				--??
[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", Tooltip = "MPZSX_20071221_19",},		--??
[9] = {image = "", Tooltip = "Tñ do",},															--???
[10]= {image = "set:CommonFrame38 image:Shuxing_ManTuoDarkPoison", Tooltip = "MPZSX_20071221_20",},				--mtsz
};


local g_ActionSkillsStudy_sectskill = 
{
	787,
	3294,
	3295,
	3828,
	3829,
}


function ActionSkillsStudy_IsSectSkill(id)
	for i,v in pairs(g_ActionSkillsStudy_sectskill) do
		if v == id then
			return 1
		end
	end

	return 0
end

--===============================================
-- OnLoad()
--===============================================
function ActionSkillsStudy_PreLoad()

	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("SKILLSTUDY_SUCCEED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("MONEYJZ_CHANGE");

end

function ActionSkillsStudy_OnLoad()
	XINFA_BUTTONS[1] = ActionSkillsStudy_XinfaSkill_1;
	XINFA_BUTTONS[2] = ActionSkillsStudy_XinfaSkill_2;
	XINFA_BUTTONS[3] = ActionSkillsStudy_XinfaSkill_3;
	XINFA_BUTTONS[4] = ActionSkillsStudy_XinfaSkill_4;
	XINFA_BUTTONS[5] = ActionSkillsStudy_XinfaSkill_5;
	XINFA_BUTTONS[6] = ActionSkillsStudy_XinfaSkill_6;
	XINFA_BUTTONS[7] = ActionSkillsStudy_XinfaSkill_7;
	XINFA_BUTTONS[8] = ActionSkillsStudy_XinfaSkill_8;

	SKILL_BUTTONS[1] = ActionSkillsStudy_ZhaoshiSkill_1;
	SKILL_BUTTONS[2] = ActionSkillsStudy_ZhaoshiSkill_2;
	SKILL_BUTTONS[3] = ActionSkillsStudy_ZhaoshiSkill_3;
	SKILL_BUTTONS[4] = ActionSkillsStudy_ZhaoshiSkill_4;
	SKILL_BUTTONS[5] = ActionSkillsStudy_ZhaoshiSkill_5;

	g_CurSelectButton = 1;
	g_CurSelect				= 1;

end

--===============================================
-- ActionSkillsStudy_OnEvent
--===============================================
function ActionSkillsStudy_OnEvent(event)

	if(event == "TOGLE_SKILLSTUDY") then
		--¹ØÐÄNPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "ActionSkillsStudy");

		this:Show();
		ActionSkillsStudy_UpdateFrame();
		ActionSkillsStudy_NpcName:SetText("#gFF0FA0" ..Target:GetXinfaNpcName());

	--Ë¢ÐÂ½ðÇ®
	elseif(event == "UNIT_MONEY") then
		local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

		ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--Ë¢ÐÂ½»×Ó
	elseif (event == "MONEYJZ_CHANGE") then
		ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	--Ë¢ÐÂ¾­ÑéÖµ
	elseif(event == "UNIT_EXP") then

		local nExpNow = Player:GetData("EXP");
		ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP có:" .. tostring(nExpNow));

	-- ÈËÎïÉý¼¶
	elseif(event == "UNIT_LEVEL") then
		ActionSkillsStudy_UpdateFrame();

	elseif(event == "SKILLSTUDY_SUCCEED") then
		ActionSkillsStudy_UpdateFrame();

	elseif (event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "ActionSkillsStudy");
		end

	end
end

--===============================================
-- UpdateFrame
--===============================================
function ActionSkillsStudy_UpdateFrame()

	-- Xinfa
	local i=1;
	local nActionIndex = 0;

	local nPlayerLevel = Player:GetData("LEVEL")

	--»æÖÆÐÄ·¨Í¼±ê
	while i<= XINFA_BUTTONS_NUM do

		local theAction = EnumAction(nActionIndex, "xinfa");

		if (theAction:GetID() == 0) then
			XINFA_BUTTONS[i]:SetActionItem(-1);
			g_XinfaID[i] = -1;
			g_XinfaDefineID[i] = -1;
		else
			XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());
			--¼ÇÂ¼Ã¿¸ö¸ñ×ÓµÄÐÄ·¨ID
			g_XinfaID[i] = theAction:GetID();
			g_XinfaDefineID[i] = theAction:GetDefineID();

			-- Èç¹ûÍæ¼Ò²»µ½20¼¶£¬ÄÇÃ´Ëû½«ÓÐ²¿·ÖµÄÐÄ·¨²»ÄÜÉý¼¶
			if nPlayerLevel < 20  then
				XINFA_BUTTONS[2]:Disable()
				XINFA_BUTTONS[3]:Disable()
				XINFA_BUTTONS[6]:Disable()
			else
				XINFA_BUTTONS[2]:Enable()
				XINFA_BUTTONS[3]:Enable()
				XINFA_BUTTONS[6]:Enable()
			end
		end


		i = i+1;
		nActionIndex = nActionIndex + 1;

	end

	--Íæ¼ÒÉíÉÏ½ðÇ®
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

	ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	--ActionSkillsStudy_Icon_Gold_Currently_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Currently_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Currently_Text:SetText(tostring(nCopperCoin));

	--Íæ¼ÒÒÑ¾­È¡µÃµÄ¾­Ñé
	local nExpNow = Player:GetData("EXP");
	ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP có:" .. tostring(nExpNow));

	--¸üÐÂµ±Ç°Ñ¡ÖÐµÄÐÄ·¨µÄ¼¼ÄÜ
	ActionSkillsStudy_Xinfa_Clicked(g_CurSelect);
	--¸üÐÂÖ÷ÊôÐÔÐÅÏ¢
	ActionSkillsStudy_UpdateMenPaiText();

end

--===============================================
-- ¼¼ÄÜµÄ¸üÐÂ»æÖÆ
--===============================================
function ActionSkillsStudy_UpdateSkill( nIndex )

	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetActionItem(-1);
		g_SkillID[i] = -1;
	end

		local nSumSkill = GetActionNum("skill");
		local nSkillIndex = 1;

		--AxTrace(0,0,"nSumSkill = ".. nSumSkill);


		for i=1, nSumSkill do
			theAction = EnumAction(i-1, "skill");

			if theAction:GetOwnerXinfa() == g_XinfaID[nIndex] and ActionSkillsStudy_IsSectSkill(theAction:GetDefineID()) == 0 then
				SKILL_BUTTONS[nSkillIndex]:SetActionItem(theAction:GetID());
				g_SkillID[nSkillIndex] = theAction:GetID();
				--AxTrace(0,0,"g_SkillID[nSkillIndex] = ".. g_SkillID[nSkillIndex]);
				nSkillIndex = nSkillIndex+1;
			end
		end
end

--===============================================
-- ¸üÐÂÒ»¸ö¼¼ÄÜÍ¼±êµÄ²Ù×÷
--===============================================
function ActionSkillsStudy_SkillInfo_Update( SkillID )

	--ActionSkillsStudy_XinfaSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Show();
	ActionSkillsStudy_SkillIcon:Show();

	ActionSkillsStudy_SkillIcon:SetActionItem( -1 );
	ActionSkillsStudy_SkillIcon:SetActionItem( SkillID );

	if(SkillID == -1)then

		--Çå¿ ¼¼ÄÜ
		ActionSkillsStudy_SkillName:SetText("");
		ActionSkillsStudy_SkillLevel:SetText("");
		ActionSkillsStudy_SkillInfo:SetText("");

		return;
	end

	local nSkillId = LifeAbility : GetLifeAbility_Number(SkillID);


	--¸üÐÂ¼¼ÄÜÐÅÏ¢
	local szInfo = Player:GetSkillInfo(nSkillId,"explain");
	local szName = Player:GetSkillInfo(nSkillId,"name");
	--local szSkillData = Player:GetSkillInfo(nSkillId,"skilldata");

	ActionSkillsStudy_SkillName:SetText(szName);
	ActionSkillsStudy_SkillLevel:SetText("");
	ActionSkillsStudy_SkillInfo:SetText(szInfo);

end

--===============================================
-- ¸üÐÂÒ»¸öÐÄ·¨Í¼±êµÄ²Ù×÷
--===============================================
function ActionSkillsStudy_XinfaInfo_Update( nIndex )--XinfaID

	ActionSkillsStudy_SkillIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Show();
	--ActionSkillsStudy_XinfaSkillIcon_Frame:Show();

	ActionSkillsStudy_XinfaIcon:SetActionItem( -1 );
	ActionSkillsStudy_XinfaIcon:SetActionItem( g_XinfaID[nIndex] );

	--»ñµÃÏÖÔÚµÄÐÄ·¨µÈ¼¶
	local nXinfaLevel = GetXinfaLevel( g_XinfaDefineID[nIndex] );

	--»ñµÃÉý¼¶ÐÄ·¨ÐèÒªµÄ½ðÇ®
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = GetUplevelXinfaSpendMoney(g_XinfaDefineID[nIndex],nXinfaLevel + 1);
	--»ñµÃÉý¼¶ÐÄ·¨ÐèÒªµÄ¾­Ñé
	local nExp = GetUplevelXinfaSpendExp(g_XinfaDefineID[nIndex],nXinfaLevel + 1);

	--ActionSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--ActionSkillsStudy_Icon_Gold_Demand_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Demand_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Demand_Text:SetText(tostring(nCopperCoin));

	ActionSkillsStudy_DemandExp_Character_Text:SetText("EXP c¥n:" .. tostring(nExp));

end

--===============================================
-- Íæ¼Òµã»÷Ñ§Ï°µÄÏìÓ¦
--===============================================
function ActionSkillsStudy_UpLevel_Clicked()
	--AxTrace(0, 0, "ActionSkillsStudy_Study" );

	--if (g_CurSelectButton < 1  or  g_CurSelectButton > XINFA_BUTTONS_NUM) then
	--	return;
		--ÐèÒªÌáÊ¾²»ÄÜÉý¼¶¼¼ÄÜ
	--end

	-- ´¦ÀíÑ§Ï°
	SkillsStudyFrame_study( g_XinfaDefineID[g_CurSelect] );
end

--===============================================
-- Ñ¡ÖÐÒ»¸öÐÄ·¨Í¼±ê
--===============================================
function ActionSkillsStudy_Xinfa_Clicked(nIndex)

	--AxTrace(0, 0, "ActionSkillsStudy_Xinfa_Clicked " ..nIndex );
	-- Êý¾Ý³¬¹ý·¶Î§£¬·µ»Ø
	if(nIndex < 1 or nIndex > XINFA_BUTTONS_NUM) then
		return;
	end

	if g_XinfaID[nIndex] == -1 then
		return
	end

	local i = 1;
	for i=1, XINFA_BUTTONS_NUM do
		if(i==nIndex) then
			XINFA_BUTTONS[i]:SetPushed(1);
		else
			XINFA_BUTTONS[i]:SetPushed(0);
		end
	end

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetPushed(0);
	end

	local nXinfaId = LifeAbility : GetLifeAbility_Number(g_XinfaID[nIndex]);

	--¸üÐÂ¼¼ÄÜµÄËµÃ÷
	local strName = Player:GetXinfaInfo(nXinfaId,"name");
	local nLevel= Player:GetXinfaInfo(nXinfaId,"level");
	local strInfo = Player:GetXinfaInfo(nXinfaId,"explain");

	ActionSkillsStudy_SkillName:SetText(strName);
	ActionSkillsStudy_SkillLevel:SetText("Trß¾c m£t c¤p b§c:".. nLevel);
	ActionSkillsStudy_SkillInfo:SetText(strInfo);

	--¸üÐÂ¼¼ÄÜ
	ActionSkillsStudy_UpdateSkill( nIndex );

	--¸üÐÂËµÃ÷ÄÚÈÝ
	ActionSkillsStudy_XinfaInfo_Update( nIndex );

	g_CurSelectButton = nIndex;
	g_CurSelect				= nIndex;
end

--===============================================
-- Ñ¡ÖÐÒ»¸ö¼¼ÄÜÍ¼±ê
--===============================================
function ActionSkillsStudy_Skill_Clicked(nIndex)

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		if(i==nIndex) then
			SKILL_BUTTONS[i]:SetPushed(1);
		else
			SKILL_BUTTONS[i]:SetPushed(0);
		end
	end

	--AxTrace(0, 0, "ActionSkillsStudy_Skill_Clicked  " ..nIndex );
	if(nIndex < 1 or nIndex > SKILL_BUTTONS_NUM) then
		return;
	end

	g_CurSelectButton = nIndex + XINFA_BUTTONS_NUM;

	--¸üÐÂËµÃ÷ÄÚÈÝ
	ActionSkillsStudy_SkillInfo_Update( g_SkillID[nIndex] )

end


--===============================================
-- Close
--===============================================
function ActionSkillsStudy_Close_Cilcked()
	this:Hide()
	--È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "ActionSkillsStudy");

end


function ActionSkillsStudy_ClearStaticImage()
	ActionSkillsStudy_MenPai_ICON : SetProperty("Tooltip", "");
	ActionSkillsStudy_MenPai_ICON : SetProperty("Image","");
end

function ActionSkillsStudy_UpdateMenPaiText()
	local menpaiID = Player : GetData("MEMPAI");		--??????ID
	if menpaiID ~= nil and menpaiID >=0 and menpaiID <=10 then
		if (menpaiID == 9) then
			ActionSkillsStudy_ClearStaticImage();
			ActionSkillsStudy_MenPai_Attr_Intro : SetText(""); --???????????
			return;
		end
		local	str = GetDictionaryString( "MPZSX_20071221_0" .. (menpaiID +1) );
		ActionSkillsStudy_MenPai_Attr_Intro : SetText("#Y" .. str);
		--ActionSkillsStudy_ClearStaticImage();

		ActionSkillsStudy_MenPai_ICON : SetToolTip(GetDictionaryString(MenPai_UsedAttr[menpaiID].Tooltip));
		ActionSkillsStudy_MenPai_ICON : SetProperty("Image",MenPai_UsedAttr[menpaiID].image);
	end
end
