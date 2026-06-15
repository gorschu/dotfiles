local laptop = "eDP-1"
local homeoffice = "Philips Consumer Electronics Company 49B2U6903 AU02421006910"

hl.monitor({ output = "desc:" .. homeoffice, mode = "5120x1440@120Hz", position = "0x0", scale = 1.0, vrr = 1 })
hl.monitor({ output = laptop, mode = "preferred", position = "auto", scale = 1.0 })

-- Disable laptop panel when the ultrawide is connected, re-enable on unplug.
local function is_homeoffice(mon)
  return mon.description:find("49B2U6903", 1, true) ~= nil
end

hl.on("hyprland.start", function()
  for _, mon in ipairs(hl.get_monitors()) do
    if is_homeoffice(mon) then
      hl.exec_cmd("hyprctl keyword monitor " .. laptop .. ",disable")
      return
    end
  end
end)

hl.on("monitor.added", function(mon)
  if is_homeoffice(mon) then
    hl.exec_cmd("hyprctl keyword monitor " .. laptop .. ",disable")
  end
end)

hl.on("monitor.removed", function(mon)
  if is_homeoffice(mon) then
    hl.exec_cmd("hyprctl keyword monitor " .. laptop .. ",preferred,auto,1.2")
  end
end)
