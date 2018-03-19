defmodule TestCli do
  use ExUnit.Case
  doctest CommentSearch

  import CommentSearch.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
    assert false
  end

  test "a tuple of id and word returned if two given" do
    assert parse_args(["id", "word"]) == { "id", "word" }
  end
end
