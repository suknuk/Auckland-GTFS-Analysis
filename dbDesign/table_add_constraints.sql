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
  add constraint weather_data_time_station_unique
    unique(timestamp, weather_station_id),
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

-- index for timestamp
create index weather_data_timestamp_index
  on weather_data(timestamp);


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

-- index for timestamp
create index speed_data_timestamp_index
  on speed_data(timestamp);

-- spatial index on geometry
create index speed_data_geom_index
  on speed_data using gist (point_geo);


-- function add a geom point with lat/lon data
create function add_geom_point_from_lat_lon()
RETURNS trigger AS
$$
BEGIN
  NEW.point_geo = ST_SetSRID(ST_MakePoint(NEW.lon, NEW.lat), 4326);
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

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


-- function to check weather_data entries for uniqueness before inserting
-- this is useful as the operation for checking existing entries can be
-- ignored. In case of restarting the weather_service container will also
-- not produce duplicates or error messages
create function check_weather_data_entry_unique()
RETURNS trigger as 
$$
BEGIN
  IF NOT EXISTS 
    (SELECT * FROM weather_data wd WHERE
      new.timestamp = wd.timestamp AND 
      new.weather_station_id = wd.weather_station_id)
  THEN
    RETURN new;
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER weather_data_uniqueness_trigger
  BEFORE INSERT OR UPDATE ON "weather_data"
  FOR EACH ROW
  EXECUTE PROCEDURE check_weather_data_entry_unique();


-- function to find the nearest weather_station point and take
-- its id when inserting new speed_data
CREATE FUNCTION find_nearest_weather_station()
RETURNS trigger AS 
$$
BEGIN
  IF EXISTS 
    (SELECT 1 from weather_station LIMIT 1)
  THEN
    NEW.weather_station_id = (
      SELECT id
      FROM weather_station
      ORDER BY point_geo <-> st_setsrid(st_makepoint(NEW.lon, NEW.lat), 4326)
      LIMIT 1);
  ELSE
    RAISE EXCEPTION 'no existing weather_station entries';
  END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER speed_data_add_nearest_weather_station_trigger
  BEFORE INSERT OR UPDATE ON "speed_data"
  FOR EACH ROW
  EXECUTE PROCEDURE find_nearest_weather_station();


-- function to check for weather_station uniqueness
-- saves checking when inserting
create function check_weather_station_unique()
RETURNS trigger as 
$$
BEGIN
  IF NOT EXISTS 
    (SELECT * FROM weather_station ws WHERE
      new.id = ws.id)
  THEN
    RETURN new;
  ELSE
    RETURN NULL;
  END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER weather_station_uniqueness_trigger
  BEFORE INSERT OR UPDATE ON "weather_station"
  FOR EACH ROW
  EXECUTE PROCEDURE check_weather_station_unique();


commit;

-- unix timestamp + NZ timezone for day of the week
-- select extract(isodow from timestamp 'epoch' + (1520085600 + 46800) * interval '1 second');
