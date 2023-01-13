""" advent of code 2022 day 21 """


const values = Dict{String, Int}()
const functions = Dict("+" => +, "*" => *, "/" => ÷, "-" => -)
const mpairs = Dict{String, Tuple{String, Function, String}}()

for line in readlines("day21.txt")
    s = split(line, r"[\s|\:]+")
    if length(s) == 2
        values[s[1]] = parse(Int, s[2])
    else
        mpairs[s[1]] = (s[2], functions[s[3]], s[4])
    end
end

const values1 = deepcopy(values)
const mpairs1 = deepcopy(mpairs)
while !haskey(values1, "root")
    for (m, (m1, f, m2)) in mpairs1
        if !haskey(values1, m) && haskey(values1, m1) && haskey(values1, m2)
            values1[m] = f(values1[m1], values1[m2])
        end
    end
end

const part = [0, 0]
part[1] = values1["root"]
@show part[1]

function part2(rang)
    for n in rang
        values2 = deepcopy(values)
        mpairs2 = deepcopy(mpairs)
        values2["humn"] = n
        while !haskey(values2, "root")
            for (m, (m1, f, m2)) in mpairs2
                if !haskey(values2, m) && haskey(values2, m1) && haskey(values2, m2)
                    values2[m] = f(values2[m1], values2[m2])
                    if m == "root"
                        values2[m1] == values2[m2] && return n
                        @show n, values2[m2] - values2[m1]
                        break
                    end
                end
            end
        end
    end
    error("no solution in $rang")
end

# found by adjusting range argument by hand
# since delta change is linear, bracket the flip negative to positive
part[2] = part2(3_006_709_232_464:3_006_709_232_470)
@show part[2]
