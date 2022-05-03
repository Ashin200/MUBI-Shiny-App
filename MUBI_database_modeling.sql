# user_info is the information table containing user infomation 
# (user_id, user_trialist, user_subscriber, user_eligible_for_trial, user_has_payment_method)
## creat table
CREATE TABLE user_info (
    user_id INTEGER NOT NULL AUTO_INCREMENT,
    user_trialist VARCHAR(160) NOT NULL,
    user_subscriber VARCHAR(160) NOT NULL,
    user_eligible_for_trial VARCHAR(160) NOT NULL,
    user_has_payment_method VARCHAR(160) NOT NULL,
    PRIMARY KEY(user_id)
);

## insert values into table
INSERT INTO user_info (user_id, user_trialist, user_subscriber, user_eligible_for_trial, user_has_payment_method)  
SELECT DISTINCT user_id, user_trialist, user_subscriber, user_eligible_for_trial, user_has_payment_method
FROM mubi_lists_user_data;

## checklist
SELECT * FROM user_info;

## Some analysis
SELECT COUNT(*) FROM mubi_lists_user_data; # 80311
SELECT COUNT(*) FROM user_info; # 23118
SELECT COUNT(DISTINCT user_id) FROM user_info; # 23118
SELECT COUNT(*) FROM user_info WHERE user_trialist = 'TRUE'; # 1759
SELECT COUNT(*) FROM user_info WHERE user_subscriber = 'TRUE'; # 6056
SELECT COUNT(*) FROM user_info WHERE user_eligible_for_trial = 'TRUE'; # 16422
SELECT COUNT(*) FROM user_info WHERE user_has_payment_method = 'TRUE'; # 10451




# Creat list_info from mubi_lists_data
SELECT COUNT(DISTINCT list_id) FROM mubi_lists_data; # 80281
## creat table
CREATE TABLE list_info (
    list_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    list_title VARCHAR(500),
    list_movie_number INTEGER,
    list_update_timestamp_utc VARCHAR(160),
    list_creation_timestamp_utc VARCHAR(160),
    list_followers INTEGER,
    list_url VARCHAR(500),
    list_comments INTEGER,
	list_cover_image_url VARCHAR(500),
	list_first_image_url VARCHAR(500),
	list_second_image_url VARCHAR(500),
	list_third_image_url VARCHAR(500),
    PRIMARY KEY(list_id),
    FOREIGN KEY (user_id)
    REFERENCES user_info(user_id)
);

## insert values into table
INSERT INTO list_info (list_id, user_id, list_title, list_movie_number, list_update_timestamp_utc,
list_creation_timestamp_utc, list_followers, list_url,  list_comments, list_cover_image_url, 
list_first_image_url, list_second_image_url, list_third_image_url)  
SELECT DISTINCT list_id, user_id, list_title, list_movie_number, list_update_timestamp_utc,
list_creation_timestamp_utc, list_followers, list_url,  list_comments, list_cover_image_url, 
list_first_image_url, list_second_image_url, list_third_image_url
FROM mubi_lists_data;

## Some analysis
SELECT COUNT(*) FROM list_info; # 80281
SELECT COUNT(distinct list_id) from list_info; # 80281
SELECT count(distinct user_id) from list_info; # 23113





## creat movie table
CREATE TABLE movie_info (
    movie_id INTEGER NOT NULL,
    movie_title VARCHAR(500) NOT NULL,
    movie_release_year INTEGER NOT NULL,
    movie_url VARCHAR(500) NOT NULL,
    movie_title_language VARCHAR(160) NOT NULL,
    movie_popularity INTEGER NOT NULL,
    PRIMARY KEY(movie_id)
);

## insert values into table
INSERT INTO movie_info (movie_id, movie_title, movie_release_year, movie_url, 
movie_title_language, movie_popularity)  
SELECT DISTINCT movie_id, movie_title, movie_release_year, movie_url, 
movie_title_language, movie_popularity
FROM mubi_movie_data;

## Some analysis
SELECT COUNT(*) FROM movie_info; # 226568
SELECT COUNT(distinct movie_id) from movie_info; # 226568




SELECT COUNT(distinct user_id) from mubi_ratings_data; # 131178
SELECT COUNT(distinct user_id) from mubi_ratings_user_data; # 186994




## creat ratings table
CREATE TABLE rating_info (
    rating_id INTEGER NOT NULL,
    rating_url VARCHAR(500) NOT NULL,
    rating_score INTEGER NOT NULL,
    rating_timestamp_utc VARCHAR(160) NOT NULL,
    movie_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    PRIMARY KEY(rating_id)
);

## insert values into table
INSERT INTO rating_info (rating_id, rating_url, rating_score, rating_timestamp_utc, movie_id, user_id)  
SELECT DISTINCT rating_id, rating_url, rating_score, rating_timestamp_utc, movie_id, user_id
FROM mubi_ratings_data;

## Some analysis
SELECT COUNT(*) FROM rating_info; # 1047190
SELECT COUNT(distinct rating_id) from rating_info; # 1047190
SELECT COUNT(distinct movie_id) from rating_info; # 842
SELECT COUNT(distinct user_id) from rating_info; # 131178

#
DELETE FROM rating_info WHERE movie_id=0;

## Set FKs
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE `mubi_database`.`rating_info` 
ADD CONSTRAINT `movie_id`
  FOREIGN KEY (`movie_id`)
  REFERENCES `mubi_database`.`movie_info` (`movie_id`);
  





## creat ratings_user_info table
CREATE TABLE ratings_user_info (
    user_id INTEGER NOT NULL,
    user_trialist VARCHAR(160) NOT NULL,
    user_subscriber VARCHAR(160) NOT NULL,
    user_eligible_for_trial VARCHAR(160) NOT NULL,
    user_has_payment_method VARCHAR(160) NOT NULL,
    PRIMARY KEY(user_id)
);

## insert values into table
INSERT INTO ratings_user_info (user_id, user_trialist, user_subscriber, 
user_eligible_for_trial, user_has_payment_method)  
SELECT DISTINCT user_id, user_trialist, user_subscriber, 
user_eligible_for_trial, user_has_payment_method
FROM mubi_ratings_data;

## Some analysis
SELECT COUNT(*) FROM ratings_user_info; # 1048575
SELECT COUNT(distinct user_id) from ratings_user_info; # 186994













