--版本7葼登陆礼包 通用
--修改：改奖励内容

--!!!reloadscript =FeelFeedBack800
local g_FeelFeedBack800_Frame_UnifiedPosition;
local g_resetflag = 0
local g_FeelFeedBack800_7DayShowTimes =0;
local g_FeelFeedBack800_7DayButtom ={};
local g_FeelFeedBack800_MD_Date = 0
local g_FeelFeedBack800_MF_Date = 0
local g_FeelFeedBack800_MD_LastDay = 0
local g_FeelFeedBack800_RedPoint_1 = 0
local g_FeelFeedBack800_RedPoint_2 = 0
local g_FeelFeedBack800_PrizeList =
{
	[1] ={
			[1]={ItemID = 38002780, num = 1, needbind =1,},		-- ??????(??3?1,15?)
			[2]={ItemID = 30501361, num = 3, needbind =1,},		-- ??? 
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????	 
			},
	[2] ={
			[1]={ItemID = 30900045, num = 1, needbind =1,},		-- ?????	
			[2]={ItemID = 30502002, num = 3, needbind =1,},		-- ?????	
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100???? 	
			},
	[3] ={
			[1]={ItemID = 38002779, num = 1, needbind =1,},		-- ?????(??4?1)
			[2]={ItemID = 30008115, num = 5, needbind =1,},		-- ???? *5
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????	 
			},
	[4] ={
			[1]={ItemID = 38002519, num = 2, needbind =1,},		-- ????*2
			[2]={ItemID = 30503133, num = 3, needbind =1,},		-- ????
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????
			},
	[5] ={
			[1]={ItemID = 20310168, num = 20,needbind =1,},		-- ???	20	 	
			[2]={ItemID = 38002530, num = 5, needbind =1,},		-- ??????*5
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????
			},
	[6] ={
			[1]={ItemID = 20502003, num = 1, needbind =1,},		-- 3???
			[2]={ItemID = 38002524, num = 3, needbind =1,},		-- ????*3
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????
			},
	[7] ={
			[1]={ItemID = 50313004, num = 1, needbind =1,},		-- ???3?	
			[2]={ItemID = 20501003, num = 1, needbind =1,},		-- 3???	
			[3]={ItemID = 38000060, num = 1, needbind =1,},		-- 100????
			},
}
local g_FeelFeedBack800_PrizeButton = {}
local g_FeelFeedBack800_Click = -1

local g_FeelFeedBack800_7DayImage = {
	[1] ={
				[1]="set:FeelFeedBack1 image:FeelFeedBack_Image1",			--FeelFeedBack400_Left_image ????
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num1",				--FeelFeedBack400_Right_imageDay ?????
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D1",			--FeelFeedBack400_Right_imageDayItem ????
				[4]="set:Seven image:Seven_day2",
				},
	[2] ={
				[1]="set:FeelFeedBack1 image:FeelFeedBack_Image2",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num2",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D2",
				[4]="set:Seven image:Seven_day2",				
				},
	[3] ={
				[1]="set:FeelFeedBack1 image:FeelFeedBack_Image3",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num3",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D3",
				[4]="set:Seven image:Seven_day3",				
				},
	[4] ={
				[1]="set:FeelFeedBack1 image:FeelFeedBack_Image4",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num4",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D6",
				[4]="set:Seven image:Seven_day4",				
				},
	[5] ={
				[1]="set:FeelFeedBack2 image:FeelFeedBack_Image5",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num5",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D5",
				[4]="set:Seven image:Seven_day5",				
				},
	[6] ={
				[1]="set:FeelFeedBack2 image:FeelFeedBack_Image6",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num6",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D4",
				[4]="set:Seven image:Seven_day6",				
				},
	[7] ={
				[1]="set:FeelFeedBack2 image:FeelFeedBack_Image7",
				[2]="set:FeelFeedBack1 image:FeelFeedBack_Num7",
				[3]="set:FeelFeedBack1 image:FeelFeedBack_D7",
				[4]="set:Seven image:Seven_day7",				
				},
}

--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack800_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- ????
	this:RegisterEvent("ADJEST_UI_POS",false)			-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- ??????????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????

end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack800_OnEvent(event)
	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack800_Close()
	elseif (event == "ADJEST_UI_POS") then
		FeelFeedBack800_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		FeelFeedBack800_On_ResetPos()
	--2023周活跃奖励放出 by ypl
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99826301 then
		-- local nOperate = Get_XParam_INT(0)
		-- local Award_RedPoint = Get_XParam_INT(2)
		-- FeelFeedBack800_Text:SetText("#{QRDL_20211229_17}")
		-- --刷新
		-- if nOperate == 1 then
			-- if this:IsVisible() then
				-- if Award_RedPoint == 1 then
					-- FeelFeedBack800_Index1_Tips:Show()
				-- else
					-- FeelFeedBack800_Index1_Tips:Hide()
				-- end
			-- end	
		-- end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 79201201 then
		g_FeelFeedBack800_RedPoint_1 = Get_XParam_INT(2)
		g_FeelFeedBack800_RedPoint_2 = Get_XParam_INT(3)
		if this:IsVisible() then
			FeelFeedBack800_Text:SetText("#{QRDL_20211229_17}")
			if g_FeelFeedBack800_RedPoint_1 == 1 then
				FeelFeedBack800_Index0_Tips:Show()
			else
				FeelFeedBack800_Index0_Tips	:Hide()
			end
			if g_FeelFeedBack800_RedPoint_2 == 1 then
				FeelFeedBack800_Index1_Tips:Show()
			else
				FeelFeedBack800_Index1_Tips	:Hide()
			end
					
			--FeelFeedBack800_Index0:SetCheck(1)
			--FeelFeedBack800_Index1:SetCheck(0)
			FeelFeedBack800_Index0:Hide()
			FeelFeedBack800_Index1:Hide()
		end
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 79201202 ) then
		local bShow =  Get_XParam_INT( 0 );
		FeelFeedBack800_Text:SetText("#{QRDL_20211229_17}")
		--2023周活跃奖励放出 by ypl
		-- if(IsWindowShow("ZhouHuoYue_Award")) then
			-- CloseWindow("ZhouHuoYue_Award", true)
		-- end		
		-- local selfUnionPos = Variable:GetVariable("ZhouHuoYue");
		-- if(selfUnionPos ~= nil) then
			-- FeelFeedBack800_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		-- end			

		--FeelFeedBack800_Index0:SetCheck(1)
		--FeelFeedBack800_Index1:SetCheck(0)
		FeelFeedBack800_Index0:Hide()
		FeelFeedBack800_Index1:Hide()
		if bShow == 1 then
			g_FeelFeedBack800_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack800_MF_Date =  Get_XParam_INT( 2 );
			g_FeelFeedBack800_MD_LastDay = Get_XParam_INT( 3 );
			g_FeelFeedBack800_RedPoint_1 = Get_XParam_INT( 4 )		--??????
			g_FeelFeedBack800_RedPoint_2 = Get_XParam_INT( 5 )  	-- ???????
			FeelFeedBack800_7Day_Update()
			local nMDLast = math.mod(g_FeelFeedBack800_MD_LastDay,10000)
			local nMDMonth = math.floor(nMDLast/100)
			local nMDMDay = math.mod(nMDLast,100)
			FeelFeedBack800_Text2:SetText( ScriptGlobal_Format("#{QRDL_20211229_18}",nMDMonth,nMDMDay) )
			this:Show()
		elseif this:IsVisible() then
			g_FeelFeedBack800_MD_Date =  Get_XParam_INT( 1 );
			g_FeelFeedBack800_MF_Date =  Get_XParam_INT( 2 );
			g_FeelFeedBack800_RedPoint_1 = Get_XParam_INT( 3 )		--??????
			g_FeelFeedBack800_RedPoint_2 = Get_XParam_INT( 4 )  	-- ???????
			FeelFeedBack800_7Day_Update()
		end	
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		FeelFeedBack800_Close()
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 79201203 ) then
		--是否打开了我们的犫个界面 for开着页面跨天
		if(IsWindowShow("FeelFeedBack800")) then
			Variable:SetVariable("ZhouHuoYue", FeelFeedBack800_Frame:GetProperty("UnifiedPosition"), 1);
			g_resetflag = 1
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnOpenMainWindow");
				Set_XSCRIPT_ScriptID(792012);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();	
		end	
	end
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack800_OnLoad()
	g_FeelFeedBack800_Frame_UnifiedPosition = FeelFeedBack800_Frame:GetProperty("UnifiedPosition")

	g_FeelFeedBack800_7DayButtom[1] ={Button =FeelFeedBack800_Top_day1_Button1 , Done = FeelFeedBack800_Top_day1_done };
	g_FeelFeedBack800_7DayButtom[2] ={Button =FeelFeedBack800_Top_day2_Button1 , Done = FeelFeedBack800_Top_day2_done };
	g_FeelFeedBack800_7DayButtom[3] ={Button =FeelFeedBack800_Top_day3_Button1 , Done = FeelFeedBack800_Top_day3_done };
	g_FeelFeedBack800_7DayButtom[4] ={Button =FeelFeedBack800_Top_day4_Button1 , Done = FeelFeedBack800_Top_day4_done };
	g_FeelFeedBack800_7DayButtom[5] ={Button =FeelFeedBack800_Top_day5_Button1 , Done = FeelFeedBack800_Top_day5_done };
	g_FeelFeedBack800_7DayButtom[6] ={Button =FeelFeedBack800_Top_day6_Button1 , Done = FeelFeedBack800_Top_day6_done };
	g_FeelFeedBack800_7DayButtom[7] ={Button =FeelFeedBack800_Top_day7_Button1 , Done = FeelFeedBack800_Top_day7_done };

	g_FeelFeedBack800_PrizeButton[1] = FeelFeedBack800_Right_ShowA;
	g_FeelFeedBack800_PrizeButton[2] = FeelFeedBack800_Right_ShowB;
	g_FeelFeedBack800_PrizeButton[3] = FeelFeedBack800_Right_ShowC;
end

--===============================================
-- Hide()
--===============================================
function FeelFeedBack800_Hide() 
	--Variable:SetVariable("ZhouHuoYue", FeelFeedBack800_Frame:GetProperty("UnifiedPosition"), 1);
	FeelFeedBack800_Close()
end

--===============================================
-- Close()
--===============================================
function FeelFeedBack800_Close()
	--Variable:SetVariable("ZhouHuoYue", FeelFeedBack800_Frame:GetProperty("UnifiedPosition"), 1);
	g_FeelFeedBack800_Click = -1
	for i=1,3 do
		g_FeelFeedBack800_PrizeButton[i]:SetActionItem( -1 );
	end
	this:Hide()
end
--===============================================
-- ResetPos()
--===============================================
function FeelFeedBack800_On_ResetPos()
	FeelFeedBack800_Frame:SetProperty("UnifiedPosition", g_FeelFeedBack800_Frame_UnifiedPosition)
end


--===============================================
-- 满月感恩回馈-begin
--===============================================
function FeelFeedBack800_7Day_Update()
	for i=1,7 do
		g_FeelFeedBack800_7DayButtom[i].Done:Hide()
	end
	local nData1 = g_FeelFeedBack800_MD_Date
	local nData2 = g_FeelFeedBack800_MF_Date
	--为了防止10版本优化MD和MF的同步，从server端同步MD
	local nTimes = math.mod(nData1,100)
	for i=1,nTimes do
		g_FeelFeedBack800_7DayButtom[i].Done:Hide()
	end

	local nDate = 1
	for i=1,nTimes do
		if math.mod(nData2,10) == 1 then
			g_FeelFeedBack800_7DayButtom[i].Done:Show()
		end
		nData2 = math.floor(nData2/10)
	end
	
	if g_resetflag == 1 then
		FeelFeedBack800_Click(nTimes)
		g_resetflag = 0 
	else
		if g_FeelFeedBack800_Click == -1 then
			FeelFeedBack800_Click(nTimes)
		else
			FeelFeedBack800_Click(g_FeelFeedBack800_Click)
		end
	end

	--页签上的俩红点
	if g_FeelFeedBack800_RedPoint_1 ~= 0  then
		FeelFeedBack800_Index0_Tips:Show()
	else
		FeelFeedBack800_Index0_Tips:Hide()	
	end
	if g_FeelFeedBack800_RedPoint_2 ~= 0  then
		FeelFeedBack800_Index1_Tips:Show()
	else
		FeelFeedBack800_Index1_Tips:Hide()	
	end
	
end

function FeelFeedBack800_Click(nIndex)

	if nIndex<1 or nIndex>7 then
		return
	end


	FeelFeedBack800_Left_image:SetProperty( "Image", g_FeelFeedBack800_7DayImage[nIndex][1] )
	FeelFeedBack800_Right_imageDay:SetProperty( "Image", g_FeelFeedBack800_7DayImage[nIndex][2] )
	FeelFeedBack800_Right_imageDayItem:SetProperty( "Image", g_FeelFeedBack800_7DayImage[nIndex][3] )
	--FeelFeedBack800_TextBK:SetProperty( "Image", "set:FeelFeedBack1 image:FeelFeedBack_ImageBK1" )
	for i=1, 7 do
		g_FeelFeedBack800_7DayButtom[i].Button:SetCheck(0)
	end

	g_FeelFeedBack800_Click = nIndex

	--显示一下奖励
	for i=1, 3 do
		g_FeelFeedBack800_PrizeButton[i]:SetActionItem( -1 );
	end

	local nCount = table.getn(g_FeelFeedBack800_PrizeList[nIndex])
	for i=1,nCount do
		if 1 == g_FeelFeedBack800_PrizeList[nIndex][i].needbind then
			local theAction = DataPool:CreateBindActionItemForShow(g_FeelFeedBack800_PrizeList[nIndex][i].ItemID, g_FeelFeedBack800_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack800_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack800_PrizeButton[i]:SetActionItem( -1 );
			end
		else
			local theAction = DataPool:CreateActionItemForShow(g_FeelFeedBack800_PrizeList[nIndex][i].ItemID, g_FeelFeedBack800_PrizeList[nIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_FeelFeedBack800_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_FeelFeedBack800_PrizeButton[i]:SetActionItem( -1 );
			end
		end

	end

	g_FeelFeedBack800_7DayButtom[nIndex].Button:SetCheck(1)


	--看一下犫页是不是可以打开
	local nData1 = g_FeelFeedBack800_MD_Date
	local nTimes = math.mod(nData1,100)

	if nIndex > nTimes then
		--第X葼可领取
		FeelFeedBack800_Right_Button1:Disable()
		FeelFeedBack800_Right_Button1:SetProperty("DisabledImage",g_FeelFeedBack800_7DayImage[nIndex][4])
	else
		--看是不是已经领取了
		local nData2 = g_FeelFeedBack800_MF_Date
		local nBase = 1
		for i=1,nIndex-1 do
			nBase = nBase * 10
		end

		local nFlag = math.mod(math.floor(nData2/nBase),10)
		if nFlag == 0 then
		--未领取
			FeelFeedBack800_Right_Button1:Enable()
		elseif nFlag == 1 then
		--已领取
			FeelFeedBack800_Right_Button1:Disable()
			FeelFeedBack800_Right_Button1: SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
		end
	end

end

function FeelFeedBack800_GetPrize()
		Variable:SetVariable("ZhouHuoYue", FeelFeedBack800_Frame:GetProperty("UnifiedPosition"), 1);
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GetPrize");
			Set_XSCRIPT_ScriptID(792012);
			Set_XSCRIPT_Parameter(0,g_FeelFeedBack800_Click)
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
end

function FeelFeedBack800_Index(param)
	if param == 0 and IsWindowShow("FeelFeedBack800") then
		FeelFeedBack800_Index0:SetCheck(1)
		FeelFeedBack800_Index1:SetCheck(0)
		return 
	end
	
	--2023周活跃奖励放出 by ypl
	-- Variable:SetVariable("ZhouHuoYue", FeelFeedBack800_Frame:GetProperty("UnifiedPosition"), 1);
	
	-- if param == 1 then
		-- Clear_XSCRIPT();
			-- Set_XSCRIPT_Function_Name("RequestOpenUI");
			-- Set_XSCRIPT_ScriptID(998263);
			-- Set_XSCRIPT_Parameter(0,1);
			-- Set_XSCRIPT_ParamCount(1);
		-- Send_XSCRIPT();
	-- end
end



