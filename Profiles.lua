-- Cursor Studio V2: bounded, local SavedVariables profiles (Lua 5.0).
local A=AzerothCursor
local fields={"enabled","size","thickness","opacity","halo","crosshair","dot","iconSize","pulse","classIcon","color","rgb","classIconToken"}
local function CopyAppearance(source)
 local out={}
 for _,key in ipairs(fields) do
  local value=source[key]
  if type(value)=="table" and key=="rgb" then
   out.rgb={value[1],value[2],value[3]}
  elseif type(value)=="number" or type(value)=="boolean" or type(value)=="string" then
   out[key]=value
  end
 end
 return out
end
local function ValidName(name)
 if type(name)~="string" or string.len(name)<1 or string.len(name)>24 then return nil end
 if string.find(name,"[^%w _%-]") then return nil end
 return name
end
function A.ProfileNames()
 local names={}
 local profiles=A.db and A.db.profiles or {}
 if type(profiles)~="table" then return names end
 for name,value in pairs(profiles) do
  if ValidName(name) and type(value)=="table" then table.insert(names,name) end
 end
 table.sort(names)
 return names
end
function A.SaveProfile(name)
 name=ValidName(name)
 if not name then return false end
 local profiles=A.db.profiles
 if type(profiles)~="table" then profiles={};A.db.profiles=profiles end
 if not profiles[name] and table.getn(A.ProfileNames())>=12 then return false end
 profiles[name]=CopyAppearance(A.db)
 return true
end
function A.LoadProfile(name)
 name=ValidName(name)
 if not name or type(A.db.profiles)~="table" then return false end
 local profile=A.db.profiles[name]
 if type(profile)~="table" then return false end
 -- Pass through the same sanitizer as startup without losing the profile library.
 local previous=A.db
 local candidate=CopyAppearance(profile)
 candidate.schema=2
 candidate.language=previous.language
 candidate.minimapAngle=previous.minimapAngle
 candidate.profiles=previous.profiles
 local saved=AzerothCursorDB
 AzerothCursorDB=candidate
 A.InitDB()
 if not A.db then AzerothCursorDB=saved;A.db=previous;return false end
 A.Apply()
 return true
end
function A.DeleteProfile(name)
 name=ValidName(name)
 if not name or type(A.db.profiles)~="table" or not A.db.profiles[name] then return false end
 A.db.profiles[name]=nil
 return true
end

-- Rename without overwriting an existing profile.
function A.RenameProfile(oldName,newName)
 oldName=ValidName(oldName);newName=ValidName(newName)
 if not oldName or not newName or type(A.db.profiles)~="table" then return false end
 if not A.db.profiles[oldName] or A.db.profiles[newName] then return false end
 A.db.profiles[newName]=A.db.profiles[oldName]
 A.db.profiles[oldName]=nil
 return true
end
function A.DuplicateProfile(sourceName,newName)
 sourceName=ValidName(sourceName);newName=ValidName(newName)
 if not sourceName or not newName or type(A.db.profiles)~="table" then return false end
 if type(A.db.profiles[sourceName])~="table" or A.db.profiles[newName] then return false end
 if table.getn(A.ProfileNames())>=12 then return false end
 A.db.profiles[newName]=CopyAppearance(A.db.profiles[sourceName])
 return true
end
