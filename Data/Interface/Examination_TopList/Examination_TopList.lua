
-- 金榜

local g_Examination_TopList_targetId = -1;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;
local HaveClicked = 0

local g_Examination_TopList_nType = 3

local g_Examination_TopList_Count = 10

local g_Examination_TopList_MyInfo = 0

local g_Examination_TopList_UnifiedPosition;

local g_Examination_TopList_RankImage = {
	[1] = "set:New_Keju image:New_Keju_No1",
	[2] = "set:New_Keju image:New_Keju_No2",
	[3] = "set:New_Keju image:New_Keju_No3",
}
local g_Examination_TopList_RankStr = {
	[4] = "#{KJYH_221013_54}",
	[5] = "#{KJYH_221013_55}",
	[6] = "#{KJYH_221013_56}",
	[7] = "#{KJYH_221013_57}",
	[8] = "#{KJYH_221013_58}",
	[9] = "#{KJYH_221013_59}",
	[10] = "#{KJYH_221013_60}",
}

function Examination_TopList_PreLoad()
	this:RegisterEvent("OPEN_EXAM_RANKINGLIST")	
	this:RegisterEvent("UPDATE_EXAM_RANKINGLIST")
	
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("ADJEST_UI_POS")
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")
end

function Examination_TopList_OnLoad()

	g_Examination_TopList_UnifiedPosition = Examination_TopList_Frame:GetProperty("UnifiedPosition");
	
end

function Examination_TopList_OnEvent(event)

	if ( event == "OPEN_EXAM_RANKINGLIST" ) then

		g_Examination_TopList_nType = tonumber(arg0)
		g_Examination_TopList_targetId = tonumber(arg1)
		objCared = DataPool:GetNPCIDByServerID(g_Examination_TopList_targetId);
		if objCared == -1 then
			return;
		end
		BeginCareObject_Exam_TopList(objCared)
			
		Examination_TopList_OnShown()
			
	elseif ( event == "UPDATE_EXAM_RANKINGLIST" ) then
			
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		
		if(tonumber(arg0) ~= objCared) then
			return
		end
		
		--如果和NPC的距离大于一定距离或犨被删除，自动关睜
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then			
			--取消关心
			Examination_TopList_OnClose()
		end
		
	elseif (event == "ADJEST_UI_POS" or event == "VIEW_RESOLUTION_CHANGED") then
		Examination_TopList_Frame_On_ResetPos()
		
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		Examination_TopList_OnClose()
		
	end
end

function Examination_TopList_OnShown()

	Examination_TopList:Clear()
	g_Examination_TopList_MyInfo = 0
	--显示榜单
	for i = 1, g_Examination_TopList_Count do
		local bar = Examination_TopList:AddChild("Examination_TopList_Item")
		
		-- 名次
		bar:GetSubItem("Examination_TopList_Ranking"):Hide()
		bar:GetSubItem("Examination_TopList_RankingImage"):Hide()
		if g_Examination_TopList_RankImage[i] ~= nil then
			bar:GetSubItem("Examination_TopList_RankingImage"):Show()			
			bar:GetSubItem("Examination_TopList_RankingImage"):SetProperty("Image", g_Examination_TopList_RankImage[i])
		else
			bar:GetSubItem("Examination_TopList_Ranking"):Show()
			if g_Examination_TopList_RankStr[i] ~= nil then
				bar:GetSubItem("Examination_TopList_Ranking"):SetText(g_Examination_TopList_RankStr[i])
			else
				bar:GetSubItem("Examination_TopList_Ranking"):SetText(""..i)
			end
		end
		
		-- 袪名
		bar:GetSubItem("Examination_TopList_Name"):SetText("#{KJYH_221013_61}")	-- ????
		-- 答对数量
		bar:GetSubItem("Examination_TopList_Num"):SetText("#{KJYH_221013_62}")	-- ?		
		-- 答题时间
		bar:GetSubItem("Examination_TopList_Time"):SetText("#{KJYH_221013_62}")	-- ?
		
		-- 从排行榜取数据
		local nRank, nGuid, name, rightnum, usetime, getstate = DataPool:lua_GetExamRankingListInfo(g_Examination_TopList_nType, i-1);
		if nRank ~= nil and nRank >= 0 and nGuid > 0 then
			local str = ScriptGlobal_Format("#{KJYH_221013_125}", name)
			bar:GetSubItem("Examination_TopList_Name"):SetText(str)
			
			str = ScriptGlobal_Format("#{KJYH_221013_125}", rightnum)
			bar:GetSubItem("Examination_TopList_Num"):SetText(str)
			
			local timeShow = Examination_TopList_FormatTime(usetime)
			str = ScriptGlobal_Format("#{KJYH_221013_125}", timeShow)
			bar:GetSubItem("Examination_TopList_Time"):SetText(str)
			
			if Player:GetGUID() == nGuid then
				g_Examination_TopList_MyInfo = nRank + 1
			end
		end		
	end	
	
	Examination_TopList_My:Hide()
	local strlist = {"#{KJYH_221013_51}", "#{KJYH_221013_52}", "#{KJYH_221013_53}", 	-- ??/??/??
						"#{KJYH_221013_139}","#{KJYH_221013_139}","#{KJYH_221013_139}",	-- ??
						"#{KJYH_221013_139}","#{KJYH_221013_139}","#{KJYH_221013_139}","#{KJYH_221013_139}"}
	if g_Examination_TopList_MyInfo > 0 and strlist[g_Examination_TopList_MyInfo] ~= nil then
		Examination_TopList_My:Show()
		local str = ScriptGlobal_Format("#{KJYH_221013_99}", strlist[g_Examination_TopList_MyInfo])
		Examination_TopList_MyRanking:SetText(str)
	end
		
	this:Show()
	
end

function Examination_TopList_FormatTime(nSec)
	local showmin = math.floor(nSec/60)
	local showsec = math.mod(nSec,60)
	
	if showmin < 10 then
		return string.format("%02d:%02d", showmin, showsec)
	else
		return string.format("%d:%02d", showmin, showsec)
	end	
end

function Examination_TopList_OnMyGet()

	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("AskGetExamGift");
		Set_XSCRIPT_ScriptID(890038);
		Set_XSCRIPT_Parameter(0, g_Examination_TopList_targetId);
		Set_XSCRIPT_Parameter(1, g_Examination_TopList_MyInfo);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定犫个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Exam_TopList(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Examination");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Exam_TopList(objCaredId)
	this:CareObject(objCaredId, 0, "Examination");
	g_Object = -1;

end

function Examination_TopList_OnHidden()

	Examination_TopList_OnClose()
	
end

function Examination_TopList_OnClose()
	
	StopCareObject_Exam_TopList(objCared)
	this:Hide();
	
end

function Examination_TopList_OnHelp()
	
end

function Examination_TopList_Frame_On_ResetPos()

  Examination_TopList_Frame:SetProperty("UnifiedPosition", g_Examination_TopList_UnifiedPosition)
  
end

