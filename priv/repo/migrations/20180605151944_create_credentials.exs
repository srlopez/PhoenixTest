defmodule App.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:credentials, [:email])
  end
end
