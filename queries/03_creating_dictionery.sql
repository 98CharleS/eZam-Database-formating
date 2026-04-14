-- Creating new static table which going to be use as dictionery for CPV divisions
DROP TABLE IF EXISTS cpv_dictionary;
CREATE TABLE cpv_dictionary (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

INSERT INTO cpv_dictionary (id, name) VALUES 
(3, 'Produkty rolne, łowieckie i rybne'), (9, 'Produkty naftowe, paliwa i energia'),
(14, 'Górnictwo i minerały'), (15, 'Artykuły spożywcze i napoje'),
(16, 'Maszyny rolnicze'), (18, 'Odzież i obuwie'),
(19, 'Wyroby skórzane i tekstylne'), (22, 'Drukowane materiały i produkty poligraficzne'),
(24, 'Produkty chemiczne'), (30, 'Sprzęt komputerowy i biurowy'),
(31, 'Sprzęt elektryczny'), (32, 'Sprzęt elektroniczny i telekomunikacyjny'),
(33, 'Sprzęt medyczny i farmaceutyczny'), (34, 'Sprzęt transportowy i pojazdy'),
(35, 'Sprzęt bezpieczeństwa i ochrony'), (37, 'Sprzęt sportowy i rekreacyjny'),
(38, 'Sprzęt laboratoryjny i naukowy'), (39, 'Meble i wyposażenie wnętrz'),
(41, 'Woda i usługi wodne'), (42, 'Maszyny przemysłowe'),
(43, 'Maszyny górnicze'), (44, 'Materiały budowlane'),
(45, 'Roboty budowlane'), (48, 'Pakiety oprogramowania'),
(50, 'Usługi napraw i konserwacji'), (51, 'Usługi instalacyjne'),
(55, 'Usługi hotelarskie i restauracyjne'), (60, 'Usługi transportu drogowego'),
(63, 'Usługi spedycji i logistyki'), (64, 'Usługi pocztowe i telekomunikacyjne'),
(65, 'Usługi komunalne (gaz, woda, energia)'), (66, 'Usługi finansowe i ubezpieczeniowe'),
(70, 'Usługi w zakresie nieruchomości'), (71, 'Usługi architektoniczne i inżynieryjne'),
(72, 'Usługi informatyczne'), (73, 'Usługi badawczo-rozwojowe'),
(75, 'Usługi administracji publicznej'), (76, 'Usługi związane z przemysłem naftowym'),
(77, 'Usługi rolnicze i leśne'), (79, 'Usługi biznesowe i doradcze'),
(80, 'Usługi edukacyjne'), (85, 'Usługi zdrowotne i społeczne'),
(90, 'Usługi środowiskowe i sanitarne'), (92, 'Usługi rekreacyjne i kulturalne'),
(98, 'Pozostałe usługi komunalne i osobiste');