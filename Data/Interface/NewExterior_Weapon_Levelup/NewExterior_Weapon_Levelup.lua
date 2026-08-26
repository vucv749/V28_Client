
local g_WeaponLevelUp_Frame_UnifiedPosition
local g_clientNpcId = -1


local g_BarList = {}								-- ????ui??
local g_MaxBarNum = 0								-- ????
local g_CurSelExteriorWeaponID = 0					-- Exterior_Weapon??id
local g_CurSelExteriorWeaponLevel = 1				-- ?????????
local g_WeponLevelup_YuanBaoPay = 1					-- ??????
local g_CurSelItemIndex = 1
local g_ExteriorType = 5							-- ??
local g_DataListCount = 0
local g_LevelMax = 4								-- ????
local g_LevelLimit = 1								-- ?????
local g_InitList = 0								-- ?????
local g_IdxList = {}								-- ????

function NewExterior_Weapon_Levelup_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_MONEY", false)
	this:RegisterEvent("MONEYJZ_CHANGE", false)
	this:RegisterEvent("ADJEST_UI_POS", false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED", false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED", false)	--????????
	this:RegisterEvent("ADD_EXTERIOR", false)
	this:RegisterEvent("UPDATE_EXTERIOR", false)
	this:RegisterEvent("EXTERIOR_OUTTIME", false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("REMOVE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)
	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	this:RegisterEvent("OPEN_EQUIP", false)
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING", false)
	this:RegisterEvent("OPEN_DRESS_ENCHASE_FITTING", false)
	
	this:RegisterEvent("YIGUI_OPEN",false);				-- ??
end

function NewExterior_Weapon_Levelup_OnLoad() 
	g_WeaponLevelUp_Frame_UnifiedPosition = NewExterior_Weapon_Levelup_Frame:GetProperty("UnifiedPosition")

	g_WeponLevelup_YuanBaoPay = 1
	g_CurSelExteriorWeaponID = 0
	g_CurSelExteriorWeaponLevel = 1
	g_CurSelItemIndex = 1
end

function NewExterior_Weapon_Levelup_OnEvent(event)
	if event == "UI_COMMAND" and arg0 ~=nil and tonumber(arg0) == 89334001 then
		NewExterior_Weapon_Levelup_OnShow()
	elseif (event == "ADJEST_UI_POS" ) then
		NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		NewExterior_Weapon_Levelup_CloseOnClick()
	elseif (event == "UNIT_MONEY") then
		NewExterior_Weapon_Levelup_MoneyUIUpdate()
	elseif (event == "MONEYJZ_CHANGE") then
		NewExterior_Weapon_Levelup_MoneyUIUpdate()
	elseif event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		NewExterior_Weapon_Levelup_Init()
	elseif event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end

		NewExterior_Weapon_Levelup_Init()		
	elseif event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end
		NewExterior_Weapon_Levelup_Init()
	elseif event == "OPEN_EQUIP" or event == "OPEN_DRESS_PAINT_FITTING" or event == "OPEN_DRESS_ENCHASE_FITTING" or event == "YIGUI_OPEN" then
		if this:IsVisible() then
			NewExterior_Weapon_Levelup_CloseOnClick()
		end
	end
		

end

function NewExterior_Weapon_Levelup_Frame_On_ResetPos()
	NewExterior_Weapon_Levelup_Frame:SetProperty("UnifiedPosition", g_WeaponLevelUp_Frame_UnifiedPosition);
end

function NewExterior_Weapon_Levelup_OnShow()
	if this : IsVisible() then	-- ??????,????
		return
	end

	local npcObjId = Get_XParam_INT(0)
	g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
	if g_clientNpcId == -1 then
		NewExterior_Weapon_Levelup_CloseOnClick()
		return
	end

	this:CareObject( g_clientNpcId, 1, "NewExterior_Weapon_Levelup" )

	NewExterior_Weapon_Levelup_CloseSameGroupWindow()

	Exterior:LuaFnUpdateExteriorWeaponPlayerData(0, 0)

	this:Show()

	NewExterior_Weapon_Levelup_Init()
end

function NewExterior_Weapon_Levelup_Init()
	-- 对List进行初始化
	Exterior:LuaFnInitExteriorWeaponList()
	-- 左侧牴示模型 初始化
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("")
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("Exterior_Weapon")
	-- 元宝确认框ui状态
	if g_WeponLevelup_YuanBaoPay == 1 or g_WeponLevelup_YuanBaoPay == 0 then
		NewExterior_Weapon_Levelup_YuanBao:SetCheck(g_WeponLevelup_YuanBaoPay)
	end

	-- 钱币刷新
	NewExterior_Weapon_Levelup_MoneyUIUpdate()

	NewExterior_Weapon_Levelup_Update()

	NewExterior_Weapon_Levelup_BtnStateUpdate()
end


function NewExterior_Weapon_Levelup_MoneyUIUpdate()
	local playerMoney = Player:GetData("MONEY")
	NewExterior_Weapon_Levelup_SelfMoney:SetProperty("MoneyNumber", playerMoney)

	local playerJZ = Player:GetData("MONEY_JZ")
	NewExterior_Weapon_Levelup_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
end

function NewExterior_Weapon_Levelup_BtnStateUpdate()
	-- 是否选中
	if g_CurSelExteriorWeaponID <= 0 then
		NewExterior_Weapon_Levelup_OK:Disable()
	else
		if Exterior:LuaFnIsHaveExteriorWeapon(g_CurSelExteriorWeaponID) == 1 then
			local maxLevel = Exterior:LuaFnGetExteriorWeaponInfo(g_CurSelExteriorWeaponID, "MaxLevel")
			if g_CurSelExteriorWeaponLevel < maxLevel - 1 then
				NewExterior_Weapon_Levelup_OK:Enable()
			else
				NewExterior_Weapon_Levelup_OK:Disable()
			end
		else
			NewExterior_Weapon_Levelup_OK:Disable()
		end
	end

	--NewExterior_Weapon_Levelup_OK:SetToolTip("#{HWSJ_201218_13}")
end

function NewExterior_Weapon_Levelup_Update()

	--右侧上面图鉴列表初始化
	Exterior:LuaFnInitExteriorWeaponList()

	g_DataListCount = Exterior:LuaFnGetExteriorWeaponListCount()

	if g_InitList <= 0 then
		g_MaxBarNum = Exterior:LuaFnGetExteriorWeaponMaxCount()
		NewExterior_Weapon_Levelup_SuperList:Clear()
		local idx = 1
		for i = 1, g_MaxBarNum do
			if NewExterior_Weapon_Levelup_IsLevelUpLimit(i) ~= 1 then
				g_IdxList[idx] = i
				local bar = NewExterior_Weapon_Levelup_SuperList:AddChild("NewExterior_Weapon_Levelup_SuperList_Item")
				bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
				g_BarList[idx] = bar
				bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction"):SetEvent("MouseLButtonDown", string.format("NewExterior_Weapon_Levelup_ItemClicked(%d)", idx))
				bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction"):SetEvent("MouseMove", string.format("NewExterior_Weapon_Levelup_ItemMouseMove(%d)", idx))
				bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction"):SetProperty("Empty", "False")
				bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction"):SetProperty("UseDefaultTooltip", "True")
				NewExterior_Weapon_Levelup_SetItem(idx)
				idx = idx + 1
			end
		end
	end

	--g_CurSelItemIndex = Exterior:LuaFnGetExteriorWeaponInUse()
		
	NewExterior_Weapon_Levelup_ItemClicked(g_CurSelItemIndex)
	
end

--初始化每个图鉴item
function NewExterior_Weapon_Levelup_SetItem(index)
	local bar = g_BarList[index]
	if bar == nil then
		return
	end

	if index > g_DataListCount then
		g_BarList[index]:Hide()
		return
	end

	local idx = g_IdxList[index]
	if idx == nil then
		g_BarList[index]:Hide()
		return
	end

	bar:Show()

	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(idx - 1)
	local strName = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Name")
	local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "Icon")
	local strImage = GetIconFullName(strIcon)
	local ctrlAction = bar:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction")
	if ctrlAction ~= nil then	
		ctrlAction:SetProperty("NormalImage", strImage)
		ctrlAction:SetProperty("HoverImage", strImage)
		local strTip = Exterior:LuaFnGetExteriorWeaponToolTip(nExteriorID)
		ctrlAction:SetToolTip(strTip)
	end

	--锁
	if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) == 1 then
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionLock"):Hide()
		local nLeftTime = Exterior:LuaFnGetExteriorWeaponLeftTime(nExteriorID)
		if nLeftTime and nLeftTime < 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Hide()
		elseif nLeftTime and nLeftTime == 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Show()
		elseif nLeftTime and nLeftTime > 0 then
			bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Show()
		end
	else
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionTime"):Hide()
		bar:GetSubItem("NewExterior_Weapon_Levelup_SuperListItemActionLock"):Show()
	end
end

--点击幻武图鉴item
function NewExterior_Weapon_Levelup_ItemClicked(nIndex)

	local idx = g_IdxList[nIndex]
	if idx == nil then
		return
	end

	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(idx - 1)

	if g_CurSelExteriorWeaponID ~= nExteriorID then
		g_CurSelExteriorWeaponID = nExteriorID
	end
	
	if g_CurSelItemIndex ~= nIndex then
		g_CurSelItemIndex = nIndex
	end

	g_CurSelExteriorWeaponLevel = 1
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_Weapon_Levelup_SuperList_ItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
				else
					ctrlAction:SetPushed(0)	
				end
			end
		end
	end
	
	-- 看是否激活
	if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) == 1 then
		-- 激活了获取
		local lv, nextlv, money, item, itemnum = Exterior:LuaFnGetExteriorWeaponLevelData(nExteriorID)
		if lv < 0 then
			g_CurSelExteriorWeaponLevel = 1
		else
			g_CurSelExteriorWeaponLevel = lv
		end
	end

	NewExterior_Weapon_Levelup_LevelInfoShow(nExteriorID)

	NewExterior_Weapon_Levelup_BtnStateUpdate()
end

--点击幻武等级item
function NewExterior_Weapon_Levelup_LevelInfoShow(nExteriorID)
	
	local lv, nextlv, money, item, itemnum = Exterior:LuaFnGetExteriorWeaponLevelData(nExteriorID)
	if lv < 0 then
		-- ID错了
		return
	end

	Exterior:LuaFnUpdateExteriorWeaponPlayerData(nExteriorID, lv)

	if lv == nextlv then 	-- ??
		-- 显示消耗
		NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", 0)
		-- 显示满级版
		NewExterior_Weapon_Levelup_LevelMax_Text:Show()
		-- 隐藏基础版
		NewExterior_Weapon_Levelup_BigText:Hide()
	else
		if Exterior:LuaFnIsHaveExteriorWeapon(nExteriorID) ~= 1 then
			-- 未满级
			NewExterior_Weapon_Levelup_Level_Text:SetText("#{HSWQ_20220607_59}")
			-- 显示消耗
			NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", 0)
		else
			-- 未满级
			NewExterior_Weapon_Levelup_Level_Text:SetText(ScriptGlobal_Format("#{HSWQ_20220607_25}", tostring(lv+1)))
			-- 显示消耗
			NewExterior_Weapon_Levelup_DemandMoney:SetProperty("MoneyNumber", tostring(money))
		end
		-- 显示所需道具
		NewExterior_Weapon_Levelup_Cailiao_Text:SetText(ScriptGlobal_Format("#{HSWQ_20220607_26}",PlayerPackage:GetItemName(item)))
		-- 显示道具数量
		NewExterior_Weapon_Levelup_CailiaoNum_Text:SetText(ScriptGlobal_Format("#{HSWQ_20220607_27}",itemnum))
		-- 显示基础板
		NewExterior_Weapon_Levelup_BigText:Show()
		-- 隐藏满级版
		NewExterior_Weapon_Levelup_LevelMax_Text:Hide()
	end

end


--悬浮幻武图鉴item
function NewExterior_Weapon_Levelup_ItemMouseMove(nIndex)

end

--点击幻武升级按钮
function NewExterior_Weapon_Levelup_OnOK()

	if g_CurSelExteriorWeaponID <= 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("TryExteriorWeaponLevelUp")
		Set_XSCRIPT_ScriptID(893340)
		Set_XSCRIPT_Parameter(0, g_CurSelExteriorWeaponID)
		Set_XSCRIPT_Parameter(1, tonumber(NewExterior_Weapon_Levelup_YuanBao:GetCheck()))
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function NewExterior_Weapon_Levelup_CheckClick()
	g_WeponLevelup_YuanBaoPay = NewExterior_Weapon_Levelup_YuanBao:GetCheck()
end

--界面隐藏
function NewExterior_Weapon_Levelup_OnHiden()
	this:CareObject( g_clientNpcId, 0, "NewExterior_Weapon_Levelup" )
	g_clientNpcId = -1
	NewExterior_Weapon_Levelup_FakeObject:SetFakeObject("")


	g_WeponLevelup_YuanBaoPay = NewExterior_Weapon_Levelup_YuanBao:GetCheck()
	g_CurSelExteriorWeaponID = 0
	g_CurSelExteriorWeaponLevel = 1
	g_CurSelItemIndex = 1

end

--点击关睜按钮
function NewExterior_Weapon_Levelup_CloseOnClick()
	this:Hide()
end


function NewExterior_Weapon_Levelup_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			NewExterior_Weapon_Levelup_FakeObject:RotateBegin(-0.3)
		--向左旋转结束
		else
			NewExterior_Weapon_Levelup_FakeObject:RotateEnd()
		end
	end
end


function NewExterior_Weapon_Levelup_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			NewExterior_Weapon_Levelup_FakeObject:RotateBegin( 0.3)
		--向右旋转结束
		else
			NewExterior_Weapon_Levelup_FakeObject:RotateEnd()
		end
	end
end

function NewExterior_Weapon_Levelup_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	--CloseWindow("NewExterior_Weapon_Levelup", true)
end

-- 是否限制升级
function NewExterior_Weapon_Levelup_IsLevelUpLimit(idx)
	if idx <= 0 then
		return 0
	end

	local nExteriorID = Exterior:LuaFnGetExteriorWeaponIDFromList(idx - 1)
	local nMaxLevel = Exterior:LuaFnGetExteriorWeaponInfo(nExteriorID, "MaxLevel")
	if nMaxLevel ~= nil and nMaxLevel == g_LevelLimit then
		return 1
	end

	return 0
end
