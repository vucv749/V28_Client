--任务四：诗情意
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 998291
local g_UICOMMAND = 99829101

local g_UI_Items = {}
local g_UI_Player1Index = 1
local g_UI_Player2Index = 2
local g_GameTime = 300
local g_GameData = {
    myPanel = 0,
    otherPanel = 0,
    --游戏的关卡号 每次随机一个关卡
    gameLevelIndex = 0,
    gameResult = 0,
    chooseItemsData = {},
    myChoose = {[1]={},[2]={}},
    otherChoose = {[1]={},[2]={}},
    dontNotifyClose = 0,
    otherServerObjId = 0,
}
local g_GameLevel = {
    [1] = {
        texts = {"#{FQZC_230331_236}","#{FQZC_230331_237}","#{FQZC_230331_238}","#{FQZC_230331_239}"},
        
    },
    [2] = {
        texts = {"#{FQZC_230331_240}","#{FQZC_230331_241}","#{FQZC_230331_242}","#{FQZC_230331_243}"},
        
    },
    [3] = {
        texts = {"#{FQZC_230331_244}","#{FQZC_230331_245}","#{FQZC_230331_246}","#{FQZC_230331_247}"},
        
    },
    [4] = {
        texts = {"#{FQZC_230331_248}","#{FQZC_230331_249}","#{FQZC_230331_250}","#{FQZC_230331_251}"},
       
    },
    [5] = {
        texts = {"#{FQZC_230331_252}","#{FQZC_230331_253}","#{FQZC_230331_254}","#{FQZC_230331_255}"},
       
    },
    [6] = {
        texts = {"#{FQZC_230331_256}","#{FQZC_230331_257}","#{FQZC_230331_258}","#{FQZC_230331_259}"},
       
    },
    [7] = {
        texts = {"#{FQZC_230331_260}","#{FQZC_230331_261}","#{FQZC_230331_262}","#{FQZC_230331_263}"},
        
    },
    [8] = {
        texts = {"#{FQZC_230331_264}","#{FQZC_230331_265}","#{FQZC_230331_266}","#{FQZC_230331_267}"},
        
    },
    [9] = {
        texts = {"#{FQZC_230331_268}","#{FQZC_230331_269}","#{FQZC_230331_270}","#{FQZC_230331_271}"},
       
    },
    [10] = {
        texts = {"#{FQZC_230331_272}","#{FQZC_230331_273}","#{FQZC_230331_274}","#{FQZC_230331_275}"},
        
    },
    [11] = {
        texts = {"#{FQZC_230331_276}","#{FQZC_230331_277}","#{FQZC_230331_278}","#{FQZC_230331_279}"},
        
    },
    [12] = {
        texts = {"#{FQZC_230331_280}","#{FQZC_230331_281}","#{FQZC_230331_282}","#{FQZC_230331_283}"},
    },
}


function XiaLv_Task4_CleanUp()
    g_GameData.myPanel = 0
    g_GameData.otherPanel = 0
    g_GameData.gameLevelIndex = 0
    g_GameData.gameResult = 0
    g_GameData.chooseItemsData = {}
    for i = 1, 2 do
        g_GameData.myChoose[i] = {}
        g_GameData.otherChoose[i] = {}
    end
    g_GameData.dontNotifyClose = 0
    g_GameData.otherServerObjId = 0
end


function XiaLv_Task4_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function XiaLv_Task4_OnLoad()
    g_Frame_UnifiedPosition = XiaLv_Task4_Frame:GetProperty("UnifiedPosition")
    g_UI_Items.Watch = XiaLv_Task4_Time
    g_UI_Items.ResultImg = XiaLv_Task4_State
    g_UI_Items.Panel = {}
    for i = 1, g_UI_Player2Index do
        g_UI_Items.Panel[i] = {}
        g_UI_Items.Panel[i].CoverWin = _G[string.format( "XiaLv_Task4_Play%dBK2",i)]
        g_UI_Items.Panel[i].CoverImg = _G[string.format( "XiaLv_Task4_Play%d_Image",i)]
        g_UI_Items.Panel[i].ChooseBtnWin =  _G[string.format( "XiaLv_Task4_Play%dAllBtn",i)]
        g_UI_Items.Panel[i].ChooseBtns = {}
        for j = 1, 6 do
            g_UI_Items.Panel[i].ChooseBtns[j] = _G[string.format( "XiaLv_Task4_Play%dBtn%d",i,j)]
        end
        g_UI_Items.Panel[i].SpaceItems = {}
        for j = 1, 2 do
            g_UI_Items.Panel[i].SpaceItems[j] =  _G[string.format( "XiaLv_Task4_Play%d_Text%d",i,j)]
        end
        g_UI_Items.Panel[i].resetBtn = _G[string.format( "XiaLv_Task4_Play%dBtnF5",i)]
        g_UI_Items.Panel[i].OkBtn = _G[string.format( "XiaLv_Task4_Play%dBtnOK",i)]
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
    if g_GameData.gameLevelIndex < 1 or g_GameData.gameLevelIndex > table.getn(g_GameLevel) then
        return false
    end
    return true
end

function XiaLv_Task4_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		local nOpt = Get_XParam_INT(0)
        if nOpt == 1 then
            XiaLv_Task4_CleanUp()

            g_GameData.myPanel = Get_XParam_INT(1)
            g_GameData.otherPanel = 3 - g_GameData.myPanel
            g_GameData.gameLevelIndex = Get_XParam_INT(2)
            g_GameData.otherServerObjId =  Get_XParam_INT(3)
            if not CheckGameData() then
                PushDebugMessage("数据错误，请重新开始任务")
            end
            
            XiaLv_Task4_Begin()
        elseif nOpt == 2 then
            --打开对方的panel
            local data1, data2 = Get_XParam_INT(1),Get_XParam_INT(2)
            g_GameData.otherChoose[1][1] = math.floor(data1/100)
            g_GameData.otherChoose[1][2] = math.mod(data1,100)
            g_GameData.otherChoose[2][1] = math.floor(data2/100)
            g_GameData.otherChoose[2][2] = math.mod(data2,100)
            g_GameData.gameResult = Get_XParam_INT(3)
            XiaLv_Task4_ShowOthersAnswer()
        elseif nOpt == 3 then
            --关闭界面
            g_GameData.dontNotifyClose = 1
            XiaLv_Task4_OnClose()
        end
			

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        XiaLv_Task4_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaLv_Task4_OnClose()


	end

end
local function RandomXNum(min,max,n)
    local counts = max - min + 1
    if counts < 0 or counts < n then
        return nil
    end
     local rsList = {}
     local ret = {}
     for i = min, max  do 
         rsList[i] = i
     end 
     local tempindex
     for i=1, n do
         local j = math.random(i, counts)
         tempindex = rsList[i]
         rsList[i]=rsList[j]
         rsList[j]=tempindex
         ret[i] =  rsList[i]
     end
     return ret
end

local function RandomChoose()
    local myAnswerPairs = {}
    local maxLevel = table.getn(g_GameLevel)
    --我的选项中有哪两个答案
    if  g_GameData.myPanel == g_UI_Player1Index then
        myAnswerPairs[1] = {g_GameData.gameLevelIndex,1}--Gamelevel,textindex
        myAnswerPairs[2] = {g_GameData.gameLevelIndex,2}
    else
        myAnswerPairs[1] = {g_GameData.gameLevelIndex,3}
        myAnswerPairs[2] = {g_GameData.gameLevelIndex,4}
    end
    --先随机一组显示顺序
    local rdShow = RandomXNum(1,6,6)
    --随机一组其他答案的levelindex 为保证答案唯一 另外4个选项在不同的level里面各选一句
    local rdOther4 = RandomXNum(1,maxLevel,5)
    if not rdOther4 then
        rdOther4 = {1,2,3,4,5}
    end
    for i=1,4 do
        if rdOther4[i] == g_GameData.gameLevelIndex then
            rdOther4[i] = rdOther4[5]
        end
    end
    --前2个显示答案
    for i = 1, 2 do
        g_GameData.chooseItemsData[rdShow[i]] = myAnswerPairs[i]
    end

    --后4个随机选
    for i = 3, 6 do
        g_GameData.chooseItemsData[rdShow[i]] ={
            rdOther4[i-2],
            math.random(1,4)
        } 
    end
end 

function XiaLv_Task4_Begin()
    XiaLv_Task4_Frame:SetProperty("Alpha",1)
    g_UI_Items.Watch:SetProperty("Timer",g_GameTime)
    g_UI_Items.ResultImg:Hide()
    --先把另一半的区域挡住
    local otherPanelTable =   g_UI_Items.Panel[g_GameData.otherPanel]
    if otherPanelTable then
        otherPanelTable.CoverWin:Show()
        otherPanelTable.ChooseBtnWin:Hide()
        for j = 1, 2 do
            otherPanelTable.SpaceItems[j]:Hide()
        end
        otherPanelTable.resetBtn:Hide()
        otherPanelTable.OkBtn:Hide()
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if myPanelTable then
        myPanelTable.CoverWin:Hide()
        myPanelTable.ChooseBtnWin:Show()
        for j = 1, 2 do
            myPanelTable.SpaceItems[j]:Show()
        end
        myPanelTable.resetBtn:Show()
        myPanelTable.OkBtn:Show()
        --otherPanelTable.OkBtn:Disable()
        --随机选项
        RandomChoose()
        --展示选项
        for i = 1, 6 do
            local answerPair = g_GameData.chooseItemsData[i]
            myPanelTable.ChooseBtns[i]:SetText(g_GameLevel[answerPair[1]].texts[answerPair[2]])
        end
        --清理展示区
        for j = 1, 2 do
            myPanelTable.SpaceItems[j]:SetText("")
        end
        
    end


    this:Show()
end


--游戏时间结束
function XiaLv_Task4_TimeOut()
    if g_GameData.gameResult > 0 then
        return 
    end
    --给当前玩家随机填两个
    local rd = RandomXNum(1,6,2) 
    if not rd then
        rd = {1,2}
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    for i = 1, 2 do
        g_GameData.myChoose[i][1] = g_GameData.chooseItemsData[i][1]
        g_GameData.myChoose[i][2] = g_GameData.chooseItemsData[i][2]
        local answerPair = g_GameData.myChoose[i]
        if myPanelTable then
            myPanelTable.SpaceItems[i]:SetText(g_GameLevel[answerPair[1]].texts[answerPair[2]] )
        end
    end
    myPanelTable.OkBtn:Enable()

    XiaLv_Task4_OnOkBtnClicked()

    PushDebugMessage("#{FQZC_230331_148}")
end

function XiaLv_Task4_ShowOthersAnswer()
    local otherPanelTable =   g_UI_Items.Panel[g_GameData.otherPanel]
    if otherPanelTable then
        otherPanelTable.CoverWin:Hide()
        for j = 1, 2 do
            local answerPair = g_GameData.otherChoose[j]
            otherPanelTable.SpaceItems[j]:Show()
            otherPanelTable.SpaceItems[j]:SetText(g_GameLevel[answerPair[1]].texts[answerPair[2]] )
        end
    end
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if myPanelTable then
        myPanelTable.ChooseBtnWin:Hide()
        myPanelTable.resetBtn:Hide()
        myPanelTable.OkBtn:Hide()
    end

    if  g_GameData.gameResult == 2 then
        g_UI_Items.ResultImg:SetProperty("Image","set:Xialv04 image:XiaLv_shiqingyiok1" )
        g_UI_Items.ResultImg:Show()
    else
        g_UI_Items.ResultImg:SetProperty("Image","set:Xialv04 image:XiaLv_shiqingyiok2" )
        g_UI_Items.ResultImg:Show()
    end
    PushDebugMessage("#{FQZC_230331_149}")
    PushDebugMessage("#{FQZC_230331_150}")

    XiaLv_Task4_FiveSecCloseUI()
    g_UI_Items.Watch:SetProperty("Timer",0)
end

function XiaLv_Task4_OnChooseWordClick(index)
    if index < 1 or index > 12 then
        return 
    end
    local myIndex = index
    if  index > 6  then
        myIndex = index-6
    end
    local fillIndex = 1
    if not g_GameData.myChoose[1][1] then
        fillIndex = 1
    elseif not g_GameData.myChoose[2][1] then
        fillIndex = 2
    else
       -- PushDebugMessage("满了")
        return 
    end
    g_GameData.myChoose[fillIndex][1] = g_GameData.chooseItemsData[myIndex][1]
    g_GameData.myChoose[fillIndex][2] = g_GameData.chooseItemsData[myIndex][2]
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel]
    if myPanelTable then
        local answerPair = g_GameData.myChoose[fillIndex]
        myPanelTable.SpaceItems[fillIndex]:SetText(g_GameLevel[answerPair[1]].texts[answerPair[2]] )
        if fillIndex == 2 then
            myPanelTable.OkBtn:Enable()
        end
    end
end
function XiaLv_Task4_OnResetClick()
    g_GameData.myChoose = {[1]={},[2]={}}
    local myPanelTable =   g_UI_Items.Panel[g_GameData.myPanel] 
    if myPanelTable then
        --myPanelTable.OkBtn:Disable()
        --清理展示区
        for j = 1, 2 do
            myPanelTable.SpaceItems[j]:SetText("" )
        end
    end
end

function XiaLv_Task4_OnOkBtnClicked()
    if  not g_GameData.myChoose[1][1] or not g_GameData.myChoose[2][1] then
        PushDebugMessage("#{FQZC_230331_145}")
        return 
    end
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnPlayerCompleted")
    Set_XSCRIPT_ScriptID(g_ExeScript)
    Set_XSCRIPT_Parameter(0,g_GameData.myChoose[1][1] * 100 + g_GameData.myChoose[1][2]);     
	Set_XSCRIPT_Parameter(1,g_GameData.myChoose[2][1] * 100 + g_GameData.myChoose[2][2]);  
	Set_XSCRIPT_ParamCount(2)
    Send_XSCRIPT()
end
function XiaLv_Task4_FadeOut()
    KillTimer("XiaLv_Task4_OnFiveSecCloseUI()")
end


function XiaLv_Task4_FiveSecCloseUI()
	KillTimer("XiaLv_Task4_OnFiveSecCloseUI()")
	SetTimer("XiaLv_Task4","XiaLv_Task4_OnFiveSecCloseUI()", 2500)
end

function XiaLv_Task4_OnFiveSecCloseUI()
    KillTimer("XiaLv_Task4_OnFiveSecCloseUI()")
    XiaLv_Task4_FadeDisappering()
end

function XiaLv_Task4_FadeDisappering()
	KillTimer("XiaLv_Task4_OnFadeDisappering()")
	XiaLv_Task4_Frame:Tween_SetInfo("Alpha", "curve:Liner mode:Once duration:2.5 startx:1 starty:0 endx:0 endy:0")
	XiaLv_Task4_Frame:Tween_Play("Alpha", true, true)
	SetTimer("XiaLv_Task4","XiaLv_Task4_OnFadeDisappering()", 2600)

end

function XiaLv_Task4_OnFadeDisappering()
	KillTimer("XiaLv_Task4_OnFadeDisappering()")
    g_GameData.dontNotifyClose = 1
	XiaLv_Task4_OnClose()
end



function XiaLv_Task4_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            XiaLv_Task4_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function XiaLv_Task4_OnClose()
    if  g_GameData.dontNotifyClose == 0 then
        g_GameData.dontNotifyClose = 1
        Clear_XSCRIPT()
        Set_XSCRIPT_ScriptID( g_ExeScript )
        Set_XSCRIPT_Function_Name( "NotifyClosed" )
        Set_XSCRIPT_Parameter(0,g_GameData.otherServerObjId);
        Set_XSCRIPT_ParamCount( 1 )
        Send_XSCRIPT()
    end
    XiaLv_Task4_Frame:Tween_Reset("Alpha",0)
	KillTimer("XiaLv_Task4_OnFiveSecCloseUI()")
    KillTimer("XiaLv_Task4_OnFadeDisappering()")
    this:Hide()
end