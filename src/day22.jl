""" advent of code 2022 day 22 """


const part = [0, 0]
const input = split(read("day22.txt", String), "\n\n")
#const input = split(read("onedrive/documents/julia programs/aoc_2022/day22.txt", String), "\n\n")
const btextlines, movetext = split(input[1], "\n"), input[2]
const boardheight, boardwidth = length(btextlines), maximum(length(lin) for lin in btextlines)
const board = fill(' ', boardheight, boardwidth)

for (i, line) in enumerate(btextlines), (j, c) in enumerate(line)
    board[i, j] = c
end

# -1 == R, -2 == L, otherwise integer move 
const moves = [isletter(m.match[1]) ? (m.match[1] == 'R' ? -1 : -2) : parse(Int, m.match)
   for m in eachmatch(r"\d+|[RL]", movetext)]

""" walk along moves for part 1 and part 2"""
function walkpath(ispart1)
    x, y, facing = 1, findfirst(==('.'), board[1, :]), 0
    for move in moves
        if move < 0  # turns are coded as negative Int
            facing = ((move == -1 ? facing + 1 : facing - 1) + 4) % 4
        else
            for _ in 1:move
                newfacing, newx, newy = facing, x, y
                if isodd(facing) # moving down or up
                    newx += (facing == 1 ? 1 : -1)
                    if newx < 1 || newx > boardheight || board[newx, y] == ' ' # need to wrap around
                        if ispart1
                            newx = facing == 1 ? findfirst(!=(' '), board[:, y]) :
                                                 findlast(!=(' '), board[:, y])
                        else # part 2, handle top and bottom edges
                            if newx < 1
                                if y < 101
                                    newfacing, newx, newy = 0, 100 + y, 1
                                else
                                    newfacing, newx, newy = 3, 200, y - 100
                                end
                            elseif newx > boardheight
                                newfacing, newx, newy = 1, 1, y + 100
                            elseif newx == 100
                                newfacing, newx, newy = 0, 50 + y, 51
                            elseif newx == 151
                                newfacing, newx, newy = 2, y + 100, 50
                            elseif newx == 51
                                newfacing, newx, newy = 2, y - 50, 100
                            end
                        end
                    end
                    board[newx, newy] == '#' && break # blocked by wall, so quit moving
                    facing, x, y = newfacing, newx, newy
                else # moving right or left
                    newy += (facing == 0 ? 1 : -1)
                    if newy < 1 || newy > boardwidth || board[x, newy] == ' ' # need to wrap around
                        if ispart1
                            newy = facing == 0 ? findfirst(!=(' '), board[x, :]) :
                                                 findlast(!=(' '), board[x, :])
                        else # part 2, handle left and right edges
                            if newy < 1
                                if x < 151
                                    newfacing, newx, newy = 0, 151 - x, 51
                                else
                                    newfacing, newx, newy = 1, 1, x - 100
                                end
                            elseif newy > boardwidth
                                    newfacing, newx, newy = 2, 151 - x, 100
                            elseif newy == 50
                                if newx < 51
                                    newfacing, newx, newy = 0, 151 - x, 1
                                else
                                    newfacing, newx, newy = 1, 101, x - 50
                                end
                            elseif newy == 51
                                newfacing, newx, newy = 3, 150, x - 100
                            elseif newy == 101
                                if newx < 101
                                    newfacing, newx, newy = 3, 50, x + 50
                                else
                                    newfacing, newx, newy = 2, 151 - x, 150
                                end   
                            end
                        end
                    end
                    board[newx, newy] == '#' && break # blocked by wall, so quit moving
                    facing, x, y = newfacing, newx, newy
                end
            end
        end
    end
    return 1000 * x + 4 * y + facing
end


part[1] = walkpath(true)
@show part[1]  # 67390
part[2] = walkpath(false)
@show part[2] # > 62219
