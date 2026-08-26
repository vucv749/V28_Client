local g_Couples_VaultSave_Frame_UnifiedXPosition
local g_Couples_VaultSave_Frame_UnifiedYPosition
local g_Couples_VaultSave_nSearch = 0

function Couples_VaultSave_PreLoad()
	this:RegisterEvent("UPDATE_COUPLEZONE_INYBORMONEY")
	this:RegisterEvent("CLOSE_COUPLEZONE_VAULT")

	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Couples_VaultSave_OnLoad()
	g_Couples_VaultSave_Frame_UnifiedXPosition = Couples_VaultSave_Frame:GetProperty("UnifiedXPosition")
	g_Couples_VaultSave_Frame_UnifiedYPosition = Couples_VaultSave_Frame:GetProperty("UnifiedYPosition")

	Couples_VaultSave_Type1_Money:AddTextItem("#{YYJG_20230407_52}",0)
	Couples_VaultSave_Type1_Money:AddTextItem("#{YYJG_20230407_53}",1)
end

function Couples_VaultSave_OnEvent(event)
	if ( event=="UPDATE_COUPLEZONE_INYBORMONEY" ) then
		Couples_VaultSave_Type1_Money:SetCurrentSelect(0)
		g_Couples_VaultSave_nSearch = 0

		Couples_VaultSave_InfoInput:SetText("")

		Couples_VaultSave_Jinbi:Show()
		Couples_VaultSave_Yuanbao:Hide()
		Couples_VaultSave_Type1_Save_Gold:SetText("")
		Couples_VaultSave_Type1_Save_Silver:SetText("")
		Couples_VaultSave_Type1_Save_CopperCoin:SetText("")

		Couples_VaultSave_JinbiBK:Show()
		Couples_VaultSave_YuanbaoBK:Hide()

		local money = Player:GetData("MONEY")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()
		Couples_VaultSave_GongxiangJinbi_Text1:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(couplemoney)))
		Couples_VaultSave_YongyouJinbi_Text:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(money)))
		
		this:Show()
	elseif ( event == "CLOSE_COUPLEZONE_VAULT" ) then
		this:Hide()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		Couples_VaultSave_Hide()
	elseif ( event == "ADJEST_UI_POS" ) then	
		Couples_VaultSave_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Couples_VaultSave_Frame_On_ResetPos()
	end
end

function Couples_VaultSave_Hide()
	this:Hide()	
end

function Couples_VaultSave_Frame_On_ResetPos()
	Couples_VaultSave_Frame:SetProperty( "UnifiedXPosition", g_Couples_VaultSave_Frame_UnifiedXPosition )
	Couples_VaultSave_Frame:SetProperty( "UnifiedYPosition", g_Couples_VaultSave_Frame_UnifiedYPosition )
end

function Couples_VaultSave_BeginCareObject(objCaredId)
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		Couples_VaultSave_Hide()
		return
	end

	local objId = DataPool:GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this:CareObject( objId, 1, "Couples_VaultSave" )
end

function Couples_VaultSave_Type1_Changed()
	local str, nIndex = Couples_VaultSave_Type1_Money:GetCurrentSelect()
	if g_Couples_VaultSave_nSearch == nIndex then
		return
	end

	g_Couples_VaultSave_nSearch = nIndex

	if g_Couples_VaultSave_nSearch == 0 then
		Couples_VaultSave_Jinbi:Show()
		Couples_VaultSave_Yuanbao:Hide()
		Couples_VaultSave_Type1_Save_Gold:SetText("")
		Couples_VaultSave_Type1_Save_Silver:SetText("")
		Couples_VaultSave_Type1_Save_CopperCoin:SetText("")

		Couples_VaultSave_JinbiBK:Show()
		Couples_VaultSave_YuanbaoBK:Hide()

		local money = Player:GetData("MONEY")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()
		Couples_VaultSave_GongxiangJinbi_Text1:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(couplemoney)))
		Couples_VaultSave_YongyouJinbi_Text:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(money)))
	elseif g_Couples_VaultSave_nSearch == 1 then
		Couples_VaultSave_Jinbi:Hide()
		Couples_VaultSave_Yuanbao:Show()
		Couples_VaultSave_Type1_Save:SetText("")

		Couples_VaultSave_JinbiBK:Hide()
		Couples_VaultSave_YuanbaoBK:Show()

		local money = Player:GetData("YUANBAO")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultYB()

		Couples_VaultSave_Gongxiangyuangbao_Text1:SetText(couplemoney)
		Couples_VaultSave_YongyouYuanbao_Text:SetText(money)
	end
end

function Couples_VaultSave_OK_Clicked()
	local money = 0
	if g_Couples_VaultSave_nSearch == 0 then
		local gold = tonumber(Couples_VaultSave_Type1_Save_Gold:GetText())
		if not gold or gold <= 0 then
			gold = 0
		end
		local silver = tonumber(Couples_VaultSave_Type1_Save_Silver:GetText())
		if not silver or silver <= 0 then
			silver = 0
		end
		local copper = tonumber(Couples_VaultSave_Type1_Save_CopperCoin:GetText())
		if not copper or copper <= 0 then
			copper = 0
		end

		money = gold*10000 + silver*100 + copper
	elseif g_Couples_VaultSave_nSearch == 1 then
		money = tonumber(Couples_VaultSave_Type1_Save:GetText())
		if not money or money <= 0 then
			money = 0
		end
	else
		return
	end

	local words = tostring(Couples_VaultSave_InfoInput:GetText())
	local ret = string.len(words)
	if ret <= 0 then
		words = ""
	end

	if money == 0 then
		return
	end

	if money ~= nil and words ~= nil then
		if g_Couples_VaultSave_nSearch == 0 then
			CoupleZone:LuaFnCoupleInYBOrMoney( 1, tonumber(money), tostring(words), 0 )
		elseif g_Couples_VaultSave_nSearch == 1 then
			CoupleZone:LuaFnCoupleInYBOrMoney( 0, tonumber(money), tostring(words), 0 )
		end
	end
end

function Couples_VaultSave_Type1_OnMaxNum()
	if g_Couples_VaultSave_nSearch == 1 then
		local money = Player:GetData("YUANBAO")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultYB()
		local reduce = 200000 - couplemoney
		local maxmoney = 0
		if reduce > money then
			maxmoney = money
		else
			maxmoney = reduce
		end

		Couples_VaultSave_Type1_Save:SetText(maxmoney)
	end
end

function Couples_VaultSave_Jinbi_OnMaxNum()
	if g_Couples_VaultSave_nSearch == 0 then
		local money = Player:GetData("MONEY")
		local couplemoney = CoupleZone:LuaFnGetCoupleVaultMoney()
		local reduce = 100000000 - couplemoney
		local maxmoney = 0
		if reduce > money then
			maxmoney = money
		else
			maxmoney = reduce
		end

		local gold = math.floor(maxmoney/10000)
		local silver = math.floor(math.mod(maxmoney,10000)/100)
		local copper = math.mod(maxmoney,100)

		Couples_VaultSave_Type1_Save_Gold:SetText(gold)
		Couples_VaultSave_Type1_Save_Silver:SetText(silver)
		Couples_VaultSave_Type1_Save_CopperCoin:SetText(copper)
	end
end
