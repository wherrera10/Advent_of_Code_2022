""" advent of code 2022 day 12 """

using Graphs

fromcart(col, row, ncols) = (row - 1) * ncols + col
tocart(idx, ncols) = (mod1(idx, ncols), (idx - 1) ÷ ncols + 1)

const heightmaplines = [collect(s) for s in strip.(split(read("day12.txt", String), "\n"))]
const mat = fill(' ', length(heightmaplines[1]), length(heightmaplines))
for row in axes(mat, 2), col in axes(mat, 1)
    mat[col, row] = heightmaplines[row][col]
end
const ncols, nrows = size(mat)
const npos = length(mat)
const startheight, destheight = 'a', 'z'

const cartS, cartE = findfirst(==('S'), mat), findfirst(==('E'), mat)
const graph = SimpleDiGraph(npos, 0)

function add_edges!(graph, mat, ncols, nrows, idx)
    hmax = mat[idx] == 'S' ? 'b' : Char(mat[idx] + 1)
    col, row = tocart(idx, ncols)
    row == 0 && (row = ncols)
    if col > 1 && mat[col - 1, row] <= hmax
        add_edge!(graph, idx, fromcart(col - 1, row, ncols))
    end
    if col < ncols && mat[col + 1, row] <= hmax
        add_edge!(graph, idx, fromcart(col + 1, row, ncols))
    end
    if row > 1 && mat[col, row - 1] <= hmax
        add_edge!(graph, idx, fromcart(col, row - 1, ncols))
    end
    if row < nrows && mat[col, row + 1] <= hmax
        add_edge!(graph, idx, fromcart(col, row + 1, ncols))
    end
end

for i in 1:length(mat)
    add_edges!(graph, mat, ncols, nrows, i)
end

const path = a_star(graph, fromcart(cartS[1], cartS[2], ncols), fromcart(cartE[1], cartE[2], ncols))
const part1 = length(path)
const astarts = filter(i -> mat[i] == ('a'), eachindex(mat))
const endp = fromcart(cartE[1], cartE[2], ncols)

leastnotzero(x) = (n = length(a_star(graph, x, endp)); n == 0 ? 1000 : n)

part2, idx = findmin(leastnotzero(startp) for startp in astarts)

@show part1, part2
