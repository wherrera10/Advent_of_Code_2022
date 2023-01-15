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
    Blueprint(arr::Vector{Int}) = new(arr...)
end
Blueprint(txtline) = Blueprint([parse(Int, s.match) for s in eachmatch(r"\d+", txtline)])

const blueprints = map(Blueprint, readlines("day19.txt"))

""" GeodeState, data for states for time series of building robots, collecting products """
mutable struct GeodeState
    minute::UInt
    ore_robots::UInt
    clay_robots::UInt
    obsidian_robots::UInt
    geode_robots::UInt
    ore::UInt
    clay::UInt
    obsidian::UInt
    geode::Int
    ob_deferred::Bool
    cl_deferred::Bool
    or_deferred::Bool
    GeodeState() = new(1, 1, 0, 0, 0, 0, 0, 0, 0, false, false, false)
end

function maxore(b::Blueprint, s::GeodeState)
    return max(b.geode_orecost, 
              (s.obsidian_robots >= b.geode_obsidiancost ? 0 : b.obsidian_orecost),
              (s.clay_robots >= b.obsidian_claycost ? 0 : b.claycost),
              (s.ore_robots >= b.orecost ? 0 : b.orecost))
end

function mineresources!(s::GeodeState)
    s.ore += s.ore_robots
    s.clay += s.clay_robots
    s.obsidian += s.obsidian_robots
    s.geode += s.geode_robots
end

function maxpotential(s::GeodeState, maxminutes::Int)
    remaining = maxminutes - s.minute + 1
    return s.geode + s.geode_robots * remaining + (remaining * (remaining - 1)) ÷ 2
end

""" 
    forkstate(b::Blueprint, state::GeodeState, maxtime:Int)
    Given a blueprint and a state, return a vector of possible successor states,
    since there may be more than one option possible to take given maxtime 
    This is a depth-first search (DFS) for a maximum of geodes at time maxtime.
"""
function forkstate(b::Blueprint, s::GeodeState, maxtime::Int, curmax, mingeod)
    s.minute > maxtime && return s
    enough_or = s.ore_robots >= maxore(b, s)
    enough_cr = s.clay_robots >= b.obsidian_claycost
    enough_ob = s.obsidian_robots >= b.geode_obsidiancost
    if curmax[begin] >= maxpotential(s, maxtime) # prune if cannot exceed current max
        return s
    end
    if s.geode == 0 && mingeod[begin] < s.minute
        return s
    end
    can_ge = s.ore >= b.geode_orecost && s.obsidian >= b.geode_obsidiancost
    can_ob = s.ore >= b.obsidian_orecost && s.clay >= b.obsidian_claycost &&
       !enough_ob && !s.ob_deferred
    can_cl = s.ore >= b.claycost && !enough_cr && !s.cl_deferred && s.minute < maxtime - 1
    can_or = s.ore >= b.orecost && !enough_or && !s.or_deferred
    newstates = GeodeState[]
    s.minute += 1
    s.ob_deferred = s.cl_deferred = s.or_deferred = false
    mineresources!(s)
    if enough_or && enough_cr && enough_ob
        # if we are here, we can shortcut since production is steady state output.
        while s.minutes <= maxtime
            s.ore -= b.geode_orecost
            s.obsidian -= b.geode_obsidiancost
            s.geode_robots += 1
            s.minutes += 1
            mineresources!(s)
        end
        return s
    end
    if can_ge  # always build the geode robots if can
        s.ore -= b.geode_orecost
        s.obsidian -= b.geode_obsidiancost
        s.geode_robots += 1
        push!(newstates, s)
    elseif can_ob || can_cl || can_or
        if can_ob
            s2 = deepcopy(s)
            s2.ore -= b.obsidian_orecost
            s2.clay -= b.obsidian_claycost
            s2.obsidian_robots += 1
            push!(newstates, s2)
        end
        if can_cl
            s2 = deepcopy(s)
            s2.ore -= b.claycost
            s2.clay_robots += 1 
            push!(newstates, s2)
        end
        if can_or
            s2 = deepcopy(s)
            s2.ore -= b.orecost
            s2.ore_robots += 1
            push!(newstates, s2)
        elseif can_ob || can_cl
            s2 = deepcopy(s)
            can_ob && (s2.ob_deferred = true)
            can_cl && (s2.cl_deferred = true)
            push!(newstates, s2)
        end
    else
        # cannot build any
        push!(newstates, s)
    end
    isempty(newstates) && return s
    # recurse, return max state
    mingeod[begin] = min(mingeod[begin], [x.minute for x in newstates if x.geode > 0]...)
    maxstate = sort!([forkstate(b, state, maxtime, curmax, mingeod)
       for state in newstates], by = gs -> gs.geode)[end]
    curmax[begin] = max(curmax[begin], maxstate.geode)
    return maxstate
end

""" part 1 sum (best geode processing outcomes * blueprint number) for all blueprints """
function part1(blueprints = blueprints, minutes = 24)
    return sum(forkstate(b, GeodeState(), minutes, [0], [minutes]).geode * b.num for b in blueprints)
end

@show part1()

""" part 2 multiply the best geode processing outcomes in 32 minutes for only blueprints 1, 2, 3"""
function part2(blueprints2 = blueprints[1:3], minutes = 32)
    return prod(forkstate(b, GeodeState(), minutes, [0], [minutes]).geode for b in blueprints2)
end

@show part2()

# part = [1834, 2240]
# 1834 [geode bests: 1 1 0 0 1 5 9 2 1 4 0 4 1 12 8 0 0 5 5 0 1 5 5 0 15 0 7 3 0 8]
# 2240 = 16 * 20 * 7
