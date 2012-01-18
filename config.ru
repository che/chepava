# encoding: utf-8

require 'rubygems'
require File.dirname(File.expand_path(__FILE__)) + '/lib/chepava'


CHEPAVA.init

map CHEPAVA::SEPARATOR do
  run CHEPAVA::Site
end