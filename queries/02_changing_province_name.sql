UPDATE raw_data
SET organizationProvince = CASE 
    WHEN TRIM(organizationProvince) = 'PL-02' THEN 'Dolnośląskie'
    WHEN TRIM(organizationProvince) = 'PL-04' THEN 'Kujawsko-pomorskie'
    WHEN TRIM(organizationProvince) = 'PL-06' THEN 'Lubelskie'
    WHEN TRIM(organizationProvince) = 'PL-08' THEN 'Lubuskie'
    WHEN TRIM(organizationProvince) = 'PL-10' THEN 'Łódzkie'
    WHEN TRIM(organizationProvince) = 'PL-12' THEN 'Małopolskie'
    WHEN TRIM(organizationProvince) = 'PL-14' THEN 'Mazowieckie'
    WHEN TRIM(organizationProvince) = 'PL-16' THEN 'Opolskie'
    WHEN TRIM(organizationProvince) = 'PL-18' THEN 'Podkarpackie'
    WHEN TRIM(organizationProvince) = 'PL-20' THEN 'Podlaskie'
    WHEN TRIM(organizationProvince) = 'PL-22' THEN 'Pomorskie'
    WHEN TRIM(organizationProvince) = 'PL-24' THEN 'Śląskie'
    WHEN TRIM(organizationProvince) = 'PL-26' THEN 'Świętokrzyskie'
    WHEN TRIM(organizationProvince) = 'PL-28' THEN 'Warmińsko-mazurskie'
    WHEN TRIM(organizationProvince) = 'PL-30' THEN 'Wielkopolskie'
    WHEN TRIM(organizationProvince) = 'PL-32' THEN 'Zachodniopomorskie'
    ELSE organizationProvince 
END;
