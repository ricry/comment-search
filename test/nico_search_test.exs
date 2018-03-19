defmodule NicoSearchTest do
  use ExUnit.Case
  doctest CommentSearch.NicoSearch

  import CommentSearch.NicoSearch

  test "get endpoint" do
    url = get_url("sm29945774")
    assert url == "http://nmsg.nicovideo.jp/api.json/thread?version=20090904&thread=1477927266&res_from=-100"
  end
end
