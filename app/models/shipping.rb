class Shipping < Address

  def full_address
    "#{first_name} #{last_name} <br /> #{address_1} #{address_2} <br /> #{city}, #{state}, ZIP: #{zip} <br /> #{country} "
  end

end
