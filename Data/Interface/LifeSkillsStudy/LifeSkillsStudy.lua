local g_nAbilityID = -1;

local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

--===============================================
-- OnLoad()
--===============================================
function LifeSkillsStudy_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("TOGLE_ABILITY_STUDY");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function LifeSkillsStudy_OnLoad()
	
end										

--===============================================
-- LifeSkillsStudy_OnEvent
--===============================================
function LifeSkillsStudy_OnEvent(event)
	if(event == "TOGLE_ABILITY_STUDY") then
		this:Show();
		
		--ÉèÖÃ¹ØÐÄNPC
		objCared = LifeAbility:GetNpcId();
		this:CareObject(objCared, 1, "AbilityStudy");
	
		LifeSkillsStudy_UpdateFrame();
		LifeSkillsStudy_UpLevel:Enable();
		
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 713587 ) then
		if g_nAbilityID ~= -1 then
			local nLevel = Player:GetAbilityInfo(g_nAbilityID, "level");
			local nMaxLevel = Player:GetAbilityInfo(g_nAbilityID, "maxlevel");
			LifeSkillsStudy_SkillLevel:SetText("C¤p:".. tostring(nLevel).."/"..tostring(nMaxLevel));
		end
				
	elseif(event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			Bank:Close();

			--È¡Ïû¹ØÐÄ
			this:CareObject(objCared, 0, "AbilityStudy");
		end
		
	elseif(event == "UNIT_MONEY" and this:IsVisible()) then
		local nMoneyNow = Player:GetData("MONEY");
		LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
		
	elseif(event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		
		LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif(event == "UNIT_LEVEL" and this:IsVisible()) then 
		
		
	elseif(event == "UNIT_EXP" and this:IsVisible()) then
		local nExpNow = Player:GetData("EXP");
		LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP có:" .. tostring(nExpNow));
		
	end
	
end

--===============================================
-- LifeSkillsStudy_UpdateFrame
--===============================================
function LifeSkillsStudy_UpdateFrame()

	--¼¼ÄÜID
	g_nAbilityID = AbilityTeacher:GetAbilityID();
	
	
	--µ±Ç°µÄ½ðÇ®
	local nMoneyNow = Player:GetData("MONEY");
	LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	
	--µ±Ç°µÄ½»×Ó
	LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	--ÐèÒªµÄ½ðÇ®
	nMoneyNow,nGold,nSilverCoin,nCopperCoin = AbilityTeacher:GetNeedMoney();
	LifeSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));

	--µ±Ç°µÄ¾­Ñé
	local nExpNow = Player:GetData("EXP");
	LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("EXP có:" .. tostring(nExpNow));
	
	--ÐèÒªµÄ¾­Ñé
	local nNeedExp = AbilityTeacher:GetNeedExp();
	LifeSkillsStudy_DemandExp_Character_Text:SetText("EXP c¥n:" .. tostring(nNeedExp));

	ActionSkillsStudy_UpdateAbility(g_nAbilityID);
end


--===============================================
-- ¸üÐÂÉú»î¼¼ÄÜ
--===============================================
function ActionSkillsStudy_UpdateAbility(nAbilityID)

	local nAbilityNum = GetActionNum("life");
	
	for i=0, nAbilityNum do
	
		local theAction = EnumAction(i, "life");
		if theAction:GetDefineID() == nAbilityID then
		
			if theAction:GetID() == 0 then
				LifeSkillsStudy_Icon:SetActionItem(-1);
			else
				LifeSkillsStudy_Icon:SetActionItem(theAction:GetID());
				
				-- Éú»î¼¼ÄÜÃû×Ö
				local szName = theAction:GetName();
				-- Éú»î¼¼ÄÜµÄµÈ¼¶
				local nLevel = Player:GetAbilityInfo(nAbilityID, "level");
				-- Éú»î¼¼ÄÜµÄ×î´óµÈ¼¶
				local nMaxLevel = Player:GetAbilityInfo(nAbilityID, "maxlevel");
				-- Éú»î¼¼ÄÜÊìÁ·¶È
				local nSkillExp = Player:GetAbilityInfo(nAbilityID, "skillexp");
				-- Éú»î¼¼ÄÜ½âÊÍ
				local szExplain = Player:GetAbilityInfo(nAbilityID, "explain");			
				
				local nNeedLevel    = AbilityTeacher:GetNeedLevel();
				-- local nLevel        = Player:GetData("LEVEL");
				
				local nNeedSkillExp = AbilityTeacher:GetNeedSkillExp();
				
				LifeSkillsStudy_SkillName:SetText(szName);
				LifeSkillsStudy_SkillLevel:SetText("C¤p:".. tostring(nLevel).."/"..tostring(nMaxLevel));
				LifeSkillsStudy_skilledDegree:SetText("Thành thÕo:"..tostring(nSkillExp) .. "/" .. tostring(nNeedSkillExp) );
				LifeSkillsStudy_PlayerLevel:SetText("C¤p:" .. tostring(nNeedLevel));
				
				LifeSkillsStudy_Explain_Desc:SetText("  "..szExplain);
			end
		end
	end

end

function LifeSkillsStudy_UpLevel_Click()


	-- »ñµÃ·þÎñÆ÷½Å±¾µÄÒ»Ð©Êý¾Ý£¬È»ºóÔÙ´ÎÈ¥µ÷ÓÃ·þÎñÆ÷µÄ âÐ©Êý¾Ý
	local ScriptId = AbilityTeacher:GetServerData("scriptid");
	local NpcId    = AbilityTeacher:GetServerData("npcid");

	Player:AskLeanAbility(g_nAbilityID, NpcId);
	
	--²»¹Ø± ´°¿Ú£¬Ö»½«´°¿ÚÑ§Ï°°´Å¥Disable
	LifeSkillsStudy_UpLevel:Disable();
	--this:Hide()
		
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDefaultEvent");
		Set_XSCRIPT_ScriptID(ScriptId);
		Set_XSCRIPT_Parameter(0,NpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	--this:CareObject(objCared, 0, "AbilityStudy");

end 


function LifeSkillsStudy_Close()
	this:Hide()
	this:CareObject(objCared, 0, "AbilityStudy");

	
end
