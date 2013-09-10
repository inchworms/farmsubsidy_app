Sequel.migration do
  change do
    create_table(:payment_year_totals) do
      primary_key :id
      BigDecimal :amount_euro
      foreign_key(:year_id, :years)
      foreign_key(:recipient_id, :recipients)
    end
  end
end
