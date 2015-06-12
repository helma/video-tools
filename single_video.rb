#!/usr/bin/env ruby

require 'qml'
require 'json'
require 'yaml'
require 'fileutils'
require_relative 'marker'

QML.run do |app|
  app.context[:marker] = Video::Marker.new
  app.load_path Pathname(__FILE__) + '../SingleVideo.qml'
end
