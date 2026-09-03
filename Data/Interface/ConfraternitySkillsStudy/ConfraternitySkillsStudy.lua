--UI COMMAND ID 555 ¸üÐÂÉý¼¶Éú»î¼¼ÄÜµÄÒªÇó£¬²¢ÏÔÊ¾
--UI COMMAND ID 556 ¹Ø± Éú»î¼¼ÄÜ½çÃæ

local g_serverScriptId = 600022;
local g_MembersCtl = {};
local g_serverNpcId = -1;
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_serverBuildingId = nil;
local g_serverAbilityId	= nil;

local g_skillNeedMoney = 0;
local g_skillNeedEXP = 0;
local g_skillNeedLevel = 0;

local g_ConfraternitySkillsStudy_Frame_UnifiedPosition;
function ConfraternitySkillsStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("MONEYJZ_CHANGE");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")		
end

function ConfraternitySkillsStudy_OnLoad()
		g_ConfraternitySkillsStudy_Frame_UnifiedPosition=ConfraternitySkillsStudy_Frame:GetProperty("UnifiedPosition");
end

function ConfraternitySkillsStudy_OnEvent(event)
	Guild_Ability_SetCtl();
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 555) then
		Guild_Ability_Clear();
		
		g_serverNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
		
		g_serverAbilityId = Get_XParam_INT(1);
		g_serverBuildingId = Get_XParam_INT(7);
		
		--¸üÐÂ²¢ÏÔÊ¾
		if(g_serverAbilityId and g_serverBuildingId) then
			if(g_serverAbilityId > 0 and g_serverBuildingId > 0) then
				Guild_Ability_Update(
					Get_XParam_INT(2),	--??????????
					Get_XParam_INT(3),	--??????
					Get_XParam_INT(4),	--?????????
					Get_XParam_INT(5),	--??????????
					Get_XParam_INT(6),	--????????????
					Get_XParam_INT(8)		--??????????
				);
				
				this:CareObject(g_clientNpcId, 1, "CityAbilityUp");
				this:Show();
			end
		end
		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 556) then
		this:Hide();
	elseif ( event == "UNIT_MONEY" and this:IsVisible() ) then
		-- µ±Ç°µÄ½ðÇ®
		local nMoneyNow = Player:GetData("MONEY");
		local currColor = "FF00FF00";
		if nMoneyNow < g_skillNeedMoney then
			currColor = "FFFF0000";
		end
		--g_MembersCtl.curmon:SetProperty("MoneyColor", currColor);
		--g_MembersCtl.curmon:SetProperty("MoneyMaxNumber", nMoneyNow-1)
		g_MembersCtl.curmon:SetProperty("MoneyNumber", tostring(nMoneyNow));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		local nMoneyJZNow = Player:GetData("MONEY_JZ");
		local currColor = "FF00FF00";
		if nMoneyJZNow < g_skillNeedMoney then
			currColor = "FFFF0000";
		end			
		--g_MembersCtl.curmonjz:SetProperty("MoneyColor", currColor);
		g_MembersCtl.curmonjz:SetProperty("MoneyNumber", tostring(nMoneyJZNow));
	elseif ( event == "UNIT_EXP" and this:IsVisible() ) then
		-- µ±Ç°µÄ¾­Ñé
		local nExpNow = Player:GetData("EXP");
		local currColor = "#c00FF00";
		if nExpNow < g_skillNeedEXP then
			currColor = "#cFF0000";
		end
		g_MembersCtl.curexp.ctl:SetText(g_MembersCtl.curexp.txt..currColor..tostring(nExpNow));
	elseif ( event == "UNIT_LEVEL") then
		-- µ±Ç°µÄµÈ¼¶
		local nLevelNow = Player:GetData("LEVEL");
		local currColor = "#c00FF00";
		if nLevelNow < g_skillNeedLevel then
			currColor = "#cFF0000";
		end
		ConfraternitySkillsStudy_PlayerLevel:SetText(g_MembersCtl.hlevel.txt..currColor..tostring(nLevelNow));
	elseif ( event == "OBJECT_CARED_EVENT") then
		Guild_Ability_CareEventHandle(arg0,arg1,arg2);
	end
	
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternitySkillsStudy_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternitySkillsStudy_Frame_On_ResetPos()
	end
end

function Guild_Ability_SetCtl()
	g_MembersCtl =	{
										--1.¼¼ÄÜÃèÊöÏà¹Ø
										icon		= ConfraternitySkillsStudy_Icon,
										name 		=	{txt = "", 							ctl = ConfraternitySkillsStudy_SkillName},
										level		=	{txt = "C¤p: ", 		ctl = ConfraternitySkillsStudy_SkillLevel},
										aexp		=	{txt = "Thành thÕo: ", 	ctl = ConfraternitySkillsStudy_skilledDegree},
										hlevel	=	{txt = "C¤p: ", ctl = ConfraternitySkillsStudy_PlayerLevel},
										--2.¼¼ÄÜËµÃ÷
										desc		=	{txt = "  ",						ctl = ConfraternitySkillsStudy_Explain_Desc},
										--3.¾­Ñé¡¢°ï¹±¡¢½ðÇ®
										curexp	=	{txt = "EXP có: ", 		ctl = ConfraternitySkillsStudy_CurrentlyExp_Character_Text},
										demexp	=	{txt = "EXP c¥n: ", 		ctl = ConfraternitySkillsStudy_DemandExp_Character_Text},
										curcon	=	{txt = "C¯ng hiªn: ", 		ctl = ConfraternitySkillsStudy_CurrentlyContribute_Character_Text},
										demcon	=	{txt = "CH Bang c¥n: ",			ctl = ConfraternitySkillsStudy_DemandContribute_Character_Text},
										curmon	=	ConfraternitySkillsStudy_Currently_Money,
										curmonjz = ConfraternitySkillsStudy_Currently_Jiaozi,
										--demmon	=	ConfraternitySkillsStudy_Demand_Money,
										demmonjz = ConfraternitySkillsStudy_Demand_Jiaozi,
										--4.Éý¼¶°´Å¥
										btn			= ConfraternitySkillsStudy_UpLevel,
									};
end

function Guild_Ability_Clear()
	g_serverAbilityId = nil;
	g_serverBuildingId = nil;
	
	g_MembersCtl.icon:SetActionItem(-1);
	g_MembersCtl.name.ctl:SetText("");
	g_MembersCtl.level.ctl:SetText("");
	g_MembersCtl.aexp.ctl:SetText("");
	g_MembersCtl.hlevel.ctl:SetText("");
	
	g_MembersCtl.desc.ctl:SetText("");

	g_MembersCtl.curexp.ctl:SetText("");
	g_MembersCtl.demexp.ctl:SetText("");
	g_MembersCtl.curcon.ctl:SetText("");
	g_MembersCtl.demcon.ctl:SetText("");
	g_MembersCtl.curmon:SetProperty("MoneyNumber", 0);
	g_MembersCtl.curmonjz:SetProperty("MoneyNumber", 0);
	--g_MembersCtl.demmon:SetProperty("MoneyNumber", 0);
	g_MembersCtl.demmonjz:SetProperty("MoneyNumber", 0);
	
	--g_MembersCtl.btn:Disable(); --2006-9-19 19:58 yangjun ³öÓÚÎÈ¶¨ÐÔ¿¼ÂÊ£¬ÔÝ²»¿ØÖÆ â¸ö°´Å¥µÄ×´Ì¬¡£
end

function Guild_Ability_Update(anexp, money, level, exp, contribute, curcon)

	g_skillNeedMoney = money;
	g_skillNeedEXP = exp;
	g_skillNeedLevel = level;
	--Icon
	local nAbilityNum = GetActionNum("life");
	local theAction = nil;
	for i=0, nAbilityNum do
		theAction = EnumAction(i, "life");
		if theAction:GetDefineID() == g_serverAbilityId then
			if theAction:GetID() == 0 then
				g_MembersCtl.icon:SetActionItem(-1);
				return;
			else
				g_MembersCtl.icon:SetActionItem(theAction:GetID());
			end
			break;
		end
	end
	
	if(nil == theAction) then return; end
	local currColor = "#c00FF00";
	-- Éú»î¼¼ÄÜÃû×Ö
	local szName = theAction:GetName();
	g_MembersCtl.name.ctl:SetText(g_MembersCtl.name.txt..szName);
	-- Éú»î¼¼ÄÜµÄµÈ¼¶
	local nLevel = Player:GetAbilityInfo(g_serverAbilityId, "level");
	-- Éú»î¼¼ÄÜµÄ×î´óµÈ¼¶
	local nMaxLevel = Player:GetAbilityInfo(g_serverAbilityId, "maxlevel");
	g_MembersCtl.level.ctl:SetText(g_MembersCtl.level.txt..tostring(nLevel).."/"..tostring(nMaxLevel));
	-- Éú»î¼¼ÄÜÊìÁ·¶È
	if(-2 ~= Player:GetAbilityInfo(g_serverAbilityId,"popup")) then
		local nSkillExp = Player:GetAbilityInfo(g_serverAbilityId, "skillexp");
		if nSkillExp < anexp then
			currColor = "#cFF0000";
		else
			currColor = "#c00FF00";
		end
		g_MembersCtl.aexp.ctl:SetText(g_MembersCtl.aexp.txt..currColor..tostring(nSkillExp).."/"..tostring(anexp));
	end
	local curLevel = Player:GetData("LEVEL");
	if curLevel < level then
		currColor = "#cFF0000";
	else
		currColor = "#c00FF00";
	end
	-- ÈËÎïÐèÒªµÈ¼¶
	g_MembersCtl.hlevel.ctl:SetText(g_MembersCtl.hlevel.txt..currColor..tostring(level));
		
	-- Éú»î¼¼ÄÜ½âÊÍ
	local szExplain = Player:GetAbilityInfo(g_serverAbilityId, "explain");
	g_MembersCtl.desc.ctl:SetText(g_MembersCtl.desc.txt..szExplain);

	-- µ±Ç°µÄ¾­Ñé
	local nExpNow = Player:GetData("EXP");
	if nExpNow < exp then
		currColor = "#cFF0000";
	else
		currColor = "#c00FF00";
	end
	g_MembersCtl.curexp.ctl:SetText(g_MembersCtl.curexp.txt..currColor.. tostring(nExpNow));
	-- ÐèÒªµÄ¾­Ñé
	g_MembersCtl.demexp.ctl:SetText(g_MembersCtl.demexp.txt..tostring(exp));
	-- µ±Ç°°ï»á¹±Ï×¶È
	if curcon < contribute then
		currColor = "#cFF0000";
	else
		currColor = "#c00FF00";
	end
	g_MembersCtl.curcon.ctl:SetText(g_MembersCtl.curcon.txt.. currColor.. tostring(curcon));
	-- ÐèÒª°ï»á¹±Ï×¶È
	g_MembersCtl.demcon.ctl:SetText(g_MembersCtl.demcon.txt..tostring(contribute));
	-- µ±Ç°µÄ½ðÇ®
	local nMoneyNow = Player:GetData("MONEY");
	if nMoneyNow < money then
		currColor = "FFFF0000";
	else
		currColor = "FF00FF00";
	end
	g_MembersCtl.curmon:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--g_MembersCtl.curmon:SetProperty("MoneyColor", currColor);
	local nMoneyJZNow = Player:GetData("MONEY_JZ");
	if nMoneyJZNow < money then
		currColor = "FFFF0000";
	else
		currColor = "FF00FF00";
	end	
	g_MembersCtl.curmonjz:SetProperty("MoneyNumber", tostring(nMoneyJZNow));
	--g_MembersCtl.curmonjz:SetProperty("MoneyColor", currColor);
	--g_MembersCtl.curmon:SetProperty("MoneyMaxNumber", nMoneyNow-1)
	-- ÐèÒªµÄ½ðÇ®
	--g_MembersCtl.demmon:SetProperty("MoneyNumber", tostring(money));
	g_MembersCtl.demmonjz:SetProperty("MoneyNumber", tostring(money));
	
	g_MembersCtl.btn:Enable();
end

function Guild_Ability_LevelUp_Click()
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("OnCityAction");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,g_serverNpcId);
	Set_XSCRIPT_Parameter(1,g_serverAbilityId);
	Set_XSCRIPT_Parameter(2,g_serverBuildingId);
	Set_XSCRIPT_Parameter(3,3);			--???????
	Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
end

function Guild_Ability_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end


--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function ConfraternitySkillsStudy_Frame_On_ResetPos()
  ConfraternitySkillsStudy_Frame:SetProperty("UnifiedPosition", g_ConfraternitySkillsStudy_Frame_UnifiedPosition);
end
