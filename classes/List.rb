require 'date'

class List 
    attr_accessor :year, :month, :ratio, :period

    # Initialisation des attributs du List.
    #
    # @param [Integer] year : année.
    # @param [Integer] month : mois.
    # @param [Float] ratio : ratio.
    # @param [Period] period : instance de la classe période.
    def initialize(year, month, ratio, period)
        @year = year
        @month = month
        @ratio = ratio
        @period = period
        period.lists << self
        # initialisation du chargement des listes.
        loadTable()
    end
    
    # Méthode qui calcule le salaire brut avec le bon ratio.
    #
    # @return [Integer].
    #
    # @example
    #   calculateSalary() #=> 200
    #
    def calculateSalary()
        ratio * period.contract.grossSalary
    end

    # Méthode qui affiche les listes.
    #
    # @return [Sring].
    #
    # @example
    #   loadTable() #=> 200
    #
    def loadTable()
        # Mode de payement chaque juin.
        junePayment = period.contract.paymentMethod.junePayment(period, month, year)
        # Mode de payement 1/12ème.
        oneTwelfth = period.contract.paymentMethod.oneTwelfth(period, month, year) 
        oneTwelfth = (oneTwelfth != nil)? oneTwelfth : 0
        # Mode de payement 10%.
        tenPercentPayment = period.contract.paymentMethod.tenPercentPayment(period, ratio, month, year)
        tenPercentPayment = (tenPercentPayment != nil)? tenPercentPayment : 0
        # Affichage en tableau.
        puts  "%-3s %-5d | %-5.2f | %-7.2f | %-7.2f | %-7.2f" % [Date::ABBR_MONTHNAMES[month], year, ratio, junePayment, oneTwelfth, tenPercentPayment]
    end
end