drop database zarządzanie_firmą_logistyczną;
create database zarządzanie_firmą_logistyczną;

use zarządzanie_firmą_logistyczną;

CREATE TABLE `company_fees` (
  `fee_ID` int(11) AUTO_INCREMENT,
  `Prąd` int(11) NOT NULL,
  `Internet` int(11) NOT NULL,
  `Ubezpieczenia` int(11) NOT NULL,
  `Pensje` int(11) NOT NULL,
  `Oprogramowanie` int(11) NOT NULL,
  `Szkolenia` int(11) NOT NULL,
  `Marketing` int(11) NOT NULL,
  `Eksploatacja_sprzętu` int(11) NOT NULL,
  `Paliwo` int(11) NOT NULL,
  `Inne` int(11) NOT NULL,
  `Data` datetime NOT NULL,
  PRIMARY KEY (`fee_ID`));
  
  
  CREATE TABLE `contracts` (
  `Contract_ID` int(11) AUTO_INCREMENT,
  `Okres_do` datetime NOT NULL,
  `Warunki` varchar(255) NOT NULL,
  `Kwota` int(11) NOT NULL COMMENT 'w zł',
  `Opis` text NOT NULL,
  `Customer_ID` int(11) NOT NULL,
  PRIMARY KEY (`Contract_ID`),
  FOREIGN KEY (`Customer_ID`) REFERENCES `customers` (`Customer_ID`));
  
  
  CREATE TABLE `customers` (
  `Customer_ID` int(11) AUTO_INCREMENT,
  `Nazwa` varchar(255) NOT NULL,
  `Miasto` varchar(255) NOT NULL,
  `Adres` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Nr_tel` varchar(255) NOT NULL,
  `NIP` int(11) NOT NULL,
  PRIMARY KEY (`Customer_ID`));

  
  CREATE TABLE `delivery_info` (
  `Delivery_ID` int(11) AUTO_INCREMENT,
  `Order_ID` int(11) NOT NULL,
  `Customer_ID` int(11) NOT NULL,
  `Cargo_ID` int(11) NOT NULL,
  `Package_ID` int(11) NOT NULL,
  `Invoice_ID` int(11) NOT NULL,
  PRIMARY KEY (`Delivery_ID`),
  FOREIGN KEY (`Cargo_ID`) REFERENCES `types_of_cargo` (`Cargo_ID`),
  FOREIGN KEY (`Customer_ID`) REFERENCES `customers` (`Customer_ID`),
  FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`Order_ID`),
  FOREIGN KEY (`Invoice_ID`) REFERENCES `invoices` (`Invoice_ID`),
  FOREIGN KEY (`Package_ID`) REFERENCES `types_of_package` (`Package_ID`));
  
  
  CREATE TABLE `delivery_status` (
  `Status_ID` int(11) AUTO_INCREMENT,
  `Status` varchar(255) NOT NULL COMMENT 'dostarczona/w trakcie/anulowana itd',
  `Order_ID` int(11) NOT NULL,
  `Uwagi` text NOT NULL,
  PRIMARY KEY (`Status_ID`),
  FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`Order_ID`));
  
  
  CREATE TABLE `drivers` (
  `Driver_ID` int(11) AUTO_INCREMENT,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Adres` varchar(255) NOT NULL,
  `Miejscowosc` varchar(255) NOT NULL,
  `Nr_tel` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Truck_ID` int(11) NOT NULL,
  `Job_position_ID` int(11) NOT NULL,
  PRIMARY KEY (`Driver_ID`),
  FOREIGN KEY (`Truck_ID`) REFERENCES `trucks` (`Truck_ID`),
  FOREIGN KEY (`Job_position_ID`) REFERENCES `job_positions` (`Job_position_ID`));

  
  CREATE TABLE `employees` (
  `Employee_ID` int(11) AUTO_INCREMENT,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Plec` varchar(255) NOT NULL,
  `Nr_tel` varchar(255) NOT NULL,
  `Miejscowosc` varchar(255) NOT NULL,
  `Adres` varchar(255) NOT NULL,
  `Job_position_ID` int(11) NOT NULL,
  PRIMARY KEY (`Employee_ID`),
  FOREIGN KEY (`Job_position_ID`) REFERENCES `job_positions` (`Job_position_ID`));
  
  
  CREATE TABLE `freelancers` (
  `Freelancer_ID` int(11) AUTO_INCREMENT,
  `Imie` varchar(255) NOT NULL,
  `Nazwisko` varchar(255) NOT NULL,
  `Adres` varchar(255) NOT NULL,
  `Miejscowosc` varchar(255) NOT NULL,
  `Nr_tel` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Job_position_ID` int(11) NOT NULL,
  PRIMARY KEY (`Freelancer_ID`),
  FOREIGN KEY (`Job_position_ID`) REFERENCES `job_positions` (`Job_position_ID`));
  
  
  CREATE TABLE `incidents` (
  `Incident_ID` int(11) AUTO_INCREMENT,
  `Order_ID` int(11) NOT NULL,
  `Opis` text NOT NULL,
  `Track_ID` int(11) NOT NULL,
  PRIMARY KEY (`Incident_ID`),
  FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`Order_ID`),
  FOREIGN KEY (`Track_ID`) REFERENCES `track_details` (`Track_ID`));
  
  
  CREATE TABLE `invoices` (
  `Invoice_ID` int(11) AUTO_INCREMENT,
  `Customer_ID` int(11) NOT NULL,
  `Data` date NOT NULL,
  `Czy_opłacona` int(11) NOT NULL,
  `Kwota` float NOT NULL COMMENT 'w zł',
  PRIMARY KEY (`Invoice_ID`),
  FOREIGN KEY (`Customer_ID`) REFERENCES `customers` (`Customer_ID`));
  
  
  CREATE TABLE `job_positions` (
  `Job_position_ID` int(11) AUTO_INCREMENT,
  `Nazwa` varchar(255) NOT NULL,
  `Wynagrodzenie` int(11) NOT NULL COMMENT 'w zł',
  PRIMARY KEY (`Job_position_ID`));
  
  
  CREATE TABLE `orders` (
  `Order_ID` int(11) AUTO_INCREMENT,
  `Data_zlozenia` date NOT NULL,
  `Data_realizacji` date NOT NULL,
  `Customer_ID` int(11) NOT NULL,
  `Driver_ID` int(11) NOT NULL,
  `Truck_ID` int(11) NOT NULL,
  `Cargo_ID` int(11) NOT NULL,
  `Trailer_ID` int(11) NOT NULL,
  `Package_type_ID` int(11) NOT NULL,
  `Invoice_ID` int(11) NOT NULL,
  `Delivery_info_ID` int(11) NOT NULL,
  `Delivery_status_ID` int(11) NOT NULL,
  `Employee_ID` int(11) NOT NULL,
  `Service_ID` int(11) NOT NULL,
  `Track_ID int(11) NOT NULL,
  PRIMARY KEY (`Order_ID`),
  FOREIGN KEY (`Driver_ID`) REFERENCES `drivers` (`Driver_ID`),
  FOREIGN KEY (`Truck_ID`) REFERENCES `trucks` (`Truck_ID`),
  FOREIGN KEY (`Cargo_ID`) REFERENCES `types_of_cargo` (`Cargo_ID`),
  FOREIGN KEY (`Employee_ID`) REFERENCES `employees` (`Employee_ID`),
  FOREIGN KEY (`Trailer_ID`) REFERENCES `trailers` (`Trailer_ID`),
  FOREIGN KEY (`Package_type_ID`) REFERENCES `types_of_package` (`Package_ID`),
  FOREIGN KEY (`Invoice_ID`) REFERENCES `invoices` (`Invoice_ID`),
  FOREIGN KEY (`Delivery_info_ID`) REFERENCES `delivery_info` (`Delivery_ID`),
  FOREIGN KEY (`Delivery_status_ID`) REFERENCES `delivery_status` (`Status_ID`);
  FOREIGN KEY (`Service_ID`) REFERENCES `services`(`Service_ID`)
  FOREIGN KEY (`Track_ID`) REFERENCES `track_details`(`Track_ID));

  
  
  CREATE TABLE `services` (
  `Service_ID` int(11) AUTO_INCREMENT,
  `Nazwa` varchar(255) NOT NULL,
  `Opis` text NOT NULL,
  `Cena` int(11) NOT NULL,
  PRIMARY KEY (`Service_ID`));

  
  CREATE TABLE `track_details` (
  `Track_ID` int(11) AUTO_INCREMENT,
  `Data_rozpoczecia` date NOT NULL,
  `Data_zakonczenia` date NOT NULL,
  `Order_ID` int(11) NOT NULL,
  `Dlugosc` int(11) NOT NULL,
  `Przewidywana_pogoda` varchar(255) NOT NULL,
  `sredni_stan_asfaltu` varchar(255) NOT NULL,
  `Punkt_startowy` varchar(255) NOT NULL,
  `Punkt_docelowy` varchar(255) NOT NULL,
  `Przewidywany_czas` int(11) NOT NULL,
  PRIMARY KEY (`Track_ID`),
  FOREIGN KEY (`Order_ID`) REFERENCES `orders` (`Order_ID`));
  
  
  CREATE TABLE `trailers` (
  `Trailer_ID` int(11) AUTO_INCREMENT,
  `Typ` varchar(255) NOT NULL,
  `Ladownosc_max` int(11) NOT NULL COMMENT 'w tonach',
  `Dostepnosc` int(11) NOT NULL COMMENT '0 - nie, 1 - tak',
  PRIMARY KEY (`Trailer_ID`));
  
  
  CREATE TABLE `trainings` (
  `Training_ID` int(11) AUTO_INCREMENT,
  `Temat` varchar(255) NOT NULL,
  `Data` date NOT NULL,
  `Miejsce` varchar(255) NOT NULL,
  `Nazwisko_prowadzacego` varchar(255) NOT NULL,
  PRIMARY KEY (`Training_ID`));
  
  
  CREATE TABLE `trucks` (
  `Truck_ID` int(11) AUTO_INCREMENT,
  `Marka` varchar(255) NOT NULL,
  `Model` varchar(255) NOT NULL,
  `Spalanie` int(11) NOT NULL,
  `Przebieg` int(11) NOT NULL,
  PRIMARY KEY (`Truck_ID`));
  
  
  CREATE TABLE `trucksinservice` (
  `Truck_serviced_ID` int(11) AUTO_INCREMENT,
  `Opis_usterki` text NOT NULL,
  `data_przyjecia` date NOT NULL,
  `data_wydania` date NOT NULL,
  `Progress` varchar(255) NOT NULL,
  `historia_serwisu` text NOT NULL,
  `Truck_ID` int(11) NOT NULL,
  PRIMARY KEY (`Truck_serviced_ID`),
  FOREIGN KEY (`Truck_ID`) REFERENCES `trucks`(`Truck_ID`));
  
  
  CREATE TABLE `types_of_cargo` (
  `Cargo_ID` int(11) AUTO_INCREMENT,
  `Typ` varchar(255) NOT NULL,
  `Opis` text NOT NULL,
  PRIMARY KEY (`Cargo_ID`));
  
  
  CREATE TABLE `types_of_package` (
  `Package_ID` int(11) AUTO_INCREMENT,
  `Nazwa` varchar(255) NOT NULL,
  `Uwagi` varchar(255) NOT NULL,
  `Waga` int(11) NOT NULL COMMENT 'w tonach',
  PRIMARY KEY (`Package_ID`));
  
  
  CREATE TABLE `warehouse` (
  `Item_ID` int(11) AUTO_INCREMENT,
  `Dostepnosc` int(11) NOT NULL,
  `Regal` int(11) NOT NULL,
  `Polka` int(11) NOT NULL,
  `Package_ID` int(11) NOT NULL,
  PRIMARY KEY (`Item_ID`),
  FOREIGN KEY (`Package_ID`) REFERENCES `types_of_package` (`Package_ID`));
  
  
  
  