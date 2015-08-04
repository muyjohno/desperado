module Rules
  class PointFactory
    def self.points_for_result(result)
      Rule.value_for("points_for_#{result}") || 0
    end
  end
end
