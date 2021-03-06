-- Math
function math.lerp(x1, x2, z) return x1 + (x2 - x1) * z end
function math.anglerp(d1, d2, z) return d1 + (angleDiff(d1, d2) * z) end
function math.distance(x1, y1, x2, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ .5 end
function math.direction(x1, y1, x2, y2) return -math.atan2(x2 - x1, y2 - y1) end
function math.inside(px, py, rx, ry, rw, rh) return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh end
function math.anglediff(d1, d2) return math.rad((((math.deg(d2) - math.deg(d1) % 360) + 540) % 360) - 180) end
function math.hcora(cx, cy, cr, rx, ry, rw, rh) -- Hot circle on rectangle action.
  local hw, hh = rw / 2, rh / 2
  local cdx, cdy = math.abs(cx - (rx + hw)), math.abs(cy - (ry + hh))
  if cdx > hw + cr or cdy > hh + cr then return false end
  if cdx <= hw or cdy <= hh then return true end
  return (cdx - hw) ^ 2 + (cdy - hh) ^ 2 <= (cr ^ 2)
end
function math.hloca(x1, y1, x2, y2, cx, cy, cr) -- Hot line on circle action.
  local dx, dy = (x2 - x1), (y2 - y1)
  local a2 = math.abs(dx * (cy - y1) - dy * (cx - x1))
  local l = (dx * dx + dy * dy) ^ .5
  local h = a2 / l
  if not (h < cr) then return false end
  local t = (dx / l) * (cx - x1) + (dy / l) * (cy - y1)
  if t < 0 then return false end
  return l > t - ((cr ^ 2 - h ^ 2) ^ .5)
end

-- Table
function table.eq(t1, t2)
  if type(t1) ~= type(t2) then return false end
  if type(t1) ~= 'table' then return t1 == t2 end
  if #t1 ~= #t2 then return false end
  for k, _ in pairs(t1) do
    if not table.eq(t1[k], t2[k]) then return false end
  end
  return true
end

function table.copy(x)
  local t = type(x)
  if t ~= 'table' then return x end
  local y = {}
  for k, v in next, x, nil do y[k] = table.copy(v) end
  setmetatable(y, getmetatable(x))
  return y
end

function table.has(t, x, deep)
  local f = deep and table.eq or rawequal
  for _, v in pairs(t) do if f(v, x) then return true end end
  return false
end

function table.only(t, ks)
  local res = {}
  for _, k in pairs(ks) do res[k] = t[k] end
  return res
end

function table.except(t, ks)
  local res = table.copy(t)
  for _, k in pairs(ks) do res[k] = nil end
  return res
end

function table.with(t, f)
  if not t then return end
  for k, v in pairs(t) do f(v, k) end
end

function table.iwith(t, f)
  if not t then return end
  for k, v in ipairs(t) do f(v, k) end
end

function table.map(t, f)
  if not t then return end
  local res = {}
  table.with(t, function(v, k) res[k] = f(v, k) end)
  return res
end

function table.filter(t, f)
  return table.map(t, function(v, k) return f(v, k) and v or nil end)
end

function table.clear(t, v)
  table.with(t, function(_, k) t[k] = v end)
end

function table.merge(t1, t2)
  t2 = t2 or {}
  for k, v in pairs(t1) do t2[k] = v end
  return t2
end 

function table.deltas(t1, t2)
  if not t1 or not t2 then return t2 end
  return table.filter(t2, function(v, k) return v ~= t1[k] end)
end

function table.print(t, n)
  n = n or 0
  if t == nil then print('nil') end
  if type(t) ~= 'table' then io.write(tostring(t)) io.write('\n')
  else
    for k, v in pairs(t) do
      io.write(string.rep('\t', n))
      io.write(k)
      if type(v) == 'table' then io.write('\n')
      else io.write('\t') end
      table.print(v, n + 1)
    end
  end
end

-- Byte
byte = {}
function byte.pack(...)
  local x = 0
  for i = 1, #arg do
    if arg[i] > 0 then x = x + (2 ^ (i - 1)) end
  end
  return x
end

function byte.unpack(x)
  local t = {}
  while x > 0 do
    table.insert(t, x % 2)
    x = math.floor(x / 2)
  end
  return t
end

function byte.extract(x, a, b)
  b = b or a
  x = x % (2 ^ (b + 1))
  for i = 1, a do
    x = math.floor(x / 2)
  end
  return x
end

function byte.insert(x, y, a, b)
  local res = x
  for i = a, b do
    res = (byte.extract(y, i - a) == byte.extract(x, i)) and res or (byte.extract(y, i - a) == 1 and res + (2 ^ i) or res - (2 ^ i))
  end
  return res
end

function byte.explode(x, l)
  local res = {}
  for i = 0, l - 1 do
    res[i + 1] = byte.extract(x, i)
  end
  return unpack(res)
end

-- Functions
f = {}
f.empty = function() end
f.id = function(x) return x end
f.inc = function(x) return x + 1 end
f.dec = function(x) return x - 1 end
f.fst = f.id
f.snd = function(...) return arg[2] end
f.lst = function(...) return arg[#arg] end
f.dbl = function(x) return x, x end
f.exe = function(x, ...) if x then x(...) end end
f.ego = function(f) return function(x, ...) x[f](x, ...) end end

-- Timing
timer = {}
timer.start = function() _t1 = love.timer.getMicroTime() end
timer.delta = function() return love.timer.getMicroTime() - _t1 end
timer.rot = function(val, f) assert(val) if val == 0 then return 0 end if val < tickRate then f() return 0 end return val - tickRate end

-- String
string.capitalize = function(s) s = ' ' .. s return s:gsub('(%s%l)', string.upper) end

-- Graphics
graphics = {}
graphics.reset = function()
  love.graphics.setColor(255, 255, 255, 255)
end