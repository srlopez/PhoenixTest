defmodule App.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field(:body, :string)
    field(:name, :string)
    # field :user_id, :id
    # field :room_id, :id

    belongs_to(:room, App.Chat.Room)
    belongs_to(:user, App.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :body, :user_id, :room_id])
    |> validate_required([:name, :body, :user_id, :room_id])
  end
end
