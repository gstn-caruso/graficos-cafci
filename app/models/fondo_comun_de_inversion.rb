class FondoComunDeInversion < ApplicationRecord
  self.table_name = 'fondos_comunes_de_inversion'
  validates_presence_of :nombre, :fecha, :valor_cuotaparte

  HEROKU_DB_LIMIT = 9_000

  HSBC_PLAZO_FIJO = ['HF Pesos - Clase G']
  HSBC_ACCIONES = [
      'HF Acciones Lideres - Clase G',
      'HF Acciones Argentinas - Clase G',
  ]
  HSBC_RENTA_FIJA = [
      'HF Pesos Plus - Clase G',
      'HF Pesos Renta Fija - Clase G',
      'HF Renta Fija Argentina - Clase G',
      'HF Renta Fija Estrategica - Clase G',
      'HF Renta Dolares - Clase G',
  ]

  FONDOS_HSBC = HSBC_RENTA_FIJA + HSBC_PLAZO_FIJO + HSBC_ACCIONES

  scope :hsbc, -> { where(nombre: FONDOS_HSBC).order('fecha ASC') }

  before_create :validar_limite_heroku

  private

  def validar_limite_heroku
    return unless Rails.env.production?
    self.class.first.destroy if self.class.count >= HEROKU_DB_LIMIT
  end
end
