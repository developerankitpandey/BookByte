class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:webhook]
  skip_before_action :authenticate_user!, only: [:webhook]

  def webhook
    endpoint_secret = 'whsec_KLvyLNkUcjLSB331gRaL5HBvm8oUnc2l'

    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      head 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      head 400
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.created'
      payment_intent = event.data.object
      handle_payment_intent_succeeded(payment_intent)
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      # handle_payment_intent_succeeded(payment_intent)
    # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end

    head :ok
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
    # Retrieve the book ID from metadata
    book_id = payment_intent.metadata['book_id']
    current_user_id = payment_intent.metadata['current_user_id']
    current_user = User.find_by(id: current_user_id) 
    # Update the user's purchased_book_ids
    current_user.update(purchased_book_ids: (current_user&.purchased_book_ids || []) << book_id)

    # Add additional logic as needed
  end

  def handle_payment_intent_failed(payment_intent)
    # Handle failed payment event
  end
end
