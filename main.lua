_G.love = require("love")
local misc = require("misc")
local gamePro = require("gameProps")
local obj = require("objects")

_G.Logtest = ""
_G.pointVec = misc.vec2.new(0, 0)
local BG = misc.color.new(0, 0, 0, 1)
--Main player 2 platform
local main_color = misc.color.new(255, 0, 50, 1)
local main_rect = misc.rect.new(0, 0, 500, 300)
local main_platform = obj.basic.new(main_rect, main_color)

--Player 2
local player_img
local player_color2 = misc.color.new(0, 255, 0, 1)
local player_rect2 = misc.rect.new(870, 60, 30, 40)
local player_vel = misc.vec2.new(0, 0)
local player_obj2 = obj.player.new(player_rect2, player_color2, player_vel)

function love.load()
    player_img = love.graphics.newImage(gamePro.player2ImgPath[1])
end

function love.update(dt)
    --Center the main platform
    main_rect.x = (love.graphics.getWidth()-main_rect.width) / 2
    main_rect.y = (love.graphics.getHeight()-main_rect.height-100)
    gamePro.hasStarted = true
    -- Collision and Velocity
    player_obj2:UpdateVelocity(dt)
    player_obj2:SeparateFromBasic(main_platform)

    local walkSpeed = gamePro.walkSpeed
    if love.keyboard.isDown("a") then
        player_obj2:Move(-walkSpeed)
        gamePro.lookState = 1
    elseif love.keyboard.isDown("d") then
        player_obj2:Move(walkSpeed)
        gamePro.lookState = 0
    end
end
function love.draw()
    love.graphics.setBackgroundColor(BG:GetValue())
    love.graphics.setColor(0, 0, 1, 1)

    -- Game elements
    main_platform:Display()
    player_obj2:Display(player_img)

    --Test point
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.circle("fill", pointVec.x, pointVec.y, 4)

    love.graphics.print(Logtest, 20, 20, 0, 3, 3)
end

function love.keypressed(key)
    if key == "escape" then
         love.event.quit()
    end

    if key == "space" and gamePro.jumpCount < gamePro.jumpCountMax then
        player_obj2:Move(0, -gamePro.jumpVelocity)
        gamePro.jumpCount = gamePro.jumpCount + 1
    end

    Logtest = key
end


