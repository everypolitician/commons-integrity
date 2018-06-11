# frozen_string_literal: true

class Commons
  class Integrity
    class Check
      # All other checks should inherit from here, and override `errors`
      class Base
        def initialize(filename, config: nil)
          @filename = filename
          @given_config = config
        end

        def errors
          []
        end

        def self.moniker
          name.sub('Commons::Integrity::Check::', '')
        end

        def applies?
          filename.fnmatch my_config.dig('AppliesTo')
        end

        private

        attr_reader :filename, :given_config

        # Simple struct to represent any errors raised
        Error = Struct.new(:category, :message, :filename)

        def error(pair)
          Error.new(*pair.first, filename)
        end

        def config
          @config ||= @given_config || Config.new
        end

        def pathname
          @pathname ||= Pathname.new(filename)
        end

        def my_config
          config.for(self.class.moniker)
        end
      end
    end
  end
end
