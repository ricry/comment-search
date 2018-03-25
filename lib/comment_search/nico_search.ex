defmodule CommentSearch.NicoSearch do
  @cookie [ {"Cookie", "user_session=user_session_26841853_9a4b84bf71230281e99005aaf6a1ab23354291e2ee8172c5cff99d20e4aea263;"} ]

  def fetch(id) do
    get_url(id)
    |> HTTPoison.get!()
    |> Map.fetch!(:body)
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

  def fetch_comment(%{"chat" => chat}) do
    %{ no: chat["no"], date: date_format(chat["date"]), time: vpos2time_string(chat["vpos"]), comment: chat["content"] }
  end

  def fetch_comment(%{}) do
    nil
  end

  def date_format(date) do
    DateTime.from_unix!(date)
    |> Timex.Timezone.convert("Asia/Tokyo")
    |> Timex.format!("%Y/%0m/%0d %H:%M:%S", :strftime)
  end

  def vpos2time_string(vpos) do
    minutes = "#{div(vpos, 6000)}" |> String.pad_leading(2, "0")
    seconds = "#{rem(vpos, 6000) |> div(100)}" |> String.pad_leading(2, "0")
    "#{minutes}:#{seconds}"
  end

  def search(list, word) do
    list
    |> Enum.filter(&comment_filter(&1[:comment], word))
  end

  def comment_filter(str, word) do
    str != nil and String.contains?(str, word)
  end

  def get_fields(list, fields) do
    fields_list = String.split(fields, ",")
    |> Enum.map(&String.to_atom(&1))
    list
    |> Enum.map(&Map.take(&1, fields_list))
  end
end
