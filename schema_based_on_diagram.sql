-- Table for Patients
CREATE TABLE patients (
  id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100),
  data_of_birth DATE,
  PRIMARY KEY(id)
);

-- Table for Medical Histories
CREATE TABLE medical_histories (
  id INT GENERATED ALWAYS AS IDENTITY,
  admitted_at TIMESTAMP NOT NULL,
  patient_id INT NOT NULL,
  status VARCHAR(100),
  PRIMARY KEY(id),
  FOREIGN KEY (patient_id)
  REFERENCES patients (id)
  ON DELETE CASCADE
);
