local g_ShengWangAll_Frame_UnifiedXPosition;
local g_ShengWangAll_Frame_UnifiedYPosition;

local g_ShengWang_Page_Type =1
local g_ShengWang_Shop_Curpage =1
local g_ShengWang_Page3_Curpage = 1
local g_ShengWang_Page3_TotalPage= 0
local g_ShengWang_Shop_PerPage =12
local g_ShengWang_Shop_itemctl = {}

local g_ShengWang_Shop2_itemctl = {}

local  g_ShengWang_TargetID = -1

local g_Shengwang_selfPoint= 0
local g_ShengWang_selfCampID = 0
local g_ShengWang_selfCampState = 0
local g_ShengWang_NPCCampID = 0

local ShengWangAll_Item  = 12

local ShengWangAll_JoinIMGStr=
{
	[1]={
		[1]="set:ShengWang01 image:ShengWang_BXHPush",
		[2]="set:ShengWang01 image:ShengWang_BXHNolmal",
		[3]="set:ShengWang01 image:ShengWang_BXHHover",
		},
	[2]={
		[1]="set:ShengWang01 image:ShengWang_SNZHPush",
		[2]="set:ShengWang01 image:ShengWang_SNZHNolmal",
		[3]="set:ShengWang01 image:ShengWang_SNZHHover",
		},
	[3]={
		[1]="set:ShengWang01 image:ShengWang_XLFLPush",
		[2]="set:ShengWang01 image:ShengWang_XLFLNolmal",
		[3]="set:ShengWang01 image:ShengWang_XLFLHover",
		},
}

local ShengWangAll_Title=
{
	[1]="#{SWXT_221213_12}",
	[2]="#{SWXT_221213_13}",
	[3]="#{SWXT_221213_14}",
}

local ShengWangAll_Image=
{
	[1]="set:ShengWang01 image:ShengWangAll_BK2",
	[2]="set:ShengWang01 image:ShengWangAll_BK1",
	[3]="set:ShengWang02 image:ShengWangAll_BK3",
}

	--简单  "#{SWXT_221213_143}"
	--普通  "#{SWXT_221213_148}",
	--苦难  "#{SWXT_221213_159}",

--任务集合
local ShengWangAll_MissionInfo = {
	--阵营1
	[1] = {
			[1]={missionid=2130, name="#{SWXT_221213_142}",des="#{SWXT_221213_144}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=613,posX=130,posZ=190,NPCname="墨如",AcceptTimeParam=5},
			[2]={missionid=2131, name="#{SWXT_221213_145}",des="#{SWXT_221213_146}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=613,posX=130,posZ=190,NPCname="墨如",AcceptTimeParam=5},
			[3]={missionid=2132, name="#{SWXT_221213_147}",des="#{SWXT_221213_149}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=613,posX=125,posZ=178,NPCname="墨晓清",AcceptTimeParam=5},
			[4]={missionid=2133, name="#{SWXT_221213_150}",des="#{SWXT_221213_151}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=613,posX=63,posZ=53,NPCname="墨知愁",AcceptTimeParam=5},
			[5]={missionid=2134, name="#{SWXT_221213_152}",des="#{SWXT_221213_153}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=613,posX=63,posZ=53,NPCname="墨知愁",AcceptTimeParam=5},
			[6]={missionid=2135, name="#{SWXT_221213_154}",des="#{SWXT_221213_155}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=613,posX=63,posZ=53,NPCname="墨知愁",AcceptTimeParam=5},
			[7]={missionid=2136, name="#{SWXT_221213_156}",des="#{SWXT_221213_157}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=613,posX=63,posZ=53,NPCname="墨知愁",AcceptTimeParam=5},
			[8]={missionid=2155, name="#{SWXT_221213_158}",des="#{SWXT_221213_160}",grade="set:ShengWang01 image:ShengWangAll_KunNan",bonus=25,scene=613,posX=130,posZ=190,NPCname="墨如",AcceptTimeParam=3},
		},
	--阵营2
	[2] = {
			[1]={missionid=2137, name="#{SWXT_221213_161}",des="#{SWXT_221213_162}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=614,posX=62,posZ=199,NPCname="墨忆",AcceptTimeParam=5},
			[2]={missionid=2138, name="#{SWXT_221213_163}",des="#{SWXT_221213_164}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=614,posX=70,posZ=37,NPCname="墨星翁",AcceptTimeParam=5},
			[3]={missionid=2139, name="#{SWXT_221213_165}",des="#{SWXT_221213_166}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=614,posX=69,posZ=142,NPCname="墨北辰",AcceptTimeParam=5},
			[4]={missionid=2140, name="#{SWXT_221213_167}",des="#{SWXT_221213_168}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=614,posX=37,posZ=119,NPCname="江行云",AcceptTimeParam=5},
			[5]={missionid=2141, name="#{SWXT_221213_169}",des="#{SWXT_221213_170}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=614,posX=56,posZ=198,NPCname="墨思思",AcceptTimeParam=5},
			[6]={missionid=2142, name="#{SWXT_221213_171}",des="#{SWXT_221213_172}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=614,posX=37,posZ=119,NPCname="江行云",AcceptTimeParam=5},
			[7]={missionid=2143, name="#{SWXT_221213_173}",des="#{SWXT_221213_174}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=614,posX=37,posZ=119,NPCname="江行云",AcceptTimeParam=5},
			[8]={missionid=2156, name="#{SWXT_221213_175}",des="#{SWXT_221213_176}",grade="set:ShengWang01 image:ShengWangAll_KunNan",bonus=25,scene=614,posX=70,posZ=37,NPCname="墨星翁",AcceptTimeParam=3},
		},
	--阵营3
	[3] = {
			[1]={missionid=2144, name="#{SWXT_221213_177}",des="#{SWXT_221213_178}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=615,posX=54,posZ=58,NPCname="墨离",AcceptTimeParam=5},
			[2]={missionid=2145, name="#{SWXT_221213_179}",des="#{SWXT_221213_180}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=615,posX=75,posZ=60,NPCname="墨回",AcceptTimeParam=5},
			[3]={missionid=2146, name="#{SWXT_221213_181}",des="#{SWXT_221213_182}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=615,posX=65,posZ=52,NPCname="阮枫眠",AcceptTimeParam=5},
			[4]={missionid=2147, name="#{SWXT_221213_183}",des="#{SWXT_221213_184}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=615,posX=54,posZ=58,NPCname="墨离",AcceptTimeParam=5},
			[5]={missionid=2148, name="#{SWXT_221213_185}",des="#{SWXT_221213_186}",grade="set:ShengWang01 image:ShengWangAll_JianDan",bonus=10,scene=615,posX=65,posZ=52,NPCname="阮枫眠",AcceptTimeParam=5},
			[6]={missionid=2149, name="#{SWXT_221213_187}",des="#{SWXT_221213_188}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=615,posX=65,posZ=52,NPCname="阮枫眠",AcceptTimeParam=5},
			[7]={missionid=2150, name="#{SWXT_221213_189}",des="#{SWXT_221213_190}",grade="set:ShengWang01 image:ShengWangAll_PuTong",bonus=15,scene=615,posX=62,posZ=52,NPCname="阮枫眠",AcceptTimeParam=5},
			[8]={missionid=2157, name="#{SWXT_221213_191}",des="#{SWXT_221213_192}",grade="set:ShengWang01 image:ShengWangAll_KunNan",bonus=25,scene=615,posX=54,posZ=58,NPCname="墨离",AcceptTimeParam=3},
		},
}

local ShengWangAll_Mission_Num =3


local ShengWangAll_JoinIMGStrFormItem=
{
	[1]={
		[1]="set:ShengWang01 image:Lingyu_MJ2",
		[2]="set:ShengWang01 image:Lingyu_SR2",
		},
	[2]={
		[1]="set:ShengWang01 image:Lingyu_SJ2",
		[2]="set:ShengWang01 image:Lingyu_Z2",
		},
	[3]={
		[1]="set:ShengWang01 image:Lingyu_YD2",
		[2]="set:ShengWang01 image:Lingyu_BS2",
		},
}
local g_ShengWangAll_SelectTextIntro = {"#{SWXT_221213_247}","#{SWXT_221213_248}","#{SWXT_221213_249}"}


function ShengWangAll_PreLoad()
	this:RegisterEvent("UI_COMMAND");
		-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_SHENGWANG_SHOP_INFO")
	this:RegisterEvent("SHOW_SHENGWANG_SHOP_INFO")
	this:RegisterEvent("NEW_MISSION")
	this:RegisterEvent("DELETE_MISSION")
end

function ShengWangAll_OnEvent(event)
	if( event == "ADJEST_UI_POS" ) then
		ShengWangAll_ResetPos()
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		ShengWangAll_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		ShengWangAll_Close()
	elseif event == "PLAYER_LEAVE_WORLD" then
		ShengWangAll_Close()
    elseif event == "SHOW_SHENGWANG_SHOP_INFO" then
        g_ShengWang_TargetID = tonumber(arg0)
        Lua_TDU_Log("g_ShengWang_TargetID"..g_ShengWang_TargetID);
		objCared = DataPool : GetNPCIDByServerID(g_ShengWang_TargetID)
        this:CareObject(objCared, 1, "ShengWangAll");

        g_ShengWang_NPCCampID = tonumber(arg1)
		g_Shengwang_selfPoint = Lua_GetShengwangPoint()
		g_ShengWang_selfCampID = Lua_GetShengwangId()
		g_ShengWang_selfCampState = Lua_GetShengwangState()

		g_ShengWang_Page_Type = tonumber(arg2)
		ShengWangAll_OnShown()

	elseif event == "UPDATE_SHENGWANG_SHOP_INFO" then
		if (IsWindowShow("ShengWangAll")) then
			 --g_ShengWang_TargetID = tonumber(arg0)
			Lua_TDU_Log("g_ShengWang_TargetID"..g_ShengWang_TargetID);
			objCared = DataPool : GetNPCIDByServerID(g_ShengWang_TargetID)
			this:CareObject(objCared, 1, "ShengWangAll");

			g_ShengWang_NPCCampID = tonumber(arg1)
			g_Shengwang_selfPoint = Lua_GetShengwangPoint()
			g_ShengWang_selfCampID = Lua_GetShengwangId()
			g_ShengWang_selfCampState = Lua_GetShengwangState()

			--g_ShengWang_Page_Type = tonumber(arg2)

			ShengWangAll_OnRefresh()
		end


    elseif (event == "OBJECT_CARED_EVENT") then
        Lua_TDU_Log("OBJECT_CARED_EVENT");
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		Lua_TDU_Log("OBJECT_CARED_EVENT tonumber(arg2):"..tonumber(arg2));
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ShengWangAll_Close()
		end
	elseif (event == "NEW_MISSION") then
		if (IsWindowShow("ShengWangAll")) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("RefreshUIForMission")
				Set_XSCRIPT_ScriptID( 890086 )
				Set_XSCRIPT_ParamCount( 0 );
			Send_XSCRIPT()
		end
	elseif (event == "DELETE_MISSION") then
		if (IsWindowShow("ShengWangAll")) then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("RefreshUIForMission")
				Set_XSCRIPT_ScriptID( 890086 )
				Set_XSCRIPT_ParamCount( 0 );
			Send_XSCRIPT()
		end
	elseif( event == "UI_COMMAND" and tonumber(arg0) == 89008602  ) then
		ShengWangAll_Close()
	end
end

function ShengWangAll_OnLoad()
	-- 保存界面的默认相对位置
	g_ShengWangAll_Frame_UnifiedXPosition	= ShengWangAll_Frame:GetProperty("UnifiedXPosition");
    g_ShengWangAll_Frame_UnifiedYPosition	= ShengWangAll_Frame:GetProperty("UnifiedYPosition");
	--商店控件
    for i = 1, g_ShengWang_Shop_PerPage do
        g_ShengWang_Shop_itemctl[i] = {}
        g_ShengWang_Shop_itemctl[i].act  = _G["ShengWangAll_Item"..i]
        g_ShengWang_Shop_itemctl[i].name = _G[string.format("ShengWangAll_ItemInfo%d_Text",i)]
        g_ShengWang_Shop_itemctl[i].money= _G[string.format("ShengWangAll_ItemInfo%d_GB",i)]
        g_ShengWang_Shop_itemctl[i].limit= _G[string.format("ShengWangAll_Item_Amount%d",i)]
    end

	--元宝商店控件
    for i = 1, g_ShengWang_Shop_PerPage do
        g_ShengWang_Shop2_itemctl[i] = {}
        g_ShengWang_Shop2_itemctl[i].act  = _G["ShengWangAll_Shop2Item"..i]
        g_ShengWang_Shop2_itemctl[i].name = _G[string.format("ShengWangAll_Shop2ItemInfo%d_Text",i)]
        g_ShengWang_Shop2_itemctl[i].money= _G[string.format("ShengWangAll_Shop2ItemInfo%d_GB",i)]
        g_ShengWang_Shop2_itemctl[i].limit= _G[string.format("ShengWangAll_Shop2Item_Amount%d",i)]
    end
end

--================================================
-- 界面的默认相对位置
--================================================
function ShengWangAll_ResetPos()
	ShengWangAll_Frame:SetProperty("UnifiedXPosition", g_ShengWangAll_Frame_UnifiedXPosition);
	ShengWangAll_Frame:SetProperty("UnifiedYPosition", g_ShengWangAll_Frame_UnifiedYPosition);
end

function ShengWangAll_Close()
    g_ShengWang_Page3_Curpage = 1

	PushEvent("SHENGWANG_YB_BUY_ITEM_CONFIRM", "close")
	this:Hide();
end

--================================================
--刷新界面
--================================================
function ShengWangAll_OnRefresh()
	if g_ShengWang_Page_Type == 1 then
		ShengWangAll_OnRefreshTask()
	end
	if g_ShengWang_Page_Type == 2 then
		ShengWangAll_OnRefreshShop()
	end
	if g_ShengWang_Page_Type == 3 then
		ShengWangAll_OnRefreshShop2()
	end
end

--================================================
--显示界面
--================================================
function ShengWangAll_OnShown()


	local nTitleStr = ShengWangAll_Title[g_ShengWang_NPCCampID]
	if nTitleStr ~=nil then
		ShengWangAll_DragTitle:SetText(nTitleStr)
	end

	local nImageStr = ShengWangAll_Image[g_ShengWang_NPCCampID]
	if nTitleStr ~=nil then
		ShengWangAll_NpcImage:SetProperty("Image", nImageStr);
	end


	if g_ShengWang_Page_Type == 1 then
		ShengWangAll_OnRefreshTask()
	end
	if g_ShengWang_Page_Type == 2 then
		g_ShengWang_Shop_Curpage = 1
		ShengWangAll_OnRefreshShop()
	end
	if g_ShengWang_Page_Type == 3 then
		g_ShengWang_Shop_Curpage = 1
		ShengWangAll_OnRefreshShop2()
	end

	this:Show();
end

--================================================
--刷新任务页签
--================================================
function ShengWangAll_OnRefreshTask()
	g_ShengWang_selfCampID = Lua_GetShengwangId()
	g_ShengWang_selfCampState = Lua_GetShengwangState()

	local CurWeekPoint = DataPool:GetPlayerMission_DataRound(876)

	local StrValue = ScriptGlobal_Format("#{SWXT_221213_92}", CurWeekPoint)
	ShengWangAll_TaskInfo2:SetText(StrValue)

	if g_ShengWang_selfCampState == 0 then
		--待加入阵营
		ShengWangAll_OnRefreshTaskJoin()
		return
	end
	if g_ShengWang_selfCampState == 1 and g_ShengWang_selfCampID ~=g_ShengWang_NPCCampID  then
		--已加入阵营，玩家阵营不属于当前npc
		ShengWangAll_OnRefreshTaskOther()
		return
	end
	--阵营存在 且属于当前npc，显示任务列表

	ShengWangAll_OnRefreshTaskList()
end

--================================================
--显示加入阵营
--================================================
function ShengWangAll_OnRefreshTaskJoin()
	ShengWangAll_Page:Hide()
	ShengWangAll_LingyuItemBK:Show()

	local  str = ShengWangAll_JoinIMGStrFormItem[g_ShengWang_NPCCampID]
	if str ~= nil then
		ShengWangAll_LingyuItem1 : SetProperty("Image", str[1]);
		ShengWangAll_LingyuItem2 : SetProperty("Image", str[2]);
	end
	ShengWangAll_LingyuItemText:SetText(g_ShengWangAll_SelectTextIntro[g_ShengWang_NPCCampID])

	ShengWangAll_ShopBtn:SetCheck(0)
	ShengWangAll_ShopBtn:Disable()
	ShengWangAll_Shop2Btn:SetCheck(0)
	ShengWangAll_Shop2Btn:Disable()
	ShengWangAll_TaskBtn:SetCheck(1)
	ShengWangAll_TaskBtn:Enable()
--	ShengWangAll_TaskInfo:Show()
--	ShengWangAll_TaskInfo:SetText("#{SWXT_221213_100}")
	ShengWangAll_Task:Show()
	ShengWangAll_Shop:Hide()
	ShengWangAll_Shop2:Hide()
--	ShengWangAll_Task_Text:Hide()

	ShengWangAll_TaskInfoImage:Show()
	ShengWangAll_TaskGet:Show()
	ShengWangAll_TaskGet2:Hide()
	ShengWangAll_Task_ActivateBtn:Hide()
--	ShengWangAll_TaskList_TitleFrame:Hide()
	ShengWangAll_TaskList_List:Hide()

	local  str = ShengWangAll_JoinIMGStr[g_ShengWang_NPCCampID]
	if str ~= nil then
		ShengWangAll_TaskGet : SetProperty("PushedImage", str[1]);
		ShengWangAll_TaskGet : SetProperty("NormalImage", str[2]);
		ShengWangAll_TaskGet : SetProperty("HoverImage", str[3]);
	end

end

--================================================
--不属于此阵营
--================================================
function ShengWangAll_OnRefreshTaskOther()
	ShengWangAll_Page:Hide()
	ShengWangAll_LingyuItemBK:Show()

	local  str = ShengWangAll_JoinIMGStrFormItem[g_ShengWang_NPCCampID]
	if str ~= nil then
		ShengWangAll_LingyuItem1 : SetProperty("Image", str[1]);
		ShengWangAll_LingyuItem2 : SetProperty("Image", str[2]);
	end
	ShengWangAll_LingyuItemText:SetText(g_ShengWangAll_SelectTextIntro[g_ShengWang_NPCCampID])

	ShengWangAll_ShopBtn:SetCheck(0)
	ShengWangAll_ShopBtn:Disable()
	ShengWangAll_Shop2Btn:SetCheck(0)
	ShengWangAll_Shop2Btn:Disable()
	ShengWangAll_TaskBtn:SetCheck(1)
	ShengWangAll_TaskBtn:Disable()
--	ShengWangAll_TaskInfo:Show()
--	ShengWangAll_TaskInfo:SetText("#{SWXT_221213_100}")
	ShengWangAll_Task:Show()
	ShengWangAll_Shop:Hide()
	ShengWangAll_Shop2:Hide()
--	ShengWangAll_Task_Text:Hide()

	ShengWangAll_TaskInfoImage:Hide()
	ShengWangAll_TaskGet:Hide()
	ShengWangAll_TaskGet2:Show()
	ShengWangAll_TaskGet2:SetText("#{SWXT_221213_104}")
--	ShengWangAll_TaskList_TitleFrame:Hide()
	ShengWangAll_TaskList_List:Hide()
	ShengWangAll_Task_ActivateBtn:Hide()
end

--================================================
--当前阵营，显示任务列表
--================================================
function ShengWangAll_OnRefreshTaskList()
	ShengWangAll_Page:Show()
	ShengWangAll_LingyuItemBK:Hide()
	ShengWangAll_ShopBtn:SetCheck(0)
	ShengWangAll_ShopBtn:Enable()
	ShengWangAll_Shop2Btn:SetCheck(0)
	ShengWangAll_Shop2Btn:Enable()
	ShengWangAll_TaskBtn:SetCheck(1)
	ShengWangAll_TaskBtn:Enable()
--	ShengWangAll_TaskInfo:Hide()
	ShengWangAll_Task:Show()
	ShengWangAll_Shop:Hide()
	ShengWangAll_Shop2:Hide()


	ShengWangAll_TaskInfoImage:Hide()
	ShengWangAll_TaskGet:Hide()
	ShengWangAll_TaskGet2:Hide()
--	ShengWangAll_TaskList_TitleFrame:Show()
	ShengWangAll_TaskList_List:Show()
	ShengWangAll_Task_ActivateBtn:Show()

	--local Undo = ShengWangAll_Mission_Num

	ShengWangAll_TaskList_List:Clear()

	for i=1,ShengWangAll_Mission_Num do


		local CanAcceptNum =2

		local doneNum =0
		local nIndex = Lua_GetShengwangMissionIndex(i-1)
		local nDone = Lua_GetShengwangMissionDoneFlag(i-1)

		local tempList = ShengWangAll_MissionInfo[g_ShengWang_selfCampID]
		if tempList ==nil then
			break
		end

		local nMissionList = tempList[nIndex]
		if nMissionList == nil then
			break
		end
		--困难任务特写，如果任务扩展这里要改
		local Mission8flag =0
		--PushDebugMessage("nIndex1="..nIndex)
		--PushDebugMessage("nDone="..nDone)
		--第一个任务完成了
		if nDone == 1 then
			nIndex = Lua_GetShengwangMissionIndex(i-1+3)
			nDone = Lua_GetShengwangMissionDoneFlag(i-1+3)
			doneNum=doneNum+1
			CanAcceptNum=CanAcceptNum-1
			--PushDebugMessage("1")
			if nDone == 1 then
				doneNum=doneNum+1
				CanAcceptNum=CanAcceptNum-1
				--PushDebugMessage("2")
			else
				local nMissionList2 = tempList[nIndex]
				if nMissionList2 == nil then
					break
				end
				--PushDebugMessage("nMissionList2.missionid="..nMissionList2.missionid)
				local isHaveMission = ShengWangAll_CheckHaveMission(nMissionList2.missionid,nMissionList2.AcceptTimeParam)
				if isHaveMission == 1 then
					CanAcceptNum=CanAcceptNum-1
					--PushDebugMessage("3")
				end
			end
		else
			local isHaveMission = ShengWangAll_CheckHaveMission(nMissionList.missionid,nMissionList.AcceptTimeParam)

			if isHaveMission == 1 then
				CanAcceptNum=CanAcceptNum-1
				--PushDebugMessage("4")
				if nIndex == 8 then
					Mission8flag=1
				end
				local nIndex2 = Lua_GetShengwangMissionIndex(i-1+3)
				local nDone2 = Lua_GetShengwangMissionDoneFlag(i-1+3)
				if nDone2 == 1 then
					doneNum=doneNum+1
					CanAcceptNum=CanAcceptNum-1
					--PushDebugMessage("5")
				else
					local nMissionList2 = tempList[nIndex2]
					if nMissionList2 == nil then
						break
					end
					local isHaveMission = ShengWangAll_CheckHaveMission(nMissionList2.missionid,nMissionList2.AcceptTimeParam)
					if isHaveMission == 1 then
						--任务8已经第一个任务已接 第二个不处理
						if Mission8flag == 0 then
							CanAcceptNum=CanAcceptNum-1
							--PushDebugMessage("6")
						end

					end
				end
			else
				local nIndex2 = Lua_GetShengwangMissionIndex(i-1+3)
				local nDone2 = Lua_GetShengwangMissionDoneFlag(i-1+3)

				if nDone2 == 1 then
					doneNum=doneNum+1
					CanAcceptNum=CanAcceptNum-1
					--PushDebugMessage("7")
				else
					local nMissionList2 = tempList[nIndex2]
					if nMissionList2 == nil then
						break
					end
					local isHaveMission = ShengWangAll_CheckHaveMission(nMissionList2.missionid,nMissionList2.AcceptTimeParam)
					if isHaveMission == 1 then
						CanAcceptNum=CanAcceptNum-1
						--PushDebugMessage("8")
					end
				end
			end

		end

		nMissionList = tempList[nIndex]
		if nMissionList == nil then
			break
		end

	--	[1]={missionid=2130, name="",des="",grade=1,bonus=100,scene=1292,posX=50,posZ=50},
		local ItemBar = ShengWangAll_TaskList_List:AddChild( "ShengWangAll_TaskList_Item")
		if ItemBar == nil then
			return
		end

		--是否已领取
		local Shengwang_Text0 = ItemBar:GetSubItem("ShengWangAll_TaskList_ItemMask")
		if doneNum == 2 then
			Shengwang_Text0:Show()
		else
			Shengwang_Text0:Hide()
		end

		--任务名称
		local Shengwang_Text1 = ItemBar:GetSubItem("ShengWangAll_TaskList_Item_Name")
		Shengwang_Text1:SetText(nMissionList.name)

		--任务内容
		local Shengwang_Text2 = ItemBar:GetSubItem("ShengWangAll_TaskList_Item_Info")
		Shengwang_Text2:SetText(nMissionList.des)

		--任务难度
		local Shengwang_Img3 = ItemBar:GetSubItem("ShengWangAll_TaskList_Item_RankImage")
		Shengwang_Img3:SetProperty("Image", nMissionList.grade);

		--任务奖励
		local Shengwang_Text4 = ItemBar:GetSubItem("ShengWangAll_TaskList_Item_RankText2")
		local StrValue = ScriptGlobal_Format("#{SWXT_221213_223}", nMissionList.bonus)
		Shengwang_Text4:SetText(StrValue)


		local nButton_1 = ItemBar:GetSubItem("ShengWangAll_TaskList_AItem_Go")
		nButton_1:SetEvent("MouseLButtonDown", string.format("ShengWangAll_TaskList_AItem_Go_Click(%d)", nIndex))

		--可接任务
		local Shengwang_Text5 = ItemBar:GetSubItem("ShengWangAll_TaskList_Item_RankText3")
		local StrValue = ScriptGlobal_Format("#{SWXT_230919_1}", CanAcceptNum)
		Shengwang_Text5:SetText(StrValue)

	end
	--ShengWangAll_Task_Text:SetText(ScriptGlobal_Format("#{SWXT_221213_92}",Undo,ShengWangAll_Mission_Num))

end

function ShengWangAll_CheckHaveMission(nMissionId,AcceptTimeParam)

	local nCurweek = Lua_GetShengwangWeek()
	local misIndex = DataPool:GetPlayerMissionIndexByID(nMissionId)
	local nAcceptWeek = DataPool:GetPlayerMission_Variable(misIndex, AcceptTimeParam)

	local isHaveMission = DataPool:Lua_IsHaveMission(nMissionId)

	if isHaveMission == 1 and nCurweek ==  nAcceptWeek then
		return 1
	end
	return 0
end

--扫荡
function ShengWangAll_Task_ActivateBtn_Click()
	--等级
	if Player:GetLevel() < 85 then
		PushDebugMessage("#{SWXT_221213_78}")
		return
	end
	--是否属于该势力
	if g_ShengWang_selfCampID ~=g_ShengWang_NPCCampID  then
		PushDebugMessage("#{SWXT_221213_81}")
		return
	end

	local nUndoNum = 0
	for i=1,6 do
		local doneNum =0
		local nIndex = Lua_GetShengwangMissionIndex(i-1)
		local nDone = Lua_GetShengwangMissionDoneFlag(i-1)

		local tempList = ShengWangAll_MissionInfo[g_ShengWang_selfCampID]
		if tempList ==nil then
			return
		end
		local nMissionList = tempList[nIndex]
		if nMissionList == nil then
			return
		end

		local isHaveMission = DataPool:Lua_IsHaveMission(nMissionList.missionid)
		if isHaveMission == 0 and nDone == 0 then
			nUndoNum=nUndoNum+1
		end
	end

	if nUndoNum == 0 then
		PushDebugMessage("#{SWXT_230919_4}")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("SaoDang")
		Set_XSCRIPT_ScriptID( 890086 )
		Set_XSCRIPT_Parameter( 0, g_ShengWang_TargetID );
		Set_XSCRIPT_Parameter( 1, g_ShengWang_NPCCampID );
		Set_XSCRIPT_ParamCount( 2 );
	Send_XSCRIPT()

end

function ShengWangAll_TaskList_AItem_Go_Click(nIndex)

	local tempList = ShengWangAll_MissionInfo[g_ShengWang_selfCampID]
	if tempList ==nil then
		return
	end
	local nMissionList = tempList[nIndex]
	if nMissionList == nil then
		return
	end
--	AutoRunToTargetEx(nMissionList.posX,nMissionList.posZ,nMissionList.scene)
	AutoRuntoTargetExWithName(nMissionList.posX,nMissionList.posZ,nMissionList.scene,nMissionList.NPCname)


end

function ClickShengWangAll_Join()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("JoinCamp")
		Set_XSCRIPT_ScriptID( 890063 )
		Set_XSCRIPT_Parameter( 0, g_ShengWang_TargetID );
		Set_XSCRIPT_Parameter( 1, g_ShengWang_NPCCampID );
		Set_XSCRIPT_ParamCount( 2 );
	Send_XSCRIPT()
end

--================================================
--刷新商店页签
--================================================
function ShengWangAll_OnRefreshShop()
	ShengWangAll_Page:Show()
	ShengWangAll_ShopBtn:SetCheck(1)
	ShengWangAll_Shop2Btn:SetCheck(0)
	ShengWangAll_TaskBtn:SetCheck(0)
	ShengWangAll_Task:Hide()
	ShengWangAll_Shop2:Hide()
	ShengWangAll_Shop:Show()

    for i = 1, table.getn(g_ShengWang_Shop_itemctl) do
        g_ShengWang_Shop_itemctl[i].name:SetText("")
        g_ShengWang_Shop_itemctl[i].money:SetText("")
        g_ShengWang_Shop_itemctl[i].limit:SetText("")
        g_ShengWang_Shop_itemctl[i].act:SetActionItem(-1)
    end

    local tblinfo= Lua_GetShengwangShopData(g_ShengWang_selfCampID, g_ShengWang_Shop_Curpage, g_ShengWang_Shop_PerPage)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if table.getn(tblinfo) > table.getn(g_ShengWang_Shop_itemctl) then
        PushDebugMessage("data over size")
        return
    end


    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)

        g_ShengWang_Shop_itemctl[i].name:SetText(itemname)

		g_ShengWang_Shop_itemctl[i].money:SetText(ScriptGlobal_Format("#{SWXT_221213_88}",tblinfo[i].daibinum) )


        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local limitweek= tblinfo[i].limitweek
		local limitweek_self= tblinfo[i].limitweek_self
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_ShengWang_Shop_itemctl[i].act:SetActionItem(theAction:GetID())
        end
        if limitweek <= 0 then
            g_ShengWang_Shop_itemctl[i].limit:Hide()
        else
            g_ShengWang_Shop_itemctl[i].limit:Hide()
            --g_ShengWang_Shop_itemctl[i].limit:SetText(ScriptGlobal_Format("#{ZCSD_220802_35}",limitweek_self) )
            g_ShengWang_Shop_itemctl[i].act:SetProperty("CornerChar","TopLeft "..limitweek_self )
            if limitweek_self <= 0 then
                g_ShengWang_Shop_itemctl[i].act:Disable()
            else
                g_ShengWang_Shop_itemctl[i].act:Enable()
            end
        end

    end
	ShengWangAll_Shop_Num_Text:SetText("#{SWXT_221213_87}"..g_Shengwang_selfPoint)

    if g_ShengWang_Shop_Curpage == 1 then
        ShengWangAll_ShopUpPage:Disable()
    else
        ShengWangAll_ShopUpPage:Enable()
    end

    if g_ShengWang_Shop_Curpage*g_ShengWang_Shop_PerPage >= Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID) then
        ShengWangAll_ShopDownPage:Disable()
    else
        ShengWangAll_ShopDownPage:Enable()
    end

    local npagecount = 0
    if Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID) <= g_ShengWang_Shop_PerPage then
        npagecount = 1
    elseif math.mod(Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID), g_ShengWang_Shop_PerPage) == 0  then
        npagecount = math.floor(Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID)/g_ShengWang_Shop_PerPage)
    else
        npagecount = math.floor(Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID)/g_ShengWang_Shop_PerPage) + 1
    end
    ShengWangAll_ShopCurrentlyPage:SetText( g_ShengWang_Shop_Curpage.."/"..npagecount)

end

--================================================
--刷新元宝商店页签
--================================================
function ShengWangAll_OnRefreshShop2()
	ShengWangAll_Page:Show()
	ShengWangAll_Shop2Btn:SetCheck(1)
	ShengWangAll_ShopBtn:SetCheck(0)
	ShengWangAll_TaskBtn:SetCheck(0)
	ShengWangAll_Task:Hide()
	ShengWangAll_Shop:Hide()
	ShengWangAll_Shop2:Show()

    for i = 1, table.getn(g_ShengWang_Shop2_itemctl) do
        g_ShengWang_Shop2_itemctl[i].name:SetText("")
        g_ShengWang_Shop2_itemctl[i].money:SetText("")
        g_ShengWang_Shop2_itemctl[i].limit:SetText("")
        g_ShengWang_Shop2_itemctl[i].act:SetActionItem(-1)
    end

	local check  = tonumber(NpcShop:GetShengWangYBDirectly())
    if check >= 1 then
        ShengWangAll_Shop2_querengoumai:SetCheck(0)
    else
        ShengWangAll_Shop2_querengoumai:SetCheck(1)
    end
    local tblinfo= Lua_GetShengwangYBShopData(g_ShengWang_selfCampID, g_ShengWang_Shop_Curpage, g_ShengWang_Shop_PerPage)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if table.getn(tblinfo) > table.getn(g_ShengWang_Shop2_itemctl) then
        PushDebugMessage("data over size")
        return
    end


    for i = 1, table.getn(tblinfo) do
        local itemname = DataPool:LuaFnGetItemNameByTableIndex(tblinfo[i].itemid)

        g_ShengWang_Shop2_itemctl[i].name:SetText(itemname)

		g_ShengWang_Shop2_itemctl[i].money:SetText(ScriptGlobal_Format("#{SWXT_221213_197}",tblinfo[i].daibinum) )


        local id = tblinfo[i].itemid
        local num= tblinfo[i].itemnum
        local limitweek= tblinfo[i].limitweek
		local limitweek_self= tblinfo[i].limitweek_self
        local theAction = DataPool:CreateBindActionItemForShow(id, num)
	    if theAction:GetID() ~= 0 then
	    	g_ShengWang_Shop2_itemctl[i].act:SetActionItem(theAction:GetID())
        end
        if limitweek <= 0 then
            g_ShengWang_Shop2_itemctl[i].limit:Hide()
        else
            g_ShengWang_Shop2_itemctl[i].limit:Hide()
            --g_ShengWang_Shop_itemctl[i].limit:SetText(ScriptGlobal_Format("#{ZCSD_220802_35}",limitweek_self) )
            g_ShengWang_Shop2_itemctl[i].act:SetProperty("CornerChar","TopLeft "..limitweek_self )
            if limitweek_self <= 0 then
                g_ShengWang_Shop2_itemctl[i].act:Disable()
            else
                g_ShengWang_Shop2_itemctl[i].act:Enable()
            end
        end

    end

	--ShengWangAll_Shop2_Num_Text:SetText("#{SWXT_221213_87}"..g_Shengwang_selfPoint)
	ShengWangAll_Shop2_Num_Text:Hide()

    if g_ShengWang_Shop_Curpage == 1 then
        ShengWangAll_Shop2UpPage:Disable()
    else
        ShengWangAll_Shop2UpPage:Enable()
    end

    if g_ShengWang_Shop_Curpage*g_ShengWang_Shop_PerPage >= Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID) then
        ShengWangAll_Shop2DownPage:Disable()
    else
        ShengWangAll_Shop2DownPage:Enable()
    end

    local npagecount = 0
    if Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID) <= g_ShengWang_Shop_PerPage then
        npagecount = 1
    elseif math.mod(Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID), g_ShengWang_Shop_PerPage) == 0  then
        npagecount = math.floor(Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID)/g_ShengWang_Shop_PerPage)
    else
        npagecount = math.floor(Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID)/g_ShengWang_Shop_PerPage) + 1
    end
    ShengWangAll_Shop2CurrentlyPage:SetText( g_ShengWang_Shop_Curpage.."/"..npagecount)

end

--================================================
--点击任务页签
--================================================
function ClickShengWangAll_TaskBtn()

	g_ShengWang_Page_Type = 1
	ShengWangAll_OnShown()

end

--================================================
--点击商店页签
--================================================
function ClickShengWangAll_ShopBtn()
	g_ShengWang_selfCampID = Lua_GetShengwangId()
	g_ShengWang_selfCampState = Lua_GetShengwangState()
	if g_ShengWang_selfCampID == 0 or g_ShengWang_selfCampState == 0 then
		return
	end
	g_ShengWang_Page_Type = 2
	ShengWangAll_OnShown()
end

--================================================
--点击元宝商店页签
--================================================
function ClickShengWangAll_Shop2Btn()
	g_ShengWang_selfCampID = Lua_GetShengwangId()
	g_ShengWang_selfCampState = Lua_GetShengwangState()
	if g_ShengWang_selfCampID == 0 or g_ShengWang_selfCampState == 0 then
		return
	end
	g_ShengWang_Page_Type = 3
	ShengWangAll_OnShown()
end



--================================================
--点击商店道具购买
--================================================
function ShengWangAll_GoodButton_Clicked(index)
    local tblinfo= Lua_GetShengwangShopData(g_ShengWang_selfCampID, g_ShengWang_Shop_Curpage, g_ShengWang_Shop_PerPage)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("buyitem")
		Set_XSCRIPT_ScriptID( 890063 )
		Set_XSCRIPT_Parameter( 0, g_ShengWang_TargetID );
		Set_XSCRIPT_Parameter( 1, g_ShengWang_selfCampID );
		Set_XSCRIPT_Parameter( 2, tblinfo[index].itemid );
		Set_XSCRIPT_ParamCount( 3 );
	Send_XSCRIPT()

end

--================================================
--点击商店下一页
--================================================
function ShengWangAll_PageDown()
    if g_ShengWang_Shop_Curpage*g_ShengWang_Shop_PerPage < Lua_GetShengwangShopTotalCount(g_ShengWang_selfCampID) then
        g_ShengWang_Shop_Curpage = g_ShengWang_Shop_Curpage + 1
        ShengWangAll_OnRefreshShop()
    end
end

--================================================
--点击商店上一页
--================================================
function ShengWangAll_PageUp()
    if g_ShengWang_Shop_Curpage > 1 then
        g_ShengWang_Shop_Curpage = g_ShengWang_Shop_Curpage - 1
        ShengWangAll_OnRefreshShop()
    end
end



--================================================
--点击元宝商店道具购买
--================================================
function ShengWangAll_GoodButton2_Clicked(index)
    local tblinfo= Lua_GetShengwangYBShopData(g_ShengWang_selfCampID, g_ShengWang_Shop_Curpage, g_ShengWang_Shop_PerPage)
	if type(tblinfo) ~= "table" then
		PushDebugMessage("error")
		return
    end

    if tblinfo[index] == nil or tblinfo[index].itemid <= 0 then
        return
    end

	local isconfirm = ShengWangAll_Shop2_querengoumai:GetCheck()

    if isconfirm == 0 then

		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("YBbuyitem")
			Set_XSCRIPT_ScriptID( 890063 )
			Set_XSCRIPT_Parameter( 0, g_ShengWang_TargetID );
			Set_XSCRIPT_Parameter( 1, g_ShengWang_selfCampID );
			Set_XSCRIPT_Parameter( 2, tblinfo[index].itemid );
			Set_XSCRIPT_ParamCount( 3 );
		Send_XSCRIPT()
	else
        PushEvent("SHENGWANG_YB_BUY_ITEM_CONFIRM", "open", tblinfo[index].itemid, tblinfo[index].daibinum, g_ShengWang_selfCampID,g_ShengWang_TargetID)
    end

end

--================================================
--点击元宝商店下一页
--================================================
function ShengWangAll_PageDown2()
    if g_ShengWang_Shop_Curpage*g_ShengWang_Shop_PerPage < Lua_GetShengwangYBShopTotalCount(g_ShengWang_selfCampID) then
        g_ShengWang_Shop_Curpage = g_ShengWang_Shop_Curpage + 1
        ShengWangAll_OnRefreshShop2()
    end
end

--================================================
--点击元宝商店上一页
--================================================
function ShengWangAll_PageUp2()
    if g_ShengWang_Shop_Curpage > 1 then
        g_ShengWang_Shop_Curpage = g_ShengWang_Shop_Curpage - 1
        ShengWangAll_OnRefreshShop2()
    end
end

function ShengWangAll_Shop2_querengoumai_Clicked()
    if(NpcShop:GetShengWangYBDirectly() == 0)then
        ShengWangAll_Shop2_querengoumai:SetCheck(0)
        NpcShop:SetShengWangYBDirectly(1)
    else
        ShengWangAll_Shop2_querengoumai:SetCheck(1)
        NpcShop:SetShengWangYBDirectly(0)
    end

end
