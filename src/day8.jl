""" advent of code 2022 day 8 """

const lines = split(read("day8.txt", String), "\n")

const mat = zeros(UInt8, length(lines), length(lines[1]))
const visibles = deepcopy(mat)
for (row, line) in enumerate(lines)
    mat[row, :] .= [parse(Int, s) for s in collect(line)]
end

const nrows, ncols = size(mat)

function isvisible(row, col, mat)
    height = mat[row, col]
    return row == 1 || all(r -> mat[r, col] < height, 1:row-1) ||
       row == nrows || all(r -> mat[r, col] < height, row+1:nrows) ||
       col == 1 || all(c -> mat[row, c] < height, 1:col-1) ||
       col == ncols || all(c -> mat[row, c] < height, col+1:ncols)
end

part1 = sum(isvisible(r, c, mat) for r in 1:nrows, c in 1:ncols)


function scenic_score(row, col, mat)
    height = mat[row, col]
    up = row == 1 ? 1 : something(findfirst(>=(height), reverse(mat[1:row-1, col])), row - 1)
    down = row == nrows ? 1 : something(findfirst(>=(height), mat[row+1:nrows, col]), nrows - row)
    left = col == 1 ? 1 : something(findfirst(>=(height), reverse(mat[row, 1:col-1])), col - 1)
    right = col == ncols ? 1 : something(findfirst(>=(height), mat[row, col+1:ncols]), ncols - col)
    return up * down * right * left
end

part2 = maximum(scenic_score(r, c, mat) for r in 1:nrows, c in 1:ncols)

@show part1, part2
