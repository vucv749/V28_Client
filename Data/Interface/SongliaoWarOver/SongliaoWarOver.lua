
local g_SongliaoWarOver_Frame_UnifiedXPosition;
local g_SongliaoWarOver_Frame_UnifiedYPosition;
local g_SongliaoWarOver_Image = {
						[1] = "set:SongLiao02 image:HJ_Shengli",   --sheng
						[2] = "set:SongLiao02 image:HJ_Baibei", 	--Bai
						[3] = "set:SongLiao02 image:HJ_Pingju",     --ping
						[4] = "set:SongLiao02 image:HJ_Zhengduo" --weiwancheng
	}

local g_select = 0 --1:? 0:?
local g_Songliao_ItemBars 				= {}
local g_SongIsWinner = 0  --0:?? 1:?? 2:??
local g_Final = 0

local SongliaoWarOver_Battle_FourTimeEnd = 11470--SongLiaoWarSingle.lua ???????
function SongliaoWarOver_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("ADJEST_UI_POS");
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED");		
	this:RegisterEvent("SHOW_SONGLIAOWAR_SCORE_M");		
	this:RegisterEvent("REFRESH_SONGLIAOWAR_MULTI_SCORE");		
end

function SongliaoWarOver_OnLoad()
	-- ±£´æ½çÃæµÄÄ¬ÈÏÏà¶ÔÎ»ÖÃ
	g_SongliaoWarOver_Frame_UnifiedXPosition	= SongliaoWarOver : GetProperty("UnifiedXPosition");
	g_SongliaoWarOver_Frame_UnifiedYPosition	= SongliaoWarOver : GetProperty("UnifiedYPosition");
end

function SongliaoWarOver_OnEvent(event)
	if (event=="SCENE_TRANSED") then
		if(548~=GetSceneID()) then
			CSongliaoWarData:ClearSongliaoData()
		end
		if arg0=="songliao_dazhan" then
			this:Hide()
		end
	elseif (event=="PLAYER_LEAVE_WORLD") then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif (event == "UI_COMMAND") then 
		if tonumber(arg0) == 502011  then
			this:Show()
			SongliaoWarOver_Open(1)
		elseif tonumber(arg0) == 20240726  then
			local myRet, myName, myCamp, myScore= CSongliaoWarData:GetMyScore()
			if myCamp == 156 then
				SongliaoWarOver_Frame_Song_Check()
			else
				SongliaoWarOver_Frame_Liao_Check()
			end
		end

	-- ÓÎÏ·´°¿Ú³ß´ç·¢ÉúÁË±ä»¯
	elseif (event == "ADJEST_UI_POS" ) then
		SongliaoWarOver_Frame_On_ResetPos();
	-- ÓÎÏ··Ö±æÂÊ·¢ÉúÁË±ä»¯		
	elseif (event == "VIEW_RESOLUTION_CHANGED" ) then
		SongliaoWarOver_Frame_On_ResetPos();
	elseif (event == "SHOW_SONGLIAOWAR_SCORE_M" ) then
		this:Show()
		SongliaoWarOver_Open(0)
	elseif (event=="REFRESH_SONGLIAOWAR_MULTI_SCORE" and this:IsVisible()) then
		SongliaoWarOver_Open(0)
	end
end

function SongliaoWarOver_Open(final)
	g_SongIsWinner = 0
	local nTick = CSongliaoWarData:GetTick()
	if nTick >= SongliaoWarOver_Battle_FourTimeEnd then
		final = 1
	end
	
	g_Final = final
	if g_Final == 1 then
		SongliaoWarOver_Sure:Enable()
	else
		SongliaoWarOver_Sure:Disable()
	end
	local myRet, myName, myCamp, myScore= CSongliaoWarData:GetMyScore()

	if myCamp == 156 then
		if final == 1 then
		    SongliaoWarOver_Frame_Song_Check()
		end

	else
		if final == 1 then
		    SongliaoWarOver_Frame_Liao_Check()
		end

	end

	--Lua_TDU_Log("myRet="..myRet.." myName="..myName.." myCamp="..myCamp.." myScore="..myScore.." mykillNum="..mykillNum)
	
	--local nState = CSongliaoWarData:GetState()
	
	local winSong = {0,0,0,0}
	local winLiao = {0,0,0,0}

	for nState=1,4 do
		local nCampScore = CSongliaoWarData:GetCampStateScore(nState);
		--Lua_TDU_Log("songliao".."nState="..nState.." nCampScore"..nCampScore)
		if nState == 1 then --????
			
			local nStateWinner=  CSongliaoWarData:GetStateWinner(nState)
			--Lua_TDU_Log("nState"..nState.." nStateWinner="..nStateWinner)
			if nStateWinner == 1 then --?	
				SongliaoWarOver_QL:SetProperty("Visible" , "True" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "False" )
				winSong[1] = 1
			elseif nStateWinner == 2 then --?
				SongliaoWarOver_QL:SetProperty("Visible" , "False" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "True" )
				winLiao[1] = 1
			else --?
				SongliaoWarOver_QL:SetProperty("Visible" , "False" )
				SongliaoWarOver_QL2:SetProperty("Visible" , "False" )	
			end
			
		elseif nState == 2 then --????

			local nStateWinner=  CSongliaoWarData:GetStateWinner(nState)
			if nStateWinner == 1 then --?	
				SongliaoWarOver_BH:SetProperty("Visible" , "True" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "False" )
				winSong[2] = 1
			elseif nStateWinner == 2 then --?
				SongliaoWarOver_BH:SetProperty("Visible" , "False" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "True" )
				winLiao[2] = 1
			else --?
				SongliaoWarOver_BH:SetProperty("Visible" , "False" )
				SongliaoWarOver_BH2:SetProperty("Visible" , "False" )	
			end

		elseif nState == 3 then --????

			local nStateWinner=  CSongliaoWarData:GetStateWinner(nState)

			if nStateWinner == 1 then --?	
				SongliaoWarOver_XW:SetProperty("Visible" , "True" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "False" )
				winSong[3] = 1
			elseif nStateWinner == 2 then --?
				SongliaoWarOver_XW:SetProperty("Visible" , "False" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "True" )
				winLiao[3] = 1
			else --?
				SongliaoWarOver_XW:SetProperty("Visible" , "False" )
				SongliaoWarOver_XW2:SetProperty("Visible" , "False" )	
			end

		elseif nState == 4 then --????

			local nStateWinner=  CSongliaoWarData:GetStateWinner(nState)
			if nStateWinner == 1 then --?	
				SongliaoWarOver_ZQ:SetProperty("Visible" , "True" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "False" )
				winSong[4] = 1
			elseif nStateWinner == 2 then --?
				SongliaoWarOver_ZQ:SetProperty("Visible" , "False" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "True" )
				winLiao[4] = 1
			else --?
				SongliaoWarOver_ZQ:SetProperty("Visible" , "False" )
				SongliaoWarOver_ZQ2:SetProperty("Visible" , "False" )				
			end
		end
	end

	local songcnt =0 
	local liaocnt =0
	for i=1,4 do
		songcnt = songcnt + winSong[i]
		liaocnt = liaocnt + winLiao[i]
	end

	if g_Final == 1 then
		if songcnt > liaocnt then
			if myCamp ==  156 then --???
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[1])
			else
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[2])
			end
			g_SongIsWinner = 1
		elseif songcnt < liaocnt then
			if myCamp ==  156 then --???
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[2])
			else
				SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[1])
			end
			g_SongIsWinner = 2
		elseif songcnt == liaocnt then
			SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[3])
			g_SongIsWinner = 0
		end
	else
		SongliaoWarOver_Sheng:SetProperty("Image", g_SongliaoWarOver_Image[4])
	end

	SongliaoWarOver_Frame_Draw(g_Final)
	
end

function SongliaoWarOver_Close()

	--SongliaoWarOver_CleanActionItemInfo()
	--SongliaoWarOver_List:CleanAllElement("SongliaoWarOver") 
	this:Hide()
	
	--SongliaoWarOver_Time:SetProperty("Timer", "-1");
end
function SongliaoWarOver_Sure_Clicked()

	SongliaoWarOver_Close()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "Transfer" )
		Set_XSCRIPT_ScriptID(502021) --???:AllowableScriptFunc.txt???????????
		Set_XSCRIPT_ParamCount(0)
	Send_XSCRIPT()		
	--SongliaoWarOver_Time:SetProperty("Timer", "-1");
end


function SongliaoWarOver_CleanActionItemInfo()
	local nListCount = table.getn(g_Songliao_ItemBars)
	if nListCount <= 0 then
		g_Songliao_ItemBars = {}
		return
	end
	for i = 1, nListCount do
		if nil ~= g_Songliao_ItemBars[i] then
			local itemButton = g_Songliao_ItemBars[i]:GetLuaActionButton(1,"SongliaoWarOver")
			if nil ~= itemButton then
				itemButton:SetActionItem(-1)
			end
		end
	end
	g_Songliao_ItemBars = {}
end

--¸üÐÂÖ÷½çÃæÎ»ÖÃ
function SongliaoWarOver_Frame_On_ResetPos()

	SongliaoWarOver : SetProperty("UnifiedXPosition", g_SongliaoWarOver_Frame_UnifiedXPosition);
	SongliaoWarOver : SetProperty("UnifiedYPosition", g_SongliaoWarOver_Frame_UnifiedYPosition);

end

function SongliaoWarOver_Frame_Song_Check()
	SongliaoWarOver_Song_Check:SetProperty("Selected", "True"); 
	SongliaoWarOver_Liao_Check:SetProperty("Selected", "False");   
	g_select = 1
	SongliaoWarOver_Frame_Draw(g_Final)	

	local myRet, myName, myCamp, myScore= CSongliaoWarData:GetMyScore()
	if myCamp == 156 then
		SongliaoWarOver_SongCamp:SetText("B±n Phß½ng")
		SongliaoWarOver_LiaoCamp:SetText("Ð¸ch quân")
	else
		SongliaoWarOver_SongCamp:SetText("Ð¸ch quân")
		SongliaoWarOver_LiaoCamp:SetText("B±n Phß½ng")
	end
end

function SongliaoWarOver_Frame_Liao_Check()
	SongliaoWarOver_Song_Check:SetProperty("Selected", "False"); 
	SongliaoWarOver_Liao_Check:SetProperty("Selected", "True");   
	g_select = 0
	SongliaoWarOver_Frame_Draw(g_Final)	

	local myRet, myName, myCamp, myScore= CSongliaoWarData:GetMyScore()
	if myCamp == 156 then
		SongliaoWarOver_SongCamp:SetText("B±n Phß½ng")
		SongliaoWarOver_LiaoCamp:SetText("Ð¸ch quân")
	else
		SongliaoWarOver_SongCamp:SetText("Ð¸ch quân")
		SongliaoWarOver_LiaoCamp:SetText("B±n Phß½ng")
	end
end

function SongliaoWarOver_Hidden()

	PushEvent('SONGLIAOSINGLE_MINI', 1)
    this:Hide()
	
end



function SongliaoWarOver_Frame_Draw(g_Final)

	local myRet, myName, myCamp, myScore, mykillNum, myGUID,mySuccKill= CSongliaoWarData:GetMyScore()
	if myRet == nil or myRet ~= 1  then
		return
	end
	local theAction

	SongliaoWarOver_CleanActionItemInfo()
	SongliaoWarOver_List:CleanAllElement("SongliaoWarOver") 

	local nNum = CSongliaoWarData:GetPlayerNum()
	local nCount = 0
	local myCount = 0
	local selfZoneWorldID = DataPool:GetSelfZoneWorldID()

	for i = 0,nNum-1 do
		local ret,charname,camp,score,killnum, humanGUID, SuccKill,zoneworldid= CSongliaoWarData:GetScoreByIndex(i)
		--Lua_TDU_Log("List".."nNum="..nNum.." ret="..ret.." charname="..charname.." camp="..camp.." score="..score.." killnum="..killnum)
		if ret == nil or ret ~= 1  then
			continue
		end

		if 	g_select == 1 then
			if camp == 157 then
				continue
			end
		else
			if camp == 156 then
				continue
			end
		end

		local ItemBar = SongliaoWarOver_List:AddItemElement( "HJSongliaoWarOver", "LEFT", "SongliaoWarOver","" ,"")
		

		if ItemBar == nil then
			return
		end

		if g_Final == 0 then
			ItemBar:Setm_newTextShow(6)
			ItemBar:Setm_newText(6,"Chßa có")
		elseif g_Final == 1 then
			ItemBar:Setm_newTextHide(6)
		end

		if (nCount+1) == 1 then
			ItemBar:Setm_newImage(1,"SongLiao02","Win_1")
			ItemBar:Setm_newImageShow(1)
			ItemBar:Setm_newTextHide(1)
		elseif (nCount+1) == 2 then
			ItemBar:Setm_newImage(1,"SongLiao02","Win_2")
			ItemBar:Setm_newImageShow(1)
			ItemBar:Setm_newTextHide(1)
		elseif (nCount+1) == 3 then
			ItemBar:Setm_newImage(1,"SongLiao02","Win_3")
			ItemBar:Setm_newImageShow(1)
			ItemBar:Setm_newTextHide(1)
		else
			ItemBar:Setm_newImageHide(1)
			ItemBar:Setm_newTextShow(1)
		end

		if zoneworldid ~= selfZoneWorldID then
			local serverName = DataPool:GetServerName( zoneworldid )
			charname = charname.."@"..tostring(serverName)           
		end
		ItemBar:Setm_newText(1,nCount+1)
		ItemBar:Setm_newText(2,charname)
		ItemBar:Setm_newText(3,killnum)
		ItemBar:Setm_newText(4,SuccKill)
		ItemBar:Setm_newText(5,score)

		local m_nIndex,m_SongBonusItemID,m_SongBonusItemNum,m_SongBonusProNum,
		    m_LiaoBonusItemID,m_LiaoBonusItemNum,m_LiaoonusProNum,
			m_BonusItemID1,m_BonusItemNum1,m_BonusProNum1,
			m_BonusItemID2,m_BonusItemNum2,m_BonusProNum2,
			m_RYItemID,m_RYValue,m_RYVictoryValue,m_LossRYRankValue,m_RYLossValue = Lua_GetSongLiaoBonusInfo(nCount)

         --Ñ¡Ôñ ¹Ê¾ËÎ½çÃæ ËÎÓ®ÁË or Ñ¡Ôñ ¹Ê¾ÁÉ½çÃæ  ÁÉÓ®ÁË
		if ( g_select == 1 and g_SongIsWinner == 1 ) or ( g_select == 0 and g_SongIsWinner == 2 ) then

			if m_RYValue > 0 then
				theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYValue)
				itemButton  = ItemBar:GetLuaActionButton(1,"SongliaoWarOver")
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			end

			if g_select == 1 and m_SongBonusItemNum > 0 then
				local itemButton  = ItemBar:GetLuaActionButton(2,"SongliaoWarOver")
				theAction = DataPool:CreateActionItemForShow(m_SongBonusItemID, m_SongBonusItemNum)
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			elseif g_select == 0 and m_LiaoBonusItemNum > 0 then
				local itemButton  = ItemBar:GetLuaActionButton(2,"SongliaoWarOver")
				theAction = DataPool:CreateActionItemForShow(m_LiaoBonusItemID, m_LiaoBonusItemNum)
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			end

			if m_RYVictoryValue > 0 then
				itemButton  = ItemBar:GetLuaActionButton(3,"SongliaoWarOver")
				if g_Final == 1 then
					theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYVictoryValue)
					if theAction:GetID() ~= 0 then 
						itemButton:SetActionItem(theAction:GetID())
					end
				else
					ItemBar:Setm_newImageHide(4)
				end
				
			end

			if m_BonusItemNum1 > 0 then
				itemButton  = ItemBar:GetLuaActionButton(4,"SongliaoWarOver")
				if g_Final == 1 then
				    theAction = DataPool:CreateActionItemForShow(m_BonusItemID1, m_BonusItemNum1)
				    if theAction:GetID() ~= 0 then 
					    itemButton:SetActionItem(theAction:GetID())
					end
				else
					ItemBar:Setm_newImageHide(5)
				end
			end

		else
			if m_LossRYRankValue > 0 then
				itemButton  = ItemBar:GetLuaActionButton(1,"SongliaoWarOver")
				theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_LossRYRankValue)
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			end
			
			if g_select == 1 and m_SongBonusItemNum > 0 then

				local itemButton  = ItemBar:GetLuaActionButton(2,"SongliaoWarOver")
				theAction = DataPool:CreateActionItemForShow(m_SongBonusItemID, m_SongBonusItemNum)
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			elseif g_select == 0 and m_LiaoBonusItemNum > 0 then

				local itemButton  = ItemBar:GetLuaActionButton(2,"SongliaoWarOver")
				theAction = DataPool:CreateActionItemForShow(m_LiaoBonusItemID, m_LiaoBonusItemNum)
				if theAction:GetID() ~= 0 then 
					itemButton:SetActionItem(theAction:GetID())
				end
			end

			if m_RYLossValue > 0 then
				itemButton  = ItemBar:GetLuaActionButton(3,"SongliaoWarOver")
				if g_Final == 1 then
					theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYLossValue)
					if theAction:GetID() ~= 0 then 
						itemButton:SetActionItem(theAction:GetID())
					end
				else
					ItemBar:Setm_newImageHide(4)
				end
			end

			if m_BonusItemNum2 > 0 then
				itemButton  = ItemBar:GetLuaActionButton(4,"SongliaoWarOver")
				if g_Final == 1 then
					theAction = DataPool:CreateActionItemForShow(m_BonusItemID2, m_BonusItemNum2)
					if theAction:GetID() ~= 0 then 
						itemButton:SetActionItem(theAction:GetID())
					end
				else
					ItemBar:Setm_newImageHide(5)
				end
			end

		end

		-- save itembar
		table.insert( g_Songliao_ItemBars, ItemBar )
		nCount = nCount + 1

	end
	
	for i = 0,nNum -1 do
		local ret,charname,camp,score,killnum, humanGUID = CSongliaoWarData:GetScoreByIndex(i)

		if ret == nil or ret ~= 1  then
			continue
		end

		if camp ~= myCamp then
			continue
		end

		if myGUID == humanGUID then
			break	
		end
		
		myCount = myCount + 1
	end


	if g_Final == 0 then
		SongliaoWarOver_NoEnd:Show()
		SongliaoWarOver_NoEnd:SetText("Chßa có")
		SongliaoWarOver_SelfButton5:Hide()
		SongliaoWarOver_SelfButton6:Hide()
	elseif g_Final == 1 then
		SongliaoWarOver_NoEnd:Hide()
		SongliaoWarOver_SelfButton5:Show()
		SongliaoWarOver_SelfButton6:Show()
	end

	if (myCount+1) == 1 then								
		SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_1")
		SongliaoWarOver_SelfRankImage:Show()
		SongliaoWarOver_SelfRank:SetText("")
	elseif (myCount+1) == 2 then
		SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_2")
		SongliaoWarOver_SelfRankImage:Show()
		SongliaoWarOver_SelfRank:SetText("")
	elseif (myCount+1) == 3 then
		SongliaoWarOver_SelfRankImage:SetProperty("Image", "set:SongLiao02 image:Win_3")
		SongliaoWarOver_SelfRankImage:Show()
		SongliaoWarOver_SelfRank:SetText("")
	else
		SongliaoWarOver_SelfRankImage:Hide()
		SongliaoWarOver_SelfRank:SetText(myCount+1)
		
	end


	SongliaoWarOver_SelfItem:Show()
	--SongliaoWarOver_SelfRank:SetText(myCount+1)
	SongliaoWarOver_SelfName:SetText(myName)
	SongliaoWarOver_SelfKill:SetText(mykillNum)
	SongliaoWarOver_SelfFlag:SetText(mySuccKill)
	SongliaoWarOver_SelfPoints:SetText(myScore)
	
	local m_nIndex,m_SongBonusItemID,m_SongBonusItemNum,m_SongBonusProNum,
		m_LiaoBonusItemID,m_LiaoBonusItemNum,m_LiaoonusProNum,
		m_BonusItemID1,m_BonusItemNum1,m_BonusProNum1,
		m_BonusItemID2,m_BonusItemNum2,m_BonusProNum2,
		m_RYItemID,m_RYValue,m_RYVictoryValue,m_LossRYRankValue,m_RYLossValue = Lua_GetSongLiaoBonusInfo(myCount)

	if ( g_SongIsWinner == 1 and myCamp == 156 ) or ( g_SongIsWinner == 2 and myCamp == 157 ) then

		if m_RYValue > 0 then
			theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYValue)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton3:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton3:SetActionItem(-1);
			end	
		else
			SongliaoWarOver_SelfButton3:SetActionItem(-1);			
		end

		if myCamp == 156 and m_SongBonusItemID > 0 then
			theAction = DataPool:CreateActionItemForShow(m_SongBonusItemID, m_SongBonusItemNum)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton4:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton4:SetActionItem(-1);
			end	
		elseif myCamp == 157 and m_LiaoBonusItemID > 0 then
			theAction = DataPool:CreateActionItemForShow(m_LiaoBonusItemID, m_LiaoBonusItemNum)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton4:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton4:SetActionItem(-1);
			end	
		elseif myCamp == 156 and m_SongBonusItemID <= 0 then
			SongliaoWarOver_SelfButton4:SetActionItem(-1);			
		elseif myCamp == 157 and m_LiaoBonusItemID <= 0 then
			SongliaoWarOver_SelfButton4:SetActionItem(-1);		
		end

		if g_Final==1 and m_RYVictoryValue > 0 then
			theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYVictoryValue)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton5:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton5:SetActionItem(-1);
			end
		elseif g_Final==1 and m_RYVictoryValue <= 0 then	
			SongliaoWarOver_SelfButton5:SetActionItem(-1);
		end

		if g_Final==1 and m_BonusItemNum1 > 0 then
			theAction = DataPool:CreateActionItemForShow(m_BonusItemID1, m_BonusItemNum1)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton6:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton6:SetActionItem(-1);
			end		
		elseif g_Final==1 and m_BonusItemNum1 <= 0 then
			SongliaoWarOver_SelfButton6:SetActionItem(-1);			
		end

	else
		if m_LossRYRankValue > 0 then
			theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_LossRYRankValue)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton3:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton3:SetActionItem(-1);
			end
		elseif m_LossRYRankValue <= 0 then
			SongliaoWarOver_SelfButton3:SetActionItem(-1);			
		end


		if  myCamp == 156 and m_SongBonusItemID > 0 then
			theAction = DataPool:CreateActionItemForShow(m_SongBonusItemID, m_SongBonusItemNum)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton4:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton4:SetActionItem(-1);
			end
		elseif myCamp == 157 and m_LiaoBonusItemID > 0 then
			theAction = DataPool:CreateActionItemForShow(m_LiaoBonusItemID, m_LiaoBonusItemNum)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton4:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton4:SetActionItem(-1);
			end
		elseif  myCamp == 156 and m_SongBonusItemID <= 0 then
			SongliaoWarOver_SelfButton4:SetActionItem(-1);
		elseif myCamp == 157 and m_LiaoBonusItemID <= 0 then			
			SongliaoWarOver_SelfButton4:SetActionItem(-1);			
		end
	
		if  g_Final==1 and m_RYLossValue > 0 then 
			theAction = DataPool:CreateActionItemForShow(m_RYItemID, m_RYLossValue)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton5:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton5:SetActionItem(-1);
			end
		elseif  g_Final==1 and m_RYLossValue <= 0 then 
			SongliaoWarOver_SelfButton5:SetActionItem(-1);
		end

		if  g_Final==1 and m_BonusItemNum2 >0 then
			theAction = DataPool:CreateActionItemForShow(m_BonusItemID2, m_BonusItemNum2)
			if theAction:GetID() ~= 0 then 
				SongliaoWarOver_SelfButton6:SetActionItem(theAction:GetID())
			else
				SongliaoWarOver_SelfButton6:SetActionItem(-1);
			end
		elseif  g_Final==1 and m_BonusItemNum2 <= 0 then
			SongliaoWarOver_SelfButton6:SetActionItem(-1);
		end

	end


	if ( g_select == 1 and myCamp == 156 ) or ( g_select == 0 and myCamp == 157 ) then
	else
		SongliaoWarOver_SelfRank:SetText("Không có")
		SongliaoWarOver_SelfRankImage:Hide()
	end

	SongliaoWarOver_List:Flash()
end
