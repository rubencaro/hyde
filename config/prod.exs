use Mix.Config

# Do not print debug messages in production
config :logger,
  level: :error,
  handle_otp_reports: false,
  handle_sasl_reports: false
