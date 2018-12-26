require_relative './routific/location'
require_relative './routific/visit'
require_relative './routific/pickup_drop_off_visit'
require_relative './routific/break'
require_relative './routific/vehicle'
require_relative './routific/route'
require_relative './routific/way_point'
require_relative './routific/options'
require_relative './routific/job'

require_relative './util'

# Main class of this gem
class Routific
  attr_reader :visits, :fleet, :options
  @@token = nil

  # Constructor
  def initialize()
    Routific.validate_token
    @visits = {}
    @fleet = {}
    @options = {}
  end

  # Sets a visit for the specified location using the specified parameters
  # id: ID of location to visit
  # params: parameters for this visit
  def set_visit(id, params={})
    visits[id] = RoutificApi::Visit.new(id, params)
  end

  def set_pickup_dropoff_visit(id, params={})
    visits[id] = RoutificApi::PickupDropOffVisit.new(params)
  end

  # Sets a vehicle with the specified ID and parameters
  # id: vehicle ID
  # params: parameters for this vehicle
  def set_vehicle(id, params)
    fleet[id] = RoutificApi::Vehicle.new(id, params)
  end

  # Sets options with the specified params
  # params: parameters for these options
  def set_options(params)
    @options = RoutificApi::Options.new(params)
  end

  # Returns the route using the previously provided visits and fleet information
  def get_route
    data = {
      visits: visits,
      fleet: fleet
    }

    data[:options] = options if options
    result = Util.send_request("POST", endpoint, Routific.token, data)
    RoutificApi::Route.parse(result)
  end

  def get_route_async
    data = {
      visits: visits,
      fleet: fleet
    }
    data[:options] = options if options
    result = Util.send_request("POST", "#{endpoint}-long", Routific.token, data)
    RoutificApi::Job.new(result["job_id"], data)
  end

  private

  def endpoint
    if visits.values.any? { |v| v.is_a?(RoutificApi::PickupDropOffVisit) }
      "pdp"
    else
      "vrp"
    end
  end

  class << self
    # Sets the default access token to use
    def set_token(token)
      @@token = token
      validate_token
      @@token = Util.prefix_token(@@token)
    end

    def token
      @@token
    end

    def validate_token
      raise ArgumentError, "access token must be set" if @@token.nil?
    end

  end
end
