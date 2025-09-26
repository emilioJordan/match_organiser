# Clear existing data
User.destroy_all
Match.destroy_all
Participation.destroy_all

# Create users
organizer1 = User.create!(
  name: "Max Müller",
  email: "max@example.com",
  password: "passw0rd",
  password_confirmation: "passw0rd",
  role: "organizer"
)

organizer2 = User.create!(
  name: "Sarah Schmidt",
  email: "sarah@example.com", 
  password: "passw0rd",
  password_confirmation: "passw0rd",
  role: "organizer"
)

player1 = User.create!(
  name: "Tom Weber",
  email: "tom@example.com",
  password: "passw0rd", 
  password_confirmation: "passw0rd",
  role: "player"
)

player2 = User.create!(
  name: "Lisa Fischer",
  email: "lisa@example.com",
  password: "passw0rd",
  password_confirmation: "passw0rd", 
  role: "player"
)

player3 = User.create!(
  name: "Mike Johnson",
  email: "mike@example.com",
  password: "passw0rd",
  password_confirmation: "passw0rd",
  role: "player"
)

# Create matches
match1 = Match.create!(
  title: "Weekly Football Match",
  description: "Our regular Tuesday evening football match. All skill levels welcome!",
  date: Date.current + 3.days,
  time: Time.parse("19:00"),
  location: "Central Park Football Field",
  created_by: organizer1
)

match2 = Match.create!(
  title: "Basketball Tournament",
  description: "3v3 basketball tournament. Prizes for winners!",
  date: Date.current + 7.days,
  time: Time.parse("14:00"),
  location: "Sports Center Basketball Court",
  created_by: organizer2
)

match3 = Match.create!(
  title: "Volleyball Beach Session",
  description: "Casual beach volleyball session. Bring your sunscreen!",
  date: Date.current + 10.days,
  time: Time.parse("16:00"),
  location: "City Beach Volleyball Courts",
  created_by: organizer1
)

# Create participations
Participation.create!(user: player1, match: match1, status: "confirmed")
Participation.create!(user: player2, match: match1, status: "confirmed") 
Participation.create!(user: player3, match: match1, status: "declined")

Participation.create!(user: player1, match: match2, status: "pending")
Participation.create!(user: player2, match: match2, status: "confirmed")

Participation.create!(user: player3, match: match3, status: "confirmed")

puts "Seed data created successfully!"
puts "Users created: #{User.count}"
puts "Matches created: #{Match.count}"
puts "Participations created: #{Participation.count}"
