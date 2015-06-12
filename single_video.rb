#!/usr/bin/env ruby

require 'qml'
require 'json'
require 'yaml'
require 'fileutils'
require_relative 'video_model'

QML.run do |app|
  app.context[:model] = Video::Model.new
  app.load_path Pathname(__FILE__) + '../SingleVideo.qml'
end
