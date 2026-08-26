--装备修改器 V5 苍山雪定制版
--雪舞@WAYLEE 2024-2-14 23:51:04
local g_GameTools5_Frame_UnifiedPosition;
local g_AttrSecond = {};
local g_Conut = 0
local g_max = 0
local StarId = -1
local KongShuId = -1

local StarNameList = {"0☆","1☆","2☆","3☆","4☆","5☆","6☆","7☆","8☆","9☆"}
local KongShuNameList = {"0孔","1孔","2孔","3孔","4孔"}--,"5孔","6孔"

local g_Equip_ID = -1 --装备显示ID
local g_posBag = -1 --装备位置

function GameTools5_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_NOTIFY");
	this:RegisterEvent("ADJEST_UI_POS",false)
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED" ); -- 离开场景
end

function GameTools5_OnLoad()
	g_GameTools5_Frame_UnifiedPosition=GameTools5_Frame:GetProperty("UnifiedPosition");
	-- 初始化表
	for i = 1, 41 do
		g_AttrSecond[i] = _G["GameTools5_AttrSecondButton"..i]
	end
end

-- 获取装备类型和字符串
function GameTools5_LuaFnGetBagEquipType(nPos)
    -- 先取装备点
    local EquipPoint = LifeAbility:Get_Equip_Point(nPos)
    local EquipNames = {
        [0]  = "武器",
        [1]  = "帽子",
        [2]  = "时装",
        [3]  = "手套",
        [4]  = "鞋子",
        [5]  = "腰带",
        [6]  = "戒指",
        [7]  = "项链",
        [8]  = "坐骑",
        [9]  = "霸王令",  -- 令牌
        [10] = "武魂",
        [11] = "戒指",   -- 第二个戒指
        [12] = "护符",
        [13] = "护符",   -- 第二个护符
        [14] = "护腕",
        [15] = "护肩",
        [16] = "衣服",
        [17] = "暗器",
        [18] = "龙纹",
        [21] = "豪侠印",
    }
    local Str = EquipNames[EquipPoint] or "未知"
    return EquipPoint, Str
end


function GameTools5_OnEvent(event)
	if(event == "UI_COMMAND" and arg0 == "202004275") then
		GameTools5_Init()
		this:Show();
		
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 201107281 ) and this:IsVisible() then
		
		--二次放入的话，先解锁以前的装备
		if g_posBag ~= -1 then
			LifeAbility:Lock_Packet_Item(g_posBag,0); 
		end
		GameTools5_FenYe5:SetCheck(1)
		g_posBag = tonumber(arg1)
		local theAction = EnumAction(g_posBag, "packageitem")
		if theAction:GetID() ~= 0 then
			g_Equip_ID = theAction:GetID()
			GameTools5_Item:SetActionItem(g_Equip_ID)
			--显示道具名字
			local ItemName = LifeAbility:GetPrescr_Material(theAction:GetDefineID())
			GameTools5_Name:SetText("#c0066ff名称:#G"..ItemName)
			--携带等级
			local nItemLevel = LifeAbility:Get_Equip_Level(g_posBag);
			GameTools5_Level:SetText("#c0066ff等级:#G"..nItemLevel)
			--装备点
			local EqType1,EqType2 = GameTools5_LuaFnGetBagEquipType(g_posBag)
			GameTools5_EqType:SetText("#c0066ff类型:#G"..EqType2)
			--Type
			GameTools5_EqType2:SetText("#c0066ff装备点:#G"..EqType1)
			
			--刷新雕纹信息
			GameTools5_reDWinfo(g_posBag)
			
			--锁定物品
			LifeAbility:Lock_Packet_Item(g_posBag,1);
			
			--创建者信息
			GameTools5_CreatEdix:SetText( PlayerPackage:GetItemCreator(g_posBag) )
		end
	--单独刷新宝石信息
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 202402112 ) and this:IsVisible() then
		-- 宝石信息显示
		local gems = { PlayerPackage:GetEquipGemInfo(g_posBag) }
		local gemUI = {
			{ btn = GameTools5_Gem1, txt = GameTools5_GeminfoTxt1, edix = GameTools5_GeminfoEdix1 },
			{ btn = GameTools5_Gem2, txt = GameTools5_GeminfoTxt2, edix = GameTools5_GeminfoEdix2 },
			{ btn = GameTools5_Gem3, txt = GameTools5_GeminfoTxt3, edix = GameTools5_GeminfoEdix3 },
			{ btn = GameTools5_Gem4, txt = GameTools5_GeminfoTxt4, edix = GameTools5_GeminfoEdix4 },
		}

		for i, ui in ipairs(gemUI) do
			local gemId = gems[i]
			if gemId ~= nil and gemId > 0 then
				local action = DataPool:CreateActionItemForShow(gemId, 1)
				ui.btn:SetActionItem(action:GetID())
				ui.txt:SetText(LuaFnGetItemName(gemId))
				ui.edix:SetText(gemId)
			else
				ui.btn:SetActionItem(-1)
				ui.txt:SetText("孔位无宝石")
				ui.edix:SetText("")
			end
		end
				
	elseif ( event=="UI_COMMAND" and tonumber(arg0) == 202402111 ) and this : IsVisible() then
	
		--星级
		StarId = PlayerPackage:GetItemQual(g_posBag) 
		GameTools5_StarEdix:SetCurrentSelect(StarId)
		
		--强化
		local nEnhanceLevel = PlayerPackage:GetEnhanceLevel(g_posBag) 
		GameTools5_strengthenEdix:SetText(nEnhanceLevel);
		
		--孔数
		KongShuId = PlayerPackage:GetEquipSlot(g_posBag)
		GameTools5_KongShuEdix:SetCurrentSelect(KongShuId);
		
		--外观ID
		local nVisual = PlayerPackage:GetVisualID(g_posBag);
		GameTools5_VisualEdix:SetText(nVisual)
		
		--浮动值
		local nFuDong = Get_XParam_INT(2)--PlayerPackage:GetEquipAttrHidden(g_posBag)
		GameTools5_FuDongEdix:SetText(nFuDong)
		
		--雕纹剩余数量获取
		local DWMaxNum = Get_XParam_INT(0)
		if DWMaxNum > 0 then
			local dwmax = math.floor(DWMaxNum / 10000)
			local dwneed = math.mod(DWMaxNum, 10000)
			GameTools5_DWSum:SetText("#G"..tostring(dwneed).."/"..tostring(dwmax))
			GameTools5_DWSumEdix1:SetText(dwneed)
		else
			GameTools5_DWSumEdix1:SetText(0)
			GameTools5_DWSum:SetText("#G无/无")
		end
		
		--装备ID
		local nItemID = PlayerPackage:GetItemTableIndex(g_posBag)
		GameTools5_IDEdix:SetText(nItemID)
		
		--装备鉴定/绑定/锁定状态/铭刻/资质鉴定
		local status = PlayerPackage:GetItemStatus(g_posBag)
		if LuaFnHasBit(status, 0) == 1 then 
			GameTools5_ZhuangTaiButton1:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton1:SetCheck(0) 
		end -- 绑定
		if LuaFnHasBit(status, 1) == 1 then 
			GameTools5_ZhuangTaiButton2:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton2:SetCheck(0) 
		end -- 鉴定
		if LuaFnHasBit(status, 2) == 1 then 
			GameTools5_ZhuangTaiButton3:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton3:SetCheck(0) 
		end -- 锁定
		if LuaFnHasBit(status, 6) == 1 then 
			GameTools5_ZhuangTaiButton4:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton4:SetCheck(0) 
		end -- 铭刻
		if LuaFnHasBit(status, 5) == 1 then 
			GameTools5_ZhuangTaiButton5:SetCheck(1) 
		else
			GameTools5_ZhuangTaiButton5:SetCheck(0) 
		end -- 资质鉴定
		
		--是否贵重
		local Goods = "#cFF0000贵重"
		if Get_XParam_INT(1) == 0 then
			Goods = "#G非贵重"
		end
		GameTools5_Goods:SetText("#c0066ff品质:"..Goods)
			
		--耐久度
		local nDurValue,nDurMaxValue = PlayerPackage:GetEquipDurValue(g_posBag)
		GameTools5_DurValueEdix:SetText(nDurValue)
		GameTools5_MaxDurValueEdix:SetText(nDurMaxValue)
		
		--剩余可修理次数
		local nXiuLi = PlayerPackage:GetFaileTimes(g_posBag)
		GameTools5_XiuLiCountEdix:SetText(nXiuLi)
		
		--属性条数
		local nTiaoShu = PlayerPackage:GetEquipAttrCount(g_posBag)
		GameTools5_ChongXiEdix:SetText(nTiaoShu)
		
		--属性类型
		local nDataValueA, nDataValueB = PlayerPackage:GetEquipAttr(g_posBag)
		local _, _, AllValueA = LuaFnCalculateAttributesAEx(nDataValueA)
		local _, _, AllValueB = LuaFnCalculateAttributesBEx(nDataValueB)
		g_Conut = 0

		for i = 1, 26 do
			if AllValueA[i] ~= nil then
				g_AttrSecond[i]:SetCheck(1)
				g_Conut = g_Conut + 1
			else
				g_AttrSecond[i]:SetCheck(0)
			end
		end

		for i = 1, 15 do
			if AllValueB[i] ~= nil then
				g_AttrSecond[26 + i]:SetCheck(1)
				g_Conut = g_Conut + 1
			else
				g_AttrSecond[26 + i]:SetCheck(0)
			end
		end

		if g_Conut <= 16 then
			GameTools5_YiXuanTXT:SetText("#G已选择" .. g_Conut .. "种属性")
		else
			GameTools5_YiXuanTXT:SetText("#cFF0000已选择" .. g_Conut .. "种属性")
		end
		
		local apt1 = PlayerPackage:GetAptitude(g_posBag, 0)
		local apt2 = PlayerPackage:GetAptitude(g_posBag, 1)
		local apt3 = PlayerPackage:GetAptitude(g_posBag, 2)
		local apt4 = PlayerPackage:GetAptitude(g_posBag, 3)
		local apt5 = PlayerPackage:GetAptitude(g_posBag, 4)
		local apt6 = PlayerPackage:GetAptitude(g_posBag, 5)

		GameTools5_ZiZhiPinZhi_NumericalValue1:SetText(apt1)
		GameTools5_ZiZhiPinZhi_NumericalValue2:SetText(apt2)
		GameTools5_ZiZhiPinZhi_NumericalValue3:SetText(apt3)
		GameTools5_ZiZhiPinZhi_NumericalValue4:SetText(apt4)
		GameTools5_ZiZhiPinZhi_NumericalValue5:SetText(apt5)
		GameTools5_ZiZhiPinZhi_NumericalValue6:SetText(apt6)

		GameTools5_ZiZhiPinZhi1:SetPosition(apt1 / 255)
		GameTools5_ZiZhiPinZhi2:SetPosition(apt2 / 255)
		GameTools5_ZiZhiPinZhi3:SetPosition(apt3 / 255)
		GameTools5_ZiZhiPinZhi4:SetPosition(apt4 / 255)
		GameTools5_ZiZhiPinZhi5:SetPosition(apt5 / 255)
		GameTools5_ZiZhiPinZhi6:SetPosition(apt6 / 255)
		
		--创建者信息
		nStr = PlayerPackage:GetItemCreator(g_posBag)	
		GameTools5_CreatEdix:SetText(nStr)
		
		-- 宝石信息显示
		local gems = { PlayerPackage:GetEquipGemInfo(g_posBag) }
		local gemUI = {
			{ btn = GameTools5_Gem1, txt = GameTools5_GeminfoTxt1, edix = GameTools5_GeminfoEdix1 },
			{ btn = GameTools5_Gem2, txt = GameTools5_GeminfoTxt2, edix = GameTools5_GeminfoEdix2 },
			{ btn = GameTools5_Gem3, txt = GameTools5_GeminfoTxt3, edix = GameTools5_GeminfoEdix3 },
			{ btn = GameTools5_Gem4, txt = GameTools5_GeminfoTxt4, edix = GameTools5_GeminfoEdix4 },
		}

		for i, ui in ipairs(gemUI) do
			local gemId = gems[i]
			if gemId and gemId > 0 then
				local action = DataPool:CreateActionItemForShow(gemId, 1)
				ui.btn:SetActionItem(action:GetID())
				ui.txt:SetText(LuaFnGetItemName(gemId))
				ui.edix:SetText(gemId)
			else
				ui.btn:SetActionItem(-1)
				ui.txt:SetText("孔位无宝石")
				ui.edix:SetText("")
			end
		end
		
		--刷新雕纹信息
		GameTools5_reDWinfo(g_posBag)
	end
	local theAction = EnumAction(g_posBag, "packageitem")
	if theAction:GetID() ~= 0 then
		g_Equip_ID = theAction:GetID()
		GameTools5_Item:SetActionItem(g_Equip_ID)
	end
	if (event == "ADJEST_UI_POS" ) then
		GameTools5_Frame_On_ResetPos()
	elseif (event == "VIEW_RESOLUTION_CHANGED") then
		GameTools5_Frame_On_ResetPos()
	elseif (event == "HIDE_ON_SCENE_TRANSED" ) then
        this:Hide()	
	end
end

function GameTools5_Init()
	--先清空当前列表
	GameTools5_StarEdix:ResetList()
	for i = 1, table.getn(StarNameList) do
		GameTools5_StarEdix:AddTextItem(StarNameList[i], i)
	end	
	
	GameTools5_KongShuEdix:ResetList()
	for i = 1, table.getn(KongShuNameList) do
		GameTools5_KongShuEdix:AddTextItem(KongShuNameList[i], i)
	end	
end

-- 刷新雕纹信息
function GameTools5_reDWinfo(g_posBag)
	local dwId,dwlevel = LifeAbility:GetEquitDiaowenID(g_posBag)
	local DWname = "无雕纹"
	local str = "无加成"
	if tonumber(dwId) == -2 then
		dwId = "雕纹ID为空"
	else
		DWname = LuaFnGetItemName( dwId )
		local msg1,msg2 = LifeAbility:GetEquipDiaowen_AttrName(g_posBag)
		local attrnum = LifeAbility:GetDWAttrbyDWID(dwId - 30110000)
		str = ScriptGlobal_Format("#{DWSJ_141202_59}",msg1,attrnum) --雕纹属性
	end
	GameTools5_DWinfoEdix1:SetText(dwId)--雕纹ID
	GameTools5_DWinfoTxt1:SetText("#G"..DWname.."#r级别:"..dwlevel) --雕纹名字
	GameTools5_DWattrTxt1:SetText(str)
end

function GameTools5_ListBox_Selected()
	local str
	str,StarId = GameTools5_StarEdix:GetCurrentSelect()
	StarId = StarId - 1
end
function VIP_EquipItem_KongShuListBox_Selected()
	local str
	str,KongShuId = GameTools5_KongShuEdix:GetCurrentSelect()
	KongShuId = KongShuId - 1
end

function GameTools5_Frame_On_ResetPos()
	GameTools5_Frame:SetProperty("UnifiedPosition", g_GameTools5_Frame_UnifiedPosition);
end

--刷新属性条数
function GameTools5_Clicked()
	g_Conut = 0
	for i = 1,41 do
		if g_AttrSecond[i]:GetCheck() == 1 then
			g_Conut = g_Conut + 1
		end
	end
	if g_Conut <= 16 then
		GameTools5_YiXuanTXT:SetText("#G已选择"..g_Conut.."种属性");
	else
		GameTools5_YiXuanTXT:SetText("#cFF0000已选择"..g_Conut.."种属性");
	end
end


--修改星级
function GameTools5_Star_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,2) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(StarId))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("修改星级成功")
end


--修改强化
function GameTools5_strengthen_Clicked()
	local nNum = GameTools5_strengthenEdix:GetText()
	if nNum == nil or nNum == ""  then
		PushDebugMessage("请先写上你需要的强化等级")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,3) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(nNum))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("修改强化成功")
end


--修改孔数
function GameTools5_KongShu_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,4) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(KongShuId))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("修改孔数成功")
end

function GameTools5_ZiZhiPinZhi_OK_Clicked()
	
	local a1 = GameTools5_ZiZhiPinZhi_NumericalValue1:GetText()
	local b1 = GameTools5_ZiZhiPinZhi_NumericalValue2:GetText()
	local a2 = GameTools5_ZiZhiPinZhi_NumericalValue3:GetText()
	local b2 = GameTools5_ZiZhiPinZhi_NumericalValue4:GetText()
	local a3 = GameTools5_ZiZhiPinZhi_NumericalValue5:GetText()
	local b3 = GameTools5_ZiZhiPinZhi_NumericalValue6:GetText()
		
	local num1 = merge_numbers(a1, b1)
	local num2 = merge_numbers(a2, b2)
	local num3 = merge_numbers(a3, b3)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,5) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,num1)
		Set_XSCRIPT_Parameter(3,num2)
		Set_XSCRIPT_Parameter(4,num3)
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	PushDebugMessage("修改资质成功")
end

function merge_numbers(a, b)
    local a_str = string.format("%03d", a) -- 补零操作，确保a是两位数
    local b_str = string.format("%03d", b) -- 补零操作，确保b是两位数
    local merged_number = a_str .. b_str -- 将两个数字转换为字符串并拼接起来
    if string.len(merged_number) > 6 then
        return "合并后的数字长度超出范围" 
    else
        return tonumber(merged_number)
    end
end

--修改外观ID
function GameTools5_Visual_Clicked()
	local nVisual = GameTools5_VisualEdix:GetText()
	if nVisual == nil or nVisual == ""  then
		PushDebugMessage("外观ID填写错误")
		return
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,6) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(nVisual))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("装备外观修改成功")
end

--修改创建者信息
function GameTools5_Creat_Clicked(index)
	if index == 1 then
	
	elseif index == 2 then
		local text = GameTools5_CreatEdix:GetText()
		-- 防御关键词屏蔽@WAYLEE
		Talk:SendChatMessage("near", 
		string.format("&SYSDATA&,%s,%s,%s,%s,%s",
			("666660"),
			("ModifyEquip"),
			("7"),
			(g_posBag),
			(text)
			)
		);
	end
end

--修改属性浮动
function GameTools5_FuDong_Clicked()
	local text = GameTools5_FuDongEdix:GetText()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,8) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(text))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("装备外观修改成功")
end

--修改装备ID
function GameTools5_ID_Clicked()
	local text = GameTools5_IDEdix:GetText()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,10) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,tonumber(text))
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
	PushDebugMessage("装备ID修改成功")
end

--修改宝石
function GameTools5_Geminfo_Clicked(nIndex)
	local GemID = 0
	if nIndex == 1 then
		GemID = tonumber(GameTools5_GeminfoEdix1:GetText())
	elseif nIndex == 2 then
		GemID = tonumber(GameTools5_GeminfoEdix2:GetText())
	elseif nIndex == 3 then
		GemID = tonumber(GameTools5_GeminfoEdix3:GetText())
	elseif nIndex == 4 then
		GemID = tonumber(GameTools5_GeminfoEdix4:GetText())
	end
	if GemID == nil then
		GemID = 0
	end
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,11) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nIndex)
		Set_XSCRIPT_Parameter(3,GemID) --宝石ID
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
end

--修改装备耐久度
function GameTools5_DurValue_Clicked()
	local nNum = tonumber(GameTools5_DurValueEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,12) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--修改耐久上限
function GameTools5_MaxDurValue_Clicked()
	local nNum = tonumber(GameTools5_MaxDurValueEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,14) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--克隆装备
function GameTools5_KeLong_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,15) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_ParamCount(2)
	Send_XSCRIPT()
end

--重洗装备
function GameTools5_ChongXi_Clicked(index)
	if index == 1 then
		local nNum = tonumber(GameTools5_ChongXiEdix:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,16) --Type修改类型
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	elseif index == 2 then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,17) --Type修改类型
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_ParamCount(2)
		Send_XSCRIPT()
	end
end

--修理次数
function GameTools5_XiuLiCount_Clicked()
	local nNum = tonumber(GameTools5_XiuLiCountEdix:GetText())
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,13) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,nNum)
		Set_XSCRIPT_ParamCount(3)
	Send_XSCRIPT()
end

--修改雕纹ID
function GameTools5_DWinfo_Clicked(nIdnex)
	if nIdnex == 1 then
		local nNum = tonumber(GameTools5_DWinfoEdix1:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,18) --Type修改类型
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	else
		--修改雕纹剩余数
		local nNum = tonumber(GameTools5_DWSumEdix1:GetText())
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name("ModifyEquip")
			Set_XSCRIPT_ScriptID(666660)
			Set_XSCRIPT_Parameter(0,19) --Type修改类型
			Set_XSCRIPT_Parameter(1,g_posBag)
			Set_XSCRIPT_Parameter(2,nNum)
			Set_XSCRIPT_ParamCount(3)
		Send_XSCRIPT()
	end
end

--刷新宝石评分
-- function GameTools5_Geminfo_ShuaXin_Clicked()
	-- PushDebugMessage("功能还没写")
-- end

--读取装备信息
function GameTools5_DuQu_Clicked()
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ReadiEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,g_posBag) --Pos
		Set_XSCRIPT_ParamCount(1)
	Send_XSCRIPT()
	PushDebugMessage("读取装备数据成功")
end

function GameTools5_ZhuangTaiClicked()
	--勾选，暂无需任何操作
end

function GameTools5_ZhuangTai_Clicked()
	--优化方案
	local CheckA, CheckB = 0, 1
	local nCheck1 = tonumber(GameTools5_ZhuangTaiButton1:GetCheck()) --已绑定
	local nCheck2 = tonumber(GameTools5_ZhuangTaiButton2:GetCheck()) --已鉴定
	local nCheck3 = tonumber(GameTools5_ZhuangTaiButton3:GetCheck()) --已锁定
	CheckA = nCheck1 * 1 + nCheck2 * 2 + nCheck3 * 4

	local nCheck4 = tonumber(GameTools5_ZhuangTaiButton4:GetCheck()) --已刻铭
	local nCheck5 = tonumber(GameTools5_ZhuangTaiButton5:GetCheck()) --资质已鉴定
	CheckB = 1 + nCheck4 * 4 + nCheck5 * 2

	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,9) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,CheckA)
		Set_XSCRIPT_Parameter(3,CheckB)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()
	PushDebugMessage("状态保存成功")
end

--取消全部所选项目
function GameTools5_QuXiao_Clicked()
	--取消勾选
	for i = 1,41 do
		g_AttrSecond[i]:SetCheck(0)
	end
	GameTools5_YiXuanTXT:SetText("#G已选择0种属性");
	PushDebugMessage("已取消所有选择")
end

function GameTools5ZiZhiPinZhi1_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue1:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi1:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi2_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue2:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi2:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi3_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue3:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi3:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi4_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue4:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi4:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi5_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue5:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi5:SetPosition(temp/255);
end
function GameTools5ZiZhiPinZhi6_Change()
	local temp = GameTools5_ZiZhiPinZhi_NumericalValue6:GetText();
	if(temp == "" ) then
		return;
	end;
	if(tonumber(temp) > 255) then
		temp = 255;
	end
	temp = tonumber(temp);
	GameTools5_ZiZhiPinZhi6:SetPosition(temp/255);
end

function GameTools5_SliderChanged1()
	local temp = GameTools5_ZiZhiPinZhi1:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue1:SetText(temp);
end
function GameTools5_SliderChanged2()
	local temp = GameTools5_ZiZhiPinZhi2:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue2:SetText(temp);
end
function GameTools5_SliderChanged3()
	local temp = GameTools5_ZiZhiPinZhi3:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue3:SetText(temp);
end
function GameTools5_SliderChanged4()
	local temp = GameTools5_ZiZhiPinZhi4:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue4:SetText(temp);
end
function GameTools5_SliderChanged5()
	local temp = GameTools5_ZiZhiPinZhi5:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue5:SetText(temp);
end
function GameTools5_SliderChanged6()
	local temp = GameTools5_ZiZhiPinZhi6:GetPosition();
	temp = temp * 255;
	GameTools5_ZiZhiPinZhi_NumericalValue6:SetText(temp);
end

--卸下装备
function GameTools5_XieXia()
	GameTools5_Item:SetActionItem(-1)
	LifeAbility:Lock_Packet_Item(g_posBag,0); 
end
function GameTools5_Close()
	--解锁
	LifeAbility:Lock_Packet_Item(g_posBag,0); 
	this:Hide()
end

--TAB界面切换
function GameTools5_ChangeTabIndex( nIndex )
 local nUI = 0
	if 1 == nIndex then
		nUI = 20200427
	elseif 2 == nIndex then
		nUI = 202004272
	elseif 3 == nIndex then
		nUI = 202004273
	elseif 4 == nIndex then
		nUI = 202004274
	elseif 5 == nIndex then
		-- nUI = 202004275
		return
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

-- 计算属性A和属性B的十六进制总和
function LuaFnCalculateAttributesHex(g_AttrSecond)
	local attributesA = {
		[1] = 0x1, -- 血上限
		[2] = 0x2, -- 百分比血上限
		[3] = 0x8, -- 气上限
		[4] = 0x10, -- 百分比气上限
		[5] = 0x40, -- 冰攻击
		[6] = 0x80, -- 冰抗
		[7] = 0x200, -- 火攻击
		[8] = 0x400, -- 火抗
		[9] = 0x1000, -- 玄攻
		[10] = 0x2000, -- 玄抗
		[11] = 0x8000, -- 毒攻
		[12] = 0x10000, -- 毒抗
		[13] = 0x40000, -- 所有抗性
		[14] = 0x80000, -- 外功攻击
		[15] = 0x100000, -- 基础外功攻击百分比
		[16] = 0x200000, -- 武器基础外功攻击百分比
		[17] = 0x400000, -- 外功防御
		[18] = 0x800000, -- 基础外功防御百分比
		[19] = 0x1000000, -- 防具基础外功防御百分比
		[20] = 0x2000000, -- 抵消外功伤害百分比
		[21] = 0x4000000, -- 内功攻击
		[22] = 0x8000000, -- 基础内功攻击百分比
		[23] = 0x10000000, -- 武器基础内功攻击百分比
		[24] = 0x20000000, -- 内功防御
		[25] = 0x40000000, -- 基础内功防御百分比
		[26] = 0x80000000, -- 防具基础内功防御百分比
	}
	local attributesB = {
		[1] = 0x1, -- 抵消内功伤害
		[2] = 0x8, -- 命中
		[3] = 0x10, -- 闪避
		[4] = 0x20, -- 会心
		[5] = 0x400, -- 力量
		[6] = 0x800, -- 灵气
		[7] = 0x1000, -- 体力
		[8] = 0x2000, -- 定力
		[9] = 0x4000, -- 身法
		[10] = 0x8000, -- 会心防御
		[11] = 0x10000, -- 所有属性
		[12] = 0x400000, -- 忽略目标冰抗
		[13] = 0x800000, -- 忽略目标火抗
		[14] = 0x1000000, -- 忽略目标玄抗
		[15] = 0x2000000, -- 忽略目标毒抗
	}

	g_max = 0
	g_Conut = 0
    local sumA, sumB = 0, 0
    -- 计算属性A的总和
    for i = 1, 26 do
        if g_AttrSecond[i] and g_AttrSecond[i]:GetCheck() == 1 then
            sumA = LuaFnBitOr(sumA, attributesA[i])
			g_Conut = g_Conut + 1
			if i == 26 then
				g_max = 9999
			end
        end
    end

    -- 计算属性B的总和
    for i = 27, 41 do
        if g_AttrSecond[i] and g_AttrSecond[i]:GetCheck() == 1 then
            sumB = LuaFnBitOr(sumB, attributesB[i - 26]) 
			g_Conut = g_Conut + 1
        end
    end
    return sumA, sumB
end

--提交数据
function GameTools5_OK_Clicked()
	if g_Conut == 0 then
		PushDebugMessage("至少选择一个属性类型")
		return
	elseif g_Conut > 16 then
		PushDebugMessage("最多选择16条属性，请取消部分属性。")
		return
	end
	
	local sumA, sumB = LuaFnCalculateAttributesHex(g_AttrSecond)

	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("ModifyEquip")
		Set_XSCRIPT_ScriptID(666660)
		Set_XSCRIPT_Parameter(0,1) --Type修改类型
		Set_XSCRIPT_Parameter(1,g_posBag)
		Set_XSCRIPT_Parameter(2,sumA)
		Set_XSCRIPT_Parameter(3,sumB)
		Set_XSCRIPT_Parameter(4,g_max) --超21亿标记
		Set_XSCRIPT_ParamCount(5)
	Send_XSCRIPT()
	
end


--属性A:计算十六进制对应的装备属性 
function LuaFnCalculateAttributesAEx(hexInputA)
	-- 属性类型位数:225-232 
    -- 属性对应的十六进制值
    local attributesA = {
        {name = "血上限", value = 1},
        {name = "百分比血上限", value = 2},
        {name = "气上限", value = 8},
        {name = "百分比气上限", value = 22},
        {name = "冰攻击", value = 64},
        {name = "冰抗", value = 128},
        {name = "火攻击", value = 512},
        {name = "火抗", value = 1024},
        {name = "玄攻", value = 4096},
        {name = "玄抗", value = 8192},
        {name = "毒攻", value = 32768},
        {name = "毒抗", value = 65536},
        {name = "所有抗性", value = 262144},
        {name = "外功攻击", value = 524288},
        {name = "基础外功攻击百分比", value = 1048576},
        {name = "武器基础外功攻击百分比", value = 2097152},
        {name = "外功防御", value = 4194304},
        {name = "基础外功防御百分比", value = 8388608},
        {name = "防具基础外功防御百分比", value = 16777216},
        {name = "抵消外功伤害百分比", value = 33554432},
        {name = "内功攻击", value = 67108864},
        {name = "基础内功攻击百分比", value = 134217728},
        {name = "武器基础内功攻击百分比", value = 268435456},
        {name = "内功防御", value = 536870912},
        {name = "基础内功防御百分比", value = 1073741824},
        {name = "防具基础内功防御百分比", value = 2147483648},
    }

    local num = hexInputA
    local count = 0 -- 用于计数包含的属性
	local ReturnValue = {}
	local AllValue = {}
    for i = 1, table.getn(attributesA) do
        local attr = attributesA[i]
        if LuaFnBitAnd(num, attr.value) ~= 0 then
            count = count + 1
			ReturnValue[count] = attr.name
			AllValue[i] = attr.name
		else
			AllValue[i] = nil
        end
		
    end
	return ReturnValue,count,AllValue
end

--属性B:计算十六进制对应的装备属性 
--注意属性类型、属性条数必须一一对应
function LuaFnCalculateAttributesBEx(hexInputB)
	-- 属性类型位数:225-232 
    -- 属性对应的十六进制值
	local attributesB = {
        {name = "抵消内功伤害", value = 1},
        {name = "命中", value = 8},
        {name = "闪避", value = 16},
        {name = "会心", value = 32},
        {name = "力量", value = 1024},
        {name = "灵气", value = 2048},
        {name = "体力", value = 4096},
        {name = "定力", value = 8192},
        {name = "身法", value = 16384},
        {name = "会心防御", value = 32768},
        {name = "所有属性", value = 65536},
        {name = "忽略目标冰抗", value = 4194304},
        {name = "忽略目标火抗", value = 8388608},
        {name = "忽略目标玄抗", value = 16777216},
        {name = "忽略目标毒抗", value = 33554432},
       
    }

    local num = hexInputB
    local count = 0 -- 用于计数包含的属性
	local ReturnValue = {}
	local AllValue = {}
    for i = 1, table.getn(attributesB) do
        local attr = attributesB[i]
        if LuaFnBitAnd(num, attr.value) ~= 0 then
            count = count + 1
			ReturnValue[count] = attr.name
			AllValue[i] = attr.name
		else
			AllValue[i] = nil	
        end
    end
	return ReturnValue,count,AllValue
end