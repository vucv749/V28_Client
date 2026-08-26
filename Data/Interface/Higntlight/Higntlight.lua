-- UI_COMMAND_INDEX 暂定22122701
--参数
local g_Higntlight_Frame_UnifiedPosition;
local g_TotalMVPCount = 0;		--MVP数量  拿数量的接口 有点问题 不使用了 后面都统一按3个来拿getdata 更新ui也是按3个来 TODO:到时候问问这个问题
local g_TreatmentIndex = 0;		--因为治疗比较特殊 要固定放在 UI的第二个显示框内，所以 单独记录 治疗MVP在MVP表中的序号 0则代表没有治疗MVP  对应UI序号2 
local g_DamageIndex_1 =0;		--还是也记录下伤害在MVP表中的索引吧 方便用来UpdateUI 对应UI序号1
local g_DamageIndex_2 =0;		--对应UI序号3

local g_MVPType_Damage = 1; --伤害类型
local g_MVPType_Treatment = 2; --治疗类型

local isTOOLTIP = 0;--1代表是点击超链打开的界面 超链用另一个界面了 这个没用了

local g_TotalMVPTable =
{	--策划修改为 最多三个 2伤害 1治疗
	--角色GUID	角色名字	角色门派	角色MVP类型(用来判断是否有效)		角色的占比
	--又改成只有两个MVP了 这里面 有一个用不上了		
	[1]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
	[2]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
	[3]	={guid = 0,name = 0, menpai = 0, MVPType = 0, MVPRate = 0},
};

--点赞这块单独摘出来
local g_ZanTable =
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
};

--[[ local g_ZanRandTitle_Treatment =
{
	[1]="#{GGSK_221221_22}",
	[2]="#{GGSK_221221_23}",
	[3]="#{GGSK_221221_24}",
	[4]="#{GGSK_221221_25}",
	[5]="#{GGSK_221221_55}",
	[6]="#{GGSK_221221_56}",
	[7]="#{GGSK_221221_57}",
} ]]

local g_ZanRandTitle_Damage =
{
	[1]="#{GGSK_221221_19}",
	[2]="#{GGSK_221221_20}",
	[3]="#{GGSK_221221_21}",
	[4]="#{GGSK_221221_52}",
	[5]="#{GGSK_221221_53}",
	[6]="#{GGSK_221221_54}",
}
local g_IsZan =  --用来判断 某个按钮玩家是否按过点赞了 0代表此点赞按钮在本次MVP结算中还没按过
{
	[1] = 0,
	[2] = 0,
	[3] = 0,
}

--UI表
local g_UI_menpai={};--item1的门派表
--local g_UI_menpai2={};--item2的门派表
--local g_UI_menpai3={};--item3的门派表
local g_UI_charName={};--玩家名称
local g_UI_rate={};--占比
local g_UI_title={};--显示 团队DPS之王当之无愧 的那个地方
local g_UI_likesDetail={};--点赞标语

function Higntlight_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	--打开高光时刻结算界面
	this:RegisterEvent("SHOW_HIGHLIGHT_MVP");
	--场景切换
	this:RegisterEvent("ON_SCENE_TRANS");
	--玩家离开世界
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	--超链
	--this:RegisterEvent("HIGHLIGHT_MVP_TOOLTIP");--会传入 角色名字 门派 mvp类型 mvp占比
	--添加好友成功
	this:RegisterEvent("HIGHLIGHT_ADDFRIEND_OK"); 
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Higntlight_OnLoad()
	this:Hide();
    g_Higntlight_Frame_UnifiedPosition = Higntlight_Frame:GetProperty("UnifiedPosition");

	--Higntlight_InitMenPaiTable()
	g_UI_menpai[1] = Higntlight_ImageMenpai
	g_UI_menpai[2] = Higntlight_ImageMenpai
	g_UI_menpai[3] = Higntlight_ImageMenpai3

	g_UI_charName[1] = Higntlight_RoleName_Text2;
	g_UI_charName[2] = Higntlight_RoleName_Text2;--Higntlight_RoleName2_Text2;
	g_UI_charName[3] = Higntlight_RoleName3_Text2;

	g_UI_rate[1] = Higntlight_DamageCount_Text2;
	g_UI_rate[2] = Higntlight_DamageCount_Text2;--Higntlight_TreatmentPercent2_Text2;	--治疗 在UI中固定放在第二个item那里 这里特殊处理
	g_UI_rate[3] = Higntlight_DamageCount3_Text2;

	g_UI_title[1] = Higntlight_Title;
	g_UI_title[2] = Higntlight_Title;--Higntlight_Title2;
	g_UI_title[3] = Higntlight_Title3;

	--资源那边 把 item1、3的治疗百分比删除，item2的伤害百分比删除了
	--Higntlight_TreatmentPercent:Hide();
	--Higntlight_DamageCount2:Hide(); --治疗 在UI中固定放在第二个item那里 这里特殊处理 第二个item的伤害字段
	--Higntlight_TreatmentPercent3:Hide();
	--this:Show();

	g_UI_likesDetail[1] = Higntlight_LikesDetail_PAOPAO;
	g_UI_likesDetail[2] = Higntlight_LikesDetail_PAOPAO--用item1的泡泡替代 Higntlight_LikesDetail_PAOPAO2;
	g_UI_likesDetail[3] = Higntlight_LikesDetail_PAOPAO3;
	g_UI_likesDetail[1]:SetText(" ");--清空点赞标语
	g_UI_likesDetail[2]:SetText(" ");
	g_UI_likesDetail[3]:SetText(" ");

	isTOOLTIP=0;

	g_IsZan[1] = 0;
	g_IsZan[2] = 0;
	g_IsZan[3] = 0;

	--治疗的组件先隐藏
	--Higntlight_Treatment:Hide() -- 治疗 标题
	--Higntlight_Item2:Hide() --右上角 治疗 item
end


function Higntlight_OnEvent(event)
	if (event == "UI_COMMAND" and tonumber(arg0) == 22122701) then
        --服务器端调用 这里获得参数并处理
		local t_index = Get_XParam_INT(0);
		local t_name = Get_XParam_STR(0);--这个是发起点赞的玩家的名字
		g_ZanTable[t_index] = g_ZanTable[t_index]+1;--点赞数加一
		--判断被点赞的是否是自己
		local targetGUID
		if t_index == 1 then
			targetGUID = g_TotalMVPTable[g_DamageIndex_1].guid
		elseif t_index == 3 then
			targetGUID = g_TotalMVPTable[g_DamageIndex_2].guid
		end
		if targetGUID ~= 0 and targetGUID == Player:GetGUID() then --被点赞玩家 是 我
			local rtxt = ScriptGlobal_Format("#{GGSK_221221_64}", tostring(t_name))
			PushDebugMessage(rtxt);
		end
	elseif (event == "SHOW_HIGHLIGHT_MVP") then
		this:Hide();
		--获取数据 打开界面
		Higntlight_GetData();
		Higntlight_UpdateUI();
		this:Show();
		SetTimer("Higntlight", "Higntlight_ZanTimer()", 2000);--点赞标语 如果有的话2秒切换一次
		isTOOLTIP = 0;--不是点击超链开启的 标志 为0
		--刚显示界面 肯定是没有人按过点赞的
		g_IsZan[1] = 0;
		g_IsZan[2] = 0;
		g_IsZan[3] = 0;
	elseif event == "ON_SCENE_TRANS" then
		--场景切换 清空
		Higntlight_OnClose()
	elseif event == "PLAYER_LEAVE_WORLD" then
		--玩家离开世界 清空
		Higntlight_OnClose()
	elseif (event == "HIGHLIGHT_ADDFRIEND_OK" ) then
		--添加好友成功
		local friendName = tostring(arg0)
		if (this:IsVisible()) then
			Higntlight_AddFriendOK(friendName)
		end
	elseif (event == "ADJEST_UI_POS" ) then
        Higntlight_Frame_On_ResetPos();
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
        Higntlight_Frame_On_ResetPos();
	end	
end

--添加好友按钮	
function Higntlight_AddFriend1(index)
	--ui的index要转换成mvp表的index
	local tempIndex = index --记录按下按钮的序号
	if (index == 1) then
		index = g_DamageIndex_1
	--elseif (index == 2) then
		--index = g_TreatmentIndex
	elseif (index == 3) then
		index = g_DamageIndex_2
	end
	if (g_TotalMVPTable[index].guid == Player:GetGUID()) then  
		PushDebugMessage("#{GGSK_221221_49}");--修改字典
		return;
	end
	if (g_TotalMVPTable[index].name == 0) then
		return;
	end
	--已是好友 则隐藏
	if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[index].name) == 1) then
		if tempIndex == 1 then
			Higntlight_AddFriend:Hide();
		--elseif tempIndex == 2 then
			--Higntlight_AddFriend2:Hide();
		elseif tempIndex == 3 then
			Higntlight_AddFriend3:Hide();
		end
		return
	end
	local strName = g_TotalMVPTable[index].name;
    DataPool:AddFriendAndGrouping(strName);
	--已成功添加好友 则隐藏
end
--点赞按钮	
function Higntlight_Like(index)
	if (isTOOLTIP ~= 0) then
		return;
	end
	if (g_IsZan[index] == 1) then
		PushDebugMessage("#{GGSK_221221_07}");
		return;
	end
    HighLight:Lua_UpdateLikeCount(index,Player:GetName());
	g_IsZan[index] = 1;--1代表此按钮在本次结算时刻 被按过了

	--点赞成功 给自己发一个醒目提示 给某人点赞
	local tipName
	if index == 1 then
		tipName = g_TotalMVPTable[g_DamageIndex_1].name
	elseif index == 3 then
		tipName = g_TotalMVPTable[g_DamageIndex_2].name
	end
	local rtxt = ScriptGlobal_Format("#{GGSK_221221_08}", tostring(tipName))
	PushDebugMessage(rtxt);

	--按完点赞 置灰对应按钮
	if index == 1 then
		Higntlight_Like1:Disable();

	--elseif index == 2 then
		--Higntlight_Like2:Disable();
		
	elseif index == 3 then
		Higntlight_Like3:Disable();
		
	end
end
--分享按钮	
function Higntlight_Share(index)
	if (isTOOLTIP ~= 0) then
		return;
	end
    --ui的index要转换成mvp表的index
	if (index == 1) then
		index = g_DamageIndex_1
	--elseif (index == 2) then
		--index = g_TreatmentIndex
	elseif (index == 3) then
		index = g_DamageIndex_2
	end

	--guid 角色名字 角色门派 角色MVP类型 角色MVP占比
	HighLight:Lua_ShareHLMVP(g_TotalMVPTable[index].guid,
							g_TotalMVPTable[index].name,
							g_TotalMVPTable[index].menpai,
							g_TotalMVPTable[index].MVPType,
							g_TotalMVPTable[index].MVPRate)
end
--关闭按钮
function Higntlight_OnClose()
    this:Hide();
	KillTimer("Higntlight_ZanTimer()");
	--玩家不能手动打开此界面 所以玩家手动关闭之后 肯定要清空表数据
	Higntlight_ClearData();
	isTOOLTIP=0;
end
--获取MVP数据
function Higntlight_GetData()
	--只清空lua表 不要清空客户端中的表
	Higntlight_ClearLocalData();
	for i = 1, 3, 1 do
		local mRet,mName,mGuid,mMenpai,mMVPType,mMVPRate = HighLight:Lua_GetHLMVPDataByIndex(i);
		--PushDebugMessage("test mRet:"..mRet);
		if mRet == 0 then
			return;
		end
		if (mMVPType == g_MVPType_Treatment) then
			g_TreatmentIndex = 0 --治疗先不上 以防万一 这里 治疗所以统一置0 当g_TreatmentIndex为0时 更新界面函数里面不会设置治疗item
			--g_TreatmentIndex = i;--记录治疗的序号 UpdateUI时 使用
			--PushDebugMessage("test type:"..mMVPType);
		elseif (mMVPType == g_MVPType_Damage) then
			if (g_DamageIndex_1 == 0) then --有伤害MVP 并且 g_DamageIndex_1处于初始化状态 则先给g_DamageIndex_1 赋值
				g_DamageIndex_1 = i;
			elseif (g_DamageIndex_1 ~= 0) then --有伤害MVP 并且 g_DamageIndex_1已经被赋值了 那么就给g_DamageIndex_2记录第二个伤害MVP
				g_DamageIndex_2 = i;
			end
			--PushDebugMessage("test type:"..mMVPType);
		end
		g_TotalMVPTable[i].guid=mGuid;
		g_TotalMVPTable[i].name=mName;
		g_TotalMVPTable[i].menpai=mMenpai;
		g_TotalMVPTable[i].MVPType=mMVPType;
		g_TotalMVPTable[i].MVPRate=mMVPRate;
	end
end
--更新界面
function Higntlight_UpdateUI()
	--用记录的 MVP索引 来刷新UI
	--Higntlight_HideAllMenPaiTable()
	Higntlight_Like1:Enable()
	--Higntlight_Like2:Enable()
	Higntlight_Like3:Enable()
	--[[ --右上角item
	if (g_TreatmentIndex ~= 0) then
		Higntlight_Item2:Show();
		g_UI_charName[2]:SetText(g_TotalMVPTable[g_TreatmentIndex].name);
		--g_UI_menpai[2]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_TreatmentIndex].menpai));
		if g_TotalMVPTable[g_TreatmentIndex].menpai ~= 9 then
			g_UI_menpai2[g_TotalMVPTable[g_TreatmentIndex].menpai + 1]:Show()
		end
		g_UI_rate[2]:SetText(g_TotalMVPTable[g_TreatmentIndex].MVPRate);
		--不随机了 固定显示
		g_UI_title[2]:SetText("#{GGSK_221221_22}");

		--是本人 则不显示 添加 和 点赞按钮
		if (g_TotalMVPTable[g_TreatmentIndex].guid == Player:GetGUID()) then
			Higntlight_AddFriend2:Hide();
			Higntlight_Like2:Hide();
		else
			Higntlight_AddFriend2:Show();
			Higntlight_Like2:Show();
			--此MVP已经是好友 则添加按钮隐藏
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_TreatmentIndex].name) == 1) then
				Higntlight_AddFriend2:Hide();
			else
				Higntlight_AddFriend2:Show()
			end
		end

	else
		Higntlight_Item2:Hide();
	end ]]
	--伤害1
	if (g_DamageIndex_1 ~= 0) then
		Higntlight_Item:Show();
		g_UI_charName[1]:SetText(g_TotalMVPTable[g_DamageIndex_1].name);
		g_UI_menpai[1]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_DamageIndex_1].menpai));
		--if g_TotalMVPTable[g_DamageIndex_1].menpai ~= 9 then
		--	g_UI_menpai[g_TotalMVPTable[g_DamageIndex_1].menpai + 1]:Show()
		--end
		g_UI_rate[1]:SetText(g_TotalMVPTable[g_DamageIndex_1].MVPRate);

		--不随机了 固定显示
		g_UI_title[1]:SetText("#{GGSK_221221_18}");
		
		--是本人 则不显示 添加 和 点赞按钮
		if (g_TotalMVPTable[g_DamageIndex_1].guid == Player:GetGUID()) then
			Higntlight_AddFriend:Hide();
			Higntlight_Like1:Hide();
		else
			Higntlight_AddFriend:Show();
			Higntlight_Like1:Show();
			--此MVP已经是好友 则添加按钮隐藏
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_DamageIndex_1].name) == 1) then
				Higntlight_AddFriend:Hide();
			else
				Higntlight_AddFriend:Show()
			end
		end

	else
		Higntlight_Item:Hide();
	end
	--伤害2
	if (g_DamageIndex_2 ~= 0) then
		Higntlight_Item3:Show();
		g_UI_charName[3]:SetText(g_TotalMVPTable[g_DamageIndex_2].name);
		g_UI_menpai[3]:SetText(Higntlight_GetMenPai(g_TotalMVPTable[g_DamageIndex_2].menpai));
		--if g_TotalMVPTable[g_DamageIndex_2].menpai ~= 9 then
		--	g_UI_menpai3[g_TotalMVPTable[g_DamageIndex_2].menpai + 1]:Show()
		--end
		g_UI_rate[3]:SetText(g_TotalMVPTable[g_DamageIndex_2].MVPRate);
		
		--不随机了 固定显示
		g_UI_title[3]:SetText("#{GGSK_221221_18}");

		--是本人 则不显示 添加 和 点赞按钮
		if (g_TotalMVPTable[g_DamageIndex_2].guid == Player:GetGUID()) then
			Higntlight_AddFriend3:Hide();
			Higntlight_Like3:Hide();
		else
			Higntlight_AddFriend3:Show();
			Higntlight_Like3:Show();
			--此MVP已经是好友 则添加按钮隐藏
			if (Friend:IsPlayerIsFriendNotTemp(g_TotalMVPTable[g_DamageIndex_2].name) == 1) then
				Higntlight_AddFriend3:Hide();
			else
				Higntlight_AddFriend3:Show()
			end
		end

	else
		Higntlight_Item3:Hide();
	end
	
	this:Show();
end
--点赞定时器 在UI界面开启时 打开此timer
function Higntlight_ZanTimer()
	for i = 1, 3, 1 do
		if i ~= 2 then
			--点赞数已经为0 则不显示点赞标语
			if (g_ZanTable[i] == 0) then
				g_UI_likesDetail[i]:SetText(" ");
			end
			--定时更新点赞标语
			if (g_ZanTable[i] > 0) then
				Higntlight_UpdateZan(i);
			end
			--更新点赞标语之后 点赞数自减
			if (g_ZanTable[i] > 0) then
				g_ZanTable[i] = g_ZanTable[i] - 1;
			end
		end
	end
end

function Higntlight_UpdateZan(t_index)
	if (t_index == 1 or t_index == 3) then --点赞伤害1 对应MVP表序号 g_DamageIndex_1
		local rand = math.random(0, 6);
		if (rand < 1 or rand > 6) then
			rand = 1; --这函数没用过 写个这个保底下
		end
		g_UI_likesDetail[t_index]:SetText(g_ZanRandTitle_Damage[rand]); --随机显示字典
	elseif (t_index == 2) then
		--[[ local rand = math.random(0, 7);
		if (rand < 1 or rand > 7) then
			rand = 1; --这函数没用过 写个这个保底下
		end
		g_UI_likesDetail[t_index]:SetText(g_ZanRandTitle_Treatment[rand]); --随机显示字典 ]]
	end
end

--清空lua脚本 以及 客户端中 MVP表
function Higntlight_ClearData()
	g_TotalMVPCount = 0;
	g_TreatmentIndex = 0;
	g_DamageIndex_1 = 0;
	g_DamageIndex_2 = 0;
	for i = 1, 3, 1 do
		g_TotalMVPTable[i].guid=0;
		g_TotalMVPTable[i].name=0;
		g_TotalMVPTable[i].menpai=0;
		g_TotalMVPTable[i].MVPType=0;
		g_TotalMVPTable[i].MVPRate=0;
	end
	for j = 1, 3, 1 do
		g_ZanTable[j]=0;
	end

	HighLight:Lua_ClearHLMVPData();
end
--清空lua脚本中MVP表
function Higntlight_ClearLocalData()
	g_TotalMVPCount = 0;
	g_TreatmentIndex = 0;
	g_DamageIndex_1 = 0;
	g_DamageIndex_2 = 0;
	for i = 1, 3, 1 do
		g_TotalMVPTable[i].guid=0;
		g_TotalMVPTable[i].name=0;
		g_TotalMVPTable[i].menpai=0;
		g_TotalMVPTable[i].MVPType=0;
		g_TotalMVPTable[i].MVPRate=0;
	end
	for j = 1, 3, 1 do
		g_ZanTable[j]=0;
	end
end
--隐藏所有item
function Higntlight_HideAllItem()
	Higntlight_Item:Hide();
	--Higntlight_Item2:Hide();
	Higntlight_Item3:Hide();
end
--添加好友成功 隐藏添加好友按钮
function Higntlight_AddFriendOK(name)
	--PushDebugMessage("高光时刻 显示时 添加好友成功 好友名字:"..name);
	--[[ if g_TreatmentIndex ~= 0 then --有治疗mvp
		if g_TotalMVPTable[g_TreatmentIndex].name == name then
			Higntlight_AddFriend2:Hide()
			
		end
	end ]]
	if g_DamageIndex_1 ~= 0 then --有伤害1mvp
		if g_TotalMVPTable[g_DamageIndex_1].name == name then
			Higntlight_AddFriend:Hide()
			
		end
	end
	if g_DamageIndex_2 ~= 0 then --有伤害2mvp
		if g_TotalMVPTable[g_DamageIndex_2].name == name then
			Higntlight_AddFriend3:Hide()
			
		end
	end
end

--获取门派名称
function Higntlight_GetMenPai( menpai )
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
function Higntlight_Frame_On_ResetPos()
    Higntlight_Frame:SetProperty("UnifiedPosition", g_Higntlight_Frame_UnifiedPosition);
end