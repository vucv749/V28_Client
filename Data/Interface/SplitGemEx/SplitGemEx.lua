-- !!!reloadscript =SplitGemEx

--新宝石摘除 KK
local g_SplitGemEx_CareObj = -1
local g_SplitGemEx_Frame_UnifiedPosition
local g_SplitGemEx_Equip_ID = -1
local g_SplitGemEx_Equip_pos = -1
local g_SplitGemEx_Material_ID = -1
local g_SplitGemEx_Material_pos = -1
local g_SplitGemEx_Gems
local g_SplitGemEx_Selected = -1
local g_SplitGemEx_YuanbaoPay = 1
g_SplitGemEx_Material_Buy = -1
local g_SplitGemEx_npcSid = -1
local g_SplitGemEx_MatTab = {
	[1]=30900037,
	[2]=30900037,
	[3]=30900038,
	[4]=30900039,
	[5]=30900040,
	[6]=30900041,
	[7]=30900042,
	[8]=30900043,
	[9]=30900044,
}

-- 所有神器都可以打四孔 by lishilong 2016-8-23
-- local EQUIP_SHENQI_BEGIN = 10300000
-- local EQUIP_SHENQI_END = 10399999

--four hole 80~90equip
local g_SplitGemEx_four_80_ID = 
{
	--新增包括80~89级的手工装备、套装（师门、秦皇、玄昊）、神器 
	10200018,10201018,10202018,10203018,10204018,10205018,10210018,10210038,10210058,10211018,
	10211038,10211058,10212018,10212038,10212058,10213018,10213038,10213058,10214018,10215018,
	10220019,10221019,10222019,10222033,10222034,10223019,10223033,10223034,10300004,10300006,
	10301000,10301198,10302004,10302006,10302008,10302010,10303000,10304004,10304006,10304008,
	10305004,10305006,10305008,10410025,10410033,10510017,10510047,10510077,10511007,10511037,
	10511067,10512017,10512047,10512077,10514007,10514017,10514037,10514047,10514067,10514077,
	10515027,10515057,10515087,10520027,10520057,10520087,10521007,10521017,10521027,10521037,
	10521047,10521057,10521067,10521077,10521087,10522007,10522037,10522067,10523017,10523047,
	10523077,10552027,10552057,10552087,10553007,10553027,10553037,10553057,10553067,10553087,
	10400075,10402075,10404072,10405071,10412081,10412083,10413084,10413086,10422122,10422124,
	10423047,10423049,10510092,10510093,10510094,10510095,10511094,10511095,10512090,10512091,
	10514101,10514102,10514103,10514104,10522099,10522100,10523099,10523100,
	10306004,10306006,10306008,--新门派曼陀神器
}
--four hole 90+ equip
local g_SplitGemEx_four_ID = 
{
	10514091,10514092,10514093,10514094,10514095,10514096,10514097,10514098,10515090,10515091,
	10515092,10515093,10515094,10515095,10515096,10515097,10515098,10521090,10521091,10521092,
	10521093,10521094,10521095,10521096,10521097,10521098,10522090,10522091,10522092,10522093,
	10522094,10522095,10522096,10522097,10522098,10523090,10523091,10523092,10523093,10523094,
	10523095,10523096,10523097,10523098,10514090,
	-- 褚少微，2008.6.12。添加102神器极限打孔
	10300100,10300101,10300102, 10301100,10301101,10301102, 10301200,10301201,10301202, 
	10302100,10302101,10302102, 10303100,10303101,10303102, 10303200,10303201,10303202,
	10304100,10304101,10304102, 10305100,10305101,10305102, 10305200,10305201,10305202,
	10422016,10423024,10422149,	10422150,
	--胡凯，2008.8.29。旧100套（五件套）及新96套开放极限打孔
	10510009,10510019,10510029,10510039,10510049,10510059,10510069,10510079,10510089,10511009,
	10511019,10511029,10511039,10511049,10511059,10511069,10511079,10511089,10512009,10512019,
	10512029,10512039,10512049,10512059,10512069,10512079,10512089,10513009,10513019,10513029,
	10513039,10513049,10513059,10513069,10513079,10513089,10511096,10512092,10520092,10522101,
	10523101,10511097,10512093,10520093,10522102,10523102,10511098,10512094,10520094,10522103,
	10523103,10511099,10512095,10520095,10522104,10523104,
	--胡凯，2008.9.18。90级以上（含90）生活技能产出的戒指，护符，肩开放极限打孔
	10215020,10222020,10223020,10222035,10222036,10223035,10223036,
	--胡凯，2008.11.11。90级以上（含90）手工装备开放极限打孔（鞋，腰带，护腕，手套，头盔，武器，护甲，项链）
	10200019,10200020,10201019,10201020,10202019,10202020,10203019,10203020,10204019,10204020,
	10205019,10205020,10210020,10210040,10210060,10213020,10213040,10213060,10212020,10212040,
	10212060,10211020,10211040,10211060,10214020,10221020,10220020,
	--zchw，2008-11-17  TT：41140 90门派套，92级神器开放第四孔													
	10510008,10510038,10510068,
	10511018,10511028,10511048,10511058,10511078,10511088,10512008,10512038,
	10512068,10513008,10513018,10513028,10513038,10513048,10513058,10513068,
	10513078,10513088,10514028,10514058,10514088,10520018,10520028,10520048,
	10520058,10520078,10520088,10521028,10521058,10521088,10522018,10522048,
	10522078,10552008,10552038,10552068,10553008,10553018,10553038,10553048,
	10553068,10553078,
	--zchw 2008-11-26 TT：41771
	10410026, 10410027, 10410034, 10410035, 10423025, 10423026,
	--houzhifang 2008-12-22: dark
	10150001,10150002,10300005,10302005,10304005,10305005, 
	--likun 2009-8-18
	10300103,10300104,10300105,10300106,10300107,10300108,10300109,10300110,10300111,10301103,
	10301104,10301105,10301106,10301107,10301108,10301109,10301110,10301111,10301203,10301204,
	10301205,10301206,10301207,10301208,10301209,10301210,10301211,10302103,10302104,10302105,
	10302106,10302107,10302108,10302109,10302110,10302111,10303103,10303104,10303105,10303106,
	10303107,10303108,10303109,10303110,10303111,10303203,10303204,10303205,10303206,10303207,
	10303208,10303209,10303210,10303211,10304103,10304104,10304105,10304106,10304107,10304108,
	10304109,10304110,10304111,10305103,10305104,10305105,10305106,10305107,10305108,10305109,
	10305110,10305111,10305203,10305204,10305205,10305206,10305207,10305208,10305209,10305210,
	10305211,
	--likun 2009-8-26
	10300007,	--赤焰九纹刀	96
	10301001,	--斩忧断愁枪	96
	10301199,	--弈天破邪杖	96
	10302007,	--含光弄影剑	96
	10302009,	--万仞龙渊剑	96
	10303001,	--转魂灭魄钩	96
	10304007,	--雷鸣离火扇	96
	10304009,	--雷鸣离火扇	96
	10305007,	--碎情雾影环	96
	10305009,	--天星耀阳环	96
	--zhanglei 2009-9-4
	10156001, --武魂：琉璃焰
	10156002, --武魂：御瑶盘
	--绑定武魂
	10156003,
	10156004,
	--新门派曼陀神器
	10306005,10306007,10306009,
	10306100,10306101,10306102,
	10306103,10306104,10306105,10306106,10306107,10306108,10306109,10306110,10306111,
}

--===============================================
-- PreLoad
--===============================================
function SplitGemEx_PreLoad()
	this:RegisterEvent("UI_COMMAND")
 	this:RegisterEvent("BUY_ITEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED" )
 	this:RegisterEvent("UPDATE_COMPOSE_GEM")
 	this:RegisterEvent("RESUME_ENCHASE_GEM" )
	this:RegisterEvent("ITEM_CLICKED_SPLITGEMEX")
	this:RegisterEvent("ADJEST_UI_POS" )
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED" )
end

function SplitGemEx_OnLoad()
--~ 	EQUIP_BUTTON	= SplitGemEx_Item
--~ 	CHARM_BUTTON	= SplitGemEx_Gem4
--~ 	GEM_BUTTONS[1]	= SplitGemEx_Gem1
--~ 	GEM_BUTTONS[2]	= SplitGemEx_Gem2
--~ 	GEM_BUTTONS[3]	= SplitGemEx_Gem3
	g_SplitGemEx_Gems={
		[1]=SplitGemEx_Gem1,
		[2]=SplitGemEx_Gem2,
		[3]=SplitGemEx_Gem3,
		[4]=SplitGemEx_Gem4,
	}

	g_SplitGemEx_Frame_UnifiedPosition=SplitGemEx_Frame:GetProperty("UnifiedPosition")
end

function SplitGemEx_OnEvent(event)

	if event == "UI_COMMAND" and tonumber(arg0) == 2013060603 then
		local serverObj = Get_XParam_INT(0)
		g_SplitGemEx_CareObj=DataPool:GetNPCIDByServerID(serverObj)
		if g_SplitGemEx_CareObj<0 then return end
		g_SplitGemEx_npcSid = tonumber(arg1)
		BeginCareObject_SplitGemEx()
		SplitGemEx_Clear()
		SplitGemEx_Update()
		this:Show()

	elseif event == "BUY_ITEM" and this:IsVisible() then
		if g_SplitGemEx_Equip_ID > 0 and g_SplitGemEx_Material_Buy > 0 then
			local item = tonumber(arg1)
			if item < 30900037 or item > 30900044 then return end
			g_SplitGemEx_Material_Buy = -1
			SplitGemEx_UI_SetItem(2,PlayerPackage:GetBagPosByItemIndex(item),0)
		end
	elseif event == "PACKAGE_ITEM_CHANGED" then
		if arg0 ~= nil and -1 == tonumber(arg0) then return end
		if g_SplitGemEx_Equip_pos == tonumber(arg0) then
			SplitGemEx_Clear()
			SplitGemEx_UI_SetItem(1,tonumber(arg0),0)
		end
		if g_SplitGemEx_Material_pos == tonumber(arg0) then
			local equip = g_SplitGemEx_Equip_pos
			SplitGemEx_Clear()
			SplitGemEx_UI_SetItem(1,equip,0)
		end
	elseif event == "UPDATE_COMPOSE_GEM" and this:IsVisible() then
		SplitGemEx_UI_SetItem(tonumber(arg0),tonumber(arg1),1)
 	elseif event == "RESUME_ENCHASE_GEM" then
		if arg0 == nil then return end
		Resume_SplitGemEx(tonumber(arg0))
	elseif event == "ITEM_CLICKED_SPLITGEMEX" and this:IsVisible() then
		if arg0 == nil or arg1 == nil then return end
		SplitGemEx_UI_SetItem(tonumber(arg0),tonumber(arg1),1)
	elseif event == "ADJEST_UI_POS" then
		SplitGemEx_Frame_On_ResetPos()
	elseif event == "VIEW_RESOLUTION_CHANGED" then
		SplitGemEx_Frame_On_ResetPos()
	end

end

--===============================================
-- Clear All Parameters
--===============================================
function SplitGemEx_Clear()
	Resume_SplitGemEx(1)
	Resume_SplitGemEx(2)
	g_SplitGemEx_Equip_ID = -1
	g_SplitGemEx_Equip_pos = -1
	g_SplitGemEx_Material_ID = -1
	g_SplitGemEx_Material_pos = -1
	g_SplitGemEx_Selected = -1
end

--===============================================
-- Set Item To SplitGemEx UI
--===============================================
function SplitGemEx_UI_SetItem(posUI,posBag,bMsg)
	if posUI < 1 or posUI > 2 then return end
	if bMsg < 0 or bMsg > 1 then return end
	local theAction = EnumAction(posBag, "packageitem")
	if theAction:GetID() ~= 0 then
		if posUI == 1 then
			--check equip point
			local equipPoint = LifeAbility:Get_Equip_Point(posBag)
			if equipPoint == -1 then return end
			if equipPoint == 8 or equipPoint == 9 or equipPoint == 10 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_25}")
				return
			elseif equipPoint == 16 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_54}")
				return
			end
			--check have gem
			local holecount = LifeAbility:GetEquip_HoleCount(posBag)
			local gemcount = LifeAbility:GetEquip_GemCount(posBag)
			if gemcount == 0 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_67}")
				return
			end
			--check equip lock
			if PlayerPackage:IsLock(posBag) == 1 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_76}")
				return
			end

			Resume_SplitGemEx(1)
			g_SplitGemEx_Equip_ID = theAction:GetID()
			g_SplitGemEx_Equip_pos = posBag
			LifeAbility:Lock_Packet_Item(posBag,1)
			SplitGemEx_Update()

		elseif posUI == 2 then
			--check equip ready
			if g_SplitGemEx_Equip_ID == -1 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_53}")
				return
			end
			--check gem selected
			if g_SplitGemEx_Selected == -1 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_50}")
				return
			end
			--check lock
			if PlayerPackage:IsLock(posBag) == 1 then
				if bMsg == 0 then return end
				PushDebugMessage("#{BSLCYH_130529_20}")
				return
			end
			--check Material level
			local gemlevel = LifeAbility:GetEquip_GemLevel(g_SplitGemEx_Equip_pos,g_SplitGemEx_Selected-1)
			if gemlevel < 1 or gemlevel > 9 then return end
			if PlayerPackage:GetItemTableIndex(posBag) < g_SplitGemEx_MatTab[gemlevel] then
				if bMsg == 0 then return end
				PushDebugMessage(ScriptGlobal_Format("#{BSLCYH_130529_49}",PlayerPackage:GetItemName(g_SplitGemEx_MatTab[gemlevel])))
				return
			end

			Resume_SplitGemEx(2)
			g_SplitGemEx_Material_ID = theAction:GetID()
			g_SplitGemEx_Material_pos = posBag
			LifeAbility:Lock_Packet_Item(g_SplitGemEx_Material_pos,1)
			SplitGemEx_Update()
		end
	else
		SplitGemEx_Clear()
		SplitGemEx_Update()
	end
end
--===============================================
-- Update Whole UI
--===============================================
function SplitGemEx_Update()
	--tab
	-- SplitGemEx_StilettoEx:SetCheck(0)
	-- SplitGemEx_EnchaseEx:SetCheck(0)
	-- SplitGemEx_SplitGemEx:SetCheck(1)
	-- SplitGemEx_SplitGemEx:Disable()
	--equip
	SplitGemEx_Item:SetActionItem(g_SplitGemEx_Equip_ID)
	--Material
	SplitGemEx_fu2:SetActionItem(g_SplitGemEx_Material_ID)
	--gem UI
	if g_SplitGemEx_Equip_ID > 0 then
		local _,_,_,holecount=LifeAbility:Stiletto_Preparation(g_SplitGemEx_Equip_pos, 1)
		LifeAbility:SplitGem_Update(g_SplitGemEx_Equip_pos)
		for i=1,4 do
			local nGemTableID = LifeAbility:LuaFnGetEquipGemId(g_SplitGemEx_Equip_pos, i-1)
			if nGemTableID > 0 then
				-- ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID)
				local theAction = DataPool:CreateActionItemForShow(nGemTableID, 1)
				if theAction:GetID() ~= 0 then
					g_SplitGemEx_Gems[i]:SetActionItem(theAction:GetID())
				end
			else
				g_SplitGemEx_Gems[i]:SetActionItem(-1)
				g_SplitGemEx_Gems[i]:SetToolTip("#{BSLCYH_130529_14}")
			end

			if i > holecount then
				g_SplitGemEx_Gems[i]:SetToolTip("#{BSLCYH_130529_12}")
				-- if SystemSetup:IsClassic() == 0 then	--若客户端是唯美版，则设置图片资源为唯美版资源
				-- 	g_SplitGemEx_Gems[i]:SetProperty( "BackImage", "set:WM_CommonFrame1 image:Feng" )
				-- else									--否则设置为经典版资源
					g_SplitGemEx_Gems[i]:SetProperty( "BackImage", "set:Agname3 image:BaoShiCheckFeng" )
				-- end
				if i == 4 and not SplitGemEx_CanFour(g_SplitGemEx_Equip_pos) then
					g_SplitGemEx_Gems[i]:SetToolTip("#{BSLCYH_130529_13}")
				end
			end
		end
	else
		for i=1,4 do
			g_SplitGemEx_Gems[i]:SetActionItem(-1)
			g_SplitGemEx_Gems[i]:SetToolTip( "" )
			g_SplitGemEx_Gems[i]:SetProperty( "BackImage", "" )
		end
	end
	--selected Gem
	for i=1,4 do
		g_SplitGemEx_Gems[i]:SetPushed(0)
	end
	if g_SplitGemEx_Equip_ID > 0 and g_SplitGemEx_Selected > 0 then
		g_SplitGemEx_Gems[g_SplitGemEx_Selected]:SetPushed(1)
	end
	--need Material
	if g_SplitGemEx_Equip_ID > 0 and g_SplitGemEx_Selected > 0 then
		local gemlevel = LifeAbility:GetEquip_GemLevel(g_SplitGemEx_Equip_pos,g_SplitGemEx_Selected-1)
		if gemlevel < 1 or gemlevel > 9 then return end

		-- local action = DoubleGem:UpdateProductAction(g_SplitGemEx_MatTab[gemlevel])
		local action = DataPool:CreateActionItemForShow(g_SplitGemEx_MatTab[gemlevel], 1)
		if action and action:GetID() ~= 0 then
			SplitGemEx_fu1:SetActionItem(action:GetID())
		end
	else
		SplitGemEx_fu1:SetActionItem(-1)
	end
end
function SplitGemEx_CanFour(posBag)
	local bCanFour = false
	local equipItem = PlayerPackage:GetItemTableIndex(posBag)
	for _,i in g_SplitGemEx_four_80_ID do
		if i == equipItem then
			bCanFour = true
			break
		end
	end
	for _,i in g_SplitGemEx_four_ID do
		if i == equipItem then
			bCanFour = true
			break
		end
	end
	
	-- 所有神器都可以打四孔 by lishilong 2016-8-23
	-- if equipItem >= EQUIP_SHENQI_BEGIN and equipItem <= EQUIP_SHENQI_END then
	-- 	bCanFour = true
	-- end
	
	if PlayerPackage:IsBagItemDark(posBag) == 1 then
		bCanFour = true
	end
	
	-- if PlayerPackage:IsBagItemHXY(posBag) == 1 then
	-- 	bCanFour = true
	-- end
	return bCanFour
end
function SplitGemEx_Submit()

	if CheckPhoneMibaoAndMinorPassword() ~= 1 then return end
	-- if tonumber(DataPool:GetLeftProtectTime()) > 0 then
	-- 	PushDebugMessage("#{ZYXT_120528_16}")
	-- 	return
	-- end

	if g_SplitGemEx_Equip_ID == -1 then
		PushDebugMessage("#{BSLCYH_130529_53}")
		return
	end

	if g_SplitGemEx_Selected == -1 then
		PushDebugMessage("#{BSLCYH_130529_50}")
		return
	end

	if g_SplitGemEx_Material_ID == -1 then
		local gemlevel = LifeAbility:GetEquip_GemLevel(g_SplitGemEx_Equip_pos,g_SplitGemEx_Selected-1)
		if gemlevel < 1 or gemlevel > 9 then return end

		if Player:GetData("LEVEL") < 15 then
			PushDebugMessage("#{BSLCYH_130529_144}")
			return
		end

		if SplitGemEx_YuanBaoPay_Button:GetCheck() == 0 then
			--不提示 自动购买
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("SplitGemEx_YuanbaoPay")
				Set_XSCRIPT_ScriptID(701614)
				Set_XSCRIPT_Parameter(0,g_SplitGemEx_MatTab[gemlevel])
				Set_XSCRIPT_Parameter(1,0)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			return
		elseif SplitGemEx_YuanBaoPay_Button:GetCheck() == 1 then
			Clear_XSCRIPT()
				Set_XSCRIPT_Function_Name("SplitGemEx_YuanbaoPay")
				Set_XSCRIPT_ScriptID(701614)
				Set_XSCRIPT_Parameter(0,g_SplitGemEx_MatTab[gemlevel])
				Set_XSCRIPT_Parameter(1,1)
				Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			return
		else return end
	end

	LifeAbility:Do_SeparateGem(g_SplitGemEx_Equip_pos, g_SplitGemEx_Selected - 1, g_SplitGemEx_Material_pos)

end


function Resume_SplitGemEx(nIndex)
	if not this:IsVisible() then return end
	if nIndex == 1 then
		if g_SplitGemEx_Equip_ID == -1 then return end
		LifeAbility:Lock_Packet_Item(g_SplitGemEx_Equip_pos,0)
		g_SplitGemEx_Equip_ID = -1
		g_SplitGemEx_Equip_pos = -1
		g_SplitGemEx_Selected = -1
		SplitGemEx_Update()
		if g_SplitGemEx_Material_ID == -1 then return end
		Resume_SplitGemEx(2)

	elseif nIndex == 2 then
		if g_SplitGemEx_Material_ID == -1 then return end
		LifeAbility:Lock_Packet_Item(g_SplitGemEx_Material_pos,0)
		g_SplitGemEx_Material_ID = -1
		g_SplitGemEx_Material_pos = -1
		SplitGemEx_Update()
	end
end
--===============================================
-- Click The Gem to Split
--===============================================
function SplitGemEx_Selected(gem_Index)
	if gem_Index < 1 or gem_Index > 4 then return end
	if g_SplitGemEx_Gems[gem_Index]:GetActionItem() == -1 then return end

	g_SplitGemEx_Selected = gem_Index
	Resume_SplitGemEx(2)
	SplitGemEx_Update()
end

--===============================================
-- Change Tab
--===============================================
function SplitGemEx_ChangeTab(nindex)
	-- if nindex < 1 or nindex > 3 then return end
	-- if nindex == 3 then return end

	-- this:Hide()
	-- if nindex == 1 then
	-- 	PushEvent("OPEN_STILETTOEX_UI", g_SplitGemEx_npcSid)
	-- elseif nindex == 2 then
	-- 	PushEvent("UI_COMMAND", 2013060602, g_SplitGemEx_npcSid)
	-- end
end
function SplitGemEx_OnShown()
	--pos
	local pos = Variable:GetVariable("Gem3UIpos")
	if pos == nil then return end
	SplitGemEx_Frame:SetProperty("UnifiedPosition", pos)
	--yuanbaoPay
	if g_SplitGemEx_YuanbaoPay == 1 or g_SplitGemEx_YuanbaoPay == 0 then
		SplitGemEx_YuanBaoPay_Button:SetCheck(g_SplitGemEx_YuanbaoPay)
	end
end
function SplitGemEx_OnHidden()
	g_SplitGemEx_YuanbaoPay = SplitGemEx_YuanBaoPay_Button:GetCheck()
	SplitGemEx_Clear()
	StopCareObject_SplitGemEx()
	Variable:SetVariable("Gem3UIpos", SplitGemEx_Frame:GetProperty("UnifiedPosition"), 1)
end
function BeginCareObject_SplitGemEx()
	this:CareObject(g_SplitGemEx_CareObj, 1, "SplitGemEx")
end

function StopCareObject_SplitGemEx()
	this:CareObject(g_SplitGemEx_CareObj, 0, "SplitGemEx")
end
function SplitGemEx_Frame_On_ResetPos()
  SplitGemEx_Frame:SetProperty("UnifiedPosition", g_SplitGemEx_Frame_UnifiedPosition)
end
