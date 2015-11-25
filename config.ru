require_relative 'lib/sir_handel'

Blocktrain::Lookups.instance.fetch_from_redis

run SirHandel::App
