module LeapSeconds

using Dates: DateTime, datetime2julian

export offset_tai_utc, offset_utc_tai

include(joinpath("..", "gen", "leap_seconds.jl"))

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
    offset_tai_utc(jd)

Returns the offset between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given Julian Date `jd`. For dates after
1972-01-01, this is the number of leap seconds.
"""
function offset_tai_utc(jd, jd1=0.0)
    mjd = jd - MJD_EPOCH + jd1

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

function offset_utc_tai(jd, jd1=0.0)
    mjd = jd - MJD_EPOCH + jd1

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
    offset_tai_utc(dt::DateTime)

Returns the offset between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given `DateTime`. For dates after
1972-01-01, this is the number of leap seconds.
"""
offset_tai_utc(dt::DateTime) = offset_tai_utc(datetime2julian(dt))

end

