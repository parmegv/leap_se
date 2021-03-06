set :application, "leap_se"
set :deploy_to, "/home/website/leap-website"
set :scm, :git
set :repo_url,  "https://leap.se/git/leap_se"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 2

# use system gems:
set :default_environment, {
  'GEM_PATH' => '',
  'GEM_HOME' => ''
}

namespace :leap do
  task :link_to_chiliproject do
    on roles(:all) do |host|
      execute "rm -f #{current_path}/public/code"
      execute "ln -s /var/www/redmine/public #{current_path}/public/code"
    end
  end
end

namespace :amber do
  task :rebuild do
    on roles(:all) do |host|
      within release_path do
        execute :amber, 'rebuild'
      end
    end
  end
end

after "deploy:updated", "amber:rebuild"
before "deploy:published", "leap:link_to_chiliproject"
