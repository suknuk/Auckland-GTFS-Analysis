begin;

alter table weather_station
  add constraint weather_station_id_pk
    primary key(id),
  alter column name set not null,
  alter column lat set not null,
  alter column lon set not null,
  alter column point_geo set not null;

-- spatial index on geometry
create index weather_station_geom_index
  on weather_station using gist (point_geo);


alter table weather_data
  alter column timestamp set not null,
  alter column weather_station_id set not null,
  alter column temp set not null,
  alter column pressure set not null,
  alter column humidity set not null,
  alter column wind_speed set not null,
  alter column wind_deg set not null,
  alter column clouds set not null,
  alter column rain set not null,
  alter column snow set not null,
  alter column weather_condition_id set not null,
  add constraint weather_data_weather_station_id_fk
    foreign key (weather_station_id)
    references weather_station(id),
  add constraint weather_data_weather_condition_id_fk
    foreign key (weather_condition_id)
    references weather_condition(weather_id);


alter table speed_data
  alter column weather_station_id set not null,
  alter column timestamp set not null,
  alter column lat set not null,
  alter column lon set not null,
  alter column vehicle_type set not null,
  alter column point_geo set not null,
  add constraint speed_data_weather_station_id_fk
    foreign key (weather_station_id)
    references weather_station(id);

-- spatial index on geometry
create index speed_data_geom_index
  on speed_data using gist (point_geo);


-- function add a geom point with lat/lon data
create function add_geom_point_from_lat_lon()
RETURNS trigger AS '
BEGIN
  NEW.point_geo = ST_SetSRID(ST_MakePoint(NEW.lon, NEW.lat), 4326);
  RETURN NEW;
END' LANGUAGE 'plpgsql';

--trigger on weather_station to create the geometry attribute
CREATE TRIGGER weather_station_geom_point_creation
  BEFORE INSERT OR UPDATE ON "weather_station"
  FOR EACH ROW
  EXECUTE PROCEDURE add_geom_point_from_lat_lon();

--trigger on speed_data to create the geometry attribute
CREATE TRIGGER speed_data_geom_point_creation
  BEFORE INSERT OR UPDATE ON "speed_data"
  FOR EACH ROW
  EXECUTE PROCEDURE add_geom_point_from_lat_lon();

commit;
