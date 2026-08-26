local g_Frame_UnifiedXPosition;
local g_Frame_UnifiedYPosition;
local g_Makefriends_Activity_Watch2_map = {}
local g_Makefriends_Activity_watch_list = {}
local g_Makefriends_Activity_Image =
{
	[1] = "set: Button8 image:IM_F_Online",	--使用中
	[2] = "set: Button8 image:IM_M_Online"	--未拥有

}

function Makefriends_Activity_Watch2_PreLoad()

	--this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",true)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("JIAOYOU_SHOW_FINAL",true)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("MAKEFRIENDS_WATCH_CLOSE",true)
	this:RegisterEvent("UI_COMMAND")
end

function Makefriends_Activity_Watch2_OnLoad()
	-- 保存界面的默认相对位置
	g_Frame_UnifiedXPosition	= Makefriends_Activity_Watch2_Frame:GetProperty("UnifiedXPosition");
	g_Frame_UnifiedYPosition	= Makefriends_Activity_Watch2_Frame:GetProperty("UnifiedYPosition");
end

function Makefriends_Activity_Watch2_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		Makefriends_Activity_Watch2_ResetPos()
	 elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Makefriends_Activity_Watch2_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
		g_Makefriends_Activity_Watch2_map = {}
		g_Makefriends_Activity_watch_list = {}
		this:Hide();
	elseif( event == "JIAOYOU_SHOW_FINAL" ) then
		Makefriends_Activity_Watch2_Updata()
		this:Show();
	elseif (event == "MAKEFRIENDS_WATCH_CLOSE") then
		if arg0=="1" then
			this:Show()
		else
			this:Hide()
		end
	end
end

function Makefriends_Activity_Watch2_Updata()
	
	for i=1,3 do 
		local nGuid, nSex, szCharName, nTimes = -1,0,"",0
		if i == 1 then
			 nGuid, nSex, szCharName, nTimes = SocialActivitesDataPool:GetTopMostskillsToMe(i-1)
			 
		elseif i ==  2 then
			 nGuid, nSex, szCharName, nTimes = SocialActivitesDataPool:GetTopMostskillsToOther(i-1)
			 
		elseif i ==  3 then
			 nGuid, nSex, szCharName, nTimes = SocialActivitesDataPool:GetTopMostskillsToMeOppositesex(i-1)
			 
		end

		if nGuid ~= -1 then
			local nValue = Makefriends_Activity_Watch2_get(nGuid,"match_count")
			if nValue then
				nValue = nValue + nTimes
			else
				nValue = nTimes
			end
			local support_other = Makefriends_Activity_Watch2_get(nGuid,"support_other")
			local support_me = Makefriends_Activity_Watch2_get(nGuid,"support_me")
			if i == 2 then
				if support_other then
					support_other = support_other + nTimes
				else
					support_other = nTimes
				end	
			elseif i== 1 or i == 3 then
				if support_me then
					support_me = support_me + nTimes
				else
					support_me = nTimes
				end
			end

			if g_Makefriends_Activity_Watch2_map[nGuid] then
				Makefriends_Activity_Watch2_insert(nGuid,  nValue,"match_count")
				Makefriends_Activity_Watch2_insert(nGuid, szCharName,"szCharName")
				Makefriends_Activity_Watch2_insert(nGuid, nSex,"nSex")
				Makefriends_Activity_Watch2_insert(nGuid, true,"is_best_partner")
				if i == 2 then
					Makefriends_Activity_Watch2_insert(nGuid,  nValue,"support_other")
				elseif i== 1 or i == 3 then
					Makefriends_Activity_Watch2_insert(nGuid,  nValue,"support_me")
				end
			else
				if i == 2 then
					Makefriends_Activity_Watch2_insert(nGuid, {like_count = 0, support_me = 0,support_other = support_other, like_me = 0, like_other = 0, match_count = nValue, is_best_partner = true, is_like_each_other = false, is_fate = false,nSex=nSex,szCharName=szCharName})
				elseif i== 1 or i == 3 then
					Makefriends_Activity_Watch2_insert(nGuid, {like_count = 0, support_me = support_me,support_other = 0, like_me = 0, like_other = 0, match_count = nValue, is_best_partner = true, is_like_each_other = false, is_fate = false,nSex=nSex,szCharName=szCharName})
				end
			end
		end
	end

	for i=1,3 do 
		local nGuid, nSex, szCharName, nTimes = SocialActivitesDataPool:GetTopLikedByMeByIndex(i-1)
		if nGuid ~= -1 then
			local nValue = Makefriends_Activity_Watch2_get(nGuid,"like_count")
			if nValue then
				nValue = nValue + nTimes
			else
				nValue = nTimes
			end
			local like_me = Makefriends_Activity_Watch2_get(nGuid,"like_me")
			if like_me then
				like_me = like_me + nTimes
			else
				like_me = nTimes
			end
			if g_Makefriends_Activity_Watch2_map[nGuid] then
				Makefriends_Activity_Watch2_insert(nGuid, nValue,"like_count")
				Makefriends_Activity_Watch2_insert(nGuid, szCharName,"szCharName")
				Makefriends_Activity_Watch2_insert(nGuid, nSex,"nSex")
				Makefriends_Activity_Watch2_insert(nGuid, true,"is_like_each_other")
				Makefriends_Activity_Watch2_insert(nGuid, like_me,"like_me")
			else
				Makefriends_Activity_Watch2_insert(nGuid, {like_count = nValue, support_me = 0,support_other = 0, like_me = like_me, like_other = 0,match_count = 0, is_best_partner = false, is_like_each_other = true, is_fate = false,nSex=nSex,szCharName=szCharName})
			end
		end
	end

	for i=1,3 do 
		local nGuid, nSex, szCharName, nTimes = SocialActivitesDataPool:GetToplikedByotherByIndex(i-1)	
		if nGuid ~= -1 then
			local nValue = Makefriends_Activity_Watch2_get(nGuid,"like_count")
			if nValue then
				nValue = nValue + nTimes
			else
				nValue = nTimes
			end
			local like_other = Makefriends_Activity_Watch2_get(nGuid,"like_other")
			if like_other then
				like_other = like_other + nTimes
			else
				like_other = nTimes
			end
			if g_Makefriends_Activity_Watch2_map[nGuid] then
				Makefriends_Activity_Watch2_insert(nGuid, nValue,"like_count")
				Makefriends_Activity_Watch2_insert(nGuid, szCharName,"szCharName")
				Makefriends_Activity_Watch2_insert(nGuid, nSex,"nSex")
				Makefriends_Activity_Watch2_insert(nGuid, true,"is_like_each_other")
				Makefriends_Activity_Watch2_insert(nGuid, like_other,"like_other")
			else
				Makefriends_Activity_Watch2_insert(nGuid, {like_count = nValue,  support_me = 0,support_other = 0, like_me = like_me, like_other = like_other,match_count = 0, is_best_partner = false, is_like_each_other = true, is_fate = false,nSex=nSex,szCharName=szCharName})
			end
		end
	end

	for i=1,18 do 
		local nGuid, nSex, szCharName = SocialActivitesDataPool:GetArrayEcahRoundCampByIndex(i-1)	
		if nGuid ~= -1 then
			if g_Makefriends_Activity_Watch2_map[nGuid] then
				Makefriends_Activity_Watch2_insert(nGuid, szCharName,"szCharName")
				Makefriends_Activity_Watch2_insert(nGuid, nSex,"nSex")
				Makefriends_Activity_Watch2_insert(nGuid, true,"is_fate")
			else
				Makefriends_Activity_Watch2_insert(nGuid, {like_count = 0,support_me = 0,support_other = 0, like_me = 0, like_other = 0, match_count = 0, is_best_partner = false, is_like_each_other = false, is_fate = true,nSex=nSex,szCharName=szCharName})
			end
		end
	end

	Makefriends_Activity_Watch2_List:Clear()

	Makefriends_Activity_Watch2_List:Show()


	for k,v in pairs(g_Makefriends_Activity_Watch2_map) do
	   v["key"] = k

	   table.insert(g_Makefriends_Activity_watch_list, v)
	end
	table.sort(g_Makefriends_Activity_watch_list, Makefriends_Activity_Watch2_sortFunc)

	for i, v in ipairs(g_Makefriends_Activity_watch_list) do
		local k = v["key"]
		local ItemBar = Makefriends_Activity_Watch2_List:AddChild("Makefriends_Activity_Watch2_ListItem1")
		local match_count = Makefriends_Activity_Watch2_get(k,"match_count")
		local like_count = Makefriends_Activity_Watch2_get(k,"like_count")
		local is_fate = Makefriends_Activity_Watch2_get(k,"is_fate")

		local support_me = Makefriends_Activity_Watch2_get(k,"support_me")
		local support_other = Makefriends_Activity_Watch2_get(k,"support_other")
		local like_me = Makefriends_Activity_Watch2_get(k,"like_me")
		local like_other = Makefriends_Activity_Watch2_get(k,"like_other")
	
		local is_best_partner = Makefriends_Activity_Watch2_get(k,"is_best_partner")
		local is_like_each_other = Makefriends_Activity_Watch2_get(k,"is_like_each_other")
		local szCharName  = Makefriends_Activity_Watch2_get(k,"szCharName")
		local nSex  = Makefriends_Activity_Watch2_get(k,"nSex")
		local name = ScriptGlobal_Format("#{JYHD_230331_109}", szCharName)
		ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Paiming"):SetText(name)
		--ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Peihe"):SetText(match_count)	
		--ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Dianzan"):SetText(like_count)
		if nSex == 0 then --女
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Null"):SetProperty("Image",g_Makefriends_Activity_Image[nSex+1])
		elseif nSex == 1 then --男
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Null"):SetProperty("Image",g_Makefriends_Activity_Image[nSex+1])
		end
		if is_fate then
			local tooltips = "#{JYHD_230331_172}"

            ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_YFZD"):SetToolTip("#{JYHD_230331_172}")
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_YFZD"):Show()		
		else
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_YFZD"):Hide()		
		end
		if is_best_partner then
			local tooltips = ""
			local linebreak = ""
			if support_me and support_me > 0 then
				tooltips = ScriptGlobal_Format("#{JYHD_230331_168}", support_me)
				linebreak = "\n"
			end
			if support_other and support_other > 0 then
				tooltips = tooltips ..linebreak.. ScriptGlobal_Format("#{JYHD_230331_169}", support_other)
			end
			if tooltips ~= "" then
				ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_ZJPD"):SetToolTip(tooltips)
			end
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_ZJPD"):Show()		
		else
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_ZJPD"):Hide()		
		end
		if is_like_each_other then
			local tooltips = ""
			local linebreak = ""
			if like_me and like_me > 0 then
				tooltips = ScriptGlobal_Format("#{JYHD_230331_170}", like_me)
				linebreak = "\n"
			end
			if like_other and like_other > 0 then
				tooltips = tooltips ..linebreak .. ScriptGlobal_Format("#{JYHD_230331_171}", like_other)
			end
			if tooltips ~= "" then
				ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_HXDZ"):SetToolTip(tooltips)
			end
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_HXDZ"):Show()		
		else
			ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_HXDZ"):Hide()		
		end
		
		
		ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Plus1"):SetEvent("Clicked", string.format("Makefriends_Activity_Watch2_B1_AddFriend(%d)", i))
		ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Good1"):SetEvent("Clicked", string.format("Makefriends_Activity_Watch2_Expressing_Emotions(%d)", i))
		ItemBar:GetSubItem("Makefriends_Activity_Watch2_ListItem1_Search"):SetEvent("Clicked", string.format("Makefriends_Activity_Watch2_B1_Search(%d)", i))
	end

	local nTime = SocialActivitesDataPool:GetNTime()
	Makefriends_Activity_Watch2_InfoTime:SetText("#{BTMX_210111_05}")
	Makefriends_Activity_Watch2_TimeWatch:SetProperty("Timer", tonumber(nTime));
	Makefriends_Activity_Watch2_InfoText:SetText("#{JYHD_230331_62}")
	Makefriends_Activity_Watch2_TimeWatch:Show()
	Makefriends_Activity_Watch2_List:Show()
end


function Makefriends_Activity_Watch2_ResetPos()
	Makefriends_Activity_Watch2_Frame:SetProperty("UnifiedXPosition", g_Frame_UnifiedXPosition);
	Makefriends_Activity_Watch2_Frame:SetProperty("UnifiedYPosition", g_Frame_UnifiedYPosition);
end



function Makefriends_Activity_Watch2_OnHiden()
	PushEvent("MAKEFRIENDS_WATCH_CLOSE","0")
	this:Hide()
end



--表达心意按钮	
function Makefriends_Activity_Watch2_Expressing_Emotions(index)

	local v = g_Makefriends_Activity_watch_list[index]
	local tempGuid = v["key"]

	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,0,""
	if tempGuid ~= -1 then
		for n = 1, 3 do
			for m = 1, 6 do
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
				
				if nGuid == tempGuid then
					if (nGuid == Player:GetGUID()) then  
						PushDebugMessage("#H无法给自己表达心意。");--修改字典
						return;
					end
					
					local name = ScriptGlobal_Format("#{JYHD_230331_74}", szCharName)
					PushEvent("MAKEFRIENDS_EXPRESSING_EMOTIONS_CONFIRM",tostring(name),tonumber(n),tonumber(m))
					return 
				end
			end
		end
	else
		Lua_TDU_Log("Expressing "..tempGuid .. " index="..index)
	end
end

function Makefriends_Activity_Watch2_insert(key,info,subkey)
    
	if g_Makefriends_Activity_Watch2_map[key] then
		--更新value
		if subkey == "like_count"  then
			g_Makefriends_Activity_Watch2_map[key]["like_count"] = info
		end

		if subkey == "match_count"  then
			g_Makefriends_Activity_Watch2_map[key]["match_count"] = info
		end
		if subkey == "is_like_each_other"  then
			g_Makefriends_Activity_Watch2_map[key]["is_like_each_other"] = info
		end
		if subkey == "is_fate"  then
			g_Makefriends_Activity_Watch2_map[key]["is_fate"] = info
		end
		if subkey == "is_best_partner"  then
			g_Makefriends_Activity_Watch2_map[key]["is_best_partner"] = info
		end
		if subkey == "szCharName"  then
			g_Makefriends_Activity_Watch2_map[key]["szCharName"] = info
		end
		if subkey == "nSex"  then
			g_Makefriends_Activity_Watch2_map[key]["nSex"] = info
		end
		if subkey == "support_me"  then
			g_Makefriends_Activity_Watch2_map[key]["support_me"] = info
		end
		if subkey == "support_other"  then
			g_Makefriends_Activity_Watch2_map[key]["support_other"] = info
		end
		if subkey == "like_me"  then
			g_Makefriends_Activity_Watch2_map[key]["like_me"] = info
		end
		if subkey == "like_other"  then
			g_Makefriends_Activity_Watch2_map[key]["like_other"] = info
		end
	else
        
		g_Makefriends_Activity_Watch2_map[key] = info
	end
end

-- 排序函数
function Makefriends_Activity_Watch2_sortFunc(a, b)
	
    -- 判断是否互相点赞
	if a["is_like_each_other"] and b["is_like_each_other"] then
        -- 判断是否缘分注定
        if a["is_fate"] and b["is_fate"] then
            -- 判断是否最佳拍档
            if a["is_best_partner"] and b["is_best_partner"] then
                -- 点赞次数排序
                if a["like_count"] ~= b["like_count"] then
                    return a["like_count"] > b["like_count"]
                end
                -- 配合次数排序
                if a["match_count"] ~= b["match_count"] then
                    return a["match_count"] > b["match_count"]
                end
                -- key大小排序
                return Makefriends_Activity_Watch2_keySort(a, b)
            elseif a["is_best_partner"] then
                return true
            elseif b["is_best_partner"] then
                return false
            end
        elseif a["is_fate"] then
            return true
        elseif b["is_fate"] then
            return false
        end
	elseif a["is_like_each_other"] then
        return true
    elseif b["is_like_each_other"] then
        return false
    end

    -- 默认情况下按照点赞次数进行排序
    if a["like_count"] ~= b["like_count"] then
        return a["like_count"] > b["like_count"]
    end
    -- 配合次数排序
    if a["match_count"] ~= b["match_count"] then
        return a["match_count"] > b["match_count"]
    end
    -- key大小排序
    return Makefriends_Activity_Watch2_keySort(a, b)
end
-- 根据key的大小排序
function Makefriends_Activity_Watch2_keySort(a, b)
	return a["key"] > b["key"]
end


function Makefriends_Activity_Watch2_B1_Search(index)
	local v = g_Makefriends_Activity_watch_list[index]
	local tempGuid = v["key"]

	local nGuid, nSex, szCharName, nTimes,nAge,nMenpai,nBloodType,nConsella,nYearAnimal,nProvince,nTypeinfo,nLevel,szLuckWord = -1,0,"",0,0,-1,0,0,0,0,0,""
	if tempGuid ~= -1 then

		for n = 1, 3 do
			for m = 1, 6 do
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
				
                if tempGuid == nGuid then
					PushEvent("SOCIALACTIVITYES_SEARCH",tonumber(n),tonumber(m))
					
					return
				end
			end
		end
	end

end


function Makefriends_Activity_Watch2_get(key, field)
	
	if g_Makefriends_Activity_Watch2_map[key] then
		if g_Makefriends_Activity_Watch2_map[key][field] then
			return g_Makefriends_Activity_Watch2_map[key][field]
		else
			return nil
		end
	else
		return nil
	end
end

--添加好友按钮	
function Makefriends_Activity_Watch2_B1_AddFriend(index)

	local v = g_Makefriends_Activity_watch_list[index]
	local nGuid = v["key"]

	local szCharName = Makefriends_Activity_Watch2_get(nGuid,"szCharName")

	if nGuid ~= -1  then
		if nGuid == Player:GetGUID() then  
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
