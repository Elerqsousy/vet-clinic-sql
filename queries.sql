-- Find all animals whose name ends in "mon".
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals
WHERE date_of_birth BETWEEN '20160101' and '20200101';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals 
WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals
WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals
WHERE weight_kg >= 10.4 and weight_kg <= 17.3;

-------------------------------------------------------------------
BEGIN;
UPDATE animals
SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
UPDATE animals
SET species = 'pokemon'
WHERE name NOT LIKE '%mon';
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals
WHERE date_of_birth > '20220101';
SAVEPOINT sp1;
UPDATE animals
SET weight_kg = weight_kg*-1;
ROLLBACK TO sp1;
UPDATE animals
SET weight_kg = weight_kg*-1
WHERE weight_kg < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) FROM animals
GROUP BY neutered;
-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '19900101' AND '20210101'
GROUP BY species;

------------------------------------------------------------------------

-- What animals belong to Melody Pond?
SELECT name, full_name AS owner FROM animals
INNER JOIN owners ON owner_id = owners.id
WHERE owners.full_name =  'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, species.name AS species FROM animals
INNER JOIN species ON species_id = species.id
WHERE species.name =  'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name as owner_name, animals.name as pet_name FROM animals
FULL JOIN owners ON owner_id = owners.id;

-- How many animals are there per species?
SELECT species.name AS species, COUNT(species.name) FROM animals
JOIN species ON species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name FROM animals
INNER JOIN owners ON owner_id = owners.id
INNER JOIN species ON species_id = species.id
WHERE owners.full_name =  'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT name, full_name AS owner FROM animals
INNER JOIN owners ON owner_id = owners.id
WHERE owners.full_name =  'Dean Winchester' AND escape_attempts=0;

-- Who owns the most animals?
SELECT full_name FROM (SELECT full_name, COUNT(animals.name) as animals_count FROM animals
INNER JOIN owners ON owner_id = owners.id
GROUP BY owners.full_name) AS animals_per_owner 
WHERE animals_count = (SELECT max(animals_count) FROM (SELECT full_name, COUNT(animals.name) as animals_count FROM animals
INNER JOIN owners ON owner_id = owners.id
GROUP BY owners.full_name) AS animals_per_owner);

---------------------------------------------------------------------------------------

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, visits.date_of_visit FROM animals 
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON vets.id = visits.vet_id 
WHERE vets.id = 1 
ORDER BY date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals.name) FROM animals 
JOIN visits ON animals.id = visits.animal_id 
JOIN vets ON vets.id = visits.vet_id 
WHERE vets.id = 3;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets 
JOIN specializations ON vets.id = specializations.vets_id 
JOIN species ON specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name FROM animals 
JOIN visits ON animals.id = visits.animal_id 
JOIN vets ON vets.id = visits.vet_id 
WHERE vets.id = 3 AND visits.date_of_visit >= '04-01-2020' AND visits.date_of_visit <='08-30-2020';

-- What animal has the most visits to vets?
SELECT COUNT(*) FROM visits 
JOIN animals ON animals.id = visits.animal_id 
GROUP BY animals.name;

-- Who was Maisy Smith's first visit?
SELECT animals.name FROM animals 
JOIN visits ON animals.id = visits.animal_id 
JOIN vets ON vets.id = visits.vet_id
 WHERE vets.id = 2 
 ORDER BY visits.date_of_visit LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.*, vets.*, visits.date_of_visit FROM visits 
LEFT JOIN animals ON animals.id = visits.animal_id 
LEFT JOIN vets ON vets.id = visits.vet_id
ORDER BY visits.date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM visits 
JOIN vets ON vets.id = visits.vet_id 
WHERE vets.id = 2;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(visits.animal_id) FROM visits 
JOIN vets ON visits.vet_id = vets.id FULL 
JOIN animals ON visits.animal_id = animals.id 
JOIN species ON species.id = animals.species_id 
WHERE vets.id = 2 GROUP BY species.name;
