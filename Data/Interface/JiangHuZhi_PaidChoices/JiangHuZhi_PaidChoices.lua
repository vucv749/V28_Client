local g_Frame_UnifiedPosition
local g_Index = 1
local g_isShowButton = 1
local g_Type = 1
local g_BagPos = -1
local g_ActionItem = {}

--=========
-- PreLoad()
--=========
function JiangHuZhi_PaidChoices_PreLoad()

	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function JiangHuZhi_PaidChoices_OnLoad()

	g_Frame_UnifiedPosition = JiangHuZhi_PaidChoices_Frame:GetProperty("UnifiedPosition")

	JiangHuZhi_PaidChoices_ConfirmBtn:Hide()

end

--=========
-- Event
--=========
function JiangHuZhi_PaidChoices_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99883103 ) then

		local isShowButton =  Get_XParam_INT( 0 )
		local isClose = Get_XParam_INT( 1 )
		g_BagPos = Get_XParam_INT( 2 )
		if isClose == 1 and this:IsVisible() then
			this:Hide()
			return
		end

		if g_BagPos < 0 then
			this:Hide()
			return
		end

		g_Type = 1
		JiangHuZhi_PaidChoices_SetFrame(isShowButton)

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99926201 ) then

		local isShowButton =  Get_XParam_INT( 0 )
		local isClose = Get_XParam_INT( 1 )
		g_BagPos = Get_XParam_INT( 2 )
		if isClose == 1 and this:IsVisible() then
			this:Hide()
			return
		end

		if g_BagPos < 0 then
			this:Hide()
			return
		end

		g_Type = 2
		JiangHuZhi_PaidChoices_SetFrame(isShowButton)

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 99883106 ) then
		JiangHuZhi_PaidChoices_SetFrame(0)
	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		JiangHuZhi_PaidChoices_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		JiangHuZhi_PaidChoices_On_ResetPos()
    end

end


function JiangHuZhi_PaidChoices_SetFrame(isShowButton)

	if isShowButton == 1 then
		JiangHuZhi_PaidChoices_ConfirmBtn:Show()
	end

	JiangHuZhi_PaidChoices_Action_SuperList:Clear()


	for i = 1 , 32 do
		local itemid, itemnum, itemname = Lua_GetZXGiftInfo(i-1)
		if itemid ~= nil and itemid > 0 then

			local ItemBar = JiangHuZhi_PaidChoices_Action_SuperList:AddChild( "JiangHuZhi_PaidChoices_Action_SuperListItem")
			g_ActionItem[i] = ItemBar
			local item = ItemBar:GetSubItem("JiangHuZhi_PaidChoices_Item1")
			local item_text = ItemBar:GetSubItem("JiangHuZhi_PaidChoices_ItemInfo1_Text")
			local theAction = DataPool:CreateActionItemForShow(itemid, 1)
			ItemBar:GetSubItem("JiangHuZhi_PaidChoices_Item1_Object1Select"):Hide()
			if (theAction:GetID() ~= 0) then
				item:SetActionItem(theAction:GetID())
				item_text:SetText(itemname)
				item:SetEvent("Clicked", string.format("JiangHuZhi_PaidChoices_ItemClicked(%d)", i))
			end
		end
	end

	g_isShowButton = isShowButton
	this:Show()
end




--=========
--重置
--=========
function JiangHuZhi_PaidChoices_On_ResetPos()
	JiangHuZhi_PaidChoices_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
--关闭
--=========
function JiangHuZhi_PaidChoices_CloseShop()

	g_Type = 1
	g_Index = 1
	g_BagPos = -1
	for i = 1 , table.getn(g_ActionItem) do
		g_ActionItem[i]:GetSubItem("JiangHuZhi_PaidChoices_Item1"):SetActionItem(-1)
		g_ActionItem[i]:GetSubItem("JiangHuZhi_PaidChoices_ItemInfo1_Text"):SetText("")
		g_ActionItem[i]:GetSubItem("JiangHuZhi_PaidChoices_Item1_Object1Select"):Hide()
	end

	JiangHuZhi_PaidChoices_ConfirmBtn:Hide()
	this:Hide()
end



function JiangHuZhi_PaidChoices_ItemClicked(index)

	if g_isShowButton == 1 then
		g_ActionItem[g_Index]:GetSubItem("JiangHuZhi_PaidChoices_Item1_Object1Select"):Hide()
		g_Index = index
		g_ActionItem[g_Index]:GetSubItem("JiangHuZhi_PaidChoices_Item1_Object1Select"):Show()
	end

end


function JiangHuZhi_PaidChoices_SelectClicked()

	if g_isShowButton == 0 then
		return
	end

	if DataPool:Lua_IsMissionComplete(2269) ~= 1 and g_Type == 1 then
		PushDebugMessage("#{QEYD_240402_111}")
		return
	end

	if Player:GetData("LEVEL") < 30 then
		PushDebugMessage("#{QEYD_240402_110}")
		return
	end

	if g_BagPos < 0 then
		this:Hide()
		return
	end

	local itemid, itemnum, itemname = Lua_GetZXGiftInfo(g_Index-1)
	if g_Type == 1 then
		PushEvent("UI_COMMAND", 99883104, 100 + g_Index,g_BagPos,itemname)
	else
		PushEvent("UI_COMMAND", 99926202, 100 + g_Index,g_BagPos,itemname)
	end

end
