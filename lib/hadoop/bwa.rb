require 'hadoop/bwa/version'
require 'hadoop/bwa/runner'

# Module Hadoop defines a namespace for Hadoop Ruby Utils
module Hadoop
  # Hadoop::Bwa includes tools to run BWA on Hadoop Streaming.
  # @author Wei-Ming Wu
  module Bwa
    # Creates a Hadoop::Bwa::Runner.
    #
    # @return [Runner] a Runner object
    def self.new opts = {}
      Runner.new opts
    end
  end
end
