defmodule App.Auth.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  embedded_schema do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string)
  end

  @fields ~w(name email password password_confirmation)a
  @user_fields ~w(name email hashed_password)a

  def new_registration do
    cast(%__MODULE__{}, %{}, @fields)
  end

  def register_user(attrs) do
    case registration_changeset(attrs) do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        changes
        |> Map.take(@user_fields)
        |> App.Accounts.create_user()

      changeset ->
        changeset
        # Importante! -> {:error, changeset}
        |> apply_action(:insert)
    end
  end

  @doc false
  defp registration_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 3, max: 30)
    |> validate_confirmation(:password, message: "must match password")
    |> hash_password()
  end

  defp hash_password(%{valid?: true, changes: %{password: pass}} = changeset),
    do: put_change(changeset, :hashed_password, hashpwsalt(pass))

  defp hash_password(changeset), do: changeset
end
