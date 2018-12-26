module RoutificApi
  # This class represents a location to be visited
  class Visit
    attr_reader :id, :start, :end, :duration, :load, :location, :priority,
      :time_windows, :type

    # Constructor
    #
    # Optional arguments in params:
    # start: the earliest time for this visit. Default value is 00:00, if not specified.
    # end: the latest time for this visit. Default value is 23:59, if not specified.
    # duration: the length of this visit in minutes
    # load: the capacity that this visit requires
    # location: the location of the visit. Instance of Location
    def initialize(id, params = {})
      validate(params)
      @id = id
      @start = params["start"]
      @end = params["end"]
      @duration = params["duration"]
      @load = params["load"]
      @location = RoutificApi::Location.new(params["location"])
      @priority = params["priority"]
      @type = params["type"]
      if params["time_windows"]
        @time_windows = params["time_windows"].map{ |tw| TimeWindow.new(tw) }
      end
    end

    def to_json(options)
      as_json(options).to_json
    end

    # Returns the JSON representation of this object
    # def to_json(options = nil)
    def as_json(options = nil)
      json_data = {}
      json_data["start"] = self.start if self.start
      json_data["end"] = self.end if self.end
      json_data["duration"] = self.duration if self.duration
      json_data["load"] = self.load if self.load
      json_data["location"] = self.location.as_json
      json_data["priority"] = self.priority if self.priority
      json_data["type"] = self.type if self.type
      if self.time_windows
        json_data["time_windows"] = self.time_windows.map{ |tw| tw.as_json }
      end

      json_data
    end

    private
    # Validates the parameters being provided
    # Raises an ArgumentError if any of the required parameters is not provided.
    # Required parameters are: location
    def validate(params)
      if params["location"].nil?
        raise ArgumentError, "'location' parameter must be provided"
      end
    end

    public
    class TimeWindow
      attr_reader :start, :end

      # Constructor
      #
      # Optional arguments
      # start: start of the time-window
      # end: end of the time-window
      def initialize(params)
        @start = params["start"]
        @end = params["end"]
      end

      def ==(another_tw)
        self.start == another_tw.start &&
          self.end == another_tw.end
      end

      def as_json
        json_data = {}
        json_data["start"] = self.start if self.start
        json_data["end"] = self.end if self.end

        json_data
      end
    end
  end
end
