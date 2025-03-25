# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Post.destroy_all

posts = [
  { title: "Getting Started with Rails", body: "This is a beginner's guide to Ruby on Rails, covering the basics of MVC and migrations." },
  { title: "Inertia.js with React Native", body: "Exploring how to integrate Inertia.js with React Native for a seamless mobile experience." },
  { title: "Why I Love Coding", body: "A personal reflection on the joys of programming and solving problems with code." },
  { title: "Deploying to Production", body: "Tips and tricks for deploying your Rails app to a production server like Heroku." },
  { title: "Understanding Expo SDK", body: "An overview of Expo SDK features and how it simplifies React Native development." }
]

posts.each do |post|
  Post.create!(
    title: post[:title],
    body: post[:body]
  )
end

puts "Seeded #{Post.count} posts successfully!"