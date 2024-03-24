class PaymentMethod
    require_relative '../utility/Utility'

    # j'ai pas initialisé l'attribut de PaymentMethod dans la diagramme de classe car je trouve que c'est inutile.
    def initialize()
    end

    # Méthode pour le type de payement en juin.
    #
    # @param [Period] period : instance de période.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : la montant si c'est en juin et à la dernière date du contrat sinon 0.
    #
    # @example
    #   junePayment(period, 3, 2023) #=> 200.00
    #
    def junePayment(period, month, year)
        # verification si c'est le dernier mais d'une période.
        isLastMonth = (month == period.contract.endDate.month && year === period.contract.endDate.year)
        # verification si durée du contrat inférieur d'une année.
        shortPeriod = (isLastMonth &&  Utility.calculateMonthDiff(period.contract.endDate, period.contract.startDate) <= 12)
        # Valeur monétaire, période précédente si il y en a, période courant si c'est la fin de la période.
        amount = (period.previous != nil || shortPeriod) ?  (isLastMonth) ? period.favMonVal() : period.previous.favMonVal() : 0
        if (month == 6 || isLastMonth)
            return amount
          else
            return 0
        end
    end

    # Méthode pour le type de payement en 1/12ème.
    #
    # @param [Period] period : instance de période.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : la montant.
    #
    # @example
    #   oneTwelfth(period, 4, 2024) #=> 250.00
    #
    def oneTwelfth(period, month, year)
        result = 0
        if period.previous != nil
            # valeur monétaire pour la période du mois précédent + régularisation :
            result = (period.previous.daysValue() / 12) + self.regOneTwelfth(period, month, year) 
        end 
    end

    # Méthode de régularisation pour le type de payement 1/12ème.
    #
    # @param [Period] period : instance de période.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : montant pour la régularisation.
    #
    # @example
    #   regOneTwelfth(period, 4, 2024) #=> 250.00
    #
    def regOneTwelfth(period, month, year)
        reg = 0.0
        if (period.previous != nil && period.previous.previous != nil && month === 6)
            reg = period.previous.previous.favMonVal() - period.previous.previous.daysValue()
        end 
        if (month === period.contract.endDate.month && year === period.contract.endDate.year)
            diffMonth = Utility.calculateMonthDiff(period.startDate, period.contract.endDate)
            # Valeur monértaire restant du période précedant (en cours de distribution pour la période courante) :
            previousRemaining = period.previous.daysValue() - (diffMonth * (period.previous.daysValue().to_f / 12))
            # régularitation de la période précédente :
            regPrevious = period.previous.favMonVal() - period.previous.daysValue()
            # régularitation de la période dernière période ou la période en cours :
            regLastPeriod = period.favMonVal() - period.daysValue()
            # valeur monétaire de la période en cours :
            currentPeriodRefund = period.daysValue()
            # Régularisation finale :
            reg = previousRemaining + regPrevious + regLastPeriod + currentPeriodRefund 
            # Si la durée du contrat est moin d'une année :
            if (Utility.calculateMonthDiff(period.contract.startDate, period.contract.endDate) <= 12)
                reg = period.favMonVal()
            end 
        end
        return reg
    end

    # Méthode pour calculer le 10% par rappor au salaire brut.
    #
    # @param [Period] period : instance de période.
    # @param [Float] ratio : ratio pour application du règle de prorata entre 0 et 1.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : résultat.
    #
    # @example
    #   tenPercent(period ,1 ,4 ,2024) #=> 242.00
    #
    def tenPercent(period, ratio, month, year)
        (ratio * period.contract.grossSalary) / 10
    end


    # Méthode pour calculer la régularisation de 10%.
    #
    # @param [Period] period : instance de période.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : la montant .
    #
    # @example
    #   regTenPercent(period, 4, 2024) #=> 250.00
    #
    def regTenPercent(period, month, year)
        # Variable de l'accumulation pour la période précédente.
        accum = 0
        # Variable de l'accumulation pour la période courante.
        accumCurr = 0
        reg = 0
        if (month === 6 && period.previous != nil) 
            # Utilisation des instances dans la périodes précédente puis calcul de la somme des ratios pour avoir accum.
            countLists = period.previous.lists.length
            totalRatio = 0.0
            for i in 0..(countLists - 1)
                totalRatio = totalRatio + period.previous.lists[i].ratio.to_f
            end
            # Total des 10% des salaires accumulés et calcul régularisation.
            accum = self.tenPercent(period, totalRatio, month, year)
            reg = period.previous.favMonVal().to_f - accum.to_f
        end
        # si c'est la dernière période, c'est la même calcule mais avec la derière période ou la période courante.
        if (month == period.contract.endDate.month && year === period.contract.endDate.year)
            countListsCurrentPer = period.lists.length
            totalCurr = 0.0
            for i in 0..(countListsCurrentPer - 1)
                totalCurr = totalCurr + period.lists[i].ratio.to_f
            end
            accumCurr = self.tenPercent(period, totalCurr, month, year)
            reg = period.favMonVal().to_f - accumCurr.to_f
        end
        return reg
    end

    # Méthode de calcul de type de payement 10%.
    #
    # @param [Period] period : instance de période.
    # @param [Float] ratio : ratio pour application du règle de prorata entre 0 et 1.
    # @param [Integer] month : mois pour le payement.
    # @param [Integer] year : année du payement.
    # @return [Float] : la montant du payement.
    #
    # @example
    #   tenPercentPayment(period, 0.5, 4, 2024) #=> 250.00
    #
    def tenPercentPayment(period, ratio, month, year)
        #  10% + régularisation 
        self.tenPercent(period, ratio, month, year) + self.regTenPercent(period, month, year)
    end

end