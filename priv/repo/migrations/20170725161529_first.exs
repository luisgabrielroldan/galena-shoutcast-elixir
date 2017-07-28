defmodule GalenaServer.Repo.Migrations.First do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :name, :string, null: false
      add :portbase, :integer, null: false
      add :password, :string, null: false
      add :admin_password, :string, null: false
      add :maxuser, :integer, null: false
      add :active, :boolean
      add :pid, :integer, null: false, default: 0
    end
  end
end
