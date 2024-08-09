namespace :assets do
  namespace :precompile do
    task :set_env do
      puts "Setting NODE environment"
      ENV['NODE_OPTIONS'] = '--openssl-legacy-provider'
    end
  end
end

Rake::Task["assets:precompile"].enhance(["assets:precompile:set_env"])
