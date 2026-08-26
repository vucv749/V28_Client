local MAX_OBJ_DISTANCE = 3.0
local DRESS_POS = -1
local g_NeedMoney = 50000
local g_ObjCared = -1

--- 2021.03.10 æ≠µ‰“∆÷≤£¨–¬‘ˆ
local g_DressPaint_YuanbaoPay	= 1		-- 2021.03.10 ??????
local g_ZiDongState 			= 0		-- ?????????  ????   0 ????  1 ????  ?? 1????????  2??????? ?????????????????????
local g_ZiDongTimerState 		= 0		-- ??????  0 ??  1 ?? 2 ??
local g_RecvGRespState 			= 0		-- ???????????  0.3??????? ??????? ????   0 ????  1 ????  ???????????? ??????????????? 
local g_Zidong_ClickTime 		= 300	-- 300?? ????????
local g_Rare_Time 				= 1000	-- 1000?? ?rou?????  ????timer ????timer
local g_Rare_Count        		= 3
local g_IsFirstAuto				= 1		-- ???auto?????
local g_IsXiYouStop				= 0
local g_dressNum 				= 9		-- ????????

local DressVisualID 			= {}	-- ??????
local DressNames 				= {}	-- ????????(??)
local DressRate 				= {}	-- ??????
local EB_BINDED					= 1		-- ????
local g_DressPaint_TipsBind = 0
----2021.03.10 æ≠µ‰“∆÷≤£¨–¬‘ˆ end -----------
local g_DressPaint_Frame_UnifiedPosition

--PreLoad
function DressPaint_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_DRESS_PAINT")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	this:RegisterEvent("PROGRESSBAR_SHOW")
	this:RegisterEvent("CLOSE_DRESS_PAINT")
	this:RegisterEvent("OPEN_STALL_SALE")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("YIGUI_OPEN")
	this:RegisterEvent("OPEN_DRESS_PAINT_FITTING") 
	this:RegisterEvent("OPEN_EQUIP") 
	this:RegisterEvent("OPEN_DRESSPREVIEW")
end

--OnLoad
function DressPaint_OnLoad()

	g_DressPaint_Frame_UnifiedPosition=DressPaint_Frame:GetProperty("UnifiedPosition")
end

--OnEvent
function DressPaint_OnEvent(event)
	-- ∂¡Ω¯∂»Ãı÷–£¨≤ªƒ‹Ω¯––»æ…´
	if ( event == "PROGRESSBAR_SHOW" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- ƒ≥–©π¶ƒ‹ª•≥‚£¨–Ë“™πÿ±†∏√ΩÁ√Ê
	if ( event == "CLOSE_DRESS_PAINT" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	--  ±◊∞‘§¿¿
	if  ( event == "UI_COMMAND" and tonumber(arg0) == 120203161 ) or (event == "OPEN_DRESSPREVIEW") or  ( event == "UI_COMMAND" and tonumber(arg0) == 2024082101 ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- ø™ º∞⁄ÃØ£¨≤ªƒ‹Ω¯––»æ…´
	if ( event == "OPEN_STALL_SALE" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden();
		end
	end

	-- ¥Úø™◊∞±∏ΩÁ√Ê£¨πÿ±†ΩÁ√Ê
	if ( event == "OPEN_EQUIP" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden()
		end
	end

	-- ¥Úø™◊∞±∏ΩÁ√Ê£¨πÿ±†ΩÁ√Ê
	if ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then
			DressPaint_OnHiden()
		end
	end
	
	if event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 0910281 then
		if this:IsVisible() then
			DressPaint_OnHiden()
		end

		local state = DressReplaceColor : ConditionCheck()
		if state == 0 then
			return
		end
		
		PushEvent( "CLOSE_DRESSPREVIEW") 
		PushEvent( "CLOSE_GEMEFFECTPREVIEW")

		DressPaint_OK:Disable()										-- ??ì??î??
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_FakeObject : Hide() 
		DressPaint_Text : SetText("") 
		DressPaint_Protect : SetText("") 
		DressPaint_Zidong_ALLChoice:Disable()
		DressPaint_Protect:Hide()
		this:Show()
		Dress_Jian : Hide()

		--DressPaint_OK:Disable()										-- Ω˚”√°∞»∑∂®°±∞¥≈•
		--DressPaint_Show:Disable()									-- Ω˚”√°∞»æ…´◊∑◊Ÿ°±∞¥≈•
		--this:Show()
		
		local xx = Get_XParam_INT(0)
		local objCared = DataPool:GetNPCIDByServerID(xx)
		if objCared == -1 then
			return;
		end
		BeginCareObject_DressPaint(objCared)
		
		DressPaint_DemandMoney:SetProperty("MoneyNumber", g_NeedMoney)
		local playerMoney = Player:GetData("MONEY")
		DressPaint_SelfMoney:SetProperty("MoneyNumber", playerMoney)
		local playerJZ = Player:GetData("MONEY_JZ")
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", playerJZ)
		
		g_DressPaint_TipsTwice = 0
		g_DressPaint_TipsBind = 0
		DressReplaceColor:SetDressPaint_TipsBind(g_DressPaint_TipsBind)
		--yuanbaoPay
		if g_DressPaint_YuanbaoPay == 1 or g_DressPaint_YuanbaoPay == 0 then
			DressPaint_Blank_Queren:SetCheck(g_DressPaint_YuanbaoPay)
		end
	-- »æ…´≥…π¶£¨∆Ù”√°∞»æ…´◊∑◊Ÿ°±∞¥≈•	
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 091109 then		
		if this:IsVisible() then
			--DressPaint_Show : Enable()

			DressPaint_Show()
			g_DressPaint_TipsTwice = 0
			g_DressPaint_TipsBind = 0
			DressReplaceColor:SetDressPaint_TipsBind(g_DressPaint_TipsBind)
		end
	elseif event ==	"UPDATE_DRESS_PAINT" then
		if arg0 ~= nil and arg1 ~= nil then
			DressPaint_Update(tonumber(arg0), tonumber(arg1))
		end

	elseif event == "OBJECT_CARED_EVENT" then
		if(arg0 ~= nil and tonumber(arg0) ~= objCared) then
			return;
		end		
		--»Áπ˚∫ÕNPCµƒæ‡¿Î¥Û”⁄“ª∂®æ‡¿ÎªÚ†ﬂ±ª…æ≥˝£¨◊‘∂Øπÿ±†
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then		
			DressPaint_OnHiden();
		end	

	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then
		if(arg0~=nil and tonumber(arg0) == 96) then
			DressPaint_Resume_Equip()
		end

	elseif event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() then
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return
		end

		if (DRESS_POS == tonumber(arg0)) then
			DressPaint_Update(tonumber(arg0), 1)
		end

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		DressPaint_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		DressPaint_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif (event == "ADJEST_UI_POS" ) then
		DressPaint_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		DressPaint_Frame_On_ResetPos()	
		
	elseif ( event == "YIGUI_OPEN" ) then
		if (this:IsVisible()) then 
			DressPaint_OnHiden()
		end
	-- ≤ªƒ‹∫Õ±‰–‘Õ¨ ±¥Ê‘⁄
	elseif (event == "UI_COMMAND" and tonumber(arg0) == 20120406) then
		if (this:IsVisible()) then 
			DressPaint_OnHiden();
		end
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 091113 then 
		DressPaint_ResetZiDongState()
	elseif event == "UI_COMMAND" and arg0 ~= nil and tonumber(arg0) == 091114 then 
		DressPaint_RetSetZidongButtonText()
	elseif(event == "OPEN_DRESS_PAINT_FITTING") then
		if arg0 == nil then
			return
		end

		--  ‘“¬
		DRESS_POS = tonumber(arg0)
		if DRESS_POS == -1 then
			return ;
		end
		DressReplaceColor : FittingOnDress(DRESS_POS)
		local n_szDressDesc, nRate,MaterBind = DressReplaceColor : GetDressVisualInfo(DRESS_POS)
		if n_szDressDesc == "" or nRate == 0 then
			return
		end

		-- …Ë÷√ π”√ƒƒ∏ˆƒ£–Õ
		DressPaint_FakeObject : SetFakeObject("")
		DressPaint_FakeObject : SetFakeObject("DressPaint_Player");
		local strdic = ""
		if nRate == 23000 then
			strdic = ScriptGlobal_Format("#{SZRSYH_120912_10}", n_szDressDesc)
		elseif nRate == 14000 then
			strdic = ScriptGlobal_Format("#{SZRSYH_120912_11}", n_szDressDesc)
		elseif nRate == 1000 then
			strdic = ScriptGlobal_Format("#{SZRSYH_120912_12}", n_szDressDesc)
		elseif nRate == -1 then
			strdic = "#G"..n_szDressDesc
		end
		DressPaint_Text:SetText(strdic)
		
		if g_ZiDongState == 1 then  
			local n_visualID = DressReplaceColor : GetDressVisualID(DRESS_POS)
			if n_visualID == 0 then
				return
			end 
			local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()  
			if DressVisualID[ComIdx] == n_visualID then
					DressPaint_SuccDestMode(strdic) 
			elseif  nRate == 1000 and g_IsXiYouStop == 1 then  
					g_IsXiYouStop = 0 
					DressPaint_SuccDestMode(strdic)  
			end   
			g_RecvGRespState = 1 
		end 
	end
end

function DressPaint_Update(Pos, isEquip)
	--DressPaint_Clear()
	if isEquip == 1 then 
		local theAction = EnumAction(Pos, "packageitem")
		if theAction:GetID() ~= 0 then

			--if PlayerPackage:IsLock(Pos) == 1 then   --tt60972 ≤ﬂªÆ∏ƒ…Ëº∆£¨º”À¯ ±◊∞“≤ƒ‹»æ…´
				--PushDebugMessage("#{SZPR_091023_16}")
				--DressPaint_Clear()
				--return
			--end

			local EquipPoint = LifeAbility:Get_Equip_Point(Pos)
			if EquipPoint ~= 16 then
				PushDebugMessage("#{SZPR_091023_17}")
				--DressPaint_Clear()
				return
			end
	
			--≈–∂œ «≤ª «ø…»æ…´ ±◊∞
			local canPaint = DressReplaceColor:DressCanPaint(Pos)
			if canPaint ~= 1 then
				PushDebugMessage("#{SZPR_091023_18}")
				--DressPaint_Clear()
				return
			end

			if( g_ZiDongState == 0 ) then  
				DressPaint_Clear()
				DRESS_POS = Pos
				DressPaint_Zidong_ALLChoice_Init()
			end 

			--DressPaint_Clear()
			--DRESS_POS = Pos;
			
			LifeAbility:Lock_Packet_Item(DRESS_POS, 1)	
			DressPaint_Object:SetActionItem(theAction:GetID())
		
			--∆Ù”√»∑∂®∞¥≈•
			DressPaint_OK:Enable()
			DressPaint_Show()
			Dress_Jian : Show()
			DressPaint_Zidong_ALLChoice:Enable()
			
			if(IsWindowShow("DressJian") == true) then
				Dress_Jian_Clicked()
			end
			g_DressPaint_TipsTwice = 0
			g_DressPaint_TipsBind = 0
			DressReplaceColor:SetDressPaint_TipsBind(g_DressPaint_TipsBind)
			return
		
		else
			--DressPaint_Clear()
			PushDebugMessage("#{SZPR_091023_17}")
			return
		end
	else
		PushDebugMessage("#{SZPR_091023_17}")
		--DressPaint_Clear()
		return
	end
end

function DressPaint_Resume_Equip()
	if g_ZiDongState == 1 then
		PushDebugMessage("#{YJRS_140613_07}") 
		return 
	end
	DressPaint_Clear()
	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end
end

function DressPaint_Clear()
	if(DRESS_POS ~= -1) then
		DressPaint_OK:Disable()										-- ??ì??î??
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable();
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Zidong_ALLChoice:Disable()
		DressPaint_Object:SetActionItem(-1)
		LifeAbility:Lock_Packet_Item(DRESS_POS, 0)
		DRESS_POS = -1

		-- «Âœ¬ ‘“¬º‰ ˝æ›
		DressReplaceColor:RestoreDressPaintFitting()
		DressPaint_FakeObject : Hide()
		DressPaint_Text : SetText("")
		Dress_Jian : Hide() 
		DressPaint_Zidong_ALLChoice_Init() 
		DressVisualID ={}
		DressNames = {}
		DressRate = {} 
		
		if g_ZiDongState == 1  then  				--- count timer  kill  ??? 
			--KillTimer("DressPaint_countEvent()") 
			PushDebugMessage("#{YJRS_140613_17}")
		end   	
		if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  ??? 
			KillTimer("DressPaint_Rare_TimerEvent()") 
		end   	
		DressPaint_ResetZiDongState()
	end

end

function DressPaint_OnHiden()
	SetDefaultMouse()
	StopCareObject_DressPaint(objCared)
	DressPaint_Clear()
	
	DressPaint_FakeObject : SetFakeObject("")
	DressPaint_Text : SetText("")
	Dress_Jian : Hide()

	-- πÿ±†°∞»æ…´◊∑◊Ÿ°± ‘“¬º‰
	if (IsWindowShow("DressPaint_Fitting")) then
		CloseWindow("DressPaint_Fitting", true)
		DressReplaceColor:RestoreDressPaintFitting()		
	end
	
	this:Hide()

	if(IsWindowShow("DressJian") == true) then
		PushEvent( "CLOSE_DRESSJIAN_DLG")		
	end

	return
end

------------------------------------------------------
--
--	»∑∂®
--
function DressPaint_OK_Clicked()
	
	if g_ZiDongState == 1 then
		PushDebugMessage("#{YJRS_140613_07}") 
		return 
	end 

	-- ≈–∂œ «∑ÒŒ™∞≤»´ ±º‰2012.6.12-LIUBO
	if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		--PushDebugMessage("#{ZYXT_120528_16}")
		return
	end
	
	--≈–∂œµÁª∞√‹±£∫Õ∂˛º∂√‹¬Î±£ª§2012.6.12-LIUBO
	if CheckPhoneMibaoAndMinorPassword() ~= 1 then
		return
	end

	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
	if selfMoney < g_NeedMoney then
		PushDebugMessage("#{RXZS_090804_11}")
		return
	end
	
	g_DressPaint_TipsBind = DressReplaceColor:GetDressPaint_TipsBind()
	local isDressBind = GetItemBindStatus(DRESS_POS)
	local n_szDressDesc, nRate,MaterBind = DressReplaceColor : GetDressVisualInfo(DRESS_POS)
	if g_DressPaint_TipsBind == 0 and isDressBind == 0 then
		--PlayerPackage:CountAvailableItemByIDTable(MaterBind) > 0 then
		local bagIdx,BindState =  PlayerPackage:FindFirstBindedItemIdxByIDTable(MaterBind)
		if bagIdx > 0 and BindState == EB_BINDED then
			PushEvent( "DRESSPAINT_BINDDRESS")
			return
		end
	end

	-- πÿ±†°∞»æ…´◊∑◊Ÿ°± ‘“¬º‰
	if (IsWindowShow("DressPaint_Fitting")) then
		DressReplaceColor:RestoreDressPaintFitting()
		CloseWindow("DressPaint_Fitting", true)	
	end

	if nRate == 1000 and g_DressPaint_TipsTwice == 0 then 
		PushEvent( "DRESSPAINT_SELECTSERVER", n_szDressDesc )
		g_DressPaint_TipsTwice = 1
	else
		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnDressPaint")
		Set_XSCRIPT_ScriptID(830001)
		Set_XSCRIPT_Parameter(0, DRESS_POS)
		Set_XSCRIPT_Parameter(1, g_DressPaint_YuanbaoPay)
		Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end

end

------------------------------------------------------
--
--	¥Úø™ ‘“¬º‰
--
function DressPaint_Show_Clicked()
	
	if (IsWindowShow("DressPaint_Fitting")) then
		-- œ»«Âø†µ±«∞ ‘“¬º‰µƒ ˝æ›
		DressReplaceColor:RestoreDressPaintFitting();
	end
	
	-- ¥Úø™ ‘“¬º‰£¨œ‘ æ ‘“¬–ßπ˚
	DressReplaceColor:OpenDressPaintFitting( DRESS_POS )

end

------------------------------------------------------
--
--	πÿ–ƒNPC
--
function BeginCareObject_DressPaint(objCaredId)
	g_ObjCared = objCaredId
	this:CareObject(g_ObjCared, 1, "DressPaint")
end


function StopCareObject_DressPaint(objCaredId)
	this:CareObject(g_ObjCared, 0, "DressPaint")
	g_ObjCared = -1
end

function DressPaint_Frame_On_ResetPos()
	DressPaint_Frame:SetProperty("UnifiedPosition", g_DressPaint_Frame_UnifiedPosition);
end

------------------------------------------------------------------
--------------- 2021.03.10 æ≠µ‰“∆÷≤≤ø∑÷ ---------------------------
------------------------------------------------------------------

function DressPaint_Show()
	-- œ»«Âø†µ±«∞ ‘“¬º‰µƒ ˝æ›
	DressReplaceColor:RestoreDressPaintFitting()
	-- ¥Úø™
	DressReplaceColor:OpenDressPaintFitting( DRESS_POS )
	DressPaint_FakeObject : Show()
	DressPaint_Text : Show()
end

function DressPaint_Blank_Queren_Clicked() 
	g_DressPaint_YuanbaoPay = DressPaint_Blank_Queren:GetCheck()
end

function DressPaint_ZiDong_TimerEvent()	--????????  0.3???  
	if g_ZiDongTimerState == 1  and g_RecvGRespState == 1 then 
 	   -- ≈–∂œ «∑ÒŒ™∞≤»´ ±º‰2012.6.12-LIUBO
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			--PushDebugMessage("#{ZYXT_120528_16}")
			DressPaint_ResetZiDongState()
			return
		end  
		--≈–∂œµÁª∞√‹±£∫Õ∂˛º∂√‹¬Î±£ª§2012.6.12-LIUBO
		if CheckPhoneMibaoAndMinorPassword() ~= 1 then
			DressPaint_ResetZiDongState()
			return
		end 
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{YJRS_140613_14}")
			DressPaint_ResetZiDongState()
			return
		end

		local destVisualID = -1
		local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
		if ComIdx ~= nil and ComIdx > 0 and DressVisualID[ComIdx] ~= nil then
			destVisualID = DressVisualID[ComIdx]
		end

		Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnAutoDressPaint")
			Set_XSCRIPT_ScriptID(830001)
			Set_XSCRIPT_Parameter(0, DRESS_POS)
			Set_XSCRIPT_Parameter(1, g_IsFirstAuto)			--??????????  ??????????  1 ????? 0??
			Set_XSCRIPT_Parameter(2, destVisualID)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT() 
		g_RecvGRespState    = 0 
		g_IsFirstAuto       = 0
 	end 
end

--÷ÿ÷√◊‘∂Ø◊¥Ã¨ 1.µ„ª˜Õ£÷π πÿ±†¥∞ø⁄ ±
function DressPaint_ResetZiDongState()
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx > 0 then
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		DressPaint_Zidong_ALLChoice:Enable() 
		DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--????????  
		--DressPaint_Zidong_ALLChoice:SetCurrentSelect(-1)
	end 

	DressPaint_Zidong:SetText("#{YJRS_140613_04}")
	if g_ZiDongTimerState == 2  and g_Rare_Count < 3 then  				--- count timer  kill  ??? 
		KillTimer("DressPaint_Rare_TimerEvent()") 
	end
	DressPaint_Protect:SetText("")
	if g_ZiDongState == 1  then 
		KillTimer("DressPaint_ZiDong_TimerEvent()") 
	end  

	g_ZiDongState 		= 0			
	g_ZiDongTimerState	= 0
	g_RecvGRespState    = 0 

end	

--rou≥ˆœ°”– ±◊∞ ∆Ù∂ØTimer
function DressPaint_GetRareDress() 
	g_ZiDongTimerState = 2  
	g_Rare_Count = 3	
	SetTimer("DressPaint","DressPaint_Rare_TimerEvent()", g_Rare_Time)
end

--rou≥ˆœ°”– ±◊∞Timerªÿµ˜∫Ø ˝
function DressPaint_Rare_TimerEvent() 
	-- …Ë÷√◊÷µ‰
	local tmpStr = ScriptGlobal_Format("#{YJRS_140613_06}" ,g_Rare_Count)  
	DressPaint_Protect:SetText(tmpStr)

	g_Rare_Count = g_Rare_Count - 1 
	if g_Rare_Count == -1 then 
		KillTimer("DressPaint_Rare_TimerEvent()")
		g_Rare_Count = 3
		g_ZiDongTimerState = 1   
		DressPaint_Protect:SetText("")
	end
end

----------------------------------------------------------------------------------
--
-- –˝◊™»ÀŒÔÕ∑œÒƒ£–Õ£®œÚ◊Û)
--
function DressPaint_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--œÚ◊Û–˝◊™ø™ º
		if(start == 1) then
			DressPaint_FakeObject:RotateBegin(-0.3)
		--œÚ◊Û–˝◊™Ω· ¯
		else
			DressPaint_FakeObject:RotateEnd()
		end
	end
end

----------------------------------------------------------------------------------
--
--–˝◊™»ÀŒÔÕ∑œÒƒ£–Õ£®œÚ”“)
--
function DressPaint_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton")
	if(mouse_button == "LeftButton") then
		--œÚ”“–˝◊™ø™ º
		if(start == 1) then
			DressPaint_FakeObject:RotateBegin(0.3)
		--œÚ”“–˝◊™Ω· ¯
		else
			DressPaint_FakeObject:RotateEnd()
		end
	end
end

-- ≤Èø¥ ±◊∞»æ…´Õºº¯£®øÓ Ω£©
function Dress_Jian_Clicked()
	DressReplaceColor :DressOpenDressJian(DRESS_POS)
end

--≥ı ºªØ◊‘∂Ø◊¥Ã¨ ≤¢ππ‘Ï ˝æ›
function DressPaint_Zidong_ALLChoice_Init() 
	DressPaint_Zidong_ALLChoice:ResetList()  	
	DressPaint_Zidong_ALLChoice:SetText("#{YJRS_140613_03}")--????????  

	if ( DRESS_POS == -1 ) then  
		DressVisualID = {}
		DressNames = {}
		DressRate = {}
		DressPaint_Zidong_ALLChoice:Disable()
		return
	end

	DressReplaceColor :StoreDressType(DRESS_POS)
	for i=1 ,g_dressNum-1 do
		local nVisual,ndesc,nRate = DressReplaceColor:GetDressDesc(i-1)
		DressVisualID[i] = nVisual
		if nRate == 23000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_07}", ndesc)
		elseif nRate == 14000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_08}", ndesc)
		elseif nRate == 1000 then
			DressNames[i] = ScriptGlobal_Format("#{SZRSYH_120912_09}", ndesc)
		elseif nRate == -1 then
			DressNames[i] = ndesc
		end
		DressRate[i]=nRate
	end

	for i = 1 , g_dressNum-1 do
		DressPaint_Zidong_ALLChoice:AddTextItem(DressNames[i] ,i) 
	end
	-- ∂‘◊Ó∫Û“ª––Ω¯––ƒ⁄»›≤π≥‰, »Œ“‚œ°”–∑Á∏Ò
	DressPaint_Zidong_ALLChoice:AddTextItem("#{YJRS_140613_23}" ,g_dressNum) 	 	 
	DressPaint_Zidong_ALLChoice:Enable() 
end

--»æ≥ˆƒø±Í—†…´
function DressPaint_SuccDestMode(strDressDesc)
	local Msg = ScriptGlobal_Format("#{YJRS_140613_15}", strDressDesc) 
	PushDebugMessage(Msg)
	DressPaint_ResetZiDongState()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnSuccDressPaint")
		Set_XSCRIPT_ScriptID(830001) 
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()  
end

--ƒø±ÍComList—°‘Ò ¬º˛
function DressPaint_DestMode_Changed() 
	if g_ZiDongState == 1 then
		PushDebugMessage("#{YJRS_140613_07}") 
		return
	end 
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()
	if ComIdx == g_dressNum then
		g_IsXiYouStop = 1
	else
		g_IsXiYouStop = 0
	end 
	
	if ComIdx > 0 then 
		DressPaint_Zidong:SetText("#G#{YJRS_140613_04}") 
		DressPaint_Zidong:Enable()
		DressPaint_Zidong_Animate:Play(true)
	else
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable() 
		DressPaint_Zidong_Animate:Play(false)
	end 
	local n_visualID = DressReplaceColor : GetDressVisualID(DRESS_POS) 
	if n_visualID == 0 then
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		return  
	end
	
	local _name,ComIdx = DressPaint_Zidong_ALLChoice:GetCurrentSelect()

	if DressVisualID[ComIdx] == n_visualID then 
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		PushDebugMessage("#{YJRS_140613_24}")
	end  
	local n_szDressDesc, nRate, MaterBind = DressReplaceColor : GetDressVisualInfo(DRESS_POS) 
	if nRate == 1000 and ComIdx == g_dressNum then 
		DressPaint_Zidong:SetText("#{YJRS_140613_04}") 
		DressPaint_Zidong:Disable()
		DressPaint_Zidong_Animate:Play(false)
		PushDebugMessage("#{YJRS_140613_24}") 
	end  
end

-- Ω´∞¥≈•…Ë÷√≥…÷†÷π◊¥Ã¨
function DressPaint_RetSetZidongButtonText()
	DressPaint_Zidong:SetText("#{YJRS_140613_05}")
end

--µ„ª˜◊‘∂Ø»æ…´ ¬º˛
function DressPaint_Zidong_Clicked()			--????  ??timer??
	if g_ZiDongState == 0 then 
		if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
			PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
			return
		end 
		--≈–∂œµÁª∞√‹±£∫Õ∂˛º∂√‹¬Î±£ª§2012.6.12-LIUBO
		if CheckPhoneMibaoAndMinorPassword() ~= 1 then
			return
		end

		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")
		if selfMoney < g_NeedMoney then
			PushDebugMessage("#{YJRS_140613_11}")
			return
		end

		g_DressPaint_TipsBind = DressReplaceColor:GetDressPaint_TipsBind()
		local isDressBind = GetItemBindStatus(DRESS_POS)
		local n_szDressDesc, nRate, MaterBind = DressReplaceColor : GetDressVisualInfo(DRESS_POS)
		if g_DressPaint_TipsBind == 0 and isDressBind == 0 then--and PlayerPackage:CountAvailableItemByIDTable(MaterBind) > 0 then
			local bagIdx,BindState =  PlayerPackage:FindFirstBindedItemIdxByIDTable(MaterBind)
			-- †“µΩ¡À∏√µ¿æﬂ£¨≤¢«“Œ™∞Û∂®◊¥Ã¨
			if bagIdx > 0 and BindState == EB_BINDED then
				PushEvent( "DRESSPAINT_BINDDRESS")
				return
			end
		end
		if nRate == 1000 and g_DressPaint_TipsTwice == 0 then 
			PushEvent( "DRESSPAINT_SELECTSERVER", n_szDressDesc )
			g_DressPaint_TipsTwice = 1
			return
		end
		g_IsFirstAuto       = 1

		g_ZiDongState 		= 1
		g_ZiDongTimerState	= 1
		g_RecvGRespState    = 1
		SetTimer("DressPaint","DressPaint_ZiDong_TimerEvent()", g_Zidong_ClickTime)
		DressPaint_Zidong_ALLChoice:Disable() 
	else 
		PushDebugMessage("#{YJRS_140613_17}")
		DressPaint_ResetZiDongState()
	end
end
