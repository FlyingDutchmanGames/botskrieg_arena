defmodule BotskriegArena.Lua do
  defmodule State do
    defstruct [:lua_state]
  end

  @type source_code :: String.t()
  @type compiled_code :: term()
  @type compilation_failure :: {:error, term(), term()}
  @type table_path :: [String.t(), ...]

  # 1 Mbit in machine words
  # https://erlang.org/doc/man/erlang.html#process_flag-2
  @default_max_heap_size round(125_000 / :erlang.system_info(:wordsize))

  # https://erlang.org/doc/man/erlang.html#type-spawn_opt_option
  @default_sandbox %{
    priority: :low,
    max_reductions: 100_000,
    # Milliseconds
    timeout: 1000,
    # As of Jan 21 2021 there isn't a way to detect if a timeout is from running
    # out of memory or from running out of time, it 100% does blow up when it
    # runs out of memory on the heap though!
    max_heap_size: @default_max_heap_size
  }

  @spec init_sandboxed :: %State{}
  def init_sandboxed do
    %State{lua_state: :luerl_sandbox.init()}
  end

  @spec compile(source_code, %State{}) ::
          {:ok, compiled_code(), %State{}} | compilation_failure()
  def compile(source_code, %State{lua_state: lua_state} = state) do
    case :luerl.load(source_code, lua_state) do
      {:ok, compiled_code, lua_state} ->
        {:ok, compiled_code, %State{state | lua_state: lua_state}}

      {:error, _, _} = err ->
        err
    end
  end

  @spec run_sandboxed(%State{}, source_code(), map) :: {any(), %State{}}
  def run_sandboxed(%State{lua_state: lua_state} = state, code, opts \\ %{}) do
    flags =
      @default_sandbox
      |> Map.merge(opts)
      |> update_in([:max_heap_size], &%{size: &1, kill: false, error_logger: false})
      |> Enum.into([])

    :luerl_sandbox.run(
      code,
      lua_state,
      flags[:max_reductions],
      Keyword.take(flags, [:priority, :max_heap_size]),
      flags[:timeout]
    )
    |> case do
      {:error, _} = err -> err
      {result, new_lua_state} -> {result, %State{state | lua_state: new_lua_state}}
    end
  end

  @spec set_on_table(%State{}, table_path(), any()) :: %State{}
  def set_on_table(%State{lua_state: lua_state} = state, path, value) do
    new_state = :luerl.set_table(path, value, lua_state)
    %State{state | lua_state: new_state}
  end

  @spec read_from_table(%State{}, table_path) :: {any(), %State{}}
  def read_from_table(%State{lua_state: lua_state} = state, path) do
    {result, new_state} = :luerl.get_table(path, lua_state)
    {result, %State{state | lua_state: new_state}}
  end
end
