local SuperToolTip_AttrCompare_y_offset = -25
local SuperToolTip_AttrCompare_g_WidthOfCompare = 0
--=========
--PreLoad==
--=========
function SuperToolTip_AttrCompare_PreLoad()
	--第二个参数表示界面关睜时是否响应事件 默认为TRUE
	this:RegisterEvent("SHOW_SP_CMP1")
	this:RegisterEvent("CLOSE_SP_CMP1")
end

--=========
--OnLoad
--=========
function SuperToolTip_AttrCompare_OnLoad()
	local toDisplay = "SuperToolTip_AttrCompare_Title;SuperToolTip_AttrCompare_Property;SuperToolTip_AttrCompare_Title2;SuperToolTip_AttrCompare_Property2"
	SuperToolTip_AttrCompare_Frame:SetProperty("PageElements", toDisplay)
	this:Hide()
end

--=========
--OnEvent
--=========
function SuperToolTip_AttrCompare_OnEvent(event)

	if (event == "SHOW_SP_CMP1") then
		--arg0 supertooltip's posx
		--arg1 supertooltip's posy
		--arg2 supertooltip's width
		--arg3 attrCompare's num
		--arg4 supertooltip's isright


		--update context
		SuperToolTip_AttrCompare_Update()--!!! must before pos Set
		--pos set
		SuperToolTip_AttrCompare_Frame:PositionSelf(0, 0, 1, 1)
		local posX = SuperToolTip_AttrCompare_Frame:SetXAttachPos(arg0, arg2, tonumber(arg4))
		SuperToolTip_AttrCompare_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip_AttrCompare_y_offset))
		--attrCompare2 show
		local nWidth = SuperToolTip_AttrCompare_Frame:GetProperty("AbsoluteWidth")
		if tonumber(arg0) > tonumber(posX) then
			--attrCompare in supertooltip's left
			SuperTooltips2:ShowCmpWindowSub(posX, tonumber(arg1), nWidth + tonumber(arg2), tonumber(arg3), 0)
		else
			--attrCompare in supertooltip's right
			SuperTooltips2:ShowCmpWindowSub(tonumber(arg0), tonumber(arg1), nWidth + tonumber(arg2), tonumber(arg3), 1)
		end
		
		this:Show()
	elseif event == "CLOSE_SP_CMP1" then
		SuperToolTip_AttrCompare_y_offset = -25
		this:Hide()
	end
end

--=========
--Update UI
--=========
function SuperToolTip_AttrCompare_Update()
	-- 先清繝以前显示的文字
	SuperToolTip_AttrCompare_ClearText()

	local cmptype = SuperTooltips_Cmp1:LuaFnGetCmpType()--enum EQUIPCOMPARE_TYPE
	local toDisplay = "SuperToolTip_AttrCompare_Title;SuperToolTip_AttrCompare_Property"
	if cmptype == 1 then
		toDisplay = toDisplay..";SuperToolTip_AttrCompare_Title2;SuperToolTip_AttrCompare_Property2"
	end
	SuperToolTip_AttrCompare_Frame:SetProperty("PageElements", toDisplay)

	--equiping's attributa
	local szPropertys = SuperTooltips_Cmp1:LuaFnGetBaseAttrCmp()
	if( szPropertys ~= nil) then
		SuperToolTip_AttrCompare_Property:SetText(szPropertys)
	else
		SuperToolTip_AttrCompare_Property:SetText("#{ZBBJ_250313_6}")
	end

	--attribute detail
	local AttrStr = AttrCompare1_1:GetAttrCmpStr()
	if AttrStr ~= nil then
		SuperToolTip_AttrCompare_Property2:SetText(AttrStr)
	else
		SuperToolTip_AttrCompare_Property2:SetText("#{ZBBJ_250313_6}")
	end

	--count yoffset (dependon supertooltip.layout.xml supertooltip.lua)
	local firstpartyoffset = 0
	SuperToolTip_AttrCompare_y_offset = -25
	if SuperTooltips:IsPresent() then
		local typeDesc = SuperTooltips:GetTypeDesc()
		local nGemHoleCounts = SuperTooltips:GetGemHoleCounts()
		local nMoney1,_ = SuperTooltips:GetMoney1()
		local nMoney2,_ = SuperTooltips:GetMoney2()
		local unLockingElapsedTime	=SuperTooltips:GetPUnlockElapsedTime()
		local IsProtectd	=SuperTooltips:GetDesc5()
		local nYuanbaotrade = SuperTooltips:GetYuanbaoTradeFlag()
		local nGoodsProtect = SuperTooltips:GetGoodsProtect_Goods()

		if SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="" then
			firstpartyoffset = firstpartyoffset + 106
		end
		if IsProtectd == "1" and unLockingElapsedTime ~= 0 then
			firstpartyoffset = firstpartyoffset + 32
		end
		if( typeDesc ~= nil) then 
			firstpartyoffset = firstpartyoffset + 18
		end
		if nYuanbaotrade == 0 or nYuanbaotrade == 2 then
			firstpartyoffset = firstpartyoffset + 30
		end
		if type(nGemHoleCounts) == "number" and nGemHoleCounts>0 then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nMoney1 ~= nil then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nMoney2 ~= nil then 
			firstpartyoffset = firstpartyoffset + 21
		end
		if nGoodsProtect == 1 then
			firstpartyoffset = firstpartyoffset + 18
		end
	end
	SuperToolTip_AttrCompare_y_offset = SuperToolTip_AttrCompare_y_offset + firstpartyoffset + SuperTooltips:LuaFnGetCmpYOffset()
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清繝显示文本
--
function SuperToolTip_AttrCompare_ClearText()
	SuperToolTip_AttrCompare_Property:SetText("")
	SuperToolTip_AttrCompare_Property2:SetText("")
end
