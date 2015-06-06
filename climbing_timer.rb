#!/usr/bin/env ruby

require 'qml'
require 'fileutils'

module Controller
  VERSION = '0.1'

  class Controller
    include QML::Access
    register_to_qml

    property :files, []

    def initialize
      super
      self.files = ARGV
    end


    def quit
      QML.application.quit
    end

  end
end

QML.run do |app|
  app.context[:controller] = Controller::Controller.new
  app.load_path Pathname(__FILE__) + '../ClimbingTimer.qml'
end
