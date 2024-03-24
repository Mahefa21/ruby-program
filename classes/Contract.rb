require_relative './Period' 
require 'date'

class Contract 
    # Crée automatiquement des méthodes d'accès en lecture et en écriture 
    attr_accessor :startDate, :endDate, :grossSalary, :paymentMethod, :periods

    #Initialisation des attributs du contrat.
    #
    # @param [Date] startDate : date de début du contrat.
    # @param [Date] endDate : date de la fin du contrat.
    # @param [Integer] grossSalary : salaire brut.
    # @param [PaymentMethod] paymentMethod : méthode de payement.
    def initialize(startDate, endDate, grossSalary, paymentMethod) 
        @startDate = startDate
        @endDate = endDate
        @grossSalary = grossSalary
        @paymentMethod = paymentMethod
        @periods = []
    end

    # Méthode de génération des périodes.
    def generatePeriods() 
        # currentDate sert à compter les mois / sartPeriodDate va stocker le début d'une période qui est le mois de juin.
        currentDate = sartPeriodDate = startDate 
        # compter les périodes pour savoir dans quelle période on est.
        countPeriod = 0 
        # pour compter les jours de repos.
        dayOff = 0 
        # previous va stocké l'intance d'un pérode précedent.
        previous = nil  
        while Date.new(currentDate.year, currentDate.month, 1) != Date.new(endDate.year, endDate.month + 1, 1)
            # Jours de repos commence en deuxième période.
            if (currentDate.month === 7 || currentDate.month === 12 || currentDate.month === 1)
                dayOff += 6
            elsif (countPeriod < 0 && currentDate.month === 8) 
                dayOff += 12
            end
            # instantiation de la dernière période et d'une nouvelle période.
            if (currentDate.month === 5) 
                endPeriodDate = Date.new(currentDate.year, currentDate.month, 31)
                previous = Period.new(sartPeriodDate, endPeriodDate, dayOff, self, previous)
                sartPeriodDate =  Date.new(currentDate.year, currentDate.month + 1, 1)
                dayOff = 0
            end
            # date avec le mois suivant.
            currentDate = currentDate.next_month 
            countPeriod += 1
        end
        # dernière période, la boucle se termine par Date.new(endDate.year, endDate.month + 1, 1) qui n'est pas
        # la date du fin de contrat, la date de la fin du contrat est endDate.
        Period.new(sartPeriodDate, endDate, dayOff, self, previous) 
        
    end
end