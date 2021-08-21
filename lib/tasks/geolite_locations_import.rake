# frozen_string_literal: true

namespace :custom_locations_import do
  desc 'Custom import auto Russia'
  task import: :environment do
    cities = []
    countries = {}
    regions = {}
    cities_hash = {}
    counter = 0
    IO.foreach(Rails.root.join('public', 'cities', 'GeoLite2-City-Locations-ru.csv').to_s) do |line|
      if counter == 0
        counter += 1
        next
      end
      _geoname_id, _locale_code, _continent_code, _continent_name,
          _country_iso_code, country_name, _subdivision_1_iso_code,
          subdivision_1_name, _subdivision_2_iso_code, _subdivision_2_name,
          city_name, _metro_code, _time_zone, _is_in_european_union = line.split(',')

      p line.split(',')

      subdivision_1_name = subdivision_1_name.strip.delete('\"')
      city_name = city_name.strip.delete('\"')
      next if city_name.blank?

      match_data = city_name.match(/(\p{Lower})(\p{Upper})/)
      if match_data.present?
        left, right = match_data.captures
        city_name = city_name.gsub(/(\p{Lower})(\p{Upper})/, "#{left} #{right}")
      end

      country_name = country_name.strip.delete('\"')

      next if country_name != 'Россия'

      countries[country_name] ||= Geo::Country.find_or_create_by(name: country_name)
      regions[countries[country_name].id] ||= {}
      regions[countries[country_name].id][subdivision_1_name] ||= begin
        countries[country_name].regions.find_or_create_by(name: subdivision_1_name)
      end

      cities_hash[country_name] ||= {}
      cities_hash[country_name][subdivision_1_name] ||= {}
      cities_hash[country_name][subdivision_1_name][city_name] ||= begin
        regions[countries[country_name].id][subdivision_1_name].cities.find_or_initialize_by(name: city_name)
      end
      city = cities_hash[country_name][subdivision_1_name][city_name]
      cities << city unless city.persisted?
      if cities.length == 1000
        Geo::City.import cities if cities.present?
        cities = []
        puts '1k inserted'
      end
    end

    Geo::City.import cities if cities.present?



    IO.foreach(Rails.root.join('public', 'cities', 'My-City-Locations-ru.csv').to_s) do |line|

      name, synonym, fias_code, lat, long, region_id, region = line.split(',')
      cities = Geo::City.where(name: name)

      cities.each do |city|
        if cities.count > 1 && city.region.name == region.strip.delete('\"')
          city.update(synonym: synonym, fias_code: fias_code, lat: lat, long: long)
        else
          cities.first.update(synonym: synonym, fias_code: fias_code, lat: lat, long: long)
        end
      end
    end
  end

  desc 'Import cities Russia'
  task city_import: :environment do
    counter = 0
    IO.foreach(Rails.root.join('public', 'cities', 'My-City-Locations-ru.csv').to_s) do |line|
      if counter == 0
        counter += 1
        next
      end

      _city_name, _city_synonym, _region_name = line.split(',')
      region = Geo::Region.find_by(name: _region_name.strip)

      p _region_name if region.blank?
    end
  end
end
