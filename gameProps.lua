local gameProperties = {
    gravity = 16, -- 7
    hasStarted = false,
    --Player 2 variables
    jumpCountMax = 3,
    jumpCount = 0,
    jumpVelocity = 330,
    walkSpeed = 160,
    walkFriction = 0.9,
    lookState = 1
}

gameProperties.player2ImgPath = {
    'ass/img/player2_main.png'
}

return gameProperties
