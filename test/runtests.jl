using LeapSeconds
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

using ERFA

@testset "Leap Seconds" begin
    @test leapseconds(DateTime(1959,1,1,)) == 0.0
    for dt = DateTime(1960,1,1):Dates.Month(1):DateTime(2018,12,1)
        year = Dates.year(dt)
        month = Dates.month(dt)
        day = Dates.day(dt)
        @test leapseconds(dt) ≈ ERFA.dat(year, month, day, 0.0)
    end
end
