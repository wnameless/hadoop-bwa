module Hadoop::Bwa
  module Errors
    class InvalidCommandError < Exception ; end
    class RequiredFilesMissingError < Exception ; end
  end
end