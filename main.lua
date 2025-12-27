_G.love = require("love")
local misc = require("misc")
local gamePro = require("gameProps")
local obj = require("objects")

_G.Logtest = "test"
local BG = misc.color.new(197, 217, 232, 1)

--Main player 2 platform
local main_color = misc.color.new(255, 0, 50, 1)
local main_rect = misc.rect.new(0, 0, 500, 300)
local main_platform = obj.basic.new(main_rect, main_color)

--Player 2
local player_color2 = misc.color.new(0, 255, 0, 1)
local player_rect2 = misc.rect.new(900, 60, 30, 40)
local player_vel = misc.vec2.new(0, 0)
local player_obj2 = obj.player.new(player_rect2, player_color2, player_vel)

local testcolor = misc.color.new(0, 0, 0, 0)
local testvoid = misc.rect.new(0, 0, 0, 0)
local testvoidObj = obj.basic.new(testvoid, testcolor)


function love.update(dt)
    --Center the main platform
    main_rect.x = (love.graphics.getWidth()-main_rect.width) / 2
    main_rect.y = (love.graphics.getHeight()-main_rect.height)
    gamePro.hasStarted = true

    testvoidObj.Rect.y = love.graphics.getHeight()
    testvoidObj.Rect.width = love.graphics.getWidth()-30
    testvoidObj.Rect.height = 20

    -- Collision and Velocity
    player_obj2:UpdateVelocity(dt)
    player_obj2:SeparateCollisionTest(main_platform)
    player_obj2:SeparateCollisionBasic(testvoidObj)

    local walkSpeed = 130
    if love.keyboard.isDown("a") then
        player_obj2:Move(-walkSpeed)
    elseif love.keyboard.isDown("d") then
        player_obj2:Move(walkSpeed)
    end
end
function love.draw()
    love.graphics.setBackgroundColor(BG:GetValue())
    love.graphics.setColor(0, 0, 1, 1)
    main_platform:Display()
    player_obj2:Display()

    love.graphics.print(Logtest, 20, 20, 0, 3, 3)
end

function love.keypressed(key)
    if key == "escape" then
         love.event.quit()
    end

    if key == "space" then
        player_obj2:Move(nil, 400)
    end

    Logtest = key
end


