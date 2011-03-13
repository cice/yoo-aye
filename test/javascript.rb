#!/usr/bin/env ruby

require 'rubygems'
require 'sprockets'

yoo_ay_js = File.expand_path("../../app/javascripts/lib/yoo_ay.js", __FILE__)

secretary = Sprockets::Secretary.new :source_files => [yoo_ay_js]

file = File.expand_path("../javascript/yoo_ay.js", __FILE__)

File.open(file, "w+") do |f|
  f.write secretary.concatenation.to_s
end

system 'open javascript/index.html'