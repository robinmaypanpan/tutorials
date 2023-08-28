local SnakeSegment = require('snake-segment')

-- This is called once on application startup. Techincally not necessary,
-- but it can feel good to use.
function love.load()
    snake = SnakeSegment:new(128,128)
    score = 0
end

-- Callback function for keypresses from the love system
function love.keypressed(key, scancode, isrepeat)
    if scancode == "d" or key == "right" then    -- move right
        snake:setDirection('right')
    elseif scancode == "a" or key == "left" then -- move left
        snake:setDirection('left')
    elseif scancode == "s" or key == "down" then -- move down
        snake:setDirection('down')
    elseif scancode == "w" or key == "up" then   -- move up
        snake:setDirection('up')
    end
end

-- Callback function for the update method. Called every frame to update things
function love.update()
    snake:update()
end

-- Love callback function for the draw method.  Called every frame to draw things
function love.draw()
    snake:draw()
    love.graphics.print("Score :" .. score, 0, 0)
end

-- Tasks
-- 1) Create an apple at a random location!
-- 2) When the snake collides with the apple, score a point and place another apple
-- 3) When you eat an apple, add another segment to the snake that follows the first segment,
-- and raise the score
-- 4) Create a reverse apple. This new apple should reverse the snake entirely, with its tail becoming the new head.
-- 5) 