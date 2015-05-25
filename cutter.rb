#!/usr/bin/env ruby

require 'qml'
require 'fileutils'

module Controller
  VERSION = '0.1'

  class Controller
    include QML::Access
    register_to_qml

    property :current, ''

    def initialize
      super
      @dir = "/media/phone/home/nemo/Videos/Camera/"
      @files = Dir[File.join(@dir,"*.mp4")]
      @bak = File.join(@dir,"bak")
      @cut = File.join(@dir,"cut")
      @delete = File.join(@dir,"delete")
      [@bak,@cut,@delete].each{|d| FileUtils.mkdir_p d}
      self.current = @files.first
    end


    def shift
      self.current = @files.first
    end

    def cut s,e
      pid = fork {
        out = File.join(@cut,File.basename(self.current))
        puts `mencoder #{self.current} -o #{out} -ss #{s/1000} -endpos #{(e-s)/1000} -nosound -ovc copy &`
        FileUtils.mv self.current ,@bak
      }
      Process.detach pid
      shift
    end

    def delete
      FileUtils.mv self.current ,@delete
    end

    def quit
      QML.application.quit
    end

  end
end

QML.run do |app|
  app.context[:controller] = Controller::Controller.new
  app.load_path Pathname(__FILE__) + '../cutter.qml'
end
