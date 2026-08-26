--»ŒŒÒŒÂ£∫»µ«≈œ…
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 998292
local g_UICOMMAND = 99829201

local g_UI_Items = {}
local g_UI_Player1Index = 1
local g_UI_Player2Index = 2
local g_TileNum = 16
local g_GameData = {
    myPanel = 0,
    otherPanel = 0,
    gameResult = 0,
    myAnswer = {},
    otherAnswer = {},
    myChoose = {[1]=0,[2]=0,[3]=0},
    otherChoose = {[1]=0,[2]=0,[3]=0},
    dontNotifyClose = 0,
    otherServerObjId = 0,
}
local g_TilePushedImg = {
    [g_UI_Player1Index] = "set:Xialv04 image:XiaLv_Queqiaoxian_blue",
    [g_UI_Player2Index] = "set:Xialv04 image:XiaLv_Queqiaoxian_red",
}


function XiaLv_Task5_CleanUp()
    g_GameData.myPanel = 0
    g_GameData.otherPanel = 0
    g_GameData.gameResult = 0
    g_GameData.otherAnswer= {}
    g_GameData.myAnswer= {}
    for i = 1, 3 do
        g_GameData.myChoose[i] = 0
        g_GameData.otherChoose[i] = 0
    end
    g_GameData.dontNotifyClose = 0
    g_GameData.otherServerObjId = 0

end


function XiaLv_Task5_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function XiaLv_Task5_OnLoad()
    g_Frame_UnifiedPosition = XiaLv_Task5_Frame:GetProperty("UnifiedPosition")
    g_UI_Items.ResultImg = XiaLv_Task5_State
    g_UI_Items.Panel = {}
    for i = 1, g_UI_Player2Index do
        g_UI_Items.Panel[i] = {}
        g_UI_Items.Panel[i].CoverWin = _G[string.format( "XiaLv_Task5_Play%dBK2",i)]
        g_UI_Items.Panel[i].CoverImg = _G[string.format( "XiaLv_Task5_Play%d_Image",i)]
        g_UI_Items.Panel[i].TipsText = _G[string.format( "XiaLv_Task5_Play%dText",i)]
        g_UI_Items.Panel[i].ChooseWin = _G[string.format( "XiaLv_Task5_Play%dInfo",i)]
        g_UI_Items.Panel[i].ChooseBtn ={}
        for j = 1, g_TileNum do
            g_UI_Items.Panel[i].ChooseBtn[j] = _G[string.format( "XiaLv_Task5_Play%d_Jigsaw%d",i,j)]
        end
        g_UI_Items.Panel[i].OkBtn = _G[string.format( "XiaLv_Task5_Play%dBtnOK",i)]
    end

end

local function CheckGameData()
    if g_GameData.myPanel < g_UI_Player1Index or g_GameData.myPanel > g_UI_Player2Index then
        return false
    end
    if g_GameData.otherPanel < g_UI_Player1Index or g_GameData.otherPanel > g_UI_Player2Index then
        return false
    end
    if g_GameData.myPanel == g_GameData.otherPanel then
        return false
    end
    return true
end

function XiaLv_Task5_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		local nOpt = Get_XParam_INT(0)
        if nOpt == 1 then
            
            XiaLv_Task5_CleanUp()

            g_GameData.myPanel = Get_XParam_INT(1)
            g_GameData.otherPanel = 3 - g_GameData.myPanel
            local myAnswer = Get_XParam_INT(2)
            local otherAnswer = Get_XParam_INT(3)
            g_GameData.otherServerObjId = Get_XParam_INT(4)
            for i = 1, 3 do
                g_GameData.myAnswer[math.mod(myAnswer,100)] = 1
                g_GameData.otherAnswer[math.mod(otherAnswer,100)] = 1
                otherAnswer = math.floor(otherAnswer/100)
                myAnswer = math.floor(myAnswer/100)
            end
            if not CheckGameData() then
                PushDebugMessage("SØ liÆu sai l•m, ThÔnh mµt l•n nÊa b°t •u nhiÆm v¯")
                return 
            end

            XiaLv_Task5_Begin()
        elseif nOpt == 2 then
            --¥Úø™∂‘∑Ωµƒpanel
            local otherChooseData = Get_XParam_INT(1)
            local gameResult =  Get_XParam_INT(2)
            for i = 1, 3 do
                g_GameData.otherChoose[i] = math.mod(otherChooseData,100)
                otherChooseData = math.floor( otherChooseData / 100 )
            end
            g_GameData.gameResult = gameResult
            XiaLv_Task5_ShowOthersAnswer()
        elseif nOpt == 3 then
            g_GameData.dontNotifyClose = 1
            XiaLv_Task5_OnClose()
        end
			

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        XiaLv_Task5_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaLv_Task5_OnClose()


	end

end
function XiaLv_Task5_Begin()
    XiaLv_Task5_Frame:SetProperty("Alpha",1)
    g_UI_Items.ResultImg:Hide()
    local othersAnswerSort = {0,0,0}
    --œ»∞—¡Ì“ª∞Îµƒ«¯”Úµ≤◊°
    local otherPanelTable =   g_UI_Items.Panel[g_GameData.otherPanel]
    if otherPanelTable then
        otherPanelTable.CoverWin:Show()
        otherPanelTable.TipsText:Hide()
        otherPanelTable.ChooseWin:Hide()
        otherPanelTable.OkBtn:Hide()
        --…Ë÷√∂‘∑Ωµƒ…®¿◊ ˝æ›
        local othersAnswerIndex = 1
        for i = 1, g_TileNum do
            otherPanelTable.ChooseBtn[i]:Enable()
            otherPanelTable.ChooseBtn[i]:SetCheck(0)
            if g_GameData.otherAnswer[i] == 1 then
                otherPanelTable.ChooseBtn[i]:SetProperty("PushedImage",g_TilePushedImg[g_GameData.otherPanel])
                othersAnswerSort[othersAnswerIndex] = i
                othersAnswerIndex = othersAnswerIndex + 1
            else
                otherPanelTable.ChooseBtn[i]:SetProperty("PushedImage","set:Xialv04 image:XiaLv_Queqiaoxian_wrong")
            end
        end
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if myPanelTable then
        myPanelTable.CoverWin:Hide()
        myPanelTable.TipsText:Show()
        myPanelTable.ChooseWin:Show()
        myPanelTable.OkBtn:Show()

        --†π æ∂‘∑Ωµƒ¥∞∏
        myPanelTable.TipsText:SetText(ScriptGlobal_Format("#{FQZC_230331_227}",othersAnswerSort[1],othersAnswerSort[2],othersAnswerSort[3]))
        --…Ë÷√Œ“µƒ…®¿◊ ˝æ›
        for i = 1, g_TileNum do
            myPanelTable.ChooseBtn[i]:Enable()
            myPanelTable.ChooseBtn[i]:SetCheck(0)
            if g_GameData.myAnswer[i] == 1 then
                myPanelTable.ChooseBtn[i]:SetProperty("PushedImage",g_TilePushedImg[g_GameData.myPanel])
            else
                myPanelTable.ChooseBtn[i]:SetProperty("PushedImage","set:Xialv04 image:XiaLv_Queqiaoxian_wrong")
            end
        end
        
    end


    this:Show()
end


function XiaLv_Task5_ShowOthersAnswer()
    local otherPanelTable =   g_UI_Items.Panel[g_GameData.otherPanel]
    if otherPanelTable then
        otherPanelTable.CoverWin:Hide()
        otherPanelTable.ChooseWin:Show()
        for j = 1, 3 do
            local otherChoose = g_GameData.otherChoose[j]
            if otherChoose >=1 and otherChoose <= g_TileNum then
                otherPanelTable.ChooseBtn[otherChoose]:SetCheck(1)
            end
        end
        for i = 1, g_TileNum do
            if otherPanelTable.ChooseBtn[i]:GetCheck() == 0 then
                otherPanelTable.ChooseBtn[i]:Disable() 
            end
        end
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if myPanelTable then
        myPanelTable.OkBtn:Hide()
    end

    if  g_GameData.gameResult == 1 then

        g_UI_Items.ResultImg:SetProperty("Image","set:Xialv05 image:XiaLv_queqiaoxianhong")
        g_UI_Items.ResultImg:Show()
        XiaLv_Task5_EffectStart()
    else
        g_UI_Items.ResultImg:SetProperty("Image","set:Xialv05 image:XiaLv_queqiaoxianlan")
        g_UI_Items.ResultImg:Show()
    end
    PushDebugMessage("#{FQZC_230331_155}")
    PushDebugMessage("#{FQZC_230331_156}")
   
    XiaLv_Task5_FiveSecCloseUI()
end

function XiaLv_Task5_OnTileClicked(index)
    if not CheckGameData() then
        PushDebugMessage("SØ liÆu sai l•m, ThÔnh mµt l•n nÊa b°t •u nhiÆm v¯")
        return
    end
    if index <= (g_GameData.myPanel-1)*g_TileNum or index > g_TileNum*g_GameData.myPanel then
        return 
    end
    local myIndex = index
    if  index > g_TileNum  then
        myIndex = index-g_TileNum
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if not myPanelTable then
        return 
    end
    if myPanelTable.ChooseBtn[myIndex]:GetCheck() == 1 then
        return 
    end
    local fillIndex = 1
    if g_GameData.myChoose[1] == 0 then
        fillIndex = 1
    elseif g_GameData.myChoose[2] == 0 then
        fillIndex = 2
    elseif g_GameData.myChoose[3] == 0 then
        fillIndex = 3
    else
        PushDebugMessage("#{FQZC_230331_228}")
        return 
    end
    g_GameData.myChoose[fillIndex] = myIndex
    --myPanelTable.ChooseBtn[myIndex]:SetCheck(1)
    if fillIndex == 3 then
        for i = 1, g_TileNum do
            if myPanelTable.ChooseBtn[i]:GetCheck() == 0 then
                myPanelTable.ChooseBtn[i]:Disable() 
            end
        end
    end
end


function XiaLv_Task5_OnOkBtnClicked()
    if  g_GameData.myChoose[1] == 0 or g_GameData.myChoose[2] == 0 or g_GameData.myChoose[3] == 0  then
        PushDebugMessage("#{FQZC_230331_153}")
        return 
    end
    local rightNum = 0
    local result = 0
    for _,v in ipairs(g_GameData.myChoose) do
        if g_GameData.myAnswer[v] == 1 then
            rightNum = rightNum + 1
        end
    end
    if rightNum >= 3 then
        result = 1
    end
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnPlayerCompleted")
    Set_XSCRIPT_ScriptID(g_ExeScript)
    Set_XSCRIPT_Parameter(0,g_GameData.myChoose[1] * 10000 + g_GameData.myChoose[2]*100 + g_GameData.myChoose[3]); 
    Set_XSCRIPT_Parameter(1,result)    
	Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end



function XiaLv_Task5_FiveSecCloseUI()
	KillTimer("XiaLv_Task5_OnFiveSecCloseUI()")
	SetTimer("XiaLv_Task5","XiaLv_Task5_OnFiveSecCloseUI()", 2500)
end

function XiaLv_Task5_OnFiveSecCloseUI()
    KillTimer("XiaLv_Task5_OnFiveSecCloseUI()")
    XiaLv_Task5_FadeDisappering()
end



function XiaLv_Task5_EffectStart()
	KillTimer("XiaLv_Task5_EffectStop()")
	SetTimer("XiaLv_Task5","XiaLv_Task5_EffectStop()", 5000)
    Lua_SetMyWeather(34)
end

function XiaLv_Task5_EffectStop()
    KillTimer("XiaLv_Task5_EffectStop()")
    Lua_StopMyWeather(34)
end

function XiaLv_Task5_FadeDisappering()
	KillTimer("XiaLv_Task5_OnFadeDisappering()")
	XiaLv_Task5_Frame:Tween_SetInfo("Alpha", "curve:Liner mode:Once duration:2.5 startx:1 starty:0 endx:0 endy:0")
	XiaLv_Task5_Frame:Tween_Play("Alpha", true, true)
    SetTimer("XiaLv_Task5","XiaLv_Task5_OnFadeDisappering()", 2600)
end

function XiaLv_Task5_OnFadeDisappering()
	KillTimer("XiaLv_Task5_OnFadeDisappering()")
    g_GameData.dontNotifyClose = 1
	XiaLv_Task5_OnClose()
end


function XiaLv_Task5_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            XiaLv_Task5_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function XiaLv_Task5_OnClose()

    if  g_GameData.dontNotifyClose == 0 then
        g_GameData.dontNotifyClose = 1
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID( g_ExeScript )
        Set_XSCRIPT_Function_Name( "NotifyClosed" )
        Set_XSCRIPT_Parameter(0,g_GameData.otherServerObjId);
        Set_XSCRIPT_ParamCount( 1 )
        Send_XSCRIPT()
    end

    XiaLv_Task5_Frame:Tween_Reset("Alpha",0)
	KillTimer("XiaLv_Task5_OnFiveSecCloseUI()")
	KillTimer("XiaLv_Task5_OnFadeDisappering()")

    this:Hide()
end
