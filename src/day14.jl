""" advent of code 2022 day 14 """

const CAVE = fill('.', 2000, 200)
const origin = [1000, 1]

rockpathlines = strip.(split(read("day14.txt", String), "\n"))
for line in rockpathlines
    nums = [m.match for m in eachmatch(r"\d+", line)]
    for i in 1:2:length(nums)-3
        p1 = [parse(Int, nums[i]) + 500, parse(Int, nums[i + 1]) + 1]
        p2 = [parse(Int, nums[i + 2]) + 500, parse(Int, nums[i + 3]) + 1]
        xsgn, ysgn = sign(p2[1] - p1[1]), sign(p2[2] - p1[2])
        xsgn == 0 && (xsgn = 1)
        ysgn == 0 && (ysgn = 1)
        CAVE[p1[1]:xsgn:p2[1], p1[2]:ysgn:p2[2]] .= '#'
    end
end

function showcave(cav)
    for row in 1:size(cav, 2)
        println(String(cav[950:1050, row]))
    end
end

const yfloor = findlast(y -> any(==('#'), CAVE[:, y]), 1:200) + 2

function simulation!(maxunits)
    cave = deepcopy(CAVE)
    pos = copy(origin)
    newpos = copy(pos)
    xmax = size(cave, 1)
    part1, part2 = 0, 0
    for i in 1:maxunits
        pos .= origin
        newpos .= pos
        while true   
            if cave[pos[1], pos[2] + 1] == '.'
                newpos .+= [0, 1]
            elseif pos[1] > 1 && cave[pos[1] - 1, pos[2] + 1] == '.'
                newpos .+= [-1, 1]
            elseif pos[1] < xmax && cave[pos[1] + 1, pos[2] + 1] == '.'
                newpos .+= [1, 1]
            end
            if newpos == pos || newpos[2] >= yfloor - 1
                cave[newpos[1], newpos[2]] = 'o'
                if newpos == origin
                    part2 = i
                    showcave(cave)
                    return part1, part2
                end
                break
            end
            pos .= newpos
        end
        if newpos[2] >= yfloor - 1 && part1 == 0
            part1 = i - 1
        end
    end
    showcave(cave)
    return part1, part2
end

part1, part2 = simulation!(10000000)




