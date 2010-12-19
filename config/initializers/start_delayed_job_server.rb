require File.expand_path(File.join(File.dirname(__FILE__), '..', 'environment'))
require 'delayed/command'

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 1
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Command.new(['stop']).daemonize
Delayed::Command.new(['start']).daemonize
Kernel.at_exit do
  Delayed::Command.new(['stop']).daemonize
end
