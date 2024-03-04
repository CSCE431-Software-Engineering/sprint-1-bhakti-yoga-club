# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

if Rails.env.development?
    # Seed development-specific data
    # ...
  elsif Rails.env.test?
    Member.create!(
        email: "test@example.com",
        title: "DefaultMember",
        is_active_paid_member: false,
        is_admin: false
      )
      
      Member.create!(
        email: "admin@example.com",
        full_name: "John Doe",
        title: "DefaultMember",
        is_active_paid_member: true,
        is_admin: true,
        date_joined: "2024-02-29"
      )
      
      Member.create!(
        email: "test2@example.com",
        full_name: "John Doe",
        title: "DefaultMember",
        is_active_paid_member: true,
        is_admin: false,
        date_joined: "2024-02-29"
      )
      
  end
  