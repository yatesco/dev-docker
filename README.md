# About

NOTE: this is developed on my personal home-lab and mirrored to <https://github.com/yatesco/dev-docker>.

A single docker image useful for building various projects on CI.

I find it annoying having to scrabble around for various docker images during CI and messing around with various tools, which all like their own configuration and ways of working.

I've consolidated on [mise](https://mise.jdx.dev/) for a while now, and use it both as a task runner and as a tool manager.

This docker image provides a good baseline on which to build projects which follow those assumptions.

[mise.toml](./mise.toml) achieves two objectives:

1. support for building this project (actually it isn't doing anything right now)
2. a baseline set of useful tools the docker should contain (e.g. a blessed version of [rust](https://www.rust-lang.org/))

##  Clarity about mise and tools

I want to keep as much commonality between local development and CI as possible. Not being able to reproduce a failure on CI locally is unfuriating, so the tools that are installed in this Docker image *are not interesting*. The tools that are installed *in mise* in this Docker image are the important ones.

Anything installed in the [Dockerfile](./Dockerfile) is needed *to allow mise to install it's tools*.

This means that as long as your CI builds and local development use mise, you should be much closer to avoiding "run's on my machine but not CI" issues.

## Day to day

It's rebuilt every day with tags for the day's build and also a "stable" tag *which will change*.
