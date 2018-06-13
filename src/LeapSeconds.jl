__precompile__()

module LeapSeconds

export leapseconds

include(joinpath("..", "gen", "leap_seconds.jl"))

# Constants for calculating the offset between TAI and UTC for
# dates between 1960-01-01 and 1972-01-01

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

function leapseconds(jd)
    # Before 1960-01-01
    if jd < 2.4369345e6
        return 0.0
    elseif jd < LS_EPOCHS[1]
        idx = searchsortedlast(EPOCHS, jd)
        return OFFSETS[idx] + (jd - DRIFT_EPOCHS[idx]) * DRIFT_RATES[idx]
    else
        return LEAP_SECONDS[searchsortedlast(LS_EPOCHS, jd)]
    end
end

leapseconds(dt::DateTime) = leapseconds(Dates.datetime2julian(dt))

end
