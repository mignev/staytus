class Stats

  def initialize(apiKey)
    @client = UptimeRobot::Client.new(apiKey: apiKey)
  end

  def getMonitors(monitors)
    Rails.cache.fetch(monitors, :expires => 1.hour) do
      @client.getMonitors(
        :monitors => monitors,
        :responseTimes => 1,
        :responseTimesAverage => 10,
        :customUptimeRatio => "1-7-30-365"
      )
    end
  end
end
