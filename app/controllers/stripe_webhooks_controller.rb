class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!
  
  def handle_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret)
      )
    rescue JSON::ParserError => e
      render json: { error: e.message }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    case event.type
    when 'payment_intent.succeeded'
      handle_payment_intent_succeeded(event.data.object)
    when 'payment_intent.payment_failed'
      handle_payment_intent_failed(event.data.object)
    else
      # Handle other events if needed
    end

    render json: { message: 'Received' }, status: :ok
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
   # Retrieve the book ID from metadata
   book_id = payment_intent.metadata['book_id']
   # Update the user's purchased_book_ids
   current_user.update(purchased_book_ids: (current_user.purchased_book_ids || []) << book_id)

   # Add additional logic as needed    
  end

  def handle_payment_intent_failed(payment_intent)
    # Handle failed payment event
  end
end


