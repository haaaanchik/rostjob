# frozen_string_literal: true

namespace :geo_ru do
  desc 'Import russia'
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
  end


  desc 'Import city data'
  task import_city_data: :environment do
    counter = 0
    IO.foreach(Rails.root.join('public', 'cities', 'My-City-Locations-ru.csv').to_s) do |line|
      if counter == 0
        counter += 1
        next
      end

      name, synonym, fias_code, lat, long, _region_id, region = line.split(',')
      city = Geo::City.find_by(name: name)
      region = region.strip.delete('\"')
      geo_region = Geo::Region.find_by(name: region)

      if city.blank?
        p geo_region
        geo_region.cities.create(name: name, synonym: synonym, fias_code: fias_code, lat: lat, long: long)

        next
      end

      city.update(synonym: synonym, fias_code: fias_code, lat: lat, long: long)
    end
  end

  desc 'Update Cities for Tables'
  task update_cities: :environment do
    Order.find_in_batches do |batch|
      batch.each do |order|
        geo_city = Geo::City.where('LOWER(name) = :name', name: order.older_city).take
        order.update(city_id: geo_city.id) if geo_city
      end
    end

    OrderTemplate.find_in_batches do |batch|
      batch.each do |order_tmp|
        geo_city = Geo::City.where('LOWER(name) = :name', name: order_tmp.older_city).take
        order_tmp.update(city_id: geo_city.id) if geo_city
      end
    end

    ProductionSite.find_in_batches do |batch|
      batch.each do |pr|
        city = pr.older_city.gsub(/\s+/, '').gsub(/г./, '')
        geo_city = Geo::City.where('LOWER(name) = :name', name: city).take
        pr.update(city_id: geo_city.id) if geo_city
      end
    end
  end
end
