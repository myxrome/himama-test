# frozen_string_literal: true

json.array! @clock_logs, partial: 'clock_logs/clock_log', as: :clock_log
