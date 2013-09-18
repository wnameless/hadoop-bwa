require 'test_helper'
require 'hadoop/bwa/errors'

class RunnerTest < Test::Unit::TestCase
  HADOOP_HOME = File.join File.dirname(__FILE__), 'hadoop'
  include Hadoop::Bwa::Errors
  
  def setup
    @runner = Hadoop::Bwa.new hadoop_home: HADOOP_HOME, bwa: '/usr/local/bin/bwa'
  end
  
  def test_new
    orig_hadoop_home = ENV['HADOOP_HOME']
    ENV['HADOOP_HOME'] = HADOOP_HOME
    hadoop_bwa = Hadoop::Bwa.new bwa: '/usr/local/bin/bwa'
    assert_equal HADOOP_HOME, hadoop_bwa.hadoop_home
    hadoop_bwa = Hadoop::Bwa.new hadoop_home: HADOOP_HOME, bwa: '/usr/local/bin/bwa'
    assert_equal HADOOP_HOME, hadoop_bwa.hadoop_home
    ENV['HADOOP_HOME'] = orig_hadoop_home
  end
  
  def test_new_error
    assert_raise HadoopNotFoundError do
      Hadoop::Bwa.new bwa: '/usr/local/bin/bwa'
    end
  end
  
  def test_streaming_statement
    expect = "#{HADOOP_HOME}/bin/hadoop jar " <<
      "#{HADOOP_HOME}/contrib/streaming/hadoop-streaming-1.1.1.jar " <<
      "-files hdfs://127.0.0.1:54310/user/test.fa " <<
      "-input hdfs://127.0.0.1:54310/user/hadoop-bwa-streaming-input.txt " <<
      "-output \"/user/hadoop/hadoop-bwa-index #{Time.now.to_s.split(/\s+/).first(2).join ' '}\" " <<
      "-mapper \"/usr/local/bin/bwa index\" " <<
      "-reducer NONE"
      
    assert_equal expect, @runner.streaming_statement('index', '/user/hadoop', ['test.fa'])
  end
  
  def test_streaming_aln
    expect = "#{HADOOP_HOME}/bin/hadoop jar " <<
      "#{HADOOP_HOME}/contrib/streaming/hadoop-streaming-1.1.2.jar " <<
      "-files hdfs://192.168.1.198:54310/user/hadoop/dna_71_5000.fa,hdfs://192.168.1.198:54310/user/hadoop/testdata_1_1.fq" <<
      "-input hdfs://192.168.1.198:54310/user/hadoop/hadoop-bwa-streaming-input.txt " <<
      "-output \"/user/hadoop/hadoop-bwa-aln }\" " <<
      "-mapper \"/usr/local/bin/bwa aln\" " <<
      "-reducer NONE"
    
    assert_equal expect, @runner.streaming_statement('aln', '/user/hadoop', ['dna_71_5000.fa','testdata_1_1.fq']) 
  end 
  
  def test_streaming_sampe
    expect = "#{HADOOP_HOME}/bin/hadoop jar " <<
      "#{HADOOP_HOME}/contrib/streaming/hadoop-streaming-1.1.2.jar " <<
      "-files hdfs://192.168.1.198:54310/user/hadoop/dna_71_5000.fa,hdfs://192.168.1.198:54310/user/hadoop/sai1.sai,hdfs://192.168.1.198:54310/user/hadoop/sai2.sai,hdfs://192.168.1.198:54310/user/hadoop/testdata_1_1.fq,hdfs://192.168.1.198:54310/user/hadoop/testdata_2_1.fq" <<
      "-input hdfs://192.168.1.198:54310/user/hadoop/hadoop-bwa-streaming-input.txt " <<
      "-output \"/user/hadoop/hadoop-bwa-sampe }\" " <<
      "-mapper \"/usr/local/bin/bwa sampe\" " <<
      "-reducer NONE"
    
    assert_equal expect, @runner.streaming_statement('sampe', '/user/hadoop', ['dna_71_5000.fa','sai1.sai','sai2.sai','testdata_1_1.fq','testdata_2_1.fq']) 
  end
  
end
