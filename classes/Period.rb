require_relative '../utility/Utility'
require_relative './List'
require 'date'

class Period
    attr_accessor :endDate, :startDate, :dayOff, :contract, :lists, :previous

    #Initialisation des attributs du Period.
    #
    # @param [Date] startDate : date de début du contrat.
    # @param [Date] endDate : date de la fin du contrat.
    # @param [Integer] dayOff : jour de repos.
    # @param [Contract] contract : instace du contrat.
    # @param [Period] previous : période précédente.
    def initialize (startDate, endDate, dayOff, contract, previous)
        @endDate = endDate
        @startDate = startDate
        @dayOff = dayOff
        @contract = contract
        @lists = []
        @previous = previous 
        # Ajout de ce période dans le contrat.
        contract.periods << self
        # chargement de résultat pour le période et instantiation des listes.
        self.loadList()
    end

    # Méthode qui génère l'output du période et crée les instances de Liste.
    def loadList() 
        puts " -------> || date de la période : #{startDate} => #{endDate} || Jours qui compte : #{self.workingDay()} || Jours acquis : #{self.acquisitionDay().round(2)} || Valeur rénumeration : #{self.daysValue().round(2)} || 1/10ème : #{self.oneTenthVal().round(2)} || Valeur favorable : #{self.favMonVal().round(2)} \n"
        puts  "%-9s | %-5s | %-7s | %-7s | %-7s" % ["Mois", "Ratio", "Juin", "1/12ème", "10%"]
        self.generateList()        
    end

    # Méthode qui génère l'output du période et crée les instances de Liste.
    def generateList()
        # Compter les mois et enlever le dernier
        countMonths = Utility.calculateMonthDiff(startDate, endDate) - 1
        # Si le premier mois est incomplète on l'enlève dans countMonths et l'instancie en calculant le ratio.
        if (!Utility.isFullMonth(startDate) && startDate.month != 6 && startDate.day != 1)
            countMonths -= 1
            List.new(startDate.year, startDate.month, Utility.ratio((Date.new(startDate.year, startDate.month, -1).day - startDate.day) , Date.new(startDate.year, startDate.month, -1).day), self)
        end
        # Bouclé les mois restant avec ratio de 1 car tous ces mois sont complet.
        currentDate = Date.new(startDate.year, startDate.month, 1)
        while currentDate != Date.new(endDate.year, endDate.month, 1)
            if (currentDate != Date.new(contract.startDate.year, contract.startDate.month, 1))
                List.new(currentDate.year, currentDate.month, 1, self)
            end
            currentDate = currentDate.next_month
        end
        # instantiation avec le bon ratio si le dernier mois est incomplet sinon c'est 1.
        if (!Utility.isFullMonth(endDate))
            countMonths -= 1
            List.new(endDate.year, endDate.month, Utility.ratio(endDate.day, Date.new(endDate.year, endDate.month, -1).day), self)
        else 
            List.new(endDate.year, endDate.month, 1, self)
        end
    end

    # Méthode de calcul des jours ouvrables.
    #
    # @return [Integer].
    #
    # @example
    #   workingDay() #=> 200
    #
    def workingDay()
        # stockage de tous les mois de la période.
        result = Utility.calculateMonthDiff(startDate, endDate)
        # Variable pour les jours en cas de mois incomplet.
        additionalDays = 0;
        # Vérification si la date de début du contrat est incomplete et ne commence pas le 1èr Juin.
        if (!Utility.isFullMonth(startDate) && startDate.month != 6 && startDate.day != 1)
            # On enlève ce mois et on ajoute les jours supplémentaires.
            result -= 1
            additionalDays = Utility.daysWithoutSunday(Date.new(startDate.year, startDate.month, 1), startDate)
        end
        # Même chose mais sur endDate.
        if (!Utility.isFullMonth(endDate))
            result -= 1
            additionalDays += Utility.daysWithoutSunday(Date.new(endDate.year, endDate.month, 1), endDate)
        end
        # Calcul des jours ouvrables des mois complet + jours supplémentaire des mois incomplet.
        result = (result * Utility::WORKING_D_MONTH) + additionalDays
    end

    # Méthode de calcul des jours acquis.
    #
    # @return [Float].
    #
    # @example
    #   acquisitionDay() #=> 20.50
    #
    def acquisitionDay()
        # Jours ouvrables * acquisition par jours.
        self.workingDay() * Utility::ACQUISITION_PER_DAY
    end

    # Méthode de calcul de la valeur monétaire basé rénumération brûte .
    #
    # @return [Float].
    #
    # @example
    #   daysValue() #=> 250.00
    #
    def daysValue()
         # Jours acquis / maintien de salaire.
        acquisitionDay() * Utility.salaryContinuity(contract.grossSalary)
    end

    # Méthode de calcul de la valeur monétaire sur 1/10 du total brûte d'une période
    #
    # @return [Float].
    #
    # @example
    #   oneTenthVal() #=> 250.00
    #
    def oneTenthVal()
        # Même principe que ce d'en haut.
        result = Utility.calculateMonthDiff(startDate, endDate)
        # Ajout de bon ration si le début est incomplet et ne commence pas le 1èr Juin.
        if (!Utility.isFullMonth(startDate) && startDate.month != 6 && startDate.day != 1)
            result -= 1
            result += Utility.ratio(startDate.day, Date.new(startDate.year, startDate.month, -1).day)
        end
        # Même chose mais sur endDate.
        if (!Utility.isFullMonth(endDate))
            result -= 1
            result += Utility.ratio(endDate.day, Date.new(endDate.year, endDate.month, -1).day)
        end
        # On obtient les ratios dans results (mois complet = 1 avec les autres).
        # Multiplication avec le salaire brut pour avoir le total en une période puis application du 1/10.
        result = (result * contract.grossSalary)
        result = result.to_f / 10
    end

    # Méthode de calcul de la valeur monétaire favorable.
    #
    # @return [Float].
    #
    # @example
    #   favMonVal() #=> 250.00
    #
    def favMonVal()
        # Obtention du la valeur favorable.
        [self.daysValue(), self.oneTenthVal()].max
    end

end