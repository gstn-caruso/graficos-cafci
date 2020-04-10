class AgregarUnicidadFciPorFecha < ActiveRecord::Migration[6.0]
  def change
    add_index :fondos_comunes_de_inversion, [:fecha, :nombre, :valor_cuotaparte], unique: true, name: :unicidad_por_fecha
  end
end
