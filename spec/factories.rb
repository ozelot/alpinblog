# By using the symbol :user we get Factory Girl to simulate the User model
Factory.define :user do |user|
  user.name                  "Andreas Stehling"
  user.email                 "stehling.andreas@gmail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
