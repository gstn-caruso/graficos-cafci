class ApplicationController < ActionController::API
  def index
    render json: fondos_agrupados
  end

  private

  def fondos_agrupados
    Rails.cache.fetch("fondos/#{Date.today}", expires_in: 12.hours) do
      agrupados = FondoComunDeInversion.hsbc.group_by(&:fecha)

      agrupados.map do |fecha, fondos|
        rendimientos_diarios = {fecha: fecha.to_date}
        fondos
            .sort { |fondo| fondo.valor_cuotaparte.floor }
            .each { |f| rendimientos_diarios.merge!({f.nombre => f.valor_cuotaparte}) }

        rendimientos_diarios
      end
    end
  end
end
