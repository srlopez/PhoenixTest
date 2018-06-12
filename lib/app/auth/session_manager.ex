defmodule App.Auth.SessionManager do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias App.Accounts.Credential

  embedded_schema do
    field(:email, :string)
    field(:password, :string)
  end

  @fields ~w(email password)a

  def new_session(attrs \\ %{}) do
    cast(%__MODULE__{}, attrs, @fields)
  end

  def create_session(attrs) do
    case session_changeset(attrs) do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        changes
        |> Map.take(@fields)
        |> validate_user

      changeset ->
        changeset
        # Importante! -> {:error, changeset}
        |> apply_action(:insert)
    end
  end

  @doc false
  defp session_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
  end

  def validate_user(%{email: email, password: password} = attrs) do
    credential = App.Repo.get_by(Credential, email: email) |> App.Repo.preload([:user])

    if credential && checkpw(password, credential.hashed_password) do
      {:ok, credential.user}
    else
      dummy_checkpw()
      {:error, attrs}
    end
  end
end
