""" advent of code 2022 day 13 """

const pairs = [[eval(Meta.parse(s)) for s in split(pair, "\n")] for pair in split(read("day13.txt", String), "\n\n")]

@show length(pairs)

function compare(left::Vector, right::Vector)
    leftlen, rightlen = length(left), length(right)
    leftlen == 0 && return rightlen > 0
    for i in 1:leftlen
        i > rightlen && return -1
        ret = compare(left[i], right[i])
        ret != 0 && return ret
    end
    return 0
end
compare(left::Int, right::Int) = sign(right - left)
compare(left::Vector, right::Int) = isempty(left) ? 1 : compare(left, [right])
compare(left::Int, right::Vector) = isempty(right) ? -1 : compare([left], right)
compare(pair) = compare(first(pair), last(pair))

const part1 = sum(i for i in eachindex(pairs) if compare(pairs[i]) > -1)

const packets = reduce(vcat, pairs)
push!(packets, [[2]], [[6]])

@show length(packets)

const sorted = sort(packets, lt = (x, y) -> compare(x, y) > -1)

const part2 = findfirst(==([[2]]), sorted) * findfirst(==([[6]]), sorted)

@show part1, part2
