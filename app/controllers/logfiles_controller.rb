################################################################################
# controller for showing logfiles                                              #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: app/controllers/logfiles_controller.rb                                 #
################################################################################
class LogfilesController < ApplicationController
  def show
    app = params[:app]
    type = params[:type]

    redirect_to "/administration" if !checkParams app, type

    name = type.nil? ? app : app + "." + type
    @title = type.nil? ? app.capitalize : app.capitalize + " " + type.capitalize
    @file = getLogFile name
  end

  private
    def getLogFile name
      path = "log/#{name}.log"
      File.read path if File.file? path
    end

    # Parameter überprüfen
    def checkParams app, type
      params_allowed = {apps: ["mysql", "nginx", "production", "redis",
                                "socketio", "unicorn"],
                        types: ["access", "error", "stdout", "stderr"]}
      if !(params_allowed[:apps].include? app)
        false
      elsif !(params_allowed[:types].include? type) && !type.nil?
        false
      else
        true
      end
    end
end
