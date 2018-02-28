class ChargesController < ApplicationController
  def create
    @amount = 1500

    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    plan = Stripe::Plan.create({
      product: {
        name: 'Premium',
      },
      nickname: 'Premium Monthly',
      currency: 'usd',
      interval: 'month',
      amount: @amount,
      })

    # Where the real magic happens
    subscription = Stripe::Subscription.create({
      customer: customer.id, # Note -- this is NOT the user_id in your app
      items: [{ plan: plan.id }],
    })

    current_user.stripe_id = subscription.id

    current_user.role = "premium"
    current_user.save
    flash[:notice] = "Thank you for upgrading to Premium, #{current_user.email}!"
    redirect_to edit_user_registration_path(current_user) # or wherever

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end


  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.name}",
      amount: @amount
    }
  end

  def destroy
    customer = Stripe::Customer.create(
      email: current_user.email,
    )
    subscription = Stripe::Subscription.retrieve(current_user.stripe_id)
    subscription.delete

    #locate all user wikis and set to public
    @wikis = Wiki.where(user_id: current_user.id)
    @wikis.each do |wiki|
      wiki.private = false
      wiki.save
    end

    #change user role from premium to standard
    current_user.role = "standard"
    current_user.save

    flash[:alert] = "#{current_user.email} is no longer a Premium member."
    redirect_to edit_user_registration_path(current_user)
  end

end
