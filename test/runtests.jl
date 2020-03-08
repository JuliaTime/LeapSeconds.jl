using LeapSeconds
using Dates: DateTime, Month, year, month, day, datetime2julian
using ERFA
using Test

@testset "Leap Seconds" begin
    @testset "Definitions" begin
        tai = ERFA.dtf2d("TAI", 2020, 1, 1, 0, 0, 37.0)
        utc = ERFA.dtf2d("UTC", 2020, 1, 1, 0, 0, 0.0)
        @test offset_tai_utc(tai...) == (tai[2] - utc[2]) * LeapSeconds.SECONDS_PER_DAY
        @test offset_utc_tai(utc...) == (utc[2] - tai[2]) * LeapSeconds.SECONDS_PER_DAY
    end
    @testset "Warning for pre-UTC dates" begin
        msg = "UTC is not defined for dates before 1960-01-01."
        @test (@test_logs (:warn, msg) offset_tai_utc(DateTime(1959,1,1,))) == 0.0
        @test (@test_logs (:warn, msg) offset_utc_tai(DateTime(1959,1,1,))) == 0.0
    end
    @testset "All leap seconds" begin
        @testset for dt in DateTime(1960,1,1):Month(1):DateTime(2018,12,1)
            y = year(dt)
            m = month(dt)
            d = day(dt)
            jd = datetime2julian(dt)
            @test offset_utc_tai(jd) ≈ -ERFA.dat(y, m, d, 0.0)
            Δt = offset_utc_tai(jd) / LeapSeconds.SECONDS_PER_DAY
            @test offset_utc_tai(jd) ≈ -offset_tai_utc(jd - Δt) atol=1e-12
        end
    end
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
            @test abs(offset_utc_tai(utc...)) ≈ abs(offset_tai_utc(tai...)) atol=1e-14
            @test utc_jd - diff_utc_tai - tai_jd ≈ 0.0 atol=1e-9
            @test tai_jd - diff_tai_utc - utc_jd ≈ 0.0 atol=1e-9
        end
    end
end
