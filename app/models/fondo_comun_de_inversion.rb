class FondoComunDeInversion < ApplicationRecord
  self.table_name = 'fondos_comunes_de_inversion'
  validates_presence_of :nombre, :fecha, :valor_cuotaparte
end
