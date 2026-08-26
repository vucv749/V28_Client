local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_SearchFriend_m = 0
local g_SearchFriend_n = 0

function Makefriends_Activity_Watch1_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--this:RegisterEvent("JIAOYOU_SHOW_FINAL",true)
	this:RegisterEvent("MAKEFRIENDS_WATCH_CLOSE",true)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SOCIALACTIVITYES_SEARCH")
end

function Makefriends_Activity_Watch1_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_Frame_UnifiedXPosition	= Makefriends_Activity_Watch1_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Makefriends_Activity_Watch1_Frame:GetProperty("UnifiedYPosition");
	
end

function Makefriends_Activity_Watch1_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Activity_Watch1_ResetPos()
	 elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Activity_Watch1_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide();
	elseif( event == "SOCIALACTIVITYES_SEARCH" ) then
		this:Show();
		g_SearchFriend_n = tonumber(arg0);
		g_SearchFriend_m = tonumber(arg1);
		Makefriends_Activity_Watch1_Updata(g_SearchFriend_n,g_SearchFriend_m)
	elseif (event == "MAKEFRIENDS_WATCH_CLOSE") then
		if arg0=="1" then
		else
			this:Hide()
		end
	end
end

function Makefriends_Activity_Watch1_Updata(n,m)
	
	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,""
	if 1 == n then
		if m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --????
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --????
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --????
		end
	elseif 2 == n then
		if m >= 1 and m <= 3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopLikedByMeByIndex(m-1)
		else
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetToplikedByotherByIndex(m-1-3)
		end
	elseif 3 == n then
		nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetArrayEcahRoundCampByIndex(m-1)
	end
	
	
	if nGuid ~= -1 then
		g_SearchFriend_n = n
		g_SearchFriend_m = m

		local szlevel = ScriptGlobal_Format("#{JYHD_230331_66}", nLevel)
		Makefriends_Activity_Watch1_Text:SetText(szlevel)
		local szMenpai = AccusationStudio_GetMenPai(nMenpai)
		Makefriends_Activity_Watch1_Text2:SetText(szMenpai)
		local szAge = ScriptGlobal_Format("#{JYHD_230331_68}", nAge)
		Makefriends_Activity_Watch1_Info2:SetText(szAge)
		local szBloodType = Makefriends_Activity_Watch1_GetBloodType(nBloodType)
		
		local szFormatBloodType = ScriptGlobal_Format("#{JYHD_230331_69}", szBloodType)		
		Makefriends_Activity_Watch1_Info3:SetText(szFormatBloodType)
		local constellation = Makefriends_Activity_Watch1_XingZuo(nConsella)
		local szconstellation = ScriptGlobal_Format("#{JYHD_230331_70}", constellation)
		Makefriends_Activity_Watch1_Info4:SetText(szconstellation)
		local szyearanimal = Makefriends_Activity_Watch1_GetnYearAnimal(nYearAnimal)
		szyearanimal = ScriptGlobal_Format("#{JYHD_230331_71}", szyearanimal)
		Makefriends_Activity_Watch1_Info5:SetText(szyearanimal)
		local szProvince = Makefriends_Activity_Watch1_Province(nProvince)
		szProvince = ScriptGlobal_Format("#{JYHD_230331_72}", szProvince)
		Makefriends_Activity_Watch1_Info6:SetText(szProvince)
		local szLuckWord = ScriptGlobal_Format("#{JYHD_230331_73}", szLuckWord)
		Makefriends_Activity_Watch1_Info:SetText(szLuckWord)
		Makefriends_Activity_Watch1_B1:SetText("Tång thêm các\\u0020hÕ t¯t")
		Makefriends_Activity_Watch1_B2:SetText("Bi¬u ğÕt tâm ı")

		Makefriends_Activity_Watch1_FakeObject : SetFakeObject("");
		Makefriends_Activity_Watch1_FakeObject : SetFakeObject("MakefriendActivity_Watch");
		SocialActivitesDataPool:SocialActivities_ChangeModel_AsTarget(n,m-1)

		Makefriends_Activity_Watch1_FakeObject : SetFakeObject("");
		Makefriends_Activity_Watch1_FakeObject : SetFakeObject("MakefriendActivity_Watch");
		SocialActivitesDataPool:SocialActivities_ChangeModel_AsTarget(n,m-1)
	 
		local playername = ScriptGlobal_Format("#{JYHD_230331_65}", szCharName)
		Makefriends_Activity_Watch1_Title:SetText(playername)
		
		if nTypeinfo ~= 0 then
			local szAge = ScriptGlobal_Format("#{JYHD_230331_68}", 0)
			Makefriends_Activity_Watch1_Info2:SetText(szAge)
			local szFormatBloodType = ScriptGlobal_Format("#{JYHD_230331_69}", "-")		
			Makefriends_Activity_Watch1_Info3:SetText(szFormatBloodType)
			local szconstellation = ScriptGlobal_Format("#{JYHD_230331_70}", "-")
			Makefriends_Activity_Watch1_Info4:SetText(szconstellation)
			szyearanimal = ScriptGlobal_Format("#{JYHD_230331_71}", "-")
			Makefriends_Activity_Watch1_Info5:SetText(szyearanimal)
			szProvince = ScriptGlobal_Format("#{JYHD_230331_72}", "-")
			Makefriends_Activity_Watch1_Info6:SetText(szProvince)
			Makefriends_Activity_Watch1_B1:SetText("Tång thêm các\\u0020hÕ t¯t")
			Makefriends_Activity_Watch1_B2:SetText("Bi¬u ğÕt tâm ı")
		end


	else
		Makefriends_Activity_Watch1_Text:SetText("-")
		Makefriends_Activity_Watch1_Text2:SetText("-")
		Makefriends_Activity_Watch1_Info2:SetText("-")
		Makefriends_Activity_Watch1_Info3:SetText("-")
		Makefriends_Activity_Watch1_Info4:SetText("-")
		Makefriends_Activity_Watch1_Info5:SetText("-")
		Makefriends_Activity_Watch1_Info6:SetText("-")
		Makefriends_Activity_Watch1_Info:SetText("-")
		Makefriends_Activity_Watch1_B1:SetText("Tång thêm các\\u0020hÕ t¯t")
		Makefriends_Activity_Watch1_B2:SetText("Bi¬u ğÕt tâm ı")
		Makefriends_Activity_Watch1_FakeObject : SetFakeObject("");
		
	end
	

end


function Makefriends_Activity_Watch1_ResetPos()
	Makefriends_Activity_Watch1_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Makefriends_Activity_Watch1_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end

function Makefriends_Activity_Watch1_OnHiden()
	this:Hide()
end


function Makefriends_Activity_Watch1_B2_SelectClicked()	
	m = g_SearchFriend_m
	n = g_SearchFriend_n
	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,""

	if 1 == n then
		if m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --????
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --????
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --????
		end
	elseif 2 == n then
		if m >= 1 and m <= 3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopLikedByMeByIndex(m-1)
		else
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetToplikedByotherByIndex(m-1-3)
		end
	elseif 3 == n then
		nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetArrayEcahRoundCampByIndex(m-1)
	end

	if nGuid ~= -1 then
		if (nGuid == Player:GetGUID()) then  
			PushDebugMessage("#HkHông th¬ C¤p chính mình bi¬u ğÕt tâm ı.");--????
			return;
		end
		
		local name = ScriptGlobal_Format("#{JYHD_230331_74}", szCharName)
		PushEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM",tostring(name),tonumber(n),tonumber(m))
		--ÒÑ³É¹¦Ìí¼ÓºÃÓÑ ÔòÒş²Ø
	end

end

function Makefriends_Activity_Watch1_GetBloodType( nBloodType )
	local strBT = "";
	
	if(1 == nBloodType) then
		strBT = "A";

	elseif(2 == nBloodType) then
		strBT = "B";

	elseif(3 == nBloodType) then
		strBT = "AB";

	elseif(4 == nBloodType) then
		strBT = "O";
	else
			strBT = "-";
	end
		
	return strBT
end

function Makefriends_Activity_Watch1_GetnYearAnimal( nYearAnimal )
	local strYA = "";
	
	if(0 == nYearAnimal) then
		strYA = "-";
	elseif(1 == nYearAnimal) then
		strYA = "ThØ";
	elseif(2 == nYearAnimal) then
		strYA = "Ngßu";
	elseif(3 == nYearAnimal) then
		strYA = "H±";
	elseif(4 == nYearAnimal) then
		strYA = "Th¯";
	elseif(5 == nYearAnimal) then
		strYA = "Thìn";
	elseif(6 == nYearAnimal) then
		strYA = "Xà";
	elseif(7 == nYearAnimal) then
		strYA = "Mã";
	elseif(8 == nYearAnimal) then
		strYA = "Dß½ng";
	elseif(9 == nYearAnimal) then
		strYA = "H¥u";
	elseif(10 == nYearAnimal) then
		strYA = "Kê";
	elseif(11 == nYearAnimal) then
		strYA = "C¦u";
	elseif(12 == nYearAnimal) then
		strYA = "Trß";
	end
		
	return strYA
end


function Makefriends_Activity_Watch1_XingZuo( nxz )
	local strYA = "";
	
	if(0 == nxz) then
		strYA = "-";
	elseif(1 == nxz) then
		strYA = "Ma HÕt ToÕ";
	elseif(2 == nxz) then
		strYA = "Chòm Thüy Bình";
	elseif(3 == nxz) then
		strYA = "Chòm Song Ngß";
	elseif(4 == nxz) then
		strYA = "Chòm BÕch Dß½ng";
	elseif(5 == nxz) then
		strYA = "Chòm Kim Ngßu";
	elseif(6 == nxz) then
		strYA = "Chòm song nam";
	elseif(7 == nxz) then
		strYA = "Chòm cñ giäi";
	elseif(8 == nxz) then
		strYA = "Chòm Sß TØ";
	elseif(9 == nxz) then
		strYA = "XØ næ ToÕ";
	elseif(10 == nxz) then
		strYA = "Chòm Thiên Bình";
	elseif(11 == nxz) then
		strYA = "Chòm sao bò cÕp";
	elseif(12 == nxz) then
		strYA = "XÕ thü ToÕ";
	end
		
	return strYA
end

function Makefriends_Activity_Watch1_Province( nxz )
	local strYA = "";
	
	if(0 == nxz) then
		strYA = "-";
	elseif(1 == nxz) then
		strYA = "B¡c Kinh";
	elseif(2 == nxz) then
		strYA = "Thiên Tân";
	elseif(3 == nxz) then
		strYA = "Thßşng Häi";
	elseif(4 == nxz) then
		strYA = "Trùng Khánh";
	elseif(5 == nxz) then
		strYA = "Hà B¡c";
	elseif(6 == nxz) then
		strYA = "Liêu Ninh";
	elseif(7 == nxz) then
		strYA = "S½n Ğông";
	elseif(8 == nxz) then
		strYA = "H¡c Long Giang";
	elseif(9 == nxz) then
		strYA = "S½n Tây";
	elseif(10 == nxz) then
		strYA = "Cát Lâm";
	elseif(11 == nxz) then
		strYA = "Thi¬m Tây";
	elseif(12 == nxz) then
		strYA = "Hà Nam";
	elseif(13 == nxz) then
		strYA = "An Huy";
	elseif(14 == nxz) then
		strYA = "Giang Tô";
	elseif(15 == nxz) then
		strYA = "H° B¡c";
	elseif(16 == nxz) then
		strYA = "Chiªt Giang";
	elseif(17 == nxz) then
		strYA = "H° Nam";
	elseif(18 == nxz) then
		strYA = "Giang Tây";
	elseif(19 == nxz) then
		strYA = "Phúc Kiªn";
	elseif(20 == nxz) then
		strYA = "Ğài Loan";
	elseif(21 == nxz) then
		strYA = "Nµi Mông C±";
	elseif(22 == nxz) then
		strYA = "Cam Túc";
	elseif(23 == nxz) then
		strYA = "Ninh HÕ";
	elseif(24 == nxz) then
		strYA = "TÑ Xuyên";
	elseif(25 == nxz) then
		strYA = "Quı Châu";
	elseif(26 == nxz) then
		strYA = "Vân Nam";
	elseif(27 == nxz) then
		strYA = "Quäng Tây";
	elseif(28 == nxz) then
		strYA = "Quäng Ğông";
	elseif(29 == nxz) then
		strYA = "Häi Nam";
	elseif(30 == nxz) then
		strYA = "Tân Cß½ng";
	elseif(31 == nxz) then
		strYA = "Thanh Häi";
	elseif(32 == nxz) then
		strYA = "Tây TÕng";
	elseif(33 == nxz) then
		strYA = "Macao";
	elseif(34 == nxz) then
		strYA = "H°ng Kông";
	elseif(35 == nxz) then
		strYA = "M£t khác";
	end
		
	return strYA
end


--Ìí¼ÓºÃÓÑ°´Å¥	
function Makefriends_Activity_Watch1_AddFriend()

	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,""
	if 1 == g_SearchFriend_n then
		if g_SearchFriend_m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --????
		elseif g_SearchFriend_m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --????
		elseif g_SearchFriend_m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --????

		end
	elseif 2 == g_SearchFriend_n then
		if g_SearchFriend_m >= 1 and g_SearchFriend_m <= 3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopLikedByMeByIndex(g_SearchFriend_m-1)
		else
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetToplikedByotherByIndex(g_SearchFriend_m-1-3)
		end
	elseif 3 == g_SearchFriend_n then
		nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetArrayEcahRoundCampByIndex(g_SearchFriend_m-1)
	end

	if nGuid ~= -1 then

		if (nGuid == Player:GetGUID()) then  
			PushDebugMessage("#{GGSK_221221_49}");--????
			return;
		end
		--ÒÑÊÇºÃÓÑ ÔòÒş²Ø
		if (Friend:IsPlayerIsFriendNotTemp(szCharName) == 1) then
			PushDebugMessage("#{JYHD_230331_138}");--????
			return
		end
		
		DataPool:AddFriendAndGrouping(szCharName);
		--ÒÑ³É¹¦Ìí¼ÓºÃÓÑ ÔòÒş²Ø
	end

end



--±í´ïĞÄÒâ°´Å¥	
function Makefriends_Activity_Watch1_Expressing_Emotions(n,m)
	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,0,""
	if 1 == n then
		if m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --????
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --????
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --????
		end
	elseif 2 == n then
		if m >= 1 and m <= 3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopLikedByMeByIndex(m-1)
		else
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetToplikedByotherByIndex(m-1-3)
		end
	elseif 3 == n then
		nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetArrayEcahRoundCampByIndex(m-1)
	end
	
	Makefriends_Activity_Watch1_InfoText:SetText("#{JYHD_230331_62}")

	if nGuid ~= -1 then
		if (nGuid == Player:GetGUID()) then  
			PushDebugMessage("#HkHông th¬ C¤p chính mình bi¬u ğÕt tâm ı.");--????
			return;
		end
		
		local name = ScriptGlobal_Format("#{JYHD_230331_74}", szCharName)
		PushEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM",tostring(name),tonumber(n),tonumber(m))
		--ÒÑ³É¹¦Ìí¼ÓºÃÓÑ ÔòÒş²Ø
	end

end
--×ó×ª
function Makefriends_Activity_Watch1_TurnLeft(idx)

	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Makefriends_Activity_Watch1_FakeObject:RotateBegin(-0.3)
	else
		Makefriends_Activity_Watch1_FakeObject:RotateEnd()
	end
	
end
--ÓÒ×ª
function Makefriends_Activity_Watch1_TurnRight(idx)

	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Makefriends_Activity_Watch1_FakeObject:RotateBegin(0.3)
	else
		Makefriends_Activity_Watch1_FakeObject:RotateEnd()
	end
	
end
