module Rules
  class Base
    def self.points
      0
    end

    def self.fetch(key)
      rule = Rule.find_by(key: key)
      return rule.value if rule
      nil
    end

    def self.value(key)
      @value ||= fetch(key)
    end

    class << self
      def key(key)
        define_singleton_method :value do
          super(key)
        end
      end
    end
  end
end
