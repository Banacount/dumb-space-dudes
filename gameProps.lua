local gameProperties = {
    gravity = 16, -- 7
    hasStarted = false,
    timeCaptures = {},
    --Player 2 variables (Asteroid dodger)
    jumpCountMax = 3,
    jumpCount = 0,
    jumpVelocity = 430,
    walkSpeed = 160,
    walkFriction = 0.9,
    lookState = 1,
    --Player 1 variables (Asteroid user)
    asteroidPower = 2,
    throwDelay = 0.7
}

gameProperties.player2ImgPath = {
    'ass/img/player2_main.png'
}

gameProperties.platformImgPath = {
    'ass/img/main_platform1.png'
}

return gameProperties
