require 'active_record'

configure :production, :development, :test do
  db = URI.parse('mysql://root@localhost/demo')

  ActiveRecord::Base.establish_connection(
    :adapter  => 'mysql2',
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
