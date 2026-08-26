-- XiaRi_YanMen 星火生雁门主界面 2022-5-9 lishilong
-- !!!reloadscript =XiaRi_YanMen
--

local g_XiaRi_YanMen_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 1
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

-- 变量
local g_nHuoDongStep		= 0
local g_nHuoDongProcess		= 0
local g_bPlayAnimate		= 0
local g_nIsDone				= 0
local g_nCurDaibi 			= 0

-- 常量
local g_nHuoDongMaxProcess	= 1000
local g_tableMissionInfo	= 
{
	[1] = {strShowMsg = "#{XHSYM_20220426_42}", strInfoMsg = "#{XHSYM_20220426_23}"	    },
	[2] = {strShowMsg = "#{XHSYM_20220426_43}",	 strInfoMsg = "#{XHSYM_20220426_149}"	},
	[3] = {strShowMsg = "#{XHSYM_20220426_49}",	 strInfoMsg = "#{XHSYM_20220426_150}"	},
	[4] = {strShowMsg = "#{XHSYM_20220426_129}", strInfoMsg = "#{XHSYM_20220426_150}"	},
	[5] = {strShowMsg = "#{XHSYM_20220426_145}", strInfoMsg = "#{XHSYM_20220426_154}"	},
}

-- local g_tableMissionInfoEx =
-- {
-- 	[5] = {strShowMsg = "#{XHSYM_20220426_145}", strInfoMsg = "#{XHSYM_20220426_157}"	}, --策划临时起兴，想让任务5阶段界面根据葼期显示不同内容 7.12-7.13 显示犫个
-- }

-- local g_tableAutoRunInfo	= 
-- {
-- 	[2076] = {nClientSceneID = 587, nPosX = 160,		nPosZ = 331, 	strNPCName = "宁婉夜", },
-- 	[2077] = {nClientSceneID = 588, nPosX = 164,		nPosZ = 332, 	strNPCName = "何安城", },
-- 	[2078] = {nClientSceneID = 588, nPosX = 164,		nPosZ = 332, 	strNPCName = "何安城", },
-- }

local g_tableItemActionBtnItem = {}

-- local g_goBtnText = 
-- {
-- 	[0] = "#{XHSYM_20220426_47}" ,  --前往
-- 	[1] = "#{XHSYM_20220426_144}"  --领奖
-- }

local g_nUICommandID			= 79102001
local g_nAutoRunUICommandID		= 79102003

--=========================================================
-- PreLoad
--=========================================================
function XiaRi_YanMen_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	if 1 == bCaredItem then
		this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	end
	if 1 == bCaredMoney then
		this:RegisterEvent("UNIT_MONEY")
		this:RegisterEvent("MONEYJZ_CHANGE")
	end
	if 1 == bCaredYuanBao then
		this:RegisterEvent("UPDATE_YUANBAO")
	end
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--=========================================================
-- OnLoad
--=========================================================
function XiaRi_YanMen_OnLoad()
	g_XiaRi_YanMen_Frame_UnifiedPosition = XiaRi_YanMen_Frame:GetProperty("UnifiedPosition")

	-- XiaRi_YanMen_OK_Button : SetEvent("Clicked", "XiaRi_YanMen_ConfirmClick()")
	g_tableItemActionBtnItem[1] = { itemid = 20800013, itemnum = 6,  btn = XiaRi_YanMen_Item_1, animate=XiaRi_YanMen_Item_1Animate, mark = XiaRi_YanMen_Item_1Mark, }
	g_tableItemActionBtnItem[2] = { itemid = 38002221, itemnum = 1,  btn = XiaRi_YanMen_Item_2, animate=XiaRi_YanMen_Item_2Animate, mark = XiaRi_YanMen_Item_2Mark, }
	g_tableItemActionBtnItem[3] = { itemid = 38002532, itemnum = 10,  btn = XiaRi_YanMen_Item_3, animate=XiaRi_YanMen_Item_3Animate,mark = XiaRi_YanMen_Item_3Mark, }
	g_tableItemActionBtnItem[4] = { itemid = 38002519, itemnum = 2,  btn = XiaRi_YanMen_Item_4, animate=XiaRi_YanMen_Item_4Animate,mark = XiaRi_YanMen_Item_4Mark, }

end

--=========================================================
-- OnEvent
--=========================================================
function XiaRi_YanMen_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关睜界面
		if 0 == nOpType then	
			if this:IsVisible() then
				XiaRi_YanMen_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						XiaRi_YanMen_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_XiaRi_YanMen()
			end

			-- 显示界面
			-- 为了解决界面被犣挡的问题，先把界面关了
			-- if this:IsVisible() then
			-- 	XiaRi_YanMen_OnClose()
			-- end
			XiaRi_YanMen_Reset()
			XiaRi_YanMen_Frame_On_ResetPos()
			this:Show()
			XiaRi_YanMen_ParamInit()
			XiaRi_YanMen_MoneyUpdate()
			XiaRi_YanMen_YuanBaoUpdate()
			XiaRi_YanMen_Update(1)
		end
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						XiaRi_YanMen_OnClose()
					end
				end
			end
			if this:IsVisible() then
				XiaRi_YanMen_ParamInit()
				XiaRi_YanMen_Update(0)
			end
		end

		-- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("XiaRi_YanMen_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- 通用逻辑
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- 如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- 关睜界面
			XiaRi_YanMen_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			XiaRi_YanMen_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		XiaRi_YanMen_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		XiaRi_YanMen_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaRi_YanMen_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		XiaRi_YanMen_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaRi_YanMen_Frame_On_ResetPos()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_nAutoRunUICommandID ) then
		-- local nMissionID = Get_XParam_INT(0)
		-- XiaRi_YanMen_DoAutoGo(nMissionID)
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function XiaRi_YanMen_ParamInit()
	g_nHuoDongStep 		= Get_XParam_INT(2)
	g_nHuoDongProcess 	= Get_XParam_INT(3)
	g_bPlayAnimate 		= Get_XParam_INT(4)
	g_nIsDone			= Get_XParam_INT(5)

	g_nCurDaibi			= Get_XParam_INT(6)

	if nil == g_nHuoDongStep or g_nHuoDongStep < 0 then
		XiaRi_YanMen_OnClose()
	end
end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function XiaRi_YanMen_OnComfirmedBack(strRet)
	if nil == strRet then
		return
	end

	if "Yes" == strRet or "Ok" == strRet then

	end

	if "No" == strRet then
		
	end
end

--=========================================================
-- 界面更新
--=========================================================
-- !!!reloadscript =XiaRi_YanMen
function XiaRi_YanMen_Update(bOpen)
	
	-- 提交成功动画
	if 1 == g_bPlayAnimate then
		XiaRi_YanMen_Animate : Show()
		XiaRi_YanMen_Animate : Play(true)
		g_bPlayAnimate = 0
	else
		XiaRi_YanMen_Animate : Hide()
	end

	-- 长城修筑进度
	local strProcess = tostring(g_nHuoDongProcess/10).."%"
	local strTipsForProgress = ScriptGlobal_Format("#{XHSYM_20220426_29}", strProcess)

	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if g_nHuoDongStep >= 5 or g_nHuoDongStep <= 0 then
		-- XiaRi_YanMen_Text_OKbtn:SetProperty("Disabled", "True");
		-- XiaRi_YanMen_Text_OKbtn:SetText("已完成")

		XiaRi_YanMen_Text_OKbtn : Hide()
		XiaRi_YanMen_Text_SubmitText : Hide()

		XiaRi_YanMen_Finish : Show()
		
	else
		-- XiaRi_YanMen_Text_OKbtn:SetProperty("Disabled", "False");
		-- XiaRi_YanMen_Text_OKbtn:SetText("助力")

		XiaRi_YanMen_Text_OKbtn : Show()
		XiaRi_YanMen_Text_SubmitText : Show()

		XiaRi_YanMen_Finish : Hide()
	end

	XiaRi_YanMen_Exptips : SetToolTip("")
	XiaRi_YanMen_Exptips : SetText(strTipsForProgress)
	XiaRi_YanMen_Exp : SetProgress(tonumber(g_nHuoDongProcess), g_nHuoDongMaxProcess)

	-- 任务提示
	local tMissionInfo = g_tableMissionInfo[g_nHuoDongStep]
	if nil == tMissionInfo then
		return
	end

	-- if (nCurDay) >= 20220712 and (nCurDay) <= 20220713 and g_nHuoDongStep == 5 then
	-- 	tMissionInfo = g_tableMissionInfoEx[g_nHuoDongStep]
	-- 	if nil == tMissionInfo then
	-- 		return
	-- 	end
	-- end
	local strInfoMsg = tMissionInfo.strInfoMsg
	XiaRi_YanMen_TextInfo : SetText(strInfoMsg)

	for i = 1, 4 do
		local theAction = DataPool:CreateBindActionItemForShow(g_tableItemActionBtnItem[i].itemid, g_tableItemActionBtnItem[i].itemnum)
        if theAction:GetID() ~= 0 then
            g_tableItemActionBtnItem[i].btn:SetActionItem(theAction:GetID())
        end
		local isDone = XiaRi_YanMen_CheckPrize(i)
		
		if isDone == 1 then
			g_tableItemActionBtnItem[i].mark : Show()
			g_tableItemActionBtnItem[i].animate:Play(false)
			g_tableItemActionBtnItem[i].animate:Hide()
		else
			if g_nHuoDongStep <= i then
				g_tableItemActionBtnItem[i].mark : Hide()
				g_tableItemActionBtnItem[i].animate:Play(false)
				g_tableItemActionBtnItem[i].animate:Hide()
			else
				g_tableItemActionBtnItem[i].mark : Hide()
				g_tableItemActionBtnItem[i].animate:Play(true)
				g_tableItemActionBtnItem[i].animate:Show()
			end
		end
	end
	
	
	local strSubmitText = ScriptGlobal_Format("#{XHSYM_20220426_143}", g_nCurDaibi)
	XiaRi_YanMen_Text_SubmitText : SetText(strSubmitText)

end

function XiaRi_YanMen_CheckPrize(index)
	local ex = 1
	if index == 2 then ex = 10 end
	if index == 3 then ex = 100 end	
	if index == 4 then ex = 1000 end
	return math.floor(math.mod(g_nIsDone , ex*10) / ex)

end

--=========================================================
-- 助力按钮
--=========================================================
function XiaRi_YanMen_OnSubmitDaiBi()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIClickEvent" )
		Set_XSCRIPT_ScriptID(791020)			
		Set_XSCRIPT_Parameter(0, g_nServerObjID)			
		Set_XSCRIPT_Parameter(1, 1)			
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 前往按钮
--=========================================================
function XiaRi_YanMen_OnAutoGo()
	-- if g_nHuoDongStep == 5 then
	-- 	XiaRi_YanMen_OnGetAllFinishReward()
	-- else
	-- 	Clear_XSCRIPT()
	-- 		Set_XSCRIPT_Function_Name( "OnUIClickEvent" )
	-- 		Set_XSCRIPT_ScriptID(791020)			
	-- 		Set_XSCRIPT_Parameter(0, g_nServerObjID)			
	-- 		Set_XSCRIPT_Parameter(1, 2)			
	-- 		Set_XSCRIPT_ParamCount(2)
	-- 	Send_XSCRIPT()
	-- end

end

--=========================================================
-- 执行自动寻路逻辑
--=========================================================
-- function XiaRi_YanMen_DoAutoGo(nMissionID)
	
-- 	local tAutoRunInfo = g_tableAutoRunInfo[nMissionID]
-- 	if nil == tAutoRunInfo then
-- 		return
-- 	end
-- 	AutoRuntoTargetExWithName(tAutoRunInfo.nPosX, tAutoRunInfo.nPosZ, tAutoRunInfo.nClientSceneID, tAutoRunInfo.strNPCName)
-- end

--=========================================================
-- 领奖按钮
--=========================================================
function XiaRi_YanMen_OnGetAllFinishReward(index)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIClickEvent" )
		Set_XSCRIPT_ScriptID(791020)			
		Set_XSCRIPT_Parameter(0, g_nServerObjID)			
		Set_XSCRIPT_Parameter(1, 3)			
		Set_XSCRIPT_Parameter(2, index)		
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--=========================================================
-- 帮助按钮
--=========================================================
function XiaRi_YanMen_OnClickHelp()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIClickEvent" )
		Set_XSCRIPT_ScriptID(791020)			
		Set_XSCRIPT_Parameter(0, g_nServerObjID)			
		Set_XSCRIPT_Parameter(1, 4)			
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- 重置界面
--=========================================================
function XiaRi_YanMen_Reset()

end

--=========================================================
-- 关睜界面
--=========================================================
function XiaRi_YanMen_OnClose()	
	this:Hide()
	StopCareObject_XiaRi_YanMen()
	-- 重置
	XiaRi_YanMen_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="XiaRi_YanMen_OnHiden();" />
--=========================================================
function XiaRi_YanMen_OnHiden()
	StopCareObject_XiaRi_YanMen()
	-- 重置
	XiaRi_YanMen_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_XiaRi_YanMen()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "XiaRi_YanMen")
end

function StopCareObject_XiaRi_YanMen()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "XiaRi_YanMen")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function XiaRi_YanMen_MoneyUpdate()
	-- XiaRi_YanMen_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- XiaRi_YanMen_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function XiaRi_YanMen_YuanBaoUpdate()
	-- XiaRi_YanMen_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function XiaRi_YanMen_Frame_On_ResetPos()
	XiaRi_YanMen_Frame:SetProperty("UnifiedPosition", g_XiaRi_YanMen_Frame_UnifiedPosition)
end
