defmodule App.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credentials" do
    field(:active, :boolean, default: false)
    field(:email, :string)
    field(:hashed_password, :string)

    belongs_to(:user, App.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :hashed_password, :active])
    |> validate_required([:email, :hashed_password, :active])
    |> unique_constraint(:email)
  end
end
