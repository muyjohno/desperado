namespace :desperado do

  desc "Import achievements into the DB."
  task :import_achievements, [:data_file] => :environment do |_, args|
    File.open(args.data_file, "r") do |data|
      achievements = Psych.load_stream data
      Achievement.transaction do
        Achievement.create! achievements
      end
      puts "Imported #{achievements.length} achievements."
    end
  end
end
