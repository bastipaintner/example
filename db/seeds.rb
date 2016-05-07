################################################################################
# seed for database                                                            #
#                                                                              #
# author: Sebastian Paintner                                                   #
#                                                                              #
# path: db/seeds.rb                                                            #
################################################################################
# trains
for n in 301..308 do
  name = n
  traintype = 1
  Train.create!(name: name,
                traintype_id: traintype)
end

for n in 310..348 do
  name = n
  traintype = 1
  Train.create!(name: name, traintype_id: traintype)
end

for n in 351..371 do
  name = n
  traintype = 1
  Train.create!(name: name, traintype_id: traintype)
end

for n in 501..535 do
  name = n
  traintype = 1
  Train.create!(name: name, traintype_id: traintype)
end

for n in 551..572 do
  name = n
  traintype = 1
  Train.create!(name: name, traintype_id: traintype)
end

for n in 601..618 do
  name = n
  traintype = 2
  Train.create!(name: name, traintype_id: traintype)
end

for n in 701..721 do
  name = n
  traintype = 2
  Train.create!(name: name, traintype_id: traintype)
end

for n in 996..998 do
  name = n
  traintype = 3
  Train.create!(name: name, traintype_id: traintype)
end

# traintypes
Traintype.create!(name: "A")
Traintype.create!(name: "B")
Traintype.create!(name: "C")

# users
User.create!(name: "admin",
            password: "PW12345",
            password_confirmation: "PW12345",
            admin: true)

User.create!(name: "leitwarte",
            password: "PW12345",
            password_confirmation: "PW12345",
            admin: false)
