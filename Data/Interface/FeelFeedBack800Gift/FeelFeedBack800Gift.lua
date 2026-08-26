--版本7日登陆礼包 通用

local g_nSelectIndex = 0;
local g_ActionBtnCtrl2 = {}
local g_TextBtnCtrl2={}
local g_MaskBtnCtrl2={}
local g_ActionBtnCtrl1 = {}
local g_TextBtnCtrl1={}
local g_MaskBtnCtrl1={}

local g_TitleCtrl;
local g_TextIntroCtrl;
local g_bagPos = -1

local g_itemgets_dress = {
[38002606]={ id={10124631,10124632,10124633},
						str={"#{EZNQQD_20220624_38}","#{EZNQQD_20220624_39}","#{EZNQQD_20220624_40}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
						},
						
[38002790]={ id={10124735,10124736,10124737},
						str={"#{QRDL_20211229_33}","#{QRDL_20211229_34}","#{QRDL_20211229_35}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
						},
[38002778]={ id={10125065,10125066,10125067},
						str={"#{QRDL_20211229_49}","#{QRDL_20211229_50}","#{QRDL_20211229_51}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
						},	

[38002780]={ id={10125283,10125284,10125285},
						str={"#{QRDL_20230718_01}","#{QRDL_20230718_02}","#{QRDL_20230718_03}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
						},						
						
}

local g_itemgets_ride = {
[38002607]={ id={10141932,10141919,10141920,10141987}, 
						str={"#{EZNQQD_20220624_41}","#{EZNQQD_20220624_42}","#{EZNQQD_20220624_43}","#{EZNQQD_20220624_44}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
					 },
[38002791]={ id={10142037,10141919,10141920,10141987}, 
						str={"#{QRDL_20211229_40}","#{QRDL_20211229_41}","#{QRDL_20211229_42}","#{QRDL_20211229_43}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
					 },
[38002779]={ id={10142059,10141919,10141920,10141987}, 
						str={"#{QRDL_20211229_53}","#{QRDL_20211229_41}","#{QRDL_20211229_42}","#{QRDL_20211229_43}"},
--						bkimg = "set:FeelFeedBack700_1 image:FeelFeedBack700_BK2"
					 },
}

local g_boxType = 0;
--===============================================
-- PreLoad()
--===============================================
function FeelFeedBack800Gift_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	this:RegisterEvent("PLAYER_LEAVE_WORLD",false)		-- 离开场景、
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED")	--进场景关闭界面
end

--===============================================
-- OnLoad()
--===============================================
function FeelFeedBack800Gift_OnLoad()
	
	--actionbutton
	g_ActionBtnCtrl1[1] = FeelFeedBack800Gift_Gift1_Icon
	g_ActionBtnCtrl1[2] = FeelFeedBack800Gift_Gift2_Icon
	g_ActionBtnCtrl1[3] = FeelFeedBack800Gift_Gift3_Icon
	g_ActionBtnCtrl2[1] = FeelFeedBack800Gift_GiftT1_Icon
	g_ActionBtnCtrl2[2] = FeelFeedBack800Gift_GiftT2_Icon
	g_ActionBtnCtrl2[3] = FeelFeedBack800Gift_GiftT3_Icon
	g_ActionBtnCtrl2[4] = FeelFeedBack800Gift_GiftT4_Icon
	g_MaskBtnCtrl1 ={FeelFeedBack800Gift_Gift1_Icon_Mask,FeelFeedBack800Gift_Gift2_Icon_Mask,FeelFeedBack800Gift_Gift3_Icon_Mask}
	g_MaskBtnCtrl2 ={FeelFeedBack800Gift_GiftT1_Icon_Mask,FeelFeedBack800Gift_GiftT2_Icon_Mask,FeelFeedBack800Gift_GiftT3_Icon_Mask,FeelFeedBack800Gift_GiftT4_Icon_Mask}
	g_TextBtnCtrl1 = {FeelFeedBack800Gift_Gift1_Text, FeelFeedBack800Gift_Gift2_Text, FeelFeedBack800Gift_Gift3_Text}
	g_TextBtnCtrl2 = {FeelFeedBack800Gift_GiftT1_Text, FeelFeedBack800Gift_GiftT2_Text, FeelFeedBack800Gift_GiftT3_Text, FeelFeedBack800Gift_GiftT4_Text}

	g_TitleCtrl = FeelFeedBack800Gift_DragTitle
	g_TextIntroCtrl = FeelFeedBack800Gift_Info
	g_bagPos = -1
end

function FeelFeedBack800Gift_UpdateUI(bagPos)
	g_nSelectIndex = 0
	if(g_bagPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_bagPos,0);
	end
	g_bagPos = bagPos
	LifeAbility : Lock_Packet_Item(g_bagPos,1);
	if g_boxType==1 then
		--时装 三选一
		FeelFeedBack800Gift_Gift:Show()
		FeelFeedBack800Gift_GiftT:Hide()
		local tableIndex = PlayerPackage:GetItemTableIndex( g_bagPos )
		if g_itemgets_dress[tableIndex] == nil then
			return
		end
		local vd = g_itemgets_dress[tableIndex]
		for i, v in pairs(g_ActionBtnCtrl1) do
			local theAction = DataPool:CreateBindActionItemForShow(vd.id[i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
			g_TextBtnCtrl1[i]:SetText(vd.str[i])
			g_MaskBtnCtrl1[i]:Hide()
		end
		local itemName = DataPool:LuaFnGetItemNameByTableIndex(tableIndex)
		g_TitleCtrl:SetText(itemName)
		g_TextIntroCtrl:SetText("#{YMDL_20220421_34}")
--		FeelFeedBack800GiftBK1 : SetProperty("Image", vd.bkimg);
	elseif g_boxType==2 then
		--坐骑 四选一
		FeelFeedBack800Gift_Gift:Hide()
		FeelFeedBack800Gift_GiftT:Show()
		local tableIndex = PlayerPackage:GetItemTableIndex( g_bagPos )
		if g_itemgets_ride[tableIndex] == nil then
			return
		end
		local vd = g_itemgets_ride[tableIndex]
		for i, v in pairs(g_ActionBtnCtrl2) do 
			local theAction = DataPool:CreateBindActionItemForShow(vd.id[i], 1)
			if theAction:GetID() ~= 0 then
				v:SetActionItem(theAction:GetID());
				v:Show();
			else
				v:SetActionItem(-1);
				v:Hide()
			end
			g_TextBtnCtrl2[i]:SetText(vd.str[i])
			g_MaskBtnCtrl2[i]:Hide()
		end
		local itemName = DataPool:LuaFnGetItemNameByTableIndex(tableIndex)
		g_TitleCtrl:SetText(itemName)
		g_TextIntroCtrl:SetText("#{YMDL_20220421_42}")
--		FeelFeedBack800GiftBK1 : SetProperty("Image", vd.bkimg);
	end
end

--===============================================
-- OnEvent()
--===============================================
function FeelFeedBack800Gift_OnEvent(event)

	-- 衣服
	if( event == "UI_COMMAND" and tonumber(arg0) == 79201301 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 1;
		if bIsShow == 1 then
			local bagPos = Get_XParam_INT(1)
			FeelFeedBack800Gift_UpdateUI(bagPos)
			this:Show();
		else
			FeelFeedBack800Gift_OnClose();
		end
	end
	
	-- 坐骑
	if( event == "UI_COMMAND" and tonumber(arg0) == 79201401 ) then
		local bIsShow = Get_XParam_INT(0);
		g_boxType = 2;
		if bIsShow == 1 then
			local bagPos = Get_XParam_INT(1)
			FeelFeedBack800Gift_UpdateUI(bagPos)
			this:Show();
		else
			FeelFeedBack800Gift_OnClose();
		end
	end

	if (event == "PLAYER_LEAVE_WORLD") then
		FeelFeedBack800Gift_OnClose()
	elseif (event == "HIDE_ON_SCENE_TRANSED") then
		FeelFeedBack800Gift_OnClose()
	end
end

function FeelFeedBack800Gift_Confirm()
	if g_boxType == 1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792013 )
			Set_XSCRIPT_Parameter( 0, g_bagPos )
			Set_XSCRIPT_Parameter( 1, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	elseif g_boxType == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "OnSelectItem" )
			Set_XSCRIPT_ScriptID( 792014 )
			Set_XSCRIPT_Parameter( 0, g_bagPos )
			Set_XSCRIPT_Parameter( 1, g_nSelectIndex )
			Set_XSCRIPT_ParamCount( 2 )
		Send_XSCRIPT()
	end
end
function FeelFeedBack800Gift_1_Select(nIndex)
	if g_boxType == 1 then
		for i, v in pairs(g_ActionBtnCtrl1) do
			v:SetPushed(0)
			g_MaskBtnCtrl1[i]:Hide()
		end
		g_ActionBtnCtrl1[nIndex]:SetPushed(1)
		g_MaskBtnCtrl1[nIndex]:Show()
		g_nSelectIndex = nIndex
	end
end
function FeelFeedBack800Gift_2_Select(nIndex)
	if g_boxType == 2 then
		for i, v in pairs(g_ActionBtnCtrl2) do
			v:SetPushed(0)
			g_MaskBtnCtrl2[i]:Hide()
		end
		g_ActionBtnCtrl2[nIndex]:SetPushed(1)
		g_MaskBtnCtrl2[nIndex]:Show()
		g_nSelectIndex = nIndex
	end
end

function FeelFeedBack800Gift_Select(nIndex)
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Hide();
--	end
--	g_nSelectIndex = nIndex;
--	if checkBox_items[g_nSelectIndex] then 
--		checkBox_items[g_nSelectIndex]:Show();
--	end
end

function FeelFeedBack800Gift_OnClose()
	g_boxType = 0
	g_nSelectIndex = 0
	if(g_bagPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_bagPos,0);
		g_bagPos = -1
	end

	this:Hide();
end
