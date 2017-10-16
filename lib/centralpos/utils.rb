module Centralpos
  module Utils
    extend self

    def inspect
      formatted_attrs = attr_inspect.map do |attr|
        "#{attr}: #{send(attr).inspect}"
      end
      "#<#{self.class.name} #{formatted_attrs.join(", ")}>"
    end

    def ensure_array(stuff)
      [stuff].flatten(1)
    end

    def in_time_zone(datetime)
      return datetime unless datetime && Centralpos.override_timezone

      datetime.change(offset: Centralpos.default_timezone)
    end

    private

    def attr_inspect
      []
    end
  end
end
