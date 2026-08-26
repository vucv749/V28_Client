local bBeingRadio = 0;
local MissionType = {};
local MissionPucker = {};
local Current_Select;
local First_Open = 1;
local MissionParam_Index = 0;
local k
local LEVEL_TO_MY_LEVEL = 10000;

local MissionOutlineDeploy = {}
local CurList      -- 1为任务列表,2为任务索引

local Current_Clicked = -1;
--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理,需要特殊处理的任务脚本号列表：
local SpecialMissionList = {200006,200031}

-- 界面的默认相对位置
local g_QuestLog_Frame_UnifiedXPosition;
local g_QuestLog_Frame_UnifiedYPosition;

function QuestLog_PreLoad()
	this:RegisterEvent("TOGLE_MISSION");
	this:RegisterEvent("UPDATE_MISSION");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_DOUBLE_EXP");
	this:RegisterEvent("UPDATE_QUESTTIME");
	this:RegisterEvent("NEW_MISSION");
	this:RegisterEvent("DELETE_MISSION");
	this:RegisterEvent("TOGLE_MISSION_OUTLINE");
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_FROM_MISSIONTRACK");
	this:RegisterEvent("UPDATE_QUESTLOG_BY_TRACK");
	this:RegisterEvent("UPDATE_TRACK_STATE_BUTTON");

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS")

	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")
end

function QuestLog_OnLoad()

	local i=1;
	for i=1,200 do
		MissionPucker[i] = 1;
	end;

	for i=1,200 do
	    MissionOutlineDeploy[ i ] = 1  --任务索引默认都为展开
	end

	First_Open = 1;
	CurList = 1

	-- 保存界面的默认相对位置
	g_QuestLog_Frame_UnifiedXPosition	= QuestLog_Frame : GetProperty("UnifiedXPosition");
	g_QuestLog_Frame_UnifiedYPosition	= QuestLog_Frame : GetProperty("UnifiedYPosition");

end

function QuestLog_OnEvent(event)
--	if(this:IsVisible()) then
--		QuestLog_OnShown();
--		return;
--	end

	--PushDebugMessage("event = " .. event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 831020) then
			QuestLog_UpdateListbox();
			QuestLog_UpdateMissionOutline();
			QuestLog_ShowWindow();
  end

	if(event == "TOGLE_MISSION" ) then
			QuestLog_UpdateListbox();
			QuestLog_ShowWindow();
	elseif(event == "TOGLE_MISSION_OUTLINE" ) then
			QuestLog_UpdateMissionOutline();
			QuestLog_ShowWindow();
	elseif(event == "UPDATE_MISSION" ) then
			if not this:IsVisible() then
				return;
			end
			if (CurList == 1) then
				QuestLog_UpdateListbox();
			end
	elseif(event == "PACKAGE_ITEM_CHANGED" ) then
			if not this:IsVisible() then
				return;
			end
			if CurList == 1 then
				QuestLog_UpdateListbox();
			end
	elseif(event == "UPDATE_DOUBLE_EXP" ) then
			local DT = SystemSetup : GetDoubleExp("remaintime");
			QuestLog_Watch:SetProperty("Timer",DT);
	elseif(event == "UPDATE_QUESTTIME") then
			if not this:IsVisible() then
				return;
			end

			if( 2 == CurList ) then
			    return    --这个消息是用来更新任务计时的,当当前选中项为任务索引时,则不应该进行更新.
			end

		if arg0 ~= nil and tonumber(arg0) <= 20 and tonumber(arg0) >= 0 then
			if tonumber(arg0) == Current_Select then
				QuestLog_ListBox_SelectChanged()
			end
		end
	elseif(event == "NEW_MISSION" ) then
		Current_Select = tonumber(arg0)
		if not this:IsVisible() then
			return;
		else
			QuestLog_UpdateListbox();
		end
	elseif(event == "DELETE_MISSION") then
		if Current_Select == tonumber(arg0) then
			DataPool:GetPlayerMission_DelActivePos(Current_Select);
			return;
		end
	elseif (event == "OPEN_FROM_MISSIONTRACK") then

		Current_Select = tonumber(arg0)
		if not this:IsVisible() then
			First_Open = 0;

			--全部展开
			for i=1,200 do
				MissionPucker[i] = 1;
			end;

			QuestLog_UpdateListbox();
			QuestLog_ShowWindow();
		else
			--QuestLog_UpdateListbox();
			this:Hide();
		end
	elseif (event == "UPDATE_QUESTLOG_BY_TRACK") then
		if this:IsVisible() then
			QuestLog_UpdateListbox();
		end
	elseif (event == "UPDATE_TRACK_STATE_BUTTON") then
		local nType = tonumber(arg0);
		if not this:IsVisible() then
			return;
		end

		if (nType == 0) then  -- MissionTrack State Changed
			if (DataPool:IsTrackFuncShow(1) > 0) then
				QuestLog_Mode1:SetCheck(1);
			else
				QuestLog_Mode1:SetCheck(0);
			end
		elseif (nType == 1) then  -- CampaignTrack StateChanged
			if (DataPool:IsTrackFuncShow(2) > 0) then
				QuestLog_Mode2:SetCheck(1);
			else
				QuestLog_Mode2:SetCheck(0);
			end
		end
	end

	-- 游戏窗口尺寸发生了变化
	if (event == "ADJEST_UI_POS" ) then
		-- 更新背包界面位置
		QuestLog_Frame_On_ResetPos()

	-- 游戏分辨率发生了变化
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		-- 更新背包界面位置	
		QuestLog_Frame_On_ResetPos()
	end
end

function QuestLog_OnShown()
	QuestLog_UpdateListbox();
end


function QuestLog_HitRiCheng()
	OpenTodayCampaignList();
end

function QuestLog_UpdateMissionType( iMissionType )
	local strOutlineName = ""
	if( 1 == MissionOutlineDeploy[ iMissionType ] ) then
	    strOutlineName = "#gFE7E82- " .. DataPool:GetMissionInfo_Kind( iMissionType )
	else
	    strOutlineName = "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind( iMissionType )
	end

	if( strOutlineName ~= "" or strOutlineName ~= 0 ) then
	    local iStart = iMissionType*10000;
	    local DeployNum = GetMissionOutlineNum( iMissionType )

	    if( DeployNum > 0 ) then
	        QuestLog_Listbox:AddItem( strOutlineName, iStart )
	        if( 1 == MissionOutlineDeploy[ iMissionType ] ) then
	            local nMyLevel = Player:GetData( "LEVEL" )
				for i=1, DeployNum do
				    local color= ""
					local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName = GetMissionOutlineInfo( iMissionType, i )

					if( MissionLevel - nMyLevel < -11 ) then
						color = "FFB9B9B9"; --灰色
					elseif( MissionLevel - nMyLevel <=-6 ) then
						color = "FF0A9605";	--绿色
					elseif( MissionLevel - nMyLevel <= 5 ) then
						color = "FFD9F80A";	--黄色
					elseif( MissionLevel - nMyLevel <= 10 ) then
						color = "FFF8A10A";	--橙色
					else
						color = "FFFA0A0A"; --红色
					end

					QuestLog_Listbox:AddItem( "    "..MissionLevel.." "..strMissionName, (iStart+i), color )
				end
	        end
	    end

	end
end

function QuestLog_UpdateMissionOutline()

    if( 1 == CurList ) then
        CurList = 2
	QuestLog_AcceptMission:SetCheck(1);
        QuestLog_Stop:Hide()
        QuestLog_AcceptMission_Button:Hide()
        QuestLog_TargetMission : SetText( "" );
    end

    local FirstItem = QuestLog_Listbox : GetCurrentFirstItem();
    --AxTrace( 0, 0, Current_Clicked )

    CollectMissionOutline()
    QuestLog_Listbox:ClearListBox()
    QuestLog_Desc:ClearAllElement();

	for i=1,200 do             --现任务类型一共200种
	    QuestLog_UpdateMissionType( i )
	end

    --QuestLog_Listbox : EnsureItemIsVisable( Current_Clicked );
    QuestLog_Listbox : SetCurrentFirstItem( FirstItem );
	QuestLog_TrackButtonState();
    --AxTrace( 0, 0, Current_Clicked )

end

function QuestLog_MissionOutlineClicked()
    local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();

    local iMod = math.mod( nSelIndex, 10000 )
    local iFloor = math.floor( nSelIndex / 10000 );
    if( 0 == iMod ) then
        if( 0 == MissionOutlineDeploy[ iFloor ] ) then
            MissionOutlineDeploy[ iFloor ] = 1
        else
            MissionOutlineDeploy[ iFloor ] = 0
        end

        QuestLog_UpdateMissionOutline()
        QuestLog_Desc:ClearAllElement();
        return
        --QuestLog_Listbox:SetItemSelectByItemID( nSelIndex )
    end

    QuestLog_Desc:ClearAllElement();
    local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName, PosX, PosY, SceneID = GetMissionOutlineInfo( iFloor, iMod )
    QuestLog_Desc:AddTextElement("#Y"..strMissionName.."#W")

    strNpcPos = "#{_INFOAIM"..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."}"
    --strNpcPos = "[["..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."]]"
    --strNpcPos = "（"..PosX.."，"..PosY.."）"

    if strScene and strScene ~= "" then
			QuestLog_Desc:AddTextElement("任务所在地："..strScene.."  "..strNpcPos )
    end
    QuestLog_Desc:AddTextElement("任务发布人："..strNpcName )
    QuestLog_Desc:AddTextElement("任务等级："..tostring(MissionLevel) )


end

function QuestLog_UpdateListbox()

    if( 2 == CurList ) then
        CurList = 1
	QuestLog_CurrentMission:SetCheck(1);
        QuestLog_Stop:Show()
        QuestLog_AcceptMission_Button:Hide()
    end

    QuestLog_CurrentMission:SetCheck( 1 )
    QuestLog_AcceptMission:SetCheck( 0 )

--	local nMissionNum = DataPool:GetPlayerMission_Num();
	local i;
	local nMyLevel = Player:GetData( "LEVEL" );

	QuestLog_Listbox:ClearListBox();

	local nMissionNum = 20
	k = 0
	local color;

	for i=1,nMissionNum do
		if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
			DataPool:GetPlayerMission_Description(i-1);
		end
	end;

	local Sequence_OnefoldGenre = {}
	local Sequence_Assemble = {}
	local Constitutes = {};

	for j=1, 200 do
		local bHave = 0;
		for i=1, nMissionNum do
			if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
				local MissionKind = DataPool:GetPlayerMission_Kind(i-1);

				if(MissionKind == j) then
					AxTrace(0,0,"j = ".. j .. " i-1 ="..(i-1));

					if ( MissionPucker[j] > 0 ) then
						local strInfo = DataPool:GetPlayerMission_Memo(i-1);
						local nMissionLevel = DataPool:GetPlayerMission_Level(i-1);

						if nMissionLevel == LEVEL_TO_MY_LEVEL then
							nMissionLevel =  Player:GetData( "LEVEL" );
						end

						if(bHave == 0) then
							local str= "#gFE7E82- " .. DataPool:GetMissionInfo_Kind(j);
		--fix					QuestLog_Listbox:AddItem(str,100+j);
							Constitutes = {str,100+j,"",0}
--							Sequence_OnefoldGenre = {}
							table.insert(Sequence_OnefoldGenre,Constitutes)
							local xx;
							for i,xx in ipairs(Constitutes) do
								AxTrace(3,1,"Constitutes["..i.."]="..xx)
							end
							AxTrace(0,0,"100+j = ".. (100+j) .. " name = " ..DataPool:GetMissionInfo_Kind(j));
							bHave = 1;
						end
--------------------------------------------------
						local strOKFail = "";
					--显示任务是否已完成或已失败
						local Mission_Variable = DataPool:GetPlayerMission_Variable(i-1,0);
--						local Mission_WhetherComplete = DataPool:GetMission_WhetherComplete(i-1);
--						if( Mission_WhetherComplete > 0 ) then
--							strOKFail = "完成";
--						end
--TT53675对于所有没有用missionparam第0位表示任务是否完成的任务，使用IsMissionSuccess判断任务是否完成
                      local IsSpecial = 0
	                  local nScriptId = DataPool:GetPlayerMission_Display(i-1,7)
	                  for i, findId in SpecialMissionList do
		                   if nScriptId == findId then
			                     IsSpecial = 1
			                     break
		                    end
	                  end
	                  if nScriptId >= 1020000 and nScriptId <= 1029999 then --所有的探索配表任务都需要特殊处理
	   	                  IsSpecial = 1
	                  end
	                   if IsSpecial == 1 then
		                    Mission_Variable = IsMissionSuccess(i-1)
		               end
						if(Mission_Variable >0) then
							if(Mission_Variable == 1) then
								strOKFail = "完成";
							elseif(Mission_Variable == 2) then
								strOKFail = "失败";
							end
						end


----------------------------------------------------
						if(nMissionLevel - nMyLevel < -11) then
							color = "FFB9B9B9"; --灰色
						elseif(nMissionLevel - nMyLevel <=-6) then
							color = "FF0A9605";	--绿色
						elseif(nMissionLevel - nMyLevel <= 5) then
							color = "FFD9F80A";	--黄色
						elseif(nMissionLevel - nMyLevel <= 10) then
							color = "FFF8A10A";	--橙色
						else
							color = "FFFA0A0A"; --红色
						end

						if(First_Open == 1) then
								First_Open = 0;
								Current_Select = i-1;
								AxTrace(0,0,"First_Open =".. First_Open .." Current_Select =".. Current_Select);
						end
--						AxTrace(0,0,"First Current_Select =".. Current_Select);
		--fix				QuestLog_Listbox:AddItem("    " .. nMissionLevel .." " .. strInfo .. " " .. strOKFail, i-1 , color);

						local nMissionTrackType = DataPool:GetPlayerMissionTrackType(i-1);
						local nIsMissionTrackOpen = DataPool:IsMissionTrackOpen(i-1);
						if (nIsMissionTrackOpen > 0 and nMissionTrackType > 0) then
							Constitutes = {"   √" .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
						else
							Constitutes = {"     " .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
						end
						table.insert(Sequence_OnefoldGenre,Constitutes)
--						local xx;
--						for i,xx in ipairs(Constitutes) do
--							AxTrace(3,1,"Constitutes["..i.."]="..xx)
--						end
						if(Current_Select == i-1) then
							QuestLog_Listbox : SetItemSelectByItemID(Current_Select);
						end
--						AxTrace(0,0,"i-1 ="..(i-1).."]  in" );
					else
						if(bHave == 0) then
							local str= "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind(j);
--							QuestLog_Listbox:AddItem(str,100+j);

							Constitutes = {str,100+j,"",0}
							table.insert(Sequence_OnefoldGenre,Constitutes)

--							AxTrace(0,0,"100+j = ".. (100+j) .. " name = " ..DataPool:GetMissionInfo_Kind(j));
							bHave = 1;
						end
--						AxTrace(0,0,"i-1 ="..(i-1).."] = out" );
					end
					k=k+1;
				end
			end
		end
		----
		table.sort(Sequence_OnefoldGenre,CompareTable)

		for i,n in ipairs(Sequence_OnefoldGenre) do
			table.insert(Sequence_Assemble,n)
		end
		Sequence_OnefoldGenre = {};
		----
	end
	local Per_Segment,xxxx,i,j;
	for i,Per_Segment in ipairs(Sequence_Assemble) do
		if Per_Segment[3] ~= "" then
			QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2],Per_Segment[3])
		else
			QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2])
		end

--		for j,xxxx in ipairs(xxx) do
--			AxTrace(3,0,"xxx["..j.."]="..xxxx)
--		end
	end

	if(k<1) then
		QuestLog_Listbox:AddItem("没有任何任务。",0);
	end
	QuestLog_Listbox : SetItemSelectByItemID(Current_Select);
	QuestLog_Amount : SetText( k .. "/" .. nMissionNum);
---
	QuestLog_ListBox_SelectChanged();

	if Current_Clicked ~= -1 then
		--QuestLog_Listbox : EnsureItemIsVisable(Current_Clicked);
		QuestLog_Listbox : SetCurrentFirstItem(Current_Clicked);
		Current_Clicked = -1
	end
	QuestLog_TrackButtonState();
--
end

function MissionType_Insert(str)
--排序算法在上面已经实现了，理论上讲这个不会被调用到。chris
--		for i=1,table.getn(MissionType) do
		for i,Per_Segment in ipairs(MissionType) do
			if(MissionType[i] == str) then
				return;
			elseif( MissionType[i] > str ) then
					table.insert(MissionType,i,str);
--					AxTrace(0,0,"MissionType [" ..i.."] =".. MissionType[i]);
					return;
			end
		end
		table.insert(MissionType,str);
		return;
end

function QuestLog_ListBox_SelectChanged()

if( 2 == CurList ) then
    QuestLog_MissionOutlineClicked()
    return
end

		local MissionParam_Index = 0;
		local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
		local Mission_Variable;
		if(k<1) then
			QuestLog_Desc:ClearAllElement();
			QuestLog_TargetMission : SetText("");
			return;
		end
		if nSelIndex == -1 then
			if Current_Select == -1 then
				QuestLog_Desc:ClearAllElement();
				QuestLog_TargetMission : SetText("");
				return;
			else
				nSelIndex = Current_Select;
			end
		end
--		AxTrace(0,0,"选中项为 =" .. nSelIndex);
		if nSelIndex > 20 then

			if MissionPucker[nSelIndex-100] == 1 then
				MissionPucker[nSelIndex-100] = 0;
--				AxTrace(0,0,"==1");
			else
				MissionPucker[nSelIndex-100] = 1;
--				AxTrace(0,0,"==0");
			end
			Current_Clicked = QuestLog_Listbox : GetCurrentFirstItem();
			QuestLog_UpdateListbox();

			return;
		end;
		if (DataPool:GetPlayerMission_InUse(nSelIndex) ~= 1) then
			QuestLog_Desc:ClearAllElement();
			QuestLog_TargetMission : SetText("");
			return;
		end
		QuestLog_Desc:ClearAllElement();
		QuestLog_TargetMission : SetText("");

		local desc = DataPool:GetPlayerMission_Description(nSelIndex)
		DataPool:GetPlayerMission_DelActivePos(Current_Select)
		Current_Select = nSelIndex;

		local strInfo,strDesc = DataPool:GetPlayerMission_Memo(nSelIndex);
		local i = 0
		local m = 0
		local nBegin = DataPool:GetPlayerMission_ForePart(nSelIndex);
		AxTrace(5,1,"nBegin="..nBegin)
		AxTrace(5,1,"strDesc="..strDesc)
		local strReplace = ""
		local strOriginal = ""
		while 1 do
			i = string.find(strDesc,"%%s")
			if i == nil then break end
			local strIndex =  DataPool:GetPlayerMission_VariableByByte(nSelIndex,nBegin,m)
			local strTemp = DataPool : GetPlayerMission_StrList(strIndex)
			AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
--			string.format(strDesc,strTemp)
			AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
			strReplace = strReplace .. string.sub(strDesc,1,i-1) .. strTemp
			AxTrace(5,1,"strReplace="..strReplace)
			AxTrace(5,1,"i="..i)
			strDesc = string.sub(strDesc,i+2)
			m = m + 1;
			AxTrace(5,1,"m="..m)
		end
		strReplace = strReplace .. strDesc
		strDesc = strReplace
		QuestLog_TargetMission : SetText("#gFF0FA0" ..strInfo);
		QuestLog_Desc:AddTextElement("#Y任务目标：#W")
		QuestLog_Desc:AddTextElement("" .. strDesc);
		-- PushDebugMessage("strDesc:"..strDesc)
--		QuestLog_Desc:AddTextElement("" .. strReplace);
		DataPool:GetPlayerMission_ActivePos(nSelIndex);

---------------------------- 任务目标特写 Begin ----------------------------
	local nScriptId_TeXie = DataPool:GetPlayerMission_Display(nSelIndex, 7)

	--【2021Q1】4月版本打卡活动 宣传英雄大会
	if nScriptId_TeXie == 250552 then
		QuestLog_Desc:AddTextElement("#{BFHX_210203_06}")
	end
	
	-- [2022Q3]拉镖周常活动设计
	if nScriptId_TeXie == 888160 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_Guard(nSelIndex))
	end
	
	--【2022Q4】情人节打卡
	if nScriptId_TeXie == 890055 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_QingRenJieDaKa(nSelIndex))
	end
	
	-- 新身份系统-引导任务
	if nScriptId_TeXie == 998657 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_IdentityGuide3(nSelIndex))
	end
	if nScriptId_TeXie == 998659 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_IdentityGuide5(nSelIndex))
	end
		
	--武道二层历练任务 任务2特写
	if nScriptId_TeXie == 893187 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission21(nSelIndex))
	end
	if nScriptId_TeXie == 893197 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission22(nSelIndex))
	end
	if nScriptId_TeXie == 893207 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission23(nSelIndex))
	end

	--武道二层历练任务 任务4特写
	if nScriptId_TeXie == 893189 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission14(nSelIndex))
	end
	if nScriptId_TeXie == 893199 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission24(nSelIndex))
	end
	if nScriptId_TeXie == 893209 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_LiLianMission34(nSelIndex))
	end

	-- 小提示：点击任务目标或任务追踪界面内相关超链，可开启武道历练任务自动流程。
	if nScriptId_TeXie >= 893186 and nScriptId_TeXie <= 893212 then
		QuestLog_Desc:AddTextElement("#{WDZD_230721_13}")
	end

	--武道三层历练任务 任务1特写
	if nScriptId_TeXie == 998355 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_JingJinMission1(nSelIndex))
	end
	
		--武道三层历练任务 任务2特写
	if nScriptId_TeXie == 998356 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_JingJinMission2(nSelIndex))
	end
	
		--武道三层历练任务 任务3特写
	if nScriptId_TeXie == 998357 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_JingJinMission3(nSelIndex))
	end
	
			--武道三层历练任务 任务4特写
	if nScriptId_TeXie == 998358 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_JingJinMission4(nSelIndex))
	end
	
			--武道三层历练任务 任务5特写
	if nScriptId_TeXie == 998359 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_JingJinMission5(nSelIndex))
	end

	-- 新天赋系统修炼任务设计 begin
	if nScriptId_TeXie == 891274 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission1(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891275 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission2(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891276 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission3(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891277 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission4(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891278 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission5(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891279 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission6(nSelIndex) .. "#{WDZD_221208_07}")
	end
	if nScriptId_TeXie == 891280 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission7(nSelIndex))
	end
	if nScriptId_TeXie == 891281 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XiuLianMission8(nSelIndex))
	end
	-- 新天赋系统修炼任务设计 end
	
	--雪球欢乐季 移植
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 889265) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetHLXQJTarget(nSelIndex));
	end

	--Q4打卡活动
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 890638) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetXunBaoLeFanTianTarget(nSelIndex));
	end

	-- [2017-元宵节猜灯谜活动]
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 892384) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2017YXJCDM(nSelIndex));
    end
	
	-- 星火生雁门任务1 
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 791022) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XingHuoYanMen01(nSelIndex));
	end	

	--//2021剧情任务-ypl -剧情1
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891083) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021JuQing1(nSelIndex));
    end	

	--//2021剧情任务-ypl -剧情2
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891095) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021JuQing2(nSelIndex));
    end	
	
	--天赋引导任务-2021 by yuanpeilong：任务2
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891219) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu2(nSelIndex));
    end	
	
	--天赋引导任务-2021 by yuanpeilong：任务3
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891220) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu3(nSelIndex));
    end	
	
	--天赋引导任务-2021 by yuanpeilong：任务4
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891221) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu4(nSelIndex));
    end		

	--天赋引导任务-2021 by yuanpeilong：任务5
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891222) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu5(nSelIndex));
    end	

	--天赋引导任务-2021 by yuanpeilong：任务6
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891223) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu6(nSelIndex));
    end	

	--天赋引导任务-2021 by yuanpeilong：任务7
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891224) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2021TianFu7(nSelIndex));
    end	
	--2021Q4十一月感恩节火鸡打卡活动
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 888767) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTrack_2021HuoJiDaKa(nSelIndex));
	end
	--2022Q4应景打卡
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893090) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTrack_2022Q1QTESignIn(nSelIndex));
	end
--	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 888779) then
--		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTrack_CleanForNewYear(nSelIndex));
--	end
	--//2022兽魂版本预热-ypl
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893108) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2022PetYuRe(nSelIndex));		
	end	

	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893242) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2022TianFu1(nSelIndex));
    end	

	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893243) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2022TianFu2(nSelIndex));
    end	

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998352) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2023TianFu3(nSelIndex));
    end	

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998353) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2023TianFu4(nSelIndex));
    end	
    --2024preheat
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998698) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_PreHeatMission4(nSelIndex));
    end	
    
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998819) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2024DWDK(nSelIndex));
    end	

  --2022Q2夏日打卡
	local iMissionScript = DataPool:GetPlayerMission_Display(nSelIndex,7)
	if iMissionScript == 893176 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2022Q2XYPCA(nSelIndex));
	elseif iMissionScript == 893181 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_2022Q2CaiDan5(nSelIndex));
	elseif iMissionScript >= 998586 and iMissionScript <= 998594 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_ShenFenTuPo(nSelIndex));
	end
	
	if nScriptId_TeXie == 505010 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_Roman(nSelIndex))
	end

	--if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 890046) then
        --QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_GCJW(nSelIndex));
    --end
	--2023Q3周年庆打卡活动 任务目标特写
	if nScriptId_TeXie == 998474 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_TianDeng_isTeam(nSelIndex))
	end	
	if nScriptId_TeXie == 890291 then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LongHaiZi(nSelIndex));
    end	
	
	if nScriptId_TeXie == 998665 then
        QuestLog_Desc:AddTextElement("" .. QuestLog_TCJL(nSelIndex));
    end		
	if nScriptId_TeXie == 998812 then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetTarget_XRBQL(nSelIndex));
    end		

---------------------------- 任务目标特写 End ----------------------------

--显示是否双倍时间
		local nDoubleExp = DataPool:GetPlayerMission_Display(nSelIndex,6)

		local DoubleExp_Text = "";
		if nDoubleExp > 0 then
			local IsDouble = DataPool:GetPlayerMission_DataRound(nDoubleExp);

			if IsDouble > 0 then
				DoubleExp_Text = "#B多倍奖励"
				QuestLog_Desc:AddTextElement(DoubleExp_Text);
			end
		end

--		AxTrace(0, 0, "strInfo= " .. strInfo );
	--前面是否有一位显示任务是否已完成,第一位为完成信息
		--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理
		local IsSpecial = 0
	    local nScriptId1 = DataPool:GetPlayerMission_Display(nSelIndex,7)
	    for i, findId in SpecialMissionList do
		    if nScriptId1 == findId then
			     IsSpecial = 1
			     break
		    end
	   end
	   if nScriptId1>=1020000 and nScriptId1<=1029999  then --所有的探索配表任务都需要特殊处理
	   	    IsSpecial = 1
	   end
	   if IsSpecial==0 then
		    MissionParam_Index = MissionParam_Index + 1;
		end

--		for i =0,7 do
--			AxTrace(0,0, "variable [" .. i .."] = " .. DataPool:GetPlayerMission_Variable(nSelIndex,i) );
--		end
--显示任务剩余时间
		local nTotalTime = DataPool:GetPlayerMission_Display(nSelIndex,2);
		AxTrace(1,1,"nTotalTime="..nTotalTime)
		if( nTotalTime > 0 ) then
			local nRemainTime = DataPool:GetPlayerMission_RemainTime(nSelIndex);
			AxTrace(1,1,"nRemainTime="..nRemainTime)
			if(nTotalTime >0) then
--				QuestLog_Desc:AddTextElement(" ");
				local strRemainTime,strTotalTime,nSecond,nMinute,nHour; --Dengxx

				if(nTotalTime >= 60000*60) then
					nHour = math.floor(nTotalTime/60000/60)
					nMinute = math.floor((math.mod(nTotalTime,60000*60))/60000)
					nSecond = math.floor((math.mod(nTotalTime,60000))/1000)
					strTotalTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
				elseif(nTotalTime >= 60000) then
					nMinute = nTotalTime/60000;
					strTotalTime = nMinute .. "分"
					nSecond = (nTotalTime - nMinute * 60000)/1000;
					strTotalTime = strTotalTime .. nSecond .."秒"
				elseif(nTotalTime >= 1000) then
					strTotalTime = nTotalTime/1000 .."秒"
				end

        if(nRemainTime >= 60000*60) then
					nHour = math.floor(nRemainTime/60000/60)
					nMinute = math.floor((math.mod(nRemainTime,60000*60))/60000)
					nSecond = math.floor((math.mod(nRemainTime,60000))/1000)
					strRemainTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
				elseif(nRemainTime >= 60000) then
					nMinute = math.floor(nRemainTime/60000);
					strRemainTime = nMinute .. "分"
					nSecond = math.floor((nRemainTime - nMinute * 60000)/1000);
					strRemainTime = strRemainTime .. nSecond .."秒"
				elseif(nRemainTime >= 1000) then
					strRemainTime = math.floor(nRemainTime/1000) .."秒"
				else
					strRemainTime = "0秒"
				end

--				QuestLog_Desc:AddTextElement("剩余时间： " .. strRemainTime .."/".. strTotalTime);
				QuestLog_Desc:AddTextElement("剩余时间： " .. strRemainTime );
--				AxTrace(0,0, "时间 [" .. nSelIndex .."] = " .. strRemainTime .. " param_index = "..MissionParam_Index);
			end
		end

		--显示任务当前环数，misInfo的第三号参数为环数，通过mission data显示
		--yanghui，设置标志，通过mission data显示环数还是mission param显示环数
		local bShowByMD = 0;
		local nRound = DataPool:GetPlayerMission_Display(nSelIndex,3);
		if( nRound >= 0 ) then
			Mission_Variable = DataPool:GetPlayerMission_DataRound(nRound);

			if(Mission_Variable >= 0) then
				QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
				bShowByMD = 1;
			end
		end

		--yanghui，千寻任务使用mission param增加环数显示
		if (bShowByMD == 0) then
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 2);
			if (Mission_Variable == 229024) then
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 5);
				if(Mission_Variable >= 0) then
					QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
				end
			end
		end


--显示任务银票数量
		if( DataPool:GetPlayerMission_Display(nSelIndex,4) > 0 ) then
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
			MissionParam_Index = MissionParam_Index + 1;

			if(Mission_Variable >0) then
--				QuestLog_Desc:AddTextElement(" ");
				silverdesc = DataPool:GetPlayerMission_BillName(nSelIndex);
				QuestLog_Desc:AddTextElement(silverdesc .. ":");
				QuestLog_Desc:AddMoneyElement(Mission_Variable);
				AxTrace(0,0, "银票 [" .. nSelIndex .."] =" ..MissionParam_Index );
			end
		end
		QuestLog_Desc:AddTextElement(" ");
		if( DataPool:GetPlayerMission_Display(nSelIndex,5) <= 0 ) then
			QuestLog_Desc:AddTextElement("#Y完成情况：#W")
		end

	--大话西游第一阶段主线剧情-ypl
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 999119) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024DHMission(nSelIndex));
    end		
	
---------------------------- 完成情况特写 Begin ----------------------------

    --【2021Q1】4月版本打卡活动 宣传英雄大会
	if nScriptId_TeXie == 250552 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_XuanChuanYXDH_State(nSelIndex))
	end
	
	-- [2022Q3]拉镖周常活动设计
	if nScriptId_TeXie == 888160 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_Guard(nSelIndex))
	end

	--【2022Q4】情人节打卡
	if nScriptId_TeXie == 890055 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_QingRenJieDaKa(nSelIndex))
	end
	
	-- 新身份系统-引导任务
	if nScriptId_TeXie == 998657 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_IdentityGuide3(nSelIndex))
	end
	-- 新身份系统-引导任务
	if nScriptId_TeXie == 998659 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_IdentityGuide5(nSelIndex))
	end
		
	--武道二层历练任务 任务2特写
	if nScriptId_TeXie == 893187 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission21(nSelIndex))
	end
	if nScriptId_TeXie == 893197 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission22(nSelIndex))
	end
	if nScriptId_TeXie == 893207 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission23(nSelIndex))
	end

	--武道二层历练任务 任务4特写
--	if nScriptId_TeXie == 893189 then
--		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission14(nSelIndex))
--	end
--	if nScriptId_TeXie == 893199 then
--		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission24(nSelIndex))
--	end
--	if nScriptId_TeXie == 893209 then
--		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_LiLianMission34(nSelIndex))
--	end

	-- 新天赋系统修炼任务设计 begin
	if nScriptId_TeXie == 891274 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission1(nSelIndex))
	end
	if nScriptId_TeXie == 891275 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission2(nSelIndex))
	end
	if nScriptId_TeXie == 891276 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission3(nSelIndex))
	end
	if nScriptId_TeXie == 891277 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission4(nSelIndex))
	end
	if nScriptId_TeXie == 891278 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission5(nSelIndex))
	end
	if nScriptId_TeXie == 891279 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission6(nSelIndex))
	end
	if nScriptId_TeXie == 891280 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission7(nSelIndex))
	end
	if nScriptId_TeXie == 891281 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XiuLianMission8(nSelIndex))
	end
	-- 新天赋系统修炼任务设计 end

	--雪球欢乐季 移植
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 889265) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_GetHLXQJComplete(nSelIndex));
    end

	-- [2017-元宵节猜灯谜活动]
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 892384) then
        QuestLog_Desc:AddTextElement("\n" .. QuestLog_Complete_2017YXJCDM(nSelIndex));
	end
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 888779) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_CleanForNewYear(nSelIndex));
	end
	
	-- 星火生雁门任务1 
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 791022) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XingHuoYanMen01(nSelIndex));
	end	

	--//2021剧情任务-ypl -剧情1
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891083) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021JuQing1(nSelIndex));
    end	

	--//2021剧情任务-ypl -剧情2
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891095) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021JuQing2(nSelIndex));
    end		

	--天赋引导任务-2021 by yuanpeilong：任务2
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891219) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu2(nSelIndex));
    end	
	
	--天赋引导任务-2021 by yuanpeilong：任务3
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891220) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu3(nSelIndex));
    end		
	
	--天赋引导任务-2021 by yuanpeilong：任务4
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891221) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu4(nSelIndex));
    end	
	
	--天赋引导任务-2021 by yuanpeilong：任务5
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891222) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu5(nSelIndex));
    end	

	--天赋引导任务-2021 by yuanpeilong：任务6
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891223) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu6(nSelIndex));
    end

	--天赋引导任务-2021 by yuanpeilong：任务7
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 891224) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2021TianFu7(nSelIndex));
	end
	
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893090) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2022Q1QTESignIn(nSelIndex));
    end
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 503000) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_petsoul_per1(nSelIndex));
	end
	--2022Q2夏日打卡
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893176) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2022Q2XYPCA(nSelIndex));
	end
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 503001) then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_petsoul_per2(nSelIndex));
	end
	
	--//2022兽魂版本预热-ypl
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893108) then
        QuestLog_Desc:AddTextElement("\n" .. QuestLog_Complete_2022PetYuRe(nSelIndex));
	end	

	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893242) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2022TianFu1(nSelIndex));
    end	

	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 893243) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2022TianFu2(nSelIndex));
    end	

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998352) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2023TianFu3(nSelIndex));
    end	

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998353) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2023TianFu4(nSelIndex));
    end	

	local iMissionScript = DataPool:GetPlayerMission_Display(nSelIndex,7)
	if iMissionScript == 892760 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_PaoShang(nSelIndex));
	elseif iMissionScript == 810115 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_TXDaGongTu(nSelIndex));
	elseif iMissionScript >= 998586 and iMissionScript <= 998594 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_ShenFenTuPo(nSelIndex));
	end
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 890046) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_GCJW(nSelIndex));
	end	
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998289) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_CoupleWeeklyMission2(nSelIndex));
    end	
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998695) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_PreHeatMission1(nSelIndex));
    end	
    --2024Q1 preheat
    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998698) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_PreHeatMission4(nSelIndex));
    end	

    if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998819) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024DWDK(nSelIndex));
    end	
	-- 【2024Q2】新版本预热-山重水复
	if nScriptId_TeXie == 998774 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024Q2PM_Mission1(nSelIndex))
	elseif nScriptId_TeXie == 998775 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024Q2PM_Mission2(nSelIndex))
	elseif nScriptId_TeXie == 998776 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024Q2PM_Mission3(nSelIndex))
	elseif nScriptId_TeXie == 998777 then
		QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_2024Q2PM_Mission4(nSelIndex))
	end
	--2024Q2 夏日冰淇淋
	if(DataPool:GetPlayerMission_Display(nSelIndex,7) == 998812) then
        QuestLog_Desc:AddTextElement("" .. QuestLog_Complete_XRBQL(nSelIndex));
    end	
---------------------------- 完成情况特写 End ----------------------------
	
--任务需要杀的npc
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
		if( nDemandKillNum > 0 ) then
--			QuestLog_Desc:AddTextElement(" ");
			QuestLog_Desc:AddTextElement("已杀死：");
		end

		for i=1, nDemandKillNum do
			--    需要的NPC，需要NPC ID，需要多少个
			local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
			MissionParam_Index = MissionParam_Index + 1;
			AxTrace(0, 0, "nNPCName:" .. nNPCName);
			AxTrace(0, 0, "num:" .. nNum);

			QuestLog_Desc:AddTextElement(nNPCName .. " ： "..Mission_Variable.. " / " .. nNum);
			AxTrace(0,0, "NPC [" .. nSelIndex .."] =" ..MissionParam_Index );
		end

--任务需要的物品
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
		if( nDemandNum > 0 ) then
--			QuestLog_Desc:AddTextElement(" ");
			if(Item_Random_Type == -100) then
				QuestLog_Desc:AddTextElement("已提交：");
				Item_Random_Type = 0
			else
				QuestLog_Desc:AddTextElement("已得到：");
			end
		end

		for i=1, nDemandNum do
			--    需要的类型，需要物品ID，需要多少个
			local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
--			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
--			MissionParam_Index = MissionParam_Index + 1
			Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
			--71435 “寻找万灵石”任务逻辑的修改
            if nItemID == 20309012 then
				Mission_Variable = Mission_Variable + DataPool : GetPlayerMission_ItemCountNow(20309020)
			end
			AxTrace(0, 0, "itemid:" .. nItemID)
			AxTrace(0, 0, "szName:" .. szName)
			AxTrace(0, 0, "num:" .. nNum)

			if Mission_Variable > nNum then
				Mission_Variable = nNum
			end


--			QuestLog_Desc:AddItemElement(nItemID, nNum, 0);
			local Mission_Variable2 = DataPool:GetPlayerMission_Variable(nSelIndex,0);
			if Mission_Variable2 > 0 then
				Mission_Variable = nNum
			end
			QuestLog_Desc:AddTextElement(szName .. " ： " .. Mission_Variable .. " / " .. nNum);
		end

-----------------------------------------------------------------------------------
--任务自定义的物品
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
		if( nCustomNum > 0 ) then
			QuestLog_Desc:AddTextElement(" ");
		end

		for i=1, nCustomNum do
			--    需要的NPC，需要NPC ID，需要多少个
			local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
			MissionParam_Index = MissionParam_Index + 1;
			AxTrace(0, 0, "strCustom = " .. strCustom);
			AxTrace(0, 0, "nNum = " .. nNum);

			if nNum == 0 then
				QuestLog_Desc:AddTextElement(strCustom);
			else
				QuestLog_Desc:AddTextElement(strCustom .. " ： ".. Mission_Variable .. " / " .. nNum);
			end
		end

-----------------------------------------------------------------------------------

--任务自定义的随机物品 zz添加

	local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
	if( nRandomCustomNum > 0 ) then
			QuestLog_Desc:AddTextElement(" ");
	end
	for i=1,nRandomCustomNum do
		local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
		if nNeedNum == 0 then
			QuestLog_Desc:AddTextElement(strCustom);
		else
			QuestLog_Desc:AddTextElement(strCustom .. " ： ".. nCompleteNum .. " / " .. nNeedNum);
		end
	end
----------------------------------------------------------------------------------

		QuestLog_Desc:AddTextElement(" ");
		local nBonusNum = DataPool:GetPlayerMissionBonus_Num();

		if( nBonusNum > 0 ) then
			QuestLog_Desc:AddTextElement("#Y奖励：#W");
		end
		local nRadio = 1;
		local nRand = 1;

		for i=1, nBonusNum do
			--奖励的类型，奖励物品ID，奖励多少个
			local strType, nItemID, nNum = DataPool:GetPlayerMissionBonus_Item(i-1);
			if(strType == "money" and nNum > 0 )then
--				QuestLog_Desc:AddTextElement("奖励金钱：");
				--这里有对剧情循环任务的特殊处理
				local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex,7)
				if (nScriptId >= 890000 and nScriptId <= 890005) then
					QuestLog_Desc:AddJiaoZiElement(nNum)
				else
					if (nScriptId >= 1010243 and nScriptId <= 1010250) or
					 (nScriptId >= 1010402 and nScriptId <= 1010409) or
					 (nScriptId >= 1018000 and nScriptId <= 1018033) or
					 (nScriptId >= 1018050 and nScriptId <= 1018084) or
					 (nScriptId >= 1018100 and nScriptId <= 1018155) or
					 (nScriptId >= 1018200 and nScriptId <= 1018235) or
					 (nScriptId >= 1018300 and nScriptId <= 1018311) or
					 (nScriptId >= 1018350 and nScriptId <= 1018352) or
					 (nScriptId >= 1018360 and nScriptId <= 1018367) or
					 (nScriptId >= 1018400 and nScriptId <= 1018455) or
					 (nScriptId >= 1018500 and nScriptId <= 1018504) or
					 (nScriptId >= 1018530 and nScriptId <= 1018541) or
					 (nScriptId >= 1018560 and nScriptId <= 1018566) or
					 (nScriptId >= 1038000 and nScriptId <= 1038040) or
					 (nScriptId >= 1038110 and nScriptId <= 1038114) or
					 (nScriptId >= 1039000 and nScriptId <= 1039011) or
					 (nScriptId >= 1039020 and nScriptId <= 1039024) or
					 (nScriptId >= 1039100 and nScriptId <= 1039104) or
					 (nScriptId >= 1038100 and nScriptId <= 1038104) or
					 (nScriptId >= 1039110 and nScriptId <= 1039126) or
					 (nScriptId >= 1039200 and nScriptId <= 1039211) or
					 (nScriptId >= 1039250 and nScriptId <= 1039259) or
					 (nScriptId >= 1039300 and nScriptId <= 1039312) or
					 (nScriptId >= 1039350 and nScriptId <= 1039357) or
					 (nScriptId >= 1039400 and nScriptId <= 1039412) or
					 (nScriptId >= 1039450 and nScriptId <= 1039462) or
					 (nScriptId >= 1039500 and nScriptId <= 1039511) or
					 (nScriptId >= 1039550 and nScriptId <= 1039554) or
					 (nScriptId >= 1039600 and nScriptId <= 1039612) or
					 (nScriptId >= 1009000 and nScriptId <= 1009027) or
					 (nScriptId >= 1009100 and nScriptId <= 1009103) then

						-- 使用玩家自己的等级来计算得到的奖励
						nNum = tonumber(Player:GetData("LEVEL") * 18 -101)
					end

					QuestLog_Desc:AddMoneyElement(nNum);
				end
			elseif(strType == "moneyjz" and nNum > 0) then
				QuestLog_Desc:AddJiaoZiElement(nNum)
			elseif(strType == "item") then
--				QuestLog_Desc:AddTextElement("固定奖励物品：");
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
			elseif(strType == "itemrand") then
				if (nRand == 1) then
					nRand = 0;
					QuestLog_Desc:AddTextElement("随机奖励物品：");
					local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
					QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
				end
--				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
--				QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
--				QuestLog_Desc:AddItemElement(-1, nNum, 0);
			elseif(strType == "itemradio") then
				bBeingRadio = 1;
				if (nRadio == 1) then
					nRadio = 0;
					QuestLog_Desc:AddTextElement("在下列物品中选择一项作为奖励");
				end
				AxTrace(0, 0, "nItemID:" .. nItemID);
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				AxTrace(0, 0, "ActionID:" .. ActionID);
				QuestLog_Desc:AddActionElement(ActionID,nNum, 0 ,0);
--				QuestLog_Desc:AddItemElement(nItemID, nNum, 1 ,1);
			end
		end

		--------------------------------------------------------------------------------
		--2009圣诞日常活动的特殊处理
		--Add by Jiang Yin
		--------------------------------------------------------------------------------
		local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex, 7)
		if nScriptId == 808200 then
			local strIndex = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
			local strTemp = DataPool:GetPlayerMission_StrList(strIndex)
			local pos = string.find(strTemp, "%%s")
			if pos ~= nil then
				strTemp = string.sub(strTemp, 1, pos - 1) .. DataPool:GetPlayerMission_Variable(nSelIndex, 2) .. string.sub(strTemp,  pos + 2)
			end
			QuestLog_Desc:AddTextElement(strTemp)
		end
		--------------------------------------------------------------------------------
		--2009圣诞日常活动的特殊处理完毕
		--------------------------------------------------------------------------------

		QuestLog_TrackButtonState();
end

function Abnegate_Quest()
	if(k<1 or QuestLog_Listbox:GetFirstSelectItem() < 0) then
		return;
	end
	if(Current_Select < 100) then
		DataPool : Mission_Abnegate_Popup( Current_Select, DataPool:GetPlayerMission_Memo(Current_Select));
	end
end

function CompareTable(table_a,table_b)
	if table_a[4] < table_b[4] then
		return true
	else
		return false
	end
end

function QuestLog_MissionTrack_Clicked()
	local nCheck = QuestLog_Mode1:GetCheck();  --为点击后的状态
	if (nCheck > 0) then
		OpenWindow("MissionTrack");
		DataPool:SetTrackFuncShow(1, 1);
	else
		CloseWindow("MissionTrack");
		DataPool:SetTrackFuncShow(1, 0);
	end
end

function QuestLog_CampaignTrack_Clicked()
	local nCheck = QuestLog_Mode2:GetCheck();  --为点击后的状态
	if (nCheck > 0) then
		OpenWindow("CampaignTrack");
		DataPool:SetTrackFuncShow(2, 1);
	else
		CloseWindow("CampaignTrack");
		DataPool:SetTrackFuncShow(2, 0);
	end
end

function QuestLog_ShowWindow()
	this:TogleShow();
	local nMissionTrackShow = DataPool:IsTrackFuncShow(1);
	local nCampaignTrackShow = DataPool:IsTrackFuncShow(2);
	if (nMissionTrackShow > 0) then
		QuestLog_Mode1:SetCheck(1);
	else
		QuestLog_Mode1:SetCheck(0);
	end
	if (nCampaignTrackShow > 0) then
		QuestLog_Mode2:SetCheck(1);
	else
		QuestLog_Mode2:SetCheck(0);
	end
end

function QuestLog_TrackButtonState()
	if( 1 ~= CurList ) then
		QuestLog_Refuse:SetText("#{INTERFACE_XML_301}");
		QuestLog_Refuse:Enable();
    	return
	end

	local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
	local nCanTrack, nCanAuto = DataPool:GetPlayerMissionTrackType(nSelIndex);
	local MissionKind = DataPool:GetPlayerMission_Kind(nSelIndex);
	
	-- 内挂自动化任务
	if nCanAuto and nCanAuto > 0 then
		QuestLog_Refuse:SetText("自动执行")
		QuestLog_Refuse:Enable()

	--关系任务不可追踪
	elseif (nCanTrack > 0 and MissionKind ~= 10) then
		local nTrackOpen = DataPool:IsMissionTrackOpen(nSelIndex);
		if (nTrackOpen > 0) then
			QuestLog_Refuse:SetText("取消追踪");
		else
			QuestLog_Refuse:SetText("开始追踪");
		end
		QuestLog_Refuse:Enable();
	else
		QuestLog_Refuse:SetText("不可追踪");
		QuestLog_Refuse:Disable();
	end
end

function QuestLog_TrackCancelOrOpen()
	if( 1 ~= CurList ) then
			--可接任务关闭
			this:Hide();
    	return
	end

	local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
	local nCanTrack, nCanAuto = DataPool:GetPlayerMissionTrackType(nSelIndex);

	if nCanAuto and nCanAuto > 0 then
		-- 开启内挂
		if IsNGRunning() == 0 then
			StartRunningNG()
		end
		return
	end

	if (nCanTrack > 0) then
		local nTrackOpen = DataPool:IsMissionTrackOpen(nSelIndex);
		if (nTrackOpen > 0) then
			DataPool:SetMissionTrackOpen(nSelIndex, 0);
		else
			if (DataPool:IsTrackFuncShow(1) == 0) then
				OpenWindow("MissionTrack");
				DataPool:SetTrackFuncShow(1, 1);
			end
			DataPool:SetMissionTrackOpen(nSelIndex, 1);
		end
		QuestLog_UpdateListbox();
		DataPool:UpdateMissionTrack();
	end
end
--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理，判断任务是否完成
function IsMissionSuccess(nSelIndex)
       local MissionParam_Index = 0
       local Mission_Variable = 0
--任务需要杀的npc
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
		if( nDemandKillNum > 0 ) then
			for i=1, nDemandKillNum do
				--    需要的NPC，需要NPC ID，需要多少个
				local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
					return 0
				end
			end
		end

--任务需要的物品
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
		if( nDemandNum > 0 ) then
			for i=1, nDemandNum do
				--    需要的类型，需要物品ID，需要多少个
				local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
				Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
				 if Mission_Variable < nNum then
					return 0
				 end
			 end
		 end

-----------------------------------------------------------------------------------
--任务自定义的物品
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
		if( nCustomNum > 0 ) then
			for i=1, nCustomNum do
				--    需要的NPC，需要NPC ID，需要多少个
				local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
				    return 0
				end
			end
		end

-----------------------------------------------------------------------------------

--任务自定义的随机物品 zz添加

	local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
	if( nRandomCustomNum > 0 ) then
		for i=1,nRandomCustomNum do
			local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
			if nCompleteNum < nNeedNum then
				return 0
			end
		end
	end

	return 1
end


function QuestLog_Complete_petsoul_per1(nMissionIndex)
		local str = "    击败"
		local monstername = 
		{
			[49816] = "残兽幽魂",
			[49817] = "残兽邪魄",
			[49818] = "残兽恶识",
		}
		
		local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 ) 
		local monsterindex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 ) 
		local index2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 ) 
		str = str..monstername[monsterindex].."："..index.."/"..index2

		
		return str


    
end

function QuestLog_Complete_petsoul_per2(nMissionIndex)
	local str = "    获得重大消息:"

	
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 ) 
	str = str.."："..index.."/"..1

	
	return str



end



function QuestLog_GetXunBaoLeFanTianTarget( nMissionIndex )

    local pos =
	{
		-- 苏州	码头（238，81）、文庙（90，81）、欧冶子（266，138）
		[1] = {
			[1] = {SceneID = 1, PosX = 238, PosZ = 81,	SceneName = "苏州",	SubName = "码头"},
			[2] = {SceneID = 1, PosX = 90,	PosZ = 81,	SceneName = "苏州",	SubName = "文庙"},
			[3] = {SceneID = 1, PosX = 266, PosZ = 138,	SceneName = "苏州",	SubName = "欧冶子"},
		},	
		-- 洛阳	武器店（209，154）、月老（48，62）、镖局（84，118）	
		[2] = {	
			[1] = {SceneID = 0, PosX = 209, PosZ = 154,	SceneName = "洛阳",	SubName = "武器店"},
			[2] = {SceneID = 0, PosX = 48,	PosZ = 62,	SceneName = "洛阳",	SubName = "月老"},
			[3] = {SceneID = 0, PosX = 84, 	PosZ = 118,	SceneName = "洛阳",	SubName = "镖局"},
		},	
		-- 大理	望苍台（240,56）、五华坛（160,169）、云飘飘（264,128）	
		[3] = {	
			[1] = {SceneID = 2, PosX = 240, PosZ = 56,	SceneName = "大理",	SubName = "望苍台"},
			[2] = {SceneID = 2, PosX = 160, PosZ = 169,	SceneName = "大理",	SubName = "五华坛"},
			[3] = {SceneID = 2, PosX = 264, PosZ = 128,	SceneName = "大理",	SubName = "云飘飘"},
		},
	}

    local index_suzhou  = 1
    local index_luoyang = 2
    local index_dali    = 3

    local sub_suzhou = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
    local sub_luoyang = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
    local sub_dali = DataPool:GetPlayerMission_Variable( nMissionIndex, 7 )

    local city_suzhou = pos[index_suzhou][sub_suzhou].SceneName;
    local posx_suzhou = pos[index_suzhou][sub_suzhou].PosX;
    local posz_suzhou = pos[index_suzhou][sub_suzhou].PosZ;
    local sceneid_suzhou = pos[index_suzhou][sub_suzhou].SceneID;
    local SubName_suzhou = pos[index_suzhou][sub_suzhou].SubName;

    local city_luoyang = pos[index_luoyang][sub_luoyang].SceneName;
    local posx_luoyang = pos[index_luoyang][sub_luoyang].PosX;
    local posz_luoyang = pos[index_luoyang][sub_luoyang].PosZ;
    local sceneid_luoyang = pos[index_luoyang][sub_luoyang].SceneID;
    local SubName_luoyang = pos[index_luoyang][sub_luoyang].SubName;

    local city_dali = pos[index_dali][sub_dali].SceneName;
    local posx_dali = pos[index_dali][sub_dali].PosX;
    local posz_dali = pos[index_dali][sub_dali].PosZ;
    local sceneid_dali = pos[index_dali][sub_dali].SceneID;
    local SubName_dali = pos[index_dali][sub_dali].SubName;

    local strComplete = ScriptGlobal_Format("#{XBLFT_131112_38}",SubName_suzhou, posx_suzhou,posz_suzhou, SubName_luoyang, posx_luoyang,posz_luoyang,SubName_dali,posx_dali,posz_dali)

    return strComplete
end

-- [2017-元宵节猜灯谜活动]
function QuestLog_GetTarget_2017YXJCDM( nSelIndex )
	local Lanterns_Info =
	{
		{LanterID = 1, 	LanternDataID = "洛神牡丹灯笼", PosX = 175, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },
		{LanterID = 2, 	LanternDataID = "风花雪月灯笼", PosX = 171, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },
		{LanterID = 3, 	LanternDataID = "曲院风荷灯笼", PosX = 171, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 4, 	LanternDataID = "云栖竹径灯笼", PosX = 175, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 5, 	LanternDataID = "梅坞春早灯笼", PosX = 179, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 6, 	LanternDataID = "玉宇琼楼灯笼", PosX = 183, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 7, LanternDataID = "流水桃花灯笼", PosX = 187, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 8, LanternDataID = "三台云水灯笼", PosX = 191, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },	
		{LanterID = 9, LanternDataID = "湖滨晴雨灯笼", PosX = 195, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },	
		{LanterID = 10, LanternDataID = "柳浪闻莺灯笼", PosX = 195, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },	
		{LanterID = 11, LanternDataID = "花港观鱼灯笼", PosX = 191, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },		
	}
	
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 ) + 1
	if index > table.getn(Lanterns_Info) then
		index = table.getn(Lanterns_Info)
	end
	if index >= 1 and index <= table.getn(Lanterns_Info) then
		local str = ScriptGlobal_Format("#{YXCDM_161114_18}", Lanterns_Info[index].PosX, Lanterns_Info[index].PosZ, Lanterns_Info[index].LanternDataID, Lanterns_Info[index].LanternDataID)
		return str	
	else
		return ""
	end
	
end

-- [2017-元宵节猜灯谜活动]
function QuestLog_Complete_2017YXJCDM( nSelIndex)
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local str = ScriptGlobal_Format("#{YXCDM_161114_19}", index)
	return str	
end

-- [2017-元宵节猜灯谜活动]
function QuestLog_GetTrack_2017YXJCDM( nSelIndex )

	local Lanterns_Info =
	{
		{LanterID = 1, 	LanternDataID = "洛神牡丹灯笼", PosX = 175, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },
		{LanterID = 2, 	LanternDataID = "风花雪月灯笼", PosX = 171, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },
		{LanterID = 3, 	LanternDataID = "曲院风荷灯笼", PosX = 171, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 4, 	LanternDataID = "云栖竹径灯笼", PosX = 175, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 5, 	LanternDataID = "梅坞春早灯笼", PosX = 179, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 6, 	LanternDataID = "玉宇琼楼灯笼", PosX = 183, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 7, LanternDataID = "流水桃花灯笼", PosX = 187, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },
		{LanterID = 8, LanternDataID = "三台云水灯笼", PosX = 191, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },	
		{LanterID = 9, LanternDataID = "湖滨晴雨灯笼", PosX = 195, PosZ = 197, aiType = 3, sceneID = {0}, dir=0 },	
		{LanterID = 10, LanternDataID = "柳浪闻莺灯笼", PosX = 195, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },	
		{LanterID = 11, LanternDataID = "花港观鱼灯笼", PosX = 191, PosZ = 202, aiType = 3, sceneID = {0}, dir=3.14 },	
	}
	
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 ) + 1
	if index >= 1 and index <= table.getn(Lanterns_Info) then
		local str = ScriptGlobal_Format("#{YXCDM_161114_61}", Lanterns_Info[index].PosX, Lanterns_Info[index].PosZ, Lanterns_Info[index].LanternDataID, Lanterns_Info[index].LanternDataID)
		return str	
	else
		return ""
	end
	
end

-- !!!reloadscript =QuestLog
-- 星火生雁门任务1 任务目标
function QuestLog_GetTarget_XingHuoYanMen01( nSelIndex )
	local bFinish 			= DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local nProcessStepNum 	= DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local nNewProccessDay 	= DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	local nCurDay 		= tonumber(DataPool:GetServerDayTime())

	-- PushDebugMessage("bFinish:"..bFinish..",nProcessStepNum:"..nProcessStepNum..",nNewProccessDay:"..nNewProccessDay..",nCurDay:"..nCurDay)

	-- 未完成
	if nProcessStepNum < 1 then
		if nCurDay < nNewProccessDay then
			-- 阶段2
			return "#{XHSYM_20220426_74}"
		else
			-- 阶段3
			return "#{XHSYM_20220426_132}"
		end
	else
		-- 完成了
		if nCurDay < nNewProccessDay then
			-- 阶段2
			return "#{XHSYM_20220426_131}"
		else
			-- 阶段3
			return "#{XHSYM_20220426_137}"
		end
	end

	return ""
end

-- 星火生雁门任务1 任务完成提示
function QuestLog_Complete_XingHuoYanMen01( nSelIndex )

	local bFinish 			= DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local nProcessStepNum 	= DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local nNewProccessDay 	= DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	-- local nCurDay 		= tonumber(DataPool:GetServerDayTime())

	-- PushDebugMessage("bFinish:"..bFinish..",nProcessStepNum:"..nProcessStepNum..",nNewProccessDay:"..nNewProccessDay..",nCurDay:"..nCurDay)

	-- 未完成
	if 1 ~= nProcessStepNum then
		return ScriptGlobal_Format("#{XHSYM_20220426_75}",  0)
	end

	return ScriptGlobal_Format("#{XHSYM_20220426_75}", 1)
end

--//2021剧情任务-ypl -剧情1
function QuestLog_GetTarget_2021JuQing1( nSelIndex )

	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "    ".."#{YXDHYD_20210207_141}"--.."\r".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	if index == 0 then
		str = "    ".."#{YXDHYD_20210207_141}"--.."\r".."#{YXDHYD_20210207_141}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 1 then
		str = "    ".."#{YXDHYD_210224_01}"--.."\r".."#{YXDHYD_210224_02}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 2 then
		str = "    ".."#{YXDHYD_210224_04}"--.."\r".."#{YXDHYD_210224_05}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 2)
	elseif index == 3 then
		str = "    ".."#{YXDHYD_210224_06}"--.."\r".."#{YXDHYD_210224_07}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 4 then
		str = "    ".."#{YXDHYD_210224_08}"--.."\r".."#{YXDHYD_210224_09}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 5 then
		str = "    ".."#{YXDHYD_210224_10}"--.."\r".."#{YXDHYD_20210304_10}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 6 then
		str = "    ".."#{YXDHYD_210224_11}"--.."\r".."#{YXDHYD_210224_12}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 7 then
		str = "    ".."#{YXDHYD_210224_13}"--.."\r".."#{YXDHYD_210224_14}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	end
	
	return str	
	
end

--//2021剧情任务-ypl -剧情1
function QuestLog_Complete_2021JuQing1( nSelIndex)
	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "\n".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	if index == 0 then
		str = "\n".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 1 then
		str = "\n".."#{YXDHYD_210224_02}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 2 then
		str = "\n".."#{YXDHYD_210224_05}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 2)
	elseif index == 3 then
		str = "\n".."#{YXDHYD_210224_07}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 4 then
		str = "\n".."#{YXDHYD_210224_09}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 5 then
		str = "\n".."#{YXDHYD_20210304_10}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 6 then
		str = "\n".."#{YXDHYD_210224_12}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 7 then
		str = "\n".."#{YXDHYD_210224_14}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	end
	
	return str	
end

--//2021剧情任务-ypl -剧情1
function QuestLog_GetTrack_2021JuQing1( nSelIndex )

	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "#W".."#{YXDHYD_20210207_141}"--.."\r".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	
	if index == 0 then
		str = "#W".."#{YXDHYD_20210207_141}".."\n".."   ".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 1 then
		str = "#W".."#{YXDHYD_210224_01}".."\n".."   ".."#{YXDHYD_210224_02}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 2 then
		str = "#W".."#{YXDHYD_210224_04}".."\n".."   ".."#{YXDHYD_210224_05}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 2)
	elseif index == 3 then
		str = "#W".."#{YXDHYD_210224_06}".."\n".."   ".."#{YXDHYD_210224_07}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 4 then
		str = "#W".."#{YXDHYD_210224_08}".."\n".."   ".."#{YXDHYD_210224_09}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 5 then
		str = "#W".."#{YXDHYD_210224_10}".."\n".."   ".."#{YXDHYD_20210304_10}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 6 then
		str = "#W".."#{YXDHYD_210224_11}".."\n".."   ".."#{YXDHYD_210224_12}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 7 then
		str = "#W".."#{YXDHYD_210224_13}".."\n".."   ".."#{YXDHYD_210224_14}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	end
	
	return str	
	
end

--//2021剧情任务-ypl -剧情2
function QuestLog_GetTarget_2021JuQing2( nSelIndex )

	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "    ".."#{YXDHYD_20210207_223}"--.."\r".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	if index == 0 then
		str = "    ".."#{YXDHYD_20210207_223}"--.."\r".."#{YXDHYD_20210207_141}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 1 then
		str = "    ".."#{YXDHYD_210224_15}"--.."\r".."#{YXDHYD_210224_02}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 2 then
		str = "    ".."#{YXDHYD_210224_17}"--.."\r".."#{YXDHYD_210224_05}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 2)
	elseif index == 3 then
		str = "    ".."#{YXDHYD_210224_19}"--.."\r".."#{YXDHYD_210224_07}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	elseif index == 4 then
		str = "    ".."#{YXDHYD_210224_21}"--.."\r".."#{YXDHYD_210224_09}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 0, 1)
	end
	
	return str	
	
end

--//2021剧情任务-ypl -剧情2
function QuestLog_Complete_2021JuQing2( nSelIndex)
	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "\n".."#{YXDHYD_20210207_224}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	if index == 0 then
		str = "\n".."#{YXDHYD_20210207_224}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 1 then
		str = "\n".."#{YXDHYD_210224_16}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 2 then
		str = "\n".."#{YXDHYD_210224_18}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 3 then
		str = "\n".."#{YXDHYD_210224_20}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 4 then
		str = "\n".."#{YXDHYD_210224_22}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	end
	
	return str	
end

--//2021剧情任务-ypl -剧情2
function QuestLog_GetTrack_2021JuQing2( nSelIndex )

	local Finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
	local str = ""
	
	if Finish == 1 then
		str = "#W".."#{YXDHYD_20210207_223}"--.."\r".."#{YXDHYD_20210207_142}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", 1, 1)
		return str
	end
	
	str = ""
	
	if index == 0 then
		str = "#W".."#{YXDHYD_20210207_223}".."\n".."   ".."#{YXDHYD_20210207_224}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 1 then
		str = "#W".."#{YXDHYD_210224_15}".."\n".."   ".."#{YXDHYD_210224_16}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 2 then
		str = "#W".."#{YXDHYD_210224_17}".."\n".."   ".."#{YXDHYD_210224_18}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 3 then
		str = "#W".."#{YXDHYD_210224_19}".."\n".."   ".."#{YXDHYD_210224_20}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	elseif index == 4 then
		str = "#W".."#{YXDHYD_210224_21}".."\n".."   ".."#{YXDHYD_210224_22}"..ScriptGlobal_Format("#{YXDHYD_210224_03}", param2, 1)
	end
	
	return str	
	
end

--天赋引导任务-2021 by yuanpeilong：任务2
function QuestLog_GetTarget_2021TianFu2(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str = ""
	if menpaiID == 0 then
		str = "#{TFYD_210729_47}"
	elseif menpaiID == 1 then 
		str = "#{TFYD_210729_48}"
	elseif menpaiID == 2 then 
		str = "#{TFYD_210729_49}"
	elseif menpaiID == 3 then 
		str = "#{TFYD_210729_50}"
	elseif menpaiID == 4 then 
		str = "#{TFYD_210729_51}"
	elseif menpaiID == 5 then 
		str = "#{TFYD_210729_52}"
	elseif menpaiID == 6 then 
		str = "#{TFYD_210729_53}"
	elseif menpaiID == 7 then 
		str = "#{TFYD_210729_54}"
	elseif menpaiID == 8 then 
		str = "#{TFYD_210729_55}"
	elseif menpaiID == 10 then 
		str = "#{TFYD_220523_4}"			
	end
	
	return ScriptGlobal_Format("#{TFYD_210729_17}", str)
	
end

--天赋引导任务-2021 by yuanpeilong：任务2
function QuestLog_Complete_2021TianFu2(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str = ""
	if menpaiID == 0 then
		str = "#{TFYD_210729_73}"
	elseif menpaiID == 1 then 
		str = "#{TFYD_210729_74}"
	elseif menpaiID == 2 then 
		str = "#{TFYD_210729_75}"
	elseif menpaiID == 3 then 
		str = "#{TFYD_210729_76}"
	elseif menpaiID == 4 then 
		str = "#{TFYD_210729_77}"
	elseif menpaiID == 5 then 
		str = "#{TFYD_210729_78}"
	elseif menpaiID == 6 then 
		str = "#{TFYD_210729_79}"
	elseif menpaiID == 7 then 
		str = "#{TFYD_210729_80}"
	elseif menpaiID == 8 then 
		str = "#{TFYD_210729_81}"
	elseif menpaiID == 10 then 
		str = "#{TFYD_220523_5}"		
	end

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_56}", str, param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务2
function QuestLog_GetTrack_2021TianFu2(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str = ""
	local str2 = ""
	local str4 = ""
	if menpaiID == 0 then
		str = "#{TFYD_210729_47}"
		str2 = "#{TFYD_210729_73}"
		str4 = "#{TFYD_210729_237}"
	elseif menpaiID == 1 then 
		str = "#{TFYD_210729_48}"
		str2 = "#{TFYD_210729_74}"
		str4 = "#{TFYD_210729_238}"
	elseif menpaiID == 2 then 
		str = "#{TFYD_210729_49}"
		str2 = "#{TFYD_210729_75}"
		str4 = "#{TFYD_210729_239}"
	elseif menpaiID == 3 then 
		str = "#{TFYD_210729_50}"
		str2 = "#{TFYD_210729_76}"
		str4 = "#{TFYD_210729_240}"
	elseif menpaiID == 4 then 
		str = "#{TFYD_210729_51}"
		str2 = "#{TFYD_210729_77}"
		str4 = "#{TFYD_210729_241}"
	elseif menpaiID == 5 then 
		str = "#{TFYD_210729_52}"
		str2 = "#{TFYD_210729_78}"
		str4 = "#{TFYD_210729_242}"
	elseif menpaiID == 6 then 
		str = "#{TFYD_210729_53}"
		str2 = "#{TFYD_210729_79}"
		str4 = "#{TFYD_210729_243}"
	elseif menpaiID == 7 then 
		str = "#{TFYD_210729_54}"
		str2 = "#{TFYD_210729_80}"
		str4 = "#{TFYD_210729_244}"
	elseif menpaiID == 8 then 
		str = "#{TFYD_210729_55}"
		str2 = "#{TFYD_210729_81}"
		str4 = "#{TFYD_210729_245}"	
	elseif menpaiID == 10 then 
		str = "#{TFYD_220523_4}"
		str2 = "#{TFYD_220523_5}"
		str4 = "#{TFYD_220523_6}"			
	end
	
	local str3 = ScriptGlobal_Format("#{TFYD_210729_56}", str2, param1)
	
	if str4 == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str4 = "#W"..ScriptGlobal_Format("#{TFYD_210729_57}", str).."\n".."   "..str3
	end
	
	if param0 == 1 then
		return str4
	else
		return "#W"..ScriptGlobal_Format("#{TFYD_210729_57}", str).."\n".."   "..str3
	end
	
end

--天赋引导任务-2021 by yuanpeilong：任务3
function QuestLog_GetTarget_2021TianFu3(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	
	return "    "..ScriptGlobal_Format("#{TFYD_210729_58}", str)
	
end

--天赋引导任务-2021 by yuanpeilong：任务3
function QuestLog_Complete_2021TianFu3(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_59}", param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务3
function QuestLog_GetTrack_2021TianFu3(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str = QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)
	if str == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str = "#W"..ScriptGlobal_Format("#{TFYD_210729_59}", param1)
	end
	
	if param0 == 1 then
		return str
	else
		return "#W"..ScriptGlobal_Format("#{TFYD_210729_60}", param1)
	end
	
end

--天赋引导任务-2021 by yuanpeilong：获取9大门派武论长老的名字
--任务目标用
function QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)

	local str = ""
	if menpaiID == 0 then
		str = "#{TFYD_210729_120}"
	elseif menpaiID == 1 then 
		str = "#{TFYD_210729_121}"
	elseif menpaiID == 2 then 
		str = "#{TFYD_210729_122}"
	elseif menpaiID == 3 then 
		str = "#{TFYD_210729_123}"
	elseif menpaiID == 4 then 
		str = "#{TFYD_210729_124}"
	elseif menpaiID == 5 then 
		str = "#{TFYD_210729_125}"
	elseif menpaiID == 6 then 
		str = "#{TFYD_210729_126}"
	elseif menpaiID == 7 then 
		str = "#{TFYD_210729_127}"
	elseif menpaiID == 8 then 
		str = "#{TFYD_210729_128}"
	elseif menpaiID == 10 then 
		str = "#{TFYD_220523_10}"		
	end
	
	return str
	
end

--天赋引导任务-2021 by yuanpeilong：获取9大门派武论长老的名字
--任务追踪用
function QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)

	local str = ""
	if menpaiID == 0 then
		str = "#{TFYD_210729_227}"
	elseif menpaiID == 1 then 
		str = "#{TFYD_210729_228}"
	elseif menpaiID == 2 then 
		str = "#{TFYD_210729_229}"
	elseif menpaiID == 3 then 
		str = "#{TFYD_210729_230}"
	elseif menpaiID == 4 then 
		str = "#{TFYD_210729_231}"
	elseif menpaiID == 5 then 
		str = "#{TFYD_210729_232}"
	elseif menpaiID == 6 then 
		str = "#{TFYD_210729_233}"
	elseif menpaiID == 7 then 
		str = "#{TFYD_210729_234}"
	elseif menpaiID == 8 then 
		str = "#{TFYD_210729_235}"	
	elseif menpaiID == 10 then 
		str = "#{TFYD_220523_11}"			
	end
	
	return str
	
end
 
--天赋引导任务-2021 by yuanpeilong：任务4
function QuestLog_GetTarget_2021TianFu4(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str1 = ""
	local str2 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	if menpaiID == 0 then
		str1 = "#{TFYD_210729_218}"
	elseif menpaiID == 1 then 
		str1 = "#{TFYD_210729_219}"
	elseif menpaiID == 2 then 
		str1 = "#{TFYD_210729_220}"
	elseif menpaiID == 3 then 
		str1 = "#{TFYD_210729_221}"
	elseif menpaiID == 4 then 
		str1 = "#{TFYD_210729_222}"
	elseif menpaiID == 5 then 
		str1 = "#{TFYD_210729_223}"
	elseif menpaiID == 6 then 
		str1 = "#{TFYD_210729_224}"
	elseif menpaiID == 7 then 
		str1 = "#{TFYD_210729_225}"
	elseif menpaiID == 8 then 
		str1 = "#{TFYD_210729_226}"	
	elseif menpaiID == 10 then 
		str1 = "#{TFYD_220523_18}"			
	end
	
	return "    "..ScriptGlobal_Format("#{TFYD_210729_61}", str1, str2)
	
end

--天赋引导任务-2021 by yuanpeilong：任务4
function QuestLog_Complete_2021TianFu4(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_62}", param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务4
function QuestLog_GetTrack_2021TianFu4(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str1 = ""
	if menpaiID == 0 then
		str1 = "#{TFYD_210729_218}"
	elseif menpaiID == 1 then 
		str1 = "#{TFYD_210729_219}"
	elseif menpaiID == 2 then 
		str1 = "#{TFYD_210729_220}"
	elseif menpaiID == 3 then 
		str1 = "#{TFYD_210729_221}"
	elseif menpaiID == 4 then 
		str1 = "#{TFYD_210729_222}"
	elseif menpaiID == 5 then 
		str1 = "#{TFYD_210729_223}"
	elseif menpaiID == 6 then 
		str1 = "#{TFYD_210729_224}"
	elseif menpaiID == 7 then 
		str1 = "#{TFYD_210729_225}"
	elseif menpaiID == 8 then 
		str1 = "#{TFYD_210729_226}"	
	elseif menpaiID == 10 then 
		str1 = "#{TFYD_220523_18}"			
	end
	
	local str2 = QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)
	if str2 == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str2 = "#W"..ScriptGlobal_Format("#{TFYD_210729_63}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_62}", param1)
	end
	
	if param0 == 1 then
		return str2
	else
		return "#W"..ScriptGlobal_Format("#{TFYD_210729_63}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_62}", param1)
	end
	
end


--天赋引导任务-2021 by yuanpeilong：任务5
function QuestLog_GetTarget_2021TianFu5(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str2 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	
	return "    "..ScriptGlobal_Format("#{TFYD_210729_65}", str2)
	
end

--天赋引导任务-2021 by yuanpeilong：任务5
function QuestLog_Complete_2021TianFu5(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_372}", param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务5
function QuestLog_GetTrack_2021TianFu5(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str1 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	local str2 = QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)
	if str2 == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str2 = "#W"..ScriptGlobal_Format("#{TFYD_210729_66}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_372}", param1)
	end
	
	if param0 == 1 then
		return str2
	else
		return "#W"..ScriptGlobal_Format("#{TFYD_210729_66}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_372}", param1)
	end
	
end

--天赋引导任务-2021 by yuanpeilong：任务6
function QuestLog_GetTarget_2021TianFu6(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str2 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	
	return "    "..ScriptGlobal_Format("#{TFYD_210729_67}", str2)
	
end

--天赋引导任务-2021 by yuanpeilong：任务6
function QuestLog_Complete_2021TianFu6(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_440}", param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务6
function QuestLog_GetTrack_2021TianFu6(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")	
	local str2 = QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)
	if str2 == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str2 = "#W".."#{TFYD_210729_68}".."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_440}", param1)
	end
	
	if param0 == 1 then
		return str2
	else
		return "#W".."#{TFYD_210729_68}".."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_440}", param1)
	end
	
end

--天赋引导任务-2021 by yuanpeilong：任务7
function QuestLog_GetTarget_2021TianFu7(nSelIndex)

	local menpaiID = Player : GetData("MEMPAI")
	local str2 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	
	return "    "..ScriptGlobal_Format("#{TFYD_210729_69}", str2)
	
end

--天赋引导任务-2021 by yuanpeilong：任务7
function QuestLog_Complete_2021TianFu7(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "\n"..ScriptGlobal_Format("#{TFYD_210729_518}", param1)
	
end

--天赋引导任务-2021 by yuanpeilong：任务7
function QuestLog_GetTrack_2021TianFu7(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	
	local menpaiID = Player : GetData("MEMPAI")
	local str1 = QuestLog_GetMenPaiWuLunNpcInfo(menpaiID)
	local str2 = QuestLog_GetMenPaiWuLunNpcTrackInfo(menpaiID)
	if str2 == "" then
		--做一个容错吧，万一nil了，返回一个常态的文字
		str2 = "#W"..ScriptGlobal_Format("#{TFYD_210729_70}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_518}", param1)
	end
	
	if param0 == 1 then
		return str2
	else
		return "#W"..ScriptGlobal_Format("#{TFYD_210729_70}", str1).."\n".."    "..ScriptGlobal_Format("#{TFYD_210729_518}", param1)
	end
	
end

--//2022兽魂版本预热-ypl
function QuestLog_GetTarget_2022PetYuRe(nSelIndex)
	local Caiji_Info = {
		[1] = {posx=191, posz=57, str="#{YRJDE_20220309_49}"},
		[2] = {posx=148, posz=132, str="#{YRJDE_20220309_50}"},
		[3] = {posx=49, posz=127, str="#{YRJDE_20220309_51}"},
	}
	
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	if index >= 1 and index <= table.getn(Caiji_Info) then
		local str = ScriptGlobal_Format("#{YRJDE_20220309_20}", Caiji_Info[index].str)
		return str	
	else
		return ""
	end
end

--//2022兽魂版本预热-ypl
function QuestLog_Complete_2022PetYuRe(nSelIndex)
	local index = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local str = ScriptGlobal_Format("#{YRJDE_20220309_21}", index)
	return str	
end

--//2022兽魂版本预热-ypl
function QuestLog_GetTrack_2022PetYuRe(nSelIndex)
	local Caiji_Info = {
		[1] = {posx=191, posz=57, str="#{YRJDE_20220309_49}"},
		[2] = {posx=148, posz=132, str="#{YRJDE_20220309_50}"},
		[3] = {posx=49, posz=127, str="#{YRJDE_20220309_51}"},
	}
	
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return "#{YRJDE_20220309_53}"
	else
		local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
		local index = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
		if index >= 1 and index <= table.getn(Caiji_Info) then
			local str = ScriptGlobal_Format("#{YRJDE_20220309_52}", Caiji_Info[index].str, param1) --.."\n".."    "..QuestLog_Complete_2022PetYuRe(nSelIndex)
			return str	
		else
			return ""
		end
	end
end

--2021Q4十一月感恩节火鸡打卡活动
function QuestLog_GetTrack_2021HuoJiDaKa(nSelIndex)
--	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	local msgtip = {"#{GEHJ_211015_74}","#{GEHJ_211015_75}","#{GEHJ_211015_76}"}
	return "\n"..ScriptGlobal_Format("#{GEHJ_211015_17}", msgtip[param2])
	
end

--2022Q1应景打卡
function QuestLog_GetTrack_2022Q1QTESignIn(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local msgtip = {"#{BBYJ_220104_11}","#{BBYJ_220104_12}","#{BBYJ_220104_13}"}
	if msgtip[param1] ~= nil then
		return "\n"..ScriptGlobal_Format(msgtip[param1], param2)
	else
		return "\n"..ScriptGlobal_Format(msgtip[1], param2)
	end
end

--2022Q1应景打卡
function QuestLog_Complete_2022Q1QTESignIn(nSelIndex)

	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	return "\n"..ScriptGlobal_Format("#{BBYJ_220104_14}", param2)
	
end
function QuestLog_GetTarget_2022Q2CaiDan5(nSelIndex)
	local nCurDay = tonumber(DataPool:GetServerDayTime());
	if nCurDay <= 20220703 then
		return "#{XRDK_220428_332}"
	else
		return "#{XRDK_220428_400}"
	end
end

function QuestLog_GetTarget_ShenFenTuPo(nSelIndex)

--	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )--数量
--	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )--需要道具id
	local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )--需要道具count
	
--	local itemname = DataPool:LuaFnGetItemNameByTableIndex(param2)

	return "\n"..ScriptGlobal_Format("#{YCGZ_231225_82}", param3 )
	
end

function QuestLog_Complete_ShenFenTuPo(nSelIndex)

	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )--数量
	--local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )--需要道具id
	local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )--需要道具count
	
	--local itemname = DataPool:LuaFnGetItemNameByTableIndex(param2)

	return "\n"..ScriptGlobal_Format("#{YCGZ_231225_13}", param1, param3 )
	
end
function QuestLog_GetTarget_Roman(nSelIndex)
	local posIdx = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	local dictArr = {
		"#{QYHY_230330_115}",
		"#{QYHY_230330_116}",
		"#{QYHY_230330_117}",
		"#{QYHY_230330_118}",
		"#{QYHY_230330_119}",
		"#{QYHY_230330_120}",
		"#{QYHY_230330_121}",
		"#{QYHY_230330_122}",
		"#{QYHY_230330_123}",
		"#{QYHY_230330_124}",
		}
	if posIdx <= 10 and posIdx >= 1 then
		return ScriptGlobal_Format("#{QYHY_230330_49}", dictArr[posIdx])
	else
		return " "
	end
end

function QuestLog_Complete_TXDaGongTu(nSelIndex)
	local bFinished = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param={0,0,0,0,0}
	local processtotal = 0
	for i=1,5 do
		param[i] = DataPool:GetPlayerMission_Variable( nSelIndex, 3+i-1 )
		processtotal = processtotal + math.floor(param[i]/10)
	end
	return "\n"..ScriptGlobal_Format("#{CJDG_221110_32}", bFinished, processtotal)
end
function QuestLog_GetTarget_2022Q2XYPCA(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )

	local lvyanidx = {math.floor(param1/10),math.floor(param2/10),math.floor(param3/10)}
	local strMissionLvYan = {	"#{XRDK_220428_383}","#{XRDK_220428_384}","#{XRDK_220428_385}","#{XRDK_220428_386}"}
	return ScriptGlobal_Format("#{XRDK_220428_163}",strMissionLvYan[lvyanidx[1]],strMissionLvYan[lvyanidx[2]],strMissionLvYan[lvyanidx[3]])
end

function QuestLog_Complete_2022Q2XYPCA(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )

	local lvyanidx = {math.floor(param1/10),math.floor(param2/10),math.floor(param3/10)}
	local lvyanpro = {math.mod(param1,10),math.mod(param2,10),math.mod(param3,10)}
	local strMissionLvYan = {	"#{XRDK_220428_383}","#{XRDK_220428_384}","#{XRDK_220428_385}","#{XRDK_220428_386}"}
	return "\n"..ScriptGlobal_Format("#{XRDK_220428_164}",strMissionLvYan[lvyanidx[1]],lvyanpro[1],strMissionLvYan[lvyanidx[2]],lvyanpro[2],strMissionLvYan[lvyanidx[3]],lvyanpro[3])
end
function QuestLog_Complete_PaoShang(nSelIndex)
	local g_MF_PAOSHANG_TIMEOVER=731
	if DataPool:LuaFnGetMF(g_MF_PAOSHANG_TIMEOVER)==0 then
		return "#{PSGN_180515_220}"
	else
		return "#{PSGN_180515_221}"
	end
end
function QuestLog_GetTarget_GCJW(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	return "\n"..ScriptGlobal_Format("#{GCJW_221017_28}", param1,param2)
end
function QuestLog_Complete_GCJW(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	return "\n"..ScriptGlobal_Format("#{GCJW_221017_28}", param1,param2)
end
function QuestLog_Complete_CoupleWeeklyMission2(nSelIndex)
	local type =    DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local needNum = DataPool:GetPlayerMission_Variable( nSelIndex, 3 ) 
	local num =     DataPool:GetPlayerMission_Variable( nSelIndex, 4 ) 
	local str = "err"
	if type == 818 then
		str = ScriptGlobal_Format("#{FQZC_230331_74}", num,needNum)
	elseif type == 817 then
		str = ScriptGlobal_Format("#{FQZC_230331_100}", num,needNum)
	elseif type == 816 then
		str = ScriptGlobal_Format("#{FQZC_230331_101}", num,needNum)
	end
	return str
end

function QuestLog_Complete_PreHeatMission1(nSelIndex)
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 5)
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 6)
	local total = 0
	for i = 1, 3 do
		if DataPool:GetPlayerMission_Variable( nSelIndex, i) == 1 then
			total = total + 1
		end
	end
	local str = ScriptGlobal_Format("#{SFYR_240104_35}", param1).."#r"..ScriptGlobal_Format("#{SFYR_240104_92}", param2).."#r"..ScriptGlobal_Format("#{SFYR_240104_93}", total).."#r"..ScriptGlobal_Format("#{SFYR_240104_185}", done)

	return str
end

function QuestLog_GetTrack_PreHeatMission1(nSelIndex)
	
	local process = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 6 )
	
	if done == 1 then
		return "#{SFYR_240104_94}"
	else
		if process == 0 then
			return "#{SFYR_240104_36}".."#r"..ScriptGlobal_Format("#{SFYR_240104_37}", param1)
		elseif process == 1 then
			return "#{SFYR_240104_186}".."#r"..ScriptGlobal_Format("#{SFYR_240104_187}", param2)
		elseif process == 2 then
			local total = 0
			for i = 1, 3 do
				if DataPool:GetPlayerMission_Variable( nSelIndex, i) == 1 then
					total = total + 1
				end
			end
			return "#{SFYR_240104_189}".."#r"..ScriptGlobal_Format("#{SFYR_240104_190}", total).."#r"..ScriptGlobal_Format("#{SFYR_240104_188}", done)
		end
	end
end

function QuestLog_GetTrack_PreHeatMission2(nSelIndex)
	
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return "#{SFYR_240104_132}"
	else
		return "#{SFYR_240104_191}".."#r"..ScriptGlobal_Format("#{SFYR_240104_131}", 0)
	end
end

function QuestLog_GetTrack_PreHeatMission3(nSelIndex)
	
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return "#{SFYR_240104_148}"
	else
		local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
		return "#{SFYR_240104_146}".."#r"..ScriptGlobal_Format("#{SFYR_240104_147}", param1)
	end
end

function QuestLog_GetTrack_PreHeatMission4(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return "#{SFYR_240104_161}"
	else
		if param1 == 1 then
			return "#{SFYR_240104_160}".."#r"..ScriptGlobal_Format("#{SFYR_240104_159}", 0)
		else
			local total = 0
			
			if DataPool:GetPlayerMission_Variable( nSelIndex, 2 ) == 1 then
				total = total + 1
			end
			if DataPool:GetPlayerMission_Variable( nSelIndex, 4 ) == 1 then
				total = total + 1
			end

			return "#{SFYR_240104_164}".."#r"..ScriptGlobal_Format("#{SFYR_240104_163}", total)
		end
		
	end
end

function QuestLog_GetTarget_PreHeatMission4(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	if param1 == 1 then
		return "#{SFYR_240104_158}"
	else
		return "#{SFYR_240104_162}"
	end
end

function QuestLog_Complete_PreHeatMission4(nSelIndex)
	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	if param1 == 1 then
		local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
		return ScriptGlobal_Format("#{SFYR_240104_159}", done)
	else
		local total = 0
		if DataPool:GetPlayerMission_Variable( nSelIndex, 2 ) == 1 then
			total = total + 1
		end
		if DataPool:GetPlayerMission_Variable( nSelIndex, 4 ) == 1 then
			total = total + 1
		end
		return ScriptGlobal_Format("#{SFYR_240104_163}", total)
	end
end

-- 【2024Q2】新版本预热-山重水复
function QuestLog_Complete_2024Q2PM_Mission1(nSelIndex)
	local done = DataPool:GetPlayerMission_Variable(nSelIndex, 0)
	local targetStr = ""
	if done ~= 1 then
		local param1 = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
		local param2 = DataPool:GetPlayerMission_Variable(nSelIndex, 2)
		targetStr = ScriptGlobal_Format("#{JJFY_240407_80}",param1) .. "#r" .. ScriptGlobal_Format("#{JJFY_240407_81}",param2)
	else
		targetStr = ScriptGlobal_Format("#{JJFY_240407_177}",0)
	end
	return "#r"..targetStr
end
function QuestLog_Complete_2024Q2PM_Mission2(nSelIndex)
	local done = DataPool:GetPlayerMission_Variable(nSelIndex, 0)
	local targetStr = ""
	if done ~= 1 then
		--修补材料
		local nMaterialCount = 0
		for i,nItemID in {40005164,40005165,40005166} do
			local nMaterialNum = DataPool : GetPlayerMission_ItemCountNow(nItemID)
			if nMaterialNum > 0 then
				nMaterialCount  = nMaterialCount + 1
			end
		end
		local param1 = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
		targetStr = ScriptGlobal_Format("#{JJFY_240407_175}",nMaterialCount) .. "#r" .. ScriptGlobal_Format("#{JJFY_240407_126}",param1)
	else
		targetStr = ScriptGlobal_Format("#{JJFY_240407_177}", 0)
	end
	return "#r"..targetStr
end
function QuestLog_Complete_2024Q2PM_Mission3(nSelIndex)
	local done = DataPool:GetPlayerMission_Variable(nSelIndex, 0)
	local targetStr = ""
	local param1 = DataPool:GetPlayerMission_Variable(nSelIndex, 1)
	targetStr = ScriptGlobal_Format("#{JJFY_240407_145}",param1)
	
	return "#r"..targetStr
end
function QuestLog_Complete_2024Q2PM_Mission4(nSelIndex)
	local done = DataPool:GetPlayerMission_Variable(nSelIndex, 0)
	local targetStr = ""
	if done ~= 1 then
		local nStep01 = DataPool:GetPlayerMission_Variable(nSelIndex, 1)	
		if nStep01 == 0 then
			targetStr = ScriptGlobal_Format("#{JJFY_240407_178}", nStep01)
		else
			local count = 0
			if DataPool:GetPlayerMission_Variable(nSelIndex, 2) ~= 0 then
				count = count + 1
			end
			if DataPool:GetPlayerMission_Variable(nSelIndex, 3) ~= 0 then
				count = count + 1
			end
			if DataPool:GetPlayerMission_Variable(nSelIndex, 4) ~= 0 then
				count = count + 1
			end
			if count < 3 then
				targetStr = ScriptGlobal_Format("#{JJFY_240407_155}",count)
			else
				targetStr = ScriptGlobal_Format("#{JJFY_240407_178}", 0)
			end	
		end
	else
		targetStr = ScriptGlobal_Format("#{JJFY_240407_178}", 0)
	end
	return "#r"..targetStr
end
-- 【2024Q2】新版本预热-山重水复 结束

function QuestLog_Complete_LongHaiZi(nSelIndex)
	local scnIndex = DataPool:GetPlayerMission_Variable(nSelIndex,2); --任务所在场景
	local clueIndex = DataPool:GetPlayerMission_Variable(nSelIndex,4); --任务所在场景
	local tableclues = { --洛阳
		"#{LNDK_231025_25}","#{LNDK_231025_26}","#{LNDK_231025_27}","#{LNDK_231025_28}",
	}
	if scnIndex == 1 then --苏州
		tableclues = {
			"#{LNDK_231025_33}","#{LNDK_231025_34}","#{LNDK_231025_35}","#{LNDK_231025_36}",
		}
	elseif scnIndex == 2 then --大理
		tableclues = {
			"#{LNDK_231025_29}","#{LNDK_231025_30}","#{LNDK_231025_31}","#{LNDK_231025_32}",
		}	
	end
	return tableclues[math.floor((clueIndex+2)/3)] or "error"..scnIndex..clueIndex
end

function QuestLog_TCJL(nSelIndex)
	
	local curDayIndex = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	local curDayId = math.mod(curDayIndex-1, 3) + 1
	local strDic = { [1] = "#{TCJL_20240109_54}",[2] = "#{TCJL_20240109_149}",[3] = "#{TCJL_20240109_150}", }
	if strDic[curDayId] ~= nil then
		return strDic[curDayId]
	end

	return ""
end

--function QuestLog_GetTrack_CleanForNewYear(nSelIndex)
--
--	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
--	local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
--	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
--	local p1=math.floor(param0/1000)
--	local p2=math.mod(param0,1000)
--	local p2=math.floor(param1/1000)
--	local p3=math.mod(param1,1000)
--	local p4=math.floor(param2/1000)
--	local p5=math.mod(param2,1000)
--	local PosInfo={"#{CCYXN_20211202_50}","#{CCYXN_20211202_51}","#{CCYXN_20211202_52}","#{CCYXN_20211202_53}",
--								"#{CCYXN_20211202_54}","#{CCYXN_20211202_55}","#{CCYXN_20211202_56}","#{CCYXN_20211202_57}",
--								"#{CCYXN_20211202_58}","#{CCYXN_20211202_59}","#{CCYXN_20211202_60}","#{CCYXN_20211202_61}"}
--	local str=ScriptGlobal_Format("#{CCYXN_20211202_49}", PosInfo[math.mod(p1,100)],PosInfo[math.mod(p2,100)],PosInfo[math.mod(p3,100)],PosInfo[math.mod(p4,100)],PosInfo[math.mod(p5,100)],PosInfo[math.mod(p6,100)])
--	return str
--end
function QuestLog_Complete_CleanForNewYear(nSelIndex)
	local nCanGo = {}
	local nPosIdx = {}
	local bDone = {}
	for i=1,6 do
		nCanGo[i] = DataPool:GetPlayerMission_Variable( nSelIndex, i )
		nPosIdx[i]=math.mod(nCanGo[i],100)
		bDone[i]=math.floor(nCanGo[i]/100)
	end
	local PosInfo={"#{CCYXN_20211202_50}","#{CCYXN_20211202_51}","#{CCYXN_20211202_52}","#{CCYXN_20211202_53}",
								"#{CCYXN_20211202_54}","#{CCYXN_20211202_55}","#{CCYXN_20211202_56}","#{CCYXN_20211202_57}",
								"#{CCYXN_20211202_58}","#{CCYXN_20211202_59}","#{CCYXN_20211202_60}","#{CCYXN_20211202_61}"}
	--	已完成除尘：#r#G%s0#W：#G%s1#W/1#r#G%s2#W：#G%s3#W/1#r#G%s4#W：#G%s5#W/1#r#G%s6#W：#G%s7#W/1#r#G%s8#W：#G%s9#W/1#r#G%s10#W：#G%s11#W/1
	local str="#r".."#{CCYXN_20211202_13}"
	for i=1,6 do
		str=str.."#r"
		str=str..PosInfo[nPosIdx[i]].."："..bDone[i].." / 1"
	end
--	local str=ScriptGlobal_Format("#{CCYXN_20211202_13}",PosInfo[nPosIdx[1]],bDone[1],PosInfo[nPosIdx[2]],bDone[2],PosInfo[nPosIdx[3]],bDone[3],
--							PosInfo[nPosIdx[4]],bDone[4],PosInfo[nPosIdx[5]],bDone[5],PosInfo[nPosIdx[6]],bDone[6])
	return str
end
--================================================
-- 恢复界面的默认相对位置
--================================================
function QuestLog_Frame_On_ResetPos()

	QuestLog_Frame : SetProperty("UnifiedXPosition", g_QuestLog_Frame_UnifiedXPosition);
	QuestLog_Frame : SetProperty("UnifiedYPosition", g_QuestLog_Frame_UnifiedYPosition);

end

--雪球欢乐季 移植
function QuestLog_GetHLXQJComplete( nSelIndex )
	local AlreadyPlay = {}

	AlreadyPlay[1] = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	AlreadyPlay[2] = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	AlreadyPlay[3] = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	AlreadyPlay[4] = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	AlreadyPlay[5] = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )

	local MenPaiList = {
		[0] = { id = 0, rate = 10, name = "#{XQ_MP_1}" },    --少林
		[1] = { id = 1, rate = 20, name = "#{XQ_MP_2}" },    --明教
		[2] = { id = 2, rate = 30, name = "#{XQ_MP_3}" },    --丐帮
		[3] = { id = 3, rate = 40, name = "#{XQ_MP_4}" },    --武当
		[4] = { id = 4, rate = 50, name = "#{XQ_MP_5}" },    --峨眉
		[5] = { id = 5, rate = 60, name = "#{XQ_MP_6}" },    --星宿
		[6] = { id = 6, rate = 70, name = "#{XQ_MP_7}" },    --天龙
		[7] = { id = 7, rate = 80, name = "#{XQ_MP_8}" },    --天山
		[8] = { id = 8, rate = 90, name = "#{XQ_MP_9}" },    --逍遥
	  [9] = { id = 9, rate = 0, name = "" },               --无门派
	  [10] = { id = 10, rate = 100, name = "#{XQ_MP_16}" },--曼陀
	}

	local strComplete = ""

	for i = 1, 5 do
		local aimMenpai = 0
		local isDone = 1
		if AlreadyPlay[i] >= 100 then
			aimMenpai = 1
			AlreadyPlay[i] = AlreadyPlay[i] - 100
		end
        local temp_str = "#{XQ_MP_11}"..MenPaiList[AlreadyPlay[i]].name.."#{XQ_MP_12}".." "..tostring( aimMenpai ).."/"..tostring( isDone )
        strComplete = strComplete..temp_str.."\n"
	end

	return strComplete
end

--雪球欢乐季 移植
function QuestLog_GetHLXQJTarget( nSelIndex )
	local AlreadyPlay = {}

  AlreadyPlay[1] = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	AlreadyPlay[2] = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	AlreadyPlay[3] = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	AlreadyPlay[4] = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
	AlreadyPlay[5] = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )

    for i = 1, 5 do
        if AlreadyPlay[i] >= 100 then
            AlreadyPlay[i] = AlreadyPlay[i] - 100
        end
    end

	local MenPaiList = {
		[0] = { id = 0, rate = 10, name = "#{XQ_MP_1}" },    --少林
		[1] = { id = 1, rate = 20, name = "#{XQ_MP_2}" },    --明教
		[2] = { id = 2, rate = 30, name = "#{XQ_MP_3}" },    --丐帮
		[3] = { id = 3, rate = 40, name = "#{XQ_MP_4}" },    --武当
		[4] = { id = 4, rate = 50, name = "#{XQ_MP_5}" },    --峨眉
		[5] = { id = 5, rate = 60, name = "#{XQ_MP_6}" },    --星宿
		[6] = { id = 6, rate = 70, name = "#{XQ_MP_7}" },    --天龙
		[7] = { id = 7, rate = 80, name = "#{XQ_MP_8}" },    --天山
		[8] = { id = 8, rate = 90, name = "#{XQ_MP_9}" },    --逍遥
	  [9] = { id = 9, rate = 0, name = "" },         			 --无门派
	  [10] = { id = 10, rate = 100, name = "#{XQ_MP_16}" },--曼陀
	}

	local strComplete = ""

	strComplete = "#{XQHLJ_101108_59}"..MenPaiList[AlreadyPlay[1]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[2]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[3]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[4]].name.."#{XQHLJ_101108_65}"..MenPaiList[AlreadyPlay[5]].name.."#{XQHLJ_101108_60}"

	return strComplete
end

function QuestLog_XuanChuanYXDH_State( nSelIndex )

	local MenPaiList = {
		[0] = "#{BFHX_210203_07}",    --少林
		[1] = "#{BFHX_210203_13}",    --明教
		[2] = "#{BFHX_210203_12}",    --丐帮
		[3] = "#{BFHX_210203_14}",    --武当
		[4] = "#{BFHX_210203_08}",    --峨眉
		[5] = "#{BFHX_210203_11}",    --星宿
		[6] = "#{BFHX_210203_10}",    --天龙
		[7] = "#{BFHX_210203_09}",    --天山
		[8] = "#{BFHX_210203_15}",     --逍遥
		[9] = "",     --无门派
		[10] = "#{GMGameInterface_Script_DataPool_Info_ManTuoShanZhuang1}",     --曼陀山庄
	}

	local strComplete = "\n"

	for i = 1, 5 do
		local menpaiId = DataPool:GetPlayerMission_VariableByByte( nSelIndex, i, 0 )
		local isDone = DataPool:GetPlayerMission_VariableByByte( nSelIndex, i, 1 )
        local temp_str = MenPaiList[menpaiId].." : "..tostring(isDone).." / 1"
		strComplete = strComplete..temp_str
		if i ~= 5 then
			strComplete = strComplete.."\n"
		end
	end

	return strComplete
end

-- [2022Q3]拉镖周常活动设计
function QuestLog_GetGuardCarData( cartype )
	local carname = ""
	local destname = ""
	local tCarData = 
	{
		[1] = {dsname="#{LBZC_220810_73}", cname="#{LBZC_220810_78}", },
		[2] = {dsname="#{LBZC_220810_75}", cname="#{LBZC_220810_79}", },
		[3] = {dsname="#{LBZC_220810_74}", cname="#{LBZC_220810_80}", },
	}
	if tCarData[cartype] ~= nil then
		carname = tCarData[cartype].cname
		destname = tCarData[cartype].dsname
	end
	return carname,destname
end
function QuestLog_GetTarget_Guard( nMissionIndex )
	local cartype = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local carname,destname = QuestLog_GetGuardCarData( cartype )
	if carname ~= "" and destname ~= "" then
		return ScriptGlobal_Format("#{LBZC_220810_31}", carname, destname)
	end
	return ""
end
function QuestLog_Complete_Guard( nMissionIndex )		
	local cartype = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local carname,destname = QuestLog_GetGuardCarData( cartype )
	local isRobed = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	if isRobed <= 0 then
		local bdone = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
		return "\n"..ScriptGlobal_Format("#{LBZC_220810_32}", bdone)
	else
		if carname ~= "" and destname ~= "" then
			return "\n"..ScriptGlobal_Format("#{LBZC_220810_33}", destname)
		end
	end
	return ""
end
function QuestLog_GetTrack_Guard( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local cartype = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local carname,destname = QuestLog_GetGuardCarData( cartype )
	if param0 == 0 then
		local isRobed = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
		if isRobed <= 0 then
			if carname ~= "" and destname ~= "" then
				return "#W"..ScriptGlobal_Format("#{LBZC_220810_121}", carname, destname)
			end
		else
			if carname ~= "" and destname ~= "" then
				return "#W"..ScriptGlobal_Format("#{LBZC_220810_33}", destname)
			end
		end
	end
	return ""
end

--【2022Q4】情人节打卡
function QuestLog_GetQingRenJieDaKa( nIndex )
	local tData = 
	{	
		{4,4,4,},{4,3,5,},{5,2,5,},{7,1,4,},{6,3,3,},	
		{2,4,6,},{3,3,6,},{4,5,3,},{2,6,4,},{4,2,6,},	
		{3,4,5,},{2,5,5,},{5,6,1,},{6,1,5,},
	}
	if tData[nIndex] ~= nil then
		return tData[nIndex][1],tData[nIndex][2],tData[nIndex][3]
	end
	return 0,0,0
end
function QuestLog_GetTarget_QingRenJieDaKa( nMissionIndex )
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )	
	local num1,num2,num3 = QuestLog_GetQingRenJieDaKa( nIndex )
	if num1 > 0 and num2 > 0 and num3 > 0 then
		return ScriptGlobal_Format("#{QRDK_221123_19}", num1, num2, num3)
	end
	return ""
end
function QuestLog_Complete_QingRenJieDaKa( nMissionIndex )		
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )	
	local curnum1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local curnum2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )	
	local curnum3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )	
	local num1,num2,num3 = QuestLog_GetQingRenJieDaKa( nIndex )
	if num1 > 0 and num2 > 0 and num3 > 0 then
		local srtnum1 = ""
		if curnum1 < num1 then--没完成 红色
			srtnum1 = ScriptGlobal_Format("#{QRDK_221123_67}", curnum1, num1)
		else--完成了 绿色
			srtnum1 = ScriptGlobal_Format("#{QRDK_221123_20}", curnum1, num1)
		end
		local srtnum2 = ""
		if curnum2 < num2 then--没完成 红色
			srtnum2 = ScriptGlobal_Format("#{QRDK_221123_69}", curnum2, num2)
		else--完成了 绿色
			srtnum2 = ScriptGlobal_Format("#{QRDK_221123_71}", curnum2, num2)
		end
		local srtnum3 = ""
		if curnum3 < num3 then--没完成 红色
			srtnum3 = ScriptGlobal_Format("#{QRDK_221123_68}", curnum3, num3)
		else--完成了 绿色
			srtnum3 = ScriptGlobal_Format("#{QRDK_221123_70}", curnum3, num3)
		end
		
		return "\n"..srtnum1..srtnum2..srtnum3
	end
	return ""
end
function QuestLog_GetTrack_QingRenJieDaKa( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )	
	local curnum1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local curnum2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )	
	local curnum3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )	
	local num1,num2,num3 = QuestLog_GetQingRenJieDaKa( nIndex )
	if param0 == 0 then
		if num1 > 0 and num2 > 0 and num3 > 0 then
			local srtnum1 = ""
			if curnum1 < num1 then--没完成 红色
				srtnum1 = ScriptGlobal_Format("#{QRDK_221123_67}", curnum1, num1)
			else--完成了 绿色
				srtnum1 = ScriptGlobal_Format("#{QRDK_221123_20}", curnum1, num1)
			end
			local srtnum2 = ""
			if curnum2 < num2 then--没完成 红色
				srtnum2 = ScriptGlobal_Format("#{QRDK_221123_69}", curnum2, num2)
			else--完成了 绿色
				srtnum2 = ScriptGlobal_Format("#{QRDK_221123_71}", curnum2, num2)
			end
			local srtnum3 = ""
			if curnum3 < num3 then--没完成 红色
				srtnum3 = ScriptGlobal_Format("#{QRDK_221123_68}", curnum3, num3)
			else--完成了 绿色
				srtnum3 = ScriptGlobal_Format("#{QRDK_221123_70}", curnum3, num3)
			end
			return "#W".."#{QRDK_221123_72}"..srtnum1..srtnum2..srtnum3
		end
	end
	return "#W".."#{QRDK_221123_72}"
end

-- 新身份系统-引导任务 begin
function QuestLog_GetTrack_IdentityGuideData( nIndex )
	local tData = {	"#{SFYD_231227_71}","#{SFYD_231227_72}","#{SFYD_231227_74}","#{SFYD_231227_76}"}
	if tData[nIndex] ~= nil then
		return tData[nIndex]
	end
	return ""
end
function QuestLog_GetTrack_IdentityGuide1( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	if param0 == 0 then
		return "#W".."#{SFYD_231227_282}"
	end
	return "#W".."#{SFYD_231227_06}"
end
function QuestLog_GetTrack_IdentityGuide2( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	if param0 == 0 then
		return "#W".."#{SFYD_231227_283}"
	end
	local szTrack = QuestLog_GetTrack_IdentityGuideData( nIndex )
	return "#W"..szTrack
end
function QuestLog_GetTrack_IdentityGuide3( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	if param0 == 0 then
		return "#W".."#{SFYD_231227_284}"
	end
	local szTrack = QuestLog_GetTrack_IdentityGuideData( nIndex )
	return "#W"..szTrack
end
function QuestLog_GetTarget_IdentityGuide3( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local tData0 = {	"#{SFYD_231227_62}","#{SFYD_231227_65}","#{SFYD_231227_277}","#{SFYD_231227_294}"}
	local tData1 = {	"#{SFYD_231227_63}","#{SFYD_231227_66}","#{SFYD_231227_278}","#{SFYD_231227_295}"}
	local tData2 = {	"#{SFYD_231227_64}","#{SFYD_231227_67}","#{SFYD_231227_279}","#{SFYD_231227_296}"}
	local tData3 = {	"#{SFYD_231227_171}","#{SFYD_231227_172}","#{SFYD_231227_174}","#{SFYD_231227_176}"}
	local tData4 = {	"#{SFYD_231227_244}","#{SFYD_231227_243}","#{SFYD_231227_245}","#{SFYD_231227_246}"}
	if tData0[nIndex] ~= nil and tData1[nIndex] ~= nil and tData2[nIndex] ~= nil and tData3[nIndex] ~= nil and tData4[nIndex] ~= nil then
		return ScriptGlobal_Format("#{SFYD_231227_57}", tData0[nIndex], tData1[nIndex], tData2[nIndex], tData3[nIndex], tData4[nIndex])
	end
	return ""
end
function QuestLog_Complete_IdentityGuide3( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local curnum1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local curnum2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local curnum3 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local tData2 = {	"#{SFYD_231227_171}","#{SFYD_231227_172}","#{SFYD_231227_174}","#{SFYD_231227_176}"}
	if tData2[nIndex] ~= nil then
		return "\n"..ScriptGlobal_Format("#{SFYD_231227_58}", curnum2, tData2[nIndex], curnum1, curnum3)
	end
	return ""
end
function QuestLog_GetTrack_IdentityGuide4( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	if param0 == 0 then
		return "#W".."#{SFYD_231227_285}"
	end
	local szTrack = QuestLog_GetTrack_IdentityGuideData( nIndex )
	return "#W"..szTrack
end
function QuestLog_GetTrack_IdentityGuide5( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	if param0 == 0 then
		local tData1 = {	"#{SFYD_231227_268}","#{SFYD_231227_267}","#{SFYD_231227_269}","#{SFYD_231227_270}"}
		local tData2 = {	"#{SFYD_231227_240}","#{SFYD_231227_239}","#{SFYD_231227_241}","#{SFYD_231227_242}"}
		if tData1[nIndex] ~= nil and tData2[nIndex] ~= nil then
			return "#W"..ScriptGlobal_Format("#{SFYD_231227_290}", tData1[nIndex], tData2[nIndex])
		end
	end
	local szTrack = QuestLog_GetTrack_IdentityGuideData( nIndex )
	return "#W"..szTrack
end
function QuestLog_GetTarget_IdentityGuide5( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local tData1 = {	"#{SFYD_231227_268}","#{SFYD_231227_267}","#{SFYD_231227_269}","#{SFYD_231227_270}"}
	local tData2 = {	"#{SFYD_231227_240}","#{SFYD_231227_239}","#{SFYD_231227_241}","#{SFYD_231227_242}"}
	local tData3 = {	"#{SFYD_231227_244}","#{SFYD_231227_243}","#{SFYD_231227_245}","#{SFYD_231227_246}"}
	if tData1[nIndex] ~= nil and tData2[nIndex] ~= nil and tData3[nIndex] ~= nil then
		return ScriptGlobal_Format("#{SFYD_231227_69}", tData1[nIndex], tData2[nIndex], tData3[nIndex])
	end
	return ""
end
function QuestLog_Complete_IdentityGuide5( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )	
	local curnum1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )	
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local curnum2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )	
	local tData2 = {	"#{SFYD_231227_240}","#{SFYD_231227_239}","#{SFYD_231227_241}","#{SFYD_231227_242}"}
	if tData2[nIndex] ~= nil then
		return "\n"..ScriptGlobal_Format("#{SFYD_231227_70}", tData2[nIndex], curnum1, curnum2)
	end
	return ""
end
-- 新身份系统-引导任务 end

--武道二层历练任务 任务2特写
function QuestLog_GetItem_LiLianMission2( nIndex )
	local itemnum = 0
	local itemname = ""
	local tList = {{3,30900028,},{3,20310110,},{1,10156001,},{1,10156002,},
		{3,20310113,},{10,20310020,},{10,20310003,},{10,20310004,},}
	if tList[nIndex] ~= nil then
		itemnum = tList[nIndex][1]
		itemname = DataPool:LuaFnGetItemNameByTableIndex(tList[nIndex][2])
	end
	return itemnum,itemname
end

--武道二层历练任务 任务2特写 任务目标
function QuestLog_GetTarget_LiLianMission21( nMissionIndex )
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	if itemnum > 0 then
		return ScriptGlobal_Format("#{ZQSS_220429_57}", itemnum, itemname)
	end
	return ""
end
function QuestLog_GetTarget_LiLianMission22( nMissionIndex )
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	if itemnum > 0 then
		return ScriptGlobal_Format("#{XZDZ_220428_57}", itemnum, itemname)
	end
	return ""
end
function QuestLog_GetTarget_LiLianMission23( nMissionIndex )
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	if itemnum > 0 then
		return ScriptGlobal_Format("#{LNQZ_220429_57}", itemnum, itemname)
	end
	return ""
end
--武道二层历练任务 任务2特写 完成情况
function QuestLog_Complete_LiLianMission21( nMissionIndex )		
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	local bdone = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if itemnum > 0 then
		return "\n"..ScriptGlobal_Format("#{ZQSS_220429_58}", itemnum, itemname)..bdone.."/1"
	end
	return ""
end
function QuestLog_Complete_LiLianMission22( nMissionIndex )		
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	local bdone = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if itemnum > 0 then
		return "\n"..ScriptGlobal_Format("#{XZDZ_220428_58}", itemnum, itemname)..bdone.."/1"
	end
	return ""
end
function QuestLog_Complete_LiLianMission23( nMissionIndex )		
	local nIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )	
	local itemnum,itemname = QuestLog_GetItem_LiLianMission2( nIndex )
	local bdone = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if itemnum > 0 then
		return "\n"..ScriptGlobal_Format("#{LNQZ_220429_58}", itemnum, itemname)..bdone.."/1"
	end
	return ""
end


--武道二层历练任务 任务4特写 任务目标
function QuestLog_GetTarget_LiLianMission4( nIndex1,nIndex2 )
	local NPCname = ""
	local LPname = ""
	local MenPaiName = ""
	local MenPaiNpc = {

	[0] ={MenPai="少林",NPC={[0]="#{LLRW_231010_22}",[1]="#{LLRW_231010_21}"},LP={[0]="#{XLRW_210725_481}",[1]="#{XLRW_210725_480}"},},
	[1] ={MenPai="明教",NPC={[0]="#{LLRW_231010_26}",[1]="#{LLRW_231010_25}"},LP={[0]="#{XLRW_210725_485}",[1]="#{XLRW_210725_484}"},},
	[2] ={MenPai="丐帮",NPC={[0]="#{LLRW_231010_24}",[1]="#{LLRW_231010_23}"},LP={[0]="#{XLRW_210725_483}",[1]="#{XLRW_210725_482}"},},
	[3] ={MenPai="武当",NPC={[0]="#{LLRW_231010_27}",[1]="#{LLRW_231010_28}"},LP={[0]="#{XLRW_210725_486}",[1]="#{XLRW_210725_487}"},},
	[4] ={MenPai="峨嵋",NPC={[0]="#{LLRW_231010_33}",[1]="#{LLRW_231010_34}"},LP={[0]="#{XLRW_210725_492}",[1]="#{XLRW_210725_493}"},},
	[5] ={MenPai="星宿",NPC={[0]="#{LLRW_231010_35}",[1]="#{LLRW_231010_36}"},LP={[0]="#{XLRW_210725_494}",[1]="#{XLRW_210725_495}"},},
	[6] ={MenPai="天龙",NPC={[0]="#{LLRW_231010_29}",[1]="#{LLRW_231010_30}"},LP={[0]="#{XLRW_210725_488}",[1]="#{XLRW_210725_489}"},},
	[7] ={MenPai="天山",NPC={[0]="#{LLRW_231010_37}",[1]="#{LLRW_231010_38}"},LP={[0]="#{XLRW_210725_496}",[1]="#{XLRW_210725_497}"},},
	[8] ={MenPai="逍遥",NPC={[0]="#{LLRW_231010_31}",[1]="#{LLRW_231010_32}"},LP={[0]="#{XLRW_210725_490}",[1]="#{XLRW_210725_491}"},},
	[10] ={MenPai="#{MTLLRW_220624_05}",NPC={[0]="#{MTLLRW_231010_03}",[1]="#{MTLLRW_231010_08}"},LP={[0]="#{MTLLRW_220624_04}",[1]="#{MTLLRW_220624_09}"},},

	}
	if nIndex1 < 0 or nIndex1 > 10 or nIndex1 == 9 or nIndex2 < 0 or nIndex2 >1 then
		return NPCname,LPname
	end
	NPCname = MenPaiNpc[nIndex1].NPC[nIndex2]
	LPname = MenPaiNpc[nIndex1].LP[nIndex2]
	MenPaiName =MenPaiNpc[nIndex1].MenPai
	return NPCname,LPname,MenPaiName
end
function QuestLog_GetTarget_LiLianMission14( nMissionIndex )

	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_LiLianMission4( nIndex1,nIndex2 )
	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{ZQSS_220429_171}", LPname, NPCname)
	end
	return ""
end

function QuestLog_GetTarget_LiLianMission24( nMissionIndex )

	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_LiLianMission4( nIndex1,nIndex2 )
	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{XZDZ_220428_172}", LPname, NPCname)
	end

	return ""
end

function QuestLog_GetTarget_LiLianMission34( nMissionIndex )

	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_LiLianMission4( nIndex1,nIndex2 )
	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{LNQZ_220429_172}", LPname, NPCname)
	end

	return ""
end

function QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )
	local NPCname = ""
	local LPname = ""
	local MenPaiName = ""
	local MenPaiNpc = {
		[0] ={MenPai="少林",NPC={[0]="#{LLRW_230309_22}",[1]="#{LLRW_230309_21}"},LP={[0]="#{XLRW_210725_481}",[1]="#{XLRW_210725_480}"},},
		[1] ={MenPai="明教",NPC={[0]="#{LLRW_230309_26}",[1]="#{LLRW_230309_25}"},LP={[0]="#{XLRW_210725_485}",[1]="#{XLRW_210725_484}"},},
		[2] ={MenPai="丐帮",NPC={[0]="#{LLRW_230309_24}",[1]="#{LLRW_230309_23}"},LP={[0]="#{XLRW_210725_483}",[1]="#{XLRW_210725_482}"},},
		[3] ={MenPai="武当",NPC={[0]="#{LLRW_230309_27}",[1]="#{LLRW_230309_28}"},LP={[0]="#{XLRW_210725_486}",[1]="#{XLRW_210725_487}"},},
		[4] ={MenPai="峨嵋",NPC={[0]="#{LLRW_230309_33}",[1]="#{LLRW_230309_34}"},LP={[0]="#{XLRW_210725_492}",[1]="#{XLRW_210725_493}"},},
		[5] ={MenPai="星宿",NPC={[0]="#{LLRW_230309_35}",[1]="#{LLRW_230309_36}"},LP={[0]="#{XLRW_210725_494}",[1]="#{XLRW_210725_495}"},},
		[6] ={MenPai="天龙",NPC={[0]="#{LLRW_230309_29}",[1]="#{LLRW_230309_30}"},LP={[0]="#{XLRW_210725_488}",[1]="#{XLRW_210725_489}"},},
		[7] ={MenPai="天山",NPC={[0]="#{LLRW_230309_37}",[1]="#{LLRW_230309_38}"},LP={[0]="#{XLRW_210725_496}",[1]="#{XLRW_210725_497}"},},
		[8] ={MenPai="逍遥",NPC={[0]="#{LLRW_230309_31}",[1]="#{LLRW_230309_32}"},LP={[0]="#{XLRW_210725_490}",[1]="#{XLRW_210725_491}"},},
		[10] ={MenPai="#{MTLLRW_220624_05}",NPC={[0]="#{MTLLRW_220624_03}",[1]="#{MTLLRW_220624_08}"},LP={[0]="#{MTLLRW_220624_04}",[1]="#{MTLLRW_220624_09}"},}
	}
	if nIndex1 < 0 or nIndex1 > 10 or nIndex1 == 9 or nIndex2 < 0 or nIndex2 >1 then
		return NPCname,LPname
	end
	NPCname = MenPaiNpc[nIndex1].NPC[nIndex2]
	LPname = MenPaiNpc[nIndex1].LP[nIndex2]
	MenPaiName =MenPaiNpc[nIndex1].MenPai
	return NPCname,LPname,MenPaiName
end
function QuestLog_GetTarget_JingJinMission1( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )
	local nQuestIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	AccomplishInfo={
		{question="#{WDJJ_230614_213}",name="段延庆",Answer="#{WDJJ_230614_237}",}, --大理 214，283  2
		{question="#{WDJJ_230614_214}",name="段延庆",Answer="#{WDJJ_230614_237}",},
		{question="#{WDJJ_230614_215}",name="段延庆",Answer="#{WDJJ_230614_237}",},

		{question="#{WDJJ_230614_219}",name="慕容复",Answer="#{WDJJ_230614_239}",}, --苏州129，76  1
		{question="#{WDJJ_230614_220}",name="慕容复",Answer="#{WDJJ_230614_239}",},
		{question="#{WDJJ_230614_221}",name="慕容复",Answer="#{WDJJ_230614_239}",},

		{question="#{WDJJ_230614_222}",name="游坦之",Answer="#{WDJJ_230614_240}",}, --洛阳 57，82  0
		{question="#{WDJJ_230614_223}",name="游坦之",Answer="#{WDJJ_230614_240}",},
		{question="#{WDJJ_230614_224}",name="游坦之",Answer="#{WDJJ_230614_240}",},

		{question="#{WDJJ_230614_225}",name="智光大师",Answer="#{WDJJ_230614_241}",}, --洛阳 77，72  0
		{question="#{WDJJ_230614_226}",name="智光大师",Answer="#{WDJJ_230614_241}",},
		{question="#{WDJJ_230614_227}",name="智光大师",Answer="#{WDJJ_230614_241}",},

		{question="#{WDJJ_230614_228}",name="段正淳",Answer="#{WDJJ_230614_242}",}, --大理 62，35  2
		{question="#{WDJJ_230614_229}",name="段正淳",Answer="#{WDJJ_230614_242}",},
		{question="#{WDJJ_230614_230}",name="段正淳",Answer="#{WDJJ_230614_242}",},

		{question="#{WDJJ_230614_231}",name="叶二娘",Answer="#{WDJJ_230614_243}",}, --大理 54，265  2
		{question="#{WDJJ_230614_232}",name="叶二娘",Answer="#{WDJJ_230614_243}",},
		{question="#{WDJJ_230614_233}",name="叶二娘",Answer="#{WDJJ_230614_243}",},

		{question="#{WDJJ_230614_234}",name="包不同",Answer="#{WDJJ_230614_244}",}, --苏州115，71  1
		{question="#{WDJJ_230614_235}",name="包不同",Answer="#{WDJJ_230614_244}",},
		{question="#{WDJJ_230614_236}",name="包不同",Answer="#{WDJJ_230614_244}",},

	}

	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{WDJJ_230614_29}", LPname, NPCname,AccomplishInfo[nQuestIndex].question)
	end

	return ""
end

function QuestLog_GetTarget_JingJinMission2( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )
	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{WDJJ_230614_66}", LPname, NPCname)
	end

	return ""
end

function QuestLog_GetTarget_JingJinMission3( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname,MeiPainame = QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )
	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{WDJJ_230614_119}", NPCname)
	end

	return ""
end


function QuestLog_GetTarget_JingJinMission4( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname,MeiPainame = QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )
	local nQuestIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local nQuestRandIndex = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )

	AccomplishInfoStr=
	{
		[0] = {
					[1] = { "#{WDJJ_230614_500}", "#{WDJJ_230614_501}", "#{WDJJ_230614_502}",},
					[2] = { "#{WDJJ_230614_503}", "#{WDJJ_230614_504}", "#{WDJJ_230614_505}",},
					[3] = { "#{WDJJ_230614_506}", "#{WDJJ_230614_507}", "#{WDJJ_230614_508}",},
					[4] = { "#{WDJJ_230614_509}", "#{WDJJ_230614_510}", "#{WDJJ_230614_511}",},
					[5] = { "#{WDJJ_230614_512}", "#{WDJJ_230614_513}", "#{WDJJ_230614_514}",},--
					[6] = { "#{WDJJ_230614_515}", "#{WDJJ_230614_516}", "#{WDJJ_230614_517}",},
					},
		[1] = {
					[1] = { "#{WDJJ_230614_536}", "#{WDJJ_230614_537}", "#{WDJJ_230614_538}",},
					[2] = { "#{WDJJ_230614_539}", "#{WDJJ_230614_540}", "#{WDJJ_230614_541}",},
					[3] = { "#{WDJJ_230614_542}", "#{WDJJ_230614_543}", "#{WDJJ_230614_544}",},
					[4] = { "#{WDJJ_230614_545}", "#{WDJJ_230614_546}", "#{WDJJ_230614_547}",},
					[5] = { "#{WDJJ_230614_548}", "#{WDJJ_230614_549}", "#{WDJJ_230614_550}",},--
					[6] = { "#{WDJJ_230614_551}", "#{WDJJ_230614_552}", "#{WDJJ_230614_553}",},
					},
		[2] = {
					[1] = { "#{WDJJ_230614_518}", "#{WDJJ_230614_519}", "#{WDJJ_230614_520}",},
					[2] = { "#{WDJJ_230614_521}", "#{WDJJ_230614_522}", "#{WDJJ_230614_523}",},
					[3] = { "#{WDJJ_230614_524}", "#{WDJJ_230614_525}", "#{WDJJ_230614_526}",},
					[4] = { "#{WDJJ_230614_527}", "#{WDJJ_230614_528}", "#{WDJJ_230614_529}",},
					[5] = { "#{WDJJ_230614_530}", "#{WDJJ_230614_531}", "#{WDJJ_230614_532}",},--
					[6] = { "#{WDJJ_230614_533}", "#{WDJJ_230614_534}", "#{WDJJ_230614_535}",},
					},
		[3] = {
					[1] = { "#{WDJJ_230614_554}", "#{WDJJ_230614_555}", "#{WDJJ_230614_556}",},
					[2] = { "#{WDJJ_230614_557}", "#{WDJJ_230614_558}", "#{WDJJ_230614_559}",},
					[3] = { "#{WDJJ_230614_560}", "#{WDJJ_230614_561}", "#{WDJJ_230614_562}",},
					[4] = { "#{WDJJ_230614_563}", "#{WDJJ_230614_564}", "#{WDJJ_230614_565}",},
					[5] = { "#{WDJJ_230614_566}", "#{WDJJ_230614_567}", "#{WDJJ_230614_568}",},--
					[6] = { "#{WDJJ_230614_569}", "#{WDJJ_230614_570}", "#{WDJJ_230614_571}",},
					},
		[4] = {
					[1] = { "#{WDJJ_230614_608}", "#{WDJJ_230614_609}", "#{WDJJ_230614_610}",},
					[2] = { "#{WDJJ_230614_611}", "#{WDJJ_230614_612}", "#{WDJJ_230614_613}",},
					[3] = { "#{WDJJ_230614_614}", "#{WDJJ_230614_615}", "#{WDJJ_230614_616}",},
					[4] = { "#{WDJJ_230614_617}", "#{WDJJ_230614_618}", "#{WDJJ_230614_619}",},
					[5] = { "#{WDJJ_230614_620}", "#{WDJJ_230614_621}", "#{WDJJ_230614_622}",},--
					[6] = { "#{WDJJ_230614_623}", "#{WDJJ_230614_624}", "#{WDJJ_230614_625}",},
					},
		[5] = {
					[1] = { "#{WDJJ_230614_626}", "#{WDJJ_230614_627}", "#{WDJJ_230614_628}",},
					[2] = { "#{WDJJ_230614_629}", "#{WDJJ_230614_630}", "#{WDJJ_230614_631}",},
					[3] = { "#{WDJJ_230614_632}", "#{WDJJ_230614_633}", "#{WDJJ_230614_634}",},
					[4] = { "#{WDJJ_230614_635}", "#{WDJJ_230614_636}", "#{WDJJ_230614_637}",},
					[5] = { "#{WDJJ_230614_638}", "#{WDJJ_230614_639}", "#{WDJJ_230614_640}",},--
					[6] = { "#{WDJJ_230614_641}", "#{WDJJ_230614_642}", "#{WDJJ_230614_643}",},
					},
		[6] = {
					[1] = { "#{WDJJ_230614_572}", "#{WDJJ_230614_573}", "#{WDJJ_230614_574}",},
					[2] = { "#{WDJJ_230614_575}", "#{WDJJ_230614_576}", "#{WDJJ_230614_577}",},
					[3] = { "#{WDJJ_230614_578}", "#{WDJJ_230614_579}", "#{WDJJ_230614_580}",},
					[4] = { "#{WDJJ_230614_581}", "#{WDJJ_230614_582}", "#{WDJJ_230614_583}",},
					[5] = { "#{WDJJ_230614_584}", "#{WDJJ_230614_585}", "#{WDJJ_230614_586}",},--
					[6] = { "#{WDJJ_230614_587}", "#{WDJJ_230614_588}", "#{WDJJ_230614_589}",},
					},
		[7] = {
					[1] = { "#{WDJJ_230614_644}", "#{WDJJ_230614_645}", "#{WDJJ_230614_646}",},
					[2] = { "#{WDJJ_230614_647}", "#{WDJJ_230614_648}", "#{WDJJ_230614_649}",},
					[3] = { "#{WDJJ_230614_650}", "#{WDJJ_230614_651}", "#{WDJJ_230614_652}",},
					[4] = { "#{WDJJ_230614_653}", "#{WDJJ_230614_654}", "#{WDJJ_230614_655}",},
					[5] = { "#{WDJJ_230614_656}", "#{WDJJ_230614_657}", "#{WDJJ_230614_658}",},--
					[6] = { "#{WDJJ_230614_659}", "#{WDJJ_230614_660}", "#{WDJJ_230614_661}",},
					},
		[8] = {
					[1] = { "#{WDJJ_230614_590}", "#{WDJJ_230614_591}", "#{WDJJ_230614_592}",},
					[2] = { "#{WDJJ_230614_593}", "#{WDJJ_230614_594}", "#{WDJJ_230614_595}",},
					[3] = { "#{WDJJ_230614_596}", "#{WDJJ_230614_597}", "#{WDJJ_230614_598}",},
					[4] = { "#{WDJJ_230614_599}", "#{WDJJ_230614_600}", "#{WDJJ_230614_601}",},
					[5] = { "#{WDJJ_230614_602}", "#{WDJJ_230614_603}", "#{WDJJ_230614_604}",},--
					[6] = { "#{WDJJ_230614_605}", "#{WDJJ_230614_606}", "#{WDJJ_230614_607}",},
					},
		[10] = {
					[1] = { "#{WDJJ_230614_662}", "#{WDJJ_230614_663}", "#{WDJJ_230614_664}",},
					[2] = { "#{WDJJ_230614_665}", "#{WDJJ_230614_666}", "#{WDJJ_230614_667}",},
					[3] = { "#{WDJJ_230614_668}", "#{WDJJ_230614_669}", "#{WDJJ_230614_670}",},
					[4] = { "#{WDJJ_230614_671}", "#{WDJJ_230614_672}", "#{WDJJ_230614_673}",},
					[5] = { "#{WDJJ_230614_674}", "#{WDJJ_230614_675}", "#{WDJJ_230614_676}",},--
					[6] = { "#{WDJJ_230614_677}", "#{WDJJ_230614_678}", "#{WDJJ_230614_679}",},
					},
	}


	if NPCname ~= "" and LPname ~= "" then
		return "#W"..ScriptGlobal_Format("#{WDJJ_230614_179}", LPname, NPCname,AccomplishInfoStr[nIndex1][nQuestIndex][nQuestRandIndex])
	end

	return ""
end

function QuestLog_GetTarget_JingJinMission5( nMissionIndex )
	local nIndex1 = Player:GetData("MEMPAI")
	local nIndex2 = DataPool:GetSectType()
	local NPCname,LPname = QuestLog_GetTarget_JingJinMission( nIndex1,nIndex2 )

	local nRand = DataPool:GetPlayerMission_Variable(nMissionIndex,2);
	local TargetStrList =
	{
	[0] ={
				[1] = { npcname = "玄渡", npcposx = 128, npcposz = 86, npcscene = 9, namestr = "#{WDJJ_230614_383}", strlink = "#{WDJJ_230614_292}"},
				[2] = { npcname = "玄慈", npcposx = 38, npcposz = 98, npcscene = 9, namestr = "#{WDJJ_230614_384}", strlink = "#{WDJJ_230614_293}"},
				[3] = { npcname = "玄寂", npcposx = 89, npcposz = 72, npcscene = 9, namestr = "#{WDJJ_230614_385}", strlink = "#{WDJJ_230614_294}"},
				[4] = { npcname = "玄难", npcposx = 91, npcposz = 71, npcscene = 9, namestr = "#{WDJJ_230614_386}", strlink = "#{WDJJ_230614_295}"},
				[5] = { npcname = "玄灭", npcposx = 57, npcposz = 88, npcscene = 9, namestr = "#{WDJJ_230614_387}", strlink = "#{WDJJ_230614_296}"},--
				[6] = { npcname = "玄鸣", npcposx = 135, npcposz = 90, npcscene = 9, namestr = "#{WDJJ_230614_388}", strlink = "#{WDJJ_230614_297}"},},
	[1] ={
				[1] = { npcname = "林岩", npcposx = 98, npcposz = 105, npcscene = 11, namestr = "#{WDJJ_230614_395}", strlink = "#{WDJJ_230614_304}"},
				[2] = { npcname = "方百花", npcposx = 133, npcposz = 117, npcscene = 11, namestr = "#{WDJJ_230614_396}", strlink = "#{WDJJ_230614_305}"},---
				[3] = { npcname = "方腊", npcposx = 89, npcposz = 56, npcscene = 11, namestr = "#{WDJJ_230614_397}", strlink = "#{WDJJ_230614_306}"},
				[4] = { npcname = "玛拉", npcposx = 133, npcposz = 118, npcscene = 11, namestr = "#{WDJJ_230614_398}", strlink = "#{WDJJ_230614_307}"},---
				[5] = { npcname = "方天定", npcposx = 87, npcposz = 58, npcscene = 11, namestr = "#{WDJJ_230614_399}", strlink = "#{WDJJ_230614_308}"},
				[6] = { npcname = "厉天佑", npcposx = 66, npcposz = 118, npcscene = 11, namestr = "#{WDJJ_230614_400}", strlink = "#{WDJJ_230614_309}"},},--
	[2] ={
				[1] = { npcname = "奚三祁", npcposx = 94, npcposz = 99, npcscene = 10, namestr = "#{WDJJ_230614_389}", strlink = "#{WDJJ_230614_298}"},
				[2] = { npcname = "吴长风", npcposx = 114, npcposz = 91, npcscene = 10, namestr = "#{WDJJ_230614_390}", strlink = "#{WDJJ_230614_299}"},
				[3] = { npcname = "上官长雨", npcposx = 131, npcposz = 83, npcscene = 10, namestr = "#{WDJJ_230614_391}", strlink = "#{WDJJ_230614_300}"},
				[4] = { npcname = "张全祥", npcposx = 95, npcposz = 120, npcscene = 10, namestr = "#{WDJJ_230614_392}", strlink = "#{WDJJ_230614_301}"},---
				[5] = { npcname = "宋慈", npcposx = 92, npcposz = 64, npcscene = 10, namestr = "#{WDJJ_230614_393}", strlink = "#{WDJJ_230614_302}"},
				[6] = { npcname = "白世镜", npcposx = 89, npcposz = 99, npcscene = 10, namestr = "#{WDJJ_230614_394}", strlink = "#{WDJJ_230614_303}"},},
	[3] ={
				[1] = { npcname = "张玄素", npcposx = 77, npcposz = 85, npcscene = 12, namestr = "#{WDJJ_230614_401}", strlink = "#{WDJJ_230614_310}"},
				[2] = { npcname = "俞远山", npcposx = 82, npcposz = 85, npcscene = 12, namestr = "#{WDJJ_230614_402}", strlink = "#{WDJJ_230614_311}"},
				[3] = { npcname = "鹤云道人", npcposx = 44, npcposz = 56, npcscene = 12, namestr = "#{WDJJ_230614_403}", strlink = "#{WDJJ_230614_312}"},
				[4] = { npcname = "莫太冲", npcposx = 101, npcposz = 136, npcscene = 12, namestr = "#{WDJJ_230614_404}", strlink = "#{WDJJ_230614_313}"},--
				[5] = { npcname = "林灵素", npcposx = 58, npcposz = 73, npcscene = 12, namestr = "#{WDJJ_230614_405}", strlink = "#{WDJJ_230614_314}"},
				[6] = { npcname = "张中行", npcposx = 78, npcposz = 95, npcscene = 12, namestr = "#{WDJJ_230614_406}", strlink = "#{WDJJ_230614_315}"},},
	[4] ={
				[1] = { npcname = "崔绿华", npcposx = 98, npcposz = 51, npcscene = 15, namestr = "#{WDJJ_230614_419}", strlink = "#{WDJJ_230614_328}"},
				[2] = { npcname = "杨四娘", npcposx = 86, npcposz = 142, npcscene = 15, namestr = "#{WDJJ_230614_420}", strlink = "#{WDJJ_230614_329}"},---
				[3] = { npcname = "孟青青", npcposx = 96, npcposz = 73, npcscene = 15, namestr = "#{WDJJ_230614_421}", strlink = "#{WDJJ_230614_330}"},
				[4] = { npcname = "孟龙", npcposx = 95, npcposz = 86, npcscene = 15, namestr = "#{WDJJ_230614_422}", strlink = "#{WDJJ_230614_331}"},
				[5] = { npcname = "孙二娘", npcposx = 105, npcposz = 57, npcscene = 15, namestr = "#{WDJJ_230614_423}", strlink = "#{WDJJ_230614_332}"},---
				[6] = { npcname = "李十二娘", npcposx = 96, npcposz = 51, npcscene = 15, namestr = "#{WDJJ_230614_424}", strlink = "#{WDJJ_230614_333}"},},
	[5] ={
				[1] = { npcname = "丁春秋", npcposx = 142, npcposz = 55, npcscene = 16, namestr = "#{WDJJ_230614_425}", strlink = "#{WDJJ_230614_334}"},
				[2] = { npcname = "韩世忠", npcposx = 95, npcposz = 75, npcscene = 16, namestr = "#{WDJJ_230614_426}", strlink = "#{WDJJ_230614_335}"},
				[3] = { npcname = "红玉", npcposx = 128, npcposz = 77, npcscene = 16, namestr = "#{WDJJ_230614_427}", strlink = "#{WDJJ_230614_336}"},
				[4] = { npcname = "出尘子", npcposx = 90, npcposz = 87, npcscene = 16, namestr = "#{WDJJ_230614_428}", strlink = "#{WDJJ_230614_337}"},---
				[5] = { npcname = "施全", npcposx = 87, npcposz = 70, npcscene = 16, namestr = "#{WDJJ_230614_429}", strlink = "#{WDJJ_230614_338}"},
				[6] = { npcname = "王彦", npcposx = 96, npcposz = 92, npcscene = 16, namestr = "#{WDJJ_230614_430}", strlink = "#{WDJJ_230614_339}"},},
	[6] ={
				[1] = { npcname = "本因", npcposx = 96, npcposz = 66, npcscene = 13, namestr = "#{WDJJ_230614_407}", strlink = "#{WDJJ_230614_316}"},
				[2] = { npcname = "本观", npcposx = 97, npcposz = 67, npcscene = 13, namestr = "#{WDJJ_230614_408}", strlink = "#{WDJJ_230614_317}"},
				[3] = { npcname = "本相", npcposx = 35, npcposz = 86, npcscene = 13, namestr = "#{WDJJ_230614_409}", strlink = "#{WDJJ_230614_318}"},
				[4] = { npcname = "本凡", npcposx = 95, npcposz = 88, npcscene = 13, namestr = "#{WDJJ_230614_410}", strlink = "#{WDJJ_230614_319}"},
				[5] = { npcname = "破嗔", npcposx = 99, npcposz = 120, npcscene = 13, namestr = "#{WDJJ_230614_411}", strlink = "#{WDJJ_230614_320}"},--
				[6] = { npcname = "盛如兰", npcposx = 152, npcposz = 118, npcscene = 13, namestr = "#{WDJJ_230614_412}", strlink = "#{WDJJ_230614_321}"},},--
	[7] ={
				[1] = { npcname = "乌老大", npcposx = 90, npcposz = 120, npcscene = 17, namestr = "#{WDJJ_230614_431}", strlink = "#{WDJJ_230614_340}"},---
				[2] = { npcname = "竹剑", npcposx = 98, npcposz = 44, npcscene = 17, namestr = "#{WDJJ_230614_432}", strlink = "#{WDJJ_230614_341}"},--
				[3] = { npcname = "兰剑", npcposx = 88, npcposz = 44, npcscene = 17, namestr = "#{WDJJ_230614_433}", strlink = "#{WDJJ_230614_342}"},
				[4] = { npcname = "梅剑", npcposx = 91, npcposz = 44, npcscene = 17, namestr = "#{WDJJ_230614_434}", strlink = "#{WDJJ_230614_343}"},
				[5] = { npcname = "符敏仪", npcposx = 95, npcposz = 60, npcscene = 17, namestr = "#{WDJJ_230614_435}", strlink = "#{WDJJ_230614_344}"},
				[6] = { npcname = "菊剑", npcposx = 101, npcposz = 44, npcscene = 17, namestr = "#{WDJJ_230614_436}", strlink = "#{WDJJ_230614_345}"},},
	[8] ={
				[1] = { npcname = "苏星河", npcposx = 125, npcposz = 144, npcscene = 14, namestr = "#{WDJJ_230614_413}", strlink = "#{WDJJ_230614_322}"},
				[2] = { npcname = "康广陵", npcposx = 125, npcposz = 142, npcscene = 14, namestr = "#{WDJJ_230614_414}", strlink = "#{WDJJ_230614_323}"},
				[3] = { npcname = "李傀儡", npcposx = 69, npcposz = 142, npcscene = 14, namestr = "#{WDJJ_230614_415}", strlink = "#{WDJJ_230614_324}"},--
				[4] = { npcname = "秦观", npcposx = 119, npcposz = 152, npcscene = 14, namestr = "#{WDJJ_230614_416}", strlink = "#{WDJJ_230614_325}"},
				[5] = { npcname = "石甘霖", npcposx = 54, npcposz = 150, npcscene = 14, namestr = "#{WDJJ_230614_417}", strlink = "#{WDJJ_230614_326}"},---
				[6] = { npcname = "冯阿三", npcposx = 62, npcposz = 68, npcscene = 14, namestr = "#{WDJJ_230614_418}", strlink = "#{WDJJ_230614_327}"},},
	[10] ={
				[1] = { npcname = "陶岭", npcposx = 62, npcposz = 191, npcscene = 1283, namestr = "#{WDJJ_230614_437}", strlink = "#{WDJJ_230614_346}"},
				[2] = { npcname = "王水风", npcposx = 186, npcposz = 171, npcscene = 1283, namestr = "#{WDJJ_230614_438}", strlink = "#{WDJJ_230614_347}"},
				[3] = { npcname = "白雪", npcposx = 141, npcposz = 74, npcscene = 1283, namestr = "#{WDJJ_230614_439}", strlink = "#{WDJJ_230614_348}"},
				[4] = { npcname = "王语嫣", npcposx = 179, npcposz = 79, npcscene = 1283, namestr = "#{WDJJ_230614_440}", strlink = "#{WDJJ_230614_349}"},
				[5] = { npcname = "王星浪", npcposx = 231, npcposz = 178, npcscene = 1283, namestr = "#{WDJJ_230614_441}", strlink = "#{WDJJ_230614_350}"},
				[6] = { npcname = "阳春", npcposx = 138, npcposz = 73, npcscene = 1283, namestr = "#{WDJJ_230614_442}", strlink = "#{WDJJ_230614_351}"},},


	}
	if NPCname ~= "" and LPname ~= ""  and TargetStrList[nIndex1][nRand] ~= nil then
		return "#W"..ScriptGlobal_Format("#{WDJJ_230614_192}", TargetStrList[nIndex1][nRand].strlink,NPCname)
	end

	return ""
end


function QuestLog_Complete_LiLianMission14( nMissionIndex )

	local str = "#{ZQSS_220429_173}"
	return str
end

function QuestLog_Complete_LiLianMission24( nMissionIndex )

	local str = "#{XZDZ_220428_173}"
	return str
end

function QuestLog_Complete_LiLianMission34( nMissionIndex )

	local str = "#{LNQZ_220429_173}"
	return str
end


-- 新天赋系统修炼任务设计 begin
function QuestLog_GetXiuLianMissionNumStr()--任务当前环数
	local nData = DataPool:GetPlayerMission_DataRound(628)
	if nData ~= nil and nData >= 0 then
		local nNum = math.mod(nData,1000) + 1
		local str = ScriptGlobal_Format("#{XLRW_210725_500}", nNum)
		return str
	end
	return ""
end
function QuestLog_GetXiuLianMission_NameStr( menpaiid, liupaiid )--流派名 门派名 流派npc名
	local g_MenPaiNpcA = {
		[0] = {str = "#{XLRW_210725_246}", strlink = "#{XLRW_210725_523}", liupainame = "#{XLRW_210725_481}", mpname = "#{XLRW_210725_43}"},--少林
		[1] = {str = "#{XLRW_210725_250}", strlink = "#{XLRW_210725_527}", liupainame = "#{XLRW_210725_485}", mpname = "#{XLRW_210725_38}"},--明教
		[2] = {str = "#{XLRW_210725_248}", strlink = "#{XLRW_210725_525}", liupainame = "#{XLRW_210725_483}", mpname = "#{XLRW_210725_39}"},--丐帮
		[3] = {str = "#{XLRW_210725_251}", strlink = "#{XLRW_210725_528}", liupainame = "#{XLRW_210725_486}", mpname = "#{XLRW_210725_40}"},--武当
		[4] = {str = "#{XLRW_210725_257}", strlink = "#{XLRW_210725_534}", liupainame = "#{XLRW_210725_492}", mpname = "#{XLRW_210725_35}"},--峨嵋
		[5] = {str = "#{XLRW_210725_259}", strlink = "#{XLRW_210725_536}", liupainame = "#{XLRW_210725_494}", mpname = "#{XLRW_210725_41}"},--星宿
		[6] = {str = "#{XLRW_210725_253}", strlink = "#{XLRW_210725_530}", liupainame = "#{XLRW_210725_488}", mpname = "#{XLRW_210725_42}"},--天龙
		[7] = {str = "#{XLRW_210725_261}", strlink = "#{XLRW_210725_538}", liupainame = "#{XLRW_210725_496}", mpname = "#{XLRW_210725_36}"},--天山
		[8] = {str = "#{XLRW_210725_255}", strlink = "#{XLRW_210725_532}", liupainame = "#{XLRW_210725_490}", mpname = "#{XLRW_210725_37}"},--逍遥
		[10] = {str = "#{XLRW_210725_770}", strlink = "#{XLRW_210725_735}", liupainame = "#{XLRW_210725_737}", mpname = "#{XLRW_210725_741}"},--曼陀山庄
	}

	local g_MenPaiNpcB = {
		[0] = {str = "#{XLRW_210725_245}", strlink = "#{XLRW_210725_522}", liupainame = "#{XLRW_210725_480}", mpname = "#{XLRW_210725_43}"},--少林
		[1] = {str = "#{XLRW_210725_249}", strlink = "#{XLRW_210725_526}", liupainame = "#{XLRW_210725_484}", mpname = "#{XLRW_210725_38}"},--明教
		[2] = {str = "#{XLRW_210725_247}", strlink = "#{XLRW_210725_524}", liupainame = "#{XLRW_210725_482}", mpname = "#{XLRW_210725_39}"},--丐帮
		[3] = {str = "#{XLRW_210725_252}", strlink = "#{XLRW_210725_529}", liupainame = "#{XLRW_210725_487}", mpname = "#{XLRW_210725_40}"},--武当
		[4] = {str = "#{XLRW_210725_258}", strlink = "#{XLRW_210725_535}", liupainame = "#{XLRW_210725_493}", mpname = "#{XLRW_210725_35}"},--峨嵋
		[5] = {str = "#{XLRW_210725_260}", strlink = "#{XLRW_210725_537}", liupainame = "#{XLRW_210725_495}", mpname = "#{XLRW_210725_41}"},--星宿
		[6] = {str = "#{XLRW_210725_254}", strlink = "#{XLRW_210725_531}", liupainame = "#{XLRW_210725_489}", mpname = "#{XLRW_210725_42}"},--天龙
		[7] = {str = "#{XLRW_210725_262}", strlink = "#{XLRW_210725_539}", liupainame = "#{XLRW_210725_497}", mpname = "#{XLRW_210725_36}"},--天山
		[8] = {str = "#{XLRW_210725_256}", strlink = "#{XLRW_210725_533}", liupainame = "#{XLRW_210725_491}", mpname = "#{XLRW_210725_37}"},--逍遥
		[10] = {str = "#{XLRW_210725_771}", strlink = "#{XLRW_210725_736}", liupainame = "#{XLRW_210725_738}", mpname = "#{XLRW_210725_741}"},--曼陀山庄
	}
	local g_LiuPaiA = 0
	local g_LiuPaiB = 1
	if liupaiid == g_LiuPaiA and g_MenPaiNpcA[menpaiid] ~= nil then
		return g_MenPaiNpcA[menpaiid].liupainame, g_MenPaiNpcA[menpaiid].mpname, g_MenPaiNpcA[menpaiid].str, g_MenPaiNpcA[menpaiid].strlink
	end
	if liupaiid == g_LiuPaiB and g_MenPaiNpcB[menpaiid] ~= nil then
		return g_MenPaiNpcB[menpaiid].liupainame, g_MenPaiNpcB[menpaiid].mpname, g_MenPaiNpcB[menpaiid].str , g_MenPaiNpcB[menpaiid].strlink
	end
	return "","",""
end

function QuestLog_GetXiuLianMission_TargetNameStr( menpaiid, liupaiid )
	local g_MenPaiNpcA = {
		[0] = {str = "#{XLRW_210725_246}", strlink = "#{WDSC_230605_75}", liupainame = "#{XLRW_210725_481}", mpname = "#{XLRW_210725_43}"},--少林
		[1] = {str = "#{XLRW_210725_250}", strlink = "#{WDSC_230605_79}", liupainame = "#{XLRW_210725_485}", mpname = "#{XLRW_210725_38}"},--明教
		[2] = {str = "#{XLRW_210725_248}", strlink = "#{WDSC_230605_77}", liupainame = "#{XLRW_210725_483}", mpname = "#{XLRW_210725_39}"},--丐帮
		[3] = {str = "#{XLRW_210725_251}", strlink = "#{WDSC_230605_80}", liupainame = "#{XLRW_210725_486}", mpname = "#{XLRW_210725_40}"},--武当
		[4] = {str = "#{XLRW_210725_257}", strlink = "#{WDSC_230605_86}", liupainame = "#{XLRW_210725_492}", mpname = "#{XLRW_210725_35}"},--峨嵋
		[5] = {str = "#{XLRW_210725_259}", strlink = "#{WDSC_230605_88}", liupainame = "#{XLRW_210725_494}", mpname = "#{XLRW_210725_41}"},--星宿
		[6] = {str = "#{XLRW_210725_253}", strlink = "#{WDSC_230605_82}", liupainame = "#{XLRW_210725_488}", mpname = "#{XLRW_210725_42}"},--天龙
		[7] = {str = "#{XLRW_210725_261}", strlink = "#{WDSC_230605_90}", liupainame = "#{XLRW_210725_496}", mpname = "#{XLRW_210725_36}"},--天山
		[8] = {str = "#{XLRW_210725_255}", strlink = "#{WDSC_230605_84}", liupainame = "#{XLRW_210725_490}", mpname = "#{XLRW_210725_37}"},--逍遥
		[10] = {str = "#{XLRW_210725_770}", strlink = "#{WDSC_230605_92}", liupainame = "#{XLRW_210725_737}", mpname = "#{XLRW_210725_741}"},--曼陀山庄
	}

	local g_MenPaiNpcB = {
		[0] = {str = "#{XLRW_210725_245}", strlink = "#{WDSC_230605_74}", liupainame = "#{XLRW_210725_480}", mpname = "#{XLRW_210725_43}"},--少林
		[1] = {str = "#{XLRW_210725_249}", strlink = "#{WDSC_230605_78}", liupainame = "#{XLRW_210725_484}", mpname = "#{XLRW_210725_38}"},--明教
		[2] = {str = "#{XLRW_210725_247}", strlink = "#{WDSC_230605_76}", liupainame = "#{XLRW_210725_482}", mpname = "#{XLRW_210725_39}"},--丐帮
		[3] = {str = "#{XLRW_210725_252}", strlink = "#{WDSC_230605_81}", liupainame = "#{XLRW_210725_487}", mpname = "#{XLRW_210725_40}"},--武当
		[4] = {str = "#{XLRW_210725_258}", strlink = "#{WDSC_230605_87}", liupainame = "#{XLRW_210725_493}", mpname = "#{XLRW_210725_35}"},--峨嵋
		[5] = {str = "#{XLRW_210725_260}", strlink = "#{WDSC_230605_89}", liupainame = "#{XLRW_210725_495}", mpname = "#{XLRW_210725_41}"},--星宿
		[6] = {str = "#{XLRW_210725_254}", strlink = "#{WDSC_230605_83}", liupainame = "#{XLRW_210725_489}", mpname = "#{XLRW_210725_42}"},--天龙
		[7] = {str = "#{XLRW_210725_262}", strlink = "#{WDSC_230605_91}", liupainame = "#{XLRW_210725_497}", mpname = "#{XLRW_210725_36}"},--天山
		[8] = {str = "#{XLRW_210725_256}", strlink = "#{WDSC_230605_85}", liupainame = "#{XLRW_210725_491}", mpname = "#{XLRW_210725_37}"},--逍遥
		[10] = {str = "#{XLRW_210725_771}", strlink = "#{WDSC_230605_93}", liupainame = "#{XLRW_210725_738}", mpname = "#{XLRW_210725_741}"},--曼陀山庄
	}
	local g_ZhangMen = {
		[0] = "#{WDSC_230605_60}",--少林
		[1] = "#{WDSC_230605_62}",--明教
		[2] = "#{WDSC_230605_61}",--丐帮
		[3] = "#{WDSC_230605_63}",--武当
		[4] = "#{WDSC_230605_66}",--峨嵋
		[5] = "#{WDSC_230605_67}",--星宿
		[6] = "#{WDSC_230605_64}",--天龙
		[7] = "#{WDSC_230605_68}",--天山
		[8] = "#{WDSC_230605_65}",--逍遥
		[10] = "#{WDSC_230605_69}",--曼陀山庄
	}
	local g_LiuPaiA = 0
	local g_LiuPaiB = 1
	if liupaiid == g_LiuPaiA and g_MenPaiNpcA[menpaiid] ~= nil then
		return g_MenPaiNpcA[menpaiid].liupainame, g_MenPaiNpcA[menpaiid].mpname, g_MenPaiNpcA[menpaiid].str, g_MenPaiNpcA[menpaiid].strlink, g_ZhangMen[menpaiid]
	end
	if liupaiid == g_LiuPaiB and g_MenPaiNpcB[menpaiid] ~= nil then
		return g_MenPaiNpcB[menpaiid].liupainame, g_MenPaiNpcB[menpaiid].mpname, g_MenPaiNpcB[menpaiid].str , g_MenPaiNpcB[menpaiid].strlink, g_ZhangMen[menpaiid]
	end
	return "","","",""
end

function QuestLog_GetXiuLianMission1_NameStr( nIndex )--任务1--答题场景名和npc名
	local npcList = {	--场景名 npc名超链接
		{"#{XLRW_210725_263}","#{XLRW_210725_267}",},{"#{XLRW_210725_263}","#{XLRW_210725_268}",},{"#{XLRW_210725_263}","#{XLRW_210725_269}",},{"#{XLRW_210725_263}","#{XLRW_210725_270}",},
		{"#{XLRW_210725_263}","#{XLRW_210725_271}",},{"#{XLRW_210725_263}","#{XLRW_210725_272}",},{"#{XLRW_210725_264}","#{XLRW_210725_273}",},{"#{XLRW_210725_264}","#{XLRW_210725_274}",},
		{"#{XLRW_210725_264}","#{XLRW_210725_275}",},{"#{XLRW_210725_264}","#{XLRW_210725_276}",},{"#{XLRW_210725_264}","#{XLRW_210725_277}",},{"#{XLRW_210725_264}","#{XLRW_210725_278}",},
		{"#{XLRW_210725_265}","#{XLRW_210725_279}",},{"#{XLRW_210725_265}","#{XLRW_210725_280}",},{"#{XLRW_210725_265}","#{XLRW_210725_281}",},{"#{XLRW_210725_265}","#{XLRW_210725_282}",},
		{"#{XLRW_210725_265}","#{XLRW_210725_283}",},{"#{XLRW_210725_265}","#{XLRW_210725_284}",},{"#{XLRW_210725_266}","#{XLRW_210725_285}",},{"#{XLRW_210725_266}","#{XLRW_210725_286}",},
		{"#{XLRW_210725_266}","#{XLRW_210725_287}",},{"#{XLRW_210725_266}","#{XLRW_210725_288}",},{"#{XLRW_210725_266}","#{XLRW_210725_289}",},{"#{XLRW_210725_266}","#{XLRW_210725_290}",},
	}
	local tNpc = npcList[nIndex]
	if tNpc ~= nil then
		return tNpc[1], tNpc[2]
	end
	return "",""
end
function QuestLog_GetTarget_XiuLianMission1( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--答题场景名和npc名
	local npcindex = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )			
	local sname,npcname = QuestLog_GetXiuLianMission1_NameStr( npcindex )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_107}", sname, npcname, lpname, mpnpcnamelink)
end
function QuestLog_Complete_XiuLianMission1( nMissionIndex )		
	--答题场景名和npc名
	local npcindex = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )			
	local sname,npcname = QuestLog_GetXiuLianMission1_NameStr( npcindex )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	--任务完成情况
	return "\n"..ScriptGlobal_Format("#{XLRW_210725_499}", npcname, param1).."\n\n"..strRound
end
function QuestLog_GetTrack_XiuLianMission1( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--答题场景名和npc名
	local npcindex = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )			
	local sname,npcname = QuestLog_GetXiuLianMission1_NameStr( npcindex )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--任务追踪
	if param0 == 0 then
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_52}", sname, npcname, param1)
	else
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
end
function QuestLog_GetXiuLianMission2_NameStr( mp, nIndex )--任务2--采集数量 采集名字
	local g_ItemList = {
		[0] = { 	{num=3,name="#{XLRW_210725_291}",posname="#{XLRW_210725_612}",},	{num=3,name="#{XLRW_210725_292}",posname="#{XLRW_210725_613}",},	{num=1,name="#{XLRW_210725_293}",posname="#{XLRW_210725_614}",}, },
		[1] = { 	{num=3,name="#{XLRW_210725_297}",posname="#{XLRW_210725_618}",}, 	{num=3,name="#{XLRW_210725_298}",posname="#{XLRW_210725_619}",},	{num=1,name="#{XLRW_210725_299}",posname="#{XLRW_210725_620}",}, },
		[2] = { 	{num=3,name="#{XLRW_210725_294}",posname="#{XLRW_210725_615}",},	{num=3,name="#{XLRW_210725_295}",posname="#{XLRW_210725_616}",},	{num=1,name="#{XLRW_210725_296}",posname="#{XLRW_210725_617}",}, },
		[3] = { 	{num=3,name="#{XLRW_210725_300}",posname="#{XLRW_210725_621}",},	{num=3,name="#{XLRW_210725_301}",posname="#{XLRW_210725_622}",},	{num=1,name="#{XLRW_210725_302}",posname="#{XLRW_210725_623}",}, },
		[4] = { 	{num=3,name="#{XLRW_210725_309}",posname="#{XLRW_210725_630}",},	{num=3,name="#{XLRW_210725_310}",posname="#{XLRW_210725_631}",},	{num=1,name="#{XLRW_210725_311}",posname="#{XLRW_210725_632}",}, },
		[5] = { 	{num=3,name="#{XLRW_210725_312}",posname="#{XLRW_210725_633}",},	{num=3,name="#{XLRW_210725_313}",posname="#{XLRW_210725_634}",},	{num=1,name="#{XLRW_210725_314}",posname="#{XLRW_210725_635}",}, },
		[6] = { 	{num=3,name="#{XLRW_210725_303}",posname="#{XLRW_210725_624}",},	{num=3,name="#{XLRW_210725_304}",posname="#{XLRW_210725_625}",},	{num=1,name="#{XLRW_210725_305}",posname="#{XLRW_210725_626}",}, },
		[7] = { 	{num=3,name="#{XLRW_210725_315}",posname="#{XLRW_210725_636}",},	{num=3,name="#{XLRW_210725_316}",posname="#{XLRW_210725_637}",},	{num=1,name="#{XLRW_210725_317}",posname="#{XLRW_210725_638}",}, },
		[8] = { 	{num=3,name="#{XLRW_210725_306}",posname="#{XLRW_210725_627}",},	{num=3,name="#{XLRW_210725_307}",posname="#{XLRW_210725_628}",},	{num=1,name="#{XLRW_210725_308}",posname="#{XLRW_210725_629}",}, },
		[10] = { 	{num=3,name="#{XLRW_210725_745}",posname="#{XLRW_210725_742}",},	{num=3,name="#{XLRW_210725_746}",posname="#{XLRW_210725_743}",},	{num=1,name="#{XLRW_210725_747}",posname="#{XLRW_210725_744}",}, },
	}
	local tItem = g_ItemList[mp][nIndex]
	if tItem ~= nil then
		return tItem.num, tItem.name, tItem.posname
	end
	return 0,""
end
function QuestLog_GetTarget_XiuLianMission2( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--采集数量 采集名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local num,name,posname = QuestLog_GetXiuLianMission2_NameStr( mp, index )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_125}", posname, name, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission2( nMissionIndex )
	--采集数量 采集名字
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local num,name,posname = QuestLog_GetXiuLianMission2_NameStr( mp, index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	--任务完成情况
	return "\n"..ScriptGlobal_Format("#{XLRW_210725_501}", name, param1, num).."\n\n"..strRound
end
function QuestLog_GetTrack_XiuLianMission2( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--采集数量 采集名字
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local num,name,posname = QuestLog_GetXiuLianMission2_NameStr( mp, index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	--任务追踪
	if param0 == 0 then
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_53}", posname, name, param1, num)
	else
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
end
function QuestLog_GetXiuLianMission3_ScenePosStr( menpaiid, nIndex )--任务3--打坐地点
	local ScenePosList = { 
		[0] = {menpaiid=0,	sceneid=9,	str = {"#{XLRW_210725_639}","#{XLRW_210725_640}","#{XLRW_210725_641}",} } ,
		[1] = {menpaiid=1,	sceneid=11,	str = {"#{XLRW_210725_645}","#{XLRW_210725_646}","#{XLRW_210725_647}",} },
		[2] = {menpaiid=2,	sceneid=10,	str = {"#{XLRW_210725_642}","#{XLRW_210725_643}","#{XLRW_210725_644}",} },
		[3] = {menpaiid=3,	sceneid=12,	str = {"#{XLRW_210725_648}","#{XLRW_210725_649}","#{XLRW_210725_650}",} },
		[4] = {menpaiid=4,	sceneid=15,	str = {"#{XLRW_210725_657}","#{XLRW_210725_658}","#{XLRW_210725_659}",} },
		[5] = {menpaiid=5,	sceneid=16,	str = {"#{XLRW_210725_660}","#{XLRW_210725_661}","#{XLRW_210725_662}",} },
		[6] = {menpaiid=6,	sceneid=13,	str = {"#{XLRW_210725_651}","#{XLRW_210725_652}","#{XLRW_210725_653}",} },
		[7] = {menpaiid=7,	sceneid=17,	str = {"#{XLRW_210725_663}","#{XLRW_210725_664}","#{XLRW_210725_665}",} },
		[8] = {menpaiid=8,	sceneid=14,	str = {"#{XLRW_210725_654}","#{XLRW_210725_655}","#{XLRW_210725_656}",} },
		[10] = {menpaiid=10,sceneid=1283,str = {"#{XLRW_210725_748}","#{XLRW_210725_749}","#{XLRW_210725_750}",} },
	}
	
	if ScenePosList[menpaiid] ~= nil and ScenePosList[menpaiid].str[nIndex] ~= nil then
		return ScenePosList[menpaiid].str[nIndex]
	end
	
	return ""
end
function QuestLog_GetTarget_XiuLianMission3( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--打坐地点
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
	local posname = QuestLog_GetXiuLianMission3_ScenePosStr( mp, index )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_502}", posname, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission3( nMissionIndex )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	--任务完成情况
	return ScriptGlobal_Format("#{XLRW_210725_143}", param1).."\n\n"..strRound
end
function QuestLog_GetTrack_XiuLianMission3( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--完成情况数值
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--打坐地点
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
	local posname = QuestLog_GetXiuLianMission3_ScenePosStr( mp, index )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	local strTrack = ""
	if param0 == 0 then
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_54}", posname, param0)
	else
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetXiuLianMission4_FubenNameStr( nIndex )--任务4--副本入口npc
	local npcList = {		
	[0] = "#{XLRW_210725_540}",--少林
	[1] = "#{XLRW_210725_542}",--明教
	[2] = "#{XLRW_210725_541}",--丐帮
	[3] = "#{XLRW_210725_543}",--武当
	[4] = "#{XLRW_210725_546}",--峨嵋
	[5] = "#{XLRW_210725_547}",--星宿
	[6] = "#{XLRW_210725_544}",--天龙
	[7] = "#{XLRW_210725_548}",--天山
	[8] = "#{XLRW_210725_545}",--逍遥
	[10] = "#{XLRW_210725_753}",--曼陀
	}
	local tNpc = npcList[nIndex]
	if tNpc ~= nil then
		return tNpc
	end
	return ""
end
function QuestLog_GetXiuLianMission4_NameStr( nIndex )--任务4-BOSS名字 小怪名字
	local npcList = {		
		[1] =	{		MonsterName = "赤瞳小卒", BossName = "冶力行", 	},
		[2] =	{		MonsterName = "削面鬼人", BossName = "申屠",  },	
		[3] =	{		MonsterName = "细腰男俑", BossName = "虹七娘",  },
	}
	local tNpc = npcList[nIndex]
	if tNpc ~= nil then
		return tNpc.BossName, tNpc.MonsterName
	end
	return "",""
end
function QuestLog_GetTarget_XiuLianMission4( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--副本入口npc名字
	local fubennpcname = QuestLog_GetXiuLianMission4_FubenNameStr( mp )
	--BOSS名字 小怪名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local bossname,monstername = QuestLog_GetXiuLianMission4_NameStr( index )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_152}", fubennpcname, bossname, monstername, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission4( nMissionIndex )
	--BOSS名字 小怪名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local bossname,monstername = QuestLog_GetXiuLianMission4_NameStr( index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	--任务完成情况
	return "\n"..ScriptGlobal_Format("#{XLRW_210725_153}", bossname, param2, monstername, param1).."\n\n"..strRound
end
function QuestLog_GetTrack_XiuLianMission4( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--副本入口npc名字
	local fubennpcname = QuestLog_GetXiuLianMission4_FubenNameStr( mp )
	--BOSS名字 小怪名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local bossname,monstername = QuestLog_GetXiuLianMission4_NameStr( index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--任务追踪
	if param0 == 0 then
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_55}", fubennpcname, bossname, param2, monstername, param1 )
	else
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
end
function QuestLog_GetXiuLianMission5_NameStr( nIndex )--任务5--副本入口npc门派+名字 残影名字
	local npcList = {		
		[0] = { MonsterName = "少林残影", NPCName = "#{XLRW_210725_76}", mpname="#{XLRW_210725_43}", },--少林
		[1] = { MonsterName = "明教残影", NPCName = "#{XLRW_210725_80}", mpname="#{XLRW_210725_38}", },--明教
		[2] = { MonsterName = "丐帮残影", NPCName = "#{XLRW_210725_78}", mpname="#{XLRW_210725_39}", },--丐帮
		[3] = { MonsterName = "武当残影", NPCName = "#{XLRW_210725_82}", mpname="#{XLRW_210725_40}", },--武当
		[4] = { MonsterName = "峨嵋残影", NPCName = "#{XLRW_210725_88}", mpname="#{XLRW_210725_35}", },--峨嵋
		[5] = { MonsterName = "星宿残影", NPCName = "#{XLRW_210725_90}", mpname="#{XLRW_210725_41}", },--星宿
		[6] = { MonsterName = "天龙残影", NPCName = "#{XLRW_210725_84}", mpname="#{XLRW_210725_42}", },--天龙
		[7] = { MonsterName = "天山残影", NPCName = "#{XLRW_210725_92}", mpname="#{XLRW_210725_36}", },--天山
		[8] = { MonsterName = "逍遥残影", NPCName = "#{XLRW_210725_86}", mpname="#{XLRW_210725_37}", },--逍遥
		[10] = { MonsterName = "曼陀残影", NPCName = "#{XLRW_210725_755}", mpname="#{XLRW_210725_741}", },--曼陀
	}
	local tNpc = npcList[nIndex]
	if tNpc ~= nil then
		return tNpc.mpname, tNpc.NPCName, tNpc.MonsterName
	end
	return "","",""
end
function QuestLog_GetTarget_XiuLianMission5( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--副本入口npc名字 残影名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local fubennpcmp, fubennpcname, monstername = QuestLog_GetXiuLianMission5_NameStr( index )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_172}", fubennpcmp, fubennpcname, monstername, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission5( nMissionIndex )
	--副本入口npc名字 残影名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local fubennpcmp, fubennpcname, monstername = QuestLog_GetXiuLianMission5_NameStr( index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	--任务完成情况
	return "\n"..ScriptGlobal_Format("#{XLRW_210725_173}", param1).."\n\n"..strRound
end
function QuestLog_GetTrack_XiuLianMission5( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--副本入口npc名字 残影名字
	local index = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local fubennpcmp, fubennpcname, monstername = QuestLog_GetXiuLianMission5_NameStr( index )
	--完成情况数值
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	--任务追踪
	if param0 == 0 then
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_56}", fubennpcmp, fubennpcname, param1)
	else
		return "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
end
function QuestLog_GetXiuLianMission6_TargetNpcStr( menpaiid, nIndex )--任务6--目标npc
	local MenPaiTargetNpc = { 
		[0] = { 
				[1] = { npcname = "玄渡", namestr = "#{XLRW_210725_347}", strlink = "#{XLRW_210725_549}"}, 
				[2] = { npcname = "玄慈", namestr = "#{XLRW_210725_348}", strlink = "#{XLRW_210725_550}"}, 
				[3] = { npcname = "玄寂", namestr = "#{XLRW_210725_349}", strlink = "#{XLRW_210725_551}"}, 
				[4] = { npcname = "玄难", namestr = "#{XLRW_210725_350}", strlink = "#{XLRW_210725_552}"}, 
				[5] = { npcname = "玄灭", namestr = "#{XLRW_210725_352}", strlink = "#{XLRW_210725_554}"}, 
				[6] = { npcname = "玄鸣", namestr = "#{XLRW_210725_353}", strlink = "#{XLRW_210725_555}"}, 
				},
		[1] = {
				[1] = { npcname = "林岩", namestr = "#{XLRW_210725_361}", strlink = "#{XLRW_210741_563}"}, 
				[2] = { npcname = "方百花", namestr = "#{XLRW_210725_362}", strlink = "#{XLRW_210741_564}"}, 
				[3] = { npcname = "方腊", namestr = "#{XLRW_210725_363}", strlink = "#{XLRW_210741_565}"}, 
				[4] = { npcname = "玛拉", namestr = "#{XLRW_210725_364}", strlink = "#{XLRW_210741_566}"}, 
				[5] = { npcname = "方天定", namestr = "#{XLRW_210725_365}", strlink = "#{XLRW_210741_567}"}, 
				[6] = { npcname = "厉天佑", namestr = "#{XLRW_210725_366}", strlink = "#{XLRW_210741_568}"}, 
				},
		[2] = {
				[1] = { npcname = "奚三祁", namestr = "#{XLRW_210725_354}", strlink = "#{XLRW_210733_556}"}, 
				[2] = { npcname = "吴长风", namestr = "#{XLRW_210725_355}", strlink = "#{XLRW_210733_557}"}, 
				[3] = { npcname = "上官长雨", namestr = "#{XLRW_210725_356}", strlink = "#{XLRW_210733_558}"}, 
				[4] = { npcname = "张全祥", namestr = "#{XLRW_210725_358}", strlink = "#{XLRW_210733_560}"}, 
				[5] = { npcname = "宋慈", namestr = "#{XLRW_210725_359}", strlink = "#{XLRW_210733_561}"}, 
				[6] = { npcname = "白世镜", namestr = "#{XLRW_210725_360}", strlink = "#{XLRW_210733_562}"}, 
				},
		[3] = {
				[1] = { npcname = "张玄素", namestr = "#{XLRW_210725_368}", strlink = "#{XLRW_210749_570}"}, 
				[2] = { npcname = "俞远山", namestr = "#{XLRW_210725_369}", strlink = "#{XLRW_210749_571}"}, 
				[3] = { npcname = "鹤云道人", namestr = "#{XLRW_210725_370}", strlink = "#{XLRW_210749_572}"}, 
				[4] = { npcname = "莫太冲", namestr = "#{XLRW_210725_372}", strlink = "#{XLRW_210749_574}"}, 
				[5] = { npcname = "林灵素", namestr = "#{XLRW_210725_373}", strlink = "#{XLRW_210749_575}"}, 
				[6] = { npcname = "张中行", namestr = "#{XLRW_210725_374}", strlink = "#{XLRW_210749_576}"}, 
				},
		[4] = {
				[1] = { npcname = "崔绿华", namestr = "#{XLRW_210725_389}", strlink = "#{XLRW_210773_591}"}, 
				[2] = { npcname = "杨四娘", namestr = "#{XLRW_210725_390}", strlink = "#{XLRW_210773_592}"}, 
				[3] = { npcname = "孟青青", namestr = "#{XLRW_210725_392}", strlink = "#{XLRW_210773_594}"}, 
				[4] = { npcname = "孟龙", namestr = "#{XLRW_210725_393}", strlink = "#{XLRW_210773_595}"}, 
				[5] = { npcname = "孙二娘", namestr = "#{XLRW_210725_394}", strlink = "#{XLRW_210773_596}"}, 
				[6] = { npcname = "李十二娘", namestr = "#{XLRW_210725_395}", strlink = "#{XLRW_210773_597}"}, 
				},
		[5] = {
				[1] = { npcname = "丁春秋",  namestr = "#{XLRW_210725_396}", strlink = "#{XLRW_210781_598}"}, 
				[2] = { npcname = "韩世忠", namestr = "#{XLRW_210725_397}", strlink = "#{XLRW_210781_599}"}, 
				[3] = { npcname = "红玉", namestr = "#{XLRW_210725_398}", strlink = "#{XLRW_210781_600}"}, 
				[4] = { npcname = "出尘子", namestr = "#{XLRW_210725_399}", strlink = "#{XLRW_210781_601}"}, 
				[5] = { npcname = "施全", namestr = "#{XLRW_210725_400}", strlink = "#{XLRW_210781_602}"}, 
				[6] = { npcname = "王彦", namestr = "#{XLRW_210725_402}", strlink = "#{XLRW_210781_604}"}, 
				},
		[6] = {
				[1] = { npcname = "本因", namestr = "#{XLRW_210725_375}", strlink = "#{XLRW_210757_577}"}, 
				[2] = { npcname = "本观", namestr = "#{XLRW_210725_376}", strlink = "#{XLRW_210757_578}"}, 
				[3] = { npcname = "本相", namestr = "#{XLRW_210725_377}", strlink = "#{XLRW_210757_579}"}, 
				[4] = { npcname = "本凡", namestr = "#{XLRW_210725_378}", strlink = "#{XLRW_210757_580}"}, 
				[5] = { npcname = "破嗔", namestr = "#{XLRW_210725_380}", strlink = "#{XLRW_210757_582}"}, 
				[6] = { npcname = "盛如兰", namestr = "#{XLRW_210725_381}", strlink = "#{XLRW_210757_583}"}, 
				},
		[7] = {
				[1] = { npcname = "乌老大", namestr = "#{XLRW_210725_404}", strlink = "#{XLRW_210789_606}"}, 
				[2] = { npcname = "竹剑", namestr = "#{XLRW_210725_405}", strlink = "#{XLRW_210789_607}"}, 
				[3] = { npcname = "兰剑", namestr = "#{XLRW_210725_406}", strlink = "#{XLRW_210789_608}"}, 
				[4] = { npcname = "梅剑", namestr = "#{XLRW_210725_407}", strlink = "#{XLRW_210789_609}"}, 
				[5] = { npcname = "符敏仪", namestr = "#{XLRW_210725_408}", strlink = "#{XLRW_210789_610}"}, 
				[6] = { npcname = "菊剑",  namestr = "#{XLRW_210725_409}", strlink = "#{XLRW_210789_611}"}, 
				},
		[8] = {
				[1] = { npcname = "苏星河", namestr = "#{XLRW_210725_382}", strlink = "#{XLRW_210765_584}"}, 
				[2] = { npcname = "康广陵", namestr = "#{XLRW_210725_383}", strlink = "#{XLRW_210765_585}"}, 
				[3] = { npcname = "李傀儡", namestr = "#{XLRW_210725_384}", strlink = "#{XLRW_210765_586}"}, 
				[4] = { npcname = "秦观", namestr = "#{XLRW_210725_385}", strlink = "#{XLRW_210765_587}"}, 
				[5] = { npcname = "石甘霖", namestr = "#{XLRW_210725_386}", strlink = "#{XLRW_210765_588}"}, 
				[6] = { npcname = "冯阿三", namestr = "#{XLRW_210725_387}", strlink = "#{XLRW_210765_589}"}, 
				},
		[10] = {
				[1] = { npcname = "陶岭", namestr = "#{XLRW_210725_768}", strlink = "#{XLRW_210725_769}"},
				[2] = { npcname = "王水风", namestr = "#{XLRW_210725_758}", strlink = "#{XLRW_210725_759}"},
				[3] = { npcname = "白雪", namestr = "#{XLRW_210725_760}", strlink = "#{XLRW_210725_761}"},
				[4] = { npcname = "王语嫣", namestr = "#{XLRW_210725_762}", strlink = "#{XLRW_210725_763}"},
				[5] = { npcname = "王星浪", namestr = "#{XLRW_210725_764}", strlink = "#{XLRW_210725_765}"},
				[6] = { npcname = "阳春", namestr = "#{XLRW_210725_766}", strlink = "#{XLRW_210725_767}"},
				},
	}
	
	if MenPaiTargetNpc[menpaiid] ~= nil and MenPaiTargetNpc[menpaiid][nIndex] ~= nil then
		return MenPaiTargetNpc[menpaiid][nIndex].namestr, MenPaiTargetNpc[menpaiid][nIndex].strlink
	end
	
	return "",""
end
function QuestLog_GetTarget_XiuLianMission6( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--道具id和num
	local itemid = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local itemnum = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
	local nret, itemlc = NpcShop:GetQianWuShopItem(itemid)
	local itemname = PlayerPackage:GetItemName( itemid )
	--目标NPC
	local npcidx = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local npcname, npclink = QuestLog_GetXiuLianMission6_TargetNpcStr( mp, npcidx )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_179}", itemnum, itemlc, itemname, npclink, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission6( nMissionIndex )
	--道具id和num
	local itemid = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local itemnum = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
	local nret, itemlc = NpcShop:GetQianWuShopItem(itemid)
	local itemname = PlayerPackage:GetItemName( itemid )
	local getitem = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--目标NPC
	local npcidx = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local npcname, npclink = QuestLog_GetXiuLianMission6_TargetNpcStr( mp, npcidx )
	local finish = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--任务完成情况
	--return ScriptGlobal_Format("#{XLRW_210725_503}", itemname, getitem, itemnum).."\n\n"..strRound
	return ScriptGlobal_Format("#{XLRW_210725_729}", itemname, getitem, npcname, param0).."\n\n"..strRound	
end
function QuestLog_GetTrack_XiuLianMission6( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--道具id和num
	local itemid = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local itemnum = DataPool:GetPlayerMission_Variable( nMissionIndex, 6 )
	local nret, itemlc = NpcShop:GetQianWuShopItem(itemid)
	local itemname = PlayerPackage:GetItemName( itemid )
	local getitem = DataPool:GetPlayerMission_Variable( nMissionIndex, 5 )
	--目标NPC
	local npcidx = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )
	local npcname, npclink  = QuestLog_GetXiuLianMission6_TargetNpcStr( mp, npcidx )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local strTrack = ""
	if param0 == 0 then
		--XLRW_210725_49	前往#G洛阳#W#{_INFOAIM135,212,0,吴三}#R吴三#W处购买秘宝#Y%s0#W后，交付给#R%s1#W#r已购买%s0：%s2/1#r已交付%s1：%s3/1
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_49}", itemname, npclink, getitem, param0, npcname)
	else
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTarget_XiuLianMission7( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--目标门派
	local targetmp = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local _, targetmpname = QuestLog_GetXiuLianMission_NameStr( targetmp, 0 )
	--任务目标
	return ScriptGlobal_Format("#{XLRW_210725_189}", targetmpname, mpnpcnamelink)	
end
function QuestLog_Complete_XiuLianMission7( nMissionIndex )

	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	
	--任务完成情况
	return ScriptGlobal_Format("#{XLRW_210725_190}", param0).."\n\n"..strRound	
end
function QuestLog_GetTrack_XiuLianMission7( nMissionIndex )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--目标门派
	local targetmp = DataPool:GetPlayerMission_Variable( nMissionIndex, 3 )
	local _, targetmpname = QuestLog_GetXiuLianMission_NameStr( targetmp, 0 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if param0 == 0 then
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_50}", targetmpname, param0)
	else
		strTrack = "#W"..ScriptGlobal_Format("#{XLRW_210725_22}", mpnpcnamelink)
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTarget_XiuLianMission8( nMissionIndex )

	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( param2, param1 )
		
	local nTarget = "\n"..ScriptGlobal_Format("#{XLRW_210725_196}", mpnpcnamelink)

	return nTarget
end
function QuestLog_Complete_XiuLianMission8( nMissionIndex )

	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--任务当前环数
	local strRound = QuestLog_GetXiuLianMissionNumStr()
	
	local nComplete = "\n"..ScriptGlobal_Format("#{XLRW_210725_197}", param0).."\n\n"..strRound

	return nComplete
	
end
function QuestLog_GetTrack_XiuLianMission8( nMissionIndex )
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )
	local lpname, mpname, mpnpcname, mpnpcnamelink = QuestLog_GetXiuLianMission_NameStr( mp, lp )
	--任务追踪
	return "#W"..ScriptGlobal_Format("#{XLRW_210725_51}", mpnpcnamelink, param0)
end
-- 新天赋系统修炼任务设计 end

function QuestLog_GetTarget_2022TianFu1(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )
	--任务追踪
	
	return "#W"..ScriptGlobal_Format("#{WDEC_220425_23}", mpnpcnamelink)

	
end

function QuestLog_Complete_2022TianFu1(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )

	return "\n"..ScriptGlobal_Format("#{WDEC_220425_25}", mpnpcname, param0)
	
end

function QuestLog_GetTrack_2022TianFu1(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )

	return "#W"..ScriptGlobal_Format("#{WDEC_220425_24}", mpnpcnamelink).."\n".."   "..ScriptGlobal_Format("#{WDEC_220425_25}", mpnpcname, param0)

end

function QuestLog_GetTarget_2022TianFu2(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )
	local str = QuestLog_GetXiuLianMission_Str( mp, lp )
	return ScriptGlobal_Format("#{WDEC_220425_74}", str, mpnpcnamelink)
	
end


function QuestLog_Complete_2022TianFu2(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	return "\n"..ScriptGlobal_Format("#{WDEC_220425_67}", param0)
	
end

function QuestLog_GetTrack_2022TianFu2(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local str = QuestLog_GetXiuLianMission_Str( mp, lp )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )
	
	return "#W"..ScriptGlobal_Format("#{WDEC_220425_75}", str, mpnpcnamelink).."\n".."   "..ScriptGlobal_Format("#{WDEC_220425_67}", param0)

end

function QuestLog_GetTarget_2023TianFu3(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )
	--任务追踪
	
	return "#W"..ScriptGlobal_Format("#{WDSC_230605_11}", mpnpcnamelink)

	
end

function QuestLog_Complete_2023TianFu3(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )

	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )

	return "\n"..ScriptGlobal_Format("#{WDSC_230605_12}", mpnpcname, param0)
	
end

function QuestLog_GetTrack_2023TianFu3(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )

	return "#W"..ScriptGlobal_Format("#{WDSC_230605_59}", mpnpcnamelink).."\n".."   "..ScriptGlobal_Format("#{WDSC_230605_12}", mpnpcname, param0)
end

function QuestLog_GetTarget_2023TianFu4(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	--流派名 门派名 流派npc名
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )
	--任务追踪
	
	return "#W"..ScriptGlobal_Format("#{WDSC_230605_36}", zhangmenname,mpnpcnamelink)

	
end

function QuestLog_Complete_2023TianFu4(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	
	return "\n"..ScriptGlobal_Format("#{WDSC_230605_37}", param0)
	
end

function QuestLog_GetTrack_2023TianFu4(nSelIndex)

	local param0 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local lp = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local mp = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local lpname,mpname,mpnpcname,mpnpcnamelink,zhangmenname = QuestLog_GetXiuLianMission_TargetNameStr( mp, lp )

	return "#W"..ScriptGlobal_Format("#{WDSC_230605_94}", zhangmenname, mpnpcnamelink).."\n".."   "..ScriptGlobal_Format("#{WDSC_230605_37}", param0)

end

function QuestLog_GetXiuLianMission_Str( menpaiid, liupaiid )
	
	local str = {
		[0] = {[0] = "#{WDEC_220425_109}", [1] = "#{WDEC_220425_108}",},--少林
		[1] = {[0] = "#{WDEC_220425_113}", [1] = "#{WDEC_220425_112}",},--明教
		[2] = {[0] = "#{WDEC_220425_111}", [1] = "#{WDEC_220425_110}",},--丐帮
		[3] = {[0] = "#{WDEC_220425_114}", [1] = "#{WDEC_220425_115}",},--武当
		[4] = {[0] = "#{WDEC_220425_120}", [1] = "#{WDEC_220425_121}",},--峨嵋
		[5] = {[0] = "#{WDEC_220425_122}", [1] = "#{WDEC_220425_123}",},--星宿
		[6] = {[0] = "#{WDEC_220425_116}", [1] = "#{WDEC_220425_117}",},--天龙
		[7] = {[0] = "#{WDEC_220425_124}", [1] = "#{WDEC_220425_125}",},--天山
		[8] = {[0] = "#{WDEC_220425_118}", [1] = "#{WDEC_220425_119}",},--逍遥
		[10] = {[0] = "#{WDEC_220425_133}", [1] = "#{WDEC_220425_134}",},--曼陀
	}

	return str[menpaiid][liupaiid]
end

function QuestLog_GetTrack_MainLineMission8( nMissionIndex )

	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	if param0 == 0 then
		strTrack = "#W".."#{ZXJQ_221225_100}"
	else
		if param2 >= 1 and param2 <= 3 then
			local strSceneName, strName, nPosX, nPosZ, nSceneId = QuestLog_GetMainLineMission_NameStr( param2 )
			strTrack = string.format("#W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strName, nPosX, nPosZ, nSceneId, strName);
		end
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTrack_MainLineMission9( nMissionIndex )

	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local str = {
		[1] = "#{ZXJQ_221225_346}",
		[2] = "#{ZXJQ_221225_347}",
		[3] = "#{ZXJQ_221225_349}",
	}
	if param0 == 0 then
		strTrack = "#W"..str[param2]
	else
		if param2 >= 1 and param2 <= 3 then
			local strSceneName, strName, nPosX, nPosZ, nSceneId = QuestLog_GetMainLineMission_NameStr( param2 )
			strTrack = string.format("#W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strName, nPosX, nPosZ, nSceneId, strName);
		end
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTrack_MainLineMission10( nMissionIndex )

	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local str = {
		[1] = "#{ZXJQ_221225_415}",
		[2] = "#{ZXJQ_221225_416}",
		[3] = "#{ZXJQ_221225_517}",
	}
	if param0 == 0 then
		strTrack = "#W"..str[param2]
	else
		if param2 >= 1 and param2 <= 3 then
			local strSceneName, strName, nPosX, nPosZ, nSceneId = QuestLog_GetMainLineMission_NameStr( param2 )
			strTrack = string.format("#W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strName, nPosX, nPosZ, nSceneId, strName);
		end
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTrack_MainLineMission11( nMissionIndex )

	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local str = {
		[1] = "#{ZXJQ_221225_518}",
		[2] = "#{ZXJQ_221225_519}",
		[3] = "#{ZXJQ_221225_520}",
	}
	if param0 == 0 then
		strTrack = "#W"..str[param2]
	else
		if param2 >= 1 and param2 <= 3 then
			local strSceneName, strName, nPosX, nPosZ, nSceneId = QuestLog_GetMainLineMission_NameStr( param2 )
			strTrack = string.format("#W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strName, nPosX, nPosZ, nSceneId, strName);
		end
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetTrack_MainLineMission12( nMissionIndex )

	local param1 = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local param2 = DataPool:GetPlayerMission_Variable( nMissionIndex, 2 )

	local strTrack = ""
	local param0 = DataPool:GetPlayerMission_Variable( nMissionIndex, 0 )
	local str = {
		[1] = "#{ZXJQ_221225_521}",
		[2] = "#{ZXJQ_221225_522}",
		[3] = "#{ZXJQ_221225_523}",
	}
	if param0 == 0 then
		strTrack = "#W"..str[param2]
	else
		if param2 >= 1 and param2 <= 3 then
			local strSceneName, strName, nPosX, nPosZ, nSceneId = QuestLog_GetMainLineMission_NameStr( param2 )
			strTrack = string.format("#W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strName, nPosX, nPosZ, nSceneId, strName);
		end
	end
	--任务追踪
	return strTrack
end
function QuestLog_GetMainLineMission_NameStr( index )
	
	local str = {
	[1] = {name="墨知愁", sceneId=613, scenename="白溪湖", posx=63, posz=53},
	[2] = {name="江行云", sceneId=614, scenename="蜀南竹海", posx=37, posz=119},
	[3] = {name="阮枫眠", sceneId=615, scenename="西凉枫林", posx=65, posz=52},
	}
	if index >= 1 and index <= 3 then
		return str[index].scenename, str[index].name, str[index].posx, str[index].posz, str[index].sceneId
	end
	
	return "","",-1,-1,-1
end

--2023Q380级神兵剧情任务 -- Start
function QuestLog_GetTrack_202380SBJQ1(nSelIndex)
	local StrInfo = {
		[0] = {dist="#{SBJQ_230627_347}", target="#{SBJQ_230627_357}"}, --target有变量，2个，参数1、2
		[1] = {dist="#{SBJQ_230627_238}", target="#{SBJQ_230627_311}"}, --target有变量，1个，参数4
		[2] = {dist="#{SBJQ_230627_241}", target="#{SBJQ_230627_312}"}, --target有变量，1个，参数4
		[3] = {dist="#{SBJQ_230627_55}", target="#{SBJQ_230627_313}"}, --target有变量，1个，参数4
		[4] = {dist="#{SBJQ_230627_55}", target="#{SBJQ_230627_313}"}, --target有变量，1个，参数4 ----------
		[5] = {dist="#{SBJQ_230627_244}", target="#{SBJQ_230627_314}"}, --target有变量，1个，参数4
		[6] = {dist="#{SBJQ_230627_245}", target="#{SBJQ_230627_315}"}, --target有变量，1个，参数4
		[7] = {dist="#{SBJQ_230627_250}", target="#{SBJQ_230627_316}"}, --target有变量，1个，参数4
		[8] = {dist="#{SBJQ_230627_62}", target="#{SBJQ_230627_317}"}, --target有变量，1个，参数4
		[9] = {dist="#{SBJQ_230627_62}", target="#{SBJQ_230627_317}"}, --target有变量，1个，参数4 ----------
		[10] = {dist="#{SBJQ_230627_318}", target="#{SBJQ_230627_319}"}, --target有变量，4个，参数4、5、6、7
		[11] = {dist="#{SBJQ_230627_264}", target="#{SBJQ_230627_320}"}, --target有变量，1个，参数4
		[12] = {dist="#{SBJQ_230627_64}", target="#{SBJQ_230627_321}"}, --target有变量，1个，参数4
		[13] = {dist="#{SBJQ_230627_352}", target="#{SBJQ_230627_353}"}, --target有变量，1个，参数4 ----------
		[14] = {dist="#{SBJQ_230627_268}", target="#{SBJQ_230627_322}"}, --target有变量，1个，参数4
		[15] = {dist="#{SBJQ_230627_271}", target="#{SBJQ_230627_323}"}, --target有变量，1个，参数4、5
		[16] = {dist="#{SBJQ_230627_281}", target="#{SBJQ_230627_324}"}, --target有变量，1个，参数4、5
		[17] = {dist="#{SBJQ_230627_347}", target="#{SBJQ_230627_357}"}, --target有变量，2个，参数1、2
	}
	
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return ""
	else
		local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
		local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
		local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
		local param4 = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
		local param5 = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )
		local param6 = DataPool:GetPlayerMission_Variable( nSelIndex, 6 )
		local param7 = DataPool:GetPlayerMission_Variable( nSelIndex, 7 )		
		if param3 >= 0 and param3 <= table.getn(StrInfo) then
			local str = ""
			if param3 == 0 or param3 == 17 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param1, param2) 
			elseif param3 == 1 or param3 == 2 or param3 == 3 or param3 == 4 or param3 == 5 or param3 == 6 or param3 == 7 or param3 == 8 or param3 == 9 or param3 == 11 or param3 == 12 or param3 == 13 or param3 == 14 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param4) 
			elseif param3 == 10 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param4, param5, param6, param7) 
			elseif param3 == 15 or param3 == 16 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param4, param5) 				
			end
			return "#W"..str	
		else
			return ""
		end
	end	
end
function QuestLog_GetTrack_202380SBJQ2(nSelIndex)
	local StrInfo = {
		[0] = {dist="#{SBJQ_230627_82}", target="#{SBJQ_230627_68}"}, --target有变量，1个，参数1
		[1] = {dist="#{SBJQ_230627_195}", target="#{SBJQ_230627_325}"}, --target有变量，1个，参数4
		[2] = {dist="#{SBJQ_230627_198}", target="#{SBJQ_230627_326}"}, --target有变量，2个，参数4、5
		[3] = {dist="#{SBJQ_230627_201}", target="#{SBJQ_230627_327}"}, --target有变量，1个，参数4、5
		[4] = {dist="#{SBJQ_230627_207}", target="#{SBJQ_230627_328}"}, --target有变量，2个，参数4、5
		[5] = {dist="#{SBJQ_230627_86}", target="#{SBJQ_230627_101}"}, --target有变量，1个，参数4、5
		[6] = {dist="#{SBJQ_230627_210}", target="#{SBJQ_230627_329}"}, --target有变量，1个，参数4
		[7] = {dist="#{SBJQ_230627_213}", target="#{SBJQ_230627_330}"}, --target有变量，1个，参数4
	}
	local done = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	if done == 1 then
		return ""
	else
		local param1 = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
		local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
		local param3 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
		local param4 = DataPool:GetPlayerMission_Variable( nSelIndex, 4 )
		local param5 = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )	
		if param3 >= 0 and param3 <= table.getn(StrInfo) then
			local str = ""
			if param3 == 0 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param1) 
			elseif param3 == 1 or param3 == 6 or param3 == 7 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param4)  
			elseif param3 == 2 or param3 == 3 or param3 == 4 or param3 == 5 then
				str = StrInfo[param3].dist.."\n"..ScriptGlobal_Format(StrInfo[param3].target, param4, param5) 				
			end	
			return "#W"..str	
		else
			return ""
		end
	end		
end
--2023Q380级神兵剧情任务 -- End
--2023Q3周年庆打卡活动 任务目标特写
function QuestLog_TianDeng_isTeam(nMissionIndex)
	local isTeam = DataPool:GetPlayerMission_Variable( nMissionIndex, 4 )--4号位存是否组队接取任务
	if isTeam == 1 then
		return "#W".."#{ZNTD_230720_208}"
	else
		return "#W".."#{ZNTD_230720_118}"
	end
end

function QuestLog_GetTrack_2024DWDK(nMissionIndex)
	local idx = DataPool:GetPlayerMission_Variable( nMissionIndex, 1 )
	local str = ""
	if idx == 1 or idx == 2 then
		str = "#{HZLH_20240415_149}"
	else
		str = "#{HZLH_20240415_150}"
	end

	return "#W".."#{HZLH_20240415_148}"..str
end

function QuestLog_Complete_2024DWDK(nSelIndex)
	return "#{HZLH_20240415_138}"
end

function QuestLog_GetTarget_2024DWDK(nSelIndex)
	
	local str = {"#{HZLH_20240415_88}","#{HZLH_20240415_89}","#{HZLH_20240415_87}",}
	local idx = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )

	return "#W"..str[idx]
	
end

--2024Q2夏日冰淇淋任务目标特写
function QuestLog_GetTarget_XRBQL(nSelIndex)
		local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	
		local msgtip = {"#{XRBG_20240412_128}","#{XRBG_20240412_129}","#{XRBG_20240412_130}"}
		local str = ScriptGlobal_Format("#{XRBG_20240412_79}", msgtip[param2])
		return "#W"..str
end
--2024Q2夏日冰淇淋完成情况特写
function QuestLog_Complete_XRBQL(nSelIndex)
	local param2 = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local str = ScriptGlobal_Format("#{XRBG_20240412_80}", param2)
	return "#W"..str
end

--大话西游第一阶段主线剧情-ypl
function QuestLog_Complete_2024DHMission(nSelIndex)
	local finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local nStep = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local num1 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local num2 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	local num3 = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )
	
	local nStr = ""
	if nStep == 0 then
		nStr = "\n"..ScriptGlobal_Format("#{DHJDY_240521_189}", num1).."\n"..ScriptGlobal_Format("#{DHJDY_240521_196}", num3).."\n"..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	elseif nStep == 1 then
		nStr = "\n"..ScriptGlobal_Format("#{DHJDY_240521_189}", num1)
	elseif nStep == 2 then
		nStr = "\n"..ScriptGlobal_Format("#{DHJDY_240521_196}", num3)		
	elseif nStep == 3 then
		nStr = "\n"..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	elseif nStep == 4 then
		nStr = "\n"..ScriptGlobal_Format("#{DHJDY_240521_189}", num1).."\n"..ScriptGlobal_Format("#{DHJDY_240521_196}", num3).."\n"..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	end

	return nStr
end
function QuestLog_GetTrack_2024DHMission(nSelIndex)	
	local finish = DataPool:GetPlayerMission_Variable( nSelIndex, 0 )
	local nStep = DataPool:GetPlayerMission_Variable( nSelIndex, 1 )
	local num1 = DataPool:GetPlayerMission_Variable( nSelIndex, 2 )
	local num2 = DataPool:GetPlayerMission_Variable( nSelIndex, 3 )
	local num3 = DataPool:GetPlayerMission_Variable( nSelIndex, 5 )
	local nStr1 = "#{DHJDY_240521_132}"
	local nStr2 = ""
	if nStep == 0 then
		nStr2 = "#W".."  "..ScriptGlobal_Format("#{DHJDY_240521_189}", num1).."\n".."  "..ScriptGlobal_Format("#{DHJDY_240521_196}", num3).."\n".."  "..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	elseif nStep == 1 then
		nStr2 = "#W".."  "..ScriptGlobal_Format("#{DHJDY_240521_189}", num1)
	elseif nStep == 2 then
		nStr2 = "#W".."  "..ScriptGlobal_Format("#{DHJDY_240521_196}", num3)		
	elseif nStep == 3 then
		nStr2 = "#W".."  "..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	elseif nStep == 4 then
		nStr2 = "#W".."  "..ScriptGlobal_Format("#{DHJDY_240521_189}", num1).."\n".."  "..ScriptGlobal_Format("#{DHJDY_240521_196}", num3).."\n".."  "..ScriptGlobal_Format("#{DHJDY_240521_190}", num2)
	end	
	
	return nStr1.."\n"..nStr2
end
