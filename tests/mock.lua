-- Geometry-aware legacy FrameXML mock. No game files or saved games are touched.
NOW=100;objects={};SlashCmdList={};UISpecialFrames={};messages={};writes=0
local M={}
local function invoke(f,script,a)
 local prevThis,prevArg=this,arg1;this=f;arg1=a
 if f.scripts[script] then f.scripts[script]() end
 this=prevThis;arg1=prevArg
end
function M:GetName() return self.name end
function M:GetObjectType() return self.kind end
function M:GetParent() return self.parent end
function M:SetParent(p) self.parent=p end
function M:SetScript(k,f) self.scripts[k]=f end
function M:GetScript(k) return self.scripts[k] end
function M:RegisterEvent(k) self.events[k]=true end
function M:GetWidth() return self.width or 100 end
function M:GetHeight() return self.height or 30 end
function M:SetWidth(n) self.width=n end
function M:SetHeight(n) self.height=n end
function M:GetScale() return self.scale or 1 end
function M:SetScale(n) self.scale=n;writes=writes+1 end
function M:GetEffectiveScale() return self:GetScale()*(self.parent and self.parent:GetEffectiveScale() or 1) end
function M:GetNumPoints() return table.getn(self.points) end
function M:GetPoint(i) if self.points[i or 1] then return unpack(self.points[i or 1]) end end
function M:SetPoint(p,rel,rp,x,y)
 if type(rel)=="string" then rel=getglobal(rel) end
 table.insert(self.points,{p,rel,rp,x or 0,y or 0});writes=writes+1
end
function M:ClearAllPoints() self.points={} end
function M:GetCenter()
 if self==UIParent then return self:GetWidth()/2,self:GetHeight()/2 end
 if self.noGeometry then return nil end
 local point=self.points[1]
 if not point then return self.cx or 0,self.cy or 0 end
 local rel=point[2] or self.parent or UIParent
 local rx,ry=rel:GetCenter();if not rx then return nil end
 local factors={CENTER={0,0},TOPLEFT={-.5,.5},TOPRIGHT={.5,.5},BOTTOMLEFT={-.5,-.5},BOTTOMRIGHT={.5,-.5},LEFT={-.5,0},RIGHT={.5,0},TOP={0,.5},BOTTOM={0,-.5}}
 local a=factors[point[1]] or factors.CENTER;local b=factors[point[3]] or factors.CENTER
 local ratio=rel:GetEffectiveScale()/self:GetEffectiveScale()
 return (rx+b[1]*rel:GetWidth())*ratio+point[4]-a[1]*self:GetWidth(),(ry+b[2]*rel:GetHeight())*ratio+point[5]-a[2]*self:GetHeight()
end
function M:Show() local old=self.shown;self.shown=true;if not old then invoke(self,"OnShow") end end
function M:Hide() local old=self.shown;self.shown=false;if old then invoke(self,"OnHide") end end
function M:IsShown() return self.shown end
function M:IsVisible() return self.shown and (not self.parent or self.parent:IsVisible()) end
function M:SetText(s) local changed=self.text~=s;self.text=s;if changed then invoke(self,"OnTextChanged") end end
function M:GetText() return self.text or "" end
function M:SetFont(path,size) self.font=path;self.fontSize=size;return true end
function M:GetStringWidth() return string.len(self:GetText())*(self.fontSize or 12)*.5 end
function M:Enable() self.enabled=true end
function M:Disable() self.enabled=false end
function M:StartMoving() self.moving=true end
function M:StopMovingOrSizing() self.moving=false end
function M:SetFocus() self.focus=true end
function M:ClearFocus() self.focus=false end
function M:ClearLines() end
for _,k in ipairs({"SetBackdrop","SetBackdropColor","SetBackdropBorderColor","SetHighlightTexture","SetPointDummy","SetTextColor","SetJustifyH","SetJustifyV","SetTextInsets","SetAutoFocus","SetMaxLetters","SetFrameStrata","SetFrameLevel","EnableMouse","SetMovable","SetClampedToScreen","RegisterForDrag","RegisterForClicks","SetOwner"}) do M[k]=function() end end
function CreateFrame(kind,name,parent,template)
 local f=setmetatable({kind=kind,name=name,parent=parent,scripts={},events={},points={},shown=true,template=template},{__index=M})
 if name then _G[name]=f end
 table.insert(objects,f);return f
end
function M:CreateFontString(name) return CreateFrame("FontString",name,self) end
function getglobal(name) return _G[name] end
UIParent=CreateFrame("Frame","UIParent");UIParent.width=1920;UIParent.height=1080;UIParent.cx=960;UIParent.cy=540
WorldFrame=CreateFrame("Frame","WorldFrame",UIParent)
DEFAULT_CHAT_FRAME={AddMessage=function(self,text) table.insert(messages,text) end}
function GetTime() return NOW end
function GetLocale() return "enUS" end
function near(a,b) assert(math.abs(a-b)<.00001,tostring(a).." != "..tostring(b)) end
for _,name in ipairs({"SetCVar","SendChatMessage","SendAddonMessage","CastSpellByName","PickupAction","PlaceAction","ReloadUI"}) do
 _G[name]=function() error("Unexpected game/network write: "..name) end
end
