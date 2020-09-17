require 'net/http'

namespace :descargar do
  desc 'Descargar información del día actual de la CAFCI'

  task informe_diario: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    api_url = 'https://api.cafci.org.ar/estadisticas/informacion/diaria/3/'
    fecha = Date.today

    if !fecha.sunday? && !fecha.saturday?
      puts("HTTP - GET fecha #{fecha}")

      url_fecha = URI(api_url + fecha.strftime('%Y-%m-%d'))
      respuesta = JSON.parse(Net::HTTP.get(url_fecha))['data']

      unless respuesta.blank?
        puts(respuesta)

        fondos_hsbc = respuesta.select { |r| FondoComunDeInversion::FONDOS_HSBC.include? r['fondo'] }

        fondos_hsbc_parseados = fondos_hsbc.map do |f|
          {
              nombre: f['fondo'],
              fecha: DateTime.strptime(f['fecha'], '%d/%m/%y'),
              valor_cuotaparte: f['vcp'],
          }
        end

        FondoComunDeInversion.create!(fondos_hsbc_parseados)
      end
    end
  end
end