local SuperToolTip2_AttrCompare2_y_offset = -25
local SuperToolTip2_AttrCompare2_g_WidthOfCompare2 = 0
--=========
--PreLoad==
--=========
function SuperToolTip2_AttrCompare2_PreLoad()
	this:RegisterEvent("SHOW_SP2_CMP2")
	this:RegisterEvent("MOVE_SP2_CMP2")
	this:RegisterEvent("CLOSE_SP2_CMP2")
end

--=========
--OnLoad
--=========
function SuperToolTip2_AttrCompare2_OnLoad()

end

--=========
--OnEvent
--=========
function SuperToolTip2_AttrCompare2_OnEvent(event)
	if (event == "SHOW_SP2_CMP2") then
		--arg0 supertooltip's posx
		--arg1 supertooltip's posy
		--arg2 width

		--context update
		SuperToolTip2_AttrCompare2_Update()--!!! must before pos Set
		SuperToolTip2_AttrCompare2_UpdateYoffset()
		--pos set
		SuperToolTip2_AttrCompare2_Frame:PositionSelf(0, 0, 1, 1)
		local posX = SuperToolTip2_AttrCompare2_Frame:SetXAttachPos(arg0, arg2, 1)
		SuperToolTip2_AttrCompare2_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip2_AttrCompare2_y_offset))

		this:Show()
	elseif (event == "MOVE_SP2_CMP2") then
		if this:IsVisible() then
			--arg0 supertooltip2's posx
			--arg1 supertooltip2's posy
			--arg2 width
			SuperToolTip2_AttrCompare2_UpdateYoffset()
			local posX = SuperToolTip2_AttrCompare2_Frame:SetXAttachPos(arg0, arg2, 1)
			SuperToolTip2_AttrCompare2_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip2_AttrCompare2_y_offset))
		end
	elseif event == "CLOSE_SP2_CMP2" then
		SuperToolTip2_AttrCompare2_y_offset = -25
		this:Hide()
	end
end

--=========
--Update UI
--=========
function SuperToolTip2_AttrCompare2_Update()
	-- 先清空以前显示的文字
	SuperToolTip2_AttrCompare2_ClearText()

	local cmptype = SuperTooltips2_Cmp2:LuaFnGetCmpType()--enum EQUIPCOMPARE_TYPE
	local toDisplay = "SuperToolTip2_AttrCompare2_Title;SuperToolTip2_AttrCompare2_Property"
	if cmptype == 1 then
		toDisplay = toDisplay..";SuperToolTip2_AttrCompare2_Title2;SuperToolTip2_AttrCompare2_Property2"
	end
	SuperToolTip2_AttrCompare2_Frame:SetProperty("PageElements", toDisplay)
	
	--equiping's attributa
	local szPropertys = SuperTooltips2_Cmp2:LuaFnGetBaseAttrCmp()
	if( szPropertys ~= nil) then
		SuperToolTip2_AttrCompare2_Property:SetText(szPropertys)
	else
		SuperToolTip2_AttrCompare2_Property:SetText("#{ZBBJ_250313_6}")
	end

	--attribute detail
	local AttrStr = AttrCompare2_2:GetAttrCmpStr()
	if AttrStr ~= nil then
		SuperToolTip2_AttrCompare2_Property2:SetText(AttrStr)
	else
		SuperToolTip2_AttrCompare2_Property2:SetText("#{ZBBJ_250313_6}")
	end
end

function SuperToolTip2_AttrCompare2_UpdateYoffset()
	--count yoffset (dependon supertooltip2.layout.xml supertooltip2.lua)
	local firstpartyoffset = 0
	SuperToolTip2_AttrCompare2_y_offset = -25
	if SuperTooltips2:IsPresent() then
		local typeDesc = SuperTooltips2:GetTypeDesc()
		local nGemHoleCounts = SuperTooltips2:GetGemHoleCounts()
		local nMoney1, szMoneyDesc1 = SuperTooltips2:GetMoney1()
		local nMoney2, szMoneyDesc2 = SuperTooltips2:GetMoney2()
		local nYuanbaotrade = SuperTooltips2:GetYuanbaoTradeFlag()
		local nGoodsProtect = SuperTooltips2:GetGoodsProtect_Goods()

		--if SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="" then
			firstpartyoffset = firstpartyoffset + 106
		--end
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
	SuperToolTip2_AttrCompare2_y_offset = SuperToolTip2_AttrCompare2_y_offset + firstpartyoffset + SuperTooltips2:LuaFnGetCmpYOffset()
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function SuperToolTip2_AttrCompare2_ClearText()
	SuperToolTip2_AttrCompare2_Property:SetText("")
	SuperToolTip2_AttrCompare2_Property2:SetText("")
end
