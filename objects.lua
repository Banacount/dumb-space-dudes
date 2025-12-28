local mc = require("misc")
local gamePro = require("gameProps")

local objects = {}
-- Basic object methods 
---@class basicObj 
---@field Rect Rectangle
---@field Color Color
objects.basic = {}
objects.basic.__index = objects.basic
---@param rect Rectangle @param color Color
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
function objects.player:Display(player_img)
    -- Code snippet below is the hitbox
    --love.graphics.setColor(self.Color:GetValue())
    --love.graphics.rectangle("fill", self.Rect.x, self.Rect.y, self.Rect.width, self.Rect.height)

    local plRect = self.Rect
    local plImgScale = 0.74
    love.graphics.setColor(1, 1, 1)
    local perc = self.Velocity.x / gamePro.walkSpeed
    local imgOrient = 0.21 * perc
    local imgP = mc.vec2.new(0, 0)
    -- Walking to right
    if gamePro.lookState == 0 then
        imgP.x = plRect.x-1
        imgP.y = plRect.y-3
        local xper = 6 * perc
        local yper = -2 * perc
        love.graphics.draw(player_img, imgP.x+xper, imgP.y+yper, imgOrient, plImgScale, plImgScale)
    -- Walking to left
    elseif gamePro.lookState == 1 then
        imgP.x = plRect.x+30.08-1
        imgP.y = plRect.y-3
        local xper = 3 * perc
        local yper = 2 * perc
        love.graphics.draw(player_img, imgP.x+xper, imgP.y+yper, imgOrient, -plImgScale, plImgScale)
    end
    --[[ Not walking for a while
    elseif gamePro.lookState == 3 then
    end]]
end
--Update velocity
---@param deltatime number
function objects.player:UpdateVelocity(deltatime)
    self.Rect.x = self.Rect.x + (deltatime * self.Velocity.x)
    self.Rect.y = self.Rect.y + (deltatime * self.Velocity.y)
    --Gravity frfr
    self.Velocity.y = self.Velocity.y + gamePro.gravity
    --Player friction
    self.Velocity.x = self.Velocity.x * gamePro.walkFriction
end

--Move player
local hasMovement = true
---@param x number|nil
---@param y number|nil
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
        local distY = (self.Rect.y+self.Rect.height) - basic.Rect.y
        self.Velocity.y = 0
        self.Rect.y = self.Rect.y - distY
    end
end

---@param basic basicObj
function objects.player:SeparateFromBasic(basic)
    local basic_center = mc.vec2.new(basic.Rect.x + (basic.Rect.width / 2), basic.Rect.y + (basic.Rect.height / 2))
    local self_center = mc.vec2.new(self.Rect.x + (self.Rect.width/2), self.Rect.y + (self.Rect.height/2))
    --X calc
    --Y calc

    if not self.Rect:IsCollide(basic.Rect) and gamePro.hasStarted then return end
    --local Ybias = 10
    local overLapX = (basic.Rect.width/2 - self.Rect.width/2) - math.abs(basic_center.x - self_center.x)
    local overLapY = (basic.Rect.height/2 - self.Rect.height/2) - math.abs(basic_center.y - self_center.y)
    if overLapX < overLapY then
        if  self_center.x < basic_center.x then
            Logtest = "What Right"
            self.Rect.x = self.Rect.x - (overLapX+self.Rect.width)
        else
            Logtest = "What Left"
            self.Rect.x = self.Rect.x + (overLapX+self.Rect.width)
        end
    else
        if self_center.y < basic_center.y then
            Logtest = "What Up"
            gamePro.jumpCount = 0
            self.Rect.y = self.Rect.y - (overLapY+self.Rect.height)
            if self.Velocity.y > 0 then self.Velocity.y = 0 end
        else
            Logtest = "What Down"
            self.Rect.y = self.Rect.y + (overLapY+self.Rect.height)
            if self.Velocity.y < 0 then self.Velocity.y = 0 end
        end
    end
end


return objects
