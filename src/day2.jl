""" advent of code 2022 day 2 """

guidetext = strip.(split(read("day2.txt", String), "\n"))

values = Dict{String, Int}(
    "A X" => 1 + 3, "B X" => 1 + 0, "C X" => 1 + 6,
    "A Y" => 2 + 6, "B Y" => 2 + 3, "C Y" => 2 + 0,
    "A Z" => 3 + 0, "B Z" => 3 + 6, "C Z" => 3 + 3,
)

part1 = mapreduce(x -> values[x], +, guidetext)

translate2 = Dict{String, String}(
    "A X" => "A Z", "B X" => "B X", "C X" => "C Y",
    "A Y" => "A X", "B Y" => "B Y", "C Y" => "C Z",
    "A Z" => "A Y", "B Z" => "B Z", "C Z" => "C X",
)

part2 = mapreduce(x -> values[translate2[x]], +, guidetext)

@show part1, part2

