local g_ManTuo_Gift_Frame_UnifiedPosition =nil
local g_MAX_OBJ_DISTANCE 		= 5.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredObj 			= 1
local g_MissionTimes = -1
local g_giftState = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
}
local g_MissionTimesLevel = {3,7,12}
local g_UI_Item = {}
local g_ShowItems = {
	{itemID=20310168,num=8},
	{itemID=50313004,num=1},
	{itemID=38002615,num=1},
}
local g_UICOMMAND = 88998901
--=========================================================
-- PreLoad
--=========================================================
function ManTuo_Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function ManTuo_Gift_OnLoad()
	g_ManTuo_Gift_Frame_UnifiedPosition = ManTuo_Gift_Frame:GetProperty("UnifiedPosition")
	g_UI_Item.gift = {}
	for i = 1, table.getn(g_giftState) do
		g_UI_Item.gift[i] = {
			btn = _G["ManTuo_Gift_Award"..i],
			got = _G[string.format( "ManTuo_Gift_Award%dOK",i)],
			times = _G[string.format( "ManTuo_Gift_Award%dText",i)],
			available = _G[string.format( "ManTuo_Gift_Award%dAnimate",i)],
		}
	end
	g_UI_Item.acculateText = ManTuo_Gift_TakeOn_Text2

end

--=========================================================
-- OnEvent
--=========================================================
function ManTuo_Gift_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND ) then
		-- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关睜界面
		if 0 == nOpType then	
			if this:IsVisible() then
				ManTuo_Gift_Close()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 显示界面
			-- 为了解决界面被犣挡的问题，先把界面关了
			-- if this:IsVisible() then
			-- 	ManTuo_Gift_Close()
			-- end
			ManTuo_Gift_Reset()
			ManTuo_Gift_Frame_On_ResetPos()
			this:Show()
			ManTuo_Gift_ParamInit()
			ManTuo_Gift_Show()
		end
			
		

	-- ============================================
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>g_MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			ManTuo_Gift_Close()
		end	



	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ManTuo_Gift_Close()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ManTuo_Gift_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ManTuo_Gift_Frame_On_ResetPos()

	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function ManTuo_Gift_ParamInit()
	g_MissionTimes =  Get_XParam_INT(1)
	if 1 == bCaredObj then
		local nServerObjID 	= Get_XParam_INT(2)
		if nServerObjID == nil or nServerObjID < 0 then
			if this:IsVisible() then
				ManTuo_Gift_Close()
			end
		end
		g_nServerObjID = nServerObjID
		g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
		BeginCareObject_ManTuo_Gift()
	end
	for i=1,3 do
		g_giftState[i] = Get_XParam_INT(2+i)
	end
end

function ManTuo_Gift_Show()

	for i = 1, table.getn(g_giftState) do
		--设置牴示道具
		local theAction = DataPool:CreateBindActionItemForShow(g_ShowItems[i].itemID,g_ShowItems[i].num)
		if theAction:GetID() ~= 0 then
			g_UI_Item.gift[i].btn:SetActionItem(theAction:GetID())
		end
		g_UI_Item.gift[i].times:SetText(ScriptGlobal_Format("#{XMPWH_20220906_14}",g_MissionTimesLevel[i]))
		if g_MissionTimes >= g_MissionTimesLevel[i] then
			--达到了
			if g_giftState[i] == 1 then
				--领过了
				g_UI_Item.gift[i].got:Show()
				g_UI_Item.gift[i].available:Hide()
			else
				--没领过
				g_UI_Item.gift[i].got:Hide()
				g_UI_Item.gift[i].available:Show()
			end
		else
			--没达到
			g_UI_Item.gift[i].got:Hide()
			g_UI_Item.gift[i].available:Hide()
		end
	end
	g_UI_Item.acculateText:SetText(ScriptGlobal_Format("#{XMPWH_20220906_13}",g_MissionTimes))
end


function ManTuo_Gift_Award_Item_Clicked(index)
	if index >=1 and index <= table.getn(g_giftState) then
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnGetPrize" )
		Set_XSCRIPT_ScriptID(889989)
		Set_XSCRIPT_Parameter(0, index)
		Set_XSCRIPT_Parameter(1, g_nServerObjID)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

function ManTuo_Gift_Help_Click()
	PushEvent("CCSHOP_HELP", 12)
end

--=========================================================
-- 重置界面
--=========================================================
function ManTuo_Gift_Reset()
	g_MissionTimes = -1
	g_giftState = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
	} 
	g_nServerObjID = -1
end





--=========================================================
-- 关睜界面
--=========================================================
function ManTuo_Gift_Close()	
	this:Hide()
	StopCareObject_ManTuo_Gift()
	-- 重置
	ManTuo_Gift_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="ManTuo_Gift_OnHiden();" />
--=========================================================
function ManTuo_Gift_OnHiden()
	StopCareObject_ManTuo_Gift()
	-- 重置
	ManTuo_Gift_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_ManTuo_Gift()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "ManTuo_Gift")
end

function StopCareObject_ManTuo_Gift()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ManTuo_Gift")
	end
	g_nServerObjID = -1
end



--=========================================================
-- 界面位置
--=========================================================
function ManTuo_Gift_Frame_On_ResetPos()
	ManTuo_Gift_Frame:SetProperty("UnifiedPosition", g_ManTuo_Gift_Frame_UnifiedPosition)
end
