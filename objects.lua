local mc = require("misc")
local gamePro = require("gameProps")

local objects = {}

-- Basic object methods 
---@class basicObj 
---@field Rect Rectangle
---@field Color Color
objects.basic = {}
objects.basic.__index = objects.basic

---@param rect Rectangle
---@param color Color
function objects.basic.new(rect, color)
    local obj = setmetatable({}, objects.basic)

    obj.Rect = rect or mc.rect.new(0, 0, 10, 10)
    obj.Color = color or mc.color.new(0, 0, 0, 0)
    return obj
end

function objects.basic:Display()
    love.graphics.setColor(self.Color:GetValue())
    love.graphics.rectangle("fill", self.Rect.x, self.Rect.y, self.Rect.width, self.Rect.height)
end


-- Player object methods
---@class playerObj
---@field Rect Rectangle
---@field Color Color 
---@field Velocity Vec2 
objects.player = {}
objects.player.__index = objects.player

---@param rect Rectangle
---@param color Color
---@param velocity Vec2
function objects.player.new(rect, color, velocity)
    local obj = setmetatable({}, objects.player)
    obj.Rect = rect
    obj.Color = color
    obj.Velocity = velocity
    return obj
end
--Display playerObj
function objects.player:Display()
    love.graphics.setColor(self.Color:GetValue())
    love.graphics.rectangle("fill", self.Rect.x, self.Rect.y, self.Rect.width, self.Rect.height)
end
--Update velocity
---@param deltatime number
function objects.player:UpdateVelocity(deltatime)
    self.Rect.x = self.Rect.x + (deltatime * self.Velocity.x)
    self.Rect.y = self.Rect.y + (deltatime * self.Velocity.y)
    --Gravity frfr
    self.Velocity.y = self.Velocity.y + gamePro.gravity
    --Player friction
    local playerFriction = 0.3
    self.Velocity.x = self.Velocity.x * playerFriction
end

--Move player
local hasMovement = true
---@param x number
---@param y number
function objects.player:Move(x, y)
    if hasMovement then
        self.Velocity.x = x or self.Velocity.x
        self.Velocity.y = y or self.Velocity.y
    end
end

--Collide methods
---@param basic basicObj
function objects.player:SeparateCollisionBasic(basic)
    local basic_center = mc.vec2.new(basic.Rect.width / 2, basic.Rect.height / 2)
    --X calc
    --Y calc
    local Ytotal = self.Rect.y + self.Rect.height
    local YtotalOther = basic.Rect.y
    local col_distY = Ytotal - YtotalOther

    if not self.Rect:IsCollide(basic.Rect) and gamePro.hasStarted then return end
    if col_distY > 0 then
        self.Velocity.y = 0
    end
end

---@param basic basicObj
function objects.player:SeparateCollisionTest(basic)
    local basic_center = mc.vec2.new(basic.Rect.x + basic.Rect.width / 2, basic.Rect.x + basic.Rect.height / 2)
    --X calc
    --Y calc

    if not self.Rect:IsCollide(basic.Rect) and gamePro.hasStarted then return end
    --self.Rect.y = self.Rect.y - 3
    local yStep = 7
    local isFocusOnY = ((self.Rect.y - yStep) + self.Rect.height <= basic.Rect.y or
                       (self.Rect.y - yStep) >= basic.Rect.y + basic.Rect.height)
    if self.Rect.x < basic_center.x and not isFocusOnY then
        Logtest = "What Left"
        self.Velocity.x = 0
        local distX = (self.Rect.x+self.Rect.width) - basic.Rect.x
        self.Rect.x = self.Rect.x - math.abs(distX+1)
    elseif self.Rect.x > basic_center.x and not isFocusOnY then
        Logtest = "What Right"
        self.Velocity.x = 0
        local distX = self.Rect.x - (basic.Rect.x + basic.Rect.width)
        self.Rect.x = self.Rect.x + math.abs(distX+1)
    elseif isFocusOnY and self.Rect.y < basic_center.x then
        Logtest = "What Up"
        self.Velocity.y = 0
        local distY = (self.Rect.y+self.Rect.height) - basic.Rect.y
        self.Rect.y = self.Rect.y - math.abs(distY+1)
    end
end


return objects
