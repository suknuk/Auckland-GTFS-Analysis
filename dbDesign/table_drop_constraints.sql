drop trigger if exists speed_data_geom_point_creation on speed_data;
drop trigger if exists weather_station_geom_point_creation on weather_station;

drop function if exists add_geom_point_from_lat_lon;


drop index speed_data_geom_index;

alter table speed_data
  alter column weather_station_id drop not null,
  alter column timestamp drop not null,
  alter column lat drop not null,
  alter column lon drop not null,
  alter column vehicle_type drop not null,
  alter column point_geo drop not null,
  drop constraint speed_data_weather_station_id_fk cascade;


alter table weather_data
  alter column timestamp drop not null,
  alter column weather_station_id drop not null,
  alter column temp drop not null,
  alter column pressure drop not null,
  alter column humidity drop not null,
  alter column wind_speed drop not null,
  alter column wind_deg drop not null,
  alter column clouds drop not null,
  alter column rain drop not null,
  alter column snow drop not null,
  alter column weather_condition_id drop not null,
  drop constraint weather_data_weather_station_id_fk,
  drop constraint weather_data_weather_condition_id_fk cascade;


drop index weather_station_geom_index;

alter table weather_station
  drop constraint weather_station_id_pk cascade,
  alter column name drop not null,
  alter column lat drop not null,
  alter column lon drop not null,
  alter column point_geo drop not null;
