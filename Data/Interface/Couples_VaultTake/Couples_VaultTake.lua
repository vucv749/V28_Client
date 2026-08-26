local g_Couples_VaultTake_Frame_UnifiedXPosition
local g_Couples_VaultTake_Frame_UnifiedYPosition
local g_Couples_VaultTake_nSearch = 0

function Couples_VaultTake_PreLoad()
	this:RegisterEvent("UPDATE_COUPLEZONE_OUTYBORMONEY")
	this:RegisterEvent("CLOSE_COUPLEZONE_VAULT")

	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Couples_VaultTake_OnLoad()
	g_Couples_VaultTake_Frame_UnifiedXPosition = Couples_VaultTake_Frame:GetProperty("UnifiedXPosition")
	g_Couples_VaultTake_Frame_UnifiedYPosition = Couples_VaultTake_Frame:GetProperty("UnifiedYPosition")

	Couples_VaultTake_Type1_Money:AddTextItem("#{YYJG_20230407_52}",0)
	Couples_VaultTake_Type1_Money:AddTextItem("#{YYJG_20230407_53}",1)
end

function Couples_VaultTake_OnEvent(event)
	if ( event=="UPDATE_COUPLEZONE_OUTYBORMONEY" ) then
		Couples_VaultTake_Type1_Money:SetCurrentSelect(0)
		g_Couples_VaultTake_nSearch = 0

		Couples_VaultTake_Jinbi:Show()
		Couples_VaultTake_Yuanbao:Hide()
		Couples_VaultTake_Type1_Save_Gold:SetText("")
		Couples_VaultTake_Type1_Save_Silver:SetText("")
		Couples_VaultTake_Type1_Save_CopperCoin:SetText("")

		Couples_VaultTake_InfoInput:SetText("")

		Couples_VaultTake_JinbiBK:Show()
		Couples_VaultTake_YuanbaoBK:Hide()

		local money = Player:GetData("MONEY")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()
		Couples_VaultTake_GongxiangJinbi_Text1:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(couplemoney)))
		Couples_VaultTake_YongyouJinbi_Text:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(money)))

		this:Show()
	elseif ( event == "CLOSE_COUPLEZONE_VAULT" ) then
		this:Hide()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		Couples_VaultTake_Hide()
	elseif ( event == "ADJEST_UI_POS" ) then	
		Couples_VaultTake_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Couples_VaultTake_Frame_On_ResetPos()
	end
end

function Couples_VaultTake_Hide()
	this:Hide()	
end

function Couples_VaultTake_Frame_On_ResetPos()
	Couples_VaultTake_Frame:SetProperty( "UnifiedXPosition", g_Couples_VaultTake_Frame_UnifiedXPosition )
	Couples_VaultTake_Frame:SetProperty( "UnifiedYPosition", g_Couples_VaultTake_Frame_UnifiedYPosition )
end

function Couples_VaultTake_BeginCareObject(objCaredId)
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		Couples_VaultTake_Hide()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "Couples_VaultTake" )
end

function Couples_VaultTake_Type1_Changed()
	local str, nIndex = Couples_VaultTake_Type1_Money:GetCurrentSelect()
	if g_Couples_VaultTake_nSearch == nIndex then
		return
	end

	g_Couples_VaultTake_nSearch = nIndex
	if g_Couples_VaultTake_nSearch == 0 then
		Couples_VaultTake_Jinbi:Show()
		Couples_VaultTake_Yuanbao:Hide()
		Couples_VaultTake_Type1_Save_Gold:SetText("")
		Couples_VaultTake_Type1_Save_Silver:SetText("")
		Couples_VaultTake_Type1_Save_CopperCoin:SetText("")

		Couples_VaultTake_InfoInput:SetText("")

		Couples_VaultTake_JinbiBK:Show()
		Couples_VaultTake_YuanbaoBK:Hide()

		local money = Player:GetData("MONEY")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()
		Couples_VaultTake_GongxiangJinbi_Text1:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(couplemoney)))
		Couples_VaultTake_YongyouJinbi_Text:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(money)))
	elseif g_Couples_VaultTake_nSearch == 1 then
		Couples_VaultTake_Jinbi:Hide()
		Couples_VaultTake_Yuanbao:Show()
		Couples_VaultTake_Type1_Save:SetText("")

		Couples_VaultTake_InfoInput:SetText("")

		Couples_VaultTake_JinbiBK:Hide()
		Couples_VaultTake_YuanbaoBK:Show()

		local money = Player:GetData("YUANBAO")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultYB()
		Couples_VaultTake_Gongxiangyuangbao_Text1:SetText(couplemoney)
		Couples_VaultTake_YongyouYuanbao_Text:SetText(money)

	end
end

function Couples_VaultTake_OK_Clicked()
	local money = 0
	if g_Couples_VaultTake_nSearch == 0 then
		local gold = tonumber(Couples_VaultTake_Type1_Save_Gold:GetText())
		if not gold or gold <= 0 then
			gold = 0
		end
		local silver = tonumber(Couples_VaultTake_Type1_Save_Silver:GetText())
		if not silver or silver <= 0 then
			silver = 0
		end
		local copper = tonumber(Couples_VaultTake_Type1_Save_CopperCoin:GetText())
		if not copper or copper <= 0 then
			copper = 0
		end

		money = gold*10000 + silver*100 + copper
	elseif g_Couples_VaultTake_nSearch == 1 then
		money = tonumber(Couples_VaultTake_Type1_Save:GetText())
		if not money or money <= 0 then
			money = 0
		end
	else
		return
	end

	local words = tostring(Couples_VaultTake_InfoInput:GetText())
	local ret = string.len(words)
	if ret <= 0 then
		words = ""
	end

	if money == 0 then
		return
	end

	if money ~= nil and words ~= nil then
		if g_Couples_VaultTake_nSearch == 0 then
			CoupleZone:LuaFnCoupleOutYBOrMoney( 1, tonumber(money), tostring(words), 0 )
		elseif g_Couples_VaultTake_nSearch == 1 then
			CoupleZone:LuaFnCoupleOutYBOrMoney( 0, tonumber(money), tostring(words), 0 )
		end
	end
end

function Couples_VaultTake_Type1_OnMaxNum()
	if g_Couples_VaultTake_nSearch == 1 then
		local money = Player:GetData("YUANBAO")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultYB()
		local reduce = 999999 - money
		local maxmoney = 0
		if reduce > couplemoney then
			maxmoney = couplemoney
		else
			maxmoney = reduce
		end

		Couples_VaultTake_Type1_Save:SetText(maxmoney)
	end
end

function Couples_VaultTake_Jinbi_OnMaxNum()
	if g_Couples_VaultTake_nSearch == 0 then
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()

		local gold = math.floor(couplemoney/10000)
		local silver = math.floor(math.mod(couplemoney,10000)/100)
		local copper = math.mod(couplemoney,100)

		Couples_VaultTake_Type1_Save_Gold:SetText(gold)
		Couples_VaultTake_Type1_Save_Silver:SetText(silver)
		Couples_VaultTake_Type1_Save_CopperCoin:SetText(copper)
	end
end


