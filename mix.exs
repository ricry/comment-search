defmodule CommentSearch.MixProject do
  use Mix.Project

  def project do
    [
      app: :comment_search,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :if_ok, :timex, :tzdata]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0.0"},
      {:poison, "3.1.0"},
      {:if_ok, "~> 0.1.0"},
      {:timex, "~> 3.1"},
      {:tzdata, "~> 0.1.8", override: true}
    ]
  end

  defp escript_config do
    [ main_module: CommentSearch.CLI ]
  end
end
