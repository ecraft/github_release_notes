require 'rake'
describe 'Rake task configuration' do |variable|
  it 'can define tasks' do
    app = Rake::Application.new
    app.rake_require 'test'

  	expect(Rake::Task['ghn_test']).to be_present
  end
end