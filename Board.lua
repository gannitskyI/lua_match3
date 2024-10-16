Board = {}
Board.__index = Board

function Board:new(size)
    local obj = setmetatable({}, self)
    obj.size = size
    obj.colors = {'A', 'B', 'C', 'D', 'E', 'F'}
    obj:initialize()
    return obj
end

function Board:initialize()
    self.grid = {}
    math.randomseed(os.time())
    for i = 1, self.size do
        self.grid[i] = {}
        for j = 1, self.size do
            repeat
                self.grid[i][j] = self.colors[math.random(#self.colors)]
            until not self:isAdjacent(i, j)
        end
    end
end

function Board:isAdjacent(x, y)
    local color = self.grid[x][y]
    if x > 1 and self.grid[x - 1][y] == color then
        return true
    end
    if y > 1 and self.grid[x][y - 1] == color then
        return true
    end
    return false
end

function Board:dump()
    io.write("   ")
    for j = 0, self.size - 1 do
        io.write(j .. " ")
    end
    io.write("\n")
    for i = 1, self.size do
        io.write(i - 1 .. "| ")
        for j = 1, self.size do
            io.write((self.grid[i][j] or ".") .. " ")
        end
        io.write("\n")
    end
end

function Board:collapse()
    for j = 1, self.size do
        local emptySlots = 0
        for i = self.size, 1, -1 do
            if self.grid[i][j] == nil then
                emptySlots = emptySlots + 1
            elseif emptySlots > 0 then
                self.grid[i + emptySlots][j] = self.grid[i][j]
                self.grid[i][j] = nil
            end
        end
        for i = 1, emptySlots do
            repeat
                self.grid[i][j] = self.colors[math.random(#self.colors)]
            until not self:isAdjacent(i, j)
        end
    end
end

function Board:getSize()
    return self.size
end

function Board:getCell(x, y)
    return self.grid[x][y]
end

function Board:setCell(x, y, value)
    self.grid[x][y] = value
end