# LeapSeconds

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/dev/)

[![Test](https://github.com/JuliaTime/LeapSeconds.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/JuliaTime/LeapSeconds.jl/actions/workflows/Test.yml)
[![Coverage](https://codecov.io/gh/JuliaTime/LeapSeconds.jl/graph/badge.svg)](https://codecov.io/gh/JuliaTime/LeapSeconds.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*Leap seconds in Julia*

The last leap second was introduced on 2016-12-31, so TAI - UTC has been 37 s since 2017-01-01.
With [Resolution 5 of the 28th CGPM (2026)](https://doi.org/10.59161/CGPM2026RES5E), UTC becomes continuous on 2027-05-20, and the [IERS](https://www.iers.org/IERS/EN/Home/home_node.html) has announced that no leap second will be introduced at the end of December 2026 ([Bulletin C 72](https://datacenter.iers.org/data/16/bulletinc-072.txt)).
The table shipped with this package is therefore expected to be final. It remains necessary for converting any date between 1960 and the present.

## Installation

```julia
pkg> add LeapSeconds
```

## Usage

The package exports the two functions `offset_tai_utc` and `offset_utc_tai`
which return the difference between International Atomic Time (TAI) and
Coordinated Universal Time (UTC) or vice versa for a given date.
For dates after 1972-01-01, this is a whole number of seconds: the initial offset of 10 s plus the leap seconds introduced since then.

```julia
using LeapSeconds
using Dates

tai = DateTime(2017, 1, 1) # 2017-01-01T00:00:00.0 TAI

# Pass a `DateTime` instance...
offset_tai_utc(tai)

# ...or a Julian day number.
offset_tai_utc(datetime2julian(tai))

# Or use UTC...
utc = DateTime(2017, 1, 1) # 2017-01-01T00:00:00.0 UTC

# ...as a `DateTime`...
offset_utc_tai(utc)

# ...or a pseudo-Julian day number.
offset_utc_tai(datetime2julian(utc))
```

## Documentation

Please refer to the [documentation](https://juliatime.github.io/LeapSeconds.jl/stable)
for additional information.

