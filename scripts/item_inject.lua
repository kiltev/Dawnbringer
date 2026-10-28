-- add this as the 19th perk entry; this is the item spawner injection:

-------------------------- THE ITEMS SPAWNER SCRIPT -------------------------------------------------------------
[19]={(function()
 local id=self.guid.."h"
 WebRequest.get("https://raw.githubusercontent.com/kiltev/Dawnbringer/main/scripts/items_script.lua",function(r)
  if r.is_error then return end
  local helper=getObjectFromGUID(id)
  if helper then
   helper.setLuaScript(r.text)
   helper.reload()
  else
   spawnObjectData{data={Name="BlockSquare",GUID=id,Locked=true,LuaScript=r.text}}
  end
 end)
end)()},
},
