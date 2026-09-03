
local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};

local g_serverNpcId = -1;
local g_clientNpcId = -1;

local g_selidx = -1;					--?????????
local g_selfrm = ""					--????????
local g_pidx = -1					--?????????????
local g_petSkillStudyMoreMoney = 990000

local g_PetStudyNewSkill_Frame_UnifiedPosition;

function PetStudyNewSkill_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETSKILLSTUDY");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	this:RegisterEvent("CONFIRM_PETSKILLSTUDY");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end



function PetStudyNewSkill_OnLoad()
	PETSKILL_BUTTONS[1] = PetStudyNewSkill_Skill01;
	PETSKILL_BUTTONS[2] = PetStudyNewSkill_Skill02;
	PETSKILL_BUTTONS[3] = PetStudyNewSkill_Skill03;
	PETSKILL_BUTTONS[4] = PetStudyNewSkill_Skill04;
	PETSKILL_BUTTONS[5] = PetStudyNewSkill_Skill05;
	PETSKILL_BUTTONS[6] = PetStudyNewSkill_Skill06;
	PETSKILL_BUTTONS[7] = PetStudyNewSkill_Skill07;
	PETSKILL_BUTTONS[8] = PetStudyNewSkill_Skill08;
	PETSKILL_BUTTONS[9] = PetStudyNewSkill_Skill09;
	PETSKILL_BUTTONS[10] = PetStudyNewSkill_Skill10;
	PETSKILL_BUTTONS[11] = PetStudyNewSkill_Skill11;
	PETSKILL_BUTTONS[12] = PetStudyNewSkill_Skill12;
	
	 g_PetStudyNewSkill_Frame_UnifiedPosition=PetStudyNewSkill_Frame:GetProperty("UnifiedPosition");
	 
end



function PetStudyNewSkill_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 223 ) then
		PetStudyNewSkill_OnUICommand();
	elseif( event == "UPDATE_PETSKILLSTUDY" and this:IsVisible() ) then
		PetStudyNewSkill_Update(arg0, arg1);
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetStudyNewSkill_Selected(tonumber(arg0));
	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetStudyNewSkill_Show();
	elseif ( event == "DELETE_PET" and this:IsVisible() ) then
		PetStudyNewSkill_Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetStudyNewSkill_CareEventHandle(arg0,arg1,arg2);
	elseif ( event == "CONFIRM_PETSKILLSTUDY") then
		PetStudyNewSkill_ConfirmPetStudyNewSkill()
	elseif (event == "ADJEST_UI_POS" ) then
		PetStudyNewSkill_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetStudyNewSkill_Frame_On_ResetPos()
		
	end
end


function PetStudyNewSkill_OnUICommand()
	
	if this:IsVisible() then
		return
	end

	g_serverNpcId = Get_XParam_INT(0);
	g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
	this:CareObject(g_clientNpcId, 1, "PetStudyNewSkill");
	
	if( g_selidx ~= -1 )then
		Pet:SetPetLocation(g_selidx,-1);
	end
	g_selidx = -1;
	PetStudyNewSkill_Hide();	
	PetStudyNewSkill_Show();	

end
--Ñ¡Ôñ äÊÞ
function PetStudyNewSkill_Selected(selidx)
	if( -1 == selidx ) then
		return;
	end
	
	-- äÊÞÒÑ±»ÆäËü½çÃæÑ¡ÖÐ
	if (Pet:GetPetLocation(selidx) ~= -1) then
		return;
	end

	PetStudyNewSkill_PetModel:SetFakeObject("");
	Pet:SetStudyNewSkillModel(selidx);
	PetStudyNewSkill_PetModel:SetFakeObject( "My_PetStudyNewSkill" );

	--Èç¹ûµ±Ç°ÊéºÍ³è¶¼Ñ¡ºÃÁË....Ôò¼ÆËãÊÇ·ñÊÇ¿ªÐÂµÄÊÖ¶¯¼¼ÄÜ¸ñ....Èç¹ûÊÇÔò¶àÊ Ç®....
	if( g_sleidx ~= selidx and g_pidx ~= -1) then
		if Pet:CheckPetSkillStudyMoreMoneyMode( selidx , g_pidx ) == 1 then
			PetStudyNewSkill_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
		else
			local ptlv = Pet:GetTakeLevel(selidx);
			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
			PetStudyNewSkill_Money:SetProperty("MoneyNumber", tostring(ptM));
		end
	end


	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end

	local i=1;
	local k=1;
	
	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( selidx, i-1, "petskill");
		i = i + 1;
		if theSkillAction:GetID() ~= 0 then
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
		end
	end

	--ÇÐ»» äÊÞµÄÊ±ºò£¬ÊÍ·ÅÉÏÒ»¸ö äÊÞ
	if(g_selidx ~= -1) then
		Pet:SetPetLocation(g_selidx,-1);
	end

	g_selidx = selidx;	--???????
	Pet:SetPetLocation(g_selidx,8);

	Pet:ClosePetSkillStudyMsgBox()
end
--¸üÐÂ½çÃæ
function PetStudyNewSkill_Update(aidxs, pidxs)
	
	local aidx = tonumber(aidxs);
	local pidx = tonumber(pidxs);
	
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	--½â³ýÔ­À´±»Ëø¶¨µÄÎïÆ·
	if("package" == g_selfrm) then
		Pet:SkillStudyUnlock(g_pidx);
	end
	
	--ÉèÖÃÐÂµÄÎïÆ·
	local action = EnumAction(pidx, "packageitem");
	if(action:GetID() ~= 0) then
		PetStudyNewSkill_Skill1:SetActionItem(action:GetID());
		g_selfrm = "package";
		g_pidx = pidx;
	end
	
	-- äÊÞ´ò¼¼ÄÜÊé....
	--Èç¹ûµ±Ç°ÊéºÍ³è¶¼Ñ¡ºÃÁË....Ôò¼ÆËãÊÇ·ñÊÇ¿ªÐÂµÄÊÖ¶¯¼¼ÄÜ¸ñ....Èç¹ûÊÇÔò¶àÊ Ç®....
	if g_selidx ~= -1 and action:GetID() ~= 0 then
		if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, pidx ) == 1 then
			PetStudyNewSkill_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
		else
			local ptlv = Pet:GetTakeLevel(g_selidx);
			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
			PetStudyNewSkill_Money:SetProperty("MoneyNumber", tostring(ptM));
		end
	end

	Pet:ClosePetSkillStudyMsgBox()

end
--¹Ø± 
function PetStudyNewSkill_Hide()
	
	Pet:ClosePetSkillStudyMsgBox()

	this:CareObject(g_clientNpcId, 0, "PetStudyNewSkill");
	PetStudyNewSkill_Unlock();
	this:Hide();
	Pet:ShowPetList(-1);
	Pet:SetPetLocation(g_selidx,-1);
	g_selidx = -1;
	g_stduySkill = false;
	g_selfrm = ""
	g_pidx = -1
end
--×óÐý×ª
function PetStudyNewSkill_Modle_TurnLeft(start)
	--Ïò×óÐý×ª¿ªÊ¼
	if(start == 1) then
		PetStudyNewSkill_PetModel:RotateBegin(-0.3);
	--Ïò×óÐý×ª½áÊø
	else
		PetStudyNewSkill_PetModel:RotateEnd();
	end

end
--ÓÒÐý×ª
function PetStudyNewSkill_Modle_TurnRight(start)
	--ÏòÓÒÐý×ª¿ªÊ¼
	if(start == 1) then
		PetStudyNewSkill_PetModel:RotateBegin(0.3);
	--ÏòÓÒÐý×ª½áÊø
	else
		PetStudyNewSkill_PetModel:RotateEnd();
	end
end
--¼¼ÄÜÊéÀ¸µã»÷
function PetStudyNewSkill_Btn_Click(aidx)

end

--µã»÷È·¶¨
function PetStudyNewSkill_Do()
	
	if (-1 == g_selidx) then
		PushDebugMessage("Ch÷n Trân Thú");
		return;
	end
	
	if(-1 == g_pidx) then		
		PushDebugMessage("C¥n Bí Kíp.");
		return;
	end

	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--???? Vega
	local nM = tonumber(PetStudyNewSkill_Money:GetProperty("MoneyNumber"));
	if( pM < nM) then
		PushDebugMessage("Không ðü ngân lßþng h÷c kÛ nång");
		return;
	end
	
	-- Èç¹ûÊÇÑ§Ï°Á½¸ö²»Í¬ÀàµÄÊÖ¶¯¼¼ÄÜ
	if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, g_pidx ) == 1 then
		Pet:OpenPetSkillStudyMsgBox()	-- ??????? MessageBox_Self ??
		return
	else
		Pet:SkillStudy_Do( 1, g_selidx , g_pidx);			
		g_stduySkill = true;	--??????			
	end
end
-- äÊÞ¼¼ÄÜÑ§Ï°£ºÁ½¸ö²»Í¬ÀàÊÖ¶¯¼¼ÄÜÈ·ÈÏ¡°Ñ§Ï°¡±£¨¸ÃÊÂ¼þÔÚ MessageBox_Self ½çÃæÖÐµÄ PET_SKILL_STUDY_CONFIRM ÊÂ¼þÖÐ´¥·¢£©
function PetStudyNewSkill_ConfirmPetStudyNewSkill()
	
	if (-1 == g_selidx) then
		PushDebugMessage("Ch÷n Trân Thú")
		return
	end
	
	if(-1 == g_pidx) then
		PushDebugMessage("C¥n Bí Kíp.")
		return
	end
	
	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")   --???? Vega
	local nM = tonumber(PetStudyNewSkill_Money:GetProperty("MoneyNumber"))
	if pM < nM then
		PushDebugMessage("Không ðü ngân lßþng h÷c kÛ nång")
		return
	end

	Pet:SkillStudy_Do( 1, g_selidx, g_pidx )

	g_stduySkill = true;	--??????

end


function PetStudyNewSkill_Show()
	
	if (g_stduySkill == false) then
		PetStudyNewSkill_PetModel:SetFakeObject( "" );
		PetStudyNewSkill_Unlock();
		for i=1, PETSKILL_BUTTONS_NUM do
			PETSKILL_BUTTONS[i]:SetActionItem(-1);
		end
		if( g_selidx ~= -1 )then
			Pet:SetPetLocation(g_selidx,-1);
		end
		g_selidx = -1;
	else
		if -1 ~= g_selidx then
			local i=1;
			local k=1;
			while i <= PETSKILL_BUTTONS_NUM do
				local theSkillAction = Pet:EnumPetSkill( g_selidx, i-1, "petskill");
				i = i + 1;
				if theSkillAction:GetID() ~= 0 then
					PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
					k = k+1;
				end
			end
		end
	end

	--Èç¹ûÑ¡ÔñÖÐµÄ äÊÞÊÇÔÚ±³°üÀïÃæ
	if g_selidx ~= -1 then
		local szPetName,szOn = Pet:GetPetList_Appoint(g_selidx)
		if( szOn ~= "on_packa" )  then 
			PetStudyNewSkill_PetModel:SetFakeObject( "" );
			PetStudyNewSkill_Unlock();
			for i=1, PETSKILL_BUTTONS_NUM do
				PETSKILL_BUTTONS[i]:SetActionItem(-1);
			end
			if( g_selidx ~= -1 )then
				Pet:SetPetLocation(g_selidx,-1);
			end
			g_selidx = -1
		end
	end
	
	PetStudyNewSkill_Money:SetProperty("MoneyNumber", 0);

	PetStudyNewSkill_Skill1: SetPushed(0);
	PetStudyNewSkill_Skill1: SetActionItem(-1);
	PetStudyNewSkill_Unlock()
	g_selfrm = ""
	g_pidx = -1
	--Èç¹û âÀï²»½«g_stduySkillÖØÖÃ£¬ÄÇÃ´ÔÚÑ§Ï°ÁËÒ»´Î¼¼ÄÜÖ®ºó£¬ÔÙ¸Ä±ä äÊÞ×´Ì¬£¬½«²»»áÇå¿ ui
	--ÀíÂÛÉÏÄ³¸ö±äÁ¿µÄÊ¹ÓÃÒ²Ó¦¸ÃÊÇÒ»¸öÑ­»·À´µÄ
	-- âÀï¼ÌÐøÊ¹ÓÃtrue false°É£¬¸ú â¸öÎÄ¼þµÄ·ç¸ñÒ»ÖÂ
	g_stduySkill = false

	Pet:ClosePetSkillStudyMsgBox()
	this:Show();
	Pet:ShowPetList(1);		-- ??????
end


--´°¿ÚÒþ²ØÇ°ÏÈ½«±³°üÖÐ±»Ëø¶¨µÄÎïÆ·½âËø
function PetStudyNewSkill_Unlock()
	if("package" == g_selfrm) then
		Pet:SkillStudyUnlock(g_pidx);
	end

	Pet:SkillStudy_MenPaiSkill_Clear();
end


function PetStudyNewSkill_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then

			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetStudyNewSkill_Hide();
		end
end


function PetStudyNewSkill_Frame_On_ResetPos()
  PetStudyNewSkill_Frame:SetProperty("UnifiedPosition", g_PetStudyNewSkill_Frame_UnifiedPosition);
end
