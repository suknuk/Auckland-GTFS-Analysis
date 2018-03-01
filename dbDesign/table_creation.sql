

begin;

create table weather_condition (
	weather_id int PRIMARY KEY,
	meaning text
);

-- weather id codes
insert into weather_condition(weather_id,meaning) values(200,'thunderstorm with light rain');
insert into weather_condition(weather_id,meaning) values(201,'thunderstorm with rain');
insert into weather_condition(weather_id,meaning) values(202,'thunderstorm with heavy rain');
insert into weather_condition(weather_id,meaning) values(210,'light thunderstorm');
insert into weather_condition(weather_id,meaning) values(211,'thunderstorm');
insert into weather_condition(weather_id,meaning) values(212,'heavy thunderstorm');
insert into weather_condition(weather_id,meaning) values(221,'ragged thunderstorm');
insert into weather_condition(weather_id,meaning) values(230,'thunderstorm with light drizzle');
insert into weather_condition(weather_id,meaning) values(231,'thunderstorm with drizzle');
insert into weather_condition(weather_id,meaning) values(232,'thunderstorm with heavy drizzle ');
insert into weather_condition(weather_id,meaning) values(300,'light intensity drizzle');
insert into weather_condition(weather_id,meaning) values(301,'drizzle');
insert into weather_condition(weather_id,meaning) values(302,'heavy intensity drizzle');
insert into weather_condition(weather_id,meaning) values(310,'light intensity drizzle rain');
insert into weather_condition(weather_id,meaning) values(311,'drizzle rain');
insert into weather_condition(weather_id,meaning) values(312,'heavy intensity drizzle rain');
insert into weather_condition(weather_id,meaning) values(313,'shower rain and drizzle');
insert into weather_condition(weather_id,meaning) values(314,'heavy shower rain and drizzle');
insert into weather_condition(weather_id,meaning) values(321,'shower drizzle');
insert into weather_condition(weather_id,meaning) values(500,'light rain');
insert into weather_condition(weather_id,meaning) values(501,'moderate rain');
insert into weather_condition(weather_id,meaning) values(502,'heavy intensity rain');
insert into weather_condition(weather_id,meaning) values(503,'very heavy rain');
insert into weather_condition(weather_id,meaning) values(504,'extreme rain');
insert into weather_condition(weather_id,meaning) values(511,'freezing rain');
insert into weather_condition(weather_id,meaning) values(520,'light intensity shower rain');
insert into weather_condition(weather_id,meaning) values(521,'shower rain');
insert into weather_condition(weather_id,meaning) values(522,'heavy intensity shower rain');
insert into weather_condition(weather_id,meaning) values(531,'ragged shower rain');
insert into weather_condition(weather_id,meaning) values(600,'light snow');
insert into weather_condition(weather_id,meaning) values(601,'snow');
insert into weather_condition(weather_id,meaning) values(602,'heavy snow');
insert into weather_condition(weather_id,meaning) values(611,'sleet');
insert into weather_condition(weather_id,meaning) values(612,'shower sleet');
insert into weather_condition(weather_id,meaning) values(615,'light rain and snow');
insert into weather_condition(weather_id,meaning) values(616,'rain and snow');
insert into weather_condition(weather_id,meaning) values(620,'light shower snow');
insert into weather_condition(weather_id,meaning) values(621,'shower snow');
insert into weather_condition(weather_id,meaning) values(622,'heavy shower snow');
insert into weather_condition(weather_id,meaning) values(701,'mist');
insert into weather_condition(weather_id,meaning) values(711,'smoke');
insert into weather_condition(weather_id,meaning) values(721,'haze');
insert into weather_condition(weather_id,meaning) values(731,'sand, dust whirls');
insert into weather_condition(weather_id,meaning) values(741,'fog');
insert into weather_condition(weather_id,meaning) values(751,'sand');
insert into weather_condition(weather_id,meaning) values(761,'dust');
insert into weather_condition(weather_id,meaning) values(762,'volcanic ash');
insert into weather_condition(weather_id,meaning) values(771,'squalls');
insert into weather_condition(weather_id,meaning) values(781,'tornado');
insert into weather_condition(weather_id,meaning) values(800,'clear sky');
insert into weather_condition(weather_id,meaning) values(801,'few clouds ');
insert into weather_condition(weather_id,meaning) values(802,'scattered clouds');
insert into weather_condition(weather_id,meaning) values(803,'broken clouds');
insert into weather_condition(weather_id,meaning) values(804,'overcast clouds');
insert into weather_condition(weather_id,meaning) values(900,'tornado');
insert into weather_condition(weather_id,meaning) values(901,'tropical storm');
insert into weather_condition(weather_id,meaning) values(902,'hurricane');
insert into weather_condition(weather_id,meaning) values(903,'cold');
insert into weather_condition(weather_id,meaning) values(904,'hot');
insert into weather_condition(weather_id,meaning) values(905,'windy');
insert into weather_condition(weather_id,meaning) values(906,'hail');
insert into weather_condition(weather_id,meaning) values(951,'calm');
insert into weather_condition(weather_id,meaning) values(952,'light breeze');
insert into weather_condition(weather_id,meaning) values(953,'gentle breeze');
insert into weather_condition(weather_id,meaning) values(954,'moderate breeze');
insert into weather_condition(weather_id,meaning) values(955,'fresh breeze');
insert into weather_condition(weather_id,meaning) values(956,'strong breeze');
insert into weather_condition(weather_id,meaning) values(957,'high wind, near gale');
insert into weather_condition(weather_id,meaning) values(958,'gale');
insert into weather_condition(weather_id,meaning) values(959,'severe gale');
insert into weather_condition(weather_id,meaning) values(960,'storm');
insert into weather_condition(weather_id,meaning) values(961,'violent storm');
insert into weather_condition(weather_id,meaning) values(962,'hurricane');

commit;

