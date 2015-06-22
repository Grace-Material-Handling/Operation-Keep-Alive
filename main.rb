#!/usr/bin/env ruby

# require nesesarry gems
require "date"
require "time"
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/zones'
require "nutshell-crm"

#configure
# config.rb

# nutshell credentials
$username = %x( echo $USERNAME )
$apiKey   = %x( echo $APIKEY )

# start app
require "./app.rb"