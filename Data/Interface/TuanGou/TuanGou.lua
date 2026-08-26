--***********************************************************************************************************************************************
--2022Q3时装团购
--主界面
--***********************************************************************************************************************************************
local g_UnifiedPosition

local objCared = -1
local targetId = -1

local g_ItemId = 10125293

--***********************************************************************************************************************************************
-- PreLoad
--************************************************************************************************************************************************
function TuanGou_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--***********************************************************************************************************************************************
-- OnLoad
--************************************************************************************************************************************************
function TuanGou_OnLoad()
	g_UnifiedPosition=TuanGou_Frame:GetProperty("UnifiedPosition")
end

--***********************************************************************************************************************************************
-- 事件响应函数
--************************************************************************************************************************************************
function TuanGou_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99851801) then
		--关注npc
		targetId = Get_XParam_INT(0)
		if targetId == nil or targetId <= -1 then
			TuanGou_Close()
			return
		end
		objCared = DataPool : GetNPCIDByServerID(tonumber(targetId))
		if objCared == nil or objCared <= -1 then
			TuanGou_Close()
			return
		end
		this:CareObject(objCared, 1, "TuanGou")
		--打开/关闭/刷新界面
		local flag = Get_XParam_INT(1) 
		if flag ~= nil and flag == 2 then
			--关界面
			if this:IsVisible() then
				TuanGou_Close()
			end
		else
			-- 开界面or刷新界面
			local nStep = Get_XParam_INT(2)
			local bFlag = Get_XParam_INT(3)
			local bPrize = Get_XParam_INT(4)
			if flag == 1 then--开界面
				this:Show()
				TuanGou_Update(nStep,bFlag,bPrize)
			else--仅刷新
				if( this:IsVisible() ) then
					TuanGou_Update(nStep,bFlag,bPrize)
				end
			end
		end
	elseif (event == "ADJEST_UI_POS") then
		TuanGou_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		TuanGou_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		TuanGou_Close()
	end
end

--***********************************************************************************************************************************************
-- 刷新界面
--************************************************************************************************************************************************
function TuanGou_Update(nStep,bFlag,bPrize)
	if nStep == nil or bFlag == nil or bPrize == nil then
		return
	end

	--道具图标
	local theAction = DataPool:CreateActionItemForShow(g_ItemId, 1)
	if theAction:GetID() ~= 0 then
		TuanGou_Item:SetActionItem(theAction:GetID())
	end	
	--按钮区域
	if nStep == 1 then--拼团
		TuanGou_Lingqu:Hide()
		TuanGou_YiLingqu:Hide()
		TuanGou_Yipintuan:Hide()
		if bFlag == 1 then--已拼团
			TuanGou_CapTainPintuan:Hide()
			TuanGou_YiGongYue:Show()
			TuanGou_YiGongYueText:Show()
		else--未拼团
			TuanGou_CapTainPintuan:Show()
			TuanGou_YiGongYue:Hide()
			TuanGou_YiGongYueText:Hide()
		end
	elseif nStep == 2 then--空闲
		TuanGou_Lingqu:Hide()
		TuanGou_YiLingqu:Hide()
		TuanGou_CapTainPintuan:Hide()
		if bFlag == 1 then--已拼团
			TuanGou_YiGongYue:Show()
			TuanGou_YiGongYueText:Show()
			TuanGou_Yipintuan:Hide()
		else--未拼团
			TuanGou_YiGongYue:Hide()
			TuanGou_YiGongYueText:Hide()
			TuanGou_Yipintuan:Show()
		end
	elseif nStep == 3 then--领奖
		TuanGou_CapTainPintuan:Hide()
		TuanGou_YiGongYue:Hide()
		TuanGou_YiGongYueText:Hide()
		if bFlag == 1 then--已拼团
			TuanGou_Yipintuan:Hide()
			if bPrize == 1 then--已领取
				TuanGou_Lingqu:Hide()
				TuanGou_YiLingqu:Show()
			else--未领取
				TuanGou_Lingqu:Show()
				TuanGou_YiLingqu:Hide()
			end
		else--未拼团
			TuanGou_Yipintuan:Show()
			TuanGou_Lingqu:Hide()
			TuanGou_YiLingqu:Hide()
		end		
	end
end

--***********************************************************************************************************************************************
-- 重置位置
--************************************************************************************************************************************************
function TuanGou_ResetPos()
  TuanGou_Frame:SetProperty("UnifiedPosition", g_UnifiedPosition)
end

--***********************************************************************************************************************************************
-- 清数据
--***********************************************************************************************************************************************
function TuanGou_OnHiden()
	--取消关心
	this:CareObject(objCared, 0, "TuanGou")
end

--***********************************************************************************************************************************************
-- 关界面
--***********************************************************************************************************************************************
function TuanGou_Close()
	--关闭确认界面
	if(IsWindowShow("TuanGouConfirm")) then
		CloseWindow("TuanGouConfirm", true)
		return
	end
	--关闭原话界面
	if(IsWindowShow("TuanGouClothes")) then
		CloseWindow("TuanGouClothes", true)
		return
	end
	--数据清空
	TuanGou_OnHiden()
	--隐藏界面
	this:Hide()
end

--***********************************************************************************************************************************************
-- 模型预览
--***********************************************************************************************************************************************
function TuanGou_OnPreviewClick()
	PushEvent("OPEN_TUANGOUCLOTHES",targetId)
end

--***********************************************************************************************************************************************
-- 发起团购
--***********************************************************************************************************************************************
function TuanGou_OnBeginClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998518)
		Set_XSCRIPT_Function_Name("OnAskBegin")
		Set_XSCRIPT_Parameter(0, targetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--***********************************************************************************************************************************************
-- 领奖
--***********************************************************************************************************************************************
function TuanGou_OnPrizeClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_ScriptID(998518)
		Set_XSCRIPT_Function_Name("OnPrize")
		Set_XSCRIPT_Parameter(0, targetId)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--***********************************************************************************************************************************************
-- 小问号
--***********************************************************************************************************************************************
function TuanGou_Help()
	PushEvent("CCSHOP_HELP", 20)
end
