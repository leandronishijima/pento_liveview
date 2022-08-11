defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  alias __MODULE__

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        number_to_guess: :rand.uniform(10),
        score: 0,
        win?: false,
        message: "Guess a game"
      )
    }
  end

  @impl true
  def render(assigns) do
    ~L"""
      <h1>Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
        It's <%= time() %>
      </h2>
      <h2>
        <%= unless @win? do %>
          <%= for n <- 1..10 do %>
            <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
          <% end %>
        <% else %>
          <%= live_patch "Reset game", to: Routes.live_path(@socket, WrongLive) %>
        <% end %>
      </h2>
    """
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, socket) do
    if socket.assigns.number_to_guess == String.to_integer(guess) do
      score = socket.assigns.score + 1

      {
        :noreply,
        assign(
          socket,
          message: "You win!",
          win?: true,
          score: score
        )
      }
    else
      message = "Your guess: #{guess}. Wrong. Guess again. "
      score = socket.assigns.score - 1

      {
        :noreply,
        assign(
          socket,
          message: message,
          score: score
        )
      }
    end
  end

  defp time do
    DateTime.utc_now() |> to_string
  end
end
