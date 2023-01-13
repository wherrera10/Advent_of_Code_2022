""" advent of code 2022 day 9 """

#using Plots

const move_texts = [strip.(split(s, r"\s+")) for s in split(read("day9.txt", String), "\n")]

const moves = [[s[1][1], parse(Int, s[2])] for s in move_texts]

const visited = Tuple{Int, Int}[]

function fixtail!(state)
    fixes = [ (1, 1) (1, 1) (1, 0) (1, -1) (1, -1)
              (1, 1) (0, 0) (0, 0) (0, 0) (1, -1)
              (0, 1) (0, 0) (0, 0) (0, 0) (0, -1)
              (-1, 1) (0, 0) (0, 0) (0, 0) (-1, -1)
              (-1, 1) (-1, 1) (-1, 0) (-1, -1) (-1, -1)]

    dx = state[2][1] - state[1][1] + 3
    dy = state[2][2] - state[1][2] + 3
    state[2] .+= fixes[dx, dy]
end

function step!(state, direction)
    oldtail = [state[2][1], state[2][2]]
    if direction == 'R'
        state[1][2] += 1
    elseif direction == 'L'
        state[1][2] -= 1
    elseif direction == 'U'
        state[1][1] -= 1
    elseif direction == 'D'
        state[1][1] += 1
    end
    fixtail!(state)
    push!(visited, (state[2][1], state[2][2]))
end

function move!(state, direction, count)
    for _ in 1:count
        step!(state, direction)
    end
end

function stepknots!(direction, knots)
    if direction == 'R'
        knots[1][2] += 1
    elseif direction == 'L'
        knots[1][2] -= 1
    elseif direction == 'U'
        knots[1][1] -= 1
    elseif direction == 'D'
        knots[1][1] += 1
    end
    for i in 1:length(knots)-1
        fixtail!([knots[i], knots[i + 1]])
    end
    push!(visited, (knots[end][1], knots[end][2]))
    #display(scatter(map(last, knots), map(x -> 30 - first(x), knots), ylims=[0, 30], xlims=[0, 30]))
end

function moveknots!(direction, count, knots)
    for _ in 1:count
        stepknots!(direction, knots)
    end
end


let 
    pos = [[0, 0], [0, 0]]
    empty!(visited)
    push!(visited, (0, 0))

    for (d, n) in moves
        move!(pos, d, n)
    end

    part1 = length(unique(visited))

    statestack = [[15, 15] for _ in 1:10]

    empty!(visited)
    push!(visited, (15, 15))

    for (d, n) in moves
        moveknots!(d, n, statestack)
    end
    
    part2 = length(unique(visited))


    @show part1, part2
end
