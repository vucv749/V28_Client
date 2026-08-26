local g_Frame_UnifiedPosition
local g_Index = 1
local g_BagPos = 0
local g_ActionItem = {}
local g_ActionItemText = {}
local g_Object1Select = {}
local g_Item_List = {10,15,17,18}


--=========
-- PreLoad()
--=========
function JiangHuZhi_FreeChoices_PreLoad()

	this:RegisterEvent("UI_COMMAND")--??or????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function JiangHuZhi_FreeChoices_OnLoad()

	g_Frame_UnifiedPosition = JiangHuZhi_FreeChoices_Frame:GetProperty("UnifiedPosition")

	g_ActionItem[1] = JiangHuZhi_FreeChoices_Item1
	g_ActionItem[2] = JiangHuZhi_FreeChoices_Item2
	g_ActionItem[3] = JiangHuZhi_FreeChoices_Item3
	g_ActionItem[4] = JiangHuZhi_FreeChoices_Item4


	g_ActionItemText[1] = JiangHuZhi_FreeChoices_ItemInfo1_Text
	g_ActionItemText[2] = JiangHuZhi_FreeChoices_ItemInfo2_Text
	g_ActionItemText[3] = JiangHuZhi_FreeChoices_ItemInfo3_Text
	g_ActionItemText[4] = JiangHuZhi_FreeChoices_ItemInfo4_Text

	g_Object1Select[1] = JiangHuZhi_FreeChoices_Item1_Object1Select
	g_Object1Select[2] = JiangHuZhi_FreeChoices_Item2_Object1Select
	g_Object1Select[3] = JiangHuZhi_FreeChoices_Item3_Object1Select
	g_Object1Select[4] = JiangHuZhi_FreeChoices_Item4_Object1Select

	JiangHuZhi_FreeChoices_ConfirmBtn:Hide()
end

--=========
-- Event
--=========
function JiangHuZhi_FreeChoices_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99883102 ) then
		--∑÷“≥
		local isShowButton = Get_XParam_INT( 0 )
		local isClose = Get_XParam_INT( 1 )
		g_BagPos = Get_XParam_INT( 2 )
	
		if isClose == 1 and this:IsVisible() then
			this:Hide()
			return
		end

		JiangHuZhi_FreeChoices_SetFrame(isShowButton)

	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		JiangHuZhi_FreeChoices_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		JiangHuZhi_FreeChoices_On_ResetPos()
    end

end


function JiangHuZhi_FreeChoices_SetFrame(isShowButton)

	if isShowButton == 1 then
		JiangHuZhi_FreeChoices_ConfirmBtn:Show()
	end

	for i = 1 , 4 do
		local itemid, itemnum, itemname = Lua_GetZXGiftInfo(g_Item_List[i])
		if g_Item_List[i] ~= nil and g_Item_List[i] >= 0 then
			local theAction = DataPool:CreateActionItemForShow(itemid, 1)
			if (theAction:GetID() ~= 0) then
				g_ActionItem[i]:SetActionItem(theAction:GetID())
				g_ActionItemText[i]:SetText(itemname)
				g_Object1Select[i]:Hide()
			else
				g_ActionItem[i]:SetActionItem(-1)
				g_Object1Select[i]:Hide()
			end
		else
			g_ActionItem[i]:SetActionItem(-1)
			g_Object1Select[i]:Hide()
		end
	end

	this:Show()
end




--=========
--÷ÿ÷√
--=========
function JiangHuZhi_FreeChoices_On_ResetPos()
	JiangHuZhi_FreeChoices_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
--πÿ±†
--=========
function  JiangHuZhi_FreeChoices_CloseShop()

	g_Index = 1

	for i = 1 , 4 do
		g_ActionItem[i]:SetActionItem(-1)
		g_Object1Select[i]:Hide()
	end

	JiangHuZhi_FreeChoices_ConfirmBtn:Hide()

	this:Hide()
end


function  JiangHuZhi_FreeChoices_ItemClicked(index)

	g_Object1Select[g_Index]:Hide()
	g_Index = index
	g_Object1Select[index]:Show()



end


function  JiangHuZhi_FreeChoices_SelectClicked()

	if DataPool:Lua_IsMissionComplete(2269) ~= 1 then
		PushDebugMessage("#{QEYD_240402_111}")
		return
	end

	if Player:GetData("LEVEL") < 30 then
		PushDebugMessage("#{QEYD_240402_110}")
		return
	end

	local itemid, itemnum, itemname = Lua_GetZXGiftInfo(g_Item_List[g_Index])
	PushEvent("UI_COMMAND", 99883104, g_Index,g_BagPos,itemname)
end
