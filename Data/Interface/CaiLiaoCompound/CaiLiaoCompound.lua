-- 材料合成界面 2017-8-25 lishilong
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_CaiLiaoCompound_Num 	= 0		-- ???????
local g_CaiLiaoCompound_Select 	= -1	-- ????????????,?0??
local g_CaiLiaoCompound_Index 	= {}	-- ????????????????????

local g_MaxNum_PerTime 			= 7500	-- ??????
local g_CurNum_PerTime			= 1		-- ??????
local g_FunControl				= 0		-- ?????????????

local g_CaiLiaoCompoundFrame_UnifiedPosition

-- 选项信息
local g_CaiLiaoCompound_Info = 
{
	[1] = {		--		??
		name = "#{CLHC_170824_04}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_05}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_06}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_07}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_08}", bCanCompound = 0},
		},
	[2] = {		--		??
		name = "#{CLHC_170824_09}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_10}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_11}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_12}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_13}", bCanCompound = 0},
		},
	[3] = {		--		??
		name = "#{CLHC_170824_14}", bShow = 0, bCanCompound = 0,
		[1] = { subname = "#{CLHC_170824_15}", bCanCompound = 0},
		[2] = { subname = "#{CLHC_170824_16}", bCanCompound = 0},
		[3] = { subname = "#{CLHC_170824_17}", bCanCompound = 0},
		[4] = { subname = "#{CLHC_170824_18}", bCanCompound = 0},
		},
}

-- 合成数值
local g_CaiLiaoCompound_Data = 
{
	-- level1为碎片，level4为3级材料，犫样
	[1] = { newlevel = 2, needlevel = 1, needcount = 5, needmoney = 500, },
	[2] = { newlevel = 3, needlevel = 2, needcount = 5, needmoney = 1000, },
	[3] = { newlevel = 4, needlevel = 3, needcount = 5, needmoney = 1500, },
	[4] = { newlevel = 5, needlevel = 4, needcount = 5, needmoney = 5000, },
}

-- 道具
local g_CaiLiaoCompound_Item = 
{
	[1]=
	{
		{nItemID = 20502000, strShowName = "#{CLHC_170904_74}"},	--????
		{nItemID = 20502001, strShowName = "#{CLHC_170904_77}"},	--1???
		{nItemID = 20502002, strShowName = "#{CLHC_170904_78}"},	--2???
		{nItemID = 20502003, strShowName = "#{CLHC_170904_79}"},	--3???
		{nItemID = 20502004, strShowName = "#{CLHC_170904_80}"},	--4???
	},
	
	[2]=
	{
		{nItemID = 20501000, strShowName = "#{CLHC_170904_75}"},	--????
		{nItemID = 20501001, strShowName = "#{CLHC_170904_81}"},	--1???
		{nItemID = 20501002, strShowName = "#{CLHC_170904_82}"},	--2???
		{nItemID = 20501003, strShowName = "#{CLHC_170904_83}"},	--3???
		{nItemID = 20501004, strShowName = "#{CLHC_170904_84}"},	--4???
	},
	
	[3]=
	{
		{nItemID = 20500000, strShowName = "#{CLHC_170904_76}"},	--????
		{nItemID = 20500001, strShowName = "#{CLHC_170904_85}"},	--1???
		{nItemID = 20500002, strShowName = "#{CLHC_170904_86}"},	--2???
		{nItemID = 20500003, strShowName = "#{CLHC_170904_87}"},	--3???
		{nItemID = 20500004, strShowName = "#{CLHC_170904_88}"},	--4???
	},
}

--=========================================================
-- PreLoad
--=========================================================
function CaiLiaoCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	
	this : RegisterEvent("ADJEST_UI_POS")
	this : RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function CaiLiaoCompound_OnLoad()
	g_CaiLiaoCompoundFrame_UnifiedPosition = CaiLiaoCompoundFrame:GetProperty("UnifiedPosition")
end

--=========================================================
-- OnEvent
--=========================================================
function CaiLiaoCompound_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 920170825 ) then
		local nOpType 	= Get_XParam_INT(0)
		local objid 	= Get_XParam_INT(1)
		-- 关睜界面
		if objid == nil or objid < 0 then
			if this:IsVisible() then
				CaiLiaoCompound_Close()
			end
		else
			-- 仅刷新界面
			if 2 == nOpType and this:IsVisible() then
				CaiLiaoCompound_Update(0)
				if g_CaiLiaoCompound_Select >= 0 then
					CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
				end
				return
			end
			-- 打开界面
			-- 关注npc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "CaiLiaoCompound")
			-- 显示界面
			this:Show()
			CaiLiaoCompound_Update(1)
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		CaiLiaoCompound_Update(0)
		if g_CaiLiaoCompound_Select >= 0 then
			CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
		end
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			CaiLiaoCompound_Close()
		end	
	elseif ( event == "SCENE_TRANSED" ) then
		-- 关睜界面
		CaiLiaoCompound_Close()
	-- 金钱变更
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		CaiLiaoCompound_MoneyUpdate()
	
	elseif (event == "ADJEST_UI_POS" ) then
		CaiLiaoCompoundFrame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		CaiLiaoCompoundFrame_On_ResetPos()
		
	end
end

--=========================================================
-- 关睜界面：脚本各种关睜逻辑调用n次 点击关睜界面调用一次
--=========================================================
function CaiLiaoCompound_Close()
	-- 数据清繝
	g_CaiLiaoCompound_Num = 0--???????
	g_CaiLiaoCompound_Select = -1--??????????
	g_CaiLiaoCompound_Index = {}--????????????????????
	g_CurNum_PerTime = 1
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		g_CaiLiaoCompound_Info[i].bShow = 0
	end
	
	this:Hide()
	-- 取消关心
	this:CareObject(objCared, 0, "CaiLiaoCompound")
	npcObjId = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function CaiLiaoCompound_MoneyUpdate()
	CaiLiaoCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	CaiLiaoCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 界面更新：服务器端打开或犨更新界面调用一次
--=========================================================
function CaiLiaoCompound_Update(bInit)	
	-- 金钱显示
	CaiLiaoCompound_MoneyUpdate()
	
	-- 显示左侧列表
	CaiLiaoCompound_LeftLoad(bInit)
end

--=========================================================
-- 显示左侧列表 
--=========================================================
function CaiLiaoCompound_LeftLoad(bInit)
	-- 左侧的控件显示
	CaiLiaoCompound_List:ClearListBox()
	g_CaiLiaoCompound_Index = {}
	
	-- 选项下标
	local itemNum = 0
	
	-- 计算可合成选项
	for nIndex = 1, table.getn(g_CaiLiaoCompound_Item) do
		local tItem = g_CaiLiaoCompound_Item[nIndex]
		if nil == tItem then
			return
		end
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if nil == tInfo then
			return
		end
		-- 先清繝可合成数据
		tInfo.bCanCompound = 0
		for nLevel = 1, table.getn(tItem) - 1 do
			local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(tItem[nLevel].nItemID)
			local tSubInfo = tInfo[nLevel]
			if nil == tSubInfo then
				return
			end
				
			if nHaveCount >= 5 then
				tInfo.bCanCompound = 1
				tSubInfo.bCanCompound = 1
			else
				tSubInfo.bCanCompound = 0
			end
		end
	end
	
	-- 显示列表
	local nHaveShow = 0
	for i=1, table.getn(g_CaiLiaoCompound_Info) do	
		-- 一级选项
		local tInfo = g_CaiLiaoCompound_Info[i]
		if tInfo ~= nil then
			-- 是否显示二级选项
			if tInfo.bShow == 1 then	
				nHaveShow = 1
				-- 增加一级选项
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("- "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("- "..tInfo.name, 10000+i)
				end
				-- 显示二级选项
				for j=1, table.getn(tInfo) do
					-- 二级选项
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- 增加二级选项
						if 1 == tSubInfo.bCanCompound then
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname.."#{CLHC_170904_73}", itemNum)
						else	
							CaiLiaoCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						end
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_CaiLiaoCompound_Index,nItem)

						-- 默认选中项
						if 1 == bInit and itemNum == 0 then
							g_CaiLiaoCompound_Select = itemNum
							CaiLiaoCompound_List : SetItemSelectByItemID(g_CaiLiaoCompound_Select)
						end
						-- 二级选项计数增加
						itemNum = itemNum + 1
					end
				end
			else
				-- 增加一级选项
				if 1 == tInfo.bCanCompound then
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name.."#{CLHC_170904_73}", 10000+i)
				else	
					CaiLiaoCompound_List:AddItem("+ "..tInfo.name, 10000+i)
				end			
			end		
		end
	end
	
	-- 更新二级选项总个数
	g_CaiLiaoCompound_Num = itemNum
	
	-- 单独更新数量
	if 1 == bInit then
		g_CurNum_PerTime = 1
		g_FunControl = 1
		CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
		g_FunControl = 0
	end
	
	-- 设置数量按钮是否可使用
	if 0 == nHaveShow then
		CaiLiaoCompound_HeChengNum:Disable()
	else
		CaiLiaoCompound_HeChengNum:Enable()
	end
	
	-- 显示右侧合成信息
	CaiLiaoCompound_ShowDetail(bInit)
end

--=========================================================
-- 左侧列表选中：点击选项调用一次
--=========================================================
function CaiLiaoCompound_ListBox_Selected()
	-- 选中项
	local nSelIndex = CaiLiaoCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- 选中一级选项
	if nSelIndex > 10000 then
		-- 一级选项下标
		local nIndex = nSelIndex-10000
		-- 一级选项
		local tInfo = g_CaiLiaoCompound_Info[nIndex]
		if tInfo ~= nil then
			-- 改变一级选项打开关睜状态
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- 关睜其他列表
				for i=1, table.getn(g_CaiLiaoCompound_Info) do	
					g_CaiLiaoCompound_Info[i].bShow = 0
				end
				-- 当前列表变为显示
				tInfo.bShow = 1
			end
			-- 重新加载列表
			CaiLiaoCompound_LeftLoad(1)
		end
		return
	end

	-- 更新选项
	g_CaiLiaoCompound_Select = nSelIndex
	
	-- 单独更新数量
	g_CurNum_PerTime = 1
	g_FunControl = 1
	CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
	g_FunControl = 0
	
	-- 显示右侧合成信息
	CaiLiaoCompound_ShowDetail(1)
end

--=========================================================
-- 清繝右侧合成信息
--=========================================================
function CaiLiaoCompound_ClearDetail()
	-- 显示繝内容
	CaiLiaoCompound_ChoiceInfo:SetText( "#{CLHC_170824_20}" )
	CaiLiaoCompound_Item:SetActionItem(-1)
	CaiLiaoCompound_Need_Info:SetText( "#{CLHC_170824_22}" )
	CaiLiaoCompound_Need_Number:SetText( "" )
	CaiLiaoCompound_Have_Info:SetText( "#{CLHC_170824_24}" )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	CaiLiaoCompound_Have_Number:SetText( "" )
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", 0)

	-- 按钮置灰
	CaiLiaoCompound_OK:Disable()
	CaiLiaoCompound_HeChengNum:Disable()
	CaiLiaoCompound_HeChengNum_MAX:Disable()
	CaiLiaoCompound_Cancel:Disable()
end

--=========================================================
-- 右侧合成信息：选中左侧列表调用一次
--=========================================================
function CaiLiaoCompound_ShowDetail(bInit)
	-- 清繝信息
	CaiLiaoCompound_ClearDetail()
	
	-- 选中项检测
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		return
	end
	
	-- 下标检测	
	local tIndex = g_CaiLiaoCompound_Index[g_CaiLiaoCompound_Select+1]
	if tIndex == nil then
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		return
	end

	local tSubData = g_CaiLiaoCompound_Data[nSubIndex]
	if tSubData == nil then
		return
	end	
	local tItem = g_CaiLiaoCompound_Item[nIndex]
	if tItem == nil then
		return
	end	
	local needCount = tSubData.needcount
	if needCount == nil or needCount <= 0 then
		return
	end
	local needMoney = tSubData.needmoney
	if needMoney == nil or needMoney <= 0 then
		return
	end
	local needLevel = tSubData.needlevel
	if needLevel == nil or needLevel <= 0 then
		return
	end
	local needItemId = tItem[needLevel].nItemID
	if needItemId == nil or needItemId <= 0 then
		return
	end
	local newLevel = tSubData.newlevel
	if newLevel == nil or newLevel <= 0 then
		return
	end
	local newItemId = tItem[newLevel].nItemID
	if newItemId == nil or newItemId <= 0 then
		return
	end
	
	local needItemName = tItem[needLevel].strShowName
	if needItemName == nil then
		return
	end
	
	local newItemName = tItem[newLevel].strShowName
	if newItemName == nil then
		return
	end
		
	-- 合成提示区域
	local szChoiceInfo  = ScriptGlobal_Format("#{CLHC_170824_19}", newItemName)
	CaiLiaoCompound_ChoiceInfo:SetText( szChoiceInfo )

	-- 道具牴示区域
	local theAction = DataPool:CreateActionItemForShow(newItemId, 1)
	if theAction:GetID() ~= 0 then
		CaiLiaoCompound_Item:SetActionItem(theAction:GetID())
	end
	
	-- 拥有个数区域
	local szHaveInfo = ScriptGlobal_Format("#{CLHC_170824_23}", needItemName)
	CaiLiaoCompound_Have_Info:SetText( szHaveInfo )
	CaiLiaoCompound_Have_Info:SetToolTip("#{CLHC_170824_25}")
	
	local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(needItemId)
	local szHaveCount = ""
	szHaveCount = ScriptGlobal_Format("#{CLHC_170825_46}", nHaveCount)
	CaiLiaoCompound_Have_Number:SetText( szHaveCount )
	
	-- 合成数量区域
	local nCanCompoundNum = math.floor(nHaveCount / 5)
	
	-- local nHaveMoney = 	Player:GetData("MONEY_JZ") + Player:GetData("MONEY")
	-- local nCanCompoundNumByMoney = math.floor(nHaveMoney / needMoney)
	
	-- if nCanCompoundNum > nCanCompoundNumByMoney then
		-- nCanCompoundNum = nCanCompoundNumByMoney
	-- end
	
	-- 数量最小为1 小于1的情况自动转成1
	if nCanCompoundNum < 1 then
		nCanCompoundNum = 1
		-- 拥有个数褷色判断
		if nHaveCount < 5 then
			szHaveCount = ScriptGlobal_Format("#{CLHC_170904_54}", nHaveCount)
			CaiLiaoCompound_Have_Number:SetText( szHaveCount )
		end
		
		-- 最大按钮提示
		if -1 == bInit then
			local strNeedItemName = PlayerPackage:GetItemName( needItemId )
			local strNewItemName = PlayerPackage:GetItemName( newItemId )
			local strTips = ScriptGlobal_Format("#{CLHC_170904_89}", strNeedItemName, strNewItemName)
			PushDebugMessage(strTips)
		end
	end	
	
	-- 自动判断取最大合成数量
	if g_CurNum_PerTime > nCanCompoundNum then		
		g_CurNum_PerTime = nCanCompoundNum
	end
	
	if 1 == bInit then
		-- 初始化操作
		g_CurNum_PerTime = 1
		
		-- 拥有个数褷色判断
		if nHaveCount < 5 then
			szHaveCount = ScriptGlobal_Format("#{CLHC_170904_54}", nHaveCount)
			CaiLiaoCompound_Have_Number:SetText( szHaveCount )
		end
	end

	local num = tonumber(CaiLiaoCompound_HeChengNum:GetText())
	
	--PushDebugMessage("g_CurNum_PerTime"..g_CurNum_PerTime.."nCanCompoundNum"..nCanCompoundNum.."num"..num)
	if num ~= g_CurNum_PerTime then
		g_FunControl = 1
		CaiLiaoCompound_HeChengNum:SetText(tostring(g_CurNum_PerTime))
		g_FunControl = 0
	end
				
	-- 需要个数区域
	local szNeedInfo = ScriptGlobal_Format("#{CLHC_170824_21}", needItemName)
	CaiLiaoCompound_Need_Info:SetText( szNeedInfo )
	local szNeedCount = ""
	szNeedCount = ScriptGlobal_Format("#{CLHC_170904_52}", g_CurNum_PerTime * 5)
	CaiLiaoCompound_Need_Number:SetText( szNeedCount )
	
	-- 合成消耗区域
	CaiLiaoCompound_DemandMoney:SetProperty("MoneyNumber", (needMoney * g_CurNum_PerTime))
	
	-- 按钮启用
	CaiLiaoCompound_OK:Enable()
	CaiLiaoCompound_HeChengNum:Enable()
	CaiLiaoCompound_HeChengNum_MAX:Enable()
	CaiLiaoCompound_Cancel:Enable()
	
	if 0 == g_CurNum_PerTime then
		CaiLiaoCompound_OK:Disable()
	end
end

function CaiLiaoCompound_OnMaxNum()
	g_CurNum_PerTime = g_MaxNum_PerTime
	-- 特写，为了提示
	CaiLiaoCompound_ShowDetail(-1)
end

function CaiLiaoCompound_OnNumChanged()
	-- 控制为1表示是内部调用导致的变更，不做处理
	if(1 == g_FunControl) then
		g_FunControl = 0
		return
	end
	
	local num = tonumber(CaiLiaoCompound_HeChengNum:GetText())
	if(nil == num or (num and num < 0)) then
		g_CurNum_PerTime = 0
		return
	end
	if(num > g_MaxNum_PerTime) then
		num = g_MaxNum_PerTime
	end
	g_CurNum_PerTime = num
	CaiLiaoCompound_ShowDetail(0)
end

--=========================================================
-- 合成事件响应
--=========================================================

function CaiLiaoCompound_OK_Click()
	CaiLiaoCompound_Do()
end

function CaiLiaoCompound_Do()
	-- 选中项检测
	if g_CaiLiaoCompound_Select == nil or g_CaiLiaoCompound_Select < 0 or g_CaiLiaoCompound_Select >= g_CaiLiaoCompound_Num then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end
	
	-- 下标检测	
	local tIndex = g_CaiLiaoCompound_Index[g_CaiLiaoCompound_Select+1]
	if tIndex == nil then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		PushDebugMessage("#{CLHC_170824_34}")
		return
	end

	--判断是否为安全时间
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		PushDebugMessage("#{KPWFS_131112_20}")
		return
	end
	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then		
		return
	end
		
	-- 合成操作
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "CaiLiaoCompound_New" )
		Set_XSCRIPT_ScriptID(701602)
		Set_XSCRIPT_Parameter(0,npcObjId)			--npcid
		Set_XSCRIPT_Parameter(1,g_CurNum_PerTime)	--???????
		Set_XSCRIPT_Parameter(2,nIndex)				--??
		Set_XSCRIPT_Parameter(3,nSubIndex)			--???
		Set_XSCRIPT_Parameter(4,0)					--????
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	
end

function CaiLiaoCompoundFrame_On_ResetPos()
  CaiLiaoCompoundFrame:SetProperty("UnifiedPosition", g_CaiLiaoCompoundFrame_UnifiedPosition)
end
