""" advent of code 2022 day 3 """

priority(ch) = findfirst(==(ch), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

rucksacks = strip.(split(read("day3.txt", String), "\n"))

sacklengths = map(length, rucksacks)

compartments = [(rucksacks[i][1:sacklengths[i] ÷ 2], rucksacks[i][sacklengths[i] ÷ 2 + 1:end]) for i in eachindex(rucksacks)]

dupes = [intersect(x[1], x[2])[1] for x in compartments]

part1 = sum(map(priority, dupes))

groups = [intersect(rucksacks[i:i+2]...)[1] for i in 1:3:length(rucksacks)-1]

part2 = mapreduce(priority, +, groups)

@show part1, part2
