-- PR #1 regressions: optional class APIs, localization, scaled square maps and collectors.
local A=AzerothCursor
local function click(b) this=b;b.scripts.OnClick() end
assert(table.getn(A.panel.classButtons)==9)
assert(A.panel.classButtons[1].class=="WARRIOR") -- Missing UnitClass/RAID_CLASS_COLORS is safe.
local labels={fr={HUNTER="Chasseur",PRIEST="Prêtre"},en={HUNTER="Hunter",PRIEST="Priest"}}
for _,token in ipairs(A.classOrder) do
 UnitClass=function() return "Localized name",token end
 A.RefreshOptions();assert(A.panel.classButtons[1].class==token)
 local seen={}
 for _,b in ipairs(A.panel.classButtons) do
  assert(not seen[b.class]);seen[b.class]=true
  A.db.enabled=false;click(b)
  assert(A.db.enabled);local r,g,blue=A.ClassColor(b.class)
  near(A.db.rgb[1],r);near(A.db.rgb[2],g);near(A.db.rgb[3],blue)
 end
 assert(table.getn(A.panel.classButtons)==9)
end
UnitClass=function() return "Chasseur" end
assert(A.PlayerClass()=="HUNTER")
for lang,words in pairs(labels) do
 A.db.language=lang;A.RefreshOptions()
 for _,b in ipairs(A.panel.classButtons) do
  if words[b.class] then assert(b.text:GetText()==words[b.class]) end
 end
end
RAID_CLASS_COLORS={HUNTER={r=.1,g=.2,b=.3}}
local r,g,b=A.ClassColor("HUNTER");near(r,.1);near(g,.2);near(b,.3)
RAID_CLASS_COLORS.HUNTER={r=0/0,g="invalid",b=99}
r,g,b=A.ClassColor("HUNTER");near(r,.67);near(g,.83);near(b,.45)
UnitClass=function() error("not ready") end;assert(not A.PlayerClass())
UnitClass=nil;RAID_CLASS_COLORS=nil
-- Both the Keijin integration and the generic shape API are optional and guarded.
KeijinUI={MinimapStyled=true};assert(not A.SquareMinimap())
KeijinUI={MinimapStyled=function() error("not ready") end}
GetMinimapShape=function() return "SQUARE" end;assert(A.SquareMinimap())
GetMinimapShape=function() error("not ready") end;assert(not A.SquareMinimap())
KeijinUI={MinimapStyled=function() return true end};assert(A.SquareMinimap())
for _,dims in ipairs({{140,140},{240,140},{100,280}}) do
 local w,h=unpack(dims)
 for angle=0,359,7 do
  local x,y=A.MinimapOffset(angle,w,h,true)
  near(math.max(math.abs(x)/(w/2+17),math.abs(y)/(h/2+17)),1)
  assert(math.abs(x)>=w/2+16.9 or math.abs(y)>=h/2+16.9)
 end
end
assert(not A.MinimapOffset(0,0,140,true))
local m=A.minimap
UIParent:SetScale(.75);Minimap:SetScale(.8)
Minimap:ClearAllPoints();Minimap:SetPoint("CENTER",UIParent,"CENTER",150,-50)
Minimap:SetWidth(240);Minimap:SetHeight(140)
A.db.minimapAngle=45;m.Place()
local point=m.points[1];local ex,ey=A.MinimapOffset(45,240,140,true)
near(point[4],ex);near(point[5],ey)
-- Drag at arbitrary UI scale, reload DB, and re-enter world: saved angle survives.
GetCursorPosition=function()
 local x,y=Minimap:GetCenter();local scale=Minimap:GetEffectiveScale()
 return (x+60)*scale,(y-60)*scale
end
m.scripts.OnDragStart();m.Drag();m.scripts.OnDragStop();near(A.db.minimapAngle,315)
A.InitDB();m.scripts.OnEvent();near(A.db.minimapAngle,315)
point=m.points[1];ex,ey=A.MinimapOffset(315,240,140,true);near(point[4],ex);near(point[5],ey)
local saved=A.db.minimapAngle
GetCursorPosition=function() return nil,nil end;m.Drag();near(A.db.minimapAngle,saved)
GetCursorPosition=function() return 0,0 end
Minimap:SetScale(0);m.Drag();near(A.db.minimapAngle,saved);Minimap:SetScale(.8)
-- A shape or size change after world entry is detected without continuous anchoring.
KeijinUI=nil;GetMinimapShape=nil;arg1=.5;m.scripts.OnUpdate()
point=m.points[1];ex,ey=A.MinimapOffset(315,240,140,false);near(point[4],ex);near(point[5],ey)
GetMinimapShape=function() return "SQUARE" end;Minimap:SetWidth(200);m.scripts.OnUpdate()
point=m.points[1];ex,ey=A.MinimapOffset(315,200,140,true);near(point[4],ex);near(point[5],ey)
local writesBefore=writes;m.scripts.OnUpdate();assert(writesBefore==writes)
-- Button collectors keep ownership; no forced reanchoring inside a drawer.
local drawer=CreateFrame("Frame",nil,UIParent);m:SetParent(drawer)
m:ClearAllPoints();m:SetPoint("CENTER",drawer,"CENTER",7,8)
arg1=.5;m.scripts.OnUpdate();m.scripts.OnEvent();assert(m.points[1][2]==drawer)
m:SetParent(Minimap);m.scripts.OnUpdate();assert(m.points[1][2]==Minimap)
A.db.minimapAngle=45;A.InitDB();assert(A.db.minimapAngle==45)
-- Expanded panel stays within a smaller viewport.
if A.panel:IsShown() then A.ToggleOptions() end
UIParent:SetWidth(640);UIParent:SetHeight(480);A.ToggleOptions()
assert(A.panel:GetHeight()*A.panel:GetScale()<=456)
print("PR #1: nine class colors, FR/EN, square/round/rectangular maps, persistence and collector compatibility OK")
