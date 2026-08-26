--!!!reloadscript =FriendChat

--好友界面的默认位置
local g_FriendChat_Frame_UnifiedXPosition
local g_FriendChat_Frame_UnifiedYPosition

local g_IsTeamOutLine = {}
local g_TeamOutLineStr = {}

local g_imgStatus = {}

local g_FriendBlank = "     "		--3个空格缩进
local g_RemarkBlank = "  "		--2个空格缩进

local g_Current_Clicked = -1
local g_GroupTitleColor = "#gFE7E82 "

local g_FriendBorderColor = "#e010101"

local g_CurSelListItemID = -1
local g_KeepSelState = 0
local g_FC_ImageArr = {}--图素对应关系定义在wowanimate.xml-FaceMotionID="-32"，顺序为夫妻>情缘>师傅>徒弟>结拜

--===============================================
-- OnLoad()
--===============================================
function FriendChat_PreLoad()
	this:RegisterEvent("OPEN_IM_CHAT")
	this:RegisterEvent("UPDATE_FRIEND")
	this:RegisterEvent("UPDATE_FRIEND_INFO")
	this:RegisterEvent("UPDATE_GROUPINGNAME")	
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function FriendChat_OnLoad()

	g_FriendChat_Frame_UnifiedXPosition	= FriendChat_Frame:GetProperty("UnifiedXPosition")
	g_FriendChat_Frame_UnifiedYPosition	= FriendChat_Frame:GetProperty("UnifiedYPosition")

	g_IsTeamOutLine = {0,0,0,0,0}
	g_TeamOutLineStr = {
							"#{KDHYYH_211025_37}",
							"#{KDHYYH_211025_38}",
							"#{KDHYYH_211025_39}",
							"#{KDHYYH_211025_40}",
							"#{KDHYYH_20211025_10}",		--临时好友
						}


	g_imgStatus = {
			[0] = { [0] = "#-27" ,[1] = "#-28" ,[2] = "#-29"} ,
			[1] = { [0] = "#-24" ,[1] = "#-25" ,[2] = "#-26"} ,
		}

	g_Current_Clicked = -1

	g_FC_ImageArr = {"#-32","#-33","#-34","#-35","#-36"}

end

function FriendChat_OnEvent(event)
	if event == "OPEN_IM_CHAT" then
		DataPool:SetCurrentChatChannel(tonumber(arg0))
		DataPool:SetCurrentChatIndex(tonumber(arg1))
		FriendChat_Show()
	elseif event == "UPDATE_FRIEND" and this:IsVisible() then
		FriendChat_Show()
	elseif event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible() then
		this:Hide()
		return	
	elseif event == "UPDATE_FRIEND_INFO" and this:IsVisible() then
		FriendChat_UpdateFriendInfo(tonumber(arg0), tonumber(arg1))
	elseif event == "UPDATE_GROUPINGNAME" and this:IsVisible() then
		FriendChat_SetGroupingName()
		g_Current_Clicked = FriendChat_List:GetCurrentFirstItem()
		FriendChat_Update()
	elseif event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		FriendChat_ResetPos() 
	end
end

function FriendChat_ResetPos()
	FriendChat_Frame:SetProperty("UnifiedXPosition", g_FriendChat_Frame_UnifiedXPosition)
	FriendChat_Frame:SetProperty("UnifiedYPosition", g_FriendChat_Frame_UnifiedYPosition)
end

function FriendChat_Show()
	
	this:Show()
	FriendChat_SetGroupingName()

	g_Current_Clicked = FriendChat_List:GetCurrentFirstItem()
	
	local nChannel = DataPool:GetCurrentChatChannel()
	local nIndex = DataPool:GetCurrentChatIndex()
	
	local list_channel = nChannel
	if list_channel == 8 then
		list_channel = 5
	end
	
	if list_channel >= 1 and list_channel <= 5 then
		g_IsTeamOutLine[list_channel] = 1
	end
	
	FriendChat_Update()
	
	FriendChat_Edit:SetProperty("DefaultEditBox", "True")	
	
	FriendChat_List:SetItemSelectByItemID(nChannel * 10000 + nIndex + 1)
	
	FriendChat_HistoryContent:RemoveAllChatString()
	DataPool:ShowFriendIMChatHistory(nChannel, nIndex)

end

function FriendChat_UpdateFriendInfo(nChannel, nIndex)
	
	local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
	local remark = FriendChat_GetSpecialRemark(nChannel, nIndex)
	local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
	local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
	local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")		
	local IMst = 0--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
	local Sex = DataPool:GetFriend(nChannel, nIndex, "SEX")
	local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")
	local guid = DataPool:GetFriend(nChannel, nIndex, "ID")
	local strFaceImage = DataPool:GetFriend( nChannel, nIndex, "PORTRAIT" )

	local namecolor = "#cC4B299"

	local bShine = ""
	if haveMsg == 1 then
		bShine = "#b"
	end
	
	local moodColor = "#cFFCC7A"
	local playerIcon = g_RemarkBlank

	local imageIdx = 0	
	if relationtype == 7 then	-- 7：师傅 8：徒弟
		namecolor = "#cFF6600"
		imageIdx = 3
	elseif relationtype == 8 then
		namecolor = "#cFF6600"
		imageIdx = 4
	elseif relationtype == 3 then					-- 3：情侣
		namecolor = "#cF246F0"
		imageIdx = 1
	elseif relationtype == 2 then					-- 2：结拜
		imageIdx = 5
		namecolor = "#c007EFF"
	elseif friendship >= 10 then
		namecolor = "#c00FF00"
	elseif friendship >= 1 then
		namecolor = "#c00C800"
	elseif friendship == 0 then	
		namecolor = "#cFFFFFF"
	end	

	local isRoman = DataPool:GetFriend(nChannel, nIndex, "ISROMAN") 
	if isRoman == 1 and relationtype ~= 3 then
		namecolor = "#cFFC0CB"
		imageIdx = 2
	end
	local nameWithImage = name
	if imageIdx > 0 then
		nameWithImage = name..g_FC_ImageArr[imageIdx]
	end
	
	if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
		if nChannel == 6 then 								--仇人
			namecolor = "#cFF0000"		
		end
		
		if IMst >= 0 and IMst <= 2 and Sex >= 0 and Sex <= 1 then
			playerIcon = g_imgStatus[Sex][IMst]
		end
		
		local idx = FriendChat_List:GetItemNumByItemId(nChannel*10000 + nIndex + 1)
		if idx ~= -1 then
			
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = g_FriendBlank..bShine..namecolor..nameWithImage
			end
			
			local listmood = g_FriendBlank..g_RemarkBlank..moodColor..emotion

			FriendChat_List:SetListItemText(idx, g_FriendBorderColor..listName.."#r"..listmood)
		end
	else
		namecolor = "#cC4B299"
		if nChannel == 6 then
			namecolor="#cc7b299"
		end
		
		local idx = FriendChat_List:GetItemNumByItemId(nChannel*10000 + nIndex + 1)
		if idx ~= -1 then
			local listName = ""
			if remark ~= nil and remark ~= "" then
				listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
			else
				listName = g_FriendBlank..bShine..namecolor..nameWithImage
			end
			
			FriendChat_List:SetListItemText(idx, g_FriendBorderColor..listName)
		end
	end

end

function FriendChat_Update()
	
	FriendChat_List:ClearListBoxEx()
	FriendChat_List:AddItem("    "..g_GroupTitleColor.."#{KDHYYH_20211025_6}", 0)
	
	local FriendCount = 0 			--好友总数
	local OnlineFriendCount = 0 	--在线好友总数
	local FriendInfo = {}
	
	--共7组
	FriendChat_AddTopFriendItem()
	for i = 1, 5 do		
		local fGroupIndex = i
		if i == 5 then
			fGroupIndex = 8	--临时好友分组的索引特殊
		end
		
		FriendInfo[i] = ""
		if fGroupIndex >= 1 and fGroupIndex <= 4 then
			local groupCount = DataPool:GetFriendNumber(fGroupIndex)				--每组人数
			local onlienCount= DataPool:GetFriendOnlineNumber(fGroupIndex)			--每组在线人数
				
			local groupCommonCount = DataPool:GetFriendNumberCommon(fGroupIndex)
			local onlienCommonCount= DataPool:GetFriendOnlineNumberCommon(  fGroupIndex)
			FriendInfo[fGroupIndex] = "(" .. onlienCommonCount .."/" ..groupCommonCount ..")"
			FriendCount = FriendCount + groupCount
			OnlineFriendCount = OnlineFriendCount + onlienCount
		end

		local strOutlineName = ""
		if g_IsTeamOutLine[i] == 1 then
			strOutlineName = g_GroupTitleColor.."- "..g_TeamOutLineStr[i]..FriendInfo[i]
		else
			strOutlineName = g_GroupTitleColor.."+ "..g_TeamOutLineStr[i]..FriendInfo[i]
		end

		if strOutlineName ~= "" or strOutlineName ~= 0 then
			local iStart = fGroupIndex*10000
			local friendnumber = DataPool:GetFriendNumber(fGroupIndex)
			local groupCommonCount = DataPool:GetFriendNumberCommon(fGroupIndex)
			if groupCommonCount < 1 then
				strOutlineName = g_GroupTitleColor.."- "..g_TeamOutLineStr[i] .. FriendInfo[i]
			end			

			FriendChat_List:AddItem(strOutlineName, iStart)
			
			if g_IsTeamOutLine[i] == 1 then
				local index = 0
				while index < friendnumber do
					FriendChat_AddFriendItem(fGroupIndex, index)
					index = index + 1
				end
			end
		end
	end

	if g_Current_Clicked ~= -1 then
		FriendChat_List:SetCurrentFirstItem(g_Current_Clicked)
		g_Current_Clicked = -1
	end
	
	if g_CurSelListItemID >= 0 then
		FriendChat_List:SetItemSelectByItemID(g_CurSelListItemID)
	else
		g_KeepSelState = 0
	end
end

function FriendChat_AddFriendItem(nChannel, nIndex)

	local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
	local remark = FriendChat_GetSpecialRemark(nChannel, nIndex)
	local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
	local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
	local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
	local IMst = 0--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
	local Sex = DataPool:GetFriend(nChannel, nIndex, "SEX")
	local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")
	local guid = DataPool:GetFriend(nChannel, nIndex, "ID")
	local nLevel = DataPool:GetFriend(nChannel, nIndex, "LEVEL")
	local strFaceImage = DataPool:GetFriend( nChannel, nIndex, "PORTRAIT" )

	local namecolor = "#cC4B299"
	local istop = DataPool:GetFriend(nChannel, nIndex, "IS_TOP")
	if istop == 1 then
		return
	end
	
	local bShine = ""
	if haveMsg == 1 then
		bShine = "#b"
	end
	
	local moodColor = "#cFFCC7A"
	local playerIcon = g_RemarkBlank	
	
	local isbindapp = 0--DataPool:GetFriend(nChannel, nIndex, "FRIEND_ISAPPBIND") --0未绑定，1绑定
	
	if FriendChat_ShowInCommonFriendGroup(nChannel, nIndex) == 0 then
		return
	end
	
	local imageIdx = 0	
	if relationtype == 7 then	-- 7：师傅 8：徒弟
		namecolor = "#cFF6600"
		imageIdx = 3
	elseif relationtype == 8 then
		namecolor = "#cFF6600"
		imageIdx = 4
	elseif relationtype == 3 then					-- 3：情侣
		namecolor = "#cF246F0"
		imageIdx = 1
	elseif relationtype == 2 then					-- 2：结拜
		imageIdx = 5
		namecolor = "#c007EFF"
	elseif friendship >= 10 then
		namecolor = "#c00FF00"
	elseif friendship >= 1 then
		namecolor = "#c00C800"
	elseif friendship == 0 then	
		namecolor = "#cFFFFFF"
	end	

	local isRoman = DataPool:GetFriend(nChannel, nIndex, "ISROMAN") 
	if isRoman == 1 and relationtype ~= 3 then
		namecolor = "#cFFC0CB"
		imageIdx = 2
	end
	local nameWithImage = name
	if imageIdx > 0 then
		nameWithImage = name..g_FC_ImageArr[imageIdx]
	end	

	if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
		if nChannel == 6 then 								--仇人
			namecolor = "#cFF0000"
		end
		
		if IMst >= 0 and IMst <= 2 and Sex >= 0 and Sex <= 1 then
			playerIcon = g_imgStatus[Sex][IMst]
		end
		
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..bShine..namecolor..nameWithImage
		end
		
		local listmood = g_FriendBlank..g_RemarkBlank..moodColor..emotion
	
		if nChannel > 0 and nChannel < 5 and nIndex >= 0 then
			--FriendChat_List:AddItemExWithoutLayout(g_FriendBorderColor..listName.."#r"..listmood, nChannel*10000 + nIndex + 1, 4, "FFFFFFFF", 4)
			FriendChat_List:AddFriendItemExWithoutLayout(g_FriendBorderColor..listName.."#r"..listmood, nChannel*10000 + nIndex + 1, 5, "FFFFFFFF", 4, strFaceImage)
		else
			--FriendChat_List:AddItem(g_FriendBorderColor..listName.."#r"..listmood , nChannel*10000 + nIndex + 1 , "FFFFFFFF", 4 )
			FriendChat_List:AddFriendItemExWithoutLayout(g_FriendBorderColor..listName.."#r"..listmood, nChannel*10000 + nIndex + 1, 5, "FFFFFFFF", 4, strFaceImage)
		end
	else
		namecolor = "#cC4B299"
		if nChannel == 6 then
			namecolor="#cc7b299"		--仇人
		end
		
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..bShine..namecolor..nameWithImage
		end

		if nChannel == 1 or nChannel == 2 or nChannel == 3 or nChannel == 4 then
			FriendChat_List:AddItemExWithoutLayout(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1 ,8, "FFFFFFFF", 0)
			--FriendChat_List:AddFriendItemExWithoutLayout(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1, 5, "FFFFFFFF", 4, strFaceImage)
		else
			FriendChat_List:AddItemExWithoutLayout(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1 ,8, "FFFFFFFF", 0)
			--FriendChat_List:AddFriendItemExWithoutLayout(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1, 5, "FFFFFFFF", 4, strFaceImage)
		end
	end

end

function FriendChat_SetGroupingName()
	local strGroupName = ""
	for i = 1, 4 do
		strGroupName = DataPool:GetGroupingName(i - 1)
		if strGroupName ~= "" then
			g_TeamOutLineStr[i] = strGroupName
		end
	end
	
end

function FriendChat_OnCloseClick()
	this:Hide()
end

function FriendChat_OnCancel()
	this:Hide()
end

function FriendChat_OnHelpClick()
	Helper:GotoHelper("*Friend")
end

function FriendChat_OnHidden()
	FriendChat_List:ClearListBoxEx()
	FriendChat_Edit:SetProperty("DefaultEditBox", "False")
	FriendChat_HistoryContent:RemoveAllChatString()
	g_CurSelListItemID = -1
	g_KeepSelState = 0
end

--双击
function FriendChat_FriendListDoubleClick()	
	local index = FriendChat_List:GetFirstSelectItem()
	if index == -1 then
		return
	end
	
	local iMod = math.mod(index, 10000)
	local iFloor = math.floor(index / 10000)
	
	if iMod ~= 0 then
		DataPool:UpdateFriendInfo(iFloor, iMod - 1)
	end

	
end
--打开菜单
function FriendChat_OpenMenu()
	
	local index = FriendChat_List:GetFirstSelectItem()
	if index == -1 then
		return
	end
	
	local iMod = math.mod(index, 10000)
	local iFloor = math.floor(index / 10000)

	Friend:OpenMenu(tostring(iFloor), tostring(iMod - 1))

end

function FriendChat_List_SelectChanged()

	local nSelIndex = FriendChat_List:GetFirstSelectItem()

	local iMod = math.mod(nSelIndex, 10000)
	local iFloor = math.floor(nSelIndex / 10000)
	if 0 == iMod then
		local outLineIndex = iFloor
		if iFloor == 8 then
			outLineIndex = 5
		end
			
		if 0 == g_IsTeamOutLine[outLineIndex] then
			g_IsTeamOutLine[outLineIndex] = 1
		else
			g_IsTeamOutLine[outLineIndex] = 0
		end
		
		g_Current_Clicked = FriendChat_List:GetCurrentFirstItem()
		g_KeepSelState = 1
		FriendChat_Update()		
		return
	else
		g_CurSelListItemID = nSelIndex
		if g_KeepSelState == 0 then
			local last_channel = DataPool:GetCurrentChatChannel()
			local last_index = DataPool:GetCurrentChatIndex()
			
			if last_channel ~= iFloor or last_index ~= (iMod - 1) then
				DataPool:SetCurrentChatChannel(iFloor)
				DataPool:SetCurrentChatIndex(iMod - 1)
				
				FriendChat_HistoryContent:RemoveAllChatString()
				
				DataPool:ShowFriendIMChatHistory(iFloor, iMod - 1)
			end			
		else
			g_KeepSelState = 0
		end
	end

end

function FriendChat_ShowInCommonFriendGroup(nChannel, nIndex)
	return 1
end

function FriendChat_GetSpecialRemark(nChannel, nIndex)
	local remark = DataPool:GetFriend(nChannel, nIndex, "REMARK")
	return remark
end

function FriendChat_SelectTextColor()
	local frame_posX = FriendChat_Frame:GetProperty("AbsoluteXPosition")
	local client_posX = FriendChat_Client:GetProperty("AbsoluteXPosition")
	local cbt_frame_posX = FriendChat_ChatButton_Frame:GetProperty("AbsoluteXPosition")
	local bt_posX = FriendChat_LetterColor:GetProperty("AbsoluteXPosition")
	
	local posX = frame_posX + client_posX + cbt_frame_posX + bt_posX
	
	local frame_posY = FriendChat_Frame:GetProperty("AbsoluteYPosition")
	local client_posY = FriendChat_Client:GetProperty("AbsoluteYPosition")
	local cbt_frame_posY = FriendChat_ChatButton_Frame:GetProperty("AbsoluteYPosition")
	local bt_posY = FriendChat_LetterColor:GetProperty("AbsoluteYPosition")
	
	local posY = frame_posY + client_posY + cbt_frame_posY + bt_posY
	
	Talk:SelectTextColor("select", posX, posY - 120)
	
	FriendChat_Edit:SetProperty("DefaultEditBox", "True")
end

function FriendChat_SelectFaceMotion()
	local frame_posX = FriendChat_Frame:GetProperty("AbsoluteXPosition")
	local client_posX = FriendChat_Client:GetProperty("AbsoluteXPosition")
	local cbt_frame_posX = FriendChat_ChatButton_Frame:GetProperty("AbsoluteXPosition")
	local bt_posX = FriendChat_Speaker_Face:GetProperty("AbsoluteXPosition")
	
	local posX = frame_posX + client_posX + cbt_frame_posX + bt_posX
	
	local frame_posY = FriendChat_Frame:GetProperty("AbsoluteYPosition")
	local client_posY = FriendChat_Client:GetProperty("AbsoluteYPosition")
	local cbt_frame_posY = FriendChat_ChatButton_Frame:GetProperty("AbsoluteYPosition")
	local bt_posY = FriendChat_Speaker_Face:GetProperty("AbsoluteYPosition")
	
	local posY = frame_posY + client_posY + cbt_frame_posY + bt_posY
	
	Talk:SelectFaceMotion("select", posX, posY - 307)
	
	FriendChat_Edit:SetProperty("DefaultEditBox", "True")
end

function FriendChat_SendMessage()
	
	local send_txt = FriendChat_Edit:GetString()
	Talk:SendImMessage(send_txt)
	
	FriendChat_Edit:SetText("")
end


function FriendChat_AddTopFriendItem(nChannel, nIndex)
	local topGUID = DataPool:GetTopGUID()
	if topGUID <= 0 then
		return
	end
	local nChannel, nIndex = DataPool:GetFriendByGUID(topGUID)

	local name = DataPool:GetFriend(nChannel, nIndex, "NAME")
	local remark = FriendChat_GetSpecialRemark(nChannel, nIndex)
	local emotion = DataPool:GetFriend(nChannel, nIndex, "MOOD")
	local friendship = DataPool:GetFriend(nChannel, nIndex, "FRIENDSHIP")
	local relationtype = DataPool:GetFriend(nChannel, nIndex, "RELATION_TYPE")
	local IMst = 0--DataPool:GetFriend(nChannel, nIndex, "IM_STATUS")
	local Sex = DataPool:GetFriend(nChannel, nIndex, "SEX")
	local haveMsg = DataPool:GetFriend(nChannel, nIndex, "HAVEMSG")
	local guid = DataPool:GetFriend(nChannel, nIndex, "ID")
	local nLevel = DataPool:GetFriend(nChannel, nIndex, "LEVEL")
	local strFaceImage = DataPool:GetFriend( nChannel, nIndex, "PORTRAIT" )
		
	local namecolor = "#cC4B299"
	
	local bShine = ""
	if haveMsg == 1 then
		bShine = "#b"
	end
	
	local moodColor = "#cFFCC7A"
	
	local isbindapp = 0--DataPool:GetFriend(nChannel, nIndex, "FRIEND_ISAPPBIND")
	
	local imageIdx = 0	
	if relationtype == 7 then	-- 7：师傅 8：徒弟
		namecolor = "#cFF6600"
		imageIdx = 3
	elseif relationtype == 8 then
		namecolor = "#cFF6600"
		imageIdx = 4
	elseif relationtype == 3 then					-- 3：情侣
		namecolor = "#cF246F0"
		imageIdx = 1
	elseif relationtype == 2 then					-- 2：结拜
		imageIdx = 5
		namecolor = "#c007EFF"
	elseif friendship >= 10 then
		namecolor = "#c00FF00"
	elseif friendship >= 1 then
		namecolor = "#c00C800"
	elseif friendship == 0 then	
		namecolor = "#cFFFFFF"
	end	

	local isRoman = DataPool:GetFriend(nChannel, nIndex, "ISROMAN") 
	if isRoman == 1 and relationtype ~= 3 then
		namecolor = "#cFFC0CB"
		imageIdx = 2
	end
	
	local nameWithImage = name
	if imageIdx > 0 then
		nameWithImage = name..g_FC_ImageArr[imageIdx]
	end	

	if DataPool:GetFriend(nChannel, nIndex, "ONLINE") then
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..bShine..namecolor..nameWithImage
		end
		
		local listmood = g_FriendBlank..g_RemarkBlank..moodColor..emotion
	
		if nChannel > 0 and nChannel < 5 and nIndex >= 0 then
			FriendChat_List:AddFriendItemExWithoutLayout(g_FriendBorderColor..listName.."#r"..listmood, nChannel*10000 + nIndex + 1, 5, "FFFFFFFF", 4, strFaceImage)
		end
	else
		namecolor = "#cC4B299"
		
		local listName = ""
		if remark ~= nil and remark ~= "" then
			listName = g_FriendBlank..bShine..namecolor..nameWithImage.."#r"..g_FriendBlank..g_RemarkBlank..namecolor.."("..remark..")"
		else
			listName = g_FriendBlank..bShine..namecolor..nameWithImage
		end

		if nChannel == 1 or nChannel == 2 or nChannel == 3 or nChannel == 4 then
			FriendChat_List:AddItemExWithoutLayout(g_FriendBorderColor..listName, nChannel*10000 + nIndex + 1 ,8, "FFFFFFFF", 0)
		end
	end

end

