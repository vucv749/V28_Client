
local g_EquipBaoshiyi_Frame_UnifiedPosition;
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local GEMSOURCE_BUTTONS = {}
local GEMDEST_BUTTONS = {}
local EQUIPITEM_SOURCE = -1
local EQUIPITEM_DEST = -1
-- 装备允许镶嵌的宝石类型表
local g_EquipGemTable = {}
local bConfirm = -1
local g_bClick = -1;
function EquipBaoshiyi_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_BAOSHIYI")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("UNIT_MONEY",false)
	this:RegisterEvent("MONEYJZ_CHANGE",false)
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("BAOSHIYI_CLEAR")
end

function EquipBaoshiyi_OnLoad()

	g_EquipBaoshiyi_Frame_UnifiedPosition=EquipBaoshiyi_Frame:GetProperty("UnifiedPosition");

	EQUIPITEM_SOURCE = -1
	EQUIPITEM_DEST = -1

	GEMSOURCE_BUTTONS[1] = EquipBaoshiyi_Special_Button
	GEMSOURCE_BUTTONS[2] = EquipBaoshiyi_Special_Button1
	GEMSOURCE_BUTTONS[3] = EquipBaoshiyi_Special_Button2
	GEMSOURCE_BUTTONS[4] = EquipBaoshiyi_Special_Button3
	GEMSOURCE_BUTTONS[5] = EquipBaoshiyi_Special_Button4

	GEMDEST_BUTTONS[1] = EquipBaoshiyi_Special_Button5
	GEMDEST_BUTTONS[2] = EquipBaoshiyi_Special_Button6
	GEMDEST_BUTTONS[3] = EquipBaoshiyi_Special_Button7
	GEMDEST_BUTTONS[4] = EquipBaoshiyi_Special_Button8
	GEMDEST_BUTTONS[5] = EquipBaoshiyi_Special_Button9

	EquipBaoshiyi_zhuanyi : Enable()
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	g_EquipGemTable[0] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[1] = { 11, 12, 13, 14 }
	g_EquipGemTable[2] = { 11, 12, 13, 14 }
	g_EquipGemTable[3] = { 11, 12, 13, 14 }
	g_EquipGemTable[4] = { 11, 12, 13, 14 }
	g_EquipGemTable[5] = { 11, 12, 13, 14 }
	g_EquipGemTable[6] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[7] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	g_EquipGemTable[11] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[12] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[13] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[14] = { 1, 2, 3, 4, 21 }
	g_EquipGemTable[15] = { 11, 12, 13, 14 }
	g_EquipGemTable[17] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	g_EquipGemTable[18] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	g_EquipGemTable[37] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }

end

function EquipBaoshiyi_OnEvent(event)
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			EquipBaoshiyi_Cancel_Clicked()
		end
	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 20110509  ) then
		EquipBaoshiyi_Close()
		this:Show()
		EquipBaoshiyi_OnShown()
		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			return
		end
		BeginCareObject_EquipBaoshiyi(objCared)
	elseif ( event == "UPDATE_BAOSHIYI" and this:IsVisible() ) then
		EquipBaoshiyi_Update(arg0, arg1)
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		return
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif (event == "ADJEST_UI_POS" ) then
		EquipBaoshiyi_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		EquipBaoshiyi_Frame_On_ResetPos()
	elseif (event == "BAOSHIYI_CLEAR") then
		EquipBaoshiyi_Clear()
	end
end

function EquipBaoshiyi_OnShown()
	EquipBaoshiyi_Clear();
	EquipBaoshiyi_zhuanyi : Enable()
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	g_bClick = 0
	EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
end

function EquipBaoshiyi_Close()
	EquipBaoshiyi_Clear()
	PushEvent("DISPLACE_CLOSE_MSGBOX")
	this:Hide()
end

function EquipBaoshiyi_OnHidden()
	StopCareObject_EquipBaoshiyi(objCared)
	EquipBaoshiyi_Close()
end

function EquipBaoshiyi_Frame_On_ResetPos()
	EquipBaoshiyi_Frame:SetProperty("UnifiedPosition", g_EquipBaoshiyi_Frame_UnifiedPosition);
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_EquipBaoshiyi(objCaredId)
	this:CareObject(objCaredId, 1, "EquipBaoshiyi")
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_EquipBaoshiyi(objCaredId)
	this:CareObject(objCaredId, 0, "EquipBaoshiyi");
end

function EquipBaoshiyi_Clear()
	EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(0))
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	if (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
	end
	for i=2,5 do 
		GEMSOURCE_BUTTONS[i]:SetActionItem(-1);
	end
	if (EQUIPITEM_DEST ~= -1) then
		GEMDEST_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
		EQUIPITEM_DEST = -1
	end
	for i=2,5 do 
		GEMDEST_BUTTONS[i]:SetActionItem(-1);
	end
	bConfirm = -1
end

--点击关闭界面的按钮
function EquipBaoshiyi_Cancel_Clicked()
	EquipBaoshiyi_Close()
	return
end

--点击确定宝石转移的按钮
function EquipBaoshiyi_Buttons_Clicked()
	--暂时没有安全时间和密保的api
	if EquipBaoshiyi_Check() ~= 1 then
		return
	end
	if bConfirm == -1 then
		local equipTableIndex = PlayerPackage : GetItemTableIndex( EQUIPITEM_DEST )
		if IsUnbindChongLouEquip(equipTableIndex) == 1 then
			PushEvent("DISPLACEGEM_CONFIRM", 26,1)--????????
		else
			PushEvent("DISPLACEGEM_CONFIRM", 26,0)--????????
		end
		bConfirm = 1
	elseif bConfirm == 1 then
		LifeAbility : Do_Displace(EQUIPITEM_SOURCE,EQUIPITEM_DEST)
		bConfirm = -1
	end
end


--点击预览按钮 或者恢复按钮都走这个方法
function EquipBaoshiyi_Zhuanyi_Clicked()
	if g_bClick ~= 1 then
		if EquipBaoshiyi_Check() ~= 1 then
			return
		end
		for i=1,4 do
			LifeAbility : Baoshiyi_SetGemByIndex(i-1, i-1, 0)
		end
		EquipBaoshiyi_UpdateButton()
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_06}")
		g_bClick = 1
	else
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
		EquipBaoshiyi_Update(1, EQUIPITEM_SOURCE)
		EquipBaoshiyi_Update(2, EQUIPITEM_DEST)
		g_bClick = 0
	end

end

--右键点击源装备和目标装备按钮
function EquipBaoshiyi_Resume_Equip(nIndex)
	if nIndex < 1 or nIndex > 3 then
		return
	end
	EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(0))
	if nIndex == 1 and (EQUIPITEM_SOURCE ~= -1) then
		GEMSOURCE_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0);
		EQUIPITEM_SOURCE = -1
		for i=2,5 do 
			GEMSOURCE_BUTTONS[i]:SetActionItem(-1);
		end
		if EQUIPITEM_DEST ~= -1 then
			EquipBaoshiyi_Update(2, EQUIPITEM_DEST)
		end
		g_bClick = 0
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	elseif nIndex == 2 and (EQUIPITEM_DEST ~= -1) then
		GEMDEST_BUTTONS[1]:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
		EQUIPITEM_DEST = -1
		for i=2,5 do 
			GEMDEST_BUTTONS[i]:SetActionItem(-1);
		end
		if EQUIPITEM_SOURCE ~= -1 then
			EquipBaoshiyi_Update(1, EQUIPITEM_SOURCE)
		end
		g_bClick = 0
		EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	end
end

function EquipBaoshiyi_UpdateButton()
	local ActionID,nItemID
	for i=1,4 do
		nItemID = LifeAbility : GetSplitGem_Gem (i-1);
		if nItemID ~= -1 then
			ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
			if ActionID and ActionID ~= -1 then
				GEMSOURCE_BUTTONS[i+1] : SetActionItem(ActionID);
			end
		else
			GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
			GEMSOURCE_BUTTONS[i+1] : Gloom();
		end
	end
	for i=1,4 do
		nItemID = LifeAbility : Baoshiyi_Gem(i-1);
		if nItemID ~= -1 then
			ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
			if ActionID and ActionID ~= -1 then
				GEMDEST_BUTTONS[i+1] : SetActionItem(ActionID);
				GEMDEST_BUTTONS[i+1] : Bright();
			end
		else
			GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
			GEMDEST_BUTTONS[i+1] : Gloom();
		end
	end
end

function EquipBaoshiyi_Check()
	if EQUIPITEM_SOURCE == -1 then
		PushDebugMessage("#{BSQKY_20110506_04}")
		return 0
	end
	if EQUIPITEM_DEST == -1 then
		PushDebugMessage("#{BSQKY_20110506_08}")
		return 0
	end
	local equippointSrc = LifeAbility : Get_Equip_Point(EQUIPITEM_SOURCE);
	if (not g_EquipGemTable[equippointSrc]) or (equippointSrc == 16) then
		PushDebugMessage("#{BSQKY_20110506_30}")
		return 0
	end
	local equippointDst = LifeAbility : Get_Equip_Point(EQUIPITEM_DEST);
	if (not g_EquipGemTable[equippointDst]) or (equippointDst == 16) then
		PushDebugMessage("#{BSQKY_20110506_30}")
		return 0
	end
	local gem_count = LifeAbility : GetEquip_GemCount(EQUIPITEM_SOURCE);
	if gem_count > 4 then
		return 0
	end
	local hole_count = LifeAbility : GetEquip_HoleCount(EQUIPITEM_DEST)
	local gemdest_count = LifeAbility : GetEquip_GemCount(EQUIPITEM_DEST)
	local nItemIDSrc = -1
	local nItemIDDest = -1
	for i=1,4 do
		nItemIDSrc = LifeAbility : GetSplitGem_Gem (i-1)
		nItemIDDest = LifeAbility : Baoshiyi_Gem (i-1)
		if (nItemIDSrc ~= -1) then
			if (i > hole_count) then
				PushDebugMessage("#{BSQKY_20110506_16}")
				return 0
			end
			if nItemIDDest ~= -1 then
				PushDebugMessage("#{BSQKY_20110506_17}")
				return 0
			end
			-- 这里需要调整一下, 只需要判断EquipSrc的前三个孔和EquipDest的前三个孔是否有重复
			local gemType = LifeAbility : Baoshiyi_GetGemType(EQUIPITEM_SOURCE, i-1)
			if ( i < 4 ) then
				local cando = LifeAbility : Can_Enchase(EQUIPITEM_DEST, i - 1);--nItemIDSrc
				if cando == false then
					PushDebugMessage("#{BSQKY_20110506_18}")
					return 0
				end
				-- 得考虑目标装备实际打孔数量, 可能没有打够前3个
				local nMaxSlot = math.min( 3, hole_count );
				for k=1, nMaxSlot do
					local gemTypeDst = LifeAbility : Baoshiyi_GetGemType(EQUIPITEM_DEST, k-1)
					if gemTypeDst ~= -1 and gemTypeDst == gemType then
						PushDebugMessage("#{BSQKY_20110506_19}")
						return 0
					end
				end
				local passFlag = 0
				for i, gt in g_EquipGemTable[equippointDst] do
					if gt == gemType then
						passFlag = 1
						break
					end
				end
				if passFlag == 0 then
					PushDebugMessage("#{BSQKY_20110506_18}")
					return 0
				end

			end
		end
	end

	if hole_count - gemdest_count < gem_count then--?????????????????????????????????
		PushDebugMessage("#{BSQKY_20110506_16}")
		return 0
	end
	return 1
end



function EquipBaoshiyi_Update(UI_index, Item_index)
	
	local i_index = tonumber(Item_index)
	local ui_index = tonumber(UI_index)
	if ui_index < 0 or ui_index > 2 then
		return
	end
	local theAction = EnumAction(i_index, "packageitem")

	EquipBaoshiyi_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	EquipBaoshiyi_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	local uiPos = -1;
	local gem_count = 0
	gem_count = LifeAbility : GetEquip_GemCount(i_index);
	if gem_count > 4 or gem_count == -1 then
		return
	end
	bConfirm = -1
	g_bClick = 0
	EquipBaoshiyi_zhuanyi : SetText("#{BSQKY_20110506_05}")
	--时装不能操作
	local equippoint = LifeAbility : Get_Equip_Point(i_index);
	if (not g_EquipGemTable[equippoint]) or (equippoint == 16) then
		PushDebugMessage("#{BSQKY_20110506_30}")
		return
	end
	if theAction:GetID() ~= 0 then
		-- PushDebugMessage("xxx:"..tostring(ui_index))
		if ui_index == 0 then
			if EQUIPITEM_SOURCE == -1 then
				if gem_count < 1 then
					PushDebugMessage("#{BSQKY_20110506_13}")
					return
				end
				GEMSOURCE_BUTTONS[1]:SetActionItem(theAction:GetID())
				LifeAbility : Lock_Packet_Item(i_index,1)
				EQUIPITEM_SOURCE = i_index
				uiPos = 1
			else
				if EQUIPITEM_DEST ~= -1 then
					LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0);
				end
				GEMDEST_BUTTONS[1]:SetActionItem(theAction:GetID())
				LifeAbility : Lock_Packet_Item(i_index,1)
				EQUIPITEM_DEST = i_index
				uiPos = 2
			end
		elseif ui_index == 1 then
			if gem_count < 1 then
				PushDebugMessage("#{BSQKY_20110506_13}")
				return
			end
			if EQUIPITEM_SOURCE ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIPITEM_SOURCE,0)
			end
			GEMSOURCE_BUTTONS[1]:SetActionItem(theAction:GetID())
			LifeAbility : Lock_Packet_Item(i_index,1)
			EQUIPITEM_SOURCE = i_index
			uiPos = 1
		elseif ui_index == 2 then
			if EQUIPITEM_DEST ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIPITEM_DEST,0)
			end
			GEMDEST_BUTTONS[1]:SetActionItem(theAction:GetID())
			LifeAbility : Lock_Packet_Item(i_index,1)
			EQUIPITEM_DEST = i_index
			uiPos = 2
		end

		EquipBaoshiyi_NeedMoney:SetProperty("MoneyNumber", tostring(100000))

		if uiPos == 1 then--?????????????????
			if not LifeAbility:SplitGem_Update(i_index) then
				for i=1,4 do
					GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
					GEMSOURCE_BUTTONS[i+1] : Gloom()
				end
			else
				local ActionID,nItemID
				for i=1,4 do
					nItemID = LifeAbility : GetSplitGem_Gem (i-1);
					
					if nItemID ~= -1 then
						-- PushDebugMessage("nItemID:"..tostring(nItemID))
						ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID)
					
						GEMSOURCE_BUTTONS[i+1] : SetActionItem(ActionID)
					else
						GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
						GEMSOURCE_BUTTONS[i+1] : Gloom()
					end
				end
			end
			if EQUIPITEM_DEST ~= -1 then
				if not LifeAbility:Baoshiyi_Update(EQUIPITEM_DEST) then
					for i=1,4 do
						GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
						GEMDEST_BUTTONS[i+1] : Gloom();
					end
				else
					local ActionID,nItemID
					for i=1,4 do
						nItemID = LifeAbility : Baoshiyi_Gem (i-1);
						if nItemID ~= -1 then
							ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
							
							GEMDEST_BUTTONS[i+1] : SetActionItem(ActionID);
							GEMDEST_BUTTONS[i+1] : Bright();
						else
							GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
							GEMDEST_BUTTONS[i+1] : Gloom();
						end
					end
				end
			end
		elseif uiPos == 2 then--????????????????
			if not LifeAbility:Baoshiyi_Update(i_index) then
				for i=1,4 do
					GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
					GEMDEST_BUTTONS[i+1] : Gloom();
				end
			else
				local ActionID,nItemID
			
				for i=1,4 do
					nItemID = LifeAbility : Baoshiyi_Gem (i-1);
					if nItemID ~= -1 then
						
						ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
						
						GEMDEST_BUTTONS[i+1] : SetActionItem(ActionID);
						GEMDEST_BUTTONS[i+1] : Bright();
					else
						GEMDEST_BUTTONS[i+1] : SetActionItem(-1)
						GEMDEST_BUTTONS[i+1] : Gloom();
					end
				end
			end
			if EQUIPITEM_SOURCE ~= -1 then
				if not LifeAbility:SplitGem_Update(EQUIPITEM_SOURCE) then
					for i=1,4 do
						GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
						GEMSOURCE_BUTTONS[i+1] : Gloom();
					end
				else
					local ActionID,nItemID
			
					for i=1,4 do
						nItemID = LifeAbility : GetSplitGem_Gem (i-1);
						if nItemID ~= -1 then
							ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
							GEMSOURCE_BUTTONS[i+1] : SetActionItem(ActionID);
						else
							GEMSOURCE_BUTTONS[i+1] : SetActionItem(-1)
							GEMSOURCE_BUTTONS[i+1] : Gloom();
						end
					end
				end
			end
		end
	else
	end
end
