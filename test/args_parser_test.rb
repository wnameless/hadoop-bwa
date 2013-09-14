require 'test_helper'
require 'hadoop/bwa/args_parser'

class ArgsParserTest < Test::Unit::TestCase
  include Hadoop::Bwa::ArgsParser
  include Hadoop::Bwa::Errors
  
  def test_parse
    assert_equal ['test.fa'], parse('index test.fa')
  end
  
  def test_parse_error_1
    assert_raise InvalidCommandError do
      parse('nope')
    end
  end
  
  def test_parse_error_2
    assert_raise RequiredFilesMissingError do
      parse('index')
    end
  end
end