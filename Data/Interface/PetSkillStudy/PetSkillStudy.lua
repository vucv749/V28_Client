local g_uitype = 1;
local g_serverScriptId = 311111;
local g_serverNpcId = -1;
local g_clientNpcId = -1;
local g_selidx = -1;						-- ???????
local g_seledidx =-1;                   --  ||-__-???????????????,?????UPDATE_PET_PAGE?????????????,
                                        --        µ«ÊÇ¼ø¶¨ äÊŞ³É³¤½ÓÏÂÀ´»¹ĞèÒªÊ¹ÓÃ â¸öĞÅÏ¢
local g_selidx_jns = -1;				-- ???????????(?????????)
local	g_selidx_ynd = -1;				-- ???????????(?????????)

--ÒòÎªÔÚdoµÄÊ±ºòÓ²Ö¸¶¨ÁËaction buttonµÄidÊÇ1£¬ËùÒÔÎŞ·¨Í¨¹ıÄÇ¸öidÀ´È·¶¨ÎïÆ·ÊÇ·ñ·Åµ½ÉÏÃæ
--ËùÒÔÎªÃ¿¸öĞèÒªÎïÆ·µÄ½çÃæÔö¼ÓÒ»¸öÀàËÆÑÓÄêµ¤µÄÊµÏÖ·½Ê½
local g_selidx_lsd = -1; --???
local g_selidx_zxd = -1; --???
local g_selidx_htjz = -1; --????

local g_stduySkill = false;			-- ????????
local MAX_OBJ_DISTANCE = 3.0;
local g_DefaultTxt = "Ğßa ğÕo cø c¥n dùng vào ô ğÕo cø.";
local g_tlvcostmoney = {};
local g_tbabaymoney = {};
local g_petSkillStudyMoreMoney = 990000

local PETSKILLSTUDY_ACCBTN = {};
local FUNCTION_ACCNAME = {};

local UITYPE_LIANSHOUDAN = 800107
local UITYPE_ZHUANXINGDAN = 800108
local CurUIType = -1       --800107???????

local g_PetSkillStudy_Frame_UnifiedPosition;

function PetSkillStudy_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETSKILLSTUDY");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
--	this:RegisterEvent("CONFIRM_PETSKILLSTUDY");				-- ¸ÃÊÂ¼şÔÚ MessageBox_Self ½çÃæÖĞµÄ PET_SKILL_STUDY_CONFIRM ÊÂ¼şÖĞ´¥·¢
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function PetSkillStudy_OnLoad()
	PETSKILLSTUDY_ACCBTN[1] = {PetSkillStudy_Skill1, "", -1, ""}; --{ActionButton??,?????,???,?????}
	--PETSKILLSTUDY_ACCBTN[2] = {PetSkillStudy_Skill2, "", -1, ""};
	--PETSKILLSTUDY_ACCBTN[3] = {PetSkillStudy_Skill3, "", -1, ""};
	
	--"S"		¼¼ÄÜÊéÑ§Ï°
	--"R"		»¹Í¯
	--"A"		ÊÙÃüÑÓ³¤
	--"L"   	Á¶ÊŞµ¤
	FUNCTION_ACCNAME = {"S", "R", "A"};
	g_tlvcostmoney = {
		[5]=1000,
		[15]=3000,
		[25]=5000,
		[35]=7000,
		[45]=9000,
		[55]=11000,
		[65]=13000,
		[75]=15000,
		[85]=17000,
		[95]=19000,
		[105]=21000,
	};
	g_tbabaymoney = {
		[5]=5000,
		[15]=6000,
		[20]=7000,
		[25]=7000,
		[35]=10000,
		[45]=15000,
		[55]=25000,
		[65]=40000,
		[75]=55000,
		[85]=70000,
		[95]=85000,
		[105]=100000,
	};
	
	g_PetSkillStudy_Frame_UnifiedPosition=PetSkillStudy_Frame:GetProperty("UnifiedPosition");
	
end

function PetSkillStudy_OnEvent(event)
	
	--µ÷ÊÔÓÃ£º´òÓ¡µã»÷¿Ø¼şºóËù·¢ÉúµÄÊÂ¼ş
	--AxTrace( 6, 0, event )
	--PushDebugMessage(event);
	
	if ( event == "UI_COMMAND" ) then
		PetSkillStudy_OnUICommand(arg0);
	elseif( event == "UPDATE_PETSKILLSTUDY" and this:IsVisible()) then
		PetSkillStudy_Update(arg0, arg1);
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetSkillStudy_Selected(tonumber(arg0));
	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetSkillStudy_Show();
		g_seledidx = g_selidx;
		if( g_selidx ~= -1 )then
			Pet:SetPetLocation(g_selidx,-1);
		end
		g_selidx = -1;
	elseif ( event == "DELETE_PET" and this:IsVisible() ) then
		PetSkillStudy_Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetSkillStudy_CareEventHandle(arg0,arg1,arg2);
--	Ê¹ÓÃĞÂµÄ äÊŞÑ§Ï°¼¼ÄÜ½çÃæ£¬´Ë½çÃæ²»ÔÙÏìÓ¦Ñ§Ï°È·ÈÏÏûÏ¢
--	elseif ( event == "CONFIRM_PETSKILLSTUDY") then
--		PetSkillStudy_ConfirmPetSkillStudy()

	elseif (event == "ADJEST_UI_POS" ) then
		PetSkillStudy_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		PetSkillStudy_Frame_On_ResetPos()
		
	end
end

function PetSkillStudy_OnUICommand(arg0)
	local op = tonumber(arg0);
	CurUIType = -1
	
	PetSkillStudy_Skill1:Show();--[tx47256]default behavor: itembox show	
	--µ÷ÊÔÓÃ£¬ÅĞ¶Ï°´µÄÄÄ¸ö¹¦ÄÜ
	--PushDebugMessage(op);
	
	-- äÊŞ¼¼ÄÜÑ§Ï°¡¢»¹Í¯¡¢ÑÓ³¤ÊÙÃü¡¢Ñ±Ñø¹²ÓÃÍ¬Ò»¸ö½çÃæ
	if( op == 3 ) then
		g_serverNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
		--AxTrace(0,0,"PetSkillStudy_OnUICommand g_clientNpcId:"..tostring(g_clientNpcId));
		this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
		g_uitype = Get_XParam_INT(1);
		if( g_selidx ~= -1 )then
			Pet:SetPetLocation(g_selidx,-1);
		end
		g_selidx = -1;
		PetSkillStudy_Hide();							--???????????????????,?????,???????
		PetSkillStudy_Show();		
	
	-- äÊŞÏ´µã	
	elseif( op == UITYPE_LIANSHOUDAN ) then
		g_serverNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
		this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
		CurUIType = op
		g_uitype = -1
		
		Variable:SetVariable("PetStudyType", tostring(g_uitype), 1)--[tx46111]
		PetSkillStudy_ShowReset()
		if( g_selidx ~= -1 )then
			Pet:SetPetLocation(g_selidx,-1);
		end
		--Ğ»ãp 47505 begin
		g_selidx = -1;
		--Ğ»ãp 47505 end
		
	--elseif( op == UITYPE_ZHUANXINGDAN ) then
	--	g_serverNpcId = Get_XParam_INT(0);
	--	g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
	--	this:CareObject(g_clientNpcId, 1, "PetSkillStudy");
	--	CurUIType = UITYPE_ZHUANXINGDAN
	--	g_uitype = -1
	--	PetSkillStudy_ShowZhuanxingdan()
				
	elseif( op == 4 and 4 == g_uitype) then
		local needMoney = Get_XParam_INT(0);
		--AxTrace(0,0,"needMoney:"..tostring(needMoney));
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(needMoney));
		PetSkillStudy_Accept:Enable();
	  PetSkillStudy_Skill1:Hide();	--[tx47256]				
	elseif( op == 4 and 6 == g_uitype) then
		local strRate = Get_XParam_STR(1);
		local sRate = nil;
		--AxTrace(0,0,"PetSkillStudy_OnUICommand "..tostring(strRate));
		if(nil == strRate) then
			strRate = "rat=1.0";
		end
		_,_,sRate = string.find(strRate, "rat=(%d+)");
		PetSkillStudy_ShowPetGrow(tonumber(sRate));
	end
end

function PetSkillStudy_ShowReset()  --??????
	--¿Ø¼şÇå³ı²Ù×÷
	
	AxTrace( 1, 0, "PetSkillStudy_ShowReset" )
	
	PetSkillStudy_PetModel:SetFakeObject( "" );
	PetSkillStudy_Unlock();
	for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
	end
	
	PetSkillStudy_SkillType_Text:SetText("#gFF0FA0T¦y ği¬m Trân Thú");
	PetSkillStudy_SkillType_Text:Show();
	PetSkillStudy_Accept:SetText("Ğ°ng ı");
	PetSkillStudy_Accept:Enable();

	PetSkillStudy_Money:SetProperty("MoneyNumber", "");
	PetSkillStudy_Money:Hide()
	PetSkillStudy_Static3:SetText("Không c¥n tiêu hao ti«n")
	--PetSkillStudy_Money:Show();
	--PetSkillStudy_Static3:SetText("ĞèÒª½ğÇ®");
	PetSkillStudy_MultiIMEEditBox:Hide();
	PetSkillStudy_Text1:SetText(g_DefaultTxt);
	PetSkillStudy_Text1:Show();
	
	PetSkillStudy_SetButtonAccName_Reset()
	this:Show();
	Pet:ShowPetList(1);
end
function PetSkillStudy_SetButtonAccName_Reset()  --??????
	PETSKILLSTUDY_ACCBTN[1][1]:SetProperty("DragAcceptName", "T"..(1).."L" );
end

function PetSkillStudy_ShowZhuanxingdan() --?????
	--¿Ø¼şÇå³ı²Ù×÷
	PetSkillStudy_PetModel:SetFakeObject( "" );
	PetSkillStudy_Unlock();
	for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
	end
	
	PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Hoàn Ğ°ng Ğan");
	PetSkillStudy_SkillType_Text:Show();
	PetSkillStudy_Accept:SetText("Ğ°ng ı");
	PetSkillStudy_Accept:Enable();

	PetSkillStudy_Money:SetProperty("MoneyNumber", "");
	PetSkillStudy_Money:Hide()
	PetSkillStudy_Static3:SetText("")
	--PetSkillStudy_Money:Show();
	--PetSkillStudy_Static3:SetText("ĞèÒª½ğÇ®");
	PetSkillStudy_MultiIMEEditBox:Hide();
	PetSkillStudy_Text1:SetText(g_DefaultTxt);
	PetSkillStudy_Text1:Show();
	
	PetSkillStudy_SetButtonAccName_Zhuanxingdan()
	this:Show();
	Pet:ShowPetList(1);
end
function PetSkillStudy_SetButtonAccName_Zhuanxingdan()  
	PETSKILLSTUDY_ACCBTN[1][1]:SetProperty("DragAcceptName", "T"..(1).."Z" );
end



function PetSkillStudy_Show()
	--local nPetCount = Pet : GetPet_Count();
	--local szPetName;
	
	--AxTrace( 1, 0, "PetSkillStudy_Show" )
	--PushDebugMessage ("PetSkillStudy_Show")
	
	--¿Ø¼şÇå³ı²Ù×÷
	--PetSkillStudy_PetList : ClearListBox();
	--Èç¹û²»ÊÇ¸ Ñ§Íê¼¼ÄÜ£¬Çå³ı´°¿ÚÖĞµÄ äÊŞ¼°Ïà¹ØĞÅÏ¢( äÊŞ¼¼ÄÜÑ§Ï°ºó²»Çå³ı)
	if (g_stduySkill == false) then
		PetSkillStudy_PetModel:SetFakeObject( "" );
		PetSkillStudy_Unlock();
		for i=1,1 do
			PETSKILLSTUDY_ACCBTN[i][1]: SetPushed(0);
			PETSKILLSTUDY_ACCBTN[i][1]: SetActionItem(-1);

			PETSKILLSTUDY_ACCBTN[i][2] = "";
			PETSKILLSTUDY_ACCBTN[i][3] = -1;
		end

		Pet:ClosePetSkillStudyMsgBox()
	end
	
	--»ñµÃÈ«²¿ äÊŞÁĞ±í
	--for	i=1, nPetCount do
	--	szPetName = Pet : GetPetList_Appoint(i-1);
	--	PetSkillStudy_PetList : AddItem(szPetName, i-1);
	--end
	
	--Ä¬ÈÏ°ïÍæ¼ÒÑ¡ÔñµÚÒ»Ö» äÊŞ
	--if(0 ~= nPetCount) then
	--	Pet:SetSkillStudyModel(0);
	--	PetSkillStudy_PetList:SetItemSelectByItemID(0);
	--	PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );
	--end
	
	Variable:SetVariable("PetStudyType", tostring(g_uitype), 1)
	
--	if(1 == g_uitype) then --Æ Í¨¼¼ÄÜÑ§Ï°
--		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Æ Í¨¼¼ÄÜÑ§Ï°");
--		PetSkillStudy_SkillType_Text:Show();
--		PetSkillStudy_Accept:SetText("Ñ§Ï°");
--		PetSkillStudy_Accept:Enable();
--		
--		PetSkillStudy_Money:SetProperty("MoneyNumber", "");
--		PetSkillStudy_Money:Show();
--		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
--		PetSkillStudy_MultiIMEEditBox:Hide();
--		PetSkillStudy_Text1:SetText(g_DefaultTxt);
--		PetSkillStudy_Text1:Show();
--		PetSkillStudy_SetButtonAccName();
		
	if(2 == g_uitype) then	--??
		--PetSkillStudy_SkillType_Text:SetText("#gFF0FA0»¹Í¯µ¤");
		--PetSkillStudy_SkillType_Text:Show();
		--PetSkillStudy_Accept:SetText("È·ÈÏ");
		--PetSkillStudy_Accept:Enable();

		--PetSkillStudy_Money:SetProperty("MoneyNumber", "");
		--PetSkillStudy_Money:Show();
		--PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		--PetSkillStudy_MultiIMEEditBox:Hide();
		--PetSkillStudy_Text1:SetText(g_DefaultTxt);
		--PetSkillStudy_Text1:Show();
		--PetSkillStudy_SetButtonAccName();
		
	elseif(3 == g_uitype) then --????
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Kéo dài tu±i th÷");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Ğ°ng ı");
		PetSkillStudy_Accept:Enable();
		
		PetSkillStudy_Money:Hide();
		PetSkillStudy_Static3:SetText("Không c¥n phäi tiêu hao ngân lßşng");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText(g_DefaultTxt);
		PetSkillStudy_Text1:Show();
		PetSkillStudy_SetButtonAccName();
		
	elseif(4 == g_uitype) then --????
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Phí thu¥n dßŞng");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Thu¥n DßŞng Trân Thú");
		PetSkillStudy_Accept:Disable();
		PetSkillStudy_Money:SetProperty("MoneyNumber", "");
		PetSkillStudy_Money:Show();
		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:Hide();
		PetSkillStudy_Skill1:Hide();	--[tx47256]
--		if( 0 ~= nPetCount ) then
--			PetSkillStudy_AskMoney(0);
--		end

	elseif(6 == g_uitype) then --???????
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0Xem trß·ng thành");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Tìm");
		PetSkillStudy_Accept:Disable();

		PetSkillStudy_Money:SetProperty("MoneyNumber", "0");
		PetSkillStudy_Money:Show();
		PetSkillStudy_Static3:SetText("#{INTERFACE_XML_789}");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText("Xem trß·ng thành Trân Thú"); -- zchw
		PetSkillStudy_Text1:Show();
		PetSkillStudy_Skill1:Hide();	--[tx47256]
		
	elseif(7 == g_uitype) then --??????
		PetSkillStudy_SkillType_Text:SetText("#gFF0FA0 Lînh nh§n danh hi®u Trân Thú");
		PetSkillStudy_SkillType_Text:Show();
		PetSkillStudy_Accept:SetText("Ğ°ng ı");
		PetSkillStudy_Accept:Enable();
		PetSkillStudy_Money:Hide();
		PetSkillStudy_Static3:SetText("Không c¥n phäi tiêu hao ngân lßşng");
		PetSkillStudy_MultiIMEEditBox:Hide();
		PetSkillStudy_Text1:SetText("Ch÷n Trân Thú mu¯n nh§n danh hi®u");
		PetSkillStudy_Text1:Show();
		PetSkillStudy_Skill1:Hide();	--[tx47256]			
	end
	
	if CurUIType == UITYPE_LIANSHOUDAN then
		PetSkillStudy_ShowReset()
	end
	
	-- äÊŞ¼¼ÄÜÑ§Ï°Ñ§Ï°Íêºó£¬É¾³ıµÀ¾ßÀ¸ÖĞµÄ¼¼ÄÜÊé
--	if (1 == g_uitype) then
--		g_selidx_jns = -1;				--»Ö¸´ÎªÎ´Ñ¡ÖĞµÀ¾ßÀ¸ÖĞµÄ¼¼ÄÜÊé£¨Ö» ë¶Ô äÊŞ¼¼ÄÜÑ§Ï°£©
		--PushDebugMessage ("¼¼ÄÜÊéÒÑÉ¾³ı¡£")
--	end
	
	-- äÊŞÑÓ³¤ÊÙÃüºó£¬É¾³ıµÀ¾ßÀ¸ÖĞµÄÑÓÄêµ¤
	if (3 == g_uitype) then
		g_selidx_ynd = -1;
		--PushDebugMessage ("ÑÓÄêµ¤ÒÑÉ¾³ı¡£")
	end	
	if (CurUIType == UITYPE_LIANSHOUDAN) then
		g_selidx_lsd = -1;
		--PushDebugMessage ("Á¶ÊŞµ¤ÒÑÉ¾³ı¡£")
	end	
	--if (3 == g_uitype) then
		--g_selidx_zxd = -1;
		--PushDebugMessage ("×ªĞÔµ¤ÒÑÉ¾³ı¡£")
	--end	
	--if (2 == g_uitype) then
	--	g_selidx_htjz = -1;
		--PushDebugMessage ("»¹Í¯¾íÖáÒÑÉ¾³ı¡£")
	--end

	this:Show();
	Pet:ShowPetList(1);		-- ??????
end

function PetSkillStudy_SetButtonAccName()
	if(nil == FUNCTION_ACCNAME[g_uitype]) then
		for i=1,1 do
				PETSKILLSTUDY_ACCBTN[i][1]:SetProperty("DragAcceptName", "T"..i);
		end
	else
		for i=1,1 do
				PETSKILLSTUDY_ACCBTN[i][1]:SetProperty("DragAcceptName", "T"..i..FUNCTION_ACCNAME[g_uitype]);
		end
	end
end

function PetSkillStudy_Test()
	g_uitype = g_uitype + 1;
	if( g_uitype > 6 ) then
		g_uitype = 1;
	end
	PetSkillStudy_Show();
end

--Ñ¡Ôñ²»Í¬ äÊŞÊ±£¬ÉèÖÃ²»Í¬µÄ äÊŞÄ£ĞÍ
function PetSkillStudy_Selected(selidx)
	--local selidx = PetSkillStudy_PetList:GetFirstSelectItem();
	
	--PushDebugMessage (selidx);
	
	if( -1 == selidx ) then
		return;
	end
	
	-- äÊŞÒÑ±»ÆäËü½çÃæÑ¡ÖĞ
	if (Pet:GetPetLocation(selidx) ~= -1) then
		return;
	end

	if 2 == g_uitype or CurUIType == UITYPE_ZHUANXINGDAN or CurUIType == UITYPE_LIANSHOUDAN then	--??,??,??
		if PlayerPackage:IsPetLock(selidx) == 1 then
			PushDebugMessage("Ğã thêm khóa v¾i Trân Thú")
			return
		end
	end	
		
	--zchw
	if g_uitype == 2 then
		if Pet:IsPetHaveEquip(selidx) == 1 then
				PushDebugMessage("#{ZSZB_090211_18}")
				return
		end
	end

	PetSkillStudy_PetModel:SetFakeObject("");
	Pet:SetSkillStudyModel(selidx);
	PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );

	-- äÊŞ´ò¼¼ÄÜÊé....
	--Èç¹ûµ±Ç°ÊéºÍ³è¶¼Ñ¡ºÃÁË....Ôò¼ÆËãÊÇ·ñÊÇ¿ªĞÂµÄÊÖ¶¯¼¼ÄÜ¸ñ....Èç¹ûÊÇÔò¶àÊ Ç®....
--	if( 1 == g_uitype and g_sleidx ~= selidx) then
--		if Pet:CheckPetSkillStudyMoreMoneyMode( selidx, PETSKILLSTUDY_ACCBTN[1][3] ) == 1 then
--			PetSkillStudy_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
--		else
--			local ptlv = Pet:GetTakeLevel(selidx);
--			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
--			PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
--		end
--	end
	
	if( 2 == g_uitype and g_sleidx ~= selidx) then
		local ptlv = Pet:GetTakeLevel(selidx);
		
		local saidx = -1;
		for i=1,1 do
			if(PETSKILLSTUDY_ACCBTN[i][1]:GetProperty("Checked") == "True") then
				saidx = i;
				break;
			end
		end
		
		local itemId = -1;
		if saidx ~= -1 then
			local bagIndex = PETSKILLSTUDY_ACCBTN[saidx][3];
			itemId = PlayerPackage:GetItemTableIndex(bagIndex);
		end
		
		local ptM = PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId);
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
	end	
	
	if( 4 == g_uitype ) then
		PetSkillStudy_AskMoney(selidx);
		PetSkillStudy_Accept:Disable();
	end
	
	if( 6 == g_uitype and g_selidx ~= selidx) then
		PetSkillStudy_Text1:SetText("Xem trß·ng thành Trân Thú!");
		PetSkillStudy_Accept:Enable();
		PetSkillStudy_Money:SetProperty("MoneyNumber", "100");
		PetSkillStudy_Money:Show();
	end

	--ÇĞ»» äÊŞµÄÊ±ºò£¬ÊÍ·ÅÉÏÒ»¸ö äÊŞ
	if(g_selidx ~= -1) then
		Pet:SetPetLocation(g_selidx,-1);
	end

	g_selidx = selidx;	--???????
	Pet:SetPetLocation(g_selidx,13);
	Pet:ClosePetSkillStudyMsgBox()

end

function PetSkillStudy_AskMoney( selidx )

	if( -1 == selidx ) then
		return;
	end
	
	local hid,lid = Pet:GetGUID(selidx);

	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("PetSkillStudy_Ask_Money");
	Set_XSCRIPT_ScriptID(g_serverScriptId);
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

--¸ù¾İÑ¡ÔñµÄ äÊŞ£¬ÏÔÊ¾ÏàÓ¦µÄÏêÏ¸ĞÅÏ¢
--function PetSkillStudy_ShowTargetPet(selidx)
	--local selidx = PetSkillStudy_PetList:GetFirstSelectItem();
--	if( -1 == selidx ) then
--		return;
--	end
	
--	Pet:ShowTargetPet(selidx);
--end

----------------------------------------------------------------------------------
--
-- Ğı×ª äÊŞÄ£ĞÍ£¨Ïò×ó)
--
function PetSkillStudy_Modle_TurnLeft(start)
	--Ïò×óĞı×ª¿ªÊ¼
	if(start == 1) then
		PetSkillStudy_PetModel:RotateBegin(-0.3);
	--Ïò×óĞı×ª½áÊø
	else
		PetSkillStudy_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--Ğı×ª äÊŞÄ£ĞÍ£¨ÏòÓÒ)
--
function PetSkillStudy_Modle_TurnRight(start)
	--ÏòÓÒĞı×ª¿ªÊ¼
	if(start == 1) then
		PetSkillStudy_PetModel:RotateBegin(0.3);
	--ÏòÓÒĞı×ª½áÊø
	else
		PetSkillStudy_PetModel:RotateEnd();
	end
end

-- ¸üĞÂ äÊŞÑ§Ï°½çÃæµÄActionButton
-- aidx  ActionButtonµÄË÷Òı
-- pidx	 ±³°ü(Packge)ÄÚµÄÎïÆ·Ë÷Òı
function PetSkillStudy_Update(aidxs, pidxs)

	--PushDebugMessage ("PetSkillStudy_Update")
	
	local aidx = tonumber(aidxs);
	local pidx = tonumber(pidxs);
	
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	--½â³ıÔ­À´±»Ëø¶¨µÄÎïÆ·
	if("package" == tostring(PETSKILLSTUDY_ACCBTN[aidx][2])) then
		Pet:SkillStudyUnlock(PETSKILLSTUDY_ACCBTN[aidx][3]);
	end
	
	--ÉèÖÃĞÂµÄÎïÆ·
	local action = EnumAction(pidx, "packageitem");
	if(action:GetID() ~= 0) then
		PETSKILLSTUDY_ACCBTN[aidx][1]:SetActionItem(action:GetID());
		PETSKILLSTUDY_ACCBTN[aidx][2] = "package";
		PETSKILLSTUDY_ACCBTN[aidx][3] = pidx;
	end
	
	if 2 == g_uitype and action:GetID() ~= 0 then
		local slidx = g_selidx;
		local ptlv = Pet:GetTakeLevel(slidx);
		local itemId = action:GetDefineID();
		local ptM = PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId);
		PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
	end
	
	if(1 == g_uitype or 3 == g_uitype or 2 == g_uitype or -1 == g_uitype ) then
		PETSKILLSTUDY_ACCBTN[1][1]:SetPushed(1);
	end

	-- äÊŞ´ò¼¼ÄÜÊé....
	--Èç¹ûµ±Ç°ÊéºÍ³è¶¼Ñ¡ºÃÁË....Ôò¼ÆËãÊÇ·ñÊÇ¿ªĞÂµÄÊÖ¶¯¼¼ÄÜ¸ñ....Èç¹ûÊÇÔò¶àÊ Ç®....
--	if 1 == g_uitype and g_selidx ~= -1 and action:GetID() ~= 0 then
--		if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, pidx ) == 1 then
--			PetSkillStudy_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
--		else
--			local ptlv = Pet:GetTakeLevel(g_selidx);
--			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
--			PetSkillStudy_Money:SetProperty("MoneyNumber", tostring(ptM));
--		end
--	end

	-- äÊŞ¼¼ÄÜÑ§Ï°
--	if (1 == g_uitype) then
--		g_selidx_jns = 1			--½«Ñ§Ï°¼¼ÄÜÊéÍÏ½øµÀ¾ßÀ¸ºó£¬Ñ¡ÖĞµÀ¾ßÀ¸£¨µ±Ç°µÀ¾ßÀ¸Ö»ÓĞ1¸ñ£¬ÇÒÖ» ë¶Ô äÊŞÑ§Ï°¼¼ÄÜ£©
		--PushDebugMessage ("ÒÑ·ÅÈë¼¼ÄÜÊé")
--	end
	
	-- äÊŞÑÓ³¤ÊÙÃü
	if (3 == g_uitype) then
		g_selidx_ynd = 1			--??????????,?????(???????1?,??????????)
		--PushDebugMessage ("ÒÑ·ÅÈë äÊŞÑÓÄêµ¤")
	end	
	if (2 == g_uitype) then
		g_selidx_htjz = 1
	end	
	if (CurUIType == UITYPE_LIANSHOUDAN) then
		g_selidx_lsd = 1
	end	
	Pet:ClosePetSkillStudyMsgBox()

end

--´¦ÀíActionButtonµÄµã»÷
function PetSkillStudy_Btn_Click(aidx)
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	for i=1,1 do
		if( i == aidx ) then
			PETSKILLSTUDY_ACCBTN[i][1]:SetPushed(1);
		else
			PETSKILLSTUDY_ACCBTN[i][1]:SetPushed(0);
		end
	end
	
end

function PetSkillStudy_PetReset( PetIndex, ItemPos ) --????
	
	if (-1 == PetIndex ) then
		PushDebugMessage("Ch÷n Trân Thú");
		return;
	end
	if(-1 == ItemPos ) then
		PushDebugMessage("C¥n Luy®n Thú Ğan");
		return;
	end
		
	local hid, lid = Pet:GetGUID(PetIndex);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("ResetPetAttrPt");
	Set_XSCRIPT_ScriptID( 800107 );
	
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_Parameter(2,ItemPos);
	Set_XSCRIPT_ParamCount(3)
	
	Send_XSCRIPT();
	
end

function PetSkillStudy_Zhuanxingdan( PetIndex, ItemPos ) --????
	
	if (-1 == PetIndex ) then
		PushDebugMessage("Ch÷n Trân Thú");
		return;
	end
	if(-1 == ItemPos ) then
		PushDebugMessage("C¥n Chuy¬n Tính Ğan");
		return;
	end
		
	local hid, lid = Pet:GetGUID(PetIndex);
	Clear_XSCRIPT();
	Set_XSCRIPT_Function_Name("ZhuanXingdian");
	Set_XSCRIPT_ScriptID( UITYPE_ZHUANXINGDAN );
	
	Set_XSCRIPT_Parameter(0,hid);
	Set_XSCRIPT_Parameter(1,lid);
	Set_XSCRIPT_Parameter(2,ItemPos);
	Set_XSCRIPT_ParamCount(3)
	
	Send_XSCRIPT();
	
end


--´¦ÀíÍæ¼ÒÈ·ÈÏÒª×öµÄÊÂÇé£¬¸ù¾İg_uitype
function PetSkillStudy_Do()
	local saidx = -1;	--ActionButton?????
	local slidx = g_selidx;	--ListBox?????
	
	--×£¿­ 2007-8-17
	--Ä¿Ç°Ö»ÓÃÁË1¸öActionButton¾Í²»ÒªÔÙÑ­»·²é Òµ±Ç°µ½µ×¼¤»îµÄÊÇÄÄ¸öÁË....
	--·ÇÒª âÃ´ÅªµÄ»°....µ±Ê§È¥½¹µãµÄÊ±ºò¾ÍËã·ÅµÄÓĞÎïÆ·Ò²»áËµÃ»ÓĞÎïÆ·ÁË....
	--for i=1,1 do
	--	if(PETSKILLSTUDY_ACCBTN[i][1]:GetProperty("Checked") == "True") then
	--		saidx = i;
	--		break;
	--	end
	--end
	--Ö±½ÓËµ¼¤»îµÄÊÇµÚ1¸öActionButton¾ÍĞĞÁË....
	saidx = 1;
	--×£¿­ 2007-8-17

	--PushDebugMessage ("PetSkillStudy_Do " .. g_uitype);
	
	if CurUIType == UITYPE_LIANSHOUDAN then
		if (-1 == slidx) then
			PushDebugMessage("Ch÷n Trân Thú");
			return;
		end
		if(-1 == g_selidx_lsd) then
			PushDebugMessage("C¥n Luy®n Thú Ğan");
			return;
		end
		PetSkillStudy_PetReset( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )
		PetSkillStudy_Hide()
		return
	end

	if CurUIType == UITYPE_ZHUANXINGDAN then
		if (-1 == slidx) then
			PushDebugMessage("Ch÷n Trân Thú");
			return;
		end
		if(-1 == saidx) then
			PushDebugMessage("C¥n Chuy¬n Tính Ğan");
			return;
		end
		PetSkillStudy_Zhuanxingdan( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )
		PetSkillStudy_Hide()
		return
	end
	
	--slidx = PetSkillStudy_PetList:GetFirstSelectItem();
	--AxTrace(0,0,"saidx: "..saidx.." slidx: "..slidx.." g_uitype: "..g_uitype);
--	if(1 == g_uitype) then
--		--Æ Í¨¼¼ÄÜÑ§Ï°
--		if (-1 == slidx) then
--			PushDebugMessage("ÇëÑ¡Ôñ äÊŞ¡£");
--			return;
--		end
--		if(-1 == g_selidx_jns) then								-- ÒòÎªÆäËûÑ¡Ïî»áÊ¹ÓÃsaidx£¬ÎªÁË²»Ó°ÏìÆäËûÑ¡Ïî£¬ âÀïÊ¹ÓÃÖ» ë¶Ô äÊŞ¼¼ÄÜÑ§Ï°µÄg_selidx_jns
--			PushDebugMessage("ĞèÒª¼¼ÄÜÊé¡£");
--			return;
--		end
	if(2 == g_uitype) then
		--»¹Í¯
		if (-1 == slidx) then
			PushDebugMessage("Ch÷n Trân Thú");
			return;
		end
		if(-1 == g_selidx_htjz) then
			PushDebugMessage("C¥n Hoàn Ğ°ng Quy¬n.");
			return;
		end
	elseif(3 == g_uitype) then
		--ÑÓ³¤ÊÙÃü
		if (-1 == slidx) then
			PushDebugMessage("Ch÷n Trân Thú");
			return;
		end
		if(-1 == g_selidx_ynd) then								-- ?????????saidx,?????????,??????????????g_selidx_ynd
			PushDebugMessage("#{ZSSM_090113_01}");	-- "Thïnh ğ¬ vào Trân Thú Diên Niên Ğan."
			return;
		end
	elseif(4 == g_uitype) then
		--Ñ±Ñø
		if (-1 == slidx) then
			PushDebugMessage("Ch÷n Trân Thú");
			return;
		end
	else
		-- âÊÇÉ¶
		--PetSkillStudy_Hide();
		--return;
	end
	
	--¸ù¾İg_uitypeÀ´´¦Àí
	--ÑÓ³¤ÊÙÃü
	if(3 == g_uitype) then
		Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);
	-- äÊŞ¼¼ÄÜÑ§Ï°
--	elseif(1 == g_uitype) then
--		local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--½»×ÓÆ ¼° Vega
--		local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
--		if( pM < nM) then
--			PushDebugMessage("½ğÇ®²»¹»£¬ÎŞ·¨Ñ§Ï°¼¼ÄÜ");
--			return;
--		end
--		
--		-- Èç¹ûÊÇÑ§Ï°Á½¸ö²»Í¬ÀàµÄÊÖ¶¯¼¼ÄÜ
--		if Pet:CheckPetSkillStudyMoreMoneyMode( slidx, PETSKILLSTUDY_ACCBTN[saidx][3] ) == 1 then
--			Pet:OpenPetSkillStudyMsgBox()				-- Í¨Öª¿Í»§¶Ëµ÷ÓÃ MessageBox_Self ½çÃæ
--			--PushDebugMessage ("×ªµ½ MessageBox_Self ½çÃæ")
--			return
--		else			
--			Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);			
--			g_stduySkill = true;	--ÒÑ¾­Ñ§¹ı¼¼ÄÜ			
--			--PushDebugMessage("µ÷ÊÔĞÅÏ¢£º¼¼ÄÜÒÑÑ§»á	");	
--		end
	--»¹Í¯
	elseif(2 == g_uitype) then
		--local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") ;          --½»×ÓÆ ¼° Vega
		--local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
		--AxTrace(0,0,"Money pM:" .. tostring(pM) .. " nM:" .. tostring(nM));
		--if( pM >= nM) then
		--        Pet:SkillStudy_Do(g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3]);
		--else
		--	PushDebugMessage("½ğÇ®²»¹»£¬ÎŞ·¨»¹Í¯");
		--	return;
		--end
	--Ñ±Ñø
	elseif(4 == g_uitype) then
		local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--???? Vega
		local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"));
		--AxTrace(0,0,"Money pM:" .. tostring(pM) .. " nM:" .. tostring(nM));
		if(100 == tonumber(Pet:GetHappy(slidx)) ) then	--and tonumber(Pet:GetHP(slidx)) == tonumber(Pet:GetMaxHP(slidx))
			PushDebugMessage("Không c¥n thu¥n dßŞng");
			return;
		end
		
		if( pM >= nM) then
			local hid,lid = Pet:GetGUID(slidx);
			Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PetSkillStudy_Domestication");
			Set_XSCRIPT_ScriptID(g_serverScriptId);
			Set_XSCRIPT_Parameter(0,hid);
			Set_XSCRIPT_Parameter(1,lid);
			Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		else
			PushDebugMessage("Không ğü ngân lßşng hu¤n luy®n");
			return;
		end
	elseif(6 == g_uitype and -1 ~= slidx) then
		local hid,lid = Pet:GetGUID(slidx);
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnInquiryForGrowRate");
		Set_XSCRIPT_ScriptID(1050);
		Set_XSCRIPT_Parameter(0,hid);
		Set_XSCRIPT_Parameter(1,lid);
		Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		return;
	elseif(7 == g_uitype and -1 ~= slidx) then
		local hid,lid = Pet:GetGUID(slidx);
		Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnAcceptPetTitle");
		Set_XSCRIPT_ScriptID(1031);
		Set_XSCRIPT_Parameter(0,g_serverNpcId);
		Set_XSCRIPT_Parameter(1,hid);
		Set_XSCRIPT_Parameter(2,lid);
		Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();
		--ĞèÒª¹Ø± ½çÃæ
		--return;
	end
	
	--»¹Í¯»ò äÊŞÑ§Ï°¼¼ÄÜºó´°¿Ú²»¹Ø± 
	if (2 ~= g_uitype) and (1 ~= g_uitype) then
		PetSkillStudy_Hide();
	end
	
	--Èç¹ûÊÇ äÊŞÑ§Ï°¼¼ÄÜ
	--if (1 == g_uitype) then		
	--	Pet:ShowPetList(1)		--ÔÙ´Î´ò¿ª äÊŞÁĞ±í
	--end	
	Pet:SetPetLocation(g_selidx,-1);
end

--´°¿ÚÒş²ØÇ°ÏÈ½«±³°üÖĞ±»Ëø¶¨µÄÎïÆ·½âËø
function PetSkillStudy_Unlock()
	for i=1,1 do
		if("package" == tostring(PETSKILLSTUDY_ACCBTN[i][2])) then
			Pet:SkillStudyUnlock(PETSKILLSTUDY_ACCBTN[i][3]);
		end
	end
	
	Pet:SkillStudy_MenPaiSkill_Clear();
end

--´°¿ÚÒş²Øº¯Êı
function PetSkillStudy_Hide()

	Pet:ClosePetSkillStudyMsgBox()

	this:CareObject(g_clientNpcId, 0, "PetSkillStudy");
	
	PetSkillStudy_Unlock();
	this:Hide();
	Pet:ShowPetList(-1);
	if( g_selidx ~= -1 )then
		Pet:SetPetLocation(g_selidx,-1);
	end
	g_selidx = -1;
	g_stduySkill = false;
	
end

--Éú³É äÊŞÃÅÅÉ¼¼ÄÜÏà¹ØµÄaction£¬²¢ºÍuiÉÏµÄbutton¹ØÁªÉÏ
function PetSkillStudy_GenMenPaiSkill()
	--if(2 == g_uitype) then
	--	--Éú³Éaction
	--	for i=2,4 do
	--		PETSKILLSTUDY_ACCBTN[i-1][2] = "menpai";
	--		PETSKILLSTUDY_ACCBTN[i-1][3] = Get_XParam_INT(i);
	--	end
	--	
	--	Pet:SkillStudy_MenPaiSkill_Created(PETSKILLSTUDY_ACCBTN[1][3],PETSKILLSTUDY_ACCBTN[2][3],PETSKILLSTUDY_ACCBTN[3][3]);
	--	
	--	--ÅäÖÃaction
	--	for k=1,3 do
	--		local action = Pet:EnumPetSkill(-4444, k-1, "petskill");
	--		if(action:GetID() ~= 0) then
	--			PETSKILLSTUDY_ACCBTN[k][1]:SetActionItem(action:GetID());
	--		end		
	--	end
	--	
	--end
end

function PetSkillStudy_Frame_OnHiden()

	Pet:ClosePetSkillStudyMsgBox()
	PetSkillStudy_MultiIMEEditBox:SetProperty("DefaultEditBox", "False");
	this:CareObject(g_clientNpcId, 0, "PetSkillStudy");
	PetSkillStudy_Unlock();
	this:Hide();
	PetSkillStudy_PetModel:SetFakeObject("")
	Pet:ShowPetList(-1);
	Pet:SetPetLocation(g_selidx,-1);
	g_selidx = -1;
	g_stduySkill = false;
end

function PetSkillStudy_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ı£¬×Ô¶¯¹Ø± 
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetSkillStudy_Hide();
		end
end

function PetSkillStudy_ShowPetGrow(nGrowLevel)
	local strTbl = {"Thß¶ng ","¿u ","Ki®t ","Trác ","Tuy®t "};
	if(nGrowLevel >= 1 and nGrowLevel <= table.getn(strTbl)) then
		if(strTbl[nGrowLevel]) then
			g_selidx = g_seledidx;
			PetSkillStudy_PetModel:SetFakeObject("");
			Pet:SetSkillStudyModel(g_selidx);
			Pet:SetPetLocation(g_selidx,13);
			PetSkillStudy_PetModel:SetFakeObject( "My_PetStudySkill" );
			
			PetSkillStudy_Text1:SetText("Trß·ng thành cüa Trân Thú #R"..strTbl[nGrowLevel]..".");
			PetSkillStudy_Accept:Disable();
		end
	end
	PetSkillStudy_Skill1:Hide();	--[tx47256]	
end

function PetSkillStudy_GetTakeLevelCostMoney(ptlv)
	if(nil == ptlv) then return 0; end
	if(nil == g_tlvcostmoney[ptlv]) then return 0; end
	
	return g_tlvcostmoney[ptlv];
end

function PetSkillStudy_GetTakeBabyCostMoney(ptlv, itemId)
	if(nil == ptlv) then return 0; end
	if(nil == g_tbabaymoney[ptlv]) then return 0; end
	
	local costMoney = g_tbabaymoney[ptlv];
	
	--AxTrace(0, 0, "costMoney="..costMoney.."¡£");
	
	--Ö ¼¶»¹Í¯¾íÖáÊ ·Ñ½µÖÁ90%
	if itemId and itemId ~= -1 then
		--AxTrace(0, 0, "itemId="..itemId.."¡£");
		if itemId == 30503011 or itemId == 30503012 then
			-- äÊŞ»¹Í¯¾íÖá/¸ß¼¶ äÊŞ»¹Í¯¾íÖá
		elseif itemId == 30503016 or itemId == 30503017 or itemId == 30503018 or itemId == 30503019 or itemId == 30503020 then
			--Ö ¼¶ äÊŞ»¹Í¯¾íÖá
			costMoney = (costMoney * 90) / 100;
			if costMoney <= 0 then
				costMoney = 1;
			end
		else
			--ÀàËÆ »¹Í¯µ¤£ºÍÃ×Ó
			costMoney = costMoney / 100;
			if costMoney <= 0 then
				costMoney = 1;
			end
		end
	end
	--AxTrace(0, 0, "ret costMoney="..costMoney.."¡£");
	
	return costMoney;
end

-- äÊŞ¼¼ÄÜÑ§Ï°£ºÁ½¸ö²»Í¬ÀàÊÖ¶¯¼¼ÄÜÈ·ÈÏ¡°Ñ§Ï°¡±£¨¸ÃÊÂ¼şÔÚ MessageBox_Self ½çÃæÖĞµÄ PET_SKILL_STUDY_CONFIRM ÊÂ¼şÖĞ´¥·¢£©
function PetSkillStudy_ConfirmPetSkillStudy()

	--PushDebugMessage ("PetSkillStudy_ConfirmPetSkillStudy")

	local saidx = g_selidx_jns
	local slidx = g_selidx

	--µ±Ç°ÊÇ·ñÊÇ äÊŞ¼¼ÄÜÑ§Ï°½çÃæ....
	if 1 ~= g_uitype then
		return
	end

	if (-1 == slidx) then
		PushDebugMessage("Ch÷n Trân Thú")
		return
	end

	if(-1 == saidx) then
		PushDebugMessage("C¥n Bí Kíp.")
		return
	end

	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")   --???? Vega
	local nM = tonumber(PetSkillStudy_Money:GetProperty("MoneyNumber"))
	if pM < nM then
		PushDebugMessage("Không ğü ngân lßşng h÷c kÛ nång")
		return
	end

	Pet:SkillStudy_Do( g_uitype, slidx, PETSKILLSTUDY_ACCBTN[saidx][3] )

	g_stduySkill = true;	--??????
	--PushDebugMessage("µ÷ÊÔĞÅÏ¢£ºÊÖ¶¯¼¼ÄÜÒÑÑ§»á¡£");

end

function PetSkillStudy_Frame_On_ResetPos()
  PetSkillStudy_Frame:SetProperty("UnifiedPosition", g_PetSkillStudy_Frame_UnifiedPosition);
end
