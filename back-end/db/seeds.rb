puts "Clearing old data..."
Category.destroy_all
Task.destroy_all

puts "Seeding Categories..."

c1 = Category.create(name: "Code")
c2 = Category.create(name: "Food")
c3 = Category.create(name: "Money")
c4 = Category.create(name: "Misc")

# create categories

puts "Seeding tasks..."

20.times do
    Task.create(text:Faker::Lorem.paragraph,category:[c1,c2,c3,c4].sample)
end

# create tasks

puts "Done!"