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

-- Table for Treatments
CREATE TABLE treatments (
  id INT NOT NULL PRIMARY KEY,
  type VARCHAR,
  name VARCHAR
);

-- Table for Invoices 
CREATE TABLE invoices (
  id INT NOT NULL PRIMARY KEY,
  total_amount DECIMAL,
  generated_at TIMESTAMP,
  payed_at TIMESTAMP,
  medical_history_id INT,
  FOREIGN KEY (medical_history_id)
  REFERENCES medical_histories(id)
  ON DELETE CASCADE
);

-- Table for invoice items
CREATE TABLE invoice_items (
  id INT NOT NULL PRIMARY KEY,
  unit_price DECIMAL,
  quantity INT,
  total_price DECIMAL,
  invoice_id INT,
  treatment_id INT REFERENCES treatments(id),
  FOREIGN KEY (invoice_id)
  REFERENCES invoices(id)
  ON DELETE CASCADE
);

-- Join many to many relationship table
CREATE TABLE medical_histories_treatments (
  id INT NOT NULL Primary KEY,
  medical_history_id INT NOT NULL,
  treatment_id INT NOT NULL,
  FOREIGN KEY (medical_history_id) 
  REFERENCES medical_histories (id) 
  ON DELETE CASCADE,
  FOREIGN KEY (treatment_id) 
  REFERENCES treatments (id) 
  ON DELETE CASCADE 
);

-- CREATE FK INDEXES
CREATE INDEX mh_index
ON invoices (medical_history_id);