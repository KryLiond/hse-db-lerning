WITH gold_members AS (
    SELECT m.person_id, m.name
    FROM get_fit_now_member m
    JOIN get_fit_now_check_in c ON m.id = c.membership_id
    WHERE m.membership_status = 'gold'
      AND m.id LIKE '48Z%'
      AND c.check_in_date = '20180109'
), killers AS (
    SELECT g.person_id, g.name, d.plate_number, d.gender
    FROM gold_members g
    JOIN person p ON g.person_id = p.id
    JOIN drivers_license d ON p.license_id = d.id
    WHERE d.plate_number LIKE '%H42W%' AND d.gender = 'male'
), description_drivers AS (
    SELECT d.id AS license_id
    FROM drivers_license d
    WHERE d.gender = 'female' AND d.hair_color = 'red'
      AND d.car_make = 'Tesla' AND d.car_model = 'Model S'
      AND d.height BETWEEN 64 AND 68
), owner_tesla AS (
    SELECT p.id AS person_id, p.name
    FROM description_drivers dr
    JOIN person p ON dr.license_id = p.license_id
), symphony_visitors AS (
    SELECT f.person_id
    FROM facebook_event_checkin f
    WHERE f.event_name = 'SQL Symphony Concert'
      AND f.date LIKE '201712%'
    GROUP BY f.person_id
    HAVING COUNT(1) = 3
)
SELECT k.name
FROM killers k

UNION

SELECT ot.name
FROM owner_tesla ot
JOIN symphony_visitors sv ON ot.person_id = sv.person_id