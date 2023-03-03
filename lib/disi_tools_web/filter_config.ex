defmodule DisiTools.FilterConfig do
  import Filtrex.Type.Config

  def password_filter() do
    defconfig do
      number [:count]
      number [:length]
      boolean [:table]
    end
  end
end
