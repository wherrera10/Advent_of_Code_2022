""" advent of code 2022 day 25 """

const dtable = Dict{Char, Int}('2' => 2, '1' => 1, '0' => 0, '-' => -1, '=' => -2)

fromSNAFU(s) = evalpoly(5, reverse([dtable[c] for c in s]))

function toSNAFU(n)
    dig = digits(n, base = 5)
    str = ""
    carry = false
    for d in dig
        if carry
            d += 1
            carry = false
        end
        if d == 3
            str = "=" * str
            carry = true
        elseif d == 4
            str = "-" * str
            carry = true
        elseif d == 5
            str = "0" * str
            carry = true
        else
            str = string(d) * str
            carry = false
        end
    end
    return carry ? "1" * str : str
end

function part1()
    input = collect(readlines("day25.txt"))
    ssum = mapreduce(fromSNAFU, +, input)
    return toSNAFU(ssum)
end

@show part1()
