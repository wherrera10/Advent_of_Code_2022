""" advent of code 2022 day 4 """

assignments = strip.(split(read("day4.txt", String), "\n"))
caps = Vector{Int}[]
for line in assignments
    push!(caps, map(s -> parse(Int, s), match(r"(\d+)\-(\d+),(\d+)\-(\d+)", line).captures))
end

contained = filter(a -> (a[1] <= a[3] && a[2] >= a[4]) || (a[3] <= a[1] && a[4] >= a[2]), caps)

part1 = length(contained)

haveoverlap = filter(a -> (r = intersect(a[1]:a[2], a[3]:a[4]); r.start <= r.stop), caps)

part2 = length(haveoverlap)

@show part1, part2

