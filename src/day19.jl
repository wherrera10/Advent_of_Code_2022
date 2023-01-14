""" advent of code 2022 day 19 """


""" Blueprints from data file, each line has recipes for building robots """
struct Blueprint
    num::Int
    orecost::Int # in ore
    claycost::Int # in ore
    obsidian_orecost::Int
    obsidian_claycost::Int
    geode_orecost::Int
    geode_obsidiancost::Int
    maxore_required::Int
    function Blueprint(arr::Vector{Int})
        @assert length(arr) == 7
        maxore = max(arr[3], arr[4], arr[6])
        return new(arr..., maxore)
    end       
end
Blueprint(txtline) = Blueprint([parse(Int, s.match) for s in eachmatch(r"\d+", txtline)])

const blueprints = map(Blueprint, readlines("aoc_2022/day19.txt"))

""" GeodeState, data for states for time series of building robots, collecting products """
mutable struct GeodeState
    minute::Int
    ore_robots::Int
    clay_robots::Int
    obsidian_robots::Int
    geode_robots::Int
    ore::Int
    clay::Int
    obsidian::Int
    geode::Int
    or_ignore::Bool # if could have built ore robot but instead did no building this time
    cl_ignore::Bool # if could have built clay robot but did no building this time
    ob_ignore::Bool # if could have built obsidian robot but did no building this time
    GeodeState() = new(1, 1, 0, 0, 0, 0, 0, 0, 0, false, false, false)
end

function maxpotential(s::GeodeState, maxminutes::Int)
    mremaining = maxminutes - s.minute + 1
    return s.geode + s.geode_robots * mremaining + (mremaining * (mremaining - 1)) ÷ 2
end

""" 
    forkstate(b::Blueprint, state::GeodeState, maxtime:Int)

    Given a blueprint and a state, return a vector of possible successor states,
    since there may be more than one option possible to take given maxtime 
    This is a depth-first search (DFS) for a maximum of geodes at time maxtime.
"""
function forkstate(b::Blueprint, s::GeodeState, maxtime::Int, curmax, verbose = false)
    mremaining = maxtime - s.minute
    mremaining < 0 && return s
    cangeoderobot = s.ore >= b.geode_orecost && s.obsidian >= b.geode_obsidiancost
    if curmax[begin] >= maxpotential(s, maxtime) # prune if cannot exceed current max
        return s
    end
    enough_or = s.ore_robots >= b.maxore_required
    enough_cr = s.clay_robots >= b.obsidian_claycost
    enough_ob = s.obsidian_robots >= b.geode_obsidiancost
    if enough_or && enough_cr && enough_ob && cangeoderobot
        # if we are here, we can shortcut since production is steady state output.
        for m in 1:mremaining
            s.ore -= b.geode_orecost
            s.obsidian -= b.geode_obsidiancost
            s.geode_robots += 1
            s.ore += s.ore_robots
            s.clay += s.clay_robots
            s.obsidian += s.obsidian_robots
            s.geode += s.geode_robots - 1 # -1 for the robot just added not making geode yet
        end
        return s
    end
    newstates = GeodeState[]
    # get the possible to build cases before adding the generated materials
    # if skipped a build last time do it once more
    canobsidianrobot = s.ore >= b.obsidian_orecost && s.clay >= b.obsidian_claycost &&
       !enough_ob && !s.ob_ignore
    canclayrobot = s.ore >= b.claycost && !enough_cr && !s.cl_ignore
    canorerobot = s.ore >= b.orecost && !enough_or && !s.or_ignore
    # generate new materials and update for next state
    s.minute += 1
    s.ob_ignore = s.cl_ignore = s.or_ignore = false
    s.ore += s.ore_robots
    s.clay += s.clay_robots
    s.obsidian += s.obsidian_robots
    s.geode += s.geode_robots
    if cangeoderobot  # always build the geode robots if can
        s.ore -= b.geode_orecost
        s.obsidian -= b.geode_obsidiancost
        s.geode_robots += 1
        push!(newstates, s)
    else
        while s.ore < min(b.orecost, b.claycost, b.obsidian_orecost, b.geode_orecost) &&
           s.clay < b.obsidian_claycost && s.obsidian < b.geode_obsidiancost # cannot make any robot
            s.minute += 1
            s.ore += s.ore_robots
            s.clay += s.clay_robots
            s.obsidian += s.obsidian_robots
            s.geode += s.geode_robots
        end        
        # first case: do not build any robots
        s2 = deepcopy(s)
        canorerobot && (s2.or_ignore = true)
        canclayrobot && (s2.cl_ignore = true)
        canobsidianrobot && (s2.ob_ignore = true)       
        push!(newstates, s2)  # this case is for no robots built
        if canobsidianrobot
            s2 = deepcopy(s)
            s2.ore -= b.obsidian_orecost
            s2.clay -= b.obsidian_claycost
            s2.obsidian_robots += 1  
            push!(newstates, s2)
        end
        if canclayrobot
            s2 = deepcopy(s)
            s2.ore -= b.claycost
            s2.clay_robots += 1 
            push!(newstates, s2)
        end
        if canorerobot
            s2 = deepcopy(s)
            s2.ore -= b.orecost
            s2.ore_robots += 1
            push!(newstates, s2)
        end
    end
    # recurse, return max state
    verbose && @show newstates
    isempty(newstates) && return s
    maxstate = sort!([forkstate(b, state, maxtime, curmax, verbose)
       for state in newstates], by = gs -> gs.geode)[end]
    curmax[begin] = max(maxstate.geode, curmax[begin]) # update current max outcome
    return maxstate
end

""" part 1 sum the best geode processing outcomes time blueprint number for all blueprints """
function part1(blueprints = blueprints, minutes = 24, verbose = true)
    qualitysum = 0
    for b in blueprints
        maxgeodes = [0]
        best = forkstate(b, GeodeState(), minutes, maxgeodes)
        qualitysum += best.geode * b.num
        verbose && @show qualitysum, b, best
    end
    return qualitysum # 1834 [geode bests: 1 1 0 0 1 5 9 2 1 4 0 4 1 12 8 0 0 5 5 0 1 5 5 0 15 0 7 3 0 8]
end

""" part 2 multiply the best geode processing outcomes for all blueprints 1, 2, 3"""
function part2(blueprints2 = blueprints[1:3], minutes = 32, verbose = true)
    geodeprod = 1
    for b in blueprints2
        maxgeode = [0]
        best = forkstate(b, GeodeState(), minutes, maxgeode)
        geodeprod *= best.geode
        verbose && @show geodeprod, b, best
    end
    return geodeprod
end

@show part1() part2() # 1834
