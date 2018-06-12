defmodule AppWeb.RoomChannel do
  use AppWeb, :channel
  alias AppWeb.Presence


  def join("room:" <> _room_id, payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
      #{:ok, %{channel: "room:#{room_id}"}, assign(socket, :room_id, room_id)
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    user =  App.Accounts.get_user! socket.assigns[:current_user_id]
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      typing: false,
      user_id: user.id,
      name: user.name,
      # online_at: inspect(System.system_time(:seconds))
    })
    {:noreply, socket}
  end

  def handle_in("message:add", payload, socket) do
    #IO.inspect payload
    App.Chat.create_message payload #%{ body: "body", name: "name", user_id: 1, room_id: 1}
    broadcast socket, "message:new", payload
    {:reply, :ok, socket}
  end

  def handle_in("user:typing", %{"typing" => typing, "name" => name}, socket) do
    # user =  App.Accounts.get_user! socket.assigns[:current_user_id]
    # Miedo da hacer un query a la base de dabtos cada vez que se aprieta o levanta una teclea
    # Así que paso lo que se pueda en el mensaje

    {:ok, _} = Presence.update(socket, "user:#{socket.assigns[:current_user_id]}", %{
      typing: typing,
      user_id: socket.assigns[:current_user_id], #user.id,
      name: name #user.name
    })

    {:reply, :ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    # IO.inspect payload
    true
  end
end
