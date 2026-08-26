--卡级服 废品回收 
--!!!reloadscript =Feipinhuishou
local g_Feipinhuishou_Frame_UnifiedPosition = 0

local MAX_OBJ_DISTANCE = 3.0
local g_Feipinhuishou_NpcId = -1;
local g_Feipinhuishou_TargetId = -1

local g_ItemPos = -1

--===============================================
-- PreLoad()
--===============================================
function Feipinhuishou_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--离开场景
	this:RegisterEvent("ADJEST_UI_POS",false)				-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- 游戏分辨率发生了变化
	
	this:RegisterEvent("FEIPINHUISHOU_ITEM",false)	-- 从背包放入道具

	this:RegisterEvent("OBJECT_CARED_EVENT",false);           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面
end

--===============================================
-- OnLoad()
--===============================================
function Feipinhuishou_OnLoad()	
	g_Feipinhuishou_Frame_UnifiedPosition = Feipinhuishou_Frame:GetProperty("UnifiedPosition")

end

--===============================================
-- OnEvent()
--===============================================
function Feipinhuishou_OnEvent(event)
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		Feipinhuishou_OnHidden()
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		Feipinhuishou_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		Feipinhuishou_On_ResetPos()
	end
	if event == "OBJECT_CARED_EVENT" then
		if(tonumber(arg0) ~= g_Feipinhuishou_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Feipinhuishou_OnClose()
		end
	
		return
	end
	
	if event == "FEIPINHUISHOU_ITEM" and this:IsVisible()then
		Feipinhuishou_UpdateItem(arg0)
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 89018601 then
		local updateOrOpen = Get_XParam_INT(0)
		if(updateOrOpen == 0)then
			g_Feipinhuishou_TargetId = Get_XParam_INT( 1 )
			Feipinhuishou_BeginCareObject( g_Feipinhuishou_TargetId )
			Feipinhuishou_Open()
		elseif(updateOrOpen == 1)then
			Feipinhuishou_UpdateItem(-1)
		end
		
	end
end

function Feipinhuishou_Open()
	this:Show()
	OpenWindow("Packet")
	Feipinhuishou_UpdateItem(-1)
end

function Feipinhuishou_UpdateItem(index)
	local is69kaji = Player : GetData("69KAJI")  
	local is89kaji = Player : GetData("89KAJI") 
	Feipinhuishou_AfterText1:Show()
	Feipinhuishou_AfterText2:Show()
	if is69kaji == 1 then
		Feipinhuishou_InfoText:SetText("#{KJTZ_230706_6}")
	end
	if is89kaji == 1 then
		Feipinhuishou_InfoText:SetText("#{HJKJ_240703_7}")
	end
	if(tonumber(index) < 0 or index == nil)then

		Feipinhuishou_BeforeIcon:SetActionItem(-1)

		if (g_ItemPos ~= -1) then
			LifeAbility:Lock_Packet_Item( g_ItemPos, 0 )
			g_ItemPos = -1
		end
 
		Feipinhuishou_AfterText2:SetProperty("MoneyNumber", 0);

	else
		local BagPos = tonumber(index) 
		--判断 是否已加锁
		if (PlayerPackage:IsLock(BagPos) == 1) then
			PushDebugMessage("#{KJTZ_230706_13}")
			return
		end

		--判断 是否是可回收道具
		local itemid = PlayerPackage:GetItemTableIndex(BagPos)
		if(itemid < 0)then
			PushDebugMessage("#{KJTZ_230706_15}")
			return
		end
		

		local awardType = 0
		local awardNum  = 0
		if is69kaji ==1 then
			awardType,awardNum = LuaFnGetFeiPinHuiShouInfo(itemid)
			if(awardType == nil)then 
				PushDebugMessage("#{KJTZ_230706_15}")
				return
			end
		elseif is89kaji == 1 then
			awardType,awardNum = LuaFnGetFeiPinHuiShouInfo_89(itemid)
			if(awardType == nil and is89kaji ==1)then 
				PushDebugMessage("#{HJKJ_240703_16}")
				return
			end
		else
			PushDebugMessage("#{HJKJ_240703_16}")
			return
		end 
		
		--清除当前道具
		Feipinhuishou_BeforeIcon:SetActionItem(-1)
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

		Feipinhuishou_BeforeIcon:SetActionItem(theAction:GetID())
		
		if(awardType == 0)then
			Feipinhuishou_AfterText2:SetProperty("MoneyNumber", awardNum * nItemNum); 
		end
		
	end
end

function Feipinhuishou_Click()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 890186 )
		Set_XSCRIPT_Function_Name( "GetAward" )
		Set_XSCRIPT_Parameter(0, g_ItemPos)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

function Feipinhuishou_Clear()
	Feipinhuishou_UpdateItem(-1)
end

function Feipinhuishou_OnClose()
	Feipinhuishou_OnHidden()
end

function Feipinhuishou_OnHidden()
	Feipinhuishou_UpdateItem(-1)
	Feipinhuishou_StopCareObject()
    this:Hide();
end

--=========================================================
-- 界面位置
--=========================================================
function Feipinhuishou_On_ResetPos()
	Feipinhuishou_Frame:SetProperty("UnifiedPosition", g_Feipinhuishou_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Feipinhuishou_BeginCareObject( objCaredId )
	g_Feipinhuishou_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_Feipinhuishou_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_Feipinhuishou_NpcId, 1, "Feipinhuishou" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Feipinhuishou_StopCareObject()
	this : CareObject( g_Feipinhuishou_NpcId, 0, "Feipinhuishou" )
	g_Feipinhuishou_NpcId = -1
end