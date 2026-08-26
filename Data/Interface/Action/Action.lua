--******************************************************************************
--
-- ÐÝÏÐ¶¯×÷
--
--******************************************************************************

-- °´Å¥
local g_Action_Buttons = {}									-- ????????
local g_Double_Action_Buttons	= {}					-- ????????
local ACTION_BUTTON_NUMBERS		= 25					-- ??????????
local ACTION_BUTTON_NUMBERS_NORMAL		= 23					-- ?????????
local g_curButton							= 0						-- ?????????

-- ·ÖÒ³
local g_PageTabs							= {}					-- ????
local g_curPage								= 1						-- ???????
local MIX_DOUBLE_ACTION_PAGE	= 4						-- ???????????
local MAX_PAGE_NUMBER					= 7						-- ??????

local g_Type_SingleDouble = {}	--????page?????????????? 0? 1? 2?


function Action_PreLoad()
	this:RegisterEvent("CHAT_ACT_SELECT")
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL")
	this:RegisterEvent("CHAT_ACCEPT_DOUBLE_ACTION")						-- ?Action????????
	this:RegisterEvent("CHAT_ACCEPT_DOUBLE_ACTION_BAR")				-- ?MainMenuBar??????????
	--this:RegisterEvent("CHAT_ACCEPT_DOUBLE_ACTION_STRING")		-- ´ÓÁÄÌìÀ¸ÊäÈë×Ö·û´®±íÊ¾Ë«ÈË¶¯×÷
end

function Action_OnLoad()

	g_Action_Buttons = {
		Action_1,  Action_2,  Action_3,  Action_4,  Action_5,
		Action_6,  Action_7,  Action_8,  Action_9,  Action_10,
		Action_11, Action_12, Action_13, Action_14, Action_15,
		Action_16, Action_17, Action_18, Action_19, Action_20,
		Action_21, Action_22, Action_23, Action_24, Action_25
	}

	g_Double_Action_Buttons = {
		Action_D1,  Action_D2,  Action_D3,  Action_D4,  Action_D5,
		Action_D6,  Action_D7,  Action_D8,  Action_D9,  Action_D10,
		Action_D11, Action_D12, Action_D13, Action_D14, Action_D15,
		Action_D16, Action_D17, Action_D18, Action_D19, Action_D20,
		Action_D21, Action_D22, Action_D23, Action_D24, Action_D25
	}

	g_PageTabs = {
		Action_Index1,
		Action_Index2,
		Action_Index3,
		Action_Index4,
		Action_Index5,
		Action_Index6,
		Action_Index7,
	}

end

function Action_OnEvent( event )

	--PushDebugMessage ("Action : ".. event)

	-- µã»÷ÁÄÌì½çÃæÉÏµÄ±¾½çÃæÍ¼±ê
	if ( event == "CHAT_ACT_SELECT" ) then
		Action_OnShow(arg0);

	-- ½ÇÉ«ÒÆ¶¯
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		Action_AdjustMoveCtl();
		
	-- ¶Ô·½Í¬Òâ×öË«ÈË¶¯×÷(´ÓAction½çÃæÉÏ°´µÄ)
	elseif (event == "CHAT_ACCEPT_DOUBLE_ACTION") then		
		Action_DoDoubleAction(tonumber(arg0), tostring(arg1))

	-- ¶Ô·½Í¬Òâ×öË«ÈË¶¯×÷£¨´ÓMainMenuBarÏà¹Ø½çÃæÉÏ°´µÄ£©
	elseif (event == "CHAT_ACCEPT_DOUBLE_ACTION_BAR") then
		Action_DoDoubleAction_Bar(tonumber(arg0), tonumber(arg1), tostring(arg2))		

	end

end

function Action_OnShow(pos)

	if (this:IsVisible() or this:ClickHide()) then
		Action_OnHide()
		return
	end
	
	-- ´ò¿ªÊ±¶¼ÊÇÄ¬ÈÏµÚÒ»Ò³
	g_curPage = 1
	
	-- ÉèÖÃ½çÃæÎ»ÖÃ
	Action_ChangePosition(pos);

	-- ·ÖÒ³ÉèÖÃ
	Action_Page_Switch(g_curPage);
	
	-- ÉèÖÃ¸÷¸ö¶¯×÷·ÖÒ³µÄTips
	g_PageTabs[1] : SetToolTip("#{SRDZ_20221107_14}")																					-- "Hßu nhàn ðµng tác"
	g_PageTabs[2] : SetToolTip("#{SRDZ_20221107_15}")																					-- "Song Nhân ðµng tác"
	g_PageTabs[3] : SetToolTip("#{SZDZ_231110_01}")																					-- "Song Nhân ðµng tác"
	for i = 0 ,3 do
		local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(i)
		local actionName = DataPool : Get_RMB_ChatActionName(actionID)
		if actionID > 0 then
			local actionHour = DataPool : Get_RMB_ChatActionValidHour(i)
			if (actionHour >= 0) then
				g_PageTabs[i+MIX_DOUBLE_ACTION_PAGE] : SetToolTip(tostring(actionName).."#r"..tostring(actionValidDate))		-- ????#r???
			else
				g_PageTabs[i+MIX_DOUBLE_ACTION_PAGE] : SetToolTip(tostring(actionName).."#r#{SRDZ_20221107_12}")									-- ????#r????
			end
		else
			g_PageTabs[i+MIX_DOUBLE_ACTION_PAGE] : SetToolTip("#{SRDZ_20221107_16}")																						-- ???
		end
	end

	this:Show();
end

--**********************************************
-- Òþ²Ø´°¿Ú
--**********************************************
function Action_OnHide()

	-- È¡Ïû·ÖÒ³Ñ¡Ïî
	g_PageTabs[g_curPage]:SetCheck(0)
	g_curPage		= 1

	g_curButton	= 0

	-- Òþ²ØÈ«²¿°´Å¥
	for i = 1, table.getn(g_Action_Buttons) do
		g_Action_Buttons[i] : SetActionItem(-1);
		g_Action_Buttons[i] : Disable();
		g_Action_Buttons[i] : Hide();
	end
	
	for i = 1, table.getn(g_Double_Action_Buttons) do
		g_Double_Action_Buttons[i] : SetActionItem(-1);
		g_Double_Action_Buttons[i] : Disable();
		g_Double_Action_Buttons[i] : Hide();
	end
	
	Action_DragTitle : SetText("")								-- ??
	Action_Uninstall : Hide()											-- ??“??”??
	Action_Time : Hide()													-- ?????	

	this : Hide();
end

--**********************************************
-- ÒÆ¶¯
--**********************************************
function Action_AdjustMoveCtl()
	Action_OnHide()
end

--**********************************************
-- ÉèÖÃ´°¿ÚÎ»ÖÃ
--**********************************************
function Action_ChangePosition(pos)
	Action_Frame : SetProperty("UnifiedXPosition", "{0.0,"..pos.."}");	
end

--**********************************************
-- ÏÔÊ¾Ò³ÃæÄÚÈÝ
--**********************************************
function Action_Button_Show(pageNum)
	
	if pageNum < 1 or pageNum > MAX_PAGE_NUMBER then
		return
	end
	
	-- ÏÈÒþ²ØÈ«²¿°´Å¥
	for i = 1, table.getn(g_Action_Buttons) do
		g_Action_Buttons[i] : SetActionItem(-1);
		g_Action_Buttons[i] : Disable();
		g_Action_Buttons[i] : Hide();
	end

	for i = 1, table.getn(g_Double_Action_Buttons) do
		g_Double_Action_Buttons[i] : SetActionItem(-1);
		g_Double_Action_Buttons[i] : Disable();
		g_Double_Action_Buttons[i] : Hide();
	end
	
	Action_DragTitle	: SetText("")
	Action_Uninstall	: Hide()											-- ??“??”??
	Action_Time				: Hide()											-- ?????
	
	-- Æ Í¨ÐÝÏÐ¶¯×÷
	if (tonumber(pageNum) == 1) then		

		for i = 1, ACTION_BUTTON_NUMBERS_NORMAL do
			local theAction = Talk : EnumChatMood(i - 1);	
			if (theAction:GetID() ~= 0) then				
				g_Action_Buttons[i] : SetActionItem(theAction:GetID());
				g_Action_Buttons[i] : Enable();
			else				
				g_Action_Buttons[i] : SetActionItem(-1);
				g_Action_Buttons[i] : Disable();
			end			
			g_Action_Buttons[i] : Show();			
		end
		
		for i = ACTION_BUTTON_NUMBERS_NORMAL + 1, ACTION_BUTTON_NUMBERS do
			g_Type_SingleDouble[i] = 1
			g_Action_Buttons[i] : SetActionItem(-1);
			g_Action_Buttons[i] : Disable();
			g_Action_Buttons[i] : Show();	
		end
  
		Action_DragTitle	: SetText("#{SRDZ_20221107_14}")		-- ??:"Hßu nhàn ðµng tác"		

	-- ¹Ì¶¨Ë«ÈËÐÝÏÐ¶¯×÷
	elseif (tonumber(pageNum) == 2) then		
  
		for i = 1, ACTION_BUTTON_NUMBERS do
			local bValid = Talk : IsValidChatActionByIndex(i - 1);
			if (bValid == 1) then
				local theAction = Talk : EnumDoubleChatMood(i - 1);
				if (theAction:GetID() ~= 0) then
					g_Double_Action_Buttons[i] : SetActionItem(theAction:GetID());
					g_Double_Action_Buttons[i] : Enable();
				else
					g_Double_Action_Buttons[i] : SetActionItem(-1);
					g_Double_Action_Buttons[i] : Disable();
				end
			else
				g_Double_Action_Buttons[i] : SetActionItem(-1);
				g_Double_Action_Buttons[i] : Disable();
			end
			g_Double_Action_Buttons[i] : Show();			
		end
  
		Action_DragTitle	: SetText("#{SRDZ_20221107_15}")		-- ??:"Song Nhân ðµng tác"		
 	-- Ê±×°+»ÃÊÎÎäÆ÷¶¯×÷
	elseif (tonumber(pageNum) == 3) then	
		local nAddIndex = 0
		local nSingleNum = 20
		local nDoubleNum = 5
		-- i=0 ÎäÆ÷¶¯×÷ i=1Ê±×°¶¯×÷
		-- i=2 ±£Áô i=3 ±£Áô i=4 ±£Áô
		-- ²ß»®Òª¸ù¾ÝÅä±í×Ô¶¨ÒåÏÔÊ¾Ë³Ðò¡£¡£¡£¡£
		local tabSort = {}
		local nChatMoodType = 1
		for i=0, nSingleNum-1 do 
			local nChatMoodId = Talk : EnumEquipChatMoodId(i, nChatMoodType);
			if nChatMoodId ~= -1 then 
				local nSortIndex = Talk : EnumEquipChatMoodSort(nChatMoodId)
				table.insert(tabSort, {id = nChatMoodId, nIndex=i, nType=nChatMoodType, nSort = nSortIndex})
			end
		end
		nChatMoodType = 2
		for i=0, nDoubleNum-1 do 
			local nChatMoodId = Talk : EnumEquipChatMoodId(i, nChatMoodType);
			if nChatMoodId ~= -1 then 
				local nSortIndex = Talk : EnumEquipChatMoodSort(nChatMoodId)
				table.insert(tabSort, {id = nChatMoodId, nIndex=i, nType=nChatMoodType, nSort = nSortIndex})
			end
		end
		table.sort(tabSort, function(a, b)
				if a.nSort ~= b.nSort then 
					return a.nSort < b.nSort
				elseif a.id ~= b.id then 
					return a.id < b.id
				end
				return false
			end)
		for i, v in pairs(tabSort) do 
			local theAction = nil
			if v.nType == 2 then 
				theAction = Talk : EnumEquipDoubleMood(v.nIndex);
			else
				theAction = Talk : EnumEquipSingleMood(v.nIndex)
			end
			if (theAction:GetID() ~= 0) then
				nAddIndex = nAddIndex + 1
				g_Type_SingleDouble[nAddIndex] = v.nType
				g_Double_Action_Buttons[nAddIndex] : SetActionItem(theAction:GetID());
				g_Double_Action_Buttons[nAddIndex] : Enable();
				g_Double_Action_Buttons[nAddIndex] : Show();
			end	
		end
		for i=nAddIndex+1,ACTION_BUTTON_NUMBERS do 
			g_Type_SingleDouble[i] = 0;
			g_Double_Action_Buttons[i] : SetActionItem(-1);
			g_Double_Action_Buttons[i] : Disable();
			g_Double_Action_Buttons[i] : Show();	
		end

		Action_DragTitle	: SetText("#{SZDZ_231110_01}")		-- ??:"Trang phøc m¯t ðµng tác"	
	-- ¸¶·ÑË«ÈËÐÝÏÐ¶¯×÷
	else
	
		-- µÃµ½µ±Ç°Ò³¶¯×÷°üÐÅÏ¢
		local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(pageNum - MIX_DOUBLE_ACTION_PAGE)
		local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID)
		
		if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
			
			-- ÏÔÊ¾¶¯×÷°ü±êÌâ
			local actionName = DataPool : Get_RMB_ChatActionName(actionID)
			Action_DragTitle : SetText("#gFF0FA0"..tostring(actionName))
			-- Ô­Ë«ÈË
			if actionType == 2 then
				-- ÏÔÊ¾°´Å¥
				for i = 1, ACTION_BUTTON_NUMBERS do
					if i <= actionCount then
						local bValid = Talk : IsValidChatActionByIndex(actionMinIndex + i - 2);
						if (bValid == 1) then
							local theAction = Talk : EnumDoubleChatMood(actionMinIndex + i - 2);
							if (theAction:GetID() ~= 0) then
								g_Double_Action_Buttons[i] : SetActionItem(theAction:GetID());
								g_Double_Action_Buttons[i] : Enable();
							else
								g_Double_Action_Buttons[i] : SetActionItem(-1);
								g_Double_Action_Buttons[i] : Disable();
							end
						else
							g_Double_Action_Buttons[i] : SetActionItem(-1);
							g_Double_Action_Buttons[i] : Disable();
						end
					else
						g_Double_Action_Buttons[i] : SetActionItem(-1);
						g_Double_Action_Buttons[i] : Disable();
					end
					g_Double_Action_Buttons[i] : Show();
				end
			elseif actionType == 1 then
				-- ÏÔÊ¾°´Å¥
				for i = 1, ACTION_BUTTON_NUMBERS do
					g_Type_SingleDouble[i] = 1
					if i <= actionCount then
						local bValid = Talk : IsValidSingleChatActionByIndex(actionMinIndex + i - 2);
						if (bValid == 1) then
							local theAction = Talk : EnumChatMood(actionMinIndex + i - 2);
							if (theAction:GetID() ~= 0) then
								g_Action_Buttons[i] : SetActionItem(theAction:GetID());
								g_Action_Buttons[i] : Enable();
							else
								g_Action_Buttons[i] : SetActionItem(-1);
								g_Action_Buttons[i] : Disable();
							end
						else
							g_Action_Buttons[i] : SetActionItem(-1);
							g_Action_Buttons[i] : Disable();
						end
					else
						g_Action_Buttons[i] : SetActionItem(-1);
						g_Action_Buttons[i] : Disable();
					end
					g_Action_Buttons[i] : Show();
				end
			end
			-- ÏÔÊ¾¼ÆÊ±Æ÷			
			local actionHour = DataPool : Get_RMB_ChatActionValidHour(pageNum - MIX_DOUBLE_ACTION_PAGE)
			if actionHour >=0 and actionHour < 24 then
				Action_Frame_TimeText : SetText("#cff0000#{BQB_XML_3}"..tostring(actionHour).."#{BQB_XML_16}");						-- ????:XX??																					-- ????:XX??
			elseif actionHour >= 24 then				
				Action_Frame_TimeText : SetText("#G#{BQB_XML_3}"..tostring(math.floor(actionHour/24)).."#{BQB_XML_15}");	-- ????:xx?																					-- ????:XX?
			else
				Action_Frame_TimeText : SetText("#G#{SRDZ_20221107_12}");																											-- ????
			end
			Action_Time : Show()
			
			-- ÏÔÊ¾¡°Ð¶ÔØ¡±°´Å¥
			Action_Uninstall : Show()			
 
		else			
			-- µ±Ç°Ò³Î´°²×°¶¯×÷°ü
			Action_DragTitle	: SetText("#{SRDZ_20221107_16}")		-- ???
			Action_Uninstall	: Hide()											-- ??“??”??
			Action_Time				: Hide()											-- ?????			
		end
  
	end

end

--**********************************************
-- ·ÖÒ³
--**********************************************
function Action_Page_Switch(pageNum)

	--PushDebugMessage ("Action_Page_Switch : pageNum = "..pageNum)

	if pageNum < 1 or pageNum > MAX_PAGE_NUMBER then
		return
	end

	g_curPage = pageNum		
	g_PageTabs[g_curPage]:SetCheck(1)
	Action_Button_Show(g_curPage)

end

--************************************************
-- ÄÜ·ñ×öË«ÈËÁÄÌì¶¯×÷
--************************************************
function Action_CanDoDoubleAction(pos)

	--PushDebugMessage ("pos = "..pos)

	if (g_curPage < MIX_DOUBLE_ACTION_PAGE-2) or (g_curPage > MAX_PAGE_NUMBER) then
		return
	end

	-- Ä¬ÈÏµÄË«ÈËÐÝÏÐ¶¯×÷
	if (g_curPage == MIX_DOUBLE_ACTION_PAGE-2) then
		-- ÅÐ¶Ï°´Å¥ÊÇ·ñÓÐÐ§
		if (pos <= 0) or (pos > ACTION_BUTTON_NUMBERS) then
			return
		end
	-- ÎäÆ÷Ê±×°¶¯×÷
	elseif (g_curPage == MIX_DOUBLE_ACTION_PAGE-1) then
		if g_Type_SingleDouble[pos] == 1 then 
			g_Double_Action_Buttons[pos]:DoAction()
			return
		end
	-- ¸¶·ÑË«ÈËÐÝÏÐ¶¯×÷
	elseif (g_curPage >= MIX_DOUBLE_ACTION_PAGE) and (g_curPage <= MAX_PAGE_NUMBER) then
		-- µÃµ½µ±Ç°Ò³¶¯×÷°üÐÅÏ¢
		local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(g_curPage - MIX_DOUBLE_ACTION_PAGE);
		
		-- ÅÐ¶Ï°´Å¥ÊÇ·ñÓÐÐ§
		if (pos <= 0) or (pos >actionCount) then
			return
		end
		
		if actionType == 1 then
			-- µ¥ÈËÌØÐ´
			-- ÏÈ¼ÇÂ¼ÏÂ±¾Ò³°´Å¥µÄÎ»ÖÃ
			g_curButton = pos
			-- Ñ¯ÎÊ¶Ô·½ÊÇ·ñ¿ÉÒÔ×öµ¥ÈË¶¯×÷£¡
			--Talk : CanDoDoubleAction(pos)
			return
		end
		
	end
	
	-- ÏÈ¼ÇÂ¼ÏÂ±¾Ò³°´Å¥µÄÎ»ÖÃ
	g_curButton = pos

	-- Ñ¯ÎÊ¶Ô·½ÊÇ·ñ¿ÉÒÔ×öË«ÈË¶¯×÷
	Talk : CanDoDoubleAction(pos)

end

--************************************************
-- ×öË«ÈËÁÄÌì¶¯×÷£¨±¾½çÃæ°´Å¥£©
--************************************************
function Action_DoDoubleAction(bEnable, talker)



	-- ²»ÊÇË«ÈË¶¯×÷Ò³Ãæ
	if (g_curPage < MIX_DOUBLE_ACTION_PAGE-2) or (g_curPage > MAX_PAGE_NUMBER) then
		return
	end

	--  Ò²»µ½Ëµ»° ß
	if (talker == "") then
		return
	end

	-- Ëµ»°µÄ²»ÊÇ×Ô¼º
	local myName = Player:GetName()	
	
	if (myName ~= talker) then
		return
	end

	-- ¶Ô·½¿ªÆôÁËÁÄÌì¶¯×÷ÉèÖÃ
	if (bEnable == 1) then
	
		-- Ä¬ÈÏµÄË«ÈË¶¯×÷Ò³Ãæ
		if (g_curPage == MIX_DOUBLE_ACTION_PAGE-2) then
			-- ÅÐ¶Ï°´Å¥ÊÇ·ñÓÐÐ§
			if (g_curButton <= 0) or (g_curButton > ACTION_BUTTON_NUMBERS) then
				return
			end
			
			local bValid = Talk : IsValidChatActionByIndex(g_curButton - 1);
			if (bValid == 1) then
				local theAction = Talk : EnumDoubleChatMood(g_curButton - 1);
				if (theAction:GetID() ~= 0) then
					g_Double_Action_Buttons[g_curButton] : DoAction();
				end
			end
		-- ÎäÆ÷Ê±×°¶¯×÷
		elseif (g_curPage == MIX_DOUBLE_ACTION_PAGE-1) then
			-- ÅÐ¶Ï°´Å¥ÊÇ·ñÓÐÐ§
			if (g_curButton <= 0) or (g_curButton > ACTION_BUTTON_NUMBERS) then
				return
			end
			g_Double_Action_Buttons[g_curButton] : DoAction();
			
		-- ¸¶·ÑË«ÈË¶¯×÷Ò³Ãæ
		elseif (g_curPage >= MIX_DOUBLE_ACTION_PAGE) and (g_curPage <= MAX_PAGE_NUMBER) then
	
			-- µÃµ½µ±Ç°Ò³¶¯×÷°üÐÅÏ¢
			local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(g_curPage - MIX_DOUBLE_ACTION_PAGE);
			
			-- ÅÐ¶Ï°´Å¥ÊÇ·ñÓÐÐ§
			if (g_curButton <= 0) or (g_curButton >actionCount) then
				return
			end
			
			local realIndex = actionMinIndex + g_curButton - 2;							-- ??????????????	
			local bValid = Talk : IsValidChatActionByIndex(realIndex);
			if (bValid == 1) then
				local theAction = Talk : EnumDoubleChatMood(realIndex);
				if (theAction:GetID() ~= 0) then
					g_Double_Action_Buttons[g_curButton] : DoAction();
				end
			end
		end

	end

end

--************************************************
-- ×öË«ÈËÁÄÌì¶¯×÷£¨MainMenuBar½çÃæ°´Å¥·¢Æð¶¯×÷£©
--************************************************
function Action_DoDoubleAction_Bar(bEnable, pos, talker)

	-- pos ÊÇ°´Å¥ÔÚ û¸öË«ÈË¶¯×÷±íÊý×éÖÐµÄÎ»ÖÃ
	if (pos < 0) then
		return
	end

	--  Ò²»µ½Ëµ»° ß
	if (talker == "") then
		return
	end

	-- Ëµ»°µÄ²»ÊÇ×Ô¼º
	local myName = Player:GetName()
	if (myName ~= talker) then
		return
	end
	
	-- ¶Ô·½¿ªÆôÁËÁÄÌì¶¯×÷ÉèÖÃ
	if (bEnable == 1) then
		local bValid = Talk : IsValidChatActionByIndex(pos);
		if (bValid == 1) then
			local theAction = Talk : EnumDoubleChatMood(pos)
			if (theAction:GetID() ~= 0) then
				Talk : DoDoubleActionByIndex(pos);
			end
		else
			PushDebugMessage("Thí nghi®m Døng, không có hi®u quä Ðích cái nút")
		end	
	end

end

--************************************************
-- Ð¶ÔØ¸¶·ÑÐÝÏÐ¶¯×÷
--************************************************
function Action_Uninstall_Click()
	
	if (g_curPage < MIX_DOUBLE_ACTION_PAGE) or (g_curPage > MAX_PAGE_NUMBER) then
		return
	end
	
	-- ¼ì²â°²È«Ê±¼ä
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("An toàn th¶i gian Nµi không th¬ tháo dÞ hßu nhàn ðµng tác Bao.")     						-- "An toàn th¶i gian Nµi không th¬ tháo dÞ hßu nhàn ðµng tác Bao"
		return
	end
	
	-- ¶þ¼¶ÃÜÂë µç»°ÃÜ±£¼ì²é
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	
	-- Ð¶ÔØ
	DataPool : UnInstall_RMB_ChatAction(g_curPage - MIX_DOUBLE_ACTION_PAGE, 0)

end
