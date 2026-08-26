local g_DIYFrame_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurPage = 0							-- ???????????
local g_nCurSelect = 0							-- ?????????
local g_Style_Index = {}
local g_Style_Count = 0							-- ???????DIY??????
local g_Original_Frame = 0				
local STYLE_PAGE_BUTTON = 12					-- ???????
local MAX_STYLE = 256							-- ???????

local g_SelectHeadFrame_Frame_UnifiedPosition;

--==================================
-- SelectHeadFrame_PreLoad
--==================================
function SelectHeadFrame_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

--==================================
-- SelectHeadFrame_OnLoad
--==================================
function SelectHeadFrame_OnLoad()
	g_DIYFrame_Icon[1]	= SelectHeadFrame_Skill1_BKG
	g_DIYFrame_Icon[2] 	= SelectHeadFrame_Skill2_BKG
	g_DIYFrame_Icon[3] 	= SelectHeadFrame_Skill3_BKG
	g_DIYFrame_Icon[4] 	= SelectHeadFrame_Skill4_BKG
	g_DIYFrame_Icon[5] 	= SelectHeadFrame_Skill5_BKG
	g_DIYFrame_Icon[6] 	= SelectHeadFrame_Skill6_BKG
	g_DIYFrame_Icon[7] 	= SelectHeadFrame_Skill7_BKG
	g_DIYFrame_Icon[8] 	= SelectHeadFrame_Skill8_BKG
	g_DIYFrame_Icon[9] 	= SelectHeadFrame_Skill9_BKG
	g_DIYFrame_Icon[10]	= SelectHeadFrame_Skill10_BKG
	g_DIYFrame_Icon[11]	= SelectHeadFrame_Skill11_BKG
	g_DIYFrame_Icon[12]	= SelectHeadFrame_Skill12_BKG
	
	for i=1, MAX_STYLE do
		g_Style_Index[i] = -1
	end
	
	g_SelectHeadFrame_Frame_UnifiedPosition=SelectHeadFrame_Frame:GetProperty("UnifiedPosition");
	
end

--==================================
-- SelectHeadFrame_OnEvent
--==================================
function SelectHeadFrame_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 901) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
				PushDebugMessage("DÊ liÆu m·y ch¸ cÛ v§n ´");
				return;
		end

		if(IsWindowShow("SelectHeadstyle")) then
			CloseWindow("SelectHeadstyle", true);
		end

		if(IsWindowShow("SelectFacestyle")) then
			CloseWindow("SelectFacestyle", true);
		end
		
		SelectHeadFrame_OnShown();
		BeginCareObject_SelectHeadFrame(objCared)

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) ~= objCared) then
			Close_DIYFrame()
			return;
		end
		--»Áπ˚∫ÕNPCµƒæ‡¿Î¥Û”⁄“ª∂®æ‡¿ÎªÚ†ﬂ±ª…æ≥˝£¨◊‘∂Øπÿ±†
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then			
			--»°œ˚πÿ–ƒ
			Close_DIYFrame()
		end
		
	elseif (event == "ADJEST_UI_POS" ) then
		SelectHeadFrame_Frame_On_ResetPos()
	
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		SelectHeadFrame_Frame_On_ResetPos()
	
	end
	
	--ΩÁ√Êª•≥‚
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20120406 ) then   --bx
		if (this:IsVisible()) then
			this:Hide()
			return
		end
	end	
end

--==================================
-- SelectHeadFrame_OnShown
--==================================
function SelectHeadFrame_OnShown()
	for i,eachstyle in g_DIYFrame_Icon do
		eachstyle : SetPushed(0)
	end
	
	-- µ√µΩµ±«∞µƒDIYÕ∑œÒ
	local FrameID, FrameName, ItemSerial, ItemCount, IconFile, CostMoney, Duration = DataPool : Get_DIYFrame_Item( Player : GetData("DIYFRAME") );
	g_Original_Frame = FrameID;
	ChangeDIYFramePreview(g_Original_Frame);

	SelectHeadFrame_Update();
	this:Show();
end

--==================================
-- SelectHeadFrame_Update
--==================================
function SelectHeadFrame_Update()

	local i;
	local k = 1;
	
	for i,eachstyle in g_DIYFrame_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	for i=0, MAX_STYLE do		
		local FrameID, FrameName, ItemSerial, ItemCount, IconFile, CostMoney, Duration = DataPool : Get_DIYFrame_Item(i);		
		if(ItemSerial > 0) then
			if k > STYLE_PAGE_BUTTON * (g_nCurPage) and k <= STYLE_PAGE_BUTTON * (g_nCurPage+1) then
				local m = k - STYLE_PAGE_BUTTON * (g_nCurPage);
				IconFile = GetIconFullName(IconFile)
				g_DIYFrame_Icon[m]:SetProperty("NormalImage", IconFile)
				g_DIYFrame_Icon[m]:SetProperty("HoverImage", IconFile)
				g_DIYFrame_Icon[m]:SetToolTip(FrameName)
				g_Style_Index[m] = i;
			end
			k = k+1
		end
	end
	-- º«¬º±Ì∏Ò÷–◊‹π≤”–∂‡…Ÿ∏ˆDIYÕ∑œÒ
	g_Style_Count = k-1

	if(g_Style_Count <= 0) then
		--SelectHeadFrame_Require:SetText("√ª”–ø…∏¸∏ƒµƒÕ∑œÒ∑Á∏Ò°£");
		SelectHeadFrame_PageUp : Disable();
		SelectHeadFrame_PageDown : Disable();
		SelectHeadFrame_Accept : Disable();
		return;
	end
	
	g_nCurSelect = 0;
	SelectHeadFrame_WarningText : SetText("#{TXDI_091110_11}");
	
	-- ∑≠“≥…Ë÷√
	if g_nCurPage == 0 then
		SelectHeadFrame_PageUp : Disable();				-- ?1?
	else
		SelectHeadFrame_PageUp : Enable();				-- ???1?
	end

	if (g_nCurPage+1)*STYLE_PAGE_BUTTON < g_Style_Count then
		SelectHeadFrame_PageDown : Enable();			-- ????1?
	else
		SelectHeadFrame_PageDown : Disable();			-- ??1?
	end

end

--==================================
--πÿ±†
--==================================
function Close_DIYFrame()
	g_nCurPage = 0
	g_nCurSelect = 0
	StopCareObject_SelectHeadFrame(objCared)
	this:Hide();	
end

--==================================
--ø™ ºπÿ–ƒNPC
--==================================
function BeginCareObject_SelectHeadFrame(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "SelectHeadFrame");
end

--==================================
--Õ£÷π∂‘ƒ≥NPCµƒπÿ–ƒ
--==================================
function StopCareObject_SelectHeadFrame(objCaredId)
	this:CareObject(objCaredId, 0, "SelectHeadFrame");
	g_Object = -1;
end

--==================================
--»°œ˚
--==================================
function SelectHeadFrame_Cancel_Clicked()
	ChangeDIYFramePreview(g_Original_Frame);
	Close_DIYFrame();
end

--==================================
--»∑»œ
--==================================
function SelectHeadFrame_OK_Clicked()

	-- √ª”–—°‘ÒDIYÕ∑œÒ
	if(g_nCurSelect == 0 )then
		PushDebugMessage("#{TXDI_091110_03}");
		return;
	end

	-- µ√µΩ—°‘ÒµƒDIYÕ∑œÒ–≈œ¢
	local FrameID, FrameName, ItemSerial, ItemCount, IconFile, CostMoney, Duration = DataPool : Get_DIYFrame_Item(g_Style_Index[g_nCurSelect]);
	
	-- ºÏ≤Èµ¿æﬂ
	if(ItemSerial ~= -1) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemSerial) < ItemCount) then
			PushDebugMessage("#{TXDI_091110_04}");
			return;
		end
	end
	
	-- µ√µΩÕÊº“µƒΩ±“∫ÕΩª◊” ˝ƒø
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	if (nMoney + nMoneyJZ) < CostMoney then
		PushDebugMessage("#{ResultText_154}");
		return;
	end
	
	-- »Áπ˚—°‘ÒµƒDIYÕ∑œÒ∫Õµ±«∞DIYÕ∑œÒ≤ªÕ¨
	if FrameID ~= g_Original_Frame then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(805031);
			Set_XSCRIPT_Parameter(0, g_Style_Index[g_nCurSelect]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_DIYFrame();		
	else
		PushDebugMessage("#{TXDI_091110_14}");
	end
	
end

--==================================
--—°÷–“ª∏ˆÕº±Í
--==================================
function SelectHeadFrame_Clicked(nIndex)
	
	-- —°÷–Œﬁ–ßÕº±Í ±µƒ¥¶¿Ì
	if ((nIndex < 0) or (nIndex + STYLE_PAGE_BUTTON * (g_nCurPage) > g_Style_Count))  then
		if(g_nCurSelect > 0 )then
			g_DIYFrame_Icon[g_nCurSelect]:SetPushed(0);
		end
		g_nCurSelect = 0
		ChangeDIYFramePreview(g_Original_Frame);
		SelectHeadFrame_WarningText : SetText("#{TXDI_091110_11}");
		return
	end

	-- —°÷–”––ßÕº±Í ±µƒ¥¶¿Ì
	if(g_nCurSelect > 0 )then
		g_DIYFrame_Icon[g_nCurSelect]:SetPushed(0);
	end
	g_nCurSelect = nIndex;
	g_DIYFrame_Icon[g_nCurSelect]:SetPushed(1);

	local FrameID, FrameName, ItemSerial, ItemCount, IconFile, CostMoney, Duration = DataPool : Get_DIYFrame_Item(g_Style_Index[g_nCurSelect]);
	local name, icon = LifeAbility : GetPrescr_Material(ItemSerial);

	SelectHeadFrame_WarningText : SetText("#{TXDI_091110_12}#G"..name.."#r#W#{TXDI_091110_13}#Y#{_EXCHG"..CostMoney.."}#W#r#{TXDI_091110_11}");
	ChangeDIYFramePreview(FrameID);

end

--=========================================
--∑≠“≥
--=========================================
function SelectHeadFrame_Page(nPage)
	g_nCurPage = g_nCurPage + nPage;
	SelectHeadFrame_Update();
end


--=========================================
--∏ƒ±‰‘§¿¿Õº
--=========================================
function ChangeDIYFramePreview(frameID)

	local nFrameID = frameID;
	if (nFrameID <= 0) then
		nFrameID = 0;
	end;
	
	--¥”≈‰÷√±Ì∂¡»°≤ºæ÷≤Œ ˝	
	local MainFramePos, MainFrameSize, MainFrameImage, TopFramePos, TopFrameSize, TopFrameImage, CharIconPos, NameBarPos, NameBarSize, NameBarImage, CampFramePos, CampFrameSize, CampImageMap0, CampImageMap1, CampImageMap2, CampImageMap3, CampImageMap4, CampImageMap5, CampImageMap6, CampImageMap7, CampImageMap8, CampImageMap9, DataBackPos, DataBackSize, DataBackImage, DataFrontImage, DataOffset, DataHeight, LevelFramePos, LevelFrameSize, LevelFrameImage, XiezhuPos, XiezhuSize, XiezhuHoverImage, XiezhuNormalImage, XiezhuPushedImage, TypeIconPos, TypeIconSize, TypeIconImage, TypeFramePos, TypeFrameSize, TypeFrameImage = Player : GetDIYFrameLayout(nFrameID);
	if (MainFramePos == nil or MainFramePos == "") then
		-- “‚Õ‚«Èøˆ
		return;
	end;
	
	SelectHeadFrame_Preview2 : SetProperty("AbsolutePosition", MainFramePos);
	SelectHeadFrame_Preview2 : SetProperty("AbsoluteSize", MainFrameSize);
	SelectHeadFrame_Preview2 : SetProperty("Image", MainFrameImage);
	SelectHeadFrame_Preview_TopFrame : SetProperty("AbsolutePosition", TopFramePos);
	SelectHeadFrame_Preview_TopFrame : SetProperty("AbsoluteSize", TopFrameSize);
	SelectHeadFrame_Preview_TopFrame : SetProperty("Image", TopFrameImage);
	SelectHeadFrame_Preview_Icon : SetProperty("AbsolutePosition", CharIconPos);
	SelectHeadFrame_Preview_NameBar : SetProperty("AbsolutePosition", NameBarPos);
	SelectHeadFrame_Preview_NameBar : SetProperty("AbsoluteSize", NameBarSize);
	SelectHeadFrame_Preview_NameBar : SetProperty("Image", NameBarImage);
	SelectHeadFrame_Preview_CampFrame : SetProperty("AbsolutePosition", CampFramePos);
	SelectHeadFrame_Preview_CampFrame : SetProperty("AbsoluteSize", CampFrameSize);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap0);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap1);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap2);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap3);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap4);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap5);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap6);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap7);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap8);
	SelectHeadFrame_Preview_CampFrame : SetProperty("ChildImage", CampImageMap9);
	SelectHeadFrame_Preview_DataBack : SetProperty("AbsolutePosition", DataBackPos);
	SelectHeadFrame_Preview_DataBack : SetProperty("AbsoluteSize", DataBackSize);
	SelectHeadFrame_Preview_DataBack : SetProperty("Image", DataBackImage);
	SelectHeadFrame_Preview_DataFront : SetProperty("Image", DataFrontImage);
	SelectHeadFrame_Preview_LevelFrame : SetProperty("AbsolutePosition", LevelFramePos);
	SelectHeadFrame_Preview_LevelFrame : SetProperty("AbsoluteSize", LevelFrameSize);
	SelectHeadFrame_Preview_LevelFrame : SetProperty("Image", LevelFrameImage);
	SelectHeadFrame_Preview_Xiezhugongji_Icon : SetProperty("AbsolutePosition", XiezhuPos);
	SelectHeadFrame_Preview_Xiezhugongji_Icon : SetProperty("AbsoluteSize", XiezhuSize);
	SelectHeadFrame_Preview_Xiezhugongji_Icon : SetProperty("Image", XiezhuNormalImage);
	SelectHeadFrame_Preview_TypeIcon : SetProperty("AbsolutePosition", TypeIconPos);
	SelectHeadFrame_Preview_TypeIcon : SetProperty("AbsoluteSize", TypeIconSize);
	SelectHeadFrame_Preview_TypeIcon : SetProperty("Image", TypeIconImage);
	SelectHeadFrame_Preview_TypeFrame : SetProperty("AbsolutePosition", TypeFramePos);
	SelectHeadFrame_Preview_TypeFrame : SetProperty("AbsoluteSize", TypeFrameSize);
	SelectHeadFrame_Preview_TypeFrame : SetProperty("Image", TypeFrameImage);
	--º∆À„—™∆¯≈≠ÃıŒª÷√∫Õ∏ﬂ∂»
	SelectHeadFrame_Preview_HP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset) );
	SelectHeadFrame_Preview_HP : SetProperty("UnifiedSize", "{{1.0,-2.0},{0.0,"..tostring(DataHeight).."}}");
	SelectHeadFrame_Preview_MP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset+DataHeight+1) );
	SelectHeadFrame_Preview_MP : SetProperty("UnifiedSize", "{{1.0,-2.0},{0.0,"..tostring(DataHeight).."}}");
	SelectHeadFrame_Preview_SP : SetProperty("AbsolutePosition", "x:1.000000 y:"..tostring(DataOffset+DataHeight*2+2) );
	SelectHeadFrame_Preview_SP : SetProperty("UnifiedSize", "{{1.0,-2.0},{0.0,"..tostring(DataHeight).."}}");
	
	--…Ë÷√ ˝æ›
	SelectHeadFrame_Preview_Name:SetText( "#W"..Player:GetName() );
	SelectHeadFrame_Preview_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( Player:GetData("MEMPAI")) );
	SelectHeadFrame_Preview_LevelText:SetText( "#W"..tostring( Player:GetData("LEVEL")) );
	SelectHeadFrame_Preview_Icon:SetProperty("Image", Player:GetData("PORTRAIT"))
	
	--œ‘ æ
	SelectHeadFrame_Preview : Show();
	
end

function SelectHeadFrame_Frame_On_ResetPos()
  SelectHeadFrame_Frame:SetProperty("UnifiedPosition", g_SelectHeadFrame_Frame_UnifiedPosition);
end
