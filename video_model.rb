#!/usr/bin/env ruby

require 'qml'
require 'json'
require 'yaml'
require 'fileutils'

module Video

  class Model

    include QML::Access
    register_to_qml under: "VideoModel", version: "0.1"

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
      positions.select{|x| x >= t}.min_by{|x| x-t}
    end

    def prev_marker_position t
      positions.select{|x| x <= t}.min_by{|x| t-x}
    end

    def add_marker n,t 
      markers << {:name => n, :time => t}
      #markers.entries.uniq!
      #self.markers = self.markers.sort{|m| m[:time]} if markers
      print markers.entries.to_yaml.to_s
      print markers.entries.uniq.to_yaml.to_s
    end

    def reset_marker n, t 
      delete_markers n
      add_marker n,t 
    end

    def delete_markers n 
      i = markers.find_index{|m| m[:name] == n}
      while i
        markers.delete_at i
        i = markers.find_index{|m| m[:name] == n}
      end
    end

    def delete_marker_before t
      t = prev_marker_position t
      i = markers.find_index{|m| m[:time] == t}
      while i
        markers.delete_at i
        i = markers.find_index{|m| m[:time] == t}
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
      File.open(file+".markers","w+"){|f| f.puts markers.entries.uniq.sort_by{|m| m[:time]}.to_yaml }
    end

  end
end
