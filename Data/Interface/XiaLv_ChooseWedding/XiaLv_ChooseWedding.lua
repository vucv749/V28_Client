-- 结婚
--!!!reloadscript =XiaLv_ChooseWedding

local g_unifiedposistion = nil
local g_ServerNpc = -1

local g_ScriptId = -1
local g_IsZhuDong = 1

local g_UICommand_Open = 80602101
local g_UICommand_Close = 80602102
local g_UICommand_Update = 80602103

local g_NeedText = {
	[1] = "#{JHYH_230330_279}",
	[2] = "#{JHYH_230330_280}",
	[3] = "#{JHYH_230330_281}",
	[4] = "#{JHYH_230330_282}",
}

local g_NeedItem = {
	[3] = 30505079,		--高级婚礼券
	[4] = 38002832,		--挚梦婚礼券
}

local g_ReexperienceWedding = 808122		--重温脚本id
local g_ZhiMengWedding = 4

local g_SelectWedding = 1 --选择婚礼 普通 高级 豪华 挚梦
local g_SelectDetail = 1 --婚礼选项 场地预览 婚礼流程预览 花车预览
local g_SelectImage = 1	--具体哪张图 时装可能有多张图

local g_Image = {}
g_Image[1] = {	--普通婚礼
	{"set:Xialv02 image:XiaLv_MarryChoose_Image5"}, --场地
	{"set:Xialv05 image:XiaLv_MarryChoose_Image22"}, --时装
	{"set:Xialv06 image:XiaLv_MarryChoose_Image17",	--司仪2
	"set:Xialv08 image:XiaLv_MarryChoose_Image19",	--远景对拜2
	"set:Xialv02 image:XiaLv_MarryChoose_Image1",	--拜堂01
	"set:Xialv03 image:XiaLv_MarryChoose_Image13",	--定情物2
	"set:Xialv06 image:XiaLv_MarryChoose_Image15",	--抛绣球2
	},	--婚礼流程预览
	{"set:Xialv03 image:XiaLv_MarryChoose_Image9"}, --花车
}

g_Image[2] = { --高级婚礼
	{"set:Xialv03 image:XiaLv_MarryChoose_Image6"},
	{"set:Xialv05 image:XiaLv_MarryChoose_Image23"},
	{"set:Xialv06 image:XiaLv_MarryChoose_Image17",	--司仪2
	"set:Xialv08 image:XiaLv_MarryChoose_Image19",	--远景对拜2
	"set:Xialv02 image:XiaLv_MarryChoose_Image2",	--拜堂02
	"set:Xialv03 image:XiaLv_MarryChoose_Image13",	--定情物2
	"set:Xialv06 image:XiaLv_MarryChoose_Image15",	--抛绣球2
	},	--婚礼流程预览
	{"set:Xialv03 image:XiaLv_MarryChoose_Image10"},
}

g_Image[3] = { --豪华婚礼
	{"set:Xialv03 image:XiaLv_MarryChoose_Image7"},
	{"set:Xialv08 image:XiaLv_MarryChoose_Image24"},
	{"set:Xialv06 image:XiaLv_MarryChoose_Image17",	--司仪2
	"set:Xialv08 image:XiaLv_MarryChoose_Image19",	--远景对拜2
	"set:Xialv02 image:XiaLv_MarryChoose_Image3",	--拜堂03
	"set:Xialv03 image:XiaLv_MarryChoose_Image13",	--定情物2
	"set:Xialv06 image:XiaLv_MarryChoose_Image15",	--抛绣球2
	},	--婚礼流程预览
	{"set:Xialv03 image:XiaLv_MarryChoose_Image11"},
}

g_Image[4] = { --挚梦婚礼
	{"set:Xialv03 image:XiaLv_MarryChoose_Image8"},
	{"set:Xialv09 image:XiaLv_MarryChoose_Image25"},
	{"set:Xialv06 image:XiaLv_MarryChoose_Image16",	--司仪1
	"set:Xialv06 image:XiaLv_MarryChoose_Image18",	--远景对拜1
	"set:Xialv02 image:XiaLv_MarryChoose_Image4",	--拜堂04
	"set:Xialv03 image:XiaLv_MarryChoose_Image12",	--定情物1
	"set:Xialv06 image:XiaLv_MarryChoose_Image14",	--抛绣球1
	},	--婚礼流程预览
	{"set:Xialv03 image:XiaLv_MarryChoose_Image11"},
	{"set:Xialv09 image:XiaLv_MarryChoose_Image26"}, --金约
}


local g_WeddingButton = {}
local g_DetailButton = {}

local g_WeddingButton_Reexperience = {}
local g_DetailButton_Reexperience = {}


function XiaLv_ChooseWedding_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("PLAYER_ENTERING_WORLD")		-- 进入游戏世界

	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");

end

function XiaLv_ChooseWedding_OnLoad()
	g_unifiedposistion = XiaLv_ChooseWedding_Frame:GetProperty("UnifiedPosition")
	
	g_WeddingButton[1] = XiaLv_ChooseWedding_Client1_Index1
	g_WeddingButton[2] = XiaLv_ChooseWedding_Client1_Index2
	g_WeddingButton[3] = XiaLv_ChooseWedding_Client1_Index3
	g_WeddingButton[4] = XiaLv_ChooseWedding_Client1_Index4
	
	g_DetailButton[1] = XiaLv_ChooseWedding_Client1_ChangDi
	g_DetailButton[2] = XiaLv_ChooseWedding_Client1_ShiZhuang
	g_DetailButton[3] = XiaLv_ChooseWedding_Client1_DaoJu
	g_DetailButton[4] = XiaLv_ChooseWedding_Client1_HuaChe
	g_DetailButton[5] = XiaLv_ChooseWedding_Client1_JinYue
	
	g_WeddingButton_Reexperience[3] = XiaLv_ChooseWedding_Client2_Index1
	g_WeddingButton_Reexperience[4] = XiaLv_ChooseWedding_Client2_Index2
	
	g_DetailButton_Reexperience[1] = XiaLv_ChooseWedding_Client2_ChangDi
	g_DetailButton_Reexperience[2] = XiaLv_ChooseWedding_Client2_ShiZhuang
	g_DetailButton_Reexperience[3] = XiaLv_ChooseWedding_Client2_DaoJu
	g_DetailButton_Reexperience[4] = XiaLv_ChooseWedding_Client2_HuaChe
	g_DetailButton_Reexperience[5] = XiaLv_ChooseWedding_Client2_JinYue
end

-- OnEvent
function XiaLv_ChooseWedding_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Open ) then --打开界面
		g_ServerNpc = Get_XParam_INT(0)
		g_ScriptId = Get_XParam_INT(1)
		XiaLv_ChooseWedding_Open()
	
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Update ) then
		g_IsZhuDong = 0
		XiaLv_ChooseWedding_SelectOK()
		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Close ) then
		g_IsZhuDong = 0
		XiaLv_ChooseWedding_Close_Click()
		
	elseif( event == "PLAYER_ENTERING_WORLD") then
		XiaLv_ChooseWedding_Close_Click()

	elseif( event == "ADJEST_UI_POS" ) then
		XiaLv_ChooseWedding_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		XiaLv_ChooseWedding_ResetPos()

	end

end



function XiaLv_ChooseWedding_Init()
	XiaLv_ChooseWedding_Client1:Hide()
	XiaLv_ChooseWedding_Client2:Hide()
	
	XiaLv_ChooseWedding_Client1_OK:Enable()
	XiaLv_ChooseWedding_Client2_OK:Enable()
	
	g_SelectWedding = 1
	g_SelectDetail = 1
	g_SelectImage = 1
	g_IsZhuDong = 1
end


function XiaLv_ChooseWedding_FillData()
	
	if g_ReexperienceWedding == g_ScriptId then
		XiaLv_ChooseWedding_Client2:Show()
		XiaLv_ChooseWedding_PlaneClick(3)
		
	else
		XiaLv_ChooseWedding_Client1:Show()
		XiaLv_ChooseWedding_PlaneClick(1)
	end
	
end


function XiaLv_ChooseWedding_FillImage_SelectPlane()
	
	g_WeddingButton[g_SelectWedding]:SetCheck(1)
	g_DetailButton[g_SelectDetail]:SetCheck(1)
			
	XiaLv_ChooseWedding_Client1_OptionNum:SetText(g_NeedText[g_SelectWedding])
	
	local planeImage = g_Image[g_SelectWedding]
	XiaLv_ChooseWedding_Client1_Image:SetProperty("Image", planeImage[g_SelectDetail][g_SelectImage]);
	
	if g_SelectImage >= table.getn(planeImage[g_SelectDetail]) then
		XiaLv_ChooseWedding_Client1_Subtract:Disable()
	else
		XiaLv_ChooseWedding_Client1_Subtract:Enable()
	end
	
	if g_SelectImage <= 1 then
		XiaLv_ChooseWedding_Client1_Plus:Disable()
	else
		XiaLv_ChooseWedding_Client1_Plus:Enable()
	end
	
	if g_SelectWedding == g_ZhiMengWedding then
		g_DetailButton[5]:Show()
	else
		g_DetailButton[5]:Hide()
	end
end


function XiaLv_ChooseWedding_FillImage_Reexperience()
	
	g_WeddingButton_Reexperience[g_SelectWedding]:SetCheck(1)
	g_DetailButton_Reexperience[g_SelectDetail]:SetCheck(1)
	
	local strNeedItemName = PlayerPackage:GetItemName( g_NeedItem[g_SelectWedding] )
	local text = ScriptGlobal_Format("#{JHYH_230330_236}", strNeedItemName)
	XiaLv_ChooseWedding_Client2_OptionNum:SetText(text)

	local planeImage = g_Image[g_SelectWedding]
	XiaLv_ChooseWedding_Client2_Image:SetProperty("Image", planeImage[g_SelectDetail][g_SelectImage]);
	
	if g_SelectImage >= table.getn(planeImage[g_SelectDetail]) then
		XiaLv_ChooseWedding_Client2_Subtract:Disable()
	else
		XiaLv_ChooseWedding_Client2_Subtract:Enable()
	end
	
	if g_SelectImage <= 1 then
		XiaLv_ChooseWedding_Client2_Plus:Disable()
	else
		XiaLv_ChooseWedding_Client2_Plus:Enable()
	end
	
	if g_SelectWedding == g_ZhiMengWedding then
		g_DetailButton_Reexperience[5]:Show()
	else
		g_DetailButton_Reexperience[5]:Hide()
	end
end



function XiaLv_ChooseWedding_Open()
	local caredNpc = DataPool:GetNPCIDByServerID( g_ServerNpc )
	if caredNpc ~= -1 then
		this:CareObject(caredNpc, 1, "XiaLv_ChooseWedding");
	end
		
	XiaLv_ChooseWedding_Init()
	XiaLv_ChooseWedding_FillData()

	this:Show();
end


function XiaLv_ChooseWedding_SelectOK( )
	XiaLv_ChooseWedding_Client1_OK:Disable()
	XiaLv_ChooseWedding_Client2_OK:Disable()
end


function XiaLv_ChooseWedding_OK_Click( )
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSelectPlane")
		Set_XSCRIPT_ScriptID(g_ScriptId)
		Set_XSCRIPT_Parameter( 0, g_ServerNpc )
		Set_XSCRIPT_Parameter( 1, 1 )
		Set_XSCRIPT_Parameter( 2, g_SelectWedding - 1 )
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end


function XiaLv_ChooseWedding_PlaneClick(index)
	g_SelectWedding = index
	g_SelectDetail = 1
	g_SelectImage = 1

	if g_ReexperienceWedding == g_ScriptId then
		XiaLv_ChooseWedding_FillImage_Reexperience( )
	else
		XiaLv_ChooseWedding_FillImage_SelectPlane( )
	end
end


function XiaLv_ChooseWedding_PageClick(index)
	g_SelectDetail = index
	g_SelectImage = 1

	if g_ReexperienceWedding == g_ScriptId then
		XiaLv_ChooseWedding_FillImage_Reexperience( )
	else
		XiaLv_ChooseWedding_FillImage_SelectPlane( )
	end
end


function XiaLv_ChooseWedding_Last()
	local lastImage = g_SelectImage - 1

	if lastImage < 1 then
		return
	end

	g_SelectImage = lastImage
	
	if g_ReexperienceWedding == g_ScriptId then
		XiaLv_ChooseWedding_FillImage_Reexperience( )
	else
		XiaLv_ChooseWedding_FillImage_SelectPlane( )
	end
end


function XiaLv_ChooseWedding_Next()
	local nextImage = g_SelectImage + 1

	local planeImage = g_Image[g_SelectWedding]
	if nextImage > table.getn(planeImage[g_SelectDetail]) then
		return
	end

	g_SelectImage = nextImage
	
	if g_ReexperienceWedding == g_ScriptId then
		XiaLv_ChooseWedding_FillImage_Reexperience( )
	else
		XiaLv_ChooseWedding_FillImage_SelectPlane( )
	end
end

--只关闭界面
function XiaLv_ChooseWedding_OnHidden()
	
	if this:IsVisible() == false then
		return
	end
	
	if g_IsZhuDong == 0 then
		return
	end
	
	if g_ScriptId <= 0 then
		return
	end
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnCloseInterface")
		Set_XSCRIPT_ScriptID(g_ScriptId)			
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()
	
	PushDebugMessage("#{JHYH_230330_107}") --您结束了方案选择。
	CloseWindow("MessageBox_Self",true)
end


function XiaLv_ChooseWedding_Close_Click()
	CloseWindow("MessageBox_Self",true)
	this:Hide()
end

--***************************************************
-- 恢复界面的默认相对位置
--***************************************************
function XiaLv_ChooseWedding_ResetPos()

	XiaLv_ChooseWedding_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

