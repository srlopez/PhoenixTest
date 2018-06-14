defmodule AppWeb.AppChannel do
  use AppWeb, :channel

  def join("app:" <> subtopic, payload, socket) do
    IO.inspect(payload)
    {:ok, Poison.encode!(%{channel: "app:#{subtopic}"}), socket}
  end

  # All events and payload broadcasted!
  def handle_in(event, payload, socket) do
    IO.inspect(payload)
    broadcast(socket, event, payload)
    {:reply, :ok, socket}
  end
end
