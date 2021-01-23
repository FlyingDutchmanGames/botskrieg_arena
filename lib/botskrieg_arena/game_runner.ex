defmodule BotskriegArena.GameRunner do
  alias BotskriegArena.GameRunner.Runnable

  def run(game_template) do
    case Runnable.next(game_template) do
      :game_over ->
        Runnable.result(game_template)

      %{commands_requests: commands_requests, timeout: timeout} ->
        run_turn(commands_requests, timeout)
    end
  end

  defp run_turn(_commands_requests, _timeout) do
  end
end
