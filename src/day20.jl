""" advent of code 2022 day 20 """


""" circular move at position for distance arr2[2] """
function circmove(arr2, pos)
    a = deepcopy(arr2)
    len, p = length(a), a[pos]
    m = p[2]
    m == 0 && return a
    m = mod1(m, (len - 1))
    return m + pos > len ?
       [a[begin:m-len+pos]; [p]; a[m-len+pos+1:pos-1]; a[pos+1:end]] :
       [a[begin:pos-1]; a[pos+1:pos+m]; [p]; a[pos+m+1:end]]
end

""" circular move all positions X times after multiplying by key, as a decoding """
function decode(arr, key = 1, times = 1)
    arr2 = [p for p in enumerate(arr .* key)]
    newarr2 = copy(arr2)
    for _ in 1:times, (i, n) in arr2
        idx = findfirst(p -> p[1] == i, newarr2)
        newarr2 = circmove(newarr2, idx)
   end
    return [p[2] for p in newarr2]
end

const part = [0, 0]
const input = [parse(Int, s) for s in split(read("day20.txt", String), r"\s+")]

const part1arr = decode(input)
const zeropos = findfirst(==(0), part1arr)
part[1] = sum(i -> part1arr[mod1(zeropos + i, length(arr))], [1000, 2000, 3000])

const part2arr = decode(input, 811589153, 10)
const zeropos2 = findfirst(==(0), part2arr)
part[2] = sum(i -> part2arr[mod1(zeropos2 + i, length(arr))], [1000, 2000, 3000])

@show part

