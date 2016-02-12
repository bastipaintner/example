class LogfilesController < ApplicationController
  def show
    app = params[:app]
    type = params[:type]

    if !checkParams app, type       # wenn keine oder falsche Parameter
                                    # übergeben wurden
      redirect_to "/administration" # dann leite weiter an Root
    end

    # Bestimmung des Namens mit oder ohne Typ
    name = type.nil? ? app : app + "." + type
    # Bestimmung des Seitentitels
    @title = type.nil? ? app.capitalize : app.capitalize + " " + type.capitalize
    # Einlesen des Logfiles
    @file = getLogFile name
  end

  private
    # Einlesen des Logfiles
    def getLogFile name
      path = "log/#{name}.log" # Bestimmung des Dateipfads
      begin
        File.read path # Einlesen
      rescue # bei Fehler
        "Dieses Logfile existiert nicht!"
      end
    end

    # Parameter überprüfen
    def checkParams app, type
      # Erlaubte Parameter
      params_allowed = {apps: ["mysql", "nginx", "production", "redis",
                                "socketio", "unicorn"],
                        types: ["access", "error", "stdout", "stderr"]}
      # wenn App nicht erlaubt
      if !(params_allowed[:apps].include? app)
        false
      # wenn Typ nicht erlaubt
      elsif !(params_allowed[:types].include? type) && !type.nil?
        false
      # wenn beides erlaubt
      else
        true
      end
    end
end
