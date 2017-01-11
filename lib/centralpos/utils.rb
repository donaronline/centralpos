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

    private

    def attr_inspect
      []
    end
  end
end
