
--!!!reloadscript =Profile_Save

local g_Profile_Save_UnifiedPosition = ""

local g_Profile_Save_Button = {}
local g_Profile_Save_Action = {}

--=========
--PreLoad==
--=========
function Profile_Save_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_SHAREPLAN")
		
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
end

--=========
--OnLoad
--=========
function Profile_Save_OnLoad()

	g_Profile_Save_UnifiedPosition = Profile_Save_Frame:GetProperty("UnifiedPosition")
	
	g_Profile_Save_Button[1] = Profile_Save_SavePlan1Btn
	g_Profile_Save_Button[2] = Profile_Save_SavePlan2Btn
	g_Profile_Save_Button[3] = Profile_Save_SavePlan3Btn		
	g_Profile_Save_Button[4] = Profile_Save_SavePlan4Btn		
	g_Profile_Save_Button[5] = Profile_Save_SavePlan5Btn		
	g_Profile_Save_Button[6] = Profile_Save_SavePlan6Btn
	
	g_Profile_Save_Action[1] = Profile_Save_Item1_Icon
	g_Profile_Save_Action[2] = Profile_Save_Item2_Icon
	g_Profile_Save_Action[3] = Profile_Save_Item3_Icon
	g_Profile_Save_Action[4] = Profile_Save_Item4_Icon
	g_Profile_Save_Action[5] = Profile_Save_Item5_Icon
	g_Profile_Save_Action[6] = Profile_Save_Item6_Icon
	
end

--=========
--OnEvent
--=========
function Profile_Save_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_SHAREPLAN" then
		if this:IsVisible() then
		
			if tonumber(arg0) == 0 then
				Profile_Save_CloseClick()	
				return
			end
			
		end
				
		Profile_Save_Show()
			
		return
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			Profile_Save_CloseClick()	
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		Profile_Save_On_ResetPos()
	end
	
end

function Profile_Save_Show()

	Profile_Save_CleanUp()
	
	Profile_Save_InitAction()
				
	this:Show()
	
end

-- 方案填充数据
function Profile_Save_InitAction()

	for i in pairs(g_Profile_Save_Action) do
		local nRet, nFashionIdx, nFashionId, nRideId, nWeaponId, nFaceId, nHairId, nPossId = Exterior:LuaFnExteriorPlayerGetSharePlan(i)
		if nRet == 1 and nFashionIdx ~= nil and nFashionIdx >= 0 and nFashionId > 0 then		
			local strImage = tostring(LifeAbility : Get_Item_Icon_NameByDataIndex(tonumber(nFashionId)))
			g_Profile_Save_Action[i]:SetProperty("BackImage", strImage)
			
			--local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
			g_Profile_Save_Action[i]:SetToolTip("fangan.."..i)
		end
	end
	
end

-- 保存对应展示方案
function Profile_Save_SavePlanClicked( nIdx )
	
	if nIdx >= 1 and nIdx <= 6 then
		local ret = Exterior:LuaFnExteriorPlayerSaveSharePlan(nIdx-1, 1)
		return ret	
	end
		
end

-- 前往个人展示界面
function Profile_Save_GotoClicked()

	local ret = Exterior:LuaFnExteriorPlayerOpenProfileUI()
	return ret	
	
end

-- 返回时装编辑界面
function Profile_Save_ConfirmClicked()

	PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
	
end

--小问号
function Profile_Save_HelpClick()
end

--关闭按钮
function Profile_Save_CloseClick()	

	Profile_Save_CleanUp()
	this:Hide()
	
end

function Profile_Save_OnHiden()
	
	Profile_Save_CleanUp()
	
end

function Profile_Save_CleanUp()
	
	for i in pairs(g_Profile_Save_Action) do		
		g_Profile_Save_Action[i]:SetActionItem(-1)
	end
	
end

function Profile_Save_On_ResetPos()

	Profile_Save_Frame:SetProperty("UnifiedPosition", g_Profile_Save_UnifiedPosition);
	
end

--!!!reloadscript =Profile_Save
