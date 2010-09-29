require 'hirb'
Hirb.enable



# Print to yaml format with "y"
require 'yaml'
# Pretty printing
require 'pp'
# Tab completion
require 'irb/completion'
# Save irb sessions to history/file
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb.history"

# Non stdlib
require 'map_by_method'
require 'what_methods'
require 'interactive_editor'
