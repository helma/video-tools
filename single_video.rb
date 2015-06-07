#!/usr/bin/env ruby

require 'qml'
require 'fileutils'

module Controller
  VERSION = '0.1'

  class Controller
    include QML::Access
    register_to_qml

    property :files, []
    #/property :markers, [0]
    property(:markers) { QML::Data::ArrayModel.new(:t) }

    def initialize
      super
      self.files = ARGV
      self.markers << {:t => 5000}
    end

    def quit
      QML.application.quit
    end

    def add_marker(m)
      self.markers << {:t => m}
      #p markers
    end

  end
end

QML.run do |app|
  app.context[:controller] = Controller::Controller.new
  app.load_path Pathname(__FILE__) + '../SingleVideo.qml'
end
