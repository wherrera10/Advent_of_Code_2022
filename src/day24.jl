""" advent of code 2022 day 24 """


const lines = [s for s in readlines("day24.txt")]
const vheight, vwidth = length(lines), length(lines[begin]) # 27, 122
const valley = fill("", vheight, vwidth)
for (i, line) in enumerate(lines), (j, c) in enumerate(line)
    if c != '.'
        valley[i, j] = string(c)
    end
end

const newvalley = fill("", vheight, vwidth)
const startpos, endpos = [1, 2], [vheight, vwidth - 1]
const preendpos, prestartpos = [vheight - 1, vwidth - 1], [2, 2]
# @show vheight, vwidth

""" one step in the valley's state changes """
function stepvalley!(valley, verbose = false)
    fill!(newvalley, "")
    newvalley[[1, vheight], :] .= "#"
    newvalley[:, [1, vwidth]] .= "#"
    verbose && display(valley)
    for c2 in CartesianIndices(valley), ch in valley[c2]
        ch == '#' && continue
        s = ""
        if ch == '>'
            newy = c2[2] == vwidth - 1 ? 2 : c2[2] + 1
            newvalley[c2[1], newy] *= ">"
        elseif ch == 'v'
            newx = c2[1] == vheight - 1 ? 2 : c2[1] + 1
            newvalley[newx, c2[2]] *= "v"
        elseif ch == '<'
            newy = c2[2] == 2 ? vwidth - 1 : c2[2] - 1
            newvalley[c2[1], newy] *= "<"
        elseif ch == '^'
            newx = c2[1] == 2 ? vheight - 1 : c2[1] - 1
            newvalley[newx, c2[2]] *= "^"
        end
    end
    valley .= newvalley
    verbose && display(valley)
end
    
const part = [0, 0]

""" breadth-first search for steps to goal from startpositions """
function pathmaking(; maxsteps = 10000, verbose = false)
    goals = [preendpos, prestartpos, preendpos]
    startpositions = [startpos, endpos, startpos]
    pathminutes = Int[]
    for i in eachindex(goals)
        positions = [startpositions[i]]
        g, goto_outerloop = goals[i], false
        verbose && @show positions, g
        for m in 1:maxsteps
            newpositions = empty(positions)
            stepvalley!(valley)
            for p in positions
                x, y = p
                moved = false
                if x < vheight - 1 && valley[x + 1, y] == ""
                    newp = [x + 1, y]
                    if newp == g 
                        verbose && println("Solved for $g, $p to $newp in $(m + 1)")
                        push!(pathminutes, m + 1)
                        stepvalley!(valley)
                        @goto goto_outerloop
                    else
                        push!(newpositions, newp)
                        moved == true
                    end
                end
                if y < vwidth - 1 && valley[x, y + 1] == ""
                    newp = [x, y + 1]
                    if newp == g 
                        verbose && println("Solved $g, $p to $newp in $(m + 1)")
                        push!(pathminutes, m + 1)
                        stepvalley!(valley)
                        @goto goto_outerloop
                    else
                        push!(newpositions, newp)
                        moved == true
                    end
                end
                if x > 2 && valley[x - 1, y] == ""
                    newp = [x - 1, y]
                    if newp == g 
                        verbose && println("Solved $g, $p to $newp using in $(m + 1)")
                        push!(pathminutes, m + 1)
                        stepvalley!(valley)
                        @goto goto_outerloop
                    else
                        push!(newpositions, newp)
                        moved == true
                    end
                end
                if y > 2 && valley[x, y - 1] == ""
                    newp = [x, y - 1]
                    if newp == g
                        verbose && println("Solved $g, $p to $newp using in $(m + 1)")
                        push!(pathminutes, m + 1)
                        stepvalley!(valley)
                        @goto goto_outerloop
                    else
                        push!(newpositions, newp)
                        moved == true
                    end
                end
                if !moved && (p == startpos || p == endpos || valley[x, y] == "")
                    push!(newpositions, [x, y]) # stand still
                end
            end
            positions = unique(newpositions)
        end
        @label goto_outerloop
    end
    part .= [pathminutes[begin], sum(pathminutes)]
end

pathmaking()
@show part # 286, 820
