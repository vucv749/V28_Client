
local MAIN_2_BUTTONS = {};
local MAIN_2_BUTTON_NUM = 10;

local MAIN_2_ANIMATES = {};
local MAIN_2_ANIMATE_NUM = 10;

function MainMenuBar_2_PreLoad()
	this:RegisterEvent("OPEN_MENUBAR_2");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("ACTION_UPDATE");
	
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR2");
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");
end

function MainMenuBar_2_OnLoad()
	MAIN_2_BUTTONS[31] = MainMenuBar_2_Button_Action1
	MAIN_2_BUTTONS[32] = MainMenuBar_2_Button_Action2
	MAIN_2_BUTTONS[33] = MainMenuBar_2_Button_Action3
	MAIN_2_BUTTONS[34] = MainMenuBar_2_Button_Action4
	MAIN_2_BUTTONS[35] = MainMenuBar_2_Button_Action5
	MAIN_2_BUTTONS[36] = MainMenuBar_2_Button_Action6
	MAIN_2_BUTTONS[37] = MainMenuBar_2_Button_Action7
	MAIN_2_BUTTONS[38] = MainMenuBar_2_Button_Action8
	MAIN_2_BUTTONS[39] = MainMenuBar_2_Button_Action9
	MAIN_2_BUTTONS[40] = MainMenuBar_2_Button_Action10

	MAIN_2_ANIMATES[31] = MainMenuBar_2_Button_Action1_Mask
	MAIN_2_ANIMATES[32] = MainMenuBar_2_Button_Action2_Mask
	MAIN_2_ANIMATES[33] = MainMenuBar_2_Button_Action3_Mask
	MAIN_2_ANIMATES[34] = MainMenuBar_2_Button_Action4_Mask
	MAIN_2_ANIMATES[35] = MainMenuBar_2_Button_Action5_Mask
	MAIN_2_ANIMATES[36] = MainMenuBar_2_Button_Action6_Mask
	MAIN_2_ANIMATES[37] = MainMenuBar_2_Button_Action7_Mask
	MAIN_2_ANIMATES[38] = MainMenuBar_2_Button_Action8_Mask
	MAIN_2_ANIMATES[39] = MainMenuBar_2_Button_Action9_Mask
	MAIN_2_ANIMATES[40] = MainMenuBar_2_Button_Action10_Mask
end


-- OnEvent
function MainMenuBar_2_OnEvent(event)
	if ( event == "OPEN_MENUBAR_2" ) then

		AxTrace(0,0,"OPEN_MENUBAR_2" .. arg0)

		if arg0 == "1" then
			this:Show()
			MainMenuBar_2_PlayAnimate()
		else
			this:Hide()
		end
		-- ÏÔÊ¾¾­Ñé
	elseif( event == "CHANGE_BAR" and arg0 == "main") then

		AxTrace(0,0,"arg1 =" .. tostring(arg1))

		if( tonumber(arg1) >= 31 and tonumber(arg1) <41 )  then
			local nIndex = tonumber(arg1) ;

			MAIN_2_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			MAIN_2_BUTTONS[nIndex]:Bright();

			if arg3~=nil then

				local pet_num = tonumber(arg3);

				if pet_num >= 0 and pet_num < 6 then

					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)

					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							MAIN_2_BUTTONS[nIndex]:Bright();
					else
							MAIN_2_BUTTONS[nIndex]:Gloom();
					end
				end
			end
		end

	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		MainMenuBar_2_AdjustMoveCtl(arg0, arg1);
	elseif( event == "ACTION_UPDATE" ) then
		MainMenuBar_2_NewSkillStudy();
		
	-- Ð¶ÔØË«ÈËÐÝÏÐ¶¯×÷°üÊ±£¬Í¬Ê±É¾³ýÍÏ¶¯µ½MainMenuBar_2ÉÏµÄ°´Å¥ÐÅÏ¢
	elseif (event == "UNINSTALL_CHAT_ACTION_BAR2") then
		MainMenuBar_2_UnInstallChatActionButton(tonumber(arg0));

	-- ÇåÀí¹ýÆÚµÄË«ÈËÐÝÏÐ¶¯×÷°üÔÚÖ÷²Ëµ¥ÉÏµÄ°´Å¥
	elseif (event == "CLEAR_CHAT_ACTION_BAR") and (tostring(arg0)== "MainMenuBar_2") then
		MainMenuBar_2_ClearChatActionButton(tonumber(arg1), tonumber(arg2), tonumber(arg3));

	end

end

function MainMenuBar_2_NewSkillStudy()
	for j=1,10 do
		MAIN_2_BUTTONS[j+30]:SetNewFlash();
	end
end

function MainMenuBar_2_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		MAIN_2_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ðßþc làm nhß v§y.")
		return;
	end
end

function MainMenuBar_2_AdjustMoveCtl( screenWidth, screenHeight )
	--local currWidth = MainMenuBar_2_Frame:GetProperty("AbsoluteWidth");
	--if(tonumber(screenWidth) < 1080) then
		--MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	--else
		--MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.0,546}"); --297+207
	--end
end

function MainMenuBar_2_PlayAnimate()
	for j=1,10 do
		MAIN_2_ANIMATES[j+30]:Show();
		MAIN_2_ANIMATES[j+30]:Play(true);
	end
end


function MainMenuBar_2_UnInstallChatActionButton(index)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, MAIN_2_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = MAIN_2_BUTTONS[i+30]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						MAIN_2_BUTTONS[i+30] : SetActionItem(-1);								-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+29);			-- ??MainMenuBar????ActionItem????(????DragName)				
					end
				end
		  end
		end
	end	

	-- ½Ó×ÅÉ¾³ý FunctionBarRight ½çÃæÉÏµÄ¿Ø¼þ
	DataPool : UnInstall_RMB_ChatAction(index , 3)

end

function MainMenuBar_2_ClearChatActionButton(index, nID, nData)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	--PushDebugMessage ("MainMenuBar_2 : actionID = "..actionID..", actionCount = "..actionCount..", actionMinIndex = "..actionMinIndex)
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID)	
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, MAIN_2_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = MAIN_2_BUTTONS[i+30]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- ±éÀúµ±Ç°¶¯×÷°üÖÐµÄÃ¿Ò»¸öActionItem£¬¿´¿´ÊÇ·ñÓÐºÍµ±Ç°ActionItemµÄIDÏàµÈµÄ¡£
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						MAIN_2_BUTTONS[i+30] : SetActionItem(-1);								-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+29);			-- ??MainMenuBar????ActionItem????(????DragName)				
					end
				end
		  end
		end
	end

	-- ¼ÌÐøÇåÀí FunctionBarRight ½çÃæÉÏµÄ¶¯×÷°ü°´Å¥
	DataPool : Clear_ChatAction_Bar("FunctionBarRight", index, nID, nData);

end
