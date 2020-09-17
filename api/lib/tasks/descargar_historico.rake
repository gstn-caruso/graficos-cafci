require 'net/http'

namespace :descargar do
  desc 'Descargar información histórica de la CAFCI'

  task :historico, [:fecha_inicio] => :environment do |_, args|
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    api_url = 'https://api.cafci.org.ar/estadisticas/informacion/diaria/3/'
    inicio_historico = DateTime.strptime(args[:fecha_inicio], '%Y-%m-%d') || 1.year.ago

    ventana_de_tiempo = ((inicio_historico)..(1.day.ago))
    rango_de_fechas = (ventana_de_tiempo.begin.to_date..ventana_de_tiempo.last.to_date)
    fondos_hsbc_parseados = []

    rango_de_fechas.each do |fecha|
      begin

        next if fecha.sunday? || fecha.saturday?

        sleep(0.25)

        puts("HTTP - GET fecha #{fecha}")
        url_fecha = URI(api_url + fecha.strftime('%Y-%m-%d'))
        respuesta = JSON.parse(Net::HTTP.get(url_fecha))['data']

        next if respuesta.blank?

        fondos_hsbc = respuesta.select { |r| FondoComunDeInversion::FONDOS_HSBC.include? r['fondo'] }

        fondos_hsbc_parseados << fondos_hsbc.map do |f|
          {
              nombre: f['fondo'],
              fecha: DateTime.strptime(f['fecha'], '%d/%m/%y'),
              valor_cuotaparte: f['vcp'],
          }
        end

        puts("HTTP - GET fondo encontrado")
      end

      FondoComunDeInversion.create!(fondos_hsbc_parseados)
    rescue => e
      puts("HTTP - GET fallo: #{e}")
      next
    end
  end
end
