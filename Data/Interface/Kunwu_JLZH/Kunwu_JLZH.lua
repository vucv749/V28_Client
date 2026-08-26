--卡级服 废品回收 
--!!!reloadscript =Kunwu_JLZH
local g_Kunwu_JLZH_Frame_UnifiedPosition = 0

local MAX_OBJ_DISTANCE = 5
local g_Kunwu_JLZH_NpcId = -1;
local g_Kunwu_JLZH_TargetId = -1

local g_ItemPos = -1

local g_activItemList = {
	[1]   = {[1] =  30402001,[2] =  -1},
	[2]   = {[1] =  30402002,[2] =  -1},
	[3]   = {[1] =  30402003,[2] =  -1},
	[4]   = {[1] =  30402004,[2] =  -1},
	[5]   = {[1] =  30402005,[2] =  -1},
	[6]   = {[1] =  30402006,[2] =  -1},
	[7]   = {[1] =  30402007,[2] =  -1},
	[8]   = {[1] =  30402008,[2] =  -1},
	[9]   = {[1] =  30402009,[2] =  -1},
	[10]  = {[1] =  30402010,[2] =  -1},
	[11]  = {[1] =  30402011,[2] =  30402012},
	[12]  = {[1] =  30402013,[2] =  30402014},
	[13]  = {[1] =  30402015,[2] =  30402016},
	[14]  = {[1] =  30402017,[2] =  30402018},
	[15]  = {[1] =  30402019,[2] =  30402020},
	[16]  = {[1] =  30402021,[2] =  -1},
	[17]  = {[1] =  30402022,[2] =  -1},
	[18]  = {[1] =  30402023,[2] =  -1},
	[19]  = {[1] =  30402024,[2] =  -1},
	[20]  = {[1] =  30402025,[2] =  30402026},
	[21]  = {[1] =  30402029,[2] =  30402030},
	[22]  = {[1] =  30402031,[2] =  30402032},
	[23]  = {[1] =  30402033,[2] =  30402034},
	[24]  = {[1] =  30402035,[2] =  30402036},
	[25]  = {[1] =  30402037,[2] =  30402038},
	[26]  = {[1] =  30402039,[2] =  30402040},
	[27]  = {[1] =  30402041,[2] =  30402042},
	[28]  = {[1] =  30402043,[2] =  30402044},
	[29]  = {[1] =  30402045,[2] =  30402046},
	[30]  = {[1] =  30402047,[2] =  30402048},
	[31]  = {[1] =  30402049,[2] =  30402050},
	[32]  = {[1] =  30402051,[2] =  -1},
	[33]  = {[1] =  30402052,[2] =  -1},
	[34]  = {[1] =  30402053,[2] =  -1},
	[35]  = {[1] =  30402054,[2] =  -1},
	[36]  = {[1] =  30402055,[2] =  30402056},
	[37]  = {[1] =  30402059,[2] =  30402060},
	[38]  = {[1] =  30402061,[2] =  30402062},
	[39]  = {[1] =  30402063,[2] =  30402064},
	[40]  = {[1] =  30402065,[2] =  30402066},
	[41]  = {[1] =  30402067,[2] =  30402068},
	[42]  = {[1] =  30402069,[2] =  30402070},
	[43]  = {[1] =  30402071,[2] =  30402072},
	[44]  = {[1] =  30402073,[2] =  30402074},
	[45]  = {[1] =  30402075,[2] =  30402076},
	[46]  = {[1] =  30402077,[2] =  30402078},
	[47]  = {[1] =  30402079,[2] =  30402080},
	[48]  = {[1] =  30402081,[2] =  -1},
	[49]  = {[1] =  30402082,[2] =  -1},
	[50]  = {[1] =  30402083,[2] =  -1},
	[51]  = {[1] =  30402084,[2] =  -1},
	[52]  = {[1] =  30402085,[2] =  -1},
	[53]  = {[1] =  30402086,[2] =  -1},
	[54]  = {[1] =  30402087,[2] =  -1},
	[55]  = {[1] =  30402088,[2] =  -1},
	[56]  = {[1] =  30402089,[2] =  -1},
	[57]  = {[1] =  30402090,[2] =  -1},
	[58]  = {[1] =  30402091,[2] =  30402092},
	[59]  = {[1] =  30402093,[2] =  30402094},
	[60]  = {[1] =  30402095,[2] =  -1},
	[61]  = {[1] =  30402096,[2] =  -1},
	[62]  = {[1] =  30402097,[2] =  -1},
	[63]  = {[1] =  30402098,[2] =  -1},
	[64]  = {[1] =  30402099,[2] =  -1},
}--技能书

local g_SkillBookIndex = 0
local g_SkillBookHigh = 0
--===============================================
-- PreLoad()
--===============================================
function Kunwu_JLZH_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)		--离开场景
	this:RegisterEvent("ADJEST_UI_POS",false)				-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	-- 游戏分辨率发生了变化
	
	this:RegisterEvent("Kunwu_JLZH_ITEM",false)	-- 从背包放入道具

	this:RegisterEvent("OBJECT_CARED_EVENT",false);           --某逻辑对象的某些发生改变，用于距离NPC够远则关闭界面
end

--===============================================
-- OnLoad()
--===============================================
function Kunwu_JLZH_OnLoad()	
	g_Kunwu_JLZH_Frame_UnifiedPosition = Kunwu_JLZH_Frame:GetProperty("UnifiedPosition")

end

--===============================================
-- OnEvent()
--===============================================
function Kunwu_JLZH_OnEvent(event)
	if event == "HIDE_ON_SCENE_TRANSED" and this:IsVisible()then
		Kunwu_JLZH_OnHidden()
	elseif event == "ADJEST_UI_POS" and this:IsVisible()then
		Kunwu_JLZH_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" and this:IsVisible()then
		Kunwu_JLZH_On_ResetPos()
	end
	if event == "OBJECT_CARED_EVENT" then
		if(tonumber(arg0) ~= g_Kunwu_JLZH_NpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			Kunwu_JLZH_OnClose()
		end
	
		return
	end
	
	if event == "Kunwu_JLZH_ITEM" and this:IsVisible()then
		Kunwu_JLZH_UpdateItem(arg0)
	end

	if event == "UI_COMMAND" and tonumber(arg0) == 99963201 then
		local updateOrOpen = Get_XParam_INT(0)
		if(updateOrOpen == 0)then
			g_Kunwu_JLZH_TargetId = Get_XParam_INT( 1 )
			Kunwu_JLZH_BeginCareObject( g_Kunwu_JLZH_TargetId )
			Kunwu_JLZH_Open()
		elseif(updateOrOpen == 1)then
			Kunwu_JLZH_OnHidden()
		end
	end
end

function Kunwu_JLZH_Open()
	this:Show()
	OpenWindow("Packet")
	Kunwu_JLZH_UpdateItem(-1)
end

--DragAcceptName G202
function Kunwu_JLZH_UpdateItem(index)
	if(tonumber(index) < 0 or index == nil)then

		Kunwu_JLZH_ActionButton:SetActionItem(-1)

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
			if itemid == g_activItemList[i][1] and g_activItemList[i][1] ~= -1 then
				g_SkillBookIndex = i
				g_SkillBookHigh = 1
				break;
			end
			if itemid == g_activItemList[i][2] and g_activItemList[i][2] ~= -1 then
				g_SkillBookIndex = i
				g_SkillBookHigh = 2
				break;
			end
			if i == table.getn(g_activItemList) then
				PushDebugMessage("#{JLZH_241209_43}") -- 您放入的道具不对，仅可放入丹药道具。
				--进入这里说明放入的道具不是活动道具，取消操作
				return
			end
		end

		--清除当前道具
		Kunwu_JLZH_ActionButton:SetActionItem(-1)
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

		Kunwu_JLZH_ActionButton:SetActionItem(theAction:GetID())
		
	end
end

function Kunwu_JLZH_OK_Clicked()
	if g_ItemPos == -1 then
		PushDebugMessage("#{JLZH_241209_21}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID( 999632 )
		Set_XSCRIPT_Function_Name( "CheckItem" )
		Set_XSCRIPT_Parameter(0, g_ItemPos)
		Set_XSCRIPT_Parameter(1, g_SkillBookIndex)
		Set_XSCRIPT_Parameter(2, g_SkillBookHigh)
		Set_XSCRIPT_Parameter(3, g_Kunwu_JLZH_TargetId)

		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

function Kunwu_JLZH_Resume()
	Kunwu_JLZH_UpdateItem(-1)
end

function Kunwu_JLZH_OnClose()
	Kunwu_JLZH_OnHidden()
end

function Kunwu_JLZH_OnHidden()
	Kunwu_JLZH_UpdateItem(-1)
	Kunwu_JLZH_StopCareObject()
    this:Hide();
end

--=========================================================
-- 界面位置
--=========================================================
function Kunwu_JLZH_On_ResetPos()
	Kunwu_JLZH_Frame:SetProperty("UnifiedPosition", g_Kunwu_JLZH_Frame_UnifiedPosition)
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function Kunwu_JLZH_BeginCareObject( objCaredId )
	g_Kunwu_JLZH_NpcId = DataPool : GetNPCIDByServerID( objCaredId )
	if g_Kunwu_JLZH_NpcId == -1 then
		this : Hide()
		return
	end
	this : CareObject( g_Kunwu_JLZH_NpcId, 1, "Kunwu_JLZH" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function Kunwu_JLZH_StopCareObject()
	this : CareObject( g_Kunwu_JLZH_NpcId, 0, "Kunwu_JLZH" )
	g_Kunwu_JLZH_NpcId = -1
end

function Kunwu_JLZH_Clear()
	Kunwu_JLZH_OnHidden()
end

function Kunwu_JLZH_Cancel_Clicked()
	Kunwu_JLZH_OnHidden()
end