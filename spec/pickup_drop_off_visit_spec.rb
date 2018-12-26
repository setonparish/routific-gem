require_relative './helper/spec_helper'

describe RoutificApi::Location do
  subject(:visit) { Factory::PICKUP_DROP_OFF_VISIT }

  describe "valid parameters" do
    it "has id" do
      expect(visit.id).to eq(Factory::PICKUP_DROP_OFF_VISIT_ID)
    end

    it "has pickup" do
      aggregate_failures do
        expect(visit.pickup).to be_an_instance_of(RoutificApi::Visit)
        expect(visit.pickup.location.lat).to eq(Factory::PICKUP_VISIT_LOCATION["lat"])
        expect(visit.pickup.location.lng).to eq(Factory::PICKUP_VISIT_LOCATION["lng"])
      end
    end

    it "has dropoff" do
      aggregate_failures do
        expect(visit.dropoff).to be_an_instance_of(RoutificApi::Visit)
        expect(visit.dropoff.location.lat).to eq(Factory::DROP_OFF_VISIT_LOCATION["lat"])
        expect(visit.dropoff.location.lng).to eq(Factory::DROP_OFF_VISIT_LOCATION["lng"])
      end
    end

    it "has type" do
      expect(visit.type).to eq(Factory::SINGLE_TYPE)
    end

    it "has load" do
      expect(visit.load).to eq(Factory::PICKUP_DROP_OFF_VISIT_LOAD)
    end
  end

  describe "#as_json" do
    subject(:visitJSON) { visit.as_json() }

    it "can be reconverted to JSON" do
      expect { visitJSON }.to_not raise_error
    end

    it "has pickup" do
      expect(visitJSON["pickup"]).to eq({ "location" =>
        { "lat" => Factory::PICKUP_VISIT_LOCATION["lat"], "lng" => Factory::PICKUP_VISIT_LOCATION["lng"] }
       })
    end

    it "has dropoff" do
      expect(visitJSON["dropoff"]).to eq({ "location" =>
        { "lat" => Factory::DROP_OFF_VISIT_LOCATION["lat"], "lng" => Factory::DROP_OFF_VISIT_LOCATION["lng"] }
       })
    end

    it "has load" do
      expect(visitJSON["load"]).to eq(Factory::PICKUP_DROP_OFF_VISIT_LOAD)
    end

    it "has type" do
      expect(visitJSON["type"]).to eq(Factory::SINGLE_TYPE)
    end
  end
end
