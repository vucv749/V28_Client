-- 界面的默认相对位置
local g_SweepAll_Frame_UnifiedXPosition;
local g_SweepAll_Frame_UnifiedYPosition;

local g_nContentButton = {}

--按牋扫荡等级进行排序
local g_SweepAll_Index = {}

local g_SweepAll_MonthCardMF= 752
local g_SweepAll_DayCardMF= 753
local g_SweepAll_SeckillTequanData= 813--????????
local g_SweepAll_SeckillTequanDayCount = 943 --???????? MD? MD_TQSD_DAYCOUNT=943        --????????,?? 11 22 3

function SweepAll_PreLoad()
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false);

	this:RegisterEvent("SHOW_SECKILL_LIST")
	this:RegisterEvent("OPEN_SECKILL_LIST")
	this:RegisterEvent("UI_COMMAND")
end

function SweepAll_OnLoad()
	g_SweepAll_Frame_UnifiedXPosition	= SweepAll_Frame : GetProperty("UnifiedXPosition");
	g_SweepAll_Frame_UnifiedYPosition	= SweepAll_Frame : GetProperty("UnifiedYPosition");
end

-- OnEvent
function SweepAll_OnEvent(event)
	if (event == "OPEN_SECKILL_LIST" ) then
		if not this:IsVisible() then
			SendSecKillDataMsg()
		end

	elseif(event == "SHOW_SECKILL_LIST" ) then
		if not this:IsVisible() then
			this:Show()
			SweepAll_On_Open()
		end
	elseif (event == "UI_COMMAND" ) then
		--PushDebugMessage(tonumber(arg0))
		if tonumber(arg0) == 89106202 then
			if not this:IsVisible() then
				-- this:Show()
				-- SweepAll_On_Open()
			else
				--关睜激活窗口
				if IsWindowShow("SweepAll_Activate") then
					CloseWindow("SweepAll_Activate", true)
				end
				--刷新
				SweepAll_On_Open()
			end
		end
	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		SweepAll_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		SweepAll_Frame_On_ResetPos()
	elseif ( event == "HIDE_ON_SCENE_TRANSED" ) then
		SweepAll_OnClosed()
	end
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function SweepAll_Frame_On_ResetPos()
	SweepAll_Frame : SetProperty("UnifiedXPosition", g_SweepAll_Frame_UnifiedXPosition);
	SweepAll_Frame : SetProperty("UnifiedYPosition", g_SweepAll_Frame_UnifiedYPosition);
end

--=================================================
--打开扫荡界面
--==================================================
function SweepAll_On_Open()
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep,TeQuanSweep,CheckHuodongTime = GetSecKillData()
	local SecKillFubenCount = GetSecKillFuBenCount()

	SweepAll_ActivateBtn:Hide()

	SweepAll_List:CleanAllElement("SweepAll")
	--特权扫荡剩余时间、特权扫荡激活按钮
	if DataPool:LuaFnGetMF(g_SweepAll_DayCardMF)==1 then 
		SweepAll_ActivateText:SetText("#{TQJF_221108_03}")
	elseif DataPool:LuaFnGetMF(g_SweepAll_MonthCardMF)==1 then 
		local nCurrentDataTime = DataPool:LuaFnGetMD(g_SweepAll_SeckillTequanData)
		
		local subTime = tonumber(Lua_GetCurrentDataTime(nCurrentDataTime))

		local strTemp = ""
		if subTime < 0 then
			strTemp = ScriptGlobal_Format("#{TQJF_221108_02}",0)
			SweepAll_ActivateText:SetText(strTemp)
		else
			local daytime = subTime
			daytime = 30 - daytime

			if daytime == 1 then
				SweepAll_ActivateText:SetText("#{TQJF_221108_03}")
			else
				strTemp = ScriptGlobal_Format("#{TQJF_221108_02}",daytime)
				SweepAll_ActivateText:SetText(strTemp)
			end
		end
		
	else 
		SweepAll_ActivateText:SetText("#{TQJF_221108_01}")
		SweepAll_ActivateBtn:Show()
	end
        SweepAll_ActivateText:SetText()
	

	local tqmfmonth = DataPool:LuaFnGetMF(g_SweepAll_MonthCardMF)
	local tqmfday = DataPool:LuaFnGetMF(g_SweepAll_DayCardMF)
	g_nContentButton = {}
	--显示特权扫荡次数 begin
	if tqmfmonth == 1 or tqmfday == 1 then
		local tqsdMD = DataPool:LuaFnGetMD(g_SweepAll_SeckillTequanDayCount)
		if tqsdMD <= 0 then
			local strTemp = ScriptGlobal_Format("#{TQJF_230425_01}","0/2")
			SweepAll_ActivateText2:SetText(strTemp)
		else
			local alreadyCount = math.mod(tqsdMD,10)
			local str1 = tostring(alreadyCount) .. "/2"
			local strTemp = ScriptGlobal_Format("#{TQJF_230425_01}",str1)
			SweepAll_ActivateText2:SetText(strTemp)
		end
		SweepAll_ActivateText2:Show()
	else
		SweepAll_ActivateText2:Hide()
	end
	--显示特权扫荡次数 end

	for i = 1, SecKillFubenCount do
		
		local tepCntButton = {
		}
		local Id, IconName,FubenName,needLevel,moneyLevel,SecKillNum,SecKillMaxNum,SecKillNeedNum,CanDoubleExp, numYuanbao, numMoney, ActionID, n1week, n2week, n3week,n4week,nPrivilegedExclusive,isCanYinbi,costYinbi = EnumSecKillTable(i-1)

		--PushDebugMessage(Id)
		local nweekDay = tonumber(DataPool:GetServerWeekDayTime())
		local tequan = 0
		if (nweekDay == n1week ) or ( nweekDay == n2week ) or ( nweekDay == n3week ) or ( nweekDay == n4week )  then
			tequan = 1
		else
			tequan = 0
		end

	    tepCntButton.Id = Id
		tepCntButton.IconName = IconName
		tepCntButton.FubenName = FubenName
		tepCntButton.needLevel = needLevel
		tepCntButton.moneyLevel = moneyLevel
		tepCntButton.SecKillNum = SecKillNum
		tepCntButton.SecKillMaxNum = SecKillMaxNum
		tepCntButton.SecKillNeedNum = SecKillNeedNum
		tepCntButton.CanDoubleExp = CanDoubleExp
		tepCntButton.numYuanbao = numYuanbao
		tepCntButton.numMoney = numMoney
		tepCntButton.ActionID = ActionID
		tepCntButton.n1week = n1week
		tepCntButton.n2week = n2week
		tepCntButton.n3week = n3week
		tepCntButton.n4week = n4week
		tepCntButton.nPrivilegedExclusive = nPrivilegedExclusive
		tepCntButton.tequan = tequan
		tepCntButton.isCanYinbi = isCanYinbi
		tepCntButton.costYinbi = costYinbi

		

		table.insert(g_nContentButton,tepCntButton)
	end

	table.sort(g_nContentButton,SweepAll_SortID)

	for i = 1, table.getn(g_nContentButton) do
		
		local Id = g_nContentButton[i].Id
		local IconName = g_nContentButton[i].IconName
		local FubenName = g_nContentButton[i].FubenName
		local needLevel = g_nContentButton[i].needLevel
		local moneyLevel = g_nContentButton[i].moneyLevel
		local SecKillNum = g_nContentButton[i].SecKillNum
		local SecKillMaxNum = g_nContentButton[i].SecKillMaxNum
		local SecKillNeedNum = g_nContentButton[i].SecKillNeedNum
		local CanDoubleExp = g_nContentButton[i].CanDoubleExp
		local numYuanbao = g_nContentButton[i].numYuanbao
		local numMoney = g_nContentButton[i].numMoney
		local ActionID = g_nContentButton[i].ActionID
		local n1week = g_nContentButton[i].n1week
		local n2week = g_nContentButton[i].n2week
		local n3week = g_nContentButton[i].n3week
		local n4week = g_nContentButton[i].n4week
		local nPrivilegedExclusive = g_nContentButton[i].nPrivilegedExclusive
		local tequan = g_nContentButton[i].tequan
		local isCanYinbi = g_nContentButton[i].isCanYinbi
		local costYinbi = g_nContentButton[i].costYinbi


		local ItemBar = SweepAll_List:AddItemElement( "SweepButton", "LEFT", "SweepAll","" ,"")
		ItemBar:SetProperty("SuperBarButtonHover","SuperBarHoverSection")

		--set:hdrc_02 image:hdrc_02_chuju
		if IconName ~= nil and IconName ~= "" then
			local sPos,_ = string.find(IconName," ");
			local IconImageSet = string.sub(IconName,5,sPos-1);
			local IconIamge = string.sub(IconName,sPos+7)
			if nil ~= IconImageSet and nil ~= IconIamge then
				ItemBar:SetImage1(IconImageSet,IconIamge)
				ItemBar:SetImage1Show()
			end
		end


		ItemBar:SetImage2Hide()

		ItemBar:SetText1( "#G"..FubenName )
		ItemBar:SetText2( "#G"..needLevel )
		if SecKillNum < SecKillNeedNum then
			ItemBar:SetText3( "#cff0000"..tostring(SecKillNum).."/"..tostring(SecKillMaxNum) )
			ItemBar:SetButton3Tips("#{TQJF_221108_09}")
		else
			ItemBar:SetText3( "#G"..tostring(SecKillNum).."/"..tostring(SecKillMaxNum) )
		end
		ItemBar:SetText4( "#G"..tostring(SecKillNeedNum) )

		local Number = ActionID
		local Micount = Number - GetCampaignCountNum( Id )

		if Micount < 0 then
			Micount = 0
		end
			
		if Micount == 0 then
			ItemBar:SetButton3State(false)
			ItemBar:SetText5( "#cff0000"..tostring(Micount).."/"..tostring(Number) )
		else
			ItemBar:SetText5( "#G"..tostring(Micount).."/"..tostring(Number) )
			ItemBar:SetButton3State(true)
		end

		ItemBar:SetText6("")
		ItemBar:SetCheckButton1Hide()

		ItemBar:SetButton1Show()
		--ItemBar:SetButton1Text("#{FBSD_150126_66}")
		ItemBar:SetButton1Tips("#{FBSD_150126_19}")
		
		--判断是否可以金币扫荡
		if moneyLevel < 1 or  numMoney < 1 then
			ItemBar:SetButton2Hide()
		else
			ItemBar:SetButton2Show()
			--ItemBar:SetButton2Text("#{JBSD_220210_63}")
		end
		--判断是否可以银币扫荡，可以银币扫荡的话金币扫荡按钮就要隐藏
		if  moneyLevel < 1 or isCanYinbi < 1 or costYinbi < 1 then--??????????,????????????
			ItemBar:SetButton5Hide()
		else
			ItemBar:SetButton5Show()
			ItemBar:SetButton2Hide()
		end

		if ( tequan == 1 ) then
			ItemBar:SetImageTe("Tequansaodang","LZBZ")
			ItemBar:SetImageTeShow()

			if tqmfmonth == 1 or tqmfday == 1 then
				ItemBar:SetButton3Show()
			else
				ItemBar:SetButton3Hide()
			end
		    --ItemBar:SetButton3Text("特")
		else
			ItemBar:SetImageTeHide()

			ItemBar:SetButton3Hide()
		end		

		g_nContentButton[i].ItemBar = ItemBar
	end
	

	local FubenID = fubenidx + 1
	local nButtonIndex = SweepAll_SecKillGetIndex(FubenID)
	
	if isInSecKill == 1 and nButtonIndex ~= -1 and nButtonIndex <= table.getn(g_nContentButton) then
		if DoubleExp == 1 then
                    g_nContentButton[nButtonIndex].ItemBar:SetButton4Tips("#{TQJF_221108_12}")
		else
                    g_nContentButton[nButtonIndex].ItemBar:SetButton4Tips("#{TQJF_221108_10}")
		end
		--隐藏茽通、金币、特权、银币扫荡按钮，显示扫荡中按钮
		g_nContentButton[nButtonIndex].ItemBar:SetButton4Show()
		g_nContentButton[nButtonIndex].ItemBar:SetButton3Hide()
		g_nContentButton[nButtonIndex].ItemBar:SetButton2Hide()
		g_nContentButton[nButtonIndex].ItemBar:SetButton1Hide()
		g_nContentButton[nButtonIndex].ItemBar:SetButton5Hide()
		local IconName,FubenName,needLevel,moneyLevel,SecKillNum,SecKillMaxNum,SecKillNeedNum,CanDoubleExp, numYuanbao, numMoney = GetSecKillInfoByIndex(FubenID)
		local strTemp = ScriptGlobal_Format("#{FBSD_150126_73}",FubenName)
		if CheckHuodongTime > 0 then
			strTemp = strTemp .. "#{SBDL_20230315_4}"
		end

		SweepAll_Explain1:SetText(strTemp)
	else
                local strExplain = "#{FBSD_200805_02}".."#{SBDL_20230315_4}"
		if CheckHuodongTime > 0 then
			SweepAll_Explain1:SetText(strExplain)
		else
			SweepAll_Explain1:SetText("#{FBSD_150126_72}")
		end
	end

	SweepAll_List:Flash()
end

--点击扫荡按钮
function SweepAll_OnButtonClick()
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep, TeQuanSweep,CheckHuodongTime,Jinbidaibi,YinBiSweep,YinbiDaibi = GetSecKillData()
	
	if isInSecKill > 0 and ( MoneySweep == 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1) then--???????
		PushDebugMessage("#{JBSD_220210_67}")
		return
	end
	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep == 1 and YinBiSweep ~= 1) then--???????
		PushDebugMessage("#{TQJF_221108_35}")
		return
	end
	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep == 1) then--???????
		PushDebugMessage("#{YBSD_231107_16}")
		return
	end
	
	local sPos,ePos = string.find(arg0, "_auto_element")
	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	local FubenId = SweepAll_SecKillGetFubenID(nIndex+1)
	
	if FubenId ~= -1 then
		--第二个参数  是否是金币扫荡
		OpenSecKillPage(FubenId,0)
	end
end


--点击金币扫荡按钮
function SweepAll_OnMoneyButtonClick()
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep, TeQuanSweep,CheckHuodongTime,Jinbidaibi,YinBiSweep,YinbiDaibi = GetSecKillData()

	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1 ) then--???????
		PushDebugMessage("#{JBSD_220210_66}")
		return
	end
	if isInSecKill > 0 and (  TeQuanSweep == 1 ) then--???????
		PushDebugMessage("#{TQJF_221108_38}")
		return
	end
	if isInSecKill > 0 and (  YinBiSweep == 1 ) then--???????
		PushDebugMessage("#{YBSD_231107_16}")
		return
	end
	
	local sPos,ePos = string.find(arg0, "_auto_element")
	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	local FubenId = SweepAll_SecKillGetFubenID(nIndex+1)

	if FubenId ~= -1 then
		--第二个参数  是否是金币扫荡
		OpenSecKillPage(FubenId,1)
	end
end

--点击特权扫荡按钮
function SweepAll_OnPrivilegeButtonClick()
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep, TeQuanSweep,CheckHuodongTime,Jinbidaibi,YinBiSweep,YinbiDaibi = GetSecKillData()

	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1)  then--???????
		PushDebugMessage("#{TQJF_221108_36}")
		return
	end
	if isInSecKill > 0 and ( MoneySweep == 1 )  then--???????
		PushDebugMessage("#{TQJF_221108_37}")
		return
	end
	if isInSecKill > 0 and ( YinBiSweep == 1 )  then--???????
		PushDebugMessage("#{YBSD_231107_16}")
		return
	end

	local sPos,ePos = string.find(arg0, "_auto_element")
	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	local FubenId = SweepAll_SecKillGetFubenID(nIndex+1)
	local PrivilegedExclusiveFlag = SweepAll_SecKillGetPrivilegedExclusive(nIndex + 1)
	--判断MD中是否已经记录了两个互斥标记 begin 其实犫里直接判断是否进行了两次特权扫荡就行
	local dayCount = DataPool:LuaFnGetMD(g_SweepAll_SeckillTequanDayCount)
	--PushDebugMessage(tostring(dayCount))--测试
	local alreadyCount = math.mod(dayCount,10)
	local firstFlag = 0
	local secondFlag = 0
	if (dayCount - alreadyCount)>0 then
		dayCount = (dayCount - alreadyCount)/10
		firstFlag = math.mod(dayCount,100)
	end
	if (dayCount - firstFlag)>0 then
		secondFlag = (dayCount - firstFlag)/100
	end
	--PushDebugMessage(tostring(PrivilegedExclusiveFlag)..","..tostring(firstFlag)..","..tostring(secondFlag))--测试
	if firstFlag>0 and secondFlag>0 and PrivilegedExclusiveFlag~=firstFlag and PrivilegedExclusiveFlag~=secondFlag then
		PushDebugMessage("#{TQJF_230425_03}")
		return
	end
	if PrivilegedExclusiveFlag~=firstFlag and PrivilegedExclusiveFlag~=secondFlag and alreadyCount == 2 then--???????? ?????????????? ?? ???????????
		PushDebugMessage("#{TQJF_230425_03}")
		return
	end
	--判断MD中是否已经记录了两个互斥标记 end
	if FubenId ~= -1 then
		--第二个参数  是特权扫荡
		OpenSecKillPage(FubenId,2)
	end
end

--点击银币扫荡按钮
function SweepAll_OnSilverMoneyButtonClick()
	--PushDebugMessage("银币扫荡")
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep, TeQuanSweep,CheckHuodongTime,Jinbidaibi,YinBiSweep,YinbiDaibi = GetSecKillData()

	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1) then--??????
		PushDebugMessage("#{YBSD_231107_13}")
		return
	end
	if isInSecKill > 0 and ( MoneySweep == 1 ) then--??????
		PushDebugMessage("#{YBSD_231107_13}")
		return
	end
	if isInSecKill > 0 and ( TeQuanSweep == 1 ) then--??????
		PushDebugMessage("#{YBSD_231107_13}")
		return
	end
	local sPos,ePos = string.find(arg0, "_auto_element")
	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	local FubenId = SweepAll_SecKillGetFubenID(nIndex+1)

	if FubenId ~= -1 then
		--第二个参数  是否是银币扫荡 0茽通 1金币 2特权 3银币
		OpenSecKillPage(FubenId,3)
	end
end

function SweepAll_OnCheckClick()
end

function SweepAll_OnClosed()
	this:Hide();
	--特权激活界面也关了
	if IsWindowShow("SweepAll_Activate") then
		CloseWindow("SweepAll_Activate", true)
	end

end

function SweepAll_OnItemClick()
	local sPos,ePos = string.find(arg0, "_auto_element")
	local nIndex = tonumber(string.sub(arg0, ePos + 1, -1))

	if nIndex >= 0 then
		SweepAll_SetButtonSelected(nIndex + 1)
		SweepAll_List:Flash()
	end
end

function SweepAll_SetButtonSelected(nIndex)
	for nButtonIndex = 1,table.getn(g_nContentButton) do
		if nil ~= g_nContentButton[nButtonIndex].ItemBar then
			if nButtonIndex ~= nIndex then
				g_nContentButton[nButtonIndex].ItemBar:SetBarButtonSelected(false)
			else
				g_nContentButton[nButtonIndex].ItemBar:SetBarButtonSelected(true)
			end
		end
	end
end



function SweepAll_HelpClicked()
	PushEvent("OPEN_SWEEPPAGE_QUEST", "SweepAll_ExplainHelp") 
end
function SweepAll_SortID(a,b)

	local tqmfmonth = DataPool:LuaFnGetMF(g_SweepAll_MonthCardMF)
	local tqmfday = DataPool:LuaFnGetMF(g_SweepAll_DayCardMF)

	if tqmfmonth == 1 or tqmfday == 1 then
		if a.tequan == 0 and b.tequan == 1 then
			return false	
		elseif a.tequan == 1 and b.tequan == 0 then
			return true
		end
	end

	if a.Id > b.Id then
		return false	
	elseif a.Id < b.Id then
		return true
	end
	
	return false	
end

function SweepAll_SecKillGetIndex(FubenID)
	for nButtonIndex = 1,table.getn(g_nContentButton) do
		if FubenID == g_nContentButton[nButtonIndex].Id then
            return nButtonIndex
		end
	end
	return -1
end

function SweepAll_SecKillGetFubenID(index)
	return  g_nContentButton[index].Id 
end

function SweepAll_SecKillGetPrivilegedExclusive(index)
	return  g_nContentButton[index].nPrivilegedExclusive 
end

function SweepAll_ActivateBtn_Clicked()
	if Player:GetLevel() < 60 then
		PushDebugMessage("#{TQJF_221108_05}")
		return
	end

	Clear_XSCRIPT()
	Set_XSCRIPT_Function_Name("OpenTeQuan")
	Set_XSCRIPT_ScriptID(891062)
	Set_XSCRIPT_Parameter(0,0);  --open
	Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()	

end

--点击扫荡中...
function SweepAll_OnSweepButtonClick()
	local isInSecKill,fubenidx,BossIndex,DoubleExp ,MoneySweep, TeQuanSweep,CheckHuodongTime,Jinbidaibi,YinBiSweep,YinbiDaibi = GetSecKillData()
	--PushDebugMessage("isInSecKill="..isInSecKill.." MoneySweep="..MoneySweep)
	
	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1)  then--?????
		SweepAll_OnButtonClick()
		return
	end
	
	if isInSecKill > 0 and ( MoneySweep == 1 and TeQuanSweep ~= 1 and YinBiSweep ~= 1)  then--?????
		SweepAll_OnMoneyButtonClick()
		return
	end

	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep == 1 and YinBiSweep ~= 1)  then--?????
		SweepAll_OnPrivilegeButtonClick()
		return
	end

	if isInSecKill > 0 and ( MoneySweep ~= 1 and TeQuanSweep ~= 1 and YinBiSweep == 1)  then--?????
		SweepAll_OnSilverMoneyButtonClick()
		return
	end
	
	PushDebugMessage("B阯 trong sai l")

end








