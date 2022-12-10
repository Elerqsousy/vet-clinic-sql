/* Populate database with sample data. */

INSERT INTO animals 
(name, date_of_birth, escape_attempts, neutered, weight_kg) 
VALUES
('Agumon', '20200203', 0, true, 10.23),
('Gabumon', '20181115', 2, true, 8),
('Pikachu', '20210107', 1, false, 15.04),
('Devimon', '20170512', 5, true, 11);

INSERT INTO animals
(name, date_of_birth, weight_kg, neutered, escape_attempts)
VALUES
('Charmander', '20200208', -11, false, 0),
('Plantmon', '20211115', -5.7, true, 2),
('Squirtle', '19930402', -12.13, false, 3),
('Angemon', '20050612', -45, true, 1),
('Boarmon', '20050607', 20.4, true, 7),
('Blossom', '19981013', 17, true, 3),
('Ditto', '20220514', 22, true, 4);


INSERT INTO owners (full_name, age) 
VALUES 
('Sam Smith', 34), 
('Jennifer Orwell', 19), 
('Bob', 45), 
('Melody Pond', 77), 
('Dean Winchester', 14),
('Jodie Whittaker', 38);

INSERT INTO species (name) 
VALUES 
('Pokemon'),('Digimon');

UPDATE animals
SET species_id = 1
WHERE name NOT LIKE '%mon';

UPDATE animals
SET species_id = 2
WHERE name LIKE '%mon';

UPDATE animals
SET owner_id = (SELECT id from owners where full_name = 'Sam Smith')
WHERE name = 'Agumon';

UPDATE animals
SET owner_id = (SELECT id from owners where full_name = 'Jennifer Orwell')
WHERE name IN ('Gabumon','Pikachu');

UPDATE animals
SET owner_id = (SELECT id from owners where full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon');

UPDATE animals
SET owner_id = (SELECT id from owners where full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

UPDATE animals
SET owner_id = (SELECT id from owners where full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon');

INSERT INTO vets(name,age,date_of_graduation) 
VALUES
('William Tatcher',45,'04-23-2000'),
('Maisy Smith',26,'01-17-2019'),
('Stephanie Mendez',64,'05-04-1981'),
('Jack Harkness',38,'06-08-2008');

INSERT INTO specializations(vets_id,species_id) 
VALUES
(1,1),
(3,2),
(3,1),
(4,2);

INSERT INTO visits(animal_id,vet_id,date_of_visit)
VALUES
(1,1,'2020-05-24'),
(1,3,'2020-07-22'),
(2,4,'2021-02-02'),
(3,2,'2020-01-05'),
(3,2,'05-14-2020'),
(3,2,'03-08-2020'),
(4,3,'05-04-2021'),
(5,4,'02-24-2021'),
(6,2,'12-21-2019'),
(6,1,'08-10-2020'),
(6,2,'04-07-2021'),
(7,3,'09-29-2019'),
(8,4,'10-03-2020'),
(8,4,'11-04-2020'),
(9,2,'01-24-2019'),
(9,2,'05-15-2019'),
(9,2,'02-27-2020'),
(9,2,'08-03-2020'),
(10,3,'05-24-2020'),
(10,1,'01-11-2021');