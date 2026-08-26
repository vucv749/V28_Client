
local UPBAR_2_BUTTONS = {}
local COMBOSKILL_4_FLASH_JUNIOR = {}
local COMBOSKILL_4_FLASH_SENIOR = {}
local UPBAR_2_BUTTON_NUM = 10

function MainMenuBar_4_PreLoad()
	this:RegisterEvent("CHANGE_BAR")
	this:RegisterEvent("ACTION_UPDATE")
	this:RegisterEvent("OPEN_UP_BAR_2")
	this:RegisterEvent("UNINSTALL_CHAT_ACTION_BAR4");
	this:RegisterEvent("CLEAR_CHAT_ACTION_BAR");
end

function MainMenuBar_4_OnLoad()	
	UPBAR_2_BUTTONS[71] = MainMenuBar_4_Button_Action1
	UPBAR_2_BUTTONS[72] = MainMenuBar_4_Button_Action2
	UPBAR_2_BUTTONS[73] = MainMenuBar_4_Button_Action3
	UPBAR_2_BUTTONS[74] = MainMenuBar_4_Button_Action4
	UPBAR_2_BUTTONS[75] = MainMenuBar_4_Button_Action5
	UPBAR_2_BUTTONS[76] = MainMenuBar_4_Button_Action6
	UPBAR_2_BUTTONS[77] = MainMenuBar_4_Button_Action7
	UPBAR_2_BUTTONS[78] = MainMenuBar_4_Button_Action8
	UPBAR_2_BUTTONS[79] = MainMenuBar_4_Button_Action9
	UPBAR_2_BUTTONS[80] = MainMenuBar_4_Button_Action10
end

function MainMenuBar_4_OnEvent(event)
	
	if event == "CHANGE_BAR" and arg0 == "main" then

		local nIndex = tonumber(arg1)
		if nIndex > 70 and nIndex < 81 then
			UPBAR_2_BUTTONS[nIndex]:SetActionItem(tonumber(arg2))
			UPBAR_2_BUTTONS[nIndex]:Bright()
			
			if arg3 ~= nil then
				local pet_num = tonumber(arg3)				
				if pet_num >= 0 and pet_num < 6 then
					if Pet:IsPresent(pet_num) and Pet:GetIsFighting(pet_num) then
						UPBAR_2_BUTTONS[nIndex]:Bright()
					else
						UPBAR_2_BUTTONS[nIndex]:Gloom()
					end
				end
			end
		end
			
	-- 卸载双人休闲动作包时，同时删除拖动到MainMenuBar_4上的按钮信息	
	elseif (event == "UNINSTALL_CHAT_ACTION_BAR4") then
		MainMenuBar_4_UnInstallChatActionButton(tonumber(arg0));

	-- 清理过期的双人休闲动作包在主菜单上的按钮
	elseif (event == "CLEAR_CHAT_ACTION_BAR") and (tostring(arg0)== "MainMenuBar_4") then
		MainMenuBar_4_ClearChatActionButton(tonumber(arg1), tonumber(arg2), tonumber(arg3));
	
	
	elseif event == "ACTION_UPDATE" then
		MainMenuBar_4_ActionUpdate()
	elseif event == "OPEN_UP_BAR_2" then
		if arg0 == "1" and arg1 == "UpBar2" then
			PushEvent("SWITCH_MENU_BUTTON", 1)
			this:Show()
		else
			PushEvent("SWITCH_MENU_BUTTON", 0)
			this:Hide()
		end
	end
	
end

function MainMenuBar_4_ActionUpdate()
	for j = 1, UPBAR_2_BUTTON_NUM do
		UPBAR_2_BUTTONS[j + 70]:SetNewFlash()
	end
end

function MainMenuBar_4_UnInstallChatActionButton(index)

	if (index < 0) or (index > 10) then
		return
	end

	-- 得到要卸载的动作包信息
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- 清空快捷栏上每一个包含动作包按钮的信息
		for i = 1, UPBAR_2_BUTTON_NUM do
			-- 得到当前ActionItem在ActionItem总表中的编号
		  tmpItem = UPBAR_2_BUTTONS[i+70]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- 遍历当前动作包中的每一个ActionItem，看看是否有和当前ActionItem的ID相等的。
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						UPBAR_2_BUTTONS[i+70] : SetActionItem(-1);				-- 取消按钮上的ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+49);			-- 删除MainMenuBar_4中保存的ActionItem对应记录（编号对应DragName）
					end
				end
		  end
		end
	end	

	-- 彻底卸载该动作包
	DataPool : UnInstall_RMB_ChatAction(index , 5)

end

function MainMenuBar_4_ClearChatActionButton(index, nID, nData)

	if (index < 0) or (index > 10) then
		return
	end

	-- 得到要卸载的动作包信息
	local actionID, actionValidDate, actionCount, actionMinIndex, actionType = DataPool : Get_RMB_ChatActionInfo(index);
	local realActionID = DataPool : Get_RMB_ChatActionRealID(actionID);
	if realActionID > 0 and actionCount > 0 and actionMinIndex > 0 and actionType > 0 then
		local tmpItem = -1
		-- 清空快捷栏上每一个包含动作包按钮的信息
		for i = 1, UPBAR_2_BUTTON_NUM do
			-- 得到当前ActionItem在ActionItem总表中的编号
		  tmpItem = UPBAR_2_BUTTONS[i+70]:GetActionItem();
		  if (tmpItem ~= -1) then
		  	-- 遍历当前动作包中的每一个ActionItem，看看是否有和当前ActionItem的ID相等的。
		  	for j = 1, actionCount do
					local theAction = nil
					if actionType == 2 then
						theAction = Talk : EnumDoubleChatMood(actionMinIndex + j - 2);
					else 
						theAction = Talk : EnumChatMood(actionMinIndex + j - 2);
					end
					if (theAction:GetID() ~= 0) and (theAction:GetID() == tmpItem) then
						UPBAR_2_BUTTONS[i+70] : SetActionItem(-1);							-- 取消按钮上的ActionItem
						DataPool : UnInstall_RMB_ChatAction_BarItem(i+49);			-- 删除MainMenuBar_4中保存的ActionItem对应记录（编号对应DragName）
					end
				end
		  end
		end
	end

	-- 设置客户端的动作包新数据
	DataPool : Set_RMB_ChatAction(index, nID, nData);

end


function MainMenuBar_4_Clicked(nIndex)
	if DataPool:IsCanDoAction() then		
		UPBAR_2_BUTTONS[nIndex]:DoAction()
	else
		PushDebugMessage("你不能这么做。")
		return
	end
end
