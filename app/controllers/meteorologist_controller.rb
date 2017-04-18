require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================
    fmt_address = @street_address.gsub(/\s/,'+')
    main_url = "http://maps.googleapis.com/maps/api/geocode/json?address="
    final_url = main_url + fmt_address
    parsed_data_loc = JSON.parse(open(final_url).read)

    lat = parsed_data_loc["results"][0]["geometry"]["location"]["lat"]
    lng = parsed_data_loc["results"][0]["geometry"]["location"]["lng"]

    base_url_weather="https://api.darksky.net/forecast/56146600599f984a5c3a1d1bb2dab3a2/"
    final_url_weather =  base_url_weather + lat.to_s + "," + lng.to_s
    parsed_data_weather = JSON.parse(open(final_url_weather).read)

    @current_temperature = parsed_data_weather["currently"]["temperature"]

    @current_summary = parsed_data_weather["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_weather["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data_weather["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data_weather["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
