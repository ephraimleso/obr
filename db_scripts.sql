CREATE DATABASE `onlinebusregistration` /*!40100 DEFAULT CHARACTER SET latin1 */;

CREATE TABLE `administrators` (
  `ID` int(11) NOT NULL,
  `InitialsAndSurname` varchar(255) NOT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `EmailAddress` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ;
CREATE TABLE `grades` (
  `ID` int(11) NOT NULL,
  `Grade` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ;

CREATE TABLE `buses` (
  `ID` int(11) NOT NULL,
  `Number` int(11) DEFAULT NULL,
  `Capacity` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ;

CREATE TABLE `learners` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `NameAndSurname` varchar(255) NOT NULL,
  `EmailAddress` varchar(255) DEFAULT NULL,
  `Grade` int(11) DEFAULT NULL,
  `ParentID` int(11) DEFAULT NULL,
  `Cellnumber` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ;

CREATE TABLE `parents` (
  `Id` int(11) NOT NULL,
  `Name` text NOT NULL,
  `Surname` text NOT NULL,
  `Cellnumber` text NOT NULL,
  `EmailAddress` text NOT NULL,
  `Password` text NOT NULL,
  PRIMARY KEY (`Id`)
) ;

CREATE TABLE `routes` (
  `ID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Number` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ;

CREATE TABLE `statuses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE `subroutes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `BusNumber` varchar(10) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Time` varchar(10) NOT NULL,
  `TripTypeId` int(11) NOT NULL,
  `BusId` int(11) NOT NULL,
  `RouteId` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE `transportapplications` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `RouteId_pickup` int(11) NOT NULL,
  `SubRouteId_pickup` int(11) NOT NULL,
  `BusNumber_pickup` varchar(10) NOT NULL,
  `RouteId_dropoff` int(11) NOT NULL,
  `SubRouteId_dropoff` int(11) NOT NULL,
  `BusNumber_dropoff` varchar(10) NOT NULL,
  `LearnerId` int(11) NOT NULL,
  `NewLearner` varchar(10) NOT NULL,
  `NextYearGrade` int(11) NOT NULL,
  `StatusId` int(11) NOT NULL,
  `ApplicationDate` date NOT NULL,
  `ApplicationYear` int(11) NOT NULL,
  `ParentId` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ;

CREATE TABLE `triptypes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
) ;




DELIMITER $$
CREATE PROCEDURE `get_applications`(IN `parentId` INT)
BEGIN
	SELECT 
	l.NameAndSurname, s.Description as Status_description, r1.Name as Pickup, r2.Name as DropOff,
	sr1.Name as Pickup_bus_route_number,sr2.Name as Dropoff_bus_route_number, t.*
	FROM transportapplications t, learners l, statuses s, 
	(select * from routes) r1, (select * from routes) r2,
	(select * from subroutes where TripTypeId = 1) sr1, 
	(select * from subroutes where TripTypeId = 2) sr2
	Where t.ParentId = parentId
	and l.ID = t.LearnerId
	and s.ID = t.StatusId
	and r1.ID = t.RouteId_pickup
	and r2.ID = t.RouteId_dropoff
	and sr1.ID = t.SubRouteId_pickup
	and sr2.ID = t.SubRouteId_dropoff;
END$$
DELIMITER ;


