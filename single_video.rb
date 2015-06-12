#!/usr/bin/env ruby

require 'qml'
require 'json'
require 'yaml'
require 'fileutils'

module Controller
  VERSION = '0.1'

  class Controller
    include QML::Access
    register_to_qml

    property :file
    property :markers, QML::Data::ArrayModel.new(:name,:time)

    def initialize
      super
      self.file = ARGV[0]
      f = file+".markers"
      YAML.load_file(f).each {|m| markers << m} if File.exists? f
    end

    def quit
      QML.application.quit
    end

    def positions
      markers.collect{|m| m[:time]}
    end

    def next_marker_position t
      larger = positions.select { |x| x >= t } 
      larger.min_by{|x| x-t}
    end

    def prev_marker_position t
      smaller = positions.select { |x| x <= t } 
      smaller.min_by{|x| t-x}
    end

    def add_marker n,t 
      self.markers << {:name => n, :time => t}
    end

    def reset_marker n, t 
      delete_marker n
      add_marker n,t 
    end

    def delete_marker n 
      i = markers.find_index{|m| m[:name] == n}
      while i
        markers.delete_at i
        i = markers.find_index{|m| m[:name] == n}
      end
    end

    def start
      r = markers.find{|m| m[:name] == "start"}
      r ? r[:time] : false
    end

    def ende
      r = markers.find{|m| m[:name] == "end"}
      r ? r[:time] : false
    end
    
    def save
      File.open(file+".markers","w+"){|f| f.puts markers.entries.to_yaml}
    end

  end
end

QML.run do |app|
  app.context[:controller] = Controller::Controller.new
  app.load_path Pathname(__FILE__) + '../SingleVideo.qml'
end
