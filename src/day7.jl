""" advent of code 2022 day 7 """

abstract type ANode end

struct NilNode <: ANode end

const NIL = NilNode()

struct Node <: ANode
    name::String
    parent::ANode
    isdir::Bool
    size::Int
    children_indices::Vector{Int}
    Node(n, p, isdir, sz = 0) = new(n, p, isdir, sz, Int[])
end

const root = Node("/", NIL, true)

const allnodes = [root]

const lines = split(read("day7.txt", String), "\n")
popfirst!(lines)

function dirsize(node, nodelist)
    totals = 0
    !node.isdir && return 0
    for i in node.children_indices
        nod = nodelist[i]
        if nod.isdir
            totals += dirsize(nod, nodelist)
        else
            totals += nod.size
        end
    end
    return totals
end



let
    curdir = root

    for line in lines
        if line[1:4] == "dir "
            push!(allnodes, Node(line[5:end], curdir, true))
            push!(curdir.children_indices, length(allnodes))
        elseif (m = match(r"(\d+) (\w+)", line)) isa RegexMatch
            fsize = parse(Int, m.captures[1])
            fname = m.captures[2]
            push!(allnodes, Node(fname, curdir, false, fsize))
            push!(curdir.children_indices, length(allnodes))
        elseif (m = match(r"cd (.+)", line)) isa RegexMatch
            nextdir = m.captures[1]
            curdir = nextdir == ".." ? curdir.parent : 
               allnodes[findfirst(n -> n.name == nextdir && n.parent == curdir, allnodes)]
        end
    end

    sizes = [dirsize(n, allnodes) for n in allnodes]
    part1 = sum(sz for sz in sizes if 0 < sz <= 100_000)

    totalsize = dirsize(root, allnodes)
    remaining = 70_000_000 - totalsize
    needed = 30_000_000 - remaining

    part2 = sort(filter(sz -> sz >= needed, sizes))[begin]

    @show part1, part2
    
end
