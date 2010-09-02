module OrdersHelper
  def card_image(card)
    if card == "visa"
      card_image = "payment-type-visa.gif";
      elsif card == "american_express"
        card_image = "payment-type-amex.jpg"
      elsif card == "master"
        card_image = "payment-type-master.gif";
      elsif card == "discover"
        card_image = "discover-card.gif";
    end
    card_image
  end
end

