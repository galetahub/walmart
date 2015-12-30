require 'walmart/application'
require 'pathname'

module Walmart
  def self.root_path
    @root_path ||= Pathname.new( File.dirname(File.expand_path('../', __FILE__)) )
  end
end
