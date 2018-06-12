defmodule App.Auth.ContactForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:full_name, :string)
    field(:email, :string)
    field(:message, :string)
    field(:accept_tos, :boolean)
  end

  @fields ~w(full_name email message accept_tos)a

  def new_contact_form(params \\ %{}) do
    cast(%__MODULE__{}, params, @fields)
  end

  def do_contact(attrs) do
    case contact_changeset(attrs) do
      %Ecto.Changeset{valid?: true, changes: data} ->
        data
        IO.inspect("New message from #{data.full_name}:")
        IO.inspect(data.message)
        {:ok, data}

      changeset ->
        changeset
        # Importante! -> {:error, changeset}
        |> apply_action(:insert)
    end
  end

  @doc false
  defp contact_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@/)
    |> validate_acceptance(:accept_tos)
  end
end
