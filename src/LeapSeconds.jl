module LeapSeconds

using Dates: DateTime, datetime2julian

export offset_tai_utc

include(joinpath("..", "gen", "leap_seconds.jl"))

# Constants for calculating the offset between TAI and UTC for
# dates between 1960-01-01 and 1972-01-01
# See ftp://maia.usno.navy.mil/ser7/tai-utc.dat

const EPOCHS = [
    2.4369345e6,
    2.4373005e6,
    2.4375125e6,
    2.4376655e6,
    2.4383345e6,
    2.4383955e6,
    2.4384865e6,
    2.4386395e6,
    2.4387615e6,
    2.4388205e6,
    2.4389425e6,
    2.4390045e6,
    2.4391265e6,
    2.4398875e6,
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
    2.4373005e6,
    2.4373005e6,
    2.4373005e6,
    2.4376655e6,
    2.4376655e6,
    2.4387615e6,
    2.4387615e6,
    2.4387615e6,
    2.4387615e6,
    2.4387615e6,
    2.4387615e6,
    2.4387615e6,
    2.4391265e6,
    2.4391265e6,
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

"""
    offset_tai_utc(jd)

Returns the offset between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given Julian Date `jd`. For dates after
1972-01-01, this is the number of leap seconds.
"""
function offset_tai_utc(jd)
    # Before 1960-01-01
    if jd < 2.4369345e6
        @warn "UTC is not defined for dates before 1960-01-01."
        return 0.0
    end

    # Before 1972-01-01
    if jd < LS_EPOCHS[1]
        idx = searchsortedlast(EPOCHS, jd)
        return OFFSETS[idx] + (jd - DRIFT_EPOCHS[idx]) * DRIFT_RATES[idx]
    end

    LEAP_SECONDS[searchsortedlast(LS_EPOCHS, jd)]
end


"""
    offset_tai_utc(dt::DateTime)

Returns the offset between International Atomic Time (TAI) and Coordinated
Universal Time (UTC) for a given `DateTime`. For dates after
1972-01-01, this is the number of leap seconds.
"""
offset_tai_utc(dt::DateTime) = offset_tai_utc(datetime2julian(dt))

end

