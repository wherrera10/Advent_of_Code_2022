""" advent of code 2022 day 5 """

crates_text, moves_text = split(read("day5.txt", String), "\n\n")

clines = reverse(split(crates_text, "\n")[1:end-1])
ncols = (length(clines[1]) + 2) ÷ 4
cols = [Char[] for _ in 1:ncols]
for line in clines
    for i in 2:4:length(line)
        line[i] != ' ' && push!(cols[(i + 2) ÷ 4], line[i])
    end
end
cols2 = deepcopy(cols)

moves = Vector{Int}[]
for line in split(moves_text, "\n")
    push!(moves, [parse(Int, s) for s in match(r"(\d+)\D+(\d+)\D+(\d+)", line).captures])
end


for (num, source, dest) in moves
    for _ in 1:num
        push!(cols[dest], pop!(cols[source]))
    end
end

part1 = String(map(last, cols))

for (num, source, dest) in moves
    moved = Char[]
    for _ in 1:num
        push!(moved, pop!(cols2[source]))
    end
    append!(cols2[dest], reverse(moved))
end

part2 = String(map(last, cols2))


@show part1, part2



