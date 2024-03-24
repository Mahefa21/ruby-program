require_relative 'classes/Contract'
require_relative 'classes/PaymentMethod'
require 'date'

# Nouvelle instance pour un contrat.
contract = Contract.new(Date.new(2023, 9, 11), Date.new(2025, 7, 25), 1000, PaymentMethod.new())
# génération des périodes.
contract.generatePeriods()
