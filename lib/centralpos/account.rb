# Allowed Operations:
# [
#   :add_registro,
#   :del_registro,
#   :get_estado_presentaciones,
#   :get_presentaciones_abiertas,
#   :list_registros,
#   :list_tarjetas_habilitadas,
#   :put_procesa_presentacion
# ]
#
# Deprecated Operations:
# [
#   :get_respuesta_presentacion,
#   :get_detalles_presentacion_respondida,
#   :put_datos_presentacion_abierta,
#   :get_presentaciones_futuras,
#   :get_presentaciones_respondidas
# ]
module Centralpos
  class Account
    include Utils
    attr_reader :username, :error, :gateway

    def initialize(username, password, mode = :sandbox)
      @username = username
      @gateway = Centralpos::Core::Gateway.new(username, password, mode)
      self
    end

    def sandbox
      @enabled_cards = nil
      @gateway.sandbox
    end

    def sandbox?
      @gateway.mode == :sandbox
    end

    def live
      @enabled_cards = nil
      @gateway.live
    end

    def live?
      !sandbox?
    end

    def valid?
      response = enabled_cards
      @error = response[:error]
      @error.nil?
    end

    def enabled_cards
      @enabled_cards ||= @gateway.call(:list_tarjetas_habilitadas)
    end

    def open_batches
      response = @gateway.call(:get_presentaciones_abiertas)
      if response[:success] && response[:error].nil?
        batches = ensure_array(response[:result][:lista_presentaciones][:presentacion])
        batches.map do |batch_data|
          Centralpos::Batch.new(batch_data.merge(account: self))
        end
      else
        response
      end
    end

    def batch(id)
      Centralpos::Batch.new({id: id}.merge(account: self))
    end

    def past_batches
      response = @gateway.call(:get_estado_presentaciones)
      if response[:success] && response[:error].nil?
        batches = ensure_array(response[:result][:lista_presentaciones][:presentacion_procesada])
        batches.map do |batch_data|
          Centralpos::Batch.new(batch_data.merge(account: self))
        end
      else
        response
      end
    end

    private

    def attr_inspect
      [ :username ]
    end
  end
end
