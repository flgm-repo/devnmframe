class Array

  #Tis is the original plugin
  def to_xls(options = {})
    output = '<?xml version="1.0" encoding="UTF-8"?><Workbook xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office">'

    if self.any?

    output << '<Styles>
                  <Style ss:ID="Default" ss:Name="Normal">
                   <Alignment ss:Vertical="Bottom"/>
                   <Borders/>
                   <Font ss:FontName="Verdana"/>
                   <Interior/>
                   <NumberFormat/>
                   <Protection/>
                  </Style>
                  <Style ss:ID="s23">
                   <Borders>
                    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                   </Borders>
                  </Style>
                  <Style ss:ID="s25">
                   <Borders>
                    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                   </Borders>
                   <Font ss:FontName="Verdana" ss:Color="#DD0806" ss:Bold="1"/>
                   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>
                  </Style>
                 </Styles>'
      options[:worksheet_name] = options[:table_to_export]
      if options[:table_to_export] == "Profile history"
        output << self.first[:user_logs].worksheet_opt(options) if !self.first[:user_logs].empty?
        options[:worksheet_name] = "Admin history"
        output << self.first[:admin_logs].worksheet_opt(options) if !self.first[:admin_logs].empty?
      else
        output << self.worksheet_opt(options)
      end
    end

    output << '</Workbook>'
  end

  protected

  def worksheet_opt(options = {})
    table = "<Worksheet ss:Name='#{options[:worksheet_name]}'><Table>"
    unless options[:headers] == false
      table << "<Row>"
      table << column_order(options[:table_to_export])
      table << "</Row>"
    end

    self.each do |item|
      table << "<Row>"
      table << row_fields(item, options[:worksheet_name])
      table << "</Row>"
    end
    table << '</Table></Worksheet>'
  end

  def column_order (order)
    columns = ""
    column_name = case order
      when "Checkout" then ["Id",
        "Gift To",
        "Gift From",
        "Gift Message",
        "Shipping Address Id",
        "Billing Address Id",
        "User Id",
        "Nameframe Id",
        "Order Number",
        "Total",
        "Tax",
        "Card Type",
        "Created At",
        "Updated At",
        "Shipping Cost",
        "Shipping Type",
        "Authorization",
        "Transaction",
        "Status",
        "Email",
        "Nameframe Cost",
        "Archived"]
    end
    column_name.each { |name| columns << "<Cell ss:StyleID=\"s25\"><Data ss:Type=\"String\">#{name}</Data></Cell>" }
    return columns
  end

  def row_fields (row, order)
    filled_row = ""
    row_fields = case order
      when "Checkout" then [row.id,
        row.gift_to,
        row.gift_from,
        row.gift_message,
        row.shipping_address_id,
        row.billing_address_id,
        row.user_id,
        row.nameframe_id,
        row.order_number,
        row.total,
        row.tax,
        row.card_type,
        row.created_at,
        row.updated_at,
        row.shipping_cost,
        row.shipping_type,
        row.authorization,
        row.transaction,
        row.status,
        row.email,
        row.nameframe_cost,
        row.archived]
    end
    row_fields.each { |field| filled_row << "<Cell ss:StyleID=\"s23\"><Data ss:Type=\"#{field.kind_of?(Integer) ? 'Number' : 'String'}\">#{field}</Data></Cell>" }
    return filled_row
  end

end
