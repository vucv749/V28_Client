----------------------
--2023Q4时装随机宝箱
--兑奖界面
----------------------
--界面位置
local g_UnifiedPosition = nil

--数据
local g_DaiBiNum = 0
local g_DuiHuanNum = 0
local g_MaxDuiHuan = 3

--控件相关
local g_DuiHuanCtrl = {}

--兑换规则
local g_DuiHuan = 
{
	[1] = { value = 600, id = 10125349, num = 1, },
	[2] = { value = 300, id = 38002172, num = 1, },
	[3] = { value = 5, id = 30503140, num = 1, },
	[4] = { value = 150, id = 10124290, num = 1, },
	[5] = { value = 150, id = 10124447, num = 1, },

}

--===============================================
-- PreLoad()
--===============================================
function Fashion_Box_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

--===============================================
-- OnLoad()
--===============================================
function Fashion_Box_OnLoad()
	g_UnifiedPosition = Fashion_Box_Frame:GetProperty("UnifiedPosition")	
	g_DuiHuanCtrl = 
	{
		[1] = {icon=Fashion_Box_Exchange_Item1_Icon,text=Fashion_Box_Exchange_Item1_Text,text2=Fashion_Box_Exchange_Item1_Text2,},
		[2] = {icon=Fashion_Box_Exchange_Item2_Icon,text=Fashion_Box_Exchange_Item2_Text,text2=Fashion_Box_Exchange_Item2_Text2,},
		[3] = {icon=Fashion_Box_Exchange_Item3_Icon,text=Fashion_Box_Exchange_Item3_Text,text2=Fashion_Box_Exchange_Item3_Text2,},
		[4] = {icon=Fashion_Box_Exchange_Item4_Icon,text=Fashion_Box_Exchange_Item4_Text,text2=Fashion_Box_Exchange_Item4_Text2,},
		[5] = {icon=Fashion_Box_Exchange_Item5_Icon,text=Fashion_Box_Exchange_Item5_Text,text2=Fashion_Box_Exchange_Item5_Text2,},
	}	
end

--===============================================
-- OnEvent()
--===============================================
function Fashion_Box_OnEvent(event)
	if (event  == "UI_COMMAND") and (tonumber(arg0) == 99853101) then
		--打开/关闭/刷新界面
		local flag = Get_XParam_INT(0) 
		if flag ~= nil and flag == 2 then
			--关界面
			if this:IsVisible() then
				Fashion_Box_Close_Click()
			end
		else
			-- 开界面or刷新界面
			g_DaiBiNum = tonumber(Get_XParam_INT(1))
			g_DuiHuanNum = tonumber(Get_XParam_INT(2))
			if flag == 1 then--开界面
				this:Show()
				Fashion_Box_Exchange_Update()
			else--仅刷新
				if( this:IsVisible() ) then
					Fashion_Box_Exchange_Update()
				end
			end
		end
	elseif (event == "ADJEST_UI_POS") then
		Fashion_Box_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Fashion_Box_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Fashion_Box_Close_Click()
	end
end

--===============================================
--兑换页-刷新
--===============================================
function Fashion_Box_Exchange_Update()
	--拥有代币
	Fashion_Box_TextNum:SetText(ScriptGlobal_Format("#{SZSJ_231114_37}", g_DaiBiNum))
	--具体图标文本
	for i = 1, table.getn(g_DuiHuan) do
		local theAction = DataPool:CreateBindActionItemForShow(g_DuiHuan[i].id, g_DuiHuan[i].num)
		if theAction:GetID() ~= 0 then
			--道具
			g_DuiHuanCtrl[i].icon:SetActionItem(theAction:GetID())
			--消耗
			g_DuiHuanCtrl[i].text:SetText(ScriptGlobal_Format("#{SZSJ_231114_25}", g_DuiHuan[i].value))
			--特写限购
			if i==2 then
				g_DuiHuanCtrl[i].text2:Show()
				if g_DuiHuanNum >= g_MaxDuiHuan then
					g_DuiHuanCtrl[i].text2:SetText("#{SZSJ_231114_27}")
				else
					g_DuiHuanCtrl[i].text2:SetText(ScriptGlobal_Format("#{SZSJ_231114_26}", g_MaxDuiHuan-g_DuiHuanNum))
				end
			else
				g_DuiHuanCtrl[i].text2:Hide()
			end
		end
	end
end

--===============================================
--重置
--===============================================
function Fashion_Box_ResetPos()
	Fashion_Box_Frame:SetProperty("UnifiedPosition",g_UnifiedPosition)
end

--===============================================
--清空
--===============================================
function Fashion_Box_Clear()
	g_DaiBiNum = 0
	g_DuiHuanNum = 0
end

--===============================================
--关闭
--===============================================
function Fashion_Box_Close_Click()
	--数据清空
	Fashion_Box_Clear()
	--界面隐藏
	this:Hide()
end

--===============================================
--兑换页-点击
--===============================================
function Fashion_Box_Exchange_Click(nIndex)
	if nIndex == nil then
		return
	end
	if g_DuiHuan[nIndex] == nil then
		return
	end
	--兑换
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "OnDuiHuan" )
		Set_XSCRIPT_ScriptID( 998531 )
		Set_XSCRIPT_Parameter(0,nIndex)
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
end

--===============================================
--小问号
--===============================================
function Fashion_Box_HelpClicked()
	PushEvent("CCSHOP_HELP", 21)
end

--===============================================
--打开元宝商店
--===============================================
function Fashion_Box_ShopClicked()
	ToggleYuanbaoShop()
end

--===============================================
--时装预览
--===============================================
function Fashion_Box_ItemPreview()
	PushEvent("OPEN_DRESSPREVIEW", 10125349, 81, 52) --时装\发型\脸型
end
