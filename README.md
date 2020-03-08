# LeapSeconds

*Leap seconds in Julia*

[![Stable Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/stable)
[![Dev Docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliatime.github.io/LeapSeconds.jl/dev)
[![Build Status](https://travis-ci.org/JuliaTime/LeapSeconds.jl.svg?branch=master)](https://travis-ci.org/JuliaTime/LeapSeconds.jl)
[![Windows Build Status](https://ci.appveyor.com/api/projects/status/b3b6ji2bo70448ex?svg=true)](https://ci.appveyor.com/project/helgee/leapseconds-jl)
[![codecov.io](http://codecov.io/github/JuliaTime/LeapSeconds.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaTime/LeapSeconds.jl?branch=master)

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

