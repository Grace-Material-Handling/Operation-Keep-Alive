#!/usr/bin/env ruby

require 'rubygems'

# require nesesarry gems
require "date"
require "time"
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/zones'

require 'nutshell-crm-api'

# nutshell credentials
$username = ARGV[0]
$apiKey   = ARGV[1]

# start app
require "./app.rb"