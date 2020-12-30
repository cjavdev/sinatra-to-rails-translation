class CheckoutSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # From sinatra:
  # # Fetch the Checkout Session to display the JSON result on the success page
  # get '/checkout-session' do
  #   content_type 'application/json'
  #   session_id = params[:sessionId]
  #
  #   session = Stripe::Checkout::Session.retrieve(session_id)
  #   session.to_json
  # end
  def show
    # /checkout_sessions/<id>
    checkout_session = Stripe::Checkout::Session.retrieve(params[:id])
    render json: checkout_session
  end

  # From sinatra:
  # post '/create-checkout-session' do
  #   content_type 'application/json'
  #   data = JSON.parse request.body.read
  #   # Create new Checkout Session for the order
  #   # Other optional params include:
  #   # [billing_address_collection] - to display billing address details on the page
  #   # [customer] - if you have an existing Stripe Customer ID
  #   # [customer_email] - lets you prefill the email input in the form
  #   # For full details see https:#stripe.com/docs/api/checkout/sessions/create
  #
  #   # ?session_id={CHECKOUT_SESSION_ID} means the redirect will have the session ID set as a query param
  #   session = Stripe::Checkout::Session.create(
  #     success_url: ENV['DOMAIN'] + '/success.html?session_id={CHECKOUT_SESSION_ID}',
  #     cancel_url: ENV['DOMAIN'] + '/canceled.html',
  #     payment_method_types: ['card'],
  #     mode: 'payment',
  #     line_items: [{
  #       quantity: data['quantity'],
  #       price: ENV['PRICE'],
  #     }]
  #   )
  #
  #   {
  #     sessionId: session['id']
  #   }.to_json
  # end

  def create
    # data = JSON.parse request.body.read
    # (use params instead)
    data = params

    # Create new Checkout Session for the order
    # Other optional params include:
    # [billing_address_collection] - to display billing address details on the page
    # [customer] - if you have an existing Stripe Customer ID
    # [customer_email] - lets you prefill the email input in the form
    # For full details see https:#stripe.com/docs/api/checkout/sessions/create

    # ?session_id={CHECKOUT_SESSION_ID} means the redirect will have the session ID set as a query param
    checkout_session = Stripe::Checkout::Session.create(
      success_url: 'http://localhost:4242/success.html?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: 'http://localhost:4242/canceled.html',
      payment_method_types: ['card'],
      mode: 'payment',
      line_items: [{
        quantity: data[:quantity],
        price: 'price_1HKUZyCZ6qsJgndJoilBF6tu',
      }]
    )

    render json: {
      sessionId: checkout_session['id']
    }
  end
end
