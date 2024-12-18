# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


a = User.new(name: "Esteban11", email: "esteban@hacker.com", password: "uwu232", password_confirmation: "uwu232", birth_date: "2006-11-16 00:00:00.000000000 +0000")
a.save!

admin_test = User.new(name: "Admin", email: "admin@supersafedomain.io", password: "safety", password_confirmation: "safety", birth_date: "2006-11-16 00:00:00.000000000 +0000", superuser: true)
admin_test.save!

deportes = Category.new(name: "Deportes")
musica = Category.new(name: "Musica")
libros = Category.new(name: "Libros")
cine = Category.new(name: "Cine")
gamers = Category.new(name: "Gamers")
otakus = Category.new(name: "Otakus")
foodies = Category.new(name: "Foodies")
otros = Category.new(name: "Otros")
deportes.save!
musica.save!
libros.save!
cine.save!
gamers.save!
otakus.save!
foodies.save!
otros.save!

grupo_1 = Group.new(category_id: 6, user_id: 1, name: "Grupootaku7", rating: 4.5, description: "Un grupo de ejemplo.")
grupo_1.save!

actividad_1 = Activity.new(group_id: 1, name: "Actividaddeejemplo", description: "Una actividad de ejemplo.", location: "Calle de ejemplo", date: "2024-04-22 18:01:18.000000000 +0000", keywords: "ejemplo", cost: 1.0, people: 1)
actividad_1.save!
