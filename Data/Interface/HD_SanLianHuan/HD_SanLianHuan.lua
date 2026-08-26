
local TBL_Item = {}
local TBL_Img = {}
local TBL_NEW = {}

local g_pos_ui = 1
local g_ItemActionNum = 8

local ObjCaredID = -1

local g_Frame_UnifiedPosition;

--宝箱属性
local g_BoxList =
{
	{ money_num = 5,  times = 0, maxTime = 10, 	tips1 = "#{JXSLH_130508_26}", tips2 = "#{JXSLH_130508_22}",  cost_text = "#{JXSLH_130508_15}"},
	{ money_num = 30, times = 0, maxTime = 10, tips1 = "#{JXSLH_130508_36}", tips2 = "#{JXSLH_130508_34}", cost_text = "#{JXSLH_130508_17}" },
	{ money_num = 500, times = 0, maxTime = 10,	tips1 = "#{JXSLH_130508_40}", tips2 = "#{JXSLH_130508_47}", cost_text = "#{JXSLH_130508_18}"},
}



local g_item =   
{
	{
		{id=30000000,num=5,new=0},
		{id=30000000,num=1,new=0},
		{id=30000000,num=1,new=1},
		{id=30000000,num=1,new=0},
		{id=30000000,num=1,new=0},
		{id=30000000,num=1,new=0},
		{id=30000000,num=1,new=1},
		{id=30000000,num=40,new=0},
	 },     
 
 
	 {
		{id=30000000,num=5,  new=0},
		{id=30000000,num=1,  new=0},
		{id=30000000,num=1,  new=0},
		{id=30000000,num=200,new=0},
		{id=30000000,num=1,  new=1},
		{id=30000000,num=1,  new=1},
		{id=30000000,num=1,  new=1},
		{id=30000000,num=3,  new=1},
	},        


	{
		{id=30000000,num=1,		new=1},
		{id=30000000,num=1,		new=1},
		{id=30000000,num=1,		new=1},
		{id=30000000,num=1,		new=1},
		{id=30000000,num=50,	new=1},
		{id=30000000,num=1,		new=1},
		{id=30000000,num=50,	new=0},
		{id=30000000,num=400,	new=0},
	},        
}


function HD_SanLianHuan_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
end

function HD_SanLianHuan_OnLoad()
	TBL_Item[1] = HD_SanLianHuan_Item1
	TBL_Item[2] = HD_SanLianHuan_Item2
	TBL_Item[3] = HD_SanLianHuan_Item3
	TBL_Item[4] = HD_SanLianHuan_Item4
	TBL_Item[5] = HD_SanLianHuan_Item5
	TBL_Item[6] = HD_SanLianHuan_Item6
	TBL_Item[7] = HD_SanLianHuan_Item7
	TBL_Item[8] = HD_SanLianHuan_Item8

	TBL_Img[1] = HD_SanLianHuan_1_Image
	TBL_Img[2] = HD_SanLianHuan_2_Image
	TBL_Img[3] = HD_SanLianHuan_3_Image
	TBL_Img[4] = HD_SanLianHuan_4_Image
	TBL_Img[5] = HD_SanLianHuan_5_Image
	TBL_Img[6] = HD_SanLianHuan_6_Image
	TBL_Img[7] = HD_SanLianHuan_7_Image
	TBL_Img[8] = HD_SanLianHuan_8_Image

	TBL_NEW[1] = HD_SanLianHuan_1_ExItemIcon
	TBL_NEW[2] = HD_SanLianHuan_2_ExItemIcon
	TBL_NEW[3] = HD_SanLianHuan_3_ExItemIcon
	TBL_NEW[4] = HD_SanLianHuan_4_ExItemIcon
	TBL_NEW[5] = HD_SanLianHuan_5_ExItemIcon
	TBL_NEW[6] = HD_SanLianHuan_6_ExItemIcon
	TBL_NEW[7] = HD_SanLianHuan_7_ExItemIcon
	TBL_NEW[8] = HD_SanLianHuan_8_ExItemIcon

	g_Frame_UnifiedPosition = HD_SanLianHuan_Frame:GetProperty("UnifiedPosition");
end

function HD_SanLianHuan_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 20130513) then
			-- ObjCaredID = DataPool : GetNPCIDByServerID(Get_XParam_INT(3))
			-- if ObjCaredID == -1 then
				-- PushDebugMessage("server传过来的数据有问题。");
				-- return
			-- end
			-- this:CareObject(ObjCaredID, 1, "HD_SanLianHuan")
			
			local s1 = Get_XParam_STR(0)
			local s2 = Get_XParam_STR(1)
			local s3 = Get_XParam_STR(2)
			local sc = Get_XParam_STR(3)

			ParseItemStrToTable(1, s1)
			ParseItemStrToTable(2, s2)
			ParseItemStrToTable(3, s3)
			ParseCostStr(sc)

			--更新次数
			HD_SanLianHuan_update_times(Get_XParam_INT(0), Get_XParam_INT(1), Get_XParam_INT(2))

			--更新领奖确认框
			-- local check  = tonumber(DataPool:GetSanLianHuanCheck())
			-- if(check>=1)then
				-- HD_SanLianHuan_QueRen:SetCheck(1)
			-- else
				-- HD_SanLianHuan_QueRen:SetCheck(0)
			-- end

			--显示分页框
			if g_BoxList[1].times > 0 then
				HD_SanLianHuan_Update_Item(1)
				HD_SanLianHuan_JinBi:SetCheck(1)

			elseif g_BoxList[2].times > 0 then
				HD_SanLianHuan_Update_Item(2)
				HD_SanLianHuan_YuanBao1:SetCheck(1)

			elseif g_BoxList[3].times > 0 then
				HD_SanLianHuan_Update_Item(3)
				HD_SanLianHuan_YuanBao2:SetCheck(1)

			else
				HD_SanLianHuan_Update_Item(1)
				HD_SanLianHuan_JinBi:SetCheck(1)
			end

			this:Show()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20130514) then
		local pos = Get_XParam_INT(0)
		HD_SanLianHuan_update_times(Get_XParam_INT(1), Get_XParam_INT(2), Get_XParam_INT(3))

		if pos < 1 or pos > 3 then
			return
		end

		if pos ~= g_pos_ui then
			return
		end

		HD_SanLianHuan_Update_State()

		--点亮获得的物品
		local ItemId = Get_XParam_INT(4)
		local Itemnum = Get_XParam_INT(5)
		for i = 1 , g_ItemActionNum do
			if g_item[g_pos_ui][i].id == ItemId and g_item[g_pos_ui][i].num == Itemnum then
				TBL_Img[i]:Show()
				break
			end
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20130515) then
		local index = Get_XParam_INT(0)
		if index < 1 or index > 3 then
			return
		end
		HD_SanLianHuan_ChouQu_Button:Show()
		HD_SanLianHuan_ChouQu_Button2:Hide()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 20130516) then
		local index = tonumber(arg1)
		if index < 1 or index > 3 then
			return
		end

		HD_SanLianHuan_ChouQu_Button:Hide()
		HD_SanLianHuan_ChouQu_Button2:Show()

	-- 游戏窗口尺寸发生了变化
	elseif (event == "ADJEST_UI_POS" ) then
		HD_SanLianHuan_On_ResetPos()
	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		HD_SanLianHuan_On_ResetPos()
	end
end

function HD_SanLianHuan_On_ResetPos()
	HD_SanLianHuan_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition);
end

function HD_SanLianHuan_Img_Hide()
	for i = 1 , g_ItemActionNum do
		TBL_Img[i]:Hide()
	end
end

function HD_SanLianHuan_Update_State()
	--更新次数

	local text

	if g_pos_ui == 1 then
		text = ScriptGlobal_Format("#{JXSLH_130508_16}",tostring(g_BoxList[g_pos_ui].times), tostring(g_BoxList[g_pos_ui].maxTime))
	else
		text = "#cfff263今日剩余次数：不限次"
	end

	--local text = ScriptGlobal_Format("#{JXSLH_130508_16}",tostring(g_BoxList[g_pos_ui].times), tostring(g_BoxList[g_pos_ui].maxTime))
	HD_SanLianHuan_1_text02:SetText(text)

	--更新按钮状态
	HD_SanLianHuan_ChouQu_Button:Show()
	HD_SanLianHuan_ChouQu_Button2:Hide()

	if g_BoxList[g_pos_ui].times > 0 then
		HD_SanLianHuan_ChouQu_Button:Enable()
	else
		HD_SanLianHuan_ChouQu_Button:Disable()
	end

	--更新花费数量
	HD_SanLianHuan_1_text01:SetText(g_BoxList[g_pos_ui].cost_text)
end

function HD_SanLianHuan_Update_Item(pos_ui)
	-- 参数校验
	if pos_ui < 1 or pos_ui > 3 then
		return
	end

	-- 隐藏点亮图标
	HD_SanLianHuan_Img_Hide()

	g_pos_ui = pos_ui

	for i = 1, g_ItemActionNum do
		TBL_Item[i]:SetProperty("CornerChar", "BotRight")
		local iid = g_item[g_pos_ui][i].id
		if iid and iid > 0 then
			local itemAction = DataPool:CreateActionItemForShow(iid, 1)
			if itemAction and itemAction:GetID() ~= 0 then
				TBL_Item[i]:SetActionItem(itemAction:GetID())
				-- 数量角标
				if g_item[g_pos_ui][i].num and g_item[g_pos_ui][i].num ~= 1 then
					local num = "BotRight" .. " " .. tostring(g_item[g_pos_ui][i].num)
					TBL_Item[i]:SetProperty("CornerChar", num)
				end
			else
				TBL_Item[i]:SetActionItem(-1)
			end
		else
			TBL_Item[i]:SetActionItem(-1)
		end
		-- NEW 标识
		if g_item[g_pos_ui][i].new == 1 then
			TBL_NEW[i]:Show()
		else
			TBL_NEW[i]:Hide()
		end
	end
dlog("006")
	-- 更新次数/按钮/花费等
	HD_SanLianHuan_Update_State()
end

function HD_SanLianHuan_update_times( Coin_Times, YuanBao_Times1, YuanBao_Times2 )
	g_BoxList[1].times = Coin_Times
	g_BoxList[2].times = YuanBao_Times1
	g_BoxList[3].times = YuanBao_Times2
end

function HD_SanLianHuan_Clicked()
	-- if(DataPool:GetSanLianHuanCheck() == 0)then
		-- DataPool:SetSanLianHuanCheck(1);
	-- else
		-- DataPool:SetSanLianHuanCheck(0);
	-- end
end

function HD_SanLianHuan_Clicked_ChouQu()
	-- 客户端等级限制
	if  Player:GetData("LEVEL") < 30 then
		PushDebugMessage("#{JXSLH_130508_21}")
		return
	end

	-- -- 检测安全时间
	-- if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		-- PushDebugMessage("#{JXSLH_130508_23}")
		-- return
	-- end

	-- -- 二级密码 电话密保检查
	-- if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		-- PushDebugMessage("#{JXSLH_130508_24}")
		-- return
	-- end

	--判断 元宝数 次数
	local num = Player:GetData("YUANBAO")
	if num < g_BoxList[g_pos_ui].money_num then
		PushDebugMessage(g_BoxList[g_pos_ui].tips1)
		return
	end

	if g_BoxList[g_pos_ui].times <= 0 then
		PushDebugMessage(g_BoxList[g_pos_ui].tips2)
		return
	end

	HD_SanLianHuan_Img_Hide()

	-- local check  = tonumber(DataPool:GetSanLianHuanCheck())
	-- if check >= 1 then
		-- PushEvent( "HUDONG_SANLIANHUAN_MESSAGE", "open", g_pos_ui, ObjCaredID )
	-- else
		HD_SanLianHuan_ChouQu_Button:Hide()
		HD_SanLianHuan_ChouQu_Button2:Show()
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("MSOnAuguryEx");
			Set_XSCRIPT_ScriptID(1024);
			Set_XSCRIPT_Parameter(0,g_pos_ui);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	-- end
end

function HD_SanLianHuan_Clicked_ChouQu1()
	PushDebugMessage("#{JXSLH_130508_54}")
end

function HD_SanLianHuan_FenYe_Clicked(pos_ui)
	if pos_ui == g_pos_ui then
		return
	end

	if HD_SanLianHuan_ChouQu_Button2:IsVisible() then
		PushDebugMessage("#{JXSLH_130508_50}")
		return
	end

	-- PushEvent( "HUDONG_SANLIANHUAN_MESSAGE", "close", g_pos_ui, ObjCaredID )

	HD_SanLianHuan_Update_Item(pos_ui)
end

function HD_SanLianHuan_Hide()
	this:Hide()
end


function ParseItemStrToTable(pos, s)
	if s == nil or s == "" then return end

	local pairs = string.split(s, "|")
	local idx = 1

	while pairs[idx] do
		local one = pairs[idx]
		if one ~= nil and one ~= "" then
			local kv = string.split(one, ",")
			local id = tonumber(kv[1]) or 0
			local itemcn = tonumber(kv[2]) or 0

			if idx <= 8 then
				g_item[pos][idx].id  = id
				g_item[pos][idx].new = math.mod(itemcn, 10)
				g_item[pos][idx].num = math.floor(itemcn / 10)
			end
		end
		idx = idx + 1
	end
end


function ParseCostStr(s)
	if s == nil or s == "" then return end

	local arr = string.split(s, ",")
	if arr[1] then g_BoxList[1].money_num = tonumber(arr[1]) or g_BoxList[1].money_num end
	if arr[2] then g_BoxList[2].money_num = tonumber(arr[2]) or g_BoxList[2].money_num end
	if arr[3] then g_BoxList[3].money_num = tonumber(arr[3]) or g_BoxList[3].money_num end
end
