defmodule CommentSearch.CLI do

  alias CommentSearch.NicoSearch

  def main(argv) do
    argv
    |> parse_args()
    |> process()
    |> IO.inspect()
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do

      { [ help: true ], _, _ }
        -> :help

      { _, [ id, word ], _ }
        -> { id, word }

      _ -> :help

    end
  end

  def process(:help) do
    IO.puts """
    usage: comment_search <id> <word>
    """
    System.halt(0)
  end

  def process({id, word}) do
    NicoSearch.fetch(id)
    |> NicoSearch.search(word)
  end
end
