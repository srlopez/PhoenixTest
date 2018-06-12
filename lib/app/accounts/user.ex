defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string, null: false)
    field(:surname, :string)

    has_one :credential, App.Accounts.Credential
    has_many :messages, App.Chat.Message


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name])
  end
end
