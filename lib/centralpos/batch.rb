module Centralpos
  class Batch
    include Utils
    attr_reader :id, :card, :status, :period

    def initialize(account: nil, **params)
      @account = account if account && account.is_a?(Centralpos::Account)
      @id = params.delete(:id) || params.delete(:id_presentacion)
      process_data(params)
    end

    def transactions
      ensure_account_valid!

      @account.gateway.call(:list_registros, batch_params)
    end

    def add_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)

      @account.gateway.call(:add_registro, batch_params.merge(transaction.to_add_params))
    end

    def remove_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)

      @account.gateway.call(:del_registro, batch_params.merge(transaction.to_remove_params))
    end

    def update_transaction(transaction)
      ensure_account_valid! && ensure_transaction_valid!(transaction)
      remove_transaction(transaction)
      add_transaction(transaction)
    end

    def process
      ensure_account_valid!

      @account.gateway.call(:put_procesa_presentacion, batch_params)
    end

    def response
      ensure_account_valid!

      @account.gateway.call(:get_respuesta_presentacion, batch_params)
    end

    private

    def batch_params
      {
        "IdPresentacion" => @id
      }
    end

    def attr_inspect
      [ :id, :card, :period ]
    end

    def process_data(data)
      return if data.nil? || data.blank?

      @card = data[:tarjeta]
      @card_id = data[:id_tarjeta]
      @period = data[:periodo]
      @commerce_number = data[:numero_de_comercio]
      @repetition_number = data[:numero_repeticion]
      @status_id = data[:id_estado]
      @status = data[:estado]
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
