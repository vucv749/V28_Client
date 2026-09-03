-- ConfraternityInfo_Amount   °ï»áid
-- ConfraternityInfo_CreateTime ´´½¨Ê±¼ä
-- ConfraternityInfo_Create	´´½¨ÈË
-- ConfraternityInfo_Master	ÏÖÈÎ°ïÖ÷
-- ConfraternityInfo_City	³ÇÊÐ
-- ConfraternityInfo_Locus	ËùÔÚµØ
--	ConfraternityInfo_CBD		ÉÌÇø
-- ConfraternityInfo_Specialty	µ±Ç°ÑÐ¾¿
-- ConfraternityInfo_CityBuilding µ±Ç°½¨Éè
-- ConfraternityInfo_Level	¹æÄ£
-- ConfraternityInfo_Info1	ÈËÊý
-- ConfraternityInfo_Info4	¹¤Òµ¶È
-- ConfraternityInfo_Info5	Å©Òµ¶È
-- ConfraternityInfo_Info6	ÉÌÒµ¶È
-- ConfraternityInfo_Info7	¹ú·À¶È
-- ConfraternityInfo_Info8	¿Æ¼¼¶È
-- ConfraternityInfo_Info9	À© Å¶È
-- ConfraternityInfo_Info3	¹ú¼Ò×Ê½ð
-- ConfraternityInfo_Shangpiao ±¾È ×î´óÉÌÆ±Êý
local g_ConfraternityInfo_Frame_UnifiedPosition;

function ConfraternityInfo_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_SHOW_DETAILINFO");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	this:RegisterEvent("GUILD_SELFEQUIP_CLICK");
		-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS")
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
end

function ConfraternityInfo_OnLoad()
		g_ConfraternityInfo_Frame_UnifiedPosition=ConfraternityInfo_Frame:GetProperty("UnifiedPosition");
end

function ConfraternityInfo_OnEvent(event)
	if(event == "UI_COMMAND") then
		if(tonumber(arg0) == 30 and this:IsVisible()) then
			Guild_Info_Close();
		elseif(tonumber(arg0) == 31) then
			Guild:AskGuildDetailInfo();
		end
	elseif(event == "GUILD_SHOW_DETAILINFO") then
		Guild_Info_Clear();
		Guild_Info_Update();
		Guild_Info_Close();
		Guild_Info_Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		Guild_Info_Close();
	elseif(event == "GUILD_SELFEQUIP_CLICK") then
		if(this:IsVisible()) then
			Guild_Info_Close();
		end
	end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	if (event == "ADJEST_UI_POS" ) then
		ConfraternityInfo_Frame_On_ResetPos()
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ConfraternityInfo_Frame_On_ResetPos()
	end
	 
end

function Guild_Info_Clear()
	ConfraternityInfo_DragTitle:SetText("");
	--ConfraternityInfo_TitleInfo:SetText("");
	
	-- ConfraternityInfo_Specialty_Text:Hide();
	--ConfraternityInfo_Specialty:Hide();
end

function Guild_Info_Update()
	--local szMsg = Guild:GetMyGuildInfo("Name");
	--ConfraternityInfo_DragTitle:SetText(szMsg.."°ï»áÏêÏ¸ÐÅÏ¢");
	--2006-9-7 16:04°´²ß»®ÒªÇóÐÞ¸ÄÎª¹Ì¶¨Ò³Ã¼
	ConfraternityInfo_DragTitle:SetText("#gFF0FA0Thông tin bang");
	
	--2006-12-7 19:43 TODO:
  --szMsg = "¹±Ï×¶È:"..Guild:GetMyGuildDetailInfo("Con");
  --ConfraternityInfo_TitleInfo:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Name");
	ConfraternityInfo_ConfraternityName:SetText(szMsg);
	
	local leagueName = Guild:GetMyGuildDetailInfo("LeagueName");
	ConfraternityInfo_GuildLeagueName:SetText(leagueName);
	
	--MainInfo
	szMsg = Guild:GetMyGuildDetailInfo("ID");
	ConfraternityInfo_Amount:SetText(szMsg);
		
	szMsg = Guild:GetMyGuildDetailInfo("FoundedTime");
	ConfraternityInfo_CreateTime:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Level");
	ConfraternityInfo_Level:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Creator");
	ConfraternityInfo_Create:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("ChiefName");
	ConfraternityInfo_Master:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CityName");
	if(szMsg == "-1") then
		szMsg = "Không có thành";
	end
	ConfraternityInfo_City:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CurBuilding");
	ConfraternityInfo_CityBuilding:SetText(szMsg);

	
	szMsg = Guild:GetMyGuildDetailInfo("Scene");
	if(szMsg == "-1") then
		szMsg = "Không rõ";
	end
	ConfraternityInfo_Locus:SetText(szMsg);
	szMsg = Guild:GetMyGuildDetailInfo("Comm");
	ConfraternityInfo_CBD:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("CurResearch");
	if(szMsg == "")then
		szMsg = "Tr¯ng";
	end;
	ConfraternityInfo_Specialty:SetText(szMsg);
	
	--TargetInfo
	szMsg = Guild:GetMyGuildDetailInfo("MemNum");
	ConfraternityInfo_Info1:SetText(szMsg);
	
	--szMsg = Guild:GetMyGuildDetailInfo("Honor");
	--ConfraternityInfo_Info2:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("FMoney");
	ConfraternityInfo_Info3:SetProperty("MoneyNumber", tostring(szMsg));
	
	szMsg = Guild:GetMyGuildDetailInfo("Ind");
	ConfraternityInfo_Info4:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Agr");
	ConfraternityInfo_Info5:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Com");
	ConfraternityInfo_Info6:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Def");
	ConfraternityInfo_Info7:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Tech");
	ConfraternityInfo_Info8:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Ambi");
	ConfraternityInfo_Info9:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Boom");
	ConfraternityInfo_Info10:SetText( GetColorBoomValueStr(szMsg) );
		
	local bldprog = Guild:GetMyGuildDetailInfo("BldProg");
	local bldmaxprog = Guild:GetMyGuildDetailInfo("BldMaxProg");
	local resprog = Guild:GetMyGuildDetailInfo("ResProg");
	local resmaxprog = Guild:GetMyGuildDetailInfo("ResMaxProg");
	szMsg = "("..bldprog.."/"..bldmaxprog..")";
	ConfraternityInfo_CityBuilding_JinDu : SetText(szMsg);
	szMsg = "("..resprog.."/"..resmaxprog..")";
	ConfraternityInfo_Specialty_JinDu:SetText(szMsg);
	
	
		  
  local guildlevel = Guild:GetMyGuildDetailInfo("guildlevel");
  if guildlevel == 0  then
		 szMsg = 0
	else 
	szMsg = 200 + (guildlevel - 1) * 25
  end   
	
	--local DayTimes, totalTakenTimes , leftTakenTimes
	--DayTimes = Guild:GetMyGuildDetailInfo("TicketTaken");
	--if DayTimes == -1 then
		--totalTakenTimes = 0
	--else
		--totalTakenTimes = math.floor( DayTimes/100000 )
	--end
	
	local totalTakenTimes , leftTakenTimes
	totalTakenTimes = Guild:GetMyGuildDetailInfo("TicketTaken")
	if totalTakenTimes == -1 then
		totalTakenTimes = 0
	end

	leftTakenTimes = szMsg - totalTakenTimes
	if leftTakenTimes < 0 then
		leftTakenTimes = 0
	end

	ConfraternityInfo_Shangpiao:SetText(leftTakenTimes..'/'..szMsg)
end

function Guild_Info_CheckMembers()
	Guild:AskGuildMembersInfo();
end

function Guild_Info_Quit()
	Guild:QuitGuild();
end

function Guild_Info_Show()
	this:Show();
end

function Guild_Info_Close()
	this:Hide();
end

--================================================
-- »Ö¸´½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
--================================================
function ConfraternityInfo_Frame_On_ResetPos()
  ConfraternityInfo_Frame:SetProperty("UnifiedPosition", g_ConfraternityInfo_Frame_UnifiedPosition);
end
