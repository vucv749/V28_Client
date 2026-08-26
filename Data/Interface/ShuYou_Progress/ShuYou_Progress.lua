-- 2023Q2版本稳活-束脩之礼
-- 进度奖励界面
-- !!!reloadscript =ShuYou_Progress

local g_UnifiedPosition = nil
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local targetId = -1

--进度值上限
local g_MaxCount = 10

--奖励
local g_PrizeCtrl = {}
local g_PrizeData =
{
	[1] = {count = 2, id = 20800013, num = 5, },
	[2] = {count = 4, id = 20501003, num = 1, },
	[3] = {count = 7, id = 20502003, num = 1, },
	[4] = {count = 10, id = 38002855, num = 1, },
}

--===============================================
-- PreLoad()
--===============================================
function ShuYou_Progress_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("OBJECT_CARED_EVENT",false)
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function ShuYou_Progress_OnLoad()
	g_UnifiedPosition = ShuYou_Progress_Frame:GetProperty("UnifiedPosition")	
	g_PrizeCtrl = 
	{
		[1] = {btn = ShuYou_Progress_Icon1Item, animate = ShuYou_Progress_Icon1Animate, flag = ShuYou_Progress_Icon1Mark, text = ShuYou_Progress_Icon1Text, },
		[2] = {btn = ShuYou_Progress_Icon2Item, animate = ShuYou_Progress_Icon2Animate, flag = ShuYou_Progress_Icon2Mark, text = ShuYou_Progress_Icon2Text, },
		[3] = {btn = ShuYou_Progress_Icon3Item, animate = ShuYou_Progress_Icon3Animate, flag = ShuYou_Progress_Icon3Mark, text = ShuYou_Progress_Icon3Text, },
		[4] = {btn = ShuYou_Progress_Icon4Item, animate = ShuYou_Progress_Icon4Animate, flag = ShuYou_Progress_Icon4Mark, text = ShuYou_Progress_Icon4Text, },
	}
end

--===============================================
-- OnEvent()
--===============================================
function ShuYou_Progress_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99826901) then
		--关注npc
		targetId = Get_XParam_INT(0)
		if targetId == nil or targetId == -1 then
			ShuYou_Progress_Close()
			return
		end
		objCared = DataPool : GetNPCIDByServerID(tonumber(targetId))
		if objCared == nil or objCared == -1 then
			ShuYou_Progress_Close()
			return
		end
		this:CareObject(objCared, 1, "ShuYou_Progress")
		--打开/关闭/刷新界面
		local flag = Get_XParam_INT(1) 
		if flag ~= nil and flag == 2 then
			--关界面
			if this:IsVisible() then
				ShuYou_Progress_Close()
			end
		else
			-- 开界面or刷新界面
			local nCount = Get_XParam_INT(2)
			local bFlag1 = Get_XParam_INT(3)
			local bFlag2 = Get_XParam_INT(4)
			local bFlag3 = Get_XParam_INT(5)
			local bFlag4 = Get_XParam_INT(6)
			if flag == 1 then--开界面
					this:Show()
					--ShuYou_Progress_ResetPos()				
					ShuYou_Progress_Open(nCount,bFlag1,bFlag2,bFlag3,bFlag4)
			else--仅刷新
				if( this:IsVisible() ) then
					--ShuYou_Progress_ResetPos()				
					ShuYou_Progress_Open(nCount,bFlag1,bFlag2,bFlag3,bFlag4)
				end
			end
		end
  elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
				return
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
				--关闭界面
				ShuYou_Progress_Close()
		end
	elseif (event == "ADJEST_UI_POS") then
		ShuYou_Progress_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ShuYou_Progress_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShuYou_Progress_Close()
	end
end

--===============================================
-- 重置
--===============================================
function ShuYou_Progress_ResetPos()
	ShuYou_Progress_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
-- 清数据
--===============================================
function ShuYou_Progress_OnHiden()
	for i=1,table.getn(g_PrizeCtrl) do
		g_PrizeCtrl[i].btn:SetActionItem(-1)
	end
	--取消关心
	this:CareObject(objCared, 0, "ShuYou_Progress")
end

--===============================================
-- 关界面
--===============================================
function ShuYou_Progress_Close()
	--数据清空
	ShuYou_Progress_OnHiden()
	--隐藏界面
	this:Hide()
end

--===============================================
-- 开界面
--===============================================
function ShuYou_Progress_Open(nCount,bFlag1,bFlag2,bFlag3,bFlag4)
	
	--进度值
	ShuYou_Progress_Text3:SetText(ScriptGlobal_Format("#{SXZL_032901_135}", nCount))
	if nCount <= g_MaxCount then
		ShuYou_Progress_EXP:SetProgress(nCount, g_MaxCount)
	else
		ShuYou_Progress_EXP:SetProgress(g_MaxCount, g_MaxCount)
	end
		
	--关系文字
	if nCount <= 3 then
		ShuYou_Progress_Text2:SetProperty("Image","set:SYZL image:SYZL_PSXF")
	elseif nCount <= 4 then
		ShuYou_Progress_Text2:SetProperty("Image","set:SYZL image:SYZL_JZZJ")
	elseif nCount <= 7 then
		ShuYou_Progress_Text2:SetProperty("Image","set:SYZL image:SYZL_ZYZY")
	else
		ShuYou_Progress_Text2:SetProperty("Image","set:SYZL image:SYZL_JLZQ")
	end
	
	--奖励显示
	local bFlag = {bFlag1,bFlag2,bFlag3,bFlag4}
	for i=1,table.getn(g_PrizeData) do
		local theAction = DataPool:CreateBindActionItemForShow(g_PrizeData[i].id, g_PrizeData[i].num)
		if theAction:GetID() ~= 0 then
			g_PrizeCtrl[i].btn:SetActionItem(theAction:GetID())
			g_PrizeCtrl[i].text:SetText(g_PrizeData[i].count)
			if nCount >= g_PrizeData[i].count then--可领奖
				if bFlag[i] == 1 then-- 已领奖
					g_PrizeCtrl[i].flag:Show()
					-- 动画不播放
					g_PrizeCtrl[i].animate:Hide()
					g_PrizeCtrl[i].animate:Play(false)
				else-- 未领奖
					g_PrizeCtrl[i].flag:Hide()
					-- 动画播放
					g_PrizeCtrl[i].animate:Show()
					g_PrizeCtrl[i].animate:Play(true)
				end
			else--不可领奖
				-- 动画不播放
				g_PrizeCtrl[i].animate:Hide()
				g_PrizeCtrl[i].animate:Play(false)
				-- 已领奖不显示
				g_PrizeCtrl[i].flag:Hide()
			end
		end
	end
end

--===============================================
-- 领奖
--===============================================
function ShuYou_Progress_Page1_OnClick(nIndex)
	if nIndex == nil then
		return
	end
	if g_PrizeCtrl[nIndex] == nil then
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998269)
		Set_XSCRIPT_Function_Name("OnPrize")
		Set_XSCRIPT_Parameter(0, targetId)
		Set_XSCRIPT_Parameter(1, nIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end
