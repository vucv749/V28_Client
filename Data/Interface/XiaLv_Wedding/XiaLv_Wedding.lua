-- 结婚
--!!!reloadscript =XiaLv_Wedding

local g_unifiedposistion = nil
local g_ServerNpc = -1
local g_ScriptId = -1
local g_IsZhuDong = 1

local g_VowText =
{
	[1] = "JHYH_230330_47",
	[2] = "JHYH_230330_48",
	[3] = "JHYH_230330_49",
	[4] = "JHYH_230330_50",
	[5] = "JHYH_230330_51",
}


local g_UICommand_Open = 80600301		--????
local g_UICommand_Update = 80600302		--????
local g_UICommand_Close = 80600303		--????

local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --??
		[1] = "#{XQ_MP_2}",    --??
		[2] = "#{XQ_MP_3}",    --??
		[3] = "#{XQ_MP_4}",    --??
		[4] = "#{XQ_MP_5}",    --??
		[5] = "#{XQ_MP_6}",    --??
		[6] = "#{XQ_MP_7}",    --??
		[7] = "#{XQ_MP_8}",    --??
		[8] = "#{XQ_MP_9}",    --??
		[9] = "",         --???
		[10] = "#{MPXR_220623_12}",
}

function XiaLv_Wedding_PreLoad()
	this:RegisterEvent("UI_COMMAND");

	this:RegisterEvent("PLAYER_ENTERING_WORLD")		-- ??????

	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");

end

function XiaLv_Wedding_OnLoad()
	g_unifiedposistion = XiaLv_Wedding_Frame:GetProperty("UnifiedPosition")
end

-- OnEvent
function XiaLv_Wedding_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Open ) then --????
		g_ServerNpc = Get_XParam_INT(0)
		g_ScriptId = Get_XParam_INT(7)
		
		local caredNpc = DataPool:GetNPCIDByServerID( g_ServerNpc )
		if caredNpc == -1 then
			PushDebugMessage("#{CommisionShop_Return_ID_Err}")
			return
		end
		this:CareObject(caredNpc, 1, "XiaLv_Wedding");

		XiaLv_Wedding_Open()

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Update ) then --?????
		if this:IsVisible() == true then
			XiaLv_Wedding_Update_OneAgree()
		end
		
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == g_UICommand_Close ) then --?????????
		g_IsZhuDong = 0
		XiaLv_Wedding_Close_Click()

	elseif( event == "PLAYER_ENTERING_WORLD") then
		XiaLv_Wedding_Close_Click()

	elseif( event == "ADJEST_UI_POS" ) then
		XiaLv_Wedding_ResetPos()

	elseif( event == "VIEW_RESOLUTION_CHANGED" ) then
		XiaLv_Wedding_ResetPos()

	end

end



function XiaLv_Wedding_Init()

	XiaLv_Wedding_ManBackLight:Hide()
	XiaLv_Wedding_WomanBackLight:Hide()
	
	XiaLv_Wedding_OKBtn:Enable()
	XiaLv_Wedding_CancleBtn:Enable()

	g_IsZhuDong = 1
end


function XiaLv_Wedding_FillData()
	local maleHeadId = Get_XParam_INT(1)
	local maleMenpai = Get_XParam_INT(2)
	local maleLevel = Get_XParam_INT(3)
	local maleName = Get_XParam_STR(0)

	local femaleHeadId = Get_XParam_INT(4)
	local femaleMenpai = Get_XParam_INT(5)
	local femaleLevel = Get_XParam_INT(6)
	local femaleName = Get_XParam_STR(1)

	local szMalePortrait = DataPool:GetPortraitByID(maleHeadId)
	XiaLv_Wedding_Man_Head:SetProperty("Image", szMalePortrait );
	
	--XiaLv_Wedding_Man_School:SetText(g_MenPaiName[maleMenpai])
	--XiaLv_Wedding_Man_Level:SetText(maleLevel)
	XiaLv_Wedding_Man_Name:SetText(maleName)

	local szFemalePortrait = DataPool:GetPortraitByID(femaleHeadId)
	XiaLv_Wedding_Woman_Icon:SetProperty("Image", szFemalePortrait );
	
	--XiaLv_Wedding_WoMan_School:SetText(g_MenPaiName[femaleMenpai])
	--XiaLv_Wedding_WoMan_Level:SetText(femaleLevel)
	XiaLv_Wedding_WoMan_Name:SetText(femaleName)

	local mySex = Player:GetMySex()
	if mySex == 0 then --?
		local msg = ScriptGlobal_Format("#{JHYH_230330_46}", maleName)
		XiaLv_Wedding_Text:SetText(msg)
	else
		local msg = ScriptGlobal_Format("#{JHYH_230330_46}", femaleName)
		XiaLv_Wedding_Text:SetText(msg)
	end

	local textNum = table.getn( g_VowText )
	local randTextIndex = math.random( 1, textNum )
	local destText = ParserString(g_VowText[randTextIndex], "Color")

	XiaLv_Wedding_TextEdit:SetText(destText)
	
	XiaLv_Wedding_TextEdit:SetProperty("ReadOnly","False");
	--设置缺省的光标
	XiaLv_Wedding_TextEdit:SetProperty("DefaultEditBox", "True");
	--XiaLv_Wedding_TextEdit:SetSelected( 0, -1 );	
	XiaLv_Wedding_TextEdit:SetProperty("CaratIndex" , -1) ;
end


function XiaLv_Wedding_Open()
	XiaLv_Wedding_Init()
	XiaLv_Wedding_FillData()

	this:Show();
end


function XiaLv_Wedding_Update_OneAgree()
	local agreeSex = Get_XParam_INT(0)
	
	if agreeSex == 0 then --??
		XiaLv_Wedding_WomanBackLight:Show()		
	else
		XiaLv_Wedding_ManBackLight:Show()			
	end
	
	local mySex = Player:GetMySex()
	if mySex == agreeSex then
		XiaLv_Wedding_OKBtn:Disable()
		XiaLv_Wedding_CancleBtn:Disable()
		
		XiaLv_Wedding_TextEdit:SetProperty("ReadOnly","True");
	end
end


function XiaLv_Wedding_Message_Changed()
	local text = XiaLv_Wedding_TextEdit:GetText();

	local nlen = string.len(text)

	if nlen > 60 then
		nlen = 60
		local str = string.sub(text, 1, 60)
		XiaLv_Wedding_TextEdit:SetText(str)
	end

	local numTips = ScriptGlobal_Format("#{JHYH_230330_53}", nlen)
	XiaLv_Wedding_TextNoticeNum:SetText(numTips)
end

function XiaLv_Wedding_OkBtn_Click(  )

	--给服务器发消息包
	local text = XiaLv_Wedding_TextEdit:GetText();
	Friend:AgreeMarry(text, g_ServerNpc, g_ScriptId)

end


--客户端主动关睜界面,给服务器发消息
function XiaLv_Wedding_OnHidden()

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
	
	PushDebugMessage("#{JHYH_230330_36}");
end


function XiaLv_Wedding_Close_Click()

	if this:IsVisible() == false then
		return
	end
	
	this:Hide();
end

--***************************************************
-- 恢复界面的默认相对位置
--***************************************************
function XiaLv_Wedding_ResetPos()
	XiaLv_Wedding_Frame:SetProperty("UnifiedPosition", g_unifiedposistion)
end

