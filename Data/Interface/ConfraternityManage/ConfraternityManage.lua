local g_MembersCtl = {};
local g_TabSel = -1;
local g_ListToMember;
local g_MemberSel = {};

local GUILD_REQUIRES_INFO = 1;	--????????
local GUILD_MEMBERS_INFO = 2;		--??????
local GUILD_MANAGE_TAB_TEXT = {};
local g_ShowMsgFlag = false;

local g_AssChiefPos = 8;

local g_positionInfo = {
	"#GÐÃi phê chu¦n",
	"Bang Chúng  ",
	"Tinh Anh  ",
	"Thß½ng Nhân  ",
	"Ho¢ng Hóa SÑ ",
	"Công Vø SÑ ",
	"Nµi Vø SÑ ",
	"Phó Bang Chü ",
	"Bang Chü  ",
};

local g_menpaiInfo = {
	"Thiªu Lâm",
	"Minh Giáo",
	"Cái Bang",
	"Võ Ðang",
	"Nga Mi",
	"Tinh Túc",
	"Thiên Long",
	"Thiên S½n",
	"Tiêu dao",
	"Tñ do",
	"MÕn Ðà S½n Trang",
};

local g_ConfraternityManage_Frame_UnifiedPosition;
function ConfraternityManage_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_SHOW_MEMBERINFO");
	this:RegisterEvent("GUILD_UPDATE_MEMBERINFO");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("GUILD_SELFEQUIP_CLICK");
	this:RegisterEvent("SHOW_GUILDWAR_ANIMI");

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityManage_OnLoad()
	g_MemberSel[GUILD_REQUIRES_INFO] = -1;
	g_MemberSel[GUILD_MEMBERS_INFO] = -1;

	GUILD_MANAGE_TAB_TEXT = {
		"Hµi viên",
		"Dñ b¸",
	};
	g_ConfraternityManage_Frame_UnifiedPosition=ConfraternityManage_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityManage_OnEvent(event)
	Guild_Manage_SetCtl();

	if ( event == "UI_COMMAND") then
		if(tonumber(arg0) == 31 and this:IsVisible()) then
			Guild_Manage_Closed();
		elseif(tonumber(arg0) == 30) then
			Guild:AskGuildMembersInfo();	--???????????????????
		end
	elseif( event == "GUILD_SHOW_MEMBERINFO" ) then
		--×¼±¸Êý¾Ý
		Guild:PrepareMembersInfomation();
		Guild_Manage_SelectTab(GUILD_MEMBERS_INFO);
		this:Hide();
		this:Show();
	elseif( event == "GUILD_UPDATE_MEMBERINFO" and this:IsVisible()) then
		--×¼±¸Êý¾Ý
		Guild:PrepareMembersInfomation();
		Guild_Manage_SelectTab(g_TabSel);
	elseif( event == "GUILD_FORCE_CLOSE" ) then
		Guild_Manage_Closed();
	elseif( event == "ACCELERATE_KEYSEND" ) then
		Guild_Manage_HandleAccKey(arg0);
	elseif( event == "GUILD_SELFEQUIP_CLICK" ) then
		if(this:IsVisible()) then
			Guild_Manage_Closed();
		else
			Guild:AskGuildMembersInfo();	--???????????????????
		end
	elseif( event == "SHOW_GUILDWAR_ANIMI" ) then	--????“????”???? ???????????,????????????????,???????????
       local type = arg0;
		if(arg0=="show") then
                ConfraternityManage_7:SetText("#g0071BFbang hµi tuyên chiªn");
                ConfraternityManage_7:SetToolTip("Cüa ngß½i bang hµi ðang · Bang Chiªn");
        else
                ConfraternityManage_7:SetText("Bang hµi tuyên chiªn");
                ConfraternityManage_7:SetToolTip("");
        end
	end
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityManage_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityManage_Frame_On_ResetPos()
	end
end

function Guild_Manage_SetCtl()
	g_MembersCtl = {
									list = ConfraternityManage_MemberList,
									header = ConfraternityManage_PageHeader,
									count = ConfraternityManage_Online,
									name = ConfraternityManage_Info1_Text,
									info = {
														{txt = ConfraternityManage_Info2_Text, msg = ConfraternityManage_Info2,},
														{txt = ConfraternityManage_Info3_Text, msg = ConfraternityManage_Info3,},
														{txt = ConfraternityManage_Info4_Text, msg = ConfraternityManage_Info4,},
														{txt = ConfraternityManage_Info5_Text, msg = ConfraternityManage_Info5,},
														{txt = ConfraternityManage_Info6_Text, msg = ConfraternityManage_Info6,},
														{txt = ConfraternityManage_Info7_Text, msg = ConfraternityManage_Info7,},
												 },
									desc = ConfraternityManage_Tenet,
									edit = ConfraternityManage_EditTenet,

									btn = {
													ConfraternityManage_1,
													ConfraternityManage_2,
													ConfraternityManage_3,
													ConfraternityManage_4,
													ConfraternityManage_5,
													ConfraternityManage_6,
													ConfraternityManage_7,
													ConfraternityManage_8		--add by xindefeng
											  },

									ConfraternityManage_Tab2,
									ConfraternityManage_Tab1,
								 };						 
 	local id=Player:GetData("GUILDLEAGUE")
	if id and id>=0 then
		ConfraternityManage_9:Enable();
	else
		ConfraternityManage_9:Disable();
	end
end

function Guild_Manage_Clear()
	g_MembersCtl.list:ClearListBox();
	g_MembersCtl.header:SetText("");
	g_MembersCtl.count:SetText("");
	g_MembersCtl.name:SetText("");
	Guild_Manage_ClearInfo();
	g_MembersCtl.desc:SetText("");
	g_MembersCtl.desc:Show();

	g_MembersCtl.edit:SetText("");
	g_MembersCtl.edit:SetProperty("CaratIndex", 1024);
	g_MembersCtl.edit:Hide();

	g_ListToMember = nil;
end

function Guild_Manage_ClearInfo()
	local i = 1;
	while g_MembersCtl.info[i] ~= nil do
		g_MembersCtl.info[i].txt:SetText("");
		g_MembersCtl.info[i].msg:SetText("");
		i=i+1;
	end
end

function Guild_Manage_SelectTab( idx )
	if(idx <= 0 or idx == nil or idx > 2) then
		return;
	end
	Guild:CloseKickGuildBox();
	Guild_Manage_SetTabColor(idx);

	--Çå¿ ½çÃæÏÔÊ¾
	Guild_Manage_Clear();
	--¿ªÊ¼¸üÐÂ½çÃæ
	if( Guild:GetMembersNum(5) == 0 ) then
		g_TabSel = 2;		--??????????????Tab2????????
	end
	g_TabSel = idx;
	Guild_Manage_BtnSet();
	Guild_Manage_Update()
end

--ÉÁ¶¯µÚ¶þ¸öTab,ÏÖÔÚÃ»ÓÃÁË
function Guild_PlayTab2()
	if( this: IsVisible() and Guild:GetMembersNum(5) > 0 ) then
		if( ConfraternityManage_Tab2 : GetCheck() == 0 ) then
			ConfraternityManage_Tab2 : SetCheck(1);
		else
			ConfraternityManage_Tab2 : SetCheck(0);
		end
	else
		KillTimer("Guild_PlayTab2()");
		--»Ö¸´×´Ì¬
		ConfraternityManage_Tab2 : SetCheck(0);

	end
end

function Guild_Manage_BtnSet()
	--°´Å¥ÏÔÊ¾¿ØÖÆ
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		g_MembersCtl.btn[1]:Show();
		g_MembersCtl.btn[2]:Show();
		g_MembersCtl.btn[3]:Show();
		--g_MembersCtl.btn[4]:Show();
		g_MembersCtl.btn[5]:Show();
		g_MembersCtl.btn[7]:Show();
		g_MembersCtl.btn[8]:Show();		--add by xindefeng

		g_MembersCtl.btn[1]:SetText("Nhâm m®nh");
		g_MembersCtl.btn[2]:SetText("Trøc xu¤t");
		g_MembersCtl.btn[3]:SetText("Nhß¶ng ngôi");
		g_MembersCtl.btn[4]:SetText("Giäi tán");
		g_MembersCtl.btn[5]:SetText("SØa chæa tôn chï");
		g_MembersCtl.btn[6]:SetText("R¶i khöi");
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		if( Guild:GetMembersNum(5) == 0 ) then --?????????
			if g_ShowMsgFlag == false then
				PushDebugMessage("Bän bang trß¾c m£t không có dñ b¸ hµi viên");
			else
				g_ShowMsgFlag = false;
			end
			g_TabSel = GUILD_MEMBERS_INFO;
			ConfraternityManage_Tab2 : FlashMe(0);
			Guild_Manage_BtnSet(g_TabSel);
			ConfraternityManage_Tab2 : Disable();
			--KillTimer("Guild_PlayTab2()");
			return;
		else
			ConfraternityManage_Tab2 : FlashMe(1);
			ConfraternityManage_Tab2 : Enable();
		end
		g_MembersCtl.btn[1]:Show();
		g_MembersCtl.btn[2]:Show();
		g_MembersCtl.btn[3]:Hide();
		g_MembersCtl.btn[4]:Hide();
		g_MembersCtl.btn[5]:Hide();
		g_MembersCtl.btn[7]:Hide();
		g_MembersCtl.btn[8]:Hide();	--add by xindefeng

		g_MembersCtl.btn[1]:SetText("Tiªp thu");
		g_MembersCtl.btn[2]:SetText("Cñ tuy®t");
		g_MembersCtl.btn[6]:SetText("R¶i khöi");
	end

	--°´Å¥EnableºÍDisable¿ØÖÆ
	local szPower = Guild:GetMyGuildPower(); --"1111111111" ?10?????10???
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--Ö°Îñµ÷¶¯È¨1
		Guild_Manage_BtnEnableDisable(szPower,1,1);
		--È¨ÏÞµ÷ ûÈ¨2
		--¿ª³ý°ïÖÚÈ¨4
		Guild_Manage_BtnEnableDisable(szPower,4,2);
		--ìøÈÃÈ¨5
		Guild_Manage_BtnEnableDisable(szPower,5,3);
		--Ö§È¡°ï×ÊÈ¨6
		--´æÈë½ð¶îÈ¨7
		--Àë¿ª°ï»áÈ¨8
		--½âÉ¢°ï»áÈ¨9
		Guild_Manage_BtnEnableDisable(szPower,9,4);
		--ÐÞ¸Ä°ï»á×ÚÖ¼È¨10
		Guild_Manage_BtnEnableDisable(szPower,10,5);
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		--½ÓÊ °ïÖÚÈ¨3
		Guild_Manage_BtnEnableDisable(szPower,3,1);
		Guild_Manage_BtnEnableDisable(szPower,3,2);
	end

	if( Guild:GetMembersNum(5) == 0 ) then --?????????
		ConfraternityManage_Tab2_Mask : SetToolTip("Bän bang trß¾c m£t không có dñ b¸ hµi viên");
		ConfraternityManage_Tab2_Mask : Enable();
		ConfraternityManage_Tab2:Disable();
	else
		ConfraternityManage_Tab2 : SetToolTip("Hi®n Hæu dñ b¸ hµi viên xin gia nh§p bän bang");
		ConfraternityManage_Tab2_Mask : Disable();
		ConfraternityManage_Tab2:Enable();
		ConfraternityManage_Tab2 : FlashMe(1);
	end
end

function Guild_Manage_BtnEnableDisable(szPower, szidx, btnidx)
	local iPower = string.byte(szPower,szidx);
	if(iPower == 48) then			--'0'
		g_MembersCtl.btn[btnidx]:Disable();
	elseif(iPower == 49) then  --'1'
		g_MembersCtl.btn[btnidx]:Enable();
	end
end

function Guild_Manage_Update()
	if(g_TabSel <= 0 or g_TabSel > 2) then
		return;
	end
	if( g_TabSel == GUILD_MEMBERS_INFO ) then
		g_MembersCtl[g_TabSel]:SetCheck(1);
	elseif( Guild:GetMembersNum(5) > 0 ) then
		g_MembersCtl[g_TabSel]:SetCheck(1);
	else
		g_MembersCtl[GUILD_MEMBERS_INFO]:SetCheck(0);
	end

	--×Ô¼º°ï»áµÄÃû³Æ
	--local szMsg = Guild:GetMyGuildInfo("Name");
	--g_MembersCtl.header:SetText(szMsg .. "°ï»á»áÔ±¹ÜÀí");
	--20060710°´²ß»®ÒªÇó£¬Ö»ÏÔÊ¾»áÔ±¹ÜÀí
	g_MembersCtl.header:SetText("#gFF0FA0hµi viên quän lý");

	--×Ô¼º°ï»áµÄ×ÚÖ¼
	szMsg = Guild:GetMyGuildInfo("Desc");
	g_MembersCtl.desc:SetText(szMsg);

	--ÈËÊý
	g_MembersCtl.count:SetText("Hµi viên:"..Guild:GetMembersNum(3).."/"..Guild:GetMembersNum(1).."/"..Guild:GetMembersNum(2));

	--ÈËÔ±ÁÐ±í
	g_ListToMember = {};
	local listidx = 0;
	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--local totalNum = Guild:GetMembersNum(1);
		local totalNum = Guild:GetMembersNum(4);
		local i = 0;

		while i < totalNum do
			--if( -1 ~= Guild:GetMembersInfo(i, "GUID")) then
				--ÓÐÐ§µÄÊý¾Ý
				--if(GUILD_REQUIRES_INFO ~= Guild:GetMembersInfo(i, "Position")) then
					--szMsg = Guild:GetMembersInfo(i, "Name");
					--g_MembersCtl.list:AddItem(g_positionInfo[Guild:GetMembersInfo(i, "Position")]..szMsg, listidx);
					--g_ListToMember[listidx] = i;
					--listidx = listidx + 1;
				--end
			--end
			local guildIdx = Guild:GetShowMembersIdx(i);
			local color,strTips = Guild:GetMembersInfo(guildIdx, "ShowColor");
			szMsg = Guild:GetMembersInfo(guildIdx, "Name");
			local FirstManGuid = Guild:GetMembersInfo(guildIdx, "FirstManGuid");
			local tPos = Guild:GetMembersInfo(guildIdx, "Position")
			if FirstManGuid == Guild:GetMembersInfo(guildIdx, "GUID") and tPos == g_AssChiefPos then
				g_MembersCtl.list:AddItem("#P"..g_positionInfo[tPos]..szMsg, listidx);
			else
				g_MembersCtl.list:AddItem(color..g_positionInfo[tPos]..szMsg, listidx);
			end
			g_MembersCtl.list:SetItemTooltip(listidx,strTips);
			g_ListToMember[listidx] = guildIdx;

			listidx = listidx + 1;
			i = i + 1;
		end
	elseif(g_TabSel == GUILD_REQUIRES_INFO) then
		--local totalNum = Guild:GetMembersNum(1);
		local totalNum = Guild:GetMembersNum(5);
		local i = 0;

		while i < totalNum do
			--if( -1 ~= Guild:GetMembersInfo(i, "GUID")) then
				--ÓÐÐ§µÄÊý¾Ý
				--if(GUILD_REQUIRES_INFO == Guild:GetMembersInfo(i, "Position")) then
					--szMsg = Guild:GetMembersInfo(i, "Name");
					--g_MembersCtl.list:AddItem(szMsg, listidx);
					--g_ListToMember[listidx] = i;
					--listidx = listidx + 1;
				--end
			--end
			local guildIdx = Guild:GetShowTraineesIdx(i);
			local color,strTips = Guild:GetMembersInfo(guildIdx, "ShowColor");
			szMsg = Guild:GetMembersInfo(guildIdx, "Name");
			g_MembersCtl.list:AddItem(color..g_positionInfo[Guild:GetMembersInfo(guildIdx, "Position")]..szMsg, listidx);
			g_MembersCtl.list:SetItemTooltip(listidx,strTips);
			g_ListToMember[listidx] = guildIdx;

			listidx = listidx + 1;
			i = i + 1;
		end
	end

	Guild_Manage_JudgeSelectMember();
end

function Guild_Manage_JudgeSelectMember()
	if(g_MemberSel[g_TabSel] < 0 or nil == g_ListToMember[g_MemberSel[g_TabSel]]
		 or g_MemberSel[g_TabSel] >= g_MembersCtl.list:GetItemNumber()) then
		g_MemberSel[g_TabSel] = -1;
		--Ä¬ÈÏÑ¡ÖÐÁÐ±íÀïµÄµÚÒ»¸öÈË
		if(nil ~= g_ListToMember[0]) then
			g_MembersCtl.list:SetItemSelectByItemID(0);
			Guild_Manage_Selected();
		end
	else
		--Ñ¡ÖÐÉÏ´ÎÑ¡ÖÐµÄÈË
		g_MembersCtl.list:SetItemSelectByItemID(g_MemberSel[g_TabSel]);
		Guild_Manage_Selected();
	end
end

function Guild_Manage_Selected()
	g_MemberSel[g_TabSel] = g_MembersCtl.list:GetFirstSelectItem();
	Guild_Manage_SetMembersInfo(g_MemberSel[g_TabSel]);
	Guild:CloseKickGuildBox();
end

function Guild_Manage_SetMembersInfo( lidx )
	if(lidx < 0 or lidx == nil) then
		return;
	end

	Guild_Manage_ClearInfo();
	local szMsg;

	--Ãû³Æ
	szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "Name");
	local szId;
	_,szId = Guild:GetMembersInfo(g_ListToMember[lidx], "GUID");
	g_MembersCtl.name:SetText(szMsg.."("..szId..")");

	--ÃÅÅÉ
	szMsg = g_menpaiInfo[Guild:GetMembersInfo(g_ListToMember[lidx], "MenPai")+1];
	g_MembersCtl.info[1].txt:SetText("Môn phái:");
	g_MembersCtl.info[1].msg:SetText(szMsg);

	--µÈ¼¶
	szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "Level");
	g_MembersCtl.info[2].txt:SetText("C¤p b§c:");
	g_MembersCtl.info[2].msg:SetText(szMsg);

	if(g_TabSel == GUILD_MEMBERS_INFO) then
		--¹±Ï×¶È
		--2006-12-7 19:44 TODO
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "CurCon").."/"..Guild:GetMembersInfo(g_ListToMember[lidx], "MaxCon");
		--szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "CurCon");
		g_MembersCtl.info[3].txt:SetText("C¯ng hiªn Ðµ:");
		g_MembersCtl.info[3].msg:SetText(szMsg);
		--Èë°ïÊ±¼ä
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "JoinTime");
		g_MembersCtl.info[4].txt:SetText("Nh§p Bang th¶i gian:");
		g_MembersCtl.info[4].msg:SetText(szMsg);
		--ÉÏÏßÊ±¼ä
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "LogOutTime");
		g_MembersCtl.info[5].txt:SetText("Login th¶i gian:");
		g_MembersCtl.info[5].msg:SetText(szMsg);
		--Ã¿ÖÜ¹±Ï×¶È
		szMsg = Guild:GetMembersInfo(g_ListToMember[lidx], "ContriPerWeek");
		g_MembersCtl.info[6].txt:SetText("B±n Chu c¯ng hiªn Ðµ:");
		g_MembersCtl.info[6].msg:SetText(szMsg);
	end
end
function Show_PopMenu()
	local index = ConfraternityManage_MemberList:GetFirstSelectItem();
	if( index > -1 ) then
		if(g_TabSel>0 and g_TabSel<3)then
			Guild:Show_PopMemu(tonumber(index),tonumber(g_TabSel));
		end
	end

end

function Guild_Manage_BtnClick( idx )
	if(g_TabSel < 0) then
		return;
	end

	Guild:CloseKickGuildBox();
	local iMember = g_ListToMember[g_MemberSel[g_TabSel]];
	if(nil ~= iMember) then
		if( idx == 1 ) then
			--btn1
			if(g_TabSel == GUILD_MEMBERS_INFO) then
				Guild:AskGuildAppointPosInfo(iMember);
			elseif(g_TabSel == GUILD_REQUIRES_INFO) then
				Guild:RecruitGuild(iMember);
				g_ShowMsgFlag = true;
			end
		elseif(idx == 2 ) then
			--btn2
			Guild:KickGuild(iMember);
			if(g_TabSel == GUILD_REQUIRES_INFO) then
				g_ShowMsgFlag = true;
			end
		end
	end

	if(g_TabSel == GUILD_MEMBERS_INFO) then
		if(idx == 3 ) then
			--btn3
			Guild:DemisGuild();
		elseif(idx == 4 ) then
			--btn4
			Guild:DestoryGuild();
		elseif(idx == 5 ) then
			--btn5
			Guild_Manage_ChangeDesc();
		elseif(idx == 7 ) then
			--btn7
			if(nil ~= iMember) then
				local strName = Guild:GetMembersInfo(iMember, "Name")
				DataPool:AddFriendAndGrouping(strName)
			end
		--add & comment by xindefeng
		--°ïÖ÷:µ¯³ö¿ÉÒÔÐÞ¸ÄÖ°Î»µÄ½çÃæ
		--·Ç°ïÖ÷:µ¯³öÖ»¿ÉÒÔ²é¿´Ö°Î»µÄ½çÃæ
		elseif(idx == 8)then	--btn8
			Guild:AskCurCustomPositionName()
		end

	end

	if(idx == 6) then
		--btn6
		Guild_Manage_Closed();
	end

	if(idx == 10) then
		ConfraternityManage_DoCommerceNet();
	end

end

function Guild_Manage_CheckDetail()
	Guild:AskGuildDetailInfo();
	--Guild_Manage_Closed();
	Guild:CloseKickGuildBox();
end

function Guild_Manage_Closed()
	g_MemberSel[GUILD_REQUIRES_INFO] = -1;
	g_MemberSel[GUILD_MEMBERS_INFO] = -1;
	this:Hide();
end

function Guild_Manage_ChangeDesc()
	if(g_MembersCtl.edit:IsVisible()) then
		Guild_Manage_ChangeDescFin();
	elseif(g_MembersCtl.desc:IsVisible()) then
		Guild_Manage_ChangeDescBegin();
	end
end

function Guild_Manage_ChangeDescBegin()

	--Èç¹ûÃ»ÊäÈë¹ý¶þ¼¶ÃÜÂëÔòÊäÈëÒ»´Î£¬×¢Òâ£ºPlayer:IsLocked() == 0±íÊ¾Ëø¶¨
	if CheckPhoneMibaoAndMinorPassword() == 0 then
		return
	end

	local szMsg = Guild:GetMyGuildInfo("Desc");

	g_MembersCtl.edit:SetText(szMsg);
	g_MembersCtl.edit:SetProperty("CaratIndex", 1024);
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "True");
	g_MembersCtl.edit:Show();

	g_MembersCtl.desc:Hide();
	g_MembersCtl.btn[5]:SetText("SØa chæa hoàn thành");
end

function Guild_Manage_ChangeDescFin()
	local szMsg = g_MembersCtl.edit:GetText();
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "False");
	g_MembersCtl.edit:Hide();

	--g_MembersCtl.desc:SetText(szMsg);
	g_MembersCtl.desc:Show();

	Guild:FixGuildInfo("Desc", szMsg);
	g_MembersCtl.btn[5]:SetText("SØa chæa tôn chï");
end

function ConfraternityManage_Hidden()
	g_MembersCtl.edit:SetProperty("DefaultEditBox", "False");
	Guild:CloseKickGuildBox();
end

function Guild_Manage_HandleAccKey( op )
	if( op == "acc_guild") then
		if(this:IsVisible()) then
			Guild_Manage_Closed();
		else
			Guild:AskGuildMembersInfo();
		end
	end
end

function Guild_Manage_SetTabColor(idx)
	if(idx == nil or idx <= 0 or idx > 2) then
		return;
	end

	local i = 1;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								ConfraternityManage_Tab2,
								ConfraternityManage_Tab1,
							};
	if( idx ==2 ) then
		if( Guild:GetMembersNum(5) == 0 ) then
				tab[1] : SetText( "#cbbbbbb" .. GUILD_MANAGE_TAB_TEXT[2]);
			else
				tab[1] : SetText( "#G" .. GUILD_MANAGE_TAB_TEXT[2]);
		end
	  tab[2] : SetText( noselColor..GUILD_MANAGE_TAB_TEXT[1] );
	else
		tab[2] : SetText( selColor..GUILD_MANAGE_TAB_TEXT[1] );
		if( Guild:GetMembersNum(5) == 0 ) then
			tab[1] : SetText( "#cbbbbbb" .. GUILD_MANAGE_TAB_TEXT[2]);
		else
			tab[1] : SetText( "#G" .. GUILD_MANAGE_TAB_TEXT[2]);
		end
	end


end

function ConfraternityManage_XuanZhan_BtnClick()
	City:OpenGuildWarDlg();
	Guild:CloseKickGuildBox();
end

function ConfraternityManage_DoLeagueInfo()
	GuildLeague:ShowInfoWindow();
end

function ConfraternityManage_DoCommerceNet()
	City:AskCityRoad(1);
end



--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function ConfraternityManage_Frame_On_ResetPos()
  ConfraternityManage_Frame:SetProperty("UnifiedPosition", g_ConfraternityManage_Frame_UnifiedPosition);
end
