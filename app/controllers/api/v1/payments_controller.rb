class Api::V1::PaymentsController < ApplicationController
  # skip_before_action :verify_authenticity_token #we think this is covered by our cors config

  def create_payment_intent
    amount = params[:amount].to_i
  
    if amount <= 0
      return render json: { error: 'Invalid amount' }, status: 400
    end
  
    amount_in_cents = amount * 100 # Convert to cents
  
    begin
      payment_intent = Stripe::PaymentIntent.create(
        amount: amount_in_cents,
        currency: 'usd',
        payment_method_types: ['card']
      )
  
      render json: { clientSecret: payment_intent.client_secret }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: 400
    end
  end
end