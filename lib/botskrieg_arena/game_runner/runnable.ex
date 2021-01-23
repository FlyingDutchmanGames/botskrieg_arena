defprotocol BotskriegArena.GameRunner.Runnable do
  @type role :: term()
  @type commands_request :: map()

  @spec next(any()) ::
          %{
            commands_requests: %{optional(role()) => commands_request()},
            timeout: non_neg_integer()
          }
          | :game_over
  def next(template)

  def result(template)
end
