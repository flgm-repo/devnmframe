module SessionHelper
  def blank_and_in_session(p, s)
     return ((p.nil? || p.blank?) && (!s.nil? || !s.blank?))
  end

  def nil_or_blank(p)
    return (p.nil? || p.blank?)
  end

  def blank_and_not_in_session(p, s)
    return ((p.nil? || p.blank?) && (s.nil?))
  end
end