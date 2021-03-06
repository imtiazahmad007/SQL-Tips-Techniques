-- Below is an example of inserting data idempotently. 
-- In otherwords, it will not insert data if a record already exists for the particular date.
-- This sort of a script can be run once a day or several times a day only inserting data for new dates.

-- NOTE: There is some extra complexity applied in the nested 
      -- query for only inserting those users subscribed to mailings. 


-- The example I am using below is for a  hypothtical users_articles table

INSERT INTO users_articles (date, user_id, hit_count)
SELECT a.date, a.user_id, sum(a.article_id) as hits
from (
select t.* from users_article_details AS t
WHERE NOT EXISTS (
    SELECT 1
    FROM do_not_email_users_tbl
    WHERE email = t.email
    LIMIT 1
)) a 
WHERE NOT EXISTS
(SELECT 1 from users_articles b
WHERE b.date = a.date)
GROUP BY date, user_id
