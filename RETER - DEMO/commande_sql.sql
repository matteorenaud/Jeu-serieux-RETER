--*******************************************************************
--**Script pour créer la table et insérer les valeurs des bâtiments**
--*******************************************************************

CREATE TABLE buildings(
    id INT NOT NULL PRIMARY KEY,
    name TEXT,
    french_name TEXT,
    path TEXT,
    picture_path TEXT,
    money_cost INT,
    people INT,
    wood INT,
    planch INT,
    iron_ores INT,
    stone INT,
    brick INT,
    wheat INT,
    water INT,
    flour INT,
    hop INT,
    beer INT,
    bread INT,
    meat INT, 
    food INT,
    coal INT,
    metal INT,
    uranium INT,
    electricity INT,
    money_revenu INT,
    ecology INT
);


INSERT INTO buildings VALUES(0,'Pub','Bar','res://assets/RETERGridMapAssets/bar.obj','res://assets/images/UI/Building/building.png',300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-6,4,0);

INSERT INTO buildings VALUES(1,'Base','Sol en béton','res://assets/RETERGridMapAssets/building_A.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(2,'Bread oven','Four à pain',NULL,'res://assets/images/UI/Building/furnace.png',150,0,0,0,0,0,0,0,-3,-3,0,2,0,0,0,0,0,0,-2,0,2);

INSERT INTO buildings VALUES(3,'Brewery','Brasserie','res://assets/RETERGridMapAssets/brewery.obj','res://assets/images/UI/Building/brewery.png',250,0,0,0,0,0,0,0,-3,0,-3,3,0,0,0,0,0,0,-4,0,2);

INSERT INTO buildings VALUES(4,'Brickyard','Briqueterie','res://assets/RETERGridMapAssets/brick.obj','res://assets/images/UI/Building/brick.png',300,0,0,0,0,4,5,0,-3,0,0,0,0,0,0,0,0,0,-5,0,-2);

INSERT INTO buildings VALUES(5,'Building','Immeuble résidentiel','res://assets/RETERGridMapAssets/building2.obj','res://assets/images/UI/Building/building.png',400,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-6,0,1);

INSERT INTO buildings VALUES(6,'Building A','Bâtiment résidentiel A','res://assets/RETERGridMapAssets/building_A.obj',NULL,50,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(7,'Building B','Bâtiment résidentiel B','res://assets/RETERGridMapAssets/building_B.obj',NULL,75,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(8,'Building C','Bâtiment résidentiel C','res://assets/RETERGridMapAssets/building_C.obj',NULL,100,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(9,'Building D','Bâtiment résidentiel D','res://assets/RETERGridMapAssets/building_D.obj',NULL,150,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(10,'Building E','Bâtiment résidentiel E','res://assets/RETERGridMapAssets/building_E.obj',NULL,200,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(11,'Building F','Bâtiment résidentiel F','res://assets/RETERGridMapAssets/building_F.obj',NULL,300,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(12,'Building G','Bâtiment résidentiel G','res://assets/RETERGridMapAssets/building_G.obj',NULL,400,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(13,'Building H','Bâtiment résidentiel H','res://assets/RETERGridMapAssets/building_H.obj',NULL,500,75,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0);

INSERT INTO buildings VALUES(14,'Coal factory','Centrale à charbon','res://assets/RETERGridMapAssets/coal.obj','res://assets/images/UI/Building/coal.png',300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-5,0,0,6,0,-10);

INSERT INTO buildings VALUES(15,'Rail road end','Fin de voie de chemin de fer','res://assets/RETERGridMapAssets/end_rail_road.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-10);

INSERT INTO buildings VALUES(16,'Farm','Ferme','res://assets/RETERGridMapAssets/farm.obj','res://assets/images/UI/Building/farm.png',150,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,2);

INSERT INTO buildings VALUES(17,'Wheat field','Champs de blé','res://assets/RETERGridMapAssets/field.obj','res://assets/images/UI/Building/wheat.png',50,0,0,0,0,0,0,5,-3,0,0,0,0,0,0,0,0,0,0,0,2);

INSERT INTO buildings VALUES(18,'Hop field','Champs de houblon','res://assets/RETERGridMapAssets/field_hop.obj','res://assets/images/UI/Building/hop.png',50,0,0,0,0,0,0,0,-3,0,4,0,0,0,0,0,0,0,0,0,2);

INSERT INTO buildings VALUES(19,'Food factory','Usine alimentaire','res://assets/RETERGridMapAssets/food.obj','res://assets/images/UI/Building/food.png',400,0,0,0,0,0,0,0,0,0,0,0,0,-8,6,0,0,0,-6,4,0);

INSERT INTO buildings VALUES(20,'Coal stove','Fourneau à charbon','res://assets/RETERGridMapAssets/furnace.obj','res://assets/images/UI/Building/coal.png',150,0,-3,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,-2,0,-4);

INSERT INTO buildings VALUES(21,'Grocery store','Epicerie','res://assets/RETERGridMapAssets/grocery_store.obj','res://assets/images/UI/Building/market.png',150,20,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,-2,2,2);

INSERT INTO buildings VALUES(22,'House','Maison résidentielle','res://assets/RETERGridMapAssets/house.obj','res://assets/images/UI/Building/house.png',200,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,1);

INSERT INTO buildings VALUES(23,'Logging camp','Camp de bucheron','res://assets/RETERGridMapAssets/lumberjack.obj','res://assets/images/UI/Building/lumberjack.png',100,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2);

INSERT INTO buildings VALUES(24,'Shop','Supermarché','res://assets/RETERGridMapAssets/market.obj','res://assets/images/UI/Building/market.png',200,10,0,0,0,0,0,0,0,0,0,0,0,0,-6,0,0,0,-6,4,0);

INSERT INTO buildings VALUES(25,'Foundry','Fonderie','res://assets/RETERGridMapAssets/metal.obj','res://assets/images/UI/Building/metal.png',400,0,0,0,-5,0,0,0,0,0,0,0,0,0,0,0,3,0,-7,0,2);

INSERT INTO buildings VALUES(26,'Mill','Moulin','res://assets/RETERGridMapAssets/mill.obj','res://assets/images/UI/Building/mill.png',150,0,0,0,0,0,0,-4,0,4,0,0,0,0,0,0,0,0,-2,0,2);

INSERT INTO buildings VALUES(27,'Mine','Mine','res://assets/RETERGridMapAssets/mine.obj','res://assets/images/UI/Building/mine.png',100,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2);

INSERT INTO buildings VALUES(28,'Nuclear power plant','Centrale nucléaire','res://assets/RETERGridMapAssets/nuclear_power_plant.obj','res://assets/UI/Building/nuke.png',300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-4,15,0,3);

INSERT INTO buildings VALUES(29,'Office','Bureau','res://assets/RETERGridMapAssets/office.obj','res://assets/images/UI/Building/office.png',300,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-4,4,4);

INSERT INTO buildings VALUES(30,'Parc','Parc','res://assets/RETERGridMapAssets/parc.obj','res://assets/images/UI/Building/parc.png',100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4);

INSERT INTO buildings VALUES(31,'Pumpe','Pompe','res://assets/RETERGridMapAssets/pump.obj','res://assets/images/UI/Building/pump.png',100,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,-2,0,2);

INSERT INTO buildings VALUES(32,'Rail road crossing','Passage à niveau','res://assets/RETERGridMapAssets/rail_road_crossing.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(33,'Rail road straight','Rail droite','res://assets/RETERGridMapAssets/rail_road_straight.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(34,'Road corner','Virage','res://assets/RETERGridMapAssets/road_corner_curved.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(35,'Road junction','Croissement','res://assets/RETERGridMapAssets/road_junction.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(36,'Road straight','Route droite','res://assets/RETERGridMapAssets/road_straight.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(37,'Road crossing','Passage péton','res://assets/RETERGridMapAssets/road_straight_crossing.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(38,'Road T split','Croissement en T','res://assets/RETERGridMapAssets/road_tsplit.obj',NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

INSERT INTO buildings VALUES(39,'Saw mill','Scierie','res://assets/RETERGridMapAssets/sawmill.obj','res://assets/images/UI/Building/sawmill.png',150,0,-4,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-2,0,2);

INSERT INTO buildings VALUES(40,'Solar panel','Panneau photovolatïque','res://assets/RETERGridMapAssets/solar.obj','res://assets/images/UI/Building/solar.png',275,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,7);

INSERT INTO buildings VALUES(41,'Wind turbine','Eolienne','res://assets/RETERGridMapAssets/wind.obj','res://assets/images/UI/Building/wind.png',300,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,7);

