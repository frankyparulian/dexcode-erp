module Numbered
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def numbered(*args, **options, &block)

      args.each do |name|
        before_validation :on => :create do
          # Build scope
          if options[:scope]
            options[:scope] = [options[:scope]] unless options[:scope].is_a?(Array)
            conditions = {}
            options[:scope].each do |column|
              conditions[column] = self[column]
            end
            scope = self.class.where(conditions)
          else
            scope = self.class
          end

          if self[name].blank?
            number = 1 + scope.count.to_i
            self[name] = loop do
              break self.class.number_string(self, options[:prefix], number) unless scope.exists?(name => self.class.number_string(self, options[:prefix], number))
              number += 1
            end
          end
        end
      end
    end

    def number_string(object, prefix, number)
      prefix = prefix.call(object) if prefix.is_a?(Proc)
      "#{prefix}#{number.to_s.rjust(4, '0')}"
    end

  end
end
