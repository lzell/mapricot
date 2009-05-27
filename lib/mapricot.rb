require 'rubygems'
require 'active_support/inflector'

module Mapricot
  VERSION = "0.0.4"
end

path = File.expand_path(File.join(File.dirname(__FILE__), 'mapricot'))

require File.join(path, 'base')
require File.join(path, 'abstract_doc')
require File.join(path, 'associations')
require File.join(path, 'attribute')
