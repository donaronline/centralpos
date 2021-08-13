module Centralpos
  class Batch
    include Utils
    attr_reader :id, :card_id, :card, :status_id, :status, :period, :date_since, :date_until, :processed_date, :commerce_number

    def initialize(account: nil, **params)
      @account = account if account && account.is_a?(Centralpos::Account)
      @id = params.delete(:id) || params.delete(:id_presentacion)
      process_data(params)
    end

    def transactions
      ensure_account_valid!

      response = @account.gateway.call(:list_registros, batch_params)

      if response[:success] && response[:error].nil?
        return [] if response[:result][:lista_registros].nil?

        entries = ensure_array(response[:result][:lista_registros][:registro])
        entries.map do |entries_data|
          Centralpos::Transaction.load_it(entries_data.merge(batch: self))
        end
      else
        response
      end
    end

    def add_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)

      response = @account.gateway.call(:add_registro, batch_params.merge(transaction.to_add_params))

      if response[:success] && response[:error].nil?
        { transaction: transaction.to_hash, response: response }
      else
        response
      end
    end

    def remove_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)

      response = @account.gateway.call(:del_registro, batch_params.merge(transaction.to_remove_params))

      if response[:success] && response[:error].nil?
        { transaction: transaction.to_hash, response: response }
      else
        response
      end
    end

    def update_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)
      remove_transaction(transaction)
      add_transaction(transaction)
    end

    def has_transaction?(transaction)
      transactions_by_id.key?(transaction.owner_id)
    end

    def get_transaction(transaction)
      return unless has_transaction?(transaction)

      { transaction: transactions_by_id.fetch(transaction.owner_id) }
    end

    def can_process?(date_when = nil)
      date_when = Time.now if date_when.nil? || !date_when.is_a?(DateTime)
      date_when_utc = date_when.utc

      (@date_since.utc <= date_when_utc) && (date_when_utc <= @date_until.utc)
    end

    def process
      ensure_account_valid!

      @account.gateway.call(:put_procesa_presentacion, batch_params)
    end

    private

    def batch_params
      {
        "IdPresentacion" => @id
      }
    end

    def attr_inspect
      [ :id, :card, :period, :date_until ]
    end

    def process_data(data)
      return if data.nil? || data.blank?

      @card = data[:tarjeta]
      @card_id = data[:id_tarjeta]
      @period = data[:periodo]
      @date_since = Centralpos::Utils.in_time_zone(data[:fecha_presentacion_desde])
      @date_until = Centralpos::Utils.in_time_zone(data[:fecha_presentacion_hasta])
      @processed_date = Centralpos::Utils.in_time_zone(data[:fecha_de_procesamiento])
      @commerce_number = data[:numero_de_comercio]
      @repetition_number = data[:numero_repeticion]
      @status_id = data[:id_estado]
      @status = data[:estado]
    end

    def transactions_by_id
      return @transactions_by_id unless @transactions_by_id.nil?

      @transactions_by_id = transactions.each_with_object({}) do |transaction, _hash|
        _hash[transaction.owner_id] = transaction
      end
    end

    def ensure_transaction_valid!(transaction)
      unless transaction.is_a?(Centralpos::Transaction) && transaction.valid?
        raise AccountError.new("You should provide a transaction to be added to the batch, and it should be a Centralpos::Transaction instance")
      end
    end

    def ensure_account_valid!
      unless @account && @account.is_a?(Centralpos::Account)
        raise AccountError.new("You should provide an account for the batch, and it should be a Centralpos::Account instance")
      end
    end

  end
end
