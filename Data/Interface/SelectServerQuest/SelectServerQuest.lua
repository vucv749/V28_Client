

------------------------------------------------------------------------------------------------------
--
-- 全局变量区
--
--
local g_iYesNoType = -1;	-- yes-no 对话框类型
													-- -1 -- 普通信息提示
													-- 0 - 退出游戏
													-- 1 - 删除角色
													-- 2 - 更换帐号
													-- 3 - 断开网络
													-- 4 - 确认是否删除10级以上玩家
													-- 5 - 7天内提醒删除10级以上玩家
													-- 6 - 7天后，14天内提醒删除10级以上玩家
													-- 7 - 是否删除10级以下玩家
													-- 8 删除玩家
													-- 9 是否注册
													--29 禁止登录
													--30 3天禁止登录
													--31 账号冻结
													--32 玩家在其它服在线
													--33 玩家已在线
													--34 玩家未认证手机
													--35 更新服务器列表
													--36 密码错误
													--37 限制登录，未实名
													--38 限制登录，注销帐号
													--39 限制登录，实名格式不对
													--40 激活
													--41 1009激活
													--42 三精材料批量合成
													--43 润魂石批量合成
													--44 灵兽丹合成
													--45 时装染色二次确认
													--46 时装染色绑定二次确认
													--47 使用国家防沉迷信息库且防沉迷信息不正确
													--48 限制登录，未成年人，未满18岁 
													--49 限制登录，未成年人，未满18岁
													--50 限制登录，正在审核中
													--51 封魂录
													--52 魂冰珠批量合成
													--53 五一放烟花
													--54 新门派扶持
													--60 圣诞应景-趣味圣诞树
													--62 春节打工兔
													--65 结婚交换信物公告二次确认
													--66 变性
													--76 代币整合兑换召唤券，二次确认
													--77 二次确认
													--78 二次确认
													--79 二次确认
local g_strMessageData;

local g_bagIndex = -1
local g_bagIndex2 = -1
local g_item = -1
local g_itemNum = -1
local g_objCared = -1
local g_pos = -1
local g_YanHua_From = -1
local g_YanHua_Param = -1

local CaiLiaoCompound_Data = {0, 0, 0, 0}			-- 三精材料批量合成 缓存数据
local DaGongTu_Data = {0, 0}						-- 春节打工兔 缓存数据
local RunHunShiCompound_Data = {0, 0, 0, 0}			-- 润魂石批量合成 缓存数据
local HunBingZhuCompound_Data = {0, 0, 0}			-- 魂冰珠批量合成 缓存数据
local LingShouDanCompound_Data = {0, 0, 0, 0}		-- 灵兽丹合成 缓存数据
local FengHunLu_Data = {0, 0}						-- 封魂录礼包 缓存数据
local g_SelecQuest_Data= {0,0,0,0}
local g_ZBS_Data = {-1, -1, -1}
local changchunlibao_data = {0,0}
local g_DLZX_Data = {-1, -1, -1, -1, -1, -1, -1}		-- 帝陵再现PVP活动

-- 注册onLoad事件
function LoginSelectServerQuest_PreLoad()

	-- 打开界面
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO");

	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_SYSTEM_INFO");


	-- 点击确定按钮关闭网络
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET");

	-- 显示不带按钮的信息
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");
	-- 显示yes-no信息
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_YESNO");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_OK");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CANCEL");
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CLOSE");
	this:RegisterEvent("UI_COMMAND");
	-- 珍兽装备分解确认
	this:RegisterEvent("PET_EQUIP_DEPART_CONFIRM")
	-- 绑定元宝商店玩家绑定元宝不足时，二次确认的界面
	this:RegisterEvent("BINDYUANBAO_NOTENOUGH_YESNO")
	this:RegisterEvent("DISPLACEGEM_CONFIRM",true)
	this:RegisterEvent( "DISPLACE_CLOSE_MSGBOX",true )
	--时装染色二次确认
	this:RegisterEvent( "DRESSPAINT_SELECTSERVER")
	this:RegisterEvent( "DRESSPAINT_BINDDRESS")
	this:RegisterEvent( "WEGAME_FORCEQUIT")

	--结婚交换信物公告二次确认
	this:RegisterEvent( "PLDGELOVE_CONFIRM")
end

function LoginSelectServerQuest_OnLoad()

	-- 设置总是在最上层显示
	SelectServerQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");

	--


end
function LoginSelectUpdateRect()
	local nWidth, nHeight = SelectServerQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	local nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	SelectServerQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	AxTrace( 0,0, "LastWindowSize ="..tostring( nWindowWidth )..","..tostring(nWindowHeight) );
	--SelectServerQuest_Frame_sub:SetWindowSize( nWindowWidth, nWindowHeight );
end

local TimerArg = "";
local g_QuitType = 0;    --增加3， 这种类型的和类型0的区别是没取消按钮的！
local g_bIsQuitMsgBox = 0;
-- OnEvent
function LoginSelectServerQuest_OnEvent(event)

	--如果处于显示中，不要初始化,否则UI_COMMAND来出现bug
	if (not this:IsVisible()) then
	
		g_bIsQuitMsgBox = 0;
    SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )

		--AxTrace( 0,0, "get event");
		SelectServerQuest_Button2:Hide();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_LostPassword:Hide()
		SelectServerQuest_Time_Text : Hide();
		SelectServerQuest_InfoWindow:Show();
	
	end
	
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO" ) then

		g_iYesNoType = -1;
		--AxTrace( 0,0, "显示系统信息");
		if( arg1 ~= "WAITFORQUIT" ) then
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
		end
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()


		if( arg1 == "USERONLINE" ) then
			g_iYesNoType = 33;
		  SelectServerQuest_LostPassword:Show();
		  SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "OTHERSEVER_ONLINE") then
			g_iYesNoType = 32;
		  SelectServerQuest_LostPassword:Show();
		  SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "NO_IPHONE") then
			g_iYesNoType = 34;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_130}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "MUST_STOPTIME") then
			g_iYesNoType = 31;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		  arg1 = nil;
		elseif (arg1 == "UserId_Password_Err") then
			g_iYesNoType = 36;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{WJMM_090427_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "NO_SHIMING") then
			g_iYesNoType = 37;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_16}");
			SelectServerQuest_LostPassword:Enable()

		elseif (arg1 == "CN_REMOVEACCOUNT") then
			g_iYesNoType = 38;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_12}");
			SelectServerQuest_LostPassword:Enable()
			
		elseif (arg1 == "CN_SHIMING_INVALID") then
			g_iYesNoType = 39;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_14}");
			SelectServerQuest_LostPassword:Enable()
			
		elseif (arg1 == "OB_REGISTER_LOGIN") then
			g_iYesNoType = 40;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{LSOB_200304_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "TLBBGREEN_NOT_ACTIVE_TLPH_TG") then
			g_iYesNoType = 41;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{LSOB_200304_02}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "LOGIN_FCM_CERTNUM_CHECKERROR") then		--47 使用国家防沉迷信息库且防沉迷信息不正确
			g_iYesNoType = 47;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_21}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERAGE_18") then
			g_iYesNoType = 48;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_23}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERAGE_18_2021") then
			g_iYesNoType = 49;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_25}");
			SelectServerQuest_LostPassword:Enable()
		elseif (arg1 == "CN_UNDERREVIEW_2021") then
			g_iYesNoType = 50;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{CMXT_191210_27}");
			SelectServerQuest_LostPassword:Enable()
		elseif(arg1 == "USERFROMMAINPRO") then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Hide();
		    SelectServerQuest_Button2:Hide();
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "MIBAOERROR" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(30));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "TURNOVER" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(8));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "WAITFORQUIT" ) then
		    if(arg3~=nil and tonumber(arg3)~=nil)then
			if(tonumber(arg3)>0)then
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(10));
				SelectServerQuest_InfoWindow:SetText("10秒后退出游戏！");
				LoginSelectUpdateRect();

			else
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
				SelectServerQuest_InfoWindow:SetText("3秒后退出游戏！");
				LoginSelectUpdateRect();
			end
		    else
			 SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
			 SelectServerQuest_InfoWindow:SetText("3秒后退出游戏！");
			LoginSelectUpdateRect();
		    end
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:SetText("取消");
		    SelectServerQuest_Button1:Show();
		    SelectServerQuest_Button1:Enable();
		    TimerArg = arg1;
		    g_QuitType = tonumber(arg2);
		    if g_QuitType == 3 then
		    	SelectServerQuest_Button1:Hide();
		    end
		    g_bIsQuitMsgBox = 1;
		    arg1 = nil;
		elseif( arg1 == "LoginCounting" ) then
				local countTime = tonumber(arg2)
				if(countTime >= 0 and countTime <= 20000) then--逻辑上来说arg2应该是在0到20000之间的。
					countTime = math.floor(countTime/1000) + 1
					if countTime==21 then
						countTime=20
					end
					SelectServerQuest_Time_Text : SetProperty("Timer",tostring(countTime));
		    	SelectServerQuest_Time_Text : Show()
		    	SelectServerQuest_Button1:Disable()
		    	TimerArg = arg1;
				end
			  arg1 = nil
			  arg2 = nil
		elseif(arg1 == "ThreedAccForbit") then
			g_iYesNoType = 30;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_131}");
			SelectServerQuest_LostPassword:Enable()
			TimerArg = nil;
		    arg1 = nil;
		elseif(arg1 == "LOGNR_Forbit") then
			g_iYesNoType = 29;
			SelectServerQuest_LostPassword:Show();
			SelectServerQuest_LostPassword:SetText("#{DLLC_180306_131}");
			SelectServerQuest_LostPassword:Enable()
			TimerArg = nil;
		    arg1 = nil;
		else
		    TimerArg = nil;
		    arg1 = nil;
		    SelectServerQuest_Time_Text : Hide()
		end

		this:Show();
		return;
	end




	if( event == "GAMELOGIN_CLOSE_SYSTEM_INFO") then

		g_iYesNoType = -1;
		this:Hide();
		return;
	end

	--AxTrace( 0,0, "event yes no");
	if( event == "GAMELOGIN_SYSTEM_INFO_YESNO") then

		--AxTrace( 0,0, "显示yes no");
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		g_iYesNoType = tonumber(arg1);

		if g_iYesNoType == 20 and arg2 ~= nil  and arg3 ~= nil then
			g_objCared = tonumber(arg2)
			g_bagIndex = tonumber(arg3)
		end
		
		if g_iYesNoType == 66 then --变性
			g_objCared = tonumber(arg2)
		end		
		
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		return;
	end
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON" ) then

	    if( nil ~= arg1 ) then
	        local strArg = tostring( arg1 )
			if( strArg == "CharSel_EnterGame" ) then
			--if( strArg == "CharSel_EnterGam" ) then
				SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.900000,-118.000000}}" )
			end
		arg1 = nil;
	    end

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		this:Show();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_OK" ) then
		AxTrace( 0,0,"GAMELOGIN_SYSTEM_INFO_OK" );
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		if g_iYesNoType == 0 then
			SelectServerQuest_Button1:SetText("关闭");
		else
			SelectServerQuest_Button1:SetText("确定");
		end
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CANCEL" ) then

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("取消");
		this:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CLOSE" ) then

		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("关闭");
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end



	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET") then

		--AxTrace( 0,0, "需要关闭网络.");
		g_iYesNoType = 3;
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		this:Show();
		return;
	end

	-- 血浴神兵——神器铸造
	if ( event == "UI_COMMAND" and tonumber(arg0) == 13906) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263#{XYSB_080925_001}");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()

		this:Show();
	end

	-- 血浴神兵——神器重铸
	if ( event == "UI_COMMAND" and tonumber(arg0) == 12032203) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cfff263重新冶炼后神器将被#G销毁#cfff263，确认提交请关闭本提示后再次点击#G确定#cfff263按钮。");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()

		this:Show();
	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 300077) then
		g_iYesNoType = 12;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{SLZSDSJ_090915_2}%s#{SLZSDSJ_090915_3}%d#{SLZSDSJ_090915_4}",petClass,slzExp)
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			--升级界面不在这里，在PetShelizi_Msg中
			return
		end

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	--天元金丹 hzp
	if( event == "UI_COMMAND" and tonumber(arg0) == 332004) then
		g_iYesNoType = 13;
		g_bagIndex = Get_XParam_INT( 0 )
		SelectServerQuest_InfoWindow:SetText("#{TSXF_090408_03}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	--暗器升级
	if( event == "UI_COMMAND" and tonumber(arg0) == 260001) then
		g_iYesNoType = -1;
		g_bagIndex = Get_XParam_INT( 0 );
		g_bagIndex2 = Get_XParam_INT( 1 )
		SelectServerQuest_InfoWindow:SetText("#{AQSJ_090709_10}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();

	end

	--神器升级
	if( event == "UI_COMMAND" and tonumber(arg0) == 500505) then
		g_iYesNoType = -1;
		g_bagIndex = Get_XParam_INT( 0 );
		g_bagIndex2 = Get_XParam_INT( 1 )
		SelectServerQuest_InfoWindow:SetText("#{SQSJ_0708_09}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();
	end

	--五一放烟花
	if( event == "UI_COMMAND" and tonumber(arg0) == 89312103) then
		g_iYesNoType = 53;
		g_YanHua_From = Get_XParam_INT( 0 );
		g_YanHua_Param = Get_XParam_INT( 1 );
		SelectServerQuest_InfoWindow:SetText("#{FYH_220407_76}");

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button2:Enable()
		this:Show();
	end

	--新舍利子 add by hzp 09-06-29
	if( event == "UI_COMMAND" and tonumber(arg0) == 300088) then
		g_iYesNoType = 14;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_21}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_28}%d#{ZSKSSJ_081113_29}%d#{ZSKSSJ_081113_30}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		end

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 808147) then
		g_iYesNoType = 24;
		g_objCared = Get_XParam_INT(0)
		g_bagIndex = Get_XParam_INT(1)
		local itemName = Get_XParam_STR(0)
		local strText = string.format("#{MYHK_100128_03}%s#{MYHK_100128_04}",itemName)
		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect();

		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();

	end

	if (event == "PET_EQUIP_DEPART_CONFIRM") then
		local equipname = arg0
		g_iYesNoType = tonumber(arg1)
		SelectServerQuest_InfoWindow:SetText("#{ZSZBSJ_XML_17}" .. equipname .. "#{ZSZBSJ_XML_18}")
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
	end

	if (event == "BINDYUANBAO_NOTENOUGH_YESNO" ) then
		g_iYesNoType = tonumber(arg0)
		g_item 		 = tonumber(arg1)
		g_itemNum 	 = tonumber(arg2)
		local nPriceOne = tonumber(arg3)
		local nNeedBindYuanbao = nPriceOne * g_itemNum
		g_pos = tonumber(arg4)
		local name = arg6
		local nHaveBindYuanbao = Player : GetData( "BIND_YUANBAO" )
		local nCostYuanbao = nNeedBindYuanbao - nHaveBindYuanbao
		--确定你是否购买这个东西 .. g_itemNum.."#{ZSZBSJ_XML_17}"
		SelectServerQuest_InfoWindow:SetText("#{BDYB_XML_1}#G" ..name .."#{BDYB_XML_2}#G"..nNeedBindYuanbao.."#{BDYB_XML_3}#G"..nHaveBindYuanbao.."#{BDYB_XML_4}#G"..nCostYuanbao.."#{BDYB_XML_5}")
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
	end

	if (event == "DISPLACEGEM_CONFIRM") then
		g_iYesNoType = tonumber(arg0)
		SelectServerQuest_Frame_sub:SetProperty( "UnifiedSize", "{{0.000000,346.000000},{0.000000,128.000000}}" )
		local infotype = tonumber(arg1);
		if infotype == 1 then
			SelectServerQuest_InfoWindow:SetText("#{CLJY_120813_04}");
		else
			SelectServerQuest_InfoWindow:SetText("#{BSQKY_20110506_22}");
		end
		SelectServerQuest_Button1:SetText("#{INTERFACE_XML_1173}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable()
		this:Show();
	end
	if (event == "DISPLACE_CLOSE_MSGBOX") then
		g_iYesNoType = -1
		this:Hide();
	end
	-- 元宝快捷强化的二次确认
	if( event == "UI_COMMAND" and tonumber(arg0) == 80926201) then
		g_iYesNoType = 30
		g_bagIndex = Get_XParam_INT( 0 )
		local strMsg = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strMsg)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("确定")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()
		SelectServerQuest_Button2:SetText("取消")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	-- 三精材料批量合成
	if( event == "UI_COMMAND" and tonumber(arg0) == 920170826) then
		g_iYesNoType = 42

		CaiLiaoCompound_Data[1] =  Get_XParam_INT(0)
		CaiLiaoCompound_Data[2] =  Get_XParam_INT(1)
		CaiLiaoCompound_Data[3] =  Get_XParam_INT(2)
		CaiLiaoCompound_Data[4] =  Get_XParam_INT(3)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("确定")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("取消")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- 润魂石批量合成
	if( event == "UI_COMMAND" and tonumber(arg0) == 2016110702) then
		g_iYesNoType = 43

		RunHunShiCompound_Data[1] =  Get_XParam_INT(0)
		RunHunShiCompound_Data[2] =  Get_XParam_INT(1)
		RunHunShiCompound_Data[3] =  Get_XParam_INT(2)
		RunHunShiCompound_Data[4] =  Get_XParam_INT(3)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("确定")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("取消")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- 魂冰珠批量合成
	if( event == "UI_COMMAND" and tonumber(arg0) == 79007502) then
		g_iYesNoType = 52

		HunBingZhuCompound_Data[1] =  Get_XParam_INT(0)
		HunBingZhuCompound_Data[2] =  Get_XParam_INT(1)
		HunBingZhuCompound_Data[3] =  Get_XParam_INT(2)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("确定")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("取消")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- 灵兽丹合成
	if( event == "UI_COMMAND" and tonumber(arg0) == 31111201) then
		g_iYesNoType = 44

		LingShouDanCompound_Data[1] =  Get_XParam_INT(0)
		LingShouDanCompound_Data[2] =  Get_XParam_INT(1)
		local strText 			=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("确定")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("取消")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	if ( event == "DRESSPAINT_SELECTSERVER" ) then
		g_iYesNoType = 45
		local strDressPaint = ScriptGlobal_Format("#{SZRSYH_120912_20}",tostring(arg0))
		SelectServerQuest_InfoWindow:SetText(strDressPaint)
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("#{SZRSYH_210315_02}")
		this:Show()
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button2:Hide()
		return;
	end

	if ( event == "DRESSPAINT_BINDDRESS" ) then
		g_iYesNoType = 46
		SelectServerQuest_InfoWindow:SetText("#{YJRS_140613_19}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{SZRSYH_210315_04}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{SZRSYH_210315_05}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return;
	end
	if ( event == "WEGAME_FORCEQUIT" ) then
		EnterQuitWait(3);
		return
	end

	-- 封魂录礼包
	if( event == "UI_COMMAND" and tonumber(arg0) == 79101102) then

		-- 0 关闭, 1 打开, 2 刷新, 3 二次确认框
		local nOpType 	= Get_XParam_INT(0)
		if nil == nOpType or 3 ~= nOpType then
			return
		end


		g_iYesNoType = 51

		FengHunLu_Data[1] 	=  Get_XParam_INT(1)
		FengHunLu_Data[2] 	=  Get_XParam_INT(2)
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{XYSHFC_20211229_160}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{XYSHFC_20211229_161}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end
	
	-- 封魂录礼包
	if( event == "UI_COMMAND" and tonumber(arg0) == 88892103) then 

		g_iYesNoType = 54

		g_SelecQuest_Data[1] 	=  Get_XParam_INT(0) 
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()
 				
		SelectServerQuest_Button1:SetText("#{MPFC_220622_122}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{MPFC_220622_123}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()

	end

	-- 争霸赛 邀请玩家入队
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022090601) then
		g_iYesNoType = 55

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)
		g_ZBS_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_124}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_125}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 争霸赛 解散战队
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022090801) then
		g_iYesNoType = 56

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 争霸赛 请离战队
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022091401) then
		g_iYesNoType = 57

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 争霸赛 退出战队
	if (event == "UI_COMMAND" and tonumber(arg0) == 2022091501) then
		g_iYesNoType = 58

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{WCBZ_180128_306}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{WCBZ_180128_133}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 89004901) then
		--圣诞应景-趣味圣诞树
		g_iYesNoType = 60
		g_bagIndex = Get_XParam_INT(0);
		SelectServerQuest_InfoWindow:SetText("#{QWSD_20221017_35}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QWSD_20221017_36}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QWSD_20221017_37}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end


	-- 天机城（不老殿） 跨服PVP 入场确认
	if (event == "UI_COMMAND" and tonumber(arg0) == 89011104) then
		g_iYesNoType = 61

		g_ZBS_Data[1] = Get_XParam_INT(0)
		g_ZBS_Data[2] = Get_XParam_INT(1)

		SelectServerQuest_InfoWindow:SetText("#{BLDPVP_221214_33}")

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{BLDPVP_221214_34}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{BLDPVP_221214_35}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 79109002) then
		-- 春节打工兔
		g_iYesNoType = 62
		DaGongTu_Data[1] = Get_XParam_INT(0);
		DaGongTu_Data[2] = Get_XParam_INT(1);
		SelectServerQuest_InfoWindow:SetText("#{YCDGT_221109_27}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{YCDGT_221109_28}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{YCDGT_221109_29}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end
	
	-- 长春礼包
	if( event == "UI_COMMAND" and tonumber(arg0) == 89017402) then

		g_iYesNoType = 63

		changchunlibao_data[1] 	=  Get_XParam_INT(0)
		changchunlibao_data[2] 	=  Get_XParam_INT(1)
		local strText 		=  Get_XParam_STR(0)

		SelectServerQuest_InfoWindow:SetText( strText )

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{ZXJQ_221225_553}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{ZXJQ_221225_554}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()
		
		this:Show()

	end

	-- 帝陵再现PVP活动
	if( event == "UI_COMMAND" and tonumber(arg0) == 99826001) then
		g_iYesNoType = 64
		
		g_DLZX_Data[1] = Get_XParam_INT(0)
		g_DLZX_Data[2] = Get_XParam_INT(1)
		g_DLZX_Data[3] = Get_XParam_INT(2)
		g_DLZX_Data[4] = Get_XParam_INT(3)
		g_DLZX_Data[5] = Get_XParam_INT(4)
		g_DLZX_Data[6] = Get_XParam_INT(5)
		g_DLZX_Data[7] = Get_XParam_INT(6)

		local msg = ScriptGlobal_Format("#{DLZX_230314_22}", g_DLZX_Data[3], g_DLZX_Data[4], g_DLZX_Data[5])
		SelectServerQuest_InfoWindow:SetText(msg)
		LoginSelectUpdateRect()
		SelectServerQuest_Button1:SetText("#{DLZX_230314_23}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button2:SetText("#{DLZX_230314_24}")
		SelectServerQuest_Button2:Show()
		this:Show()
	end


	if ( event == "PLDGELOVE_CONFIRM" ) then
		--结婚交换信物公告二次确认
		g_iYesNoType = 65
		g_bagIndex = tonumber(arg0)
		SelectServerQuest_InfoWindow:SetText("#{JHYH_230330_187}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{JHYH_230330_188}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{JHYH_230330_189}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end


	-- 新6v6 邀请入队
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849701) then
		g_iYesNoType = 70

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_75}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_76}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 新6v6 解散战队
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849702) then
		g_iYesNoType = 71

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		SelectServerQuest_InfoWindow:SetText("#{JZGN_20230710_98}")

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_99}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_100}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 新6v6 退出战队
	if (event == "UI_COMMAND" and tonumber(arg0) == 99849704) then
		g_iYesNoType = 72

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{JZGN_20230710_99}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{JZGN_20230710_100}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 99853701) then
		g_iYesNoType = 73
		g_bagIndex = Get_XParam_INT(0);
		SelectServerQuest_InfoWindow:SetText("#{QWSD_20221017_35}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QWSD_20221017_36}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QWSD_20221017_37}");
		SelectServerQuest_Button2:Show();
		this:Show();
	end

	-- 跨服爬塔夺宝 领奖（个人结算）
	if (event == "UI_COMMAND" and tonumber(arg0) == 99856301) then
		g_iYesNoType = 74

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end
	-- 跨服爬塔夺宝 领奖（帮会结算）
	if (event == "UI_COMMAND" and tonumber(arg0) == 99856302) then
		g_iYesNoType = 75

		g_SelecQuest_Data[1] = Get_XParam_INT(0)
		g_SelecQuest_Data[2] = Get_XParam_INT(1)
		g_SelecQuest_Data[3] = Get_XParam_INT(2)

		local strText = Get_XParam_STR(0)
		SelectServerQuest_InfoWindow:SetText(strText)

		LoginSelectUpdateRect()

		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}")
		SelectServerQuest_Button1:Show()
		SelectServerQuest_Button1:Enable()

		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}")
		SelectServerQuest_Button2:Show()
		SelectServerQuest_Button2:Enable()

		this:Show()
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99873903) then
		g_iYesNoType = 76
		local ItemId;
		local changeStrFlag;
		--此处传入的typeID,非bagIndex
		g_bagIndex = Get_XParam_INT(0);
		changeStrFlag = Get_XParam_INT(1);
		if g_bagIndex == 1 then
			ItemId = 38003116
		else
			ItemId = 38003117
end
		local text
		if changeStrFlag == 1 then
			text = ScriptGlobal_Format("#{ZNDB_230215_120}",1,PlayerPackage:GetItemName( ItemId ));
		else
			text = ScriptGlobal_Format("#{ZNDB_230215_152}",PlayerPackage:GetItemName( ItemId ));
		end
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{PTDB_231225_81}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{PTDB_231225_82}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99883104) then
		g_iYesNoType = 77
		--传入界面Index
		g_SelecQuest_Data[1] = tonumber(arg1);
		g_SelecQuest_Data[2] = tonumber(arg2);
		local ItemName = tostring(arg3)
		local text = ScriptGlobal_Format("#{QEYD_240402_160}",ItemName);
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99883105) then
		g_iYesNoType = 78
		g_SelecQuest_Data[1] = tonumber(arg1);
		local text = ScriptGlobal_Format("#{QEYD_240402_112}",PlayerPackage:GetItemName( 38003158 ));
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

	if ( event == "UI_COMMAND" and tonumber(arg0) == 99926202) then
		g_iYesNoType = 79
		--传入界面Index
		g_SelecQuest_Data[1] = tonumber(arg1);
		g_SelecQuest_Data[2] = tonumber(arg2);
		local ItemName = tostring(arg3)
		local text = ScriptGlobal_Format("#{QEYD_240402_160}",ItemName);
		SelectServerQuest_InfoWindow:SetText(text);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("#{QEYD_240402_154}");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:SetText("#{QEYD_240402_155}");
		SelectServerQuest_Button2:Show();
		this:Show();
		return
	end

end

function SelectServerQuest_LostPassWord()
	
	if g_iYesNoType == 29 then
		if GameProduceLogin:IsWeGameClient() <= 0 then
			GameProduceLogin:OpenURL(GetWeblink("WEB_THREEDDAYFORBIT"))
		else
			GameProduceLogin:OpenURL(GetWeblink("WEB_WEGAME_KF"))
		end
	elseif g_iYesNoType == 30 then
		if GameProduceLogin:IsWeGameClient() <= 0 then
			GameProduceLogin:OpenURL(GetWeblink("WEB_THREEDDAYFORBIT"))
		else
			GameProduceLogin:OpenURL(GetWeblink("WEB_WEGAME_KF"))
		end
	elseif g_iYesNoType == 31 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))	
	elseif g_iYesNoType == 32 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
	elseif g_iYesNoType == 33 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
	elseif g_iYesNoType == 34 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_INPUTAUTHPHONE"))
	elseif g_iYesNoType == 36 then
		if(Variable:GetVariable("System_CodePage") == "1258") then
			GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
		else
  	  GameProduceLogin:OpenURL(GetWeblink("WEB_KEYFOUND"))
		end
	
	elseif g_iYesNoType == 37 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT3"))
		
	elseif g_iYesNoType == 38 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT1"))
		
	elseif g_iYesNoType == 39 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT2"))	
	elseif g_iYesNoType == 40 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_LSOB"))	
	elseif g_iYesNoType == 41 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_ZHJH"))	
	elseif g_iYesNoType == 47 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT4"))	
	elseif g_iYesNoType == 48 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT6"))
	elseif g_iYesNoType == 49 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT7"))
	elseif g_iYesNoType == 50 then
		GameProduceLogin:OpenURL(GetWeblink("WEB_FCMXT4"))	
	end
	
end

-------------------------------------------------------------
--
-- 按钮1 点击事件
--
function SelectServerQuest_Bn1Click()
-- 0 - 退出游戏
-- 4 - 确认是否删除10级以上玩家
-- 5 - 7天内提醒删除10级以上玩家
-- 6 - 7天后，14天内提醒删除10级以上玩家
-- 7 - 是否删除10级以下玩家
-- 8 - 大于10级得提示
	if( -1 == g_iYesNoType and 1 == g_bIsQuitMsgBox) then
		CancelQuitWait(); --取消退出
	end
	if(0 == g_iYesNoType) then
		QuitApplication("quit");
	elseif(1 == g_iYesNoType) then
	elseif(2==g_iYesNoType) then
		GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
	elseif( 3 == g_iYesNoType ) then
		GameProduceLogin:CloseNetConnect();
	elseif( 4 == g_iYesNoType ) then
			local strInfo;
		  strInfo ="您的角色不能马上删除，请在3天以后14天以内登录游戏，到洛阳（268，46）找到关汉寿或者到大理（80，136）找到周仓确认，即可永久删除。确认删除时角色不能处于有帮会、结婚、结拜、师徒、开店状态，否则删除将被取消。超过14天没有再次删除则删除操作无效。"
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "8" );
	elseif( 5 == g_iYesNoType ) then
	elseif( 6 == g_iYesNoType ) then
	elseif( 7 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 8 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:LoginPlayer( 1 );
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "是否激活_点击了OK");
	elseif(11 == g_iYesNoType) then
		GameProduceLogin:CheckAccountNoMibao();
	elseif(12 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300077 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_Parameter( 1, 0)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif(13 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseTianYuanJinDan" )
			Set_XSCRIPT_ScriptID( 332004 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif(14 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300088 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif(15 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Anqi2Shenzhen" )
			Set_XSCRIPT_ScriptID( 260001 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_Parameter( 1, g_bagIndex2 )
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (17 == g_iYesNoType) then
		PetEquipSuitDepart:ConfirmDepart()
	elseif (18 == g_iYesNoType) then
		--绑定元宝不足时，确定
		NpcShop:BindYuanBaoNotEnough(g_itemNum, g_item,g_pos)
	elseif (19 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenShike(1)
	elseif (20 == g_iYesNoType) then
		if g_objCared ~= -1 and g_bagIndex ~= -1 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("DelProtectGoods");
				Set_XSCRIPT_ScriptID(124);
				Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
				Set_XSCRIPT_Parameter(1,tonumber(g_bagIndex));
				Set_XSCRIPT_ParamCount(2);
			Send_XSCRIPT();
		end
	elseif (21 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenHecheng(1)
	elseif (22 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenQianghua(1)
	elseif (23 == g_iYesNoType) then
		LifeAbility:ConfirmDiaowenShike(2)
	elseif (24 == g_iYesNoType) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GivePrize");
			Set_XSCRIPT_ScriptID(808147)
			Set_XSCRIPT_Parameter(0,tonumber(g_objCared))
			Set_XSCRIPT_Parameter(1,tonumber(g_bagIndex))
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (25 == g_iYesNoType) then --取消更新服务器列表
		--如果杀Launch进程失败，不隐藏
		if (GameProduceLogin:KillLaunchProcess() == 0) then
			return;
		end
	elseif (30 == g_iYesNoType) then
		-- 元宝快捷强化的二次确认
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("DoQuickQiangHuaByYB")
			Set_XSCRIPT_ScriptID(809262)
			Set_XSCRIPT_Parameter(0, tonumber(g_bagIndex))
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (42 == g_iYesNoType) then
		-- 三精材料批量合成
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "CaiLiaoCompound_New" )
			Set_XSCRIPT_ScriptID(701602)
			Set_XSCRIPT_Parameter(0,CaiLiaoCompound_Data[1])--npcid
			Set_XSCRIPT_Parameter(1,CaiLiaoCompound_Data[2])--1快捷2普通
			Set_XSCRIPT_Parameter(2,CaiLiaoCompound_Data[3])--类型
			Set_XSCRIPT_Parameter(3,CaiLiaoCompound_Data[4])--子类型
			Set_XSCRIPT_Parameter(4,1)--二次确认
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif (43 == g_iYesNoType) then
		-- 润魂石批量合成
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "RunHunShiCompound_New" )
			Set_XSCRIPT_ScriptID(809270)
			Set_XSCRIPT_Parameter(0,RunHunShiCompound_Data[1])--npcid
			Set_XSCRIPT_Parameter(1,RunHunShiCompound_Data[2])--1快捷2普通
			Set_XSCRIPT_Parameter(2,RunHunShiCompound_Data[3])--类型
			Set_XSCRIPT_Parameter(3,RunHunShiCompound_Data[4])--子类型
			Set_XSCRIPT_Parameter(4,1)--二次确认
			Set_XSCRIPT_ParamCount(5)
		Send_XSCRIPT()
	elseif (44 == g_iYesNoType) then
		-- 灵兽丹合成
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "PetMedicineHC_ForCheck" )
			Set_XSCRIPT_ScriptID(311112)
			Set_XSCRIPT_Parameter(0,LingShouDanCompound_Data[1]) -- npcid
			Set_XSCRIPT_Parameter(1,LingShouDanCompound_Data[2]) -- standardStuff
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif(46 == g_iYesNoType) then
		-- g_DressPaint_TipsBind = 1 -- 原经典为全局变量，变换形势吧
		DressReplaceColor:SetDressPaint_TipsBind(1)
	elseif (51 == g_iYesNoType) then
		-- 封魂录礼包
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
			Set_XSCRIPT_ScriptID(791011)
			Set_XSCRIPT_Parameter(0, FengHunLu_Data[1])
			Set_XSCRIPT_Parameter(1, FengHunLu_Data[2]) 
			Set_XSCRIPT_Parameter(2, 1) 
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (52 == g_iYesNoType) then
		-- 魂冰珠批量合成
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnHunBingZhuCompoundNew" )
			Set_XSCRIPT_ScriptID(790075)
			-- Set_XSCRIPT_Parameter(0, g_nServerObjID)					
			-- Set_XSCRIPT_Parameter(1, g_nCurSelectedPage)					
			-- Set_XSCRIPT_Parameter(2, g_nCurSelectedIndex)		
			Set_XSCRIPT_Parameter(0, HunBingZhuCompound_Data[1])					
			Set_XSCRIPT_Parameter(1, HunBingZhuCompound_Data[2])					
			Set_XSCRIPT_Parameter(2, HunBingZhuCompound_Data[3])			
			Set_XSCRIPT_Parameter(3, 1)	
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (53 == g_iYesNoType) then
		-- 五一放烟花
		if g_YanHua_From == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OpenUICommand" )
				Set_XSCRIPT_ScriptID(893123)	
				Set_XSCRIPT_Parameter(0, 1)		
				Set_XSCRIPT_Parameter(1, g_YanHua_Param)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif g_YanHua_From == 2 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name( "OnClickFire" )
				Set_XSCRIPT_ScriptID(893124)	
				Set_XSCRIPT_Parameter(0, g_YanHua_Param)	
				Set_XSCRIPT_Parameter(1, 0)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		else
			--error
		end
	elseif (54 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "GetPage3Gift" )
			Set_XSCRIPT_ScriptID(888921)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])	
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (55 == g_iYesNoType) then
		-- 争霸赛 邀请玩家入队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_Parameter(2, g_ZBS_Data[2])
			Set_XSCRIPT_Parameter(3, g_ZBS_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (56 == g_iYesNoType) then
		-- 争霸赛 解散战队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_DismissConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (57 == g_iYesNoType) then
		-- 争霸赛 请离战队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_DeleteMemberConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[2])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (58 == g_iYesNoType) then
		-- 争霸赛 退出战队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_QuitConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	elseif (60 == g_iYesNoType) then
		--圣诞应景-趣味圣诞树
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Confim")
			Set_XSCRIPT_ScriptID(890049)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (61 == g_iYesNoType) then
		-- 天机城（不老殿） 跨服PVP
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Callback_EnterConfirmed")
			Set_XSCRIPT_ScriptID(890111)
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (62 == g_iYesNoType) then
		-- 春节打工兔
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnSubmitDaiBi")
			Set_XSCRIPT_ScriptID(791090)
			Set_XSCRIPT_Parameter(0, DaGongTu_Data[1])
			Set_XSCRIPT_Parameter(1, DaGongTu_Data[2])
			Set_XSCRIPT_Parameter(2, 1)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (63 == g_iYesNoType) then
		-- 长春礼包
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnUIClickCallBack" )
			Set_XSCRIPT_ScriptID(890174)
			Set_XSCRIPT_Parameter(0, changchunlibao_data[1])
			Set_XSCRIPT_Parameter(1, changchunlibao_data[2]) 
			Set_XSCRIPT_Parameter(2, 1) 
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif (64 == g_iYesNoType) then
		-- 帝陵再现PVP活动
		if (g_DLZX_Data[1] == 1) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("CallBack_BuyPermision_Confirm")
				Set_XSCRIPT_ScriptID(998260)
				Set_XSCRIPT_Parameter(0, g_DLZX_Data[2])
				Set_XSCRIPT_Parameter(1, g_DLZX_Data[6])
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		elseif (g_DLZX_Data[1] == 2) then
			Clear_XSCRIPT()
				if (g_DLZX_Data[7] > 0) then
					Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_BuyConfirm_DLSY")
				else
					Set_XSCRIPT_Function_Name("CallBack_TryEnterScene_BuyConfirm")
				end
				Set_XSCRIPT_ScriptID(998260)
				Set_XSCRIPT_Parameter(0, g_DLZX_Data[2])
				Set_XSCRIPT_Parameter(1, g_DLZX_Data[6])
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
		end
	elseif (65 == g_iYesNoType) then
		--结婚交换信物公告二次确认
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SaveItemData");
			Set_XSCRIPT_ScriptID(401030);
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_Parameter(1,1);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (70 == g_iYesNoType) then
		-- 新6v6 邀请玩家入队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_Parameter(1, 1)
			Set_XSCRIPT_Parameter(2, g_SelecQuest_Data[2])
			Set_XSCRIPT_Parameter(3, g_SelecQuest_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	elseif (71 == g_iYesNoType) then
		-- 新6v6 解散战队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_DismissConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (72 == g_iYesNoType) then
		-- 新6v6 退出战队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_QuitConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (73 == g_iYesNoType) then
		--情人节打卡
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Confirm")
			Set_XSCRIPT_ScriptID(998537)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (74 == g_iYesNoType) then
		-- 跨服爬塔夺宝 领奖（个人结算）
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TryRewardConfirm_Self")
			Set_XSCRIPT_ScriptID(998563)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (75 == g_iYesNoType) then
		-- 跨服爬塔夺宝 领奖（个人结算）
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("TryRewardConfirm_Guild")
			Set_XSCRIPT_ScriptID(998563)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif 66 == g_iYesNoType then --变性确认界面
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ChangeSexSure")
			Set_XSCRIPT_ScriptID(250557)
			Set_XSCRIPT_Parameter(0, g_objCared)
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (76 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ExchangeCheckAgain")
			Set_XSCRIPT_ScriptID(998739)
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif (77 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(998831)
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_Parameter(1,g_SelecQuest_Data[2]);
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	elseif (78 == g_iYesNoType) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("GiveGiftBox");
			Set_XSCRIPT_ScriptID(998831);
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	elseif (79 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("GiveAward")
			Set_XSCRIPT_ScriptID(999262)
			Set_XSCRIPT_Parameter(0,g_SelecQuest_Data[1]);
			Set_XSCRIPT_Parameter(1,g_SelecQuest_Data[2]);
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

	this:Hide();
end


-------------------------------------------------------------
--
-- 按钮2 点击事件
--
function SelectServerQuest_Bn2Click()

	if(3 == g_iYesNoType) then
		GameProduceLogin:CloseNetConnect();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:PassportButNotReg();
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "是否激活_点击了NO");
	elseif (55 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(889961)	
			Set_XSCRIPT_Parameter(0, g_ZBS_Data[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_Parameter(2, g_ZBS_Data[2])
			Set_XSCRIPT_Parameter(3, g_ZBS_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()

	elseif (65 == g_iYesNoType) then
		--结婚交换信物公告二次确认
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SaveItemData");
			Set_XSCRIPT_ScriptID(401030);
			Set_XSCRIPT_Parameter(0,g_bagIndex);
			Set_XSCRIPT_Parameter(1,0);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	elseif (70 == g_iYesNoType) then
		-- 新6v6 邀请玩家入队
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("Team_CCallBack_InviteConfirm")
			Set_XSCRIPT_ScriptID(998497)	
			Set_XSCRIPT_Parameter(0, g_SelecQuest_Data[1])
			Set_XSCRIPT_Parameter(1, 0)
			Set_XSCRIPT_Parameter(2, g_SelecQuest_Data[2])
			Set_XSCRIPT_Parameter(3, g_SelecQuest_Data[3])
			Set_XSCRIPT_ParamCount(4)
		Send_XSCRIPT()
	end

	this:Hide();
end

function SelectServerQuest_TimeOut()
  if(TimerArg == "MIBAOERROR" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "USERFROMMAINPRO") then
	this:Hide();
	TimerArg = nil
  elseif(TimerArg == "WAITFORQUIT") then
	if(tonumber(g_QuitType)==0 or tonumber(g_QuitType)==3)then
		QuitApplication("quit");
	else
		AskRet2SelServer();
	end
	this:Hide();
	TimerArg = nil
	g_QuitType = nil
  elseif(TimerArg == "TURNOVER") then
	SelectServerQuest_Button1:Enable()
	TimerArg = nil
	elseif( TimerArg == "LoginCounting" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
	end
end

function SelectServerQuest_Frame_OnHiden()
	if(IsWindowShow("AntiJDY")) then          --简单游互斥界面显示时，不激活快捷键 for 69994
		DataPool:SetCanUseHotKey(0);
	else
		DataPool:SetCanUseHotKey(1);
	end
end
