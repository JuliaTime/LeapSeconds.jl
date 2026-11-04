# LeapSeconds

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/dev/)

[![Test](https://github.com/JuliaTime/LeapSeconds.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/JuliaTime/LeapSeconds.jl/actions/workflows/Test.yml)
[![Coverage](https://codecov.io/gh/JuliaTime/LeapSeconds.jl/graph/badge.svg)](https://codecov.io/gh/JuliaTime/LeapSeconds.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

*Leap seconds in Julia*

**A new minor version of this package will be published everytime a new leap second
is issued be the [IERS](https://www.iers.org/IERS/EN/Home/home_node.html) and dependent
packages will need to be updated!**

## Installation

```julia
pkg> add LeapSeconds
```

## Usage

The package exports the two functions `offset_tai_utc` and `offset_utc_tai`
which return the difference between International Atomic Time (TAI) and
Coordinated Universal Time (UTC) or vice versa for a given date.
For dates after 1972-01-01, this is the number of leap seconds.

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

