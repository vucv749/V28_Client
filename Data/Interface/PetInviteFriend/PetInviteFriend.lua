local g_Invite = {};
local g_serverNpcId = -1;
local g_clientNpcId = -1;
local g_serverScriptId = 311111;
local MAX_OBJ_DISTANCE = 3.0;

local g_PetInviteFriend_Frame_UnifiedPosition;

--ÉèÖÃ¿Ø¼þ±ãÓÚºóÃæluaÖÐÊ¹ÓÃ
function PetInviteFriend_SetInviteCtl()
	g_Invite[1] = {
									model = PetInviteFriend_PetModel1,
									id = PetInviteFriend_Pet1_ID,
									name = PetInviteFriend_Pet1_Name,
									menpai = PetInviteFriend_Pet1_ManPai,
									level = PetInviteFriend_Pet1_Level,
									guild = PetInviteFriend_Pet1_Confraternity,
									msg = PetInviteFriend_Pet1_MessageBoard,
									view = PetInviteFriend_Pet1_Investigate,
									mail = PetInviteFriend_Pet1_Acquaintance,
									left = PetInviteFriend_PetModel1_TurnLeft,
									right = PetInviteFriend_PetModel1_TurnRight,
								};

	g_Invite[2] = {
									model = PetInviteFriend_PetModel2,
									id = PetInviteFriend_Pet2_ID,
									name = PetInviteFriend_Pet2_Name,
									menpai = PetInviteFriend_Pet2_ManPai,
									level = PetInviteFriend_Pet2_Level,
									guild = PetInviteFriend_Pet2_Confraternity,
									msg = PetInviteFriend_Pet2_MessageBoard,
									view = PetInviteFriend_Pet2_Investigate,
									mail = PetInviteFriend_Pet2_Acquaintance,
									left = PetInviteFriend_PetModel2_TurnLeft,
									right = PetInviteFriend_PetModel2_TurnRight,
								};
	g_Invite.prevbtn = PetInviteFriend_PageUp;
	g_Invite.nextbtn = PetInviteFriend_PageDown;
end

function PetInviteFriend_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetInviteFriend_OnLoad()
	g_PetInviteFriend_Frame_UnifiedPosition=PetInviteFriend_Frame:GetProperty("UnifiedPosition");
end

function PetInviteFriend_OnEvent(event)
	PetInviteFriend_SetInviteCtl();
	if(event == "UI_COMMAND") then
		local op = tonumber(arg0);
		if(op == 5) then
			g_serverNpcId = Get_XParam_INT(0);
			g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
			PetInviteFriend_Clear_All();
			this:Show();
			this:CareObject(g_clientNpcId, 1, "PetInviteFriend");
			PetInviteFriend_PageBtnDisable();
		end
	elseif(event == "UPDATE_PETINVITEFRIEND") then
		if("invite" == arg0) then
			PetInviteFriend_Clear_All();
			local num = PetInviteFriend:GetInviteNum();
			for i=1,num do
				PetInviteFriend_Update(i);
			end
			PetInviteFriend_PageBtnEnable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetInviteFriend_CareEventHandle(arg0,arg1,arg2);
		
	elseif (event == "ADJEST_UI_POS" ) then
		PetInviteFriend_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetInviteFriend_Frame_On_ResetPos()
		
	end
end

function PetInviteFriend_Clear_All()
	for i=1,2 do
		PetInviteFriend_Clear(i);
	end
end

function PetInviteFriend_Clear( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end

	--Çå³ýÄ£ÐÍ
	g_Invite[idx].model:SetFakeObject( "" );

	--Çå³ýÎÄ×Ö
	g_Invite[idx].id:SetText("");
	g_Invite[idx].name:SetText("");
	g_Invite[idx].menpai:SetText("");
	g_Invite[idx].level:SetText("");
	g_Invite[idx].guild:SetText("");
	g_Invite[idx].msg:SetText("");

	--°´Å¥¿ØÖÆ
	g_Invite[idx].view:Disable();
	g_Invite[idx].mail:Disable();
	g_Invite[idx].left:Disable();
	g_Invite[idx].right:Disable();
end

function PetInviteFriend_PageBtnEnable()
	g_Invite.prevbtn:Enable();
	g_Invite.nextbtn:Enable();
end

function PetInviteFriend_PageBtnDisable()
	g_Invite.prevbtn:Disable();
	g_Invite.nextbtn:Disable();
end

function PetInviteFriend_Hide()
	this:CareObject(g_clientNpcId, 0, "PetInviteFriend");
	PetInviteFriend_Clear_All();
	this:Hide();
end

function PetInviteFriend_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	--ÉèÖÃ äÊÞÖ÷ÈËÐÅÏ¢
	local strTxt = PetInviteFriend:GetHumanINFO(idx, "GUID");
	g_Invite[idx].id:SetText(strTxt);

	strTxt = PetInviteFriend:GetHumanINFO(idx, "NAME");
	g_Invite[idx].name:SetText(strTxt);

	strTxt = tostring(PetInviteFriend:GetHumanINFO(idx, "LEVEL"));
	g_Invite[idx].level:SetText(strTxt);

	strTxt = PetInviteFriend:GetHumanINFO(idx, "GUILD");
	if( "" == strTxt or nil == strTxt) then
		--strTxt = "???"
		strTxt = "";
	end
	g_Invite[idx].guild:SetText(strTxt);

	strTxt = PetInviteFriend_ConvertNumToMenPai(PetInviteFriend:GetHumanINFO(idx, "MENPAI"));
	g_Invite[idx].menpai:SetText(strTxt);

	--ÉèÖÃ äÊÞµÄ ÷ÓÑÐÅÏ¢
	strTxt = PetInviteFriend:GetInviteMsg(idx);
	g_Invite[idx].msg:SetText(strTxt);

	--ÉèÖÃ äÊÞÄ£ÐÍ
	PetInviteFriend:SetPetModel(idx);
	strTxt = "My_PetInviteFriend0" .. tostring(idx);
	g_Invite[idx].model:SetFakeObject(strTxt);

	--ÉèÖÃ°´Å¥
	g_Invite[idx].view:Enable();
	g_Invite[idx].mail:Enable();
	g_Invite[idx].left:Enable();
	g_Invite[idx].right:Enable();
end

function PetInviteFriend_ConvertNumToMenPai( MenPaiId )
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
function PetInviteFriend_Modle_TurnLeft(modelIdx, start)

	if(modelIdx <= 2 and modelIdx > 0) then
		--Ïò×óÐý×ª¿ªÊ¼
		if(start == 1) then
			g_Invite[modelIdx]["model"]:RotateBegin(-0.3);
		--Ïò×óÐý×ª½áÊø
		else
			g_Invite[modelIdx]["model"]:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--Ðý×ª äÊÞÄ£ÐÍ£¨ÏòÓÒ)
--
function PetInviteFriend_Modle_TurnRight(modelIdx, start)
	if(modelIdx <= 2 and modelIdx > 0) then
		--ÏòÓÒÐý×ª¿ªÊ¼
		if(start == 1) then
			g_Invite[modelIdx]["model"]:RotateBegin(0.3);
		--ÏòÓÒÐý×ª½áÊø
		else
			g_Invite[modelIdx]["model"]:RotateEnd();
		end
	end
end

--²éÑ¯ äÊÞµÄÏêÏ¸ÐÅÏ¢
function PetInviteFriend_ShowTargetFrame( idx )
	if(idx < 0 and idx > 2) then
		return;
	end

	PetInviteFriend:ShowTargetPet(idx);
end

--²éÑ¯ÉÏÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetInviteFriend_PrevPage()
	--»ñµÃµ±Ç°Ò³ÐÅÏ¢
	local num = PetInviteFriend:GetInviteNum();
	local guid1=0;
	local guid2=0;
	local tmp;

	if(num == 1) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
	elseif(num == 2) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
		tmp,guid2 = PetInviteFriend:GetHumanINFO(2, "GUID");
	end

	--Í¨Öª·þÎñÆ÷·¢ËÍÐÂµÄÐÅÏ¢¹ýÀ´
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetInviteFriend_Ask_NewPage");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,g_serverNpcId);
	Set_XSCRIPT_Parameter(1,guid1);
	Set_XSCRIPT_Parameter(2,guid2);
	Set_XSCRIPT_Parameter(3,0);
	Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
end

--²éÑ¯ÏÂÒ»ÆªµÄ äÊÞ ÷ÓÑÐÅÏ¢
function PetInviteFriend_NextPage()
	--»ñµÃµ±Ç°Ò³ÐÅÏ¢
	local num = PetInviteFriend:GetInviteNum();
	local guid1=0;
	local guid2=0;
	local tmp;

	if(num == 1) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
	elseif(num == 2) then
		tmp,guid1 = PetInviteFriend:GetHumanINFO(1, "GUID");
		tmp,guid2 = PetInviteFriend:GetHumanINFO(2, "GUID");
	end

	--Í¨Öª·þÎñÆ÷·¢ËÍÐÂµÄÐÅÏ¢¹ýÀ´
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetInviteFriend_Ask_NewPage");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,g_serverNpcId);
	Set_XSCRIPT_Parameter(1,guid2);
	Set_XSCRIPT_Parameter(2,guid1);
	Set_XSCRIPT_Parameter(3,1);
	Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
end

--¸ø äÊÞÖ÷ÈË·¢ÓÊ¼þ£¬ËµÃ÷Ïë ÷ÓÑ
function PetInviteFriend_SendMail( idx )
	if(idx < 0 and idx > 2) then
		return;
	end
	local strOHuman = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local strOPet		= PetInviteFriend:GetPetINFO(idx, "NAME");
	local strUser = Player:GetName();

	if(strUser == strOHuman) then
		--²»ÄÜ½áÊ¶×Ô¼ºµÄ äÊÞ
		PushDebugMessage("Không th¬ Hoà chính mình Ðích Trân Thú kªt các\\u0020hÕ.");
	else
		--Í¨Öª×Ô¼º
		PushDebugMessage("Dî gæi ði cüa ngß½i kªt các\\u0020hÕ thïnh c¥u.");
		--·¢ËÍÓÊ¼þ
		DataPool:SendMail(strOHuman, strUser .. "Tß·ng kªt các\\u0020hÕ cüa ngß½i"  .. strOPet .. "!" );
		--·¢ËÍ½áÊ¶Í³¼ÆÐÅÏ¢
		PetInviteFriend : SendAuditMsg(g_serverNpcId);
	end
end

function PetInviteFriend_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetInviteFriend_Hide();
		end
end

function PetInviteFriend_Frame_On_ResetPos()
  PetInviteFriend_Frame:SetProperty("UnifiedPosition", g_PetInviteFriend_Frame_UnifiedPosition);
end
