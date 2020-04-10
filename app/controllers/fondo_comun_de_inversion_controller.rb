class FondoComunDeInversionController < ApplicationController
  def index
    agrupados = FondoComunDeInversion.hsbc.group_by(&:fecha)

    fondos_de_inversion = agrupados.map do |fecha, fondos|
      rendimientos_diarios = {fecha: fecha.to_date}
      fondos
          .sort { |fondo| fondo.valor_cuotaparte.floor }
          .each { |f| rendimientos_diarios.merge!({f.nombre => f.valor_cuotaparte}) }

      rendimientos_diarios
    end

    render json: fondos_de_inversion
  end
end
