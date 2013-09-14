require 'active_support/core_ext/hash'
require 'hadoop/bwa/errors'

module Hadoop::Bwa
  module ArgsParser
    include Errors
    CMD_FORMAT = { index: [1],   mem: [2, 3],   aln: [2],
                   samse: [2], sampe: [5],    bwasw: [2] }.with_indifferent_access
    
    def parse(cmd)
      files = cmd.strip.split(/\s+/).delete_if { |co| co =~ /^-/ }
      cmd = files.shift
      if cmd !~ %r{#{CMD_FORMAT.keys.map { |c| "^#{c}$" }.join '|'}}
        raise InvalidCommandError, "Invalid command: #{cmd}."
      end
      unless CMD_FORMAT[cmd].include? files.size
        raise RequiredFilesMissingError,
          "Required #{CMD_FORMAT[cmd].join ' or '} file(s), " <<
          "#{CMD_FORMAT[cmd][0] - files.size} missing."
      end
      files
    end
  end
end