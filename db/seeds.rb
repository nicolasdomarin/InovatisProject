# create default test user
User.create!(name: "Admin Inovatis", email: "inovatis@example.com", password: "123456789", password_confirmation: "123456789", admin: true)
