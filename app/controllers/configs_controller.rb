class ConfigsController < ApplicationController
  # From sinatra:
  #
  # get '/config' do
  #   content_type 'application/json'
  #   price = Stripe::Price.retrieve(ENV['PRICE'])
  #
  #   {
  #     publicKey: ENV['STRIPE_PUBLISHABLE_KEY'],
  #     unitAmount: price['unit_amount'],
  #     currency: price['currency']
  #   }.to_json
  # end

  def show
    price = Stripe::Price.retrieve(
      'price_1HKUZyCZ6qsJgndJoilBF6tu'
    )

    render json: {
      publicKey: Rails.application.credentials.dig(:stripe, :public_key),
      unitAmount: price.unit_amount,
      currency: price.currency
    }
  end
end
