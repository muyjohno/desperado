namespace :desperado do

  desc 'Import achievements into the DB.'
  task :achievements_import, [:data_file] => :environment do |_, args|
    data_file = "#{Rails.root}/#{args.data_file}"
    File.open(data_file, 'r') do |data|
      achievements = Psych.load_stream data
      Achievement.transaction do
        Achievement.create! achievements
      end
      puts "Imported #{achievements.length} achievements."
    end
  end

end
