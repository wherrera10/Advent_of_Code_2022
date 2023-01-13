""" advent of code 2022 day 23 """


""" location and proposed next location for a wandering planting task elf in the grove """
mutable struct Elf
    x::Int
    y::Int
    have_valid_proposal::Bool
    proposedx::Int
    proposedy::Int
    Elf(x, y) = new(x, y, false, 0, 0)
end

const elves = Elf[]
for (i, line) in enumerate(readlines("day23.txt")), (j, c) in enumerate(line)
    c == '#' && push!(elves, Elf(i, j))
end

northclear(elf) = all(s -> s == elf || s.x != elf.x - 1 || s.y ∉ elf.y-1:elf.y+1, elves)
southclear(elf) = all(s -> s == elf || s.x != elf.x + 1 || s.y ∉ elf.y-1:elf.y+1, elves)
westclear(elf) = all(s -> s == elf || s.y != elf.y - 1 || s.x ∉ elf.x-1:elf.x+1, elves)
eastclear(elf) = all(s -> s == elf || s.y != elf.y + 1 || s.x ∉ elf.x-1:elf.x+1, elves)

const initial_ordering = [northclear, southclear, westclear, eastclear]

""" get a move proposal for an elf, Conway Game of Life sort-of-style """
function propose!(elf, ordering)
    elf.have_valid_proposal = false
    checkings = [f(elf) for f in ordering]
    if 0 < sum(checkings) < 4  # if none blocked or all blocked, no proposal
        for (i, f) in enumerate(ordering)
            if checkings[i]
                elf.have_valid_proposal = true
                elf.proposedx = elf.x + (f == northclear ? -1 : f == southclear ? 1 : 0)
                elf.proposedy = elf.y + (f == westclear ? -1 : f == eastclear ? 1 : 0)
                break
            end
        end
    end
end

""" get all elf proposals and resolve collisions """
function proposals!(elves, ordering)
    usedxy = Dict{Vector{Int}, Int}()
    for s in elves # get all proposals
        propose!(s, ordering)
        if s.have_valid_proposal
            px, py = s.proposedx, s.proposedy
            if haskey(usedxy, [px, py])
                usedxy[[px, py]] += 1
            else
                usedxy[[px, py]] = 1
            end
        end
    end
    for s in elves  # if duplicative proposal, invalidate proposal
        if s.have_valid_proposal && usedxy[[s.proposedx, s.proposedy]] > 1
            s.have_valid_proposal = false
        end
    end
end

""" return 1 if moved, 0 if not for part 2 counting of moves """
function move_as_proposed!(elf)
    if elf.have_valid_proposal
        elf.x, elf.y = elf.proposedx, elf.proposedy
        return 1
    end
    return 0
end

""" run moves, return total of elves that did move this turn """
move_as_proposed!(elves::Vector) = sum(move_as_proposed!(s) for s in elves)

""" bounding rectangle for part of grove where there are planting elves """
boundingrectangle(elves) = [extrema(s.x for s in elves)..., extrema(s.y for s in elves)...]

""" get the total empty tiles in the bounding rectangle """
function empties_in_boundingrectangle(elves)
    x1, x2, y1, y2 = boundingrectangle(elves)
    return (x2 - x1 + 1) * (y2 - y1 + 1) - length(elves)
end

""" optional display of grove (1 = elf, 0 = empty) """
function displaygrove(elves)
    x1, x2, y1, y2 = boundingrectangle(elves)
    points = [[s.x + x1 + 1, s.y + y1 + 1] for s in elves]
    mat = zeros(Int, x2 + x1 + 1, y2 + y1 + 1)
    for p in points
        mat[p[1], p[2]] = 1
    end
    display(mat)
end

const part = [0, 0]

function run_grove!(elves, part, verbose = false, nsteps = 10)
    step = 0
    verbose && displaygrove(elves)
    for stepnumber in 1:typemax(Int)
        ordering = circshift(initial_ordering, -stepnumber + 1)
        proposals!(elves, ordering)
        elves_moved = move_as_proposed!(elves)
        verbose && displaygrove(elves)
        if (step += 1) == nsteps
            part[1] = empties_in_boundingrectangle(elves)
        end
        if elves_moved == 0
            part[2] = stepnumber
            break
        end
    end
end

run_grove!(elves, part)
@show part
