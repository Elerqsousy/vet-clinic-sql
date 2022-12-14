-- Find all animals whose name ends in "mon".
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals
WHERE date_of_birth BETWEEN '20160101' AND '20200101';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals 
WHERE neutered AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT name, date_of_birth AS DOB FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals 
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered;

-- Find all animals not named Gabumon.
SELECT * FROM animals
WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals
WHERE 17.3 >= weight_kg AND weight_kg >= 10.4;

-------------------------------------------------------------------
BEGIN;
UPDATE animals
SET species = 'unspecified';
ROLLBACK;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals
WHERE date_of_birth > '20220102';
SAVEPOINT sp1;
UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO sp1;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(name) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(name) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type 
-- of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '19900101' AND '20010101'
GROUP BY species;

------------------------------------------------------------------------

-- What animals belong to Melody Pond?
SELECT name FROM animals
INNER JOIN owners on owners.id = owner_id
WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM animals 
LEFT JOIN species s ON species_id = s.id
WHERE s.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT full_name AS owner, name AS pet FROM animals a
FULL JOIN owners o ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT COUNT(a.name), s.name FROM animals a
FULL JOIN species s ON species_id = s.id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT a.name FROM animals a 
LEFT JOIN owners o ON o.id = a.owner_id
LEFT JOIN species s ON s.id = a.species_id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM animals a
FULL JOIN owners o ON o.id = owner_id
WHERE o.full_name = 'Dean Winchester' AND escape_attempts = 0;

-- Who owns the most animals?
SELECT owner FROM (
  SELECT COUNT(a.name) as count, full_name as owner FROM animals a
  JOIN owners o ON o.id = owner_id
  GROUP BY owner
) AS animals_per_owner
WHERE count = (SELECT MAX(count) FROM (
  SELECT COUNT(a.name) as count, full_name as owner FROM animals a
  JOIN owners o ON o.id = owner_id
  GROUP BY owner
) AS animals_per_owner);


---------------------------------------------------------------------------------------

-- Who was the last animal seen by William Tatcher?
SELECT a.name FROM animals a
WHERE a.id = ( SELECT animal_id FROM visits
  LEFT JOIN vets ON visits.vet_id = vets.id
  WHERE vets.name = 'William Tatcher' 
  GROUP BY animal_id
  ORDER BY MAX(date_of_visits) DESC LIMIT 1
);

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(*) FROM visits
WHERE vet_id = (
  SELECT id FROM vets WHERE name = 'Stephanie Mendez'
);

-- List all vets and their specialties, including vets with no specialties.
SELECT * FROM vets 
FULL JOIN specializations ON vet

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT * FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = vet_id
WHERE vets.name = 'Stephanie Mendez' AND date_of_visits BETWEEN '20200401' AND '20200901';

-- What animal has the most visits to vets?
SELECT name FROM (
  SELECT COUNT(date_of_visits) AS count, animals.name as name FROM animals
  LEFT JOIN visits ON animals.id = animal_id
  GROUP BY animals.name
) as tt1
GROUP BY name
ORDER BY MAX(count) DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT name FROM animals 
Where id = (SELECT animal_id FROM visits
LEFT JOIN vets ON vets.id = vet_id
WHERE vets.name = 'Maisy Smith'
ORDER BY date_of_visits LIMIT 1);

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT * FROM animals
LEFT JOIN visits ON animal_id = animals.id
FULL JOIN vets on vets.id = visits.vet_id
ORDER BY date_of_visits DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name AS "Vet", COUNT(*) FROM visits 
LEFT JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON vets.id = specializations.vet_id 
LEFT JOIN species ON specializations.species_id = species.id 
WHERE specializations.species_id IS NULL 
OR specializations.species_id != species.id 
GROUP BY vets.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT vets.name AS "Vet", species.name AS "Specie", COUNT(*) FROM visits 
LEFT JOIN vets ON visits.vet_id = vets.id
LEFT JOIN animals ON visits.animal_id = animals.id 
LEFT JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith' 
GROUP BY vets.name, species.name LIMIT 1;

---------------------------------------------------
-- PERFORMANCE 

-- All team devices has high specs and couldn't get anything above ~300
-- that is the reason for the low performance scores for the ((Excution time)).
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4

--QUERIES:
--Before
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4; --Execution Time: 314.654ms

--After
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4; --Execution Time: 63.073ms



--Before
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2; -- Execution Time: 823.387ms

--After
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2; -- Execution Time: 587.945ms




--Before
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com'; -- Execution Time: 295.548ms

--After
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com'; -- Execution Time: 0.223ms