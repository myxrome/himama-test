# frozen_string_literal: true

json.extract! clock_log, :id, :clocked_in_at, :clocked_out_at
json.url clock_log_url(clock_log, format: :json)
