require "./routes/ProjectsHandler.cr"
require "./routes/OAuth2Handler.cr"
require "./middleware/main.cr"
require "./struct/Error.cr"
require "multi_auth"
require "dotenv"
require "sqlite3"
require "kemal"

if File.exists?("../../.env")
  Dotenv.load("../../.env")
end

module Hypilus
  Database = DB.open "sqlite3://.storage/data.db"
  #Database = DB.open "mysql://#{ENV["MYSQL_USER"]}:#{ENV["MYSQL_PASSWORD"]}@#{ENV["MYSQL_IP"]}/hypilus"
  Database.exec "create table if not exists projects (name text, description text, author text, github_repository_url text)"
end

add_handler MainMiddleware::Handler.new
add_handler ProjectsHandler.new

error 404 do |env|
  Error.new(404).out(env)
end

error 500 do |env|
  Error.new(500).out(env)
end

Kemal.run
