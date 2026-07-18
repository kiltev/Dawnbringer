-- add this as the 19th perk entry; this is the spawner script injection:

-------------------------- THE RIMEARC SPAWNER SCRIPT -------------------------------------------------------------
  [19]={ (function()
      local URL = "https://raw.githubusercontent.com/kiltev/zephyr/main/scripts/rimearc_spawner.lua"
      Wait.time(function() WebRequest.get(URL, function(r)
          if r.text and not r.is_error then self.setLuaScript(r.text); self.reload() end
      end) end, 0.5)
      return "Active"
  end)() },
},