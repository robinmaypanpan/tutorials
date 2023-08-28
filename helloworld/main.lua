local class = require('../lib/middleclass')

local Test = class('Test')

Test.static.num2 = love.math.random(200,400)

function Test:initialize()
    self.num = love.math.random(200)
end

-- This is called once on application startup. Techincally not necessary,
-- but it can feel good to use.
function love.load()
    x = 400
    y = 300
    test = Test:new()
end

-- Called before calling draw each time a frame updates
function love.update()
    if not love.mouse.isDown(1) then
        x, y = love.mouse.getPosition()
    end
end

-- Called after calling update each frame.
function love.draw()
    love.graphics.print("Hello World", x, y)
    love.graphics.print("Number is " .. test.num)
    love.graphics.print("Number 2 is " .. test.num2, 0,30)
end
