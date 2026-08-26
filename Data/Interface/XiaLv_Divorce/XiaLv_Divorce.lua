
-- 离婚
--!!!reloadscript =XiaLv_Divorce
local g_unifiedposistion = nil

local g_ServerNpc = -1
local g_IsZhuDong = 1

local g_DivorceType = { invalid=0, ziYuan=1, qiangZhi=2, } --1:?????? 2:????
local g_DivorceValue = 0

local g_UICommand_Open = 80600501		--????
local g_UICommand_Update = 80600502		--????
local g_UICommand_Close = 80600503		--????
local g_UICommand_UnMarry = 80600504	--????

local g_ServerData = {
	marryYear = 0,
	marryMonth = 0,
	marryDay = 0,
	spouseName = "",
	diffDay = 0,
}

function XiaLv_Divorce_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("FILLDATA_VOW")
	
	this:RegisterEvent("PLAYER_ENTERING_WORLD")		-- ??????

	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");

end

function XiaLv_Divorce_OnLoad()
	g_unifiedposistion = XiaLv_Divorce_Frame:GetProperty("UnifiedPosition")
end

-- OnEvent
function XiaLv_Divorce_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Open ) then --????
		g_ServerNpc = Get_XParam_INT(0)
		local CaredNpc = DataPool:GetNPCIDByServerID( g_ServerNpc )
		if CaredNpc == -1 then
			PushDebugMessage("#{CommisionShop_Return_ID_Err}")
			return
		end
		
		this:CareObject(CaredNpc, 1, "XiaLv_Divorce");
		
		XiaLv_Divorce_Open()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Update ) then --??????
		XiaLv_Divorce_Update_One()
	
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_UnMarry ) then --??????/????
		g_IsZhuDong = 0
		XiaLv_Divorce_Divorce_Success()
			
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Close ) then --?????????
		g_IsZhuDong = 0
		XiaLv_Divorce_Close_Click()
	
	elseif( event == "PLAYER_ENTERING_WORLD") then
		XiaLv_Divorce_Close_Click()
	
	elseif( event == "ADJEST_UI_POS" ) then
		XiaLv_Divorce_ResetPos()
	
	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		XiaLv_Divorce_ResetPos()
		
	end

end



function XiaLv_Divorce_Init()

	XiaLv_Divorce_Text1:SetText("")
	
	XiaLv_Divorce_ManHeartBroken:Hide()
	XiaLv_Divorce_WomanHeartBroken:Hide()
	
	XiaLv_Divorce_ManHeart:Show()
	XiaLv_Divorce_WomanHeart:Show()
	
	XiaLv_Divorce_OkBtn:Enable()
	XiaLv_Divorce_CancleBtn:Enable()
	
	g_DivorceValue = g_DivorceType.invalid
	
	KillTimer("XiaLv_Divorce_Timer()")
	
	g_IsZhuDong = 1
end


function XiaLv_Divorce_FillData()

	local myName = Player:GetName()
	local myPortrait = Player:GetData( "PORTRAIT" )
	
	--配偶信息
	local spouseGuid = Get_XParam_INT(6)
	local group, index = DataPool:GetFriendByGUID(spouseGuid)
	local spouseName = DataPool:GetFriend(group, index, "NAME")
	local spouseHead = DataPool:GetFriend(group, index, "PORTRAIT")
	
	local mySex = Player:GetMySex()
	if mySex == 0 then --?
		XiaLv_Divorce_Man_Head:SetProperty("Image", spouseHead )
		XiaLv_Divorce_Man_Name:SetText(spouseName)

		XiaLv_Divorce_Woman_Head:SetProperty("Image", myPortrait )
		XiaLv_Divorce_Woman_Name:SetText(myName)
	else
		XiaLv_Divorce_Man_Head:SetProperty("Image", myPortrait )
		XiaLv_Divorce_Man_Name:SetText(myName)

		XiaLv_Divorce_Woman_Head:SetProperty("Image", spouseHead )
		XiaLv_Divorce_Woman_Name:SetText(spouseName)
	end
	
	g_DivorceValue = Get_XParam_INT(1)
	if g_DivorceValue == g_DivorceType.ziYuan then
		local msg = ScriptGlobal_Format("#{JHYH_230330_82}", spouseName)
		XiaLv_Divorce_ConfirmText:SetText(msg)
	elseif g_DivorceValue == g_DivorceType.qiangZhi then
		local msg = ScriptGlobal_Format("#{JHYH_230330_81}", spouseName)
		XiaLv_Divorce_ConfirmText:SetText(msg)
	end
		
	--AAA年BBB月CCC葼，你与DDD于携手在月老处，立下共度余生的誓言。
	g_ServerData.marryYear = Get_XParam_INT(2)
	g_ServerData.marryMonth = Get_XParam_INT(3)
	g_ServerData.marryDay = Get_XParam_INT(4)
	g_ServerData.diffDay = Get_XParam_INT(5)
	
	g_ServerData.spouseName = spouseName
	
	XiaLv_Divorce_Update_Vow()
end

function XiaLv_Divorce_Update_Vow()
	--AAA年BBB月CCC葼，你与DDD于携手在月老处，立下共度余生的誓言。
	local msg1 = ScriptGlobal_Format("#{JHYH_230330_77}", tostring(g_ServerData.marryYear), 
				tostring(g_ServerData.marryMonth), tostring(g_ServerData.marryDay), g_ServerData.spouseName)
	
	--曾记得，那时%s0说:"%s1"
	local szFemaleVow = Get_XParam_STR(0)
	local szMaleVow = Get_XParam_STR(1)
	
	if szFemaleVow == "" or szMaleVow == "" then
		XiaLv_Divorce_Text1:SetText(msg1)	
		return
	end

	local mySex = Player:GetMySex()
	
	local msg2 = ""
	if mySex == 0 then --?		
		msg2 = ScriptGlobal_Format("#{JHYH_230330_78}", "Huynh ", szMaleVow)
	else
		msg2 = ScriptGlobal_Format("#{JHYH_230330_78}", "Mu礽 ", szFemaleVow)
	end
	
	--在EEE个葼夜里，你们携手同行。
	local msg3 = ""
	if g_ServerData.diffDay > 0 then
		msg3 = ScriptGlobal_Format("#{JHYH_230330_79}", g_ServerData.diffDay)
	end
	
	-- 前世500次的回眸，才换来今生的曾经拥有。
	-- 您确定要与DDD，侠侣和离吗？
	local msg4 = ""
	if g_DivorceValue == g_DivorceType.ziYuan then
		msg4 = "#{JHYH_230330_80}"
	else
		msg4 = "#{JHYH_230330_99}".."#{JHYH_230330_100}"
	end
	
	XiaLv_Divorce_Text1:SetText(msg1..msg2..msg3..msg4)	
end


function XiaLv_Divorce_Open()
	XiaLv_Divorce_Init()
	XiaLv_Divorce_FillData()
	
	this:Show();
end


function XiaLv_Divorce_Update_One()
	
	if this:IsVisible() == false then
		return
	end
	
	local agreeSex = Get_XParam_INT(0) --???????
	
	if agreeSex  == 0 then
		XiaLv_Divorce_WomanHeart:Hide()
		XiaLv_Divorce_WomanHeartBroken:Show()
		
	else
		XiaLv_Divorce_ManHeart:Hide()
		XiaLv_Divorce_ManHeartBroken:Show()
	end
	
	local mySex = Player:GetMySex()
	if agreeSex == mySex then
		XiaLv_Divorce_OkBtn:Disable()
		XiaLv_Divorce_CancleBtn:Disable()
	end
	
end


--两人同意离婚/强制离婚
function XiaLv_Divorce_Divorce_Success()
	if this:IsVisible() == false then
		return
	end
	
	XiaLv_Divorce_WomanHeart:Hide()
	XiaLv_Divorce_WomanHeartBroken:Show()
	
	XiaLv_Divorce_ManHeart:Hide()
	XiaLv_Divorce_ManHeartBroken:Show()
	
	XiaLv_Divorce_OkBtn:Disable()
	XiaLv_Divorce_CancleBtn:Disable()
	
	SetTimer("XiaLv_Divorce", "XiaLv_Divorce_Timer()", 2000)
end

--**********************************
--客户端计时器
--**********************************
function XiaLv_Divorce_Timer()
	KillTimer("XiaLv_Divorce_Timer()")
	XiaLv_Divorce_Close_Click()
end

--确定离婚
function XiaLv_Divorce_OkBtn_Click(  )	
	
	if g_DivorceValue == g_DivorceType.ziYuan then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AgreeUnMarry")
			Set_XSCRIPT_ScriptID(806005)
			Set_XSCRIPT_Parameter( 0, g_ServerNpc )		
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		
	else
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("AgreeUnMarry_Force")
			Set_XSCRIPT_ScriptID(806004)
			Set_XSCRIPT_Parameter( 0, g_ServerNpc )		
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
		
	end
	
	
end

--客户端主动关睜界面,给服务器发消息
function XiaLv_Divorce_OnHiden(index)
	
	if this:IsVisible() == false then
		return
	end
	
	if g_IsZhuDong == 0 then
		return
	end
	
	if g_DivorceValue == g_DivorceType.ziYuan then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("OnCloseInterface")
			Set_XSCRIPT_ScriptID(806005)			
			Set_XSCRIPT_ParamCount(0)
		Send_XSCRIPT()
	end
	
	PushDebugMessage("#{JHYH_230330_75}") --????????
end

--只关睜界面，不发消息
function XiaLv_Divorce_Close_Click()
	
	this:Hide()
end

--***************************************************
-- 恢复界面的默认相对位置
--***************************************************
function XiaLv_Divorce_ResetPos()

	XiaLv_Divorce_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end



