local g_Talent_Frame_UnifiedPosition = nil 

local g_Talent_UI = {}
local g_Talent_Item = {}
local g_Talent_Line = {}
local g_Talent_LearnedList = {}
local g_Talent_poslist = {}
local g_Talent_StudyTree = {}
local g_Talent_curToplayer = -1
local g_Talent_Schema = nil
local g_Talent_subSchema = nil
local g_Talent_curFenye = 1
local g_Talent_Info =
{
	[0] =
	{
		[1] = {instrct = "#{TalentSL_20210804_02}",icon="set:Talent image:Talent_SLLH"},
		[2] = {instrct = "#{TalentSL_20210804_04}",icon="set:Talent image:Talent_SLJG"}
	},
	[1] =
	{
		[1] = {instrct = "#{TalentMJ_20210804_02}",icon="set:Talent image:Talent_MJTL"},
		[2] = {instrct = "#{TalentMJ_20210804_04}",icon="set:Talent image:Talent_MJXL"}
	},	

	[2] =
	{
		[1] = {instrct = "#{TalentGB_20210804_02}",icon="set:Talent image:Talent_GBJK"},
		[2] = {instrct = "#{TalentGB_20210804_04}",icon="set:Talent image:Talent_GBXX"}
	},
	[3] =
	{
		[1] = {instrct = "#{TalentWD_20210804_02}",icon="set:Talent2 image:Talent_WDPX"},
		[2] = {instrct = "#{TalentWD_20210804_04}",icon="set:Talent2 image:Talent_WDZX"}
	},
	[4] =
	{
		[1] = {instrct = "#{TalentEM_20210804_02}",icon="set:Talent image:Talent_EMQF"},
		[2] = {instrct = "#{TalentEM_20210804_04}",icon="set:Talent image:Talent_EMQY"}
	},
	[5] =
	{
		[1] = {instrct = "#{TalentXX_20210804_02}",icon="set:Talent2 image:Talent_XXHM"},
		[2] = {instrct = "#{TalentXX_20210804_04}",icon="set:Talent2 image:Talent_XXJE"}
	},
	[6] =
	{
		[1] = {instrct = "#{TalentTL_20210804_02}",icon="set:Talent image:Talent_TLLW"},
		[2] = {instrct = "#{TalentTL_20210804_04}",icon="set:Talent image:Talent_TLPT"}
	},
	[7] =
	{
		[1] = {instrct = "#{TalentTS_20210804_02}",icon="set:Talent2 image:Talent_TSNS"},
		[2] = {instrct = "#{TalentTS_20210804_04}",icon="set:Talent2 image:Talent_TSXY"}
	},
	[8] =
	{
		[1] = {instrct = "#{TalentXY_20210804_02}",icon="set:Talent2 image:Talent_XYYX"},
		[2] = {instrct = "#{TalentXY_20210804_04}",icon="set:Talent2 image:Talent_XYMG"}
	},
	[10] =
	{
		[1] = {instrct = "#{TalentMT_20220621_04}",icon="set:Talent2 image:Talent_MTWL"},
		[2] = {instrct = "#{TalentMT_20220621_05}",icon="set:Talent2 image:Talent_MTZM"}
	},
	[11] =--MPTODO menpai11
	{
		[1] = {instrct = "#{TalentER_20240802_04}",icon="set:Talent3 image:Talent_ERGSH"},
		[2] = {instrct = "#{TalentER_20240802_05}",icon="set:Talent3 image:Talent_ERGPM"}
	},
}
-------------------------------------------
--统一化下页签显示隐藏 目前固定顺序 新增改序号 每个页签都需要添加
local g_Page = {
	[1] = {Text = "#{INTERFACE_XML_877}",		NeedCheck = 0,Tip = ""},
	[2] = {Text = "#{INTERFACE_XML_882}",		NeedCheck = 0,Tip = ""},
	[3] = {Text = "#{INTERFACE_XML_854}",		NeedCheck = 0,Tip = ""},
	[4] = {Text = "#{WH_xml_XX(95)}",			NeedCheck = 0,Tip = ""},
	[5] = {Text = "#{XL_XML_35}",				NeedCheck = 0,Tip = ""},
	[6] = {Text = "#{TalentMP_20210804_57}",	NeedCheck = 1,Tip = ""},
	[7] = {Text = "#{SZXT_221216_22}",			NeedCheck = 0,Tip = "#{SZXT_221216_23}"},
	[8] = {Text = "#{SBFW_20230707_1}",		NeedCheck = 1,Tip = "#{SBFW_20230707_2}"},
	[9] = {Text = "#{DWJJ_240329_153}",  	 	NeedCheck = 0,Tip = ""},
	[10] = {Text = "#{DFJC_250709_1}",		NeedCheck = 0,Tip = ""},
	[11] = {Text = "#{GRYM_221213_22}",  	 	NeedCheck = 0,Tip = ""},
	[12] = {Text = "#{INTERFACE_XML_496}",		NeedCheck = 0,Tip = ""},
	

}
local g_PageButton = {}
local g_PageTip = {}
local g_PageMask = {}
local g_MaxPage = 12
local g_PageCount = 12
local g_PageOrder = {}


local g_Talent_ButtonMis = 
{
	[2] = {id = 2080, msg = "#{TalentMP_20210804_84}"},
	[3] = {id = 2211, msg = "#{WUDAO_20230613_401}"},
	[4] = {id = 2359, msg = "#{WUDAO_20250325_01}"},
}

function Talent_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("TOGGLE_SECT_PAGE")
	this:RegisterEvent("SECT_OPPOSITE",false)
	this:RegisterEvent("FLUSH_SECT_PT",false)
	
	this:RegisterEvent("UPDATE_EXTERIOR_TIP")
end 

-- Talent_Checkbox_Frame => DefaultWindow
-- Talent_DragTitle => TLBB_DragTitle
-- Talent_Help => TLBB_ButtonHelp
-- Talent_Frame_Client => DefaultWindow
-- Talent_Close => TLBB_ButtonClose
function Talent_OnLoad()
	g_Talent_Frame_UnifiedPosition = Talent_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Skill"..i.."Icon"]
		local name = _G["Talent_Skill"..i.."Name"]
		local level = _G["Talent_Skill"..i.."Level"]
		local iconmask = _G["Talent_Skill"..i.."IconMask"]
		local all =  _G["Talent_Skill"..i]
		g_Talent_Item[i] = {icon=icon,name=name,level = level,iconmask=iconmask, all=all}

	end


	for i=1,9 do
		local light = _G["Talent_Tree_Line"..i.."_2"]
		local dark  = _G["Talent_Tree_Line"..i]

		g_Talent_Line[i] = { light = light, dark = dark}

	end
	
	g_Talent_UI[1] = {icon = Talent_SkillIcon, name = Talent_SkillName}
	g_Talent_UI[2] = {[1] = g_Talent_Item[1], [2] = g_Talent_Item[2],[3] = g_Talent_Item[3]}
	g_Talent_UI[3] = {[1] = g_Talent_Item[4], [2] = g_Talent_Item[5],[3] = g_Talent_Item[6]}
	g_Talent_UI[4] = {[1] = g_Talent_Item[7], [2] = g_Talent_Item[8],[3] = g_Talent_Item[9]}
	g_Talent_UI[5] = {[1] = g_Talent_Item[10], [2] = g_Talent_Item[11],[3]=g_Talent_Item[12]}

	g_PageButton[1] = Talent_SelfEquip
	g_PageButton[2] = Talent_SelfData
	g_PageButton[3] = Talent_Pet
	g_PageButton[4] = Talent_Wuhun
	g_PageButton[5] = Talent_Xiulian
	g_PageButton[6] = Talent_Talent
	g_PageButton[7] = Talent_Lingyu
	g_PageButton[8] = Talent_Weapon2
	g_PageButton[9] = Talent_DWJinJie
	g_PageButton[10] = Talent_Peak
	g_PageButton[11] = Talent_Profile
	g_PageButton[12] = Talent_OtherInfo
	

	
	g_PageMask[1] = Talent_SelfEquip_Mask
	g_PageMask[2] = Talent_SelfData_Mask
	g_PageMask[3] = Talent_Pet_Mask
	g_PageMask[4] = Talent_Wuhun_Mask
	g_PageMask[5] = Talent_Xiulian_Mask
	g_PageMask[6] = Talent_Talent_Mask
	g_PageMask[7] = Talent_Lingyu_Mask
	g_PageMask[8] = Talent_Weapon2_Mask
	g_PageMask[9] = Talent_DWJinJie_Mask
	g_PageMask[10] = Talent_Peak_Mask
	g_PageMask[11] = Talent_Profile_Mask
	g_PageMask[12] = Talent_OtherInfo_Mask
	

	
	g_PageTip[1] = Talent_SelfEquip_tips
	g_PageTip[2] = Talent_SelfData_tips
	g_PageTip[3] = Talent_Pet_tips
	g_PageTip[4] = Talent_Wuhun_tips
	g_PageTip[5] = Talent_Xiulian_tips
	g_PageTip[6] = Talent_Talent_tips
	g_PageTip[7] = Talent_Lingyu_tips
	g_PageTip[8] = Talent_Weapon2_tips
	g_PageTip[9] = Talent_DWJinJie_tips
	g_PageTip[10] = Talent_Peak_tips
	g_PageTip[11] = Talent_Profile_tips
	g_PageTip[12] = Talent_OtherInfo_tips
	


end

function Talent_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Talent_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_On_Hide()
	elseif event == "TOGGLE_SECT_PAGE" then
		if this:IsVisible() then
			this:Hide()
			return
		end
		PushEvent("SECT_OPPOSITE",3)
			--Pos
		local selfUnionPos = Variable:GetVariable("SelfUnionPos");
		if(selfUnionPos ~= nil) then
			Talent_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		local menpai = Player:GetData("MEMPAI")
		Talent_InitSchema(menpai,DataPool:GetSectType()) 

		local totallevel = DataPool:Lua_GetSectTotalLevel(0)
		local maxlayer = 4;		--????
		local showlayer = math.floor(totallevel/20)+1;
		if showlayer > maxlayer then
			showlayer = maxlayer	--????????
		end



		Talent_ChangeFenye(showlayer,1)

		Talent_ShowPage()
		this:Show()
		Talent_UpdateRedPoint()
		local isopen6 = T300Func:IsNoDifOpen(6)
		local isopen5 = T300Func:IsNoDifOpen(5)
		if isopen5 == 1 then
			--Talent_Wuhun:Disable()
		else
			Talent_Wuhun:Enable()
		end
		if isopen6 == 1 then
			--Talent_Xiulian:Disable()
		else
			Talent_Xiulian:Enable()
		end

		return
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 3 then
			this:Hide()
		end
	elseif event == "FLUSH_SECT_PT" then
		Talent_SetLeftpoint()

	end
	
	if event == "UPDATE_EXTERIOR_TIP" and this:IsVisible() then
		Talent_UpdateRedPoint()
	end
end


function Talent_SetFenYe(fenye)
	local fenyetable = {Talent_SkillTree_Advance,Talent_SkillTree_Advance2,Talent_SkillTree_Advance3,Talent_SkillTree_Advance4}
	for i , v in ipairs(fenyetable) do
		if i == fenye then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end
function Talent_Update()
	Talent_Talent:SetCheck(1)


	local menpai = Player:GetData("MEMPAI")
	local secttype = DataPool:GetSectType() + 1

	
	Talent_InitSect(menpai,secttype)
	Talent_produceline()
	Talent_ShowLearnTree(menpai,secttype)
end



function Talent_InitSchema(menpai,secttype)
	g_Talent_Schema = DataPool:Lua_GetSectSchema(menpai,secttype) 



end

function Talent_MakeSubSchema(page)

	local pagelist = 
	{
		[1] = {1,2,3,4,5},
		[2] = {1,6,7,8,9},
		[3] = {1,10,11,12,13},
		[4] = {1,14,15,16,17},
	}
	g_Talent_subSchema = {}

	for i=1,5 do
		table.insert(g_Talent_subSchema,i,g_Talent_Schema.info[pagelist[page][i]])
	end
end

--犫个函数处理第一排能不能学，区分于canlearn犫速度更快一些
--后续如果增加了复杂度，考虑和canlearn合并
function Talent_CanLight(page)
	if page == 1 then
		return 1
	elseif page == 2 then
		local totallevel = DataPool:Lua_GetSectTotalLevel(0)
		if totallevel >= 20 then
			return 1
		end
	end

	return 0
end
--根据已学武道亮or暗一个武道
function Talent_ShowLearnTree(menpai,secttype)
	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	--工具函数，是否有犫个value
	local hasValue = function(list, value)

		for i,v in ipairs(list) do
			if v == value then
				return 1
			end
		end

		return 0
	end




	local totallist = {}
	local light = {}
	local dark = {}

	if g_Talent_curToplayer <= 1 then
		for i,v in ipairs(g_Talent_subSchema) do
			for vi,vv in ipairs(v) do
				if i == 1 then

				else
					if i <= 2 then
						if vv > 0 then
							if Talent_CanLight(g_Talent_curFenye) == 1 then
								table.insert(light,vv)
								g_Talent_UI[i][vi].iconmask:Hide();
							else
								table.insert(dark,vv)
							end
						end				
					else
						if(vv > 0) then
							table.insert(dark,vv)
						end
					end

				end
			end
			
		end	
		
		Talent_produceBoard(light,1)
		Talent_produceBoard(dark,0)	
		return --????
	end

	--构建全表
	for i,v in ipairs(g_Talent_subSchema) do
		for vi,vv in ipairs(v) do
			if i == 1 then

			else
				if i <= g_Talent_curToplayer then
					if vv > 0 then
						if g_Talent_LearnedList[i] and vv == g_Talent_LearnedList[i].id then
							table.insert(light,vv)
							g_Talent_UI[i][vi].iconmask:Hide();
							removekey(totallist,vv)	
						else
							table.insert(dark,vv)
							g_Talent_UI[i][vi].iconmask:Show();
							removekey(totallist,vv)	
						end	
					end				
				else
					if(vv > 0) then
						table.insert(totallist,vv)
					end
				end

			end
		end
		
	end	

			--他上层的
		for i = g_Talent_curToplayer+1,5 do
			for j,vj in ipairs(g_Talent_subSchema[i]) do
				if vj > 0 then
					if g_Talent_poslist[vj].canlearn > 0 then
						table.insert(light,vj)
						removekey(totallist,vj)	
					else
						table.insert(dark,vj)
						removekey(totallist,vj)	
					end
				end
			end
		end


		Talent_produceBoard(light,1)
		Talent_produceBoard(dark,0)

end


function Talent_GetposByID(id)
	if g_Talent_poslist[id] ~= nil then
		return g_Talent_poslist[id].layer,g_Talent_poslist[id].col
	end	

	return 1,1
end

function Talent_produceBoard(list,blight)
	if list ~= nil then
		for i,v in pairs(list) do
			local x,y =Talent_GetposByID(v)
			if x > 1 then
				if blight == 1 then
					Talent_MaskHide(g_Talent_UI[x][y].all)
				else
					Talent_MaskShow(g_Talent_UI[x][y].all)
				end
				
			end
		end	
	end
end
function Talent_SetLeftpoint()
	--剩余天赋点数
	local leftpoint = DataPool:Lua_GetSectPoint()
	Talent_Have:SetText(ScriptGlobal_Format("#{TalentMP_20210804_25}",leftpoint))
end


--处理连线
function Talent_Getline(p1,p2)

	p1 = tonumber(p1)
	p2 = tonumber(p2)
	--lua的二维数组不是很好用
	local list = { 
			[1] = {[4] = 1, [5] = 2},
			[3] = {[5] = 9, [6] = 3},
			[6] = {[9] = 8, [12] = 6},
			[7] = {[10] = 4, [11] = 5},
			[9]= {[12] = 7}}


	if list[p1]~= nil and list[p1][p2] ~= nil then
		return list[p1][p2]
	end
	return -1


end
function Talent_produceline()
	local coverpos = function(info)
		if info then
			return (info.layer-2)*3+info.col   --(i-2)*3+vi
		end
		return -1
	end

	local hasvalue = function(table,value)
		for i,v in pairs(table) do
			if v == value then
				return 1
			end
		end
		return 0
	end		
	--local linelist = g_Talent_Studyup_Info[menpai][secttype].line
	for i,v in ipairs(g_Talent_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}

	for i,v in pairs(g_Talent_StudyTree) do
		local lineid = Talent_Getline(coverpos(g_Talent_poslist[v]),coverpos(g_Talent_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Line[vj].dark:Show()		
	end	
	--目前只有一个6,12 是跨行的，特写一下
	if g_Talent_curToplayer == 5 then
		local lineindex = Talent_Studyup_Getline(g_Talent_LearnedList[3].pos,g_Talent_LearnedList[5].pos)
		if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
			
			g_Talent_Line[lineindex].light:Show()
			g_Talent_Line[lineindex].dark:Hide()
		end		
	end
	for i,v in ipairs(g_Talent_LearnedList) do
		if g_Talent_LearnedList[i+1] ~= nil then
			local lineindex = Talent_Getline(g_Talent_LearnedList[i].pos,g_Talent_LearnedList[i+1].pos)
			if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
				
				g_Talent_Line[lineindex].light:Show()
				g_Talent_Line[lineindex].dark:Hide()
			end
		end
	end

end
--处理连线end

function Talent_InitSect(menpai,secttype)
	Talent_UpPage:Disable()
	Talent_DownPage:Disable()

	g_Talent_LearnedList={}
	g_Talent_poslist = {}
	g_Talent_StudyTree = {}
	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	local IfHasSkill = function(ui,skillid)
		ui.icon:SetProperty("DraggingEnabled","False")
		if skillid > 0 then
					--有技能就换技能的图标啊
			local nSumSkill = GetActionNum("skill");
			for j=1, nSumSkill do
				local theAction = EnumAction(j-1, "skill");
				if theAction:GetDefineID() == skillid then	
					ui.icon:SetProperty("DraggingEnabled","True")
					ui.icon:SetActionItem(theAction:GetID());
					
				end
			end
		end
	end


	Talent_SetLeftpoint()
	local listTT = g_Talent_Info[menpai][secttype]

	local sectname = DataPool:Lua_GetSectName(menpai,secttype-1)
	Talent_LiuPaiIcon:SetProperty( "Image", listTT.icon )
	Talent_LiuPaiName:SetText(sectname)
	Talent_LiuPaiDetails:SetText(listTT.instrct)

	
	local totallevel = DataPool:Lua_GetSectTotalLevel(0)
	for i,v in ipairs(g_Talent_subSchema) do
		for vi,vv in ipairs(v) do
			local infodetail;
			local action = nil
			local bhave,level;
			local canlearn = 0;
			if vv >= 0 then
				bhave,level = DataPool:Lua_HasSect(vv,0);
				action = DataPool:Lua_CreateSectInfoAction(vv,level);
				infodetail = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",vv)

				--把他的前置条件存一下
				if infodetail.limittype > 0 then
					table.insert(g_Talent_StudyTree,vv,infodetail.limittype)
				end		
				if bhave > 0 then
					table.insert(g_Talent_LearnedList,i,{id = vv, pos = (i-2)*3+vi, line=i,col=vi,level=level})
					g_Talent_curToplayer = i
				else
					canlearn = Talent_CheckCanLearn(infodetail,totallevel) 
				end

				table.insert(g_Talent_poslist,vv,{layer = i,col = vi,canlearn=canlearn})
			end
			if i == 1 then
				--第一层数据少
				if action then

					g_Talent_UI[i].icon:SetActionItem(action:GetID());
					IfHasSkill(g_Talent_UI[i],infodetail.addskill)
					g_Talent_UI[i].name:SetText(infodetail.szName)
				end


			else
				local uidata = g_Talent_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)

					if(action) then
						uidata.icon:SetActionItem(action:GetID());
						IfHasSkill(uidata,infodetail.addskill)
					end


					uidata.name:SetText(infodetail.szName);


					if bhave == 0 then
						if canlearn > 0 then
							uidata.iconmask:Hide()
							--Talent_MaskHide(uidata.all)	
						else
							uidata.iconmask:Show()
							--Talent_MaskShow(uidata.all)
						end

					else
						Talent_MaskHide(uidata.all)		
						uidata.iconmask:Hide()						
					end

					uidata.level:SetText(level.."/"..infodetail.maxlevel)
				end

			end
		end
		
	end

end



function Talent_CheckCanLearn(infodetail,totalpoint)
	local canup1 = 0;
	local canup2 = 0;
	if infodetail.limittype > 0 then
		local bhave,level = DataPool:Lua_HasSect(infodetail.limittype,0);
		if bhave > 0 and level >= infodetail.lparam1 then
				canup1 = 1;
		else
			canup1 = 0;
		end
	else
		canup1 = 1
	end

	if(infodetail.lparam2 > 0) then
		if infodetail.lparam2 > totalpoint then
			canup2 = 0
		else
			canup2 = 1
		end
	else
		canup2 = 1
	end

	if canup1 > 0 and canup2 > 0 then
		return 1
	else
		return 0
	end


end

function Talent_CareObj()
	if(tonumber(arg0) ~= g_objCareID) then
		return;
	end
	--如果和NPC的距离大于一定距离或犨被删除，自动关睜
	if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
		--取消关心
		Talent_StopCareObject(g_objCareID)
		Talent_On_Hide()
	end		
end

function Talent_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "Talent");
	g_objCareID = -1;
end

function Talent_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Talent");
end

function Talent_On_ResetPos()
	Talent_Frame:SetProperty("UnifiedPosition", g_Talent_Frame_UnifiedPosition)
end

function Talent_On_Hide()
	this:Hide()
end

function Talent_Help_Click()
end



function Talent_SelfEquip_Page_Switch()

	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	OpenEquip(1);
end

function Talent_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
end

function Talent_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	TogglePetPage();
end


function Talent_Wuhun_Switch()
	local isopen = T300Func:IsNoDifOpen(5)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_24}")
		Talent_Wuhun : SetCheck(0)
		Talent_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);	
	ToggleWuhunPage();
end


function Talent_Xiulian_Switch()
	local isopen = T300Func:IsNoDifOpen(6)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{HSSC_191009_25}")
		Talent_Xiulian : SetCheck(0)
		Talent_ClearPage()
		return
	end
	
    local nLevel = Player:GetData("LEVEL")
	if(nLevel >= 70) then
		Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
		XiuLianPage();
	else
	    Talent_Xiulian:SetCheck(0)
	    PushDebugMessage("#{XL_090707_62}")
	    Talent_ClearPage()
	end
end


function Talent_Talent_Switch()
	Talent_Talent:SetCheck(1)
end

--切换个人牴示界面
function Talent_Profile_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);	
	Exterior:LuaFnExteriorPlayerOpenProfileUI()	
end

function Talent_Page_LingYu()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		PushDebugMessage("#{SZXT_221216_116}")
		Talent_LingYu:SetCheck(0)
		Talent_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleLingYuPage()
end

function Talent_Page_ShenBing()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		Talent_Weapon2:SetCheck(0)
		Talent_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleShenBingPage()
end

function Talent_Page_DWJinJie()
	local isopen = T300Func:IsNoDifOpen(7)
	if isopen ~= nil and isopen == 1 then
		--PushDebugMessage("#{SZXT_221216_116}")
		Talent_DWJinJie:SetCheck(0)
		Talent_ClearPage()
		return
	end
	
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1)
	LuaFnToggleFeaturesPage()
end

function Talent_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
end

function Talent_Close()
	this:Hide()
end

function Talent_OnHidden()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end
function Talent_Page_Peak()
	Variable:SetVariable("SelfUnionPos", Talent_Frame:GetProperty("UnifiedPosition"), 1)
	TogglePeak()
end
function Talent_MaskHide(mask)
	mask:SetProperty("Image","set:Talent image:Talent_HoverBK")
end

function Talent_MaskShow(mask)
	mask:SetProperty("Image","set:Talent image:Talent_DisBK")
end

function Talent_ChatBtn()
	Player:Lua_CreateSectShare()



end

function Talent_ChangeFenye(index,bInit)
	local errorfuc = function(index,bInit)
		local bComplete = DataPool:Lua_IsMissionComplete(g_Talent_ButtonMis[index].id)
		if bComplete ~= 1 then
			if bInit == nil or bInit ~= 1 then		
					PushDebugMessage(g_Talent_ButtonMis[index].msg)
			end
			return 1
		end
		return 0
	end

	if (g_Talent_ButtonMis[index] ~= nil )then
		if errorfuc(index,bInit) == 1 then
			index = g_Talent_curFenye
		end
	end

	Talent_SetFenYe(index)
	Talent_MakeSubSchema(index)
	g_Talent_curFenye = index
	Talent_Update()
end

function Talent_ShowPage()

	for i = 1, g_MaxPage do
		g_PageButton[i]:Hide()
	end
	local nPageNumber = tonumber(Variable:GetVariable("PageNumber"));
	Talent_ClearPage()
	if nPageNumber ~= nil and nPageNumber ~= 0 then
		g_PageButton[nPageNumber]:SetCheck(1)
		for i = 1, g_MaxPage do
			if i ~= nPageNumber then
				g_PageButton[i]:SetCheck(0)
			end
		end
	end
	
	g_PageOrder = {}
	g_PageCount = 0
	for i = 1, g_MaxPage do
		if Talent_CheckPage(i) == 1 then
			g_PageCount = g_PageCount + 1
			g_PageButton[g_PageCount]:Show()
			g_PageButton[g_PageCount]:SetText(g_Page[i].Text)	
			g_PageOrder[g_PageCount] = i
			
			if Talent_IsPageEnable(i) == 1 then
				g_PageButton[g_PageCount]:Enable()
				g_PageMask[g_PageCount]:Hide()
			else
				g_PageButton[g_PageCount]:Disable()
				g_PageMask[g_PageCount]:Show()
				g_PageMask[g_PageCount]:SetToolTip(g_Page[i].Tip)
			end
		end
	end
end

function Talent_OnPageClicked(idx)
	Variable:SetVariable("PageNumber", tostring(idx), 1);
	idx = g_PageOrder[idx]
	if idx == 1 then--??
		Talent_SelfEquip_Page_Switch()
	elseif idx == 2 then--??
		Talent_SelfData_Switch()
	elseif idx == 3 then--??
		Talent_Pet_Switch()
	elseif idx == 4 then--??
		Talent_Wuhun_Switch()
	elseif idx == 5 then--??
		Talent_Xiulian_Switch()
	elseif idx == 6 then--??
		Talent_Talent_Switch()
		Talent_ClearPage()
	elseif idx == 7 then--??
		Talent_Page_LingYu()
	elseif idx == 8 then--??
		Talent_Page_ShenBing()
	elseif idx == 9 then--????
		Talent_Page_DWJinJie()
	elseif idx == 10 then--?? 
		Talent_Page_Peak()
	elseif idx == 11 then--??
		Talent_Profile_Switch()
	elseif idx == 12 then--??
		Talent_Other_Info_Page_Switch()
	end
end

function Talent_CheckPage(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return DataPool:Lua_CheckIsShowTalent()
	elseif idx == 7 then--??
		return 1
	elseif idx == 8 then--??
		return 1
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--?? 
		if Player : GetData("IsOriginalHJ") == 1 then
			return 0
		end
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end

	elseif idx == 11 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 15 then
			return 1
		end
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Talent_IsPageEnable(idx)
	if idx == 1 then--??
		return 1
	elseif idx == 2 then--??
		return 1
	elseif idx == 3 then--??
		return 1
	elseif idx == 4 then--??
		return 1
	elseif idx == 5 then--??
		return 1
	elseif idx == 6 then--??
		return 1
	elseif idx == 7 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 8 then--??
		local my_level = Player:GetData("LEVEL")
		if my_level >= 65 then
			return 1
		end
	elseif idx == 9 then--????
		return 1
	elseif idx == 10 then--??
		
		local my_level = Player:GetData("LEVEL")
		if my_level >= 85 then
			return 1
		end
	elseif idx == 11 then--??
		return 1
	elseif idx == 12 then--??
		return 1
	end
	return 0
end

function Talent_ClearPage()
	Variable:SetVariable("PageNumber", tostring(0), 1)
end

--更新分页红点
function Talent_UpdateRedPoint()
	for i = 1, g_MaxPage do
		g_PageTip[i]:Hide()
	end
end
