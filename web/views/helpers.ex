require IEx

defmodule PitchIn.ViewHelpers do
  import PitchIn.Router.Helpers
  use Phoenix.HTML

  @moduledoc """
  This module holds random shared helpers for the views.
  """

  @doc """
  Convert an enum to an options list for a select input.
  """
  def enum_to_options(enum_module) do
    enum_module.__enum_map__()
    |> Keyword.keys
    |> Enum.reverse
    |> Enum.reduce([], fn atom, acc ->
      Keyword.put(acc, String.to_atom(titleize_key(atom)), atom)
    end)
  end

  @doc """
  Converts a snake case atom or string to a capitalized string with spaces.
  """
  def titleize_key(atom) when is_atom(atom), do: titleize_key(Atom.to_string(atom))
  def titleize_key(key) do
    key
    |> String.split("_")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  def webpack_path(conn, path) do
    if Mix.env == :dev do
      "http://localhost:4001#{path}"
    else
      static_path(conn, path)
    end
  end

  @doc """
  Like update_in, but works with structs.
  """
  def update_in_struct(struct, [], f), do: f.(struct)
  def update_in_struct(struct, [key | keys], f) do
    Map.update!(struct, key, &(update_in_struct(&1, keys, f)))
    |> IO.inspect
  end

  ##############
  # Formatters #
  ##############
  def format_date(date) do
    Timex.format!(date, "%m/%d/%Y", :strftime)
  end

  def format_phone(phone) do
    [_ | parts] = Regex.run(~r/(\d\d\d)(\d\d\d)(\d\d\d\d)/, phone)
    Enum.join(parts, "-")
  end

  def format_url(nil), do: ""
  def format_url(""), do: ""
  def format_url(url) do
    link(url, to: url)
  end
end
