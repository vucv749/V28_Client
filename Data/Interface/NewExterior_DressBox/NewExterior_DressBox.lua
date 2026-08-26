--!!!reloadscript =NewExterior_DressBox

local EXTERIORFILTTING_TOTALKIND = 0;
local g_NewExterior_DressBox_UnifiedPosition = ""

local g_TargetExteriorIndex = 0		--???????,?1??
local g_TargetExteriorID = 0		--?????ID

local g_NeedChangeScrollSize = 1

local g_CurSelExteriorIndex = 0		--?????????,?1??
local g_CurSelExteriorID = 0		--???????ID,?1??

local g_Distance = 1
local g_Distance_Ori = 2
local g_Distance_Max = 4
local g_InitList = 0
local m_PlayerfashionDepotType = 1 	--???? 1 ?????? 2 ??????
local g_MaxBarNum = 100
local g_BarList = {}
local g_PlayerFashionInfoList = {}

local g_ActionButtonList = {}

local g_CameraHeight = 1     --?????
local g_CameraDistance = 2   --?????
local g_CameraPitch = 3      --?????
local g_CameraPosition =
{
	--女性相关位置
	[0] = 
	{
		{fHeight = 0.82, fDistance = 8, fPitch=0.1},
		{fHeight = 0.82, fDistance = 6.5, fPitch=0.1},
		{fHeight = 1.5, fDistance = 2.5, fPitch=0.10},
		{fHeight = 1.57, fDistance = 1.7, fPitch=0.10}
	},
	--男性相关位置
	[1] = 
	{
		{fHeight = 0.91, fDistance = 8.8, fPitch=0.2},
		{fHeight = 0.91, fDistance = 7.1, fPitch=0.2},
		{fHeight = 1.67, fDistance = 2.5, fPitch=0.2},
		{fHeight = 1.745, fDistance = 1.7, fPitch=0.2}
	},
}

local g_SpecialFashionCamera = {
	-- 周年庆时装
	{startid = 10125382, endid = 10125481, fHeight = 1.9, fDistance = 12, fPitch = -1, nIndex = 1, timecount = 9000},
	{startid = 10125382, endid = 10125481, fHeight = 1.9, fDistance = 12, fPitch = -1, nIndex = 2, timecount = 10000},
	--  
	{startid = 10126034, endid = 10126133, fHeight = 2.5, fDistance = 25, fPitch = -1, nIndex = 1, timecount = 14000},
	{startid = 10126034, endid = 10126133, fHeight = 1.7, fDistance = 18, fPitch = -1, nIndex = 2, timecount = 19000},
}
local g_PetSoulLevelLimit = 85
local g_NewExterior_DressBox_CurPage = 0
local g_NewExterior_DressBox_MLevel = 35
local g_NewExterior_DressBox_FLevel = 20
local g_NewExterior_DressBox_Married = 0
local g_MaxShareBarNum = 20
local g_CurSel_Offset = 200
local g_ShareBarList = {}
local g_MyCoupleFashionInfoList = {}
local g_SpouseCoupleFashionInfoList = {}

local g_OrnamentState				= {		-- ??
	INVALID	= 0,							-- ??
	EMPTY	= 1,							-- ??
	TIME	= 2,							-- ??
	TIMEOUT	= 3,							-- ??
	FOREVER	= 4,							-- ??
}
--=========
--PreLoad==
--=========
function NewExterior_DressBox_PreLoad()

	this:RegisterEvent("OPEN_EXTERIOR_FASHION")
	this:RegisterEvent("UPDATE_EXTERIOR_FASHION",false)
	this:RegisterEvent("EXTERIOR_FASHION_OP", false)
	this:RegisterEvent("OPEN_EXTERIOR_COUPLEFASHION")
	
	this:RegisterEvent("ADD_EXTERIOR",false)
	this:RegisterEvent("UPDATE_EXTERIOR",false)
	this:RegisterEvent("EXTERIOR_OUTTIME",false)
	this:RegisterEvent("EXTERIOR_ID_CHANGED",false)
	this:RegisterEvent("EXERIOR_SAVEALL_RET", false)
	
	this:RegisterEvent("ADD_EXTERIOR_WEAPON", false)
	this:RegisterEvent("UPDATE_EXTERIOR_WEAPON", false)
	this:RegisterEvent("EXTERIOR_OUTTIME_WEAPON", false)
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_CHANGED", false)	
	this:RegisterEvent("DEF_EXTERIOR_WEAPON_LEVEL_CHANGED", false)
	
	this:RegisterEvent("ON_SCENE_TRANS",false)
	this:RegisterEvent("ON_SERVER_TRANS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)

	this:RegisterEvent("ADJEST_UI_POS",false)	
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	
	this:RegisterEvent("OPEN_STALL_SALE",false)
	this:RegisterEvent("PROGRESSBAR_SHOW",false)
	-- this:RegisterEvent("MODELID_CHANGE",false)
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UNIT_LEVEL", false)
	this:RegisterEvent("OPEN_DRESSPREVIEW")
	
	this:RegisterEvent("UPDATE_RIDE_CARD_INFO", false)
	this:RegisterEvent("ORNAMENTS_DISPLAYUPDATE", false)
end

--=========
--OnLoad
--=========
function NewExterior_DressBox_OnLoad()
	g_NewExterior_DressBox_UnifiedPosition = NewExterior_DressBox_Frame:GetProperty("UnifiedPosition")

	g_ActionButtonList = {
		NewExterior_DressBox_FashionAction_MidBtn1,
		NewExterior_DressBox_FashionAction_MidBtn2,
		NewExterior_DressBox_FashionAction_MidBtn3,
		NewExterior_DressBox_FashionAction_MidBtn4,
		NewExterior_DressBox_FashionAction_MidBtn5,
	}
end

--=========
--OnEvent
--=========
function NewExterior_DressBox_OnEvent(event)
	
	if event == "OPEN_EXTERIOR_FASHION" then
		if this:IsVisible() then
			if tonumber(arg0) == 0 then
				NewExterior_DressBox_SavePosition()
				this:Hide()
			end
		else
			if tonumber(arg0) == m_PlayerfashionDepotType then			
				--关睜元宝商店相关界面
				if(IsWindowShow("YuanbaoShop")) then
					CloseWindow("YuanbaoShop", true)
				end
				
				PushEvent( "CLOSE_DRESSPREVIEW") 
				PushEvent( "CLOSE_GEMEFFECTPREVIEW")
				
				EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
				
				if tonumber(arg1) == 1 then	
					Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")					
					Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
				end
				
				g_NewExterior_DressBox_Married = 0
				if Exterior:LuaFnGetCoupleFashionValidity() == 1 then
					g_NewExterior_DressBox_Married = 1					
				end
				
				-- 打开个人衣柜
				g_NewExterior_DressBox_CurPage = 1
			
				NewExterior_DressBox_SetPosition()
				NewExterior_DressBox_CloseSameGroupWindow()
				this:Show()
				NewExterior_DressBox_Show()
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				NewExterior_DressBox_UpdateCamera()
			end
		end	
		return
	end
	
	if event == "OPEN_EXTERIOR_COUPLEFASHION" then
		if this:IsVisible() then
			NewExterior_DressBox_SavePosition()
			this:Hide()
		else
			if tonumber(arg0) == m_PlayerfashionDepotType then			
				--关睜元宝商店相关界面
				if(IsWindowShow("YuanbaoShop")) then
					CloseWindow("YuanbaoShop", true)
				end
								
				EXTERIORFILTTING_TOTALKIND = Exterior:LuaFnGetExteriorPlayerFittingCount()
								
				g_NewExterior_DressBox_Married = 0
				if Exterior:LuaFnGetCoupleFashionValidity() == 1 then
					g_NewExterior_DressBox_Married = 1					
				end
				
				-- 打开个人衣柜
				g_NewExterior_DressBox_CurPage = 2
			
				NewExterior_DressBox_SetPosition()
				NewExterior_DressBox_CloseSameGroupWindow()
				this:Show()
				NewExterior_DressBox_Show()
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				NewExterior_DressBox_UpdateCamera()
			end
		end	
		return
	end
	
	if event == "EXERIOR_SAVEALL_RET" then
		if not this:IsVisible() then
			return
		end
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
		Exterior:LuaFnSetCurrentExteriorSetInfo("RESETEX")
		Exterior:LuaFnInitCurrentExteriorSetExceptFashion(0)
		NewExterior_DressBox_Show()
	end
	
	if event == "OPEN_STALL_SALE"			-- ????,????
		or event == "PROGRESSBAR_SHOW"		-- ?????,????
		--or event == "MODELID_CHANGE" 		-- 变身 关睜界面
		then
		NewExterior_DressBox_CloseClick()	
		return
	end
	
	if event == "ADD_EXTERIOR" or event == "UPDATE_EXTERIOR" or event == "EXTERIOR_OUTTIME" or event == "EXTERIOR_ID_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateRedPoint()
		--模型
		Exterior:LuaFnUpdateExteriorPlayerData()
	end
	
	if event == "ADD_EXTERIOR_WEAPON" or event == "UPDATE_EXTERIOR_WEAPON" or event == "EXTERIOR_OUTTIME_WEAPON" or event == "DEF_EXTERIOR_WEAPON_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateRedPoint()
		--模型
		Exterior:LuaFnUpdateExteriorPlayerData()
	end
	
	if event == "DEF_EXTERIOR_WEAPON_LEVEL_CHANGED" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateRedPoint()
		--模型
		Exterior:LuaFnUpdateExteriorPlayerData()
	end
	
	
	
	if event == "EXTERIOR_FASHION_OP" then
		if tonumber(arg0) == 1 then
			if tonumber(arg1) == 1 and (this:IsVisible()) then
				-- enFashionDepotOPType_DepositOnly 背包右键存入衣柜 
				local nSourcePos = tonumber(arg2)
				local targetPos = -1
				--Optype enCGFashionDepotOperationType_Deposit = 1
				NewExterior_DressBox_BagToFashionDepot(1, nSourcePos, targetPos)
				return
			end
			if tonumber(arg1) == 2 and (this:IsVisible()) then
				-- enFashionDepotOPType_BagMoveToDressBox 背包拖拽存入衣柜
				local nSourcePos = tonumber(arg2)
				local targetPos = tonumber(arg3)
				--Optype enCGFashionDepotOperationType_Deposit = 1
				NewExterior_DressBox_BagToFashionDepot(1, nSourcePos, targetPos)
				return
			end
			if tonumber(arg1) == 3 and (this:IsVisible()) then
				-- enFashionDepotOPType_Move 衣柜内拖拽
				local nSourcePos = tonumber(arg2)
				local targetPos = tonumber(arg3)
				if nSourcePos == targetPos then --??????????
					return
				end
				Exterior:LuaFnExteriorFashionOperation(m_PlayerfashionDepotType, 3, nSourcePos, targetPos)
			end
			if tonumber(arg1) == 4 and (this:IsVisible()) then
				-- enFashionDepotOPType_TakeOut 右键衣柜时装取出到背包
				local nSourcePos = tonumber(arg2)
				local targetPos = tonumber(arg3)
				NewExterior_DressBox_FashionDepotToBag(nSourcePos, targetPos)
			end
			
			if tonumber(arg1) == 6 and (this:IsVisible()) then
				NewExterior_DressBox_SuperListArrangeBtn:Disable()
			end
			if tonumber(arg1) == 7 and (this:IsVisible()) then
				NewExterior_DressBox_SuperListArrangeBtn:Enable()
				NewExterior_DressBox_Show()
			end
		end
		return
	end
	
	if event == "UPDATE_EXTERIOR_FASHION" then
		if not this:IsVisible() then
			return
		end
		if tonumber(arg0) == m_PlayerfashionDepotType then
			--init
			NewExterior_DressBox_InitList()	
			--列表
			NewExterior_DressBox_UpdateList()
			--左侧
			NewExterior_DressBox_UpdateLeftBtn()
			NewExterior_DressBox_UpdateRedPoint()
			--模型
			NewExterior_DressBox_UpdateObj()
			--共享衣柜
			NewExterior_DressBox_ShowCoupleDressButton()
		end
		return
	end
	
	-- FakeObject模型界面互斥
	if (event == "UI_COMMAND" and tonumber(arg0) == 120203161) or (event == "OPEN_DRESSPREVIEW") or ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) or ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then   --????
		if this:IsVisible() then
			NewExterior_DressBox_CloseClick()
			return
		end
	end
	
	if event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" or event == "HIDE_ON_SCENE_TRANSED" then
		if this:IsVisible() then
			this:Hide()
		end
	end
	
	-- 游戏窗口尺寸发生了变化 or 游戏分辨率发生了变化
	if event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED" then
		NewExterior_DressBox_Frame:SetProperty("UnifiedPosition", g_NewExterior_DressBox_UnifiedPosition)
	end

	if event == "UNIT_LEVEL" and arg0 == "player" then
		if this:IsVisible() then
			NewExterior_DressBox_UpdateLeftBtn()
		end
	end
	
	if event == "UPDATE_RIDE_CARD_INFO" then
		if not this:IsVisible() then
			return
		end
		--左侧
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateRedPoint()
		--模型
		Exterior:LuaFnUpdateExteriorPlayerData()
	end

	if event == "ORNAMENTS_DISPLAYUPDATE" then
		-- 刷新模型
		Exterior:LuaFnUpdateExteriorPlayerData()
		return
	end
end

function NewExterior_DressBox_InitList()
	
	if g_InitList == 0 then				
		for i = 1, g_MaxBarNum do
			local bar = NewExterior_DressBox_SuperList:AddChild("NewExterior_DressBox_SuperListItem")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
		
			bar:GetSubItem("NewExterior_DressBox_SuperListItemAction"):SetEvent("Clicked", string.format("NewExterior_DressBox_ItemClicked(%d)", i))
			bar:GetSubItem("NewExterior_DressBox_SuperListItemAction"):SetEvent("RBClicked", string.format("NewExterior_DressBox_ItemBtnClicked(%d)", i))
			bar:GetSubItem("NewExterior_DressBox_SuperListItemAction"):SetProperty("DraggingEnabled", "True")
			local kidx = i-1
			bar:GetSubItem("NewExterior_DressBox_SuperListItemAction"):SetProperty("DragAcceptName", "K"..tostring(kidx))
			--小表			
			--bar:GetSubItem("NewExterior_DressBox_SuperListItemActionTime"):Hide()
			--新		
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionTip"):Hide()
			--共享中
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare"):Hide()
			--可共享
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare2"):Hide()
			--牸用
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionZhan"):Hide()
			--试穿标识
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
			--当前装备中
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionEqu"):Hide()
			--编号特效
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionLuxury"):Hide()
			
			table.insert(g_BarList, bar)
			table.insert(g_PlayerFashionInfoList, {})
		end
		
		for i = 1, g_MaxShareBarNum do
			local bar = NewExterior_DressBox_SuperList2:AddChild("NewExterior_DressBox_SuperList2Item")
			bar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")
		
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemAction"):SetEvent("Clicked", string.format("NewExterior_DressBox_Item2Clicked(%d)", i))
			--不可拖拽
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemAction"):SetProperty("DraggingEnabled", "False")
			--共享中
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionShare"):Hide()
			--可共享
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionShare2"):Hide()
			--新		
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Hide()
			--牸用
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionZhan"):Hide()
			--试穿标识
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Hide()
			--当前装备中
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionEqu"):Hide()
			--编号特效
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionLuxury"):Hide()
			
			table.insert(g_ShareBarList, bar)
			table.insert(g_MyCoupleFashionInfoList, {})
			table.insert(g_SpouseCoupleFashionInfoList, {})
		end
		g_InitList = 1
	end
		
	-- 填充时装数据
	local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
	for i=1, g_MaxBarNum do 
		local nVecIndex = i-1
		local nExteriorID = FashionDepot:LuaFnGetFashionId(m_PlayerfashionDepotType, nVecIndex)

		-- 衣柜里的下标
		g_PlayerFashionInfoList[i].nVecIndex = nVecIndex
		
		if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionId == nExteriorID and nCurFashionIdx == nVecIndex then
			g_PlayerFashionInfoList[i].bDressUp = 1
		else
			g_PlayerFashionInfoList[i].bDressUp = 0
		end
		
		-- 时装id
		if nExteriorID and nExteriorID > 0 then
			g_PlayerFashionInfoList[i].nExteriorID = nExteriorID
		else
			g_PlayerFashionInfoList[i].nExteriorID = -1
		end
		
		local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(nVecIndex)
		if nCurShareState == 1 then
			-- 共享状态
			g_PlayerFashionInfoList[i].nCoupleDepotPos = nCurCoupleDepotPos
			
			if nCurWearState > 0 then
				g_PlayerFashionInfoList[i].nWearShare = 1
			else
				g_PlayerFashionInfoList[i].nWearShare = 0
			end
		else
			g_PlayerFashionInfoList[i].nWearShare = 0
			g_PlayerFashionInfoList[i].nCoupleDepotPos = -1
		end
	end
	
	local CoupleIdx = 1
	local nCurCoupleFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
	for i = 1, g_MaxShareBarNum do
		local nVecIndex = i-1
		local nRet, nExteriorID, nPlayerDepotPos, nCurWearState = Exterior:LuaFnGetSpouseCoupleFashionInfo(nVecIndex)		
		if nRet == 1 then
			g_SpouseCoupleFashionInfoList[CoupleIdx].nVecIndex = nVecIndex
			g_SpouseCoupleFashionInfoList[CoupleIdx].nExteriorID = nExteriorID
			
			-- 共享时装在配偶衣柜中的下标
			g_SpouseCoupleFashionInfoList[CoupleIdx].nPlayerDepotPos = nPlayerDepotPos
			
			if nCurWearState > 0 then
				g_SpouseCoupleFashionInfoList[CoupleIdx].nWearShare = 1
			else
				g_SpouseCoupleFashionInfoList[CoupleIdx].nWearShare = 0
			end
			
			if nCurCoupleFashionIdx ~= nil and nCurCoupleFashionIdx >= 0 and nCurCoupleFashionIdx == nVecIndex then
				g_SpouseCoupleFashionInfoList[CoupleIdx].bDressUp = 1
			else
				g_SpouseCoupleFashionInfoList[CoupleIdx].bDressUp = 0
			end
			
			CoupleIdx = CoupleIdx + 1
		end
	end
	
	if CoupleIdx <= g_MaxShareBarNum then
		for i = CoupleIdx, g_MaxShareBarNum do
			g_SpouseCoupleFashionInfoList[i].nVecIndex = -1
			g_SpouseCoupleFashionInfoList[i].nExteriorID = -1
			g_SpouseCoupleFashionInfoList[i].nPlayerDepotPos = -1
			g_SpouseCoupleFashionInfoList[i].bDressUp = 0
			g_SpouseCoupleFashionInfoList[i].nWearShare = 0
		end
	end
	
end

function NewExterior_DressBox_Show()
	
	g_Distance = g_Distance_Ori
	g_NeedChangeScrollSize = 1
	
	NewExterior_DressBox_InitList()	
	
	NewExterior_DressBox_CleanUp()
	
	Exterior:LuaFnInitCurrentExteriorSet(1)
	
	g_CurSelExteriorID = 0
	g_CurSelExteriorIndex = -1
	g_TargetExteriorID = 0
	g_TargetExteriorIndex = -1
			
	--列表 排序
	NewExterior_DressBox_UpdateList()
	
	--左侧
	NewExterior_DressBox_UpdateLeftBtn()
	--模型
	NewExterior_DressBox_UpdateObj()
	
	NewExterior_DressBox_RemoveCoupleTip(g_CurSelExteriorIndex)
	NewExterior_DressBox_UpdateRedPoint()
	
	NewExterior_DressBox_ShowFashionWeaponCheckButton()
	
	--分享按钮
	NewExterior_DressBox_ShowDressShareButton()
	
	--共享衣柜
	NewExterior_DressBox_ShowCoupleDressButton()
	
end
--左侧
function NewExterior_DressBox_UpdateLeftBtn()
	
	for i = 1, table.getn(g_ActionButtonList) do
		g_ActionButtonList[i]:Hide()
	end

	NewExterior_DressBox_CleanUp_LeftButton()
	
	local sex = Player:GetMySex()
	
	--时装		
	local nFashionId = -1
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, cacheExteriorIdx)
		if theAction:GetID() ~= 0 then
			NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())
			NewExterior_DressBox_Dress_ActionImg:Show()
				
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 and nCurFashionIdx == cacheExteriorIdx  then
				NewExterior_DressBox_Dress_ActionImg:Hide()
			end
				
			nFashionId = cacheExteriorID
		end
		local actionVisualID = Exterior:LuaFnGetFashionEquipVisual(1, cacheExteriorID, cacheExteriorIdx)
		local ActionNum = Exterior:LuaFnGetFashionActionActionNum(cacheExteriorID, actionVisualID)
		for i = 1, ActionNum do
			g_ActionButtonList[i]:Show()
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(cacheExteriorIdx)
			if theAction:GetID() ~= 0 then
				NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())
				NewExterior_DressBox_Dress_ActionImg:Show()
				
				local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and nCurFashionIdx == cacheExteriorIdx then
					NewExterior_DressBox_Dress_ActionImg:Hide()
				end
				
				nFashionId = cacheExteriorID
			end
			local actionVisualID = Exterior:LuaFnGetFashionEquipVisual(2, cacheExteriorID, cacheExteriorIdx)
			local ActionNum = Exterior:LuaFnGetFashionActionActionNum(cacheExteriorID, actionVisualID)
			for i = 1, ActionNum do
				g_ActionButtonList[i]:Show()
			end
		else
			local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
			if nCurFashionId ~= nil and nCurFashionId > 0 then
				local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, nCurFashionIdx)
				if theAction:GetID() ~= 0 then
					NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
					nFashionId = nCurFashionId
				end
			else
				local nCurFashionIdx, nCurFashionId = Exterior:LuaFnGetCoupleFashionInUse()
				if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 then
					local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nCurFashionIdx)
					if theAction:GetID() ~= 0 then
						NewExterior_DressBox_Dress_LeftBtn:SetActionItem(theAction:GetID())
						
						nFashionId = nCurFashionId
					end
				end
			end			
		end
	end
		
	NewExterior_DressBox_Dress_LeftBtnLuxury:Hide()
	if nFashionId ~= -1 then	
		local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nFashionId, "Number")
		if nFashionNumber ~= nil and nFashionNumber > 0 then
			NewExterior_DressBox_Dress_LeftBtnLuxury:Show()
		end
	end
	
	--坐骑
	local edType = 3	
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorRideInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Ride_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_83}", strName)
		NewExterior_DressBox_Ride_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_DressBox_Ride_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 and DataPool:LuaFnIsExteriorRideActiveByRideCard(cacheExteriorID) ~= 1 then
			NewExterior_DressBox_Ride_LockImg:Show()
		end
	end
	
	--脸型
	edType = 0
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("FACE")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorFaceInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_82}", strName)
		NewExterior_DressBox_FaceStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_DressBox_FaceStyle_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_DressBox_FaceStyle_LockImg:Show()
		end
	end
	
	--发型
	edType = 1
	cacheExteriorID, cacheColorIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("HAIR")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorHairInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_HairStyle_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_81}", strName)
		NewExterior_DressBox_HairStyle_LeftBtn:SetToolTip(strTemp)
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_DressBox_HairStyle_ActionImg:Show()
		else
			if Exterior:LuaFnGetExteriorHairColorIndex() ~= cacheColorIndex then
				NewExterior_DressBox_HairStyle_ActionImg:Show()
			end
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_DressBox_HairStyle_LockImg:Show()
		end
	end
	
	--头像
	edType = 2
	local strHeadTip = ""
	cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("PORTRAIT")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPortraitInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{WGTJ_201222_79}", strName)
		NewExterior_DressBox_PlayerFrame_LeftBtn:SetToolTip(strTemp)
		strHeadTip = strTemp
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID then
			NewExterior_DressBox_PlayerFrame_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_DressBox_PlayerFrame_LockImg:Show()
		end		
	end
	
	--幻武
	local cacheWeaponLevel = 0
	cacheExteriorID, cacheWeaponLevel = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Name")
		local strIcon = Exterior:LuaFnGetExteriorWeaponInfo(cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Weapon_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{HSWQ_20220607_02}", strName, tostring(cacheWeaponLevel + 1))
		NewExterior_DressBox_Weapon_LeftBtn:SetToolTip(strTemp)
	
		--试穿
		if Exterior:LuaFnGetExteriorWeaponInUse() ~= cacheExteriorID or cacheWeaponLevel ~= Exterior:LuaFnGetExteriorWeaponLevel() then
			NewExterior_DressBox_Weapon_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExteriorWeapon(cacheExteriorID) ~= 1 then
			NewExterior_DressBox_Weapon_LockImg:Show()
		end
	end
	
	--融魂外观
	local player_level = Player:GetData("LEVEL")
	if player_level < g_PetSoulLevelLimit then
		NewExterior_DressBox_PetSoul_LeftCheckBtn:Hide()
	else
		NewExterior_DressBox_PetSoul_LeftCheckBtn:Show()
	end

	edType = 4
	local strPossTip = ""
	local cachePossVisualIndex = 0
	cacheExteriorID, cachePossVisualIndex = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName 	= Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Name", sex)
		local strIcon 	= Exterior:LuaFnGetExteriorPossInfo(cacheExteriorID, "Icon", sex)
		local strImage = GetIconFullName(strIcon)		
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_PetSoul_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{SHRH_20220427_64}", strName)
		NewExterior_DressBox_PetSoul_LeftBtn:SetToolTip(strTemp)
		
		--试穿
		if Exterior:LuaFnGetExteriorInUse(edType) ~= cacheExteriorID or cachePossVisualIndex ~= Exterior:LuaFnGetExteriorPossVisualIndex() then
			NewExterior_DressBox_PetSoul_ActionImg:Show()
		end
		--未激活
		if Exterior:LuaFnIsHaveExterior(edType, cacheExteriorID) ~= 1 then
			NewExterior_DressBox_PetSoul_LockImg:Show()
		end
	end

	-- 背饰
	local edOrnamentsType, cacheExteriorX, cacheExteriorY, cacheExteriorZ = 0,0,0,0
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsBack")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_DressBox_Widget_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Widget_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_DressBox_Widget_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_DressBox_Widget_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_DressBox_Widget_LockImg:Show()
		end
	end

	edOrnamentsType= 1
	cacheExteriorID, cacheExteriorX, cacheExteriorY, cacheExteriorZ = Exterior:LuaFnGetCurrentExteriorSetInfo("OrnamentsHead")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		local strName = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Name")
		local strIcon = OrnamentsScript:GetOrnamentsInfo(edOrnamentsType, cacheExteriorID, "Icon")
		local strImage = GetIconFullName(strIcon)
		
		NewExterior_DressBox_Headdress_LeftBtn:SetProperty("NormalImage", strImage)
		NewExterior_DressBox_Headdress_LeftBtn:SetProperty("HoverImage", strImage)
		
		local strTemp = ScriptGlobal_Format("#{BGTS_220125_49}", strName)
		NewExterior_DressBox_Headdress_LeftBtn:SetToolTip(strTemp)
		--试穿
		if OrnamentsScript:GetOrnamentsUseID(edOrnamentsType) ~= cacheExteriorID then
			NewExterior_DressBox_Headdress_ActionImg:Show()
		end
		--未激活
		local nIdx, nX, nY, nZ, nState = OrnamentsScript:GetPlayerOrnamentsInfo(edOrnamentsType, cacheExteriorID, 0)
		if nIdx < 0 or (nState ~= g_OrnamentState.TIME and nState ~= g_OrnamentState.FOREVER ) then
			NewExterior_DressBox_Headdress_LockImg:Show()
		end
	end
end

--模型
function NewExterior_DressBox_UpdateObj()
	
	NewExterior_DressBox_FakeObject:SetFakeObject("")
	if g_NewExterior_DressBox_CurPage == 2 then	-- ????
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 then
			NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
			Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
			Exterior:LuaFnUpdateExteriorPlayerData()
			Exterior:LuaFnUpdateExteriorAvatarFashion(2, cacheExteriorID, cacheExteriorIdx)	
		else
			local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
			if cacheExteriorID ~= nil and cacheExteriorID > 0 then
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
				Exterior:LuaFnUpdateExteriorPlayerData()
				Exterior:LuaFnUpdateExteriorAvatarFashion(1, cacheExteriorID, cacheExteriorIdx)	
			else
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
				Exterior:LuaFnUpdateExteriorPlayerData()
			end
		end
	else
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 then
			NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
			Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
			Exterior:LuaFnUpdateExteriorPlayerData()
			Exterior:LuaFnUpdateExteriorAvatarFashion(1, cacheExteriorID, cacheExteriorIdx)	
		else
			local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
			if cacheExteriorID ~= nil and cacheExteriorID > 0 then
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
				Exterior:LuaFnUpdateExteriorPlayerData()
				Exterior:LuaFnUpdateExteriorAvatarFashion(2, cacheExteriorID, cacheExteriorIdx)	
			else
				NewExterior_DressBox_FakeObject:SetFakeObject("Exterior_Player")
				Exterior:LuaFnShowExteriorPlayerPetSoulEffect(1)
				Exterior:LuaFnUpdateExteriorPlayerData()
			end
		end
	end
	
	NewExterior_DressBox_ActionEnd()

	NewExterior_DressBox_UpdateCamera()
	
end

--列表
function NewExterior_DressBox_UpdateList()
	
	if g_NewExterior_DressBox_CurPage == 2 then
		NewExterior_DressBox_UpdateCoupleList()	-- ????
		return
	end
	
	g_NewExterior_DressBox_CurPage = 1
	NewExterior_DressBox_SuperListArrangeBtn:Show()		-- ????
	NewExterior_DressBox_SuperListShareBtn:Show()		-- ????
	NewExterior_DressBox_SuperListShareBtn:SetText("#{FQYG_20230410_6}");
	NewExterior_DressBox_SuperListShareBtn:SetToolTip("#{FQYG_20230410_8}")	
	NewExterior_DressBox_SuperListMineBtn:SetCheck(1)
	NewExterior_DressBox_SuperListOurBtn:SetCheck(0)
	NewExterior_DressBox_SuperList2:Hide()
	NewExterior_DressBox_SuperList:Show()
		
	NewExterior_DressBox_CleanUp_Bar()
	
	-- 显示
	for i, v in pairs(g_PlayerFashionInfoList) do 
	
		local bar = g_BarList[i]
		bar:Show()
	
		local ctrlAction = bar:GetSubItem("NewExterior_DressBox_SuperListItemAction")
		local nVecIndex = v.nVecIndex
		local nExteriorID = FashionDepot:LuaFnGetFashionId(m_PlayerfashionDepotType, nVecIndex)
		-- ActionButton
		local theAction, bLocked = FashionDepot:LuaFnGetFashionDepotItem(m_PlayerfashionDepotType, nVecIndex)
		if theAction:GetID() ~= 0 then
			ctrlAction:SetActionItem(theAction:GetID())
		else
			ctrlAction:SetActionItem(-1)
		end
		
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionEqu"):Hide()
		local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
		if nCurFashionId ~= nil and nCurFashionId > 0 then
			if nCurFashionId == nExteriorID and v.bDressUp == 1 then
				bar:GetSubItem("NewExterior_DressBox_SuperListItemActionEqu"):Show()
			end
		end
		
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare"):Hide()
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare2"):Hide()
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionZhan"):Hide()
		local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(nVecIndex)
		if nCurShareState == 1 then
			bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare"):Show()
			if v.nWearShare == 1 and nCurFashionIdx ~= nVecIndex then
				bar:GetSubItem("NewExterior_DressBox_SuperListItemActionZhan"):Show()
			end
		else
			local nCanShare = Exterior:LuaFnExteriorGetPlayerDepotIsCanShare(nVecIndex)
			if nCanShare == 1 then
				bar:GetSubItem("NewExterior_DressBox_SuperListItemActionShare2"):Show()
			end
		end
				
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionLuxury"):Hide()
		if nExteriorID > 0 then	
			local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nExteriorID, "Number")
			if nFashionNumber ~= nil and nFashionNumber > 0 then
				bar:GetSubItem("NewExterior_DressBox_SuperListItemActionLuxury"):Show()
			end
		end
		
		bar:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
		local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
		if cacheExteriorID ~= nil and cacheExteriorID > 0 then
			if cacheExteriorID == nExteriorID and cacheExteriorIdx == nVecIndex and v.bDressUp == 0 then
				bar:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Show()
			end

			if cacheExteriorID == nExteriorID and cacheExteriorIdx == nVecIndex and v.bDressUp == 1 then
				g_TargetExteriorID = nCurFashionId
				g_TargetExteriorIndex = i
				g_CurSelExteriorID = nCurFashionId
				g_CurSelExteriorIndex = nVecIndex + 1
			end
		end
		
		if g_TargetExteriorID == 0 then			
			if g_CurSelExteriorID == nExteriorID and g_CurSelExteriorIndex == (nVecIndex+1) then
				ctrlAction:SetPushed(1)
			else
				ctrlAction:SetPushed(0)
			end
		else
			if g_TargetExteriorID == nExteriorID and g_TargetExteriorIndex == i then
				ctrlAction:SetPushed(1)				
				g_CurSelExteriorID = g_TargetExteriorID	
				g_CurSelExteriorIndex = nVecIndex + 1
			else
				ctrlAction:SetPushed(0)
			end
		end
	end
	
	if g_NeedChangeScrollSize == 1 then
		NewExterior_DressBox_SuperList:RefreshLayout()
		g_NeedChangeScrollSize = 0
	end

end

function NewExterior_DressBox_ItemBtnClicked(nIndex)
	
	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	-- 右键从衣柜到背包
	Exterior:LuaFnExteriorFashionTakeOut(tabInfo.nVecIndex, -1)

end

--时装动作
function NewExterior_DressBox_onAction(nIndex)
	if not nIndex then 
		return
	end
	
	local tabInfo = g_PlayerFashionInfoList[g_CurSelExteriorIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	for i = 1, table.getn(g_SpecialFashionCamera) do
		if tabInfo.nExteriorID >= g_SpecialFashionCamera[i].startid and tabInfo.nExteriorID <= g_SpecialFashionCamera[i].endid then
			if g_SpecialFashionCamera[i].nIndex == nIndex or g_SpecialFashionCamera[i].nIndex == -1 then 
				local fHeight, fDistance, fPitch = FakeObj_GetCamera("Exterior_Player")
				if g_SpecialFashionCamera[i].fDistance ~= -1 then
					fDistance = g_SpecialFashionCamera[i].fDistance
				end
				if g_SpecialFashionCamera[i].fHeight ~= -1 then
					fHeight = g_SpecialFashionCamera[i].fHeight
				end
				if g_SpecialFashionCamera[i].fPitch ~= -1 then
					fPitch = g_SpecialFashionCamera[i].fPitch
				end
				FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
				FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
				FakeObj_SetCamera("Exterior_Player", g_CameraPitch, fPitch)

				NewExterior_DressBox_Model_Plus:Disable()
				NewExterior_DressBox_Model_Subtract:Disable()
				NewExterior_DressBox_Model_TurnLeft:Disable()
				NewExterior_DressBox_Model_TurnRight:Disable()
				
				KillTimer("NewExterior_DressBox_ActionEnd()");
				SetTimer("NewExterior_DressBox","NewExterior_DressBox_ActionEnd()", g_SpecialFashionCamera[i].timecount)
				break
			end
		end		
	end
	
	Exterior:LuaFnExteriorAvatarPlayAction(1, g_CurSelExteriorIndex-1, nIndex-1)
end

function NewExterior_DressBox_ActionEnd()
	KillTimer("NewExterior_DressBox_ActionEnd()");
	
	NewExterior_DressBox_Model_Plus:Enable()
	NewExterior_DressBox_Model_Subtract:Enable()
	NewExterior_DressBox_Model_TurnLeft:Enable()
	NewExterior_DressBox_Model_TurnRight:Enable()

	NewExterior_DressBox_UpdateCamera()
end

function NewExterior_DressBox_MakeHyperlink(nVecIndex)
	local ret = Exterior:LuaFnExteriorFashionDepotItemClick(m_PlayerfashionDepotType, nVecIndex)
	return ret
end

function NewExterior_DressBox_ItemClicked(nIndex)

	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	if NewExterior_DressBox_MakeHyperlink(tabInfo.nVecIndex) == 1 then
		return
	end
	
	local nVecIndex = tabInfo.nVecIndex+1
	--local nExteriorID = FashionDepot:LuaFnGetFashionId(m_PlayerfashionDepotType, nIndex-1)
	if g_CurSelExteriorID ~= tabInfo.nExteriorID or g_CurSelExteriorIndex ~= nVecIndex then	
		g_CurSelExteriorID = tabInfo.nExteriorID
		g_CurSelExteriorIndex = nVecIndex
		
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", g_CurSelExteriorID, nVecIndex-1)		
		NewExterior_DressBox_SetItemSelected(nIndex)
			
		NewExterior_DressBox_UpdateObj()	
		NewExterior_DressBox_UpdateLeftBtn()
		
		NewExterior_DressBox_ShowCoupleDressButton()
	else
		g_CurSelExteriorID = 0
		g_CurSelExteriorIndex = -1
		local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
		if nCurFashionId ~= nil and nCurFashionId > 0 then
			g_CurSelExteriorID = nCurFashionId
			g_CurSelExteriorIndex = nCurFashionIdx			
		end
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", g_CurSelExteriorID, g_CurSelExteriorIndex)		
				
		local nCurCoupleFashionIdx, nCurCoupleFashionId = Exterior:LuaFnGetCoupleFashionInUse()
		if nCurCoupleFashionIdx ~= nil and nCurCoupleFashionIdx >= 0 then
			Exterior:LuaFnSetCurrentExteriorSetInfo("COUPLEDRESS", nCurCoupleFashionId, nCurCoupleFashionIdx)	
		end
		
		NewExterior_DressBox_Show()
	end	
end

function NewExterior_DressBox_SetItemSelected(nIndex)

	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	for i = 1, g_MaxBarNum do		
		if g_BarList[i] ~= nil then	
			g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
			
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					if tabInfo.bDressUp == 0 then
						g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Show()
					end
	
					local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
					if nCurFashionId ~= nil and nCurFashionId > 0 then
						if nCurFashionIdx == tabInfo.nVecIndex then
						g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemActionTry"):Hide()
						end
					end
					
				else
					ctrlAction:SetPushed(0)	
				end
			end
		end
	end
end

function NewExterior_DressBox_CloseClick()	
	Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
		
	NewExterior_DressBox_SavePosition()
	this:Hide()
end

function NewExterior_DressBox_OnHidden()

	if IsWindowShow("Profile_Save") then
		CloseWindow("Profile_Save", true)
	end
	
	if IsWindowShow("NewExterior_Ride") 
		or IsWindowShow("NewExterior_Facestyle") 
		or IsWindowShow("NewExterior_HairStyle") 
		or IsWindowShow("NewExterior_PlayerFrame")
		or IsWindowShow("NewExterior_PetSoul") 
		or IsWindowShow("NewExterior_Weapon")
		or IsWindowShow("NewExterior_Widget")
		or IsWindowShow("NewExterior_Headdress") then
	else	
		Exterior:LuaFnRestoreExteriorPlayerFittingData(EXTERIORFILTTING_TOTALKIND)
	end	

	NewExterior_DressBox_CleanUp_Bar()
	
	NewExterior_DressBox_CleanUp()
end
	
function NewExterior_DressBox_CleanUp_LeftButton()

	NewExterior_DressBox_Dress_LeftBtn:SetActionItem(-1)
	
	local ctrl_list = {
		NewExterior_DressBox_Ride_LeftBtn,
		NewExterior_DressBox_FaceStyle_LeftBtn,
		NewExterior_DressBox_HairStyle_LeftBtn,
		NewExterior_DressBox_PlayerFrame_LeftBtn,
		NewExterior_DressBox_PetSoul_LeftBtn,
		NewExterior_DressBox_Weapon_LeftBtn,
		NewExterior_DressBox_Widget_LeftBtn,
		NewExterior_DressBox_Headdress_LeftBtn,
	}
	
	for i in pairs(ctrl_list) do
		ctrl_list[i]:SetProperty("Empty", "False")
		ctrl_list[i]:SetProperty("UseDefaultTooltip", "True")
		ctrl_list[i]:SetProperty("NormalImage", "")
		ctrl_list[i]:SetProperty("HoverImage", "")
		ctrl_list[i]:SetToolTip("")
	end
	
	NewExterior_DressBox_Dress_LeftBtnLuxury:Hide()
	NewExterior_DressBox_Dress_ActionImg:Hide()
	NewExterior_DressBox_Ride_ActionImg:Hide()
	NewExterior_DressBox_FaceStyle_ActionImg:Hide()
	NewExterior_DressBox_HairStyle_ActionImg:Hide()
	NewExterior_DressBox_PlayerFrame_ActionImg:Hide()
	NewExterior_DressBox_PetSoul_ActionImg:Hide()
	NewExterior_DressBox_Weapon_ActionImg:Hide()
	NewExterior_DressBox_Widget_ActionImg:Hide()
	NewExterior_DressBox_Headdress_ActionImg:Hide()

	NewExterior_DressBox_Dress_LockImg:Hide()
	NewExterior_DressBox_Ride_LockImg:Hide()
	NewExterior_DressBox_FaceStyle_LockImg:Hide()
	NewExterior_DressBox_HairStyle_LockImg:Hide()
	NewExterior_DressBox_PlayerFrame_LockImg:Hide()
	NewExterior_DressBox_PetSoul_LockImg:Hide()
	NewExterior_DressBox_Weapon_LockImg:Hide()
	NewExterior_DressBox_Widget_LockImg:Hide()
	NewExterior_DressBox_Headdress_LockImg:Hide()
end

function NewExterior_DressBox_CleanUp_ShareBar()
	for i = 1, g_MaxShareBarNum do
		if g_ShareBarList[i] then
			local ctrlAction = g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemAction")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end
	end
end

function NewExterior_DressBox_CleanUp_Bar()
	for i = 1, g_MaxBarNum do
		if g_BarList[i] then
			local ctrlAction = g_BarList[i]:GetSubItem("NewExterior_DressBox_SuperListItemAction")			
			if ctrlAction then
				ctrlAction:SetActionItem(-1)
			end
		end
	end
end

function NewExterior_DressBox_CleanUp()
	
	NewExterior_DressBox_FakeObject:SetFakeObject("")
	
	NewExterior_DressBox_CleanUp_LeftButton()
	
end

--左转
function NewExterior_DressBox_FakeObject_TurnLeft(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_DressBox_FakeObject:RotateBegin(-0.3)
	else
		NewExterior_DressBox_FakeObject:RotateEnd()
	end
	
end

--右转
function NewExterior_DressBox_FakeObject_TurnRight(idx)
	
	if idx == 1 and CEArg:GetValue("MouseButton") == "LeftButton" then
		NewExterior_DressBox_FakeObject:RotateBegin(0.3)
	else
		NewExterior_DressBox_FakeObject:RotateEnd()
	end
	
end

--缩小
function NewExterior_DressBox_ZoomOut()

	if g_Distance == 1 then
		return
	end
	
	g_Distance = g_Distance - 1	

	NewExterior_DressBox_UpdateCamera()
	
end

--放大
function NewExterior_DressBox_ZoomIn()

	if g_Distance == g_Distance_Max then
		return
	end
	
	g_Distance = g_Distance + 1	
	
	NewExterior_DressBox_UpdateCamera()

end

function NewExterior_DressBox_UpdateCamera()

	local sex = Player:GetMySex()
	if sex ~= 0 and sex ~= 1 then 
		return
	end
		
	if g_Distance < 1 or g_Distance > g_Distance_Max then
		return
	end

	fHeight = g_CameraPosition[sex][g_Distance].fHeight
	fDistance = g_CameraPosition[sex][g_Distance].fDistance
	fPitch = g_CameraPosition[sex][g_Distance].fPitch

	FakeObj_SetCamera("Exterior_Player", g_CameraHeight, fHeight)
	FakeObj_SetCamera("Exterior_Player", g_CameraDistance, fDistance)
	FakeObj_SetCamera("Exterior_Player", g_CameraPitch, fPitch)

end

--时装仓库到背包
function NewExterior_DressBox_FashionDepotToBag(nSourcePos, targetPos)
	if targetPos ~= -1 then
		local theAction, bLocked, bProtect, nElapsedTime = PlayerPackage:EnumItem("base", targetPos);
		if theAction:GetID() ~= 0  then 
			local opResult = FashionDepot:LuaFnJudgeBagItem(m_PlayerfashionDepotType, targetPos)
			if opResult == 2 then --????
				PushDebugMessage("#{HCG_190117_18}")
				return
			end
			
			if opResult == 5 then --???????? -???????????? ?????? enCGFashionDepotOperationType_TakeOut=2
				PushEvent("EXTERIOR_FASHION_CONFIRM", 1000, m_PlayerfashionDepotType, 2, nSourcePos, targetPos) --????
				return
			end
			
			--镶嵌有 密语金丝 --计时时装 
			if opResult == 3 or opResult == 4 or opResult == 1 then 
				Exterior:LuaFnExteriorFashionTakeOut(nSourcePos, targetPos)
				return
			end
		end
	end	
	Exterior:LuaFnExteriorFashionTakeOut(nSourcePos, targetPos)
end

--背包到时装仓库
function NewExterior_DressBox_BagToFashionDepot(opType, nSourcePos, targetPos)

	local theAction, bLocked, bProtect, nElapsedTime = PlayerPackage:EnumItem("base", nSourcePos);
	if theAction:GetID() ~= 0  then 
		local opResult = FashionDepot:LuaFnJudgeBagItem(m_PlayerfashionDepotType, nSourcePos)
		if opResult == 2 then --????
			PushDebugMessage("#{HCG_190117_18}")
			return
		end
		
		if opResult == 5 then --???????? -???????????? ??????
			PushEvent("EXTERIOR_FASHION_CONFIRM", 1000, m_PlayerfashionDepotType, opType, nSourcePos, targetPos) --????
			return
		end
		
		--镶嵌有 密语金丝 --计时时装 
		if opResult == 3 or opResult == 4 or opResult == 1 then 
			Exterior:LuaFnExteriorFashionOperation(m_PlayerfashionDepotType, opType, nSourcePos, targetPos)
		end
	end
	
end

--卸下时装 
function NewExterior_DressBox_ActionToDressBox()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	if cacheExteriorID ~= nil and cacheExteriorID > 0 then
		cacheExteriorID = 0
		cacheExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", cacheExteriorID, cacheExteriorIdx)			
		NewExterior_DressBox_Show()
		--return
	end
	
	local CoupleExteriorID, CoupleExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
	if CoupleExteriorIdx ~= nil and CoupleExteriorIdx >= 0 then
		CoupleExteriorID = 0
		CoupleExteriorIdx = -1
		Exterior:LuaFnSetCurrentExteriorSetInfo("COUPLEDRESS", CoupleExteriorID, CoupleExteriorIdx)			
		NewExterior_DressBox_Show()
	end
	
	Exterior:LuaFnUnUseExteriorFashion(m_PlayerfashionDepotType)
end

--保存
function NewExterior_DressBox_DressChange_Save()

	if Exterior:LuaFnIsHaveExteriorChange() == 0 then
		PushDebugMessage("#{WGJM_210104_02}")
		return
	end
	
	Exterior:LuaFnSaveExteriorAllChange(1)
end

--还原
function NewExterior_DressBox_Undo()

	if Exterior:LuaFnIsHaveExteriorChange() == 0 then
		PushDebugMessage("#{WGJM_210104_01}")
		return
	end	
	Exterior:LuaFnRemovePlayerExteriorFitting()
	Exterior:LuaFnSetCurrentExteriorSetInfo("RESET")
	Exterior:LuaFnInitCurrentExteriorSet(0)
	NewExterior_DressBox_Show()
end

--狖理
function NewExterior_DressBox_ClickClearUpBtn()

	g_CurSelExteriorID = 0
	g_CurSelExteriorIndex = -1
	
	local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
	if nCurFashionId ~= nil and nCurFashionId > 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", nCurFashionId, nCurFashionIdx)
	else
		Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", g_CurSelExteriorID, g_CurSelExteriorIndex)
	end
	
	Exterior:LuaFnInitCurrentExteriorSet(0)		
		
	FashionDepot:LuaFnRefreshFashionDepot(1)
end

--时装
function NewExterior_DressBox_OpenFashion()
	local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("FASHION")
	Exterior:LuaFnExteriorFashionDepotItemClick(m_PlayerfashionDepotType, cacheExteriorIdx)
	--NewExterior_DressBox_SavePosition()
	--PushEvent("OPEN_EXTERIOR_FASHION", 1, 0)
end

--坐骑
function NewExterior_DressBox_OpenRide()
	NewExterior_DressBox_SavePosition()
	Exterior:LuaFnAskOpenExterior(3)
end

--发型
function NewExterior_DressBox_OpenHair()
	NewExterior_DressBox_SavePosition()	
	Exterior:LuaFnAskOpenExterior(1)
end

--脸型
function NewExterior_DressBox_OpenFace()
	NewExterior_DressBox_SavePosition()	
	Exterior:LuaFnAskOpenExterior(0)
end

--头像
function NewExterior_DressBox_OpenPortrait()
	NewExterior_DressBox_SavePosition()	
	Exterior:LuaFnAskOpenExterior(2)
end

--幻武
function NewExterior_DressBox_OpenWeapon()
	NewExterior_DressBox_SavePosition()
	Exterior:LuaFnAskOpenExteriorWeapon()
end

--融魂外观
function NewExterior_DressBox_OpenPoss()
	NewExterior_DressBox_SavePosition()
	Exterior:LuaFnAskOpenExterior(4)
end

-- 背挂
function NewExterior_DressBox_OpenOrnamentsBack()
	NewExterior_DressBox_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(0)
end

-- 头饰
function NewExterior_DressBox_OpenOrnamentsHead()
	NewExterior_DressBox_SavePosition()	
	OrnamentsScript:AskOrnamentsInfo(1)
end

function NewExterior_DressBox_TakeOffRide()
	local cacheExteriorID = Exterior:LuaFnGetCurrentExteriorSetInfo("RIDE")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(3)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("RIDE", 0)
		NewExterior_DressBox_UpdateLeftBtn()
	else
		Exterior:LuaFnSetExteriorInUse(3, 0, 0)
	end
end

function NewExterior_DressBox_TakeOffPoss()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("POSS")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorInUse(4)
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("POSS", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(4)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateObj()
	else
		Exterior:LuaFnSetExteriorInUse(4, 0, 0)
	end
end

function NewExterior_DressBox_TakeOffWeapon()
	local cacheExteriorID, _ = Exterior:LuaFnGetCurrentExteriorSetInfo("WEAPON")
	if cacheExteriorID == 0 then
		return
	end
	local defExteriorID = Exterior:LuaFnGetExteriorWeaponInUse()
	if defExteriorID == 0 then
		Exterior:LuaFnSetCurrentExteriorSetInfo("WEAPON", 0, 0)
		Exterior:LuaFnRestoreExteriorPlayerFittingData(5)
		Exterior:LuaFnUpdateExteriorPlayerData()
		NewExterior_DressBox_UpdateLeftBtn()
		NewExterior_DressBox_UpdateObj()
	else
		Exterior:LuaFnSetExteriorWeaponInUse(0, 0)
	end
end

function NewExterior_DressBox_ActionToOrnamentsBack()
	local useID = OrnamentsScript:GetOrnamentsUseID(0)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(0)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSBACK", 0, 0, 0, 0)
	NewExterior_DressBox_UpdateLeftBtn()
	NewExterior_DressBox_UpdateObj()
end

function NewExterior_DressBox_ActionToOrnamentsHead()
	local useID = OrnamentsScript:GetOrnamentsUseID(1)
	if useID > 0 then
		OrnamentsScript:TakeOffOrnaments(1)
	end
	Exterior:LuaFnSetCurrentExteriorSetInfo("ORNAMENTSHEAD", 0, 0, 0, 0)
	NewExterior_DressBox_UpdateLeftBtn()
	NewExterior_DressBox_UpdateObj()
end

function NewExterior_DressBox_UpdateRedPoint()
	
	NewExterior_DressBox_Dress_Tip:Hide()
	
	if Exterior:LuaFnIsHaveCoupleFashionShowTip(-1) == 1 then
		NewExterior_DressBox_SuperListOurBtn_Tip:Show()
	else
		NewExterior_DressBox_SuperListOurBtn_Tip:Hide()
    end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(3) == 1 then
		NewExterior_DressBox_Ride_Tip:Show()
	else
		NewExterior_DressBox_Ride_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(0) == 1 then
		NewExterior_DressBox_FaceStyle_Tip:Show()
	else
		NewExterior_DressBox_FaceStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(1) == 1 or Exterior:LuaFnIsHaveHairColorShowTip() == 1 then
		NewExterior_DressBox_HairStyle_Tip:Show()
	else
		NewExterior_DressBox_HairStyle_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorShowTip(2) == 1 then
		NewExterior_DressBox_PlayerFrame_Tip:Show()
	else
		NewExterior_DressBox_PlayerFrame_Tip:Hide()
	end

	if Exterior:LuaFnIsHaveExteriorShowTip(4) == 1 then
		NewExterior_DressBox_PetSoul_Tip:Show()
	else
		NewExterior_DressBox_PetSoul_Tip:Hide()
	end
	
	if Exterior:LuaFnIsHaveExteriorWeaponShowTip() == 1 then
		NewExterior_DressBox_Weapon_Tip:Show()
	else
		NewExterior_DressBox_Weapon_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(0) == 1 then
		NewExterior_DressBox_Widget_Tip:Show()
	else
		NewExterior_DressBox_Widget_Tip:Hide()
	end

	if OrnamentsScript:IsHaveOrnamentsShowTip(1) == 1 then
		NewExterior_DressBox_Headdress_Tip:Show()
	else
		NewExterior_DressBox_Headdress_Tip:Hide()
	end
end

function NewExterior_DressBox_CloseSameGroupWindow()
	CloseWindow("SelfEquip", true)
	--CloseWindow("NewExterior_DressBox", true)
	CloseWindow("NewExterior_Ride", true)
	CloseWindow("NewExterior_Facestyle", true)
	CloseWindow("NewExterior_HairStyle", true)
	CloseWindow("NewExterior_PlayerFrame", true)
	CloseWindow("NewExterior_PetSoul", true)
	CloseWindow("NewExterior_Weapon", true)
	CloseWindow("NewExterior_Widget", true)
	CloseWindow("NewExterior_Headdress", true)
end

function NewExterior_DressBox_SavePosition()
	Variable:SetVariable("ExteriorUnionPos", NewExterior_DressBox_Frame:GetProperty("UnifiedPosition"), 1)
end

function NewExterior_DressBox_SetPosition()
	
	local nExteriorUnionPos = Variable:GetVariable("ExteriorUnionPos")
	if nExteriorUnionPos ~= nil then
		NewExterior_DressBox_Frame:SetProperty("UnifiedPosition", nExteriorUnionPos)
	end

end

function NewExterior_DressBox_ShowFashionWeaponCheckButton()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	NewExterior_DressBox_Dress_Type:SetCheck(IsDisplay)
end

function NewExterior_DressBox_FashionDisplay()
	local IsDisplay = SystemSetup:Get_Display_Dress()
	if IsDisplay == 1 then
		NewExterior_DressBox_Dress_Type:SetCheck(0)
		SystemSetup:Set_Display_Dress(0)
	else
		NewExterior_DressBox_Dress_Type:SetCheck(1)
		SystemSetup:Set_Display_Dress(1)
	end	
end

function NewExterior_DressBox_ShowDressShareButton()
	
	local player_level = Player:GetData("LEVEL")
	if player_level >= 15 then
		NewExterior_DressBox_SaveChangeBtn:Hide()
		NewExterior_DressBox_ShareBtn:Show()
	else
		NewExterior_DressBox_SaveChangeBtn:Hide()
		NewExterior_DressBox_ShareBtn:Hide()
	end
	
end

function NewExterior_DressBox_Share_Clicked()
	local ret = Exterior:LuaFnExteriorPlayerShareClick(0)
	return ret	
end

function NewExterior_DressBox_SaveChange_Clicked()	
	local ret = Exterior:LuaFnExteriorPlayerOpenSharePlan()
	return ret	
end

--共享衣柜按钮刷新
function NewExterior_DressBox_ShowCoupleDressButton()
	
	local IsShowButton = 1
	local player_level = Player:GetData("LEVEL")
	local sex = Player:GetMySex()
	if sex == 1 then
		if player_level < g_NewExterior_DressBox_MLevel then
			IsShowButton = 0
		end
	end
	
	if sex == 0 then
		if player_level < g_NewExterior_DressBox_FLevel then
			IsShowButton = 0
		end
	end
	
	if g_NewExterior_DressBox_Married == 0 then
		IsShowButton = 0
	end
	
	if IsShowButton == 0 then
		NewExterior_DressBox_SuperListOurBtn:Hide()
	else
		NewExterior_DressBox_SuperListOurBtn:Show()
	end
	
	if g_NewExterior_DressBox_CurPage == 2 then
		IsShowButton = 0
	end
	
	if IsShowButton == 0 then
		NewExterior_DressBox_SuperListShareBtn:Hide()
	else
		NewExterior_DressBox_SuperListShareBtn:Show()
		
		if 	g_CurSelExteriorIndex >= 0 then
			local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(g_CurSelExteriorIndex-1)
			if nCurShareState == 1 then
				NewExterior_DressBox_SuperListShareBtn:SetText("#{FQYG_20230410_7}");
				NewExterior_DressBox_SuperListShareBtn:SetToolTip("#{FQYG_20230410_9}")
			else
				NewExterior_DressBox_SuperListShareBtn:SetText("#{FQYG_20230410_6}");
				NewExterior_DressBox_SuperListShareBtn:SetToolTip("#{FQYG_20230410_8}")
			end
		end
	end
		
	
end

--打开我的衣柜
function NewExterior_DressBox_OnOpenMyBox()
	if g_NewExterior_DressBox_CurPage == 1 then
		return
	end
	
	g_NewExterior_DressBox_CurPage = 1
	NewExterior_DressBox_UpdateList()
	
	NewExterior_DressBox_UpdateLeftBtn()		
end

--打开共享衣柜
function NewExterior_DressBox_OnOpenOurBox()
	if g_NewExterior_DressBox_CurPage == 2 then
		return
	end
	
	g_NewExterior_DressBox_CurPage = 2
	NewExterior_DressBox_UpdateCoupleList()
	
	NewExterior_DressBox_UpdateLeftBtn()	
end

function NewExterior_DressBox_RemoveCoupleTip(nExteriorIdx)

	if g_NewExterior_DressBox_CurPage ~= 2 then
		return
	end

	local tabInfo = g_SpouseCoupleFashionInfoList[nExteriorIdx]
	if not tabInfo or tabInfo.nExteriorID < 0 or tabInfo.nVecIndex < 0 then 
		return
	end
	
	local nTip = Exterior:LuaFnIsHaveCoupleFashionShowTip( tabInfo.nVecIndex )
	if nTip == 1 then
		Exterior:LuaFnRemoveCoupleFashionShowTip( tabInfo.nVecIndex )
		for i = 1, g_MaxShareBarNum do
			if g_ShareBarList[i] then
				tabInfo = g_SpouseCoupleFashionInfoList[i]
				if tabInfo and tabInfo.nVecIndex >= 0 then
					if Exterior:LuaFnIsHaveCoupleFashionShowTip( tabInfo.nVecIndex ) == 1 then
						g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Show()
					else
						g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Hide()
					end
				else
					g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Hide()
				end
			end
		end	
	end
end

--共享时装
function NewExterior_DressBox_UpdateCoupleList()
	
	g_NewExterior_DressBox_CurPage = 2
	NewExterior_DressBox_SuperListArrangeBtn:Hide()	-- ????
	NewExterior_DressBox_SuperListShareBtn:Hide()	-- ????
	NewExterior_DressBox_SuperListMineBtn:SetCheck(0)
	NewExterior_DressBox_SuperListOurBtn:SetCheck(1)
	NewExterior_DressBox_SuperList2:Show()
	NewExterior_DressBox_SuperList:Hide()

	NewExterior_DressBox_CleanUp_ShareBar()
		
	g_CurSelExteriorID = 0
	g_CurSelExteriorIndex = -1
	
	-- 显示
	for i, v in pairs(g_SpouseCoupleFashionInfoList) do 
	
		local bar = g_ShareBarList[i]
		bar:Show()
		
		local nVecIndex = v.nVecIndex
		local nExteriorID = v.nExteriorID
		
		if nVecIndex >= 0 then	
			local ctrlAction = bar:GetSubItem("NewExterior_DressBox_SuperList2ItemAction")
			-- ActionButton
			local theAction, bLocked = Exterior:LuaFnGetCoupleFashionDepotItem(nVecIndex)
			if theAction:GetID() ~= 0 then
				ctrlAction:SetActionItem(theAction:GetID())
			else
				ctrlAction:SetActionItem(-1)
			end
			
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionShare"):Hide()
			
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionEqu"):Hide()
			local nCurFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
			if nCurFashionIdx ~= nil and nCurFashionIdx >= 0 and v.bDressUp == 1 then
				bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionEqu"):Show()
			end
			
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionZhan"):Hide()
			if v.nWearShare == 1 and nCurFashionIdx ~= nVecIndex then
				bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionZhan"):Show()
			end
		
			if Exterior:LuaFnIsHaveCoupleFashionShowTip( nVecIndex ) == 1 then
				bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Show()
			else
				bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Hide()
			end
				
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionLuxury"):Hide()
			if nExteriorID > 0 then	
				local nFashionNumber = Exterior:LuaFnGetNumberingFashionInfo(nExteriorID, "Number")
				if nFashionNumber ~= nil and nFashionNumber > 0 then
					bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionLuxury"):Show()
				end
			end
				
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Hide()
			local cacheExteriorID, cacheExteriorIdx = Exterior:LuaFnGetCurrentExteriorSetInfo("COUPLEDRESS")
			if cacheExteriorIdx ~= nil and cacheExteriorIdx >= 0 then
				if cacheExteriorID == nExteriorID and cacheExteriorIdx == nVecIndex and v.bDressUp == 0 then
					bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Show()
				end

				if cacheExteriorID == nExteriorID and cacheExteriorIdx == nVecIndex and v.bDressUp == 1 then
					g_CurSelExteriorID = nCurFashionId
					g_CurSelExteriorIndex = nVecIndex + 1 + g_CurSel_Offset
				end
			end
		else			
			--共享中
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionShare"):Hide()
			--可共享
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionShare2"):Hide()
			--新		
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTip"):Hide()
			--牸用
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionZhan"):Hide()
			--试穿标识
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Hide()
			--当前装备中
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionEqu"):Hide()
			--编号特效
			bar:GetSubItem("NewExterior_DressBox_SuperList2ItemActionLuxury"):Hide()
		end
	end
		
end

function NewExterior_DressBox_Item2Clicked(nIndex)

	local tabInfo = g_SpouseCoupleFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	if g_CurSelExteriorIndex > g_CurSel_Offset then
		g_CurSelExteriorIndex = g_CurSelExteriorIndex - g_CurSel_Offset
	end	
	
	
	local nVecIndex = tabInfo.nVecIndex+1
	if g_CurSelExteriorID ~= tabInfo.nExteriorID or g_CurSelExteriorIndex ~= nVecIndex then	
		g_CurSelExteriorID = tabInfo.nExteriorID
		g_CurSelExteriorIndex = nVecIndex
		
		Exterior:LuaFnSetCurrentExteriorSetInfo("COUPLEDRESS", g_CurSelExteriorID, nVecIndex-1)		
		NewExterior_DressBox_SetItem2Selected(nIndex)
			
		NewExterior_DressBox_UpdateObj()
		
		NewExterior_DressBox_UpdateLeftBtn()
		
		NewExterior_DressBox_RemoveCoupleTip(g_CurSelExteriorIndex)
		NewExterior_DressBox_UpdateRedPoint()
	else
		g_CurSelExteriorID = 0
		g_CurSelExteriorIndex = -1
		
		local nCurCoupleFashionIdx, nCurCoupleFashionId = Exterior:LuaFnGetCoupleFashionInUse()
		if nCurCoupleFashionIdx ~= nil and nCurCoupleFashionIdx >= 0 then
			g_CurSelExteriorIndex = nCurCoupleFashionIdx	
			g_CurSelExteriorID = nCurCoupleFashionId
		end		
		Exterior:LuaFnSetCurrentExteriorSetInfo("COUPLEDRESS", g_CurSelExteriorID, g_CurSelExteriorIndex)		

		local nCurFashionId, nCurFashionIdx = Exterior:LuaFnGetExteriorFashionInUse()
		if nCurFashionId ~= nil and nCurFashionId > 0 then
			Exterior:LuaFnSetCurrentExteriorSetInfo("FASHION", nCurFashionId, nCurFashionIdx)			
		end	
		
		NewExterior_DressBox_Show()
	end	
end

function NewExterior_DressBox_SetItem2Selected(nIndex)

	local tabInfo = g_SpouseCoupleFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		return
	end
	
	for i = 1, g_MaxShareBarNum do		
		if g_ShareBarList[i] ~= nil then	
			g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Hide()
			
			local ctrlAction = g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemAction")
			if ctrlAction ~= nil then
				if i == nIndex then
					ctrlAction:SetPushed(1)
					if tabInfo.bDressUp == 0 then
						g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Show()
					end
	
					local nCurCoupleFashionIdx = Exterior:LuaFnGetCoupleFashionInUse()
					if nCurCoupleFashionIdx ~= nil and nCurCoupleFashionIdx >= 0 and nCurCoupleFashionIdx == tabInfo.nVecIndex then
						g_ShareBarList[i]:GetSubItem("NewExterior_DressBox_SuperList2ItemActionTry"):Hide()
					end
					
				else
					ctrlAction:SetPushed(0)	
				end
			end
		end
	end
end

function NewExterior_DressBox_CoupleDress_Clicked()
	
	local tabInfo = g_PlayerFashionInfoList[g_CurSelExteriorIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		PushDebugMessage("#{FQYG_20230410_12}")
		return
	end
	
	local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(tabInfo.nVecIndex)
	if nCurShareState == 1 then
		NewExterior_DressBox_MoveCoupleFashion_Clicked(g_CurSelExteriorIndex)
	else
		NewExterior_DressBox_AddCoupleFashion_Clicked(g_CurSelExteriorIndex)
	end
	
end

function NewExterior_DressBox_AddCoupleFashion_Clicked(nIndex)
	
	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		PushDebugMessage("#{FQYG_20230410_12}")
		return
	end
	
	local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(tabInfo.nVecIndex)
	if nCurShareState == 1 then
	--	PushDebugMessage("#{FQYG_20230410_27}")
	--	return
	end
			
	local nCanShare = Exterior:LuaFnExteriorGetPlayerDepotIsCanShare(tabInfo.nVecIndex)
	if nCanShare ~= 1 then
	--	PushDebugMessage("#{FQYG_20230410_12}")
	--	return
	end
	
	local itemName = DataPool:LuaFnGetItemNameByTableIndex(tabInfo.nExteriorID)
	PushEvent("COUPLE_FASHION_ADD_CONFIRM", tabInfo.nVecIndex, tabInfo.nExteriorID, itemName)
	--Exterior:LuaFnExteriorAddCoupleFashion(tabInfo.nVecIndex)	
end

function NewExterior_DressBox_MoveCoupleFashion_Clicked(nIndex)
	
	local tabInfo = g_PlayerFashionInfoList[nIndex]
	if not tabInfo or tabInfo.nExteriorID < 0 then 
		PushDebugMessage("#{FQYG_20230410_12}")
		return
	end
	
	local nCurShareState, nCurCoupleDepotPos, nCurWearState = Exterior:LuaFnGetMyCoupleFashionInfoByPlayerDepotIdx(tabInfo.nVecIndex)
	if nCurShareState ~= 1 then
	--	PushDebugMessage("#{FQYG_20230410_21}")
	--	return
	end
	
	if nCurWearState > 0 then
	--	PushDebugMessage("#{FQYG_20230410_19}")
	--	return
	end
	
	local itemName = DataPool:LuaFnGetItemNameByTableIndex(tabInfo.nExteriorID)
	PushEvent("COUPLE_FASHION_MOVE_CONFIRM", tabInfo.nVecIndex, tabInfo.nExteriorID, itemName)
	--Exterior:LuaFnExteriorMoveCoupleFashion(tabInfo.nVecIndex)	
end

--!!!reloadscript =NewExterior_DressBox
