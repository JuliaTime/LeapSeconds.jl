module LeapSeconds

using Dates: DateTime, datetime2julian

export offset_tai_utc, offset_utc_tai

include("leap_seconds.jl")

const MJD_EPOCH = 2400000.5
const SECONDS_PER_DAY = 86400

# Constants for calculating the offset between TAI and UTC for
# dates between 1960-01-01 and 1972-01-01
# See ftp://maia.usno.navy.mil/ser7/tai-utc.dat

const EPOCHS = [
    36934,
    37300,
    37512,
    37665,
    38334,
    38395,
    38486,
    38639,
    38761,
    38820,
    38942,
    39004,
    39126,
    39887,
]

const OFFSETS = [
    1.417818,
    1.422818,
    1.372818,
    1.845858,
    1.945858,
    3.240130,
    3.340130,
    3.440130,
    3.540130,
    3.640130,
    3.740130,
    3.840130,
    4.313170,
    4.213170,
]

const DRIFT_EPOCHS = [
    37300,
    37300,
    37300,
    37665,
    37665,
    38761,
    38761,
    38761,
    38761,
    38761,
    38761,
    38761,
    39126,
    39126,
]

const DRIFT_RATES = [
    0.0012960,
    0.0012960,
    0.0012960,
    0.0011232,
    0.0011232,
    0.0012960,
    0.0012960,
    0.0012960,
    0.0012960,
    0.0012960,
    0.0012960,
    0.0012960,
    0.0025920,
    0.0025920,
]

leapseconds(mjd) = LEAP_SECONDS[searchsortedlast(LS_EPOCHS, floor(Int, mjd))]

"""
    offset_tai_utc(tai1, tai2=0.0)

Returns the difference between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given TAI Julian date `tai1 + tai2`.

The Julian date can be passed as a single number `tai1`, or split between `tai1` and `tai2` in any convenient way for increased precision, e.g., with `tai1` as the Julian day number and `tai2` as the fraction of the day.

``\\Delta AT = TAI - UTC``

# Examples

```jldoctest; setup = :(using LeapSeconds)
julia> offset_tai_utc(2457754.5) # 2017-01-01T00:00:00 TAI
37.0

julia> offset_tai_utc(2457754.0, 0.5) # The same date, split into day number and fraction
37.0
```
"""
function offset_tai_utc(tai1, tai2=0.0)
    mjd = tai1 - MJD_EPOCH + tai2

    # Before 1960-01-01
    if mjd < 36934.0
        @warn "UTC is not defined for dates before 1960-01-01."
        return 0.0
    end

    # Before 1972-01-01
    if mjd < LS_EPOCHS[1]
        idx = searchsortedlast(EPOCHS, floor(Int, mjd))
        rate_utc = DRIFT_RATES[idx] / SECONDS_PER_DAY
        rate_tai = rate_utc / (1 + rate_utc) * SECONDS_PER_DAY
        offset = OFFSETS[idx]
        Δt = mjd - DRIFT_EPOCHS[idx] - offset / SECONDS_PER_DAY
        return offset + Δt * rate_tai
    end

    leapseconds(mjd)
end

"""
    offset_tai_utc(dt::DateTime)

Returns the difference between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given `DateTime` in TAI.

``\\Delta AT = TAI - UTC``
"""
offset_tai_utc(dt::DateTime) = offset_tai_utc(datetime2julian(dt))

"""
    offset_utc_tai(utc1, utc2=0.0)

Returns the difference between Coordinated Universal Time (UTC) and
International Atomic Time (TAI) for a given UTC pseudo-Julian date `utc1 + utc2`.

The pseudo-Julian date can be passed as a single number `utc1`, or split between `utc1` and `utc2` in any convenient way for increased precision, e.g., with `utc1` as the Julian day number and `utc2` as the fraction of the day.

``\\Delta AT = UTC - TAI``

!!! note
    This function uses the [SOFA convention](https://juliaastro.org/SOFA/stable/api/timescales/#SOFA.dtf2d)
    for pseudo-Julian dates representing UTC dates during leap seconds.

# Examples

```jldoctest; setup = :(using LeapSeconds)
julia> offset_utc_tai(2457754.5) # 2017-01-01T00:00:00 UTC
-37.0

julia> offset_utc_tai(2457754.0, 0.5) # The same date, split into day number and fraction
-37.0
```
"""
function offset_utc_tai(utc1, utc2=0.0)
    mjd = utc1 - MJD_EPOCH + utc2

    # Before 1960-01-01
    if mjd < 36934.0
        @warn "UTC is not defined for dates before 1960-01-01."
        return 0.0
    end

    # Before 1972-01-01
    if mjd < LS_EPOCHS[1]
        idx = searchsortedlast(EPOCHS, floor(Int, mjd))
        offset = OFFSETS[idx] + (mjd - DRIFT_EPOCHS[idx]) * DRIFT_RATES[idx]
        return -offset
    end

    offset = 0.0
    for _ = 1:3
        offset = leapseconds(mjd + offset / SECONDS_PER_DAY)
    end
    return -offset
end

"""
    offset_utc_tai(dt::DateTime)

Returns the difference between Coordinated Universal Time (UTC) and
International Atomic Time (TAI) for a given `DateTime` in UTC.

``\\Delta AT = UTC - TAI``

!!! warning
    The `DateTime` type from Julia's Standard Libary cannot represent UTC dates
    during leap seconds, e.g. "2016-12-31T23:59:60.0" will not be parsed as a
    valid `DateTime` but throw an error.
    The [AstroTime.jl](https://github.com/JuliaAstro/AstroTime.jl) package
    provides a leap second-aware `Epoch` type that can be used as a replacement.
"""
offset_utc_tai(dt::DateTime) = offset_utc_tai(datetime2julian(dt))

end

