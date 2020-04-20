
require './features/support/logs.rb'
require './features/support/methods.rb'
require 'httparty'
require 'json'
require 'json-compare'
require 'uri'
require 'selenium-webdriver'
require 'zip'
require 'pg'

if ARGV.include?('Jenkins=true')
  $DbLogEnable  = ENV['DbLogEnable']
  $JenkinsRun   = true
else
  $DbLogEnable  = true
  $JenkinsRun   = false
end

if $DbLogEnable == nil
  $DbLogEnable = true
else
  $DbLogEnable = if $DbLogEnable.to_s.casecmp?('true')
                  true
                else
                  if $DbLogEnable.to_s.casecmp?('false')
                    false
                  else
                    error("Недопустимое значение DbLogEnable #{$DbLogEnable}")
                  end
                end
end