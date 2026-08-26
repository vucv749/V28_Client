--id:429
--界面1
local g_Talent_Studyup_Frame_UnifiedPosition = nil 

local g_IsShowAni = 0
local g_Talent_Studyup_Item = {}
local g_Talent_Studyup_UI = {}
local g_Talent_Studyup_Line = {}
local g_Talent_Studyup_saveid = -1
local g_Talent_Studyup_layer = -1
local g_Talent_Studyup_col = -1
local g_Talent_Studyup_StudyTree = {}	--???????????????
local g_Talent_Studyup_LearnedList = {}
local g_Talent_Studyup_curToplayer = 0
local g_Talent_Studyup_Schema = nil
local g_Talent_Studyup_subSchema = nil
local g_Talent_Studyup_curFenye = 1
local g_Talent_Studyup_poslist = {}		--??ID????
local g_Talent_Studyup_Info =
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

local g_Talent_Studyup_ButtonMis = 
{
	[2] = {id = 2080, msg = "#{TalentMP_20210804_84}"},
	[3] = {id = 2211, msg = "#{WUDAO_20230613_401}"},
	[4] = {id = 2359, msg = "#{WUDAO_20250325_01}"},
}
function Talent_Studyup_PreLoad()
	this:RegisterEvent("UI_COMMAND",true)
	-- 游戏窗口尺寸发生了变化
	this:RegisterEvent("ADJEST_UI_POS",false)
	-- 游戏分辨率发生了变化
	this:RegisterEvent("VIEW_RESOLUTION_CHANGED",false)
	this:RegisterEvent("HIDE_ON_SCENE_TRANSED",false)
	--this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("OPEN_SECT_LEVELUP")
	this:RegisterEvent("FLUSH_SECT_LEVELUP",false)
	this:RegisterEvent("SECT_OPPOSITE",false)

end 

-- Talent_Studyup_DragTitle => TLBB_DragTitle
-- Talent_Studyup_Help => TLBB_ButtonHelp
-- Talent_Studyup_Close => TLBB_ButtonClose
-- Talent_Studyup_Frame_Client => DefaultWindow
function Talent_Studyup_OnLoad()
	g_Talent_Studyup_Frame_UnifiedPosition = Talent_Studyup_Frame:GetProperty("UnifiedPosition");

	for i =1, 12 do

		local icon = _G["Talent_Studyup_SkillTree_Skill"..i.."Icon"]
		local name = _G["Talent_Studyup_SkillTree_Skill"..i.."Name"]
		local level = _G["Talent_Studyup_SkillTree_Skill"..i.."Level"]
		local mask = _G["Talent_Studyup_SkillTree_Skill"..i]
		local iconmask = _G["Talent_Studyup_SkillTree_Skill"..i.."IconMask"]
		local all = _G["Talent_Studyup_SkillTree_Skill"..i.."Btn"]
		local animate = _G["Talent_Studyup_SkillTree_Skill"..i.."IconAnimate"]
		local animate2 = _G["Talent_Studyup_SkillTree_Skill"..i.."Animate"]
		g_Talent_Studyup_Item[i] = {icon=icon,name=name,level=level,mask=mask, iconmask=iconmask, animate= animate,all=all,animate2= animate2,}

	end

	for i=1,9 do
		local light = _G["Talent_Studyup_SkillTree_Line"..i.."_2"]
		local dark  = _G["Talent_Studyup_SkillTree_Line"..i]

		g_Talent_Studyup_Line[i] = { light = light, dark = dark}

	end
	--g_Talent_Studyup_Item[5].name:SetText("fdd")
	g_Talent_Studyup_UI[1] = {icon = Talent_Studyup_SkillTree_SkillIcon, name = Talent_Studyup_SkillTree_SkillName}
	g_Talent_Studyup_UI[2] = {[1] = g_Talent_Studyup_Item[1], [2] = g_Talent_Studyup_Item[2],[3] = g_Talent_Studyup_Item[3]}
	g_Talent_Studyup_UI[3] = {[1] = g_Talent_Studyup_Item[4], [2] = g_Talent_Studyup_Item[5],[3] = g_Talent_Studyup_Item[6]}
	g_Talent_Studyup_UI[4] = {[1] = g_Talent_Studyup_Item[7], [2] = g_Talent_Studyup_Item[8],[3] = g_Talent_Studyup_Item[9]}
	g_Talent_Studyup_UI[5] = {[1] = g_Talent_Studyup_Item[10], [2] = g_Talent_Studyup_Item[11],[3]=g_Talent_Studyup_Item[12]}


	--Talent_Studyup_SkillTree_MenPai:Hide()
end

function Talent_Studyup_OnEvent(event)
	if(event == "ADJEST_UI_POS") then
		Talent_Studyup_On_ResetPos()
	elseif(event == "VIEW_RESOLUTION_CHANGED") then
		Talent_Studyup_On_ResetPos()
	elseif(event == "HIDE_ON_SCENE_TRANSED") then
		Talent_Studyup_On_Hide()
	elseif event == "OPEN_SECT_LEVELUP" then
		g_IsShowAni = 0
		local menpai = Player:GetData("MEMPAI")
		local secttype = DataPool:GetSectType() + 1
		--
		--必需先读取样式
		Talent_Studyup_InitSchema(menpai,secttype)
		--根据点数算出来该牴示哪一页了
		local totallevel = DataPool:Lua_GetSectTotalLevel(0)
		local maxlayer = 4;		--??4?
		local showlayer = math.floor(totallevel/20)+1;
		if showlayer > maxlayer then
			showlayer = maxlayer	--????????
		end




		Talent_Studyup_ChangeFenye(showlayer,1)

		local targetobjId = tonumber(arg0);

		Talent_Studyup_BeginCareObject(targetobjId)
		PushEvent("SECT_OPPOSITE",1)
		Talent_Studyup_SkillTree_Advance2Animate:Hide()
		Talent_Studyup_SkillTree_Advance3Animate:Hide()
		Talent_Studyup_SkillTree_Advance4Animate:Hide()
		this:Show()	
		
	elseif event == "FLUSH_SECT_LEVELUP" then
		local menpai = Player:GetData("MEMPAI")
		local secttype = DataPool:GetSectType() + 1
		Talent_Studyup_InitSect(menpai,secttype)
		Talent_Studyup_produceline()	
		local param = tonumber(arg0);
		Talent_Studyup_animate(param)
		Talent_Studyup_SkillTreeClicked(g_Talent_Studyup_layer,g_Talent_Studyup_col)
	elseif event == "SECT_OPPOSITE" then
		if tonumber(arg0) ~= 1 then
			this:Hide()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 89324301 then
		if(this:IsVisible()) then
			Talent_Studyup_SkillTree_Advance2Animate:Show()
			g_IsShowAni = 1
			Talent_Studyup_Update()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99835302 then
		
		if(this:IsVisible()) then
			Talent_Studyup_SkillTree_Advance3Animate:Show()
			g_IsShowAni = 1
			Talent_Studyup_Update()
		end
	elseif event == "UI_COMMAND" and tonumber(arg0) == 99971202 then
		
		if(this:IsVisible()) then
			Talent_Studyup_SkillTree_Advance4Animate:Show()
			g_IsShowAni = 1
			Talent_Studyup_Update()
		end
	end
end

function Talent_Studyup_Update()
	local menpai = Player:GetData("MEMPAI")
	local secttype = DataPool:GetSectType() + 1
	
	Talent_Studyup_InitSect(menpai,secttype)
	Talent_Studyup_produceline()
	local line,col = Talent_Studyup_ShowSkill(menpai,secttype)
	Talent_Studyup_SkillTreeClicked(line,col)
end

function Talent_Studyup_animate(param)
	local i,j = Talent_Studyup_GetposByID(param)
	if i > 1 then
		g_Talent_Studyup_UI[i][j].animate:Play(true)
	end

end

function Talent_Studyup_InitSchema(menpai,secttype)
	--调用
	g_Talent_Studyup_Schema = DataPool:Lua_GetSectSchema(menpai,secttype-1) 

end

function Talent_Studyup_MakeSubSchema(page)

	local pagelist = 
	{
		[1] = {1,2,3,4,5},
		[2] = {1,6,7,8,9},
		[3] = {1,10,11,12,13},
		[4] = {1,14,15,16,17},
	}
	g_Talent_Studyup_subSchema = {}

	for i=1,5 do
		table.insert(g_Talent_Studyup_subSchema,i,g_Talent_Studyup_Schema.info[pagelist[page][i]])
	end
end

function Talent_Studyup_GetposByID(id)
	if g_Talent_Studyup_poslist[id] ~= nil then
		return g_Talent_Studyup_poslist[id].layer,g_Talent_Studyup_poslist[id].col
	end	

	return 1,1
end


--犫个是自动选中将要可以学习的技能~
function Talent_Studyup_ShowSkill(menpai,secttype)
	if g_Talent_Studyup_curToplayer == 1 then
		return 2,1
	end
	list = g_Talent_Studyup_subSchema
	local learnedinfo = g_Talent_Studyup_LearnedList[g_Talent_Studyup_curToplayer];
	if learnedinfo ~= nil then
		if learnedinfo.level < 5 or g_Talent_Studyup_curToplayer == 5 then	--????????5?
			return learnedinfo.line,learnedinfo.col
		else

			--犫里好像不对
			--第二顺位			
			for i,v in ipairs(list[g_Talent_Studyup_curToplayer+1]) do
			--下一排的需要挨个检验
				if g_Talent_Studyup_StudyTree[v] ~= nil then
					if g_Talent_Studyup_StudyTree[v] ~= nil then
						if g_Talent_Studyup_StudyTree[v] == learnedinfo.id then
							return g_Talent_Studyup_curToplayer+1,i
						else

						end
					end
				else
					return g_Talent_Studyup_curToplayer+1,i
				end
			end			
			--返回下一层第一个
			return g_Talent_Studyup_curToplayer+1,1
		end

	


	end

end

--处理连线
function Talent_Studyup_Getline(p1,p2)

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
function Talent_Studyup_produceline()

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

	for i,v in ipairs(g_Talent_Studyup_Line) do

		v.light:Hide()
		v.dark:Hide()
	end

	local linelist = {}
	--可以根据g_Talent_Studyup_StudyTree算出那些有关联
	for i,v in pairs(g_Talent_Studyup_StudyTree) do
		local lineid = Talent_Studyup_Getline(coverpos(g_Talent_Studyup_poslist[v]),coverpos(g_Talent_Studyup_poslist[i]))
		if lineid > 0 then
			table.insert(linelist,lineid)
		end
	end
	for j,vj in pairs(linelist) do
		g_Talent_Studyup_Line[vj].dark:Show()		
	end	

	--目前只有一个6,12 是跨行的，特写一下
	if g_Talent_Studyup_curToplayer == 5 then
		local lineindex = Talent_Studyup_Getline(g_Talent_Studyup_LearnedList[3].pos,g_Talent_Studyup_LearnedList[5].pos)
		if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
			
			g_Talent_Studyup_Line[lineindex].light:Show()
			g_Talent_Studyup_Line[lineindex].dark:Hide()
		end		
	end
	for i,v in ipairs(g_Talent_Studyup_LearnedList) do
		if g_Talent_Studyup_LearnedList[i+1] ~= nil then
			local lineindex = Talent_Studyup_Getline(g_Talent_Studyup_LearnedList[i].pos,g_Talent_Studyup_LearnedList[i+1].pos)

			if lineindex > 0 and hasvalue(linelist,lineindex) == 1 then
				
				g_Talent_Studyup_Line[lineindex].light:Show()
				g_Talent_Studyup_Line[lineindex].dark:Hide()
			end
		end
	end

end


function Talent_Studyup_SetLeftpoint(leftpoint)
			--剩余天赋点数

			Talent_Studyup_Skillup_Have:SetText(ScriptGlobal_Format("#{TalentMP_20210804_25}",leftpoint))
end


function Talent_Studyup_CheckCanLearn(infodetail,totalpoint)
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

--设置界面
function Talent_Studyup_InitSect(menpai,secttype)

	Talent_Studyup_SkillTree_Line1:Show()
	Talent_Studyup_SkillTree_UpPage:Disable()
	Talent_Studyup_SkillTree_DownPage:Disable()

	g_Talent_Studyup_StudyTree = {}
	g_Talent_Studyup_LearnedList={}
	g_Talent_Studyup_poslist = {}
	local SetSectcube = function(info,state)
		if state == 0 then
			info.all:Hide()
		else
			info.all:Show()
		end
	end

	local listTT = g_Talent_Studyup_Info[menpai][secttype]
	local sectname = DataPool:Lua_GetSectName(menpai,secttype-1)
	Talent_Studyup_SkillTree_LiuPaiName:SetText(sectname)
	Talent_Studyup_SkillTree_LiuPaiDetails:SetText(listTT.instrct)
	Talent_Studyup_SkillTree_LiuPaiIcon:SetProperty( "Image", listTT.icon )
	
	local totallevel = DataPool:Lua_GetSectTotalLevel(0)
	for i,v in ipairs(g_Talent_Studyup_subSchema) do

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
					table.insert(g_Talent_Studyup_StudyTree,vv,infodetail.limittype)
				end
				if bhave > 0 then
					table.insert(g_Talent_Studyup_LearnedList,i,{id = vv, pos = (i-2)*3+vi, line=i,col=vi,level=level})
					g_Talent_Studyup_curToplayer = i
				else
					canlearn = Talent_Studyup_CheckCanLearn(infodetail,totallevel) 
				end

				table.insert(g_Talent_Studyup_poslist,vv,{layer = i,col = vi, canlearn=canlearn})
			end
			if i == 1 then
				--第一层数据少
				if action then
					g_Talent_Studyup_UI[i].icon:SetActionItem(action:GetID());
					g_Talent_Studyup_UI[i].name:SetText(infodetail.szName)
				end

				
			else
				local uidata = g_Talent_Studyup_UI[i][vi];
				if vv < 0 then
					SetSectcube(uidata,0)
				else
					SetSectcube(uidata,1)
					uidata.all:SetCheck(0)
					if(action) then
						uidata.icon:SetActionItem(action:GetID());
					end

					uidata.animate:Play(false)
					uidata.name:SetText(infodetail.szName);

					if i == 2 and g_IsShowAni == 1 and g_Talent_Studyup_curFenye == 2 then
						uidata.animate2:Play(true)
					else
						uidata.animate2:Play(false)
					end

					if i == 2 and g_IsShowAni == 1 and g_Talent_Studyup_curFenye == 3 then
						uidata.animate2:Play(true)
					else
						uidata.animate2:Play(false)
					end

					if i == 2 and g_IsShowAni == 1 and g_Talent_Studyup_curFenye == 4 then
						uidata.animate2:Play(true)
					else
						uidata.animate2:Play(false)
					end

					if bhave == 0 then
						if canlearn > 0 then
							uidata.iconmask:Hide()	
						else
							uidata.iconmask:Show()
						end

					else
						Talent_Studyup_MaskHide(uidata.mask)
						uidata.iconmask:Hide()							
					end

					uidata.level:SetText(level.."/"..infodetail.maxlevel)
				end

			end
		end
		
	end

	

end
function Talent_Studyup_CleanUp()

end

function Talent_Studyup_Close()

	this:Hide()
end


function Talent_Studyup_BeginCareObject(objid)
	local nID = DataPool : GetNPCIDByServerID( objid )
	this:CareObject(nID, 1, "Talent_Studyup");
end

function Talent_Studyup_On_ResetPos()
	Talent_Studyup_Frame:SetProperty("UnifiedPosition", g_Talent_Studyup_Frame_UnifiedPosition)
end

function Talent_Studyup_On_Hide()
	this:Hide()
end

function Talent_Studyup_Help_Click()
end

function Talent_Studyup_Close_Click()
end


function Talent_Studyup_DetailShow(bshow)

	if bshow == 0 then
		Talent_Studyup_Details:Show()
		Talent_Studyup_Skillup:Hide()
	else
		Talent_Studyup_Details:Hide()
		Talent_Studyup_Skillup:Show()
	end

end



function Talent_Studyup_ShowTree()

	for i=2,5 do
		for j,vj in ipairs(g_Talent_Studyup_subSchema[i]) do
			if vj > 0  then				
				local x,y =Talent_Studyup_GetposByID(vj)				
				if i == 2 then
					Talent_Studyup_MaskHide(g_Talent_Studyup_UI[x][y].mask)
				else				
					Talent_Studyup_MaskShow(g_Talent_Studyup_UI[x][y].mask)
				end
			end
		end
	end

	

end


function Talent_Studyup_produceBoard(mainlist,list,blight)
	if list ~= nil then
		for i,v in pairs(list) do
			local x,y =Talent_Studyup_GetposByID(v)
			if x > 1 then
				if blight == 1 then
					Talent_Studyup_MaskHide(g_Talent_Studyup_UI[x][y].mask)
				else
					Talent_Studyup_MaskShow(g_Talent_Studyup_UI[x][y].mask)
				end
				
			end
		end	
	end
end

function Talent_Studyup_DebugList(head,list)
	local str = ""
	if list ~= nil then
		for i,v in pairs(list) do
			str = str..","..v
		end
	else
		str = str.."null"
	end
	PushDebugMessage(head..str)
end


--犫个特点是已经学过的技能，同级和下级铁锁定
function Talent_Studyup_ShowLearnTree(layer,col)

	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	if layer < 2 then
		return
	end

	local id = g_Talent_Studyup_subSchema[layer][col];

	local totallist,light,dark = Talent_Studyup_Createboardlist()



			--他上层的全暗
		for i = g_Talent_Studyup_curToplayer+1,5 do
			for j,vj in ipairs(g_Talent_Studyup_subSchema[i]) do
				if vj > 0 then
					if g_Talent_Studyup_poslist[vj].canlearn > 0 then
						table.insert(light,vj)
						removekey(totallist,vj)	
					else
						table.insert(dark,vj)
						removekey(totallist,vj)	
					end
				end
			end
		end


		Talent_Studyup_produceBoard(list,light,1)
		Talent_Studyup_produceBoard(list,dark,0)

	
end

function Talent_Studyup_Createboardlist()
	local totallist = {}
	local light = {}
	local dark = {}
	--工具函数，移出table
	local removekey = function(list,key)
		for i,v in ipairs(list) do
			if key == v then
				table.remove(list,i)
			end
		end
	end

	--构建全表
	for i,v in ipairs(g_Talent_Studyup_subSchema) do
		for vi,vv in ipairs(v) do
			if i == 1 then

			else
				if i <= g_Talent_Studyup_curToplayer then
					if vv > 0 then
						if g_Talent_Studyup_LearnedList[i] and vv == g_Talent_Studyup_LearnedList[i].id then
							table.insert(light,vv)
							g_Talent_Studyup_UI[i][vi].iconmask:Hide();
							removekey(totallist,vv)	
						else
							table.insert(dark,vv)
							g_Talent_Studyup_UI[i][vi].iconmask:Show();
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
	return totallist,light,dark

end




function Talent_Studyup_SkillTreeClicked(layer,col)

	local menpai = Player:GetData("MEMPAI")
	local secttype = DataPool:GetSectType() + 1

	local totallevel = DataPool:Lua_GetSectTotalLevel(0)

	local id = g_Talent_Studyup_subSchema[layer][col]; --?,??????????
	g_Talent_Studyup_saveid = id 
	g_Talent_Studyup_layer = layer
	g_Talent_Studyup_col = col
	Talent_Studyup_Skillup_Up:Enable()

	if totallevel <= 0 then
		--什么都没学的状态下需要牴示冲突树
		Talent_Studyup_ShowTree()
	else
		Talent_Studyup_ShowLearnTree(layer,col)
	end




	local color = "#cFFF263"
	if layer == 1 then
		local infodesc = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",id)
		
		Talent_Studyup_DetailsName:SetText(info.szName)
		Talent_Studyup_Skillup_DetailsText:SetText(color..DataPool:Lua_GetSectDesc(id,0))
		Talent_Studyup_DetailShow(0)
		Talent_Studyup_SkillTree_SkillBtn:SetCheck(1)

		
	else
		g_Talent_Studyup_UI[layer][col].all:SetCheck(1)
		local bhave,level = DataPool:Lua_HasSect(id,0);
		local infodesc = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",id)
		local info = DataPool:TBSearch_Index_EQU("DBC_SECT_INFO",id)
		Talent_Studyup_DetailShow(1)
		Talent_Studyup_SkillupName:SetText(info.szName)

		local str = ScriptGlobal_Format("#{TalentMP_20210804_69}",level)
		Talent_Studyup_Skilluplevel:SetText(str)
		local strlayer = ScriptGlobal_Format("#{TalentMP_20210804_16}",infodesc.szJingjie)
		Talent_Studyup_SkilluplevelRealm:SetText(strlayer)

		local needpt = 0
			--所需天赋点
			if level == info.maxlevel then
				Talent_Studyup_Skillup_EffectTitle:SetText(ScriptGlobal_Format("#{TalentMP_20210804_17}",level))
				Talent_Studyup_Skillup_Explain1:SetText(color..DataPool:Lua_GetSectDesc(id,level-1))
				Talent_Studyup_Skillup_Explain2:SetText("")
				needpt = 0
				Talent_Studyup_Skillup_Up:Disable()
				Talent_Studyup_Skillup_EffectNextTitleDot:Hide()
				Talent_Studyup_Skillup_EffectNextTitle:Hide()
			elseif level == 0 then
				Talent_Studyup_Skillup_EffectTitle:SetText("#{TalentMP_20210804_60}")
				Talent_Studyup_Skillup_Explain1:SetText(color..DataPool:Lua_GetSectDesc(id,level))

				Talent_Studyup_Skillup_Explain2:SetText("")

				Talent_Studyup_Skillup_EffectNextTitleDot:Hide()
				Talent_Studyup_Skillup_EffectNextTitle:Hide()

				needpt = info.m_levelinfo[level+1].m_point

			else
				Talent_Studyup_Skillup_EffectTitle:SetText(ScriptGlobal_Format("#{TalentMP_20210804_17}",level))
				Talent_Studyup_Skillup_Explain1:SetText(color..DataPool:Lua_GetSectDesc(id,level-1))

				Talent_Studyup_Skillup_EffectNextTitleDot:Show()
				Talent_Studyup_Skillup_EffectNextTitle:Show()		
				Talent_Studyup_Skillup_EffectNextTitle:SetText(ScriptGlobal_Format("#{TalentMP_20210804_19}",level+1))
				Talent_Studyup_Skillup_Explain2:SetText(color..DataPool:Lua_GetSectDesc(id,level))
				

				needpt = info.m_levelinfo[level+1].m_point
			end



			local levelrequire = {Talent_Studyup_Skillup_Text1,Talent_Studyup_Skillup_Text2,Talent_Studyup_Skillup_Text3}

			local str1 = ""
			--处理升级限制条件1
			if info.limittype > 0 then

				local infoc = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",info.limittype)
				str1 = ScriptGlobal_Format("#{TalentMP_20210804_82}",infoc.szName,info.lparam1)
				
			else
				str1 = ""
			end
			
			local str2 = ""
			--处理升级限制条件2
			if info.lparam2 > 0 then
				local sectname = DataPool:Lua_GetSectName(menpai,secttype-1)
				str2 = ScriptGlobal_Format("#{TalentMP_20210804_83}",sectname,info.lparam2 )
			else
				str2 = ""
			end

			local str3 = ""
			--处理冲突字符串
			local conflictstr = ""
			for i,v in ipairs(g_Talent_Studyup_subSchema[layer]) do
				if v > 0 and v ~= id then
					local infocname = DataPool:TBSearch_Index_EQU("DBC_SECT_DESC",v,"szName")	

					conflictstr = conflictstr..infocname..","
				end
			end
			if string.len(conflictstr) > 0 then
				conflictstr = string.sub(conflictstr,1,-3)
				str3 = ScriptGlobal_Format("#{TalentMP_20210804_81}",conflictstr)
			else
				str3 = ""
			end


			local strlist = {str1,str2,str3}
			local textUI = 1
			for i=1,3 do
				levelrequire[i]:SetText("")
				if(string.len(strlist[i]) > 0) then
					levelrequire[textUI]:SetText(strlist[i])
					textUI = textUI+1
				end
			end



			local strneed = ""
			local leftpoint = DataPool:Lua_GetSectPoint()
			if leftpoint >= needpt then
				strneed = "#G"..needpt
			else
				strneed = "#cff0000"..needpt
			end

			Talent_Studyup_Skillup_Need:SetText(ScriptGlobal_Format("#{TalentMP_20210804_26}",strneed))
			Talent_Studyup_SetLeftpoint(leftpoint)

		




	end
end


function Talent_Studyup_Skillup_Up_Clicked()
	--升级流派
	Player:Lua_AskSectOper(0,g_Talent_Studyup_saveid)

end


function Talent_Studyup_SkillTree_UpPage_Clicked()

end

function Talent_Studyup_SkillTree_DownPage_Clicked()

end

function Talent_Studyup_MaskHide(mask)
	mask:SetProperty("Image","set:Talent image:Talent_HoverBK")
end

function Talent_Studyup_MaskShow(mask)
	mask:SetProperty("Image","set:Talent image:Talent_DisBK")
end

function Talent_Studyup_SetFenYe(page)
	local fenyetable = {Talent_Studyup_SkillTree_Advance,Talent_Studyup_SkillTree_Advance2,Talent_Studyup_SkillTree_Advance3,Talent_Studyup_SkillTree_Advance4}
	for i , v in ipairs(fenyetable) do
		if i == page then
			v:SetCheck(1)
		else
			v:SetCheck(0)
		end
	end
end
function Talent_Studyup_ChangeFenye(page,bInit)

	local errorfuc = function(page,bInit)
		local bComplete = DataPool:Lua_IsMissionComplete(g_Talent_Studyup_ButtonMis[page].id)
		if bComplete ~= 1 then
			if bInit == nil or bInit ~= 1 then		
					PushDebugMessage(g_Talent_Studyup_ButtonMis[page].msg)
			end
			return 1
		end
		return 0
	end

	if (g_Talent_Studyup_ButtonMis[page] ~= nil )then
		if errorfuc(page,bInit) == 1 then
			page = g_Talent_Studyup_curFenye
		end
	end
	
	Talent_Studyup_SetFenYe(page)
	Talent_Studyup_MakeSubSchema(page)
	g_Talent_Studyup_curFenye = page

	Talent_Studyup_Update()
end
