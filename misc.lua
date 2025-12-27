
local misc = {}

--Color stuff
---@class Color
---@field red number
---@field green number
---@field blue number
---@field alpha number
misc.color = {}
misc.color.__index = misc.color

---@return Color
function misc.color:GetValue()
    return {self.red, self.green, self.blue, self.alpha}
end

---@param r number
---@param g number
---@param b number
---@param a number
function misc.color.new(r, g, b, a)
    local ins = setmetatable({}, misc.color)
    ins.red = (r or 255) / 255
    ins.green = (g or 255) / 255
    ins.blue = (b or 255) / 255
    ins.alpha = a or 1
    return ins
end


--Rect stuff
---@class Rectangle
---@field x number
---@field y number
---@field width number
---@field height number
misc.rect = {}
misc.rect.__index = misc.rect

function misc.rect.new(x, y, width, height)
    local ins = setmetatable({}, misc.rect)
    ins.x = x or 0
    ins.y = y or 0
    ins.height = height or 5
    ins.width = width or 5
    return ins
end
--Collide rects
---@param other Rectangle
---@return boolean
function misc.rect:IsCollide(other)
    local rec1 = self
    local rec2 = other
    local isCol = false

    if rec1.x+rec1.width > rec2.x and
       rec2.x+rec2.width > rec1.x and
       rec1.y+rec1.height > rec2.y and
       rec2.y+rec2.height > rec1.y then
        isCol = true
    end

    return isCol
end


-- Vector stuff
---@class Vec2
---@field x number
---@field y number
misc.vec2 = {}
misc.vec2.__index = misc.vec2

function misc.vec2.new(x, y)
    local ins = setmetatable({}, misc.vec2)
    ins.x = x
    ins.y = y
    return ins
end
function misc.vec2:GetValue()
    return {self.x, self.y}
end

return misc
