defmodule CommentSearch.CLI do

  import CommentSearch.NicoSearch, only: [fetch: 1, search: 2, get_fields: 2]

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

      { _, [ id, word , fields ], _ }
        -> { id, word , fields }

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
    fetch(id)
    |> search(word)
  end

  def process({id, word, fields}) do
    fetch(id)
    |> search(word)
    |> get_fields(fields)
  end
end
