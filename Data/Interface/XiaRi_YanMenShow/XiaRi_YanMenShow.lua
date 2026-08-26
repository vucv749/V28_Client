-- XiaRi_YanMenShow 星火生雁门牴示画卷界面 2022-5-9 lishilong
-- !!!reloadscript =XiaRi_YanMenShow
--

local g_XiaRi_YanMenShow_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 1
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nUICommandID		= 79102002
local g_nImagePosX			= 0 
local g_nImagePosY			= 0 

local g_XiaRi_YanMenShow_ShowTime = 5

--=========================================================
-- PreLoad
--=========================================================
function XiaRi_YanMenShow_PreLoad()
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
function XiaRi_YanMenShow_OnLoad()
	g_XiaRi_YanMenShow_Frame_UnifiedPosition = XiaRi_YanMenShow_Frame:GetProperty("UnifiedPosition")
	
	-- g_nImagePosX = XiaRi_YanMenShow_Image1 : GetProperty("UnifiedXPosition")
	-- g_nImagePosY = XiaRi_YanMenShow_Image1 : GetProperty("UnifiedYPosition")

	-- XiaRi_YanMenShow_OK_Button : SetEvent("Clicked", "XiaRi_YanMenShow_ConfirmClick()")
end

--=========================================================
-- OnEvent
--=========================================================
function XiaRi_YanMenShow_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nUICommandID ) then
		-- 0 关睜, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)

		-- 关睜界面
		if 0 == nOpType then	
			if this:IsVisible() then
				XiaRi_YanMenShow_OnClose()
			end
		end

		-- 打开界面
		if 1 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						XiaRi_YanMenShow_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_XiaRi_YanMenShow()
			end

			-- 显示界面
			-- 为了解决界面被犣挡的问题，先把界面关了
			if this:IsVisible() then
				XiaRi_YanMenShow_OnClose()
			end
			XiaRi_YanMenShow_Reset()
			XiaRi_YanMenShow_Frame_On_ResetPos()
			this:Show()
			XiaRi_YanMenShow_ParamInit()
			XiaRi_YanMenShow_MoneyUpdate()
			XiaRi_YanMenShow_YuanBaoUpdate()
			XiaRi_YanMenShow_Update(1)
		end
			
		-- 刷新界面
		if 2 == nOpType then
			-- 关注npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						XiaRi_YanMenShow_OnClose()
					end
				end
			end
			if this:IsVisible() then
				XiaRi_YanMenShow_ParamInit()
				XiaRi_YanMenShow_Update(0)
			end
		end

		-- 二次确认框
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("XiaRi_YanMenShow_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
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
			XiaRi_YanMenShow_OnClose()
		end	

	-- 物品改变
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- 刷新界面
		if this:IsVisible() then
			XiaRi_YanMenShow_Update(0)
		end

	-- 金钱改变
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		XiaRi_YanMenShow_MoneyUpdate()

	-- 元宝改变
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		XiaRi_YanMenShow_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaRi_YanMenShow_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		XiaRi_YanMenShow_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		XiaRi_YanMenShow_Frame_On_ResetPos()
	end
end

--=========================================================
-- 界面参数初始化
--=========================================================
function XiaRi_YanMenShow_ParamInit()

end

--=========================================================
-- 二次确认框回调 ["Type"] "Ok"的返回值有"Ok"； ["Type"] "YesNo"的返回值有 "Yes" "No"
--=========================================================
function XiaRi_YanMenShow_OnComfirmedBack(strRet)
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
-- !!!reloadscript =XiaRi_YanMenShow
function XiaRi_YanMenShow_Update(bOpen)
	-- PushDebugMessage("X"..XiaRi_YanMenShow_Image1:GetProperty("UnifiedXPosition").."Y"..XiaRi_YanMenShow_Image1:GetProperty("UnifiedYPosition") )
	KillTimer( "XiaRi_YanMenShow_OnTimer()" )
	SetTimer("XiaRi_YanMenShow","XiaRi_YanMenShow_OnTimer()", g_XiaRi_YanMenShow_ShowTime*1000)
	-- XiaRi_YanMenShow_Image1 : Tween_SetInfo("Position", "curve:Liner mode:Once duration:2.0 startx:-800 starty:0 endx:0 endy:0")
	-- XiaRi_YanMenShow_Image1 : Tween_Play("Position", true, true)
	-- XiaRi_YanMenShow_Close : Tween_SetInfo("Position", "curve:Liner mode:Once duration:2.0 startx:-800 starty:0 endx:0 endy:0")
	-- XiaRi_YanMenShow_Close : Tween_Play("Position", true, true)
end

--=========================================================
-- 重置界面
--=========================================================
function XiaRi_YanMenShow_Reset()
	-- KillTimer("XiaRi_YanMenShow_OnTweenTimer()")
	-- XiaRi_YanMenShow_Image1 : Tween_Reset("Position", true)
	-- XiaRi_YanMenShow_Image1 : SetProperty("UnifiedXPosition", g_nImagePosX)
	-- XiaRi_YanMenShow_Image1 : SetProperty("UnifiedYPosition", g_nImagePosY)
	KillTimer( "XiaRi_YanMenShow_OnTimer()" )
end

--=========================================================
-- 界面确认按钮
--=========================================================
function XiaRi_YanMenShow_ConfirmClick()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(060225)
		Set_XSCRIPT_Parameter(0, 2)					
		Set_XSCRIPT_Parameter(1, 1)				
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

function XiaRi_YanMenShow_OnTimer()
	--关睜定时器
	KillTimer( "XiaRi_YanMenShow_OnTimer()" )
	XiaRi_YanMenShow_OnClose()	
end

--=========================================================
-- 关睜界面
--=========================================================
function XiaRi_YanMenShow_OnClose()	
	this:Hide()
	StopCareObject_XiaRi_YanMenShow()
	-- 重置
	XiaRi_YanMenShow_Reset()
end

--=========================================================
-- 界面隐藏
-- <Event Name="Hidden" Function="XiaRi_YanMenShow_OnHiden();" />
--=========================================================
function XiaRi_YanMenShow_OnHiden()
	StopCareObject_XiaRi_YanMenShow()
	-- 重置
	XiaRi_YanMenShow_Reset()
end

--=========================================================
-- 关心操作
--=========================================================
function BeginCareObject_XiaRi_YanMenShow()
	-- 关心
	this:CareObject(g_nObjCaredIDClient, 1, "XiaRi_YanMenShow")
end

function StopCareObject_XiaRi_YanMenShow()
	-- 取消关心
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "XiaRi_YanMenShow")
	end
	g_nServerObjID = -1
end

--=========================================================
-- 金钱刷新：界面更新调用一次 金钱事件调用一次
--=========================================================
function XiaRi_YanMenShow_MoneyUpdate()
	-- XiaRi_YanMenShow_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- XiaRi_YanMenShow_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- 元宝刷新：界面更新调用一次 元宝事件调用一次
--=========================================================
function XiaRi_YanMenShow_YuanBaoUpdate()
	-- XiaRi_YanMenShow_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- 界面位置
--=========================================================
function XiaRi_YanMenShow_Frame_On_ResetPos()
	XiaRi_YanMenShow_Frame:SetProperty("UnifiedPosition", g_XiaRi_YanMenShow_Frame_UnifiedPosition)
end
