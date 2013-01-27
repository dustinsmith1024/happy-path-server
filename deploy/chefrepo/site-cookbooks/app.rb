application "responsiveshots" do
  path "/usr/local/www/responsiveshots"

  rails do 
    database do
      database "responsiveshots"
      username "dustin"
      password "dustin"
    end
    database_master_role "responsiveshots_database_master"
  end

  passenger_apache2 do
  end
end