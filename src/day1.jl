""" advent of code 2022 day 1 """

input = read("day1.txt", String)

burdens = [[parse(Int, strip(s)) for s in split(grouping, r"\s+")] for grouping in split(strip(input), "\n\n")]

max3 = sort(map(sum, burdens), rev = true)[1:3]

@show max3, sum(max3)

