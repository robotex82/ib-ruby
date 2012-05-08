require 'rails/generators/migration'

module IB
  module Generators
    class MigrationsGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "Installs the needed migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_executions.rb", "db/migrate/create_executions.rb"
        migration_template "create_order_states.rb", "db/migrate/create_order_state.rb"
        migration_template "create_orders.rb", "db/migrate/create_orders.rb"
        migration_template "create_combo_legs.rb", "db/migrate/create_combo_legs.rb"
        migration_template "create_underlyings.rb", "db/migrate/create_underlyings.rb"
        migration_template "create_contract_details.rb", "db/migrate/create_contract_details.rb"
        migration_template "create_contracts.rb", "db/migrate/create_contracts.rb"
      end         
    end
  end
end

