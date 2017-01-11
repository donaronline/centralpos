module Centralpos
  class Transaction
    include Utils
    MD5_DIGEST = OpenSSL::Digest.new("md5").freeze
    UPDATABLE_VALUES = [ :cc_number, :amount, :optional_data_1, :optional_data_2 ].freeze
    attr_reader :id, :owner_id

    def initialize(owner_id:, cc_number:, amount:, optional_data_1: "", optional_data_2: "")
      @id = md5("#{owner_id}-#{cc_number}")
      @owner_id = owner_id
      @cc_number = cc_number
      @amount = amount.to_s
      @optional_data_1 = optional_data_1
      @optional_data_2 = optional_data_2
    end
    UPDATABLE_VALUES.each do |key|
      define_method("#{key}=") do |value|
        instance_variable_set("@#{key}", value)
      end
    end

    def valid?
      !invalid?
    end

    def invalid?
      @owner_id.empty? || @cc_number.empty? || !@amount || @amount <= 0.0
    end

    def to_add_params
      {
        "DatoOpcional1" => @optional_data_1,
        "DatoOpcional2" => @optional_data_2,
        "IdUser"        => @owner_id,
        "NroTarjeta"    => @cc_number,
        "Importe"       => @amount
      }
    end

    def to_remove_params
      {
        "IdUser" => owner_id
      }
    end

    private

    def attr_inspect
      [ :id ]
    end

    def md5(string)
      MD5_DIGEST.hexdigest(string)
    end
  end
end