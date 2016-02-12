# Trains
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

Traintype.create!(name: "A")
Traintype.create!(name: "B")
Traintype.create!(name: "C")

User.create!(name: "admin",
            password: "SWM12345",
            password_confirmation: "SWM12345",
            admin: true)

User.create!(name: "leitwarte",
            password: "SWM12345",
            password_confirmation: "SWM12345",
            admin: false)
