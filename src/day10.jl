""" advent of code 2022 day 10 """

const oplines = strip.(split(read("day10.txt", String), "\n"))

const strengths = Int[]
const xpositions = Int[]
const screen = fill('.', 240)

let 
    cycle = 1
    x = 1

    for s in oplines
        push!(strengths, x * cycle)
        push!(xpositions, x)
        if s[1] == 'n' # noop
            cycle += 1
        else
            push!(strengths, x * (cycle + 1))
            push!(xpositions, x)
            x += parse(Int, split(s, r"\s+")[2])
            cycle += 2
        end
    end
    
    part1wanted = [20, 60, 100, 140, 180, 220]

    part1 = sum(strengths[i] for i in part1wanted)

    for i in 1:240
        x = xpositions[i]
        modi = mod1(i, 40)
        if modi - 2 <= x <= modi
            screen[i] = '#'
        end
    end
    @show part1
    
    for i in 1:40:238
        println(String(screen[i:i+39]))
    end

end

