defmodule CommentSearch.NicoSearch do
  @cookie [ {"Cookie", "user_session=user_session_26841853_9a4b84bf71230281e99005aaf6a1ab23354291e2ee8172c5cff99d20e4aea263;"} ]

  def fetch(id) do
    get_url(id)
    |> HTTPoison.get!()
    |> get_body()
    |> Poison.decode!()
    |> Enum.map(&fetch_comment(&1))
    |> Enum.filter(&(&1 != nil))
  end

  def get_url(id) do
    get_thread_id(id)
    |> get_url_by_thread_id()
  end

  def get_thread_id(id) do
    response = "http://flapi.nicovideo.jp/api/getflv/#{id}"
    |> HTTPoison.get!(@cookie)
    qmap = response.body
    |> URI.query_decoder()
    |> Enum.map(&(&1))
    |> Enum.into(%{})
    qmap["thread_id"]
  end

  def get_url_by_thread_id(thread_id) do
    "http://nmsg.nicovideo.jp/api.json/thread?version=20090904&thread=#{thread_id}&res_from=-1000"
  end

  def get_body(response) do
    response
    |> Map.fetch(:body)
    |> elem(1)
  end

  def fetch_comment(%{"chat" => chat}) do
    chat["content"]
  end

  def fetch_comment(%{}) do
    nil
  end

  def search(list, word) do
    list
    |> Enum.filter(&String.contains?(&1, word))
  end
end
