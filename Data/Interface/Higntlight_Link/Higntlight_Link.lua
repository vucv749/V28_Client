-- UI_COMMAND_INDEX 无
--参数
local g_Higntlight_Link_Frame_UnifiedPosition;
local g_MVPname;
local g_menpai;
local g_type;
local g_rate;
local g_MVPType_Damage = 1;--伤害MVP
local g_MVPType_Treatment =2;--治疗MVP



function Higntlight_Link_PreLoad()
	--this:RegisterEvent("UI_COMMAND");
	--场景切换
	this:RegisterEvent("ON_SCENE_TRANS");
	--玩家离开世界
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--超链
	this:RegisterEvent("HIGHLIGHT_MVP_TOOLTIP");--会传入 角色名字 门派 mvp类型 mvp占比
	--添加好友成功
	this:RegisterEvent("HIGHLIGHT_ADDFRIEND_OK"); 
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Higntlight_Link_OnLoad()
	this:Hide();
    g_Higntlight_Link_Frame_UnifiedPosition = Higntlight_Link_Frame:GetProperty("UnifiedPosition");
end

function Higntlight_Link_OnEvent(event)
	if event == "ON_SCENE_TRANS" then
		Higntlight_Link_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		Higntlight_Link_OnClose()
	elseif event == "HIGHLIGHT_MVP_TOOLTIP" then
		--点击超链开启的界面
		local name = tostring(arg0);
		local menpai = tonumber(arg1);
		local type = tonumber(arg2);
		local rate = tonumber(arg3);
		g_MVPname = name;
		g_menpai = menpai;
		g_type = type;
		g_rate = rate;
		Higntlight_Link_ShowHYPERLINK(name,menpai,type,rate);
	elseif (event == "HIGHLIGHT_ADDFRIEND_OK" ) then
		--添加好友成功
		local friendName = tostring(arg0)
		if (this:IsVisible()) then
			Higntlight_Link_AddFriendOK(friendName)
		end
	elseif (event == "ADJEST_UI_POS" ) then
        Higntlight_Link_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Higntlight_Link_Frame_On_ResetPos();
	end	
end

--添加好友按钮	
function Higntlight_Link_AddFriend1()
	if (g_MVPname == Player:GetName()) then  --这里之所以用名字判断 是因为 超链点开的界面 表里面没有存guid 只存了名字
		PushDebugMessage("#{GGSK_221221_49}");
		return;
	end
	--已经是好友了
	if (Friend:IsPlayerIsFriendNotTemp(g_MVPname) == 1) then
		Higntlight_Link_AddFriend:Hide()
		return;
	end
    DataPool:AddFriendAndGrouping(g_MVPname);
	--已成功添加好友 则隐藏
end

--分享自己按钮	
function Higntlight_Link_Share_Clicked()
	--guid 角色名字 角色门派 角色MVP类型 角色MVP占比
	HighLight:Lua_ShareHLMVP(Player:GetGUID(),
							g_MVPname,
							g_menpai,
							g_type,
							g_rate)
end

--关闭按钮
function Higntlight_Link_OnClose()
    this:Hide();
end

--显示超链信息
function Higntlight_Link_ShowHYPERLINK(name,menpai,mvpType,mvpRate)
	this:Hide();
	if (mvpType == g_MVPType_Damage) then--伤害mvp超链
		-- 设置名字 门派 占比 以及 左下角标语
		--:SetText("#{GGSK_221221_18}");
		--Higntlight_Link_TreatmentPercent:Hide();--关闭治疗占比显示
		--Higntlight_Link_Title_Treatment:Hide();--关闭治疗标语

		Higntlight_Link_DamageCount:Show();
		Higntlight_Link_DamageCount_Text2:SetText(mvpRate);

		Higntlight_Link_Title_Damage:Show();
		Higntlight_Link_ImageMenpai:SetText(Higntlight_Link_GetMenPai(menpai));--门派
		Higntlight_Link_RoleName_Text2:SetText(name);
		
	end

	if (mvpType == g_MVPType_Treatment) then--治疗mvp超链
		-- 设置名字 门派 占比 以及 左下角标语
		--:SetText("#{GGSK_221221_22}");
		--Higntlight_Link_DamageCount:Hide();
		--Higntlight_Link_Title_Damage:Hide();

		--Higntlight_Link_TreatmentPercent:Show();
		--Higntlight_Link_TreatmentPercent_Text2:SetText(mvpRate);

		--Higntlight_Link_Title_Treatment:Show();
		--Higntlight_Link_ImageMenpai:SetText(Higntlight_Link_GetMenPai(menpai));--门派
		--Higntlight_Link_RoleName_Text2:SetText(name);
		--治疗就隐藏
		this:Hide()
		return	
	end
	--默认开启 添加好友 以及 隐藏 分享按钮
	Higntlight_Link_AddFriend:Show()
	Higntlight_Link_Share:Hide()
	--打开界面的为本人 则 隐藏添加按钮 显示分享按钮
	if (name == Player:GetName()) then --这里之所以用名字判断 是因为 超链点开的界面 表里面没有存guid 只存了名字
		Higntlight_Link_AddFriend:Hide()
		--打开分享按钮
		Higntlight_Link_Share:Show()
	else
		Higntlight_Link_Share:Hide()
		--已好友 则隐藏
		if (Friend:IsPlayerIsFriendNotTemp(g_MVPname) == 1) then
			Higntlight_Link_AddFriend:Hide()
		end
	end

	
	this:Show();
end
--添加好友成功 隐藏添加好友按钮
function Higntlight_Link_AddFriendOK(name)
	--PushDebugMessage("高光时刻 显示时 添加好友成功 好友名字:"..name);
	if g_MVPname == name then
		Higntlight_Link_AddFriend:Hide()
		return
	end
end
--获取门派名称
function Higntlight_Link_GetMenPai( menpai )
	local strName = "";
	-- 得到门派名称.
	if(0 == menpai) then
		strName = "少林";
	elseif(1 == menpai) then
		strName = "明教";
	elseif(2 == menpai) then
		strName = "丐帮";
	elseif(3 == menpai) then
		strName = "武当";
	elseif(4 == menpai) then
		strName = "峨嵋";
	elseif(5 == menpai) then
		strName = "星宿";
	elseif(6 == menpai) then
		strName = "天龙";
	elseif(7 == menpai) then
		strName = "天山";
	elseif(8 == menpai) then
		strName = "逍遥";
	elseif(9 == menpai) then
		strName = "无门派";
	elseif(10== menpai) then
		strName = "曼陀山庄";
	end
	return strName
end
--游戏窗口尺寸变化
--游戏分辨率变化
function Higntlight_Link_Frame_On_ResetPos()
    Higntlight_Link_Frame:SetProperty("UnifiedPosition", g_Higntlight_Link_Frame_UnifiedPosition);
end