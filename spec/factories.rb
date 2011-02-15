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
end
