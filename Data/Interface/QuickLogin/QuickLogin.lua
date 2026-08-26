--快捷登录界面
--雪舞移植并二次制作 2024-7-9 16:49:42

g_UserPassWord 		= "../Accounts/Accounts.cfg" --记住账号密码的文件
--控件列表
local LoginButtons 			= {}
local ControlPanels 		= {}
local AccountFields 		= {}
local selectedAccountIndex 	= 0
local g_check = -1
--翻页功能变量
local currentPage 	  = 1
local accountsPerPage = 10  -- 每页显示的账号数量
local totalAccounts   = 0     -- 总账号数，需要在获取账号时更新

--===============================================
-- 初始化函数
--===============================================
function QuickLogin_PreLoad()
    this:RegisterEvent("UI_COMMAND")
end

--===============================================
-- 初始化登录控件
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
-- 处理UI命令事件
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
-- 选择账号时触发的函数
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
-- 展示保存的账号
--===============================================
function QuickLogin_ShowSavedAccounts()
    local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord()
    totalAccounts = table.getn(nSavenAccID)  -- 更新总账号数

    if totalAccounts == 0 then
        PushDebugMessage("暂无保存的账号。")
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
--下一页
--===============================================
function QuickLogin_nextPage()
    local maxPage = math.ceil(totalAccounts / accountsPerPage)
    if currentPage < maxPage then
        currentPage = currentPage + 1
        QuickLogin_ShowSavedAccounts()
    end
end

--===============================================
--上一页
--===============================================
function QuickLogin_previousPage()
    if currentPage > 1 then
        currentPage = currentPage - 1
        QuickLogin_ShowSavedAccounts()
    end
end

--===============================================
-- 从文件获取保存的账号和密码
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
-- 登录选定账号
--===============================================
function QuickLogin_AccountLoginClick()
    if selectedAccountIndex == 0 then
        PushDebugMessage("未选择需要登录的账号。")
        return
    end
	local startIndex = (currentPage - 1) * accountsPerPage + 1
    local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord()
    PushEvent("UI_COMMAND", 2023122306, nSavenAccID[startIndex + selectedAccountIndex - 1], nSavenPassd[startIndex + selectedAccountIndex - 1])
    QuickLogin_Close_Clicked()
end

--===============================================
-- 更新翻页按钮状态
--===============================================
function QuickLogin_UpdatePaginationButtons()
    local maxPage = math.ceil(totalAccounts / accountsPerPage)
    if currentPage >= maxPage then
        QuickLogin_next:Disable()  -- 如果当前页是最后一页或者只有一页，禁用“下一页”按钮
    else
        QuickLogin_next:Enable()   -- 如果不是最后一页，启用“下一页”按钮
    end

    if currentPage > 1 then
        QuickLogin_previous:Enable()  -- 如果当前页不是第一页，启用“上一页”按钮
    else
        QuickLogin_previous:Disable() -- 如果是第一页，禁用“上一页”按钮
    end
end

--===============================================
--删除保存的账号
--===============================================
function QuickLogin_RemoveSavedAccounts()
    if selectedAccountIndex == 0 then
        PushDebugMessage("未选择需要删除的账号。")
        return
    end
    local nSavenAccID,_ = QuickLogin_GetPassWord()
    local accountToDelete = nSavenAccID[selectedAccountIndex]
	if not accountToDelete then
        PushDebugMessage("选择的账号无效。")
        return
    end
	
	--删除二次确认
	if g_check ~= 1 then
		GameProduceLogin:GameLoginShowSystemInfo("#cfff263确定要删除账号吗？#r#G小提示：请在关闭本提示后再次点击删除按钮即可删除账号。")
		g_check = 1;
		return
	end
	
    local ID, PassWord = LogOn_GetPassWord() -- 获取当前保存的所有账号和密码
	-- 重构数据，排除需要删除的账号
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
	-- 保存更新后的数据到文件
    local file = io.open(g_UserPassWord, "wb")
    if file ~= nil and nSvaeData ~= "" then
        file:write(nSvaeData)
        file:close()
    end
	-- 重置选择状态并更新显示
    for i = 1, 10 do
        LoginButtons[i]:SetCheck(0)
    end
    selectedAccountIndex = 0
    QuickLogin_ShowSavedAccounts()
    PushDebugMessage("该账号成功删除。")
end

--显示修改界面
function QuickLogin_modifyAccounts()
	QuickLogin_Frame:SetProperty("UnifiedSize","{{0,502.000000},{0.000000,210.000000}");
	QuickLogin_modify_Frame:Show();
	if selectedAccountIndex == 0 then
		PushDebugMessage("请先选择需要修改的账号。")
		return
	end
	local nSavenAccID, nSavenPassd = QuickLogin_GetPassWord(1,selectedAccountIndex)
	QuickLogin_Edix1:SetText(tostring(nSavenAccID))
	QuickLogin_Edix2:SetText(tostring(nSavenPassd))
end

--确认修改账号信息
function QuickLogin_modifyOK(OP)
	if OP == 1 then --确认修改
		QuickLogin_Frame:SetProperty("UnifiedSize","{{0,340.000000},{0.000000,210.000000}");
		QuickLogin_modify_Frame:Hide();
		if selectedAccountIndex == 0 then
			PushDebugMessage("请先选择需要修改的账号。")
			return
		end
		--储存修改的账号
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
		--刷新界面
		QuickLogin_ShowSavedAccounts()
	elseif OP == 2 then  --取消
		QuickLogin_Frame:SetProperty("UnifiedSize","{{0,340.000000},{0.000000,210.000000}");
		QuickLogin_modify_Frame:Hide();
	end
end
--===============================================
-- 关闭界面
--===============================================
function QuickLogin_Close_Clicked()
    this:Hide()
end