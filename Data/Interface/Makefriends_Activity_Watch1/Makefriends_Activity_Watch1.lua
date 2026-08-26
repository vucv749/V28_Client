local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_SearchFriend_m = 0
local g_SearchFriend_n = 0

function Makefriends_Activity_Watch1_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--this:RegisterEvent("JIAOYOU_SHOW_FINAL",true)
	this:RegisterEvent("MAKEFRIENDS_WATCH_CLOSE",true)
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("SOCIALACTIVITYES_SEARCH")
end

function Makefriends_Activity_Watch1_OnLoad()
	-- 保存界面的默认相对位置
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
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --参数没用
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --参数没用
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --参数没用
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
		Makefriends_Activity_Watch1_B1:SetText("添加好友")
		Makefriends_Activity_Watch1_B2:SetText("表达心意")

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
			Makefriends_Activity_Watch1_B1:SetText("添加好友")
			Makefriends_Activity_Watch1_B2:SetText("表达心意")
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
		Makefriends_Activity_Watch1_B1:SetText("添加好友")
		Makefriends_Activity_Watch1_B2:SetText("表达心意")
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
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --参数没用
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --参数没用
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --参数没用
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
			PushDebugMessage("#H无法给自己表达心意。");--修改字典
			return;
		end
		
		local name = ScriptGlobal_Format("#{JYHD_230331_74}", szCharName)
		PushEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM",tostring(name),tonumber(n),tonumber(m))
		--已成功添加好友 则隐藏
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
		strYA = "鼠";
	elseif(2 == nYearAnimal) then
		strYA = "牛";
	elseif(3 == nYearAnimal) then
		strYA = "虎";
	elseif(4 == nYearAnimal) then
		strYA = "兔";
	elseif(5 == nYearAnimal) then
		strYA = "龙";
	elseif(6 == nYearAnimal) then
		strYA = "蛇";
	elseif(7 == nYearAnimal) then
		strYA = "马";
	elseif(8 == nYearAnimal) then
		strYA = "羊";
	elseif(9 == nYearAnimal) then
		strYA = "猴";
	elseif(10 == nYearAnimal) then
		strYA = "鸡";
	elseif(11 == nYearAnimal) then
		strYA = "狗";
	elseif(12 == nYearAnimal) then
		strYA = "猪";
	end
		
	return strYA
end


function Makefriends_Activity_Watch1_XingZuo( nxz )
	local strYA = "";
	
	if(0 == nxz) then
		strYA = "-";
	elseif(1 == nxz) then
		strYA = "魔羯座";
	elseif(2 == nxz) then
		strYA = "水瓶座";
	elseif(3 == nxz) then
		strYA = "双鱼座";
	elseif(4 == nxz) then
		strYA = "白羊座";
	elseif(5 == nxz) then
		strYA = "金牛座";
	elseif(6 == nxz) then
		strYA = "双子座";
	elseif(7 == nxz) then
		strYA = "巨蟹座";
	elseif(8 == nxz) then
		strYA = "狮子座";
	elseif(9 == nxz) then
		strYA = "处女座";
	elseif(10 == nxz) then
		strYA = "天秤座";
	elseif(11 == nxz) then
		strYA = "天蝎座";
	elseif(12 == nxz) then
		strYA = "射手座";
	end
		
	return strYA
end

function Makefriends_Activity_Watch1_Province( nxz )
	local strYA = "";
	
	if(0 == nxz) then
		strYA = "-";
	elseif(1 == nxz) then
		strYA = "北京";
	elseif(2 == nxz) then
		strYA = "天津";
	elseif(3 == nxz) then
		strYA = "上海";
	elseif(4 == nxz) then
		strYA = "重庆";
	elseif(5 == nxz) then
		strYA = "河北";
	elseif(6 == nxz) then
		strYA = "辽宁";
	elseif(7 == nxz) then
		strYA = "山东";
	elseif(8 == nxz) then
		strYA = "黑龙江";
	elseif(9 == nxz) then
		strYA = "山西";
	elseif(10 == nxz) then
		strYA = "吉林";
	elseif(11 == nxz) then
		strYA = "陕西";
	elseif(12 == nxz) then
		strYA = "河南";
	elseif(13 == nxz) then
		strYA = "安徽";
	elseif(14 == nxz) then
		strYA = "江苏";
	elseif(15 == nxz) then
		strYA = "湖北";
	elseif(16 == nxz) then
		strYA = "浙江";
	elseif(17 == nxz) then
		strYA = "湖南";
	elseif(18 == nxz) then
		strYA = "江西";
	elseif(19 == nxz) then
		strYA = "福建";
	elseif(20 == nxz) then
		strYA = "台湾";
	elseif(21 == nxz) then
		strYA = "内蒙古";
	elseif(22 == nxz) then
		strYA = "甘肃";
	elseif(23 == nxz) then
		strYA = "宁夏";
	elseif(24 == nxz) then
		strYA = "四川";
	elseif(25 == nxz) then
		strYA = "贵州";
	elseif(26 == nxz) then
		strYA = "云南";
	elseif(27 == nxz) then
		strYA = "广西";
	elseif(28 == nxz) then
		strYA = "广东";
	elseif(29 == nxz) then
		strYA = "海南";
	elseif(30 == nxz) then
		strYA = "新疆";
	elseif(31 == nxz) then
		strYA = "青海";
	elseif(32 == nxz) then
		strYA = "西藏";
	elseif(33 == nxz) then
		strYA = "澳门";
	elseif(34 == nxz) then
		strYA = "香港";
	elseif(35 == nxz) then
		strYA = "其他";
	end
		
	return strYA
end


--添加好友按钮	
function Makefriends_Activity_Watch1_AddFriend()

	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,""
	if 1 == g_SearchFriend_n then
		if g_SearchFriend_m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --参数没用
		elseif g_SearchFriend_m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --参数没用
		elseif g_SearchFriend_m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --参数没用

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
			PushDebugMessage("#{GGSK_221221_49}");--修改字典
			return;
		end
		--已是好友 则隐藏
		if (Friend:IsPlayerIsFriendNotTemp(szCharName) == 1) then
			PushDebugMessage("#{JYHD_230331_138}");--修改字典
			return
		end
		
		DataPool:AddFriendAndGrouping(szCharName);
		--已成功添加好友 则隐藏
	end

end



--表达心意按钮	
function Makefriends_Activity_Watch1_Expressing_Emotions(n,m)
	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,0,""
	if 1 == n then
		if m == 1 then
			 nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMe(0) --参数没用
		elseif m ==  2 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToOther(1) --参数没用
		elseif m ==  3 then
			nGuid, nSex, szCharName, _,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(2) --参数没用
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
			PushDebugMessage("#H无法给自己表达心意。");--修改字典
			return;
		end
		
		local name = ScriptGlobal_Format("#{JYHD_230331_74}", szCharName)
		PushEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM",tostring(name),tonumber(n),tonumber(m))
		--已成功添加好友 则隐藏
	end

end
--左转
function Makefriends_Activity_Watch1_TurnLeft(idx)

	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Makefriends_Activity_Watch1_FakeObject:RotateBegin(-0.3)
	else
		Makefriends_Activity_Watch1_FakeObject:RotateEnd()
	end
	
end
--右转
function Makefriends_Activity_Watch1_TurnRight(idx)

	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		Makefriends_Activity_Watch1_FakeObject:RotateBegin(0.3)
	else
		Makefriends_Activity_Watch1_FakeObject:RotateEnd()
	end
	
end
