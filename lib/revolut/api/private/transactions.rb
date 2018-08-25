module Revolut
  module Api
    module Private
      module Transactions
      
        def transactions(from: Time.new(Time.now.year, Time.now.month, 1, 0, 0, 0, 0), type: nil, phrase: nil, completed: nil, pending: nil, fetch_all: true, memoize: true)
          current                     =   Time.now.utc
          txs                         =   {}
      
          if fetch_all && memoize && memoized.fetch(:transactions, []).any?
            txs                       =   memoized.fetch(:transactions, [])
          else
            while from < current
              params                  =   {from: ::Revolut::Api::Utilities.utc_to_epoch(from)}
              data                    =   request_transactions(params: params)
        
              data.each do |item|
                tx                    =   ::Revolut::Api::Response::Transaction.new(item)
                txs[tx.id]            =   tx if tx && !tx.id.to_s.empty?
              end
        
              from                    =   from + ::Revolut::Api::Constants::TIME[:one_month]
              break unless fetch_all
            end
      
            txs                       =   txs.values
            memoized[:transactions]   =   txs if fetch_all
          end
      
          if !type.to_s.empty?
            txs                       =   txs.select { |tx| tx.type.to_s.upcase.strip == type.to_s.upcase.strip }
          end
      
          if completed.eql?(true)
            txs                       =   txs.select { |tx| tx.completed? }
          end
          
          if pending.eql?(true)
            txs                       =   txs.select { |tx| tx.pending? }
          end
      
          if !phrase.to_s.empty?
            txs                       =   txs.select { |tx| !(tx.description =~ /#{phrase}/i).nil? }
          end
      
          txs                         =   txs.sort_by { |tx| tx.started_date }
      
          return txs
        end
    
        def request_transactions(params: {}, retries: 3)
          data                        =   nil
      
          begin
            data                      =   get("user/current/transactions", params: params)
          rescue Faraday::ParsingError => e
            retries        -=   1
            retry if retries > 0
          end
      
          return data
        end
    
        def transaction(id)
          response          =   get("transaction/#{id}")
      
          if response.is_a?(Hash)
            log "#{response["message"]}"
          elsif response.is_a?(Array)
            return ::Revolut::Api::Response::Transaction.new(response&.first)
          end
        end
      
      end
    end
  end
end
