--·òÆÞÖÜ³£ÈÎÎñ½çÃæ
local g_Frame_UnifiedPosition = nil
local g_ExeScript = 998293
local g_UICOMMAND = 99829301
local g_curMissionIndex = 0

local g_UI_Items = {}

local g_CurPage = 0

local g_MissionIndexs = {
    [1] = 0,[2] = 0,[3] = 0,[4] = 0,
}

local g_Mission1SubInfo = {
    [1] = {path = {cliectScene=2,x=191,z=131,npc="Thiên S½n Muµi Muµi"},gotoText = "#{FQZC_230331_45}"},
    [2] = {path = {cliectScene=260,x=65,z=164,npc="Thß½ng Lan"},gotoText = "#{FQZC_230331_45}"},
    [3] = {path = {cliectScene=592,x=225,z=149,npc="Hoa Chiªu ThuÖ"},gotoText = "#{FQZC_230331_45}"},
    [4] = {path = {cliectScene=4,x=158,z=190,npc="Giang Tß Tuy«n"},gotoText = "#{FQZC_230331_45}"},
    [5] = {path = {cliectScene=164,x=271,z=175,npc="Tri«u Ðoan L­"},gotoText = "#{FQZC_230331_45}"},
}

local g_MissionInfo = {
    [1] = {title="#{FQZC_230331_37}"},
    [2] = {title="#{FQZC_230331_38}",path = {cliectScene=164,x=79,z=45,npc="Lång Ch¤n"}},
    [3] = {title="#{FQZC_230331_39}",path = {cliectScene=1,x=170,z=134,npc="Tô Ðào"}},
    [4] = {title="#{FQZC_230331_40}",path = {cliectScene=1,x=97,z=204,npc="Tô ThÑc"}},
    [5] = {title="#{FQZC_230331_41}",path = {cliectScene=0,x=40,z=60,npc="Hoa Tiên"}},
}

local g_Mission1BKImg = {
    [1] = "set:Xialv02 image:XiaLv_Zhouchang_Inage_Dali",
    [2] = "set:Xialv06 image:XiaLv_Zhouchang_Inage_Shuhe",
    [3] = "set:Xialv03 image:XiaLv_Zhouchang_Inage_Mantuo",
    [4] = "set:Xialv05 image:XiaLv_Zhouchang_Inage_Taihu",
    [5] = "set:Xialv06 image:XiaLv_Zhouchang_Inage_Yexihu2",
}


function XiaLv_ZhouChang_CleanUp()
    for i = 1, 4 do
        g_MissionIndexs[i] = 0
    end
    g_curMissionIndex = 0
    g_CurPage = 0
end


function XiaLv_ZhouChang_PreLoad()
	this:RegisterEvent("UI_COMMAND", true)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
    this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
end

function XiaLv_ZhouChang_OnLoad()
    g_Frame_UnifiedPosition = XiaLv_ZhouChang_Frame:GetProperty("UnifiedPosition")
    g_UI_Items.OpenWin = XiaLv_ZhouChang_ClientOpen
    g_UI_Items.MissionWin = XiaLv_ZhouChang_AllClient
    g_UI_Items.AwardActionBtn = XiaLv_ZhouChang_AwardItem
    g_UI_Items.AwardAvailable = XiaLv_ZhouChang_AwardItem_Animate
    g_UI_Items.AwardGot = XiaLv_ZhouChang_AwardItem_OK
    g_UI_Items.MissionCheck = {}
    for i = 1, 3 do
        g_UI_Items.MissionCheck[i] = _G["XiaLv_ZhouChang_Index"..i-1]
    end
    g_UI_Items.MissionCliect = {}
    for i = 1, 5 do
        g_UI_Items.MissionCliect[i] = {
            frame = _G["XiaLv_ZhouChang_Client"..i],
            infoText = _G[string.format( "XiaLv_ZhouChang_Info%dText1",i )],
            gotoBtn = _G[string.format( "XiaLv_ZhouChang_Task%dBtnGo",i )],
            doneImg = _G[string.format( "XiaLv_ZhouChang_Task%dImage",i )],
            doneText = _G[string.format( "XiaLv_ZhouChang_Info%dText2",i )]
        }
    end
end

function XiaLv_ZhouChang_OnEvent(event)
    if event == "UI_COMMAND" and tonumber(arg0) == g_UICOMMAND then
		local nOpt = Get_XParam_INT(0)
        if nOpt == 1 then
            XiaLv_ZhouChang_CleanUp()
            --´ò¿ªÐèÒªË¢ÐÂ½çÃæ
            XiaLv_ZhouChang_ShowOpenWin()
        elseif nOpt == 2 then
            XiaLv_ZhouChang_CleanUp()
            local showIndex = Get_XParam_INT(1)
            g_MissionIndexs[1] =  Get_XParam_INT(2)
            g_MissionIndexs[2] =  Get_XParam_INT(3)
            g_MissionIndexs[3] =  Get_XParam_INT(4)
            g_MissionIndexs[4] =  Get_XParam_INT(5)
            local curMissionDone = Get_XParam_INT(6)
            local comNum = Get_XParam_INT(7)
            local haveGotAward = Get_XParam_INT(8)
            XiaLv_ZhouChang_ShowMissionWin(showIndex,curMissionDone,comNum,haveGotAward)
        elseif nOpt == 3 then
            XiaLv_ZhouChang_OnClose()
        end
			

	elseif event == "VIEW_RESOLUTION_CHANGED" or event=="ADJEST_UI_POS" then
        XiaLv_ZhouChang_On_ResetPos()
    elseif event == "HIDE_ON_SCENE_TRANSED" then
		XiaLv_ZhouChang_OnClose()


	end

end
function XiaLv_ZhouChang_ShowOpenWin()
    this:Hide()
    g_UI_Items.OpenWin:Show()
    g_UI_Items.MissionWin:Hide()
    g_UI_Items.AwardActionBtn :Hide()
    g_UI_Items.AwardAvailable :Hide()
    g_UI_Items.AwardGot :Hide()
    this:Show()
end

function XiaLv_ZhouChang_TabClicked(index)
    if index < 1 or index >3 then
        return 
    end
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OpenUISub")
    Set_XSCRIPT_ScriptID(g_ExeScript)
    Set_XSCRIPT_Parameter(0,index)
	Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end


function XiaLv_ZhouChang_ShowMissionWin(index,curMissionDone,comNum,haveGotAward)
    this:Hide()
    g_UI_Items.OpenWin:Hide()
    g_UI_Items.MissionWin:Show()
    g_UI_Items.AwardActionBtn :Show()
    g_UI_Items.AwardAvailable :Hide()
    g_UI_Items.AwardGot :Hide()
    if index < 1 or index > 3 then
        return 
    end
    g_CurPage = index
    --µ±Ç°´ò¿ªÒ³ÃæµÄmissionindex 1~5
    local missionIndex = g_MissionIndexs[index]
    if missionIndex < 1 or missionIndex > 5 then
        return 
    end
    g_curMissionIndex = missionIndex
    local curPage = g_UI_Items.MissionCliect[g_curMissionIndex]
    if not curPage then
        return 
    end
    for i = 1, 5 do
        if i==g_curMissionIndex then
            g_UI_Items.MissionCliect[i].frame:Show()
        else
            g_UI_Items.MissionCliect[i].frame:Hide()
        end
    end
    
    -- if g_curMissionIndex == 1 then
    --     local Mission1SubIndex = g_MissionIndexs[4]
    --     if g_Mission1SubInfo[Mission1SubIndex] then
    --         curPage.gotoBtn:SetText(g_Mission1SubInfo[Mission1SubIndex].gotoText)
    --     end
    -- end
    if g_curMissionIndex == 1 then
        local Mission1SubIndex = g_MissionIndexs[4]
        if g_Mission1BKImg[Mission1SubIndex] then
            XiaLv_ZhouChang_Client1:SetProperty("Image",g_Mission1BKImg[Mission1SubIndex] )
        end
    end
    for i = 1, 3 do
        local k = g_MissionIndexs[i]
        if g_MissionInfo[k] then
            g_UI_Items.MissionCheck[i]:SetText(g_MissionInfo[k].title)
        end
    end
    if g_curMissionIndex > 0 then
        if curMissionDone > 0 then
            curPage.doneImg:Show()
            curPage.doneText:Show()
            curPage.gotoBtn:Hide()
        else
            curPage.doneImg:Hide()
            curPage.doneText:Hide()
            curPage.gotoBtn:Show()
        end
    end

    local theAction = DataPool:CreateBindActionItemForShow(38002826,1)
    if theAction:GetID() ~= 0 then
        g_UI_Items.AwardActionBtn:SetActionItem(theAction:GetID())
    end

    if haveGotAward == 1 then
        g_UI_Items.AwardGot :Show()
    elseif comNum >= 3 then
        g_UI_Items.AwardAvailable :Show()
    end

    for i = 1, 3 do
        if i==index then
            g_UI_Items.MissionCheck[i]:SetCheck(1)
        else
            g_UI_Items.MissionCheck[i]:SetCheck(0)
        end
    end

    this:Show()
end

function XiaLv_ZhouChang_OpenThisWeekMission()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("OnOpenThisWeekMission")
    Set_XSCRIPT_ScriptID(g_ExeScript)
	Set_XSCRIPT_ParamCount(0)
    Send_XSCRIPT()
end


function XiaLv_ZhouChang_OnGotoBtnClicked()
    if g_curMissionIndex < 1 or g_curMissionIndex > 5 then
        return 
    end
    local info = g_MissionInfo
    local index = g_curMissionIndex
    if g_curMissionIndex == 1 then
        info = g_Mission1SubInfo
        index = g_MissionIndexs[4]
    end
    local path = info[index].path
    AutoRuntoTargetExWithName(path.x, path.z, path.cliectScene, path.npc)
end

function XiaLv_ZhouChang_OnAwardCliecked()
    Clear_XSCRIPT()
    Set_XSCRIPT_Function_Name("GetWeekAward")
    Set_XSCRIPT_ScriptID(g_ExeScript)
    Set_XSCRIPT_Parameter(0,g_CurPage)
	Set_XSCRIPT_ParamCount(1)
    Send_XSCRIPT()
end







function XiaLv_ZhouChang_On_ResetPos()
    if (this:IsVisible()) then
        if (g_Frame_UnifiedPosition ~= nil) then
            XiaLv_ZhouChang_Frame:SetProperty("UnifiedPosition", g_Frame_UnifiedPosition)
        end
    end
end



function XiaLv_ZhouChang_OnClose()
    this:Hide()
end

function XiaLv_ZhouChang_HelpClicked()
    PushEvent("QUEST_HELPINFO", "#{FQZC_230331_294}")
end
