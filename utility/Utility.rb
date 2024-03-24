
module Utility
    # Possiblité de jours ouvrable par mois et 22 jours de travail par mois.
    WORKING_D_MONTH = 26
    # Valeur d'acquisition par jour.
    ACQUISITION_PER_DAY = 5.0/52

    # Méthode qui vérifie si un mois est complet.
    #
    # @param [Date] date : date.
    # @return [Integer].
    #
    # @example
    #   isFullMonth(Date.new(2024, 3, 21)) #=> false
    #
    def self.isFullMonth(date)
        date == Date.new(date.year, date.month, -1)
    end

    # Méthode qui calcule les jours sans le dimanche entre deux dates.
    #
    # @param [Date] startDate : date de commencement.
    # @param [Date] endDate : date de fin.
    # @return [Integer] : les jours.
    #
    # @example
    #   daysWithoutSunday(Date.new(2024, 3, 21), Date.new(2024, 3, 14)) #=> 4
    #
    def self.daysWithoutSunday(startDate, endDate)
        result = 0
        (startDate..endDate).each do |date|
          result += 1 unless date.sunday?
        end
        result
    end

    # Méthode qui calcule le maintien de salaire.
    #
    # @param [Float] grossSalary : salaire brut.
    # @return [Float] : résultat du maintien de salaire.
    #
    # @example
    #   salaryContinuity(1000)  #=> 45.45
    #
    def self.salaryContinuity(grossSalary) 
        # self::WORKING_D_MONTH - 4 = 22
        result = grossSalary.to_f / (self::WORKING_D_MONTH - 4)
    end

    # Méthode qui calcule la différence de mois entre deux dates.
    #
    # @param [Date] startDate : date de commencement.
    # @param [Date] endDate : date de fin.
    # @return [Integer] : la différence de mois.
    #
    # @example
    #   calculateMonthDiff(Date.new(2023, 9, 11), Date.new(2023, 10, 11)) #=> 1
    #
    def self.calculateMonthDiff(startDate, endDate)
        yearDiff = (endDate.year - startDate.year) * 12
        monthDiff = endDate.month - startDate.month
        result = (yearDiff + monthDiff) + 1
    end

    # Méthode qui calcule le ratio entre deux jours.
    #
    # @param [Date] currentDay : jour de commencement.
    # @param [Date] totalDay : jour total d'un mois.
    # @return [Float] : ratio.
    #
    # @example
    #   self.ratio(20, 30) #=> 0.66
    #
    def self.ratio(currentDay, totalDay)
        currentDay.to_f / totalDay
    end

  end