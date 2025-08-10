# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ZoomV2 < OmniAuth::Strategies::OAuth2
      USER_INFO_URL = 'https://api.zoom.us/v2/users/me'

      option :name, 'zoom_v2'

      option :client_options, {
        site: 'https://zoom.us',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      }

      option :authorize_options, [:scope, :state]

      uid { raw_info['id'] }

      info do
        prune!({
          name: "#{raw_info['first_name']} #{raw_info['last_name']}".strip,
          first_name: raw_info['first_name'],
          last_name: raw_info['last_name'],
          nickname: raw_info['display_name'],
          email: raw_info['email'],
          image: raw_info['pic_url'],
          location: raw_info['location'],
          verified: raw_info['verified'],
          urls: {
            zoom: raw_info['personal_meeting_url']
          }
        })
      end

      extra do
        hash = {}
        hash[:raw_info] = raw_info unless skip_info?
        prune!(hash)
      end

      credentials do
        hash = { token: access_token.token }
        hash[:expires] = access_token.expires?
        hash[:expires_at] = access_token.expires_at if access_token.expires?
        hash[:refresh_token] = access_token.refresh_token if access_token.refresh_token
        hash
      end

      def raw_info
        @raw_info ||= access_token.get(USER_INFO_URL).parsed
      end

      def callback_url
        options[:redirect_uri] || (full_host + callback_path)
      end

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |key|
            params[key] = request.params[key.to_s] unless empty?(request.params[key.to_s])
          end
          params[:response_type] = 'code'
          session['omniauth.state'] = params[:state] unless empty?(params[:state])
        end
      end

      private

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          empty?(value)
        end
      end

      def empty?(value)
        value.nil? || (value.respond_to?(:empty?) && value.empty?)
      end
    end
  end
end
