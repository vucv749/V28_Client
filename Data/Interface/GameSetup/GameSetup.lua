local g_PreAlpha = "0.8";
local g_Track_PreAlpha = "1.0";
--===============================================
-- PreLoad()
--===============================================
function GameSetup_PreLoad()

	this:RegisterEvent("TOGLE_GAMESETUP")
	this:RegisterEvent("TOGLE_SYSTEMFRAME")
	this:RegisterEvent("TOGLE_SOUNDSETUP")
	this:RegisterEvent("TOGLE_VIEWSETUP")

	this:RegisterEvent("LEVELUPLOCK_UPDATA")

end

--===============================================
-- OnLoad()
--===============================================
function GameSetup_OnLoad()
	GameSetup_ChatBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_ChatBkg_Slider:SetProperty( "PageSize","0.1" );
	GameSetup_ChatBkg_Slider:SetProperty( "StepSize","0.1" );
	GameSetup_TrackBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_TrackBkg_Slider:SetProperty( "PageSize","0.0" );
	GameSetup_TrackBkg_Slider:SetProperty( "StepSize","0.1" );
end

--===============================================
-- OnEvent()
--===============================================
function GameSetup_OnEvent(event)
	
	if event == "TOGLE_GAMESETUP" then
		this:Show()
		local old = {SystemSetup:GameGetData()}
		g_PreAlpha = tostring(old[10])
		g_Track_PreAlpha = tostring(old[17])
		GameSetup_UpdateFrame()
	elseif event == "TOGLE_VIEWSETUP" and this:IsVisible() then
		GameSetup_Cancel_Clicked()
	elseif event == "TOGLE_SYSTEMFRAME" and this:IsVisible() then
		GameSetup_Cancel_Clicked()
	elseif event == "TOGLE_SOUNDSETUP" and this:IsVisible() then
		GameSetup_Cancel_Clicked()
	elseif event == "LEVELUPLOCK_UPDATA" then
		GameSetup_LevelUpLockUpdate()
	end

end

--===============================================
-- UpdateFrame()
--===============================================
function GameSetup_UpdateFrame()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15,n16,f17,n18,n31,n34,n21,nRefActMood = SystemSetup:GameGetData();
	
	GameSetup_Item1						:SetCheck(n1);					-- ??????
	GameSetup_Item2						:SetCheck(n2);					-- ??????
	GameSetup_Item3						:SetCheck(n3);					-- ???????
	GameSetup_Item4						:SetCheck(n4);					-- ????
	GameSetup_Item5						:SetCheck(n5);					-- ??????
	GameSetup_Item6						:SetCheck(n6);					-- ???????
	GameSetup_Item7						:SetCheck(n7);					-- ??????
	GameSetup_Item8						:SetCheck(n8);					-- ??????
	GameSetup_Item9						:SetCheck(n9);					-- ?????
	GameSetup_ChatBkg_Slider	:SetPosition(f10);			-- ???????
	GameSetup_Item11					:SetCheck(n11);					-- ???????
	GameSetup_Lock						:SetCheck(n12);					-- ?????
	-- GameSetup_Scene						:SetCheck(n13);					-- 快速切换场景
	GameSetup_ChatItem				:SetCheck(n15);					-- ???????
	GameSetup_TeamFollow			:SetCheck(n16);						-- ????????
	GameSetup_TrackBkg_Slider	:SetPosition(f17);	--???????????
	GameSetup_FunctionBar_3:SetCheck(n18)
	GameSetup_cooltime:SetCheck(n31)
	--GameSetup_ShowNotice:SetCheck(n34)
	
	GameSetup_Item12:SetCheck(nRefActMood)  --??????
	
	local nState,nFlag,nTime = Lua_LevelUpLock_GetState()--???
	n35 = GameSetup_FunctionBar_4:SetCheck(nFlag)--???
	GameSetup_LevelUpLockUpdate()--?????tip??
	
	GameSetup_Upload:SetCheck(n21)
end

--===============================================
-- GameSetup_Accept
-- 确定
--===============================================
function GameSetup_Accept_Clicked()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15,n16,f17,n18,n31,n34,n21,nRefActMood = SystemSetup:GameGetData();

	n1 = GameSetup_Item1:GetCheck();									-- ??????
	n2 = GameSetup_Item2:GetCheck();                  -- ??????       
	n3 = GameSetup_Item3:GetCheck();                  -- ???????     
	n4 = GameSetup_Item4:GetCheck();                  -- ????           
	n5 = GameSetup_Item5:GetCheck();                  -- ??????       
	n6 = GameSetup_Item6:GetCheck();                  -- ???????     
	n7 = GameSetup_Item7:GetCheck();                  -- ??????       
	n8 = GameSetup_Item8:GetCheck();                  -- ??????       
	n9 = GameSetup_Item9:GetCheck();                  -- ?????
	f10 = GameSetup_ChatBkg_Slider:GetPosition();     -- ???????
	n11 = GameSetup_Item11:GetCheck();                -- ???????  
	n12 = GameSetup_Lock:GetCheck();                  -- ?????         
	n13 = 0--GameSetup_Scene:GetCheck();                 -- ??????       
	n15 = GameSetup_ChatItem:GetCheck();              -- ???????  
	n16 = GameSetup_TeamFollow:GetCheck();						-- ????????	   
	f17 = GameSetup_TrackBkg_Slider:GetPosition();	--???????????
	n18 = GameSetup_FunctionBar_3:GetCheck()
	n31 = GameSetup_cooltime:GetCheck()  --????
	--n34 = GameSetup_ShowNotice:GetCheck()
	n35 = GameSetup_FunctionBar_4:GetCheck()--???
	n21 = GameSetup_Upload:GetCheck()
	nRefActMood = GameSetup_Item12:GetCheck()

	SystemSetup:SaveGameSetup(n1,n2,n3,n4,n5,n6,n7,n8,n9,tonumber(f10),n11,n12,n13,n14,n15,n16,f17,n18,n31,n34,n35,n21,nRefActMood)
	
	g_PreAlpha = f10
	g_Track_PreAlpha = f17

	this:Hide()
end

--===============================================
-- GameSetup_Cancel
-- 取消
--===============================================
function GameSetup_Cancel_Clicked()

	GameSetup_ChatBkg_Slider:SetPosition(g_PreAlpha)
	Talk:HandleMainBarAction("chatbkg",g_PreAlpha)
	DataPool:HandleGameSetupAction(g_Track_PreAlpha)
	this:Hide()

end

--===============================================
-- GameSetup_DefaultSetting
-- 恢复默认
--===============================================
function GameSetup_Default_Clicked()

	GameSetup_Item1						:SetCheck(0);							-- ??????
	GameSetup_Item2						:SetCheck(0);             -- ??????
	GameSetup_Item3						:SetCheck(0);             -- ???????
	GameSetup_Item4						:SetCheck(0);             -- ????
	GameSetup_Item5						:SetCheck(0);             -- ??????
	GameSetup_Item6						:SetCheck(0);             -- ???????
	GameSetup_Item7						:SetCheck(0);             -- ??????
	GameSetup_Item8						:SetCheck(0);             -- ??????
	if not GameProduceLogin:IsYunGameMobileClient() then 
		GameSetup_Item9					:SetCheck(0);             -- ?????
	end
	GameSetup_ChatBkg_Slider	:SetPosition(1);       		-- ???????
	GameSetup_Item11					:SetCheck(1);							-- ???????
	GameSetup_Lock						:SetCheck(0);             -- ?????
	-- GameSetup_Scene						:SetCheck(1);             -- 快速切换场景
	GameSetup_ChatItem				:SetCheck(0);             -- ???????
	GameSetup_TeamFollow			:SetCheck(0);-- ????????
	GameSetup_TrackBkg_Slider	:SetPosition(1)
	GameSetup_FunctionBar_3:SetCheck(0)
	GameSetup_cooltime:SetCheck(0)
	--GameSetup_ShowNotice:SetCheck(1)
	GameSetup_FunctionBar_4:SetCheck(0)--???
	GameSetup_Upload					:SetCheck(1)
end

--===============================================
-- GameSetup_ChatBkg_Slider
-- 设置聊天背景透明度
--===============================================
function GameSetup_ChatBkg_Change()
	local pos = GameSetup_ChatBkg_Slider:GetPosition();
	Talk:HandleMainBarAction("chatbkg",pos);
end

function GameSetup_TrackBkg_Change()
	local pos = GameSetup_TrackBkg_Slider:GetPosition();
	DataPool:HandleGameSetupAction(pos);
end

function GameSetup_CheckSetting_Clicked()

end

function GameSetup_LevelUpLock_Clicked()

	local bChange = 1 --???????????

	--判断电话密保和二级密码保护
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		bChange = 0
	end

	--判断等级 
	local nLevel = Player:GetData( "LEVEL" )
	if( nLevel < 40 ) then
		PushDebugMessage("#{JZSJ_220321_07}")
		bChange = 0
	end

	if(bChange == 0)then--?????????? ?????? ??????????,????????????,???????
		local nState,nFlag,nTime = Lua_LevelUpLock_GetState()
		GameSetup_FunctionBar_4:SetCheck(nFlag)
	end
end

function GameSetup_LevelUpLockUpdate()
	local nState,nFlag,nTime = Lua_LevelUpLock_GetState()
	if(nState == 2)then
		GameSetup_FunctionBar_4_Text:SetText("#{JZSJ_220321_04}")
		GameSetup_FunctionBar_4_Text:SetToolTip(ScriptGlobal_Format("#{JZSJ_220321_05}",nTime))
	else
		GameSetup_FunctionBar_4_Text:SetText("#{JZSJ_220321_02}")
		GameSetup_FunctionBar_4_Text:SetToolTip("#{JZSJ_220321_03}")
	end
end


function GameSetup_ChatActive_Clicked()
	if GameProduceLogin:IsYunGameMobileClient() then 
		PushDebugMessage("#{YYTL_221013_02}")
		GameSetup_Item9:SetCheck(1)
	end
end
