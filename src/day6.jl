""" advent of code 2022 day 6 """

stream = read("day6.txt", String)

@show stream

part1 = findfirst(i -> length(unique(stream[i:i+3])) == 4, 1:length(stream)-3) + 3

part2 = findfirst(i -> length(unique(stream[i:i+13])) == 14, 1:length(stream)-3) + 13

