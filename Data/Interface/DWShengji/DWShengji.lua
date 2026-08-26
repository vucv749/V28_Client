--雕纹直接升级


local MAX_OBJ_DISTANCE = 3.0
local g_CaredNpc = -1

local g_DWShengji_Item = -1--???????,???????

local g_DWShengji_Frame_UnifiedPosition;
local g_DWShengji_BindConfirmed = 0


-- 金蚕丝, 强化用的道具, 按牋 绑定 -> 元宝交易 -> 随便交易 顺序使用
local g_DWQIANGHUA_ToolItem = {20310168, 20310166, 20310167}
local g_DWQIANGHUA_UnbindItem = {20310166, 20310167}
--=========================================================
-- 注册窗口关心的所有事件
--=========================================================
function DWShengji_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("UPDATE_EQUIPDWLEVELUP")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED",false)
	this:RegisterEvent("RESUME_ENCHASE_GEM",false)
	
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	--元宝
	this:RegisterEvent("UPDATE_YUANBAO",false);
	this:RegisterEvent("UPDATE_BIND_YUANBAO",false);
	--绑定确认
	this:RegisterEvent("BINDSURE_EQUIPDWLEVELUP",false);
	this:RegisterEvent("DW_QHSJ_UI_CHANGE");
end

--=========================================================
-- 载入初始化
--=========================================================
function DWShengji_OnLoad()
	g_DWShengji_Item = -1
	g_DWShengji_BindConfirmed = 0
	g_DWShengji_Frame_UnifiedPosition=DWShengji_Frame:GetProperty("UnifiedPosition");
end

--=========================================================
-- 事件处理
--=========================================================
function DWShengji_OnEvent(event)

	if (event == "UI_COMMAND" and tonumber(arg0) == 20141204) then
		local xx = Get_XParam_INT(0)
		g_CaredNpc = DataPool:GetNPCIDByServerID(xx)
		if g_CaredNpc == -1 then
			return
		end
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		this:Show()
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if (arg0~= nil and -1 == tonumber(arg0)) then
			return
		end
		if (g_DWShengji_Item == tonumber(arg0)) then
			--DWShengji_Resume_DWInfo()
			DWShengji_Update(tonumber(arg0),0)
		end
		DWShengji_UpdateBasic()
	elseif (event == "UPDATE_EQUIPDWLEVELUP") then
		if arg0 ~= nil then
			DWShengji_Update(arg0,1)
			DWShengji_UpdateBasic()
		end
	elseif (event == "RESUME_ENCHASE_GEM") then
		if (arg0 ~= nil) then
			DWShengji_Resume_DWInfo()
			DWShengji_UpdateBasic()
		end
	--挪拽
	elseif (event == "ADJEST_UI_POS" ) then
		DWShengji_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DWShengji_Frame_On_ResetPos()
	--元宝
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "UPDATE_BIND_YUANBAO" and this:IsVisible()) then
		DWShengji_UpdateBasic()
	elseif (event == "BINDSURE_EQUIPDWLEVELUP" and tonumber(arg0)==1) then
		g_DWShengji_BindConfirmed=1
	elseif (event == "DW_QHSJ_UI_CHANGE" and tonumber(arg0)==2) then
		if tonumber(arg1) == nil then
			return
		end
		g_CaredNpc = tonumber(arg1)
		BeginCareObject_DWShengji()
		DWShengji_Clear()
		DWShengji_UpdateBasic()
		--调狖界面位置
		if tostring(arg2) ~= nil then
			DWShengji_Frame:SetProperty("UnifiedPosition", tostring(arg2));
		end
		this:Show()
	end
end

--=========================================================
-- 更新基本显示信息
--=========================================================
function DWShengji_UpdateBasic()
	--拥有绑定元宝
	DWShengji_Bangdingyuangbao_Text:SetText(tostring(Player:GetData("BIND_YUANBAO")));
	--拥有元宝
	DWShengji_Yuanbao_Text:SetText(tostring(Player:GetData("YUANBAO")));
	--背包内未锁定的金蚕丝
	local toolNumInBag = 0		-- ??????????
	for i, tbIndex in ipairs(g_DWQIANGHUA_ToolItem) do
		toolNumInBag = toolNumInBag + PlayerPackage:CountAvailableItemByIDTable(tonumber(tbIndex))
	end
	DWShengji_JCSown_Text:SetText(tostring(toolNumInBag))
end

--=========================================================
-- 重置界面
--=========================================================
function DWShengji_Clear()
	if g_DWShengji_Item ~= -1 then
		DWShengji_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		g_DWShengji_Item = -1
	end
	DWShengji_Type1_name:SetText("#{DWSJ_141202_51}")
	DWShengji_Type1_Level:ResetList()
	DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--????
	DWShengji_Type1_Level:SetCurrentSelect(0);
	--DWShengji_Type1_Level:Disable()
	DWShengji_Type1_Info:SetText("")
	--需要的金蚕丝数量
	DWShengji_JCSneed_Text:SetText("")
	DWShengji_OK:Disable()
	g_DWShengji_BindConfirmed = 0
	--按钮显示
	DWShengji_Type1_Leveltip:Show()
end

--=========================================================
-- 更新界面
--=========================================================
function DWShengji_Update(itemIndex,bNotice)
	g_DWShengji_BindConfirmed = 0
	local index = tonumber(itemIndex)--????
	local theAction = EnumAction(index, "packageitem")

	if theAction:GetID() ~= 0 then
		local equipPoint = LifeAbility:Get_Equip_Point(index)
		if equipPoint == -1 then
			return
		end
		if equipPoint == 8 or equipPoint == 9 or equipPoint == 10 then
			PushDebugMessage("#{DWSJ_141202_16}")
			return
		end
		if equipPoint == 16 then
			PushDebugMessage("#{DWSJ_141202_17}")
			return
		end
		--是否为蚀刻了雕纹的装备
		local ret = LifeAbility:CanEquipDiaowen_Enchase(index)
		if ret == -1 then
			-- 非装备
			PushDebugMessage("#{DWSJ_141202_15}")
			return
		end
		if ret == -2 then
			-- 不是一个已经蚀刻了雕纹的装备
			PushDebugMessage("#{DWSJ_141202_18}")
			return
		end
		if ret == -3 then
			--满级
			if bNotice==1 then
				PushDebugMessage("#{DWSJ_141202_19}")
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--?????
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
				DWShengji_Type1_Info:SetText("")
				DWShengji_UpdateRequireMat()
			end
			return
		end
		--不检测加锁

		-- 如果繝格内已经有图样了, 替换之
		if g_DWShengji_Item ~= -1 then
			LifeAbility:Lock_Packet_Item(g_DWShengji_Item, 0)
		end

		DWShengji_Object:SetActionItem(theAction:GetID())
		LifeAbility:Lock_Packet_Item(index, 1)
		g_DWShengji_Item = index
		--隐藏按钮
		DWShengji_Type1_Leveltip:Hide()

		--更新乱七八糟的东西
		local msg1,msg2= LifeAbility:GetEquipDiaowen_AttrName(index)
		--名称and so on
		if msg1~="" then
			--单属性雕纹
			local strname1 = ScriptGlobal_Format("#{DWSJ_141202_57}",msg1)
			DWShengji_Type1_name:SetText(strname1)--"#cfff263"..
			--level
			local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(index)
			if dwlevel<=0 then return end;
			--10级
			if dwlevel==10 then
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_6}" ,0)--?????
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Disable()
			else
				DWShengji_Type1_Level:ResetList()
				DWShengji_Type1_Level:AddTextItem("#{DWSJ_141202_5}" ,0)--????
				for i=dwlevel+1,10 do
					DWShengji_Type1_Level:AddTextItem(tostring(i) ,i)
				end
				DWShengji_Type1_Level:SetCurrentSelect(0);
				--DWShengji_Type1_Level:Enable()

				DWShengji_Type1_Info:SetText("")
			end
		end

		--清除需要金蚕丝信息
		DWShengji_JCSneed_Text:SetText("")
		
		DWShengji_OK:Enable()

	else
		DWShengji_Clear()
	end
end

--=========================================================
-- 取出窗口内放入的物品
--=========================================================
function DWShengji_Resume_DWInfo()
	if this:IsVisible() then
		DWShengji_Clear()
	end
end

--=========================================================
-- 确定执行功能
--=========================================================
function DWShengji_OK_Clicked()
	-- 安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{DWSJ_141202_20}")
		return
	end
--	--- 角色当前未处于全沉迷或半沉迷状态；
--	if IsInFatigueState() <= 0 then
--		PushDebugMessage( "#{GY_120202_33}" )
--		return
--	end
	-- 二级密码 电话密保检查
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end
	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end
	--是否有雕纹
	-- 判断物品是否为蚀刻了一个雕纹的装备
	local IsHaveDiaowen = LifeAbility:IsEquipHaveDiaowen(g_DWShengji_Item)
	if IsHaveDiaowen~=1 then
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end

	--雕纹是否满级
	local ret = LifeAbility:CanEquipDiaowen_Enchase(g_DWShengji_Item)
	if ret == -1 then
		-- 非装备
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end
	if ret == -2 then
		-- 不是一个已经蚀刻了雕纹的装备
		PushDebugMessage("#{DWSJ_141202_21}")
		return
	end
	if ret == -3 then
		--满级
		PushDebugMessage("#{DWSJ_141202_22}")
		return
	end

	--雕纹的当前等级
	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(g_DWShengji_Item)
	--选择等级
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	if iToLevelSel<=0 then--???????
		PushDebugMessage("#{DWSJ_141202_23}")
		return
	end

	--升级1号雕纹
	if iToLevelSel<=dwlevel then
		PushDebugMessage("#{DWSJ_141202_24}")
		return
	end

	--require for jcs count
	local requireJCS1,newDWID1=LifeAbility:GetReqMatforEquipDWLevelUp(g_DWShengji_Item,iToLevelSel)--??1?2????
	--校验略去，服务器端做严格检测
	if requireJCS1<=0 then
		return
	end
	local requireJCS=requireJCS1
	--条件检测，不区分是否双极雕纹
	--特例之装备绑定与否
	--装备是否绑定
	local equipBindState = PlayerPackage:GetItemBindStatusByIndex(g_DWShengji_Item)
	if equipBindState~=1 then
		--非绑定的金蚕丝够否
		--判断玩家背包内未锁定的非绑定的金蚕丝数量是否大于等于本次升级所需要的金蚕丝数量
		local unbindNumInBag = 0		-- ??????????
		for i, tbIndex in ipairs(g_DWQIANGHUA_UnbindItem) do
			unbindNumInBag = unbindNumInBag + PlayerPackage:CountAvailableItemByIDTable(tonumber(tbIndex))
		end
		if unbindNumInBag>=requireJCS then
			--给服务器端发包，直接升级吧
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("DoEquipDWLevelUp")
				Set_XSCRIPT_ScriptID(809272)
				Set_XSCRIPT_Parameter(0, g_DWShengji_Item)
				Set_XSCRIPT_Parameter(1, iToLevelSel)
				Set_XSCRIPT_Parameter(2, 1)
				Set_XSCRIPT_ParamCount(3)
			Send_XSCRIPT()
			return
		else
			--非绑定的金蚕丝不够噢
			local equipTableIndex	= PlayerPackage : GetItemTableIndex( g_DWShengji_Item )
			--非绑定重楼不做绑定的二级确认
			if equipTableIndex == 10422016 or equipTableIndex == 10423024 then
--			if IsUnbindChongLouEquip(equipTableIndex) == 1 then
				g_DWShengji_BindConfirmed=1
			end
			--绑定确认
			if g_DWShengji_BindConfirmed==0 then
				PushEvent( "BINDSURE_EQUIPDWLEVELUP", 0)
				return
			end
		end
	end

	local UserjcsCnt=0
	local UserBYBCnt=0
	local UserYBCnt=0
	--各种够不？
	local toolNumInBag = 0		-- ??????????
	for i, tbIndex in ipairs(g_DWQIANGHUA_ToolItem) do
		toolNumInBag = toolNumInBag + PlayerPackage:CountAvailableItemByIDTable(tonumber(tbIndex))
	end
	--拥有绑定元宝
	local curBYB=Player:GetData("BIND_YUANBAO")
	--拥有元宝
	local curYB=Player:GetData("YUANBAO")
	--元宝
	if toolNumInBag>=requireJCS then
		--金蚕丝足够
		UserjcsCnt=requireJCS
	else
		UserjcsCnt=toolNumInBag
		local leftyuanbao=(requireJCS-UserjcsCnt)*35
		if curBYB>=leftyuanbao then
			--金蚕丝+绑定元宝足够
			UserBYBCnt=leftyuanbao
		else
			UserBYBCnt=curBYB
			--元宝够不
			leftyuanbao=leftyuanbao-UserBYBCnt
			if curYB>=leftyuanbao then
				UserYBCnt=leftyuanbao
			else
				--钱不够啊
				PushDebugMessage("#{DWSJ_141202_33}")--????,????????
				return
			end
		end
	end
	--简单校验一下
	if (UserjcsCnt*35+UserBYBCnt+UserYBCnt)~=requireJCS*35 then
		return
	end
	--是否选择了绑定元宝/元宝支付确认
	local SelectOK= string.lower( DWShengji_cost:GetProperty("Selected") )
	if SelectOK=="true" then
		if UserBYBCnt>0 or UserYBCnt>0 then
			PushEvent( "CONSUMESURE_EQUIPDWLEVELUP",g_DWShengji_Item,iToLevelSel,requireJCS,UserjcsCnt,UserBYBCnt,UserYBCnt)
			return
		end
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("DoEquipDWLevelUp")
		Set_XSCRIPT_ScriptID(809272)
		Set_XSCRIPT_Parameter(0, g_DWShengji_Item)
		Set_XSCRIPT_Parameter(1, iToLevelSel)
		Set_XSCRIPT_Parameter(2, 0)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

function DWShengji_Type1_Changed()
	if g_DWShengji_Item==-1 then
		return
	end
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local requireJCS1,newDWID1=LifeAbility:GetReqMatforEquipDWLevelUp(g_DWShengji_Item,iToLevelSel)

	local attrnum=LifeAbility:GetDWAttrbyDWID(newDWID1)
	if attrnum>0 then
		--更新乱七八糟的东西
		local msg1,msg2= LifeAbility:GetEquipDiaowen_AttrName(g_DWShengji_Item)
		local str = ScriptGlobal_Format("#{DWSJ_141202_59}",msg1,attrnum)
		DWShengji_Type1_Info:SetText(str)
	else
		DWShengji_Type1_Info:SetText("")
	end
	DWShengji_UpdateRequireMat()
end

function DWShengji_UpdateRequireMat()
	local sToLevelSel,iToLevelSel =  DWShengji_Type1_Level:GetCurrentSelect()
	local requireJCS1,newDWID1=LifeAbility:GetReqMatforEquipDWLevelUp(g_DWShengji_Item,iToLevelSel)--??1?2????
	if requireJCS1>0 then
		DWShengji_JCSneed_Text:SetText(requireJCS1)
	else
		DWShengji_JCSneed_Text:SetText("")
	end
end
--=========================================================
-- 关睜界面
--=========================================================
function DWShengji_Close()
	this:Hide()
	return
end

--=========================================================
-- 界面隐藏
--=========================================================
function DWShengji_OnHiden()
	StopCareObject_DWShengji()
	DWShengji_Clear()
	return
end

--=========================================================
-- 开始关心NPC，
-- 在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
-- 如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 1, "DWShengji")
	return
end

--=========================================================
-- 停止对某NPC的关心
--=========================================================
function StopCareObject_DWShengji()
	this:CareObject(g_CaredNpc, 0, "DWShengji")
	g_CaredNpc = -1
	return
end


function DWShengji_Frame_On_ResetPos()
  DWShengji_Frame:SetProperty("UnifiedPosition", g_DWShengji_Frame_UnifiedPosition);
end

function DWShengji_ItemBtnRBClicked()
	DWShengji_Resume_DWInfo()
end

function DWShengji_Type1_Leveltip_Click()
	if g_DWShengji_Item==-1 then
		PushDebugMessage("#{DWSJ_141202_54}")
	end
end

--打开雕纹强化界面
function DWShengji_ChangeTabIndex()
	--参数2:1-强化、2-升级
	PushEvent("DW_QHSJ_UI_CHANGE", 1,g_CaredNpc,DWShengji_Frame:GetProperty("UnifiedPosition"))
	DWShengji_Close()
end
