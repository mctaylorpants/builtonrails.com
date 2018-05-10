#!/usr/bin/ruby
# A quick way of pulling down a contributor's branch to
# test locally.
#
# Usage: `./pull_forked username:branchname

owner, branch = ARGV[0].split(':')
system %|git pull https://github.com/#{owner}/builtonrails.com #{branch}|
