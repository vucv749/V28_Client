-- Èó»êÊ¯ºÏ³É½çÃæ 20161107
--
local MAX_OBJ_DISTANCE = 3.0
local objCared = -1
local npcObjId = -1

local g_RunHunShiCompound_Page = 0--????????? 1:?? 2:??
local g_RunHunShiCompound_Num = 0--???????
local g_RunHunShiCompound_Select = -1--????????????,?0??
local g_RunHunShiCompound_Index = {}--????????????????????

-- Ñ¡ÏîÐÅÏ¢
local g_RunHunShiCompound_Info = 
{
	[1] = {
		name = "#{RHSYH_161104_06}", typename = "#{RHSYH_161104_35}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_07}", },
		[2] = { subname = "#{RHSYH_161104_08}", },
		[3] = { subname = "#{RHSYH_161104_09}", },
		[4] = { subname = "#{RHSYH_161104_10}", },
		[5] = { subname = "#{RHSYH_161104_11}", },
		[6] = { subname = "#{RHSYH_161104_12}", },
		},
	[2] = {
		name = "#{RHSYH_161104_13}", typename = "#{RHSYH_161104_36}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_14}", },
		[2] = { subname = "#{RHSYH_161104_15}", },
		[3] = { subname = "#{RHSYH_161104_16}", },
		[4] = { subname = "#{RHSYH_161104_17}", },
		[5] = { subname = "#{RHSYH_161104_18}", },
		[6] = { subname = "#{RHSYH_161104_19}", },
		},
	[3] = {
		name = "#{RHSYH_161104_20}", typename = "#{RHSYH_161104_37}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_21}", },
		[2] = { subname = "#{RHSYH_161104_22}", },
		[3] = { subname = "#{RHSYH_161104_23}", },
		[4] = { subname = "#{RHSYH_161104_24}", },
		[5] = { subname = "#{RHSYH_161104_25}", },
		[6] = { subname = "#{RHSYH_161104_26}", },
		},
	[4] = {
		name = "#{RHSYH_161104_27}", typename = "#{RHSYH_161104_38}", bShow = 0, 
		[1] = { subname = "#{RHSYH_161104_28}", },
		[2] = { subname = "#{RHSYH_161104_29}", },
		[3] = { subname = "#{RHSYH_161104_30}", },
		[4] = { subname = "#{RHSYH_161104_31}", },
		[5] = { subname = "#{RHSYH_161104_32}", },
		[6] = { subname = "#{RHSYH_161104_33}", },
		},
}

-- ºÏ³ÉÊýÖµ
local g_RunHunShiCompound_Data = 
{
	-- ¿ì½Ý
	[1] = 
	{
		[1] = { newlevel = 2, needlevel = 1, needcount = 3, needmoney = 5000, },
		[2] = { newlevel = 3, needlevel = 1, needcount = 9, needmoney = 20000, },
		[3] = { newlevel = 4, needlevel = 1, needcount = 27, needmoney = 70000, },
		[4] = { newlevel = 5, needlevel = 1, needcount = 81, needmoney = 220000, },
		[5] = { newlevel = 6, needlevel = 1, needcount = 162, needmoney = 455000, },
		[6] = { newlevel = 7, needlevel = 1, needcount = 324, needmoney = 925000, },
	},
	-- Æ Í¨
	[2] = 
	{
		[1] = { newlevel = 2, needlevel = 1, needcount = 3, needmoney = 5000, },
		[2] = { newlevel = 3, needlevel = 2, needcount = 3, needmoney = 10000, },
		[3] = { newlevel = 4, needlevel = 3, needcount = 3, needmoney = 10000, },
		[4] = { newlevel = 5, needlevel = 4, needcount = 3, needmoney = 15000, },
		[5] = { newlevel = 6, needlevel = 5, needcount = 2, needmoney = 15000, },
		[6] = { newlevel = 7, needlevel = 6, needcount = 2, needmoney = 20000, },
	},
}

-- µÀ¾ß
local g_RunHunShiCompound_Item = 
{
	[1]=
	{
		20310122,	--???·?(1?)
		20310123,	--???·?(2?)
		20310124,	--???·?(3?)
		20310125,	--???·?(4?)
		20310126,	--???·?(5?)
		20310127,	--???·?(6?)
		20310128,	--???·?(7?)
		20310129,	--???·?(8?)
		20310130,	--???·?(9?)
	},
	[2]=
	{
		20310131,	--???·?(1?)
		20310132,	--???·?(2?)
		20310133,	--???·?(3?)
		20310134,	--???·?(4?)
		20310135,	--???·?(5?)
		20310136,	--???·?(6?)
		20310137,	--???·?(7?)
		20310138,	--???·?(8?)
		20310139,	--???·?(9?)
	},
	[3]=
	{
		20310140,	--???·?(1?)
		20310141,	--???·?(2?)
		20310142,	--???·?(3?)
		20310143,	--???·?(4?)
		20310144,	--???·?(5?)
		20310145,	--???·?(6?)
		20310146,	--???·?(7?)
		20310147,	--???·?(8?)
		20310148,	--???·?(9?)
	},
	[4]=
	{
		20310149,	--???·?(1?)
		20310150,	--???·?(2?)
		20310151,	--???·?(3?)
		20310152,	--???·?(4?)
		20310153,	--???·?(5?)
		20310154,	--???·?(6?)
		20310155,	--???·?(7?)
		20310156,	--???·?(8?)
		20310157,	--???·?(9?)
	},
}

--=========================================================
-- PreLoad
--=========================================================
function RunHunShiCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("SCENE_TRANSED")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY")
	this:RegisterEvent("MONEYJZ_CHANGE")
	--this:RegisterEvent("UPDATE_YUANBAO")
end

--=========================================================
-- OnLoad
--=========================================================
function RunHunShiCompound_OnLoad()

end

--=========================================================
-- OnEvent
--=========================================================
function RunHunShiCompound_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 2016110701 ) then
		local objid = Get_XParam_INT(0)
		local nPage = Get_XParam_INT(1)
		-- ¹Ø± ½çÃæ
		if objid == nil or objid < 0 or nPage == nil or nPage < 1 or nPage > 2 then
			if this:IsVisible() then
				RunHunShiCompound_Close()
			end
		-- ´ò¿ª½çÃæ
		else
			-- ¹Ø×¢npc
			npcObjId = objid
			objCared = DataPool : GetNPCIDByServerID(tonumber(objid))
			this:CareObject(objCared, 1, "RunHunShiCompound")
			-- ÏÔÊ¾½çÃæ
			this:Show()
			--g_RunHunShiCompound_Page = nPage
			RunHunShiCompound_Update(nPage)
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		-- ÖØË¢ÓÒ²àºÏ³ÉÐÅÏ¢
		RunHunShiCompound_ShowDetail()
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= objCared) then
			return
		end
		-- Èç¹ûºÍNPCµÄ¾àÀë´óÓÚÒ»¶¨¾àÀë»ò ß±»É¾³ý£¬×Ô¶¯¹Ø± 
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			-- ¹Ø± ½çÃæ
			RunHunShiCompound_Close()
		end	
	elseif ( event == "SCENE_TRANSED" ) then
		-- ¹Ø± ½çÃæ
		RunHunShiCompound_Close()
	-- ½ðÇ®±ä¸ü
	elseif event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE" then
		RunHunShiCompound_MoneyUpdate()
	-- Ôª±¦±ä¸ü
	--elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		--RunHunShiCompound_YuanbaoUpdate()
	end
end

--=========================================================
-- ¹Ø± ½çÃæ£º½Å±¾¸÷ÖÖ¹Ø± Âß¼­µ÷ÓÃn´Î µã»÷¹Ø± ½çÃæµ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_Close()
	-- Êý¾ÝÇå¿ 
	g_RunHunShiCompound_Page = 0--????????? 1:?? 2:??
	g_RunHunShiCompound_Num = 0--???????
	g_RunHunShiCompound_Select = -1--??????????
	g_RunHunShiCompound_Index = {}--????????????????????
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		g_RunHunShiCompound_Info[i].bShow = 0
	end
	
	-- ÁÐ±íÇå¿ 
	--RunHunShiCompound_Bk1:CleanAllElement("RunHunShiCompound")
	
	this:Hide()
	-- È¡Ïû¹ØÐÄ
	this:CareObject(objCared, 0, "RunHunShiCompound")
	npcObjId = -1
end

--=========================================================
-- ½ðÇ®Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î ½ðÇ®ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_MoneyUpdate()
	RunHunShiCompound_CurrentlyJiaozi : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )
	RunHunShiCompound_CurrentlyMoney : SetProperty( "MoneyNumber", tostring(Player:GetData("MONEY")) )
end

--=========================================================
-- Ôª±¦Ë¢ÐÂ£º½çÃæ¸üÐÂµ÷ÓÃÒ»´Î Ôª±¦ÊÂ¼þµ÷ÓÃÒ»´Î
--=========================================================
--function RunHunShiCompound_YuanbaoUpdate()
	--RunHunShiCompound_Cost_HaveYuanBaoNum : SetText (tostring(Player:GetData("YUANBAO")))
--end

--=========================================================
-- ½çÃæ¸üÐÂ£º·þÎñÆ÷¶Ë´ò¿ª»ò ß¸üÐÂ½çÃæµ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_Update(nPage)	
	-- ½ðÇ®ÏÔÊ¾
	RunHunShiCompound_MoneyUpdate()
	-- Ôª±¦
	--RunHunShiCompound_YuanbaoUpdate()
	
	-- ÇÐ»»Ò³Ç©
	RunHunShiCompound_SwitchPage(nPage)	
	
	--Çå¿ Ò³Ç©
	--g_RunHunShiCompound_Page = 0
	--g_RunHunShiCompound_BtnIndex = 1
	--Ä¬ÈÏÑ¡ÖÐ½ðÇ®Ò³²¢ÇÐ»»µ½¸ÃÒ³
	--local nPage = 1
	--RunHunShiCompound_SwitchPage(nPage)
end

--=========================================================
-- ÇÐ»»µ½Ö¸¶¨Ò³Ç©£º´ò¿ª½çÃæµ÷ÓÃÒ»´Î Ò³Ç©µãÑ¡µ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_SwitchPage( nPage )
	if nPage == nil or nPage < 1 or nPage > 2 then
		return
	end

	-- Ò³Ç©Ã»±ä
	if nPage == g_RunHunShiCompound_Page then
		return
	end
	
	-- È¡ÏûÔ­°´Å¥Ñ¡ÖÐ
	if g_RunHunShiCompound_Page == 1 then
		RunHunShiCompound_YeQian01:SetCheck(0)
	elseif g_RunHunShiCompound_Page == 2 then
		RunHunShiCompound_YeQian02:SetCheck(0)
	end

	-- ÐÂ°´Å¥Ñ¡ÖÐ
	if nPage == 1 then
		RunHunShiCompound_YeQian01:SetCheck(1)
	elseif nPage == 2 then
		RunHunShiCompound_YeQian02:SetCheck(1)
	end
	
	-- ±£´æµ±Ç°Ò³Ç©
	g_RunHunShiCompound_Page = nPage
	
	-- ¼ÓÔØÒ³Ç©¾ßÌåÐÅÏ¢
	RunHunShiCompound_UpdatePageInfo()
	
	-- ×ó²àÁÐ±í¼ÓÔØ
	RunHunShiCompound_LeftLoad()
end

--=========================================================
-- ¼ÓÔØÒ³Ç©¾ßÌåÐÅÏ¢£ºÇÐ»»Ò³Ç©µ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_UpdatePageInfo()
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- Ò³Ç©1£º¿ì½ÝºÏ³É
	if g_RunHunShiCompound_Page == 1 then
		-- ½éÉÜÎÄ×Ö
		RunHunShiCompound_ExplainInfo:SetText( "#{RHSYH_161104_04}" )
	-- Ò³Ç©2£ºÆ Í¨ºÏ³É
	elseif g_RunHunShiCompound_Page == 2 then
		-- ½éÉÜÎÄ×Ö
		RunHunShiCompound_ExplainInfo:SetText( "#{RHSYH_161104_57}" )
	end	
		
end

--=========================================================
-- ×ó²àÁÐ±í¼ÓÔØ£ºÇÐ»»Ò³Ç©µ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_LeftLoad()
	
	-- ÁÐ±íÇå¿ 
	RunHunShiCompound_List:ClearListBox()
	g_RunHunShiCompound_Index = {}
	
	-- Ñ¡ÏîÏÂ±ê
	local itemNum = 0
	
	-- ÏÔÊ¾ÁÐ±í
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- Ò»¼¶Ñ¡Ïî
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- ÊÇ·ñÏÔÊ¾¶þ¼¶Ñ¡Ïî
			if tInfo.bShow == 1 then				
				-- Ôö¼ÓÒ»¼¶Ñ¡Ïî
				RunHunShiCompound_List:AddItem("- "..tInfo.name, 10000+i)
				-- ÏÔÊ¾¶þ¼¶Ñ¡Ïî
				for j=1, table.getn(tInfo) do
					-- ¶þ¼¶Ñ¡Ïî
					local tSubInfo = tInfo[j]
					if tSubInfo ~= nil then
						-- Ôö¼Ó¶þ¼¶Ñ¡Ïî
						RunHunShiCompound_List:AddItem("  "..tSubInfo.subname, itemNum)
						--tSubInfo.btnIndex = itemNum
						--g_RunHunShiCompound_Index[itemNum].nIndex = i
						--g_RunHunShiCompound_Index[itemNum].nSubIndex = j
						local nItem = {}
						nItem.nIndex = i
						nItem.nSubIndex = j
						table.insert(g_RunHunShiCompound_Index,nItem)
						-- Ñ¡ÖÐÑ¡Ïî
						--if g_RunHunShiCompound_Select == -1 then
							--g_RunHunShiCompound_Select = itemNum
						--end
						--if g_RunHunShiCompound_Select == itemNum then
							--RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						--end
						-- Ä¬ÈÏÑ¡ÖÐÏî
						if itemNum == 0 then
							g_RunHunShiCompound_Select = itemNum
							RunHunShiCompound_List : SetItemSelectByItemID(g_RunHunShiCompound_Select)
						end
						-- ¶þ¼¶Ñ¡Ïî¼ÆÊýÔö¼Ó
						itemNum = itemNum + 1
					end
				end
			else
				-- Ôö¼ÓÒ»¼¶Ñ¡Ïî
				RunHunShiCompound_List:AddItem("+ "..tInfo.name, 10000+i)
			end		
		end
	end
	
	-- ¸üÐÂ¶þ¼¶Ñ¡Ïî×Ü¸öÊý
	g_RunHunShiCompound_Num = itemNum
	-- ÏÔÊ¾ÓÒ²àºÏ³ÉÐÅÏ¢
	RunHunShiCompound_ShowDetail()
	
end

--=========================================================
-- ×ó²àÁÐ±íÑ¡ÖÐ£ºÇÐ»»Ò³Ç©µ÷ÓÃÒ»´Î µã»÷Ñ¡Ïîµ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_ListBox_Selected()
	-- Ñ¡ÖÐÏî
	local nSelIndex = RunHunShiCompound_List:GetFirstSelectItem()
	if nSelIndex < 0 then
		return
	end

	-- Ñ¡ÖÐÒ»¼¶Ñ¡Ïî
	if nSelIndex > 10000 then
		-- Ò»¼¶Ñ¡ÏîÏÂ±ê
		local nIndex = nSelIndex-10000
		-- Ò»¼¶Ñ¡Ïî
		local tInfo = g_RunHunShiCompound_Info[nIndex]
		if tInfo ~= nil then
			-- ¸Ä±äÒ»¼¶Ñ¡Ïî´ò¿ª¹Ø± ×´Ì¬
			if tInfo.bShow == 1 then
				tInfo.bShow = 0
			else
				-- ¹Ø± ÆäËûÁÐ±í
				for i=1, table.getn(g_RunHunShiCompound_Info) do	
					g_RunHunShiCompound_Info[i].bShow = 0
				end
				-- µ±Ç°ÁÐ±í±äÎªÏÔÊ¾
				tInfo.bShow = 1
			end
			-- ÖØÐÂ¼ÓÔØÁÐ±í
			RunHunShiCompound_LeftLoad()
		end
		return
	end

	-- ¸üÐÂÑ¡Ïî
	g_RunHunShiCompound_Select = nSelIndex
	
	-- ÏÔÊ¾ÓÒ²àºÏ³ÉÐÅÏ¢
	RunHunShiCompound_ShowDetail()
end

--=========================================================
-- Çå¿ ÓÒ²àºÏ³ÉÐÅÏ¢
--=========================================================
function RunHunShiCompound_ClearDetail()
	-- ÏÔÊ¾¿ ÄÚÈÝ
	RunHunShiCompound_ChoiceInfo:SetText( "#{RHSYH_161104_39}" )
	RunHunShiCompound_Item:SetActionItem(-1)
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	RunHunShiCompound_Need_Number:SetText( "" )
	RunHunShiCompound_Have_Info:SetText( "#{RHSYH_161104_41}" )
	RunHunShiCompound_Have_Number:SetText( "" )
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", 0)
	-- °´Å¥ÖÃ»Ò
	RunHunShiCompound_OK:Disable()
	RunHunShiCompound_Cancel:Disable()
end

--=========================================================
-- »ñµÃÒ»¼¶¶þ¼¶Ñ¡ÏîÏÂ±ê
--=========================================================
function RunHunShiCompound_GetSubIndex(nBtnIndex)
	if nBtnIndex == nil or nBtnIndex < 0 or nBtnIndex >= g_RunHunShiCompound_Num then
		return 0,0
	end
	
	-- ÏÔÊ¾ÁÐ±í
	for i=1, table.getn(g_RunHunShiCompound_Info) do	
		-- Ò»¼¶Ñ¡Ïî
		local tInfo = g_RunHunShiCompound_Info[i]
		if tInfo ~= nil then
			-- ÏÔÊ¾¶þ¼¶Ñ¡Ïî
			for j=1, table.getn(tInfo) do
				-- ¶þ¼¶Ñ¡Ïî
				local tSubInfo = tInfo[j]
				if tSubInfo ~= nil then
					if tSubInfo.btnIndex == nBtnIndex then
						return i,j
					end
				end
			end
		end
	end

	return 0,0
end

--=========================================================
-- ÓÒ²àºÏ³ÉÐÅÏ¢£ºÑ¡ÖÐ×ó²àÁÐ±íµ÷ÓÃÒ»´Î
--=========================================================
function RunHunShiCompound_ShowDetail()
	-- Çå¿ ÐÅÏ¢
	RunHunShiCompound_ClearDetail()
	
	-- Ò³Ç©¼ì²â
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		return
	end
	
	-- Ñ¡ÖÐÏî¼ì²â
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		return
	end
	
	-- ÏÂ±ê¼ì²â	
	local tIndex = g_RunHunShiCompound_Index[g_RunHunShiCompound_Select+1]
	if tIndex == nil then
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		return
	end
	
	-- Êý¾Ý¼ì²â
	--local tInfo = g_RunHunShiCompound_Info[nIndex]
	--if tInfo == nil then
		--return
	--end	
	--local tSubInfo = tInfo[nSubIndex]
	--if tSubInfo == nil then
		--return
	--end
	local tData = g_RunHunShiCompound_Data[g_RunHunShiCompound_Page]
	if tData == nil then
		return
	end	
	local tSubData = tData[nSubIndex]
	if tSubData == nil then
		return
	end	
	local tItem = g_RunHunShiCompound_Item[nIndex]
	if tItem == nil then
		return
	end	
	local needCount = tSubData.needcount
	if needCount == nil or needCount <= 0 then
		return
	end
	local needMoney = tSubData.needmoney
	if needMoney == nil or needMoney <= 0 then
		return
	end
	local needLevel = tSubData.needlevel
	if needLevel == nil or needLevel <= 0 then
		return
	end
	local needItemId = tItem[needLevel]
	if needItemId == nil or needItemId <= 0 then
		return
	end
	local newLevel = tSubData.newlevel
	if newLevel == nil or newLevel <= 0 then
		return
	end
	local newItemId = tItem[newLevel]
	if newItemId == nil or newItemId <= 0 then
		return
	end
	local needItemName = PlayerPackage:GetItemName( needItemId )
	local newItemName = PlayerPackage:GetItemName( newItemId )
		
	-- ºÏ³ÉÌáÊ¾ÇøÓò
	local szChoiceInfo = ""
	if g_RunHunShiCompound_Page == 1 then
		szChoiceInfo = ScriptGlobal_Format("#{RHSYH_161104_58}", newItemName)
	elseif g_RunHunShiCompound_Page == 2 then
		szChoiceInfo = ScriptGlobal_Format("#{RHSYH_161201_61}", newItemName)
	end
	RunHunShiCompound_ChoiceInfo:SetText( szChoiceInfo )

	-- µÀ¾ß ¹Ê¾ÇøÓò
	local theAction = DataPool:CreateActionItemForShow(newItemId, 1)
	if theAction:GetID() ~= 0 then
		RunHunShiCompound_Item:SetActionItem(theAction:GetID())
	end
			
	-- ÐèÒª¸öÊýÇøÓò
	RunHunShiCompound_Need_Info:SetText( "#{RHSYH_161104_40}" )
	local szNeedCount = ScriptGlobal_Format("#{RHSYH_161122_60}", needCount, needItemName)
	RunHunShiCompound_Need_Number:SetText( szNeedCount )
	
	-- ÓµÓÐ¸öÊýÇøÓò
	RunHunShiCompound_Have_Info:SetText( "#{RHSYH_161104_41}" )
	local nHaveCount = PlayerPackage:CountAvailableItemByIDTable(needItemId)
	local szHaveCount = ""
	if nHaveCount >= needCount then
		szHaveCount = ScriptGlobal_Format("#{RHSYH_161122_60}", nHaveCount, needItemName)
	else
		szHaveCount = ScriptGlobal_Format("#{RHSYH_161118_59}", nHaveCount, needItemName)
	end
	RunHunShiCompound_Have_Number:SetText( szHaveCount )
	
	-- ºÏ³ÉÏûºÄÇøÓò
	RunHunShiCompound_DemandMoney:SetProperty("MoneyNumber", needMoney)
	
	-- °´Å¥ÆôÓÃ
	RunHunShiCompound_OK:Enable()
	RunHunShiCompound_Cancel:Enable()

end

--=========================================================
-- ºÏ³ÉÊÂ¼þÏìÓ¦
--=========================================================
function RunHunShiCompound_HeCheng()
	-- Ò³Ç©¼ì²â
	if g_RunHunShiCompound_Page == nil or g_RunHunShiCompound_Page < 1 or g_RunHunShiCompound_Page > 2 then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- Ñ¡ÖÐÏî¼ì²â
	if g_RunHunShiCompound_Select == nil or g_RunHunShiCompound_Select < 0 or g_RunHunShiCompound_Select >= g_RunHunShiCompound_Num then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end
	
	-- ÏÂ±ê¼ì²â	
	local tIndex = g_RunHunShiCompound_Index[g_RunHunShiCompound_Select+1]
	if tIndex == nil then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end	
	local nIndex = tIndex.nIndex
	local nSubIndex = tIndex.nSubIndex
	if nIndex == nil or nIndex <= 0 or nSubIndex == nil or nSubIndex <= 0 then
		PushDebugMessage("#{RHSYH_161104_48}")
		return
	end

	-- ÅÐ¶ÏÊÇ·ñÎª°²È«Ê±¼ä
	--if (tonumber(DataPool:GetLeftProtectTime()) > 0) then
		--PushDebugMessage("#{KPWFS_131112_20}")
		--return
	--end
	--ÅÐ¶Ïµç»°ÃÜ±£ºÍ¶þ¼¶ÃÜÂë±£»¤
	--if CheckPhoneMibaoAndMinorPassword() ~= 1 then		
		--return
	--end
		
	-- ºÏ³É²Ù×÷
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "RunHunShiCompound_New" )
		Set_XSCRIPT_ScriptID(809270)
		Set_XSCRIPT_Parameter(0,npcObjId)--npcid
		Set_XSCRIPT_Parameter(1,g_RunHunShiCompound_Page)--1??2??
		Set_XSCRIPT_Parameter(2,nIndex)--??
		Set_XSCRIPT_Parameter(3,nSubIndex)--???
		Set_XSCRIPT_Parameter(4,0)--????
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	
end
