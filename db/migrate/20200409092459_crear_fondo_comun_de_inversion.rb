class CrearFondoComunDeInversion < ActiveRecord::Migration[6.0]
  def change
    create_table :fondos_comunes_de_inversion do |t|
      t.string :nombre, null: false
      t.datetime :fecha, null: false
      t.float :valor_cuotaparte, null: false
      t.float :cantidad_cuotaparte
      t.float :patrimonio

      t.timestamps
    end
  end
end
