require 'active_support/core_ext/hash'
require 'hadoop/bwa/errors'

module Hadoop::Bwa
  # ArgsParser is used to parse BWA command arguments.
  # @author Wei-Ming Wu
  module ArgsParser
    # CMD_FORMAT defines the number of required files for each BWA command.
    CMD_FORMAT = { index: [1],   mem: [2, 3],   aln: [2],
                   samse: [3], sampe: [5],    bwasw: [2] }.with_indifferent_access
    include Errors
    
    # Returns required files for a BWA command after parsing arguments.
    #
    # @return [Array] an Array of required files
    def parse_args cmd
      args = cmd.strip.split(/\s+/)
      cmd = args.shift
      if cmd !~ %r{#{CMD_FORMAT.keys.map { |c| "^#{c}$" }.join '|'}}
        raise InvalidCommandError, "Invalid command: #{cmd}."
      end
      files = args.slice_before { |co| co =~ /^-/ }.to_a.last.delete_if { |co| co =~ /^-/ }
      files.shift while CMD_FORMAT[cmd].max < files.size
      files.keep_if { |file| file =~ /^\w+(\.\w+)+$/ } if cmd == 'mem'
      unless CMD_FORMAT[cmd].include? files.size
        raise RequiredFilesMissingError,
          "Required #{CMD_FORMAT[cmd].join ' or '} file(s), " <<
          "#{CMD_FORMAT[cmd][0] - files.size} missing."
      end
      files
    end
  end
end
