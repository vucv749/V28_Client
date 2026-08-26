--GMÄÚ²¿¹¤¾ßµÚ¶þÌ×V2.0 Ñ©Îè±àÐ´ 
--Ñ©ÎèÖÆ×÷ ÓÊÏä£ºhnxq@foxmail.com 2022-05-26 

local g_GameTools2_Frame_UnifiedPosition;
local TargetID
function GameTools2_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED" ); -- ????
	this:RegisterEvent("MAINTARGET_CHANGED")
end

function GameTools2_OnLoad()
	g_GameTools2_Frame_UnifiedPosition=GameTools2_Frame:GetProperty("UnifiedPosition");
end

function GameTools2_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "202004272") then
		GameTools2_FenYe2:SetCheck(1)
		this:Show();
	elseif ( event == "MAINTARGET_CHANGED" ) then
		TargetID = tonumber(arg0)
	elseif (event == "ADJEST_UI_POS" ) then
		GameTools2_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools2_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

--Ôª±¦
function GameTools2_BOSS(index)
    local nID 		= GameTools2_BOSS1Edix:GetText() --??ID
	local nBAI		= GameTools2_BOSS2Edix:GetText() --??AI
	local nEAI 		= GameTools2_BOSS3Edix:GetText() --??AI
	local nScriptID = GameTools2_BOSS4Edix:GetText() --??
	if nID == nil then 
		PushDebugMessage("Thïnh ðßa vào chính xác Ðích quái v§t ID!")
	end
	if nBAI == nil then
		nBAI = 0
	end
	if nEAI == nil then
		nEAI = 0
	end
	if nScriptID == nil then
		nScriptID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,25); 
		Set_XSCRIPT_Parameter(1,tonumber(index));
		Set_XSCRIPT_Parameter(2,tonumber(nID)); 
		Set_XSCRIPT_Parameter(3,tonumber(nBAI));
		Set_XSCRIPT_Parameter(4,tonumber(nEAI));
		Set_XSCRIPT_Parameter(5,tonumber(nScriptID));
		Set_XSCRIPT_ParamCount(6);
    Send_XSCRIPT();	
end



--ÎäÑ§ÐÄµÃ
function GameTools2_XinDe(index) 
    local nNum = GameTools2_XinDeEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,28);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end



--ÆõÁéÖµ
function GameTools2_QiLing(index) 
    local nNum = GameTools2_QiLingEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,30);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--¹¦Ñ«Öµ
function GameTools2_GongXun(index) 
    local nNum = GameTools2_GongXunEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,31);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

-- ¶É±Ä¿±ê
function GameTools2_ZhanSha(index) 
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,32);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,0);
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--²éÑ¯ºÍÉèÖÃGetMissionDataµÄÖµ [Ìí¼ÓÊ±¼ä£º2022-7-19 23:49:00 XUEWU-QQ784055837]
function GameTools2_GetMissionData(index) 
	local nNum = GameTools2_GetMissionDataEdix:GetText() --????
	local SetValue = GameTools2_GetMissionData2Edix:GetText() --???????
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	--Ö»ÏÔÊ¾¿Í»§¶ËµÄÖµ£¨ÌØÊâ×÷ÓÃ£© Ç°ÃæÊäÈë99999£¬ºóÃæÊäÈëÄãÒª²éÑ¯µÄ¿Í»§¶ËµÄÖµ¾Í¿ÉÒÔÏÔÊ¾ÁË¡£
	if nNum == 99999 and SetValue ~= nil  then 
		DataValue = DataPool:GetPlayerMission_DataRound(tonumber(SetValue))
		PushDebugMessage("DataPool: GetPlayerMission_DataRound hµ khách Ðoan Tr¸:"..DataValue)
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("Thïnh ði«n c¥n tu¥n tra Ðích lßþng biªn ð±i ID.")
	end
	if  index == 1 then
		SetValue = 0
	end
	
	if	index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("Ngß¶i thÑ nh¤t Hoà ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không, Thïnh ði«n ð¥y ðü H§u m¾i có th¬ sØa chæa Nga!")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("Thïnh ðßa vào mu¯n sØa chæa giá tr¸, ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không!")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("Thïnh ðßa vào Yêu sØa chæa Ðích lßþng biªn ð±i ID, ngß¶i thÑ nh¤t biên t§p Khuông nµi dung Vi Không!")
		return
	end
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ tu¥n tra møc tiêu ngß¶i ch½i Ðích GetMissionDataTr¸!")
		elseif index == 2 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ thiªt trí møc tiêu ngß¶i ch½i Ðích GetMissionDataTr¸!")
		end
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,33);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --?????
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--²éÑ¯ºÍÉèÖÃGetMissionDataExµÄÖµ [Ìí¼ÓÊ±¼ä£º2022-7-19 23:49:00 XUEWU-QQ784055837]
function GameTools2_GetMissionDataEx(index) 
	local nNum = GameTools2_GetMissionDataExEdix:GetText() --????
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	local SetValue = GameTools2_GetMissionDataEx2Edix:GetText() --???????
	if  index == 1 then
		SetValue = 0
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("Thïnh ði«n c¥n tu¥n tra Ðích lßþng biªn ð±i ID.")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("Ngß¶i thÑ nh¤t Hoà ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không, Thïnh ði«n ð¥y ðü H§u m¾i có th¬ sØa chæa Nga!")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("Thïnh ðßa vào mu¯n sØa chæa giá tr¸, ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không!")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("Thïnh ðßa vào Yêu sØa chæa Ðích lßþng biªn ð±i ID, ngß¶i thÑ nh¤t biên t§p Khuông nµi dung Vi Không!")
		return
	end	

	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ tu¥n tra møc tiêu ngß¶i ch½i Ðích GetMissionDataExTr¸!")
		elseif index == 2 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ thiªt trí møc tiêu ngß¶i ch½i Ðích GetMissionDataExTr¸!")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,34);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --?????
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--²éÑ¯ºÍÉèÖÃGetMissionFlagµÄÖµ [Ìí¼ÓÊ±¼ä£º2022-7-20 15:43:08 XUEWU]
function GameTools2_GetMissionFlag(index) 
	local nNum = GameTools2_GetMissionFlagEdix:GetText() --????
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	local SetValue = GameTools2_GetMissionFlag2Edix:GetText() --???????

	if  index == 1 then
		SetValue = 0
	end
	
	if  SetValue ~= 1 and SetValue ~= 0 then
		PushDebugMessage("Thiªt trí giá tr¸ chï có th¬ Th¸ 0ho£c là 1.")
		return
	end
	
	if  index == 1 and nNum == nil then
		PushDebugMessage("Thïnh ði«n c¥n tu¥n tra Ðích lßþng biªn ð±i ID.")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("Ngß¶i thÑ nh¤t Hoà ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không, Thïnh ði«n ð¥y ðü H§u m¾i có th¬ sØa chæa Nga!")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("Thïnh ðßa vào mu¯n sØa chæa giá tr¸, ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không!")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("Thïnh ðßa vào Yêu sØa chæa Ðích lßþng biªn ð±i ID, ngß¶i thÑ nh¤t biên t§p Khuông nµi dung Vi Không!")
		return
	end	

	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ tu¥n tra møc tiêu ngß¶i ch½i Ðích GetMissionFlagTr¸!")
		elseif index == 2 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ thiªt trí møc tiêu ngß¶i ch½i Ðích GetMissionFlagTr¸!")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,35);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --?????
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--²éÑ¯ºÍÉèÖÃLuaFnGetWorldGlobalDataµÄÖµ [Ìí¼ÓÊ±¼ä£º2022-7-20 15:43:08 XUEWU]
function GameTools2_GetWorldGlobalData(index) 
	local nNum = GameTools2_GetWorldGlobalDataEdix:GetText() --????
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	local SetValue = GameTools2_GetWorldGlobalData2Edix:GetText() --???????
	if  index == 1 then
		SetValue = 0
	end
	if  index == 1 and nNum == nil then
		PushDebugMessage("Thïnh ði«n c¥n tu¥n tra Ðích lßþng biªn ð±i ID.")
		return
	end
	if  index == 2 and SetValue == nil and nNum == nil then
		PushDebugMessage("Ngß¶i thÑ nh¤t Hoà ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không, Thïnh ði«n ð¥y ðü H§u m¾i có th¬ sØa chæa Nga!")
		return
	elseif index == 2 and SetValue == nil then
		PushDebugMessage("Thïnh ðßa vào mu¯n sØa chæa giá tr¸, ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không!")
		return
	elseif index == 2 and nNum == nil then
		PushDebugMessage("Thïnh ðßa vào Yêu sØa chæa Ðích lßþng biªn ð±i ID, ngß¶i thÑ nh¤t biên t§p Khuông nµi dung Vi Không!")
		return
	end	
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ tu¥n tra møc tiêu ngß¶i ch½i Ðích GetWorldGlobalDataTr¸!")
		elseif index == 2 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ thiªt trí møc tiêu ngß¶i ch½i Ðích GetWorldGlobalDataTr¸!")
		end
		TargetID = 0
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,36);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue)); --?????
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end



--ÎäÒâµÈ¼¶
function GameTools2_WuYiLevel(index)
    local nNum = GameTools2_WuYiLevelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,38);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--ÎäÒâÉ±¹Ö
function GameTools2_WuYiShaGuai(index)
    local nNum = GameTools2_WuYiShaGuaiEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,39);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--ÎäÒâË«±¶
function GameTools2_WuYiSB(index)
    local nNum = GameTools2_WuYiSBEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,40);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--ÅàÔªµã
function GameTools2_WuYiPY(index)
    local nNum = GameTools2_WuYiPYEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,41);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--Éñ¶¦Ò©³¾
function GameTools2_ZiNvLevel(index)
    local nNum = GameTools2_ZiNvLevelEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,42);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--×ÓÅ®¾­Ñé
function GameTools2_ZiNvJY(index)
    local nNum = GameTools2_ZiNvJYEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,43);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end

--Éñ¹¤Öµ
function GameTools2_CZD(index)
    local nNum = GameTools2_CZDEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	if TargetID == nil then
		PushDebugMessage("Nªu cho vay C¤p ngß¶i ch½i, Thïnh Tiên lña ch÷n ð¥u cüa h¡n Tßþng!")
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,44);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_ParamCount(4);
    Send_XSCRIPT();	
end



function GameTools2_Frame_On_ResetPos()
	GameTools2_Frame:SetProperty("UnifiedPosition", g_GameTools2_Frame_UnifiedPosition);
end

--TAB½çÃæÇÐ»»
function GameTools2_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		return
		-- nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		nUI = 202004275
	elseif 6 == nIndex then
		nUI = 202004276
	elseif 7 == nIndex then
		nUI = 316022021
	end
	if nUI ~= 0 then
		PushEvent("UI_COMMAND", nUI)
		this:Hide();
	end
end

--²éÑ¯ºÍÉèÖÃGetMissionFlagExµÄÖµ
function GameTools2_GetMissionFlagEx(index) 
	local nNum = GameTools2_GetMissionFlagExEdix:GetText()
	if nNum == nil or nNum == "" then
		PushDebugMessage("Thïnh Tiên ðßa vào s¯ li®u, Tái ch¤p hành thao tác")
		return
	end
	local SetValue = GameTools2_GetMissionFlagEx2Edix:GetText()
	if  index == 1 then
		SetValue = 0
	end
	if  index == 2 and SetValue ~= "1" and SetValue ~= "0" then
		PushDebugMessage("Thiªt trí giá tr¸ chï có th¬ Th¸ 0ho£c là 1.")
		return
	end
	if  index == 2 and (SetValue == nil or SetValue == "") then
		PushDebugMessage("Thïnh ðßa vào mu¯n sØa chæa giá tr¸, ngß¶i thÑ hai biên t§p Khuông nµi dung Vi Không!")
		return
	end
	if TargetID == nil then
		if index == 1 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ tu¥n tra møc tiêu ngß¶i ch½i Ðích GetMissionFlagExTr¸!")
		elseif index == 2 then 
			PushDebugMessage("Thïnh Tiên lña ch÷n møc tiêu hình cái ð¥u, m¾i có th¬ thiªt trí møc tiêu ngß¶i ch½i Ðích GetMissionFlagExTr¸!")
		end
		TargetID = 0
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,46);
		Set_XSCRIPT_Parameter(1,index);
		Set_XSCRIPT_Parameter(2,tonumber(nNum));
		Set_XSCRIPT_Parameter(3,TargetID);
		Set_XSCRIPT_Parameter(4,tonumber(SetValue));
		Set_XSCRIPT_ParamCount(5);
    Send_XSCRIPT();	
end

--·¢ËÍ¹«¸æ
function GameTools2_GongGao()
	local msg = GameTools2_GongGaoEdix:GetText()
	if msg == nil or msg == "" then
		PushDebugMessage("Thïnh ðßa vào thông cáo nµi dung!")
		return
	end
	-- Clear_XSCRIPT();
		-- Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		-- Set_XSCRIPT_ScriptID(666666);
		-- Set_XSCRIPT_Parameter(0,47);
		-- Set_XSCRIPT_Parameter(1,1);
		-- Set_XSCRIPT_Parameter(2,0);
		-- Set_XSCRIPT_Parameter(3,0);
		-- Set_XSCRIPT_ParamCount(4);
		-- Set_XSCRIPT_String(0,msg);
    -- Send_XSCRIPT();	
	
	local text = GameTools2_GongGaoEdix:GetText()
	Talk:SendChatMessage("near", 
		string.format("&SYSDATA&,%s,%s,%s",
			("666666"),
			("AddGlobalCountNews"),
			(text)
			)
		);
		
end


--½âÉ¢°ï»á(ÊäÈëGuildID)
function GameTools2_DisbandGuild()
	local nGuildID = GameTools2_DisbandGuildEdix:GetText()
	if nGuildID == nil or nGuildID == "" then
		PushDebugMessage("Thïnh ðßa vào Yêu giäi tán Ðích bang hµi ID!")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("GMToolTypeTwo");
		Set_XSCRIPT_ScriptID(666666);
		Set_XSCRIPT_Parameter(0,48);
		Set_XSCRIPT_Parameter(1,1);
		Set_XSCRIPT_Parameter(2,tonumber(nGuildID));
		Set_XSCRIPT_Parameter(3,0);
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
end
