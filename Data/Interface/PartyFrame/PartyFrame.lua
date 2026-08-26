--***********************************************************************************************************************************************
--***********************************************************************************************************************************************
--
-- ×é¶ÓÁÐ±í¿òµÄÖ÷Òª½Å±¾ÊÂ¼þ
--
--
--
--************************************************************************************************************************************************
--************************************************************************************************************************************************



--------------------------------------------------------------------------------------------------------------------------------------------------
--
-- ¾Ö²¿±äÁ¿µÄ¶¨Òå.
--
local PARTYFRAMEs = {};
local PARTY_HP = {};
local PARTY_MP = {};
local PARTY_FRAME = {};
local PARTY_NAME  = {};
local Portrait_ToolTips = {};
local UnLink_flag = {};					-- ????
local Porttrait_Mask = {};			-- ????

local RatioFakeObjNeedUpdate = 1;

-- ÏÔÊ¾hpµÄtext
local HP_Text_Tip = {};

local	MemberName;
local strIconIndex;
local HPValue;
local HPMax;
local MPValue;
local MPMax;
local Fammily;
local Level;
local Anger;
local DeadLink;
local Dead;
local sex;

-- ÏÔÊ¾¶ÓÓÑËùÖÐµÄbuf
local PARTY_BUFF_MAX = 6;
local PARTY_IMPACT_CTL = {};

local PARTY_IMPACT_NUM = 30; --?????20???????????6?

-- ¶ÓÓÑ³ö ½ äÊÞ°´Å¥
local Team_Member_Pet_Button = {};
-- ¶ÓÓÑµÄ³ö ½ äÊÞÏÔÊ¾ÐÅÏ¢
local PetPortrait_ToolTips = {};

local Raid_Flags = {}
--***********************************************************************************************************************************************
--
--
--
--
--************************************************************************************************************************************************
function PartyFrame_PreLoad()

	--AxTrace( 0,0, "partyframe_Preload");
	this:RegisterEvent("TEAM_ENTER_MEMBER");				-- ????????
	this:RegisterEvent("TEAM_UPDATE_MEMBER");				-- ????????
	this:RegisterEvent("TEAM_HIDE_ALL_PLAYER");			-- ????????
	this:RegisterEvent("TEAM_REFRESH_DATA");				-- ??????????
	this:RegisterEvent("ON_TEAM_UPDATE_PARTYFRAME");			-- ??PartyFrame??			add by WTT

	this:RegisterEvent("RAID_UPDATE_SQUAD_FRAME",true)
	this:RegisterEvent("RAID_CLOSE_SQUAD_FRAME",false)

end

function PartyFrame_OnLoad()


	PARTYFRAMEs[1] = PartyFrame1;
	PARTYFRAMEs[2] = PartyFrame2;
	PARTYFRAMEs[3] = PartyFrame3;
	PARTYFRAMEs[4] = PartyFrame4;
	PARTYFRAMEs[5] = PartyFrame5;

	PARTY_HP[1] = PartyFrame_HP1;
	PARTY_HP[2] = PartyFrame_HP2;
	PARTY_HP[3] = PartyFrame_HP3;
	PARTY_HP[4] = PartyFrame_HP4;
	PARTY_HP[5] = PartyFrame_HP5;

	--PARTY_MP[1] = PartyFrame_MP1;
	--PARTY_MP[2] = PartyFrame_MP2;
	--PARTY_MP[3] = PartyFrame_MP3;
	--PARTY_MP[4] = PartyFrame_MP4;
	--PARTY_MP[5] = PartyFrame_MP5;

	PARTY_FRAME[1] = PartyFrame_Party1;
	PARTY_FRAME[2] = PartyFrame_Party2;
	PARTY_FRAME[3] = PartyFrame_Party3;
	PARTY_FRAME[4] = PartyFrame_Party4;
	PARTY_FRAME[5] = PartyFrame_Party5;

	--PARTY_NAME[1] = Name1;
	--PARTY_NAME[2] = Name2;
	--PARTY_NAME[3] = Name3;
	--PARTY_NAME[4] = Name4;
	--PARTY_NAME[5] = Name5;

	Portrait_ToolTips[1] = Portrait_Icon1;
	Portrait_ToolTips[2] = Portrait_Icon2;
	Portrait_ToolTips[3] = Portrait_Icon3;
	Portrait_ToolTips[4] = Portrait_Icon4;
	Portrait_ToolTips[5] = Portrait_Icon5;

	HP_Text_Tip[1] = PartyFrame_HP_Text1;
	HP_Text_Tip[2] = PartyFrame_HP_Text2;
	HP_Text_Tip[3] = PartyFrame_HP_Text3;
	HP_Text_Tip[4] = PartyFrame_HP_Text4;
	HP_Text_Tip[5] = PartyFrame_HP_Text5;

	--2006Äê5ÔÂ20È , ÐÞ¸ÄµôÏßÐÅÏ¢¹¦ÄÜ
	UnLink_flag[1] = Team_Leader_Flag2;
	UnLink_flag[2] = Team_Leader2_Flag2;
	UnLink_flag[3] = Team_Leader3_Flag2;
	UnLink_flag[4] = Team_Leader4_Flag2;
	UnLink_flag[5] = Team_Leader5_Flag2;


	--2006Äê5ÔÂ20È , ÐÞ¸ÄËÀÍöÃÉ×Ó
	Porttrait_Mask[1] = Portrait_Icon1_Mask;
	Porttrait_Mask[2] = Portrait_Icon2_Mask;
	Porttrait_Mask[3] = Portrait_Icon3_Mask;
	Porttrait_Mask[4] = Portrait_Icon4_Mask;
	Porttrait_Mask[5] = Portrait_Icon5_Mask;


	PARTY_IMPACT_CTL[1] = {
												PartyFrame_1_Buff1,
												PartyFrame_1_Buff2,
												PartyFrame_1_Buff3,
												PartyFrame_1_Buff4,
												PartyFrame_1_Buff5,
												PartyFrame_1_Buff6,
											};
	PARTY_IMPACT_CTL[2] = {
												PartyFrame_2_Buff1,
												PartyFrame_2_Buff2,
												PartyFrame_2_Buff3,
												PartyFrame_2_Buff4,
												PartyFrame_2_Buff5,
												PartyFrame_2_Buff6,
											};
	PARTY_IMPACT_CTL[3] = {
												PartyFrame_3_Buff1,
												PartyFrame_3_Buff2,
												PartyFrame_3_Buff3,
												PartyFrame_3_Buff4,
												PartyFrame_3_Buff5,
												PartyFrame_3_Buff6,
											};
	PARTY_IMPACT_CTL[4] = {
												PartyFrame_4_Buff1,
												PartyFrame_4_Buff2,
												PartyFrame_4_Buff3,
												PartyFrame_4_Buff4,
												PartyFrame_4_Buff5,
												PartyFrame_4_Buff6,
											};
	PARTY_IMPACT_CTL[5] = {
												PartyFrame_5_Buff1,
												PartyFrame_5_Buff2,
												PartyFrame_5_Buff3,
												PartyFrame_5_Buff4,
												PartyFrame_5_Buff5,
												PartyFrame_5_Buff6,
											};


	Team_Leader2_Flag:Hide();
	Team_Leader3_Flag:Hide();
	Team_Leader4_Flag:Hide();
	Team_Leader5_Flag:Hide();

	-- µÚ1ÖÁ5ºÅ¶ÓÓÑµÄ³ö ½³èÎï°´Å¥
	-- add by WTT
	Team_Member_Pet_Button[1] = Team_Pet_Button;
	Team_Member_Pet_Button[2] = Team_Pet2_Button;
	Team_Member_Pet_Button[3] = Team_Pet3_Button;
	Team_Member_Pet_Button[4] = Team_Pet4_Button;
	Team_Member_Pet_Button[5] = Team_Pet5_Button;

	--  äÊÞÍ·ÏñÉÏµÄ¸¡¶¯ÐÅÏ¢
	-- add by WTT
	PetPortrait_ToolTips[1]= Team_Pet_Button;
	PetPortrait_ToolTips[2]= Team_Pet2_Button;
	PetPortrait_ToolTips[3]= Team_Pet3_Button;
	PetPortrait_ToolTips[4]= Team_Pet4_Button;
	PetPortrait_ToolTips[5]= Team_Pet5_Button;
	
	Raid_Flags[1] = Team_Leader_Flag3
	Raid_Flags[2] = Team_Leader2_Flag3
	Raid_Flags[3] = Team_Leader3_Flag3
	Raid_Flags[4] = Team_Leader4_Flag3
	Raid_Flags[5] = Team_Leader5_Flag3

end

--****************************************************************************************************************
--
-- ÊÂ¼þÈë¿Ú
--
--****************************************************************************************************************
function PartyFrame_OnEvent(event)

	--AxTrace( 0,0, "eventÃæ");
	----------------------------------------------------------------------------------------------------------------
	--
	-- Òþ²ØËùÓÐ¶ÓÓÑ½çÃæ
	if ( event == "TEAM_HIDE_ALL_PLAYER" ) then

		--AxTrace( 0,0, "É¾³ýËùÓÐ½çÃæ");
		Hide_All_Play_Func();
		return;
	end


	-----------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂËùÓÐ¶ÓÓÑ½çÃæ.
	if( event == "TEAM_REFRESH_DATA" ) then

		Refresh_All_Member_Info_Func();
			return;
	end



	------------------------------------------------------------------------------------------------------------------
	--
	-- ÓÐÐÂµÄ¶ÓÔ±½øÈë
	if ( event == "TEAM_ENTER_MEMBER" ) then
		Refresh_All_Member_Info_Func();
		return;

	end



	--------------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂ¶ÓÔ±ÐÅÏ¢.
	if ( event == "TEAM_UPDATE_MEMBER" ) then
			Refresh_All_Member_Info_Func();
		return;

	end

	--------------------------------------------------------------------------------------------------------------------
	--
	-- ¸üÐÂPartyFrame½çÃæ
	-- add by WTT
	if ( event == "ON_TEAM_UPDATE_PARTYFRAME" ) then
		Refresh_All_Member_Info_Func();
		return;
	end

	if (event == "RAID_UPDATE_SQUAD_FRAME") then
		RatioFakeObjNeedUpdate = tonumber( arg2 )
		Refresh_All_RaidMember_Info()
		RatioFakeObjNeedUpdate = 1
		return
	end

	if (event == "RAID_CLOSE_SQUAD_FRAME") then
		Hide_All_Play_Func()
		return
	end


end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾Ò»¸öÐÂ¼ÓÈëµÄ¶ÓÔ±
--
--************************************************************************************************************************************************
function PartyFrame_UpdatePage(index)


	--AxTrace( 0,0, "ÏÔÊ¾¶ÓÓÑ!" .. tostring(index));
	if((index < 1) or (index > 5)) then
			--AxTrace( 0,0, "½çÃæË÷Òý³öÏÖÒì³£!");
			return;
	end

	this:Show();

	--ÏÔÊ¾ÐÂ¼ÓÈë¶ÓÓÑµÄÍ·Ïñ
	PARTYFRAMEs[index]:Show();

	--ÏÔÊ¾ÐÂ¼ÓÈë¶ÓÓÑµÄ äÊÞ°´Å¥
	PetButton_Show (index);

	--AxTrace( 0,0, "ÏÔÊ¾¶ÓÓÑÍê±Ï!" .. tostring(index));

end



--***********************************************************************************************************************************************
--
-- µ±ÓÒ¼üµã»÷´°¿ÚµÄÊ±ºò, µ¯³ö²Ëµ¥
--
--************************************************************************************************************************************************
function Show_Team_Func(index)

	PartyFrame_SelectAsTarget(index)
	if Player:IsInRaid() == 1 then
		local sIdx, mIdx = Raid:GetMySquadMemIdxByUIIdx(index - 1)
		Raid:ShowMemberContMenu("PartyFrame", sIdx, mIdx)
	else
		Show_Team_Func_Menu(index);
	end
end


--***********************************************************************************************************************************************
--
-- Òþ²Ø¶ÓÁÐ´°¿Ú
--
--************************************************************************************************************************************************
function Hide_All_Play_Func()

	local index = 1;
	while (index < 6) do

			PARTYFRAMEs[index]:Hide();
			Team_Member_Pet_Button[index]:Hide();
			Raid_Flags[index]:Hide()

			index = index + 1;

	end

	Team_Leader_Flag:Hide();
	PartyFrame_ClerAllBufInfo();

end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶ÓÔ±ÐÅÏ¢
--
--************************************************************************************************************************************************
function Show_Team_Member_Info_Func(index)

		--AxTrace( 0,0, "¿ªÊ¼µÃµ½¶ÓÓÑÐÅÏ¢Íê±Ï!" .. tostring(index));
		-- µÃµ½¶ÓÔ±µÄ¸öÊý
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊý!" .. tostring(iMemCount));

		if((iMemCount < 1)and(iMemCount > 5)) then

			--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊýÒì³£" .. tostring(iMemCount));
			return;
		end

		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
		MemberName
		, strIconIndex
		, HPValue
		, HPMax
		, MPValue
		, MPMax
		, Fammily
		, Level
		, Anger
		, DeadLink
		, Dead
		, sex
		, ScenceName
		= DataPool:GetTeamMemberInfo( index );

		--AxTrace( 0,0, "µÃµ½¶ÓÓÑÐÅÏ¢Íê±Ï!" .. tostring(index));
		-- ÉèÖÃÃû×Ö.
		--PARTY_NAME[index]:SetText(MemberName);

		-- ÉèÖÃhp
		if(-1 ~= HPValue) then
			PARTY_HP[index]:SetProgress(tonumber(HPValue), tonumber(HPMax));
		else
			PARTY_HP[index]:SetProgress(1, 1);
		end;
		--AxTrace( 0,0, "µ±Ç°ÑªÖµ!" .. tostring(HPValue));
		--AxTrace( 0,0, "ÑªÖµ×î´ó!" .. tostring(HPMax));

		-- ÉèÖÃmp
		--PARTY_MP[index]:SetProgress(tonumber(MPValue), tonumber(MPMax));
		--AxTrace( 0,0, "µ±Ç°Ä§·¨!" .. tostring(MPValue));
		--AxTrace( 0,0, "Ä§·¨×î´ó!" .. tostring(MPMax));


		Show_Leader_Flag_Func();

		-- ÉèÖÃtooltips
		local bDead = "Sai";
		local bDeadLink = "Sai";

		Portrait_ToolTips[index]:SetProperty("Image", "set:PlayerFrame_Icon image:Icon_xiaoyao");
		Portrait_ToolTips[index]:SetProperty("Image", strIconIndex);

		--if(0 ~= Dead) then
		--	bDead = "ÊÇ"
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Die_Icon");
		--end

		--if(0 ~= DeadLink) then
		--	bDeadLink = "ÊÇ"
		--	AxTrace( 0,0, "ÉèÖÃµôÏßÐÅÏ¢");
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Downline_Icon");
		--end

		AxTrace( 0,0, "Nh§n ðßþc Ðµi Hæu tin tÑc xong!" .. tostring(index));
		if(0 ~= Dead) then
			bDead = "Ðúng"
			--Portrait_ToolTips[tonumber(index)]:Disable();
			Porttrait_Mask[index]:Show();
		else

			--Portrait_ToolTips[tonumber(index)]:Eable();
			Porttrait_Mask[index]:Hide();
		end

		if(0 == DeadLink) then

			UnLink_flag[tonumber(index)]:Hide();
		else

			bDeadLink = "Ðúng"
			UnLink_flag[tonumber(index)]:Show();
		end


		--local strInfo = "\n Ãû×Ö: "
		--								.. tostring(MemberName)
		--      					.. "\n ÃÅÅÉ:"
		--								.. tostring(Fammily)
		--								.. "\n µÈ¼¶:"
		--								.. tostring(Level)
		--								.. " \n hp:"
		--								.. tostring(HPValue) .. "/" .. tostring(HPMax)
		--								.. " \n mp:"
		--								.. tostring(MPValue) .. "/" .. tostring(MPMax)
		--								.. " \n Å­Æø:"
		--								.. tostring(Anger)
		--								.. " \n ¶ÏÏß:"
		--								.. tostring(bDeadLink)
		--								.. " \n ËÀÍö:"
		--								.. tostring(bDead);

		--AxTrace( 0,0, "fmaily  " .. tostring(Fammily));
		local strMenPai = "";
		-- µÃµ½ÃÅÅÉÃû³Æ.
		if(0 == Fammily) then
			strMenPai = "Thiªu Lâm";

		elseif(1 == Fammily) then
			strMenPai = "Minh Giáo";

		elseif(2 == Fammily) then
			strMenPai = "Cái Bang";

		elseif(3 == Fammily) then
			strMenPai = "Võ Ðang";

		elseif(4 == Fammily) then
			strMenPai = "Nga Mi";

		elseif(5 == Fammily) then
			strMenPai = "Tinh Túc";

		elseif(6 == Fammily) then
			strMenPai = "Thiên Long";

		elseif(7 == Fammily) then
			strMenPai = "Thiên S½n";

		elseif(8 == Fammily) then
			strMenPai = "Tiêu dao";

		elseif(9 == Fammily) then
			strMenPai = "Tñ do";

		elseif(10== Fammily) then
			strMenPai = "MÕn Ðà S½n Trang";

		end

		local strInfo = tostring(MemberName)
		      					.. "\n"
										.. tostring(strMenPai).."  "
										.. tostring(Level).. "C¤p"
										.. "\\nch², n½i Ð¸a:"
										.. ScenceName;


		Portrait_ToolTips[index]:SetToolTip(strInfo);

		if(-1 == HPValue) then

			-- ¿ç³¡¾°µÄÇé¿ö¡£
			PARTY_HP[index]:SetToolTip("Không biªt");
		else

			PARTY_HP[index]:SetToolTip(tostring(HPValue).."/"..tostring(HPMax));
		end;

		PartyFrame_ClerBufInfo(index);
		PartyFrame_UpdateBufInfo(index);

		-- ÏÔÊ¾¶ÓÔ±³ö ½ äÊÞÍ¼±ê
		PetButton_Show(index);

end


--***********************************************************************************************************************************************
--
-- ¸üÐÂËùÓÐ¶ÓÔ±ÐÅÏ¢
--
--************************************************************************************************************************************************
function Refresh_All_Member_Info_Func()

		-- ÏÈÒþ²ØµôËùÓÐµÄ¶ÓÔ±.
		Hide_All_Play_Func();

		-- µÃµ½¶ÓÔ±µÄ¸öÊý
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊý!" .. tostring(iMemCount));

		--
		if((iMemCount < 1)or(iMemCount > 6)) then

			--AxTrace( 0,0, "µÃµ½¶ÓÓÑ¸öÊýÒì³£" .. tostring(iMemCount));
			return;
		end

		for index = 1, iMemCount - 1 do

				-- ÏÔÊ¾Ò»¸ö¶ÓÔ±
				PartyFrame_UpdatePage(index);

				-- ÏÔÊ¾¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
				Show_Team_Member_Info_Func(index);

				-- ÏÔÊ¾¶ÓÔ±µÄ äÊÞ°´Å¥
				PetButton_Show(index);

		end

		Show_Leader_Flag_Func();

end


--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶Ó³¤ÐÅÏ¢
--
--************************************************************************************************************************************************
function Show_Leader_Flag_Func()

	-- ÏÔÊ¾¶Ó³¤±ê¼Ç
	local iIsLeader = DataPool:IsTeamLeader();
	if (1 == iIsLeader) then

		Team_Leader_Flag:Show();
	end

end


--***********************************************************************************************************************************************
--
-- Ñ¡Ôñ¶ÓÓÑ×÷Îªtarget(Í¬ÓÎÏ·ÖÐ, ÓÒ¼üµã»÷Ò»¸öÄ£ÐÍÐ§¹ûÒ»Ñù)
--
--************************************************************************************************************************************************
function PartyFrame_SelectAsTarget(UIIndex)

	--AxTrace( 0,0, "Ñ¡ÔñÍ·Ïñ");
	if Player:IsInRaid() == 1 then
		local sIdx, mIdx = Raid:GetMySquadMemIdxByUIIdx(UIIndex - 1)
		Raid:SelectAsTargetByIdx(sIdx, mIdx)
	else
		DataPool:SelectAsTargetByUIIndex(UIIndex);
	end
end;


--***********************************************************************************************************************************************
--
-- Êó±êÒÆÈëÊÂ¼þ
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseEnter(UIIndex)


		-- µÃµ½¶ÓÔ±µÄÏêÏ¸ÐÅÏ¢
		--MemberName
		--, strIconIndex
		--, HPValue
		--, HPMax
		--, MPValue
		--, MPMax
		--, Fammily
		--, Level
		--, Anger
		--, DeadLink
		--, Dead
		--, sex
		--= DataPool:GetTeamMemberInfo( UIIndex );
	--AxTrace( 0,0, "party frame enter"..tostring(UIIndex));
	--local ShowHpTipText = "";

	--if(-1 == HPValue) then

	--	ShowHpTipText = "Î´Öª";
	--else

	--	ShowHpTipText = tostring(HPValue).."/"..tostring(HPMax);
	--end;
	--HP_Text_Tip[UIIndex]:SetText(ShowHpTipText);

end;

--***********************************************************************************************************************************************
--
-- Êó±êÒÆ³öÊÂ¼þ
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseLeave(UIIndex)

	--AxTrace( 0,0, "party frame out"..tostring(UIIndex));
	--HP_Text_Tip[UIIndex]:SetText("");
end;

function PartyFrame_ClerAllBufInfo()
	local i;
	for i = 1, 5 do
		PartyFrame_ClerBufInfo( i );
	end
end

function PartyFrame_ClerBufInfo( idx )
	if(idx == nil) then return; end
	if(idx < 1 or idx > 5) then return; end

	local i = 0;
	while i < PARTY_BUFF_MAX do
		--AxTrace(0,0,"PartyFrame_ClerBufInfo:"..idx);
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][i+1]:Hide();
		i = i + 1;
	end
end

function PartyFrame_UpdateBufInfo( idx )
	if(idx < 1 or idx > 5) then return; end
	local nBuffNum = DataPool:GetTeamMemBufNum(idx);
	local nFindNum = nBuffNum --???nBuffNum???????
	if(nFindNum > PARTY_IMPACT_NUM) then nFindNum = PARTY_IMPACT_NUM; end
	if(nBuffNum > PARTY_BUFF_MAX) then nBuffNum = PARTY_BUFF_MAX; end

	--´Ó×î¶à20¸öÀïÃæÑ¡È¡6¸ö
	local BUFFINDEX_LIST = {} --??list???????
	do
		for jj=1,PARTY_BUFF_MAX do
			BUFFINDEX_LIST[jj] = -1;
		end
		
		local BuffPriority = {}
		for jj=1,nFindNum do --??20
			BuffPriority[jj] = {}
			BuffPriority[jj].key = jj-1;
			BuffPriority[jj].val = DataPool:GetTeamMemBufPriority(idx, jj-1);
		end
		
		for jj=nFindNum,1,-1 do --??20
			for kk=1,jj-1 do --??20
				if BuffPriority[kk].val < BuffPriority[kk+1].val then
					BuffPriority[kk],BuffPriority[kk+1] = BuffPriority[kk+1],BuffPriority[kk]
				end
			end
		end
		
		for jj=1,nBuffNum do --??6
			BUFFINDEX_LIST[jj] = BuffPriority[jj].key;
		end
	end
	
	local i = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;

		szIconName,szTipInfo = DataPool:GetTeamMemBufInfo(idx, BUFFINDEX_LIST[i+1]);
		--ÓÐÍ¼±êÔòÏÔÊ¾£¬Ã»ÓÐÍ¼±êÔò²»ÏÔÊ¾£¬ÊÊÓÃÓÚÃ»ÓÐÍ¼±êµÄbuff¡£
		--ÓÉÓÚÃ»ÓÐÍ¼±êµÄbuff¸ù¾ÝÓÅÏÈ¼¶¶¼ÅÅµ½×îºóÈ¥ÁË£¬ËùÒÔÊµ¼ÊÐ§¹ûÊÇ×îºó¼¸¸öÃ»Í¼±êµÄbuff²»ÏÔÊ¾³öÀ´ 62434~62437
		if szIconName and szTipInfo then
			PARTY_IMPACT_CTL[idx][i+1]:SetProperty("ShortImage", szIconName);
			PARTY_IMPACT_CTL[idx][i+1]:Show();
			PARTY_IMPACT_CTL[idx][i+1]:SetToolTip(szTipInfo);
		else
			PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
			PARTY_IMPACT_CTL[idx][i+1]:Hide();
		end
		
		i = i + 1;
	end

	while i < PARTY_BUFF_MAX do
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][i+1]:Hide();
		i = i + 1;
	end
end

--***********************************************************************************************************************************************
--
-- ÏÔÊ¾¶ÓÔ±µÄ äÊÞ°´Å¥
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_Show(UIIndex)

	-- ÏÔÊ¾ äÊÞ°´Å¥
	Team_Member_Pet_Button[UIIndex]:Show();

	return

end

--***********************************************************************************************************************************************
--
-- Êó±ê×ó¼üµ¥»÷£ºÑ¡ÖÐ¶ÓÓÑµÄµ±Ç°³ö ½ äÊÞ
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_SetFightPetAsTarget(UIIndex)

	-- Ê×ÏÈÍ¨¹ýUIË÷ÒýÀ´Ñ¡ÖÐ¶ÓÓÑµÄ äÊÞ×÷Îªµ±Ç°Ñ¡ÖÐÄ¿±ê
	local iFindFightingPet = DataPool:SelectTeamMemPetAsTargetByUIIndex(UIIndex);

	-- Èç¹û Ò²»µ½¶ÓÓÑµÄ³ö ½ äÊÞ
	if (iFindFightingPet == -1) then

		PushDebugMessage ("#{ZSAN_90311_2}");			-- ??????,???????,?????????

	end

	-- ¸üÐÂµ±Ç°µÄPartyFrame½çÃæ
	Update_PartyFrame_Menu ();

end

--***********************************************************************************************************************************************
--
-- Êó±êÓÒ¼üµ¥»÷£º´ò¿ª¶ÓÓÑµÄ³ö ½ äÊÞµÄÑ¡Ïî²Ëµ¥
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_ToggleTargetPetPage(UIIndex)

	-- Ê×ÏÈÍ¨¹ýUIË÷ÒýÀ´Ñ¡ÖÐ¶ÓÓÑµÄ äÊÞ×÷Îªµ±Ç°Ñ¡ÖÐÄ¿±ê
	local iFindFightingPet = DataPool:SelectTeamMemPetAsTargetByUIIndex(UIIndex);

	-- Èç¹û Ò²»µ½¶ÓÓÑµÄ³ö ½ äÊÞ
	if (iFindFightingPet == -1) then

		PushDebugMessage ("#{ZSAN_90311_2}");			-- ??????,???????,?????????

	-- Èç¹ûÄÜ Òµ½¶ÓÓÑµÄ³ö ½ äÊÞ
	else

		-- µ¯³ö¶ÓÓÑ äÊÞ°´Å¥µÄÓÒ¼ü²Ëµ¥
		Show_Team_Member_Pet_Menu ();

	end

	-- ¸üÐÂµ±Ç°µÄPartyFrame½çÃæ
	Update_PartyFrame_Menu ();

end


function Refresh_All_RaidMember_Info()

	-- ÏÈÒþ²ØµôËùÓÐµÄ¶ÓÔ±.
	Hide_All_Play_Func()
	local iMemCount = Raid:GetMySquadMemCount()
	if((iMemCount < 1)or(iMemCount > 6)) then
		return;
	end
	
	for index = 1, iMemCount - 1 do
		PARTYFRAMEs[index]:Show()
			
		local sIdx, mIdx = Raid:GetMySquadMemIdxByUIIdx(index - 1)
		local MemberName, strIconIndex, HPValue, HPMax, MPValue, MPMax, Fammily, Level, Anger, DeadLink, Dead, sex, ScenceName
		= Raid:GetMemberDetailByIdx(sIdx,mIdx);
		
		local pos = Raid:IsLeaderByIdx(sIdx, mIdx)
		if pos == 1 then
			Raid_Flags[index]:SetProperty("Image", "set:Union1 image:Union_LeaderIcon_S")
			Raid_Flags[index]:Show()
		elseif pos == 2 then
			Raid_Flags[index]:SetProperty("Image", "set:Union1 image:Union_MemberIcon_S")
			Raid_Flags[index]:Show()
		else
			Raid_Flags[index]:Hide()
		end
		
		if(-1 ~= HPValue) then
			PARTY_HP[index]:SetProgress(tonumber(HPValue), tonumber(HPMax))
		else
			PARTY_HP[index]:SetProgress(1, 1)
		end

		Portrait_ToolTips[index]:SetProperty("Image", "set:PlayerFrame_Icon image:Icon_xiaoyao");
		Portrait_ToolTips[index]:SetProperty("Image", strIconIndex);

		if(RatioFakeObjNeedUpdate == 1) then
			-- µÃµ½head uiÄ£ÐÍÐÅÏ¢
			local strModelName = Raid:SetModelHeadLookByIdx(sIdx, mIdx);
		end

		if(0 ~= Dead) then
			Porttrait_Mask[index]:Show();
		else
			Porttrait_Mask[index]:Hide();
		end

		if(0 == DeadLink) then
			UnLink_flag[index]:Hide();
		else
			UnLink_flag[index]:Show();
		end

		local strMenPai = "";
		if(0 == Fammily) then
			strMenPai = "Thiªu Lâm";
		elseif(1 == Fammily) then
			strMenPai = "Minh Giáo";
		elseif(2 == Fammily) then
			strMenPai = "Cái Bang";
		elseif(3 == Fammily) then
			strMenPai = "Võ Ðang";
		elseif(4 == Fammily) then
			strMenPai = "Nga Mi";
		elseif(5 == Fammily) then
			strMenPai = "Tinh Túc";
		elseif(6 == Fammily) then
			strMenPai = "Thiên Long";
		elseif(7 == Fammily) then
			strMenPai = "Thiên S½n";
		elseif(8 == Fammily) then
			strMenPai = "Tiêu dao";
		elseif(10 == Fammily) then
			strMenPai = "MÕn Ðà";
		else
			strMenPai = "Tñ do";
		end

		local strInfo = tostring(MemberName) .. "\n" .. tostring(strMenPai) .. "  " .. tostring(Level).. "C¤p" .. "\\nch², n½i Ð¸a:" .. ScenceName;
		Portrait_ToolTips[index]:SetToolTip(strInfo);

		if(-1 == HPValue) then
			-- ¿ç³¡¾°µÄÇé¿ö¡£
			PARTY_HP[index]:SetToolTip("Không biªt");
		else
			PARTY_HP[index]:SetToolTip(tostring(HPValue).."/"..tostring(HPMax));
		end;

		-- local cur;
		-- for cur = 1, 5 do
			PartyFrame_ClerBufInfo(index);
		-- end
		
		local nBuffNum = Raid:GetMemberBufNumByIdx(sIdx, mIdx)
		local nFindNum = nBuffNum --???nBuffNum???????
		if(nFindNum > PARTY_IMPACT_NUM) then 
			nFindNum = PARTY_IMPACT_NUM 
		end
		if(nBuffNum > PARTY_BUFF_MAX) then
			nBuffNum = PARTY_BUFF_MAX
		end

		--´Ó×î¶à20¸öÀïÃæÑ¡È¡6¸ö
		local BUFFINDEX_LIST = {} --??list???????
		do
			for jj=1,PARTY_BUFF_MAX do
				BUFFINDEX_LIST[jj] = -1;
			end
	
			local BuffPriority = {}
			for jj=1,nFindNum do --??20
				BuffPriority[jj] = {}
				BuffPriority[jj].key = jj-1;
				BuffPriority[jj].val = Raid:GetMemberBufPriorityByIdx(sIdx, mIdx, jj-1);
			end
	
			for jj=nFindNum,1,-1 do --??20
				for kk=1,jj-1 do --??20
					if BuffPriority[kk].val < BuffPriority[kk+1].val then
						BuffPriority[kk],BuffPriority[kk+1] = BuffPriority[kk+1],BuffPriority[kk]
					end
				end
			end
	
			for jj=1,nBuffNum do --??6
				BUFFINDEX_LIST[jj] = BuffPriority[jj].key;
			end
		end

		local i = 0;
		while i < nBuffNum do
			local szIconName;
			local szTipInfo;

			szIconName,szTipInfo = Raid:GetMemberBufInfoByIdx(sIdx, mIdx, BUFFINDEX_LIST[i+1]);
			--ÓÐÍ¼±êÔòÏÔÊ¾£¬Ã»ÓÐÍ¼±êÔò²»ÏÔÊ¾£¬ÊÊÓÃÓÚÃ»ÓÐÍ¼±êµÄbuff¡£
			--ÓÉÓÚÃ»ÓÐÍ¼±êµÄbuff¸ù¾ÝÓÅÏÈ¼¶¶¼ÅÅµ½×îºóÈ¥ÁË£¬ËùÒÔÊµ¼ÊÐ§¹ûÊÇ×îºó¼¸¸öÃ»Í¼±êµÄbuff²»ÏÔÊ¾³öÀ´ 62434~62437
			if szIconName and szTipInfo then
				PARTY_IMPACT_CTL[index][i+1]:SetProperty("ShortImage", szIconName);
				PARTY_IMPACT_CTL[index][i+1]:Show();
				PARTY_IMPACT_CTL[index][i+1]:SetToolTip(szTipInfo);
			else
				PARTY_IMPACT_CTL[index][i+1]:SetToolTip("");
				PARTY_IMPACT_CTL[index][i+1]:Hide();
			end
	
			i = i + 1;
		end

		while i < PARTY_BUFF_MAX do
			PARTY_IMPACT_CTL[index][i+1]:SetToolTip("");
			PARTY_IMPACT_CTL[index][i+1]:Hide();
			i = i + 1;
		end
		
		--PetButton_Show(index);
	end
	this:Show()
end
