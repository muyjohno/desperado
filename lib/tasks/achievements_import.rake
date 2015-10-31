namespace :desperado do

  desc 'Import achievements into the DB.'
  task :achievements_import, [:data_file] => :environment do |_, args|
    File.open("#{Rails.root}/#{args.data_file}", 'r') do |data|
      achievements = Psych.load_stream data
      achievements.each do |achievement|
        Achievement.create achievement
      end
      puts "Imported #{achievements.length} achievements."
    end
  end

end
