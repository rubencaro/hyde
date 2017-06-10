require Hyde.Helpers, as: H

defmodule HydeTest do
  use ExUnit.Case
  doctest Hyde

  test "ping" do
    res = H.Test.get("/ping")
    assert res.status == 200
  end

  test "not found" do
    res = H.Test.get("/heyheyheyheyh")
    assert res.status == 404
  end
end
