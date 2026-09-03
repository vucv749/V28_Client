
local ErrViewmode = 10;

local nowSettings = {}
local nowSettingsType = 0
local validCheckSetting = {}
--- ±£¥Êµ±«∞…Ë÷√
local curViewSetupBackup = {}

 -- ÀŸ∂»”≈œ»1°¢æ˘∫‚…Ë÷√2°¢ª≠÷ ”≈œ»3°¢≥¨∏ﬂª≠÷ 4
local defaultSetting = 1 		-- ????????
-- ∏¸∏ƒ¥À¥¶–Ë“™Õ¨≤Ω–ﬁ∏ƒ CVariableSystem::FitVideoOptionTypeClassic()
local settingSets = { 
		[2] =	{0,0,0,1},  	--?????
		[3] =	{0,2,2,2},  	--????
		[4] =	{0,1,2,2},  	--????
--		[5] =	{2,2,2,2},  	--œ‘ æƒ£–Õ ˝
		[6] =	{0,2,2,2},  	--????
		[8] =	{0,2,2,2},  	--??
		[9] =	{0,2,2,2},  	--????
		[11] =	{0,0,1,1}, 		--????
		[13] =	{1,1,1,1},  	--????
		[15] =	{0,0,0,0},  	--????
		[16] =	{1,1,1,0},  	--????
		[17] =	{0,1,1,1}, 		--????
	 -- [14] =	{0,0,1,1},  	--†⁄µ≤∞ÎÕ∏
	}
local allSettings = {}
local settingByIndex = {}

--===============================================
-- OnLoad()
--===============================================
function ViewSetup_PreLoad()
	this:RegisterEvent("TOGLE_VIEWSETUP",true);

	this:RegisterEvent("TOGLE_INPUTSETUP",false);
	this:RegisterEvent("TOGLE_SYSTEMFRAME",false);
	this:RegisterEvent("TOGLE_SOUNDSETUP",false);
	this:RegisterEvent("TOGLE_GAMESETUP",false);

	this:RegisterEvent("CHANGE_VIEW_SETUP",true);
	this:RegisterEvent("CLOSE_SETUP_WINDOW",false);
	this:RegisterEvent("CHANGE_VIEW_SETUP_QUALITY", true)
end

function ViewSetup_OnLoad()
	allSettings =
	{
		{index = 2, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_Check2 	,str = "fhj"},			--?????			View_Fanhunjiao
		{index = 3, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item3_Control 	,str = "wtdh"},			--????				View_ObjectMove
		{index = 4, ctrltype = "slider" , docSize = 2, default = 1, ctrl = ViewSetup_Item9_Control 	,str = "rwyy"},			--????				View_HumanLightmap
		{index = 5, ctrltype = "slider" , docSize = 170, default = 170, ctrl = ViewSetup_Item10_Control 	,str = "ksfw"},		--????? ????	View_VisibleModelNum
		--{index = 5, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item10_Control 	,str = "ksfw"},		--œ‘ æƒ£–Õ ˝ ø… ”∑∂Œß	View_VisibleRangeLevelNew
		{index = 6, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item11_Control 	,str = "dhgxzl"},	--????				View_UpdateQuality
		{index = 8, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item7_Control 	,str = "cy"},			--??					View_TextureFiltering
		{index = 9, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item14_Control 	,str = "txdjsz"},	--????				View_EffectLevel
		{index = 10, ctrltype = "slider" , docSize = 2, default = 2, ctrl = ViewSetup_Item17_Control 	,str = "mxxslj"},	--????				View_ModelShowLogic
		{index = 11, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_Check4 		,str = "qpfg"},		--????				View_HDRFilter
		{index = 13, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_Miwu 		,str = "miwu"},			--????				View_EnableFog
		{index = 14, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_Bantou 		,str = "zdbt"},		--????				View_Transparency
		{index = 15, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_Check7 		,str = "qpms"},		--????				View_FullScreen
		{index = 16, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_Check5 		,str = "cztb"},		--????				View_Aplomb
		{index = 17, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_SetEffect 		,str = "mxtx"},		--????				View_ModelEffect
		-- {index = 18, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_HDR 			,str = "hdr"},		--HDR					View_HDRFilter
		{index = 21, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_INSTEADMODEL	,str = "tm"},		--???? 				View_InsteadModel
		{index = 22, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_Check11		,str = "tksj"}, 	--???? 				View_UseSkyCamera
		{index = 23, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_shijiao		,str = "sjbc"}, 	--???? 				Camera_RestoreView
		{index = 24, ctrltype = "check" , docSize = 0, default = 1, ctrl = ViewSetup_Item_Check_ShijJu	,str = "mrsj"}, 	--???? 				View_DefaultCamera
		-- {index = 25, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_MARS			,str = "WaveWater"}, --MarsÀÆ-–¬ÀÆ 			View_WaveWater
		-- {index = 26, ctrltype = "check" , docSize = 0, default = 0, ctrl = ViewSetup_Item_Checkfps		,str = "zhenlv"}, 	--∏ﬂ÷°¬ (60÷°) 			View_GaoZhenLv
	}
	for i, v in pairs(allSettings) do 
		if settingSets[v.index] then 
			v.default = settingSets[v.index][defaultSetting]
		end 
		settingByIndex[v.index] = v;
		if v.ctrl and v.ctrltype == "slider" then 
			local stepSize = "1";
			if v.str == "mxxslj"then 
				stepSize = "2";
			end
			v.ctrl:SetProperty( "DocumentSize",tostring(v.docSize) );
			v.ctrl:SetProperty( "PageSize","0" );
			v.ctrl:SetProperty( "StepSize",stepSize );
		end
	end

	ViewSetup_Item15:ComboBoxAddItem("CÛ", 0);
	ViewSetup_Item15:ComboBoxAddItem("800X600", 1);
	ViewSetup_Item15:ComboBoxAddItem("1024X768", 2);
	ViewSetup_Item15:ComboBoxAddItem("1280X720", 3);
	ViewSetup_Item15:ComboBoxAddItem("1280X1024", 4);
	ViewSetup_Item15:ComboBoxAddItem("1920X1080", 5);

	ViewSetup_ResetComboList(1)
end

--===============================================
-- OnEvent()
--===============================================
function ViewSetup_OnEvent(event)

	if ( event == "TOGLE_VIEWSETUP" ) then
		local setupUnionPos = Variable:GetVariable("SetupUnionPos");
		if(setupUnionPos ~= nil) then
			ViewSetup_Frame:SetProperty("UnifiedPosition", setupUnionPos);
		end

        --- √ø¥Œ¥Úø™∏√ΩÁ√Ê£¨∂ºœ»∂‘µ±«∞œ‘ æ…Ë÷√Ω¯––“ªœ¬±∏∑›
        ViewSetup_Save_Cur_Setup()
		ViewSetup_MenuButtons_Reset()
		this:Show();
		ViewSetup_UpdateFrame()
        --- …Ë÷√√ª”––ﬁ∏ƒ»Œ∫Œ≈‰÷√
        ViewSetup_Set_Setup_UnChanged()
	elseif event == "TOGLE_SYSTEMFRAME" then
		this:Hide()
	elseif event == "TOGLE_SOUNDSETUP" then
		this:Hide()
	elseif event == "TOGLE_GAMESETUP" then
		this:Hide()
	elseif event == "TOGLE_INPUTSETUP" then
		this:Hide()
	elseif event == "CHANGE_VIEW_SETUP" then
        if ( tonumber(arg0) == 0 ) then
            ViewSetup_YingYong_Clicked()
        else
            ViewSetup_Retrieve_Setup()
        end
    elseif event == "CHANGE_VIEW_SETUP_QUALITY" then
    	ViewSetup_DirectChgQuality(tonumber(arg0))
    elseif event == "CLOSE_SETUP_WINDOW" then
        this:Hide()
	end
end


--===============================================
-- UpdateFrame()
--===============================================
function ViewSetup_UpdateFrame()
	ViewSetup_Item15:SetCurrentSelect(0);
	for i, v in pairs(allSettings) do 
		local temp = SystemSetup:View_GetData( v.str );
		nowSettings[v.index] = temp;
		if v.ctrl ~= nil then 
			if v.ctrltype == "slider" then 
				if v.str == "ksfw" and temp == ErrViewmode then 
					--µ⁄“ª¥Œƒ¨»œŒ™∏ﬂ
					v.ctrl:SetPosition(2);
				else
					v.ctrl:SetPosition(temp);
				end
				if v.index == 5 then
					local thumbPos = v.ctrl:GetThumbPositionX()
					ViewSetup_SetModleNum(temp + 10, thumbPos)
				end
			elseif v.ctrltype == "check" then 
				v.ctrl:SetCheck(temp);
			end
		end
	end

	ViewSetup_SpecialCamera_Check()
	ViewSetup_Sjbc_ClickEx()
	ViewSetup_GlobalQualityCheck();
end
function ViewSetup_SpecialCamera_Check()
	-- local special_type = SystemSetup:IsCameraSpecial()
	-- -- 1£∫PBR≥°æ∞ 2£∫–¬ÃÏÕ‚≥°æ∞
	-- if 1==special_type or 2==special_type then
	-- 	ViewSetup_Item12_ShijJu_Text:SetToolTip("#{XSSZ_191130_15}")
	-- else
	-- 	ViewSetup_Item12_ShijJu_Text:SetToolTip("#{SJ_XML_02}")		--æ≠µ‰ ”æ‡
	-- end
	-- if 1==special_type then
	-- 	ViewSetup_Item_Miwu_Text:SetToolTip("#{XSSZ_191130_15}")	
	-- 	ViewSetup_Item11_Text:SetToolTip("#{XSSZ_191130_15}")		
	-- 	ViewSetup_HDR_Text:SetToolTip("#{XSSZ_191130_15}")			
	-- else
	-- 	ViewSetup_Item_Miwu_Text:SetToolTip("#{INTERFACE_XML_1251}")--œ‘ æ√‘ŒÌ	
	-- 	ViewSetup_Item11_Text:SetToolTip("#{INTERFACE_XML_397}")	--»´∆¡∑∫π‚		
	-- 	ViewSetup_HDR_Text:SetToolTip("#{XSYH_XML_26}")				--HDR
	-- end
end

--===============================================
-- ViewSetup_Accept_Clicked()
--===============================================
function ViewSetup_Accept_Clicked()
	ViewSetup_YingYong_Clicked()
	this:Hide();
end

--===============================================
-- SliderChanged
--===============================================
function ViewSetup_SliderChanged(nIndex)
	local tabinfo = settingByIndex[nIndex];
	if not tabinfo then 
		PushDebugMessage( "ViewSetup_SliderChanged allSettings is nil:"..(nIndex or "nil") )
		return
	end
	if tabinfo.ctrltype ~= "slider" then 
		PushDebugMessage( "ViewSetup_SliderChanged ctrltype is not slider:"..(nIndex or "nil") )
		return
	end
	if not tabinfo.ctrl then 
		PushDebugMessage( "ViewSetup_SliderChanged ctrl is nil:"..(nIndex or "nil") )
		return
	end
	local pos = tabinfo.ctrl:GetPosition();
	if pos == nowSettings[nIndex] then return end
	nowSettings[nIndex] = pos;
	ViewSetup_GlobalQualityCheck();
	ViewSetup_Set_Setup_Changed()
	
	if nIndex == 5 then
		local thumbPos = tabinfo.ctrl:GetThumbPositionX()
	 	ViewSetup_SetModleNum( math.floor(pos + 10), thumbPos )
	end
end

function ViewSetup_SetModleNum(num, thumbPos)
	--PushDebugMessage("ViewSetup_SetModleNum:"..(num or "nil")..":"..(thumbPos or "nil"))
	if num <= 10 or num >= 180 then
		ViewSetup_Item10_Text4:Hide()
	else
		ViewSetup_Item10_Text4:Show()
		ViewSetup_Item10_Text4:SetText(num)
	end
	ViewSetup_Item10_Text4:SetProperty("AbsoluteXPosition", thumbPos)
end

--===============================================
-- Default Setting
--===============================================
function ViewSetup_Default_Clicked()
	for i, v in pairs(allSettings) do 
		SystemSetup:View_SetData( v.str, v.default);
	end

	ViewSetup_UpdateFrame();
    ViewSetup_Set_Setup_Changed()
end

function ViewSetup_GlobalQualityCheck()
	local tmpType = 0
	for i=1 ,4 do
		if tmpType == 0 then
			tmpType = i
		else
			break;
		end
		for nIndex, v in pairs(settingSets) do 
			if v[i] ~= nowSettings[nIndex] then 
				tmpType = 0
				break;
			end
		end
	end

	nowSettingsType = tmpType
	if tmpType == 0 then
		ViewSetup_ResetComboList(0)
		ViewSetup_SelSettings:SetCurrentSelect(4)
	else
		ViewSetup_ResetComboList(1)
		ViewSetup_SelSettings:SetCurrentSelect(tmpType - 1)
	end
end

function ViewSetup_Res_Changed()
	ViewSetup_Item_Check7:SetCheck(0);

    ViewSetup_Set_Setup_Changed()
end

-- ∏¸–¬ ”Ω«±£≥÷∏¥—°øÚ◊¥Ã¨
function ViewSetup_Sjbc_ClickEx()

	-- »ÙÃÏø† ”Ω«¥Úø™£¨‘Ú ”Ω«±£≥÷œ‘ æ
	if ViewSetup_Item_Check11:GetCheck() == 1 then
		ViewSetup_Item_shijiao:Show()
		ViewSetup_shijiao_Text:Show()
	-- ∑Ò‘Ú≤ªœ‘ æ ”Ω«±£≥÷∏¥—°øÚ
	else
		ViewSetup_Item_shijiao:Hide()
		ViewSetup_shijiao_Text:Hide()
	end
end

function ViewSetup_DirectChgQuality(nIndex)
	if nowSettingsType == nIndex or nIndex >= 5 or nIndex < 1 then
		return
	end
	nowSettingsType = nIndex
	for i, v in pairs(settingSets) do 
		nowSettings[i] = v[nIndex]
		local tabinfo = settingByIndex[i];
		if tabinfo.ctrl then 
			if tabinfo.ctrltype == "slider" then 
				tabinfo.ctrl:SetPosition(v[nIndex]);
			elseif tabinfo.ctrltype == "check" then 
				tabinfo.ctrl:SetCheck(v[nIndex]);
			end
		end
	end
    ViewSetup_Set_Setup_Changed()
	ViewSetup_YingYong_Clicked()
end
function ViewSetup_SettingsSel()

	local str , nIndex = ViewSetup_SelSettings:GetCurrentSelect()

	if nowSettingsType == nIndex or nIndex == 5 then
		return
	end

	nowSettingsType = nIndex

	for i, v in pairs(settingSets) do 
		nowSettings[i] = v[nIndex]
		local tabinfo = settingByIndex[i];
		if tabinfo.ctrl then 
			if tabinfo.ctrltype == "slider" then 
				tabinfo.ctrl:SetPosition(v[nIndex]);
			elseif tabinfo.ctrltype == "check" then 
				tabinfo.ctrl:SetCheck(v[nIndex]);
			end
		end
	end

	ViewSetup_ResetComboList(1)
	ViewSetup_SelSettings:SetCurrentSelect(nowSettingsType - 1)
    ViewSetup_Set_Setup_Changed()
end

function ViewSetup_ResetComboList(nXX)

	ViewSetup_SelSettings:ResetList()
	ViewSetup_SelSettings:AddTextItem("#{XSYH_XML_7}",	1)			--????
	ViewSetup_SelSettings:AddTextItem("#{XSYH_XML_8}",	2)			--????	????
	ViewSetup_SelSettings:AddTextItem("#{XSYH_XML_9}",	3)			--????
	ViewSetup_SelSettings:AddTextItem("#{XSYH_XML_10}",	4)			--????

	if nXX == 0 then
		ViewSetup_SelSettings:AddTextItem("#{XSYH_XML_2}",5)			--???
	end
end

function ViewSetup_CheckSetting_Clicked(nIndex)
	if nIndex == 15 then 
		--»´∆¡ƒ£ Ω
		local temp = ViewSetup_Item_Check7:GetCheck();
		if(temp == 1) then
			ViewSetup_Item15:Disable();
		else
			ViewSetup_Item15:Enable();
		end
	elseif nIndex == 22 then 
		-- ÃÏø† ”Ω«
		ViewSetup_Sjbc_ClickEx()
	elseif nIndex == 11 then 
		-- »´∆¡∑∫π‚
		-- ViewSetup_Item_HDR:SetCheck(0);
		nowSettings[18] = 0
	elseif nIndex == 18 then 
		-- HDR
		ViewSetup_Item_Check4:SetCheck(0);
		nowSettings[11] = 0
	end
    ViewSetup_Set_Setup_Changed()
    ViewSetup_CheckSetting_ClickedEx( nIndex )
end

function ViewSetup_CheckSetting_ClickedEx(nIndex)
	local tabinfo = settingByIndex[nIndex];
	if not tabinfo then 
		PushDebugMessage( "ViewSetup_Check_Clicked allSettings is nil:"..(nIndex or "nil") )
		return
	end
	if tabinfo.ctrltype ~= "check" then 
		PushDebugMessage( "ViewSetup_Check_Clicked ctrltype is not check:"..(nIndex or "nil") )
		return
	end
	if not tabinfo.ctrl then 
		PushDebugMessage( "ViewSetup_Check_Clicked ctrl is nil:"..(nIndex or "nil") )
		return
	end
	nowSettings[tabinfo.index] = tabinfo.ctrl:GetCheck();
	ViewSetup_GlobalQualityCheck();
end

function ViewSetup_SetUp()
	--¥Úø™”≈ªØœÚµºΩÁ√Ê
	SystemSetup:OpenOptimize();
end

function ViewSetup_SoundSetup_Clicked()
	Variable:SetVariable("SetupUnionPos", ViewSetup_Frame:GetProperty("UnifiedPosition"), 1);

    if 1 == SystemSetup:GetIsConfigChanged() then
        PushEvent( "CONFIRM_SAVE_GAME_SETUP", 0, 1, "#{XTSZYH_111220_03}" )
    else
        SystemSetup:SoundSetup()
    end
end

function ViewSetup_GameSetup_Clicked()
	Variable:SetVariable("SetupUnionPos", ViewSetup_Frame:GetProperty("UnifiedPosition"), 1);

    if 1 == SystemSetup:GetIsConfigChanged() then
        PushEvent( "CONFIRM_SAVE_GAME_SETUP", 0, 2, "#{XTSZYH_111220_03}" )
    else
        SystemSetup:GameSetup()
    end
end

function ViewSetup_AcceSetup_Clicked()
	Variable:SetVariable("SetupUnionPos", ViewSetup_Frame:GetProperty("UnifiedPosition"), 1);

    if 1 == SystemSetup:GetIsConfigChanged() then
        PushEvent( "CONFIRM_SAVE_GAME_SETUP", 0, 3, "#{XTSZYH_111220_03}" )
    else
        SystemSetup:InputSetup()
    end
end

function ViewSetup_MenuButtons_Reset()
	-- ViewSetup_MenuBox_ViewSetup	:SetCheck(1)
	-- ViewSetup_MenuBox_SoundSetup:SetCheck(0)
	-- ViewSetup_MenuBox_GameSetup	:SetCheck(0)
	-- ViewSetup_MenuBox_AcceSetup	:SetCheck(0)
end

function ViewSetup_UIScale_SliderChanged()
--	local posText = string.format("%0.2f" , ViewSetup_UIScale_Control:GetPosition() + 0.8)
--	ViewSetup_UIScale_Text1:SetText("Àı∑≈±»¿˝"..posText)
end

function ViewSetup_ViewSetup_Clicked()

end

function ViewSetup_YingYong_Clicked()
    if 0 == SystemSetup:GetIsConfigChanged( ) then
        return
    end

    --- Œ™ ≤√¥†‚æ‰ª∞“™∑≈‘⁄†‚¿Ô£¨“ÚŒ™“™«Û°∞ƒ˙µƒ…Ë÷√“—æ≠…˙–ß°±∑≈‘⁄°∞≤ø∑÷…Ë÷√–Ë“™÷ÿ∆Ù°±«∞√Ê
    PushDebugMessage( "#{XTSZYH_111220_10}" )

   -- «∑Ò–Ë“™÷ÿ–¬∆Ù∂Ø
    local tabinfo = settingByIndex[16] -- ????
	local bNeedReset2 = false;
	if tabinfo and settingByIndex[ctrlName].ctrl then bNeedReset2 = tonumber(SystemSetup:View_GetData(tabinfo.str)) ~= (tonumber(tabinfo.ctrl:GetCheck())); end

	if(bNeedReset2) then
		PushDebugMessage("Vertical sync c•n kh∑i µng l’i");
	end

	for i, v in pairs(allSettings) do 
		if v.ctrl ~= nil then 
			if v.ctrltype == "slider" then 
				SystemSetup:View_SetData( v.str,v.ctrl:GetPosition() );
			elseif v.ctrltype == "check" then 
				SystemSetup:View_SetData( v.str,v.ctrl:GetCheck() );
			end
		else
			SystemSetup:View_SetData( v.str,nowSettings[v.index] );
		end
	end

	local bFullScreen = ViewSetup_Item_Check7:GetCheck();

	--µ±«∞∑«»´∆¡
	if (bFullScreen ~= 1) then
		local thisRes, thisResIndex = ViewSetup_Item15:GetCurrentSelect();

		if(thisRes == "800X600") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "800,600", 0);
		elseif(thisRes == "1024X768") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1024,768", 0);
		elseif(thisRes == "1280X720") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1280,720", 0);
		elseif(thisRes == "1280X1024") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1280,1024", 0);
		elseif(thisRes == "1920X1080") then
			Variable:SetVariable("View_Resoution", "", 0);
			Variable:SetVariable("View_Resoution", "1920,1080", 0);
		end
	end
    -- ViewSetup_YingYong:Disable()
    SystemSetup:SetIsConfigChanged( 0 )
	SystemSetup:Lua_ViewSetupToFile()
end

--- ±£¥Êµ±«∞”Œœ∑µƒ…Ë÷√
function ViewSetup_Save_Cur_Setup()
   	for i, v in pairs(allSettings) do 
		curViewSetupBackup[v.str] = SystemSetup:View_GetData(v.str);
	end
	--- ∑÷±Ê¬ …Ë÷√
    local resolution = Variable:GetVariable( "View_Resoution" );
    curViewSetupBackup[ "View_Resoution" ] = resolution;
end

--- ª÷∏¥÷Æ«∞µƒ…Ë÷√
function ViewSetup_Retrieve_Setup()
    for i, v in pairs(allSettings) do 
		SystemSetup:View_SetData(v.str, tonumber(curViewSetupBackup[v.str]));
	end
	--- ª÷∏¥∑÷±Ê¬ …Ë÷√
    local curResolution = Variable:GetVariable( "View_Resoution" );
    local bakResolution = curViewSetupBackup[ "View_Resoution" ]
    if curResolution ~= bakResolution and thisResIndex ~= 0 then
        Variable:SetVariable("View_Resoution", "", 0);
        Variable:SetVariable("View_Resoution", bakResolution, 0);
    end
end

function ViewSetup_Set_Setup_UnChanged()
    SystemSetup:SetIsConfigChanged( 0 )
	-- ViewSetup_YingYong:Disable()
end

function ViewSetup_Set_Setup_Changed()
    SystemSetup:SetIsConfigChanged( 1 )
	-- ViewSetup_YingYong:Enable()
end

function ViewSetup_Close_Clicked()
    if 1 == SystemSetup:GetIsConfigChanged() then
        PushEvent( "CONFIRM_SAVE_GAME_SETUP", 0, -1, "#{XTSZYH_111220_03}" )
    else
        this:Hide()
    end
end

function ViewSetup_Cancel_Clicked()
    ViewSetup_Close_Clicked()
end
