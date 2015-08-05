class League < ActiveRecord::Base
  INSTANCE_ID = 1

  has_many :rules

  def self.current
    return find(INSTANCE_ID) if exists?(INSTANCE_ID)
    new(id: INSTANCE_ID).tap(&:save!)
  end

  def display_name
    name.present? ? name : "Desperado"
  end

  def all_rules
    rules.tap do |rules|
      Rule::KEYS.each do |key, ordinal|
        rules << Rule.new(key: key, ordinal: ordinal) unless rules.detect { |r| r.key == key.to_s }
      end
      rules.sort_by { |r| r.ordinal || 0 }
    end
  end
end
