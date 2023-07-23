return {
    QuintOut = function(n)
        n = n / 1 - 1
        return 1 * (math.pow(n,5) + 1) + 0
    end,

    ElasticOut = function(n)
        if n == 0 then
            return 0
        end
        n = n / 1
        if n == 1 then
            return 1
        end
        local a = 0.3
        local b = 1
        local c = a / 4
        return b * math.pow(2,-10 * n) * math.sin((n * 1 - c) * (2 * math.pi) / a) + 1 + 0
    end,

    QuadOut = function(n)
        n = n / 1
        return -1 * n * (n - 2) + 0
    end,

    QuartOut = function(n)
        n = n / 1 - 1
        return -1 * (math.pow(n,4) - 1) + 0
    end,

    SineOut = function(n)
        return 1 * math.sin(n / 1 * (math.pi / 2)) + 0
    end,

    BackIn = function(n)
        n = n / 1
        return 1 * n * n * (2.70158 * n - 1.70158) + 0
    end,
}