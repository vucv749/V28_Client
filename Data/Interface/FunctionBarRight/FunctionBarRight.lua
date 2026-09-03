
local RIGHTBAR_BUTTONS = {};
local RIGHTBAR_BUTTON_NUM = 9;


function FunctionBarRight_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("ACTION_UPDATE");
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR3");
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");
end

function FunctionBarRight_OnLoad()
	RIGHTBAR_BUTTONS[41] = FunctionBarRight_Button_Action1;
	RIGHTBAR_BUTTONS[42] = FunctionBarRight_Button_Action2;
	RIGHTBAR_BUTTONS[43] = FunctionBarRight_Button_Action3;
	RIGHTBAR_BUTTONS[44] = FunctionBarRight_Button_Action4;
	RIGHTBAR_BUTTONS[45] = FunctionBarRight_Button_Action5;
	RIGHTBAR_BUTTONS[46] = FunctionBarRight_Button_Action6;
	RIGHTBAR_BUTTONS[47] = FunctionBarRight_Button_Action7;
	RIGHTBAR_BUTTONS[48] = FunctionBarRight_Button_Action8;
	RIGHTBAR_BUTTONS[49] = FunctionBarRight_Button_Action9;
end


-- OnEvent
function FunctionBarRight_OnEvent(event)
	if ZBS:IsViewerWatching() > 0 or GMVisible:LuaFnGetViewType() > 0 then
		this:Hide()
		return
	end
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		-- ÏÔÊ¾¾­Ñé
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		if( tonumber(arg1) > 40 and tonumber(arg1) <50 )  then
			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			local nIndex = tonumber(arg1) ;

			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			RIGHTBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			RIGHTBAR_BUTTONS[nIndex] : Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							RIGHTBAR_BUTTONS[nIndex] : Bright();
					else
							RIGHTBAR_BUTTONS[nIndex] : Gloom();
					end
						
				end
				
			end
			
		end
	elseif( event == "ACTION_UPDATE" ) then
		FunctionBarRight_ActionUpdate();
-- Ð¶ÔØË«ÈËÐÝÏÐ¶¯×÷°üÊ±£¬Í¬Ê±É¾³ýÍÏ¶¯µ½FunctionBarRightÉÏµÄ°´Å¥ÐÅÏ¢	
	elseif (event == "UNINSTALL_CHAT_ACTION_BAR3") then
		FunctionBarRight_UnInstallChatActionButton(tonumber(arg0));

	-- ÇåÀí¹ýÆÚµÄË«ÈËÐÝÏÐ¶¯×÷°üÔÚÖ÷²Ëµ¥ÉÏµÄ°´Å¥
	elseif (event == "CLEAR_CHAT_ACTION_BAR") and (tostring(arg0)== "FunctionBarRight") then
		FunctionBarRight_ClearChatActionButton(tonumber(arg1), tonumber(arg2), tonumber(arg3));

	end
	
	end
function FunctionBarRight_ActionUpdate()
	for j=1,9 do
		RIGHTBAR_BUTTONS[j+40]:SetNewFlash();
	end
end

function FunctionBarRight_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		
		RIGHTBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("Các hÕ không ðßþc làm nhß v§y.")
		return;
	end
end

function FunctionBarRight_UnInstallChatActionButton(index)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, RIGHTBAR_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = RIGHTBAR_BUTTONS[i+40]:GetActionItem();
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
						RIGHTBAR_BUTTONS[i+40] : SetActionItem(-1);							-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+39);			-- ??MainMenuBar????ActionItem????(????DragName)
					end
				end
		  end
		end
	end	

	-- ³¹µ×Ð¶ÔØ¸Ã¶¯×÷°ü
	DataPool : UnInstall_RMB_ChatAction(index , 4)

end

function FunctionBarRight_ClearChatActionButton(index, nID, nData)

	if (index < 0) or (index > 3) then
		return
	end

	-- µÃµ½ÒªÐ¶ÔØµÄ¶¯×÷°üÐÅÏ¢
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	--PushDebugMessage ("FunctionBarRight : actionID = "..actionID..", actionCount = "..actionCount..", actionMinIndex = "..actionMinIndex)
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- Çå¿ ¿ì½ÝÀ¸ÉÏÃ¿Ò»¸ö°üº¬¶¯×÷°ü°´Å¥µÄÐÅÏ¢
		for i = 1, RIGHTBAR_BUTTON_NUM do
			-- µÃµ½µ±Ç°ActionItemÔÚActionItem×Ü±íÖÐµÄ±àºÅ
		  tmpItem = RIGHTBAR_BUTTONS[i+40]:GetActionItem();
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
						RIGHTBAR_BUTTONS[i+40] : SetActionItem(-1);							-- ??????ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+39);			-- ??MainMenuBar????ActionItem????(????DragName)
					end
				end
		  end
		end
	end
	
	-- ¼ÌÐøÇåÀí FunctionBarRight ½çÃæÉÏµÄ¶¯×÷°ü°´Å¥
	DataPool : Clear_ChatAction_Bar("MainMenuBar_4", index, nID, nData);


end
