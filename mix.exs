defmodule BotskriegArena.MixProject do
  use Mix.Project

  def project do
    [
      app: :botskrieg_arena,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:luerl, "~> 0.4.0"},
      {:table_top_ex, git: "https://github.com/FlyingDutchmanGames/table_top_ex.git"}
    ]
  end
end
