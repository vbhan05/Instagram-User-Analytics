-- to use ig_clone database
use ig_clone;

-- 1. To find out the most loyal users as per the database info
select * from users;

select username, created_at
from users
order by created_at limit 5;

-- 2. To find users who are inactive from a very long time
select * from photos, users;

select u.username from users u
left join photos p on p.user_id = u.id where p.image_url is null 
order by u.username;

-- 3. To find the winner of the contest
select * from likes, photos , users;

select l.photo_id, u.username, count(l.user_id) as no_of_likes
from likes l 
join photos p on l.photo_id = p.id
join users u on p.user_id = u.id 
group by l.photo_id, u.username 
order by no_of_likes desc;

-- 4. Most used hashtag
select * from photo_tags, tags;

select t.tag_name, count(pt.photo_id) as no_of_counts
from photo_tags pt
join tags t on t.id = pt.tag_id
group by t.tag_name 
order by no_of_counts desc limit 5;

-- 5. At what day of the week most users registers on
select * from users;

select date_format((created_at), '%W') as day, count(username) 
from users group by 1 
order by 2 desc;

-- 6. Provide how many times does average user posts on Instagram. Also, provide the 
-- total number of photos on Instagram/total number of users
select * from photos, users;

 with base as(
 select u.id as user_id, count(p.id) as photo_id 
 from users u 
 left join photos p on p.user_id = u.id
 group by u.id)
 select sum(photo_id) as total_no_of_photos, count(user_id) as total_no_of_users, sum(photo_id)/count(user_id) as photo_per_user
 from base;

-- 7. Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).
select * from users, likes;

with base as(
select u.username, count(l.photo_id) as no_of_likes
from likes l 
join users u on u.id = l.user_id
group by u.username)
select username, no_of_likes 
from base 
where no_of_likes = (select count(*) from photos)
order by username;