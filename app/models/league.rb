class League < ActiveRecord::Base
  INSTANCE_ID = 1

  def self.current
    return find(INSTANCE_ID) if exists?(INSTANCE_ID)
    new(id: INSTANCE_ID)
  end

  def display_name
    name.present? ? name : "Desperado"
  end
end
