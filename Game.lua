Game = {}
Game.__index = Game

function Game:new(boardSize)
    local obj = setmetatable({}, self)
    obj.board = Board:new(boardSize)
    return obj
end

function Game:move(from, to)
    local fx, fy = from[1], from[2]
    local tx, ty = to[1], to[2]

    if math.abs(fx - tx) + math.abs(fy - ty) == 1 then
        
        local temp = self.board:getCell(tx, ty)
        self.board:setCell(tx, ty, self.board:getCell(fx, fy))
        self.board:setCell(fx, fy, nil)

        if not self:tick() then
            
            self.board:setCell(fx, fy, self.board:getCell(tx, ty))
            self.board:setCell(tx, ty, temp)
            print("The crystal did not form a trio.") 
        else
            self.board:collapse()  
        end
    else
        print("Invalid move.")
    end
end

function Game:tick()
    local matches = {}
    for i = 1, self.board:getSize() do
        for j = 1, self.board:getSize() - 2 do
            if self.board:getCell(i, j) and self.board:getCell(i, j) == self.board:getCell(i, j + 1) and self.board:getCell(i, j) == self.board:getCell(i, j + 2) then
                table.insert(matches, {i, j})
                table.insert(matches, {i, j + 1})
                table.insert(matches, {i, j + 2})
            end
        end
    end

    for j = 1, self.board:getSize() do
        for i = 1, self.board:getSize() - 2 do
            if self.board:getCell(i, j) and self.board:getCell(i, j) == self.board:getCell(i + 1, j) and self.board:getCell(i, j) == self.board:getCell(i + 2, j) then
                table.insert(matches, {i, j})
                table.insert(matches, {i + 1, j})
                table.insert(matches, {i + 2, j})
            end
        end
    end
 
    for _, match in ipairs(matches) do
        local x, y = match[1], match[2]
        self.board:setCell(x, y, nil)
    end
 
    return #matches > 0
end

function Game:run()
    self.board:dump()
    while true do
        io.write("> ")
        local input = io.read()
        if input == "q" then break end
        local cmd, x, y, d = input:match("(%a) (%d) (%d) (%a)")
        if cmd == "m" then
            x, y = tonumber(x) + 1, tonumber(y) + 1
            local to = {x, y}
            if d == "l" then to[2] = to[2] - 1
            elseif d == "r" then to[2] = to[2] + 1
            elseif d == "u" then to[1] = to[1] - 1
            elseif d == "d" then to[1] = to[1] + 1
            end

            if to[1] >= 1 and to[1] <= self.board:getSize() and to[2] >= 1 and to[2] <= self.board:getSize() then
                self:move({x, y}, to)
                self.board:collapse() 
                self.board:dump()
            else
                print("Move is out of bounds.")
            end
        else
            print("Invalid command. Please try again.")
        end
    end
end