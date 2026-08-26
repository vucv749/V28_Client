local SuperToolTip2_AttrCompare_y_offset = -25
local SuperToolTip2_AttrCompare_g_WidthOfCompare = 0
--=========
--PreLoad==
--=========
function SuperToolTip2_AttrCompare_PreLoad()
	this:RegisterEvent("SHOW_SP2_CMP1")
	this:RegisterEvent("MOVE_SP2_CMP1")
	this:RegisterEvent("CLOSE_SP2_CMP1")
end

--=========
--OnLoad
--=========
function SuperToolTip2_AttrCompare_OnLoad()

end

--=========
--OnEvent
--=========
function SuperToolTip2_AttrCompare_OnEvent(event)
	if (event == "SHOW_SP2_CMP1") then
		--arg0 supertooltip2's posx
		--arg1 supertooltip2's posy
		--arg2 supertooltip2's width
		--arg3 attrCompare's num

		--context update
		SuperToolTip2_AttrCompare_Update()--!!! must before pos Set
		SuperToolTip2_AttrCompare_UpdateYoffset()
		--pos set
		SuperToolTip2_AttrCompare_Frame:PositionSelf(0, 0, 1, 1)
		local posX = SuperToolTip2_AttrCompare_Frame:SetXAttachPos(arg0, arg2, 1)
		SuperToolTip2_AttrCompare_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip2_AttrCompare_y_offset))
		--attrCompare2 show
		local nWidth = SuperToolTip2_AttrCompare_Frame:GetProperty("AbsoluteWidth")
		if tonumber(arg0) > tonumber(posX) then
			--attrCompare in supertooltip2's left
			SuperTooltips2:ShowCmp2WindowSub(posX, tonumber(arg1), nWidth + tonumber(arg2), tonumber(arg3), 0)
		else
			--attrCompare in supertooltip2's right
			SuperTooltips2:ShowCmp2WindowSub(tonumber(arg0), tonumber(arg1), nWidth + tonumber(arg2), tonumber(arg3), 1)
		end

		this:Show()
	elseif event == "MOVE_SP2_CMP1" then
		if this:IsVisible() then
			--arg0 supertooltip2's posx
			--arg1 supertooltip2's posy
			--arg2 supertooltip2's width
			SuperToolTip2_AttrCompare_UpdateYoffset()
			local posX = SuperToolTip2_AttrCompare_Frame:SetXAttachPos(arg0, arg2, 1)
			SuperToolTip2_AttrCompare_Frame:SetProperty("AbsoluteYPosition", tostring(arg1 + SuperToolTip2_AttrCompare_y_offset))
			--move
			local nWidth = SuperToolTip2_AttrCompare_Frame:GetProperty("AbsoluteWidth")
			if tonumber(arg0) > tonumber(posX) then
				--attrCompare in supertooltip2's left
				SuperTooltips2:Cmp2WindowSubMove( posX , tonumber(arg1), nWidth + tonumber(arg2) )
			else
				--attrCompare in supertooltip2's right
				SuperTooltips2:Cmp2WindowSubMove( tonumber(arg0) , tonumber(arg1), nWidth + tonumber(arg2) )
			end
		end
	elseif event == "CLOSE_SP2_CMP1" then
		SuperToolTip2_AttrCompare_y_offset = -25
		this:Hide()
	end

end

--=========
--Update UI
--=========
function SuperToolTip2_AttrCompare_Update()
	-- 先清繝以前显示的文字
	SuperToolTip2_AttrCompare_ClearText()

	local cmptype = SuperTooltips2_Cmp1:LuaFnGetCmpType()--enum EQUIPCOMPARE_TYPE
	local toDisplay = "SuperToolTip2_AttrCompare_Title;SuperToolTip2_AttrCompare_Property"
	if cmptype == 1 then
		toDisplay = toDisplay..";SuperToolTip2_AttrCompare_Title2;SuperToolTip2_AttrCompare_Property2"
	end
	SuperToolTip2_AttrCompare_Frame:SetProperty("PageElements", toDisplay)
	
	--equiping's attributa
	local szPropertys = SuperTooltips2_Cmp1:LuaFnGetBaseAttrCmp()
	if( szPropertys ~= nil) then
		SuperToolTip2_AttrCompare_Property:SetText(szPropertys)
	else
		SuperToolTip2_AttrCompare_Property:SetText("#{ZBBJ_250313_6}")
	end

	--attribute detail
	local AttrStr = AttrCompare2_1:GetAttrCmpStr()
	if AttrStr ~= nil then
		SuperToolTip2_AttrCompare_Property2:SetText(AttrStr)
	else
		SuperToolTip2_AttrCompare_Property2:SetText("#{ZBBJ_250313_6}")
	end
end

function SuperToolTip2_AttrCompare_UpdateYoffset()
	--count yoffset (dependon supertooltip2.layout.xml supertooltip2.lua)
	local firstpartyoffset = 0
	SuperToolTip2_AttrCompare_y_offset = -25
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
	SuperToolTip2_AttrCompare_y_offset = SuperToolTip2_AttrCompare_y_offset + firstpartyoffset + SuperTooltips2:LuaFnGetCmpYOffset()
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清繝显示文本
--
function SuperToolTip2_AttrCompare_ClearText()
	SuperToolTip2_AttrCompare_Property:SetText("")
	SuperToolTip2_AttrCompare_Property2:SetText("")
end
