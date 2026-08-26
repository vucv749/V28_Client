-- 玩家血条积分UI 最小化UI
local g_unifiedposistion

function HuaShanLunJian_Score_Tiny_PreLoad()
	this:RegisterEvent("BWTROOPS_SHOW_MINI_BOX",true)
	this:RegisterEvent("BWTROOPS_COPYDATA_FULL_INFO",false)
	this:RegisterEvent("BWTROOPS_RESULT_SHOW",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HuaShanLunJian_Score_Tiny_OnLoad()
	-- 保存界面的默认相对位置
	g_unifiedposistion	= HuaShanLunJian_Score_Tiny_Frame:GetProperty("UnifiedPosition")
end

function HuaShanLunJian_Score_Tiny_OnEvent(event)

	if event == "BWTROOPS_SHOW_MINI_BOX" then
		HuaShanLunJian_Score_Tiny_OnShow()
	elseif( event == "ADJEST_UI_POS" ) then
		HuaShanLunJian_Score_Tiny_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED") then
		HuaShanLunJian_Score_Tiny_ResetPos()
	elseif( event == "HIDE_ON_SCENE_TRANSED" ) then
		this:Hide()
	elseif( event == "BWTROOPS_COPYDATA_FULL_INFO" ) then
		this:Hide()
	elseif( event == "BWTROOPS_RESULT_SHOW" ) then
		this:Hide()
	end
end

function HuaShanLunJian_Score_Tiny_OnShow()	
	this:Show()
end

function HuaShanLunJian_Score_Tiny_ResetPos()
	HuaShanLunJian_Score_Tiny_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

function HuaShanLunJian_Score_Tiny_OnShowNormalUI()
	this:Hide()
	PushEvent("BWTROOPS_COPYDATA_FULL_INFO")
end
