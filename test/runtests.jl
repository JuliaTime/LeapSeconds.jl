using LeapSeconds
using Dates: DateTime, Month, year, month, day
using ERFA
using Test

@testset "Leap Seconds" begin
    @testset "Warning for pre-UTC dates" begin
        msg = "UTC is not defined for dates before 1960-01-01."
        @test (@test_logs (:warn, msg) offset_tai_utc(DateTime(1959,1,1,))) == 0.0
    end
    # @testset "All leap seconds" begin
    #     @testset for dt in DateTime(1960,1,1):Month(1):DateTime(2018,12,1)
    #         y = year(dt)
    #         m = month(dt)
    #         d = day(dt)
    #         @test offset_tai_utc(dt) ≈ ERFA.dat(y, m, d, 0.0)
    #     end
    # end
    @testset "During leap seconds" begin
        @testset for dt in ((1963, 7, 23, 14, 12, 3.0),
                            (2012, 6, 30, 23, 59, 59.0),
                            (2012, 6, 30, 23, 59, 60.0),
                            (2012, 6, 30, 23, 59, 60.5),
                            (2012, 7, 1, 0, 0, 0.0),
                           )
            utc = ERFA.dtf2d("UTC", dt...)
            utc_jd = sum(utc)
            tai = ERFA.utctai(utc...)
            tai_jd = sum(tai)
            diff_utc_tai = offset_utc_tai(utc_jd) / LeapSeconds.SECONDS_PER_DAY
            diff_tai_utc = offset_tai_utc(tai_jd) / LeapSeconds.SECONDS_PER_DAY
            @test abs(offset_utc_tai(utc_jd)) ≈ abs(offset_tai_utc(tai_jd)) atol=1e-14
            @show offset_utc_tai(utc_jd)
            @show offset_tai_utc(tai_jd)
            @show (tai_jd - utc_jd) * LeapSeconds.SECONDS_PER_DAY
            @test utc_jd - diff_utc_tai - tai_jd ≈ 0.0 atol=1e-8
            @test tai_jd - diff_tai_utc - utc_jd ≈ 0.0 atol=1e-8
        end
    end
end
