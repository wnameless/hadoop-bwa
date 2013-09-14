require 'hadoop/bwa/version'
require 'hadoop/bwa/runner'

module Hadoop
  module Bwa
    def self.new opts = {}
      Runner.new opts
    end
  end
end