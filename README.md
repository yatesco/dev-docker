# About

A single docker image useful for building various projects.

I find it annoying having to scrabble around for various docker images during CI and messing around with various tools, which all like their own configuration and ways of working.

I've consolidated on [mise](https://mise.jdx.dev/) for a while now, and use it both as a task runner and as a tool manager.

This docker image provides a good baseline on which to build projects which follow those assumptions.

[mise.toml](./mise.toml) achieves two objectives:

1. support for building this project (actually it isn't doing anything right now)
2. a baseline set of useful tools the docker should contain (e.g. a blessed version of [rust](https://www.rust-lang.org/))

## Day to day

It's rebuilt every day with tags for the day's build and also a "stable" tag *which will change*.
