module Revolut
  module Api
    module Private
      module Exchange

        def exchange(from:, to:, amount:, side: :sell)
          status, success   =   nil, nil
          transactions      =   []
          error             =   {}
          from              =   from.to_s.upcase
          to                =   to.to_s.upcase

          if amount.eql?(:all)
            pocket          =   self.wallet.pocket(from)

            if pocket
              amount        =   pocket.balance
              log "Will exchange total balance #{from} to #{to}. Balance: #{amount}."
            end
          end
      
          if !from.to_s.empty? && !to.to_s.empty? && !amount.nil?
            log "Will exchange #{amount} #{from} to #{to}"

            payload             =   {
              "fromCcy"         =>    from,
              "toCcy"           =>    to,
              "rateTimestamp"   =>    Time.now.utc.to_i,
            }

            if side.eql?(:sell)
              payload.merge!("fromAmount" => ::Revolut::Api::Utilities.convert_to_integer_amount(from, amount))
            elsif side.eql?(:buy)
              payload.merge!("toAmount" => ::Revolut::Api::Utilities.convert_to_integer_amount(to, amount))
            end

            data                =   post("exchange", data: payload.to_json)

            if data && data.is_a?(Array) && data.any?
              data.each do |response|
                transactions   <<   ::Revolut::Api::Response::Transaction.new(response)
              end

              complete_count    =   0
              pending_count     =   0

              transactions.each do |transaction|
                complete_count +=   1 if transaction.completed?
                pending_count  +=   1 if transaction.pending?
              end

              success           =   (complete_count == data.count || pending_count == data.count)
              status            =   :completed if complete_count == data.count
              status            =   :pending   if pending_count == data.count

              log "Successfully exchanged #{amount} #{from} to #{to}!"            if status.eql?(:completed)
              log "Exchange from #{amount} #{from} to #{to} is currently pending" if status.eql?(:pending)

            elsif data && data.is_a?(Hash)
              error_message     =   data.fetch("message", nil)
              error_code        =   data.fetch("code", nil)

              status            =   :failed
              success           =   false
              error[:message]   =   error_message if !error_message.to_s.empty?
              error[:code]      =   error_code    if !error_code.to_s.empty?

              log "Error occurred while trying to exchange #{amount} #{from} to #{to}. Error (#{error_code}): #{error_message}"
            end
          else
            log "Missing some data required for the exchange. From: #{from}. To: #{to}. Amount: #{amount}."
          end

          return {status: status, success: success, transactions: transactions, error: error}
        end

        def quote(from:, to:, amount:, side: :sell)
          params      =   {
            amount: ::Revolut::Api::Utilities.convert_to_integer_amount(from, amount),
            side:   side.to_s.upcase
          }

          endpoint    =   "quote/#{from.to_s.upcase}#{to.to_s.upcase}"

          return ::Revolut::Api::Response::Quote.new(get(endpoint, params: params))
        end

      end
    end
  end
end
