_G.love = require("love")
local misc = require("misc")
local gamePro = require("gameProps")
local obj = require("objects")

_G.Logtest = ""
_G.pointVec = misc.vec2.new(0, 0)
_G.astePowerLine = {misc.vec2.new(0, 0), misc.vec2.new(0, 0)}
local BG = misc.color.new(0, 0, 0, 1)
local mouseRecent = 0

--Main player 2 platform
local platform_img
local main_color = misc.color.new(255, 103, 62, 1)
local main_rect = misc.rect.new(0, 0, 500, 300)
local main_platform = obj.basic.new(main_rect, main_color)

--Player 2
local player_img
local player_color2 = misc.color.new(0, 255, 0, 1)
local player_rect2 = misc.rect.new(870, 60, 30, 40)
local player_vel = misc.vec2.new(0, 0)
local player_obj2 = obj.player.new(player_rect2, player_color2, player_vel)

--Asteroid default properties
local aste_color = misc.color.new(0, 32, 255, 1)
local aste_rect = misc.rect.new(0, 0, 40, 40)
local aste_vel = misc.vec2.new(0, 0)
local asteroids = {}

function love.load()
    player_img = love.graphics.newImage(gamePro.player2ImgPath[1])
    platform_img = love.graphics.newImage(gamePro.platformImgPath[1])
end

function love.update(dt)
    --Center the main platform
    main_rect.x = (love.graphics.getWidth()-main_rect.width) / 2
    main_rect.y = (love.graphics.getHeight()-main_rect.height)
    gamePro.hasStarted = true -- Collision and Velocity
    player_obj2:UpdateVelocity(dt)
    player_obj2:SeparateFromBasic(main_platform)
    -- Asteroids collisions and velocity
    for n,aste in ipairs(asteroids) do
        aste:UpdateVelocity(dt)

        if  aste.Rect.x > love.graphics.getWidth()+aste.Rect.width or
            aste.Rect.y > love.graphics.getHeight()+aste.Rect.height or
            aste.Rect.x+aste.Rect.width < 0 or aste.Rect.y+aste.Rect.height < 0 then
            table.remove(asteroids, n)
            print("Removed: ", n)
        end

        if player_obj2.Rect:IsCollide(aste.Rect) then
            player_obj2.Velocity.x = aste.Velocity.x
            player_obj2.Velocity.y = aste.Velocity.y
            table.remove(asteroids, n)
        end
    end

    -- A - D Movement of player 2(the robot thingy)
    local walkSpeed = gamePro.walkSpeed * 10
    if love.keyboard.isDown("a") then
        if math.abs(player_obj2.Velocity.x) < walkSpeed then
            player_obj2.Velocity.x = player_obj2.Velocity.x - (dt * walkSpeed)
        end
        gamePro.lookState = 1
    elseif love.keyboard.isDown("d") then
        if math.abs(player_obj2.Velocity.x) < walkSpeed then
            player_obj2.Velocity.x = player_obj2.Velocity.x + (dt * walkSpeed)
        end
        gamePro.lookState = 0
    end

    -- Throwing asteroids frfr
    local cursorPos = {x = love.mouse.getX(), y = love.mouse.getY()}
    if love.mouse.isDown(1) then
        if mouseRecent == 0 then
            astePowerLine[1].x = cursorPos.x
            astePowerLine[1].y = cursorPos.y
        end
        astePowerLine[2].x = cursorPos.x
        astePowerLine[2].y = cursorPos.y
        mouseRecent = 1
    -- Detect mouse up
    elseif mouseRecent == 1 then
        mouseRecent = 0
        local xLinePower = (astePowerLine[2].x - astePowerLine[1].x) * gamePro.asteroidPower
        local yLinePower = (astePowerLine[2].y - astePowerLine[1].y) * gamePro.asteroidPower
        local validPower = 20
        Logtest = "Shot velocity: "..xLinePower..", "..yLinePower
        local isPowerValid = (math.abs(astePowerLine[1].x-astePowerLine[2].x) > validPower or
                              math.abs(astePowerLine[1].y-astePowerLine[2].y) > validPower)

        if isPowerValid then
            local newRect = misc.rect.new(astePowerLine[1].x - (aste_rect.width / 2), astePowerLine[1].y - (aste_rect.height / 2), aste_rect.width, aste_rect.height)
            local newVel = misc.vec2.new(xLinePower, yLinePower)
            local aste = obj.movable.new(newRect, newVel, aste_color)
            table.insert(asteroids, aste)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(BG:GetValue())
    love.graphics.setColor(0, 0, 1, 1)
    misc.StarsBG()

    -- Game elements
    main_platform:Display(platform_img)
    player_obj2:Display(player_img)
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setLineWidth(5)
    love.graphics.line(astePowerLine[1].x, astePowerLine[1].y, astePowerLine[2].x, astePowerLine[2].y)
    for n,aste in ipairs(asteroids) do
        aste:Display()
    end

    --Test display shits
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.circle("fill", pointVec.x, pointVec.y, 4)
    love.graphics.print(Logtest, 20, 20, 0, 3, 3)
end

function love.keypressed(key)
    if key == "escape" then
         love.event.quit()
    end

    if key == "space" and gamePro.jumpCount < gamePro.jumpCountMax then
        player_obj2:Move(nil, -gamePro.jumpVelocity)
        gamePro.jumpCount = gamePro.jumpCount + 1
    end

    Logtest = key
end


