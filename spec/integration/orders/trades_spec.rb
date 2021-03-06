require 'order_helper'

describe "Trades", :connected => true, :integration => true, :slow => true do

  before(:all) { verify_account }

  context "Trading Forex", :if => :forex_trading_hours do

    before(:all) do
      @contract = IB::Symbols::Forex[:eurusd]
      @ib = IB::Connection.new OPTS[:connection].merge(:logger => mock_logger)
      @ib.wait_for :NextValidId
    end

    after(:all) { close_connection }

    context "Placing BUY order" do

      before(:all) do
        place_order @contract,
                    :total_quantity => 20000,
                    :limit_price => 2,
                    :action => 'BUY'
                    #:what_if => true

        @ib.wait_for(5, :ExecutionData, :OpenOrder) do
          @ib.received[:OpenOrder].last &&
              @ib.received[:OpenOrder].last.order.commission
        end
      end

      after(:all) do
        clean_connection # Clear logs and message collector
        @ib.cancel_order @local_id_placed # Just in case...
      end

      it 'changes client`s next_local_id' do
        @local_id_placed = @local_id_before
        @ib.next_local_id.should == @local_id_before + 1
      end

      it { @ib.received[:OpenOrder].should have_at_least(1).open_order_message }
      it { @ib.received[:OrderStatus].should have_at_least(1).status_message }
      it { @ib.received[:ExecutionData].should have_exactly(1).execution_data }
      it { @ib.received[:ExecutionDataEnd].should be_empty }

      it 'receives filled OpenOrder' do
        order_should_be 'Filled'
        msg = @ib.received[:OpenOrder].last
        msg.order.commission.should == 2.5
      end

      it 'receives Execution Data' do
        execution_should_be :buy
      end

      it 'receives OrderStatus with fill details' do
        status_should_be 'Filled'
      end
    end # Placing BUY

    context "Placing SELL order" do

      before(:all) do
        place_order @contract,
                    :total_quantity => 20000,
                    :limit_price => 1,
                    :action => 'SELL'

        @ib.wait_for(:ExecutionData, :OpenOrder, 5) do
          @ib.received[:OpenOrder].last.order.commission
        end
      end

      after(:all) do
        clean_connection # Clear logs and message collector
        @ib.cancel_order @local_id_placed # Just in case...
      end

      it 'changes client`s next_local_id' do
        @local_id_placed = @local_id_before
        @ib.next_local_id.should == @local_id_before + 1
      end

      it { @ib.received[:OpenOrder].should have_at_least(1).open_order_message }
      it { @ib.received[:OrderStatus].should have_at_least(1).status_message }
      it { @ib.received[:ExecutionData].should have_exactly(1).execution_data }

      it 'receives filled OpenOrder' do
        order_should_be 'Filled'
        msg = @ib.received[:OpenOrder].last
        msg.order.commission.should == 2.5
      end

      it 'receives Execution Data' do
        execution_should_be :sell
      end

      it 'receives OrderStatus with fill details' do
        status_should_be 'Filled'
      end
    end # Placing SELL

    context "Request executions" do
      # TODO: RequestExecutions with filters?

      before(:all) do
        @ib.send_message :RequestExecutions,
                         :request_id => 456,
                         :client_id => OPTS[:connection][:client_id],
                         :time => (Time.now-10).to_ib # Time zone problems possible
        @ib.wait_for :ExecutionData, 3 # sec
      end

      #after(:all) { clean_connection }

      it 'does not receive Order-related messages' do
        @ib.received[:OpenOrder].should be_empty
        @ib.received[:OrderStatus].should be_empty
      end

      it 'receives ExecutionData messages' do
        @ib.received[:ExecutionData].should have_at_least(1).execution_data
      end

      it 'receives Execution Data' do
        execution_should_be :sell, :request_id => 456
      end
    end # Request executions
  end # Forex order

end # Trades
