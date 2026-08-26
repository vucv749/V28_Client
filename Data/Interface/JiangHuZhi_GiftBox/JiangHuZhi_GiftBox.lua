local g_Frame_UnifiedPosition
local g_BagPos = 0

--=========
-- PreLoad()
--=========
function JiangHuZhi_GiftBox_PreLoad()

	this:RegisterEvent("UI_COMMAND")--打开or刷新界面
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("ADJEST_UI_POS")

end

--=========
-- OnLoad()
--=========
function JiangHuZhi_GiftBox_OnLoad()

	g_Frame_UnifiedPosition = JiangHuZhi_GiftBoxFrame:GetProperty("UnifiedPosition")

end

--=========
-- Event
--=========
function JiangHuZhi_GiftBox_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0)== 99883101 ) then
		local isClose = Get_XParam_INT( 1 )
		g_BagPos = Get_XParam_INT( 2 )
		if isClose == 1 and this:IsVisible() then
			this:Hide()
			return
		end
		JiangHuZhi_GiftBox_SetFrame()
	elseif event == "HIDE_ON_SCENE_TRANSED" then
        this:Hide()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		JiangHuZhi_GiftBox_On_ResetPos()
	elseif event == "ADJEST_UI_POS" then
		JiangHuZhi_GiftBox_On_ResetPos()
    end

end


function JiangHuZhi_GiftBox_SetFrame()

	local theAction = DataPool:CreateActionItemForShow(38003158, 1)
	if (theAction:GetID() ~= 0) then
		JiangHuZhi_GiftBoxGift1_Icon1:SetActionItem(theAction:GetID())
	end
	local theAction = DataPool:CreateActionItemForShow(38003158, 1)
	if (theAction:GetID() ~= 0) then
		JiangHuZhi_GiftBoxGift1_Icon2:SetActionItem(theAction:GetID())
	end

	this:Show()
end




--=========
--重置
--=========
function JiangHuZhi_GiftBox_On_ResetPos()
	JiangHuZhi_GiftBoxFrame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end

--=========
--关闭
--=========
function JiangHuZhi_GiftBoxOnClose()
	this:Hide()
end

function JiangHuZhi_GiftBox_OnHidden()
	this:Hide()
end


function JiangHuZhi_GiftBoxConfirm()


	if DataPool:Lua_IsMissionComplete(2269) ~= 1 then
		PushDebugMessage("#{QEYD_240402_111}")
		return
	end

	if Player:GetData("LEVEL") < 50 then
		PushDebugMessage("#{QEYD_240402_110}")
		return
	end

	PushEvent("UI_COMMAND", 99883105, g_BagPos)

end


function JiangHuZhi_GiftBoxPreview()

	PushEvent("UI_COMMAND", 99883106)

end