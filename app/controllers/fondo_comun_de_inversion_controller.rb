class FondoComunDeInversionController < ApplicationController
  def index
    agrupados = FondoComunDeInversion.all.group_by(&:fecha)

    fondos_de_inversion = agrupados.map do |fecha, fondos|
      r = {fecha: fecha.to_date}
      fondos.each { |f| r.merge!({f.nombre => f.valor_cuotaparte}) }
      r
    end

    render json: fondos_de_inversion
  end
end