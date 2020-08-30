module ZarplataRu
  module Search
    class << self
      include ZarplataRu::Base

      def rubrics
        get_search(rubrics_url)
      end

      def specialties(parent_id)
        return { rubrics: [] } if parent_id.blank?

        get_search(rubrics_url('&parent_id=' + parent_id))
      end

      def city(term)
        return { geo: [] } if term.blank?

        get_search(city_url(term))
      end

      private

      def rubrics_url(params = '')
        zarplata_config[:api_url] + '/rubrics?' + params
      end

      def city_url(term)
        zarplata_config[:api_url] + '/geo?' + uri_encode('q=' + term)
      end
    end
  end
end