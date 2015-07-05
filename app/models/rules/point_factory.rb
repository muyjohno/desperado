module Rules
  class PointFactory
    def self.points_for_result(result)
      "Rules::PointsFor#{result.to_s.camelize}".constantize.value
    end
  end
end
