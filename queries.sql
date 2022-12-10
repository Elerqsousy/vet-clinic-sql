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
SELECT full_name FROM (
  SELECT full_name, COUNT(animals.name) as animals_count FROM animals
  INNER JOIN owners ON owner_id = owners.id
  GROUP BY owners.full_name
) AS animals_per_owner 
WHERE animals_count = (
  SELECT max(animals_count) FROM (
    SELECT full_name, COUNT(animals.name) as animals_count FROM animals
    INNER JOIN owners ON owner_id = owners.id
    GROUP BY owners.full_name
    ) AS animals_per_owner
);

---------------------------------------------------------------------------------------

-- Who was the last animal seen by William Tatcher?
SELECT name FROM animals
WHERE id = (SELECT animal_id from (
  SELECT animal_id, MAX(visit_date) FROM visits 
  WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
  GROUP BY animal_id ORDER BY MAX(visit_date) DESC LIMIT 1
  ) as animal_last_visit_by_doctor );

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(*) FROM visits 
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, s.name FROM specializations sp
JOIN species s ON s.id = sp.species_id
RIGHT JOIN vets v ON sp.vet_id = v.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name, vi.visit_date, ve.name FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets ve ON vi.vet_id = ve.id
WHERE ve.name = ('Stephanie Mendez') AND vi.visit_date BETWEEN '20200401' AND '202000831';

-- What animal has the most visits to vets?
SELECT name FROM animals
WHERE id = (
  SELECT animal_id FROM (
  SELECT animal_id, COUNT(visit_date) AS n FROM visits
GROUP BY animal_id ORDER BY COUNT(visit_date) DESC LIMIT 1 
) max_visits
);

-- Who was Maisy Smith's first visit?
SELECT name FROM animals
WHERE id = (
  SELECT animal_id FROM visits 
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
ORDER BY visit_date LIMIT 1
);

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.*, ve.*, vi.visit_date FROM visits vi
RIGHT JOIN vets ve ON ve.id = vi.vet_id
RIGHT JOIN animals a ON a.id = vi.animal_id
ORDER BY vi.visit_date DESC LIMIT 1;

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


