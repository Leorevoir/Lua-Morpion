--\
-- EPITECH PROJECT, 2024
-- Morpion
-- File description:
-- graphics in LUA using LOVE2D
--/

love = require("love")

local board = {
    {" ", " ", " "},
    {" ", " ", " "},
    {" ", " ", " "}
}

local current_player = "X"
local x_png, o_png

---------------// load game //---------------

function love.load()
    love.window.setTitle("My first LOVE2D game !")
    love.window.setMode(800, 800)
    x_png = love.graphics.newImage("data/x.png")
    o_png = love.graphics.newImage("data/o.png")
end


---------------// draw board //---------------

local function draw_height_lines()
    local x = love.graphics.getWidth() / 3
    local y1 = 0
    local y2 = love.graphics.getHeight()

    for i = 1, 2 do
        love.graphics.line(x, y1, x, y2)
        x = x + love.graphics.getWidth() / 3
    end
    for i = 1, 2 do
        love.graphics.print("-")
        x = x + love.graphics.getWidth() / 3
    end
end


local function draw_width_lines()
    local y = love.graphics.getHeight() / 3
    local x1 = 0
    local x2 = love.graphics.getWidth()

    for i = 1, 2 do
        love.graphics.line(x1, y, x2, y)
        y = y + love.graphics.getHeight() / 3
    end
end

---------------// draw x or o //---------------


local function draw_cell(cell_type, x, y, cell_size)
    local image_to_draw

    if cell_type == "X" then
        image_to_draw = x_png
    elseif cell_type == "O" then
        image_to_draw = o_png
    else
        return
    end

    local image_width = image_to_draw:getWidth()
    local image_height = image_to_draw:getHeight()

    love.graphics.draw(
        image_to_draw, x, y, 0, cell_size / image_width, cell_size / image_height
    )
end


local function draw_if_empty(cell, cell_size, i, j)
    local x
    local y

    if cell ~= "" then
        x = (j - 1) * cell_size
        y = (i - 1) * cell_size
        draw_cell(cell, x, y, cell_size)
    end
end


local function draw_x_or_o()
    local cell_size = love.graphics.getWidth() / 3

    for i, row in ipairs(board) do
        for j, cell in ipairs(row) do
            draw_if_empty(cell, cell_size, i, j)
        end
    end
end

---------------// draw game //---------------

function love.draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(0, 0, 0)
    draw_height_lines()
    draw_width_lines()
    draw_x_or_o()
end

---------------// check winner //---------------

local function check_winner()
    for i = 1, 3 do
       if board[i][1] ~= " " and
            board[i][1] == board[i][2] and board[i][2] == board[i][3] then
            return board[i][1]
       end
    end
    for j = 1, 3 do
        if board[1][j] ~= " " and
            board[1][j] == board[2][j] and board[2][j] == board[3][j] then
            return board[1][j]
        end
    end
    if board[1][1] ~= " " and
        board[1][1] == board[2][2] and board[2][2] == board[3][3] then
        return board[1][1]
    end
    if board[1][3] ~= " " and
        board[1][3] == board[2][2] and board[2][2] == board[3][1] then
        return board[1][3]
    end
    return nil
end


local function are_cells_full()
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == " " then
                return false
            end
        end
    end

    return true
end

---------------// update game //---------------

local function update_game()
    local winner = check_winner()

    if winner then
        print("PLAYER " .. winner .. " WON !")
    elseif are_cells_full() then
        print("it's a draw :(")
    end
end

---------------// click button event //---------------

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        local cell_size = love.graphics.getWidth() / 3
        local col = math.ceil(x / cell_size)
        local row = math.ceil(y / cell_size)

        if board[row][col] == " " and not check_winner() then
            board[row][col] = current_player
            current_player = current_player == "X" and "O" or "X"
            update_game()
        end
    end
end
