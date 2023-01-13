""" advent of code 2022 day 17 """


const part, chamberwidth, chamberdepth = [0, 0], 7, 50_000
const mat = falses(chamberdepth, chamberwidth)
const jetmoves = [c == '>' ? 1 : -1 for c in read("day17.txt", String) |> strip]
const shapes = [
    [true true true true],
    [false true false
     true true true
     false true false],
    [true true true
     false false true
     false false true],
    reshape([true true true true], 4, 1),
    [true true
     true true]]

""" Detect collision between shapes already fallen and a falling shape """
function have_collision(mat, s, r, c, dy, dx)
    return r < 1 || c < 1 || c + dx > chamberwidth || sum(mat[r:r+dy, c:c+dx] .& s) > 0
end

""" Simulate racks dropping in chamber, like Tetris but no spinning of rocks """
function simulate!(chamber, rocks_to_drop, maxrun = 5_000, demand = 1_000_000_000_000)
    stackheight, jetpos, jetlen, shapepos, shapelen = 0, 0, length(jetmoves), 0, length(shapes)
    states = Dict{Pair{Int}, Vector{Pair{Int}}}()
    for shapesdropped in 1:maxrun
        if shapesdropped > rocks_to_drop && part[1] == 0
            part[1] = stackheight
        end
        shapepos = mod1(shapepos + 1, shapelen)
        shape = shapes[shapepos]
        row, col = stackheight + 4, 3
        dy, dx = size(shape) .- 1
        for j in 1:typemax(Int32)
            jetpos = mod1(jetpos + 1, jetlen)
            jetdelta = jetmoves[jetpos]
            if !have_collision(chamber, shape, row, col + jetdelta, dy, dx)
                col += jetdelta
            end
            have_collision(chamber, shape, row - 1, col, dy, dx) && break
            row -= 1
        end
        chamber[row:row+dy, col:col+dx] .|= shape
        push!(get!(states, shapepos => jetpos, Pair{Int}[]), shapesdropped => stackheight)
        stackheight = max(stackheight, row + dy)
    end
    #= Part 2: Find dropped count and heights at duplicate shape and jet position.
       The difference in shape count can be used to calculate the difference in heights
       which can be used as a unit to span a larger shape count than we can run directly. =#
    for pvec in values(states)
        if length(pvec) > 1
            dropped1, sheight1 = pvec[1]
            dropped2, sheight2 = pvec[2]
            if (demand - dropped2 + 1) % (dropped2 - dropped1) == 0
                part[2] = (demand - dropped2 + 1) ÷ (dropped2 - dropped1) * (sheight2 - sheight1) + sheight2
                break
            end
        end
    end
end

simulate!(mat, 2022)
@show part[1] part[2]

