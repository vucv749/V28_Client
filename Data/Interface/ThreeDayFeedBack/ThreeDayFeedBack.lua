
--!!!reloadscript =ThreeDayFeedBack

local g_Frame_UnifiedPosition
local g_ThreeDayFeedBack_Npcid = -1

local g_ThreeDayFeedBack_NowIndex = 0
local g_ThreeDayFeedBack_Flag = {}
local g_ThreeDayFeedBack_TotalNum = 0
local g_ThreeDayFeedBack_PageButton = {}
local g_ThreeDayFeedBack_PageButtonMask = {}
local g_ThreeDayFeedBack_DayImg = false
local g_ThreeDayFeedBack_GiftTextImg = false
local g_ThreeDayFeedBack_GiftImg = false
local g_ThreeDayFeedBack_GiftButton = false
local g_ThreeDayFeedBack_PrizeButton = {}
local g_ThreeDayFeedBack_Image = {
	[1] ={
		[1]="set:ThreeDayFeedBack image:ThreeDayFeedBack_XHX",			--FeelFeedBack400_Left_image ????
		[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num1",				--FeelFeedBack400_Right_imageDay ?????
		[3]="set:ThreeDayFeedBack image:ThreeDayFeedBack_LHSF",			--FeelFeedBack400_Right_imageDayItem ????
		[4]="set:Seven image:Seven_day2", 									--??????
		},
	[2] ={
		[1]="set:ThreeDayFeedBack image:ThreeDayFeedBack_DDJ",
		[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num2",
		[3]="set:ThreeDayFeedBack image:ThreeDayFeedBack_MJZL",
		[4]="set:Seven image:Seven_day2",				
		},	
	[3] ={
		[1]="set:ThreeDayFeedBack image:ThreeDayFeedBack_DDN",
		[2]="set:FeelFeedBack600_1 image:FeelFeedBack600_Num3",
		[3]="set:ThreeDayFeedBack image:ThreeDayFeedBack_HNXB",
		[4]="set:Seven image:Seven_day3",				
		},
}

local g_ThreeDayFeedBack_PrizeList =
{
	[1] =
        {
			[1]={ItemID = 20501003, num = 1, needbind =1,},		-- 3???
			[2]={ItemID = 30900045, num = 1, needbind =1,},		-- ?????	
			[3]={ItemID = 20310168, num = 15, needbind =1,},	-- ???*15 
		},
    [2] =
        {
			[1]={ItemID = 20502003, num = 1, needbind =1,},		-- 3???
			[2]={ItemID = 30008048, num = 1, needbind =1,},		-- ???
			[3]={ItemID = 50313004, num = 1, needbind =1,},		-- ???3?
		},
    [3] =
        {
			[1]={ItemID = 38002519, num = 2, needbind =1,},		-- ????*2
			[2]={ItemID = 38002524, num = 3, needbind =1,},		-- ????*3
			[3]={ItemID = 38002532, num = 5, needbind =1,},		-- ???*5
		},
}
--=========
--PreLoad==
--=========
function ThreeDayFeedBack_PreLoad()
	this:RegisterEvent("UI_COMMAND")
    this:RegisterEvent("PLAYER_LEAVE_WORLD")		-- ????
	this:RegisterEvent("ADJEST_UI_POS",false)			-- ???????????
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)	        -- ??????????
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--???????
end
--=========
--OnLoad
--=========
function ThreeDayFeedBack_OnLoad()
	g_Frame_UnifiedPosition = ThreeDayFeedBack_Frame:GetProperty("UnifiedPosition")

	g_ThreeDayFeedBack_PageButton[1] = ThreeDayFeedBack_Top_day1_Button1
	g_ThreeDayFeedBack_PageButton[2] = ThreeDayFeedBack_Top_day2_Button1
	g_ThreeDayFeedBack_PageButton[3] = ThreeDayFeedBack_Top_day3_Button1

	g_ThreeDayFeedBack_PageButtonMask[1] = ThreeDayFeedBack_Top_day1_done
	g_ThreeDayFeedBack_PageButtonMask[2] = ThreeDayFeedBack_Top_day2_done
	g_ThreeDayFeedBack_PageButtonMask[3] = ThreeDayFeedBack_Top_day3_done

	g_ThreeDayFeedBack_PrizeButton[1] = ThreeDayFeedBack_Right_ShowA
	g_ThreeDayFeedBack_PrizeButton[2] = ThreeDayFeedBack_Right_ShowB
	g_ThreeDayFeedBack_PrizeButton[3] = ThreeDayFeedBack_Right_ShowC

	g_ThreeDayFeedBack_DayImg = ThreeDayFeedBack_Right_imageDay
	g_ThreeDayFeedBack_GiftTextImg = ThreeDayFeedBack_Right_imageDayItem
	g_ThreeDayFeedBack_GiftImg = ThreeDayFeedBack_Left_image
	g_ThreeDayFeedBack_GiftButton = ThreeDayFeedBack_Right_Button1


end
--=========
--OnEvent
--=========
function ThreeDayFeedBack_OnEvent(event)
    
    if (event == "PLAYER_LEAVE_WORLD" or event == "HIDE_ON_SCENE_TRANSED") then
		ThreeDayFeedBack_OnHiden()
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
        ThreeDayFeedBack_On_ResetPos()
    end

	if (event == "UI_COMMAND" and tonumber(arg0) == 88998602 ) then
		local bShow =  Get_XParam_INT(0)
		g_ThreeDayFeedBack_Flag = {}
		g_ThreeDayFeedBack_Flag[1] = Get_XParam_INT(1)
		g_ThreeDayFeedBack_Flag[2] = Get_XParam_INT(2)
		g_ThreeDayFeedBack_Flag[3] = Get_XParam_INT(3)
		g_ThreeDayFeedBack_TotalNum = Get_XParam_INT(4)
		
		if(bShow == 0)then --????
			this:Hide()
			return

		elseif(bShow == 1)then --???? ?????????????
			if(this:IsVisible())then
				this:Hide()
				return
			end

			if(g_ThreeDayFeedBack_TotalNum < 1) then
				g_ThreeDayFeedBack_NowIndex = 1 
			elseif(g_ThreeDayFeedBack_TotalNum < 3)then
				g_ThreeDayFeedBack_NowIndex = g_ThreeDayFeedBack_TotalNum
			else
				g_ThreeDayFeedBack_NowIndex = 3
			end

			ThreeDayFeedBack_Open() --?????

			this:Show()

		elseif(bShow == 2)then --????
			if(this:IsVisible())then
				g_ThreeDayFeedBack_GiftButton:Disable()
				g_ThreeDayFeedBack_GiftButton:SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
				if(g_ThreeDayFeedBack_NowIndex > 0)then
					g_ThreeDayFeedBack_PageButtonMask[g_ThreeDayFeedBack_NowIndex]:Show() 
				end
			end

		elseif(bShow == 3)then --????
			if(this:IsVisible())then
				ThreeDayFeedBack_Open()
			end
		end
	end
end


function ThreeDayFeedBack_Open()
	if(g_ThreeDayFeedBack_NowIndex < 1 or g_ThreeDayFeedBack_NowIndex > 3)then
		return
	end

	--页签按钮
	for i = 1 , 3 do 
		g_ThreeDayFeedBack_PageButton[i]:SetCheck(0)
	end
	g_ThreeDayFeedBack_PageButton[g_ThreeDayFeedBack_NowIndex]:SetCheck(1)

	--页签犣挡
	for i = 1 , 3 do
		g_ThreeDayFeedBack_PageButtonMask[i]:Hide() 
		if(g_ThreeDayFeedBack_Flag[i] == 2)then--???
			g_ThreeDayFeedBack_PageButtonMask[i]:Show() 
		end
	end

	--页面图片
	g_ThreeDayFeedBack_DayImg:SetProperty( "Image", g_ThreeDayFeedBack_Image[g_ThreeDayFeedBack_NowIndex][2] )
	g_ThreeDayFeedBack_GiftTextImg:SetProperty( "Image", g_ThreeDayFeedBack_Image[g_ThreeDayFeedBack_NowIndex][3] )
	g_ThreeDayFeedBack_GiftImg:SetProperty( "Image", g_ThreeDayFeedBack_Image[g_ThreeDayFeedBack_NowIndex][1] )

	--领取按钮
	g_ThreeDayFeedBack_GiftButton:Enable()
	if(g_ThreeDayFeedBack_Flag[g_ThreeDayFeedBack_NowIndex] == 0)then --???
		g_ThreeDayFeedBack_GiftButton:SetProperty("DisabledImage",g_ThreeDayFeedBack_Image[g_ThreeDayFeedBack_NowIndex][4])
		g_ThreeDayFeedBack_GiftButton:Disable()
	elseif(g_ThreeDayFeedBack_Flag[g_ThreeDayFeedBack_NowIndex] == 1)then --????
		g_ThreeDayFeedBack_GiftButton:Enable()
	elseif(g_ThreeDayFeedBack_Flag[g_ThreeDayFeedBack_NowIndex] == 2)then --???
		g_ThreeDayFeedBack_GiftButton:Disable()
		g_ThreeDayFeedBack_GiftButton:SetProperty("DisabledImage","set:Seven image:Seven_lingquDis")
	end

	--物品显示
	for i=1,3 do
		if 1 == g_ThreeDayFeedBack_PrizeList[g_ThreeDayFeedBack_NowIndex][i].needbind then
			local theAction = DataPool:CreateBindActionItemForShow(g_ThreeDayFeedBack_PrizeList[g_ThreeDayFeedBack_NowIndex][i].ItemID, g_ThreeDayFeedBack_PrizeList[g_ThreeDayFeedBack_NowIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_ThreeDayFeedBack_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_ThreeDayFeedBack_PrizeButton[i]:SetActionItem( -1 );
			end
		else
			local theAction = DataPool:CreateActionItemForShow(g_ThreeDayFeedBack_PrizeList[g_ThreeDayFeedBack_NowIndex][i].ItemID, g_ThreeDayFeedBack_PrizeList[g_ThreeDayFeedBack_NowIndex][i].num)
			if theAction:GetID() ~= 0 then
				g_ThreeDayFeedBack_PrizeButton[i]:SetActionItem( theAction:GetID() );
			else
				g_ThreeDayFeedBack_PrizeButton[i]:SetActionItem( -1 );
			end
		end

	end
end


--不同葼页签点击
function ThreeDayFeedBack_Click(nIndex)
	g_ThreeDayFeedBack_NowIndex = nIndex
	ThreeDayFeedBack_Open()
end

--领取按钮点击
function ThreeDayFeedBack_GetPrize()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GetAward");
		Set_XSCRIPT_ScriptID(889986);
		Set_XSCRIPT_Parameter(0,g_ThreeDayFeedBack_NowIndex)
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
end

--=========
--OnClose "X"
--=========
function ThreeDayFeedBack_Close()
	this:Hide()
end
--=========
--handle Hide Event
--=========
function ThreeDayFeedBack_OnHiden()
	this:Hide()
end

function ThreeDayFeedBack_On_ResetPos()
	ThreeDayFeedBack_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
end
