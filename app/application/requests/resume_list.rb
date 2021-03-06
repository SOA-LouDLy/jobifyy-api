# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module Jobify
  module Request
    # Resume list request parser
    class EncodedResumeList
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming list requests
      def call
        Success(
          JSON.parse(decode(@params['list']))
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(
            status: :bad_request,
            message: 'Resume list not found'
          )
        )
      end

      # Decode params
      def decode(param)
        Base64.urlsafe_decode64(param)
      end

      # - Use this method to create encoded params for testing
      def self.to_encoded(list)
        Base64.urlsafe_encode64(list.to_json)
      end

      # Use in tests to create a ProjectList object from a list
      def self.to_request(list)
        EncodedResumeList.new('list' => to_encoded(list))
      end
    end
  end
end
