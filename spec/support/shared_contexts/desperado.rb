require "rake"

##
# Define a shared context that loads our "desperado" tasks.
#
# {Link Test Rake Tasks Like a BOSS}[https://robots.thoughtbot.com/test-rake-tasks-like-a-boss]
#
shared_context 'desperado' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/desperado" }
  subject         { rake[task_name] }

  def loaded_files
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files)

    Rake::Task.define_task(:environment)
  end
end
