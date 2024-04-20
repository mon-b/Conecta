# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


a = User.new(name: "Esteban11", email: "esteban@hacker.com", password: "uwu232", password_confirmation: "uwu232", birth_date: "2006-11-16 00:00:00.000000000 +0000")
a.save!

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

