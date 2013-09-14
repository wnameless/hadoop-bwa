require 'test_helper'
require 'hadoop/bwa/errors'

class InstanceTest < Test::Unit::TestCase
  HADOOP_HOME = File.join File.dirname(__FILE__), 'hadoop'
  include Hadoop::Bwa::Errors
  
  def test_new
    orig_hadoop_home = ENV['HADOOP_HOME']
    ENV['HADOOP_HOME'] = HADOOP_HOME
    hadoop_bwa = Hadoop::Bwa.new bwa: '/usr/local/bin/bwa'
    assert_equal HADOOP_HOME, hadoop_bwa.hadoop_home
    hadoop_bwa = Hadoop::Bwa.new hadoop_home: HADOOP_HOME, bwa: '/usr/local/bin/bwa'
    assert_equal HADOOP_HOME, hadoop_bwa.hadoop_home
    ENV['HADOOP_HOME'] = orig_hadoop_home
  end
  
  def test_new_with_option
    Hadoop::Bwa.new hadoop_home: HADOOP_HOME, bwa: '/usr/local/bin/bwa'
  end
  
  def test_new_error
    assert_raise HadoopNotFoundError do
      Hadoop::Bwa.new bwa: '/usr/local/bin/bwa'
    end
  end
end