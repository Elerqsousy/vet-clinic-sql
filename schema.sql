/* Database schema to keep the structure of entire database. */

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
    id SERIAL,
    full_name VARCHAR(40),
    age INT,
    PRIMARY KEY(id)
);

CREATE TABLE species (
    id SERIAL,
    name VARCHAR(40),
    PRIMARY KEY(id)
);

BEGIN;
ALTER TABLE animals DROP id;
ALTER TABLE animals ADD id SERIAL PRIMARY KEY;
ALTER TABLE animals DROP species;
ALTER TABLE animals ADD species_id INT;
ALTER TABLE animals ADD owner_id INT;
COMMIT;

BEGIN;
ALTER TABLE animals ADD CONSTRAINT c1
      FOREIGN KEY(species_id) 
	  REFERENCES species(id);
ALTER TABLE animals ADD CONSTRAINT c2
      FOREIGN KEY(owner_id) 
	  REFERENCES owners(id);
COMMIT;