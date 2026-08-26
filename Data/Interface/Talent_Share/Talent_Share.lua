local g_Talent_Share_Frame_UnifiedPosition = nil 

local g_Talent_Share_UI = {}
local g_Talent_Share_Item = {}
local g_Talent_Share_Line = {}
local g_Talent_Share_LearnedList = {}
local g_Talent_Share_StudyTree = {}
local g_Talent_Share_poslist = {}
local g_Talent_Share_curToplayer = -1
local g_Talent_Share_Schema = nil
local g_Talent_Share_subSchema = nil
local g_Talent_Share_Info =
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


function Talent_Share_PreLoad()

	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("OPEN_SHARESECT")
	this:RegisterEvent("SECT_OPPOSITE",false)

end 

-- Talent_Share_DragTitle => TLBB_DragTitle
-- Talent_Share_Close => TLBB_ButtonClose
-- Talent_Share_Frame_Client => DefaultWindow
-- Talent_Share_Help => TLBB_ButtonHelp
function Talent_Share_OnLoad()
	g_Talent_Share_Frame_UnifiedPosition = Talent_Share_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Share_Skill"..i.."Icon"]
		local name = _G["Talent_Share_Skill"..i.."Name"]
		local level = _G["Talent_Share_Skill"..i.."Level"]
		local iconmask = _G["Talent_Share_Skill"..i.."IconMask"]
		local all = _G["Talent_Share_Skill"..i]
		g_Talent_Share_Item[i] = {icon=icon,name=name,level=level,iconmask = iconmask,all=all}

	end

	for i=1,9 do
		local light = _G["Talent_Share_Tree_Line"..i.."_2"]
		local dark  = _G["Talent_Share_Tree_Line"..i]

		g_Talent_Share_Line[i] = { light = light, dark = dark}

	end

	g_Talent_Share_UI[1] = {icon = Talent_Share_SkillIcon, name = Talent_Share_SkillName}
	g_Talent_Share_UI[2] = {[1] = g_Talent_Share_Item[1], [2] = g_Talent_Share_Item[2],[3] = g_Talent_Share_Item[3]}
	g_Talent_Share_UI[3] = {[1] = g_Talent_Share_Item[4], [2] = g_Talent_Share_Item[5],[3] = g_Talent_Share_Item[6]}
	g_Talent_Share_UI[4] = {[1] = g_Talent_Share_Item[7], [2] = g_Talent_Share_Item[8],[3] = g_Talent_Share_Item[9]}
	g_Talent_Share_UI[5] = {[1] = g_Talent_Share_Item[10], [2] = g_Talent_Share_Item[11],[3]=g_Talent_Share_Item[12]}


end

function Talent_Share_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Talent_Share_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Share_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Share_On_Hide()
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		Talent_Share_CareObj()
	elseif (event == "OPEN_SHARESECT") then

		local menpai,secttype = DataPool:Lua_GetTargetSectMT()
		secttype = secttype + 1
		Talent_Share_InitSchema(menpai,secttype)
		Talent_Share_MakeSubSchema(1)
		Talent_Share_SetFenYe(1)
		Talent_Share_Update()
		PushEvent("SECT_OPPOSITE",4)
		this:Show()
	elseif event == "SECT_OPPOSITE" then
		
		if tonumber(arg0) ~= 4 then
			this:Hide()
		end		
	end
end

function Talent_Share_InitSchema(menpai,secttype)
	--调用
	g_Talent_Share_Schema = DataPool:Lua_GetSectSchema(menpai,secttype-1) 

end

function Talent_Share_SetFenYe(page)
	local fenyetable = {Talent_Share_SkillTree_Advance,Talent_Share_SkillTree_Advance2,Talent_Share_SkillTree_Advance3,Talent_Share_SkillTree_Advance4}
	for i , v in ipairs(fenyetable) do
		if i == page then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end

function Talent_Share_ChangeFenye(page)
	Talent_Share_SetFenYe(page)
	Talent_Share_MakeSubSchema(page)


	Talent_Share_Update()
end

function Talent_Share_Update()
	local menpai,secttype = DataPool:Lua_GetTargetSectMT()
	secttype = secttype + 1
	Talent_Share_InitSect(menpai,secttype)
	Talent_Share_produceline()
	Talent_Share_ShowLearnTree(menpai,secttype)	
end

function Talent_Share_MakeSubSchema(page)

	local pagelist = 
	{
		[1] = {1,2,3,4,5},
		[2] = {1,6,7,8,9},
		[3] = {1,10,11,12,13},
		[4] = {1,14,15,16,17},
	}
	g_Talent_Share_subSchema = {}

	for i=1,5 do
		table.insert(g_Talent_Share_subSchema,i,g_Talent_Share_Schema.info[pagelist[page][i]])
	end
end



function Talent_Share_CareObj()
	if(tonumber(arg0) ~= g_objCareID) then
		return;
	end
	--如果和NPC的距离大于一定距离或犨被删除，自动关睜
	if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
		--取消关心
		Talent_Share_StopCareObject(g_objCareID)
		Talent_Share_On_Hide()
	end		
end

function Talent_Share_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "Talent_Share");
	g_objCareID = -1;
end

function Talent_Share_BeginCareObject(objid)
	g_Object = objid
	this:CareObject(g_Object, 1, "Talent_Share");
end

--处理连线
function Talent_Share_Getline(p1,p2)

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
function Talent_Share_produceline()
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

	for i,v in ipairs(g_Talent_Share_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}
	for i,v in pairs(g_Talent_Share_StudyTree) do
		local lineid = Talent_Share_Getline(coverpos(g_Talent_Share_poslist[v]),coverpos(g_Talent_Share_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Share_Line[vj].dark:Show()		
	end	
	--目前只有一个6,12 是跨行的，特写一下
	if g_Talent_Share_curToplayer == 5 then
		local lineindex = Talent_Share_Getline(g_Talent_Share_LearnedList[3].pos,g_Talent_Share_LearnedList[5].pos)
		if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
			
			g_Talent_Share_Line[lineindex].light:Show()
			g_Talent_Share_Line[lineindex].dark:Hide()
		end		
	end

	for i,v in ipairs(g_Talent_Share_LearnedList) do
		if g_Talent_Share_LearnedList[i+1] ~= nil then
			local lineindex = Talent_Share_Getline(g_Talent_Share_LearnedList[i].pos,g_Talent_Share_LearnedList[i+1].pos)

			if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
				
				g_Talent_Share_Line[lineindex].light:Show()
				g_Talent_Share_Line[lineindex].dark:Hide()
			end
		end
	end

end
--处理连线end


function Talent_Share_On_ResetPos()
	Talent_Share_Frame:SetProperty("UnifiedPosition", g_Talent_Share_Frame_UnifiedPosition)
end

function Talent_Share_On_Hide()
	this:Hide()
end

function Talent_Share_Close_Click()
end

function Talent_Share_Help_Click()
end

function Talent_Share_Close()
	this:Hide()
end


function Talent_Share_ShowLearnTree(menpai,secttype)
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

	local list = g_Talent_Share_Info[menpai][secttype]
	local totallist = {}
	local light = {}
	local dark = {}
	if g_Talent_Share_curToplayer <= 1 then
		for i,v in ipairs(g_Talent_Share_subSchema) do
			for vi,vv in ipairs(v) do
				if i == 1 then

				else
					if i <= 2 then
						if vv > 0 then
							table.insert(light,vv)
							g_Talent_Share_UI[i][vi].iconmask:Hide();
						end				
					else
						if(vv > 0) then
							table.insert(dark,vv)
						end
					end

				end
			end
			
		end	
		
		Talent_Share_produceBoard(light,1)
		Talent_Share_produceBoard(dark,0)	
		return --????
	end
	--构建全表
	for i,v in ipairs(g_Talent_Share_subSchema) do
		for vi,vv in ipairs(v) do
			if i == 1 then

			else
				if i <= g_Talent_Share_curToplayer then
					if vv > 0 then
						if g_Talent_Share_LearnedList[i] and vv == g_Talent_Share_LearnedList[i].id then
							table.insert(light,vv)
							g_Talent_Share_UI[i][vi].iconmask:Hide();
							removekey(totallist,vv)	
						else
							table.insert(dark,vv)
							g_Talent_Share_UI[i][vi].iconmask:Show();
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
		for i = g_Talent_Share_curToplayer+1,5 do
			for j,vj in ipairs(g_Talent_Share_subSchema[i]) do
				if vj > 0 then
					if g_Talent_Share_poslist[vj].canlearn > 0 then
						table.insert(light,vj)
						removekey(totallist,vj)	
					else
						table.insert(dark,vj)
						removekey(totallist,vj)	
					end
				end
			end
		end


		Talent_Share_produceBoard(light,1)
		Talent_Share_produceBoard(dark,0)
end


function Talent_Share_GetposByID(id)
	if g_Talent_Share_poslist[id] ~= nil then
		return g_Talent_Share_poslist[id].layer,g_Talent_Share_poslist[id].col
	end	

	return 1,1
end

function Talent_Share_produceBoard(list,blight)
	if list ~= nil then
		for i,v in pairs(list) do
			local x,y =Talent_Share_GetposByID(v)

			if x > 1 then
				if blight == 1 then
					Talent_MaskHide(g_Talent_Share_UI[x][y].all)
				else
					Talent_MaskShow(g_Talent_Share_UI[x][y].all)
				end
				
			end
		end	
	end
end


function Talent_Share_InitSect(menpai,secttype)

	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	local totallevel = DataPool:Lua_GetSectTotalLevel(1)

	local listTT = g_Talent_Share_Info[menpai][secttype]

	local sectname = DataPool:Lua_GetSectName(menpai,secttype-1)

	Talent_Share_LiuPaiName:SetText(sectname)
	Talent_Share_LiuPaiDetails:SetText(listTT.instrct)
	Talent_Share_LiuPaiIcon:SetProperty( "Image", listTT.icon )
	g_Talent_Share_StudyTree = {}
	g_Talent_Share_LearnedList = {}
	g_Talent_Share_poslist = {}
	for i,v in ipairs(g_Talent_Share_subSchema) do
		for vi,vv in ipairs(v) do
			--PushDebugMessage("vv="..vv)
			local infodetail;
			local action = nil
			local bhave,level;
			local canlearn = 0
			if vv >= 0 then
				bhave,level = DataPool:Lua_HasSect(vv,1);
				
				infodetail = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",vv)	
				action = DataPool:Lua_CreateSectInfoAction(vv,level);
				--把他的前置条件存一下
				if infodetail.limittype > 0 then
					table.insert(g_Talent_Share_StudyTree,vv,infodetail.limittype)
				end
				if bhave > 0 then
					table.insert(g_Talent_Share_LearnedList,i,{id = vv, pos = (i-2)*3+vi, line=i,col=vi,level=level})
					g_Talent_Share_curToplayer = i
				else
					canlearn = Talent_Share_CheckCanLearn(infodetail,totallevel) 

				end
				table.insert(g_Talent_Share_poslist,vv,{layer = i,col = vi,canlearn = canlearn})
			end
			if i == 1 then
				--第一层数据少
				if action then
					g_Talent_Share_UI[i].icon:SetActionItem(action:GetID());
				end
				g_Talent_Share_UI[i].name:SetText(infodetail.szName)
			else
				local uidata = g_Talent_Share_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)

					if(action) then
						uidata.icon:SetActionItem(action:GetID());
					end
					uidata.name:SetText(infodetail.szName);
					if bhave == 0 then
						if canlearn > 0 then
							uidata.iconmask:Hide()
						else
							uidata.iconmask:Show()
						end

					else
						Talent_Share_MaskHide(uidata.all)
						uidata.iconmask:Hide()							
					end
					uidata.level:SetText(level.."/"..infodetail.maxlevel)
				end

			end
		end
		
	end

	

end

function Talent_Share_CheckCanLearn(infodetail,totalpoint)
	local canup1 = 0;
	local canup2 = 0;
	if infodetail.limittype > 0 then
		local bhave,level = DataPool:Lua_HasSect(infodetail.limittype,1);
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


function Talent_Share_MaskHide(mask)
	mask:SetProperty("Image","set:Talent image:Talent_HoverBK")
end

function Talent_Share_MaskShow(mask)
	mask:SetProperty("Image","set:Talent image:Talent_DisBK")
end
