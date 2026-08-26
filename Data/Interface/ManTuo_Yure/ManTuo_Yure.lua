-- ManTuo_Yure ÂüÍÓÉ½×¯ÐÂÃÅÅÉÔ¤ÈÈÈÎÎñ 2022-7-13 lishilong
-- !!!reloadscript =ManTuo_Yure
--

local g_ManTuo_Yure_Frame_UnifiedPosition
local MAX_OBJ_DISTANCE 		= 3.0
local g_nObjCaredIDClient 	= -1
local g_nServerObjID 		= -1
local bCaredItem 			= 0
local bCaredObj 			= 0
local bCaredMoney 			= 0
local bCaredYuanBao			= 0
local g_nComfirmParam1		= 0

local g_nMainUICommandID	= 79106001
local g_nAutoGoUICommandID	= 79106002
local g_nMaxHuoDongStep		= 3
local g_nMaxProcessNum		= 4

local g_tStrTitle			= {"#{MTYR_220617_05}", "#{MTYR_220617_17}", "#{MTYR_220617_19}",}
local g_nRewardItemID		= 38002654
local g_nRewardItemNum		= 1

local g_nHuoDongStep		= 0
local g_nFinishMissionNum	= 0
local g_bShowHotPoint		= 0
local g_bRewardGeted		= 0

local g_nCurPageIndex		= 1

local g_hPageBk				= {}
local g_hProcessHover		= {}
local g_hProcessDis			= {}
local g_hMissionReward		= {}

local g_tableAutoRunInfo	= 
{
	[1] = { nClientSceneID = 1, nPosX = 194, nPosZ = 132, 	strNPCName = "Vß½ng Hoà Linh", },
	[2] = { nClientSceneID = 1, nPosX = 194, nPosZ = 132, 	strNPCName = "Vß½ng Hoà Linh", },
	[3] = { nClientSceneID = 1, nPosX = 194, nPosZ = 132, 	strNPCName = "Vß½ng Hoà Linh", },
}

-- 10ÔÂ13È 	²Æ¸»Í¨±¦*20	38002625	
-- 10ÔÂ14È 	½ð²ÏË¿*25	20310168	²ÄÁÏÀ¸
-- 10ÔÂ15È 	ÉñÊÞ»êÓñÀñºÐ	38002675	
-- 10ÔÂ16È 	ºçÒ«Ê¯*5	30503140	
-- 10ÔÂ17È 	¾§Ê¯3¼¶ÀñºÐ*2	38002221	
-- 10ÔÂ18È 	»ÄÊÞ»êÓñÀñºÐ*2	38002676	
-- 10ÔÂ19È 	3¼¶ºì±¦Ê¯*2		
-- 10ÔÂ20È 		50313004	²ÄÁÏÀ¸
local g_tabMissionRewardInfo		= 
{
	[1] = {nItemID = 38002625, nItemNum = 20, 	nNeedBagSpace = 1, nNeedMatSpce = 0, },
	[2] = {nItemID = 20310168, nItemNum = 25, 	nNeedBagSpace = 0, nNeedMatSpce = 1, },
	[3] = {nItemID = 38002675, nItemNum = 1, 	nNeedBagSpace = 1, nNeedMatSpce = 0, },
	[4] = {nItemID = 30503140, nItemNum = 5, 	nNeedBagSpace = 1, nNeedMatSpce = 0, },
	[5] = {nItemID = 38002221, nItemNum = 2, 	nNeedBagSpace = 1, nNeedMatSpce = 0, },
	[6] = {nItemID = 38002676, nItemNum = 2, 	nNeedBagSpace = 1, nNeedMatSpce = 0, },
	[7] = {nItemID = 50313004, nItemNum = 2, 	nNeedBagSpace = 0, nNeedMatSpce = 1, },
}

--=========================================================
-- PreLoad
--=========================================================
function ManTuo_Yure_PreLoad()
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
function ManTuo_Yure_OnLoad()
	g_ManTuo_Yure_Frame_UnifiedPosition = ManTuo_Yure_FrameBK:GetProperty("UnifiedPosition")

	-- ManTuo_Yure_OK_Button : SetEvent("Clicked", "ManTuo_Yure_ConfirmClick()")

	g_hPageBk[1] = ManTuo_Yure_ManTuo1
	g_hPageBk[2] = ManTuo_Yure_ManTuo2
	g_hPageBk[3] = ManTuo_Yure_ManTuo3

	g_hProcessHover[1] = ManTuo_Yure_Progress_Hover1
	g_hProcessHover[2] = ManTuo_Yure_Progress_Hover2
	g_hProcessHover[3] = ManTuo_Yure_Progress_Hover3
	g_hProcessHover[4] = ManTuo_Yure_Progress_Hover4
	-- g_hProcessHover[5] = ManTuo_Yure_Progress_Hover5

	g_hProcessDis[1] = ManTuo_Yure_Progress_Dis1
	g_hProcessDis[2] = ManTuo_Yure_Progress_Dis2
	g_hProcessDis[3] = ManTuo_Yure_Progress_Dis3
	g_hProcessDis[4] = ManTuo_Yure_Progress_Dis4
	-- g_hProcessDis[5] = ManTuo_Yure_Progress_Dis5

	g_hMissionReward[1] = ManTuo_Yure_ManTuo1_Gift1
	g_hMissionReward[2] = ManTuo_Yure_ManTuo1_Gift2
	g_hMissionReward[3] = ManTuo_Yure_ManTuo1_Gift3
	g_hMissionReward[4] = ManTuo_Yure_ManTuo2_Gift1
	g_hMissionReward[5] = ManTuo_Yure_ManTuo2_Gift2
	g_hMissionReward[6] = ManTuo_Yure_ManTuo2_Gift3
	g_hMissionReward[7] = ManTuo_Yure_ManTuo3_Gift1

end

--=========================================================
-- OnEvent
--=========================================================
function ManTuo_Yure_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == g_nMainUICommandID ) then
		-- 0 ¹Ø± , 1 ´ò¿ª, 2 Ë¢ÐÂ, 3 ¶þ´ÎÈ·ÈÏ¿ò
		local nOpType 	= Get_XParam_INT(0)

		-- ¹Ø± ½çÃæ
		if 0 == nOpType then	
			if this:IsVisible() then
				ManTuo_Yure_OnClose()
			end
		end

		-- ´ò¿ª½çÃæ
		if 1 == nOpType then
			-- ¹Ø×¢npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ManTuo_Yure_OnClose()
					end
				end
				g_nServerObjID = nServerObjID
				g_nObjCaredIDClient = DataPool : GetNPCIDByServerID(tonumber(nServerObjID))
				BeginCareObject_ManTuo_Yure()
			end

			-- ÏÔÊ¾½çÃæ
			-- ÎªÁË½â¾ö½çÃæ±» Úµ²µÄÎÊÌâ£¬ÏÈ°Ñ½çÃæ¹ØÁË
			-- if this:IsVisible() then
			-- 	ManTuo_Yure_OnClose()
			-- end
			ManTuo_Yure_Reset()
			ManTuo_Yure_Frame_On_ResetPos()
			this:Show()
			ManTuo_Yure_ParamInit()
			ManTuo_Yure_MoneyUpdate()
			ManTuo_Yure_YuanBaoUpdate()
			ManTuo_Yure_Update(1)
		end
			
		-- Ë¢ÐÂ½çÃæ
		if 2 == nOpType then
			-- ¹Ø×¢npc
			if 1 == bCaredObj then
				local nServerObjID 	= Get_XParam_INT(1)
				if nServerObjID == nil or nServerObjID < 0 then
					if this:IsVisible() then
						ManTuo_Yure_OnClose()
					end
				end
			end
			if this:IsVisible() then
				ManTuo_Yure_ParamInit()
				ManTuo_Yure_Update(0)
			end
		end

		-- ¶þ´ÎÈ·ÈÏ¿ò
		if 3 == nOpType then
			local strMsg = Get_XParam_STR(0)
			-- g_nComfirmParam1 = Get_XParam_INT(1)
			-- ["Type"] "Ok" "YesNo"
			MessageBoxSelf3("ManTuo_Yure_OnComfirmedBack", {["Content"] = strMsg,["Type"] = "YesNo", })
		end

	-- ============================================
	-- Í¨ÓÃÂß¼­
	elseif ( event == "OBJECT_CARED_EVENT" ) and 1 == bCaredObj then
		if(tonumber(arg0) ~= g_nObjCaredIDClient) then
			return
		end
		-- Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- ¹Ø± ½çÃæ
			ManTuo_Yure_OnClose()
		end	

	-- ÎïÆ·¸Ä±ä
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() and 1 == bCaredItem ) then
		-- Ë¢ÐÂ½çÃæ
		if this:IsVisible() then
			ManTuo_Yure_Update(0)
		end

	-- ½ðÇ®¸Ä±ä
	elseif (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and 1 == bCaredMoney then
		ManTuo_Yure_MoneyUpdate()

	-- Ôª±¦¸Ä±ä
	elseif event == "UPDATE_YUANBAO" and 1 == bCaredYuanBao then
		ManTuo_Yure_YuanBaoUpdate()

	elseif event == "HIDE_ON_SCENE_TRANSED" then
		ManTuo_Yure_OnClose()
	
	elseif (event == "ADJEST_UI_POS" ) then
		ManTuo_Yure_Frame_On_ResetPos()

	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		ManTuo_Yure_Frame_On_ResetPos()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_nAutoGoUICommandID ) then
		local nParam = Get_XParam_INT(0)
		ManTuo_Yure_DoAutoGo(nParam)
	end
end

--=========================================================
-- ½çÃæ²ÎÊý³õÊ¼»¯
--=========================================================
function ManTuo_Yure_ParamInit()
	g_nHuoDongStep 		= Get_XParam_INT(1)
	g_nFinishMissionNum = Get_XParam_INT(2)
	g_bShowHotPoint 	= Get_XParam_INT(3)
	g_bRewardGeted 		= Get_XParam_INT(4)

	if (g_nHuoDongStep <= 0 or g_nHuoDongStep > g_nMaxHuoDongStep) and this:IsVisible() then
		ManTuo_Yure_OnClose()
	end

	g_nCurPageIndex = g_nHuoDongStep
end

--=========================================================
-- ½çÃæ¸üÐÂ
--=========================================================
-- !!!reloadscript =ManTuo_Yure
function ManTuo_Yure_Update(bOpen)

	-- Ð£Ñé»î¶¯Ê±¼ä ×Ô¶¯¹Ø± ½çÃæ
	if (g_nHuoDongStep <= 0 or g_nHuoDongStep > g_nMaxHuoDongStep) and this:IsVisible() then
		ManTuo_Yure_OnClose()
	end

	-- Ð£Ñéµ±Ç°Ò³Ç©ÊÇ·ñºÏ·¨
	if (g_nCurPageIndex <= 0 or g_nCurPageIndex > g_nMaxHuoDongStep) and this:IsVisible() then
		ManTuo_Yure_OnClose()
	end

	-- ÈÎÎñÒ³ÃæÏÔÊ¾
	for i = 1, g_nMaxHuoDongStep do
		if i == g_nCurPageIndex then
			g_hPageBk[i] : Show()	
		else
			g_hPageBk[i] : Hide()
		end
	end

	-- ·­Ò³°´Å¥Âß¼­
	ManTuo_Yure_Pre 	: Show()
	ManTuo_Yure_Next 	: Show()
	if 1 == g_nCurPageIndex then
		ManTuo_Yure_Pre : Hide()
	end
	if g_nMaxHuoDongStep == g_nCurPageIndex then
		ManTuo_Yure_Next : Hide()
	end

	-- ½çÃæ±êÌâ
	ManTuo_Yure_DragTitle : SetText( g_tStrTitle[g_nCurPageIndex] )

	-- ½±Àø½ø¶ÈÏÔÊ¾
	for i = 1, g_nMaxProcessNum do
		if g_nFinishMissionNum >= i then
			g_hProcessHover[i] 	: Show()
			g_hProcessDis[i] 	: Hide()
		else
			g_hProcessHover[i] 	: Hide()
			g_hProcessDis[i] 	: Show()
		end
	end
	-- ManTuo_Yure_Progress_Bar_EXP : SetProgress(g_nFinishMissionNum, g_nMaxProcessNum)	

	-- ÓµÓÐÏÔÊ¾
	local nHaveNum = g_nFinishMissionNum
	if nHaveNum > g_nMaxProcessNum then
		nHaveNum = g_nMaxProcessNum
	end
	ManTuo_Yure_Progress_BarButIocn_Text : SetText( ScriptGlobal_Format("#{MTYR_220617_145}", nHaveNum) )

	-- ½±Àø°´Å¥¶¯»­ÌØÐ§
	if 1 == g_bShowHotPoint then
		ManTuo_Yure_Progress_BarBut_Tips : Show()
		-- ManTuo_Yure_Progress_BarButAnimate : Play(true)
	else
		ManTuo_Yure_Progress_BarBut_Tips : Hide()
		-- ManTuo_Yure_Progress_BarButAnimate : Play(false)
	end

	-- ½±Àø°´Å¥ÉèÖÃ
	-- local theAction = DataPool:CreateActionItemForShow(g_nRewardItemID, g_nRewardItemNum)
	-- local theAction = DataPool:CreateBindActionItemForShow(g_nRewardItemID, g_nRewardItemNum)
	-- ManTuo_Yure_Progress_BarBut : SetActionItem(theAction:GetID())

	-- ÒÑÁìÈ¡Âß¼­
	if 1 == g_bRewardGeted then
		ManTuo_Yure_Progress_BarBut_Icon_Mask 	: Show()
		ManTuo_Yure_Progress_BarBut				: Hide()
	else
		ManTuo_Yure_Progress_BarBut_Icon_Mask 	: Hide()
		ManTuo_Yure_Progress_BarBut				: Show()
	end

	-- ÈÎÎñ½±Àø ¹Ê¾
	for i = 1, table.getn(g_tabMissionRewardInfo) do
		local tRewardInfo = g_tabMissionRewardInfo[i]
		if nil == tRewardInfo then
			return
		end
		-- local theAction = DataPool:CreateActionItemForShow(tRewardInfo.nItemID, tRewardInfo.nItemNum)
		local theAction = DataPool:CreateBindActionItemForShow(tRewardInfo.nItemID, tRewardInfo.nItemNum)
		g_hMissionReward[i] : SetActionItem(theAction:GetID())
	end

end

--=========================================================
-- ÖØÖÃ½çÃæ
--=========================================================
function ManTuo_Yure_Reset()
	g_nHuoDongStep 		= 0
	g_nFinishMissionNum = 0
	g_bShowHotPoint		= 0
	g_bRewardGeted		= 0
end

--=========================================================
-- ÉÏ·­Ò³
--=========================================================
function ManTuo_Yure_Pre_Clicked()
	local nNewPageIndex = g_nCurPageIndex - 1

	if (nNewPageIndex <= 0 or nNewPageIndex > g_nMaxHuoDongStep) then
		-- PushDebugMessage("·Ç·¨²ÎÊý")
		return
	end

	g_nCurPageIndex = nNewPageIndex
	ManTuo_Yure_Update(0)
end

--=========================================================
-- ÏÂ·­Ò³
--=========================================================
function ManTuo_Yure_Next_Clicked()

	local nNewPageIndex = g_nCurPageIndex + 1

	if (nNewPageIndex <= 0 or nNewPageIndex > g_nMaxHuoDongStep) then
		-- PushDebugMessage("·Ç·¨²ÎÊý")
		return
	end

	-- PushDebugMessage("ManTuo_Yure_Next_Clicked"..",nNewPageIndex:"..nNewPageIndex..",g_nHuoDongStep:"..g_nHuoDongStep)

	if nNewPageIndex > g_nHuoDongStep then
		PushDebugMessage("#{MTYR_220617_16}")
		return
	end

	g_nCurPageIndex = nNewPageIndex
	ManTuo_Yure_Update(0)
end

--=========================================================
-- ÁìÈ¡½±Àø
--=========================================================
function ManTuo_Yure_GetProcessReward()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791060)
		-- 1¡¢ÁìÈ¡½±Àø 2¡¢×Ô¶¯Ñ°Â· 3¡¢°ïÖú
		Set_XSCRIPT_Parameter(0, 1)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--=========================================================
-- Ö´ÐÐ×Ô¶¯Ñ°Â·Âß¼­
--=========================================================
function ManTuo_Yure_DoAutoGo(nParam)
	
	local tAutoRunInfo = g_tableAutoRunInfo[nParam]
	if nil == tAutoRunInfo then
		return
	end
	AutoRuntoTargetExWithName(tAutoRunInfo.nPosX, tAutoRunInfo.nPosZ, tAutoRunInfo.nClientSceneID, tAutoRunInfo.strNPCName)
end

--=========================================================
-- ²ÎÓë°´Å¥
--=========================================================
function ManTuo_Yure_GoToButtonClicked(nPageIndex)
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791060)
		-- 1¡¢ÁìÈ¡½±Àø 2¡¢×Ô¶¯Ñ°Â· 3¡¢°ïÖú
		Set_XSCRIPT_Parameter(0, 2)
		Set_XSCRIPT_Parameter(1, nPageIndex)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--=========================================================
-- °ïÖú
--=========================================================
function ManTuo_Yure_OnHelpClicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnUIEvent" )
		Set_XSCRIPT_ScriptID(791060)
		-- 1¡¢ÁìÈ¡½±Àø 2¡¢×Ô¶¯Ñ°Â· 3¡¢°ïÖú
		Set_XSCRIPT_Parameter(0, 3)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--=========================================================
-- ¹Ø± ½çÃæ
--=========================================================
function ManTuo_Yure_OnClose()	
	this:Hide()
	StopCareObject_ManTuo_Yure()
	-- ÖØÖÃ
	ManTuo_Yure_Reset()
end

--=========================================================
-- ½çÃæÒþ²Ø
-- <Event Name="Hidden" Function="ManTuo_Yure_OnHiden();" />
--=========================================================
function ManTuo_Yure_OnHiden()
	StopCareObject_ManTuo_Yure()
	-- ÖØÖÃ
	ManTuo_Yure_Reset()
end

--=========================================================
-- ¹ØÐÄ²Ù×÷
--=========================================================
function BeginCareObject_ManTuo_Yure()
	-- ¹ØÐÄ
	this:CareObject(g_nObjCaredIDClient, 1, "ManTuo_Yure")
end

function StopCareObject_ManTuo_Yure()
	-- È¡Ïû¹ØÐÄ
	if nil ~= g_nObjCaredIDClient and g_nObjCaredIDClient > 0 then
		this:CareObject(g_nObjCaredIDClient, 0, "ManTuo_Yure")
	end
	g_nServerObjID = -1
end

--=========================================================
-- ½ðÇ®Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î ½ðÇ®ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
function ManTuo_Yure_MoneyUpdate()
	-- ManTuo_Yure_HaveJiaoZiNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	-- ManTuo_Yure_HaveGoldNum : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ôª±¦Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î Ôª±¦ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
function ManTuo_Yure_YuanBaoUpdate()
	-- ManTuo_Yure_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
end

--=========================================================
-- ½çÃæÎ»ÖÃ
--=========================================================
function ManTuo_Yure_Frame_On_ResetPos()
	ManTuo_Yure_FrameBK:SetProperty("UnifiedPosition", g_ManTuo_Yure_Frame_UnifiedPosition)
end
