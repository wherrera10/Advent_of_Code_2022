""" advent of code 2022 day 11 """

const MONKEYS = [
    Dict(
        :items => [83, 97, 95, 67],
        :op => (old) -> old * 19,
        :test => (n) -> n % 17 == 0 ? 2 : 7,
        :inspections => 0,
    ),
    Dict(
        :items => [71, 70, 79, 88, 56, 70],
        :op => (old) -> old + 2,
        :test => (n) -> n % 19 == 0 ? 7 : 0,
        :inspections => 0,
    ),
    Dict(
        :items => [98, 51, 51, 63, 80, 85, 84, 95],
        :op => (old) -> old + 7,
        :test => (n) -> n % 7 == 0 ? 4 : 3,
        :inspections => 0,
    ),
    Dict(
        :items => [77, 90, 82, 80, 79],
        :op => (old) -> old + 1,
        :test => (n) -> n % 11 == 0 ? 6 : 4,
        :inspections => 0,
    ),
    Dict(
        :items => [68],
        :op => (old) -> old * 5,
        :test => (n) -> n % 13 == 0 ? 6 : 5,
        :inspections => 0,
    ),
    Dict(
        :items => [60, 94],
        :op => (old) -> old + 5,
        :test => (n) -> n % 3 == 0 ? 1 : 0,
        :inspections => 0,
    ),
    Dict(
        :items => [81, 51, 85],
        :op => (old) -> old * old,
        :test => (n) -> n % 5 == 0 ? 5 : 1,
        :inspections => 0,
    ),
    Dict(
        :items => [98, 81, 63, 65, 84, 71, 84],
        :op => (old) -> old + 3,
        :test => (n) -> n % 2 == 0 ? 2 : 3,
        :inspections => 0,
    ),
]

let

    monkeys = deepcopy(MONKEYS)

    for round in 1:20
        for m in monkeys
            for i in m[:items]
                worry = m[:op](i) ÷ 3
                push!(monkeys[m[:test](worry) + 1][:items], worry)
                m[:inspections] += 1
            end
            empty!(m[:items])
        end
    end

    inspections = sort([m[:inspections] for m in monkeys])

    part1 = prod(inspections[end-1:end])

    monkeys = deepcopy(MONKEYS)

    modval = 2 * 5 * 3 * 13 * 11 * 7 * 19 * 17

    for round in 1:10_000
        for m in monkeys
            for i in m[:items]
                worry = m[:op](i)
                push!(monkeys[m[:test](worry) + 1][:items], worry % modval)
                m[:inspections] += 1
            end
            empty!(m[:items])
        end
    end

    inspections = sort([m[:inspections] for m in monkeys])

    part2 = prod(inspections[end-1:end])

    @show part1, part2


end

