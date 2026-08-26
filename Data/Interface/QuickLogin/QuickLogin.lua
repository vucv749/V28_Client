--¿ì½ÝµÇÂ¼½çÃæ
--Ñ©ÎèÒÆÖ²²¢¶þ´ÎÖÆ×÷ 2024-7-9 16:49:42

g_UserPassWord 		= "../Accounts/Accounts.cfg" --?????????
--¿Ø¼þÁÐ±í
local LoginButtons 			= {}
local ControlPanels 		= {}
local AccountFields 		= {}
local selectedAccountIndex 	= 0
local g_check = -1
--·­Ò³¹¦ÄÜ±äÁ¿
local currentPage 	  = 1
local accountsPerPage = 10  -- ?????????
local totalAccounts   = 0     -- ????,??????????

--===============================================
-- ³õÊ¼»¯º¯Êý
--===============================================
function QuickLogin_PreLoad()
    this:RegisterEvent("UI_COMMAND")
end

--===============================================
-- ³õÊ¼»¯µÇÂ¼¿Ø¼þ
--===============================================
function QuickLogin_OnLoad()
    for i = 1, 10 do
        LoginButtons[i] = _G["QuickLogin_Button" .. i]
        ControlPanels[i] = _G["QuickLogin_Panel" .. i]
        AccountFields[i] = _G["QuickLogin_AccountField" .. i]
    end
	QuickLogin_modify_Frame:Hide();
end

--===============================================
-- ´¦ÀíUIÃüÁîÊÂ¼þ
--===============================================
function QuickLogin_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == 2023122205 then
        selectedAccountIndex = 0
        for i = 1, 10 do
            LoginButtons[i]:SetCheck(0)
        end
        QuickLogin_ShowSavedAccounts()
		QuickLogin_modify_Frame:Hide();
		QuickLogin_Frame:SetProperty("UnifiedSize","{{0,340.000000},{0.000000,210.000000}");
    end
end

--===============================================
-- Ñ¡Ôñ ËºÅÊ±´¥·¢µÄº¯Êý
--===============================================
function QuickLogin_SelectAccount(arg)
    for i = 1, 10 do
        if arg ~= i then
            LoginButtons[i]:SetCheck(0)
        end
    end
    selectedAccountIndex = arg
    LoginButtons[selectedAccountIndex]:SetCheck(1)
end

--===============================================
--  ¹Ê¾±£´æµÄ ËºÅ
--===============================================
function QuickLogin_ShowSavedAccounts()
    local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord()
    totalAccounts = table.getn(nSavenAccID)  -- ??????

    if totalAccounts == 0 then
        PushDebugMessage("TÕm Vô bäo t°n Ðích tài khoän.")
        if this:IsVisible() then
            QuickLogin_Close_Clicked()
        end
        return
    end

    local startIndex = (currentPage - 1) * accountsPerPage + 1
    local endIndex = math.min(startIndex + accountsPerPage - 1, totalAccounts)

    for i = 1, accountsPerPage do
        local panelIndex = startIndex + i - 1
        if panelIndex <= endIndex then
            ControlPanels[i]:Show()
            AccountFields[i]:SetText(tostring(nSavenAccID[panelIndex]))
        else
            ControlPanels[i]:Hide()
        end
    end
    this:Show()
	QuickLogin_UpdatePaginationButtons()
end

--===============================================
--ÏÂÒ»Ò³
--===============================================
function QuickLogin_nextPage()
    local maxPage = math.ceil(totalAccounts / accountsPerPage)
    if currentPage < maxPage then
        currentPage = currentPage + 1
        QuickLogin_ShowSavedAccounts()
    end
end

--===============================================
--ÉÏÒ»Ò³
--===============================================
function QuickLogin_previousPage()
    if currentPage > 1 then
        currentPage = currentPage - 1
        QuickLogin_ShowSavedAccounts()
    end
end

--===============================================
-- ´ÓÎÄ¼þ»ñÈ¡±£´æµÄ ËºÅºÍÃÜÂë
--===============================================
function QuickLogin_GetPassWord(OP,targetLine)
	if OP == nil then
		local nSavenAccID, nSavenPassd = {}, {}
		local i = 1
		local file = io.open(g_UserPassWord, "r")
		if file ~= nil then
			for line in file:lines() do
				if line == nil then
					break
				end
				local _, _, nID, nPass = string.find(line, "(.*)\t(.*)")
				nSavenAccID[i] = nID--LuaFnGetPassWord(nID)
				nSavenPassd[i] = nPass--LuaFnGetPassWord(nPass)
				i = i + 1
			end
			file:close()
			return nSavenAccID, nSavenPassd
		end
		return nSavenAccID, nSavenPassd
	else
		local nSavenAccID, nSavenPassd = -1, -1
		local currentLine = 1
		local file = io.open(g_UserPassWord, "r")
		if file ~= nil then
			for line in file:lines() do
				if currentLine == targetLine then
					local _, _, nID, nPass = string.find(line, "(.*)\t(.*)")
					nSavenAccID = nID--LuaFnGetPassWord(nID)
					nSavenPassd = nPass--LuaFnGetPassWord(nPass)
					break
				end
				currentLine = currentLine + 1
			end
			file:close()
		end
		return nSavenAccID, nSavenPassd
	end
end


--===============================================
-- µÇÂ¼Ñ¡¶¨ ËºÅ
--===============================================
function QuickLogin_AccountLoginClick()
    if selectedAccountIndex == 0 then
        PushDebugMessage("V¸ lña ch÷n c¥n ðång ký Ðích tài khoän.")
        return
    end
	local startIndex = (currentPage - 1) * accountsPerPage + 1
    local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord()
    PushEvent("UI_COMMAND", 2023122306, nSavenAccID[startIndex + selectedAccountIndex - 1], nSavenPassd[startIndex + selectedAccountIndex - 1])
    QuickLogin_Close_Clicked()
end

--===============================================
-- ¸üÐÂ·­Ò³°´Å¥×´Ì¬
--===============================================
function QuickLogin_UpdatePaginationButtons()
    local maxPage = math.ceil(totalAccounts / accountsPerPage)
    if currentPage >= maxPage then
        QuickLogin_next:Disable()  -- ????????????????,??“???”??
    else
        QuickLogin_next:Enable()   -- ????????,??“???”??
    end

    if currentPage > 1 then
        QuickLogin_previous:Enable()  -- ??????????,??“???”??
    else
        QuickLogin_previous:Disable() -- ??????,??“???”??
    end
end

--===============================================
--É¾³ý±£´æµÄ ËºÅ
--===============================================
function QuickLogin_RemoveSavedAccounts()
    if selectedAccountIndex == 0 then
        PushDebugMessage("V¸ lña ch÷n c¥n xóa bö Ðích tài khoän.")
        return
    end
    local nSavenAccID,_ = QuickLogin_GetPassWord()
    local accountToDelete = nSavenAccID[selectedAccountIndex]
	if not accountToDelete then
        PushDebugMessage("Lña ch÷n Ðích tài khoän không có hi®u quä.")
        return
    end
	
	--É¾³ý¶þ´ÎÈ·ÈÏ
	if g_check ~= 1 then
		GameProduceLogin:GameLoginShowSystemInfo("#cfff263xác ð¸nh Yêu xóa bö tài khoän Ma? #r#GTI¬u nêu lên: Thïnh TÕi ðóng cØa B±n nêu lên H§u lÕi Ði¬m Kích xóa bö cái nút có th¬ xóa bö tài khoän.")
		g_check = 1;
		return
	end
	
    local ID, PassWord = LogOn_GetPassWord() -- ??????????????
	-- ÖØ¹¹Êý¾Ý£¬ÅÅ³ýÐèÒªÉ¾³ýµÄ ËºÅ
	local nHave = 0
    for i = 1, table.getn(nSavenAccID) do
        if accountToDelete == nil then
            break
        end
        if accountToDelete == nSavenAccID[i] then
            nHave = i
        end
    end
    local nSvaeData = ""
    for i = 1, table.getn(nSavenAccID) do
        if nHave ~= i then
            -- nSvaeData = nSvaeData .. LuaFnSavePassWord(ID[i]) .. "\t" .. LuaFnSavePassWord(PassWord[i]) .. "\n"
			nSvaeData = nSvaeData .. (ID[i]) .. "\t" .. (PassWord[i]) .. "\n"
        end
    end
	-- ±£´æ¸üÐÂºóµÄÊý¾Ýµ½ÎÄ¼þ
    local file = io.open(g_UserPassWord, "wb")
    if file ~= nil and nSvaeData ~= "" then
        file:write(nSvaeData)
        file:close()
    end
	-- ÖØÖÃÑ¡Ôñ×´Ì¬²¢¸üÐÂÏÔÊ¾
    for i = 1, 10 do
        LoginButtons[i]:SetCheck(0)
    end
    selectedAccountIndex = 0
    QuickLogin_ShowSavedAccounts()
    PushDebugMessage("M¡c nþ Hào thành công xóa bö.")
end

--ÏÔÊ¾ÐÞ¸Ä½çÃæ
function QuickLogin_modifyAccounts()
	QuickLogin_Frame:SetProperty("UnifiedSize","{{0,502.000000},{0.000000,210.000000}");
	QuickLogin_modify_Frame:Show();
	if selectedAccountIndex == 0 then
		PushDebugMessage("Thïnh Tiên lña ch÷n c¥n sØa chæa Ðích tài khoän.")
		return
	end
	local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord(1,selectedAccountIndex)
	QuickLogin_Edix1:SetText(tostring(nSavenAccID))
	QuickLogin_Edix2:SetText(tostring(nSavenPassd))
end

--È·ÈÏÐÞ¸Ä ËºÅÐÅÏ¢
function QuickLogin_modifyOK(OP)
	if OP == 1 then --????
		QuickLogin_Frame:SetProperty("UnifiedSize","{{0,340.000000},{0.000000,210.000000}");
		QuickLogin_modify_Frame:Hide();
		if selectedAccountIndex == 0 then
			PushDebugMessage("Thïnh Tiên lña ch÷n c¥n sØa chæa Ðích tài khoän.")
			return
		end
		--´¢´æÐÞ¸ÄµÄ ËºÅ
		local nSvaeData = ""
		local nSavenAccID = QuickLogin_Edix1:GetText()
		local nSavenPassd = QuickLogin_Edix2:GetText()
		local ID,PassWord = LogOn_GetPassWord()
		for i = 1,table.getn(ID) do
			if i == selectedAccountIndex then
				--nSvaeData = nSvaeData..LuaFnSavePassWord(nSavenAccID).."\t"..LuaFnSavePassWord(nSavenPassd).."\n"
				nSvaeData = nSvaeData..(nSavenAccID).."\t"..(nSavenPassd).."\n"
			else
				--nSvaeData = nSvaeData..LuaFnSavePassWord(ID[i]).."\t"..LuaFnSavePassWord(PassWord[i]).."\n"	
				nSvaeData = nSvaeData..(ID[i]).."\t"..(PassWord[i]).."\n"	
			end
		end
		local file = io.open(g_UserPassWord, "wb")
		if file ~= nil and nSvaeData ~= ""then
			file:write(nSvaeData);
			file:close();
		end
		--Ë¢ÐÂ½çÃæ
		QuickLogin_ShowSavedAccounts()
	elseif OP == 2 then  --??
		QuickLogin_Frame:SetProperty("UnifiedSize","{{0,340.000000},{0.000000,210.000000}");
		QuickLogin_modify_Frame:Hide();
	end
end
--===============================================
-- ¹Ø± ½çÃæ
--===============================================
function QuickLogin_Close_Clicked()
    this:Hide()
end
