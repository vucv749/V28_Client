-------∏ªº◊ÃÏœ¬ ≈≈––∞Ò
-------!!!reloadscript =FujiatianxiaTopList

local g_FujiatianxiaTopList_Frame_UnifiedXPosition;
local g_FujiatianxiaTopList_Frame_UnifiedYPosition;

--◊Ó¥Û…œ∞Ò ˝
local g_MaxPlayer = 50
local g_NeedLevel = 60
local g_TargetId = -1
--nType == RANKINGLIST_TYPE_FUJIATIANXIA
local g_nType = -1
local g_self_nType = -1 
--RankingList.txt †ºŒª
local g_ZhanWei = 4
--MD_PAOSHANG_MAXMONEY
local g_MD_Point = 827    --????????

local g_MenPaiName = {
		[0] = "#{XQ_MP_1}",    --??
		[1] = "#{XQ_MP_2}",    --??
		[2] = "#{XQ_MP_3}",    --??
		[3] = "#{XQ_MP_4}",    --??
		[4] = "#{XQ_MP_5}",    --??
		[5] = "#{XQ_MP_6}",    --??
		[6] = "#{XQ_MP_7}",    --??
		[7] = "#{XQ_MP_8}",    --??
		[8] = "#{XQ_MP_9}",    --??
		[9] = " ",         --???
		[10] = "#{MPZH_180719_16}",    --??
}

-- local g_MenPaiPic = {
-- 	[0] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconShaolin_Name",    --…Ÿ¡÷
-- 	[1] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconMingjiao_Name",    --√˜ΩÃ
-- 	[2] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconGaibang_Name",    --ÿ§∞Ô
-- 	[3] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconWudang_Name",    --Œ‰µ±
-- 	[4] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconEmei_Name",    --∂Î√º
-- 	[5] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconXingsu_Normal",    --–«Àﬁ
-- 	[6] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconTianlong_Name",    --ÃÏ¡˙
-- 	[7] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconTianshan_Name",    --ÃÏ…Ω
-- 	[8] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconXiaoyao_Name",    --Â–“£
-- 	[9] = "set:HJ_MenPaiLogo02 image:HJ_PatternIconEmei_Normal",         --Œﬁ√≈≈…
-- }

-- --«∞3√˚
-- local g_TOP_Name = { } --√˚◊÷
-- local g_TOP_Level = { } --µ»º∂
-- local g_TOP_PIC = { } --√≈≈…Õº±Í

--local g_Choice_Day = { } --—°‘Ò≤Èø¥ÃÏ ˝

function FujiatianxiaTopList_PreLoad()
	--
	this:RegisterEvent("OPEN_FUJIATIANXIA_RANKINGLIST");
	
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end


function FujiatianxiaTopList_OnLoad()

	g_FujiatianxiaTopList_Frame_UnifiedXPosition	= FujiatianxiaTopList_Frame : GetProperty("UnifiedXPosition");
	g_FujiatianxiaTopList_Frame_UnifiedYPosition	= FujiatianxiaTopList_Frame : GetProperty("UnifiedYPosition");
	
	-- --«∞3√˚
	-- g_TOP_Name[1] = FujiatianxiaTopList_RightContent_Top1_Text1
	-- g_TOP_Name[2] = FujiatianxiaTopList_RightContent_Top2_Text1
	-- g_TOP_Name[3] = FujiatianxiaTopList_RightContent_Top3_Text1

	-- g_TOP_Level[1]= FujiatianxiaTopList_RightContent_Top1_Text2
	-- g_TOP_Level[2]= FujiatianxiaTopList_RightContent_Top2_Text2
	-- g_TOP_Level[3]= FujiatianxiaTopList_RightContent_Top3_Text2

	-- g_TOP_PIC[1]= FujiatianxiaTopList_MenPai1
	-- g_TOP_PIC[2]= FujiatianxiaTopList_MenPai2
	-- g_TOP_PIC[3]= FujiatianxiaTopList_MenPai3

--	g_Choice_Day[1] = FujiatianxiaTopList_But1
--	g_Choice_Day[2] = FujiatianxiaTopList_But2
--	g_Choice_Day[3] = FujiatianxiaTopList_But3
--	g_Choice_Day[4] = FujiatianxiaTopList_But4
--	g_Choice_Day[5] = FujiatianxiaTopList_But5
--	g_Choice_Day[6] = FujiatianxiaTopList_But6
--	g_Choice_Day[7] = FujiatianxiaTopList_But7

end

function FujiatianxiaTopList_OnEvent(event)

	if (event=="OPEN_FUJIATIANXIA_RANKINGLIST") then 

		g_nType = tonumber(arg0)
		--NPC care
		g_TargetId = tonumber(arg1)
		FujiatianxiaTopList_BeginCareObject( tonumber(arg1) )

		FujiatianxiaTopList_Update()
		
--		local Choice = g_nType - g_ZhanWei + 1
--		FujiatianxiaTopList_SetCheck(Choice)

		this : Show()

	elseif (event=="PLAYER_LEAVE_WORLD") then 
		FujiatianxiaTopList_Cancel_Clicked()
		
	elseif (event == "ADJEST_UI_POS" ) then	
		FujiatianxiaTopList_Frame_On_ResetPos()
		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		FujiatianxiaTopList_Frame_On_ResetPos()
		
	end
end

--∏¸–¬–≈œ¢
function FujiatianxiaTopList_Update()	

	FujiatianxiaTopList_RecordInfo()	
	FujiatianxiaTopList_MyInfo()
	
end


function FujiatianxiaTopList_Init( )
	
	FujiatianxiaTopList_RightContent_List:Clear()
	
end


function FujiatianxiaTopList_RecordInfo( )

	--≥ı ºªØList
	FujiatianxiaTopList_Init( )

	--»°µ√…œ∞Ò ˝¡ø
	local dataCnt = DataPool:lua_GetJSRankingListDataCount( g_nType )
	--◊Ó¥Û…œ∞Ò ˝
	for index=0, g_MaxPlayer-1 do
		if index < dataCnt then
			--”–º«¬º
			FujiatianxiaTopList_HaveRecord( index )
		else
			--Œﬁº«¬º
			FujiatianxiaTopList_NoRecord( index )
		end
	end
	
end


function FujiatianxiaTopList_HaveRecord( index )
	local nRank, name, usetime, state = DataPool:lua_GetJSRankingListInfo(g_nType, index);
	if nRank == nil then
		return
	end
			
	local ItemBar = FujiatianxiaTopList_RightContent_List:AddChild( "FujiatianxiaTopList_RightContent_Shilian_Item")
	if ItemBar == nil then
		return 
	end
		
	
	local bValid, memguid, memname, menpai, level = DataPool:lua_GetJSRankingListMemberInfo(g_nType, index, 0);

	if bValid ~= nil and bValid == 1 then

		--≈≈√˚
		local Shilian_Text1 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text1")
		Shilian_Text1:SetText(index+1)
		--√˚≥∆
		local Shilian_Text2 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text2")
		Shilian_Text2:SetText(memname)
		--ªı±“ ˝¡ø
		local Shilian_Text3 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text5")
		Shilian_Text3:SetText(usetime)
		ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_jinbi"):Show() --???????
		--µ»º∂
		local Shilian_Text4 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text4")
		Shilian_Text4:SetText(level)
		--√≈≈…
		local Shilian_Text5 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text3")
		Shilian_Text5:SetText(g_MenPaiName[menpai])

		-- --√˚¥Œ «∞3√˚
		-- if index <= 2 then
		-- 	g_TOP_Level[index+1]:SetText(level)
		-- 	g_TOP_Name[index+1]:SetText(memname)

		-- 	--√≈≈…Õ∑œÒ
		-- 	g_TOP_PIC[index+1]:SetProperty("Image", g_MenPaiPic[menpai])
			
		-- 	-- FujiatianxiaTopList_RightContent_Top1_Image:SetProperty("Image", "set:GirlProtagonist2 image:GirlProtagonist2_1")

		-- 	-- PushDebugMessage(g_MenPaiPic[menpai])
		-- 	-- PushDebugMessage("bValid"..bValid.." memname"..memname.." menpai"..menpai.." level"..level)
		-- end

	end

end


function FujiatianxiaTopList_NoRecord( index )

	local ItemBar = FujiatianxiaTopList_RightContent_List:AddChild( "FujiatianxiaTopList_RightContent_Shilian_Item")
	if ItemBar == nil then
		return 
	end

	--≈≈√˚
	local Shilian_Text1 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text1")
	Shilian_Text1:SetText(index+1)
	--√˚≥∆
	local Shilian_Text2 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text2")
	Shilian_Text2:SetText("#{PSGN_180515_218}")
	--ªı±“ ˝¡ø
	local Shilian_Text3 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text5")
	Shilian_Text3:SetText(" ")
	ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_jinbi"):Hide() --???????
	--µ»º∂
	local Shilian_Text4 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text4")
	Shilian_Text4:SetText(" ")
	--√≈≈…
	local Shilian_Text5 = ItemBar:GetSubItem("FujiatianxiaTopList_RightContent_Shilian_Text3")
	Shilian_Text5:SetText(" ")

	-- --√˚¥Œ «∞3√˚
	-- if index <= 2 then
	-- 	g_TOP_Level[index+1]:SetText("0")
	-- 	g_TOP_Name[index+1]:SetText("V∏ trÌ cÚn trØng")

	-- 	--√≈≈…Õ∑œÒ
	-- 	g_TOP_PIC[index+1]:SetProperty("Image", g_MenPaiPic[9])
	-- end

end

--	∏ˆ»À–≈œ¢
function FujiatianxiaTopList_MyInfo()

	if this:IsVisible() then
		if g_self_nType ~= g_nType then
			return
		end
    else
		g_self_nType = g_nType
	end

	--«Â≥˝∏ˆ»À–≈œ¢
	FujiatianxiaTopList_Clean_MyInfo()

	-- local nRank,name,usetime,nlevel,nMenPai,state = DataPool:lua_GetFuJiaTianXiaRankingListInfo(g_self_nType,0)

	-- 	FujiatianxiaTopList_RightContent_ListInfo1 ≈≈√˚
	-- 	FujiatianxiaTopList_RightContent_ListInfo2 √˚◊÷
	-- 	FujiatianxiaTopList_RightContent_ListInfo3  ˝¡ø
	-- 	FujiatianxiaTopList_RightContent_ListInfo4 µ»º∂
	-- 	FujiatianxiaTopList_RightContent_ListInfo5 √≈≈…

	--∏ˆ»À≈≈√˚
	local myRank = -1
	--∏ˆ»À ±º‰
	local myRankTime = 0

	local nDataCount = DataPool:lua_GetJSRankingListDataCount(g_self_nType)
	if nDataCount <= 0 then
		FujiatianxiaTopList_RightContent_ListInfo1:SetText("#{PSGN_180515_217}")
		return
	end

	for i = 0, nDataCount-1 do
		local nRank,name,usetime,state = DataPool:lua_GetJSRankingListInfo(g_self_nType,i)
		for j = 1,6 do
			local bValid, memguid, membname,menpai,level,score = DataPool:lua_GetJSRankingListMemberInfo(g_self_nType,i,j-1);
			if bValid == 1 and myRank < 0 then
				if memguid == Player:GetGUID() then
					myRank = nRank
					myRankTime = usetime
					break
				end
			end
		end

		if myRank ~= -1 then
			break
		end
	end

	if myRank == -1 then
		FujiatianxiaTopList_RightContent_ListInfo1:SetText("#{PSGN_180515_217}")
	else
		FujiatianxiaTopList_RightContent_ListInfo1:SetText(myRank+1)
	end
	
	--◊ Ω ˝¡ø
	local myPoint = DataPool:GetPlayerMission_DataRound(g_MD_Point)
	if myPoint <= 0 then
		myPoint = 0
	end

	local myname = Player:GetName() --????
	local myLevel = Player:GetLevel() --????
	local myMP = Player:GetData("MEMPAI") --????

	FujiatianxiaTopList_RightContent_ListInfo2:SetText(myname)
	FujiatianxiaTopList_RightContent_ListInfo5:SetText(myPoint)
	FujiatianxiaTopList_RightContent_ListInfo4:SetText(myLevel)
	FujiatianxiaTopList_RightContent_ListInfo3:SetText(g_MenPaiName[myMP])
	FujiatianxiaTopList_RightContent_ListInfo5_jinbi:Show()

end

--	«Â≥˝∏ˆ»À–≈œ¢
function FujiatianxiaTopList_Clean_MyInfo()
	FujiatianxiaTopList_RightContent_ListInfo1:SetText("")
	FujiatianxiaTopList_RightContent_ListInfo2:SetText("")
	FujiatianxiaTopList_RightContent_ListInfo3:SetText("")
	FujiatianxiaTopList_RightContent_ListInfo4:SetText("")
	FujiatianxiaTopList_RightContent_ListInfo5:SetText("")
	FujiatianxiaTopList_RightContent_ListInfo5_jinbi:Hide()
end

function FujiatianxiaTopList_Frame_On_ResetPos()

	FujiatianxiaTopList_Frame : SetProperty("UnifiedXPosition", g_FujiatianxiaTopList_Frame_UnifiedXPosition);
	FujiatianxiaTopList_Frame : SetProperty("UnifiedYPosition", g_FujiatianxiaTopList_Frame_UnifiedYPosition);

end

function FujiatianxiaTopList_Cancel_Clicked()
	this:Hide()
end

function FujiatianxiaTopList_On_Hide()
	FujiatianxiaTopList_Cancel_Clicked()
end


--=========================================================
--ø™ ºπÿ–ƒNPC
--=========================================================
function FujiatianxiaTopList_BeginCareObject(objCaredId)
	
	g_TargetId = objCaredId
	if g_TargetId <= -1 then
		FujiatianxiaTopList_Cancel_Clicked()
		return
	end

	local objId = DataPool : GetNPCIDByServerID(g_TargetId)
	if objId <= -1 then
		return
	end
		
	this : CareObject( objId, 1, "FujiatianxiaTopList_RightContent_List" )
end


--function FujiatianxiaTopList_RightBut2_Click(nIndex)
--
--	--…Ë÷√∞¥≈•◊¥Ã¨
--	FujiatianxiaTopList_SetCheck(nIndex)
--
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("OpenRankList_Num");
--		Set_XSCRIPT_ScriptID(890042);
--		Set_XSCRIPT_Parameter(0,g_TargetId)
--		Set_XSCRIPT_Parameter(1,nIndex-1+g_ZhanWei)
--		Set_XSCRIPT_ParamCount(2);
--	Send_XSCRIPT();
--
--
--end
--
----…Ë÷√∞¥≈•◊¥Ã¨
--function FujiatianxiaTopList_SetCheck(nIndex)
--
--	--≤Œ ˝–£—È
--	if nIndex < 1 or nIndex > 7 then
--		return
--	end
--	for index=1,table.getn(g_Choice_Day)  do
--		if nIndex == index then
--			g_Choice_Day[index]:SetCheck(1);
--		else
--			g_Choice_Day[index]:SetCheck(0);
--		end
--	end
--
--end

