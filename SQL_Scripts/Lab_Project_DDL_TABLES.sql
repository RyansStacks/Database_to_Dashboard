ALTER TABLE Customers
ADD CONSTRAINT Customers_Addresses_fk
FOREIGN KEY (address_id)
REFERENCES Addresses (address_id);

ALTER TABLE Employees
ADD CONSTRAINT Employees_Addresses_fk
FOREIGN KEY (address_id)
REFERENCES Addresses (address_id);

ALTER TABLE QC_Definitions
ADD CONSTRAINT QC_Definitions_Analyzers_fk
FOREIGN KEY (serial_number)
REFERENCES Analyzers (serial_number);

ALTER TABLE Test_Definitions
ADD CONSTRAINT Test_Definitions_Analyzers_fk
FOREIGN KEY (serial_number)
REFERENCES Analyzers (serial_number);

ALTER TABLE Samples
ADD CONSTRAINT Samples_Containers_fk
FOREIGN KEY (container_id)
REFERENCES Containers (container_id);

ALTER TABLE Orders
ADD CONSTRAINT Orders_Customers_fk
FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id);

ALTER TABLE Customer_Surveys
ADD CONSTRAINT Customer_Surveys_Customers_fk
FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id);

ALTER TABLE Patient_Results
ADD CONSTRAINT Patient_Results_Customers_fk
FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id);

ALTER TABLE Samples
ADD CONSTRAINT Samples_Customers_fk
FOREIGN KEY (customer_id)
REFERENCES Customers (customer_id);

ALTER TABLE Employee_Surveys
ADD CONSTRAINT Employee_SurveysEmployees_fk
FOREIGN KEY (employee_id)
REFERENCES Employees (employee_id);

ALTER TABLE Samples
ADD CONSTRAINT Samples_SurveysEmployees_fk
FOREIGN KEY (employee_id)
REFERENCES Employees (employee_id);

ALTER TABLE Analyzers
ADD CONSTRAINT Analyzers_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Employees
ADD CONSTRAINT Employees_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Expenses
ADD CONSTRAINT Expenses_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Orders
ADD CONSTRAINT Orders_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Patient_Results
ADD CONSTRAINT Patient_Results_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE QC_Definitions
ADD CONSTRAINT QC_Definitions_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Shipments
ADD CONSTRAINT Shipments_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Test_Definitions
ADD CONSTRAINT Test_Definitions_Laboratories_fk
FOREIGN KEY (lab_id)
REFERENCES Laboratories (lab_id);

ALTER TABLE Patient_Results
ADD CONSTRAINT Patient_Results_Orders_fk
FOREIGN KEY (order_id)
REFERENCES Orders (order_id);

ALTER TABLE Samples
ADD CONSTRAINT Samples_Orders_fk
FOREIGN KEY (order_id)
REFERENCES Orders (order_id);

ALTER TABLE Analyzers
ADD CONSTRAINT Analyzers_Panels_fk
FOREIGN KEY (panel_id)
REFERENCES Panels (panel_id);

ALTER TABLE Containers
ADD CONSTRAINT Containers_Panels_fk
FOREIGN KEY (panel_id)
REFERENCES Panels (panel_id);

ALTER TABLE Orders
ADD CONSTRAINT Orders_Panels_fk
FOREIGN KEY (panel_id)
REFERENCES Panels (panel_id);

ALTER TABLE Patient_Results
ADD CONSTRAINT Patient_Results_Panels_fk
FOREIGN KEY (panel_id)
REFERENCES Panels (panel_id);

ALTER TABLE Test_Definitions
ADD CONSTRAINT Test_Definitions_Panels_fk
FOREIGN KEY (panel_id)
REFERENCES Panels (panel_id);

ALTER TABLE QC_Results
ADD CONSTRAINT QC_Results_QC_Definitions_fk
FOREIGN KEY (qc_definition_id)
REFERENCES QC_Definitions (qc_definition_id);




