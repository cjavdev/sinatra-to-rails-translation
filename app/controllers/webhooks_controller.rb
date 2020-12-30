class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # From sinatra:
  # post '/webhook' do
  #   You can use webhooks to receive information about asynchronous payment events.
  #   For more about our webhook events check out https://stripe.com/docs/webhooks.
  #   webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']
  #   payload = request.body.read
  #   if !webhook_secret.empty?
  #     # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
  #     sig_header = request.env['HTTP_STRIPE_SIGNATURE']
  #     event = nil
  #
  #     begin
  #       event = Stripe::Webhook.construct_event(
  #         payload, sig_header, webhook_secret
  #       )
  #     rescue JSON::ParserError => e
  #       # Invalid payload
  #       status 400
  #       return
  #     rescue Stripe::SignatureVerificationError => e
  #       # Invalid signature
  #       puts '⚠️  Webhook signature verification failed.'
  #       status 400
  #       return
  #     end
  #   else
  #     data = JSON.parse(payload, symbolize_names: true)
  #     event = Stripe::Event.construct_from(data)
  #   end
  #   # Get the type of webhook event sent - used to check the status of PaymentIntents.
  #   event_type = event['type']
  #   data = event['data']
  #   data_object = data['object']
  #
  #   puts '🔔  Payment succeeded!' if event_type == 'checkout.session.completed'
  #
  #   content_type 'application/json'
  #   {
  #     status: 'success'
  #   }.to_json
  # end


  def create
    # You can use webhooks to receive information about asynchronous payment events.
    # For more about our webhook events check out https://stripe.com/docs/webhooks.
    webhook_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    payload = request.body.read

    if !webhook_secret.empty?
      # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        render json: {message: 'failed to parse webhook event'}, status: 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        puts '⚠️  Webhook signature verification failed.'
        render json: {message: 'failed to parse webhook event'}, status: 400
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end

    # Get the type of webhook event sent - used to check the status of PaymentIntents.
    event_type = event['type']
    data = event['data']
    data_object = data['object']

    puts '🔔  Payment succeeded!' if event_type == 'checkout.session.completed'

    render json: {
      status: 'success'
    }
  end
end
