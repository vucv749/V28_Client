--------------------------------------------------------------------------------
-- 装备按钮数据定义
--
local  g_BAG;			--行囊
local  g_BOX;			--格箱

--师德相关ToolTip内容	--add by xindefeng
local g_ShiDeTbl = {
											[0] = {"无#r", "0#r", 0},
											[1] = {"初级师傅#r", "2#r", 30},
											[2] = {"中级师傅#r", "3#r", 35},
											[3] = {"高级师傅#r", "5#r", 50},
											[4] = {"一代名师#r", "8#r", 70}
										}

-- 界面的默认相对位置
local g_OtherInfo_Frame_UnifiedXPosition;
local g_OtherInfo_Frame_UnifiedYPosition;

--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",  	 	NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}

function OtherInfo_PreLoad()

	-- 打开界面
	this:RegisterEvent("OPEN_OTHER_INFO");

	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UPDATE_DOUBLE_EXP");

	--更新装备
	this:RegisterEvent("REFRESH_EQUIP1");

	-- 任务数据发生变化
	this:RegisterEvent("UPDATE_MISSION_DATA");

	--玩家使用兽栏--add by xindefeng
	this:RegisterEvent("UPDATE_PET_EXTRANUM");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")

	this:RegisterEvent("UPDATE_EXTERIOR_TIP")

end

function OtherInfo_OnLoad()

	g_BAG = OtherInfo_Packet1_Skill1; --行囊
	g_BOX = OtherInfo_Packet2_Skill1; --行囊

	OTHERINFO_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"其他",
	};

	-- 保存界面的默认相对位置
	g_OtherInfo_Frame_UnifiedXPosition	= OtherInfo_Frame : GetProperty("UnifiedXPosition");
	g_OtherInfo_Frame_UnifiedYPosition	= OtherInfo_Frame : GetProperty("UnifiedYPosition");

	g_PageButton[1] = OtherInfo_SelfEquip
	g_PageButton[2] = OtherInfo_SelfData
	g_PageButton[3] = OtherInfo_Pet
	g_PageButton[4] = OtherInfo_Wuhun
	g_PageButton[5] = OtherInfo_Xiulian
	g_PageButton[6] = OtherInfo_Talent
	g_PageButton[7] = OtherInfo_Lingyu
	g_PageButton[8] = OtherInfo_Weapon2
	g_PageButton[9] = OtherInfo_DWJinJie
	g_PageButton[10] = OtherInfo_Peak
	g_PageButton[11] = OtherInfo_Profile
	g_PageButton[12] = OtherInfo_OtherInfo
	
	g_PageMask[1] = OtherInfo_SelfEquip_Mask
	g_PageMask[2] = OtherInfo_SelfData_Mask
	g_PageMask[3] = OtherInfo_Pet_Mask
	g_PageMask[4] = OtherInfo_Wuhun_Mask
	g_PageMask[5] = OtherInfo_Xiulian_Mask
	g_PageMask[6] = OtherInfo_Talent_Mask
	g_PageMask[7] = OtherInfo_Lingyu_Mask
	g_PageMask[8] = OtherInfo_Weapon2_Mask
	g_PageMask[9] = OtherInfo_DWJinJie_Mask
	g_PageMask[10] = OtherInfo_Peak_Mask
	g_PageMask[11] = OtherInfo_Profile_Mask
	g_PageMask[12] = OtherInfo_OtherInfo_Mask
	
	g_PageTip[1] = OtherInfo_SelfEquip_tips
	g_PageTip[2] = OtherInfo_SelfData_tips
	g_PageTip[3] = OtherInfo_Pet_tips
	g_PageTip[4] = OtherInfo_Wuhun_tips
	g_PageTip[5] = OtherInfo_Xiulian_tips
	g_PageTip[6] = OtherInfo_Talent_tips
	g_PageTip[7] = OtherInfo_Lingyu_tips
	g_PageTip[8] = OtherInfo_Weapon2_tips
	g_PageTip[9] = OtherInfo_DWJinJie_tips
	g_PageTip[10] = OtherInfo_Peak_tips
	g_PageTip[11] = OtherInfo_Profile_tips
	g_PageTip[12] = OtherInfo_OtherInfo_tips
end

-- OnEvent
function OtherInfo_OnEvent(event)
--OtherInfo_SetTabColor(4);
	if ( event == "OPEN_OTHER_INFO" ) then

		if(this:IsVisible()) then

			this:Hide();
			return;
		end

		-- 执行服务器脚本，请求更新打劫数据
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("UpdataDacoityData");
			Set_XSCRIPT_ScriptID(311012);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		OtherInfo_OnShow();
		OtherInfo_ShowPage()
		this:Show()
		OtherInfo_UpdateRedPoint()
		local isopen6 = T300Func:IsNoDifOpen(6)
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--OtherInfo_Wuhun:Disable()
		else
			OtherInfo_Wuhun:Enable()
		end
		if isopen6 == 1 then
			--OtherInfo_Xiulian:Disable()
		else
			OtherInfo_Xiulian:Enable()
		end
		
	end

	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end

	if( event == "UPDATE_DOUBLE_EXP") then
		local str = SystemSetup:GetDoubleExp( "count" )
		OtherInfo_6 : SetText(str.."小时")
		local str1 = SystemSetup:GetDoubleExp( "juqing" )
		OtherInfo_7 : SetText(str1 .. "")
		return;
	end

	if( event == "REFRESH_EQUIP1") then
		Equip_RefreshEquip1();
	end

	if(event == "UPDATE_MISSION_DATA")  then
		OtherInfo_OnShow();
	end

	--处理兽栏事件--add by xindefeng
	if(event == "UPDATE_PET_EXTRANUM") then
		if(this:IsVisible()) then
			OtherInfo_OnShow()
		end
	end

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		OtherInfo_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置
		OtherInfo_Frame_On_ResetPos()
	end

	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		OtherInfo_UpdateRedPoint()
	end

	return;
end

function Equip_RefreshEquip1()
	--  清空按钮显示图标
	g_BAG:SetActionItem(-1);			--行囊
	g_BOX:SetActionItem(-1);			--格箱

	local ActionBag 		= EnumAction(9 , "equip");
	local ActionBox 		= EnumAction(10, "equip");

	-- 显示人身上的武器装备
	g_BAG:SetActionItem(ActionBag:GetID());			--行囊
	g_BOX:SetActionItem(ActionBox:GetID());			--格箱
end

-- 行囊点击事件
function SelfEquip_Bag_Click()
	g_BAG:DoSubAction();	--行囊
end

-- 格箱点击事件
function SelfEquip_Box_Click()
	g_BOX:DoSubAction();	--格箱
end

function OtherInfo_OnShow()
	--OtherInfo_OtherInfo : SetCheck(1);
	local str;
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		OtherInfo_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end

	str = Player : GetData("GOODBADVALUE");
	OtherInfo_1 : SetText(str)
	SetOtherInfo_1_Tooltip()	--设置其ToolTips	-- add by xindefeng

	str = Player : GetData("PKVALUE");
	OtherInfo_2 : SetText(str)

	local prenticeNum = Player : GetData("PRENTICCOUNT");
	local masterLvl = Player : GetData("MASTERLEVEL");
	local availRecruitNum = 0;
	if masterLvl == 1 then
		availRecruitNum = 2;
	elseif masterLvl == 2 then
		availRecruitNum = 3;
	elseif masterLvl == 3 then
		availRecruitNum = 5;
	elseif masterLvl == 4 then
		availRecruitNum = 8;
	end
	OtherInfo_9_Text:SetText("收徒数量:");
	OtherInfo_9:SetText(prenticeNum.."/"..availRecruitNum);
--	str = Player : GetData("MORALPOINT");
--	OtherInfo_3 : SetText(str)

	str = Player : GetData("MENPAIPOINT");
	OtherInfo_4 : SetText(str)

	str = SystemSetup:GetDoubleExp( "count" )
	OtherInfo_6 : SetText(str.."小时")
	str = Guild:GetGuildContri();
	OtherInfo_5 : SetText(str);

	local nCount = DataPool:GetPlayerMission_DataRound(150)
	OtherInfo_3:SetText(tostring(nCount))

	OtherInfo_8:SetText(tonumber(Player:GetData("PET_EXTRANUM")))	--显示兽栏空间--add by xindefeng

	OtherInfo_10 : SetText(Player : GetData("HONOR"));

	--OtherInfo_11 : SetText(Player : GetData("RECOMMENDER"));

	--显示已杀死怪物数
	local nKillMonsterCount = Player : GetData("KILLMONSTERCOUNT");
	local nNilIncomeMonsterCount = Player : GetData("NILINCOMEMONSTERCOUNT");
	if nKillMonsterCount > nNilIncomeMonsterCount then
		nKillMonsterCount = nNilIncomeMonsterCount;
	end
	OtherInfo_12 : SetText(nKillMonsterCount.."/"..nNilIncomeMonsterCount);

	--显示活跃值
	local totalActivePoint = Lua_GetZhouHuoYueValueDay()
	OtherInfo_13 : SetText(totalActivePoint.."/"..500);
	--显示婚姻数据
		-- 得到配偶信息
	str = SystemSetup:GetPrivateInfo("self","Consort");
	OtherInfo_14:SetText(str);
	
	--得到结婚时间
	str = SystemSetup:GetPrivateInfo("self","Weddingtime");
	OtherInfo_15:SetText(str)
end


function OtherInfo_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end

	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherInfo_SelfEquip,
								OtherInfo_SelfData,
								OtherInfo_Pet,
								OtherInfo_OtherInfo,
							};

	while i < 4 do
		if(i == idx) then
			tab[i]:SetText(selColor..OTHERINFO_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..OTHERINFO_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function OtherInfo_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0)
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

--打开自己的资料页面
function OtherInfo_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
	this:Hide();
end

function OtherInfo_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	TogglePetPage();
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

function OtherInfo_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		OtherInfo_Xiulian : SetCheck(0)
		OtherInfo_ClearPage()
		return
	end
	
	local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    OtherInfo_Xiulian : SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    OtherInfo_ClearPage()
	end
end

function OnOtherInfo_OpenReputationClick()

	OpenWindow( "Reputation" );
	AxTrace( 0,0, "Open Window Reputation" );
end

function OtherInfo_OnOpenGruidClick()
	Guild:ToggleGuildDetailInfo();
end

-- 打开关系界面
function OtherInfo_OpenGuanXi_Click()
	OpenWindow( "Relation" );
	AxTrace( 0,0, "Open Window Relation" );
end

--设置otherinfo_1的tooltip	--add by xindefeng
function SetOtherInfo_1_Tooltip()
	local MasterLevel = Player:GetData("MASTERLEVEL")	--获取师德等级
	if(MasterLevel < 0)then
		return
	end

	local ShanEValue = Player:GetData("GOODBADVALUE")						--获取善恶值
	local TuDiCount = Player:GetData("PRENTICCOUNT")						--获取徒弟数量
	local TuDiSupplyExp = Player:GetData("PRENTICSUPPLYEXP")		--获取当前徒弟贡献的经验值
	local ShanEExp = ShanEValue * (g_ShiDeTbl[MasterLevel][3])	--计算与善恶值挂钩可以领取的经验值
	local TrueExp = ((TuDiSupplyExp < ShanEExp) and TuDiSupplyExp) or ShanEExp	--获取二者最小值

	local str =	"师傅等级："..g_ShiDeTbl[MasterLevel][1].."弟子数目："..TuDiCount.."/"..g_ShiDeTbl[MasterLevel][2].."可兑换经验："..TrueExp

	OtherInfo_1:SetToolTip(str)
end

--显示武魂UI
function OtherInfo_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		OtherInfo_Wuhun : SetCheck(0)
		OtherInfo_ClearPage()
		return
	end
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
	ToggleWuhunPage();
end


function OtherInfo_Talent_Switch()
	if DataPool:Lua_CheckOpenTalent() == 1 then
		Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
		ToggleTalentPage();
	else
		OtherInfo_Talent : SetCheck(0)
		OtherInfo_ClearPage()
	end
end

function OtherInfo_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		OtherInfo_Wuhun : SetCheck(0)
		OtherInfo_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function OtherInfo_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		OtherInfo_Weapon2:SetCheck(0)
		OtherInfo_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function OtherInfo_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		OtherInfo_DWJinJie:SetCheck(0)
		OtherInfo_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

function OtherInfo_GotoPaihang()
	--PushDebugMessage("功能尚未开放")
	Helper:GotoPaihang()
end

--切换个人展示界面
function OtherInfo_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function OtherInfo_GotoDianCang()
	PushEvent("UI_COMMAND", 99222222)
end

--================================================
-- 恢复界面的默认相对位置
--================================================
function OtherInfo_Frame_On_ResetPos()

	OtherInfo_Frame : SetProperty("UnifiedXPosition", g_OtherInfo_Frame_UnifiedXPosition);
	OtherInfo_Frame : SetProperty("UnifiedYPosition", g_OtherInfo_Frame_UnifiedYPosition);

end

function OtherInfo_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	OtherInfo_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if OtherInfo_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if OtherInfo_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function OtherInfo_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]
	if idx == 1 then--装备
		OtherInfo_SelfEquip_Page_Switch()
	elseif idx == 2 then--资料
		OtherInfo_SelfData_Switch()
	elseif idx == 3 then--珍兽
		OtherInfo_Pet_Switch()
	elseif idx == 4 then--武魂
		OtherInfo_Wuhun_Switch()
	elseif idx == 5 then--修炼
		OtherInfo_Xiulian_Switch()
	elseif idx == 6 then--武道
		OtherInfo_Talent_Switch()
	elseif idx == 7 then--灵玉
		OtherInfo_Page_LingYu()
	elseif idx == 8 then--神兵
		OtherInfo_Page_ShenBing()
	elseif idx == 9 then--雕文进阶
		OtherInfo_Page_DWJinJie()
	elseif idx == 10 then--巅峰
		OtherInfo_Page_Peak()	
	elseif idx == 11 then--个人
		OtherInfo_Profile_Switch()
	elseif idx == 12 then--其他
		OtherInfo_ClearPage()
	end
end

function OtherInfo_CheckPage(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--灵玉
		return 1
	elseif idx == 8 then--神兵
		return 1
	elseif idx == 9 then--雕文进阶
		return 1
	elseif idx == 10 then--武境
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--个人
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function OtherInfo_IsPageEnable(idx)
	if idx == 1 then--装备
		return 1
	elseif idx == 2 then--资料
		return 1
	elseif idx == 3 then--珍兽
		return 1
	elseif idx == 4 then--武魂
		return 1
	elseif idx == 5 then--修炼
		return 1
	elseif idx == 6 then--武道
		return 1
	elseif idx == 7 then--灵玉
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--神兵
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--雕文进阶
		return 1
	elseif idx == 10 then--武境
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--个人
		return 1
	elseif idx == 12 then--其他
		return 1
	end
	return 0
end

function OtherInfo_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

function OtherInfo_OnHidden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

--更新分页红点
function OtherInfo_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end

function OtherInfo_Page_Peak()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
	this:Hide();
end