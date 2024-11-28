# Advent Of Code 2024

Advent Of Code 2024 Solutions in Zig (version 0.13.0)

## Basic Usage

The `template` folder contains, obviously, the template for a single day's problems. The
`create_day` script will conveniently copy-paste the template to a new day for you, including
changing the output binary name to match the day.

For example: `create_day 5` creates a folder named `5` which contains a Zig project setup to build a
`day5` binary.

## Using the templates

Each day is a standalone Zig project, containing a `build.zig` file, a `main.zig` file, and `.txt`
files for the problem input. The `test.txt` file is intended for the sample input, while the
`input.txt` file is intended for your unique input.

Within `main.zig` there are placeholder functions for `part1` and `part2`, and a `main()` which runs
both parts (and helpfully times them for you). There are also two tests, one for each part; you can
use these to check your solution against the sample input and solution given in the problem
statements. Just change the line `const answer: usize = 0;` to the expected answer.

The template also creates a `utils` module from the `common` folder in the root; this can be used to
store generically useful algorithms and data structures to speed up your problem solving. The
template `main.zig` file imports this module as `utils`.

## Build & Run

```sh
./create_day 5
cd 5
zig build test # Build and run the tests
zig build run  # Build and run main()
```

Sample output for unit tests:

```sh
AdventOfCode2023/5$ zig build test --summary all
test
└─ run test stderr
[AoC] (warn):  -- Running Tests --
[AoC] (warn): [Test] Part 1: 0
[AoC] (warn): [Test] Part 2: 0
Build Summary: 3/3 steps succeeded; 2/2 tests passed
test success
└─ run test 2 passed 737us MaxRSS:1M
   └─ zig test Debug native cached 6ms MaxRSS:37M
```

Sample output for for the full input:

```sh
AdventOfCode2023/5$ zig build run
info(aoc): Part 1 answer: << 0 >>
info(aoc): Part 1 took 0.000010s
info(aoc): Part 2 answer: << 0 >>
info(aoc): Part 2 took 0.000004s
```
