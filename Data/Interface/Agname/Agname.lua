local g_Agname_Frame_UnifiedPosition;
local g_Agname_MapIndex = {}	--1.title???,2.?????
local g_Agname_LogicTypeTable = {}
local g_Agname_curselect = -1
local g_Agname_Curname = ""
local g_Agname_Time =
{
	[1] = "Mµt",	[2] = "Nh∏",	[3] = "Tam",	[4] = "T—",	[5] = "Ng˚",	[6] = "L¯c",	[7] = "Ng‡y",
}
local g_Agname_Image =
{
	[1] = "set:AgnameLayout image:AgnameLayout_Inuse",	--???
	[2] = "",	--???
	[3] = "set:AgnameLayout image:AgnameLayout_Notgain"	--???

}

local g_Agname_BarCache = {}
function Agname_PreLoad()
	this:RegisterEvent("OPEN_AGNAME");
	this:RegisterEvent("CLOSE_AGNAME");
	-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	this:RegisterEvent("ADJEST_UI_POS")
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED")	
	this:RegisterEvent("CHANGE_TITLE_STATUS")
end

function Agname_OnLoad()
	g_Agname_MapIndex = {}

  g_Agname_Frame_UnifiedPosition=AgnameFrame:GetProperty("UnifiedPosition");
end

-- OnEvent
function Agname_OnEvent(event)
	if ( event == "OPEN_AGNAME" ) then
		this:TogleShow();
		Agname_Init()
		Agname_UpdateFrame();


	end
	
	if ( event == "CLOSE_AGNAME" ) then
		Agname_CloseUI()
	end
	
		-- ”Œœ∑¥∞ø⁄≥ﬂ¥Á∑¢…˙¡À±‰ªØ
	if (event == "ADJEST_UI_POS" ) then
		Agname_Frame_On_ResetPos()
	-- ”Œœ∑∑÷±Ê¬ ∑¢…˙¡À±‰ªØ
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		Agname_Frame_On_ResetPos()
	elseif (event == "CHANGE_TITLE_STATUS") then
		if this:IsVisible() then
			Agname_SHOW_HIDE_Format()
			Agname_UpdateFrame()
		end
	end
end



function Agname_Init()
	local Show_Hide = Lua_Get_IsShow_Hide_Flag()
	if Show_Hide == 1 then

		Agname_Button_Show:SetText("#{XCHXT_180124_12}") --????
	else

		Agname_Button_Show:SetText("#{XCHXT_180124_17}") --????
	end

end

----------------------------------------------------------------------------------------
--
-- πÿ±†ΩÁ√Ê
--

function Agname_CloseUI()



end

function Agname_LeftLoad()

	--AgnameFrame_ListContent:Clear()
	AgnameFrame_ListContent:Show()
	AgnameFrame_Text:Hide()
	g_Agname_Curname = ""
	local nAgnameNum = Player:GetAgnameNum();

	--“—”µ”–≥∆∫≈«∞≈≈œ‘ æ
	g_Agname_LogicTypeTable = {}
	local alltitlelist = {}
	local count = Player:GetAllTitlesNum();    --?????????
	local index = 0
	local name = ""
	local valid = 1
	local titleindex = 0
	local curid = Player:GetCurTitleID()
	local curstr = Player:GetCurTitle()
	for i = 0 , count do
		local tableindex = index
		index,titleindex,logictype,level,bnew,name,_,_,_,_,property = Player:FeatchVaildTitle(index);
		
		if index < 0 then
			break
		else
			-- if logictype > 0 then
			-- 	table.insert(g_Agname_LogicTypeTable[logictype],titleindex)
			-- end

			local bhave,bflag,strname,_,shorname = Player:HaveTitle(titleindex)
			local bwear = 0
			if bnew == 1 then
				if titleindex == curid then
					bwear = 1
				end
			else
				if bhave == 1 and bflag == 2 then
					if curstr == strname then	--????**,???????????,???????
						bwear = 1
					end
					name = shorname
				end
				if bhave == 1 then
					if curstr == name then
						bwear = 1
					end
				end	
			end
			alltitlelist[valid] = {["name"]=name,["titleindex"]=titleindex,["tableindex"]=tableindex,["bhave"]=bhave,["property"]=property,
														["logictype"]=logictype,["level"]=level,["bnew"]=bnew,["bwear"]=bwear}

			--Agname_InsertData(valid,name,titleindex,tableindex)
			valid = valid+1
		end
	end

	table.sort(alltitlelist,function(a,b)
		if a.bhave == b.bhave then
			if a.bwear == b.bwear then
				if a.logictype == b.logictype then
					if a.level == b.level then
						return a.tableindex < b.tableindex
					else
						return a.level < b.level
					end
				else
					return a.logictype < b.logictype
				end
			else
				return a.bwear > b.bwear
			end
		else	
			return a.bhave > b.bhave
		end

	end)

	local havetypelist = {}
	for i, v in ipairs(alltitlelist) do 
		Agname_InsertData(i,v)
		if v.bhave == 1  then	--?????????
			g_Agname_LogicTypeTable[v.logictype] = v.level
		end

	end
	AgnameFrame_Text:Hide()
	AgnameFrame_ListContent:Show();

end

function Agname_InsertData(index,info)
	if g_Agname_LogicTypeTable[info.logictype] and g_Agname_LogicTypeTable[info.logictype] > info.level then
		return
	end
	if Agname_is_Sex_title(info.titleindex) == 1 then
		if Agname_Sex_title_filiter(info.titleindex) == 0 then
			return 
		end
	end
	local ItemBar = g_Agname_BarCache[index]
	if ItemBar == nil then
		 ItemBar = AgnameFrame_ListContent:AddChild("AgnameFrame_ListContent_CoinAItem")
	end
	--local ItemBar = AgnameFrame_ListContent:AddChild("AgnameFrame_ListContent_CoinAItem")
	ItemBar:GetSubItem("AgnameFrame_CoinAItem_Text"):SetText(info.name)
	ItemBar:SetEvent( "MouseLClick", "Agname_ListContent_CoinAItem_Click("..index..")" )
	if info.bwear == 1 then
		ItemBar:GetSubItem("AgnameFrame_CoinAItem_Image"):SetProperty("Image",g_Agname_Image[1]);
	elseif info.bhave == 1 then
	
		ItemBar:GetSubItem("AgnameFrame_CoinAItem_Image"):SetProperty("Image",g_Agname_Image[2]);
		
	else
		ItemBar:GetSubItem("AgnameFrame_CoinAItem_Image"):SetProperty("Image",g_Agname_Image[3]);
	end
	ItemBar:GetSubItem("AgnameFrame_CoinAItem_Image"):Show()
	if info.property and info.property ~= "" then
		ItemBar:GetSubItem("AgnameFrame_CoinAItem_Icon"):Show()
	else
		ItemBar:GetSubItem("AgnameFrame_CoinAItem_Icon"):Hide()
	end
	g_Agname_MapIndex[index] = {info.titleindex,info.tableindex};
	g_Agname_BarCache[index] = ItemBar
end


function Agname_SetTitlePos()
	local nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteHeight"))
	local nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))

	local FramH = tonumber(AgnameFrame_FenYeWindow1:GetProperty("AbsoluteHeight"))
	local FramW = tonumber(AgnameFrame_Prize1_Image:GetProperty("AbsoluteWidth"))	

	local fX = 0
	local fY = 0

	fX = math.floor(tonumber(FramW/2 - nPosX/2 ))	
	fY = math.floor(tonumber(fY+20 )	)

	AgnameFrame_PlayerTitle:SetProperty("AbsoluteXPosition", fX);	
	AgnameFrame_PlayerTitle:SetProperty("AbsoluteYPosition", fY);
end

function Agname_SetTitleanimatePos()
	fH = tonumber(AgnameFrame_TopTitleAnimate:GetProperty("AbsoluteHeight"))
	fW = tonumber(AgnameFrame_TopTitleAnimate:GetProperty("AbsoluteWidth"))	

		FramW = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))
	nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteXPosition"))
	nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteYPosition"))

	fX = math.floor(tonumber( nPosX + (FramW  * 0.5) - (fW * 0.5)))	
	fY = math.floor(tonumber(nPosY - fH/4 ))

	AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
	AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteYPosition", fY);
end



function Agname_ShowTitle(nIndex)
	local _,titleindex,logictype,level,bnew,name,desc,desc2,validtime,validtype,property = Player:FeatchVaildTitle(g_Agname_MapIndex[nIndex][2]);
	local setvalidstr = function(str) Agname_Info2_Text2:SetText(str) end

	local bHave,bflag,strname,newdesc = Player:HaveTitle(g_Agname_MapIndex[nIndex][1])
	if bHave == 1 and bflag == 2  then
		name = strname
		if g_Agname_MapIndex[nIndex][1] < 1000 then
			desc = newdesc
		end

	end
	
	
	local banimate = 0
	local animateindex = 0
	local boardindex = 0
	if bnew == 1 then
		banimate,animateindex,boardindex = Player:GetTitleAnimateInfo(g_Agname_MapIndex[nIndex][1])
	end




	if(name) then
		g_Agname_Curname = name
		local StrColorName = Player : GetSystemColorText(titleindex,name);		
		AgnameFrame_PlayerTitle:SetText(StrColorName)
		AgnameFrame_PlayerTitle:Show()
		AgnameFrame_LeftTitleAnimate:Hide()
		AgnameFrame_RightTitleAnimate:Hide()
		AgnameFrame_TopTitleAnimate:Hide()
		Agname_SetTitlePos()

		if banimate == 1 then
			--∂Øª≠µƒ«Èøˆ£®∂Øª≠ÃÊ¥˙¡À≥∆∫≈◊÷£©
			AgnameFrame_TopTitleAnimate:Show()
			local SizeX,SizeY,szName = Player:EnumFlashType(animateindex);

			AgnameFrame_TopTitleAnimate:SetProperty("AbsoluteSize", "w:"..SizeX.." ".."h:"..SizeY)	
			Agname_SetTitleanimatePos()
			AgnameFrame_TopTitleAnimate:SetProperty( "Animate", szName );			
			AgnameFrame_PlayerTitle:Hide()
		else
			if boardindex and boardindex > 0 then
				AgnameFrame_LeftTitleAnimate:Show()
				AgnameFrame_RightTitleAnimate:Show()

				local Leftname,Rightname,LeftSizeX,LeftSizeY,RightSizeX,RightSizeY,
				LeftOffsetX,LeftOffsetY,RightOffsetX,RightOffsetY = Player:EnumBoardType(boardindex);
				if Leftname then
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteSize", "w:"..LeftSizeX.." ".."h:"..LeftSizeY)
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteSize", "w:"..RightSizeX.." ".."h:"..RightSizeY)
					AgnameFrame_LeftTitleAnimate:SetProperty("Animate", Leftname)
					AgnameFrame_RightTitleAnimate:SetProperty("Animate", Rightname)
					if(string.len(Leftname) == 0) then
						AgnameFrame_LeftTitleAnimate:Play(false)
					else
						AgnameFrame_LeftTitleAnimate:Play(true)
					end
					
					if(string.len(Rightname) == 0) then
						AgnameFrame_RightTitleAnimate:Play(false)
					else
						AgnameFrame_RightTitleAnimate:Play(true)
					end

					nPosX = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteXPosition"))
					nPosY = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteYPosition"))
					local nHeight = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteHeight"))
					local nWidth = tonumber(AgnameFrame_PlayerTitle:GetProperty("AbsoluteWidth"))
					
					--Left
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX - LeftOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - LeftOffsetY))
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_LeftTitleAnimate:SetProperty("AbsoluteYPosition", fY);

					--Right
					fX = 0
					fY = 0
					fX = math.floor(tonumber(fX + nPosX + nWidth - RightOffsetX ))
					fY = math.floor(tonumber(fY + nPosY + nHeight - RightOffsetY))
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteXPosition", fX);	
					AgnameFrame_RightTitleAnimate:SetProperty("AbsoluteYPosition", fY);
					
					AgnameFrame_LeftTitleAnimate:Show()
					AgnameFrame_RightTitleAnimate:Show()
				end



			end
		end

		Agname_Info2_Text3:SetText(desc)
		Agname_Info2_Text7_1:SetText(desc2)
		if(bnew == 0) then
			if validtime < 0 then
				setvalidstr("#{XCHXT_180428_72}")
			else
				if bHave == 1 then
					local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
					if disableDayTime == 0 then
						disableDayTime =  1
					end
					setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}",math.floor( disableDayTime ) ))
				else
					local nTemp= math.floor( validtime/24 )
					if nTemp <= 0 then
						nTemp = 1
					end
					setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_74}",nTemp))
				end

			end
			if(property and string.len(property) > 0 ) then
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText(property)
			else
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			end
		else

			if validtype > 0 then
				if validtype == 1 then
					if bHave == 1 then
						local disableDayTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						if disableDayTime == 0 then
							disableDayTime =  1
						end
						setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}",math.floor( disableDayTime ) ))
					else

						local nTemp= math.floor( validtime/24 )
						if nTemp <= 0 then
							nTemp = 1
						end
						setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_74}",nTemp))
					end

				elseif validtype == 2 then
					if bHave == 1 then
						local DifDay = DataPool:GetDifDayWithServerTime(validtime,2)
						if DifDay <= 0 then
							DifDay = 1
						end
						setvalidstr(ScriptGlobal_Format("#{XCHXT_180428_73}", DifDay))
					else
						local year = math.floor(validtime/10000)
						local month = math.floor(math.mod(validtime,10000)/100)
						local day = math.mod(validtime,100)
						local str = ScriptGlobal_Format("#{XCHXT_180428_34}",year,month,day)
						setvalidstr(str)
					end
				elseif validtype == 3 then
					if bHave == 1 then
						local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						if nTrueTime == 0 then
							nTrueTime = 1
						end
						setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))

					else
						local str = ScriptGlobal_Format("#{XCHXT_180428_35}",g_Agname_Time[validtime])
						setvalidstr(str)
					end
				elseif validtype == 4 then

					if bHave == 1 then
						local nTrueTime = Player:GetTitleDisableTimeByTitleID(g_Agname_MapIndex[nIndex][1])
						if nTrueTime == 0 then
							nTrueTime = 1
						end
						setvalidstr( ScriptGlobal_Format("#{XCHXT_180428_73}", math.floor( nTrueTime )))
					else
						local str = ScriptGlobal_Format("#{XCHXT_180428_82}",g_Agname_Time[validtime])
						setvalidstr(str)
					end

				end
			else
				setvalidstr("#{XCHXT_180428_72}")
			end

			if(property and string.len(property) > 0 ) then
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText(property)
			else
				Agname_Info2_Text6:SetText("#{XCHXT_180428_37}")
				Agname_Info2_Text5_1:SetText("#{XCHXT_180322_25}")
			end
			
		end
	end


end
function Agname_UpdateFrame()
	--«Âø†
	Agname_LeftLoad()
	Agname_TitlteInfoOnChoice(1)

	Agname_Info2_Text2:SetText("")
	Agname_Info2_Text3:SetText("")
	Agname_Info2_Text5_1:SetText("")
	AgnameFrame_PlayerTitle:SetText("")
	Agname_Info2_Text7_1:SetText("")
	AgnameFrame_LeftTitleAnimate:Hide()
	AgnameFrame_RightTitleAnimate:Hide()

end

function Agname_TitlteInfoOnChoice(switch)

	if switch == 0 then
			
		Agname_AllAgname:Show()
		Agname_SelectAgname:Hide()
		Agname_Info1_Title:Hide()
		Agname_Xinxi:SetCheck(1)
	elseif switch == 1 then
		Agname_AllAgname:Hide()
		Agname_SelectAgname:Show()
		Agname_Info1_Title:SetText("")
		Agname_ShowAllAttr()
		Agname_Info1_Title:Show()
		Agname_Shuxing:SetCheck(1)
	end



end

function Agname_ShowAllAttr()
	local str = Player:calcAllEffectAgname()
	if str and str ~= "" then
		Agname_Info1_Title:SetText("#{XCHXT_180428_76}")
		Agname_Info1_MiniTitle:SetText(str)
	else
		Agname_Info1_Title:SetText("#{XCHXT_180428_76}")
		Agname_Info1_MiniTitle:SetText("#{XCHXT_180124_11}")
	end
	

end

--œ‘ æ“˛≤ÿ≥∆∫≈
function Agname_SHOW_HIDE_Clicked()
	local nAgnameNum = Player:GetAgnameNum()
	
	if nAgnameNum <= 0  then
	    PushDebugMessage("#{XCHXT_180124_15}")
	    return 
	end


	local str = Player:GetCurTitle()

	if str and string.len(str) > 0 then
		local Show_Hide = Lua_Get_IsShow_Hide_Flag()
		if Show_Hide == 1 then
			Lua_Set_IsShow_Hide_Flag(0)
		else
			Lua_Set_IsShow_Hide_Flag(1)
		end
	else
		PushDebugMessage("#{XCHXT_180428_77}")
	end
end



function Agname_SHOW_HIDE_Format()
	local str = Player:GetCurTitle()
	if str and string.len(str) > 0 then
		local Show_Hide = Lua_Get_IsShow_Hide_Flag()
		if Show_Hide == 1 then
			Agname_Button_Show:SetText("#{XCHXT_180124_12}") --????
		else
			Agname_Button_Show:SetText("#{XCHXT_180124_17}") --????
		end
	else
		--PushDebugMessage("#{XCHXT_180124_15}")
	end
end

function Agname_ListContent_CoinAItem_Click(index)
	Agname_TitlteInfoOnChoice(0)
	Agname_ShowTitle(index)
	g_Agname_curselect = index
end



function Agname_ChangeBtn_Clicked()
	
	local nAgnameNum = Player:GetAgnameNum();
	if nAgnameNum <= 0 then
		PushDebugMessage("#{XCHXT_180124_15}")
		return 
	end
	
	if g_Agname_curselect <= 0 then
		PushDebugMessage("#{XCHXT_180428_60}")
		return 
	end

	--¿œ±Ì ˝æ›√ª∑®¥¶¿Ì£¨÷ªƒ‹”√√˚◊÷¿¥±»Ωœ¡À
	local str = Player:GetCurTitle()
	if str and string.len(str)>0 and str == g_Agname_Curname then
		PushDebugMessage("#{XCHXT_180428_63}")
		return 
	end





	local nIndex = Player:GetOwnerIndexByTitleID(g_Agname_MapIndex[g_Agname_curselect][1])
	if nIndex < 0 then
		PushDebugMessage("#{XCHXT_180428_61}")
		return 

	end
	Player:AskChangeCurrentAgname(nIndex);

	--¿œ±Ìº”Ã· æÃ´ƒ—¡À£¨÷±Ω”‘⁄øÕªß∂ÀµØÃ· æ∞…
	if(string.len(g_Agname_Curname) > 0 ) then
		local str = ScriptGlobal_Format("#{XCHXT_180428_64}",g_Agname_Curname)
		PushDebugMessage(str)
	end
end

function Agname_HideTitle_Clicked()

	Agname_Currently:SetText( "Danh hiÆu hiÆn t’i: ");
	Player:SetNullAgname();
end


--================================================
-- ª÷∏¥ΩÁ√Êµƒƒ¨»œœ‡∂‘Œª÷√
--================================================
function Agname_Frame_On_ResetPos()
	AgnameFrame:SetProperty("UnifiedPosition", g_Agname_Frame_UnifiedPosition);
end

function Agname_CloseUI()

	-- ¥Úø™ªÚ†ﬂπÿ±†≥∆∫≈ΩÁ√Ê



	this:Hide();
end


function Agname_Close()


	this:Hide();
end

function Agname_Sex_title_filiter(titleid)
	local sex = Player:GetMySex()
	local woman_titleid = {1261,1262,1265,1266,1267,1268,1269,1270}
	local man_titleid = {1252,1253,1255,1256,1257,1258,1259,1260}
	if sex == 0 then
		for i=1,table.getn(woman_titleid) do
			if woman_titleid[i] == titleid then
				return 1
			end
		end
	elseif sex == 1 then
		for i=1,table.getn(man_titleid) do
			if man_titleid[i] == titleid then
				return 1
			end
		end
	end
	return 0
end
function Agname_is_Sex_title(titleid)
	local titleid_tab = {1261,1262,1265,1266,1267,1268,1269,1270,1252,1253,1255,1256,1257,1258,1259,1260}

	for i=1,table.getn(titleid_tab) do
		if titleid_tab[i] == titleid then
			return 1
		end
	end

	return 0
end
