local g_Couples_Vault_Frame_UnifiedXPosition
local g_Couples_Vault_Frame_UnifiedYPosition

function Couples_Vault_PreLoad()
	this:RegisterEvent("UPDATE_COUPLEZONE_VAULT")

	this:RegisterEvent("PLAYER_LEAVE_WORLD")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function Couples_Vault_OnLoad()
	g_Couples_Vault_Frame_UnifiedXPosition = Couples_Vault_Frame:GetProperty("UnifiedXPosition")
	g_Couples_Vault_Frame_UnifiedYPosition = Couples_Vault_Frame:GetProperty("UnifiedYPosition")
end

function Couples_Vault_OnEvent(event)
	if ( event == "UPDATE_COUPLEZONE_VAULT" ) then 
		Couples_Vault_Update()
		this:Show()
	elseif ( event == "PLAYER_LEAVE_WORLD" ) then 
		Couples_Vault_Frame_Close()
	elseif ( event == "ADJEST_UI_POS" ) then	
		Couples_Vault_Frame_On_ResetPos()
	elseif ( event == "VIEW_RESOLUTION_CHANGED" ) then
		Couples_Vault_Frame_On_ResetPos()
	end
end

function Couples_Vault_Update()
	local yb = CoupleZone:LuaFnGetCoupleVaultYB()
	local money = CoupleZone:LuaFnGetCoupleVaultMoney()
	local lognum = CoupleZone:LuaFnGetCoupleVaultLogNum()
	local name_0 = CoupleZone:LuaFnGetCoupleVaultCharName_0()
	local name_1 = CoupleZone:LuaFnGetCoupleVaultCharName_1()
	if lognum == 0 then
		Couples_Vault_List:Clear()
	else
		local moneylog = ""
		Couples_Vault_List:Clear()
		for i = 0, lognum-1 do
			local isvalid, optype, currency, name, cnt, note, daytime = CoupleZone:LuaFnGetCoupleVaultLogContent(i)

			local year = math.floor(daytime / 100000000) + 2000
			local month = math.floor(math.mod( daytime, 100000000 ) / 1000000)
			local day = math.floor(math.mod( daytime, 1000000 ) / 10000)
			local hour = math.floor(math.mod( daytime, 10000 ) / 100)
			local minute = math.floor(math.mod( daytime, 100 ))

			local str = ""
			local str1 = ""

			str = ScriptGlobal_Format( "#{YYJG_20230407_91}", tostring(year), tostring(month), tostring(day), tostring(hour), tostring(minute) )

			if optype == 1 then
				str1 = ScriptGlobal_Format( "#{YYJG_20230407_93}", tostring(cnt) )
			elseif optype == 2 then
				str1 = ScriptGlobal_Format( "#{YYJG_20230407_95}", tostring(cnt) )
			elseif optype == 3 then
				str1 = ScriptGlobal_Format( "#{YYJG_20230407_94}", tostring(cnt) )
			elseif optype == 4 then
				str1 = ScriptGlobal_Format( "#{YYJG_20230407_96}", tostring(cnt) )
			end

			local words = ""
			if string.len(note) > 0 then
				words = ScriptGlobal_Format( "#{YYJG_20230407_92}", note )
			end

			local bar1 = Couples_Vault_List:AddChild("Couples_Vault_Info3")
			if not bar1 then
				break
			end

			local ShowName = ScriptGlobal_Format( "#{YYJG_20230407_90}", tostring(name) )

			bar1:GetSubItem("Couples_Vault_InfoText1"):SetText(ShowName)
			bar1:GetSubItem("Couples_Vault_InfoText2"):SetText(str)
			bar1:GetSubItem("Couples_Vault_InfoText3"):SetText(words)
			bar1:GetSubItem("Couples_Vault_InfoText4"):SetText(str1)

			moneylog = moneylog..str..str1..words

			if i ~= lognum-1 then
				moneylog = moneylog.."\n"
			end
		end
		--Couples_Vault_Info3:SetText(moneylog)
	end
	local title = ""
	if Player:GetMySex() == 0 then
		title = ScriptGlobal_Format( "#{YYJG_20230407_43}", name_0, name_1 )
	else
		title = ScriptGlobal_Format( "#{YYJG_20230407_43}", name_1, name_0 )
	end
	Couples_Vault_Title:SetText(title)
	Couples_Vault_Money1:SetText(ScriptGlobal_Format("#{YYJG_20230407_89}",tostring(money)))
	Couples_Vault_Money2:SetText( yb )
end

function Couples_Vault_InYBOrMoney_Click()
	PushEvent( "UPDATE_COUPLEZONE_INYBORMONEY" )
end

function Couples_Vault_OutYBOrMoney_Click()
	PushEvent( "UPDATE_COUPLEZONE_OUTYBORMONEY" )
end

function Couples_Vault_Frame_Close()
	this:Hide()
end

function Couples_Vault_Frame_On_ResetPos()
	Couples_Vault_Frame:SetProperty( "UnifiedXPosition", g_Couples_Vault_Frame_UnifiedXPosition )
	Couples_Vault_Frame:SetProperty( "UnifiedYPosition", g_Couples_Vault_Frame_UnifiedYPosition )
end


