FROM elixir:1.14.3-otp-24

WORKDIR /tools
COPY . /tools
RUN export SECRET_KEY_BASE=$(mix phx.gen.secret)
RUN mix local.hex --force && mix local.rebar --force && mix deps.get --only prod && MIX_ENV=prod mix compile
RUN mix phx.gen.release && MIX_ENV=prod mix release

CMD ["./_build/prod/rel/disi_tools/bin/server", "start"]