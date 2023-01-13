""" advent of code 2022 day 18 """

let 
    
    coords = [split(strip(line), ",") .|> x -> parse(Int, x) for line in readlines("day18.txt")]
    coords = map(p -> [p[1] + 1, p[2] + 1, p[3] + 1], coords)
    nlines = length(coords)
    sarea = nlines * 6

    for i in 1:nlines-1, j in i+1:nlines
        deltas = abs.(coords[i] .- coords[j])
        if count(deltas .== 0) == 2 && count(deltas .== 1) == 1
            sarea -= 2
        end
    end
    part1 = sarea

    xmax = maximum(c[1] for c in coords) + 1
    ymax = maximum(c[2] for c in coords) + 1
    zmax = maximum(c[3] for c in coords) + 1

    arr = zeros(UInt8, xmax, ymax, zmax)
    for p in coords
        arr[p[1], p[2], p[3]] = 2
    end
    arr[1, 1, 1] = 1
    while true
        onecount = count(==(1), arr)
        for x in 1:xmax, y in 1:ymax, z in 1:zmax # floodfill
            if arr[x, y, z] == 1
                if x > 1 && arr[x - 1, y, z] == 0
                    arr[x - 1, y, z] = 1
                end
                if x < xmax && arr[x + 1, y, z] == 0
                    arr[x + 1, y, z] = 1
                end
                if y > 1 && arr[x, y - 1, z] == 0
                    arr[x, y - 1, z] = 1
                end
                if y < ymax && arr[x, y + 1, z] == 0
                    arr[x, y + 1, z] = 1
                end
                if z > 1 && arr[x, y, z - 1] == 0
                    arr[x, y, z - 1] = 1
                end
                if z < zmax && arr[x, y, z + 1] == 0
                    arr[x, y, z + 1] = 1
                end
            end
        end
        newcount = count(==(1), arr)
        onecount == newcount && break
        onecount = newcount
    end

    newcoords = empty(coords)
    for c in CartesianIndices(arr)
        if arr[c] == 0 # internal void
            push!(newcoords, [c[1], c[2], c[3]])  # fill in non-flood-filled spaces
        end
    end
    newlines = length(newcoords)
    newsarea = newlines * 6
    for i in 1:newlines-1, j in i+1:newlines
        deltas = abs.(newcoords[i] .- newcoords[j])
        if count(deltas .== 0) == 2 && count(deltas .== 1) == 1
            newsarea -= 2
        end
    end
    part2 = sarea - newsarea

    @show part1, part2

end

