# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClockLogsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/clock_logs').to route_to('clock_logs#index')
    end

    it 'routes to #show' do
      expect(get: '/clock_logs/1').to route_to('clock_logs#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/clock_logs').to route_to('clock_logs#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/clock_logs/1').to route_to('clock_logs#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/clock_logs/1').to route_to('clock_logs#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/clock_logs/1').to route_to('clock_logs#destroy', id: '1')
    end
  end
end
