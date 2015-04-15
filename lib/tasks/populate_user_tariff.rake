namespace :db do
  task :populate_user_tariff => :environment do
    User.where('expire_date <= ?', Date.today).update_all("tariff_type = 0, expire_date = null")
  end
end