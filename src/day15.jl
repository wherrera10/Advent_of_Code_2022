""" advent of code 2022 day 15 """

manhattan(x0, y0, x1, y1) = abs(x1 - x0) + abs(y1 - y0)
manhattan(p1, p2) = manhattan(p1[1], p1[2], p2[1], p2[2])

# x is columns, y is rows; data is x then y pairs, 2 pairs per row
const a = [parse(Int, m.match) for m in eachmatch(r"[1234567890-]+", read("day15.txt", String))]
const sensors, beacons = [[a[i], a[i + 1]] for i in 1:4:length(a)-1], [[a[i], a[i + 1]] for i in 3:4:length(a)]
const trow, nsensors = 2_000_000, length(sensors)
const mdists = [manhattan(sensors[i], beacons[i]) for i in 1:nsensors]
const beaconsontrow = length(unique([b for b in beacons if b[2] == trow]))

function exclusions(sensornum, row)
    d = mdists[sensornum]
    x, y = sensors[sensornum]
    dy = abs(y - row)
    dx = d - dy
    return dx < 0 ? (1:0) : x - dx : x + dx
end

function exclusions(row)
    allranges = filter!(r -> r != 1:0, sort!([exclusions(i, row) for i in 1:nsensors]))
    condensed = [copy(first(allranges))]
    for r in allranges[2:end]
        if condensed[end].stop < r.stop
            if r.start < condensed[end].stop + 2
                condensed[end] = condensed[end].start:r.stop
            else
                push!(condensed, copy(r))
            end
        end
    end
    return condensed
end

const part = [0, 0]

part[1] = sum(map(length, exclusions(trow))) - beaconsontrow  # subtract beacons on row
println("part1 = ", part[1])

for row in 0:4_000_000
    rangesfound = exclusions(row)
    if length(rangesfound) > 1  # break in exclusions present in condensed row ranges
        part[2] = (rangesfound[begin].stop + 1) * 4_000_000 + row
        break
    end
end

println("part2 = ", part[2])
