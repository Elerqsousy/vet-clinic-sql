CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL
);

ALTER TABLE animals
ADD species VARCHAR(100);

CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100),
  age VARCHAR(100)
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100)
);

BEGIN;
ALTER TABLE animals DROP id;
ALTER TABLE animals ADD id SERIAL PRIMARY KEY;
ALTER TABLE animals DROP species;
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD owner_id INT;

ALTER TABLE animals ADD CONSTRAINT c1
FOREIGN KEY (species_id)
REFERENCES species(id);
ALTER TABLE animals ADD CONSTRAINT c2
FOREIGN KEY (owner_id)
REFERENCES owners(id);
COMMIT;

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  age INT,
  date_of_graduation DATE
);

CREATE TABLE specializations (
  vet_id INT NOT NULL,
  species_id INT NOT NULL,
  PRIMARY KEY(vet_id,species_id),
  FOREIGN KEY (species_id) REFERENCES species (id),
  FOREIGN KEY (vet_id) REFERENCES vets (id)
);

CREATE TABLE visits (
  animal_id INT NOT NULL,
  vet_id INT NOT NULL,
  date_of_visits Date NOT NULL,
  CONSTRAINT primary_pk
  PRIMARY KEY (animal_id, vet_id, date_of_visits),
  FOREIGN KEY (animal_id) REFERENCES animals (id),
  FOREIGN KEY (vet_id) REFERENCES vets (id)
);