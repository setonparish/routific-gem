require_relative './visit'

module RoutificApi
  # This class represents a location to be visited
  class PickupDropOffVisit
    attr_reader :id, :pickup, :dropoff, :load, :type


    # Constructor
    #
    # Required arguments in params:
    # pickup_location: the location of the pickup. Instance of Location
    # dropoff_location: the location of the dropoff. Instance of Location
    # load: the capacity that this visit requires
    def initialize(id, params = {})
      validate(params)
      @id = id
      @pickup = RoutificApi::Visit.new(nil, params["pickup"])
      @dropoff = RoutificApi::Visit.new(nil, params["dropoff"])
      @load = params["load"]
      @type = params["type"]
    end

    def to_json(options)
      as_json(options).to_json
    end

    # Returns the JSON representation of this object
    # def to_json(options = nil)
    def as_json(options = nil)
      json_data = {}
      json_data["pickup"] = self.pickup.as_json if self.pickup
      json_data["dropoff"] = self.dropoff.as_json if self.dropoff
      json_data["load"] = self.load if self.load
      json_data["type"] = self.type if self.type
      json_data
    end

    private
    # Validates the parameters being provided
    # Raises an ArgumentError if any of the required parameters is not provided.
    # Required parameters are: location
    def validate(params)
      if params["pickup"].nil?
        raise ArgumentError, "'pickup' parameter must be provided"
      end
      if params["dropoff"].nil?
        raise ArgumentError, "'dropoff' parameter must be provided"
      end
    end
  end
end
