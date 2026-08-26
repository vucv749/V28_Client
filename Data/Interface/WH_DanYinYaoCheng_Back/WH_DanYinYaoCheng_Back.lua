--卡级服 废品回收 
--!!!reloadscript =WH_DanYinYaoCheng_Back
local g_WH_DanYinYaoCheng_Back_Frame_UnifiedPosition = 0

local MAX_OBJ_DISTANCE = 3.0
local g_WH_DanYinYaoCheng_Back_NpcId = -1;
local g_WH_DanYinYaoCheng_Back_TargetId = -1

local g_ItemPos = -1

local g_activItemList = {
	38003146,38003147,38003149,38003150,38003152,38003153,
}--各类口味冰淇淋,对应等级为mod(index-1,3)+1
local g_icecreamLevel = 0
--===============================================
-- PreLoad()
--===============================================
function WH_DanYinYaoCheng_Back_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--离开场景
	this:RegisterEvent("ADJEST_UI_POS",false)				-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- 游戏分辨率发生了变化
	
	this:RegisterEvent("WH_DanYinYaoCheng_Back_ITEM",false)	-- 从背包放入道具

	this:RegisterEvent("OBJECT_CARED_EVENT",false);           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面
end

--===============================================
-- OnLoad()
--===============================================
function WH_DanYinYaoCheng_Back_OnLoad()	
	g_WH_DanYinYaoCheng_Back_Frame_UnifiedPosition = WH_DanYinYaoCheng_Back_Frame:GetProperty("UnifiedPosition")

end

--===============================================
-- OnEvent()
--===============================================
function WH_DanYinYaoCheng_Back_OnEvent(event)
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		WH_DanYinYaoCheng_Back_OnHidden()
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		WH_DanYinYaoCheng_Back_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		WH_DanYinYaoCheng_Back_On_ResetPos()
	end
	if event == "OBJECT_CARED_EVENT" then
		if(tonumber(arg0) ~= g_WH_DanYinYaoCheng_Back_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			WH_DanYinYaoCheng_Back_OnClose()
		end
	
		return
	end
	
	if event == "WH_DanYinYaoCheng_Back_ITEM" and this:IsVisible()then
		WH_DanYinYaoCheng_Back_UpdateItem(arg0)
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 99881401 then
		local updateOrOpen = Get_XParam_INT(0)
		if(updateOrOpen == 0)then
			g_WH_DanYinYaoCheng_Back_TargetId = Get_XParam_INT( 1 )
			WH_DanYinYaoCheng_Back_BeginCareObject( g_WH_DanYinYaoCheng_Back_TargetId )
			WH_DanYinYaoCheng_Back_Open()
		elseif(updateOrOpen == 1)then
			WH_DanYinYaoCheng_Back_UpdateItem(-1)
		end
		
	end
end

function WH_DanYinYaoCheng_Back_Open()
	this:Show()
	OpenWindow("Packet")
	WH_DanYinYaoCheng_Back_UpdateItem(-1)
end

function WH_DanYinYaoCheng_Back_UpdateItem(index)
	if(tonumber(index) < 0 or index == nil)then

		WH_DanYinYaoCheng_Back_Item1_Icon:SetActionItem(-1)

		if (g_ItemPos ~= -1) then
			LifeAbility:Lock_Packet_Item( g_ItemPos, 0 )
			g_ItemPos = -1
		end

	else
		local BagPos = tonumber(index)

		--判断 是否是可回收道具
		local itemid = PlayerPackage:GetItemTableIndex(BagPos)

		if(itemid < 0)then
			return
		end
		for i = 1 ,table.getn(g_activItemList) do
			if itemid == g_activItemList[i] then
				g_icecreamLevel = math.mod(i-1 , 2)+1

				break;
			end
			if i == table.getn(g_activItemList) then
				PushDebugMessage("#{XRBG_20240412_74}") -- 您放入的道具不对，仅可放入丹药道具。
				--进入这里说明放入的道具不是活动道具，取消操作
				return
			end
		end

		--清除当前道具
		WH_DanYinYaoCheng_Back_Item1_Icon:SetActionItem(-1)
		if (g_ItemPos ~= -1) then
			LifeAbility:Lock_Packet_Item( g_ItemPos, 0 )
			g_ItemPos = -1
		end

		--锁定道具
		LifeAbility:Lock_Packet_Item( BagPos, 1 )
		g_ItemPos = BagPos

		local nItemNum = PlayerPackage:GetBagItemNum(BagPos);

		local theAction = DataPool:CreateActionItemForShow(itemid, nItemNum)
		if (theAction:GetID() == 0) then
			return
		end

		WH_DanYinYaoCheng_Back_Item1_Icon:SetActionItem(theAction:GetID())
		
	end
end

function WH_DanYinYaoCheng_Back_SelectClicked()
	if g_ItemPos == -1 then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 998814 )
		Set_XSCRIPT_Function_Name( "RemakeIcecream" )
		Set_XSCRIPT_Parameter(0, g_ItemPos)
		Set_XSCRIPT_Parameter(1, g_icecreamLevel)
		Set_XSCRIPT_Parameter(2, g_WH_DanYinYaoCheng_Back_TargetId)

		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function WH_DanYinYaoCheng_Back_MaskClk()
	WH_DanYinYaoCheng_Back_UpdateItem(-1)
end

function WH_DanYinYaoCheng_Back_OnClose()
	WH_DanYinYaoCheng_Back_OnHidden()
end

function WH_DanYinYaoCheng_Back_OnHidden()
	WH_DanYinYaoCheng_Back_UpdateItem(-1)
	WH_DanYinYaoCheng_Back_StopCareObject()
    this:Hide();
end

--=========================================================
-- 界面位置
--=========================================================
function WH_DanYinYaoCheng_Back_On_ResetPos()
	WH_DanYinYaoCheng_Back_Frame:SetProperty("UnifiedPosition", g_WH_DanYinYaoCheng_Back_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function WH_DanYinYaoCheng_Back_BeginCareObject( objCaredId )
	g_WH_DanYinYaoCheng_Back_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_WH_DanYinYaoCheng_Back_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_WH_DanYinYaoCheng_Back_NpcId, 1, "WH_DanYinYaoCheng_Back" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function WH_DanYinYaoCheng_Back_StopCareObject()
	this : CareObject( g_WH_DanYinYaoCheng_Back_NpcId, 0, "WH_DanYinYaoCheng_Back" )
	g_WH_DanYinYaoCheng_Back_NpcId = -1
end