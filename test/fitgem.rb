#!/usr/bin/env ruby
require 'httparty'
require 'multi_json'

class FitbitAccount
  include HTTParty
  @@base_uri = 'api.fitbit.com/1/user'

  def initialize()
    @access_token = `echo -n $FB_ACCESS_TOKEN`
    @user_id = `echo -n $FB_USER_ID`

    if @access_token == "" && @user_id == ""
      puts "We need some information. It will be saved"
      print "Copy your Access Token: "
      @access_token = gets.chomp

      print "Copy your User ID: "
      @user_id = gets.chomp

      system( "clear" ) # Clears Screen
      # system( "echo \"export FB_ACCESS_TOKEN=#{@access_token}\" >> ~/.bashrc")
      @authorization_header = {"Authorization" => "Bearer #{@access_token}"}
    end
  end

  def steps
    @response = self.class.get("https://#{@@base_uri}/#{@user_id}/activities/steps/date/today/1d/1min.json",
      :headers => {"Authorization" => "Bearer #{@access_token}"})
    @parsed_response = MultiJson.load(@response.body)
    @parsed_response = @parsed_response["activities-steps"][0]["value"].to_i
  end

  def floors
    @response = self.class.get("https://#{@@base_uri}/#{@user_id}/activities/floors/date/today/1d/1min.json",
      :headers => {"Authorization" => "Bearer #{@access_token}"})
    @parsed_response = MultiJson.load(@response.body)
    @parsed_response = @parsed_response["activities-floors"][0]["value"].to_i
  end

  def cals_out
    @response = self.class.get("https://#{@@base_uri}/#{@user_id}/activities/calories/date/today/1d/1min.json",
      :headers => {"Authorization" => "Bearer #{@access_token}"})
    @parsed_response = MultiJson.load(@response.body)
    @parsed_response = @parsed_response["activities-calories"][0]["value"].to_i
  end

  def distance
    @response = self.class.get("https://#{@@base_uri}/#{@user_id}/activities/distance/date/today/1d/1min.json",
      :headers => {"Authorization" => "Bearer #{@access_token}"})
    @parsed_response = MultiJson.load(@response.body)
    @parsed_response = @parsed_response["activities-distance"][0]["value"]
  end

  def full_report
    # Full Report
    puts "Full Report:\n-------"
    puts "#{self.steps} steps"
    puts "#{self.distance} miles"
    puts "#{self.floors} stairs climbed"
    puts "#{self.cals_out} calories burned"
  end

  def hello
    return "Hello, World!"
  end

  def help
    puts "NAME"
    puts "    fitgem - A simple Fitbit CLI\n"
    puts "SYNOPSIS"
    puts "    fitgem SHORT-OPTION"
    puts "    fitgem LONG-OPTION\n"
    puts "DESCRIPTION"
    puts "    steps (s) -- Output steps"
    puts "    distance (d) -- Output distance (miles)"
    puts "    floors (f) -- Output climbed floors"
    puts "    calories (c) -- Output calories burned"
    puts "    all (a) -- Output a full report"
    puts "    full -- Same as all or a"
    puts "    help (?) -- Output this help. Same as leaving blank\n"
    puts "BUGS"
    puts "    Please report any bugs to the bug tracker on Github at http://github.com/juniorRubyist/fitgem."
    puts "\nLICENSE"
    puts "    This software is released under the MIT License.\n"
    puts "AUTHOR"
    puts "    Joseph Geis <geis28@gmail.com> (see files AUTHORS for details)."
  end
end

fitgem = FitbitAccount.new()

choice = ARGV[0]
case choice
when 'steps', 's'
  puts fitgem.steps
when 'distance', 'd'
  puts fitgem.distance
when 'floors', 'f'
  puts fitgem.floors
when 'calories', 'c'
  puts calories
when 'full', 'all', 'a'
  fitgem.full_report
when 'help', 'h', '?'
  fitgem.help
else
  fitgem.help
end
