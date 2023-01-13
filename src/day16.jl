""" advent of code 2022 day 16 """

const rate = Dict{String, Int}()
const destvalves = Dict{String, Vector{String}}()
for line in readlines("day16.txt")
    valve, ratetext = match(r"Valve ([A-Z]+)\s.+=(\d+);", line).captures
    rate[valve] = parse(Int, ratetext)
    destvalves[valve] = [m.match for m in eachmatch(r"[A-Z][A-Z]", line[30:end])]
end

#=
const valvecount = count(>(0), values(rate))
const valvesum = sum(values(rate))
@show valvecount valvesum  # 15 217
=#

""" measure pressure released in time series in part 1 """
function pressure_released(steps, final = false)
    open, total = 0, 0
    for elem in steps[firstindex(steps) + 1 : (final ? lastindex(steps) - 1 : lastindex(steps))]
        if elem isa Int
            open += elem
        end
        total += open
    end
    return total
end

""" part 1 simulation with multiple variants """
function runsteps(nsteps, mult = 6, divs = 7)
    routes = Vector{Union{String, Int}}[]
    push!(routes, ["AA"])
    newroutes = empty(routes)
    for i in 1:nsteps
        for r in routes
            prevstep = r[end]
            if prevstep isa AbstractString
                dup, newrate = false, rate[prevstep]
                if newrate > 0
                    for j in firstindex(r)+1:lastindex(r)-1
                        if r[j] == prevstep && r[j + 1] == newrate
                            dup = true
                            break
                        end
                    end
                    !dup && push!(newroutes, [r; newrate])
                end
            end
            for v in shuffle(destvalves[prevstep isa Int ? r[end - 1] : prevstep])
                push!(newroutes, [r; v])
            end
        end
        routes = newroutes
        sort!(routes, by = pressure_released)
        length(routes) > 30_000 && (routes = routes[lastindex(routes) * mult ÷ divs + 1 : end])
        newroutes = empty(routes)
        # @show i, length(routes)
    end
    return routes    
end

const part = [0, 0]
part[1] = maximum(s -> pressure_released(s, true), runsteps(30))

""" measure pressure released in time series in part 2 (two actors)"""
function pressure_released2(steps, final = false)
    open, total = 0, 0
    for elems in steps[begin:(final ? lastindex(steps) - 1 : lastindex(steps))]
        if elems[1] isa Int
            open += elems[1]
        end
        if elems[2] isa Int
            open += elems[2]
        end
        total += open
    end
    return total
end

""" part 2 simulation with multiple variants """
function runsteps2(nsteps, mult = 6, divs = 7)
    routes = Vector{Vector{Union{String, Int}}}[]
    push!(routes, [["AA", "AA"]])
    newroutes = empty(routes)
    for i in 1:nsteps
        for r in routes
            if opentotal(r) == valvesum
                push!(newroutes, [r; [["AA", "AA"]]])
                continue
            end
            added1, added2, addv1, addv2 = 0, 0, "", ""
            p = r[end][1]
            if p isa AbstractString
                newrate = rate[p] 
                if newrate > 0
                    nodup = true
                    for j in firstindex(r)+1:lastindex(r)-1
                        if r[j][1] == p && r[j + 1][1] == newrate || r[j][2] == p && r[j + 1][2] == newrate
                            nodup = false
                            break
                        end
                    end
                    if nodup
                        added1 = newrate
                        addv1 = p
                    end
                end
            end
            p = r[end][2]
            if p isa AbstractString
                newrate = rate[p] 
                if newrate > 0
                    nodup = true
                    for j in firstindex(r)+1:lastindex(r)-1
                        if r[j][1] == p && r[j + 1][1] == newrate || r[j][2] == p && r[j + 1][2] == newrate
                            nodup = false
                            break
                        end
                    end
                    if nodup
                        added2 = newrate
                        addv2 = p
                    end
                end
            end
            last1 = r[end][1] isa Int ? length(r) - 1 : length(r)
            last2 = r[end][2] isa Int ? length(r) - 1 : length(r)
            prev1 = filter(v -> all(p -> p[2] != v, r), destvalves[r[last1][1]])
            prev2 = filter(v -> all(p -> p[1] != v, r), destvalves[r[last2][2]])
            if added1 == 0 && added2 > 0
                for v1 in prev1
                    push!(newroutes, [r; [[v1, added2]]])
                end
            elseif added1 > 0 && added2 == 0
                for v2 in prev2
                    push!(newroutes, [r; [[added1, v2]]])
                end
            elseif added1 > 0 && added2 > 0 && addv1 != addv2
                push!(newroutes, [r; [[added1, added2]]])
            end
            for v1 in prev1, v2 in prev2
                push!(newroutes, [r; [[v1, v2]]])
            end
        end
        routes = newroutes
        sort!(routes, by = pressure_released2)
        if length(routes) > 30_000
            routes = routes[lastindex(routes) * mult ÷ divs + 1 : end]
        end
        newroutes = empty(routes)
        # @show i, length(routes), routes[end]
    end
    return routes    
end

part[2] = maximum(s -> pressure_released2(s, true), runsteps2(26))

println("part1 = ", part[1], ", part2 = ", part[2])
