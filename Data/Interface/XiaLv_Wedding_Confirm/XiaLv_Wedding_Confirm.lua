-- 结婚
--!!!reloadscript =XiaLv_Wedding_Confirm

local g_unifiedposistion = nil
local g_ServerNpc = -1
local g_MaxPlaneLevel = 3

local g_UICommand_HunShu = 80600305		--婚书界面
local g_UICommand_HunShu_CoupleZone = 80600306		--婚书界面

local g_normal_plane = 1
local g_high_plane = 2

local g_ControlList = {}

function XiaLv_Wedding_Confirm_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("FILLDATA_HUNSHU")
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD")		-- 进入游戏世界

	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");

end

function XiaLv_Wedding_Confirm_OnLoad()
	g_unifiedposistion = XiaLv_Wedding_Confirm_Frame:GetProperty("UnifiedPosition")
	
	g_ControlList[g_normal_plane] = {}
	g_ControlList[g_normal_plane].client = XiaLv_Wedding_Confirm_Client
	g_ControlList[g_normal_plane].man_head = XiaLv_Wedding_Confirm_Man_Head
	g_ControlList[g_normal_plane].man_name = XiaLv_Wedding_Confirm_Man_Name
	g_ControlList[g_normal_plane].woman_head = XiaLv_Wedding_Confirm_Woman_Head
	g_ControlList[g_normal_plane].woman_name = XiaLv_Wedding_Confirm_Woman_Name
	g_ControlList[g_normal_plane].congrats = XiaLv_Wedding_Confirm_Congrats
	g_ControlList[g_normal_plane].man_text = XiaLv_Wedding_Confirm_Bridegroom_Text
	g_ControlList[g_normal_plane].woman_text = XiaLv_Wedding_Confirm_Bride_Text
	g_ControlList[g_normal_plane].congrats_2 = XiaLv_Wedding_Confirm_Congrats2
	
	g_ControlList[g_high_plane] = {}
	g_ControlList[g_high_plane].frame = XiaLv_Wedding_Confirm_Frame2
	g_ControlList[g_high_plane].client = XiaLv_Wedding_Confirm_Client2
	g_ControlList[g_high_plane].man_head = XiaLv_Wedding_Confirm_Man_Head_2
	g_ControlList[g_high_plane].man_name = XiaLv_Wedding_Confirm_Man_Name_2
	g_ControlList[g_high_plane].woman_head = XiaLv_Wedding_Confirm_Woman_Head_2
	g_ControlList[g_high_plane].woman_name = XiaLv_Wedding_Confirm_Woman_Name_2
	g_ControlList[g_high_plane].congrats = XiaLv_Wedding_Confirm_Congrats_2
	g_ControlList[g_high_plane].man_text = XiaLv_Wedding_Confirm_Bridegroom_Text_2
	g_ControlList[g_high_plane].woman_text = XiaLv_Wedding_Confirm_Bride_Text_2
	g_ControlList[g_high_plane].congrats_2 = XiaLv_Wedding_Confirm_Congrats2_2
end

-- OnEvent
function XiaLv_Wedding_Confirm_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_HunShu ) then --打开界面
		g_ServerNpc = Get_XParam_INT(0)
		local caredNpc = DataPool:GetNPCIDByServerID( g_ServerNpc )
		if caredNpc ~= -1 then
			this:CareObject(caredNpc, 1, "XiaLv_Wedding_Confirm");
		end
		
		XiaLv_Wedding_Confirm_Open(1)

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_HunShu_CoupleZone ) then --打开界面
		XiaLv_Wedding_Confirm_Open(2)
		
	elseif( event == "PLAYER_ENTERING_WORLD") then
		XiaLv_Wedding_Confirm_Close()

	elseif( event == "ADJEST_UI_POS" ) then
		XiaLv_Wedding_Confirm_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		XiaLv_Wedding_Confirm_ResetPos()

	end

end



function XiaLv_Wedding_Confirm_Init()

	XiaLv_Wedding_Confirm_Frame2:Hide()
	XiaLv_Wedding_Confirm_Client:Hide()
	XiaLv_Wedding_Confirm_Client2:Hide()
end


function XiaLv_Wedding_Confirm_FillData()
	
	XiaLv_Wedding_Confirm_DragTitle:SetText("#{JHYH_230330_35}")
	local ControlList = g_ControlList[g_normal_plane]
	local planeLevel = Get_XParam_INT(10)
	if planeLevel == g_MaxPlaneLevel then
		ControlList = g_ControlList[g_high_plane]
		XiaLv_Wedding_Confirm_DragTitle:SetText("#{JHYH_230330_336}")
	end
	
	ControlList.client:Show()
	if ControlList.frame ~= nil then
		ControlList.frame:Show()
	end
	
	local femaleHeadId = Get_XParam_INT(7)
	local maleHeadId = Get_XParam_INT(8)

	local femaleName = Get_XParam_STR(0)
	local maleName = Get_XParam_STR(1)
	
	local szMalePortrait = DataPool:GetPortraitByID(maleHeadId)
	ControlList.man_head:SetProperty("Image", szMalePortrait )
	ControlList.man_name:SetText(maleName)
		
	local szFemalePortrait = DataPool:GetPortraitByID(femaleHeadId)
	ControlList.woman_head:SetProperty("Image", szFemalePortrait )
	ControlList.woman_name:SetText(femaleName)

	local femalVow = Get_XParam_STR(2)
	local malVow = Get_XParam_STR(3)
	ControlList.man_text:SetText(malVow)
	ControlList.woman_text:SetText(femalVow)
	
	--	结婚日期
	local year = Get_XParam_INT(1)
	local month = Get_XParam_INT(2)
	local day = Get_XParam_INT(3)
	local hour = Get_XParam_INT(4)
	local num = Get_XParam_INT(6)

	local spouseName = femaleName
	local mySex = Player:GetMySex()
	if mySex == 0 then
		spouseName = maleName
	end
	
	local szMarryDate = ScriptGlobal_Format("#{JHYH_230330_57}", spouseName, year, month, day, hour, num)	
	ControlList.congrats:SetText(szMarryDate)
	
	local isNewMarry = Get_XParam_INT(9)
	if isNewMarry == 1 then
		ControlList.congrats_2:Show()
	else
		ControlList.congrats_2:Hide()
	end

end


function XiaLv_Wedding_Confirm_FillData_CoupleZone()
	
	local mainData = CoupleZone:LuaFnGetCoupleZoneData_Main()
	if type(mainData) ~= "table" then
		return
    end
	
	local femaleHeadId = mainData["portrait_0"]
	local maleHeadId = mainData["portrait_1"]
	local femaleName = mainData["name_0"]
	local maleName = mainData["name_1"]
	
	local year = Get_XParam_INT(1)
	local month = Get_XParam_INT(2)
	local day = Get_XParam_INT(3)
	local hour = Get_XParam_INT(4)
	
	XiaLv_Wedding_Confirm_DragTitle:SetText("#{JHYH_230330_35}")
	local ControlList = g_ControlList[g_normal_plane]
	local planeLevel = Get_XParam_INT(5)
	if planeLevel == g_MaxPlaneLevel then
		ControlList = g_ControlList[g_high_plane]
		XiaLv_Wedding_Confirm_DragTitle:SetText("#{JHYH_230330_336}")
	end
	
	ControlList.client:Show()
	if ControlList.frame ~= nil then
		ControlList.frame:Show()
	end
	
	--local szMalePortrait = DataPool:GetPortraitByID(maleHeadId)
	ControlList.man_head:SetProperty("Image", maleHeadId )
	ControlList.man_name:SetText(maleName)
		
	--local szFemalePortrait = DataPool:GetPortraitByID(femaleHeadId)
	ControlList.woman_head:SetProperty("Image", femaleHeadId )
	ControlList.woman_name:SetText(femaleName)

	local num = Get_XParam_INT(0)
	local femalVow = Get_XParam_STR(0)
	local malVow = Get_XParam_STR(1)

	ControlList.man_text:SetText(malVow)
	ControlList.woman_text:SetText(femalVow)
	
	local spouseName = femaleName
	local mySex = Player:GetMySex()
	if mySex == 0 then
		spouseName = maleName
	end
	
	local szMarryDate = ScriptGlobal_Format("#{JHYH_230330_57}", spouseName, year, month, day, hour, num)	
	ControlList.congrats:SetText(szMarryDate)
	
	ControlList.congrats_2:Hide()
end


function XiaLv_Wedding_Confirm_Open(nType)
	XiaLv_Wedding_Confirm_Init()
	
	if nType == 1 then
		XiaLv_Wedding_Confirm_FillData()
	else
		XiaLv_Wedding_Confirm_FillData_CoupleZone()
	end
	
	this:Show();
end


--只关闭界面
function XiaLv_Wedding_Confirm_Close()

	this:Hide()
end


--***************************************************
-- 恢复界面的默认相对位置
--***************************************************
function XiaLv_Wedding_Confirm_ResetPos()

	XiaLv_Wedding_Confirm_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

