-- !!!reloadscript =MonthPVP_DaoJuBao
local m_Frame_UnifiedXPosition
local m_Frame_UnifiedYPosition

-- 界面控件
local g_item_list = {}
local g_item_limit_list = {
	38003204,
	38003206,
	38003393,
	38003203,
	38003205,
	38003207,
}

--预加载函数，可以而且只能在这里注册脚本关心的事件
function MonthPVP_DaoJuBao_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");

	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
end

--加载窗口的时候调用的函数，加载窗口时调用一次
function MonthPVP_DaoJuBao_OnLoad()
	-- 保存界面的默认相对位置
	m_Frame_UnifiedXPosition	= MonthPVP_DaoJuBao_Frame:GetProperty("UnifiedXPosition");
	m_Frame_UnifiedYPosition	= MonthPVP_DaoJuBao_Frame:GetProperty("UnifiedYPosition");

	g_item_list = {
		MonthPVP_DaoJuBao_Equip_Item1,
		MonthPVP_DaoJuBao_Equip_Item2,
		MonthPVP_DaoJuBao_Equip_Item3,
		MonthPVP_DaoJuBao_Equip_Item4,
		MonthPVP_DaoJuBao_Equip_Item5,
		MonthPVP_DaoJuBao_Equip_Item6,
	}

end

--================================================
-- 恢复界面的默认相对位置
--================================================
function MonthPVP_DaoJuBao_ResetPos()
	MonthPVP_DaoJuBao_Frame:SetProperty("UnifiedXPosition", m_Frame_UnifiedXPosition);
	MonthPVP_DaoJuBao_Frame:SetProperty("UnifiedYPosition", m_Frame_UnifiedYPosition);
end


--响应事件的函数，当注册的事件发生时会调用的函数
function MonthPVP_DaoJuBao_OnEvent(event)
	if( event == "UI_COMMAND" and tonumber(arg0) == 99959301) then
		
		if (this:IsVisible()) then
			MonthPVP_DaoJuBao_Update()
			return
		end

		if (IsWindowShow("MonthPVP_DaoJuBaoMini")) then
			this:Hide()
			return
		else
			MonthPVP_DaoJuBao_Show()
			MonthPVP_DaoJuBao_Update()
		end
	elseif(event == "OPEN_WINDOW") then
		if( arg0 == "MonthPVP_DaoJuBao") then
			MonthPVP_DaoJuBao_Show()
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "MonthPVP_DaoJuBao") then
			MonthPVP_DaoJuBao_HideByMe()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" ) then
		if (this:IsVisible()) then
			MonthPVP_DaoJuBao_Update()
			return
		end

		if (IsWindowShow("MonthPVP_DaoJuBaoMini")) then
			this:Hide()
			return
		else
			MonthPVP_DaoJuBao_Show()
			MonthPVP_DaoJuBao_Update()
		end
	elseif event=="HIDE_ON_SCENE_TRANSED" or event=="SCENE_TRANSED" or event=="PLAYER_LEAVE_WORLD" then
		MonthPVP_DaoJuBao_HideByMe()
	end

	if this:IsVisible() then
        if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
			MonthPVP_DaoJuBao_ResetPos()
        end
	end
end

--显示UI
function MonthPVP_DaoJuBao_Show()
	if IsWindowShow("MonthPVP_DaoJuBaoMini") == true then
		CloseWindow("MonthPVP_DaoJuBaoMini", true)
	end
	this:Show()
end

--ITEM UI
function MonthPVP_DaoJuBao_Update()
	for _, ui in (g_item_list or {}) do
		ui:SetActionItem(-1)
		ui:Enable()
	end

	local index = 0
	local num = DataPool:GetBaseBag_Num()
	for i=1, num do
		local theAction,bLocked,bProtect,nElapsedTime = PlayerPackage:EnumItem("base", i-1)
		if theAction ~= nil then
			local itemIndex = theAction:GetDefineID()
			for _, itemid in (g_item_limit_list or {}) do
				if itemIndex == itemid then
					index = index + 1
					local actbtn = g_item_list[index]
					if actbtn == nil then
						break
					end

					actbtn:Show()
					actbtn:SetProperty("BackImage", "")
					if theAction:GetID() ~= 0 then
						actbtn:SetActionItem(theAction:GetID())
					end

					if bLocked == 1 then
						actbtn:Disable()
					end
					break
				end
			end
		end
	end
end

--隐藏UI
function MonthPVP_DaoJuBao_HideByMe()
	this:Hide()
end

--MiniUI
function MonthPVP_DaoJuBao_Hide_OnClick()
	OpenWindow("MonthPVP_DaoJuBaoMini")
	this:Hide()
end

function MonthPVP_DaoJuBao_Equip_Item_Click(index, flag)
	local actbtn = g_item_list[index]
	if actbtn == nil then
		return
	end

	if flag > 0 then
		actbtn:DoSubAction()
	else
		actbtn:DoAction()
	end
end