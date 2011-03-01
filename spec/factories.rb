# see https://gist.github.com/162881 for more information on this implementation of file attachements for rspec
require 'factory_attachement'
# By using the symbol :user we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                  "Andreas Stehling"
  user.email                 "hero@gmail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :blogpost do |blogpost|
  blogpost.title "The title"
  blogpost.subtitle "The subtitle"
  blogpost.content "The content."
  blogpost.association :user
  blogpost.photo_file_name :filename
  blogpost.photo_content_type "image/png"
  blogpost.photo_file_size "6646"
end
