-- 界面的默认相对位置
local SweepPage_Frame_UnifiedXPosition;
local SweepPage_Frame_UnifiedYPosition;

local SweepPage_open_fubenId = -1
local SweepPage_SpecialSweep = -1 --1金币扫荡 2特权扫荡 3银币扫荡

--格子及其编号
local SweepPage_ITEM_NUM = 12;
local SweepPage_ITEMS = {};

local SweepPage_BossIcon = {}
local SweepPage_BossButton = {}
local SweepPage_BossingAnimate = {}
local SweepPage_BossDieIcon = {}
local SweepPage_BossName = {}
local SeeepPage_Timer = {}

local SweepPage_MaxBoss = 6

local SweepPage_CheckButton = {}

local SweepPage_GiveUpCheckButton = 1

local SweepPage_curPassIndex = 0

local SweepPage_FuBenSecKillNum = {}

function SweepPage_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);
	
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("REFRESH_SECKILL_PAGE")
	this:RegisterEvent("REFRESH_SECKILL_ITEM")
	this:RegisterEvent("SEND_SECKILL")
	this:RegisterEvent("UPDATE_SECKILL_FUBEN_SECKILLNUM")
	this:RegisterEvent("REFRESH_SECKILL_MONEY",false)
	this:RegisterEvent("REFRESH_SECKILL_YINBI",false)
end

function SweepPage_OnLoad()
	SweepPage_Frame_UnifiedXPosition	= SweepPage_Frame : GetProperty("UnifiedXPosition");
	SweepPage_Frame_UnifiedYPosition	= SweepPage_Frame : GetProperty("UnifiedYPosition");
	
	local SecKillFubenCount = GetSecKillFuBenCount()
	for i = 0, SecKillFubenCount do
		SweepPage_CheckButton[i] = 0
	end
	
	SweepPage_ITEMS[1] = SweepPage_Item1
	SweepPage_ITEMS[2] = SweepPage_Item2
	SweepPage_ITEMS[3] = SweepPage_Item3
	SweepPage_ITEMS[4] = SweepPage_Item4
	SweepPage_ITEMS[5] = SweepPage_Item5
	SweepPage_ITEMS[6] = SweepPage_Item6
	SweepPage_ITEMS[7] = SweepPage_Item7
	SweepPage_ITEMS[8] = SweepPage_Item8
	SweepPage_ITEMS[9] = SweepPage_Item9
	SweepPage_ITEMS[10] = SweepPage_Item10
	SweepPage_ITEMS[11] = SweepPage_Item11
	SweepPage_ITEMS[12] = SweepPage_Item12
	
	SweepPage_BossIcon[1] = SweepPage_Boss1
	SweepPage_BossIcon[2] = SweepPage_Boss2
	SweepPage_BossIcon[3] = SweepPage_Boss3
	SweepPage_BossIcon[4] = SweepPage_Boss4
	SweepPage_BossIcon[5] = SweepPage_Boss5
	SweepPage_BossIcon[6] = SweepPage_Boss6
	
	SweepPage_BossButton[1] = SweepPage_Boss1AnimateImage
	SweepPage_BossButton[2] = SweepPage_Boss2AnimateImage
	SweepPage_BossButton[3] = SweepPage_Boss3AnimateImage
	SweepPage_BossButton[4] = SweepPage_Boss4AnimateImage
	SweepPage_BossButton[5] = SweepPage_Boss5AnimateImage
	SweepPage_BossButton[6] = SweepPage_Boss6AnimateImage
	
	SweepPage_BossingAnimate[1] = SweepPage_Boss1doing
	SweepPage_BossingAnimate[2] = SweepPage_Boss2doing
	SweepPage_BossingAnimate[3] = SweepPage_Boss3doing
	SweepPage_BossingAnimate[4] = SweepPage_Boss4doing
	SweepPage_BossingAnimate[5] = SweepPage_Boss5doing
	SweepPage_BossingAnimate[6] = SweepPage_Boss6doing
	
	SweepPage_BossDieIcon[1] = SweepPage_Boss1finish
	SweepPage_BossDieIcon[2] = SweepPage_Boss2finish
	SweepPage_BossDieIcon[3] = SweepPage_Boss3finish
	SweepPage_BossDieIcon[4] = SweepPage_Boss4finish
	SweepPage_BossDieIcon[5] = SweepPage_Boss5finish
	SweepPage_BossDieIcon[6] = SweepPage_Boss6finish
	
	SweepPage_BossName[1] = SweepPage_Boss1Name
	SweepPage_BossName[2] = SweepPage_Boss2Name
	SweepPage_BossName[3] = SweepPage_Boss3Name
	SweepPage_BossName[4] = SweepPage_Boss4Name
	SweepPage_BossName[5] = SweepPage_Boss5Name
	SweepPage_BossName[6] = SweepPage_Boss6Name
	
	SeeepPage_Timer[1] = SweepPage_Boss1_StopWatch
	SeeepPage_Timer[2] = SweepPage_Boss2_StopWatch
	SeeepPage_Timer[3] = SweepPage_Boss3_StopWatch
	SeeepPage_Timer[4] = SweepPage_Boss4_StopWatch
	SeeepPage_Timer[5] = SweepPage_Boss5_StopWatch
	SeeepPage_Timer[6] = SweepPage_Boss6_StopWatch
	
	SweepPage_Double2:Hide()
	SweepPage_Explain4:Hide()
end

-- OnEvent
function SweepPage_OnEvent(event)
	if (event == "UI_COMMAND" ) then
		if tonumber(arg0) == 20150212 then
			SweepPage_open_fubenId = Get_XParam_INT(0)
			SweepPage_SpecialSweep = Get_XParam_INT(1)
			OpenWindow("Packet")
			this:Show()
			SweepPage_Update(0)
		elseif tonumber(arg0) == 20150228 then
			if this:IsVisible() then
				SweepPage_Update(0)
			end
		end
		
	elseif (event == "REFRESH_SECKILL_PAGE") then
		if this:IsVisible() then
			SweepPage_Update(1)
		end
		
	elseif (event == "REFRESH_SECKILL_ITEM") then
		if this:IsVisible() then
			SweepPage_Item_Update()
		end
	
	elseif (event == "SEND_SECKILL") then
		if this:IsVisible() then
			if tonumber(arg0) == 0 then
				SweepPage_SendSecKill(tonumber(arg1), tonumber(arg2), tonumber(arg3))
			end
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SweepPage_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		SweepPage_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		SweepPage_OnClosed()
		
	elseif( event == "UPDATE_SECKILL_FUBEN_SECKILLNUM") then
		SweepPage_UpdateSeckillNum()
	elseif( event == "REFRESH_SECKILL_MONEY") then
		if  SweepPage_SpecialSweep == 1 then
			--金币扫荡
			local _,_,_,_,_,_,_,uDaiBi = GetSecKillData()
			local strDaiBiMoney = ScriptGlobal_Format("#{JBSD_230919_01}",uDaiBi)
			--SweepPage_Sweepcoin:Show()
			SweepPage_Sweepcoin:SetText(strDaiBiMoney)
			SweepPage_Sweepcoin:SetToolTip("#{JBSD_230919_02}")
		elseif SweepPage_SpecialSweep == 3 then
			--银币扫荡
			local _,_,_,_,_,_,_,uDaiBi = GetSecKillData()
			local strDaiBiMoney = ScriptGlobal_Format("#{JBSD_230919_01}",uDaiBi)
			--SweepPage_Sweepcoin:Show()
			SweepPage_Sweepcoin:SetText(strDaiBiMoney)
			SweepPage_Sweepcoin:SetToolTip("#{JBSD_230919_02}")
		else
			--SweepPage_Sweepcoin:Hide()
			SweepPage_Sweepcoin:SetText("")
			SweepPage_Sweepcoin:SetToolTip("")
		end
	elseif( event == "REFRESH_SECKILL_YINBI") then
		if  SweepPage_SpecialSweep == 3 then
			--银币扫荡
			SweepPage_Sweepsilvercoin_icons_Show()
		else
			SweepPage_Sweepsilvercoin_icons_Hide()
		end
	end
end

function SweepPage_Frame_On_ResetPos()
	SweepPage_Frame : SetProperty("UnifiedXPosition", SweepPage_Frame_UnifiedXPosition);
	SweepPage_Frame : SetProperty("UnifiedYPosition", SweepPage_Frame_UnifiedYPosition);
end

--显示扫荡银币(铜符)控件
function SweepPage_Sweepsilvercoin_icons_Show()
	--银币扫荡
	local _,_,_,_,_,_,_,uDaiBi,_,uYinbi = GetSecKillData()
	local strYinbi = ScriptGlobal_Format("#{YBSD_231107_08}",uYinbi)
	--SweepPage_Sweepsilvercoin:Show()
	SweepPage_Sweepsilvercoin:SetText(strYinbi)
	SweepPage_Sweepsilvercoin:SetToolTip("#{YBSD_231107_09}")
	--SweepPage_Sweepsilvercoin_icons:Show()
end

function SweepPage_Sweepsilvercoin_icons_Hide()
	--SweepPage_Sweepsilvercoin:Hide()
	SweepPage_Sweepsilvercoin:SetText("")
	SweepPage_Sweepsilvercoin:SetToolTip("")
	--SweepPage_Sweepsilvercoin_icons:Hide()
end

function SweepPage_OnClosed()
	this:Hide();
	
	for i=1, SweepPage_MaxBoss do
		SeeepPage_Timer[i]:SetProperty("Timer", "-1");
	end
end

function SweepPage_Item_Update()
	--显示物品栏的物品
	for i=1, SweepPage_ITEM_NUM do
		SweepPage_ITEMS[i]:SetActionItem(-1);
		SweepPage_ITEMS[i]:Enable();
	end
	
	--从数据池中使用数据填入背包内的物品
	local nActIndex = 0
	
	for i=1, SweepPage_ITEM_NUM  do
		local theAction = SecKillEnumItem(nActIndex);
		nActIndex = nActIndex+1;

		if theAction:GetID() ~= 0 then
			SweepPage_ITEMS[i]:SetActionItem(theAction:GetID());
		else
			SweepPage_ITEMS[i]:SetActionItem(-1);
		end
	end
end

function SweepPage_UpdateControl()

		SweepPage_ExplainBK:Show()
		SweepPage_Explain3:Hide()
		SweepPage_ExplainJinBiBK:Hide()
		
		SweepPage_Boss4_SanShen:Hide()
		SweepPage_BossIcon[4] = SweepPage_Boss4
		SweepPage_BossButton[4] = SweepPage_Boss4AnimateImage
		SweepPage_BossingAnimate[4] = SweepPage_Boss4doing
		SweepPage_BossDieIcon[4] = SweepPage_Boss4finish
	
		SweepPage_Boss5_SanShen:Hide()
		SweepPage_BossIcon[5] = SweepPage_Boss5
		SweepPage_BossButton[5] = SweepPage_Boss5AnimateImage
		SweepPage_BossingAnimate[5] = SweepPage_Boss5doing
		SweepPage_BossDieIcon[5] = SweepPage_Boss5finish
	
		SweepPage_Boss6_SanShen:Hide()
		SweepPage_BossIcon[6] = SweepPage_Boss6
		SweepPage_BossButton[6] = SweepPage_Boss6AnimateImage
		SweepPage_BossingAnimate[6] = SweepPage_Boss6doing
		SweepPage_BossDieIcon[6] = SweepPage_Boss6finish

end

function SweepPage_Update(InSeckill)
	SweepPage_Item_Update()

	SweepPage_GoOn:Disable()
	SweepPage_GoOn_tips:Show()
	
	SweepPage_UpdateControl()
	
	--显示Boss图标
	local isInSecKill,FubenIdex,BossIndex,DoubleExp,MoneySweep,TeQuanSweep,CheckHuodongTime,uDaiBi,YinbiSweep,Yinbi = GetSecKillData()
	local BossIcon = {}
	local BossName = {}
	local BossMaxNum = 0
	
	if isInSecKill == 1 and FubenIdex == (SweepPage_open_fubenId-1) and DoubleExp == 1 then
		SweepPage_CheckButton[SweepPage_open_fubenId-1] = 1
	end
	local IconName,FubenName,needLevel,moneyLevel,SecKillNum,SecKillMaxNum,SecKillNeedNum,CanDoubleExp, numYuanbao, numMoney,costYinbi= GetSecKillInfoByIndex(SweepPage_open_fubenId)
	local strTemp = ScriptGlobal_Format("#{FBSD_150126_26}",FubenName)
	SweepPage_DragTitle:SetText(strTemp)
	if  SweepPage_SpecialSweep == 1 then
		--金币扫荡
		local strDaiBiMoney = ScriptGlobal_Format("#{JBSD_230919_01}",uDaiBi)
		--SweepPage_Sweepcoin:Show()
		SweepPage_Sweepcoin :SetText(strDaiBiMoney)
		SweepPage_Sweepcoin :SetToolTip("#{JBSD_230919_02}")
		SweepPage_Sweepsilvercoin_icons_Hide()
		
		SweepPage_ExplainBK:Hide()
		SweepPage_ExplainJinBiBK:Show()
		SweepPage_ExplainTeQuanBK:Hide()
		local strTemp = ScriptGlobal_Format("#{JBSD_220210_03}",FubenName,numMoney).."#{JBSD_220210_04}"
		SweepPage_ExplainJinBi1:SetText(strTemp)
		SweepPage_GoOn:SetText("再次进行扫荡")

	elseif SweepPage_SpecialSweep == 2 then
		--特权扫荡
		SweepPage_ExplainBK:Hide()
		SweepPage_ExplainJinBiBK:Hide()
		SweepPage_ExplainTeQuanBK:Show()
		SweepPage_ExplainTeQuan1:SetText("#{TQJF_221108_27}")
		SweepPage_GoOn:SetText("再次特权扫荡")
		strTemp = ScriptGlobal_Format("#{TQJF_221108_07}",FubenName)
	    SweepPage_DragTitle:SetText(strTemp)

		--SweepPage_Sweepcoin:Hide()
		SweepPage_Sweepcoin :SetText("")
		SweepPage_Sweepcoin :SetToolTip("")
		SweepPage_Sweepsilvercoin_icons_Hide()
	
	elseif SweepPage_SpecialSweep == 3 then
		--银币扫荡
		local strJinbi = ScriptGlobal_Format("#{JBSD_230919_01}",uDaiBi)
		--SweepPage_Sweepcoin:Show()
		SweepPage_Sweepcoin :SetText(strJinbi)
		SweepPage_Sweepcoin :SetToolTip("#{JBSD_230919_02}")
		SweepPage_Sweepsilvercoin_icons_Show()

		SweepPage_ExplainBK:Hide()
		SweepPage_ExplainJinBiBK:Show()
		SweepPage_ExplainTeQuanBK:Hide()
		costYinbi = math.floor(costYinbi/10000)--显示时做个转换
		local strTemp = ScriptGlobal_Format("#{YBSD_231107_03}",FubenName,costYinbi).."#{YBSD_231107_04}"
		SweepPage_ExplainJinBi1:SetText(strTemp)
		SweepPage_GoOn:SetText("再次进行扫荡")
	else
		--普通扫荡
		SweepPage_ExplainBK:Show()
		SweepPage_Explain3:Hide()
		SweepPage_ExplainJinBiBK:Hide()
		SweepPage_ExplainTeQuanBK:Hide()
		local strTemp = ScriptGlobal_Format("#{FBSD_210129_01}", numYuanbao)
		SweepPage_Explain:SetText(strTemp)
		SweepPage_GoOn:SetText("再次进行扫荡")

		--SweepPage_Sweepcoin:Hide()
		SweepPage_Sweepcoin :SetText("")
		SweepPage_Sweepcoin :SetToolTip("")
		SweepPage_Sweepsilvercoin_icons_Hide()
	end
	
	if DoubleExp == 1 then
		SweepPage_DoubleText2:SetText("#{FBSD_150126_74}")
		
	else
		local text = ScriptGlobal_Format("#{FBSD_210129_03}", numYuanbao)
		SweepPage_DoubleText2:SetText(text)
		
		local tips = ScriptGlobal_Format("#{FBSD_210129_02}", numYuanbao)
		SweepPage_DoubleCheck:SetToolTip(tips)
	end
	
	FubenName,BossMaxNum,BossIcon[1],BossName[1],BossIcon[2],BossName[2],BossIcon[3],BossName[3],BossIcon[4],BossName[4],BossIcon[5],BossName[5],BossIcon[6],BossName[6], CanDoubleExp = GetSecKillBossIconByIndex(SweepPage_open_fubenId)
	
	local KillBossIndex = 1
	
	if isInSecKill == 1 and FubenIdex == (SweepPage_open_fubenId-1) then
		KillBossIndex = BossIndex + 1
	elseif isInSecKill == 0 and InSeckill == 1 then
		KillBossIndex = BossMaxNum + 1
		SweepPage_GoOn:Enable()
		SweepPage_GoOn_tips:Hide()
	end
	
	local Msg = ScriptGlobal_Format("#{SDYH_170123_09}",0,0)
	
	if SweepPage_FuBenSecKillNum[SweepPage_open_fubenId-1][1] ~= 0 then
	 Msg = ScriptGlobal_Format("#{SDYH_170123_09}",SweepPage_FuBenSecKillNum[SweepPage_open_fubenId-1][1], SweepPage_FuBenSecKillNum[SweepPage_open_fubenId-1][2])
	else
	 Msg = ScriptGlobal_Format("#{SDYH_170123_09}","#cff0000"..SweepPage_FuBenSecKillNum[SweepPage_open_fubenId-1][1], SweepPage_FuBenSecKillNum[SweepPage_open_fubenId-1][2])
	end
	
	SweepPage_Explain_times:SetText(Msg)
	
	for i=1, BossMaxNum do
		SweepPage_BossIcon[i]:Show()
		SweepPage_BossName[i]:Show()
		SweepPage_BossName[i]:SetText("#cfff263"..BossName[i])
		
		if BossIcon[i] ~= nil and BossIcon[i] ~= "" then
				local sPos,_ = string.find(BossIcon[i]," ");
				local IconImageSet = string.sub(BossIcon[i],5,sPos-1);
				local IconIamge = string.sub(BossIcon[i],sPos+7)
				if nil ~= IconImageSet and nil ~= IconIamge then
					SweepPage_BossIcon[i]:SetImage(IconImageSet,IconIamge)
				end
		end
		
		if i < KillBossIndex then
			if KillBossIndex == i + 1 and InSeckill == 1 and SweepPage_curPassIndex ~= KillBossIndex then
				SweepPage_BossingAnimate[i]:Show()
				SweepPage_BossingAnimate[i]:SetToolTip("#{FBSD_150126_30}")
				SweepPage_BossDieIcon[i]:Hide()
				SeeepPage_Timer[i]:SetProperty("Timer", "1.8");
			else
				SweepPage_BossingAnimate[i]:Hide()
				SweepPage_BossDieIcon[i]:Show()
				SweepPage_BossDieIcon[i]:SetToolTip("#{FBSD_150126_30}")
			end
			
			SweepPage_BossButton[i]:Hide()
		elseif i == KillBossIndex then
			SweepPage_BossDieIcon[i]:Hide()
			SweepPage_BossButton[i]:Show()
			SweepPage_BossButton[i]:Enable()
			SweepPage_BossButton[i]:SetToolTip("#{FBSD_150126_29}")
			SweepPage_BossButton[i]:PlayWarning(1)
			SweepPage_BossingAnimate[i]:Hide()
			local strTemp = ScriptGlobal_Format("#{FBSD_150126_81}",BossName[i])
			SweepPage_Explain1:SetText(strTemp)
		else
			SweepPage_BossDieIcon[i]:Hide()
			SweepPage_BossButton[i]:Hide()
			SweepPage_BossIcon[i]:SetToolTip("#{FBSD_150126_28}")
			SweepPage_BossingAnimate[i]:Hide()
		end
	end
	
	for i = BossMaxNum + 1, SweepPage_MaxBoss do
		SweepPage_BossIcon[i]:Hide()
		SweepPage_BossName[i]:Hide()
	end
	
	if SweepPage_CheckButton[SweepPage_open_fubenId-1] == 1 then
		SweepPage_DoubleCheck:SetCheck(1)
	else
		SweepPage_DoubleCheck:SetCheck(0)
	end
	
	if SweepPage_GiveUpCheckButton == 1 then
		SweepPage_AbandonCheckButton:SetCheck(1)
	else
		SweepPage_AbandonCheckButton:SetCheck(0)
	end
	
	if CanDoubleExp == 1 then
		SweepPage_DoubleCheck:Show()
		SweepPage_DoubleText1:Show()
		SweepPage_DoubleText2:Show()
	else
		SweepPage_DoubleCheck:Hide()
		SweepPage_DoubleText1:Hide()
		SweepPage_DoubleText2:Hide()
	end
	
	if InSeckill == 1 or isInSecKill == 1 then
		SweepPage_DoubleCheck:Disable()
	else
		SweepPage_DoubleCheck:Enable()
	end
end

function SweepPage_OnBossButton(index)
	if SecKillItemListEmpty() ~=1 then
		PushDebugMessage("#{FBSD_150126_47}")
		return
	end
	
	local IconName,FubenName,needLevel,moneyLevel,SecKillNum,SecKillMaxNum,SecKillNeedNum,CanDoubleExp, numYuanbao = GetSecKillInfoByIndex(SweepPage_open_fubenId)
	local itemID, itemNum = LuaFnGetSecKillInfoByIndexEx(SweepPage_open_fubenId-1, "Item")
	if nil == itemID or nil == itemNum then
		return
	end
	local itemcount = PlayerPackage:CountAvailableItemByIDTable(itemID)
	-- PushDebugMessage(itemcount.." "..itemNum.." "..numYuanbao)
	local isInSecKill,FubenIdx,BossIndex,DoubleExp,MoneySweep = GetSecKillData()	
	if isInSecKill == 1 then
		if FubenIdx ~= (SweepPage_open_fubenId-1) then
			PushDebugMessage("#{FBSD_150126_70}")
			return
		end
		
	else
		if index ~= 1 then
			PushDebugMessage("#{FBSD_150126_49}")
			return
		end
		
		if SweepPage_SpecialSweep ~= 1 and  SweepPage_SpecialSweep ~= 2 and SweepPage_SpecialSweep ~= 3 then
			--普通扫荡判断点数
			
			if SecKillNum < SecKillNeedNum then
				
				PushDebugMessage("#{FBSD_150126_52}")
				return
			end
		end
	end
	

	if SweepPage_DoubleCheck:GetCheck() == 1 and index == 1 and CanDoubleExp == 1 and isInSecKill == 0 then
		if itemID > 0 and itemNum > 0 and itemcount >= itemNum then
			PushEvent( "DOUBLE_SECKILL_CONFIRM",index, 0, numYuanbao, itemID, itemNum,SweepPage_SpecialSweep )
		else
			PushEvent( "DOUBLE_SECKILL_CONFIRM",index, 1, numYuanbao, 0, 0,SweepPage_SpecialSweep )
		end
	else
		SweepPage_SendSecKill(index, 1,SweepPage_SpecialSweep)
	end

	
	SweepPage_curPassIndex = index
end


function SweepPage_SendSecKill(index, isYuanBao,isSpecialSweep) 
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnFuBenSecKill");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,SweepPage_DoubleCheck:GetCheck());
		Set_XSCRIPT_Parameter(3,isYuanBao)
		Set_XSCRIPT_Parameter(4,isSpecialSweep)
		Set_XSCRIPT_ParamCount(5);
	Send_XSCRIPT();
	
	SweepPage_BossButton[index]:Disable()
end

function SweepPage_OnOkClicked()
	SecKillRemoveItem()
end

function SweepPage_OnCheckClick()	
	if (SweepPage_open_fubenId-1) >= 0  and (SweepPage_open_fubenId-1) < table.getn(SweepPage_CheckButton) then
		if SweepPage_CheckButton[SweepPage_open_fubenId-1] == 1 then
			SweepPage_CheckButton[SweepPage_open_fubenId-1] = 0
		else
			SweepPage_CheckButton[SweepPage_open_fubenId-1] = 1
		end
	end
end

function SweepPage_OnGiveUpCheckClick()
	if SweepPage_GiveUpCheckButton == 1 then
		SweepPage_GiveUpCheckButton = 0
	else
		SweepPage_GiveUpCheckButton = 1
	end
end

function SweepPage_OnTimer(index)
	SweepPage_BossingAnimate[index]:Hide()
	SweepPage_BossDieIcon[index]:Show()
	SweepPage_BossDieIcon[index]:SetToolTip("#{FBSD_150126_30}")
	SeeepPage_Timer[index]:SetProperty("Timer", "-1")
end	

function SweepPage_OnGotoSweepAll()
	-- 打开UI
	OpenSecKillList();
end

function SweepPage_OnGiveUp()
	if SecKillItemListEmpty() ==1 then
		return
	end
	
	if SweepPage_GiveUpCheckButton == 1  then
		PushEvent( "SECKILL_GIVEUP_CONFIRM" )
	else
		SecKillGiveUpItem()
	end
end

function SweepPage_OnContinue()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnContinueFuBenSecKill");
		Set_XSCRIPT_ScriptID(891062);
		Set_XSCRIPT_Parameter(0,SweepPage_open_fubenId);
		Set_XSCRIPT_Parameter(1,SweepPage_SpecialSweep);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function SweepPage_UpdateSeckillNum()
	local SecKillFubenCount = GetSecKillFuBenCount()
	for i = 0, SecKillFubenCount - 1 do
		local Id, IconName,FubenName,needLevel,moneyLevel,SecKillNum,SecKillMaxNum,SecKillNeedNum,CanDoubleExp, numYuanbao, numMoney, ActionID = EnumSecKillTable(i)
	
		local Number = ActionID
		local Micount = Number - GetCampaignCountNum( Id )
		
		if Micount < 0 then
			Micount = 0
		end
			
		SweepPage_FuBenSecKillNum[Id-1] = {Micount, Number};
	end
end

function SweepPage_Button_Clicked(index)
	PushEvent("OPEN_SWEEPPAGE_QUEST", "SweepPage")
end

